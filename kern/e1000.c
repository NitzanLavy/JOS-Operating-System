#include <kern/e1000.h>

// LAB 6: Your driver code here

#include <kern/pci.h>
#include <kern/pmap.h>
#include <inc/assert.h>
#include <inc/string.h>
#include <inc/error.h>
#include <kern/picirq.h>
#include <kern/pmap.h>
#include <kern/env.h>

volatile uint32_t *nic;


// Structs of TX and RX packet buffers
typedef struct {
	uint8_t buf[MAX_TX_PACKET_SIZE];
} tx_packet_buf;

typedef struct {
	uint8_t buf[MAX_RX_PACKET_SIZE];
} rx_packet_buf;


// Arrays of TX and RX buffs
tx_packet_buf tx_buf_array[NUM_TX_DESC];
rx_packet_buf rx_buf_array[NUM_RX_DESC];


// Ring queues of TX an RX of NIC, alligned to 16 bytes
struct e1000_tx_desc tx_desc_queue[NUM_TX_DESC] __attribute__ ((aligned (16)));
struct e1000_rx_desc rx_desc_queue[NUM_RX_DESC] __attribute__ ((aligned (16)));



// Helper func to access and set NIC registers
static void
nicw(int index, int value) {
	nic[index/4] = value;
	nic[index];  // wait for write to finish, by reading
}

// Another helper func that returns NIC register's value
uint32_t
nic_get_reg(int index) {
	return nic[index/4];
}


// The following 2 functions were implemented due to 
// read MAC address from EEPROM challenge.
// This function reads addr from EEPROM, and 
// returns it.
uint32_t
read_EEPROM_addr(uint16_t addr) {
	addr = addr << 8;
	uint16_t read_addr = E1000_EERC_ADDR & addr;
	nicw(E1000_EERD, E1000_EERD | E1000_EERC_START | read_addr);
	while (!(nic_get_reg(E1000_EERD) & E1000_EERC_DONE));
	return (nic_get_reg(E1000_EERD) & E1000_EERC_DATA);
}

// This function receives pointers to two parameters,
// and writes into them the MAC address read from EEPROM.
void
get_MAC_from_EEPROM(uint32_t* low, uint32_t* high) {
	uint32_t mac_low = read_EEPROM_addr(0);
	mac_low = mac_low >> 16;
	mac_low += read_EEPROM_addr(0x1);
	uint32_t mac_high = read_EEPROM_addr(0x2);
	mac_high = mac_high >> 16;
	*low = mac_low;
	*high = mac_high;
}

int
e1000_attachfn(struct pci_func *pcif) {
	pci_func_enable(pcif);
	if (!((physaddr_t)pcif->reg_base[0]))
		return -1;

	nic = mmio_map_region((physaddr_t)pcif->reg_base[0], pcif->reg_size[0]);
	nicw(E1000_IMS, E1000_IMS | E1000_ICR_TXDW | E1000_ICR_RXT0);
	nicw(E1000_RDTR, 0);
	irq_setmask_8259A(irq_mask_8259A & ~(1<<11));

	Tx_init();
	Rx_init();


	return 0;
}

// Initializes memory, registers, transmit ring queue and transmit
// buffs array for transmit operation.
void
Tx_init() {
	memset(tx_desc_queue, 0, NUM_TX_DESC * sizeof(struct e1000_tx_desc));

	nicw(E1000_TDBAL, PADDR(tx_desc_queue));
	nicw(E1000_TDBAH, 0);
	nicw(E1000_TDLEN, NUM_TX_DESC * sizeof(struct e1000_tx_desc));
	nicw(E1000_TDH, 0);
	nicw(E1000_TDT, 0);

	nicw(E1000_TCTL, E1000_TCTL | E1000_TCTL_EN | E1000_TCTL_PSP | (E1000_TCTL_CT & ( 0x10 << 4)) | (E1000_TCTL_COLD & ( 0x40 << 12)));
	nicw(E1000_TIPG, (10 + (4 << 10) + (6 << 20)));

	int i;
	for(i = 0; i < NUM_TX_DESC; i++) {
		tx_desc_queue[i].cmd |= E1000_TXD_CMD_RS;
		tx_desc_queue[i].cmd |= E1000_TXD_CMD_EOP;

		// Mark DD = 1, meaning descriptor is free
		tx_desc_queue[i].status |= E1000_TXD_STAT_DD;			
		tx_desc_queue[i].buffer_addr = PADDR(&tx_buf_array[i]);
	}
}


// Initializes memory, registers, receive ring queue and receive
// buffs array for receive operation.
void
Rx_init() {
	memset(rx_desc_queue, 0, NUM_RX_DESC * sizeof(struct e1000_rx_desc));

	uint32_t mac_low = 0, mac_high = 0;
	get_MAC_from_EEPROM(&mac_low, &mac_high);

	nicw(E1000_RAL, mac_low);
	nicw(E1000_RAH, (nic_get_reg(E1000_RAH) & mac_high) | E1000_RAH_AV);

	nicw(E1000_MTA, 0);

	nicw(E1000_RDBAL,  PADDR(rx_desc_queue));
	nicw(E1000_RDBAH, 0);
	nicw(E1000_RDLEN, NUM_RX_DESC * sizeof(struct e1000_rx_desc));
	nicw(E1000_RDH, 0);
	nicw(E1000_RDT, NUM_RX_DESC-1);

	int i;
	for(i = 0; i < NUM_RX_DESC; i++) {
		// Mark DD = 0, meaning no packet written to descriptor
		rx_desc_queue[i].status &= ~E1000_RXD_STAT_DD;
		rx_desc_queue[i].buffer_addr = PADDR(&rx_buf_array[i]);
	}

	nicw(E1000_RCTL, 0);
	nicw(E1000_RCTL, E1000_RCTL | E1000_RCTL_EN | E1000_RCTL_BAM | E1000_RCTL_SECRC | E1000_RCTL_LBM_NO | E1000_RCTL_SZ_2048);
}

// Copies the given buf array's content to a tx_packet_buf.
// Important note: TDT Register points to the next free descriptor.
// buf is being written to TDT index in packet array. At the end,
// TDT register is incremented by 1, meaning the current index is in use.
// Returns 0 on success.
// Possible errors:
// - if size argument is bigger then max allowed - return -E_PACKET_TOO_BIG
// - if ring desriptor queue is full - return -E_TX_FULL
int
tx_packet(char *buf, int size) {
	if (size > MAX_TX_PACKET_SIZE) {
		return -E_PACKET_TOO_BIG;
	}

	uint32_t tail_index = nic_get_reg(E1000_TDT);

	// If DD = 0, then descriptor is not free. this means that tail = head index.
	if ((tx_desc_queue[tail_index].status & E1000_TXD_STAT_DD) == 0) {
		return -E_TX_FULL;
	}

	//memcpy(&tx_buf_array[tail_index].buf, buf, size);
	// Because of Zero Copy challenge, the line above was replaced by the
	// following 4 lines.
	struct PageInfo* pg_buf = page_lookup(curenv->env_pgdir, buf, 0);
	if (pg_buf == NULL)
		return -E_FAULT;
	tx_desc_queue[tail_index].buffer_addr = page2pa(pg_buf) + PGOFF(buf);
	

	tx_desc_queue[tail_index].length = size;
	

	// Mark DD = 0, meaning descriptor is not free.
	tx_desc_queue[tail_index].status &= ~E1000_TXD_STAT_DD;

	nicw(E1000_TDT, (tail_index + 1) % NUM_TX_DESC);
	return 0;
}


// Copies the buf of tail queue index of tx_packet_buf array's content to the given buf.
// Important note: TDT Register points to the next no-empty descriptor.
// buf is being written to from TDT index in packet array. At the end,
// TDT register is incremented by 1, meaning the current index is empty.
// Returns the length of the packet written to buf on success.
// Possible errors:
// - if size argument is smaller then received packet size - return -E_PACKET_TOO_BIG
// - if ring desriptor queue is empty - return -E_RX_EMPTY
int
rx_packet(void *buf, uint32_t* size) {
	int tail_index = (nic_get_reg(E1000_RDT) + 1) % NUM_RX_DESC;

	// If DD = 0, then descriptor doesnt contain packet. this means that tail = head index.
	if ((rx_desc_queue[tail_index].status & E1000_RXD_STAT_DD) == 0) {
		return -E_RX_EMPTY;
	}

	if ((rx_desc_queue[tail_index].status & E1000_RXD_STAT_EOP) == 0) {
		return -E_RX_EMPTY;
	}

	int len = rx_desc_queue[tail_index].length;
	*size = len;
	memcpy(buf, rx_buf_array[tail_index].buf, len);

	// Mark DD = 0, meaning no packet written to descriptor
	rx_desc_queue[tail_index].status &= ~E1000_RXD_STAT_DD;

	nicw(E1000_RDT, tail_index);
	return 0;
}






