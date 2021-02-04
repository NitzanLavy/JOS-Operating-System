#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

#include <kern/pci.h>

int e1000_attachfn(struct pci_func *pcif);
int tx_packet(char *buf, int size);
int rx_packet(void *buf, uint32_t* size);
void Tx_init();
void Rx_init();
static void nicw(int index, int value);
uint32_t nic_get_reg(int index);
void get_MAC_from_EEPROM(uint32_t* low, uint32_t* high);
uint32_t read_EEPROM_addr(uint16_t addr);

/* Transmit Descriptor */
struct e1000_tx_desc {
    uint64_t buffer_addr;       /* Address of the descriptor's data buffer */
    uint16_t length;    /* Data buffer length */
    uint8_t cso;        /* Checksum offset */
    uint8_t cmd;        /* Descriptor control */
    uint8_t status;     /* Descriptor status */
    uint8_t css;        /* Checksum start */
    uint16_t special;
};

/* Receive Descriptor */
struct e1000_rx_desc {
    uint64_t buffer_addr; /* Address of the descriptor's data buffer */
    uint16_t length;     /* Length of data DMAed into data buffer */
    uint16_t csum;       /* Packet checksum */
    uint8_t status;      /* Descriptor status */
    uint8_t errors;      /* Descriptor Errors */
    uint16_t special;
};

/* PCI Device IDs */
#define VENDOR_ID_82540EM 0x8086
#define DEVICE_ID_82540EM 0x100e

/* Sizes */
#define NUM_TX_DESC		64
#define NUM_RX_DESC		128
#define MAX_TX_PACKET_SIZE	1518
#define MAX_RX_PACKET_SIZE	2048
#define HEAD_SIZE 		4

/* MAC Address */
#define MAC_LOW 0x12005452		// Maybe should translate to int for nicw func?
#define MAC_HIGH 0x5634

/* Register Set. (82543, 82544)
 *
 * Registers are defined to be 32 bits and  should be accessed as 32 bit values.
 * These registers are physically located on the NIC, but are mapped into the
 * host memory address space.
 *
 * RW - register is both readable and writable
 * RO - register is read only
 * WO - register is write only
 * R/clr - register is read only and is cleared when read
 * A - register array
 */
#define E1000_TDBAL    0x03800  /* TX Descriptor Base Address Low - RW */
#define E1000_TDBAH    0x03804  /* TX Descriptor Base Address High - RW */
#define E1000_TDLEN    0x03808  /* TX Descriptor Length - RW */
#define E1000_TDH      0x03810  /* TX Descriptor Head - RW */
#define E1000_TDT      0x03818  /* TX Descripotr Tail - RW */
#define E1000_TCTL     0x00400  /* TX Control - RW */
#define E1000_TIPG     0x00410  /* TX Inter-packet gap -RW */
#define E1000_RAL      0x05400  /* Receive Address - RW Array */
#define E1000_RAH      0x05404  /* Receive Address - RW Array HIGH */
#define E1000_MTA      0x05200  /* Multicast Table Array - RW Array */
#define E1000_RDBAL    0x02800  /* RX Descriptor Base Address Low - RW */
#define E1000_RDBAH    0x02804  /* RX Descriptor Base Address High - RW */
#define E1000_RDLEN    0x02808  /* RX Descriptor Length - RW */
#define E1000_RDH      0x02810  /* RX Descriptor Head - RW */
#define E1000_RDT      0x02818  /* RX Descriptor Tail - RW */
#define E1000_RCTL     0x00100  /* RX Control - RW */
#define E1000_IMS      0x000D0  /* Interrupt Mask Set - RW */
#define E1000_RDTR     0x02820  /* RX Delay Timer - RW */
#define E1000_RDTR     0x02820  /* RX Delay Timer - RW */
#define E1000_ICR      0x000C0  /* Interrupt Cause Read - R/clr */
#define E1000_EERD     0x00014  /* EEPROM Read - RW */

/* Transmit Control */
#define E1000_TCTL_EN     0x00000002    /* enable tx */
#define E1000_TCTL_PSP    0x00000008    /* pad short packets */
#define E1000_TCTL_CT     0x00000ff0    /* collision threshold */
#define E1000_TCTL_COLD   0x003ff000    /* collision distance */

/* Transmit Descriptor bit definitions */
#define E1000_TXD_STAT_DD    0x00000001 /* Descriptor Done */

/* Transmit Descriptor bit definitions */
#define E1000_TXD_CMD_EOP    0x1 /* End of Packet */
#define E1000_TXD_CMD_RS     0x8 /* Report Status */

/* Receive Control */
#define E1000_RCTL_EN             0x00000002    /* enable */
#define E1000_RCTL_BAM            0x00008000    /* broadcast enable */
#define E1000_RCTL_SECRC          0x04000000    /* Strip Ethernet CRC */
#define E1000_RAH_AV  0x80000000        /* Receive descriptor valid */
#define E1000_RXD_STAT_EOP      0x02    /* End of Packet */
#define E1000_RCTL_SZ_2048 0x00000000 /* rx buffer size 2048 */
#define E1000_RCTL_LBM_NO 0x00000000 /* no loopback mode */

/* Receive Descriptor bit definitions */
#define E1000_RXD_STAT_DD       0x01    /* Descriptor Done */

/* Interrupt Cause Read */
#define E1000_ICR_TXDW          0x00000001 /* Transmit desc written back */
#define E1000_ICR_RXT0          0x00000080 /* rx timer intr (ring 0) */

/* EEPROM bit definitions */
#define E1000_EERC_ADDR          0xFF00
#define E1000_EERC_START         1
#define E1000_EERC_DONE          0x10
#define E1000_EERC_DATA          0xFFFF0000

#define E1000_IRQ_MASK          0x00000800 /* IRQ number */


#endif	// JOS_KERN_E1000_H
