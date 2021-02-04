
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 40 12 00       	mov    $0x124000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 40 12 f0       	mov    $0xf0124000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 6a 00 00 00       	call   f01000a8 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	83 ec 10             	sub    $0x10,%esp
f0100048:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010004b:	83 3d 8c 4e 2c f0 00 	cmpl   $0x0,0xf02c4e8c
f0100052:	75 46                	jne    f010009a <_panic+0x5a>
		goto dead;
	panicstr = fmt;
f0100054:	89 35 8c 4e 2c f0    	mov    %esi,0xf02c4e8c

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f010005a:	fa                   	cli    
f010005b:	fc                   	cld    

	va_start(ap, fmt);
f010005c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010005f:	e8 c5 6e 00 00       	call   f0106f29 <cpunum>
f0100064:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100067:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010006b:	8b 55 08             	mov    0x8(%ebp),%edx
f010006e:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100072:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100076:	c7 04 24 60 81 10 f0 	movl   $0xf0108160,(%esp)
f010007d:	e8 54 42 00 00       	call   f01042d6 <cprintf>
	vcprintf(fmt, ap);
f0100082:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100086:	89 34 24             	mov    %esi,(%esp)
f0100089:	e8 15 42 00 00       	call   f01042a3 <vcprintf>
	cprintf("\n");
f010008e:	c7 04 24 9b 8c 10 f0 	movl   $0xf0108c9b,(%esp)
f0100095:	e8 3c 42 00 00       	call   f01042d6 <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010009a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000a1:	e8 38 0d 00 00       	call   f0100dde <monitor>
f01000a6:	eb f2                	jmp    f010009a <_panic+0x5a>

f01000a8 <i386_init>:
static void boot_aps(void);


void
i386_init(void)
{
f01000a8:	55                   	push   %ebp
f01000a9:	89 e5                	mov    %esp,%ebp
f01000ab:	53                   	push   %ebx
f01000ac:	83 ec 14             	sub    $0x14,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f01000af:	b8 c0 e7 35 f0       	mov    $0xf035e7c0,%eax
f01000b4:	2d 0d 39 2c f0       	sub    $0xf02c390d,%eax
f01000b9:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01000c4:	00 
f01000c5:	c7 04 24 0d 39 2c f0 	movl   $0xf02c390d,(%esp)
f01000cc:	e8 06 68 00 00       	call   f01068d7 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01000d1:	e8 d9 05 00 00       	call   f01006af <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f01000d6:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f01000dd:	00 
f01000de:	c7 04 24 cc 81 10 f0 	movl   $0xf01081cc,(%esp)
f01000e5:	e8 ec 41 00 00       	call   f01042d6 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f01000ea:	e8 aa 17 00 00       	call   f0101899 <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f01000ef:	e8 e4 39 00 00       	call   f0103ad8 <env_init>
	trap_init();
f01000f4:	e8 ef 42 00 00       	call   f01043e8 <trap_init>

	// Lab 4 multiprocessor initialization functions
	mp_init();
f01000f9:	e8 1c 6b 00 00       	call   f0106c1a <mp_init>
	lapic_init();
f01000fe:	66 90                	xchg   %ax,%ax
f0100100:	e8 3f 6e 00 00       	call   f0106f44 <lapic_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f0100105:	e8 e9 40 00 00       	call   f01041f3 <pic_init>

	// Lab 6 hardware initialization functions
	time_init();
f010010a:	e8 5b 7d 00 00       	call   f0107e6a <time_init>
	pci_init();
f010010f:	90                   	nop
f0100110:	e8 27 7d 00 00       	call   f0107e3c <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0100115:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f010011c:	e8 86 70 00 00       	call   f01071a7 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100121:	83 3d 94 4e 2c f0 07 	cmpl   $0x7,0xf02c4e94
f0100128:	77 24                	ja     f010014e <i386_init+0xa6>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010012a:	c7 44 24 0c 00 70 00 	movl   $0x7000,0xc(%esp)
f0100131:	00 
f0100132:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0100139:	f0 
f010013a:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
f0100141:	00 
f0100142:	c7 04 24 e7 81 10 f0 	movl   $0xf01081e7,(%esp)
f0100149:	e8 f2 fe ff ff       	call   f0100040 <_panic>
	void *code;
	struct CpuInfo *c;

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f010014e:	b8 52 6b 10 f0       	mov    $0xf0106b52,%eax
f0100153:	2d d8 6a 10 f0       	sub    $0xf0106ad8,%eax
f0100158:	89 44 24 08          	mov    %eax,0x8(%esp)
f010015c:	c7 44 24 04 d8 6a 10 	movl   $0xf0106ad8,0x4(%esp)
f0100163:	f0 
f0100164:	c7 04 24 00 70 00 f0 	movl   $0xf0007000,(%esp)
f010016b:	e8 b4 67 00 00       	call   f0106924 <memmove>

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f0100170:	bb 20 50 2c f0       	mov    $0xf02c5020,%ebx
f0100175:	eb 4d                	jmp    f01001c4 <i386_init+0x11c>
		if (c == cpus + cpunum())  // We've started already.
f0100177:	e8 ad 6d 00 00       	call   f0106f29 <cpunum>
f010017c:	6b c0 74             	imul   $0x74,%eax,%eax
f010017f:	05 20 50 2c f0       	add    $0xf02c5020,%eax
f0100184:	39 c3                	cmp    %eax,%ebx
f0100186:	74 39                	je     f01001c1 <i386_init+0x119>
f0100188:	89 d8                	mov    %ebx,%eax
f010018a:	2d 20 50 2c f0       	sub    $0xf02c5020,%eax
			continue;

		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010018f:	c1 f8 02             	sar    $0x2,%eax
f0100192:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100198:	c1 e0 0f             	shl    $0xf,%eax
f010019b:	8d 80 00 e0 2c f0    	lea    -0xfd32000(%eax),%eax
f01001a1:	a3 90 4e 2c f0       	mov    %eax,0xf02c4e90
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
f01001a6:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
f01001ad:	00 
f01001ae:	0f b6 03             	movzbl (%ebx),%eax
f01001b1:	89 04 24             	mov    %eax,(%esp)
f01001b4:	e8 db 6e 00 00       	call   f0107094 <lapic_startap>
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
f01001b9:	8b 43 04             	mov    0x4(%ebx),%eax
f01001bc:	83 f8 01             	cmp    $0x1,%eax
f01001bf:	75 f8                	jne    f01001b9 <i386_init+0x111>
	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f01001c1:	83 c3 74             	add    $0x74,%ebx
f01001c4:	6b 05 c4 53 2c f0 74 	imul   $0x74,0xf02c53c4,%eax
f01001cb:	05 20 50 2c f0       	add    $0xf02c5020,%eax
f01001d0:	39 c3                	cmp    %eax,%ebx
f01001d2:	72 a3                	jb     f0100177 <i386_init+0xcf>

	// Starting non-boot CPUs
	boot_aps();

	// Start fs.
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f01001d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f01001db:	00 
f01001dc:	c7 04 24 a6 6c 1e f0 	movl   $0xf01e6ca6,(%esp)
f01001e3:	e8 bd 3a 00 00       	call   f0103ca5 <env_create>

#if !defined(TEST_NO_NS)
	// Start ns.
	ENV_CREATE(net_ns, ENV_TYPE_NS);
f01001e8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f01001ef:	00 
f01001f0:	c7 04 24 a6 3b 24 f0 	movl   $0xf0243ba6,(%esp)
f01001f7:	e8 a9 3a 00 00       	call   f0103ca5 <env_create>
#endif

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100203:	00 
f0100204:	c7 04 24 b1 87 20 f0 	movl   $0xf02087b1,(%esp)
f010020b:	e8 95 3a 00 00       	call   f0103ca5 <env_create>
	ENV_CREATE(user_icode, ENV_TYPE_USER);

#endif // TEST*

	// Should not be necessary - drains keyboard because interrupt has given up.
	kbd_intr();
f0100210:	e8 3e 04 00 00       	call   f0100653 <kbd_intr>

	// Schedule and run the first user environment!
	sched_yield();
f0100215:	e8 8e 4f 00 00       	call   f01051a8 <sched_yield>

f010021a <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f010021a:	55                   	push   %ebp
f010021b:	89 e5                	mov    %esp,%ebp
f010021d:	83 ec 18             	sub    $0x18,%esp
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f0100220:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0100225:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010022a:	77 20                	ja     f010024c <mp_main+0x32>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010022c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100230:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0100237:	f0 
f0100238:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
f010023f:	00 
f0100240:	c7 04 24 e7 81 10 f0 	movl   $0xf01081e7,(%esp)
f0100247:	e8 f4 fd ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010024c:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0100251:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100254:	e8 d0 6c 00 00       	call   f0106f29 <cpunum>
f0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
f010025d:	c7 04 24 f3 81 10 f0 	movl   $0xf01081f3,(%esp)
f0100264:	e8 6d 40 00 00       	call   f01042d6 <cprintf>

	lapic_init();
f0100269:	e8 d6 6c 00 00       	call   f0106f44 <lapic_init>
	env_init_percpu();
f010026e:	e8 3b 38 00 00       	call   f0103aae <env_init_percpu>
	trap_init_percpu();
f0100273:	e8 78 40 00 00       	call   f01042f0 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100278:	e8 ac 6c 00 00       	call   f0106f29 <cpunum>
f010027d:	6b d0 74             	imul   $0x74,%eax,%edx
f0100280:	81 c2 20 50 2c f0    	add    $0xf02c5020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0100286:	b8 01 00 00 00       	mov    $0x1,%eax
f010028b:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f010028f:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f0100296:	e8 0c 6f 00 00       	call   f01071a7 <spin_lock>
	// to start running processes on this CPU.  But make sure that
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:
	lock_kernel();
	sched_yield();
f010029b:	e8 08 4f 00 00       	call   f01051a8 <sched_yield>

f01002a0 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01002a0:	55                   	push   %ebp
f01002a1:	89 e5                	mov    %esp,%ebp
f01002a3:	53                   	push   %ebx
f01002a4:	83 ec 14             	sub    $0x14,%esp
	va_list ap;

	va_start(ap, fmt);
f01002a7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
f01002ad:	89 44 24 08          	mov    %eax,0x8(%esp)
f01002b1:	8b 45 08             	mov    0x8(%ebp),%eax
f01002b4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002b8:	c7 04 24 09 82 10 f0 	movl   $0xf0108209,(%esp)
f01002bf:	e8 12 40 00 00       	call   f01042d6 <cprintf>
	vcprintf(fmt, ap);
f01002c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01002c8:	8b 45 10             	mov    0x10(%ebp),%eax
f01002cb:	89 04 24             	mov    %eax,(%esp)
f01002ce:	e8 d0 3f 00 00       	call   f01042a3 <vcprintf>
	cprintf("\n");
f01002d3:	c7 04 24 9b 8c 10 f0 	movl   $0xf0108c9b,(%esp)
f01002da:	e8 f7 3f 00 00       	call   f01042d6 <cprintf>
	va_end(ap);
}
f01002df:	83 c4 14             	add    $0x14,%esp
f01002e2:	5b                   	pop    %ebx
f01002e3:	5d                   	pop    %ebp
f01002e4:	c3                   	ret    
f01002e5:	66 90                	xchg   %ax,%ax
f01002e7:	66 90                	xchg   %ax,%ax
f01002e9:	66 90                	xchg   %ax,%ax
f01002eb:	66 90                	xchg   %ax,%ax
f01002ed:	66 90                	xchg   %ax,%ax
f01002ef:	90                   	nop

f01002f0 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f01002f0:	55                   	push   %ebp
f01002f1:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002f3:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002f8:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002f9:	a8 01                	test   $0x1,%al
f01002fb:	74 08                	je     f0100305 <serial_proc_data+0x15>
f01002fd:	b2 f8                	mov    $0xf8,%dl
f01002ff:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100300:	0f b6 c0             	movzbl %al,%eax
f0100303:	eb 05                	jmp    f010030a <serial_proc_data+0x1a>

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f0100305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return inb(COM1+COM_RX);
}
f010030a:	5d                   	pop    %ebp
f010030b:	c3                   	ret    

f010030c <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010030c:	55                   	push   %ebp
f010030d:	89 e5                	mov    %esp,%ebp
f010030f:	53                   	push   %ebx
f0100310:	83 ec 04             	sub    $0x4,%esp
f0100313:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100315:	eb 2a                	jmp    f0100341 <cons_intr+0x35>
		if (c == 0)
f0100317:	85 d2                	test   %edx,%edx
f0100319:	74 26                	je     f0100341 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
f010031b:	a1 24 42 2c f0       	mov    0xf02c4224,%eax
f0100320:	8d 48 01             	lea    0x1(%eax),%ecx
f0100323:	89 0d 24 42 2c f0    	mov    %ecx,0xf02c4224
f0100329:	88 90 20 40 2c f0    	mov    %dl,-0xfd3bfe0(%eax)
		if (cons.wpos == CONSBUFSIZE)
f010032f:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100335:	75 0a                	jne    f0100341 <cons_intr+0x35>
			cons.wpos = 0;
f0100337:	c7 05 24 42 2c f0 00 	movl   $0x0,0xf02c4224
f010033e:	00 00 00 
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f0100341:	ff d3                	call   *%ebx
f0100343:	89 c2                	mov    %eax,%edx
f0100345:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100348:	75 cd                	jne    f0100317 <cons_intr+0xb>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f010034a:	83 c4 04             	add    $0x4,%esp
f010034d:	5b                   	pop    %ebx
f010034e:	5d                   	pop    %ebp
f010034f:	c3                   	ret    

f0100350 <kbd_proc_data>:
f0100350:	ba 64 00 00 00       	mov    $0x64,%edx
f0100355:	ec                   	in     (%dx),%al
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f0100356:	a8 01                	test   $0x1,%al
f0100358:	0f 84 ef 00 00 00    	je     f010044d <kbd_proc_data+0xfd>
f010035e:	b2 60                	mov    $0x60,%dl
f0100360:	ec                   	in     (%dx),%al
f0100361:	89 c2                	mov    %eax,%edx
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f0100363:	3c e0                	cmp    $0xe0,%al
f0100365:	75 0d                	jne    f0100374 <kbd_proc_data+0x24>
		// E0 escape character
		shift |= E0ESC;
f0100367:	83 0d 00 40 2c f0 40 	orl    $0x40,0xf02c4000
		return 0;
f010036e:	b8 00 00 00 00       	mov    $0x0,%eax
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100373:	c3                   	ret    
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f0100374:	55                   	push   %ebp
f0100375:	89 e5                	mov    %esp,%ebp
f0100377:	53                   	push   %ebx
f0100378:	83 ec 14             	sub    $0x14,%esp

	if (data == 0xE0) {
		// E0 escape character
		shift |= E0ESC;
		return 0;
	} else if (data & 0x80) {
f010037b:	84 c0                	test   %al,%al
f010037d:	79 37                	jns    f01003b6 <kbd_proc_data+0x66>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f010037f:	8b 0d 00 40 2c f0    	mov    0xf02c4000,%ecx
f0100385:	89 cb                	mov    %ecx,%ebx
f0100387:	83 e3 40             	and    $0x40,%ebx
f010038a:	83 e0 7f             	and    $0x7f,%eax
f010038d:	85 db                	test   %ebx,%ebx
f010038f:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100392:	0f b6 d2             	movzbl %dl,%edx
f0100395:	0f b6 82 80 83 10 f0 	movzbl -0xfef7c80(%edx),%eax
f010039c:	83 c8 40             	or     $0x40,%eax
f010039f:	0f b6 c0             	movzbl %al,%eax
f01003a2:	f7 d0                	not    %eax
f01003a4:	21 c1                	and    %eax,%ecx
f01003a6:	89 0d 00 40 2c f0    	mov    %ecx,0xf02c4000
		return 0;
f01003ac:	b8 00 00 00 00       	mov    $0x0,%eax
f01003b1:	e9 9d 00 00 00       	jmp    f0100453 <kbd_proc_data+0x103>
	} else if (shift & E0ESC) {
f01003b6:	8b 0d 00 40 2c f0    	mov    0xf02c4000,%ecx
f01003bc:	f6 c1 40             	test   $0x40,%cl
f01003bf:	74 0e                	je     f01003cf <kbd_proc_data+0x7f>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f01003c1:	83 c8 80             	or     $0xffffff80,%eax
f01003c4:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01003c6:	83 e1 bf             	and    $0xffffffbf,%ecx
f01003c9:	89 0d 00 40 2c f0    	mov    %ecx,0xf02c4000
	}

	shift |= shiftcode[data];
f01003cf:	0f b6 d2             	movzbl %dl,%edx
f01003d2:	0f b6 82 80 83 10 f0 	movzbl -0xfef7c80(%edx),%eax
f01003d9:	0b 05 00 40 2c f0    	or     0xf02c4000,%eax
	shift ^= togglecode[data];
f01003df:	0f b6 8a 80 82 10 f0 	movzbl -0xfef7d80(%edx),%ecx
f01003e6:	31 c8                	xor    %ecx,%eax
f01003e8:	a3 00 40 2c f0       	mov    %eax,0xf02c4000

	c = charcode[shift & (CTL | SHIFT)][data];
f01003ed:	89 c1                	mov    %eax,%ecx
f01003ef:	83 e1 03             	and    $0x3,%ecx
f01003f2:	8b 0c 8d 60 82 10 f0 	mov    -0xfef7da0(,%ecx,4),%ecx
f01003f9:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f01003fd:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100400:	a8 08                	test   $0x8,%al
f0100402:	74 1b                	je     f010041f <kbd_proc_data+0xcf>
		if ('a' <= c && c <= 'z')
f0100404:	89 da                	mov    %ebx,%edx
f0100406:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100409:	83 f9 19             	cmp    $0x19,%ecx
f010040c:	77 05                	ja     f0100413 <kbd_proc_data+0xc3>
			c += 'A' - 'a';
f010040e:	83 eb 20             	sub    $0x20,%ebx
f0100411:	eb 0c                	jmp    f010041f <kbd_proc_data+0xcf>
		else if ('A' <= c && c <= 'Z')
f0100413:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100416:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100419:	83 fa 19             	cmp    $0x19,%edx
f010041c:	0f 46 d9             	cmovbe %ecx,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010041f:	f7 d0                	not    %eax
f0100421:	89 c2                	mov    %eax,%edx
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100423:	89 d8                	mov    %ebx,%eax
			c += 'a' - 'A';
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100425:	f6 c2 06             	test   $0x6,%dl
f0100428:	75 29                	jne    f0100453 <kbd_proc_data+0x103>
f010042a:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100430:	75 21                	jne    f0100453 <kbd_proc_data+0x103>
		cprintf("Rebooting!\n");
f0100432:	c7 04 24 23 82 10 f0 	movl   $0xf0108223,(%esp)
f0100439:	e8 98 3e 00 00       	call   f01042d6 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010043e:	ba 92 00 00 00       	mov    $0x92,%edx
f0100443:	b8 03 00 00 00       	mov    $0x3,%eax
f0100448:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100449:	89 d8                	mov    %ebx,%eax
f010044b:	eb 06                	jmp    f0100453 <kbd_proc_data+0x103>
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
f010044d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100452:	c3                   	ret    
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100453:	83 c4 14             	add    $0x14,%esp
f0100456:	5b                   	pop    %ebx
f0100457:	5d                   	pop    %ebp
f0100458:	c3                   	ret    

f0100459 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100459:	55                   	push   %ebp
f010045a:	89 e5                	mov    %esp,%ebp
f010045c:	57                   	push   %edi
f010045d:	56                   	push   %esi
f010045e:	53                   	push   %ebx
f010045f:	83 ec 1c             	sub    $0x1c,%esp
f0100462:	89 c7                	mov    %eax,%edi
f0100464:	bb 01 32 00 00       	mov    $0x3201,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100469:	be fd 03 00 00       	mov    $0x3fd,%esi
f010046e:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100473:	eb 06                	jmp    f010047b <cons_putc+0x22>
f0100475:	89 ca                	mov    %ecx,%edx
f0100477:	ec                   	in     (%dx),%al
f0100478:	ec                   	in     (%dx),%al
f0100479:	ec                   	in     (%dx),%al
f010047a:	ec                   	in     (%dx),%al
f010047b:	89 f2                	mov    %esi,%edx
f010047d:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f010047e:	a8 20                	test   $0x20,%al
f0100480:	75 05                	jne    f0100487 <cons_putc+0x2e>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100482:	83 eb 01             	sub    $0x1,%ebx
f0100485:	75 ee                	jne    f0100475 <cons_putc+0x1c>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f0100487:	89 f8                	mov    %edi,%eax
f0100489:	0f b6 c0             	movzbl %al,%eax
f010048c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010048f:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100494:	ee                   	out    %al,(%dx)
f0100495:	bb 01 32 00 00       	mov    $0x3201,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010049a:	be 79 03 00 00       	mov    $0x379,%esi
f010049f:	b9 84 00 00 00       	mov    $0x84,%ecx
f01004a4:	eb 06                	jmp    f01004ac <cons_putc+0x53>
f01004a6:	89 ca                	mov    %ecx,%edx
f01004a8:	ec                   	in     (%dx),%al
f01004a9:	ec                   	in     (%dx),%al
f01004aa:	ec                   	in     (%dx),%al
f01004ab:	ec                   	in     (%dx),%al
f01004ac:	89 f2                	mov    %esi,%edx
f01004ae:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004af:	84 c0                	test   %al,%al
f01004b1:	78 05                	js     f01004b8 <cons_putc+0x5f>
f01004b3:	83 eb 01             	sub    $0x1,%ebx
f01004b6:	75 ee                	jne    f01004a6 <cons_putc+0x4d>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004b8:	ba 78 03 00 00       	mov    $0x378,%edx
f01004bd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f01004c1:	ee                   	out    %al,(%dx)
f01004c2:	b2 7a                	mov    $0x7a,%dl
f01004c4:	b8 0d 00 00 00       	mov    $0xd,%eax
f01004c9:	ee                   	out    %al,(%dx)
f01004ca:	b8 08 00 00 00       	mov    $0x8,%eax
f01004cf:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f01004d0:	89 fa                	mov    %edi,%edx
f01004d2:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f01004d8:	89 f8                	mov    %edi,%eax
f01004da:	80 cc 07             	or     $0x7,%ah
f01004dd:	85 d2                	test   %edx,%edx
f01004df:	0f 44 f8             	cmove  %eax,%edi

	switch (c & 0xff) {
f01004e2:	89 f8                	mov    %edi,%eax
f01004e4:	0f b6 c0             	movzbl %al,%eax
f01004e7:	83 f8 09             	cmp    $0x9,%eax
f01004ea:	74 76                	je     f0100562 <cons_putc+0x109>
f01004ec:	83 f8 09             	cmp    $0x9,%eax
f01004ef:	7f 0a                	jg     f01004fb <cons_putc+0xa2>
f01004f1:	83 f8 08             	cmp    $0x8,%eax
f01004f4:	74 16                	je     f010050c <cons_putc+0xb3>
f01004f6:	e9 9b 00 00 00       	jmp    f0100596 <cons_putc+0x13d>
f01004fb:	83 f8 0a             	cmp    $0xa,%eax
f01004fe:	66 90                	xchg   %ax,%ax
f0100500:	74 3a                	je     f010053c <cons_putc+0xe3>
f0100502:	83 f8 0d             	cmp    $0xd,%eax
f0100505:	74 3d                	je     f0100544 <cons_putc+0xeb>
f0100507:	e9 8a 00 00 00       	jmp    f0100596 <cons_putc+0x13d>
	case '\b':
		if (crt_pos > 0) {
f010050c:	0f b7 05 28 42 2c f0 	movzwl 0xf02c4228,%eax
f0100513:	66 85 c0             	test   %ax,%ax
f0100516:	0f 84 e5 00 00 00    	je     f0100601 <cons_putc+0x1a8>
			crt_pos--;
f010051c:	83 e8 01             	sub    $0x1,%eax
f010051f:	66 a3 28 42 2c f0    	mov    %ax,0xf02c4228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100525:	0f b7 c0             	movzwl %ax,%eax
f0100528:	66 81 e7 00 ff       	and    $0xff00,%di
f010052d:	83 cf 20             	or     $0x20,%edi
f0100530:	8b 15 2c 42 2c f0    	mov    0xf02c422c,%edx
f0100536:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f010053a:	eb 78                	jmp    f01005b4 <cons_putc+0x15b>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f010053c:	66 83 05 28 42 2c f0 	addw   $0x50,0xf02c4228
f0100543:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f0100544:	0f b7 05 28 42 2c f0 	movzwl 0xf02c4228,%eax
f010054b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100551:	c1 e8 16             	shr    $0x16,%eax
f0100554:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100557:	c1 e0 04             	shl    $0x4,%eax
f010055a:	66 a3 28 42 2c f0    	mov    %ax,0xf02c4228
f0100560:	eb 52                	jmp    f01005b4 <cons_putc+0x15b>
		break;
	case '\t':
		cons_putc(' ');
f0100562:	b8 20 00 00 00       	mov    $0x20,%eax
f0100567:	e8 ed fe ff ff       	call   f0100459 <cons_putc>
		cons_putc(' ');
f010056c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100571:	e8 e3 fe ff ff       	call   f0100459 <cons_putc>
		cons_putc(' ');
f0100576:	b8 20 00 00 00       	mov    $0x20,%eax
f010057b:	e8 d9 fe ff ff       	call   f0100459 <cons_putc>
		cons_putc(' ');
f0100580:	b8 20 00 00 00       	mov    $0x20,%eax
f0100585:	e8 cf fe ff ff       	call   f0100459 <cons_putc>
		cons_putc(' ');
f010058a:	b8 20 00 00 00       	mov    $0x20,%eax
f010058f:	e8 c5 fe ff ff       	call   f0100459 <cons_putc>
f0100594:	eb 1e                	jmp    f01005b4 <cons_putc+0x15b>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f0100596:	0f b7 05 28 42 2c f0 	movzwl 0xf02c4228,%eax
f010059d:	8d 50 01             	lea    0x1(%eax),%edx
f01005a0:	66 89 15 28 42 2c f0 	mov    %dx,0xf02c4228
f01005a7:	0f b7 c0             	movzwl %ax,%eax
f01005aa:	8b 15 2c 42 2c f0    	mov    0xf02c422c,%edx
f01005b0:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f01005b4:	66 81 3d 28 42 2c f0 	cmpw   $0x7cf,0xf02c4228
f01005bb:	cf 07 
f01005bd:	76 42                	jbe    f0100601 <cons_putc+0x1a8>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005bf:	a1 2c 42 2c f0       	mov    0xf02c422c,%eax
f01005c4:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f01005cb:	00 
f01005cc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005d2:	89 54 24 04          	mov    %edx,0x4(%esp)
f01005d6:	89 04 24             	mov    %eax,(%esp)
f01005d9:	e8 46 63 00 00       	call   f0106924 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f01005de:	8b 15 2c 42 2c f0    	mov    0xf02c422c,%edx
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005e4:	b8 80 07 00 00       	mov    $0x780,%eax
			crt_buf[i] = 0x0700 | ' ';
f01005e9:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005ef:	83 c0 01             	add    $0x1,%eax
f01005f2:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f01005f7:	75 f0                	jne    f01005e9 <cons_putc+0x190>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f01005f9:	66 83 2d 28 42 2c f0 	subw   $0x50,0xf02c4228
f0100600:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f0100601:	8b 0d 30 42 2c f0    	mov    0xf02c4230,%ecx
f0100607:	b8 0e 00 00 00       	mov    $0xe,%eax
f010060c:	89 ca                	mov    %ecx,%edx
f010060e:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010060f:	0f b7 1d 28 42 2c f0 	movzwl 0xf02c4228,%ebx
f0100616:	8d 71 01             	lea    0x1(%ecx),%esi
f0100619:	89 d8                	mov    %ebx,%eax
f010061b:	66 c1 e8 08          	shr    $0x8,%ax
f010061f:	89 f2                	mov    %esi,%edx
f0100621:	ee                   	out    %al,(%dx)
f0100622:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100627:	89 ca                	mov    %ecx,%edx
f0100629:	ee                   	out    %al,(%dx)
f010062a:	89 d8                	mov    %ebx,%eax
f010062c:	89 f2                	mov    %esi,%edx
f010062e:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010062f:	83 c4 1c             	add    $0x1c,%esp
f0100632:	5b                   	pop    %ebx
f0100633:	5e                   	pop    %esi
f0100634:	5f                   	pop    %edi
f0100635:	5d                   	pop    %ebp
f0100636:	c3                   	ret    

f0100637 <serial_intr>:
}

void
serial_intr(void)
{
	if (serial_exists)
f0100637:	80 3d 34 42 2c f0 00 	cmpb   $0x0,0xf02c4234
f010063e:	74 11                	je     f0100651 <serial_intr+0x1a>
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f0100640:	55                   	push   %ebp
f0100641:	89 e5                	mov    %esp,%ebp
f0100643:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
		cons_intr(serial_proc_data);
f0100646:	b8 f0 02 10 f0       	mov    $0xf01002f0,%eax
f010064b:	e8 bc fc ff ff       	call   f010030c <cons_intr>
}
f0100650:	c9                   	leave  
f0100651:	f3 c3                	repz ret 

f0100653 <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f0100653:	55                   	push   %ebp
f0100654:	89 e5                	mov    %esp,%ebp
f0100656:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100659:	b8 50 03 10 f0       	mov    $0xf0100350,%eax
f010065e:	e8 a9 fc ff ff       	call   f010030c <cons_intr>
}
f0100663:	c9                   	leave  
f0100664:	c3                   	ret    

f0100665 <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f0100665:	55                   	push   %ebp
f0100666:	89 e5                	mov    %esp,%ebp
f0100668:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f010066b:	e8 c7 ff ff ff       	call   f0100637 <serial_intr>
	kbd_intr();
f0100670:	e8 de ff ff ff       	call   f0100653 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f0100675:	a1 20 42 2c f0       	mov    0xf02c4220,%eax
f010067a:	3b 05 24 42 2c f0    	cmp    0xf02c4224,%eax
f0100680:	74 26                	je     f01006a8 <cons_getc+0x43>
		c = cons.buf[cons.rpos++];
f0100682:	8d 50 01             	lea    0x1(%eax),%edx
f0100685:	89 15 20 42 2c f0    	mov    %edx,0xf02c4220
f010068b:	0f b6 88 20 40 2c f0 	movzbl -0xfd3bfe0(%eax),%ecx
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
f0100692:	89 c8                	mov    %ecx,%eax
	kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
f0100694:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010069a:	75 11                	jne    f01006ad <cons_getc+0x48>
			cons.rpos = 0;
f010069c:	c7 05 20 42 2c f0 00 	movl   $0x0,0xf02c4220
f01006a3:	00 00 00 
f01006a6:	eb 05                	jmp    f01006ad <cons_getc+0x48>
		return c;
	}
	return 0;
f01006a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01006ad:	c9                   	leave  
f01006ae:	c3                   	ret    

f01006af <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f01006af:	55                   	push   %ebp
f01006b0:	89 e5                	mov    %esp,%ebp
f01006b2:	57                   	push   %edi
f01006b3:	56                   	push   %esi
f01006b4:	53                   	push   %ebx
f01006b5:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01006b8:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01006bf:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01006c6:	5a a5 
	if (*cp != 0xA55A) {
f01006c8:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01006cf:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006d3:	74 11                	je     f01006e6 <cons_init+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f01006d5:	c7 05 30 42 2c f0 b4 	movl   $0x3b4,0xf02c4230
f01006dc:	03 00 00 

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006df:	bf 00 00 0b f0       	mov    $0xf00b0000,%edi
f01006e4:	eb 16                	jmp    f01006fc <cons_init+0x4d>
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
f01006e6:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01006ed:	c7 05 30 42 2c f0 d4 	movl   $0x3d4,0xf02c4230
f01006f4:	03 00 00 
{
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01006f7:	bf 00 80 0b f0       	mov    $0xf00b8000,%edi
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f01006fc:	8b 0d 30 42 2c f0    	mov    0xf02c4230,%ecx
f0100702:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100707:	89 ca                	mov    %ecx,%edx
f0100709:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010070a:	8d 59 01             	lea    0x1(%ecx),%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010070d:	89 da                	mov    %ebx,%edx
f010070f:	ec                   	in     (%dx),%al
f0100710:	0f b6 f0             	movzbl %al,%esi
f0100713:	c1 e6 08             	shl    $0x8,%esi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100716:	b8 0f 00 00 00       	mov    $0xf,%eax
f010071b:	89 ca                	mov    %ecx,%edx
f010071d:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010071e:	89 da                	mov    %ebx,%edx
f0100720:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f0100721:	89 3d 2c 42 2c f0    	mov    %edi,0xf02c422c

	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);
f0100727:	0f b6 d8             	movzbl %al,%ebx
f010072a:	09 de                	or     %ebx,%esi

	crt_buf = (uint16_t*) cp;
	crt_pos = pos;
f010072c:	66 89 35 28 42 2c f0 	mov    %si,0xf02c4228

static void
kbd_init(void)
{
	// Drain the kbd buffer so that QEMU generates interrupts.
	kbd_intr();
f0100733:	e8 1b ff ff ff       	call   f0100653 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f0100738:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f010073f:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100744:	89 04 24             	mov    %eax,(%esp)
f0100747:	e8 38 3a 00 00       	call   f0104184 <irq_setmask_8259A>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010074c:	be fa 03 00 00       	mov    $0x3fa,%esi
f0100751:	b8 00 00 00 00       	mov    $0x0,%eax
f0100756:	89 f2                	mov    %esi,%edx
f0100758:	ee                   	out    %al,(%dx)
f0100759:	b2 fb                	mov    $0xfb,%dl
f010075b:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100760:	ee                   	out    %al,(%dx)
f0100761:	bb f8 03 00 00       	mov    $0x3f8,%ebx
f0100766:	b8 0c 00 00 00       	mov    $0xc,%eax
f010076b:	89 da                	mov    %ebx,%edx
f010076d:	ee                   	out    %al,(%dx)
f010076e:	b2 f9                	mov    $0xf9,%dl
f0100770:	b8 00 00 00 00       	mov    $0x0,%eax
f0100775:	ee                   	out    %al,(%dx)
f0100776:	b2 fb                	mov    $0xfb,%dl
f0100778:	b8 03 00 00 00       	mov    $0x3,%eax
f010077d:	ee                   	out    %al,(%dx)
f010077e:	b2 fc                	mov    $0xfc,%dl
f0100780:	b8 00 00 00 00       	mov    $0x0,%eax
f0100785:	ee                   	out    %al,(%dx)
f0100786:	b2 f9                	mov    $0xf9,%dl
f0100788:	b8 01 00 00 00       	mov    $0x1,%eax
f010078d:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010078e:	b2 fd                	mov    $0xfd,%dl
f0100790:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100791:	3c ff                	cmp    $0xff,%al
f0100793:	0f 95 c1             	setne  %cl
f0100796:	88 0d 34 42 2c f0    	mov    %cl,0xf02c4234
f010079c:	89 f2                	mov    %esi,%edx
f010079e:	ec                   	in     (%dx),%al
f010079f:	89 da                	mov    %ebx,%edx
f01007a1:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f01007a2:	84 c9                	test   %cl,%cl
f01007a4:	74 1d                	je     f01007c3 <cons_init+0x114>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f01007a6:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f01007ad:	25 ef ff 00 00       	and    $0xffef,%eax
f01007b2:	89 04 24             	mov    %eax,(%esp)
f01007b5:	e8 ca 39 00 00       	call   f0104184 <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01007ba:	80 3d 34 42 2c f0 00 	cmpb   $0x0,0xf02c4234
f01007c1:	75 0c                	jne    f01007cf <cons_init+0x120>
		cprintf("Serial port does not exist!\n");
f01007c3:	c7 04 24 2f 82 10 f0 	movl   $0xf010822f,(%esp)
f01007ca:	e8 07 3b 00 00       	call   f01042d6 <cprintf>
}
f01007cf:	83 c4 1c             	add    $0x1c,%esp
f01007d2:	5b                   	pop    %ebx
f01007d3:	5e                   	pop    %esi
f01007d4:	5f                   	pop    %edi
f01007d5:	5d                   	pop    %ebp
f01007d6:	c3                   	ret    

f01007d7 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007d7:	55                   	push   %ebp
f01007d8:	89 e5                	mov    %esp,%ebp
f01007da:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007dd:	8b 45 08             	mov    0x8(%ebp),%eax
f01007e0:	e8 74 fc ff ff       	call   f0100459 <cons_putc>
}
f01007e5:	c9                   	leave  
f01007e6:	c3                   	ret    

f01007e7 <getchar>:

int
getchar(void)
{
f01007e7:	55                   	push   %ebp
f01007e8:	89 e5                	mov    %esp,%ebp
f01007ea:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007ed:	e8 73 fe ff ff       	call   f0100665 <cons_getc>
f01007f2:	85 c0                	test   %eax,%eax
f01007f4:	74 f7                	je     f01007ed <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007f6:	c9                   	leave  
f01007f7:	c3                   	ret    

f01007f8 <iscons>:

int
iscons(int fdnum)
{
f01007f8:	55                   	push   %ebp
f01007f9:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01007fb:	b8 01 00 00 00       	mov    $0x1,%eax
f0100800:	5d                   	pop    %ebp
f0100801:	c3                   	ret    
f0100802:	66 90                	xchg   %ax,%ax
f0100804:	66 90                	xchg   %ax,%ax
f0100806:	66 90                	xchg   %ax,%ax
f0100808:	66 90                	xchg   %ax,%ax
f010080a:	66 90                	xchg   %ax,%ax
f010080c:	66 90                	xchg   %ax,%ax
f010080e:	66 90                	xchg   %ax,%ax

f0100810 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100810:	55                   	push   %ebp
f0100811:	89 e5                	mov    %esp,%ebp
f0100813:	56                   	push   %esi
f0100814:	53                   	push   %ebx
f0100815:	83 ec 10             	sub    $0x10,%esp
f0100818:	bb 44 89 10 f0       	mov    $0xf0108944,%ebx
f010081d:	be a4 89 10 f0       	mov    $0xf01089a4,%esi
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100822:	8b 03                	mov    (%ebx),%eax
f0100824:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100828:	8b 43 fc             	mov    -0x4(%ebx),%eax
f010082b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010082f:	c7 04 24 80 84 10 f0 	movl   $0xf0108480,(%esp)
f0100836:	e8 9b 3a 00 00       	call   f01042d6 <cprintf>
f010083b:	83 c3 0c             	add    $0xc,%ebx
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f010083e:	39 f3                	cmp    %esi,%ebx
f0100840:	75 e0                	jne    f0100822 <mon_help+0x12>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}
f0100842:	b8 00 00 00 00       	mov    $0x0,%eax
f0100847:	83 c4 10             	add    $0x10,%esp
f010084a:	5b                   	pop    %ebx
f010084b:	5e                   	pop    %esi
f010084c:	5d                   	pop    %ebp
f010084d:	c3                   	ret    

f010084e <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010084e:	55                   	push   %ebp
f010084f:	89 e5                	mov    %esp,%ebp
f0100851:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100854:	c7 04 24 89 84 10 f0 	movl   $0xf0108489,(%esp)
f010085b:	e8 76 3a 00 00       	call   f01042d6 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100860:	c7 44 24 04 0c 00 10 	movl   $0x10000c,0x4(%esp)
f0100867:	00 
f0100868:	c7 04 24 4c 86 10 f0 	movl   $0xf010864c,(%esp)
f010086f:	e8 62 3a 00 00       	call   f01042d6 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100874:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f010087b:	00 
f010087c:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f0100883:	f0 
f0100884:	c7 04 24 74 86 10 f0 	movl   $0xf0108674,(%esp)
f010088b:	e8 46 3a 00 00       	call   f01042d6 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100890:	c7 44 24 08 57 81 10 	movl   $0x108157,0x8(%esp)
f0100897:	00 
f0100898:	c7 44 24 04 57 81 10 	movl   $0xf0108157,0x4(%esp)
f010089f:	f0 
f01008a0:	c7 04 24 98 86 10 f0 	movl   $0xf0108698,(%esp)
f01008a7:	e8 2a 3a 00 00       	call   f01042d6 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008ac:	c7 44 24 08 0d 39 2c 	movl   $0x2c390d,0x8(%esp)
f01008b3:	00 
f01008b4:	c7 44 24 04 0d 39 2c 	movl   $0xf02c390d,0x4(%esp)
f01008bb:	f0 
f01008bc:	c7 04 24 bc 86 10 f0 	movl   $0xf01086bc,(%esp)
f01008c3:	e8 0e 3a 00 00       	call   f01042d6 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008c8:	c7 44 24 08 c0 e7 35 	movl   $0x35e7c0,0x8(%esp)
f01008cf:	00 
f01008d0:	c7 44 24 04 c0 e7 35 	movl   $0xf035e7c0,0x4(%esp)
f01008d7:	f0 
f01008d8:	c7 04 24 e0 86 10 f0 	movl   $0xf01086e0,(%esp)
f01008df:	e8 f2 39 00 00       	call   f01042d6 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f01008e4:	b8 bf eb 35 f0       	mov    $0xf035ebbf,%eax
f01008e9:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f01008ee:	25 00 fc ff ff       	and    $0xfffffc00,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008f3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f01008f9:	85 c0                	test   %eax,%eax
f01008fb:	0f 48 c2             	cmovs  %edx,%eax
f01008fe:	c1 f8 0a             	sar    $0xa,%eax
f0100901:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100905:	c7 04 24 04 87 10 f0 	movl   $0xf0108704,(%esp)
f010090c:	e8 c5 39 00 00       	call   f01042d6 <cprintf>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
f0100911:	b8 00 00 00 00       	mov    $0x0,%eax
f0100916:	c9                   	leave  
f0100917:	c3                   	ret    

f0100918 <mon_stepping>:
}

//Enables single stepping by setting trap flag (bit num 8) of EFLAGS register to 1.
//no arguments
int
mon_stepping(int argc, char **argv, struct Trapframe *tf) {
f0100918:	55                   	push   %ebp
f0100919:	89 e5                	mov    %esp,%ebp
f010091b:	83 ec 18             	sub    $0x18,%esp
f010091e:	8b 45 10             	mov    0x10(%ebp),%eax
	if (argc != 1) {
f0100921:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
f0100925:	74 13                	je     f010093a <mon_stepping+0x22>
		cprintf("Incorrect amount of arguments\n");
f0100927:	c7 04 24 30 87 10 f0 	movl   $0xf0108730,(%esp)
f010092e:	e8 a3 39 00 00       	call   f01042d6 <cprintf>
		return 0;
f0100933:	b8 00 00 00 00       	mov    $0x0,%eax
f0100938:	eb 23                	jmp    f010095d <mon_stepping+0x45>
	}

	if (tf == NULL) {
f010093a:	85 c0                	test   %eax,%eax
f010093c:	75 13                	jne    f0100951 <mon_stepping+0x39>
		cprintf("No valid trap frame\n");
f010093e:	c7 04 24 a2 84 10 f0 	movl   $0xf01084a2,(%esp)
f0100945:	e8 8c 39 00 00       	call   f01042d6 <cprintf>
		return 0;
f010094a:	b8 00 00 00 00       	mov    $0x0,%eax
f010094f:	eb 0c                	jmp    f010095d <mon_stepping+0x45>
	}

	tf->tf_eflags = tf->tf_eflags | FL_TF;
f0100951:	81 48 38 00 01 00 00 	orl    $0x100,0x38(%eax)

	return -1;
f0100958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f010095d:	c9                   	leave  
f010095e:	c3                   	ret    

f010095f <mon_continue>:

//Disables single stepping by setting trap flag (bit num 8) of EFLAGS register to 0.
//no arguments
int
mon_continue(int argc, char **argv, struct Trapframe *tf) {
f010095f:	55                   	push   %ebp
f0100960:	89 e5                	mov    %esp,%ebp
f0100962:	83 ec 18             	sub    $0x18,%esp
f0100965:	8b 45 10             	mov    0x10(%ebp),%eax
	if (argc != 1) {
f0100968:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
f010096c:	74 13                	je     f0100981 <mon_continue+0x22>
		cprintf("Incorrect amount of arguments\n");
f010096e:	c7 04 24 30 87 10 f0 	movl   $0xf0108730,(%esp)
f0100975:	e8 5c 39 00 00       	call   f01042d6 <cprintf>
		return 0;
f010097a:	b8 00 00 00 00       	mov    $0x0,%eax
f010097f:	eb 23                	jmp    f01009a4 <mon_continue+0x45>
	}

	if (tf == NULL) {
f0100981:	85 c0                	test   %eax,%eax
f0100983:	75 13                	jne    f0100998 <mon_continue+0x39>
		cprintf("No valid trap frame\n");
f0100985:	c7 04 24 a2 84 10 f0 	movl   $0xf01084a2,(%esp)
f010098c:	e8 45 39 00 00       	call   f01042d6 <cprintf>
		return 0;
f0100991:	b8 00 00 00 00       	mov    $0x0,%eax
f0100996:	eb 0c                	jmp    f01009a4 <mon_continue+0x45>
	}

	tf->tf_eflags = tf->tf_eflags & ~FL_TF;
f0100998:	81 60 38 ff fe ff ff 	andl   $0xfffffeff,0x38(%eax)

	return -1;
f010099f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f01009a4:	c9                   	leave  
f01009a5:	c3                   	ret    

f01009a6 <mon_backtrace>:
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01009a6:	55                   	push   %ebp
f01009a7:	89 e5                	mov    %esp,%ebp
f01009a9:	57                   	push   %edi
f01009aa:	56                   	push   %esi
f01009ab:	53                   	push   %ebx
f01009ac:	83 ec 3c             	sub    $0x3c,%esp
	uint32_t* ebp = (uint32_t*)read_ebp();
f01009af:	89 ee                	mov    %ebp,%esi
	uint32_t eip;
	uint32_t* stack;
	int i;
	struct Eipdebuginfo info;
	cprintf("Stack backtrace:\n");
f01009b1:	c7 04 24 b7 84 10 f0 	movl   $0xf01084b7,(%esp)
f01009b8:	e8 19 39 00 00       	call   f01042d6 <cprintf>

   	while (ebp != 0x0) {
f01009bd:	e9 a2 00 00 00       	jmp    f0100a64 <mon_backtrace+0xbe>
		stack = ebp;
		eip = stack[1];
f01009c2:	8b 7e 04             	mov    0x4(%esi),%edi
		cprintf("ebp %x eip %x args", ebp, eip);
f01009c5:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01009c9:	89 74 24 04          	mov    %esi,0x4(%esp)
f01009cd:	c7 04 24 c9 84 10 f0 	movl   $0xf01084c9,(%esp)
f01009d4:	e8 fd 38 00 00       	call   f01042d6 <cprintf>
		for (i = 2; i < 7; i++) {
f01009d9:	bb 02 00 00 00       	mov    $0x2,%ebx
		   	cprintf(" %08x", stack[i]);
f01009de:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
f01009e1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009e5:	c7 04 24 dc 84 10 f0 	movl   $0xf01084dc,(%esp)
f01009ec:	e8 e5 38 00 00       	call   f01042d6 <cprintf>
			if (i == 6) {
f01009f1:	83 fb 06             	cmp    $0x6,%ebx
f01009f4:	75 0e                	jne    f0100a04 <mon_backtrace+0x5e>
				cprintf("\n");
f01009f6:	c7 04 24 9b 8c 10 f0 	movl   $0xf0108c9b,(%esp)
f01009fd:	e8 d4 38 00 00       	call   f01042d6 <cprintf>
f0100a02:	eb 08                	jmp    f0100a0c <mon_backtrace+0x66>

   	while (ebp != 0x0) {
		stack = ebp;
		eip = stack[1];
		cprintf("ebp %x eip %x args", ebp, eip);
		for (i = 2; i < 7; i++) {
f0100a04:	83 c3 01             	add    $0x1,%ebx
f0100a07:	83 fb 07             	cmp    $0x7,%ebx
f0100a0a:	75 d2                	jne    f01009de <mon_backtrace+0x38>
			if (i == 6) {
				cprintf("\n");
			}
		}

		debuginfo_eip(eip,&info);		
f0100a0c:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a13:	89 3c 24             	mov    %edi,(%esp)
f0100a16:	e8 25 52 00 00       	call   f0105c40 <debuginfo_eip>
		cprintf("\t%s:%d: ", info.eip_file, info.eip_line);
f0100a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100a1e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a22:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100a25:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a29:	c7 04 24 e2 84 10 f0 	movl   $0xf01084e2,(%esp)
f0100a30:	e8 a1 38 00 00       	call   f01042d6 <cprintf>
		cprintf("%.*s", info.eip_fn_namelen, info.eip_fn_name);
f0100a35:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100a38:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100a3f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a43:	c7 04 24 eb 84 10 f0 	movl   $0xf01084eb,(%esp)
f0100a4a:	e8 87 38 00 00       	call   f01042d6 <cprintf>
		cprintf("+%d\n", eip-info.eip_fn_addr);
f0100a4f:	2b 7d e0             	sub    -0x20(%ebp),%edi
f0100a52:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a56:	c7 04 24 f0 84 10 f0 	movl   $0xf01084f0,(%esp)
f0100a5d:	e8 74 38 00 00       	call   f01042d6 <cprintf>
		ebp = (uint32_t*)(*stack);
f0100a62:	8b 36                	mov    (%esi),%esi
	uint32_t* stack;
	int i;
	struct Eipdebuginfo info;
	cprintf("Stack backtrace:\n");

   	while (ebp != 0x0) {
f0100a64:	85 f6                	test   %esi,%esi
f0100a66:	0f 85 56 ff ff ff    	jne    f01009c2 <mon_backtrace+0x1c>
		cprintf("%.*s", info.eip_fn_namelen, info.eip_fn_name);
		cprintf("+%d\n", eip-info.eip_fn_addr);
		ebp = (uint32_t*)(*stack);
    	}
    	return 0;
}
f0100a6c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a71:	83 c4 3c             	add    $0x3c,%esp
f0100a74:	5b                   	pop    %ebx
f0100a75:	5e                   	pop    %esi
f0100a76:	5f                   	pop    %edi
f0100a77:	5d                   	pop    %ebp
f0100a78:	c3                   	ret    

f0100a79 <string_to_number>:

uint32_t string_to_number(char* string) {
f0100a79:	55                   	push   %ebp
f0100a7a:	89 e5                	mov    %esp,%ebp
	uint32_t number = 0;
	string += 2;
f0100a7c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a7f:	8d 48 02             	lea    0x2(%eax),%ecx
    	}
    	return 0;
}

uint32_t string_to_number(char* string) {
	uint32_t number = 0;
f0100a82:	b8 00 00 00 00       	mov    $0x0,%eax
	string += 2;
	while (*string != '\0') {
f0100a87:	eb 1e                	jmp    f0100aa7 <string_to_number+0x2e>
		if (*string >= 'a') {
f0100a89:	80 fa 60             	cmp    $0x60,%dl
f0100a8c:	7e 0c                	jle    f0100a9a <string_to_number+0x21>
			number = number * 16 + *string - 'a' + 10;
f0100a8e:	c1 e0 04             	shl    $0x4,%eax
f0100a91:	0f be d2             	movsbl %dl,%edx
f0100a94:	8d 44 10 a9          	lea    -0x57(%eax,%edx,1),%eax
f0100a98:	eb 0a                	jmp    f0100aa4 <string_to_number+0x2b>
		} else {
			number = number * 16 + *string - '0';
f0100a9a:	c1 e0 04             	shl    $0x4,%eax
f0100a9d:	0f be d2             	movsbl %dl,%edx
f0100aa0:	8d 44 10 d0          	lea    -0x30(%eax,%edx,1),%eax
		}
		string++;
f0100aa4:	83 c1 01             	add    $0x1,%ecx
}

uint32_t string_to_number(char* string) {
	uint32_t number = 0;
	string += 2;
	while (*string != '\0') {
f0100aa7:	0f b6 11             	movzbl (%ecx),%edx
f0100aaa:	84 d2                	test   %dl,%dl
f0100aac:	75 db                	jne    f0100a89 <string_to_number+0x10>
			number = number * 16 + *string - '0';
		}
		string++;
	}
	return number;
}
f0100aae:	5d                   	pop    %ebp
f0100aaf:	c3                   	ret    

f0100ab0 <mon_show_mappings>:


//Display physical page mappings of given virtual memory range
//arg1 = virtual start address, arg2 = virtual end address
int
mon_show_mappings(int argc, char **argv, struct Trapframe *tf) {
f0100ab0:	55                   	push   %ebp
f0100ab1:	89 e5                	mov    %esp,%ebp
f0100ab3:	57                   	push   %edi
f0100ab4:	56                   	push   %esi
f0100ab5:	53                   	push   %ebx
f0100ab6:	83 ec 2c             	sub    $0x2c,%esp
f0100ab9:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (argc != 3) {
f0100abc:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100ac0:	74 11                	je     f0100ad3 <mon_show_mappings+0x23>
		cprintf("Incorrect amount of arguments\n");
f0100ac2:	c7 04 24 30 87 10 f0 	movl   $0xf0108730,(%esp)
f0100ac9:	e8 08 38 00 00       	call   f01042d6 <cprintf>
		return 0;
f0100ace:	e9 d0 00 00 00       	jmp    f0100ba3 <mon_show_mappings+0xf3>
	}

	uint32_t va_start = string_to_number(argv[1]);
f0100ad3:	8b 46 04             	mov    0x4(%esi),%eax
f0100ad6:	89 04 24             	mov    %eax,(%esp)
f0100ad9:	e8 9b ff ff ff       	call   f0100a79 <string_to_number>
f0100ade:	89 c3                	mov    %eax,%ebx
	uint32_t va_end = string_to_number(argv[2]);
f0100ae0:	8b 46 08             	mov    0x8(%esi),%eax
f0100ae3:	89 04 24             	mov    %eax,(%esp)
f0100ae6:	e8 8e ff ff ff       	call   f0100a79 <string_to_number>
f0100aeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

static __inline uint32_t
rcr3(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr3,%0" : "=r" (val));
f0100aee:	0f 20 df             	mov    %cr3,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100af1:	89 f8                	mov    %edi,%eax
f0100af3:	c1 e8 0c             	shr    $0xc,%eax
f0100af6:	3b 05 94 4e 2c f0    	cmp    0xf02c4e94,%eax
f0100afc:	72 20                	jb     f0100b1e <mon_show_mappings+0x6e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100afe:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0100b02:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0100b09:	f0 
f0100b0a:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
f0100b11:	00 
f0100b12:	c7 04 24 f5 84 10 f0 	movl   $0xf01084f5,(%esp)
f0100b19:	e8 22 f5 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0100b1e:	81 ef 00 00 00 10    	sub    $0x10000000,%edi
	uint32_t i = 0;
	pde_t* pgdir = KADDR((physaddr_t)(rcr3()));
	pte_t* pte;

	while (va_start+i <= va_end ) {
f0100b24:	eb 78                	jmp    f0100b9e <mon_show_mappings+0xee>
		pte = pgdir_walk(pgdir, (void*)(va_start+i), false);
f0100b26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100b2d:	00 
f0100b2e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100b32:	89 3c 24             	mov    %edi,(%esp)
f0100b35:	e8 65 0a 00 00       	call   f010159f <pgdir_walk>
f0100b3a:	89 c6                	mov    %eax,%esi
		if (pte == NULL || (!(*pte & PTE_P))) 
f0100b3c:	85 c0                	test   %eax,%eax
f0100b3e:	74 06                	je     f0100b46 <mon_show_mappings+0x96>
f0100b40:	8b 00                	mov    (%eax),%eax
f0100b42:	a8 01                	test   $0x1,%al
f0100b44:	75 12                	jne    f0100b58 <mon_show_mappings+0xa8>
			cprintf("No mapping exists for virtual address %x\n", va_start+i);
f0100b46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100b4a:	c7 04 24 50 87 10 f0 	movl   $0xf0108750,(%esp)
f0100b51:	e8 80 37 00 00       	call   f01042d6 <cprintf>
f0100b56:	eb 19                	jmp    f0100b71 <mon_show_mappings+0xc1>
		else
			cprintf("virtual address: %x   physical page: %x   ", va_start+i, PTE_ADDR(*pte));
f0100b58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b5d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b61:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100b65:	c7 04 24 7c 87 10 f0 	movl   $0xf010877c,(%esp)
f0100b6c:	e8 65 37 00 00       	call   f01042d6 <cprintf>
			cprintf("permissions: PTE_P = %x, PTE_W = %x, PTE_U = %x\n", *pte&PTE_P, *pte&PTE_W, *pte&PTE_U);
f0100b71:	8b 06                	mov    (%esi),%eax
f0100b73:	89 c2                	mov    %eax,%edx
f0100b75:	83 e2 04             	and    $0x4,%edx
f0100b78:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100b7c:	89 c2                	mov    %eax,%edx
f0100b7e:	83 e2 02             	and    $0x2,%edx
f0100b81:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100b85:	83 e0 01             	and    $0x1,%eax
f0100b88:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b8c:	c7 04 24 a8 87 10 f0 	movl   $0xf01087a8,(%esp)
f0100b93:	e8 3e 37 00 00       	call   f01042d6 <cprintf>
f0100b98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	uint32_t va_end = string_to_number(argv[2]);
	uint32_t i = 0;
	pde_t* pgdir = KADDR((physaddr_t)(rcr3()));
	pte_t* pte;

	while (va_start+i <= va_end ) {
f0100b9e:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
f0100ba1:	73 83                	jae    f0100b26 <mon_show_mappings+0x76>
			cprintf("permissions: PTE_P = %x, PTE_W = %x, PTE_U = %x\n", *pte&PTE_P, *pte&PTE_W, *pte&PTE_U);
		i = i + PGSIZE;
	}

	return 0;
}
f0100ba3:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ba8:	83 c4 2c             	add    $0x2c,%esp
f0100bab:	5b                   	pop    %ebx
f0100bac:	5e                   	pop    %esi
f0100bad:	5f                   	pop    %edi
f0100bae:	5d                   	pop    %ebp
f0100baf:	c3                   	ret    

f0100bb0 <mon_set_mem>:

//Set the permissions of given virtual address.
//arg1 = virtual address, arg2 = permission (P,W,U), arg3 = value to set to.
int mon_set_mem(int argc, char **argv, struct Trapframe *tf) {
f0100bb0:	55                   	push   %ebp
f0100bb1:	89 e5                	mov    %esp,%ebp
f0100bb3:	57                   	push   %edi
f0100bb4:	56                   	push   %esi
f0100bb5:	53                   	push   %ebx
f0100bb6:	83 ec 1c             	sub    $0x1c,%esp
	if ((argc != 4) && (argc != 3)) {
f0100bb9:	8b 45 08             	mov    0x8(%ebp),%eax
f0100bbc:	83 e8 03             	sub    $0x3,%eax
f0100bbf:	83 f8 01             	cmp    $0x1,%eax
f0100bc2:	76 11                	jbe    f0100bd5 <mon_set_mem+0x25>
		cprintf("Incorrect amount of arguments\n");
f0100bc4:	c7 04 24 30 87 10 f0 	movl   $0xf0108730,(%esp)
f0100bcb:	e8 06 37 00 00       	call   f01042d6 <cprintf>
		return 0;
f0100bd0:	e9 65 01 00 00       	jmp    f0100d3a <mon_set_mem+0x18a>
	}

	uint32_t addr = string_to_number(argv[1]);
f0100bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100bd8:	8b 40 04             	mov    0x4(%eax),%eax
f0100bdb:	89 04 24             	mov    %eax,(%esp)
f0100bde:	e8 96 fe ff ff       	call   f0100a79 <string_to_number>
f0100be3:	89 c7                	mov    %eax,%edi

	pte_t *pte = pgdir_walk(kern_pgdir, (void *) addr, false);
f0100be5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100bec:	00 
f0100bed:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bf1:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0100bf6:	89 04 24             	mov    %eax,(%esp)
f0100bf9:	e8 a1 09 00 00       	call   f010159f <pgdir_walk>
f0100bfe:	89 c6                	mov    %eax,%esi
	pte_t old_pte_value = *pte;
f0100c00:	8b 18                	mov    (%eax),%ebx
	
	char perm_flag = argv[2][0];
f0100c02:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100c05:	8b 40 08             	mov    0x8(%eax),%eax
f0100c08:	0f b6 00             	movzbl (%eax),%eax
	char perm_bit;
	if(argc == 3){
f0100c0b:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100c0f:	75 55                	jne    f0100c66 <mon_set_mem+0xb6>
		switch (perm_flag) {
f0100c11:	3c 55                	cmp    $0x55,%al
f0100c13:	74 2f                	je     f0100c44 <mon_set_mem+0x94>
f0100c15:	3c 57                	cmp    $0x57,%al
f0100c17:	74 1a                	je     f0100c33 <mon_set_mem+0x83>
f0100c19:	3c 50                	cmp    $0x50,%al
f0100c1b:	90                   	nop
f0100c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100c20:	75 33                	jne    f0100c55 <mon_set_mem+0xa5>
			case 'P':
				if(*pte & PTE_P){
f0100c22:	89 da                	mov    %ebx,%edx
f0100c24:	83 e2 01             	and    $0x1,%edx
					perm_bit = '0';
				} else {
					perm_bit = '1';
f0100c27:	f7 da                	neg    %edx
f0100c29:	83 c2 31             	add    $0x31,%edx
	}
	
	uint32_t perm = 0;
	switch (perm_flag) {
		case 'P':
			perm = PTE_P;
f0100c2c:	b8 01 00 00 00       	mov    $0x1,%eax
f0100c31:	eb 73                	jmp    f0100ca6 <mon_set_mem+0xf6>
					perm_bit = '1';
				}
				break;

			case 'W':
				if(*pte & PTE_W){
f0100c33:	89 d8                	mov    %ebx,%eax
f0100c35:	83 e0 02             	and    $0x2,%eax
					perm_bit = '0';
				} else {
					perm_bit = '1';
f0100c38:	83 f8 01             	cmp    $0x1,%eax
f0100c3b:	19 d2                	sbb    %edx,%edx
f0100c3d:	f7 d2                	not    %edx
f0100c3f:	83 c2 31             	add    $0x31,%edx
f0100c42:	eb 3e                	jmp    f0100c82 <mon_set_mem+0xd2>
				}
				break;

			case 'U':
				if(*pte & PTE_U){
f0100c44:	89 d8                	mov    %ebx,%eax
f0100c46:	83 e0 04             	and    $0x4,%eax
					perm_bit = '0';
				} else {
					perm_bit = '1';
f0100c49:	83 f8 01             	cmp    $0x1,%eax
f0100c4c:	19 d2                	sbb    %edx,%edx
f0100c4e:	f7 d2                	not    %edx
f0100c50:	83 c2 31             	add    $0x31,%edx
f0100c53:	eb 34                	jmp    f0100c89 <mon_set_mem+0xd9>
				}
				break;
				
			default:
				cprintf("Invalid permission type\n");
f0100c55:	c7 04 24 04 85 10 f0 	movl   $0xf0108504,(%esp)
f0100c5c:	e8 75 36 00 00       	call   f01042d6 <cprintf>
				return 0;
f0100c61:	e9 d4 00 00 00       	jmp    f0100d3a <mon_set_mem+0x18a>
		}

	} else {
		perm_bit = argv[3][0];
f0100c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0100c69:	8b 51 0c             	mov    0xc(%ecx),%edx
f0100c6c:	0f b6 12             	movzbl (%edx),%edx
	}
	
	uint32_t perm = 0;
	switch (perm_flag) {
f0100c6f:	3c 55                	cmp    $0x55,%al
f0100c71:	74 16                	je     f0100c89 <mon_set_mem+0xd9>
f0100c73:	3c 57                	cmp    $0x57,%al
f0100c75:	74 0b                	je     f0100c82 <mon_set_mem+0xd2>
f0100c77:	3c 50                	cmp    $0x50,%al
f0100c79:	75 15                	jne    f0100c90 <mon_set_mem+0xe0>
f0100c7b:	90                   	nop
f0100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100c80:	eb 1f                	jmp    f0100ca1 <mon_set_mem+0xf1>
		case 'P':
			perm = PTE_P;
			break;

		case 'W':
			perm = PTE_W;
f0100c82:	b8 02 00 00 00       	mov    $0x2,%eax
			break;
f0100c87:	eb 1d                	jmp    f0100ca6 <mon_set_mem+0xf6>

		case 'U':
			perm = PTE_U;
f0100c89:	b8 04 00 00 00       	mov    $0x4,%eax
			break;
f0100c8e:	eb 16                	jmp    f0100ca6 <mon_set_mem+0xf6>
		default:
			cprintf("Invalid permission type\n");
f0100c90:	c7 04 24 04 85 10 f0 	movl   $0xf0108504,(%esp)
f0100c97:	e8 3a 36 00 00       	call   f01042d6 <cprintf>
			return 0;
f0100c9c:	e9 99 00 00 00       	jmp    f0100d3a <mon_set_mem+0x18a>
	}
	
	uint32_t perm = 0;
	switch (perm_flag) {
		case 'P':
			perm = PTE_P;
f0100ca1:	b8 01 00 00 00       	mov    $0x1,%eax
		default:
			cprintf("Invalid permission type\n");
			return 0;
	}

	switch (perm_bit) {
f0100ca6:	80 fa 30             	cmp    $0x30,%dl
f0100ca9:	74 07                	je     f0100cb2 <mon_set_mem+0x102>
f0100cab:	80 fa 31             	cmp    $0x31,%dl
f0100cae:	74 0a                	je     f0100cba <mon_set_mem+0x10a>
f0100cb0:	eb 0e                	jmp    f0100cc0 <mon_set_mem+0x110>
		case '0':
			*pte = *pte & ~perm;
f0100cb2:	f7 d0                	not    %eax
f0100cb4:	21 d8                	and    %ebx,%eax
f0100cb6:	89 06                	mov    %eax,(%esi)
			break;
f0100cb8:	eb 14                	jmp    f0100cce <mon_set_mem+0x11e>

		case '1':
			*pte = *pte | perm;
f0100cba:	09 d8                	or     %ebx,%eax
f0100cbc:	89 06                	mov    %eax,(%esi)
			break;
f0100cbe:	eb 0e                	jmp    f0100cce <mon_set_mem+0x11e>

		default:
			cprintf("Invalid permission value\n");
f0100cc0:	c7 04 24 1d 85 10 f0 	movl   $0xf010851d,(%esp)
f0100cc7:	e8 0a 36 00 00       	call   f01042d6 <cprintf>
			return 0;
f0100ccc:	eb 6c                	jmp    f0100d3a <mon_set_mem+0x18a>
	}

	cprintf("%x before setting memory: ", addr);
f0100cce:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100cd2:	c7 04 24 37 85 10 f0 	movl   $0xf0108537,(%esp)
f0100cd9:	e8 f8 35 00 00       	call   f01042d6 <cprintf>
	cprintf("PTE_P: %x, PTE_W: %x, PTE_U: %x\n", old_pte_value & PTE_P, old_pte_value & PTE_W, old_pte_value & PTE_U);
f0100cde:	89 d8                	mov    %ebx,%eax
f0100ce0:	83 e0 04             	and    $0x4,%eax
f0100ce3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100ce7:	89 d8                	mov    %ebx,%eax
f0100ce9:	83 e0 02             	and    $0x2,%eax
f0100cec:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100cf0:	83 e3 01             	and    $0x1,%ebx
f0100cf3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100cf7:	c7 04 24 dc 87 10 f0 	movl   $0xf01087dc,(%esp)
f0100cfe:	e8 d3 35 00 00       	call   f01042d6 <cprintf>
	cprintf("%x after  setting memory: ", addr);
f0100d03:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100d07:	c7 04 24 52 85 10 f0 	movl   $0xf0108552,(%esp)
f0100d0e:	e8 c3 35 00 00       	call   f01042d6 <cprintf>
	cprintf("PTE_P: %x, PTE_W: %x, PTE_U: %x\n", *pte & PTE_P, *pte & PTE_W, *pte & PTE_U);
f0100d13:	8b 06                	mov    (%esi),%eax
f0100d15:	89 c2                	mov    %eax,%edx
f0100d17:	83 e2 04             	and    $0x4,%edx
f0100d1a:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100d1e:	89 c2                	mov    %eax,%edx
f0100d20:	83 e2 02             	and    $0x2,%edx
f0100d23:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100d27:	83 e0 01             	and    $0x1,%eax
f0100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d2e:	c7 04 24 dc 87 10 f0 	movl   $0xf01087dc,(%esp)
f0100d35:	e8 9c 35 00 00       	call   f01042d6 <cprintf>
	return 0;
}
f0100d3a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d3f:	83 c4 1c             	add    $0x1c,%esp
f0100d42:	5b                   	pop    %ebx
f0100d43:	5e                   	pop    %esi
f0100d44:	5f                   	pop    %edi
f0100d45:	5d                   	pop    %ebp
f0100d46:	c3                   	ret    

f0100d47 <mon_mem_dump>:


//Display the memory content of given address range.
//arg1 = start address, arg2 = end address
int
mon_mem_dump(int argc, char **argv, struct Trapframe *tf) {
f0100d47:	55                   	push   %ebp
f0100d48:	89 e5                	mov    %esp,%ebp
f0100d4a:	56                   	push   %esi
f0100d4b:	53                   	push   %ebx
f0100d4c:	83 ec 10             	sub    $0x10,%esp
f0100d4f:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (argc != 3) {
f0100d52:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100d56:	74 0e                	je     f0100d66 <mon_mem_dump+0x1f>
		cprintf("Incorrect amount of arguments\n");
f0100d58:	c7 04 24 30 87 10 f0 	movl   $0xf0108730,(%esp)
f0100d5f:	e8 72 35 00 00       	call   f01042d6 <cprintf>
		return 0;
f0100d64:	eb 6c                	jmp    f0100dd2 <mon_mem_dump+0x8b>
	}

	uint32_t address_start = string_to_number(argv[1]);
f0100d66:	8b 46 04             	mov    0x4(%esi),%eax
f0100d69:	89 04 24             	mov    %eax,(%esp)
f0100d6c:	e8 08 fd ff ff       	call   f0100a79 <string_to_number>
f0100d71:	89 c3                	mov    %eax,%ebx
	uint32_t address_end = string_to_number(argv[2]);
f0100d73:	8b 46 08             	mov    0x8(%esi),%eax
f0100d76:	89 04 24             	mov    %eax,(%esp)
f0100d79:	e8 fb fc ff ff       	call   f0100a79 <string_to_number>
	void** va_start = (void**) (address_start);
	void** va_end = (void**) (address_end);
f0100d7e:	89 c6                	mov    %eax,%esi
	uint32_t i = 0;

	if (PGNUM(address_start) < npages)
f0100d80:	8b 15 94 4e 2c f0    	mov    0xf02c4e94,%edx
f0100d86:	89 d9                	mov    %ebx,%ecx
f0100d88:	c1 e9 0c             	shr    $0xc,%ecx
f0100d8b:	39 d1                	cmp    %edx,%ecx
f0100d8d:	73 36                	jae    f0100dc5 <mon_mem_dump+0x7e>
f0100d8f:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
		va_start =(void**) KADDR(address_start);

	if (PGNUM(address_end) < npages)
f0100d95:	89 c1                	mov    %eax,%ecx
f0100d97:	c1 e9 0c             	shr    $0xc,%ecx
f0100d9a:	39 ca                	cmp    %ecx,%edx
f0100d9c:	76 21                	jbe    f0100dbf <mon_mem_dump+0x78>
f0100d9e:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi
f0100da4:	eb 19                	jmp    f0100dbf <mon_mem_dump+0x78>
		va_end =(void**) KADDR(address_end);

	while (va_start+i <= va_end ) {
		cprintf("Memory content at virtual address %x is %x\n",va_start+i,va_start[i]);
f0100da6:	8b 03                	mov    (%ebx),%eax
f0100da8:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100db0:	c7 04 24 00 88 10 f0 	movl   $0xf0108800,(%esp)
f0100db7:	e8 1a 35 00 00       	call   f01042d6 <cprintf>
f0100dbc:	83 c3 04             	add    $0x4,%ebx
		va_start =(void**) KADDR(address_start);

	if (PGNUM(address_end) < npages)
		va_end =(void**) KADDR(address_end);

	while (va_start+i <= va_end ) {
f0100dbf:	39 de                	cmp    %ebx,%esi
f0100dc1:	73 e3                	jae    f0100da6 <mon_mem_dump+0x5f>
f0100dc3:	eb 0d                	jmp    f0100dd2 <mon_mem_dump+0x8b>
	uint32_t i = 0;

	if (PGNUM(address_start) < npages)
		va_start =(void**) KADDR(address_start);

	if (PGNUM(address_end) < npages)
f0100dc5:	89 c1                	mov    %eax,%ecx
f0100dc7:	c1 e9 0c             	shr    $0xc,%ecx
f0100dca:	39 ca                	cmp    %ecx,%edx
f0100dcc:	77 d0                	ja     f0100d9e <mon_mem_dump+0x57>
f0100dce:	66 90                	xchg   %ax,%ax
f0100dd0:	eb ed                	jmp    f0100dbf <mon_mem_dump+0x78>
		cprintf("Memory content at virtual address %x is %x\n",va_start+i,va_start[i]);
		i++;
	}

	return 0;
}
f0100dd2:	b8 00 00 00 00       	mov    $0x0,%eax
f0100dd7:	83 c4 10             	add    $0x10,%esp
f0100dda:	5b                   	pop    %ebx
f0100ddb:	5e                   	pop    %esi
f0100ddc:	5d                   	pop    %ebp
f0100ddd:	c3                   	ret    

f0100dde <monitor>:
}


void
monitor(struct Trapframe *tf)
{
f0100dde:	55                   	push   %ebp
f0100ddf:	89 e5                	mov    %esp,%ebp
f0100de1:	57                   	push   %edi
f0100de2:	56                   	push   %esi
f0100de3:	53                   	push   %ebx
f0100de4:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100de7:	c7 04 24 2c 88 10 f0 	movl   $0xf010882c,(%esp)
f0100dee:	e8 e3 34 00 00       	call   f01042d6 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100df3:	c7 04 24 50 88 10 f0 	movl   $0xf0108850,(%esp)
f0100dfa:	e8 d7 34 00 00       	call   f01042d6 <cprintf>

	if (tf != NULL)
f0100dff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100e03:	74 0b                	je     f0100e10 <monitor+0x32>
		print_trapframe(tf);
f0100e05:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e08:	89 04 24             	mov    %eax,(%esp)
f0100e0b:	e8 c1 3b 00 00       	call   f01049d1 <print_trapframe>

	while (1) {
		buf = readline("K> ");
f0100e10:	c7 04 24 6d 85 10 f0 	movl   $0xf010856d,(%esp)
f0100e17:	e8 3e 58 00 00       	call   f010665a <readline>
f0100e1c:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100e1e:	85 c0                	test   %eax,%eax
f0100e20:	74 ee                	je     f0100e10 <monitor+0x32>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100e22:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100e29:	be 00 00 00 00       	mov    $0x0,%esi
f0100e2e:	eb 0a                	jmp    f0100e3a <monitor+0x5c>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100e30:	c6 03 00             	movb   $0x0,(%ebx)
f0100e33:	89 f7                	mov    %esi,%edi
f0100e35:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100e38:	89 fe                	mov    %edi,%esi
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100e3a:	0f b6 03             	movzbl (%ebx),%eax
f0100e3d:	84 c0                	test   %al,%al
f0100e3f:	74 63                	je     f0100ea4 <monitor+0xc6>
f0100e41:	0f be c0             	movsbl %al,%eax
f0100e44:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e48:	c7 04 24 71 85 10 f0 	movl   $0xf0108571,(%esp)
f0100e4f:	e8 46 5a 00 00       	call   f010689a <strchr>
f0100e54:	85 c0                	test   %eax,%eax
f0100e56:	75 d8                	jne    f0100e30 <monitor+0x52>
			*buf++ = 0;
		if (*buf == 0)
f0100e58:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100e5b:	74 47                	je     f0100ea4 <monitor+0xc6>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100e5d:	83 fe 0f             	cmp    $0xf,%esi
f0100e60:	75 16                	jne    f0100e78 <monitor+0x9a>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100e62:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100e69:	00 
f0100e6a:	c7 04 24 76 85 10 f0 	movl   $0xf0108576,(%esp)
f0100e71:	e8 60 34 00 00       	call   f01042d6 <cprintf>
f0100e76:	eb 98                	jmp    f0100e10 <monitor+0x32>
			return 0;
		}
		argv[argc++] = buf;
f0100e78:	8d 7e 01             	lea    0x1(%esi),%edi
f0100e7b:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100e7f:	eb 03                	jmp    f0100e84 <monitor+0xa6>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
f0100e81:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100e84:	0f b6 03             	movzbl (%ebx),%eax
f0100e87:	84 c0                	test   %al,%al
f0100e89:	74 ad                	je     f0100e38 <monitor+0x5a>
f0100e8b:	0f be c0             	movsbl %al,%eax
f0100e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e92:	c7 04 24 71 85 10 f0 	movl   $0xf0108571,(%esp)
f0100e99:	e8 fc 59 00 00       	call   f010689a <strchr>
f0100e9e:	85 c0                	test   %eax,%eax
f0100ea0:	74 df                	je     f0100e81 <monitor+0xa3>
f0100ea2:	eb 94                	jmp    f0100e38 <monitor+0x5a>
			buf++;
	}
	argv[argc] = 0;
f0100ea4:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100eab:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100eac:	85 f6                	test   %esi,%esi
f0100eae:	0f 84 5c ff ff ff    	je     f0100e10 <monitor+0x32>
f0100eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100eb9:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100ebc:	8b 04 85 40 89 10 f0 	mov    -0xfef76c0(,%eax,4),%eax
f0100ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ec7:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100eca:	89 04 24             	mov    %eax,(%esp)
f0100ecd:	e8 6a 59 00 00       	call   f010683c <strcmp>
f0100ed2:	85 c0                	test   %eax,%eax
f0100ed4:	75 24                	jne    f0100efa <monitor+0x11c>
			return commands[i].func(argc, argv, tf);
f0100ed6:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100ed9:	8b 55 08             	mov    0x8(%ebp),%edx
f0100edc:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100ee0:	8d 4d a8             	lea    -0x58(%ebp),%ecx
f0100ee3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100ee7:	89 34 24             	mov    %esi,(%esp)
f0100eea:	ff 14 85 48 89 10 f0 	call   *-0xfef76b8(,%eax,4)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100ef1:	85 c0                	test   %eax,%eax
f0100ef3:	78 25                	js     f0100f1a <monitor+0x13c>
f0100ef5:	e9 16 ff ff ff       	jmp    f0100e10 <monitor+0x32>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0100efa:	83 c3 01             	add    $0x1,%ebx
f0100efd:	83 fb 08             	cmp    $0x8,%ebx
f0100f00:	75 b7                	jne    f0100eb9 <monitor+0xdb>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100f02:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100f05:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100f09:	c7 04 24 93 85 10 f0 	movl   $0xf0108593,(%esp)
f0100f10:	e8 c1 33 00 00       	call   f01042d6 <cprintf>
f0100f15:	e9 f6 fe ff ff       	jmp    f0100e10 <monitor+0x32>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100f1a:	83 c4 5c             	add    $0x5c,%esp
f0100f1d:	5b                   	pop    %ebx
f0100f1e:	5e                   	pop    %esi
f0100f1f:	5f                   	pop    %edi
f0100f20:	5d                   	pop    %ebp
f0100f21:	c3                   	ret    
f0100f22:	66 90                	xchg   %ax,%ax
f0100f24:	66 90                	xchg   %ax,%ax
f0100f26:	66 90                	xchg   %ax,%ax
f0100f28:	66 90                	xchg   %ax,%ax
f0100f2a:	66 90                	xchg   %ax,%ax
f0100f2c:	66 90                	xchg   %ax,%ax
f0100f2e:	66 90                	xchg   %ax,%ax

f0100f30 <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100f30:	83 3d 3c 42 2c f0 00 	cmpl   $0x0,0xf02c423c
f0100f37:	75 11                	jne    f0100f4a <boot_alloc+0x1a>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100f39:	ba bf f7 35 f0       	mov    $0xf035f7bf,%edx
f0100f3e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100f44:	89 15 3c 42 2c f0    	mov    %edx,0xf02c423c
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.

	if (n == 0) {
f0100f4a:	85 c0                	test   %eax,%eax
f0100f4c:	75 06                	jne    f0100f54 <boot_alloc+0x24>
		return nextfree;
f0100f4e:	a1 3c 42 2c f0       	mov    0xf02c423c,%eax
f0100f53:	c3                   	ret    
	}
	
	page_num = n/PGSIZE;
f0100f54:	89 c2                	mov    %eax,%edx
f0100f56:	c1 ea 0c             	shr    $0xc,%edx
	page_remainder = n%PGSIZE;
	if (page_remainder != 0) {
f0100f59:	89 c1                	mov    %eax,%ecx
f0100f5b:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		page_num++;
f0100f61:	83 f9 01             	cmp    $0x1,%ecx
f0100f64:	83 da ff             	sbb    $0xffffffff,%edx
	}

	if ((page_num + boot_alloc_allocated) > npages) {
f0100f67:	03 15 38 42 2c f0    	add    0xf02c4238,%edx
f0100f6d:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f0100f73:	76 22                	jbe    f0100f97 <boot_alloc+0x67>
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100f75:	55                   	push   %ebp
f0100f76:	89 e5                	mov    %esp,%ebp
f0100f78:	83 ec 18             	sub    $0x18,%esp
	if (page_remainder != 0) {
		page_num++;
	}

	if ((page_num + boot_alloc_allocated) > npages) {
		panic("boot_alloc: Out of memory\n");
f0100f7b:	c7 44 24 08 a0 89 10 	movl   $0xf01089a0,0x8(%esp)
f0100f82:	f0 
f0100f83:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
f0100f8a:	00 
f0100f8b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0100f92:	e8 a9 f0 ff ff       	call   f0100040 <_panic>
	}

	result = nextfree;
f0100f97:	8b 0d 3c 42 2c f0    	mov    0xf02c423c,%ecx
	boot_alloc_allocated += page_num;
f0100f9d:	89 15 38 42 2c f0    	mov    %edx,0xf02c4238
	nextfree = ROUNDUP((char *) (nextfree+n), PGSIZE);
f0100fa3:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
f0100faa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100faf:	a3 3c 42 2c f0       	mov    %eax,0xf02c423c

	return result;
f0100fb4:	89 c8                	mov    %ecx,%eax
}
f0100fb6:	c3                   	ret    

f0100fb7 <page2kva>:
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100fb7:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f0100fbd:	c1 f8 03             	sar    $0x3,%eax
f0100fc0:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100fc3:	89 c2                	mov    %eax,%edx
f0100fc5:	c1 ea 0c             	shr    $0xc,%edx
f0100fc8:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f0100fce:	72 26                	jb     f0100ff6 <page2kva+0x3f>
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0100fd0:	55                   	push   %ebp
f0100fd1:	89 e5                	mov    %esp,%ebp
f0100fd3:	83 ec 18             	sub    $0x18,%esp

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100fd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100fda:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0100fe1:	f0 
f0100fe2:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0100fe9:	00 
f0100fea:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0100ff1:	e8 4a f0 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0100ff6:	2d 00 00 00 10       	sub    $0x10000000,%eax

static inline void*
page2kva(struct PageInfo *pp)
{
	return KADDR(page2pa(pp));
}
f0100ffb:	c3                   	ret    

f0100ffc <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100ffc:	89 d1                	mov    %edx,%ecx
f0100ffe:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0101001:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0101004:	a8 01                	test   $0x1,%al
f0101006:	74 5d                	je     f0101065 <check_va2pa+0x69>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0101008:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010100d:	89 c1                	mov    %eax,%ecx
f010100f:	c1 e9 0c             	shr    $0xc,%ecx
f0101012:	3b 0d 94 4e 2c f0    	cmp    0xf02c4e94,%ecx
f0101018:	72 26                	jb     f0101040 <check_va2pa+0x44>
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f010101a:	55                   	push   %ebp
f010101b:	89 e5                	mov    %esp,%ebp
f010101d:	83 ec 18             	sub    $0x18,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101020:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101024:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f010102b:	f0 
f010102c:	c7 44 24 04 88 03 00 	movl   $0x388,0x4(%esp)
f0101033:	00 
f0101034:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010103b:	e8 00 f0 ff ff       	call   f0100040 <_panic>

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
f0101040:	c1 ea 0c             	shr    $0xc,%edx
f0101043:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0101049:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0101050:	89 c2                	mov    %eax,%edx
f0101052:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0101055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010105a:	85 d2                	test   %edx,%edx
f010105c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0101061:	0f 44 c2             	cmove  %edx,%eax
f0101064:	c3                   	ret    
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0101065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f010106a:	c3                   	ret    

f010106b <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f010106b:	55                   	push   %ebp
f010106c:	89 e5                	mov    %esp,%ebp
f010106e:	57                   	push   %edi
f010106f:	56                   	push   %esi
f0101070:	53                   	push   %ebx
f0101071:	83 ec 4c             	sub    $0x4c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101074:	84 c0                	test   %al,%al
f0101076:	0f 85 31 03 00 00    	jne    f01013ad <check_page_free_list+0x342>
f010107c:	e9 3e 03 00 00       	jmp    f01013bf <check_page_free_list+0x354>
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
		panic("'page_free_list' is a null pointer!");
f0101081:	c7 44 24 08 d0 8c 10 	movl   $0xf0108cd0,0x8(%esp)
f0101088:	f0 
f0101089:	c7 44 24 04 bd 02 00 	movl   $0x2bd,0x4(%esp)
f0101090:	00 
f0101091:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101098:	e8 a3 ef ff ff       	call   f0100040 <_panic>

	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010109d:	8d 55 d8             	lea    -0x28(%ebp),%edx
f01010a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01010a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01010a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01010a9:	89 c2                	mov    %eax,%edx
f01010ab:	2b 15 9c 4e 2c f0    	sub    0xf02c4e9c,%edx
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f01010b1:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f01010b7:	0f 95 c2             	setne  %dl
f01010ba:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f01010bd:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f01010c1:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f01010c3:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f01010c7:	8b 00                	mov    (%eax),%eax
f01010c9:	85 c0                	test   %eax,%eax
f01010cb:	75 dc                	jne    f01010a9 <check_page_free_list+0x3e>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f01010cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01010d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f01010d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01010d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01010dc:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f01010de:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01010e1:	a3 44 42 2c f0       	mov    %eax,0xf02c4244
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01010e6:	be 01 00 00 00       	mov    $0x1,%esi
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01010eb:	8b 1d 44 42 2c f0    	mov    0xf02c4244,%ebx
f01010f1:	eb 63                	jmp    f0101156 <check_page_free_list+0xeb>
f01010f3:	89 d8                	mov    %ebx,%eax
f01010f5:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f01010fb:	c1 f8 03             	sar    $0x3,%eax
f01010fe:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0101101:	89 c2                	mov    %eax,%edx
f0101103:	c1 ea 16             	shr    $0x16,%edx
f0101106:	39 f2                	cmp    %esi,%edx
f0101108:	73 4a                	jae    f0101154 <check_page_free_list+0xe9>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010110a:	89 c2                	mov    %eax,%edx
f010110c:	c1 ea 0c             	shr    $0xc,%edx
f010110f:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f0101115:	72 20                	jb     f0101137 <check_page_free_list+0xcc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101117:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010111b:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0101122:	f0 
f0101123:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f010112a:	00 
f010112b:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0101132:	e8 09 ef ff ff       	call   f0100040 <_panic>
			memset(page2kva(pp), 0x97, 128);
f0101137:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f010113e:	00 
f010113f:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0101146:	00 
	return (void *)(pa + KERNBASE);
f0101147:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010114c:	89 04 24             	mov    %eax,(%esp)
f010114f:	e8 83 57 00 00       	call   f01068d7 <memset>
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101154:	8b 1b                	mov    (%ebx),%ebx
f0101156:	85 db                	test   %ebx,%ebx
f0101158:	75 99                	jne    f01010f3 <check_page_free_list+0x88>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f010115a:	b8 00 00 00 00       	mov    $0x0,%eax
f010115f:	e8 cc fd ff ff       	call   f0100f30 <boot_alloc>
f0101164:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101167:	8b 15 44 42 2c f0    	mov    0xf02c4244,%edx
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f010116d:	8b 0d 9c 4e 2c f0    	mov    0xf02c4e9c,%ecx
		assert(pp < pages + npages);
f0101173:	a1 94 4e 2c f0       	mov    0xf02c4e94,%eax
f0101178:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f010117b:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f010117e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101181:	89 4d cc             	mov    %ecx,-0x34(%ebp)
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f0101184:	bf 00 00 00 00       	mov    $0x0,%edi
f0101189:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f010118c:	e9 c4 01 00 00       	jmp    f0101355 <check_page_free_list+0x2ea>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0101191:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0101194:	73 24                	jae    f01011ba <check_page_free_list+0x14f>
f0101196:	c7 44 24 0c d5 89 10 	movl   $0xf01089d5,0xc(%esp)
f010119d:	f0 
f010119e:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01011a5:	f0 
f01011a6:	c7 44 24 04 d7 02 00 	movl   $0x2d7,0x4(%esp)
f01011ad:	00 
f01011ae:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01011b5:	e8 86 ee ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f01011ba:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f01011bd:	72 24                	jb     f01011e3 <check_page_free_list+0x178>
f01011bf:	c7 44 24 0c f6 89 10 	movl   $0xf01089f6,0xc(%esp)
f01011c6:	f0 
f01011c7:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01011ce:	f0 
f01011cf:	c7 44 24 04 d8 02 00 	movl   $0x2d8,0x4(%esp)
f01011d6:	00 
f01011d7:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01011de:	e8 5d ee ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01011e3:	89 d0                	mov    %edx,%eax
f01011e5:	2b 45 cc             	sub    -0x34(%ebp),%eax
f01011e8:	a8 07                	test   $0x7,%al
f01011ea:	74 24                	je     f0101210 <check_page_free_list+0x1a5>
f01011ec:	c7 44 24 0c f4 8c 10 	movl   $0xf0108cf4,0xc(%esp)
f01011f3:	f0 
f01011f4:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01011fb:	f0 
f01011fc:	c7 44 24 04 d9 02 00 	movl   $0x2d9,0x4(%esp)
f0101203:	00 
f0101204:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010120b:	e8 30 ee ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101210:	c1 f8 03             	sar    $0x3,%eax
f0101213:	c1 e0 0c             	shl    $0xc,%eax
		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0101216:	85 c0                	test   %eax,%eax
f0101218:	75 24                	jne    f010123e <check_page_free_list+0x1d3>
f010121a:	c7 44 24 0c 0a 8a 10 	movl   $0xf0108a0a,0xc(%esp)
f0101221:	f0 
f0101222:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101229:	f0 
f010122a:	c7 44 24 04 db 02 00 	movl   $0x2db,0x4(%esp)
f0101231:	00 
f0101232:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101239:	e8 02 ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f010123e:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101243:	75 24                	jne    f0101269 <check_page_free_list+0x1fe>
f0101245:	c7 44 24 0c 1b 8a 10 	movl   $0xf0108a1b,0xc(%esp)
f010124c:	f0 
f010124d:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101254:	f0 
f0101255:	c7 44 24 04 dc 02 00 	movl   $0x2dc,0x4(%esp)
f010125c:	00 
f010125d:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101264:	e8 d7 ed ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101269:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f010126e:	75 24                	jne    f0101294 <check_page_free_list+0x229>
f0101270:	c7 44 24 0c 28 8d 10 	movl   $0xf0108d28,0xc(%esp)
f0101277:	f0 
f0101278:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010127f:	f0 
f0101280:	c7 44 24 04 dd 02 00 	movl   $0x2dd,0x4(%esp)
f0101287:	00 
f0101288:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010128f:	e8 ac ed ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101294:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0101299:	75 24                	jne    f01012bf <check_page_free_list+0x254>
f010129b:	c7 44 24 0c 34 8a 10 	movl   $0xf0108a34,0xc(%esp)
f01012a2:	f0 
f01012a3:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01012aa:	f0 
f01012ab:	c7 44 24 04 de 02 00 	movl   $0x2de,0x4(%esp)
f01012b2:	00 
f01012b3:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01012ba:	e8 81 ed ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01012bf:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f01012c4:	0f 86 1c 01 00 00    	jbe    f01013e6 <check_page_free_list+0x37b>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01012ca:	89 c1                	mov    %eax,%ecx
f01012cc:	c1 e9 0c             	shr    $0xc,%ecx
f01012cf:	39 4d c4             	cmp    %ecx,-0x3c(%ebp)
f01012d2:	77 20                	ja     f01012f4 <check_page_free_list+0x289>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01012d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01012d8:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f01012df:	f0 
f01012e0:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01012e7:	00 
f01012e8:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f01012ef:	e8 4c ed ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f01012f4:	8d 88 00 00 00 f0    	lea    -0x10000000(%eax),%ecx
f01012fa:	39 4d c8             	cmp    %ecx,-0x38(%ebp)
f01012fd:	0f 86 d3 00 00 00    	jbe    f01013d6 <check_page_free_list+0x36b>
f0101303:	c7 44 24 0c 4c 8d 10 	movl   $0xf0108d4c,0xc(%esp)
f010130a:	f0 
f010130b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101312:	f0 
f0101313:	c7 44 24 04 df 02 00 	movl   $0x2df,0x4(%esp)
f010131a:	00 
f010131b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101322:	e8 19 ed ff ff       	call   f0100040 <_panic>
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0101327:	c7 44 24 0c 4e 8a 10 	movl   $0xf0108a4e,0xc(%esp)
f010132e:	f0 
f010132f:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101336:	f0 
f0101337:	c7 44 24 04 e1 02 00 	movl   $0x2e1,0x4(%esp)
f010133e:	00 
f010133f:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101346:	e8 f5 ec ff ff       	call   f0100040 <_panic>

		if (page2pa(pp) < EXTPHYSMEM)
			++nfree_basemem;
f010134b:	83 c3 01             	add    $0x1,%ebx
f010134e:	eb 03                	jmp    f0101353 <check_page_free_list+0x2e8>
		else
			++nfree_extmem;
f0101350:	83 c7 01             	add    $0x1,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101353:	8b 12                	mov    (%edx),%edx
f0101355:	85 d2                	test   %edx,%edx
f0101357:	0f 85 34 fe ff ff    	jne    f0101191 <check_page_free_list+0x126>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f010135d:	85 db                	test   %ebx,%ebx
f010135f:	7f 24                	jg     f0101385 <check_page_free_list+0x31a>
f0101361:	c7 44 24 0c 6b 8a 10 	movl   $0xf0108a6b,0xc(%esp)
f0101368:	f0 
f0101369:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101370:	f0 
f0101371:	c7 44 24 04 e9 02 00 	movl   $0x2e9,0x4(%esp)
f0101378:	00 
f0101379:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101380:	e8 bb ec ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0101385:	85 ff                	test   %edi,%edi
f0101387:	7f 6d                	jg     f01013f6 <check_page_free_list+0x38b>
f0101389:	c7 44 24 0c 7d 8a 10 	movl   $0xf0108a7d,0xc(%esp)
f0101390:	f0 
f0101391:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101398:	f0 
f0101399:	c7 44 24 04 ea 02 00 	movl   $0x2ea,0x4(%esp)
f01013a0:	00 
f01013a1:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01013a8:	e8 93 ec ff ff       	call   f0100040 <_panic>
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f01013ad:	a1 44 42 2c f0       	mov    0xf02c4244,%eax
f01013b2:	85 c0                	test   %eax,%eax
f01013b4:	0f 85 e3 fc ff ff    	jne    f010109d <check_page_free_list+0x32>
f01013ba:	e9 c2 fc ff ff       	jmp    f0101081 <check_page_free_list+0x16>
f01013bf:	83 3d 44 42 2c f0 00 	cmpl   $0x0,0xf02c4244
f01013c6:	0f 84 b5 fc ff ff    	je     f0101081 <check_page_free_list+0x16>
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01013cc:	be 00 04 00 00       	mov    $0x400,%esi
f01013d1:	e9 15 fd ff ff       	jmp    f01010eb <check_page_free_list+0x80>
		assert(page2pa(pp) != IOPHYSMEM);
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
		assert(page2pa(pp) != EXTPHYSMEM);
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f01013d6:	3d 00 70 00 00       	cmp    $0x7000,%eax
f01013db:	0f 85 6f ff ff ff    	jne    f0101350 <check_page_free_list+0x2e5>
f01013e1:	e9 41 ff ff ff       	jmp    f0101327 <check_page_free_list+0x2bc>
f01013e6:	3d 00 70 00 00       	cmp    $0x7000,%eax
f01013eb:	0f 85 5a ff ff ff    	jne    f010134b <check_page_free_list+0x2e0>
f01013f1:	e9 31 ff ff ff       	jmp    f0101327 <check_page_free_list+0x2bc>
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
	assert(nfree_extmem > 0);
}
f01013f6:	83 c4 4c             	add    $0x4c,%esp
f01013f9:	5b                   	pop    %ebx
f01013fa:	5e                   	pop    %esi
f01013fb:	5f                   	pop    %edi
f01013fc:	5d                   	pop    %ebp
f01013fd:	c3                   	ret    

f01013fe <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f01013fe:	55                   	push   %ebp
f01013ff:	89 e5                	mov    %esp,%ebp
f0101401:	56                   	push   %esi
f0101402:	53                   	push   %ebx
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!

	size_t i;
	for (i = 1; i < npages_basemem; i++) {
f0101403:	8b 35 48 42 2c f0    	mov    0xf02c4248,%esi
f0101409:	8b 1d 44 42 2c f0    	mov    0xf02c4244,%ebx
f010140f:	b8 01 00 00 00       	mov    $0x1,%eax
f0101414:	eb 27                	jmp    f010143d <page_init+0x3f>
		if (MPENTRY_PADDR/PGSIZE == i)
f0101416:	83 f8 07             	cmp    $0x7,%eax
f0101419:	74 1f                	je     f010143a <page_init+0x3c>
f010141b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
			continue;
		pages[i].pp_ref = 0;
f0101422:	89 d1                	mov    %edx,%ecx
f0101424:	03 0d 9c 4e 2c f0    	add    0xf02c4e9c,%ecx
f010142a:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0101430:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0101432:	03 15 9c 4e 2c f0    	add    0xf02c4e9c,%edx
f0101438:	89 d3                	mov    %edx,%ebx
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!

	size_t i;
	for (i = 1; i < npages_basemem; i++) {
f010143a:	83 c0 01             	add    $0x1,%eax
f010143d:	39 f0                	cmp    %esi,%eax
f010143f:	72 d5                	jb     f0101416 <page_init+0x18>
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
	
	int cont = (int)ROUNDUP((sizeof(struct Env)*NENV) + ((char*)envs) - 0xf0000000, PGSIZE)/PGSIZE;
f0101441:	a1 4c 42 2c f0       	mov    0xf02c424c,%eax
f0101446:	05 ff 1f 02 10       	add    $0x10021fff,%eax
f010144b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101450:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0101456:	85 c0                	test   %eax,%eax
f0101458:	0f 48 c2             	cmovs  %edx,%eax
f010145b:	c1 f8 0c             	sar    $0xc,%eax

	for (i = cont; i < npages; i++) {
f010145e:	89 c2                	mov    %eax,%edx
f0101460:	c1 e0 03             	shl    $0x3,%eax
f0101463:	eb 1e                	jmp    f0101483 <page_init+0x85>
		pages[i].pp_ref = 0;
f0101465:	89 c1                	mov    %eax,%ecx
f0101467:	03 0d 9c 4e 2c f0    	add    0xf02c4e9c,%ecx
f010146d:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0101473:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0101475:	89 c3                	mov    %eax,%ebx
f0101477:	03 1d 9c 4e 2c f0    	add    0xf02c4e9c,%ebx
		page_free_list = &pages[i];
	}
	
	int cont = (int)ROUNDUP((sizeof(struct Env)*NENV) + ((char*)envs) - 0xf0000000, PGSIZE)/PGSIZE;

	for (i = cont; i < npages; i++) {
f010147d:	83 c2 01             	add    $0x1,%edx
f0101480:	83 c0 08             	add    $0x8,%eax
f0101483:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f0101489:	72 da                	jb     f0101465 <page_init+0x67>
f010148b:	89 1d 44 42 2c f0    	mov    %ebx,0xf02c4244
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
}
f0101491:	5b                   	pop    %ebx
f0101492:	5e                   	pop    %esi
f0101493:	5d                   	pop    %ebp
f0101494:	c3                   	ret    

f0101495 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f0101495:	55                   	push   %ebp
f0101496:	89 e5                	mov    %esp,%ebp
f0101498:	53                   	push   %ebx
f0101499:	83 ec 14             	sub    $0x14,%esp
    if (page_free_list) {
f010149c:	8b 1d 44 42 2c f0    	mov    0xf02c4244,%ebx
f01014a2:	85 db                	test   %ebx,%ebx
f01014a4:	74 6f                	je     f0101515 <page_alloc+0x80>
        struct PageInfo *ret = page_free_list;
        page_free_list = page_free_list->pp_link;
f01014a6:	8b 03                	mov    (%ebx),%eax
f01014a8:	a3 44 42 2c f0       	mov    %eax,0xf02c4244
	ret->pp_link = NULL;
f01014ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if (alloc_flags & ALLOC_ZERO)
            memset(page2kva(ret), 0, PGSIZE);        
	return ret;
f01014b3:	89 d8                	mov    %ebx,%eax
{
    if (page_free_list) {
        struct PageInfo *ret = page_free_list;
        page_free_list = page_free_list->pp_link;
	ret->pp_link = NULL;
        if (alloc_flags & ALLOC_ZERO)
f01014b5:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01014b9:	74 5f                	je     f010151a <page_alloc+0x85>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01014bb:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f01014c1:	c1 f8 03             	sar    $0x3,%eax
f01014c4:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01014c7:	89 c2                	mov    %eax,%edx
f01014c9:	c1 ea 0c             	shr    $0xc,%edx
f01014cc:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f01014d2:	72 20                	jb     f01014f4 <page_alloc+0x5f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01014d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01014d8:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f01014df:	f0 
f01014e0:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01014e7:	00 
f01014e8:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f01014ef:	e8 4c eb ff ff       	call   f0100040 <_panic>
            memset(page2kva(ret), 0, PGSIZE);        
f01014f4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01014fb:	00 
f01014fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101503:	00 
	return (void *)(pa + KERNBASE);
f0101504:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101509:	89 04 24             	mov    %eax,(%esp)
f010150c:	e8 c6 53 00 00       	call   f01068d7 <memset>
	return ret;
f0101511:	89 d8                	mov    %ebx,%eax
f0101513:	eb 05                	jmp    f010151a <page_alloc+0x85>
    }
    return NULL;
f0101515:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010151a:	83 c4 14             	add    $0x14,%esp
f010151d:	5b                   	pop    %ebx
f010151e:	5d                   	pop    %ebp
f010151f:	c3                   	ret    

f0101520 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f0101520:	55                   	push   %ebp
f0101521:	89 e5                	mov    %esp,%ebp
f0101523:	83 ec 18             	sub    $0x18,%esp
f0101526:	8b 45 08             	mov    0x8(%ebp),%eax
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	if (pp->pp_ref != 0) {
f0101529:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010152e:	74 1c                	je     f010154c <page_free+0x2c>
		panic("page_free: pp_ref is not zero\n");
f0101530:	c7 44 24 08 94 8d 10 	movl   $0xf0108d94,0x8(%esp)
f0101537:	f0 
f0101538:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
f010153f:	00 
f0101540:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101547:	e8 f4 ea ff ff       	call   f0100040 <_panic>
	}

	if (pp->pp_link != NULL){
f010154c:	83 38 00             	cmpl   $0x0,(%eax)
f010154f:	74 1c                	je     f010156d <page_free+0x4d>
		panic("page_free: pp_link is not NULL\n");
f0101551:	c7 44 24 08 b4 8d 10 	movl   $0xf0108db4,0x8(%esp)
f0101558:	f0 
f0101559:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
f0101560:	00 
f0101561:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101568:	e8 d3 ea ff ff       	call   f0100040 <_panic>
	}

	pp->pp_link = page_free_list;
f010156d:	8b 15 44 42 2c f0    	mov    0xf02c4244,%edx
f0101573:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101575:	a3 44 42 2c f0       	mov    %eax,0xf02c4244
	
}
f010157a:	c9                   	leave  
f010157b:	c3                   	ret    

f010157c <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f010157c:	55                   	push   %ebp
f010157d:	89 e5                	mov    %esp,%ebp
f010157f:	83 ec 18             	sub    $0x18,%esp
f0101582:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0101585:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
f0101589:	8d 51 ff             	lea    -0x1(%ecx),%edx
f010158c:	66 89 50 04          	mov    %dx,0x4(%eax)
f0101590:	66 85 d2             	test   %dx,%dx
f0101593:	75 08                	jne    f010159d <page_decref+0x21>
		page_free(pp);
f0101595:	89 04 24             	mov    %eax,(%esp)
f0101598:	e8 83 ff ff ff       	call   f0101520 <page_free>
}
f010159d:	c9                   	leave  
f010159e:	c3                   	ret    

f010159f <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f010159f:	55                   	push   %ebp
f01015a0:	89 e5                	mov    %esp,%ebp
f01015a2:	56                   	push   %esi
f01015a3:	53                   	push   %ebx
f01015a4:	83 ec 10             	sub    $0x10,%esp
f01015a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo* page_info;
	pte_t* pgtbl_page;
	pde_t* pde = &pgdir[PDX(va)];
f01015aa:	89 f3                	mov    %esi,%ebx
f01015ac:	c1 eb 16             	shr    $0x16,%ebx
f01015af:	c1 e3 02             	shl    $0x2,%ebx
f01015b2:	03 5d 08             	add    0x8(%ebp),%ebx

	if (!(*pde & PTE_P)) {
f01015b5:	f6 03 01             	testb  $0x1,(%ebx)
f01015b8:	75 2c                	jne    f01015e6 <pgdir_walk+0x47>
		if (create == false)
f01015ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01015be:	74 6c                	je     f010162c <pgdir_walk+0x8d>
			return NULL;

		page_info = page_alloc(ALLOC_ZERO);
f01015c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01015c7:	e8 c9 fe ff ff       	call   f0101495 <page_alloc>
		if (page_info == NULL)
f01015cc:	85 c0                	test   %eax,%eax
f01015ce:	74 63                	je     f0101633 <pgdir_walk+0x94>
			return NULL;
		
		page_info->pp_ref++;
f01015d0:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01015d5:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f01015db:	c1 f8 03             	sar    $0x3,%eax
f01015de:	c1 e0 0c             	shl    $0xc,%eax
		*pde = page2pa(page_info) | PTE_P | PTE_W | PTE_U;
f01015e1:	83 c8 07             	or     $0x7,%eax
f01015e4:	89 03                	mov    %eax,(%ebx)
	}

	pgtbl_page = KADDR(PTE_ADDR(*pde));
f01015e6:	8b 03                	mov    (%ebx),%eax
f01015e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01015ed:	89 c2                	mov    %eax,%edx
f01015ef:	c1 ea 0c             	shr    $0xc,%edx
f01015f2:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f01015f8:	72 20                	jb     f010161a <pgdir_walk+0x7b>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01015fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01015fe:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0101605:	f0 
f0101606:	c7 44 24 04 c6 01 00 	movl   $0x1c6,0x4(%esp)
f010160d:	00 
f010160e:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101615:	e8 26 ea ff ff       	call   f0100040 <_panic>
	return &pgtbl_page[PTX(va)];
f010161a:	c1 ee 0a             	shr    $0xa,%esi
f010161d:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101623:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f010162a:	eb 0c                	jmp    f0101638 <pgdir_walk+0x99>
	pte_t* pgtbl_page;
	pde_t* pde = &pgdir[PDX(va)];

	if (!(*pde & PTE_P)) {
		if (create == false)
			return NULL;
f010162c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101631:	eb 05                	jmp    f0101638 <pgdir_walk+0x99>

		page_info = page_alloc(ALLOC_ZERO);
		if (page_info == NULL)
			return NULL;
f0101633:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	pgtbl_page = KADDR(PTE_ADDR(*pde));
	return &pgtbl_page[PTX(va)];
	
}
f0101638:	83 c4 10             	add    $0x10,%esp
f010163b:	5b                   	pop    %ebx
f010163c:	5e                   	pop    %esi
f010163d:	5d                   	pop    %ebp
f010163e:	c3                   	ret    

f010163f <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f010163f:	55                   	push   %ebp
f0101640:	89 e5                	mov    %esp,%ebp
f0101642:	57                   	push   %edi
f0101643:	56                   	push   %esi
f0101644:	53                   	push   %ebx
f0101645:	83 ec 2c             	sub    $0x2c,%esp
f0101648:	89 c7                	mov    %eax,%edi
f010164a:	89 55 e0             	mov    %edx,-0x20(%ebp)
f010164d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i;
	pte_t* pte;	
	for (i = 0; i < size; i = i + PGSIZE) {
f0101650:	bb 00 00 00 00       	mov    $0x0,%ebx
		pte = pgdir_walk(pgdir, (void*)(va+i), true);
		if (pte == NULL) 
			panic("boot_map_region: out of memory\n");
		*pte = (pa+i) | perm | PTE_P;
f0101655:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101658:	83 c8 01             	or     $0x1,%eax
f010165b:	89 45 dc             	mov    %eax,-0x24(%ebp)
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	int i;
	pte_t* pte;	
	for (i = 0; i < size; i = i + PGSIZE) {
f010165e:	eb 47                	jmp    f01016a7 <boot_map_region+0x68>
		pte = pgdir_walk(pgdir, (void*)(va+i), true);
f0101660:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0101667:	00 
f0101668:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010166b:	01 d8                	add    %ebx,%eax
f010166d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101671:	89 3c 24             	mov    %edi,(%esp)
f0101674:	e8 26 ff ff ff       	call   f010159f <pgdir_walk>
		if (pte == NULL) 
f0101679:	85 c0                	test   %eax,%eax
f010167b:	75 1c                	jne    f0101699 <boot_map_region+0x5a>
			panic("boot_map_region: out of memory\n");
f010167d:	c7 44 24 08 d4 8d 10 	movl   $0xf0108dd4,0x8(%esp)
f0101684:	f0 
f0101685:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
f010168c:	00 
f010168d:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101694:	e8 a7 e9 ff ff       	call   f0100040 <_panic>
f0101699:	03 75 08             	add    0x8(%ebp),%esi
		*pte = (pa+i) | perm | PTE_P;
f010169c:	0b 75 dc             	or     -0x24(%ebp),%esi
f010169f:	89 30                	mov    %esi,(%eax)
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	int i;
	pte_t* pte;	
	for (i = 0; i < size; i = i + PGSIZE) {
f01016a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01016a7:	89 de                	mov    %ebx,%esi
f01016a9:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
f01016ac:	77 b2                	ja     f0101660 <boot_map_region+0x21>
		pte = pgdir_walk(pgdir, (void*)(va+i), true);
		if (pte == NULL) 
			panic("boot_map_region: out of memory\n");
		*pte = (pa+i) | perm | PTE_P;
	}
}
f01016ae:	83 c4 2c             	add    $0x2c,%esp
f01016b1:	5b                   	pop    %ebx
f01016b2:	5e                   	pop    %esi
f01016b3:	5f                   	pop    %edi
f01016b4:	5d                   	pop    %ebp
f01016b5:	c3                   	ret    

f01016b6 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f01016b6:	55                   	push   %ebp
f01016b7:	89 e5                	mov    %esp,%ebp
f01016b9:	53                   	push   %ebx
f01016ba:	83 ec 14             	sub    $0x14,%esp
f01016bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
    pte_t *p = pgdir_walk(pgdir, va, 0);
f01016c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01016c7:	00 
f01016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016cb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016cf:	8b 45 08             	mov    0x8(%ebp),%eax
f01016d2:	89 04 24             	mov    %eax,(%esp)
f01016d5:	e8 c5 fe ff ff       	call   f010159f <pgdir_walk>
    if ((p == NULL) || (!(*p & PTE_P))){
f01016da:	85 c0                	test   %eax,%eax
f01016dc:	74 3f                	je     f010171d <page_lookup+0x67>
f01016de:	f6 00 01             	testb  $0x1,(%eax)
f01016e1:	74 41                	je     f0101724 <page_lookup+0x6e>
        return NULL;
    }
    if (pte_store) {
f01016e3:	85 db                	test   %ebx,%ebx
f01016e5:	74 02                	je     f01016e9 <page_lookup+0x33>
        *pte_store = p;
f01016e7:	89 03                	mov    %eax,(%ebx)
    }
    return pa2page(PTE_ADDR(*p));
f01016e9:	8b 00                	mov    (%eax),%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01016eb:	c1 e8 0c             	shr    $0xc,%eax
f01016ee:	3b 05 94 4e 2c f0    	cmp    0xf02c4e94,%eax
f01016f4:	72 1c                	jb     f0101712 <page_lookup+0x5c>
		panic("pa2page called with invalid pa");
f01016f6:	c7 44 24 08 f4 8d 10 	movl   $0xf0108df4,0x8(%esp)
f01016fd:	f0 
f01016fe:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0101705:	00 
f0101706:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f010170d:	e8 2e e9 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0101712:	8b 15 9c 4e 2c f0    	mov    0xf02c4e9c,%edx
f0101718:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f010171b:	eb 0c                	jmp    f0101729 <page_lookup+0x73>
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
    pte_t *p = pgdir_walk(pgdir, va, 0);
    if ((p == NULL) || (!(*p & PTE_P))){
        return NULL;
f010171d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101722:	eb 05                	jmp    f0101729 <page_lookup+0x73>
f0101724:	b8 00 00 00 00       	mov    $0x0,%eax
    }
    if (pte_store) {
        *pte_store = p;
    }
    return pa2page(PTE_ADDR(*p));
}
f0101729:	83 c4 14             	add    $0x14,%esp
f010172c:	5b                   	pop    %ebx
f010172d:	5d                   	pop    %ebp
f010172e:	c3                   	ret    

f010172f <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f010172f:	55                   	push   %ebp
f0101730:	89 e5                	mov    %esp,%ebp
f0101732:	83 ec 08             	sub    $0x8,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0101735:	e8 ef 57 00 00       	call   f0106f29 <cpunum>
f010173a:	6b c0 74             	imul   $0x74,%eax,%eax
f010173d:	83 b8 28 50 2c f0 00 	cmpl   $0x0,-0xfd3afd8(%eax)
f0101744:	74 16                	je     f010175c <tlb_invalidate+0x2d>
f0101746:	e8 de 57 00 00       	call   f0106f29 <cpunum>
f010174b:	6b c0 74             	imul   $0x74,%eax,%eax
f010174e:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0101754:	8b 55 08             	mov    0x8(%ebp),%edx
f0101757:	39 50 60             	cmp    %edx,0x60(%eax)
f010175a:	75 06                	jne    f0101762 <tlb_invalidate+0x33>
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010175c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010175f:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f0101762:	c9                   	leave  
f0101763:	c3                   	ret    

f0101764 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0101764:	55                   	push   %ebp
f0101765:	89 e5                	mov    %esp,%ebp
f0101767:	56                   	push   %esi
f0101768:	53                   	push   %ebx
f0101769:	83 ec 20             	sub    $0x20,%esp
f010176c:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010176f:	8b 75 0c             	mov    0xc(%ebp),%esi
	pte_t pte;
	pte_t* pte_store = &pte;			
f0101772:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101775:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct PageInfo* page = page_lookup(pgdir, va, &pte_store);
f0101778:	8d 45 f0             	lea    -0x10(%ebp),%eax
f010177b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010177f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101783:	89 1c 24             	mov    %ebx,(%esp)
f0101786:	e8 2b ff ff ff       	call   f01016b6 <page_lookup>
	
	if ((page == NULL) || (!(*pte_store & PTE_P))) {
f010178b:	85 c0                	test   %eax,%eax
f010178d:	74 25                	je     f01017b4 <page_remove+0x50>
f010178f:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101792:	f6 02 01             	testb  $0x1,(%edx)
f0101795:	74 1d                	je     f01017b4 <page_remove+0x50>
		return;
	}

	page_decref(page);
f0101797:	89 04 24             	mov    %eax,(%esp)
f010179a:	e8 dd fd ff ff       	call   f010157c <page_decref>
	*pte_store = 0;
f010179f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01017a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir,va);
f01017a8:	89 74 24 04          	mov    %esi,0x4(%esp)
f01017ac:	89 1c 24             	mov    %ebx,(%esp)
f01017af:	e8 7b ff ff ff       	call   f010172f <tlb_invalidate>
}
f01017b4:	83 c4 20             	add    $0x20,%esp
f01017b7:	5b                   	pop    %ebx
f01017b8:	5e                   	pop    %esi
f01017b9:	5d                   	pop    %ebp
f01017ba:	c3                   	ret    

f01017bb <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f01017bb:	55                   	push   %ebp
f01017bc:	89 e5                	mov    %esp,%ebp
f01017be:	57                   	push   %edi
f01017bf:	56                   	push   %esi
f01017c0:	53                   	push   %ebx
f01017c1:	83 ec 1c             	sub    $0x1c,%esp
f01017c4:	8b 75 0c             	mov    0xc(%ebp),%esi
f01017c7:	8b 7d 10             	mov    0x10(%ebp),%edi
    pte_t *p = pgdir_walk(pgdir, va, 1);
f01017ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01017d1:	00 
f01017d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01017d6:	8b 45 08             	mov    0x8(%ebp),%eax
f01017d9:	89 04 24             	mov    %eax,(%esp)
f01017dc:	e8 be fd ff ff       	call   f010159f <pgdir_walk>
f01017e1:	89 c3                	mov    %eax,%ebx
    if (p == NULL) {
f01017e3:	85 c0                	test   %eax,%eax
f01017e5:	74 36                	je     f010181d <page_insert+0x62>
        return -E_NO_MEM;
    }
    pp->pp_ref++;
f01017e7:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
    if (*p & PTE_P) {
f01017ec:	f6 00 01             	testb  $0x1,(%eax)
f01017ef:	74 0f                	je     f0101800 <page_insert+0x45>
        page_remove(pgdir, va);
f01017f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01017f5:	8b 45 08             	mov    0x8(%ebp),%eax
f01017f8:	89 04 24             	mov    %eax,(%esp)
f01017fb:	e8 64 ff ff ff       	call   f0101764 <page_remove>
    }
    *p = page2pa(pp) | perm | PTE_P;
f0101800:	8b 45 14             	mov    0x14(%ebp),%eax
f0101803:	83 c8 01             	or     $0x1,%eax
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101806:	2b 35 9c 4e 2c f0    	sub    0xf02c4e9c,%esi
f010180c:	c1 fe 03             	sar    $0x3,%esi
f010180f:	c1 e6 0c             	shl    $0xc,%esi
f0101812:	09 c6                	or     %eax,%esi
f0101814:	89 33                	mov    %esi,(%ebx)
    return 0;
f0101816:	b8 00 00 00 00       	mov    $0x0,%eax
f010181b:	eb 05                	jmp    f0101822 <page_insert+0x67>
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
    pte_t *p = pgdir_walk(pgdir, va, 1);
    if (p == NULL) {
        return -E_NO_MEM;
f010181d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if (*p & PTE_P) {
        page_remove(pgdir, va);
    }
    *p = page2pa(pp) | perm | PTE_P;
    return 0;
}
f0101822:	83 c4 1c             	add    $0x1c,%esp
f0101825:	5b                   	pop    %ebx
f0101826:	5e                   	pop    %esi
f0101827:	5f                   	pop    %edi
f0101828:	5d                   	pop    %ebp
f0101829:	c3                   	ret    

f010182a <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f010182a:	55                   	push   %ebp
f010182b:	89 e5                	mov    %esp,%ebp
f010182d:	53                   	push   %ebx
f010182e:	83 ec 14             	sub    $0x14,%esp
	// okay to simply panic if this happens).
	//
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:
	size_t alloc_size = ROUNDUP(size, PGSIZE);
f0101831:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101834:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f010183a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (MMIOLIM < base + alloc_size)
f0101840:	8b 15 00 63 12 f0    	mov    0xf0126300,%edx
f0101846:	8d 04 13             	lea    (%ebx,%edx,1),%eax
f0101849:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f010184e:	76 1c                	jbe    f010186c <mmio_map_region+0x42>
		panic("mmio_map_region: out of memory\n");
f0101850:	c7 44 24 08 14 8e 10 	movl   $0xf0108e14,0x8(%esp)
f0101857:	f0 
f0101858:	c7 44 24 04 70 02 00 	movl   $0x270,0x4(%esp)
f010185f:	00 
f0101860:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101867:	e8 d4 e7 ff ff       	call   f0100040 <_panic>
	boot_map_region(kern_pgdir, base, alloc_size, pa, PTE_W | PTE_PCD | PTE_PWT);
f010186c:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
f0101873:	00 
f0101874:	8b 45 08             	mov    0x8(%ebp),%eax
f0101877:	89 04 24             	mov    %eax,(%esp)
f010187a:	89 d9                	mov    %ebx,%ecx
f010187c:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0101881:	e8 b9 fd ff ff       	call   f010163f <boot_map_region>
	uintptr_t ret = base;
f0101886:	a1 00 63 12 f0       	mov    0xf0126300,%eax
	base = base +  alloc_size;
f010188b:	01 c3                	add    %eax,%ebx
f010188d:	89 1d 00 63 12 f0    	mov    %ebx,0xf0126300
	return (void*)ret;
}
f0101893:	83 c4 14             	add    $0x14,%esp
f0101896:	5b                   	pop    %ebx
f0101897:	5d                   	pop    %ebp
f0101898:	c3                   	ret    

f0101899 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0101899:	55                   	push   %ebp
f010189a:	89 e5                	mov    %esp,%ebp
f010189c:	57                   	push   %edi
f010189d:	56                   	push   %esi
f010189e:	53                   	push   %ebx
f010189f:	83 ec 4c             	sub    $0x4c,%esp
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f01018a2:	c7 04 24 15 00 00 00 	movl   $0x15,(%esp)
f01018a9:	e8 ac 28 00 00       	call   f010415a <mc146818_read>
f01018ae:	89 c3                	mov    %eax,%ebx
f01018b0:	c7 04 24 16 00 00 00 	movl   $0x16,(%esp)
f01018b7:	e8 9e 28 00 00       	call   f010415a <mc146818_read>
f01018bc:	c1 e0 08             	shl    $0x8,%eax
f01018bf:	09 c3                	or     %eax,%ebx
{
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f01018c1:	89 d8                	mov    %ebx,%eax
f01018c3:	c1 e0 0a             	shl    $0xa,%eax
f01018c6:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01018cc:	85 c0                	test   %eax,%eax
f01018ce:	0f 48 c2             	cmovs  %edx,%eax
f01018d1:	c1 f8 0c             	sar    $0xc,%eax
f01018d4:	a3 48 42 2c f0       	mov    %eax,0xf02c4248
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f01018d9:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
f01018e0:	e8 75 28 00 00       	call   f010415a <mc146818_read>
f01018e5:	89 c3                	mov    %eax,%ebx
f01018e7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
f01018ee:	e8 67 28 00 00       	call   f010415a <mc146818_read>
f01018f3:	c1 e0 08             	shl    $0x8,%eax
f01018f6:	09 c3                	or     %eax,%ebx
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
	npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f01018f8:	89 d8                	mov    %ebx,%eax
f01018fa:	c1 e0 0a             	shl    $0xa,%eax
f01018fd:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0101903:	85 c0                	test   %eax,%eax
f0101905:	0f 48 c2             	cmovs  %edx,%eax
f0101908:	c1 f8 0c             	sar    $0xc,%eax

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (npages_extmem)
f010190b:	85 c0                	test   %eax,%eax
f010190d:	74 0e                	je     f010191d <mem_init+0x84>
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f010190f:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
f0101915:	89 15 94 4e 2c f0    	mov    %edx,0xf02c4e94
f010191b:	eb 0c                	jmp    f0101929 <mem_init+0x90>
	else
		npages = npages_basemem;
f010191d:	8b 15 48 42 2c f0    	mov    0xf02c4248,%edx
f0101923:	89 15 94 4e 2c f0    	mov    %edx,0xf02c4e94

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024);
f0101929:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010192c:	c1 e8 0a             	shr    $0xa,%eax
f010192f:	89 44 24 0c          	mov    %eax,0xc(%esp)
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
f0101933:	a1 48 42 2c f0       	mov    0xf02c4248,%eax
f0101938:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010193b:	c1 e8 0a             	shr    $0xa,%eax
f010193e:	89 44 24 08          	mov    %eax,0x8(%esp)
		npages * PGSIZE / 1024,
f0101942:	a1 94 4e 2c f0       	mov    0xf02c4e94,%eax
f0101947:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010194a:	c1 e8 0a             	shr    $0xa,%eax
f010194d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101951:	c7 04 24 34 8e 10 f0 	movl   $0xf0108e34,(%esp)
f0101958:	e8 79 29 00 00       	call   f01042d6 <cprintf>
	// Remove this line when you're ready to test this function.
	//panic("mem_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f010195d:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101962:	e8 c9 f5 ff ff       	call   f0100f30 <boot_alloc>
f0101967:	a3 98 4e 2c f0       	mov    %eax,0xf02c4e98
	memset(kern_pgdir, 0, PGSIZE);
f010196c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101973:	00 
f0101974:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010197b:	00 
f010197c:	89 04 24             	mov    %eax,(%esp)
f010197f:	e8 53 4f 00 00       	call   f01068d7 <memset>
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101984:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101989:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010198e:	77 20                	ja     f01019b0 <mem_init+0x117>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101990:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101994:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f010199b:	f0 
f010199c:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
f01019a3:	00 
f01019a4:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01019ab:	e8 90 e6 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01019b0:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01019b6:	83 ca 05             	or     $0x5,%edx
f01019b9:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
	pages = boot_alloc(npages*sizeof(struct PageInfo));
f01019bf:	a1 94 4e 2c f0       	mov    0xf02c4e94,%eax
f01019c4:	c1 e0 03             	shl    $0x3,%eax
f01019c7:	e8 64 f5 ff ff       	call   f0100f30 <boot_alloc>
f01019cc:	a3 9c 4e 2c f0       	mov    %eax,0xf02c4e9c
	memset(pages, 0, npages*sizeof(struct PageInfo));
f01019d1:	8b 0d 94 4e 2c f0    	mov    0xf02c4e94,%ecx
f01019d7:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f01019de:	89 54 24 08          	mov    %edx,0x8(%esp)
f01019e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01019e9:	00 
f01019ea:	89 04 24             	mov    %eax,(%esp)
f01019ed:	e8 e5 4e 00 00       	call   f01068d7 <memset>

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	envs = boot_alloc(NENV*sizeof(struct Env));
f01019f2:	b8 00 10 02 00       	mov    $0x21000,%eax
f01019f7:	e8 34 f5 ff ff       	call   f0100f30 <boot_alloc>
f01019fc:	a3 4c 42 2c f0       	mov    %eax,0xf02c424c
	memset(pages, 0, NENV*sizeof(struct Env));
f0101a01:	c7 44 24 08 00 10 02 	movl   $0x21000,0x8(%esp)
f0101a08:	00 
f0101a09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101a10:	00 
f0101a11:	a1 9c 4e 2c f0       	mov    0xf02c4e9c,%eax
f0101a16:	89 04 24             	mov    %eax,(%esp)
f0101a19:	e8 b9 4e 00 00       	call   f01068d7 <memset>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f0101a1e:	e8 db f9 ff ff       	call   f01013fe <page_init>

	check_page_free_list(1);
f0101a23:	b8 01 00 00 00       	mov    $0x1,%eax
f0101a28:	e8 3e f6 ff ff       	call   f010106b <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0101a2d:	83 3d 9c 4e 2c f0 00 	cmpl   $0x0,0xf02c4e9c
f0101a34:	75 1c                	jne    f0101a52 <mem_init+0x1b9>
		panic("'pages' is a null pointer!");
f0101a36:	c7 44 24 08 8e 8a 10 	movl   $0xf0108a8e,0x8(%esp)
f0101a3d:	f0 
f0101a3e:	c7 44 24 04 fb 02 00 	movl   $0x2fb,0x4(%esp)
f0101a45:	00 
f0101a46:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101a4d:	e8 ee e5 ff ff       	call   f0100040 <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101a52:	a1 44 42 2c f0       	mov    0xf02c4244,%eax
f0101a57:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101a5c:	eb 05                	jmp    f0101a63 <mem_init+0x1ca>
		++nfree;
f0101a5e:	83 c3 01             	add    $0x1,%ebx

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101a61:	8b 00                	mov    (%eax),%eax
f0101a63:	85 c0                	test   %eax,%eax
f0101a65:	75 f7                	jne    f0101a5e <mem_init+0x1c5>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101a67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a6e:	e8 22 fa ff ff       	call   f0101495 <page_alloc>
f0101a73:	89 c7                	mov    %eax,%edi
f0101a75:	85 c0                	test   %eax,%eax
f0101a77:	75 24                	jne    f0101a9d <mem_init+0x204>
f0101a79:	c7 44 24 0c a9 8a 10 	movl   $0xf0108aa9,0xc(%esp)
f0101a80:	f0 
f0101a81:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101a88:	f0 
f0101a89:	c7 44 24 04 03 03 00 	movl   $0x303,0x4(%esp)
f0101a90:	00 
f0101a91:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101a98:	e8 a3 e5 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101a9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101aa4:	e8 ec f9 ff ff       	call   f0101495 <page_alloc>
f0101aa9:	89 c6                	mov    %eax,%esi
f0101aab:	85 c0                	test   %eax,%eax
f0101aad:	75 24                	jne    f0101ad3 <mem_init+0x23a>
f0101aaf:	c7 44 24 0c bf 8a 10 	movl   $0xf0108abf,0xc(%esp)
f0101ab6:	f0 
f0101ab7:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101abe:	f0 
f0101abf:	c7 44 24 04 04 03 00 	movl   $0x304,0x4(%esp)
f0101ac6:	00 
f0101ac7:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101ace:	e8 6d e5 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101ad3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ada:	e8 b6 f9 ff ff       	call   f0101495 <page_alloc>
f0101adf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101ae2:	85 c0                	test   %eax,%eax
f0101ae4:	75 24                	jne    f0101b0a <mem_init+0x271>
f0101ae6:	c7 44 24 0c d5 8a 10 	movl   $0xf0108ad5,0xc(%esp)
f0101aed:	f0 
f0101aee:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101af5:	f0 
f0101af6:	c7 44 24 04 05 03 00 	movl   $0x305,0x4(%esp)
f0101afd:	00 
f0101afe:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101b05:	e8 36 e5 ff ff       	call   f0100040 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101b0a:	39 f7                	cmp    %esi,%edi
f0101b0c:	75 24                	jne    f0101b32 <mem_init+0x299>
f0101b0e:	c7 44 24 0c eb 8a 10 	movl   $0xf0108aeb,0xc(%esp)
f0101b15:	f0 
f0101b16:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101b1d:	f0 
f0101b1e:	c7 44 24 04 08 03 00 	movl   $0x308,0x4(%esp)
f0101b25:	00 
f0101b26:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101b2d:	e8 0e e5 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b35:	39 c6                	cmp    %eax,%esi
f0101b37:	74 04                	je     f0101b3d <mem_init+0x2a4>
f0101b39:	39 c7                	cmp    %eax,%edi
f0101b3b:	75 24                	jne    f0101b61 <mem_init+0x2c8>
f0101b3d:	c7 44 24 0c 70 8e 10 	movl   $0xf0108e70,0xc(%esp)
f0101b44:	f0 
f0101b45:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101b4c:	f0 
f0101b4d:	c7 44 24 04 09 03 00 	movl   $0x309,0x4(%esp)
f0101b54:	00 
f0101b55:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101b5c:	e8 df e4 ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101b61:	8b 15 9c 4e 2c f0    	mov    0xf02c4e9c,%edx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b67:	a1 94 4e 2c f0       	mov    0xf02c4e94,%eax
f0101b6c:	c1 e0 0c             	shl    $0xc,%eax
f0101b6f:	89 f9                	mov    %edi,%ecx
f0101b71:	29 d1                	sub    %edx,%ecx
f0101b73:	c1 f9 03             	sar    $0x3,%ecx
f0101b76:	c1 e1 0c             	shl    $0xc,%ecx
f0101b79:	39 c1                	cmp    %eax,%ecx
f0101b7b:	72 24                	jb     f0101ba1 <mem_init+0x308>
f0101b7d:	c7 44 24 0c fd 8a 10 	movl   $0xf0108afd,0xc(%esp)
f0101b84:	f0 
f0101b85:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101b8c:	f0 
f0101b8d:	c7 44 24 04 0a 03 00 	movl   $0x30a,0x4(%esp)
f0101b94:	00 
f0101b95:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101b9c:	e8 9f e4 ff ff       	call   f0100040 <_panic>
f0101ba1:	89 f1                	mov    %esi,%ecx
f0101ba3:	29 d1                	sub    %edx,%ecx
f0101ba5:	c1 f9 03             	sar    $0x3,%ecx
f0101ba8:	c1 e1 0c             	shl    $0xc,%ecx
	assert(page2pa(pp1) < npages*PGSIZE);
f0101bab:	39 c8                	cmp    %ecx,%eax
f0101bad:	77 24                	ja     f0101bd3 <mem_init+0x33a>
f0101baf:	c7 44 24 0c 1a 8b 10 	movl   $0xf0108b1a,0xc(%esp)
f0101bb6:	f0 
f0101bb7:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101bbe:	f0 
f0101bbf:	c7 44 24 04 0b 03 00 	movl   $0x30b,0x4(%esp)
f0101bc6:	00 
f0101bc7:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101bce:	e8 6d e4 ff ff       	call   f0100040 <_panic>
f0101bd3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101bd6:	29 d1                	sub    %edx,%ecx
f0101bd8:	89 ca                	mov    %ecx,%edx
f0101bda:	c1 fa 03             	sar    $0x3,%edx
f0101bdd:	c1 e2 0c             	shl    $0xc,%edx
	assert(page2pa(pp2) < npages*PGSIZE);
f0101be0:	39 d0                	cmp    %edx,%eax
f0101be2:	77 24                	ja     f0101c08 <mem_init+0x36f>
f0101be4:	c7 44 24 0c 37 8b 10 	movl   $0xf0108b37,0xc(%esp)
f0101beb:	f0 
f0101bec:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101bf3:	f0 
f0101bf4:	c7 44 24 04 0c 03 00 	movl   $0x30c,0x4(%esp)
f0101bfb:	00 
f0101bfc:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101c03:	e8 38 e4 ff ff       	call   f0100040 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101c08:	a1 44 42 2c f0       	mov    0xf02c4244,%eax
f0101c0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101c10:	c7 05 44 42 2c f0 00 	movl   $0x0,0xf02c4244
f0101c17:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101c1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c21:	e8 6f f8 ff ff       	call   f0101495 <page_alloc>
f0101c26:	85 c0                	test   %eax,%eax
f0101c28:	74 24                	je     f0101c4e <mem_init+0x3b5>
f0101c2a:	c7 44 24 0c 54 8b 10 	movl   $0xf0108b54,0xc(%esp)
f0101c31:	f0 
f0101c32:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101c39:	f0 
f0101c3a:	c7 44 24 04 13 03 00 	movl   $0x313,0x4(%esp)
f0101c41:	00 
f0101c42:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101c49:	e8 f2 e3 ff ff       	call   f0100040 <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101c4e:	89 3c 24             	mov    %edi,(%esp)
f0101c51:	e8 ca f8 ff ff       	call   f0101520 <page_free>
	page_free(pp1);
f0101c56:	89 34 24             	mov    %esi,(%esp)
f0101c59:	e8 c2 f8 ff ff       	call   f0101520 <page_free>
	page_free(pp2);
f0101c5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c61:	89 04 24             	mov    %eax,(%esp)
f0101c64:	e8 b7 f8 ff ff       	call   f0101520 <page_free>

	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101c69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c70:	e8 20 f8 ff ff       	call   f0101495 <page_alloc>
f0101c75:	89 c6                	mov    %eax,%esi
f0101c77:	85 c0                	test   %eax,%eax
f0101c79:	75 24                	jne    f0101c9f <mem_init+0x406>
f0101c7b:	c7 44 24 0c a9 8a 10 	movl   $0xf0108aa9,0xc(%esp)
f0101c82:	f0 
f0101c83:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101c8a:	f0 
f0101c8b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
f0101c92:	00 
f0101c93:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101c9a:	e8 a1 e3 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101c9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ca6:	e8 ea f7 ff ff       	call   f0101495 <page_alloc>
f0101cab:	89 c7                	mov    %eax,%edi
f0101cad:	85 c0                	test   %eax,%eax
f0101caf:	75 24                	jne    f0101cd5 <mem_init+0x43c>
f0101cb1:	c7 44 24 0c bf 8a 10 	movl   $0xf0108abf,0xc(%esp)
f0101cb8:	f0 
f0101cb9:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101cc0:	f0 
f0101cc1:	c7 44 24 04 1c 03 00 	movl   $0x31c,0x4(%esp)
f0101cc8:	00 
f0101cc9:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101cd0:	e8 6b e3 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101cd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101cdc:	e8 b4 f7 ff ff       	call   f0101495 <page_alloc>
f0101ce1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101ce4:	85 c0                	test   %eax,%eax
f0101ce6:	75 24                	jne    f0101d0c <mem_init+0x473>
f0101ce8:	c7 44 24 0c d5 8a 10 	movl   $0xf0108ad5,0xc(%esp)
f0101cef:	f0 
f0101cf0:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101cf7:	f0 
f0101cf8:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
f0101cff:	00 
f0101d00:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101d07:	e8 34 e3 ff ff       	call   f0100040 <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101d0c:	39 fe                	cmp    %edi,%esi
f0101d0e:	75 24                	jne    f0101d34 <mem_init+0x49b>
f0101d10:	c7 44 24 0c eb 8a 10 	movl   $0xf0108aeb,0xc(%esp)
f0101d17:	f0 
f0101d18:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101d1f:	f0 
f0101d20:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
f0101d27:	00 
f0101d28:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101d2f:	e8 0c e3 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d37:	39 c7                	cmp    %eax,%edi
f0101d39:	74 04                	je     f0101d3f <mem_init+0x4a6>
f0101d3b:	39 c6                	cmp    %eax,%esi
f0101d3d:	75 24                	jne    f0101d63 <mem_init+0x4ca>
f0101d3f:	c7 44 24 0c 70 8e 10 	movl   $0xf0108e70,0xc(%esp)
f0101d46:	f0 
f0101d47:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101d4e:	f0 
f0101d4f:	c7 44 24 04 20 03 00 	movl   $0x320,0x4(%esp)
f0101d56:	00 
f0101d57:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101d5e:	e8 dd e2 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101d63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101d6a:	e8 26 f7 ff ff       	call   f0101495 <page_alloc>
f0101d6f:	85 c0                	test   %eax,%eax
f0101d71:	74 24                	je     f0101d97 <mem_init+0x4fe>
f0101d73:	c7 44 24 0c 54 8b 10 	movl   $0xf0108b54,0xc(%esp)
f0101d7a:	f0 
f0101d7b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101d82:	f0 
f0101d83:	c7 44 24 04 21 03 00 	movl   $0x321,0x4(%esp)
f0101d8a:	00 
f0101d8b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101d92:	e8 a9 e2 ff ff       	call   f0100040 <_panic>
f0101d97:	89 f0                	mov    %esi,%eax
f0101d99:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f0101d9f:	c1 f8 03             	sar    $0x3,%eax
f0101da2:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101da5:	89 c2                	mov    %eax,%edx
f0101da7:	c1 ea 0c             	shr    $0xc,%edx
f0101daa:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f0101db0:	72 20                	jb     f0101dd2 <mem_init+0x539>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101db2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101db6:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0101dbd:	f0 
f0101dbe:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101dc5:	00 
f0101dc6:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0101dcd:	e8 6e e2 ff ff       	call   f0100040 <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0101dd2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101dd9:	00 
f0101dda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0101de1:	00 
	return (void *)(pa + KERNBASE);
f0101de2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101de7:	89 04 24             	mov    %eax,(%esp)
f0101dea:	e8 e8 4a 00 00       	call   f01068d7 <memset>
	page_free(pp0);
f0101def:	89 34 24             	mov    %esi,(%esp)
f0101df2:	e8 29 f7 ff ff       	call   f0101520 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101df7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101dfe:	e8 92 f6 ff ff       	call   f0101495 <page_alloc>
f0101e03:	85 c0                	test   %eax,%eax
f0101e05:	75 24                	jne    f0101e2b <mem_init+0x592>
f0101e07:	c7 44 24 0c 63 8b 10 	movl   $0xf0108b63,0xc(%esp)
f0101e0e:	f0 
f0101e0f:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101e16:	f0 
f0101e17:	c7 44 24 04 26 03 00 	movl   $0x326,0x4(%esp)
f0101e1e:	00 
f0101e1f:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101e26:	e8 15 e2 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101e2b:	39 c6                	cmp    %eax,%esi
f0101e2d:	74 24                	je     f0101e53 <mem_init+0x5ba>
f0101e2f:	c7 44 24 0c 81 8b 10 	movl   $0xf0108b81,0xc(%esp)
f0101e36:	f0 
f0101e37:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101e3e:	f0 
f0101e3f:	c7 44 24 04 27 03 00 	movl   $0x327,0x4(%esp)
f0101e46:	00 
f0101e47:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101e4e:	e8 ed e1 ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101e53:	89 f0                	mov    %esi,%eax
f0101e55:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f0101e5b:	c1 f8 03             	sar    $0x3,%eax
f0101e5e:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101e61:	89 c2                	mov    %eax,%edx
f0101e63:	c1 ea 0c             	shr    $0xc,%edx
f0101e66:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f0101e6c:	72 20                	jb     f0101e8e <mem_init+0x5f5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101e6e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101e72:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0101e79:	f0 
f0101e7a:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101e81:	00 
f0101e82:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0101e89:	e8 b2 e1 ff ff       	call   f0100040 <_panic>
f0101e8e:	8d 90 00 10 00 f0    	lea    -0xffff000(%eax),%edx
	return (void *)(pa + KERNBASE);
f0101e94:	8d 80 00 00 00 f0    	lea    -0x10000000(%eax),%eax
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f0101e9a:	80 38 00             	cmpb   $0x0,(%eax)
f0101e9d:	74 24                	je     f0101ec3 <mem_init+0x62a>
f0101e9f:	c7 44 24 0c 91 8b 10 	movl   $0xf0108b91,0xc(%esp)
f0101ea6:	f0 
f0101ea7:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101eae:	f0 
f0101eaf:	c7 44 24 04 2a 03 00 	movl   $0x32a,0x4(%esp)
f0101eb6:	00 
f0101eb7:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101ebe:	e8 7d e1 ff ff       	call   f0100040 <_panic>
f0101ec3:	83 c0 01             	add    $0x1,%eax
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0101ec6:	39 d0                	cmp    %edx,%eax
f0101ec8:	75 d0                	jne    f0101e9a <mem_init+0x601>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f0101eca:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ecd:	a3 44 42 2c f0       	mov    %eax,0xf02c4244

	// free the pages we took
	page_free(pp0);
f0101ed2:	89 34 24             	mov    %esi,(%esp)
f0101ed5:	e8 46 f6 ff ff       	call   f0101520 <page_free>
	page_free(pp1);
f0101eda:	89 3c 24             	mov    %edi,(%esp)
f0101edd:	e8 3e f6 ff ff       	call   f0101520 <page_free>
	page_free(pp2);
f0101ee2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ee5:	89 04 24             	mov    %eax,(%esp)
f0101ee8:	e8 33 f6 ff ff       	call   f0101520 <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101eed:	a1 44 42 2c f0       	mov    0xf02c4244,%eax
f0101ef2:	eb 05                	jmp    f0101ef9 <mem_init+0x660>
		--nfree;
f0101ef4:	83 eb 01             	sub    $0x1,%ebx
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101ef7:	8b 00                	mov    (%eax),%eax
f0101ef9:	85 c0                	test   %eax,%eax
f0101efb:	75 f7                	jne    f0101ef4 <mem_init+0x65b>
		--nfree;
	assert(nfree == 0);
f0101efd:	85 db                	test   %ebx,%ebx
f0101eff:	74 24                	je     f0101f25 <mem_init+0x68c>
f0101f01:	c7 44 24 0c 9b 8b 10 	movl   $0xf0108b9b,0xc(%esp)
f0101f08:	f0 
f0101f09:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101f10:	f0 
f0101f11:	c7 44 24 04 37 03 00 	movl   $0x337,0x4(%esp)
f0101f18:	00 
f0101f19:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101f20:	e8 1b e1 ff ff       	call   f0100040 <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f0101f25:	c7 04 24 90 8e 10 f0 	movl   $0xf0108e90,(%esp)
f0101f2c:	e8 a5 23 00 00       	call   f01042d6 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101f31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101f38:	e8 58 f5 ff ff       	call   f0101495 <page_alloc>
f0101f3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101f40:	85 c0                	test   %eax,%eax
f0101f42:	75 24                	jne    f0101f68 <mem_init+0x6cf>
f0101f44:	c7 44 24 0c a9 8a 10 	movl   $0xf0108aa9,0xc(%esp)
f0101f4b:	f0 
f0101f4c:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101f53:	f0 
f0101f54:	c7 44 24 04 9d 03 00 	movl   $0x39d,0x4(%esp)
f0101f5b:	00 
f0101f5c:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101f63:	e8 d8 e0 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101f68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101f6f:	e8 21 f5 ff ff       	call   f0101495 <page_alloc>
f0101f74:	89 c3                	mov    %eax,%ebx
f0101f76:	85 c0                	test   %eax,%eax
f0101f78:	75 24                	jne    f0101f9e <mem_init+0x705>
f0101f7a:	c7 44 24 0c bf 8a 10 	movl   $0xf0108abf,0xc(%esp)
f0101f81:	f0 
f0101f82:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101f89:	f0 
f0101f8a:	c7 44 24 04 9e 03 00 	movl   $0x39e,0x4(%esp)
f0101f91:	00 
f0101f92:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101f99:	e8 a2 e0 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101f9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101fa5:	e8 eb f4 ff ff       	call   f0101495 <page_alloc>
f0101faa:	89 c6                	mov    %eax,%esi
f0101fac:	85 c0                	test   %eax,%eax
f0101fae:	75 24                	jne    f0101fd4 <mem_init+0x73b>
f0101fb0:	c7 44 24 0c d5 8a 10 	movl   $0xf0108ad5,0xc(%esp)
f0101fb7:	f0 
f0101fb8:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101fbf:	f0 
f0101fc0:	c7 44 24 04 9f 03 00 	movl   $0x39f,0x4(%esp)
f0101fc7:	00 
f0101fc8:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101fcf:	e8 6c e0 ff ff       	call   f0100040 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101fd4:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0101fd7:	75 24                	jne    f0101ffd <mem_init+0x764>
f0101fd9:	c7 44 24 0c eb 8a 10 	movl   $0xf0108aeb,0xc(%esp)
f0101fe0:	f0 
f0101fe1:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0101fe8:	f0 
f0101fe9:	c7 44 24 04 a2 03 00 	movl   $0x3a2,0x4(%esp)
f0101ff0:	00 
f0101ff1:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0101ff8:	e8 43 e0 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101ffd:	39 c3                	cmp    %eax,%ebx
f0101fff:	74 05                	je     f0102006 <mem_init+0x76d>
f0102001:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0102004:	75 24                	jne    f010202a <mem_init+0x791>
f0102006:	c7 44 24 0c 70 8e 10 	movl   $0xf0108e70,0xc(%esp)
f010200d:	f0 
f010200e:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102015:	f0 
f0102016:	c7 44 24 04 a3 03 00 	movl   $0x3a3,0x4(%esp)
f010201d:	00 
f010201e:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102025:	e8 16 e0 ff ff       	call   f0100040 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f010202a:	a1 44 42 2c f0       	mov    0xf02c4244,%eax
f010202f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0102032:	c7 05 44 42 2c f0 00 	movl   $0x0,0xf02c4244
f0102039:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f010203c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102043:	e8 4d f4 ff ff       	call   f0101495 <page_alloc>
f0102048:	85 c0                	test   %eax,%eax
f010204a:	74 24                	je     f0102070 <mem_init+0x7d7>
f010204c:	c7 44 24 0c 54 8b 10 	movl   $0xf0108b54,0xc(%esp)
f0102053:	f0 
f0102054:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010205b:	f0 
f010205c:	c7 44 24 04 aa 03 00 	movl   $0x3aa,0x4(%esp)
f0102063:	00 
f0102064:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010206b:	e8 d0 df ff ff       	call   f0100040 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102070:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0102073:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102077:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010207e:	00 
f010207f:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102084:	89 04 24             	mov    %eax,(%esp)
f0102087:	e8 2a f6 ff ff       	call   f01016b6 <page_lookup>
f010208c:	85 c0                	test   %eax,%eax
f010208e:	74 24                	je     f01020b4 <mem_init+0x81b>
f0102090:	c7 44 24 0c b0 8e 10 	movl   $0xf0108eb0,0xc(%esp)
f0102097:	f0 
f0102098:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010209f:	f0 
f01020a0:	c7 44 24 04 ad 03 00 	movl   $0x3ad,0x4(%esp)
f01020a7:	00 
f01020a8:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01020af:	e8 8c df ff ff       	call   f0100040 <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01020b4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01020bb:	00 
f01020bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01020c3:	00 
f01020c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01020c8:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f01020cd:	89 04 24             	mov    %eax,(%esp)
f01020d0:	e8 e6 f6 ff ff       	call   f01017bb <page_insert>
f01020d5:	85 c0                	test   %eax,%eax
f01020d7:	78 24                	js     f01020fd <mem_init+0x864>
f01020d9:	c7 44 24 0c e8 8e 10 	movl   $0xf0108ee8,0xc(%esp)
f01020e0:	f0 
f01020e1:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01020e8:	f0 
f01020e9:	c7 44 24 04 b0 03 00 	movl   $0x3b0,0x4(%esp)
f01020f0:	00 
f01020f1:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01020f8:	e8 43 df ff ff       	call   f0100040 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f01020fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102100:	89 04 24             	mov    %eax,(%esp)
f0102103:	e8 18 f4 ff ff       	call   f0101520 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102108:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010210f:	00 
f0102110:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102117:	00 
f0102118:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010211c:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102121:	89 04 24             	mov    %eax,(%esp)
f0102124:	e8 92 f6 ff ff       	call   f01017bb <page_insert>
f0102129:	85 c0                	test   %eax,%eax
f010212b:	74 24                	je     f0102151 <mem_init+0x8b8>
f010212d:	c7 44 24 0c 18 8f 10 	movl   $0xf0108f18,0xc(%esp)
f0102134:	f0 
f0102135:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010213c:	f0 
f010213d:	c7 44 24 04 b4 03 00 	movl   $0x3b4,0x4(%esp)
f0102144:	00 
f0102145:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010214c:	e8 ef de ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102151:	8b 3d 98 4e 2c f0    	mov    0xf02c4e98,%edi
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102157:	a1 9c 4e 2c f0       	mov    0xf02c4e9c,%eax
f010215c:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010215f:	8b 17                	mov    (%edi),%edx
f0102161:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102167:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010216a:	29 c1                	sub    %eax,%ecx
f010216c:	89 c8                	mov    %ecx,%eax
f010216e:	c1 f8 03             	sar    $0x3,%eax
f0102171:	c1 e0 0c             	shl    $0xc,%eax
f0102174:	39 c2                	cmp    %eax,%edx
f0102176:	74 24                	je     f010219c <mem_init+0x903>
f0102178:	c7 44 24 0c 48 8f 10 	movl   $0xf0108f48,0xc(%esp)
f010217f:	f0 
f0102180:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102187:	f0 
f0102188:	c7 44 24 04 b5 03 00 	movl   $0x3b5,0x4(%esp)
f010218f:	00 
f0102190:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102197:	e8 a4 de ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010219c:	ba 00 00 00 00       	mov    $0x0,%edx
f01021a1:	89 f8                	mov    %edi,%eax
f01021a3:	e8 54 ee ff ff       	call   f0100ffc <check_va2pa>
f01021a8:	89 da                	mov    %ebx,%edx
f01021aa:	2b 55 cc             	sub    -0x34(%ebp),%edx
f01021ad:	c1 fa 03             	sar    $0x3,%edx
f01021b0:	c1 e2 0c             	shl    $0xc,%edx
f01021b3:	39 d0                	cmp    %edx,%eax
f01021b5:	74 24                	je     f01021db <mem_init+0x942>
f01021b7:	c7 44 24 0c 70 8f 10 	movl   $0xf0108f70,0xc(%esp)
f01021be:	f0 
f01021bf:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01021c6:	f0 
f01021c7:	c7 44 24 04 b6 03 00 	movl   $0x3b6,0x4(%esp)
f01021ce:	00 
f01021cf:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01021d6:	e8 65 de ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01021db:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01021e0:	74 24                	je     f0102206 <mem_init+0x96d>
f01021e2:	c7 44 24 0c a6 8b 10 	movl   $0xf0108ba6,0xc(%esp)
f01021e9:	f0 
f01021ea:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01021f1:	f0 
f01021f2:	c7 44 24 04 b7 03 00 	movl   $0x3b7,0x4(%esp)
f01021f9:	00 
f01021fa:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102201:	e8 3a de ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102206:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102209:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010220e:	74 24                	je     f0102234 <mem_init+0x99b>
f0102210:	c7 44 24 0c b7 8b 10 	movl   $0xf0108bb7,0xc(%esp)
f0102217:	f0 
f0102218:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010221f:	f0 
f0102220:	c7 44 24 04 b8 03 00 	movl   $0x3b8,0x4(%esp)
f0102227:	00 
f0102228:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010222f:	e8 0c de ff ff       	call   f0100040 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102234:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010223b:	00 
f010223c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102243:	00 
f0102244:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102248:	89 3c 24             	mov    %edi,(%esp)
f010224b:	e8 6b f5 ff ff       	call   f01017bb <page_insert>
f0102250:	85 c0                	test   %eax,%eax
f0102252:	74 24                	je     f0102278 <mem_init+0x9df>
f0102254:	c7 44 24 0c a0 8f 10 	movl   $0xf0108fa0,0xc(%esp)
f010225b:	f0 
f010225c:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102263:	f0 
f0102264:	c7 44 24 04 bb 03 00 	movl   $0x3bb,0x4(%esp)
f010226b:	00 
f010226c:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102273:	e8 c8 dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102278:	ba 00 10 00 00       	mov    $0x1000,%edx
f010227d:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102282:	e8 75 ed ff ff       	call   f0100ffc <check_va2pa>
f0102287:	89 f2                	mov    %esi,%edx
f0102289:	2b 15 9c 4e 2c f0    	sub    0xf02c4e9c,%edx
f010228f:	c1 fa 03             	sar    $0x3,%edx
f0102292:	c1 e2 0c             	shl    $0xc,%edx
f0102295:	39 d0                	cmp    %edx,%eax
f0102297:	74 24                	je     f01022bd <mem_init+0xa24>
f0102299:	c7 44 24 0c dc 8f 10 	movl   $0xf0108fdc,0xc(%esp)
f01022a0:	f0 
f01022a1:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01022a8:	f0 
f01022a9:	c7 44 24 04 bc 03 00 	movl   $0x3bc,0x4(%esp)
f01022b0:	00 
f01022b1:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01022b8:	e8 83 dd ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01022bd:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01022c2:	74 24                	je     f01022e8 <mem_init+0xa4f>
f01022c4:	c7 44 24 0c c8 8b 10 	movl   $0xf0108bc8,0xc(%esp)
f01022cb:	f0 
f01022cc:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01022d3:	f0 
f01022d4:	c7 44 24 04 bd 03 00 	movl   $0x3bd,0x4(%esp)
f01022db:	00 
f01022dc:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01022e3:	e8 58 dd ff ff       	call   f0100040 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f01022e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01022ef:	e8 a1 f1 ff ff       	call   f0101495 <page_alloc>
f01022f4:	85 c0                	test   %eax,%eax
f01022f6:	74 24                	je     f010231c <mem_init+0xa83>
f01022f8:	c7 44 24 0c 54 8b 10 	movl   $0xf0108b54,0xc(%esp)
f01022ff:	f0 
f0102300:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102307:	f0 
f0102308:	c7 44 24 04 c0 03 00 	movl   $0x3c0,0x4(%esp)
f010230f:	00 
f0102310:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102317:	e8 24 dd ff ff       	call   f0100040 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010231c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102323:	00 
f0102324:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010232b:	00 
f010232c:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102330:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102335:	89 04 24             	mov    %eax,(%esp)
f0102338:	e8 7e f4 ff ff       	call   f01017bb <page_insert>
f010233d:	85 c0                	test   %eax,%eax
f010233f:	74 24                	je     f0102365 <mem_init+0xacc>
f0102341:	c7 44 24 0c a0 8f 10 	movl   $0xf0108fa0,0xc(%esp)
f0102348:	f0 
f0102349:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102350:	f0 
f0102351:	c7 44 24 04 c3 03 00 	movl   $0x3c3,0x4(%esp)
f0102358:	00 
f0102359:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102360:	e8 db dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102365:	ba 00 10 00 00       	mov    $0x1000,%edx
f010236a:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f010236f:	e8 88 ec ff ff       	call   f0100ffc <check_va2pa>
f0102374:	89 f2                	mov    %esi,%edx
f0102376:	2b 15 9c 4e 2c f0    	sub    0xf02c4e9c,%edx
f010237c:	c1 fa 03             	sar    $0x3,%edx
f010237f:	c1 e2 0c             	shl    $0xc,%edx
f0102382:	39 d0                	cmp    %edx,%eax
f0102384:	74 24                	je     f01023aa <mem_init+0xb11>
f0102386:	c7 44 24 0c dc 8f 10 	movl   $0xf0108fdc,0xc(%esp)
f010238d:	f0 
f010238e:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102395:	f0 
f0102396:	c7 44 24 04 c4 03 00 	movl   $0x3c4,0x4(%esp)
f010239d:	00 
f010239e:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01023a5:	e8 96 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01023aa:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01023af:	74 24                	je     f01023d5 <mem_init+0xb3c>
f01023b1:	c7 44 24 0c c8 8b 10 	movl   $0xf0108bc8,0xc(%esp)
f01023b8:	f0 
f01023b9:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01023c0:	f0 
f01023c1:	c7 44 24 04 c5 03 00 	movl   $0x3c5,0x4(%esp)
f01023c8:	00 
f01023c9:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01023d0:	e8 6b dc ff ff       	call   f0100040 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f01023d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01023dc:	e8 b4 f0 ff ff       	call   f0101495 <page_alloc>
f01023e1:	85 c0                	test   %eax,%eax
f01023e3:	74 24                	je     f0102409 <mem_init+0xb70>
f01023e5:	c7 44 24 0c 54 8b 10 	movl   $0xf0108b54,0xc(%esp)
f01023ec:	f0 
f01023ed:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01023f4:	f0 
f01023f5:	c7 44 24 04 c9 03 00 	movl   $0x3c9,0x4(%esp)
f01023fc:	00 
f01023fd:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102404:	e8 37 dc ff ff       	call   f0100040 <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0102409:	8b 15 98 4e 2c f0    	mov    0xf02c4e98,%edx
f010240f:	8b 02                	mov    (%edx),%eax
f0102411:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102416:	89 c1                	mov    %eax,%ecx
f0102418:	c1 e9 0c             	shr    $0xc,%ecx
f010241b:	3b 0d 94 4e 2c f0    	cmp    0xf02c4e94,%ecx
f0102421:	72 20                	jb     f0102443 <mem_init+0xbaa>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102423:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102427:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f010242e:	f0 
f010242f:	c7 44 24 04 cc 03 00 	movl   $0x3cc,0x4(%esp)
f0102436:	00 
f0102437:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010243e:	e8 fd db ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0102443:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102448:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f010244b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102452:	00 
f0102453:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010245a:	00 
f010245b:	89 14 24             	mov    %edx,(%esp)
f010245e:	e8 3c f1 ff ff       	call   f010159f <pgdir_walk>
f0102463:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0102466:	8d 51 04             	lea    0x4(%ecx),%edx
f0102469:	39 d0                	cmp    %edx,%eax
f010246b:	74 24                	je     f0102491 <mem_init+0xbf8>
f010246d:	c7 44 24 0c 0c 90 10 	movl   $0xf010900c,0xc(%esp)
f0102474:	f0 
f0102475:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010247c:	f0 
f010247d:	c7 44 24 04 cd 03 00 	movl   $0x3cd,0x4(%esp)
f0102484:	00 
f0102485:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010248c:	e8 af db ff ff       	call   f0100040 <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102491:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0102498:	00 
f0102499:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01024a0:	00 
f01024a1:	89 74 24 04          	mov    %esi,0x4(%esp)
f01024a5:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f01024aa:	89 04 24             	mov    %eax,(%esp)
f01024ad:	e8 09 f3 ff ff       	call   f01017bb <page_insert>
f01024b2:	85 c0                	test   %eax,%eax
f01024b4:	74 24                	je     f01024da <mem_init+0xc41>
f01024b6:	c7 44 24 0c 4c 90 10 	movl   $0xf010904c,0xc(%esp)
f01024bd:	f0 
f01024be:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01024c5:	f0 
f01024c6:	c7 44 24 04 d0 03 00 	movl   $0x3d0,0x4(%esp)
f01024cd:	00 
f01024ce:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01024d5:	e8 66 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024da:	8b 3d 98 4e 2c f0    	mov    0xf02c4e98,%edi
f01024e0:	ba 00 10 00 00       	mov    $0x1000,%edx
f01024e5:	89 f8                	mov    %edi,%eax
f01024e7:	e8 10 eb ff ff       	call   f0100ffc <check_va2pa>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01024ec:	89 f2                	mov    %esi,%edx
f01024ee:	2b 15 9c 4e 2c f0    	sub    0xf02c4e9c,%edx
f01024f4:	c1 fa 03             	sar    $0x3,%edx
f01024f7:	c1 e2 0c             	shl    $0xc,%edx
f01024fa:	39 d0                	cmp    %edx,%eax
f01024fc:	74 24                	je     f0102522 <mem_init+0xc89>
f01024fe:	c7 44 24 0c dc 8f 10 	movl   $0xf0108fdc,0xc(%esp)
f0102505:	f0 
f0102506:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010250d:	f0 
f010250e:	c7 44 24 04 d1 03 00 	movl   $0x3d1,0x4(%esp)
f0102515:	00 
f0102516:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010251d:	e8 1e db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102522:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102527:	74 24                	je     f010254d <mem_init+0xcb4>
f0102529:	c7 44 24 0c c8 8b 10 	movl   $0xf0108bc8,0xc(%esp)
f0102530:	f0 
f0102531:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102538:	f0 
f0102539:	c7 44 24 04 d2 03 00 	movl   $0x3d2,0x4(%esp)
f0102540:	00 
f0102541:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102548:	e8 f3 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010254d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102554:	00 
f0102555:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010255c:	00 
f010255d:	89 3c 24             	mov    %edi,(%esp)
f0102560:	e8 3a f0 ff ff       	call   f010159f <pgdir_walk>
f0102565:	f6 00 04             	testb  $0x4,(%eax)
f0102568:	75 24                	jne    f010258e <mem_init+0xcf5>
f010256a:	c7 44 24 0c 8c 90 10 	movl   $0xf010908c,0xc(%esp)
f0102571:	f0 
f0102572:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102579:	f0 
f010257a:	c7 44 24 04 d3 03 00 	movl   $0x3d3,0x4(%esp)
f0102581:	00 
f0102582:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102589:	e8 b2 da ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f010258e:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102593:	f6 00 04             	testb  $0x4,(%eax)
f0102596:	75 24                	jne    f01025bc <mem_init+0xd23>
f0102598:	c7 44 24 0c d9 8b 10 	movl   $0xf0108bd9,0xc(%esp)
f010259f:	f0 
f01025a0:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01025a7:	f0 
f01025a8:	c7 44 24 04 d4 03 00 	movl   $0x3d4,0x4(%esp)
f01025af:	00 
f01025b0:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01025b7:	e8 84 da ff ff       	call   f0100040 <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01025bc:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01025c3:	00 
f01025c4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01025cb:	00 
f01025cc:	89 74 24 04          	mov    %esi,0x4(%esp)
f01025d0:	89 04 24             	mov    %eax,(%esp)
f01025d3:	e8 e3 f1 ff ff       	call   f01017bb <page_insert>
f01025d8:	85 c0                	test   %eax,%eax
f01025da:	74 24                	je     f0102600 <mem_init+0xd67>
f01025dc:	c7 44 24 0c a0 8f 10 	movl   $0xf0108fa0,0xc(%esp)
f01025e3:	f0 
f01025e4:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01025eb:	f0 
f01025ec:	c7 44 24 04 d7 03 00 	movl   $0x3d7,0x4(%esp)
f01025f3:	00 
f01025f4:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01025fb:	e8 40 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102600:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102607:	00 
f0102608:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010260f:	00 
f0102610:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102615:	89 04 24             	mov    %eax,(%esp)
f0102618:	e8 82 ef ff ff       	call   f010159f <pgdir_walk>
f010261d:	f6 00 02             	testb  $0x2,(%eax)
f0102620:	75 24                	jne    f0102646 <mem_init+0xdad>
f0102622:	c7 44 24 0c c0 90 10 	movl   $0xf01090c0,0xc(%esp)
f0102629:	f0 
f010262a:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102631:	f0 
f0102632:	c7 44 24 04 d8 03 00 	movl   $0x3d8,0x4(%esp)
f0102639:	00 
f010263a:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102641:	e8 fa d9 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102646:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010264d:	00 
f010264e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102655:	00 
f0102656:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f010265b:	89 04 24             	mov    %eax,(%esp)
f010265e:	e8 3c ef ff ff       	call   f010159f <pgdir_walk>
f0102663:	f6 00 04             	testb  $0x4,(%eax)
f0102666:	74 24                	je     f010268c <mem_init+0xdf3>
f0102668:	c7 44 24 0c f4 90 10 	movl   $0xf01090f4,0xc(%esp)
f010266f:	f0 
f0102670:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102677:	f0 
f0102678:	c7 44 24 04 d9 03 00 	movl   $0x3d9,0x4(%esp)
f010267f:	00 
f0102680:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102687:	e8 b4 d9 ff ff       	call   f0100040 <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f010268c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102693:	00 
f0102694:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f010269b:	00 
f010269c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010269f:	89 44 24 04          	mov    %eax,0x4(%esp)
f01026a3:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f01026a8:	89 04 24             	mov    %eax,(%esp)
f01026ab:	e8 0b f1 ff ff       	call   f01017bb <page_insert>
f01026b0:	85 c0                	test   %eax,%eax
f01026b2:	78 24                	js     f01026d8 <mem_init+0xe3f>
f01026b4:	c7 44 24 0c 2c 91 10 	movl   $0xf010912c,0xc(%esp)
f01026bb:	f0 
f01026bc:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01026c3:	f0 
f01026c4:	c7 44 24 04 dc 03 00 	movl   $0x3dc,0x4(%esp)
f01026cb:	00 
f01026cc:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01026d3:	e8 68 d9 ff ff       	call   f0100040 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01026d8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01026df:	00 
f01026e0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01026e7:	00 
f01026e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01026ec:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f01026f1:	89 04 24             	mov    %eax,(%esp)
f01026f4:	e8 c2 f0 ff ff       	call   f01017bb <page_insert>
f01026f9:	85 c0                	test   %eax,%eax
f01026fb:	74 24                	je     f0102721 <mem_init+0xe88>
f01026fd:	c7 44 24 0c 64 91 10 	movl   $0xf0109164,0xc(%esp)
f0102704:	f0 
f0102705:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010270c:	f0 
f010270d:	c7 44 24 04 df 03 00 	movl   $0x3df,0x4(%esp)
f0102714:	00 
f0102715:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010271c:	e8 1f d9 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102721:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102728:	00 
f0102729:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102730:	00 
f0102731:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102736:	89 04 24             	mov    %eax,(%esp)
f0102739:	e8 61 ee ff ff       	call   f010159f <pgdir_walk>
f010273e:	f6 00 04             	testb  $0x4,(%eax)
f0102741:	74 24                	je     f0102767 <mem_init+0xece>
f0102743:	c7 44 24 0c f4 90 10 	movl   $0xf01090f4,0xc(%esp)
f010274a:	f0 
f010274b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102752:	f0 
f0102753:	c7 44 24 04 e0 03 00 	movl   $0x3e0,0x4(%esp)
f010275a:	00 
f010275b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102762:	e8 d9 d8 ff ff       	call   f0100040 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102767:	8b 3d 98 4e 2c f0    	mov    0xf02c4e98,%edi
f010276d:	ba 00 00 00 00       	mov    $0x0,%edx
f0102772:	89 f8                	mov    %edi,%eax
f0102774:	e8 83 e8 ff ff       	call   f0100ffc <check_va2pa>
f0102779:	89 c1                	mov    %eax,%ecx
f010277b:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010277e:	89 d8                	mov    %ebx,%eax
f0102780:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f0102786:	c1 f8 03             	sar    $0x3,%eax
f0102789:	c1 e0 0c             	shl    $0xc,%eax
f010278c:	39 c1                	cmp    %eax,%ecx
f010278e:	74 24                	je     f01027b4 <mem_init+0xf1b>
f0102790:	c7 44 24 0c a0 91 10 	movl   $0xf01091a0,0xc(%esp)
f0102797:	f0 
f0102798:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010279f:	f0 
f01027a0:	c7 44 24 04 e3 03 00 	movl   $0x3e3,0x4(%esp)
f01027a7:	00 
f01027a8:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01027af:	e8 8c d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01027b4:	ba 00 10 00 00       	mov    $0x1000,%edx
f01027b9:	89 f8                	mov    %edi,%eax
f01027bb:	e8 3c e8 ff ff       	call   f0100ffc <check_va2pa>
f01027c0:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01027c3:	74 24                	je     f01027e9 <mem_init+0xf50>
f01027c5:	c7 44 24 0c cc 91 10 	movl   $0xf01091cc,0xc(%esp)
f01027cc:	f0 
f01027cd:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01027d4:	f0 
f01027d5:	c7 44 24 04 e4 03 00 	movl   $0x3e4,0x4(%esp)
f01027dc:	00 
f01027dd:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01027e4:	e8 57 d8 ff ff       	call   f0100040 <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01027e9:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f01027ee:	74 24                	je     f0102814 <mem_init+0xf7b>
f01027f0:	c7 44 24 0c ef 8b 10 	movl   $0xf0108bef,0xc(%esp)
f01027f7:	f0 
f01027f8:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01027ff:	f0 
f0102800:	c7 44 24 04 e6 03 00 	movl   $0x3e6,0x4(%esp)
f0102807:	00 
f0102808:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010280f:	e8 2c d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102814:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102819:	74 24                	je     f010283f <mem_init+0xfa6>
f010281b:	c7 44 24 0c 00 8c 10 	movl   $0xf0108c00,0xc(%esp)
f0102822:	f0 
f0102823:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010282a:	f0 
f010282b:	c7 44 24 04 e7 03 00 	movl   $0x3e7,0x4(%esp)
f0102832:	00 
f0102833:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010283a:	e8 01 d8 ff ff       	call   f0100040 <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f010283f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102846:	e8 4a ec ff ff       	call   f0101495 <page_alloc>
f010284b:	85 c0                	test   %eax,%eax
f010284d:	74 04                	je     f0102853 <mem_init+0xfba>
f010284f:	39 c6                	cmp    %eax,%esi
f0102851:	74 24                	je     f0102877 <mem_init+0xfde>
f0102853:	c7 44 24 0c fc 91 10 	movl   $0xf01091fc,0xc(%esp)
f010285a:	f0 
f010285b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102862:	f0 
f0102863:	c7 44 24 04 ea 03 00 	movl   $0x3ea,0x4(%esp)
f010286a:	00 
f010286b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102872:	e8 c9 d7 ff ff       	call   f0100040 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0102877:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010287e:	00 
f010287f:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102884:	89 04 24             	mov    %eax,(%esp)
f0102887:	e8 d8 ee ff ff       	call   f0101764 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010288c:	8b 3d 98 4e 2c f0    	mov    0xf02c4e98,%edi
f0102892:	ba 00 00 00 00       	mov    $0x0,%edx
f0102897:	89 f8                	mov    %edi,%eax
f0102899:	e8 5e e7 ff ff       	call   f0100ffc <check_va2pa>
f010289e:	83 f8 ff             	cmp    $0xffffffff,%eax
f01028a1:	74 24                	je     f01028c7 <mem_init+0x102e>
f01028a3:	c7 44 24 0c 20 92 10 	movl   $0xf0109220,0xc(%esp)
f01028aa:	f0 
f01028ab:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01028b2:	f0 
f01028b3:	c7 44 24 04 ee 03 00 	movl   $0x3ee,0x4(%esp)
f01028ba:	00 
f01028bb:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01028c2:	e8 79 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01028c7:	ba 00 10 00 00       	mov    $0x1000,%edx
f01028cc:	89 f8                	mov    %edi,%eax
f01028ce:	e8 29 e7 ff ff       	call   f0100ffc <check_va2pa>
f01028d3:	89 da                	mov    %ebx,%edx
f01028d5:	2b 15 9c 4e 2c f0    	sub    0xf02c4e9c,%edx
f01028db:	c1 fa 03             	sar    $0x3,%edx
f01028de:	c1 e2 0c             	shl    $0xc,%edx
f01028e1:	39 d0                	cmp    %edx,%eax
f01028e3:	74 24                	je     f0102909 <mem_init+0x1070>
f01028e5:	c7 44 24 0c cc 91 10 	movl   $0xf01091cc,0xc(%esp)
f01028ec:	f0 
f01028ed:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01028f4:	f0 
f01028f5:	c7 44 24 04 ef 03 00 	movl   $0x3ef,0x4(%esp)
f01028fc:	00 
f01028fd:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102904:	e8 37 d7 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102909:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010290e:	74 24                	je     f0102934 <mem_init+0x109b>
f0102910:	c7 44 24 0c a6 8b 10 	movl   $0xf0108ba6,0xc(%esp)
f0102917:	f0 
f0102918:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010291f:	f0 
f0102920:	c7 44 24 04 f0 03 00 	movl   $0x3f0,0x4(%esp)
f0102927:	00 
f0102928:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010292f:	e8 0c d7 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102934:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102939:	74 24                	je     f010295f <mem_init+0x10c6>
f010293b:	c7 44 24 0c 00 8c 10 	movl   $0xf0108c00,0xc(%esp)
f0102942:	f0 
f0102943:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010294a:	f0 
f010294b:	c7 44 24 04 f1 03 00 	movl   $0x3f1,0x4(%esp)
f0102952:	00 
f0102953:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010295a:	e8 e1 d6 ff ff       	call   f0100040 <_panic>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010295f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102966:	00 
f0102967:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010296e:	00 
f010296f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102973:	89 3c 24             	mov    %edi,(%esp)
f0102976:	e8 40 ee ff ff       	call   f01017bb <page_insert>
f010297b:	85 c0                	test   %eax,%eax
f010297d:	74 24                	je     f01029a3 <mem_init+0x110a>
f010297f:	c7 44 24 0c 44 92 10 	movl   $0xf0109244,0xc(%esp)
f0102986:	f0 
f0102987:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010298e:	f0 
f010298f:	c7 44 24 04 f4 03 00 	movl   $0x3f4,0x4(%esp)
f0102996:	00 
f0102997:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010299e:	e8 9d d6 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f01029a3:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01029a8:	75 24                	jne    f01029ce <mem_init+0x1135>
f01029aa:	c7 44 24 0c 11 8c 10 	movl   $0xf0108c11,0xc(%esp)
f01029b1:	f0 
f01029b2:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01029b9:	f0 
f01029ba:	c7 44 24 04 f5 03 00 	movl   $0x3f5,0x4(%esp)
f01029c1:	00 
f01029c2:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01029c9:	e8 72 d6 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f01029ce:	83 3b 00             	cmpl   $0x0,(%ebx)
f01029d1:	74 24                	je     f01029f7 <mem_init+0x115e>
f01029d3:	c7 44 24 0c 1d 8c 10 	movl   $0xf0108c1d,0xc(%esp)
f01029da:	f0 
f01029db:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01029e2:	f0 
f01029e3:	c7 44 24 04 f6 03 00 	movl   $0x3f6,0x4(%esp)
f01029ea:	00 
f01029eb:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01029f2:	e8 49 d6 ff ff       	call   f0100040 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f01029f7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01029fe:	00 
f01029ff:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102a04:	89 04 24             	mov    %eax,(%esp)
f0102a07:	e8 58 ed ff ff       	call   f0101764 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a0c:	8b 3d 98 4e 2c f0    	mov    0xf02c4e98,%edi
f0102a12:	ba 00 00 00 00       	mov    $0x0,%edx
f0102a17:	89 f8                	mov    %edi,%eax
f0102a19:	e8 de e5 ff ff       	call   f0100ffc <check_va2pa>
f0102a1e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a21:	74 24                	je     f0102a47 <mem_init+0x11ae>
f0102a23:	c7 44 24 0c 20 92 10 	movl   $0xf0109220,0xc(%esp)
f0102a2a:	f0 
f0102a2b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102a32:	f0 
f0102a33:	c7 44 24 04 fa 03 00 	movl   $0x3fa,0x4(%esp)
f0102a3a:	00 
f0102a3b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102a42:	e8 f9 d5 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102a47:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102a4c:	89 f8                	mov    %edi,%eax
f0102a4e:	e8 a9 e5 ff ff       	call   f0100ffc <check_va2pa>
f0102a53:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a56:	74 24                	je     f0102a7c <mem_init+0x11e3>
f0102a58:	c7 44 24 0c 7c 92 10 	movl   $0xf010927c,0xc(%esp)
f0102a5f:	f0 
f0102a60:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102a67:	f0 
f0102a68:	c7 44 24 04 fb 03 00 	movl   $0x3fb,0x4(%esp)
f0102a6f:	00 
f0102a70:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102a77:	e8 c4 d5 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102a7c:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102a81:	74 24                	je     f0102aa7 <mem_init+0x120e>
f0102a83:	c7 44 24 0c 32 8c 10 	movl   $0xf0108c32,0xc(%esp)
f0102a8a:	f0 
f0102a8b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102a92:	f0 
f0102a93:	c7 44 24 04 fc 03 00 	movl   $0x3fc,0x4(%esp)
f0102a9a:	00 
f0102a9b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102aa2:	e8 99 d5 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102aa7:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102aac:	74 24                	je     f0102ad2 <mem_init+0x1239>
f0102aae:	c7 44 24 0c 00 8c 10 	movl   $0xf0108c00,0xc(%esp)
f0102ab5:	f0 
f0102ab6:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102abd:	f0 
f0102abe:	c7 44 24 04 fd 03 00 	movl   $0x3fd,0x4(%esp)
f0102ac5:	00 
f0102ac6:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102acd:	e8 6e d5 ff ff       	call   f0100040 <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0102ad2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102ad9:	e8 b7 e9 ff ff       	call   f0101495 <page_alloc>
f0102ade:	85 c0                	test   %eax,%eax
f0102ae0:	74 04                	je     f0102ae6 <mem_init+0x124d>
f0102ae2:	39 c3                	cmp    %eax,%ebx
f0102ae4:	74 24                	je     f0102b0a <mem_init+0x1271>
f0102ae6:	c7 44 24 0c a4 92 10 	movl   $0xf01092a4,0xc(%esp)
f0102aed:	f0 
f0102aee:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102af5:	f0 
f0102af6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0102afd:	00 
f0102afe:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102b05:	e8 36 d5 ff ff       	call   f0100040 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0102b0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102b11:	e8 7f e9 ff ff       	call   f0101495 <page_alloc>
f0102b16:	85 c0                	test   %eax,%eax
f0102b18:	74 24                	je     f0102b3e <mem_init+0x12a5>
f0102b1a:	c7 44 24 0c 54 8b 10 	movl   $0xf0108b54,0xc(%esp)
f0102b21:	f0 
f0102b22:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102b29:	f0 
f0102b2a:	c7 44 24 04 03 04 00 	movl   $0x403,0x4(%esp)
f0102b31:	00 
f0102b32:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102b39:	e8 02 d5 ff ff       	call   f0100040 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b3e:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102b43:	8b 08                	mov    (%eax),%ecx
f0102b45:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102b4b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102b4e:	2b 15 9c 4e 2c f0    	sub    0xf02c4e9c,%edx
f0102b54:	c1 fa 03             	sar    $0x3,%edx
f0102b57:	c1 e2 0c             	shl    $0xc,%edx
f0102b5a:	39 d1                	cmp    %edx,%ecx
f0102b5c:	74 24                	je     f0102b82 <mem_init+0x12e9>
f0102b5e:	c7 44 24 0c 48 8f 10 	movl   $0xf0108f48,0xc(%esp)
f0102b65:	f0 
f0102b66:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102b6d:	f0 
f0102b6e:	c7 44 24 04 06 04 00 	movl   $0x406,0x4(%esp)
f0102b75:	00 
f0102b76:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102b7d:	e8 be d4 ff ff       	call   f0100040 <_panic>
	kern_pgdir[0] = 0;
f0102b82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0102b88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b8b:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102b90:	74 24                	je     f0102bb6 <mem_init+0x131d>
f0102b92:	c7 44 24 0c b7 8b 10 	movl   $0xf0108bb7,0xc(%esp)
f0102b99:	f0 
f0102b9a:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102ba1:	f0 
f0102ba2:	c7 44 24 04 08 04 00 	movl   $0x408,0x4(%esp)
f0102ba9:	00 
f0102baa:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102bb1:	e8 8a d4 ff ff       	call   f0100040 <_panic>
	pp0->pp_ref = 0;
f0102bb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bb9:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102bbf:	89 04 24             	mov    %eax,(%esp)
f0102bc2:	e8 59 e9 ff ff       	call   f0101520 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102bc7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102bce:	00 
f0102bcf:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f0102bd6:	00 
f0102bd7:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102bdc:	89 04 24             	mov    %eax,(%esp)
f0102bdf:	e8 bb e9 ff ff       	call   f010159f <pgdir_walk>
f0102be4:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102be7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102bea:	8b 15 98 4e 2c f0    	mov    0xf02c4e98,%edx
f0102bf0:	8b 7a 04             	mov    0x4(%edx),%edi
f0102bf3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102bf9:	8b 0d 94 4e 2c f0    	mov    0xf02c4e94,%ecx
f0102bff:	89 f8                	mov    %edi,%eax
f0102c01:	c1 e8 0c             	shr    $0xc,%eax
f0102c04:	39 c8                	cmp    %ecx,%eax
f0102c06:	72 20                	jb     f0102c28 <mem_init+0x138f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102c08:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0102c0c:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0102c13:	f0 
f0102c14:	c7 44 24 04 0f 04 00 	movl   $0x40f,0x4(%esp)
f0102c1b:	00 
f0102c1c:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102c23:	e8 18 d4 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102c28:	81 ef fc ff ff 0f    	sub    $0xffffffc,%edi
f0102c2e:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0102c31:	74 24                	je     f0102c57 <mem_init+0x13be>
f0102c33:	c7 44 24 0c 43 8c 10 	movl   $0xf0108c43,0xc(%esp)
f0102c3a:	f0 
f0102c3b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102c42:	f0 
f0102c43:	c7 44 24 04 10 04 00 	movl   $0x410,0x4(%esp)
f0102c4a:	00 
f0102c4b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102c52:	e8 e9 d3 ff ff       	call   f0100040 <_panic>
	kern_pgdir[PDX(va)] = 0;
f0102c57:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
	pp0->pp_ref = 0;
f0102c5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c61:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102c67:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f0102c6d:	c1 f8 03             	sar    $0x3,%eax
f0102c70:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102c73:	89 c2                	mov    %eax,%edx
f0102c75:	c1 ea 0c             	shr    $0xc,%edx
f0102c78:	39 d1                	cmp    %edx,%ecx
f0102c7a:	77 20                	ja     f0102c9c <mem_init+0x1403>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102c7c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102c80:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0102c87:	f0 
f0102c88:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0102c8f:	00 
f0102c90:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0102c97:	e8 a4 d3 ff ff       	call   f0100040 <_panic>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102c9c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102ca3:	00 
f0102ca4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f0102cab:	00 
	return (void *)(pa + KERNBASE);
f0102cac:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102cb1:	89 04 24             	mov    %eax,(%esp)
f0102cb4:	e8 1e 3c 00 00       	call   f01068d7 <memset>
	page_free(pp0);
f0102cb9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102cbc:	89 3c 24             	mov    %edi,(%esp)
f0102cbf:	e8 5c e8 ff ff       	call   f0101520 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102cc4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102ccb:	00 
f0102ccc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102cd3:	00 
f0102cd4:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102cd9:	89 04 24             	mov    %eax,(%esp)
f0102cdc:	e8 be e8 ff ff       	call   f010159f <pgdir_walk>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102ce1:	89 fa                	mov    %edi,%edx
f0102ce3:	2b 15 9c 4e 2c f0    	sub    0xf02c4e9c,%edx
f0102ce9:	c1 fa 03             	sar    $0x3,%edx
f0102cec:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102cef:	89 d0                	mov    %edx,%eax
f0102cf1:	c1 e8 0c             	shr    $0xc,%eax
f0102cf4:	3b 05 94 4e 2c f0    	cmp    0xf02c4e94,%eax
f0102cfa:	72 20                	jb     f0102d1c <mem_init+0x1483>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102cfc:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0102d00:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0102d07:	f0 
f0102d08:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0102d0f:	00 
f0102d10:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0102d17:	e8 24 d3 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0102d1c:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102d22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102d25:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102d2b:	f6 00 01             	testb  $0x1,(%eax)
f0102d2e:	74 24                	je     f0102d54 <mem_init+0x14bb>
f0102d30:	c7 44 24 0c 5b 8c 10 	movl   $0xf0108c5b,0xc(%esp)
f0102d37:	f0 
f0102d38:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102d3f:	f0 
f0102d40:	c7 44 24 04 1a 04 00 	movl   $0x41a,0x4(%esp)
f0102d47:	00 
f0102d48:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102d4f:	e8 ec d2 ff ff       	call   f0100040 <_panic>
f0102d54:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f0102d57:	39 d0                	cmp    %edx,%eax
f0102d59:	75 d0                	jne    f0102d2b <mem_init+0x1492>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f0102d5b:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102d66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d69:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102d6f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102d72:	89 0d 44 42 2c f0    	mov    %ecx,0xf02c4244

	// free the pages we took
	page_free(pp0);
f0102d78:	89 04 24             	mov    %eax,(%esp)
f0102d7b:	e8 a0 e7 ff ff       	call   f0101520 <page_free>
	page_free(pp1);
f0102d80:	89 1c 24             	mov    %ebx,(%esp)
f0102d83:	e8 98 e7 ff ff       	call   f0101520 <page_free>
	page_free(pp2);
f0102d88:	89 34 24             	mov    %esi,(%esp)
f0102d8b:	e8 90 e7 ff ff       	call   f0101520 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102d90:	c7 44 24 04 01 10 00 	movl   $0x1001,0x4(%esp)
f0102d97:	00 
f0102d98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102d9f:	e8 86 ea ff ff       	call   f010182a <mmio_map_region>
f0102da4:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102da6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102dad:	00 
f0102dae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102db5:	e8 70 ea ff ff       	call   f010182a <mmio_map_region>
f0102dba:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102dbc:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f0102dc2:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102dc7:	77 08                	ja     f0102dd1 <mem_init+0x1538>
f0102dc9:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102dcf:	77 24                	ja     f0102df5 <mem_init+0x155c>
f0102dd1:	c7 44 24 0c c8 92 10 	movl   $0xf01092c8,0xc(%esp)
f0102dd8:	f0 
f0102dd9:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102de0:	f0 
f0102de1:	c7 44 24 04 2a 04 00 	movl   $0x42a,0x4(%esp)
f0102de8:	00 
f0102de9:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102df0:	e8 4b d2 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102df5:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f0102dfb:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102e01:	77 08                	ja     f0102e0b <mem_init+0x1572>
f0102e03:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102e09:	77 24                	ja     f0102e2f <mem_init+0x1596>
f0102e0b:	c7 44 24 0c f0 92 10 	movl   $0xf01092f0,0xc(%esp)
f0102e12:	f0 
f0102e13:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102e1a:	f0 
f0102e1b:	c7 44 24 04 2b 04 00 	movl   $0x42b,0x4(%esp)
f0102e22:	00 
f0102e23:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102e2a:	e8 11 d2 ff ff       	call   f0100040 <_panic>
f0102e2f:	89 da                	mov    %ebx,%edx
f0102e31:	09 f2                	or     %esi,%edx
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102e33:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102e39:	74 24                	je     f0102e5f <mem_init+0x15c6>
f0102e3b:	c7 44 24 0c 18 93 10 	movl   $0xf0109318,0xc(%esp)
f0102e42:	f0 
f0102e43:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102e4a:	f0 
f0102e4b:	c7 44 24 04 2d 04 00 	movl   $0x42d,0x4(%esp)
f0102e52:	00 
f0102e53:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102e5a:	e8 e1 d1 ff ff       	call   f0100040 <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f0102e5f:	39 c6                	cmp    %eax,%esi
f0102e61:	73 24                	jae    f0102e87 <mem_init+0x15ee>
f0102e63:	c7 44 24 0c 72 8c 10 	movl   $0xf0108c72,0xc(%esp)
f0102e6a:	f0 
f0102e6b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102e72:	f0 
f0102e73:	c7 44 24 04 2f 04 00 	movl   $0x42f,0x4(%esp)
f0102e7a:	00 
f0102e7b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102e82:	e8 b9 d1 ff ff       	call   f0100040 <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102e87:	8b 3d 98 4e 2c f0    	mov    0xf02c4e98,%edi
f0102e8d:	89 da                	mov    %ebx,%edx
f0102e8f:	89 f8                	mov    %edi,%eax
f0102e91:	e8 66 e1 ff ff       	call   f0100ffc <check_va2pa>
f0102e96:	85 c0                	test   %eax,%eax
f0102e98:	74 24                	je     f0102ebe <mem_init+0x1625>
f0102e9a:	c7 44 24 0c 40 93 10 	movl   $0xf0109340,0xc(%esp)
f0102ea1:	f0 
f0102ea2:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102ea9:	f0 
f0102eaa:	c7 44 24 04 31 04 00 	movl   $0x431,0x4(%esp)
f0102eb1:	00 
f0102eb2:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102eb9:	e8 82 d1 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102ebe:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102ec4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102ec7:	89 c2                	mov    %eax,%edx
f0102ec9:	89 f8                	mov    %edi,%eax
f0102ecb:	e8 2c e1 ff ff       	call   f0100ffc <check_va2pa>
f0102ed0:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102ed5:	74 24                	je     f0102efb <mem_init+0x1662>
f0102ed7:	c7 44 24 0c 64 93 10 	movl   $0xf0109364,0xc(%esp)
f0102ede:	f0 
f0102edf:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102ee6:	f0 
f0102ee7:	c7 44 24 04 32 04 00 	movl   $0x432,0x4(%esp)
f0102eee:	00 
f0102eef:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102ef6:	e8 45 d1 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102efb:	89 f2                	mov    %esi,%edx
f0102efd:	89 f8                	mov    %edi,%eax
f0102eff:	e8 f8 e0 ff ff       	call   f0100ffc <check_va2pa>
f0102f04:	85 c0                	test   %eax,%eax
f0102f06:	74 24                	je     f0102f2c <mem_init+0x1693>
f0102f08:	c7 44 24 0c 94 93 10 	movl   $0xf0109394,0xc(%esp)
f0102f0f:	f0 
f0102f10:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102f17:	f0 
f0102f18:	c7 44 24 04 33 04 00 	movl   $0x433,0x4(%esp)
f0102f1f:	00 
f0102f20:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102f27:	e8 14 d1 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102f2c:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102f32:	89 f8                	mov    %edi,%eax
f0102f34:	e8 c3 e0 ff ff       	call   f0100ffc <check_va2pa>
f0102f39:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102f3c:	74 24                	je     f0102f62 <mem_init+0x16c9>
f0102f3e:	c7 44 24 0c b8 93 10 	movl   $0xf01093b8,0xc(%esp)
f0102f45:	f0 
f0102f46:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102f4d:	f0 
f0102f4e:	c7 44 24 04 34 04 00 	movl   $0x434,0x4(%esp)
f0102f55:	00 
f0102f56:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102f5d:	e8 de d0 ff ff       	call   f0100040 <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102f62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102f69:	00 
f0102f6a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102f6e:	89 3c 24             	mov    %edi,(%esp)
f0102f71:	e8 29 e6 ff ff       	call   f010159f <pgdir_walk>
f0102f76:	f6 00 1a             	testb  $0x1a,(%eax)
f0102f79:	75 24                	jne    f0102f9f <mem_init+0x1706>
f0102f7b:	c7 44 24 0c e4 93 10 	movl   $0xf01093e4,0xc(%esp)
f0102f82:	f0 
f0102f83:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102f8a:	f0 
f0102f8b:	c7 44 24 04 36 04 00 	movl   $0x436,0x4(%esp)
f0102f92:	00 
f0102f93:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102f9a:	e8 a1 d0 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102f9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102fa6:	00 
f0102fa7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102fab:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102fb0:	89 04 24             	mov    %eax,(%esp)
f0102fb3:	e8 e7 e5 ff ff       	call   f010159f <pgdir_walk>
f0102fb8:	f6 00 04             	testb  $0x4,(%eax)
f0102fbb:	74 24                	je     f0102fe1 <mem_init+0x1748>
f0102fbd:	c7 44 24 0c 28 94 10 	movl   $0xf0109428,0xc(%esp)
f0102fc4:	f0 
f0102fc5:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0102fcc:	f0 
f0102fcd:	c7 44 24 04 37 04 00 	movl   $0x437,0x4(%esp)
f0102fd4:	00 
f0102fd5:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0102fdc:	e8 5f d0 ff ff       	call   f0100040 <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102fe1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102fe8:	00 
f0102fe9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102fed:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0102ff2:	89 04 24             	mov    %eax,(%esp)
f0102ff5:	e8 a5 e5 ff ff       	call   f010159f <pgdir_walk>
f0102ffa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0103000:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103007:	00 
f0103008:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010300b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010300f:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0103014:	89 04 24             	mov    %eax,(%esp)
f0103017:	e8 83 e5 ff ff       	call   f010159f <pgdir_walk>
f010301c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0103022:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103029:	00 
f010302a:	89 74 24 04          	mov    %esi,0x4(%esp)
f010302e:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0103033:	89 04 24             	mov    %eax,(%esp)
f0103036:	e8 64 e5 ff ff       	call   f010159f <pgdir_walk>
f010303b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0103041:	c7 04 24 84 8c 10 f0 	movl   $0xf0108c84,(%esp)
f0103048:	e8 89 12 00 00       	call   f01042d6 <cprintf>
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
    	boot_map_region(kern_pgdir,UPAGES,PTSIZE,PADDR(pages),PTE_U);
f010304d:	a1 9c 4e 2c f0       	mov    0xf02c4e9c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103052:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103057:	77 20                	ja     f0103079 <mem_init+0x17e0>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103059:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010305d:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103064:	f0 
f0103065:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
f010306c:	00 
f010306d:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103074:	e8 c7 cf ff ff       	call   f0100040 <_panic>
f0103079:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
f0103080:	00 
	return (physaddr_t)kva - KERNBASE;
f0103081:	05 00 00 00 10       	add    $0x10000000,%eax
f0103086:	89 04 24             	mov    %eax,(%esp)
f0103089:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010308e:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0103093:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0103098:	e8 a2 e5 ff ff       	call   f010163f <boot_map_region>
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	boot_map_region(kern_pgdir,UENVS,PTSIZE,PADDR(envs),PTE_U);
f010309d:	a1 4c 42 2c f0       	mov    0xf02c424c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01030a2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01030a7:	77 20                	ja     f01030c9 <mem_init+0x1830>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01030a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01030ad:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f01030b4:	f0 
f01030b5:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
f01030bc:	00 
f01030bd:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01030c4:	e8 77 cf ff ff       	call   f0100040 <_panic>
f01030c9:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
f01030d0:	00 
	return (physaddr_t)kva - KERNBASE;
f01030d1:	05 00 00 00 10       	add    $0x10000000,%eax
f01030d6:	89 04 24             	mov    %eax,(%esp)
f01030d9:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01030de:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01030e3:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f01030e8:	e8 52 e5 ff ff       	call   f010163f <boot_map_region>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01030ed:	b8 00 c0 11 f0       	mov    $0xf011c000,%eax
f01030f2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01030f7:	77 20                	ja     f0103119 <mem_init+0x1880>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01030f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01030fd:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103104:	f0 
f0103105:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
f010310c:	00 
f010310d:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103114:	e8 27 cf ff ff       	call   f0100040 <_panic>
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed; so if
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
    	boot_map_region(kern_pgdir,KSTACKTOP-KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W);
f0103119:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f0103120:	00 
f0103121:	c7 04 24 00 c0 11 00 	movl   $0x11c000,(%esp)
f0103128:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010312d:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0103132:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0103137:	e8 03 e5 ff ff       	call   f010163f <boot_map_region>
	//      the PA range [0, 2^32 - KERNBASE)
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
    	boot_map_region(kern_pgdir,KERNBASE,-KERNBASE,0,PTE_W);
f010313c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f0103143:	00 
f0103144:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010314b:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0103150:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103155:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f010315a:	e8 e0 e4 ff ff       	call   f010163f <boot_map_region>
f010315f:	bf 00 60 30 f0       	mov    $0xf0306000,%edi
f0103164:	bb 00 60 2c f0       	mov    $0xf02c6000,%ebx
f0103169:	be 00 80 ff ef       	mov    $0xefff8000,%esi
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010316e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0103174:	77 20                	ja     f0103196 <mem_init+0x18fd>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103176:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010317a:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103181:	f0 
f0103182:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
f0103189:	00 
f010318a:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103191:	e8 aa ce ff ff       	call   f0100040 <_panic>

	int i;
	uintptr_t kstacktop_i;
	for (i=0 ; i<NCPU ; i++) {
		kstacktop_i = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
		boot_map_region(kern_pgdir,kstacktop_i-KSTKSIZE,KSTKSIZE,PADDR(percpu_kstacks[i]),PTE_W);
f0103196:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f010319d:	00 
f010319e:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01031a4:	89 04 24             	mov    %eax,(%esp)
f01031a7:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01031ac:	89 f2                	mov    %esi,%edx
f01031ae:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f01031b3:	e8 87 e4 ff ff       	call   f010163f <boot_map_region>
f01031b8:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f01031be:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	//
	// LAB 4: Your code here:

	int i;
	uintptr_t kstacktop_i;
	for (i=0 ; i<NCPU ; i++) {
f01031c4:	39 fb                	cmp    %edi,%ebx
f01031c6:	75 a6                	jne    f010316e <mem_init+0x18d5>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f01031c8:	8b 3d 98 4e 2c f0    	mov    0xf02c4e98,%edi

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01031ce:	a1 94 4e 2c f0       	mov    0xf02c4e94,%eax
f01031d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01031d6:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01031dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01031e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01031e5:	8b 35 9c 4e 2c f0    	mov    0xf02c4e9c,%esi
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01031eb:	89 75 cc             	mov    %esi,-0x34(%ebp)
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
	return (physaddr_t)kva - KERNBASE;
f01031ee:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01031f4:	89 45 c8             	mov    %eax,-0x38(%ebp)

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01031f7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01031fc:	eb 6a                	jmp    f0103268 <mem_init+0x19cf>
f01031fe:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0103204:	89 f8                	mov    %edi,%eax
f0103206:	e8 f1 dd ff ff       	call   f0100ffc <check_va2pa>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010320b:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0103212:	77 20                	ja     f0103234 <mem_init+0x199b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103214:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0103218:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f010321f:	f0 
f0103220:	c7 44 24 04 4f 03 00 	movl   $0x34f,0x4(%esp)
f0103227:	00 
f0103228:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010322f:	e8 0c ce ff ff       	call   f0100040 <_panic>
f0103234:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0103237:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f010323a:	39 d0                	cmp    %edx,%eax
f010323c:	74 24                	je     f0103262 <mem_init+0x19c9>
f010323e:	c7 44 24 0c 5c 94 10 	movl   $0xf010945c,0xc(%esp)
f0103245:	f0 
f0103246:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010324d:	f0 
f010324e:	c7 44 24 04 4f 03 00 	movl   $0x34f,0x4(%esp)
f0103255:	00 
f0103256:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010325d:	e8 de cd ff ff       	call   f0100040 <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0103262:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103268:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f010326b:	77 91                	ja     f01031fe <mem_init+0x1965>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f010326d:	8b 1d 4c 42 2c f0    	mov    0xf02c424c,%ebx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103273:	89 de                	mov    %ebx,%esi
f0103275:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f010327a:	89 f8                	mov    %edi,%eax
f010327c:	e8 7b dd ff ff       	call   f0100ffc <check_va2pa>
f0103281:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0103287:	77 20                	ja     f01032a9 <mem_init+0x1a10>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103289:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010328d:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103294:	f0 
f0103295:	c7 44 24 04 54 03 00 	movl   $0x354,0x4(%esp)
f010329c:	00 
f010329d:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01032a4:	e8 97 cd ff ff       	call   f0100040 <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01032a9:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f01032ae:	81 c6 00 00 40 21    	add    $0x21400000,%esi
f01032b4:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f01032b7:	39 d0                	cmp    %edx,%eax
f01032b9:	74 24                	je     f01032df <mem_init+0x1a46>
f01032bb:	c7 44 24 0c 90 94 10 	movl   $0xf0109490,0xc(%esp)
f01032c2:	f0 
f01032c3:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01032ca:	f0 
f01032cb:	c7 44 24 04 54 03 00 	movl   $0x354,0x4(%esp)
f01032d2:	00 
f01032d3:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01032da:	e8 61 cd ff ff       	call   f0100040 <_panic>
f01032df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01032e5:	81 fb 00 10 c2 ee    	cmp    $0xeec21000,%ebx
f01032eb:	0f 85 a8 05 00 00    	jne    f0103899 <mem_init+0x2000>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01032f1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01032f4:	c1 e6 0c             	shl    $0xc,%esi
f01032f7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01032fc:	eb 3b                	jmp    f0103339 <mem_init+0x1aa0>
f01032fe:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0103304:	89 f8                	mov    %edi,%eax
f0103306:	e8 f1 dc ff ff       	call   f0100ffc <check_va2pa>
f010330b:	39 c3                	cmp    %eax,%ebx
f010330d:	74 24                	je     f0103333 <mem_init+0x1a9a>
f010330f:	c7 44 24 0c c4 94 10 	movl   $0xf01094c4,0xc(%esp)
f0103316:	f0 
f0103317:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010331e:	f0 
f010331f:	c7 44 24 04 58 03 00 	movl   $0x358,0x4(%esp)
f0103326:	00 
f0103327:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010332e:	e8 0d cd ff ff       	call   f0100040 <_panic>
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103333:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103339:	39 f3                	cmp    %esi,%ebx
f010333b:	72 c1                	jb     f01032fe <mem_init+0x1a65>
f010333d:	c7 45 d0 00 60 2c f0 	movl   $0xf02c6000,-0x30(%ebp)
f0103344:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010334b:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0103350:	b8 00 60 2c f0       	mov    $0xf02c6000,%eax
f0103355:	05 00 80 00 20       	add    $0x20008000,%eax
f010335a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f010335d:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0103363:	89 45 cc             	mov    %eax,-0x34(%ebp)
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103366:	89 f2                	mov    %esi,%edx
f0103368:	89 f8                	mov    %edi,%eax
f010336a:	e8 8d dc ff ff       	call   f0100ffc <check_va2pa>
f010336f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0103372:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0103378:	77 20                	ja     f010339a <mem_init+0x1b01>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010337a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f010337e:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103385:	f0 
f0103386:	c7 44 24 04 60 03 00 	movl   $0x360,0x4(%esp)
f010338d:	00 
f010338e:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103395:	e8 a6 cc ff ff       	call   f0100040 <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010339a:	89 f3                	mov    %esi,%ebx
f010339c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f010339f:	03 4d d4             	add    -0x2c(%ebp),%ecx
f01033a2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f01033a5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01033a8:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f01033ab:	39 c2                	cmp    %eax,%edx
f01033ad:	74 24                	je     f01033d3 <mem_init+0x1b3a>
f01033af:	c7 44 24 0c ec 94 10 	movl   $0xf01094ec,0xc(%esp)
f01033b6:	f0 
f01033b7:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01033be:	f0 
f01033bf:	c7 44 24 04 60 03 00 	movl   $0x360,0x4(%esp)
f01033c6:	00 
f01033c7:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01033ce:	e8 6d cc ff ff       	call   f0100040 <_panic>
f01033d3:	81 c3 00 10 00 00    	add    $0x1000,%ebx

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01033d9:	3b 5d cc             	cmp    -0x34(%ebp),%ebx
f01033dc:	0f 85 a9 04 00 00    	jne    f010388b <mem_init+0x1ff2>
f01033e2:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f01033e8:	89 da                	mov    %ebx,%edx
f01033ea:	89 f8                	mov    %edi,%eax
f01033ec:	e8 0b dc ff ff       	call   f0100ffc <check_va2pa>
f01033f1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01033f4:	74 24                	je     f010341a <mem_init+0x1b81>
f01033f6:	c7 44 24 0c 34 95 10 	movl   $0xf0109534,0xc(%esp)
f01033fd:	f0 
f01033fe:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0103405:	f0 
f0103406:	c7 44 24 04 62 03 00 	movl   $0x362,0x4(%esp)
f010340d:	00 
f010340e:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103415:	e8 26 cc ff ff       	call   f0100040 <_panic>
f010341a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0103420:	39 de                	cmp    %ebx,%esi
f0103422:	75 c4                	jne    f01033e8 <mem_init+0x1b4f>
f0103424:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f010342a:	81 45 d4 00 80 01 00 	addl   $0x18000,-0x2c(%ebp)
f0103431:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f0103438:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f010343e:	0f 85 19 ff ff ff    	jne    f010335d <mem_init+0x1ac4>
f0103444:	b8 00 00 00 00       	mov    $0x0,%eax
f0103449:	e9 c2 00 00 00       	jmp    f0103510 <mem_init+0x1c77>
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f010344e:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0103454:	83 fa 04             	cmp    $0x4,%edx
f0103457:	77 2e                	ja     f0103487 <mem_init+0x1bee>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
		case PDX(MMIOBASE):
			assert(pgdir[i] & PTE_P);
f0103459:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f010345d:	0f 85 aa 00 00 00    	jne    f010350d <mem_init+0x1c74>
f0103463:	c7 44 24 0c 9d 8c 10 	movl   $0xf0108c9d,0xc(%esp)
f010346a:	f0 
f010346b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0103472:	f0 
f0103473:	c7 44 24 04 6d 03 00 	movl   $0x36d,0x4(%esp)
f010347a:	00 
f010347b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103482:	e8 b9 cb ff ff       	call   f0100040 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f0103487:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f010348c:	76 55                	jbe    f01034e3 <mem_init+0x1c4a>
				assert(pgdir[i] & PTE_P);
f010348e:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0103491:	f6 c2 01             	test   $0x1,%dl
f0103494:	75 24                	jne    f01034ba <mem_init+0x1c21>
f0103496:	c7 44 24 0c 9d 8c 10 	movl   $0xf0108c9d,0xc(%esp)
f010349d:	f0 
f010349e:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01034a5:	f0 
f01034a6:	c7 44 24 04 71 03 00 	movl   $0x371,0x4(%esp)
f01034ad:	00 
f01034ae:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01034b5:	e8 86 cb ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f01034ba:	f6 c2 02             	test   $0x2,%dl
f01034bd:	75 4e                	jne    f010350d <mem_init+0x1c74>
f01034bf:	c7 44 24 0c ae 8c 10 	movl   $0xf0108cae,0xc(%esp)
f01034c6:	f0 
f01034c7:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01034ce:	f0 
f01034cf:	c7 44 24 04 72 03 00 	movl   $0x372,0x4(%esp)
f01034d6:	00 
f01034d7:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01034de:	e8 5d cb ff ff       	call   f0100040 <_panic>
			} else
				assert(pgdir[i] == 0);
f01034e3:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f01034e7:	74 24                	je     f010350d <mem_init+0x1c74>
f01034e9:	c7 44 24 0c bf 8c 10 	movl   $0xf0108cbf,0xc(%esp)
f01034f0:	f0 
f01034f1:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01034f8:	f0 
f01034f9:	c7 44 24 04 74 03 00 	movl   $0x374,0x4(%esp)
f0103500:	00 
f0103501:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103508:	e8 33 cb ff ff       	call   f0100040 <_panic>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f010350d:	83 c0 01             	add    $0x1,%eax
f0103510:	3d 00 04 00 00       	cmp    $0x400,%eax
f0103515:	0f 85 33 ff ff ff    	jne    f010344e <mem_init+0x1bb5>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f010351b:	c7 04 24 58 95 10 f0 	movl   $0xf0109558,(%esp)
f0103522:	e8 af 0d 00 00       	call   f01042d6 <cprintf>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f0103527:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f010352c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103531:	77 20                	ja     f0103553 <mem_init+0x1cba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103533:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103537:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f010353e:	f0 
f010353f:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
f0103546:	00 
f0103547:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010354e:	e8 ed ca ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103553:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103558:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f010355b:	b8 00 00 00 00       	mov    $0x0,%eax
f0103560:	e8 06 db ff ff       	call   f010106b <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0103565:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
	cr0 &= ~(CR0_TS|CR0_EM);
f0103568:	83 e0 f3             	and    $0xfffffff3,%eax
f010356b:	0d 23 00 05 80       	or     $0x80050023,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0103570:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103573:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010357a:	e8 16 df ff ff       	call   f0101495 <page_alloc>
f010357f:	89 c3                	mov    %eax,%ebx
f0103581:	85 c0                	test   %eax,%eax
f0103583:	75 24                	jne    f01035a9 <mem_init+0x1d10>
f0103585:	c7 44 24 0c a9 8a 10 	movl   $0xf0108aa9,0xc(%esp)
f010358c:	f0 
f010358d:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0103594:	f0 
f0103595:	c7 44 24 04 4c 04 00 	movl   $0x44c,0x4(%esp)
f010359c:	00 
f010359d:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01035a4:	e8 97 ca ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01035a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01035b0:	e8 e0 de ff ff       	call   f0101495 <page_alloc>
f01035b5:	89 c7                	mov    %eax,%edi
f01035b7:	85 c0                	test   %eax,%eax
f01035b9:	75 24                	jne    f01035df <mem_init+0x1d46>
f01035bb:	c7 44 24 0c bf 8a 10 	movl   $0xf0108abf,0xc(%esp)
f01035c2:	f0 
f01035c3:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01035ca:	f0 
f01035cb:	c7 44 24 04 4d 04 00 	movl   $0x44d,0x4(%esp)
f01035d2:	00 
f01035d3:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01035da:	e8 61 ca ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01035df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01035e6:	e8 aa de ff ff       	call   f0101495 <page_alloc>
f01035eb:	89 c6                	mov    %eax,%esi
f01035ed:	85 c0                	test   %eax,%eax
f01035ef:	75 24                	jne    f0103615 <mem_init+0x1d7c>
f01035f1:	c7 44 24 0c d5 8a 10 	movl   $0xf0108ad5,0xc(%esp)
f01035f8:	f0 
f01035f9:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0103600:	f0 
f0103601:	c7 44 24 04 4e 04 00 	movl   $0x44e,0x4(%esp)
f0103608:	00 
f0103609:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103610:	e8 2b ca ff ff       	call   f0100040 <_panic>
	page_free(pp0);
f0103615:	89 1c 24             	mov    %ebx,(%esp)
f0103618:	e8 03 df ff ff       	call   f0101520 <page_free>
	memset(page2kva(pp1), 1, PGSIZE);
f010361d:	89 f8                	mov    %edi,%eax
f010361f:	e8 93 d9 ff ff       	call   f0100fb7 <page2kva>
f0103624:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010362b:	00 
f010362c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0103633:	00 
f0103634:	89 04 24             	mov    %eax,(%esp)
f0103637:	e8 9b 32 00 00       	call   f01068d7 <memset>
	memset(page2kva(pp2), 2, PGSIZE);
f010363c:	89 f0                	mov    %esi,%eax
f010363e:	e8 74 d9 ff ff       	call   f0100fb7 <page2kva>
f0103643:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010364a:	00 
f010364b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f0103652:	00 
f0103653:	89 04 24             	mov    %eax,(%esp)
f0103656:	e8 7c 32 00 00       	call   f01068d7 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f010365b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0103662:	00 
f0103663:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010366a:	00 
f010366b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010366f:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0103674:	89 04 24             	mov    %eax,(%esp)
f0103677:	e8 3f e1 ff ff       	call   f01017bb <page_insert>
	assert(pp1->pp_ref == 1);
f010367c:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103681:	74 24                	je     f01036a7 <mem_init+0x1e0e>
f0103683:	c7 44 24 0c a6 8b 10 	movl   $0xf0108ba6,0xc(%esp)
f010368a:	f0 
f010368b:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0103692:	f0 
f0103693:	c7 44 24 04 53 04 00 	movl   $0x453,0x4(%esp)
f010369a:	00 
f010369b:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01036a2:	e8 99 c9 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01036a7:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f01036ae:	01 01 01 
f01036b1:	74 24                	je     f01036d7 <mem_init+0x1e3e>
f01036b3:	c7 44 24 0c 78 95 10 	movl   $0xf0109578,0xc(%esp)
f01036ba:	f0 
f01036bb:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01036c2:	f0 
f01036c3:	c7 44 24 04 54 04 00 	movl   $0x454,0x4(%esp)
f01036ca:	00 
f01036cb:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01036d2:	e8 69 c9 ff ff       	call   f0100040 <_panic>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f01036d7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01036de:	00 
f01036df:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01036e6:	00 
f01036e7:	89 74 24 04          	mov    %esi,0x4(%esp)
f01036eb:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f01036f0:	89 04 24             	mov    %eax,(%esp)
f01036f3:	e8 c3 e0 ff ff       	call   f01017bb <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01036f8:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f01036ff:	02 02 02 
f0103702:	74 24                	je     f0103728 <mem_init+0x1e8f>
f0103704:	c7 44 24 0c 9c 95 10 	movl   $0xf010959c,0xc(%esp)
f010370b:	f0 
f010370c:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0103713:	f0 
f0103714:	c7 44 24 04 56 04 00 	movl   $0x456,0x4(%esp)
f010371b:	00 
f010371c:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103723:	e8 18 c9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0103728:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010372d:	74 24                	je     f0103753 <mem_init+0x1eba>
f010372f:	c7 44 24 0c c8 8b 10 	movl   $0xf0108bc8,0xc(%esp)
f0103736:	f0 
f0103737:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010373e:	f0 
f010373f:	c7 44 24 04 57 04 00 	movl   $0x457,0x4(%esp)
f0103746:	00 
f0103747:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010374e:	e8 ed c8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0103753:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103758:	74 24                	je     f010377e <mem_init+0x1ee5>
f010375a:	c7 44 24 0c 32 8c 10 	movl   $0xf0108c32,0xc(%esp)
f0103761:	f0 
f0103762:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0103769:	f0 
f010376a:	c7 44 24 04 58 04 00 	movl   $0x458,0x4(%esp)
f0103771:	00 
f0103772:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103779:	e8 c2 c8 ff ff       	call   f0100040 <_panic>
	*(uint32_t *)PGSIZE = 0x03030303U;
f010377e:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0103785:	03 03 03 
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103788:	89 f0                	mov    %esi,%eax
f010378a:	e8 28 d8 ff ff       	call   f0100fb7 <page2kva>
f010378f:	81 38 03 03 03 03    	cmpl   $0x3030303,(%eax)
f0103795:	74 24                	je     f01037bb <mem_init+0x1f22>
f0103797:	c7 44 24 0c c0 95 10 	movl   $0xf01095c0,0xc(%esp)
f010379e:	f0 
f010379f:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01037a6:	f0 
f01037a7:	c7 44 24 04 5a 04 00 	movl   $0x45a,0x4(%esp)
f01037ae:	00 
f01037af:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01037b6:	e8 85 c8 ff ff       	call   f0100040 <_panic>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01037bb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01037c2:	00 
f01037c3:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f01037c8:	89 04 24             	mov    %eax,(%esp)
f01037cb:	e8 94 df ff ff       	call   f0101764 <page_remove>
	assert(pp2->pp_ref == 0);
f01037d0:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01037d5:	74 24                	je     f01037fb <mem_init+0x1f62>
f01037d7:	c7 44 24 0c 00 8c 10 	movl   $0xf0108c00,0xc(%esp)
f01037de:	f0 
f01037df:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01037e6:	f0 
f01037e7:	c7 44 24 04 5c 04 00 	movl   $0x45c,0x4(%esp)
f01037ee:	00 
f01037ef:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f01037f6:	e8 45 c8 ff ff       	call   f0100040 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01037fb:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
f0103800:	8b 08                	mov    (%eax),%ecx
f0103802:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103808:	89 da                	mov    %ebx,%edx
f010380a:	2b 15 9c 4e 2c f0    	sub    0xf02c4e9c,%edx
f0103810:	c1 fa 03             	sar    $0x3,%edx
f0103813:	c1 e2 0c             	shl    $0xc,%edx
f0103816:	39 d1                	cmp    %edx,%ecx
f0103818:	74 24                	je     f010383e <mem_init+0x1fa5>
f010381a:	c7 44 24 0c 48 8f 10 	movl   $0xf0108f48,0xc(%esp)
f0103821:	f0 
f0103822:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0103829:	f0 
f010382a:	c7 44 24 04 5f 04 00 	movl   $0x45f,0x4(%esp)
f0103831:	00 
f0103832:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f0103839:	e8 02 c8 ff ff       	call   f0100040 <_panic>
	kern_pgdir[0] = 0;
f010383e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0103844:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103849:	74 24                	je     f010386f <mem_init+0x1fd6>
f010384b:	c7 44 24 0c b7 8b 10 	movl   $0xf0108bb7,0xc(%esp)
f0103852:	f0 
f0103853:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010385a:	f0 
f010385b:	c7 44 24 04 61 04 00 	movl   $0x461,0x4(%esp)
f0103862:	00 
f0103863:	c7 04 24 bb 89 10 f0 	movl   $0xf01089bb,(%esp)
f010386a:	e8 d1 c7 ff ff       	call   f0100040 <_panic>
	pp0->pp_ref = 0;
f010386f:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f0103875:	89 1c 24             	mov    %ebx,(%esp)
f0103878:	e8 a3 dc ff ff       	call   f0101520 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f010387d:	c7 04 24 ec 95 10 f0 	movl   $0xf01095ec,(%esp)
f0103884:	e8 4d 0a 00 00       	call   f01042d6 <cprintf>
f0103889:	eb 1c                	jmp    f01038a7 <mem_init+0x200e>
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f010388b:	89 da                	mov    %ebx,%edx
f010388d:	89 f8                	mov    %edi,%eax
f010388f:	e8 68 d7 ff ff       	call   f0100ffc <check_va2pa>
f0103894:	e9 0c fb ff ff       	jmp    f01033a5 <mem_init+0x1b0c>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0103899:	89 da                	mov    %ebx,%edx
f010389b:	89 f8                	mov    %edi,%eax
f010389d:	e8 5a d7 ff ff       	call   f0100ffc <check_va2pa>
f01038a2:	e9 0d fa ff ff       	jmp    f01032b4 <mem_init+0x1a1b>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f01038a7:	83 c4 4c             	add    $0x4c,%esp
f01038aa:	5b                   	pop    %ebx
f01038ab:	5e                   	pop    %esi
f01038ac:	5f                   	pop    %edi
f01038ad:	5d                   	pop    %ebp
f01038ae:	c3                   	ret    

f01038af <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f01038af:	55                   	push   %ebp
f01038b0:	89 e5                	mov    %esp,%ebp
f01038b2:	57                   	push   %edi
f01038b3:	56                   	push   %esi
f01038b4:	53                   	push   %ebx
f01038b5:	83 ec 1c             	sub    $0x1c,%esp
f01038b8:	8b 7d 08             	mov    0x8(%ebp),%edi
f01038bb:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 3: Your code here.
	uint32_t i;
	for (i = (uint32_t) ROUNDDOWN(va, PGSIZE); i < (uint32_t) ROUNDUP(va+len, PGSIZE); i+=PGSIZE) {
f01038be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01038c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01038c7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01038ca:	03 45 10             	add    0x10(%ebp),%eax
f01038cd:	05 ff 0f 00 00       	add    $0xfff,%eax
f01038d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01038d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01038da:	eb 4b                	jmp    f0103927 <user_mem_check+0x78>
		pte_t *pte = pgdir_walk(env->env_pgdir, (void*)i, 0);
f01038dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01038e3:	00 
f01038e4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01038e8:	8b 47 60             	mov    0x60(%edi),%eax
f01038eb:	89 04 24             	mov    %eax,(%esp)
f01038ee:	e8 ac dc ff ff       	call   f010159f <pgdir_walk>

		if ((i>=ULIM) || !pte || ((*pte & perm) != perm) || !(*pte & PTE_P)) {
f01038f3:	85 c0                	test   %eax,%eax
f01038f5:	74 16                	je     f010390d <user_mem_check+0x5e>
f01038f7:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f01038fd:	77 0e                	ja     f010390d <user_mem_check+0x5e>
f01038ff:	8b 00                	mov    (%eax),%eax
f0103901:	89 c2                	mov    %eax,%edx
f0103903:	21 f2                	and    %esi,%edx
f0103905:	39 d6                	cmp    %edx,%esi
f0103907:	75 04                	jne    f010390d <user_mem_check+0x5e>
f0103909:	a8 01                	test   $0x1,%al
f010390b:	75 14                	jne    f0103921 <user_mem_check+0x72>
f010390d:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0103910:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
			user_mem_check_addr = (i<(uint32_t)va?(uint32_t)va:i);
f0103914:	89 1d 40 42 2c f0    	mov    %ebx,0xf02c4240
			return -E_FAULT;
f010391a:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010391f:	eb 10                	jmp    f0103931 <user_mem_check+0x82>
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
	// LAB 3: Your code here.
	uint32_t i;
	for (i = (uint32_t) ROUNDDOWN(va, PGSIZE); i < (uint32_t) ROUNDUP(va+len, PGSIZE); i+=PGSIZE) {
f0103921:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103927:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010392a:	72 b0                	jb     f01038dc <user_mem_check+0x2d>
		if ((i>=ULIM) || !pte || ((*pte & perm) != perm) || !(*pte & PTE_P)) {
			user_mem_check_addr = (i<(uint32_t)va?(uint32_t)va:i);
			return -E_FAULT;
		}
	}
	return 0;
f010392c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103931:	83 c4 1c             	add    $0x1c,%esp
f0103934:	5b                   	pop    %ebx
f0103935:	5e                   	pop    %esi
f0103936:	5f                   	pop    %edi
f0103937:	5d                   	pop    %ebp
f0103938:	c3                   	ret    

f0103939 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0103939:	55                   	push   %ebp
f010393a:	89 e5                	mov    %esp,%ebp
f010393c:	53                   	push   %ebx
f010393d:	83 ec 14             	sub    $0x14,%esp
f0103940:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103943:	8b 45 14             	mov    0x14(%ebp),%eax
f0103946:	83 c8 04             	or     $0x4,%eax
f0103949:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010394d:	8b 45 10             	mov    0x10(%ebp),%eax
f0103950:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103954:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103957:	89 44 24 04          	mov    %eax,0x4(%esp)
f010395b:	89 1c 24             	mov    %ebx,(%esp)
f010395e:	e8 4c ff ff ff       	call   f01038af <user_mem_check>
f0103963:	85 c0                	test   %eax,%eax
f0103965:	79 24                	jns    f010398b <user_mem_assert+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
f0103967:	a1 40 42 2c f0       	mov    0xf02c4240,%eax
f010396c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103970:	8b 43 48             	mov    0x48(%ebx),%eax
f0103973:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103977:	c7 04 24 18 96 10 f0 	movl   $0xf0109618,(%esp)
f010397e:	e8 53 09 00 00       	call   f01042d6 <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0103983:	89 1c 24             	mov    %ebx,(%esp)
f0103986:	e8 2d 06 00 00       	call   f0103fb8 <env_destroy>
	}
}
f010398b:	83 c4 14             	add    $0x14,%esp
f010398e:	5b                   	pop    %ebx
f010398f:	5d                   	pop    %ebp
f0103990:	c3                   	ret    

f0103991 <region_alloc>:
// Does not zero or otherwise initialize the mapped pages in any way.
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len) {
f0103991:	55                   	push   %ebp
f0103992:	89 e5                	mov    %esp,%ebp
f0103994:	57                   	push   %edi
f0103995:	56                   	push   %esi
f0103996:	53                   	push   %ebx
f0103997:	83 ec 1c             	sub    $0x1c,%esp
f010399a:	89 c7                	mov    %eax,%edi
    // Hint: It is easier to use region_alloc if the caller can pass
    //   'va' and 'len' values that are not page-aligned.
    //   You should round va down, and round (va + len) up.
    //   (Watch out for corner-cases!)
	void *start;
    for (start = ROUNDDOWN(va, PGSIZE); start < ROUNDUP(va + len, PGSIZE); start += PGSIZE) {
f010399c:	89 d3                	mov    %edx,%ebx
f010399e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01039a4:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01039ab:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01039b1:	eb 4d                	jmp    f0103a00 <region_alloc+0x6f>
        struct PageInfo *p_i = page_alloc(0);
f01039b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01039ba:	e8 d6 da ff ff       	call   f0101495 <page_alloc>
        if (!p_i) {
f01039bf:	85 c0                	test   %eax,%eax
f01039c1:	75 1c                	jne    f01039df <region_alloc+0x4e>
            panic("region_alloc allocation failed!");
f01039c3:	c7 44 24 08 50 96 10 	movl   $0xf0109650,0x8(%esp)
f01039ca:	f0 
f01039cb:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
f01039d2:	00 
f01039d3:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f01039da:	e8 61 c6 ff ff       	call   f0100040 <_panic>
        }
        page_insert(e->env_pgdir, p_i, start, PTE_W | PTE_U);
f01039df:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f01039e6:	00 
f01039e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01039eb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039ef:	8b 47 60             	mov    0x60(%edi),%eax
f01039f2:	89 04 24             	mov    %eax,(%esp)
f01039f5:	e8 c1 dd ff ff       	call   f01017bb <page_insert>
    // Hint: It is easier to use region_alloc if the caller can pass
    //   'va' and 'len' values that are not page-aligned.
    //   You should round va down, and round (va + len) up.
    //   (Watch out for corner-cases!)
	void *start;
    for (start = ROUNDDOWN(va, PGSIZE); start < ROUNDUP(va + len, PGSIZE); start += PGSIZE) {
f01039fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103a00:	39 f3                	cmp    %esi,%ebx
f0103a02:	72 af                	jb     f01039b3 <region_alloc+0x22>
        if (!p_i) {
            panic("region_alloc allocation failed!");
        }
        page_insert(e->env_pgdir, p_i, start, PTE_W | PTE_U);
    }
}
f0103a04:	83 c4 1c             	add    $0x1c,%esp
f0103a07:	5b                   	pop    %ebx
f0103a08:	5e                   	pop    %esi
f0103a09:	5f                   	pop    %edi
f0103a0a:	5d                   	pop    %ebp
f0103a0b:	c3                   	ret    

f0103a0c <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103a0c:	55                   	push   %ebp
f0103a0d:	89 e5                	mov    %esp,%ebp
f0103a0f:	56                   	push   %esi
f0103a10:	53                   	push   %ebx
f0103a11:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103a17:	85 c0                	test   %eax,%eax
f0103a19:	75 1a                	jne    f0103a35 <envid2env+0x29>
		*env_store = curenv;
f0103a1b:	e8 09 35 00 00       	call   f0106f29 <cpunum>
f0103a20:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a23:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0103a29:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103a2c:	89 06                	mov    %eax,(%esi)
		return 0;
f0103a2e:	b8 00 00 00 00       	mov    $0x0,%eax
f0103a33:	eb 75                	jmp    f0103aaa <envid2env+0x9e>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0103a35:	89 c2                	mov    %eax,%edx
f0103a37:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0103a3d:	89 d3                	mov    %edx,%ebx
f0103a3f:	c1 e3 07             	shl    $0x7,%ebx
f0103a42:	8d 1c 93             	lea    (%ebx,%edx,4),%ebx
f0103a45:	03 1d 4c 42 2c f0    	add    0xf02c424c,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103a4b:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103a4f:	74 05                	je     f0103a56 <envid2env+0x4a>
f0103a51:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103a54:	74 10                	je     f0103a66 <envid2env+0x5a>
		*env_store = 0;
f0103a56:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103a5f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103a64:	eb 44                	jmp    f0103aaa <envid2env+0x9e>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103a66:	84 c9                	test   %cl,%cl
f0103a68:	74 36                	je     f0103aa0 <envid2env+0x94>
f0103a6a:	e8 ba 34 00 00       	call   f0106f29 <cpunum>
f0103a6f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a72:	39 98 28 50 2c f0    	cmp    %ebx,-0xfd3afd8(%eax)
f0103a78:	74 26                	je     f0103aa0 <envid2env+0x94>
f0103a7a:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103a7d:	e8 a7 34 00 00       	call   f0106f29 <cpunum>
f0103a82:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a85:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0103a8b:	3b 70 48             	cmp    0x48(%eax),%esi
f0103a8e:	74 10                	je     f0103aa0 <envid2env+0x94>
		*env_store = 0;
f0103a90:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103a93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103a99:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103a9e:	eb 0a                	jmp    f0103aaa <envid2env+0x9e>
	}

	*env_store = e;
f0103aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103aa3:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103aaa:	5b                   	pop    %ebx
f0103aab:	5e                   	pop    %esi
f0103aac:	5d                   	pop    %ebp
f0103aad:	c3                   	ret    

f0103aae <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103aae:	55                   	push   %ebp
f0103aaf:	89 e5                	mov    %esp,%ebp
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f0103ab1:	b8 20 63 12 f0       	mov    $0xf0126320,%eax
f0103ab6:	0f 01 10             	lgdtl  (%eax)
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f0103ab9:	b8 23 00 00 00       	mov    $0x23,%eax
f0103abe:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0103ac0:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0103ac2:	b0 10                	mov    $0x10,%al
f0103ac4:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0103ac6:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0103ac8:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));
f0103aca:	ea d1 3a 10 f0 08 00 	ljmp   $0x8,$0xf0103ad1
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f0103ad1:	b0 00                	mov    $0x0,%al
f0103ad3:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f0103ad6:	5d                   	pop    %ebp
f0103ad7:	c3                   	ret    

f0103ad8 <env_init>:
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103ad8:	55                   	push   %ebp
f0103ad9:	89 e5                	mov    %esp,%ebp
f0103adb:	56                   	push   %esi
f0103adc:	53                   	push   %ebx

	// Per-CPU part of the initialization

	int i;
    for(i = NENV-1; i >= 0; i--){
        envs[i].env_id = 0;
f0103add:	8b 35 4c 42 2c f0    	mov    0xf02c424c,%esi
f0103ae3:	8b 0d 50 42 2c f0    	mov    0xf02c4250,%ecx
f0103ae9:	8d 86 7c 0f 02 00    	lea    0x20f7c(%esi),%eax
f0103aef:	ba 00 04 00 00       	mov    $0x400,%edx
f0103af4:	89 c3                	mov    %eax,%ebx
f0103af6:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
        envs[i].env_link = env_free_list;
f0103afd:	89 48 44             	mov    %ecx,0x44(%eax)
f0103b00:	2d 84 00 00 00       	sub    $0x84,%eax
	// LAB 3: Your code here.

	// Per-CPU part of the initialization

	int i;
    for(i = NENV-1; i >= 0; i--){
f0103b05:	83 ea 01             	sub    $0x1,%edx
f0103b08:	74 04                	je     f0103b0e <env_init+0x36>
        envs[i].env_id = 0;
        envs[i].env_link = env_free_list;
        env_free_list = envs+i;
f0103b0a:	89 d9                	mov    %ebx,%ecx
f0103b0c:	eb e6                	jmp    f0103af4 <env_init+0x1c>
f0103b0e:	89 35 50 42 2c f0    	mov    %esi,0xf02c4250
    }

	env_init_percpu();
f0103b14:	e8 95 ff ff ff       	call   f0103aae <env_init_percpu>
}
f0103b19:	5b                   	pop    %ebx
f0103b1a:	5e                   	pop    %esi
f0103b1b:	5d                   	pop    %ebp
f0103b1c:	c3                   	ret    

f0103b1d <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103b1d:	55                   	push   %ebp
f0103b1e:	89 e5                	mov    %esp,%ebp
f0103b20:	53                   	push   %ebx
f0103b21:	83 ec 14             	sub    $0x14,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f0103b24:	8b 1d 50 42 2c f0    	mov    0xf02c4250,%ebx
f0103b2a:	85 db                	test   %ebx,%ebx
f0103b2c:	0f 84 61 01 00 00    	je     f0103c93 <env_alloc+0x176>
{
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103b32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103b39:	e8 57 d9 ff ff       	call   f0101495 <page_alloc>
f0103b3e:	85 c0                	test   %eax,%eax
f0103b40:	0f 84 54 01 00 00    	je     f0103c9a <env_alloc+0x17d>
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.

    p->pp_ref++;
f0103b46:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
f0103b4b:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f0103b51:	c1 f8 03             	sar    $0x3,%eax
f0103b54:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103b57:	89 c2                	mov    %eax,%edx
f0103b59:	c1 ea 0c             	shr    $0xc,%edx
f0103b5c:	3b 15 94 4e 2c f0    	cmp    0xf02c4e94,%edx
f0103b62:	72 20                	jb     f0103b84 <env_alloc+0x67>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103b64:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103b68:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0103b6f:	f0 
f0103b70:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103b77:	00 
f0103b78:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0103b7f:	e8 bc c4 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0103b84:	2d 00 00 00 10       	sub    $0x10000000,%eax
    e->env_pgdir = (pde_t *) page2kva(p);
f0103b89:	89 43 60             	mov    %eax,0x60(%ebx)
    memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0103b8c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103b93:	00 
f0103b94:	8b 15 98 4e 2c f0    	mov    0xf02c4e98,%edx
f0103b9a:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103b9e:	89 04 24             	mov    %eax,(%esp)
f0103ba1:	e8 e6 2d 00 00       	call   f010698c <memcpy>

	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103ba6:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103ba9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103bae:	77 20                	ja     f0103bd0 <env_alloc+0xb3>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103bb0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103bb4:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103bbb:	f0 
f0103bbc:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
f0103bc3:	00 
f0103bc4:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0103bcb:	e8 70 c4 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103bd0:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103bd6:	83 ca 05             	or     $0x5,%edx
f0103bd9:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103bdf:	8b 43 48             	mov    0x48(%ebx),%eax
f0103be2:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103be7:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103bec:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103bf1:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103bf4:	89 da                	mov    %ebx,%edx
f0103bf6:	2b 15 4c 42 2c f0    	sub    0xf02c424c,%edx
f0103bfc:	c1 fa 02             	sar    $0x2,%edx
f0103bff:	69 d2 e1 83 0f 3e    	imul   $0x3e0f83e1,%edx,%edx
f0103c05:	09 d0                	or     %edx,%eax
f0103c07:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c0d:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103c10:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103c17:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103c1e:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->pri = 100;
f0103c25:	c7 43 7c 64 00 00 00 	movl   $0x64,0x7c(%ebx)
	e->channel = 0;
f0103c2c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
f0103c33:	00 00 00 

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103c36:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0103c3d:	00 
f0103c3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103c45:	00 
f0103c46:	89 1c 24             	mov    %ebx,(%esp)
f0103c49:	e8 89 2c 00 00       	call   f01068d7 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f0103c4e:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103c54:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103c5a:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103c60:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103c67:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags |= FL_IF;
f0103c6d:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)

	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0103c74:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0103c7b:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f0103c7f:	8b 43 44             	mov    0x44(%ebx),%eax
f0103c82:	a3 50 42 2c f0       	mov    %eax,0xf02c4250
	*newenv_store = e;
f0103c87:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c8a:	89 18                	mov    %ebx,(%eax)

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
f0103c8c:	b8 00 00 00 00       	mov    $0x0,%eax
f0103c91:	eb 0c                	jmp    f0103c9f <env_alloc+0x182>
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
		return -E_NO_FREE_ENV;
f0103c93:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103c98:	eb 05                	jmp    f0103c9f <env_alloc+0x182>
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;
f0103c9a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	env_free_list = e->env_link;
	*newenv_store = e;

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
}
f0103c9f:	83 c4 14             	add    $0x14,%esp
f0103ca2:	5b                   	pop    %ebx
f0103ca3:	5d                   	pop    %ebp
f0103ca4:	c3                   	ret    

f0103ca5 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103ca5:	55                   	push   %ebp
f0103ca6:	89 e5                	mov    %esp,%ebp
f0103ca8:	57                   	push   %edi
f0103ca9:	56                   	push   %esi
f0103caa:	53                   	push   %ebx
f0103cab:	83 ec 3c             	sub    $0x3c,%esp
f0103cae:	8b 7d 08             	mov    0x8(%ebp),%edi
	// LAB 3: Your code here.

	struct Env *p_env;
	env_alloc(&p_env, 0);
f0103cb1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103cb8:	00 
f0103cb9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103cbc:	89 04 24             	mov    %eax,(%esp)
f0103cbf:	e8 59 fe ff ff       	call   f0103b1d <env_alloc>
	load_icode(p_env, binary);
f0103cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103cc7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // LAB 3: Your code here.
    struct Elf *E_H = (struct Elf *) binary;
    struct Proghdr *p_h, *e_p_h;

    if (E_H->e_magic != ELF_MAGIC)
f0103cca:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f0103cd0:	74 1c                	je     f0103cee <env_create+0x49>
        panic("Not executable!");
f0103cd2:	c7 44 24 08 7b 96 10 	movl   $0xf010967b,0x8(%esp)
f0103cd9:	f0 
f0103cda:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
f0103ce1:	00 
f0103ce2:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0103ce9:	e8 52 c3 ff ff       	call   f0100040 <_panic>

    p_h = (struct Proghdr *) ((uint8_t *) E_H + E_H->e_phoff);
f0103cee:	89 fb                	mov    %edi,%ebx
f0103cf0:	03 5f 1c             	add    0x1c(%edi),%ebx
    e_p_h = p_h + E_H->e_phnum;
f0103cf3:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f0103cf7:	c1 e6 05             	shl    $0x5,%esi
f0103cfa:	01 de                	add    %ebx,%esi


    lcr3(PADDR(e->env_pgdir));
f0103cfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103cff:	8b 40 60             	mov    0x60(%eax),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103d02:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103d07:	77 20                	ja     f0103d29 <env_create+0x84>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103d09:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103d0d:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103d14:	f0 
f0103d15:	c7 44 24 04 71 01 00 	movl   $0x171,0x4(%esp)
f0103d1c:	00 
f0103d1d:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0103d24:	e8 17 c3 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103d29:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103d2e:	0f 22 d8             	mov    %eax,%cr3
f0103d31:	eb 4b                	jmp    f0103d7e <env_create+0xd9>


    for (; p_h < e_p_h; p_h++)
        if (p_h->p_type == ELF_PROG_LOAD) {
f0103d33:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103d36:	75 43                	jne    f0103d7b <env_create+0xd6>
            region_alloc(e, (void *) p_h->p_va, p_h->p_memsz);
f0103d38:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103d3b:	8b 53 08             	mov    0x8(%ebx),%edx
f0103d3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103d41:	e8 4b fc ff ff       	call   f0103991 <region_alloc>
            memset((void *) p_h->p_va, 0, p_h->p_memsz);
f0103d46:	8b 43 14             	mov    0x14(%ebx),%eax
f0103d49:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103d4d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103d54:	00 
f0103d55:	8b 43 08             	mov    0x8(%ebx),%eax
f0103d58:	89 04 24             	mov    %eax,(%esp)
f0103d5b:	e8 77 2b 00 00       	call   f01068d7 <memset>
            memcpy((void *) p_h->p_va, binary + p_h->p_offset, p_h->p_filesz);
f0103d60:	8b 43 10             	mov    0x10(%ebx),%eax
f0103d63:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103d67:	89 f8                	mov    %edi,%eax
f0103d69:	03 43 04             	add    0x4(%ebx),%eax
f0103d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103d70:	8b 43 08             	mov    0x8(%ebx),%eax
f0103d73:	89 04 24             	mov    %eax,(%esp)
f0103d76:	e8 11 2c 00 00       	call   f010698c <memcpy>


    lcr3(PADDR(e->env_pgdir));


    for (; p_h < e_p_h; p_h++)
f0103d7b:	83 c3 20             	add    $0x20,%ebx
f0103d7e:	39 de                	cmp    %ebx,%esi
f0103d80:	77 b1                	ja     f0103d33 <env_create+0x8e>
            region_alloc(e, (void *) p_h->p_va, p_h->p_memsz);
            memset((void *) p_h->p_va, 0, p_h->p_memsz);
            memcpy((void *) p_h->p_va, binary + p_h->p_offset, p_h->p_filesz);
        }

    lcr3(PADDR(kern_pgdir));
f0103d82:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103d87:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103d8c:	77 20                	ja     f0103dae <env_create+0x109>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103d8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103d92:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103d99:	f0 
f0103d9a:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
f0103da1:	00 
f0103da2:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0103da9:	e8 92 c2 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103dae:	05 00 00 00 10       	add    $0x10000000,%eax
f0103db3:	0f 22 d8             	mov    %eax,%cr3

    e->env_tf.tf_eip = E_H->e_entry;
f0103db6:	8b 47 18             	mov    0x18(%edi),%eax
f0103db9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0103dbc:	89 47 30             	mov    %eax,0x30(%edi)
    // Now map one page for the program's initial stack
    // at virtual address USTACKTOP - PGSIZE.

    // LAB 3: Your code here.

    region_alloc(e, (void *) (USTACKTOP - PGSIZE), PGSIZE);
f0103dbf:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103dc4:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103dc9:	89 f8                	mov    %edi,%eax
f0103dcb:	e8 c1 fb ff ff       	call   f0103991 <region_alloc>
	// LAB 3: Your code here.

	struct Env *p_env;
	env_alloc(&p_env, 0);
	load_icode(p_env, binary);
	p_env->env_type = type;
f0103dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103dd6:	89 48 50             	mov    %ecx,0x50(%eax)

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.

	if (type == ENV_TYPE_FS)
f0103dd9:	83 f9 01             	cmp    $0x1,%ecx
f0103ddc:	75 07                	jne    f0103de5 <env_create+0x140>
		p_env->env_tf.tf_eflags = p_env->env_tf.tf_eflags | FL_IOPL_3;
f0103dde:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
}
f0103de5:	83 c4 3c             	add    $0x3c,%esp
f0103de8:	5b                   	pop    %ebx
f0103de9:	5e                   	pop    %esi
f0103dea:	5f                   	pop    %edi
f0103deb:	5d                   	pop    %ebp
f0103dec:	c3                   	ret    

f0103ded <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103ded:	55                   	push   %ebp
f0103dee:	89 e5                	mov    %esp,%ebp
f0103df0:	57                   	push   %edi
f0103df1:	56                   	push   %esi
f0103df2:	53                   	push   %ebx
f0103df3:	83 ec 2c             	sub    $0x2c,%esp
f0103df6:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103df9:	e8 2b 31 00 00       	call   f0106f29 <cpunum>
f0103dfe:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e01:	39 b8 28 50 2c f0    	cmp    %edi,-0xfd3afd8(%eax)
f0103e07:	74 09                	je     f0103e12 <env_free+0x25>
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103e09:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103e10:	eb 36                	jmp    f0103e48 <env_free+0x5b>

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
		lcr3(PADDR(kern_pgdir));
f0103e12:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103e17:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103e1c:	77 20                	ja     f0103e3e <env_free+0x51>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103e22:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103e29:	f0 
f0103e2a:	c7 44 24 04 ad 01 00 	movl   $0x1ad,0x4(%esp)
f0103e31:	00 
f0103e32:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0103e39:	e8 02 c2 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103e3e:	05 00 00 00 10       	add    $0x10000000,%eax
f0103e43:	0f 22 d8             	mov    %eax,%cr3
f0103e46:	eb c1                	jmp    f0103e09 <env_free+0x1c>
f0103e48:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103e4b:	89 c8                	mov    %ecx,%eax
f0103e4d:	c1 e0 02             	shl    $0x2,%eax
f0103e50:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103e53:	8b 47 60             	mov    0x60(%edi),%eax
f0103e56:	8b 34 88             	mov    (%eax,%ecx,4),%esi
f0103e59:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103e5f:	0f 84 b7 00 00 00    	je     f0103f1c <env_free+0x12f>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103e65:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103e6b:	89 f0                	mov    %esi,%eax
f0103e6d:	c1 e8 0c             	shr    $0xc,%eax
f0103e70:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103e73:	3b 05 94 4e 2c f0    	cmp    0xf02c4e94,%eax
f0103e79:	72 20                	jb     f0103e9b <env_free+0xae>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103e7b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0103e7f:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0103e86:	f0 
f0103e87:	c7 44 24 04 bc 01 00 	movl   $0x1bc,0x4(%esp)
f0103e8e:	00 
f0103e8f:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0103e96:	e8 a5 c1 ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103e9e:	c1 e0 16             	shl    $0x16,%eax
f0103ea1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103ea4:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f0103ea9:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f0103eb0:	01 
f0103eb1:	74 17                	je     f0103eca <env_free+0xdd>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103eb3:	89 d8                	mov    %ebx,%eax
f0103eb5:	c1 e0 0c             	shl    $0xc,%eax
f0103eb8:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103ebb:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103ebf:	8b 47 60             	mov    0x60(%edi),%eax
f0103ec2:	89 04 24             	mov    %eax,(%esp)
f0103ec5:	e8 9a d8 ff ff       	call   f0101764 <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103eca:	83 c3 01             	add    $0x1,%ebx
f0103ecd:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103ed3:	75 d4                	jne    f0103ea9 <env_free+0xbc>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103ed5:	8b 47 60             	mov    0x60(%edi),%eax
f0103ed8:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103edb:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103ee2:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103ee5:	3b 05 94 4e 2c f0    	cmp    0xf02c4e94,%eax
f0103eeb:	72 1c                	jb     f0103f09 <env_free+0x11c>
		panic("pa2page called with invalid pa");
f0103eed:	c7 44 24 08 f4 8d 10 	movl   $0xf0108df4,0x8(%esp)
f0103ef4:	f0 
f0103ef5:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0103efc:	00 
f0103efd:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0103f04:	e8 37 c1 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0103f09:	a1 9c 4e 2c f0       	mov    0xf02c4e9c,%eax
f0103f0e:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103f11:	8d 04 d0             	lea    (%eax,%edx,8),%eax
		page_decref(pa2page(pa));
f0103f14:	89 04 24             	mov    %eax,(%esp)
f0103f17:	e8 60 d6 ff ff       	call   f010157c <page_decref>
	// Note the environment's demise.
	// cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103f1c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0103f20:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0103f27:	0f 85 1b ff ff ff    	jne    f0103e48 <env_free+0x5b>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103f2d:	8b 47 60             	mov    0x60(%edi),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103f30:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103f35:	77 20                	ja     f0103f57 <env_free+0x16a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103f37:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103f3b:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0103f42:	f0 
f0103f43:	c7 44 24 04 ca 01 00 	movl   $0x1ca,0x4(%esp)
f0103f4a:	00 
f0103f4b:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0103f52:	e8 e9 c0 ff ff       	call   f0100040 <_panic>
	e->env_pgdir = 0;
f0103f57:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103f5e:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103f63:	c1 e8 0c             	shr    $0xc,%eax
f0103f66:	3b 05 94 4e 2c f0    	cmp    0xf02c4e94,%eax
f0103f6c:	72 1c                	jb     f0103f8a <env_free+0x19d>
		panic("pa2page called with invalid pa");
f0103f6e:	c7 44 24 08 f4 8d 10 	movl   $0xf0108df4,0x8(%esp)
f0103f75:	f0 
f0103f76:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0103f7d:	00 
f0103f7e:	c7 04 24 c7 89 10 f0 	movl   $0xf01089c7,(%esp)
f0103f85:	e8 b6 c0 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0103f8a:	8b 15 9c 4e 2c f0    	mov    0xf02c4e9c,%edx
f0103f90:	8d 04 c2             	lea    (%edx,%eax,8),%eax
	page_decref(pa2page(pa));
f0103f93:	89 04 24             	mov    %eax,(%esp)
f0103f96:	e8 e1 d5 ff ff       	call   f010157c <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103f9b:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103fa2:	a1 50 42 2c f0       	mov    0xf02c4250,%eax
f0103fa7:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103faa:	89 3d 50 42 2c f0    	mov    %edi,0xf02c4250
}
f0103fb0:	83 c4 2c             	add    $0x2c,%esp
f0103fb3:	5b                   	pop    %ebx
f0103fb4:	5e                   	pop    %esi
f0103fb5:	5f                   	pop    %edi
f0103fb6:	5d                   	pop    %ebp
f0103fb7:	c3                   	ret    

f0103fb8 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103fb8:	55                   	push   %ebp
f0103fb9:	89 e5                	mov    %esp,%ebp
f0103fbb:	53                   	push   %ebx
f0103fbc:	83 ec 14             	sub    $0x14,%esp
f0103fbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103fc2:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103fc6:	75 19                	jne    f0103fe1 <env_destroy+0x29>
f0103fc8:	e8 5c 2f 00 00       	call   f0106f29 <cpunum>
f0103fcd:	6b c0 74             	imul   $0x74,%eax,%eax
f0103fd0:	39 98 28 50 2c f0    	cmp    %ebx,-0xfd3afd8(%eax)
f0103fd6:	74 09                	je     f0103fe1 <env_destroy+0x29>
		e->env_status = ENV_DYING;
f0103fd8:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103fdf:	eb 2f                	jmp    f0104010 <env_destroy+0x58>
	}

	env_free(e);
f0103fe1:	89 1c 24             	mov    %ebx,(%esp)
f0103fe4:	e8 04 fe ff ff       	call   f0103ded <env_free>

	if (curenv == e) {
f0103fe9:	e8 3b 2f 00 00       	call   f0106f29 <cpunum>
f0103fee:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ff1:	39 98 28 50 2c f0    	cmp    %ebx,-0xfd3afd8(%eax)
f0103ff7:	75 17                	jne    f0104010 <env_destroy+0x58>
		curenv = NULL;
f0103ff9:	e8 2b 2f 00 00       	call   f0106f29 <cpunum>
f0103ffe:	6b c0 74             	imul   $0x74,%eax,%eax
f0104001:	c7 80 28 50 2c f0 00 	movl   $0x0,-0xfd3afd8(%eax)
f0104008:	00 00 00 
		sched_yield();
f010400b:	e8 98 11 00 00       	call   f01051a8 <sched_yield>
	}
}
f0104010:	83 c4 14             	add    $0x14,%esp
f0104013:	5b                   	pop    %ebx
f0104014:	5d                   	pop    %ebp
f0104015:	c3                   	ret    

f0104016 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0104016:	55                   	push   %ebp
f0104017:	89 e5                	mov    %esp,%ebp
f0104019:	53                   	push   %ebx
f010401a:	83 ec 14             	sub    $0x14,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f010401d:	e8 07 2f 00 00       	call   f0106f29 <cpunum>
f0104022:	6b c0 74             	imul   $0x74,%eax,%eax
f0104025:	8b 98 28 50 2c f0    	mov    -0xfd3afd8(%eax),%ebx
f010402b:	e8 f9 2e 00 00       	call   f0106f29 <cpunum>
f0104030:	89 43 5c             	mov    %eax,0x5c(%ebx)

	__asm __volatile("movl %0,%%esp\n"
f0104033:	8b 65 08             	mov    0x8(%ebp),%esp
f0104036:	61                   	popa   
f0104037:	07                   	pop    %es
f0104038:	1f                   	pop    %ds
f0104039:	83 c4 08             	add    $0x8,%esp
f010403c:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f010403d:	c7 44 24 08 8b 96 10 	movl   $0xf010968b,0x8(%esp)
f0104044:	f0 
f0104045:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
f010404c:	00 
f010404d:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0104054:	e8 e7 bf ff ff       	call   f0100040 <_panic>

f0104059 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0104059:	55                   	push   %ebp
f010405a:	89 e5                	mov    %esp,%ebp
f010405c:	53                   	push   %ebx
f010405d:	83 ec 14             	sub    $0x14,%esp
f0104060:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.

    if (curenv && curenv->env_status == ENV_RUNNING){
f0104063:	e8 c1 2e 00 00       	call   f0106f29 <cpunum>
f0104068:	6b c0 74             	imul   $0x74,%eax,%eax
f010406b:	83 b8 28 50 2c f0 00 	cmpl   $0x0,-0xfd3afd8(%eax)
f0104072:	74 29                	je     f010409d <env_run+0x44>
f0104074:	e8 b0 2e 00 00       	call   f0106f29 <cpunum>
f0104079:	6b c0 74             	imul   $0x74,%eax,%eax
f010407c:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104082:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104086:	75 15                	jne    f010409d <env_run+0x44>
        curenv->env_status = ENV_RUNNABLE;
f0104088:	e8 9c 2e 00 00       	call   f0106f29 <cpunum>
f010408d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104090:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104096:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
    }
    curenv = e;
f010409d:	e8 87 2e 00 00       	call   f0106f29 <cpunum>
f01040a2:	6b c0 74             	imul   $0x74,%eax,%eax
f01040a5:	89 98 28 50 2c f0    	mov    %ebx,-0xfd3afd8(%eax)
    e->env_status = ENV_RUNNING;
f01040ab:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
    e->env_runs++;
f01040b2:	83 43 58 01          	addl   $0x1,0x58(%ebx)
    lcr3(PADDR(e->env_pgdir));
f01040b6:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01040b9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01040be:	77 20                	ja     f01040e0 <env_run+0x87>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01040c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01040c4:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f01040cb:	f0 
f01040cc:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
f01040d3:	00 
f01040d4:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f01040db:	e8 60 bf ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01040e0:	05 00 00 00 10       	add    $0x10000000,%eax
f01040e5:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01040e8:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f01040ef:	e8 5f 31 00 00       	call   f0107253 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01040f4:	f3 90                	pause  
    unlock_kernel();
    env_pop_tf(&e->env_tf);
f01040f6:	89 1c 24             	mov    %ebx,(%esp)
f01040f9:	e8 18 ff ff ff       	call   f0104016 <env_pop_tf>

f01040fe <sleep>:
}


int
sleep (enum EnvChannel channel) {
f01040fe:	55                   	push   %ebp
f01040ff:	89 e5                	mov    %esp,%ebp
f0104101:	83 ec 08             	sub    $0x8,%esp
	curenv->channel = channel;
f0104104:	e8 20 2e 00 00       	call   f0106f29 <cpunum>
f0104109:	6b c0 74             	imul   $0x74,%eax,%eax
f010410c:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104112:	8b 55 08             	mov    0x8(%ebp),%edx
f0104115:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	//curenv->env_status = ENV_NOT_RUNNABLE;
	return 0;
	//sched_yield();
}
f010411b:	b8 00 00 00 00       	mov    $0x0,%eax
f0104120:	c9                   	leave  
f0104121:	c3                   	ret    

f0104122 <wakeup>:

void
wakeup (enum EnvChannel channel) {
f0104122:	55                   	push   %ebp
f0104123:	89 e5                	mov    %esp,%ebp
f0104125:	53                   	push   %ebx
f0104126:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104129:	a1 4c 42 2c f0       	mov    0xf02c424c,%eax
f010412e:	83 c0 54             	add    $0x54,%eax
	int i;
	for(i = 0; i < NENV; i++){
        	if ((envs[i].env_status == ENV_NOT_RUNNABLE) && (envs[i].channel == channel)) {
f0104131:	ba 00 04 00 00       	mov    $0x400,%edx
f0104136:	83 38 04             	cmpl   $0x4,(%eax)
f0104139:	75 12                	jne    f010414d <wakeup+0x2b>
f010413b:	39 58 2c             	cmp    %ebx,0x2c(%eax)
f010413e:	75 0d                	jne    f010414d <wakeup+0x2b>
			envs[i].channel = 0;
f0104140:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
			envs[i].env_status = ENV_RUNNABLE;
f0104147:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
f010414d:	05 84 00 00 00       	add    $0x84,%eax
}

void
wakeup (enum EnvChannel channel) {
	int i;
	for(i = 0; i < NENV; i++){
f0104152:	83 ea 01             	sub    $0x1,%edx
f0104155:	75 df                	jne    f0104136 <wakeup+0x14>
        	if ((envs[i].env_status == ENV_NOT_RUNNABLE) && (envs[i].channel == channel)) {
			envs[i].channel = 0;
			envs[i].env_status = ENV_RUNNABLE;
		}
	}
}
f0104157:	5b                   	pop    %ebx
f0104158:	5d                   	pop    %ebp
f0104159:	c3                   	ret    

f010415a <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010415a:	55                   	push   %ebp
f010415b:	89 e5                	mov    %esp,%ebp
f010415d:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104161:	ba 70 00 00 00       	mov    $0x70,%edx
f0104166:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0104167:	b2 71                	mov    $0x71,%dl
f0104169:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010416a:	0f b6 c0             	movzbl %al,%eax
}
f010416d:	5d                   	pop    %ebp
f010416e:	c3                   	ret    

f010416f <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f010416f:	55                   	push   %ebp
f0104170:	89 e5                	mov    %esp,%ebp
f0104172:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104176:	ba 70 00 00 00       	mov    $0x70,%edx
f010417b:	ee                   	out    %al,(%dx)
f010417c:	b2 71                	mov    $0x71,%dl
f010417e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104181:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0104182:	5d                   	pop    %ebp
f0104183:	c3                   	ret    

f0104184 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0104184:	55                   	push   %ebp
f0104185:	89 e5                	mov    %esp,%ebp
f0104187:	56                   	push   %esi
f0104188:	53                   	push   %ebx
f0104189:	83 ec 10             	sub    $0x10,%esp
f010418c:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f010418f:	66 a3 a8 63 12 f0    	mov    %ax,0xf01263a8
	if (!didinit)
f0104195:	80 3d 54 42 2c f0 00 	cmpb   $0x0,0xf02c4254
f010419c:	74 4e                	je     f01041ec <irq_setmask_8259A+0x68>
f010419e:	89 c6                	mov    %eax,%esi
f01041a0:	ba 21 00 00 00       	mov    $0x21,%edx
f01041a5:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f01041a6:	66 c1 e8 08          	shr    $0x8,%ax
f01041aa:	b2 a1                	mov    $0xa1,%dl
f01041ac:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01041ad:	c7 04 24 97 96 10 f0 	movl   $0xf0109697,(%esp)
f01041b4:	e8 1d 01 00 00       	call   f01042d6 <cprintf>
	for (i = 0; i < 16; i++)
f01041b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01041be:	0f b7 f6             	movzwl %si,%esi
f01041c1:	f7 d6                	not    %esi
f01041c3:	0f a3 de             	bt     %ebx,%esi
f01041c6:	73 10                	jae    f01041d8 <irq_setmask_8259A+0x54>
			cprintf(" %d", i);
f01041c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01041cc:	c7 04 24 3f 9b 10 f0 	movl   $0xf0109b3f,(%esp)
f01041d3:	e8 fe 00 00 00       	call   f01042d6 <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f01041d8:	83 c3 01             	add    $0x1,%ebx
f01041db:	83 fb 10             	cmp    $0x10,%ebx
f01041de:	75 e3                	jne    f01041c3 <irq_setmask_8259A+0x3f>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f01041e0:	c7 04 24 9b 8c 10 f0 	movl   $0xf0108c9b,(%esp)
f01041e7:	e8 ea 00 00 00       	call   f01042d6 <cprintf>
}
f01041ec:	83 c4 10             	add    $0x10,%esp
f01041ef:	5b                   	pop    %ebx
f01041f0:	5e                   	pop    %esi
f01041f1:	5d                   	pop    %ebp
f01041f2:	c3                   	ret    

f01041f3 <pic_init>:

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
f01041f3:	c6 05 54 42 2c f0 01 	movb   $0x1,0xf02c4254
f01041fa:	ba 21 00 00 00       	mov    $0x21,%edx
f01041ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104204:	ee                   	out    %al,(%dx)
f0104205:	b2 a1                	mov    $0xa1,%dl
f0104207:	ee                   	out    %al,(%dx)
f0104208:	b2 20                	mov    $0x20,%dl
f010420a:	b8 11 00 00 00       	mov    $0x11,%eax
f010420f:	ee                   	out    %al,(%dx)
f0104210:	b2 21                	mov    $0x21,%dl
f0104212:	b8 20 00 00 00       	mov    $0x20,%eax
f0104217:	ee                   	out    %al,(%dx)
f0104218:	b8 04 00 00 00       	mov    $0x4,%eax
f010421d:	ee                   	out    %al,(%dx)
f010421e:	b8 03 00 00 00       	mov    $0x3,%eax
f0104223:	ee                   	out    %al,(%dx)
f0104224:	b2 a0                	mov    $0xa0,%dl
f0104226:	b8 11 00 00 00       	mov    $0x11,%eax
f010422b:	ee                   	out    %al,(%dx)
f010422c:	b2 a1                	mov    $0xa1,%dl
f010422e:	b8 28 00 00 00       	mov    $0x28,%eax
f0104233:	ee                   	out    %al,(%dx)
f0104234:	b8 02 00 00 00       	mov    $0x2,%eax
f0104239:	ee                   	out    %al,(%dx)
f010423a:	b8 01 00 00 00       	mov    $0x1,%eax
f010423f:	ee                   	out    %al,(%dx)
f0104240:	b2 20                	mov    $0x20,%dl
f0104242:	b8 68 00 00 00       	mov    $0x68,%eax
f0104247:	ee                   	out    %al,(%dx)
f0104248:	b8 0a 00 00 00       	mov    $0xa,%eax
f010424d:	ee                   	out    %al,(%dx)
f010424e:	b2 a0                	mov    $0xa0,%dl
f0104250:	b8 68 00 00 00       	mov    $0x68,%eax
f0104255:	ee                   	out    %al,(%dx)
f0104256:	b8 0a 00 00 00       	mov    $0xa,%eax
f010425b:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f010425c:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f0104263:	66 83 f8 ff          	cmp    $0xffff,%ax
f0104267:	74 12                	je     f010427b <pic_init+0x88>
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0104269:	55                   	push   %ebp
f010426a:	89 e5                	mov    %esp,%ebp
f010426c:	83 ec 18             	sub    $0x18,%esp

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
		irq_setmask_8259A(irq_mask_8259A);
f010426f:	0f b7 c0             	movzwl %ax,%eax
f0104272:	89 04 24             	mov    %eax,(%esp)
f0104275:	e8 0a ff ff ff       	call   f0104184 <irq_setmask_8259A>
}
f010427a:	c9                   	leave  
f010427b:	f3 c3                	repz ret 

f010427d <irq_eoi>:
	cprintf("\n");
}

void
irq_eoi(void)
{
f010427d:	55                   	push   %ebp
f010427e:	89 e5                	mov    %esp,%ebp
f0104280:	ba 20 00 00 00       	mov    $0x20,%edx
f0104285:	b8 20 00 00 00       	mov    $0x20,%eax
f010428a:	ee                   	out    %al,(%dx)
f010428b:	b2 a0                	mov    $0xa0,%dl
f010428d:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f010428e:	5d                   	pop    %ebp
f010428f:	c3                   	ret    

f0104290 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0104290:	55                   	push   %ebp
f0104291:	89 e5                	mov    %esp,%ebp
f0104293:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f0104296:	8b 45 08             	mov    0x8(%ebp),%eax
f0104299:	89 04 24             	mov    %eax,(%esp)
f010429c:	e8 36 c5 ff ff       	call   f01007d7 <cputchar>
	*cnt++;
}
f01042a1:	c9                   	leave  
f01042a2:	c3                   	ret    

f01042a3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01042a3:	55                   	push   %ebp
f01042a4:	89 e5                	mov    %esp,%ebp
f01042a6:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f01042a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01042b0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01042b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01042b7:	8b 45 08             	mov    0x8(%ebp),%eax
f01042ba:	89 44 24 08          	mov    %eax,0x8(%esp)
f01042be:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01042c1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01042c5:	c7 04 24 90 42 10 f0 	movl   $0xf0104290,(%esp)
f01042cc:	e8 ed 1d 00 00       	call   f01060be <vprintfmt>
	return cnt;
}
f01042d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01042d4:	c9                   	leave  
f01042d5:	c3                   	ret    

f01042d6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01042d6:	55                   	push   %ebp
f01042d7:	89 e5                	mov    %esp,%ebp
f01042d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01042dc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01042df:	89 44 24 04          	mov    %eax,0x4(%esp)
f01042e3:	8b 45 08             	mov    0x8(%ebp),%eax
f01042e6:	89 04 24             	mov    %eax,(%esp)
f01042e9:	e8 b5 ff ff ff       	call   f01042a3 <vcprintf>
	va_end(ap);

	return cnt;
}
f01042ee:	c9                   	leave  
f01042ef:	c3                   	ret    

f01042f0 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f01042f0:	55                   	push   %ebp
f01042f1:	89 e5                	mov    %esp,%ebp
f01042f3:	57                   	push   %edi
f01042f4:	56                   	push   %esi
f01042f5:	53                   	push   %ebx
f01042f6:	83 ec 0c             	sub    $0xc,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - thiscpu->cpu_id * (KSTKSIZE + KSTKGAP);
f01042f9:	e8 2b 2c 00 00       	call   f0106f29 <cpunum>
f01042fe:	89 c3                	mov    %eax,%ebx
f0104300:	e8 24 2c 00 00       	call   f0106f29 <cpunum>
f0104305:	6b db 74             	imul   $0x74,%ebx,%ebx
f0104308:	6b c0 74             	imul   $0x74,%eax,%eax
f010430b:	0f b6 80 20 50 2c f0 	movzbl -0xfd3afe0(%eax),%eax
f0104312:	f7 d8                	neg    %eax
f0104314:	c1 e0 10             	shl    $0x10,%eax
f0104317:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010431c:	89 83 30 50 2c f0    	mov    %eax,-0xfd3afd0(%ebx)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0104322:	e8 02 2c 00 00       	call   f0106f29 <cpunum>
f0104327:	6b c0 74             	imul   $0x74,%eax,%eax
f010432a:	66 c7 80 34 50 2c f0 	movw   $0x10,-0xfd3afcc(%eax)
f0104331:	10 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id] = SEG16(STS_T32A, (uint32_t) (&thiscpu->cpu_ts),
f0104333:	e8 f1 2b 00 00       	call   f0106f29 <cpunum>
f0104338:	6b c0 74             	imul   $0x74,%eax,%eax
f010433b:	0f b6 98 20 50 2c f0 	movzbl -0xfd3afe0(%eax),%ebx
f0104342:	83 c3 05             	add    $0x5,%ebx
f0104345:	e8 df 2b 00 00       	call   f0106f29 <cpunum>
f010434a:	89 c7                	mov    %eax,%edi
f010434c:	e8 d8 2b 00 00       	call   f0106f29 <cpunum>
f0104351:	89 c6                	mov    %eax,%esi
f0104353:	e8 d1 2b 00 00       	call   f0106f29 <cpunum>
f0104358:	66 c7 04 dd 40 63 12 	movw   $0x67,-0xfed9cc0(,%ebx,8)
f010435f:	f0 67 00 
f0104362:	6b ff 74             	imul   $0x74,%edi,%edi
f0104365:	81 c7 2c 50 2c f0    	add    $0xf02c502c,%edi
f010436b:	66 89 3c dd 42 63 12 	mov    %di,-0xfed9cbe(,%ebx,8)
f0104372:	f0 
f0104373:	6b d6 74             	imul   $0x74,%esi,%edx
f0104376:	81 c2 2c 50 2c f0    	add    $0xf02c502c,%edx
f010437c:	c1 ea 10             	shr    $0x10,%edx
f010437f:	88 14 dd 44 63 12 f0 	mov    %dl,-0xfed9cbc(,%ebx,8)
f0104386:	c6 04 dd 45 63 12 f0 	movb   $0x99,-0xfed9cbb(,%ebx,8)
f010438d:	99 
f010438e:	c6 04 dd 46 63 12 f0 	movb   $0x40,-0xfed9cba(,%ebx,8)
f0104395:	40 
f0104396:	6b c0 74             	imul   $0x74,%eax,%eax
f0104399:	05 2c 50 2c f0       	add    $0xf02c502c,%eax
f010439e:	c1 e8 18             	shr    $0x18,%eax
f01043a1:	88 04 dd 47 63 12 f0 	mov    %al,-0xfed9cb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id].sd_s = 0;
f01043a8:	e8 7c 2b 00 00       	call   f0106f29 <cpunum>
f01043ad:	6b c0 74             	imul   $0x74,%eax,%eax
f01043b0:	0f b6 80 20 50 2c f0 	movzbl -0xfd3afe0(%eax),%eax
f01043b7:	80 24 c5 6d 63 12 f0 	andb   $0xef,-0xfed9c93(,%eax,8)
f01043be:	ef 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (thiscpu->cpu_id << 3));
f01043bf:	e8 65 2b 00 00       	call   f0106f29 <cpunum>
f01043c4:	6b c0 74             	imul   $0x74,%eax,%eax
f01043c7:	0f b6 80 20 50 2c f0 	movzbl -0xfd3afe0(%eax),%eax
f01043ce:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01043d5:	0f 00 d8             	ltr    %ax
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f01043d8:	b8 aa 63 12 f0       	mov    $0xf01263aa,%eax
f01043dd:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f01043e0:	83 c4 0c             	add    $0xc,%esp
f01043e3:	5b                   	pop    %ebx
f01043e4:	5e                   	pop    %esi
f01043e5:	5f                   	pop    %edi
f01043e6:	5d                   	pop    %ebp
f01043e7:	c3                   	ret    

f01043e8 <trap_init>:

#define MAKE_THE_MF_T(i_n,the_mf_t,per) void the_mf_t(); SETGATE(idt[i_n], 0, GD_KT, the_mf_t, per);

void
trap_init(void)
{
f01043e8:	55                   	push   %ebp
f01043e9:	89 e5                	mov    %esp,%ebp
f01043eb:	83 ec 08             	sub    $0x8,%esp
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.

	MAKE_THE_MF_T(0,t_func_divide,0)
f01043ee:	b8 6a 50 10 f0       	mov    $0xf010506a,%eax
f01043f3:	66 a3 60 42 2c f0    	mov    %ax,0xf02c4260
f01043f9:	66 c7 05 62 42 2c f0 	movw   $0x8,0xf02c4262
f0104400:	08 00 
f0104402:	c6 05 64 42 2c f0 00 	movb   $0x0,0xf02c4264
f0104409:	c6 05 65 42 2c f0 8e 	movb   $0x8e,0xf02c4265
f0104410:	c1 e8 10             	shr    $0x10,%eax
f0104413:	66 a3 66 42 2c f0    	mov    %ax,0xf02c4266
	MAKE_THE_MF_T(1,t_func_debug,0)
f0104419:	b8 70 50 10 f0       	mov    $0xf0105070,%eax
f010441e:	66 a3 68 42 2c f0    	mov    %ax,0xf02c4268
f0104424:	66 c7 05 6a 42 2c f0 	movw   $0x8,0xf02c426a
f010442b:	08 00 
f010442d:	c6 05 6c 42 2c f0 00 	movb   $0x0,0xf02c426c
f0104434:	c6 05 6d 42 2c f0 8e 	movb   $0x8e,0xf02c426d
f010443b:	c1 e8 10             	shr    $0x10,%eax
f010443e:	66 a3 6e 42 2c f0    	mov    %ax,0xf02c426e

	MAKE_THE_MF_T(3, t_func_brkpt, 3);
f0104444:	b8 76 50 10 f0       	mov    $0xf0105076,%eax
f0104449:	66 a3 78 42 2c f0    	mov    %ax,0xf02c4278
f010444f:	66 c7 05 7a 42 2c f0 	movw   $0x8,0xf02c427a
f0104456:	08 00 
f0104458:	c6 05 7c 42 2c f0 00 	movb   $0x0,0xf02c427c
f010445f:	c6 05 7d 42 2c f0 ee 	movb   $0xee,0xf02c427d
f0104466:	c1 e8 10             	shr    $0x10,%eax
f0104469:	66 a3 7e 42 2c f0    	mov    %ax,0xf02c427e
	MAKE_THE_MF_T(4, t_func_oflow, 0);
f010446f:	b8 7c 50 10 f0       	mov    $0xf010507c,%eax
f0104474:	66 a3 80 42 2c f0    	mov    %ax,0xf02c4280
f010447a:	66 c7 05 82 42 2c f0 	movw   $0x8,0xf02c4282
f0104481:	08 00 
f0104483:	c6 05 84 42 2c f0 00 	movb   $0x0,0xf02c4284
f010448a:	c6 05 85 42 2c f0 8e 	movb   $0x8e,0xf02c4285
f0104491:	c1 e8 10             	shr    $0x10,%eax
f0104494:	66 a3 86 42 2c f0    	mov    %ax,0xf02c4286
	MAKE_THE_MF_T(5, t_func_bound, 0);
f010449a:	b8 82 50 10 f0       	mov    $0xf0105082,%eax
f010449f:	66 a3 88 42 2c f0    	mov    %ax,0xf02c4288
f01044a5:	66 c7 05 8a 42 2c f0 	movw   $0x8,0xf02c428a
f01044ac:	08 00 
f01044ae:	c6 05 8c 42 2c f0 00 	movb   $0x0,0xf02c428c
f01044b5:	c6 05 8d 42 2c f0 8e 	movb   $0x8e,0xf02c428d
f01044bc:	c1 e8 10             	shr    $0x10,%eax
f01044bf:	66 a3 8e 42 2c f0    	mov    %ax,0xf02c428e
	MAKE_THE_MF_T(6, t_func_illop, 0);
f01044c5:	b8 88 50 10 f0       	mov    $0xf0105088,%eax
f01044ca:	66 a3 90 42 2c f0    	mov    %ax,0xf02c4290
f01044d0:	66 c7 05 92 42 2c f0 	movw   $0x8,0xf02c4292
f01044d7:	08 00 
f01044d9:	c6 05 94 42 2c f0 00 	movb   $0x0,0xf02c4294
f01044e0:	c6 05 95 42 2c f0 8e 	movb   $0x8e,0xf02c4295
f01044e7:	c1 e8 10             	shr    $0x10,%eax
f01044ea:	66 a3 96 42 2c f0    	mov    %ax,0xf02c4296
	MAKE_THE_MF_T(7, t_func_device, 0);
f01044f0:	b8 8e 50 10 f0       	mov    $0xf010508e,%eax
f01044f5:	66 a3 98 42 2c f0    	mov    %ax,0xf02c4298
f01044fb:	66 c7 05 9a 42 2c f0 	movw   $0x8,0xf02c429a
f0104502:	08 00 
f0104504:	c6 05 9c 42 2c f0 00 	movb   $0x0,0xf02c429c
f010450b:	c6 05 9d 42 2c f0 8e 	movb   $0x8e,0xf02c429d
f0104512:	c1 e8 10             	shr    $0x10,%eax
f0104515:	66 a3 9e 42 2c f0    	mov    %ax,0xf02c429e
	MAKE_THE_MF_T(8, t_func_dblfit, 0);
f010451b:	b8 94 50 10 f0       	mov    $0xf0105094,%eax
f0104520:	66 a3 a0 42 2c f0    	mov    %ax,0xf02c42a0
f0104526:	66 c7 05 a2 42 2c f0 	movw   $0x8,0xf02c42a2
f010452d:	08 00 
f010452f:	c6 05 a4 42 2c f0 00 	movb   $0x0,0xf02c42a4
f0104536:	c6 05 a5 42 2c f0 8e 	movb   $0x8e,0xf02c42a5
f010453d:	c1 e8 10             	shr    $0x10,%eax
f0104540:	66 a3 a6 42 2c f0    	mov    %ax,0xf02c42a6

	MAKE_THE_MF_T(10, t_func_tss, 0);
f0104546:	b8 98 50 10 f0       	mov    $0xf0105098,%eax
f010454b:	66 a3 b0 42 2c f0    	mov    %ax,0xf02c42b0
f0104551:	66 c7 05 b2 42 2c f0 	movw   $0x8,0xf02c42b2
f0104558:	08 00 
f010455a:	c6 05 b4 42 2c f0 00 	movb   $0x0,0xf02c42b4
f0104561:	c6 05 b5 42 2c f0 8e 	movb   $0x8e,0xf02c42b5
f0104568:	c1 e8 10             	shr    $0x10,%eax
f010456b:	66 a3 b6 42 2c f0    	mov    %ax,0xf02c42b6
	MAKE_THE_MF_T(11, t_func_segnp, 0);
f0104571:	b8 9c 50 10 f0       	mov    $0xf010509c,%eax
f0104576:	66 a3 b8 42 2c f0    	mov    %ax,0xf02c42b8
f010457c:	66 c7 05 ba 42 2c f0 	movw   $0x8,0xf02c42ba
f0104583:	08 00 
f0104585:	c6 05 bc 42 2c f0 00 	movb   $0x0,0xf02c42bc
f010458c:	c6 05 bd 42 2c f0 8e 	movb   $0x8e,0xf02c42bd
f0104593:	c1 e8 10             	shr    $0x10,%eax
f0104596:	66 a3 be 42 2c f0    	mov    %ax,0xf02c42be
	MAKE_THE_MF_T(12, t_func_stack, 0);
f010459c:	b8 a0 50 10 f0       	mov    $0xf01050a0,%eax
f01045a1:	66 a3 c0 42 2c f0    	mov    %ax,0xf02c42c0
f01045a7:	66 c7 05 c2 42 2c f0 	movw   $0x8,0xf02c42c2
f01045ae:	08 00 
f01045b0:	c6 05 c4 42 2c f0 00 	movb   $0x0,0xf02c42c4
f01045b7:	c6 05 c5 42 2c f0 8e 	movb   $0x8e,0xf02c42c5
f01045be:	c1 e8 10             	shr    $0x10,%eax
f01045c1:	66 a3 c6 42 2c f0    	mov    %ax,0xf02c42c6
	MAKE_THE_MF_T(13, t_func_gpflt, 0);
f01045c7:	b8 a4 50 10 f0       	mov    $0xf01050a4,%eax
f01045cc:	66 a3 c8 42 2c f0    	mov    %ax,0xf02c42c8
f01045d2:	66 c7 05 ca 42 2c f0 	movw   $0x8,0xf02c42ca
f01045d9:	08 00 
f01045db:	c6 05 cc 42 2c f0 00 	movb   $0x0,0xf02c42cc
f01045e2:	c6 05 cd 42 2c f0 8e 	movb   $0x8e,0xf02c42cd
f01045e9:	c1 e8 10             	shr    $0x10,%eax
f01045ec:	66 a3 ce 42 2c f0    	mov    %ax,0xf02c42ce
	MAKE_THE_MF_T(14, t_func_pgflt, 0);
f01045f2:	b8 a8 50 10 f0       	mov    $0xf01050a8,%eax
f01045f7:	66 a3 d0 42 2c f0    	mov    %ax,0xf02c42d0
f01045fd:	66 c7 05 d2 42 2c f0 	movw   $0x8,0xf02c42d2
f0104604:	08 00 
f0104606:	c6 05 d4 42 2c f0 00 	movb   $0x0,0xf02c42d4
f010460d:	c6 05 d5 42 2c f0 8e 	movb   $0x8e,0xf02c42d5
f0104614:	c1 e8 10             	shr    $0x10,%eax
f0104617:	66 a3 d6 42 2c f0    	mov    %ax,0xf02c42d6

	MAKE_THE_MF_T(16, t_func_fperr, 0);
f010461d:	b8 ac 50 10 f0       	mov    $0xf01050ac,%eax
f0104622:	66 a3 e0 42 2c f0    	mov    %ax,0xf02c42e0
f0104628:	66 c7 05 e2 42 2c f0 	movw   $0x8,0xf02c42e2
f010462f:	08 00 
f0104631:	c6 05 e4 42 2c f0 00 	movb   $0x0,0xf02c42e4
f0104638:	c6 05 e5 42 2c f0 8e 	movb   $0x8e,0xf02c42e5
f010463f:	c1 e8 10             	shr    $0x10,%eax
f0104642:	66 a3 e6 42 2c f0    	mov    %ax,0xf02c42e6


	MAKE_THE_MF_T(48, t_func_syscall, 3);
f0104648:	b8 b2 50 10 f0       	mov    $0xf01050b2,%eax
f010464d:	66 a3 e0 43 2c f0    	mov    %ax,0xf02c43e0
f0104653:	66 c7 05 e2 43 2c f0 	movw   $0x8,0xf02c43e2
f010465a:	08 00 
f010465c:	c6 05 e4 43 2c f0 00 	movb   $0x0,0xf02c43e4
f0104663:	c6 05 e5 43 2c f0 ee 	movb   $0xee,0xf02c43e5
f010466a:	c1 e8 10             	shr    $0x10,%eax
f010466d:	66 a3 e6 43 2c f0    	mov    %ax,0xf02c43e6
	extern void IRQ_11();
	extern void IRQ_12();
	extern void IRQ_13();
	extern void IRQ_14();
	extern void IRQ_15();
	SETGATE(idt[IRQ_OFFSET + 0], 0, GD_KT, IRQ_0, 0);
f0104673:	b8 ee 4f 10 f0       	mov    $0xf0104fee,%eax
f0104678:	66 a3 60 43 2c f0    	mov    %ax,0xf02c4360
f010467e:	66 c7 05 62 43 2c f0 	movw   $0x8,0xf02c4362
f0104685:	08 00 
f0104687:	c6 05 64 43 2c f0 00 	movb   $0x0,0xf02c4364
f010468e:	c6 05 65 43 2c f0 8e 	movb   $0x8e,0xf02c4365
f0104695:	c1 e8 10             	shr    $0x10,%eax
f0104698:	66 a3 66 43 2c f0    	mov    %ax,0xf02c4366
	SETGATE(idt[IRQ_OFFSET + 1], 0, GD_KT, IRQ_1, 0);
f010469e:	b8 f8 4f 10 f0       	mov    $0xf0104ff8,%eax
f01046a3:	66 a3 68 43 2c f0    	mov    %ax,0xf02c4368
f01046a9:	66 c7 05 6a 43 2c f0 	movw   $0x8,0xf02c436a
f01046b0:	08 00 
f01046b2:	c6 05 6c 43 2c f0 00 	movb   $0x0,0xf02c436c
f01046b9:	c6 05 6d 43 2c f0 8e 	movb   $0x8e,0xf02c436d
f01046c0:	c1 e8 10             	shr    $0x10,%eax
f01046c3:	66 a3 6e 43 2c f0    	mov    %ax,0xf02c436e
	SETGATE(idt[IRQ_OFFSET + 2], 0, GD_KT, IRQ_2, 0);
f01046c9:	b8 02 50 10 f0       	mov    $0xf0105002,%eax
f01046ce:	66 a3 70 43 2c f0    	mov    %ax,0xf02c4370
f01046d4:	66 c7 05 72 43 2c f0 	movw   $0x8,0xf02c4372
f01046db:	08 00 
f01046dd:	c6 05 74 43 2c f0 00 	movb   $0x0,0xf02c4374
f01046e4:	c6 05 75 43 2c f0 8e 	movb   $0x8e,0xf02c4375
f01046eb:	c1 e8 10             	shr    $0x10,%eax
f01046ee:	66 a3 76 43 2c f0    	mov    %ax,0xf02c4376
	SETGATE(idt[IRQ_OFFSET + 3], 0, GD_KT, IRQ_3, 0);
f01046f4:	b8 0c 50 10 f0       	mov    $0xf010500c,%eax
f01046f9:	66 a3 78 43 2c f0    	mov    %ax,0xf02c4378
f01046ff:	66 c7 05 7a 43 2c f0 	movw   $0x8,0xf02c437a
f0104706:	08 00 
f0104708:	c6 05 7c 43 2c f0 00 	movb   $0x0,0xf02c437c
f010470f:	c6 05 7d 43 2c f0 8e 	movb   $0x8e,0xf02c437d
f0104716:	c1 e8 10             	shr    $0x10,%eax
f0104719:	66 a3 7e 43 2c f0    	mov    %ax,0xf02c437e
	SETGATE(idt[IRQ_OFFSET + 4], 0, GD_KT, IRQ_4, 0);
f010471f:	b8 16 50 10 f0       	mov    $0xf0105016,%eax
f0104724:	66 a3 80 43 2c f0    	mov    %ax,0xf02c4380
f010472a:	66 c7 05 82 43 2c f0 	movw   $0x8,0xf02c4382
f0104731:	08 00 
f0104733:	c6 05 84 43 2c f0 00 	movb   $0x0,0xf02c4384
f010473a:	c6 05 85 43 2c f0 8e 	movb   $0x8e,0xf02c4385
f0104741:	c1 e8 10             	shr    $0x10,%eax
f0104744:	66 a3 86 43 2c f0    	mov    %ax,0xf02c4386
	SETGATE(idt[IRQ_OFFSET + 5], 0, GD_KT, IRQ_5, 0);
f010474a:	b8 20 50 10 f0       	mov    $0xf0105020,%eax
f010474f:	66 a3 88 43 2c f0    	mov    %ax,0xf02c4388
f0104755:	66 c7 05 8a 43 2c f0 	movw   $0x8,0xf02c438a
f010475c:	08 00 
f010475e:	c6 05 8c 43 2c f0 00 	movb   $0x0,0xf02c438c
f0104765:	c6 05 8d 43 2c f0 8e 	movb   $0x8e,0xf02c438d
f010476c:	c1 e8 10             	shr    $0x10,%eax
f010476f:	66 a3 8e 43 2c f0    	mov    %ax,0xf02c438e
	SETGATE(idt[IRQ_OFFSET + 6], 0, GD_KT, IRQ_6, 0);
f0104775:	b8 2a 50 10 f0       	mov    $0xf010502a,%eax
f010477a:	66 a3 90 43 2c f0    	mov    %ax,0xf02c4390
f0104780:	66 c7 05 92 43 2c f0 	movw   $0x8,0xf02c4392
f0104787:	08 00 
f0104789:	c6 05 94 43 2c f0 00 	movb   $0x0,0xf02c4394
f0104790:	c6 05 95 43 2c f0 8e 	movb   $0x8e,0xf02c4395
f0104797:	c1 e8 10             	shr    $0x10,%eax
f010479a:	66 a3 96 43 2c f0    	mov    %ax,0xf02c4396
	SETGATE(idt[IRQ_OFFSET + 7], 0, GD_KT, IRQ_7, 0);
f01047a0:	b8 34 50 10 f0       	mov    $0xf0105034,%eax
f01047a5:	66 a3 98 43 2c f0    	mov    %ax,0xf02c4398
f01047ab:	66 c7 05 9a 43 2c f0 	movw   $0x8,0xf02c439a
f01047b2:	08 00 
f01047b4:	c6 05 9c 43 2c f0 00 	movb   $0x0,0xf02c439c
f01047bb:	c6 05 9d 43 2c f0 8e 	movb   $0x8e,0xf02c439d
f01047c2:	c1 e8 10             	shr    $0x10,%eax
f01047c5:	66 a3 9e 43 2c f0    	mov    %ax,0xf02c439e
	SETGATE(idt[IRQ_OFFSET + 8], 0, GD_KT, IRQ_8, 0);
f01047cb:	b8 3a 50 10 f0       	mov    $0xf010503a,%eax
f01047d0:	66 a3 a0 43 2c f0    	mov    %ax,0xf02c43a0
f01047d6:	66 c7 05 a2 43 2c f0 	movw   $0x8,0xf02c43a2
f01047dd:	08 00 
f01047df:	c6 05 a4 43 2c f0 00 	movb   $0x0,0xf02c43a4
f01047e6:	c6 05 a5 43 2c f0 8e 	movb   $0x8e,0xf02c43a5
f01047ed:	c1 e8 10             	shr    $0x10,%eax
f01047f0:	66 a3 a6 43 2c f0    	mov    %ax,0xf02c43a6
	SETGATE(idt[IRQ_OFFSET + 9], 0, GD_KT, IRQ_9, 0);
f01047f6:	b8 40 50 10 f0       	mov    $0xf0105040,%eax
f01047fb:	66 a3 a8 43 2c f0    	mov    %ax,0xf02c43a8
f0104801:	66 c7 05 aa 43 2c f0 	movw   $0x8,0xf02c43aa
f0104808:	08 00 
f010480a:	c6 05 ac 43 2c f0 00 	movb   $0x0,0xf02c43ac
f0104811:	c6 05 ad 43 2c f0 8e 	movb   $0x8e,0xf02c43ad
f0104818:	c1 e8 10             	shr    $0x10,%eax
f010481b:	66 a3 ae 43 2c f0    	mov    %ax,0xf02c43ae
	SETGATE(idt[IRQ_OFFSET + 10], 0, GD_KT, IRQ_10, 0);
f0104821:	b8 46 50 10 f0       	mov    $0xf0105046,%eax
f0104826:	66 a3 b0 43 2c f0    	mov    %ax,0xf02c43b0
f010482c:	66 c7 05 b2 43 2c f0 	movw   $0x8,0xf02c43b2
f0104833:	08 00 
f0104835:	c6 05 b4 43 2c f0 00 	movb   $0x0,0xf02c43b4
f010483c:	c6 05 b5 43 2c f0 8e 	movb   $0x8e,0xf02c43b5
f0104843:	c1 e8 10             	shr    $0x10,%eax
f0104846:	66 a3 b6 43 2c f0    	mov    %ax,0xf02c43b6
	SETGATE(idt[IRQ_OFFSET + 11], 0, GD_KT, IRQ_11, 0);
f010484c:	b8 4c 50 10 f0       	mov    $0xf010504c,%eax
f0104851:	66 a3 b8 43 2c f0    	mov    %ax,0xf02c43b8
f0104857:	66 c7 05 ba 43 2c f0 	movw   $0x8,0xf02c43ba
f010485e:	08 00 
f0104860:	c6 05 bc 43 2c f0 00 	movb   $0x0,0xf02c43bc
f0104867:	c6 05 bd 43 2c f0 8e 	movb   $0x8e,0xf02c43bd
f010486e:	c1 e8 10             	shr    $0x10,%eax
f0104871:	66 a3 be 43 2c f0    	mov    %ax,0xf02c43be
	SETGATE(idt[IRQ_OFFSET + 12], 0, GD_KT, IRQ_12, 0);
f0104877:	b8 52 50 10 f0       	mov    $0xf0105052,%eax
f010487c:	66 a3 c0 43 2c f0    	mov    %ax,0xf02c43c0
f0104882:	66 c7 05 c2 43 2c f0 	movw   $0x8,0xf02c43c2
f0104889:	08 00 
f010488b:	c6 05 c4 43 2c f0 00 	movb   $0x0,0xf02c43c4
f0104892:	c6 05 c5 43 2c f0 8e 	movb   $0x8e,0xf02c43c5
f0104899:	c1 e8 10             	shr    $0x10,%eax
f010489c:	66 a3 c6 43 2c f0    	mov    %ax,0xf02c43c6
	SETGATE(idt[IRQ_OFFSET + 13], 0, GD_KT, IRQ_13, 0);
f01048a2:	b8 58 50 10 f0       	mov    $0xf0105058,%eax
f01048a7:	66 a3 c8 43 2c f0    	mov    %ax,0xf02c43c8
f01048ad:	66 c7 05 ca 43 2c f0 	movw   $0x8,0xf02c43ca
f01048b4:	08 00 
f01048b6:	c6 05 cc 43 2c f0 00 	movb   $0x0,0xf02c43cc
f01048bd:	c6 05 cd 43 2c f0 8e 	movb   $0x8e,0xf02c43cd
f01048c4:	c1 e8 10             	shr    $0x10,%eax
f01048c7:	66 a3 ce 43 2c f0    	mov    %ax,0xf02c43ce
	SETGATE(idt[IRQ_OFFSET + 14], 0, GD_KT, IRQ_14, 0);
f01048cd:	b8 5e 50 10 f0       	mov    $0xf010505e,%eax
f01048d2:	66 a3 d0 43 2c f0    	mov    %ax,0xf02c43d0
f01048d8:	66 c7 05 d2 43 2c f0 	movw   $0x8,0xf02c43d2
f01048df:	08 00 
f01048e1:	c6 05 d4 43 2c f0 00 	movb   $0x0,0xf02c43d4
f01048e8:	c6 05 d5 43 2c f0 8e 	movb   $0x8e,0xf02c43d5
f01048ef:	c1 e8 10             	shr    $0x10,%eax
f01048f2:	66 a3 d6 43 2c f0    	mov    %ax,0xf02c43d6
	SETGATE(idt[IRQ_OFFSET + 15], 0, GD_KT, IRQ_15, 0);
f01048f8:	b8 64 50 10 f0       	mov    $0xf0105064,%eax
f01048fd:	66 a3 d8 43 2c f0    	mov    %ax,0xf02c43d8
f0104903:	66 c7 05 da 43 2c f0 	movw   $0x8,0xf02c43da
f010490a:	08 00 
f010490c:	c6 05 dc 43 2c f0 00 	movb   $0x0,0xf02c43dc
f0104913:	c6 05 dd 43 2c f0 8e 	movb   $0x8e,0xf02c43dd
f010491a:	c1 e8 10             	shr    $0x10,%eax
f010491d:	66 a3 de 43 2c f0    	mov    %ax,0xf02c43de
	

	// Per-CPU setup 
	trap_init_percpu();
f0104923:	e8 c8 f9 ff ff       	call   f01042f0 <trap_init_percpu>
}
f0104928:	c9                   	leave  
f0104929:	c3                   	ret    

f010492a <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f010492a:	55                   	push   %ebp
f010492b:	89 e5                	mov    %esp,%ebp
f010492d:	53                   	push   %ebx
f010492e:	83 ec 14             	sub    $0x14,%esp
f0104931:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104934:	8b 03                	mov    (%ebx),%eax
f0104936:	89 44 24 04          	mov    %eax,0x4(%esp)
f010493a:	c7 04 24 ab 96 10 f0 	movl   $0xf01096ab,(%esp)
f0104941:	e8 90 f9 ff ff       	call   f01042d6 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104946:	8b 43 04             	mov    0x4(%ebx),%eax
f0104949:	89 44 24 04          	mov    %eax,0x4(%esp)
f010494d:	c7 04 24 ba 96 10 f0 	movl   $0xf01096ba,(%esp)
f0104954:	e8 7d f9 ff ff       	call   f01042d6 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104959:	8b 43 08             	mov    0x8(%ebx),%eax
f010495c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104960:	c7 04 24 c9 96 10 f0 	movl   $0xf01096c9,(%esp)
f0104967:	e8 6a f9 ff ff       	call   f01042d6 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f010496c:	8b 43 0c             	mov    0xc(%ebx),%eax
f010496f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104973:	c7 04 24 d8 96 10 f0 	movl   $0xf01096d8,(%esp)
f010497a:	e8 57 f9 ff ff       	call   f01042d6 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f010497f:	8b 43 10             	mov    0x10(%ebx),%eax
f0104982:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104986:	c7 04 24 e7 96 10 f0 	movl   $0xf01096e7,(%esp)
f010498d:	e8 44 f9 ff ff       	call   f01042d6 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104992:	8b 43 14             	mov    0x14(%ebx),%eax
f0104995:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104999:	c7 04 24 f6 96 10 f0 	movl   $0xf01096f6,(%esp)
f01049a0:	e8 31 f9 ff ff       	call   f01042d6 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01049a5:	8b 43 18             	mov    0x18(%ebx),%eax
f01049a8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049ac:	c7 04 24 05 97 10 f0 	movl   $0xf0109705,(%esp)
f01049b3:	e8 1e f9 ff ff       	call   f01042d6 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01049b8:	8b 43 1c             	mov    0x1c(%ebx),%eax
f01049bb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049bf:	c7 04 24 14 97 10 f0 	movl   $0xf0109714,(%esp)
f01049c6:	e8 0b f9 ff ff       	call   f01042d6 <cprintf>
}
f01049cb:	83 c4 14             	add    $0x14,%esp
f01049ce:	5b                   	pop    %ebx
f01049cf:	5d                   	pop    %ebp
f01049d0:	c3                   	ret    

f01049d1 <print_trapframe>:
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
f01049d1:	55                   	push   %ebp
f01049d2:	89 e5                	mov    %esp,%ebp
f01049d4:	56                   	push   %esi
f01049d5:	53                   	push   %ebx
f01049d6:	83 ec 10             	sub    $0x10,%esp
f01049d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f01049dc:	e8 48 25 00 00       	call   f0106f29 <cpunum>
f01049e1:	89 44 24 08          	mov    %eax,0x8(%esp)
f01049e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01049e9:	c7 04 24 78 97 10 f0 	movl   $0xf0109778,(%esp)
f01049f0:	e8 e1 f8 ff ff       	call   f01042d6 <cprintf>
	print_regs(&tf->tf_regs);
f01049f5:	89 1c 24             	mov    %ebx,(%esp)
f01049f8:	e8 2d ff ff ff       	call   f010492a <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01049fd:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104a01:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a05:	c7 04 24 96 97 10 f0 	movl   $0xf0109796,(%esp)
f0104a0c:	e8 c5 f8 ff ff       	call   f01042d6 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104a11:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104a15:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a19:	c7 04 24 a9 97 10 f0 	movl   $0xf01097a9,(%esp)
f0104a20:	e8 b1 f8 ff ff       	call   f01042d6 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104a25:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0104a28:	83 f8 13             	cmp    $0x13,%eax
f0104a2b:	77 09                	ja     f0104a36 <print_trapframe+0x65>
		return excnames[trapno];
f0104a2d:	8b 14 85 40 9a 10 f0 	mov    -0xfef65c0(,%eax,4),%edx
f0104a34:	eb 1f                	jmp    f0104a55 <print_trapframe+0x84>
	if (trapno == T_SYSCALL)
f0104a36:	83 f8 30             	cmp    $0x30,%eax
f0104a39:	74 15                	je     f0104a50 <print_trapframe+0x7f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104a3b:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104a3e:	83 fa 0f             	cmp    $0xf,%edx
f0104a41:	ba 2f 97 10 f0       	mov    $0xf010972f,%edx
f0104a46:	b9 42 97 10 f0       	mov    $0xf0109742,%ecx
f0104a4b:	0f 47 d1             	cmova  %ecx,%edx
f0104a4e:	eb 05                	jmp    f0104a55 <print_trapframe+0x84>
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
f0104a50:	ba 23 97 10 f0       	mov    $0xf0109723,%edx
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104a55:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104a59:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a5d:	c7 04 24 bc 97 10 f0 	movl   $0xf01097bc,(%esp)
f0104a64:	e8 6d f8 ff ff       	call   f01042d6 <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104a69:	3b 1d 60 4a 2c f0    	cmp    0xf02c4a60,%ebx
f0104a6f:	75 19                	jne    f0104a8a <print_trapframe+0xb9>
f0104a71:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104a75:	75 13                	jne    f0104a8a <print_trapframe+0xb9>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0104a77:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a7e:	c7 04 24 ce 97 10 f0 	movl   $0xf01097ce,(%esp)
f0104a85:	e8 4c f8 ff ff       	call   f01042d6 <cprintf>
	cprintf("  err  0x%08x", tf->tf_err);
f0104a8a:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a91:	c7 04 24 dd 97 10 f0 	movl   $0xf01097dd,(%esp)
f0104a98:	e8 39 f8 ff ff       	call   f01042d6 <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0104a9d:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104aa1:	75 51                	jne    f0104af4 <print_trapframe+0x123>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f0104aa3:	8b 43 2c             	mov    0x2c(%ebx),%eax
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
f0104aa6:	89 c2                	mov    %eax,%edx
f0104aa8:	83 e2 01             	and    $0x1,%edx
f0104aab:	ba 51 97 10 f0       	mov    $0xf0109751,%edx
f0104ab0:	b9 5c 97 10 f0       	mov    $0xf010975c,%ecx
f0104ab5:	0f 45 ca             	cmovne %edx,%ecx
f0104ab8:	89 c2                	mov    %eax,%edx
f0104aba:	83 e2 02             	and    $0x2,%edx
f0104abd:	ba 68 97 10 f0       	mov    $0xf0109768,%edx
f0104ac2:	be 6e 97 10 f0       	mov    $0xf010976e,%esi
f0104ac7:	0f 44 d6             	cmove  %esi,%edx
f0104aca:	83 e0 04             	and    $0x4,%eax
f0104acd:	b8 73 97 10 f0       	mov    $0xf0109773,%eax
f0104ad2:	be a8 98 10 f0       	mov    $0xf01098a8,%esi
f0104ad7:	0f 44 c6             	cmove  %esi,%eax
f0104ada:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0104ade:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ae6:	c7 04 24 eb 97 10 f0 	movl   $0xf01097eb,(%esp)
f0104aed:	e8 e4 f7 ff ff       	call   f01042d6 <cprintf>
f0104af2:	eb 0c                	jmp    f0104b00 <print_trapframe+0x12f>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
f0104af4:	c7 04 24 9b 8c 10 f0 	movl   $0xf0108c9b,(%esp)
f0104afb:	e8 d6 f7 ff ff       	call   f01042d6 <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104b00:	8b 43 30             	mov    0x30(%ebx),%eax
f0104b03:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b07:	c7 04 24 fa 97 10 f0 	movl   $0xf01097fa,(%esp)
f0104b0e:	e8 c3 f7 ff ff       	call   f01042d6 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104b13:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104b17:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b1b:	c7 04 24 09 98 10 f0 	movl   $0xf0109809,(%esp)
f0104b22:	e8 af f7 ff ff       	call   f01042d6 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104b27:	8b 43 38             	mov    0x38(%ebx),%eax
f0104b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b2e:	c7 04 24 1c 98 10 f0 	movl   $0xf010981c,(%esp)
f0104b35:	e8 9c f7 ff ff       	call   f01042d6 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104b3a:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104b3e:	74 27                	je     f0104b67 <print_trapframe+0x196>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104b40:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104b43:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b47:	c7 04 24 2b 98 10 f0 	movl   $0xf010982b,(%esp)
f0104b4e:	e8 83 f7 ff ff       	call   f01042d6 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104b53:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104b57:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b5b:	c7 04 24 3a 98 10 f0 	movl   $0xf010983a,(%esp)
f0104b62:	e8 6f f7 ff ff       	call   f01042d6 <cprintf>
	}
}
f0104b67:	83 c4 10             	add    $0x10,%esp
f0104b6a:	5b                   	pop    %ebx
f0104b6b:	5e                   	pop    %esi
f0104b6c:	5d                   	pop    %ebp
f0104b6d:	c3                   	ret    

f0104b6e <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104b6e:	55                   	push   %ebp
f0104b6f:	89 e5                	mov    %esp,%ebp
f0104b71:	57                   	push   %edi
f0104b72:	56                   	push   %esi
f0104b73:	53                   	push   %ebx
f0104b74:	83 ec 2c             	sub    $0x2c,%esp
f0104b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104b7a:	0f 20 d6             	mov    %cr2,%esi
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if ((tf->tf_cs&3) == 0){
f0104b7d:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104b81:	75 20                	jne    f0104ba3 <page_fault_handler+0x35>
		panic("Kernel page fault! Faulty address %08x",fault_va);
f0104b83:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0104b87:	c7 44 24 08 f4 99 10 	movl   $0xf01099f4,0x8(%esp)
f0104b8e:	f0 
f0104b8f:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
f0104b96:	00 
f0104b97:	c7 04 24 4d 98 10 f0 	movl   $0xf010984d,(%esp)
f0104b9e:	e8 9d b4 ff ff       	call   f0100040 <_panic>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	
	if(curenv->env_pgfault_upcall == NULL){
f0104ba3:	e8 81 23 00 00       	call   f0106f29 <cpunum>
f0104ba8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bab:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104bb1:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104bb5:	75 4a                	jne    f0104c01 <page_fault_handler+0x93>
		cprintf("[%08x] user fault va %08x ip %08x\n",curenv->env_id, fault_va, tf->tf_eip);
f0104bb7:	8b 7b 30             	mov    0x30(%ebx),%edi
f0104bba:	e8 6a 23 00 00       	call   f0106f29 <cpunum>
f0104bbf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0104bc3:	89 74 24 08          	mov    %esi,0x8(%esp)
f0104bc7:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bca:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104bd0:	8b 40 48             	mov    0x48(%eax),%eax
f0104bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104bd7:	c7 04 24 1c 9a 10 f0 	movl   $0xf0109a1c,(%esp)
f0104bde:	e8 f3 f6 ff ff       	call   f01042d6 <cprintf>
		print_trapframe(tf);
f0104be3:	89 1c 24             	mov    %ebx,(%esp)
f0104be6:	e8 e6 fd ff ff       	call   f01049d1 <print_trapframe>
		env_destroy(curenv);
f0104beb:	e8 39 23 00 00       	call   f0106f29 <cpunum>
f0104bf0:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bf3:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104bf9:	89 04 24             	mov    %eax,(%esp)
f0104bfc:	e8 b7 f3 ff ff       	call   f0103fb8 <env_destroy>
	}

	struct UTrapframe* utf = NULL;
	uint32_t cur_esp = tf->tf_esp;
f0104c01:	8b 43 3c             	mov    0x3c(%ebx),%eax

	if(tf->tf_esp < UXSTACKTOP && tf->tf_esp >= (UXSTACKTOP-PGSIZE)) {
f0104c04:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
		utf = (struct UTrapframe *)(cur_esp - 4);
f0104c0a:	83 e8 04             	sub    $0x4,%eax
f0104c0d:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f0104c13:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0104c18:	0f 46 d0             	cmovbe %eax,%edx
f0104c1b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	} else {
		utf = (struct UTrapframe *)UXSTACKTOP;
	}

	utf -= sizeof(struct UTrapframe)/4;
f0104c1e:	8d 82 5c fd ff ff    	lea    -0x2a4(%edx),%eax
f0104c24:	89 c7                	mov    %eax,%edi
f0104c26:	89 45 e0             	mov    %eax,-0x20(%ebp)

	user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_U);
f0104c29:	e8 fb 22 00 00       	call   f0106f29 <cpunum>
f0104c2e:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0104c35:	00 
f0104c36:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
f0104c3d:	00 
f0104c3e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104c42:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c45:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104c4b:	89 04 24             	mov    %eax,(%esp)
f0104c4e:	e8 e6 ec ff ff       	call   f0103939 <user_mem_assert>
	user_mem_assert(curenv, curenv->env_pgfault_upcall, 1, PTE_U);
f0104c53:	e8 d1 22 00 00       	call   f0106f29 <cpunum>
f0104c58:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c5b:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104c61:	8b 78 64             	mov    0x64(%eax),%edi
f0104c64:	e8 c0 22 00 00       	call   f0106f29 <cpunum>
f0104c69:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0104c70:	00 
f0104c71:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104c78:	00 
f0104c79:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104c7d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c80:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104c86:	89 04 24             	mov    %eax,(%esp)
f0104c89:	e8 ab ec ff ff       	call   f0103939 <user_mem_assert>
		
	utf->utf_fault_va = fault_va;
f0104c8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104c91:	89 b2 5c fd ff ff    	mov    %esi,-0x2a4(%edx)
	utf->utf_err = tf->tf_err;
f0104c97:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104c9a:	89 82 60 fd ff ff    	mov    %eax,-0x2a0(%edx)
	utf->utf_regs = tf->tf_regs;
f0104ca0:	8d ba 64 fd ff ff    	lea    -0x29c(%edx),%edi
f0104ca6:	89 de                	mov    %ebx,%esi
f0104ca8:	b8 20 00 00 00       	mov    $0x20,%eax
f0104cad:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0104cb3:	74 03                	je     f0104cb8 <page_fault_handler+0x14a>
f0104cb5:	a4                   	movsb  %ds:(%esi),%es:(%edi)
f0104cb6:	b0 1f                	mov    $0x1f,%al
f0104cb8:	f7 c7 02 00 00 00    	test   $0x2,%edi
f0104cbe:	74 05                	je     f0104cc5 <page_fault_handler+0x157>
f0104cc0:	66 a5                	movsw  %ds:(%esi),%es:(%edi)
f0104cc2:	83 e8 02             	sub    $0x2,%eax
f0104cc5:	89 c1                	mov    %eax,%ecx
f0104cc7:	c1 e9 02             	shr    $0x2,%ecx
f0104cca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0104ccc:	ba 00 00 00 00       	mov    $0x0,%edx
f0104cd1:	a8 02                	test   $0x2,%al
f0104cd3:	74 0b                	je     f0104ce0 <page_fault_handler+0x172>
f0104cd5:	0f b7 16             	movzwl (%esi),%edx
f0104cd8:	66 89 17             	mov    %dx,(%edi)
f0104cdb:	ba 02 00 00 00       	mov    $0x2,%edx
f0104ce0:	a8 01                	test   $0x1,%al
f0104ce2:	74 07                	je     f0104ceb <page_fault_handler+0x17d>
f0104ce4:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
f0104ce8:	88 04 17             	mov    %al,(%edi,%edx,1)
	utf->utf_eip = tf->tf_eip;
f0104ceb:	8b 43 30             	mov    0x30(%ebx),%eax
f0104cee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0104cf1:	89 81 84 fd ff ff    	mov    %eax,-0x27c(%ecx)
	utf->utf_eflags = tf->tf_eflags;
f0104cf7:	8b 43 38             	mov    0x38(%ebx),%eax
f0104cfa:	89 81 88 fd ff ff    	mov    %eax,-0x278(%ecx)
	utf->utf_esp = tf->tf_esp;
f0104d00:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104d03:	89 81 8c fd ff ff    	mov    %eax,-0x274(%ecx)

	tf->tf_eip = (uint32_t)(curenv->env_pgfault_upcall);
f0104d09:	e8 1b 22 00 00       	call   f0106f29 <cpunum>
f0104d0e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d11:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104d17:	8b 40 64             	mov    0x64(%eax),%eax
f0104d1a:	89 43 30             	mov    %eax,0x30(%ebx)
	tf->tf_esp = (uint32_t)utf;
f0104d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104d20:	89 43 3c             	mov    %eax,0x3c(%ebx)
	env_run(curenv);
f0104d23:	e8 01 22 00 00       	call   f0106f29 <cpunum>
f0104d28:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d2b:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104d31:	89 04 24             	mov    %eax,(%esp)
f0104d34:	e8 20 f3 ff ff       	call   f0104059 <env_run>

f0104d39 <trap>:
	}
}

void
trap(struct Trapframe *tf)
{
f0104d39:	55                   	push   %ebp
f0104d3a:	89 e5                	mov    %esp,%ebp
f0104d3c:	57                   	push   %edi
f0104d3d:	56                   	push   %esi
f0104d3e:	83 ec 20             	sub    $0x20,%esp
f0104d41:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f0104d44:	fc                   	cld    

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
f0104d45:	83 3d 8c 4e 2c f0 00 	cmpl   $0x0,0xf02c4e8c
f0104d4c:	74 01                	je     f0104d4f <trap+0x16>
		asm volatile("hlt");
f0104d4e:	f4                   	hlt    

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104d4f:	e8 d5 21 00 00       	call   f0106f29 <cpunum>
f0104d54:	6b d0 74             	imul   $0x74,%eax,%edx
f0104d57:	81 c2 20 50 2c f0    	add    $0xf02c5020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0104d5d:	b8 01 00 00 00       	mov    $0x1,%eax
f0104d62:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f0104d66:	83 f8 02             	cmp    $0x2,%eax
f0104d69:	75 0c                	jne    f0104d77 <trap+0x3e>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0104d6b:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f0104d72:	e8 30 24 00 00       	call   f01071a7 <spin_lock>

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
f0104d77:	9c                   	pushf  
f0104d78:	58                   	pop    %eax
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0104d79:	f6 c4 02             	test   $0x2,%ah
f0104d7c:	74 24                	je     f0104da2 <trap+0x69>
f0104d7e:	c7 44 24 0c 59 98 10 	movl   $0xf0109859,0xc(%esp)
f0104d85:	f0 
f0104d86:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0104d8d:	f0 
f0104d8e:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
f0104d95:	00 
f0104d96:	c7 04 24 4d 98 10 f0 	movl   $0xf010984d,(%esp)
f0104d9d:	e8 9e b2 ff ff       	call   f0100040 <_panic>

	if ((tf->tf_cs & 3) == 3) {
f0104da2:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104da6:	83 e0 03             	and    $0x3,%eax
f0104da9:	66 83 f8 03          	cmp    $0x3,%ax
f0104dad:	0f 85 a7 00 00 00    	jne    f0104e5a <trap+0x121>
f0104db3:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f0104dba:	e8 e8 23 00 00       	call   f01071a7 <spin_lock>
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		lock_kernel();
		assert(curenv);
f0104dbf:	e8 65 21 00 00       	call   f0106f29 <cpunum>
f0104dc4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dc7:	83 b8 28 50 2c f0 00 	cmpl   $0x0,-0xfd3afd8(%eax)
f0104dce:	75 24                	jne    f0104df4 <trap+0xbb>
f0104dd0:	c7 44 24 0c 72 98 10 	movl   $0xf0109872,0xc(%esp)
f0104dd7:	f0 
f0104dd8:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0104ddf:	f0 
f0104de0:	c7 44 24 04 5f 01 00 	movl   $0x15f,0x4(%esp)
f0104de7:	00 
f0104de8:	c7 04 24 4d 98 10 f0 	movl   $0xf010984d,(%esp)
f0104def:	e8 4c b2 ff ff       	call   f0100040 <_panic>

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
f0104df4:	e8 30 21 00 00       	call   f0106f29 <cpunum>
f0104df9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dfc:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104e02:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104e06:	75 2d                	jne    f0104e35 <trap+0xfc>
			env_free(curenv);
f0104e08:	e8 1c 21 00 00       	call   f0106f29 <cpunum>
f0104e0d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e10:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104e16:	89 04 24             	mov    %eax,(%esp)
f0104e19:	e8 cf ef ff ff       	call   f0103ded <env_free>
			curenv = NULL;
f0104e1e:	e8 06 21 00 00       	call   f0106f29 <cpunum>
f0104e23:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e26:	c7 80 28 50 2c f0 00 	movl   $0x0,-0xfd3afd8(%eax)
f0104e2d:	00 00 00 
			sched_yield();
f0104e30:	e8 73 03 00 00       	call   f01051a8 <sched_yield>
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f0104e35:	e8 ef 20 00 00       	call   f0106f29 <cpunum>
f0104e3a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e3d:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104e43:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104e48:	89 c7                	mov    %eax,%edi
f0104e4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0104e4c:	e8 d8 20 00 00       	call   f0106f29 <cpunum>
f0104e51:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e54:	8b b0 28 50 2c f0    	mov    -0xfd3afd8(%eax),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0104e5a:	89 35 60 4a 2c f0    	mov    %esi,0xf02c4a60
static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	// LAB 3: Your code here.
	switch (tf->tf_trapno) {
f0104e60:	8b 46 28             	mov    0x28(%esi),%eax
f0104e63:	83 f8 03             	cmp    $0x3,%eax
f0104e66:	74 31                	je     f0104e99 <trap+0x160>
f0104e68:	83 f8 03             	cmp    $0x3,%eax
f0104e6b:	77 07                	ja     f0104e74 <trap+0x13b>
f0104e6d:	83 f8 01             	cmp    $0x1,%eax
f0104e70:	74 1a                	je     f0104e8c <trap+0x153>
f0104e72:	eb 67                	jmp    f0104edb <trap+0x1a2>
f0104e74:	83 f8 0e             	cmp    $0xe,%eax
f0104e77:	74 0b                	je     f0104e84 <trap+0x14b>
f0104e79:	83 f8 30             	cmp    $0x30,%eax
f0104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104e80:	74 24                	je     f0104ea6 <trap+0x16d>
f0104e82:	eb 57                	jmp    f0104edb <trap+0x1a2>

		case T_PGFLT:
			page_fault_handler(tf);
f0104e84:	89 34 24             	mov    %esi,(%esp)
f0104e87:	e8 e2 fc ff ff       	call   f0104b6e <page_fault_handler>
			return;

		case T_DEBUG:
			monitor(tf);
f0104e8c:	89 34 24             	mov    %esi,(%esp)
f0104e8f:	e8 4a bf ff ff       	call   f0100dde <monitor>
f0104e94:	e9 15 01 00 00       	jmp    f0104fae <trap+0x275>
			return;

		case T_BRKPT:
			monitor(tf);
f0104e99:	89 34 24             	mov    %esi,(%esp)
f0104e9c:	e8 3d bf ff ff       	call   f0100dde <monitor>
f0104ea1:	e9 08 01 00 00       	jmp    f0104fae <trap+0x275>
			return;

		case T_SYSCALL:
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);
f0104ea6:	8b 46 04             	mov    0x4(%esi),%eax
f0104ea9:	89 44 24 14          	mov    %eax,0x14(%esp)
f0104ead:	8b 06                	mov    (%esi),%eax
f0104eaf:	89 44 24 10          	mov    %eax,0x10(%esp)
f0104eb3:	8b 46 10             	mov    0x10(%esi),%eax
f0104eb6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104eba:	8b 46 18             	mov    0x18(%esi),%eax
f0104ebd:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104ec1:	8b 46 14             	mov    0x14(%esi),%eax
f0104ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ec8:	8b 46 1c             	mov    0x1c(%esi),%eax
f0104ecb:	89 04 24             	mov    %eax,(%esp)
f0104ece:	e8 fd 03 00 00       	call   f01052d0 <syscall>
f0104ed3:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104ed6:	e9 d3 00 00 00       	jmp    f0104fae <trap+0x275>
	}

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104edb:	83 f8 27             	cmp    $0x27,%eax
f0104ede:	75 19                	jne    f0104ef9 <trap+0x1c0>
		cprintf("Spurious interrupt on irq 7\n");
f0104ee0:	c7 04 24 79 98 10 f0 	movl   $0xf0109879,(%esp)
f0104ee7:	e8 ea f3 ff ff       	call   f01042d6 <cprintf>
		print_trapframe(tf);
f0104eec:	89 34 24             	mov    %esi,(%esp)
f0104eef:	e8 dd fa ff ff       	call   f01049d1 <print_trapframe>
f0104ef4:	e9 b5 00 00 00       	jmp    f0104fae <trap+0x275>
	}

	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f0104ef9:	83 f8 20             	cmp    $0x20,%eax
f0104efc:	75 1c                	jne    f0104f1a <trap+0x1e1>
		lapic_eoi();
f0104efe:	66 90                	xchg   %ax,%ax
f0104f00:	e8 71 21 00 00       	call   f0107076 <lapic_eoi>
		if (cpunum() == 0)
f0104f05:	e8 1f 20 00 00       	call   f0106f29 <cpunum>
f0104f0a:	85 c0                	test   %eax,%eax
f0104f0c:	75 07                	jne    f0104f15 <trap+0x1dc>
			time_tick();
f0104f0e:	66 90                	xchg   %ax,%ax
f0104f10:	e8 64 2f 00 00       	call   f0107e79 <time_tick>
		sched_yield();
f0104f15:	e8 8e 02 00 00       	call   f01051a8 <sched_yield>
	// Was more logical in my opinion to implement it alongside the previous if condition.

	// Handling interrupt from NIC
	// LAB 6

	if (tf->tf_trapno == IRQ_OFFSET +IRQ_NIC) {
f0104f1a:	83 f8 2b             	cmp    $0x2b,%eax
f0104f1d:	75 2d                	jne    f0104f4c <trap+0x213>
		uint32_t icr_reg = nic_get_reg(E1000_ICR);
f0104f1f:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
f0104f26:	e8 60 24 00 00       	call   f010738b <nic_get_reg>
		enum EnvChannel channel;

		if (icr_reg & E1000_ICR_TXDW)
			channel = ENV_CHANNEL_TX;
		
		if (icr_reg & E1000_ICR_RXT0)
f0104f2b:	25 80 00 00 00       	and    $0x80,%eax
f0104f30:	83 f8 01             	cmp    $0x1,%eax
f0104f33:	19 c0                	sbb    %eax,%eax
f0104f35:	83 c0 02             	add    $0x2,%eax
			channel = ENV_CHANNEL_RX;

		wakeup(channel);
f0104f38:	89 04 24             	mov    %eax,(%esp)
f0104f3b:	e8 e2 f1 ff ff       	call   f0104122 <wakeup>
		lapic_eoi();
f0104f40:	e8 31 21 00 00       	call   f0107076 <lapic_eoi>
		irq_eoi();
f0104f45:	e8 33 f3 ff ff       	call   f010427d <irq_eoi>
f0104f4a:	eb 62                	jmp    f0104fae <trap+0x275>
	}


	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
f0104f4c:	83 f8 21             	cmp    $0x21,%eax
f0104f4f:	90                   	nop
f0104f50:	75 07                	jne    f0104f59 <trap+0x220>
		kbd_intr();
f0104f52:	e8 fc b6 ff ff       	call   f0100653 <kbd_intr>
f0104f57:	eb 55                	jmp    f0104fae <trap+0x275>
		return;
	}

	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
f0104f59:	83 f8 24             	cmp    $0x24,%eax
f0104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104f60:	75 07                	jne    f0104f69 <trap+0x230>
		serial_intr();
f0104f62:	e8 d0 b6 ff ff       	call   f0100637 <serial_intr>
f0104f67:	eb 45                	jmp    f0104fae <trap+0x275>
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f0104f69:	89 34 24             	mov    %esi,(%esp)
f0104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104f70:	e8 5c fa ff ff       	call   f01049d1 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104f75:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104f7a:	75 1c                	jne    f0104f98 <trap+0x25f>
		panic("unhandled trap in kernel");
f0104f7c:	c7 44 24 08 96 98 10 	movl   $0xf0109896,0x8(%esp)
f0104f83:	f0 
f0104f84:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
f0104f8b:	00 
f0104f8c:	c7 04 24 4d 98 10 f0 	movl   $0xf010984d,(%esp)
f0104f93:	e8 a8 b0 ff ff       	call   f0100040 <_panic>
	else {
		env_destroy(curenv);
f0104f98:	e8 8c 1f 00 00       	call   f0106f29 <cpunum>
f0104f9d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fa0:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104fa6:	89 04 24             	mov    %eax,(%esp)
f0104fa9:	e8 0a f0 ff ff       	call   f0103fb8 <env_destroy>
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104fae:	e8 76 1f 00 00       	call   f0106f29 <cpunum>
f0104fb3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fb6:	83 b8 28 50 2c f0 00 	cmpl   $0x0,-0xfd3afd8(%eax)
f0104fbd:	74 2a                	je     f0104fe9 <trap+0x2b0>
f0104fbf:	e8 65 1f 00 00       	call   f0106f29 <cpunum>
f0104fc4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fc7:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104fcd:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104fd1:	75 16                	jne    f0104fe9 <trap+0x2b0>
		env_run(curenv);
f0104fd3:	e8 51 1f 00 00       	call   f0106f29 <cpunum>
f0104fd8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fdb:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0104fe1:	89 04 24             	mov    %eax,(%esp)
f0104fe4:	e8 70 f0 ff ff       	call   f0104059 <env_run>
	else
		sched_yield();
f0104fe9:	e8 ba 01 00 00       	call   f01051a8 <sched_yield>

f0104fee <IRQ_0>:
	pushl $(num);							\
	jmp _alltraps

.text

TRAPHANDLER_NOEC(IRQ_0, IRQ_OFFSET + 0)
f0104fee:	6a 00                	push   $0x0
f0104ff0:	6a 20                	push   $0x20
f0104ff2:	e9 c1 00 00 00       	jmp    f01050b8 <_alltraps>
f0104ff7:	90                   	nop

f0104ff8 <IRQ_1>:
TRAPHANDLER_NOEC(IRQ_1, IRQ_OFFSET + 1)
f0104ff8:	6a 00                	push   $0x0
f0104ffa:	6a 21                	push   $0x21
f0104ffc:	e9 b7 00 00 00       	jmp    f01050b8 <_alltraps>
f0105001:	90                   	nop

f0105002 <IRQ_2>:
TRAPHANDLER_NOEC(IRQ_2, IRQ_OFFSET + 2)
f0105002:	6a 00                	push   $0x0
f0105004:	6a 22                	push   $0x22
f0105006:	e9 ad 00 00 00       	jmp    f01050b8 <_alltraps>
f010500b:	90                   	nop

f010500c <IRQ_3>:
TRAPHANDLER_NOEC(IRQ_3, IRQ_OFFSET + 3)
f010500c:	6a 00                	push   $0x0
f010500e:	6a 23                	push   $0x23
f0105010:	e9 a3 00 00 00       	jmp    f01050b8 <_alltraps>
f0105015:	90                   	nop

f0105016 <IRQ_4>:
TRAPHANDLER_NOEC(IRQ_4, IRQ_OFFSET + 4)
f0105016:	6a 00                	push   $0x0
f0105018:	6a 24                	push   $0x24
f010501a:	e9 99 00 00 00       	jmp    f01050b8 <_alltraps>
f010501f:	90                   	nop

f0105020 <IRQ_5>:
TRAPHANDLER_NOEC(IRQ_5, IRQ_OFFSET + 5)
f0105020:	6a 00                	push   $0x0
f0105022:	6a 25                	push   $0x25
f0105024:	e9 8f 00 00 00       	jmp    f01050b8 <_alltraps>
f0105029:	90                   	nop

f010502a <IRQ_6>:
TRAPHANDLER_NOEC(IRQ_6, IRQ_OFFSET + 6)
f010502a:	6a 00                	push   $0x0
f010502c:	6a 26                	push   $0x26
f010502e:	e9 85 00 00 00       	jmp    f01050b8 <_alltraps>
f0105033:	90                   	nop

f0105034 <IRQ_7>:
TRAPHANDLER_NOEC(IRQ_7, IRQ_OFFSET + 7)
f0105034:	6a 00                	push   $0x0
f0105036:	6a 27                	push   $0x27
f0105038:	eb 7e                	jmp    f01050b8 <_alltraps>

f010503a <IRQ_8>:
TRAPHANDLER_NOEC(IRQ_8, IRQ_OFFSET + 8)
f010503a:	6a 00                	push   $0x0
f010503c:	6a 28                	push   $0x28
f010503e:	eb 78                	jmp    f01050b8 <_alltraps>

f0105040 <IRQ_9>:
TRAPHANDLER_NOEC(IRQ_9, IRQ_OFFSET + 9)
f0105040:	6a 00                	push   $0x0
f0105042:	6a 29                	push   $0x29
f0105044:	eb 72                	jmp    f01050b8 <_alltraps>

f0105046 <IRQ_10>:
TRAPHANDLER_NOEC(IRQ_10, IRQ_OFFSET + 10)
f0105046:	6a 00                	push   $0x0
f0105048:	6a 2a                	push   $0x2a
f010504a:	eb 6c                	jmp    f01050b8 <_alltraps>

f010504c <IRQ_11>:
TRAPHANDLER_NOEC(IRQ_11, IRQ_OFFSET + 11)
f010504c:	6a 00                	push   $0x0
f010504e:	6a 2b                	push   $0x2b
f0105050:	eb 66                	jmp    f01050b8 <_alltraps>

f0105052 <IRQ_12>:
TRAPHANDLER_NOEC(IRQ_12, IRQ_OFFSET + 12)
f0105052:	6a 00                	push   $0x0
f0105054:	6a 2c                	push   $0x2c
f0105056:	eb 60                	jmp    f01050b8 <_alltraps>

f0105058 <IRQ_13>:
TRAPHANDLER_NOEC(IRQ_13, IRQ_OFFSET + 13)
f0105058:	6a 00                	push   $0x0
f010505a:	6a 2d                	push   $0x2d
f010505c:	eb 5a                	jmp    f01050b8 <_alltraps>

f010505e <IRQ_14>:
TRAPHANDLER_NOEC(IRQ_14, IRQ_OFFSET + 14)
f010505e:	6a 00                	push   $0x0
f0105060:	6a 2e                	push   $0x2e
f0105062:	eb 54                	jmp    f01050b8 <_alltraps>

f0105064 <IRQ_15>:
TRAPHANDLER_NOEC(IRQ_15, IRQ_OFFSET + 15)
f0105064:	6a 00                	push   $0x0
f0105066:	6a 2f                	push   $0x2f
f0105068:	eb 4e                	jmp    f01050b8 <_alltraps>

f010506a <t_func_divide>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
 
	TRAPHANDLER_NOEC(t_func_divide, 0)
f010506a:	6a 00                	push   $0x0
f010506c:	6a 00                	push   $0x0
f010506e:	eb 48                	jmp    f01050b8 <_alltraps>

f0105070 <t_func_debug>:
	TRAPHANDLER_NOEC(t_func_debug, 1)
f0105070:	6a 00                	push   $0x0
f0105072:	6a 01                	push   $0x1
f0105074:	eb 42                	jmp    f01050b8 <_alltraps>

f0105076 <t_func_brkpt>:
	TRAPHANDLER_NOEC(t_func_brkpt, 3)
f0105076:	6a 00                	push   $0x0
f0105078:	6a 03                	push   $0x3
f010507a:	eb 3c                	jmp    f01050b8 <_alltraps>

f010507c <t_func_oflow>:
	TRAPHANDLER_NOEC(t_func_oflow, 4)
f010507c:	6a 00                	push   $0x0
f010507e:	6a 04                	push   $0x4
f0105080:	eb 36                	jmp    f01050b8 <_alltraps>

f0105082 <t_func_bound>:
	TRAPHANDLER_NOEC(t_func_bound, 5)
f0105082:	6a 00                	push   $0x0
f0105084:	6a 05                	push   $0x5
f0105086:	eb 30                	jmp    f01050b8 <_alltraps>

f0105088 <t_func_illop>:
	TRAPHANDLER_NOEC(t_func_illop, 6)
f0105088:	6a 00                	push   $0x0
f010508a:	6a 06                	push   $0x6
f010508c:	eb 2a                	jmp    f01050b8 <_alltraps>

f010508e <t_func_device>:
	TRAPHANDLER_NOEC(t_func_device, 7)
f010508e:	6a 00                	push   $0x0
f0105090:	6a 07                	push   $0x7
f0105092:	eb 24                	jmp    f01050b8 <_alltraps>

f0105094 <t_func_dblfit>:
	TRAPHANDLER(t_func_dblfit, 8)
f0105094:	6a 08                	push   $0x8
f0105096:	eb 20                	jmp    f01050b8 <_alltraps>

f0105098 <t_func_tss>:
	//TRAPHANDLER_NOEC(th9, 9)
	TRAPHANDLER(t_func_tss, 10)
f0105098:	6a 0a                	push   $0xa
f010509a:	eb 1c                	jmp    f01050b8 <_alltraps>

f010509c <t_func_segnp>:
	TRAPHANDLER(t_func_segnp, 11)
f010509c:	6a 0b                	push   $0xb
f010509e:	eb 18                	jmp    f01050b8 <_alltraps>

f01050a0 <t_func_stack>:
	TRAPHANDLER(t_func_stack, 12)
f01050a0:	6a 0c                	push   $0xc
f01050a2:	eb 14                	jmp    f01050b8 <_alltraps>

f01050a4 <t_func_gpflt>:
	TRAPHANDLER(t_func_gpflt, 13)
f01050a4:	6a 0d                	push   $0xd
f01050a6:	eb 10                	jmp    f01050b8 <_alltraps>

f01050a8 <t_func_pgflt>:
	TRAPHANDLER(t_func_pgflt, 14)
f01050a8:	6a 0e                	push   $0xe
f01050aa:	eb 0c                	jmp    f01050b8 <_alltraps>

f01050ac <t_func_fperr>:
	TRAPHANDLER_NOEC(t_func_fperr, 16)
f01050ac:	6a 00                	push   $0x0
f01050ae:	6a 10                	push   $0x10
f01050b0:	eb 06                	jmp    f01050b8 <_alltraps>

f01050b2 <t_func_syscall>:

	TRAPHANDLER_NOEC(t_func_syscall, 48)
f01050b2:	6a 00                	push   $0x0
f01050b4:	6a 30                	push   $0x30
f01050b6:	eb 00                	jmp    f01050b8 <_alltraps>

f01050b8 <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
 
 _alltraps:	pushl %ds
f01050b8:	1e                   	push   %ds
			pushl %es
f01050b9:	06                   	push   %es
			pushal
f01050ba:	60                   	pusha  
			movw $GD_KD, %ax
f01050bb:	66 b8 10 00          	mov    $0x10,%ax
			movw %ax, %ds
f01050bf:	8e d8                	mov    %eax,%ds
			movw %ax, %es
f01050c1:	8e c0                	mov    %eax,%es
			pushl %esp
f01050c3:	54                   	push   %esp
			call trap
f01050c4:	e8 70 fc ff ff       	call   f0104d39 <trap>

f01050c9 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01050c9:	55                   	push   %ebp
f01050ca:	89 e5                	mov    %esp,%ebp
f01050cc:	83 ec 18             	sub    $0x18,%esp
f01050cf:	a1 4c 42 2c f0       	mov    0xf02c424c,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01050d4:	ba 00 00 00 00       	mov    $0x0,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_NOT_RUNNABLE || // Environment might be waiting for IPC or network
f01050d9:	8b 48 54             	mov    0x54(%eax),%ecx
f01050dc:	83 e9 01             	sub    $0x1,%ecx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01050df:	83 f9 03             	cmp    $0x3,%ecx
f01050e2:	77 06                	ja     f01050ea <sched_halt+0x21>
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_NOT_RUNNABLE || // Environment might be waiting for IPC or network
		     envs[i].env_status == ENV_DYING
		     ) && envs[i].env_type == ENV_TYPE_USER)
f01050e4:	83 78 50 00          	cmpl   $0x0,0x50(%eax)
f01050e8:	74 12                	je     f01050fc <sched_halt+0x33>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01050ea:	83 c2 01             	add    $0x1,%edx
f01050ed:	05 84 00 00 00       	add    $0x84,%eax
f01050f2:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f01050f8:	75 df                	jne    f01050d9 <sched_halt+0x10>
f01050fa:	eb 08                	jmp    f0105104 <sched_halt+0x3b>
		     envs[i].env_status == ENV_NOT_RUNNABLE || // Environment might be waiting for IPC or network
		     envs[i].env_status == ENV_DYING
		     ) && envs[i].env_type == ENV_TYPE_USER)
			break;
	}
	if (i == NENV) {
f01050fc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f0105102:	75 1a                	jne    f010511e <sched_halt+0x55>
		cprintf("No runnable environments in the system!\n");
f0105104:	c7 04 24 90 9a 10 f0 	movl   $0xf0109a90,(%esp)
f010510b:	e8 c6 f1 ff ff       	call   f01042d6 <cprintf>
		while (1)
			monitor(NULL);
f0105110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0105117:	e8 c2 bc ff ff       	call   f0100dde <monitor>
f010511c:	eb f2                	jmp    f0105110 <sched_halt+0x47>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f010511e:	e8 06 1e 00 00       	call   f0106f29 <cpunum>
f0105123:	6b c0 74             	imul   $0x74,%eax,%eax
f0105126:	c7 80 28 50 2c f0 00 	movl   $0x0,-0xfd3afd8(%eax)
f010512d:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0105130:	a1 98 4e 2c f0       	mov    0xf02c4e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0105135:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010513a:	77 20                	ja     f010515c <sched_halt+0x93>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010513c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105140:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0105147:	f0 
f0105148:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
f010514f:	00 
f0105150:	c7 04 24 b9 9a 10 f0 	movl   $0xf0109ab9,(%esp)
f0105157:	e8 e4 ae ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010515c:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0105161:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0105164:	e8 c0 1d 00 00       	call   f0106f29 <cpunum>
f0105169:	6b d0 74             	imul   $0x74,%eax,%edx
f010516c:	81 c2 20 50 2c f0    	add    $0xf02c5020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0105172:	b8 02 00 00 00       	mov    $0x2,%eax
f0105177:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010517b:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f0105182:	e8 cc 20 00 00       	call   f0107253 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0105187:	f3 90                	pause  
		"pushl $0\n"
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0105189:	e8 9b 1d 00 00       	call   f0106f29 <cpunum>
f010518e:	6b c0 74             	imul   $0x74,%eax,%eax

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
f0105191:	8b 80 30 50 2c f0    	mov    -0xfd3afd0(%eax),%eax
f0105197:	bd 00 00 00 00       	mov    $0x0,%ebp
f010519c:	89 c4                	mov    %eax,%esp
f010519e:	6a 00                	push   $0x0
f01051a0:	6a 00                	push   $0x0
f01051a2:	fb                   	sti    
f01051a3:	f4                   	hlt    
f01051a4:	eb fd                	jmp    f01051a3 <sched_halt+0xda>
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
}
f01051a6:	c9                   	leave  
f01051a7:	c3                   	ret    

f01051a8 <sched_yield>:
void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f01051a8:	55                   	push   %ebp
f01051a9:	89 e5                	mov    %esp,%ebp
f01051ab:	57                   	push   %edi
f01051ac:	56                   	push   %esi
f01051ad:	53                   	push   %ebx
f01051ae:	83 ec 1c             	sub    $0x1c,%esp
	// another CPU (env_status == ENV_RUNNING). If there are
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.

	// LAB 4: Your code here.
	int start = curenv ? ENVX(curenv->env_id) + 1: 0;
f01051b1:	e8 73 1d 00 00       	call   f0106f29 <cpunum>
f01051b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01051b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01051c0:	83 b8 28 50 2c f0 00 	cmpl   $0x0,-0xfd3afd8(%eax)
f01051c7:	74 1c                	je     f01051e5 <sched_yield+0x3d>
f01051c9:	e8 5b 1d 00 00       	call   f0106f29 <cpunum>
f01051ce:	6b c0 74             	imul   $0x74,%eax,%eax
f01051d1:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f01051d7:	8b 40 48             	mov    0x48(%eax),%eax
f01051da:	25 ff 03 00 00       	and    $0x3ff,%eax
f01051df:	83 c0 01             	add    $0x1,%eax
f01051e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int current_pri = curenv ? curenv->pri : 200;
f01051e5:	e8 3f 1d 00 00       	call   f0106f29 <cpunum>
f01051ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01051ed:	c7 45 dc c8 00 00 00 	movl   $0xc8,-0x24(%ebp)
f01051f4:	83 b8 28 50 2c f0 00 	cmpl   $0x0,-0xfd3afd8(%eax)
f01051fb:	74 14                	je     f0105211 <sched_yield+0x69>
f01051fd:	e8 27 1d 00 00       	call   f0106f29 <cpunum>
f0105202:	6b c0 74             	imul   $0x74,%eax,%eax
f0105205:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f010520b:	8b 40 7c             	mov    0x7c(%eax),%eax
f010520e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int pri = 200;
	bool found = false;
	
	for (j = 0; j < NENV; j++) {
		i = (start + j) % NENV;
		if (envs[i].env_status == ENV_RUNNABLE){
f0105211:	8b 1d 4c 42 2c f0    	mov    0xf02c424c,%ebx
f0105217:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010521a:	89 f8                	mov    %edi,%eax
f010521c:	8d b7 00 04 00 00    	lea    0x400(%edi),%esi
	// LAB 4: Your code here.
	int start = curenv ? ENVX(curenv->env_id) + 1: 0;
	int current_pri = curenv ? curenv->pri : 200;
	int i, j, env_to_run = start;
	int pri = 200;
	bool found = false;
f0105222:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)

	// LAB 4: Your code here.
	int start = curenv ? ENVX(curenv->env_id) + 1: 0;
	int current_pri = curenv ? curenv->pri : 200;
	int i, j, env_to_run = start;
	int pri = 200;
f0105226:	bf c8 00 00 00       	mov    $0xc8,%edi
	bool found = false;
	
	for (j = 0; j < NENV; j++) {
		i = (start + j) % NENV;
f010522b:	89 c1                	mov    %eax,%ecx
f010522d:	c1 f9 1f             	sar    $0x1f,%ecx
f0105230:	c1 e9 16             	shr    $0x16,%ecx
f0105233:	8d 14 08             	lea    (%eax,%ecx,1),%edx
f0105236:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f010523c:	29 ca                	sub    %ecx,%edx
		if (envs[i].env_status == ENV_RUNNABLE){
f010523e:	89 d1                	mov    %edx,%ecx
f0105240:	c1 e1 07             	shl    $0x7,%ecx
f0105243:	8d 0c 91             	lea    (%ecx,%edx,4),%ecx
f0105246:	01 d9                	add    %ebx,%ecx
f0105248:	83 79 54 02          	cmpl   $0x2,0x54(%ecx)
f010524c:	75 10                	jne    f010525e <sched_yield+0xb6>
			if(envs[i].pri < pri){
f010524e:	8b 49 7c             	mov    0x7c(%ecx),%ecx
f0105251:	39 f9                	cmp    %edi,%ecx
f0105253:	7d 09                	jge    f010525e <sched_yield+0xb6>
				found = true;
				pri = envs[i].pri;
f0105255:	89 cf                	mov    %ecx,%edi
				env_to_run = i;
f0105257:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	
	for (j = 0; j < NENV; j++) {
		i = (start + j) % NENV;
		if (envs[i].env_status == ENV_RUNNABLE){
			if(envs[i].pri < pri){
				found = true;
f010525a:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
f010525e:	83 c0 01             	add    $0x1,%eax
	int current_pri = curenv ? curenv->pri : 200;
	int i, j, env_to_run = start;
	int pri = 200;
	bool found = false;
	
	for (j = 0; j < NENV; j++) {
f0105261:	39 f0                	cmp    %esi,%eax
f0105263:	75 c6                	jne    f010522b <sched_yield+0x83>
				env_to_run = i;
			}
		}
	}

	if ((found) && (current_pri >= envs[env_to_run].pri)) {
f0105265:	80 7d e3 00          	cmpb   $0x0,-0x1d(%ebp)
f0105269:	74 1d                	je     f0105288 <sched_yield+0xe0>
f010526b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010526e:	89 f8                	mov    %edi,%eax
f0105270:	c1 e0 07             	shl    $0x7,%eax
f0105273:	8d 04 b8             	lea    (%eax,%edi,4),%eax
f0105276:	01 c3                	add    %eax,%ebx
f0105278:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010527b:	3b 43 7c             	cmp    0x7c(%ebx),%eax
f010527e:	7c 08                	jl     f0105288 <sched_yield+0xe0>
		env_run(&envs[env_to_run]);
f0105280:	89 1c 24             	mov    %ebx,(%esp)
f0105283:	e8 d1 ed ff ff       	call   f0104059 <env_run>
	} else if (curenv && curenv->env_status == ENV_RUNNING) {
f0105288:	e8 9c 1c 00 00       	call   f0106f29 <cpunum>
f010528d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105290:	83 b8 28 50 2c f0 00 	cmpl   $0x0,-0xfd3afd8(%eax)
f0105297:	74 2a                	je     f01052c3 <sched_yield+0x11b>
f0105299:	e8 8b 1c 00 00       	call   f0106f29 <cpunum>
f010529e:	6b c0 74             	imul   $0x74,%eax,%eax
f01052a1:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f01052a7:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01052ab:	75 16                	jne    f01052c3 <sched_yield+0x11b>
		env_run(curenv);
f01052ad:	e8 77 1c 00 00       	call   f0106f29 <cpunum>
f01052b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01052b5:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f01052bb:	89 04 24             	mov    %eax,(%esp)
f01052be:	e8 96 ed ff ff       	call   f0104059 <env_run>
	}

	// sched_halt never returns
	sched_halt();
f01052c3:	e8 01 fe ff ff       	call   f01050c9 <sched_halt>
}
f01052c8:	83 c4 1c             	add    $0x1c,%esp
f01052cb:	5b                   	pop    %ebx
f01052cc:	5e                   	pop    %esi
f01052cd:	5f                   	pop    %edi
f01052ce:	5d                   	pop    %ebp
f01052cf:	c3                   	ret    

f01052d0 <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01052d0:	55                   	push   %ebp
f01052d1:	89 e5                	mov    %esp,%ebp
f01052d3:	57                   	push   %edi
f01052d4:	56                   	push   %esi
f01052d5:	53                   	push   %ebx
f01052d6:	81 ec bc 00 00 00    	sub    $0xbc,%esp
f01052dc:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	switch (syscallno) {
f01052df:	83 f8 13             	cmp    $0x13,%eax
f01052e2:	0f 87 3f 08 00 00    	ja     f0105b27 <syscall+0x857>
f01052e8:	ff 24 85 c8 9a 10 f0 	jmp    *-0xfef6538(,%eax,4)

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f01052ef:	e8 35 1c 00 00       	call   f0106f29 <cpunum>
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.
	struct Env *env;
	envid2env(sys_getenvid(), &env, 1);
f01052f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01052fb:	00 
f01052fc:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
f0105302:	89 54 24 04          	mov    %edx,0x4(%esp)

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f0105306:	6b c0 74             	imul   $0x74,%eax,%eax
f0105309:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.
	struct Env *env;
	envid2env(sys_getenvid(), &env, 1);
f010530f:	8b 40 48             	mov    0x48(%eax),%eax
f0105312:	89 04 24             	mov    %eax,(%esp)
f0105315:	e8 f2 e6 ff ff       	call   f0103a0c <envid2env>
	user_mem_assert(env, s, len, PTE_U);
f010531a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105321:	00 
f0105322:	8b 45 10             	mov    0x10(%ebp),%eax
f0105325:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105329:	8b 45 0c             	mov    0xc(%ebp),%eax
f010532c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105330:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
f0105336:	89 04 24             	mov    %eax,(%esp)
f0105339:	e8 fb e5 ff ff       	call   f0103939 <user_mem_assert>
	

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f010533e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105341:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105345:	8b 45 10             	mov    0x10(%ebp),%eax
f0105348:	89 44 24 04          	mov    %eax,0x4(%esp)
f010534c:	c7 04 24 eb 84 10 f0 	movl   $0xf01084eb,(%esp)
f0105353:	e8 7e ef ff ff       	call   f01042d6 <cprintf>

	switch (syscallno) {

		case SYS_cputs:
			sys_cputs((char*)(a1), a2);
			return 0;
f0105358:	b8 00 00 00 00       	mov    $0x0,%eax
f010535d:	e9 d1 07 00 00       	jmp    f0105b33 <syscall+0x863>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0105362:	e8 fe b2 ff ff       	call   f0100665 <cons_getc>
		case SYS_cputs:
			sys_cputs((char*)(a1), a2);
			return 0;

		case SYS_cgetc:
			return sys_cgetc();
f0105367:	e9 c7 07 00 00       	jmp    f0105b33 <syscall+0x863>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105370:	e8 b4 1b 00 00       	call   f0106f29 <cpunum>
f0105375:	6b c0 74             	imul   $0x74,%eax,%eax
f0105378:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f010537e:	8b 40 48             	mov    0x48(%eax),%eax

		case SYS_cgetc:
			return sys_cgetc();

		case SYS_getenvid:
			return sys_getenvid();
f0105381:	e9 ad 07 00 00       	jmp    f0105b33 <syscall+0x863>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0105386:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010538d:	00 
f010538e:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f0105394:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105398:	8b 45 0c             	mov    0xc(%ebp),%eax
f010539b:	89 04 24             	mov    %eax,(%esp)
f010539e:	e8 69 e6 ff ff       	call   f0103a0c <envid2env>
		return r;
f01053a3:	89 c2                	mov    %eax,%edx
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f01053a5:	85 c0                	test   %eax,%eax
f01053a7:	78 13                	js     f01053bc <syscall+0xec>
	/*if (e == curenv)
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
	*/
	env_destroy(e);
f01053a9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
f01053af:	89 04 24             	mov    %eax,(%esp)
f01053b2:	e8 01 ec ff ff       	call   f0103fb8 <env_destroy>
	return 0;
f01053b7:	ba 00 00 00 00       	mov    $0x0,%edx

		case SYS_getenvid:
			return sys_getenvid();

		case SYS_env_destroy:
			return sys_env_destroy(a1);
f01053bc:	89 d0                	mov    %edx,%eax
f01053be:	e9 70 07 00 00       	jmp    f0105b33 <syscall+0x863>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f01053c3:	e8 e0 fd ff ff       	call   f01051a8 <sched_yield>
	// will appear to return 0.

	// LAB 4: Your code here.

	struct Env env;
	struct Env *new_env = &env;
f01053c8:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f01053ce:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)

	int ret_value = env_alloc(&new_env, curenv->env_id);
f01053d4:	e8 50 1b 00 00       	call   f0106f29 <cpunum>
f01053d9:	6b c0 74             	imul   $0x74,%eax,%eax
f01053dc:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f01053e2:	8b 40 48             	mov    0x48(%eax),%eax
f01053e5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053e9:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
f01053ef:	89 04 24             	mov    %eax,(%esp)
f01053f2:	e8 26 e7 ff ff       	call   f0103b1d <env_alloc>
	if (ret_value < 0)
		return ret_value;
f01053f7:	89 c2                	mov    %eax,%edx

	struct Env env;
	struct Env *new_env = &env;

	int ret_value = env_alloc(&new_env, curenv->env_id);
	if (ret_value < 0)
f01053f9:	85 c0                	test   %eax,%eax
f01053fb:	78 34                	js     f0105431 <syscall+0x161>
		return ret_value;

	new_env->env_status = ENV_NOT_RUNNABLE;
f01053fd:	8b 9d 60 ff ff ff    	mov    -0xa0(%ebp),%ebx
f0105403:	c7 43 54 04 00 00 00 	movl   $0x4,0x54(%ebx)
	new_env->env_tf = curenv->env_tf;
f010540a:	e8 1a 1b 00 00       	call   f0106f29 <cpunum>
f010540f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105412:	8b b0 28 50 2c f0    	mov    -0xfd3afd8(%eax),%esi
f0105418:	b9 11 00 00 00       	mov    $0x11,%ecx
f010541d:	89 df                	mov    %ebx,%edi
f010541f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	new_env->env_tf.tf_regs.reg_eax = 0;
f0105421:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f0105427:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	return new_env->env_id;
f010542e:	8b 50 48             	mov    0x48(%eax),%edx
		case SYS_yield:
			sys_yield();
			return -1;
	
		case SYS_exofork:
			return sys_exofork();
f0105431:	89 d0                	mov    %edx,%eax
f0105433:	e9 fb 06 00 00       	jmp    f0105b33 <syscall+0x863>
	// envid's status.

	// LAB 4: Your code here.

	struct Env temp;
	struct Env *env = &temp;
f0105438:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f010543e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)

	int ret_value = envid2env(envid, &env, 1);
f0105444:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010544b:	00 
f010544c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
f0105452:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105456:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105459:	89 04 24             	mov    %eax,(%esp)
f010545c:	e8 ab e5 ff ff       	call   f0103a0c <envid2env>
	if (ret_value < 0)
f0105461:	85 c0                	test   %eax,%eax
f0105463:	0f 88 ca 06 00 00    	js     f0105b33 <syscall+0x863>
		return ret_value;

	if ((status != ENV_RUNNABLE) && (status != ENV_NOT_RUNNABLE))
f0105469:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f010546d:	74 06                	je     f0105475 <syscall+0x1a5>
f010546f:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f0105473:	75 16                	jne    f010548b <syscall+0x1bb>
		return -E_INVAL;

	env->env_status = status;
f0105475:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f010547b:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010547e:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f0105481:	b8 00 00 00 00       	mov    $0x0,%eax
f0105486:	e9 a8 06 00 00       	jmp    f0105b33 <syscall+0x863>
	int ret_value = envid2env(envid, &env, 1);
	if (ret_value < 0)
		return ret_value;

	if ((status != ENV_RUNNABLE) && (status != ENV_NOT_RUNNABLE))
		return -E_INVAL;
f010548b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	
		case SYS_exofork:
			return sys_exofork();

		case SYS_env_set_status:
			return sys_env_set_status((envid_t) a1, (int) a2);
f0105490:	e9 9e 06 00 00       	jmp    f0105b33 <syscall+0x863>
	//   allocated!

	// LAB 4: Your code here.
	
	struct Env temp;
	struct Env *env = &temp;
f0105495:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f010549b:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)

	int ret_value = envid2env(envid, &env, 1);
f01054a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01054a8:	00 
f01054a9:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
f01054af:	89 44 24 04          	mov    %eax,0x4(%esp)
f01054b3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01054b6:	89 04 24             	mov    %eax,(%esp)
f01054b9:	e8 4e e5 ff ff       	call   f0103a0c <envid2env>
	if (ret_value < 0)
f01054be:	85 c0                	test   %eax,%eax
f01054c0:	0f 88 6d 06 00 00    	js     f0105b33 <syscall+0x863>
		return ret_value;

	if (((uintptr_t)va >= UTOP) || ((uintptr_t)va % PGSIZE != 0) || (perm & ~PTE_SYSCALL))
f01054c6:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f01054cd:	77 64                	ja     f0105533 <syscall+0x263>
f01054cf:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f01054d6:	75 65                	jne    f010553d <syscall+0x26d>
f01054d8:	f7 45 14 f8 f1 ff ff 	testl  $0xfffff1f8,0x14(%ebp)
f01054df:	75 66                	jne    f0105547 <syscall+0x277>
		return -E_INVAL;

	struct PageInfo* page_info = page_alloc(ALLOC_ZERO);
f01054e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01054e8:	e8 a8 bf ff ff       	call   f0101495 <page_alloc>
f01054ed:	89 c3                	mov    %eax,%ebx
	if (page_info == NULL)
f01054ef:	85 c0                	test   %eax,%eax
f01054f1:	74 5e                	je     f0105551 <syscall+0x281>
		return -E_NO_MEM;

	if (page_insert(env->env_pgdir, page_info, va, perm | PTE_U) != 0) {
f01054f3:	8b 45 14             	mov    0x14(%ebp),%eax
f01054f6:	83 c8 04             	or     $0x4,%eax
f01054f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01054fd:	8b 45 10             	mov    0x10(%ebp),%eax
f0105500:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105504:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105508:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f010550e:	8b 40 60             	mov    0x60(%eax),%eax
f0105511:	89 04 24             	mov    %eax,(%esp)
f0105514:	e8 a2 c2 ff ff       	call   f01017bb <page_insert>
f0105519:	85 c0                	test   %eax,%eax
f010551b:	0f 84 12 06 00 00    	je     f0105b33 <syscall+0x863>
		page_free(page_info);
f0105521:	89 1c 24             	mov    %ebx,(%esp)
f0105524:	e8 f7 bf ff ff       	call   f0101520 <page_free>
		return -E_NO_MEM;
f0105529:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010552e:	e9 00 06 00 00       	jmp    f0105b33 <syscall+0x863>
	int ret_value = envid2env(envid, &env, 1);
	if (ret_value < 0)
		return ret_value;

	if (((uintptr_t)va >= UTOP) || ((uintptr_t)va % PGSIZE != 0) || (perm & ~PTE_SYSCALL))
		return -E_INVAL;
f0105533:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105538:	e9 f6 05 00 00       	jmp    f0105b33 <syscall+0x863>
f010553d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105542:	e9 ec 05 00 00       	jmp    f0105b33 <syscall+0x863>
f0105547:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010554c:	e9 e2 05 00 00       	jmp    f0105b33 <syscall+0x863>

	struct PageInfo* page_info = page_alloc(ALLOC_ZERO);
	if (page_info == NULL)
		return -E_NO_MEM;
f0105551:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax

		case SYS_env_set_status:
			return sys_env_set_status((envid_t) a1, (int) a2);

		case SYS_page_alloc:
			return sys_page_alloc((envid_t) a1, (void *) a2, (int) a3);
f0105556:	e9 d8 05 00 00       	jmp    f0105b33 <syscall+0x863>
	//   check the current permissions on the page.

	// LAB 4: Your code here.

	struct Env temp;
	struct Env *src_env = &temp;
f010555b:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f0105561:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	struct Env *dst_env = &temp;
f0105567:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

	int ret_value1 = envid2env(srcenvid, &src_env, 1);
f010556d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105574:	00 
f0105575:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
f010557b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010557f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105582:	89 04 24             	mov    %eax,(%esp)
f0105585:	e8 82 e4 ff ff       	call   f0103a0c <envid2env>
f010558a:	89 c3                	mov    %eax,%ebx
	int ret_value2 = envid2env(dstenvid, &dst_env, 1);
f010558c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105593:	00 
f0105594:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
f010559a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010559e:	8b 45 14             	mov    0x14(%ebp),%eax
f01055a1:	89 04 24             	mov    %eax,(%esp)
f01055a4:	e8 63 e4 ff ff       	call   f0103a0c <envid2env>
	if ((ret_value1 < 0) || (ret_value2 < 0))
f01055a9:	c1 e8 1f             	shr    $0x1f,%eax
f01055ac:	84 c0                	test   %al,%al
f01055ae:	0f 85 c8 00 00 00    	jne    f010567c <syscall+0x3ac>
f01055b4:	c1 eb 1f             	shr    $0x1f,%ebx
f01055b7:	84 db                	test   %bl,%bl
f01055b9:	0f 85 bd 00 00 00    	jne    f010567c <syscall+0x3ac>
		return -E_BAD_ENV;

	if (((uintptr_t)srcva >= UTOP) || ((uintptr_t)srcva % PGSIZE != 0) || ((uintptr_t)dstva >= UTOP) || ((uintptr_t)dstva % PGSIZE != 0) || (perm & ~PTE_SYSCALL))
f01055bf:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f01055c6:	0f 87 ba 00 00 00    	ja     f0105686 <syscall+0x3b6>
f01055cc:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f01055d3:	0f 85 b7 00 00 00    	jne    f0105690 <syscall+0x3c0>
f01055d9:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f01055e0:	0f 87 b4 00 00 00    	ja     f010569a <syscall+0x3ca>
f01055e6:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f01055ed:	0f 85 b1 00 00 00    	jne    f01056a4 <syscall+0x3d4>
f01055f3:	f7 45 1c f8 f1 ff ff 	testl  $0xfffff1f8,0x1c(%ebp)
f01055fa:	0f 85 ae 00 00 00    	jne    f01056ae <syscall+0x3de>
		return -E_INVAL;

	pte_t temp_pte;
	pte_t* pte = &temp_pte;
f0105600:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
f0105606:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	struct PageInfo* page_info = page_lookup(src_env->env_pgdir, srcva, &pte);
f010560c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
f0105612:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105616:	8b 45 10             	mov    0x10(%ebp),%eax
f0105619:	89 44 24 04          	mov    %eax,0x4(%esp)
f010561d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
f0105623:	8b 40 60             	mov    0x60(%eax),%eax
f0105626:	89 04 24             	mov    %eax,(%esp)
f0105629:	e8 88 c0 ff ff       	call   f01016b6 <page_lookup>
	if (page_info == NULL)
f010562e:	85 c0                	test   %eax,%eax
f0105630:	0f 84 82 00 00 00    	je     f01056b8 <syscall+0x3e8>
		return -E_INVAL;

	if ((perm & PTE_W) && (!(*pte & PTE_W)))
f0105636:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f010563a:	74 0b                	je     f0105647 <syscall+0x377>
f010563c:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
f0105642:	f6 02 02             	testb  $0x2,(%edx)
f0105645:	74 7b                	je     f01056c2 <syscall+0x3f2>
		return -E_INVAL;

	if (page_insert(dst_env->env_pgdir, page_info, dstva, perm | PTE_U) != 0) {
f0105647:	8b 55 1c             	mov    0x1c(%ebp),%edx
f010564a:	83 ca 04             	or     $0x4,%edx
f010564d:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105651:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105654:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105658:	89 44 24 04          	mov    %eax,0x4(%esp)
f010565c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0105662:	8b 40 60             	mov    0x60(%eax),%eax
f0105665:	89 04 24             	mov    %eax,(%esp)
f0105668:	e8 4e c1 ff ff       	call   f01017bb <page_insert>
		return -E_NO_MEM;
f010566d:	85 c0                	test   %eax,%eax
f010566f:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
f0105674:	0f 45 c2             	cmovne %edx,%eax
f0105677:	e9 b7 04 00 00       	jmp    f0105b33 <syscall+0x863>
	struct Env *dst_env = &temp;

	int ret_value1 = envid2env(srcenvid, &src_env, 1);
	int ret_value2 = envid2env(dstenvid, &dst_env, 1);
	if ((ret_value1 < 0) || (ret_value2 < 0))
		return -E_BAD_ENV;
f010567c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105681:	e9 ad 04 00 00       	jmp    f0105b33 <syscall+0x863>

	if (((uintptr_t)srcva >= UTOP) || ((uintptr_t)srcva % PGSIZE != 0) || ((uintptr_t)dstva >= UTOP) || ((uintptr_t)dstva % PGSIZE != 0) || (perm & ~PTE_SYSCALL))
		return -E_INVAL;
f0105686:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010568b:	e9 a3 04 00 00       	jmp    f0105b33 <syscall+0x863>
f0105690:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105695:	e9 99 04 00 00       	jmp    f0105b33 <syscall+0x863>
f010569a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010569f:	e9 8f 04 00 00       	jmp    f0105b33 <syscall+0x863>
f01056a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01056a9:	e9 85 04 00 00       	jmp    f0105b33 <syscall+0x863>
f01056ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01056b3:	e9 7b 04 00 00       	jmp    f0105b33 <syscall+0x863>

	pte_t temp_pte;
	pte_t* pte = &temp_pte;
	struct PageInfo* page_info = page_lookup(src_env->env_pgdir, srcva, &pte);
	if (page_info == NULL)
		return -E_INVAL;
f01056b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01056bd:	e9 71 04 00 00       	jmp    f0105b33 <syscall+0x863>

	if ((perm & PTE_W) && (!(*pte & PTE_W)))
		return -E_INVAL;
f01056c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

		case SYS_page_alloc:
			return sys_page_alloc((envid_t) a1, (void *) a2, (int) a3);

		case SYS_page_map:
			return sys_page_map((envid_t) a1, (void *) a2, (envid_t) a3, (void *) a4, (int) a5);
f01056c7:	e9 67 04 00 00       	jmp    f0105b33 <syscall+0x863>
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	
	struct Env temp;
	struct Env *env = &temp;
f01056cc:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f01056d2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)

	int ret_value = envid2env(envid, &env, 1);
f01056d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01056df:	00 
f01056e0:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
f01056e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01056ea:	8b 45 0c             	mov    0xc(%ebp),%eax
f01056ed:	89 04 24             	mov    %eax,(%esp)
f01056f0:	e8 17 e3 ff ff       	call   f0103a0c <envid2env>
	if (ret_value < 0)
f01056f5:	85 c0                	test   %eax,%eax
f01056f7:	0f 88 36 04 00 00    	js     f0105b33 <syscall+0x863>
		return ret_value;

	if (((uintptr_t)va >= UTOP) || ((uintptr_t)va % PGSIZE != 0))
f01056fd:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105704:	77 2b                	ja     f0105731 <syscall+0x461>
f0105706:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f010570d:	75 2c                	jne    f010573b <syscall+0x46b>
		return -E_INVAL;

	page_remove(env->env_pgdir, va);
f010570f:	8b 45 10             	mov    0x10(%ebp),%eax
f0105712:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105716:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f010571c:	8b 40 60             	mov    0x60(%eax),%eax
f010571f:	89 04 24             	mov    %eax,(%esp)
f0105722:	e8 3d c0 ff ff       	call   f0101764 <page_remove>
	return 0;
f0105727:	b8 00 00 00 00       	mov    $0x0,%eax
f010572c:	e9 02 04 00 00       	jmp    f0105b33 <syscall+0x863>
	int ret_value = envid2env(envid, &env, 1);
	if (ret_value < 0)
		return ret_value;

	if (((uintptr_t)va >= UTOP) || ((uintptr_t)va % PGSIZE != 0))
		return -E_INVAL;
f0105731:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105736:	e9 f8 03 00 00       	jmp    f0105b33 <syscall+0x863>
f010573b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

		case SYS_page_map:
			return sys_page_map((envid_t) a1, (void *) a2, (envid_t) a3, (void *) a4, (int) a5);

		case SYS_page_unmap:
			return sys_page_unmap((envid_t) a1, (void *) a2);
f0105740:	e9 ee 03 00 00       	jmp    f0105b33 <syscall+0x863>
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	struct Env* env;
	if(envid2env(envid,&env,1) < 0) {
f0105745:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010574c:	00 
f010574d:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f0105753:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105757:	8b 45 0c             	mov    0xc(%ebp),%eax
f010575a:	89 04 24             	mov    %eax,(%esp)
f010575d:	e8 aa e2 ff ff       	call   f0103a0c <envid2env>
f0105762:	85 c0                	test   %eax,%eax
f0105764:	78 16                	js     f010577c <syscall+0x4ac>
		return -E_BAD_ENV;
	}
	env->env_pgfault_upcall = func;
f0105766:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
f010576c:	8b 7d 10             	mov    0x10(%ebp),%edi
f010576f:	89 78 64             	mov    %edi,0x64(%eax)
	return 0;
f0105772:	b8 00 00 00 00       	mov    $0x0,%eax
f0105777:	e9 b7 03 00 00       	jmp    f0105b33 <syscall+0x863>
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	struct Env* env;
	if(envid2env(envid,&env,1) < 0) {
		return -E_BAD_ENV;
f010577c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

		case SYS_page_unmap:
			return sys_page_unmap((envid_t) a1, (void *) a2);

		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall((envid_t) a1, (void *) a2);
f0105781:	e9 ad 03 00 00       	jmp    f0105b33 <syscall+0x863>
{
	//struct Env temp;
	//struct Env *dst_env = &temp;
	struct Env* dst_env;

	int ret_value = envid2env(envid, &dst_env, 0);
f0105786:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010578d:	00 
f010578e:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
f0105794:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105798:	8b 45 0c             	mov    0xc(%ebp),%eax
f010579b:	89 04 24             	mov    %eax,(%esp)
f010579e:	e8 69 e2 ff ff       	call   f0103a0c <envid2env>
	if (ret_value < 0)
f01057a3:	85 c0                	test   %eax,%eax
f01057a5:	0f 88 88 03 00 00    	js     f0105b33 <syscall+0x863>
		return ret_value;

	if (dst_env->env_ipc_recving == false)
f01057ab:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
f01057b1:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01057b5:	0f 84 25 01 00 00    	je     f01058e0 <syscall+0x610>
		return -E_IPC_NOT_RECV;

	if ((srcva < (void*) UTOP) && (dst_env->env_ipc_dstva < (void*) UTOP)) {
f01057bb:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01057c2:	0f 87 cf 00 00 00    	ja     f0105897 <syscall+0x5c7>
f01057c8:	81 78 6c ff ff bf ee 	cmpl   $0xeebfffff,0x6c(%eax)
f01057cf:	0f 87 c2 00 00 00    	ja     f0105897 <syscall+0x5c7>
		if (((uintptr_t)srcva % PGSIZE != 0) || (perm & ~PTE_SYSCALL))
			return -E_INVAL;
f01057d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	if (dst_env->env_ipc_recving == false)
		return -E_IPC_NOT_RECV;

	if ((srcva < (void*) UTOP) && (dst_env->env_ipc_dstva < (void*) UTOP)) {
		if (((uintptr_t)srcva % PGSIZE != 0) || (perm & ~PTE_SYSCALL))
f01057da:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f01057e1:	0f 85 4c 03 00 00    	jne    f0105b33 <syscall+0x863>
f01057e7:	f7 45 18 f8 f1 ff ff 	testl  $0xfffff1f8,0x18(%ebp)
f01057ee:	0f 85 3f 03 00 00    	jne    f0105b33 <syscall+0x863>
			return -E_INVAL;

		pte_t temp_pte;
		pte_t* pte = &temp_pte;
f01057f4:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
f01057fa:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		struct PageInfo* page_info = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105800:	e8 24 17 00 00       	call   f0106f29 <cpunum>
f0105805:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
f010580b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010580f:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0105812:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105816:	6b c0 74             	imul   $0x74,%eax,%eax
f0105819:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f010581f:	8b 40 60             	mov    0x60(%eax),%eax
f0105822:	89 04 24             	mov    %eax,(%esp)
f0105825:	e8 8c be ff ff       	call   f01016b6 <page_lookup>
f010582a:	89 c2                	mov    %eax,%edx
		if (page_info == NULL)
f010582c:	85 c0                	test   %eax,%eax
f010582e:	74 5d                	je     f010588d <syscall+0x5bd>
			return -E_INVAL;

		if ((perm & PTE_W) && (!(*pte & PTE_W)))
f0105830:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105834:	74 14                	je     f010584a <syscall+0x57a>
			return -E_INVAL;
f0105836:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		pte_t* pte = &temp_pte;
		struct PageInfo* page_info = page_lookup(curenv->env_pgdir, srcva, &pte);
		if (page_info == NULL)
			return -E_INVAL;

		if ((perm & PTE_W) && (!(*pte & PTE_W)))
f010583b:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
f0105841:	f6 01 02             	testb  $0x2,(%ecx)
f0105844:	0f 84 e9 02 00 00    	je     f0105b33 <syscall+0x863>
			return -E_INVAL;

		if (page_insert(dst_env->env_pgdir, page_info, dst_env->env_ipc_dstva, perm | PTE_U) != 0) {
f010584a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
f0105850:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105853:	83 c9 04             	or     $0x4,%ecx
f0105856:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f010585a:	8b 48 6c             	mov    0x6c(%eax),%ecx
f010585d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105861:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105865:	8b 40 60             	mov    0x60(%eax),%eax
f0105868:	89 04 24             	mov    %eax,(%esp)
f010586b:	e8 4b bf ff ff       	call   f01017bb <page_insert>
f0105870:	89 c2                	mov    %eax,%edx
			return -E_NO_MEM;
f0105872:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
			return -E_INVAL;

		if ((perm & PTE_W) && (!(*pte & PTE_W)))
			return -E_INVAL;

		if (page_insert(dst_env->env_pgdir, page_info, dst_env->env_ipc_dstva, perm | PTE_U) != 0) {
f0105877:	85 d2                	test   %edx,%edx
f0105879:	0f 85 b4 02 00 00    	jne    f0105b33 <syscall+0x863>
			return -E_NO_MEM;
		}

		dst_env->env_ipc_perm = perm;
f010587f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
f0105885:	8b 7d 18             	mov    0x18(%ebp),%edi
f0105888:	89 78 78             	mov    %edi,0x78(%eax)
f010588b:	eb 11                	jmp    f010589e <syscall+0x5ce>

		pte_t temp_pte;
		pte_t* pte = &temp_pte;
		struct PageInfo* page_info = page_lookup(curenv->env_pgdir, srcva, &pte);
		if (page_info == NULL)
			return -E_INVAL;
f010588d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105892:	e9 9c 02 00 00       	jmp    f0105b33 <syscall+0x863>
		}

		dst_env->env_ipc_perm = perm;

	} else {
		dst_env->env_ipc_perm = 0;
f0105897:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	}

	dst_env->env_ipc_recving = false;
f010589e:	8b 9d 5c ff ff ff    	mov    -0xa4(%ebp),%ebx
f01058a4:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	dst_env->env_ipc_from = curenv->env_id;
f01058a8:	e8 7c 16 00 00       	call   f0106f29 <cpunum>
f01058ad:	6b c0 74             	imul   $0x74,%eax,%eax
f01058b0:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f01058b6:	8b 40 48             	mov    0x48(%eax),%eax
f01058b9:	89 43 74             	mov    %eax,0x74(%ebx)
	dst_env->env_ipc_value = value;
f01058bc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
f01058c2:	8b 7d 10             	mov    0x10(%ebp),%edi
f01058c5:	89 78 70             	mov    %edi,0x70(%eax)
	dst_env->env_status = ENV_RUNNABLE;
f01058c8:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f01058cf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	return 0;
f01058d6:	b8 00 00 00 00       	mov    $0x0,%eax
f01058db:	e9 53 02 00 00       	jmp    f0105b33 <syscall+0x863>
	int ret_value = envid2env(envid, &dst_env, 0);
	if (ret_value < 0)
		return ret_value;

	if (dst_env->env_ipc_recving == false)
		return -E_IPC_NOT_RECV;
f01058e0:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax

		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall((envid_t) a1, (void *) a2);

		case SYS_ipc_try_send:
			return sys_ipc_try_send((envid_t) a1, (uint32_t) a2, (void *) a3, (unsigned) a4);
f01058e5:	e9 49 02 00 00       	jmp    f0105b33 <syscall+0x863>
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	if ((dstva < (void*) UTOP) && ((uintptr_t)dstva % PGSIZE != 0)) 
f01058ea:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f01058f1:	77 0d                	ja     f0105900 <syscall+0x630>
f01058f3:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f01058fa:	0f 85 2e 02 00 00    	jne    f0105b2e <syscall+0x85e>
		return -E_INVAL;

	curenv->env_ipc_recving = true;
f0105900:	e8 24 16 00 00       	call   f0106f29 <cpunum>
f0105905:	6b c0 74             	imul   $0x74,%eax,%eax
f0105908:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f010590e:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0105912:	e8 12 16 00 00       	call   f0106f29 <cpunum>
f0105917:	6b c0 74             	imul   $0x74,%eax,%eax
f010591a:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0105920:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105923:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105926:	e8 fe 15 00 00       	call   f0106f29 <cpunum>
f010592b:	6b c0 74             	imul   $0x74,%eax,%eax
f010592e:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0105934:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f010593b:	e8 68 f8 ff ff       	call   f01051a8 <sched_yield>
//	-E_INVAL is pri is not between 1-100
static int
sys_set_pri(envid_t envid, int pri)
{
	struct Env temp;
	struct Env *env = &temp;
f0105940:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f0105946:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)

	int ret_value = envid2env(envid, &env, 1);
f010594c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105953:	00 
f0105954:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
f010595a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010595e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105961:	89 04 24             	mov    %eax,(%esp)
f0105964:	e8 a3 e0 ff ff       	call   f0103a0c <envid2env>
	if (ret_value < 0)
f0105969:	85 c0                	test   %eax,%eax
f010596b:	0f 88 c2 01 00 00    	js     f0105b33 <syscall+0x863>
		return ret_value;

	if ((pri > 100) || (pri < 1))
f0105971:	8b 45 10             	mov    0x10(%ebp),%eax
f0105974:	83 e8 01             	sub    $0x1,%eax
f0105977:	83 f8 63             	cmp    $0x63,%eax
f010597a:	77 16                	ja     f0105992 <syscall+0x6c2>
		return -E_INVAL;

	env->pri = pri;
f010597c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f0105982:	8b 75 10             	mov    0x10(%ebp),%esi
f0105985:	89 70 7c             	mov    %esi,0x7c(%eax)
	return 0;
f0105988:	b8 00 00 00 00       	mov    $0x0,%eax
f010598d:	e9 a1 01 00 00       	jmp    f0105b33 <syscall+0x863>
	int ret_value = envid2env(envid, &env, 1);
	if (ret_value < 0)
		return ret_value;

	if ((pri > 100) || (pri < 1))
		return -E_INVAL;
f0105992:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

		case SYS_ipc_recv:
			return sys_ipc_recv((void *) a1);

		case SYS_set_pri:
			return sys_set_pri((envid_t) a1, (int) a2);
f0105997:	e9 97 01 00 00       	jmp    f0105b33 <syscall+0x863>

		case SYS_env_set_trapframe:
			return sys_env_set_trapframe((envid_t) a1, (struct Trapframe*) a2);
f010599c:	8b 75 10             	mov    0x10(%ebp),%esi
	// Remember to check whether the user has supplied us with a good
	// address!
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0){
f010599f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01059a6:	00 
f01059a7:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
f01059ad:	89 44 24 04          	mov    %eax,0x4(%esp)
f01059b1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01059b4:	89 04 24             	mov    %eax,(%esp)
f01059b7:	e8 50 e0 ff ff       	call   f0103a0c <envid2env>
f01059bc:	85 c0                	test   %eax,%eax
f01059be:	78 54                	js     f0105a14 <syscall+0x744>
		return -E_BAD_ENV;
	}
	if (tf == NULL){
f01059c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01059c4:	74 58                	je     f0105a1e <syscall+0x74e>
		return -E_BAD_ENV;
	}

	user_mem_assert(e, tf, sizeof(struct Trapframe), PTE_U);
f01059c6:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f01059cd:	00 
f01059ce:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f01059d5:	00 
f01059d6:	8b 45 10             	mov    0x10(%ebp),%eax
f01059d9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01059dd:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
f01059e3:	89 04 24             	mov    %eax,(%esp)
f01059e6:	e8 4e df ff ff       	call   f0103939 <user_mem_assert>

	e->env_tf = *tf;
f01059eb:	b9 11 00 00 00       	mov    $0x11,%ecx
f01059f0:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
f01059f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f01059f8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
f01059fe:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f0105a03:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	
	return 0;
f0105a0a:	b8 00 00 00 00       	mov    $0x0,%eax
f0105a0f:	e9 1f 01 00 00       	jmp    f0105b33 <syscall+0x863>
	// address!
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0){
		return -E_BAD_ENV;
f0105a14:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105a19:	e9 15 01 00 00       	jmp    f0105b33 <syscall+0x863>
	}
	if (tf == NULL){
		return -E_BAD_ENV;
f0105a1e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

		case SYS_set_pri:
			return sys_set_pri((envid_t) a1, (int) a2);

		case SYS_env_set_trapframe:
			return sys_env_set_trapframe((envid_t) a1, (struct Trapframe*) a2);
f0105a23:	e9 0b 01 00 00       	jmp    f0105b33 <syscall+0x863>
// Return the current time.
static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	return time_msec();
f0105a28:	e8 86 24 00 00       	call   f0107eb3 <time_msec>

		case SYS_env_set_trapframe:
			return sys_env_set_trapframe((envid_t) a1, (struct Trapframe*) a2);

		case SYS_time_msec:
			return sys_time_msec();
f0105a2d:	8d 76 00             	lea    0x0(%esi),%esi
f0105a30:	e9 fe 00 00 00       	jmp    f0105b33 <syscall+0x863>
}

static int
sys_pkt_send(void *addr, int size)
{
	user_mem_assert(curenv, addr, size, PTE_P|PTE_W);
f0105a35:	e8 ef 14 00 00       	call   f0106f29 <cpunum>
f0105a3a:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
f0105a41:	00 
f0105a42:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105a45:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0105a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105a4c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105a50:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a53:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0105a59:	89 04 24             	mov    %eax,(%esp)
f0105a5c:	e8 d8 de ff ff       	call   f0103939 <user_mem_assert>
	return tx_packet(addr, size);
f0105a61:	8b 45 10             	mov    0x10(%ebp),%eax
f0105a64:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105a68:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105a6b:	89 04 24             	mov    %eax,(%esp)
f0105a6e:	e8 a9 1c 00 00       	call   f010771c <tx_packet>

		case SYS_time_msec:
			return sys_time_msec();

		case SYS_pkt_send:
			return sys_pkt_send((void *)a1, a2);
f0105a73:	e9 bb 00 00 00       	jmp    f0105b33 <syscall+0x863>
}

static int
sys_pkt_recv(void *addr, uint32_t *size)
{
	user_mem_assert(curenv, addr, 2048, PTE_P|PTE_W);
f0105a78:	e8 ac 14 00 00       	call   f0106f29 <cpunum>
f0105a7d:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
f0105a84:	00 
f0105a85:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
f0105a8c:	00 
f0105a8d:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105a90:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105a94:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a97:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0105a9d:	89 04 24             	mov    %eax,(%esp)
f0105aa0:	e8 94 de ff ff       	call   f0103939 <user_mem_assert>
	return rx_packet(addr, size);
f0105aa5:	8b 45 10             	mov    0x10(%ebp),%eax
f0105aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105aac:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105aaf:	89 04 24             	mov    %eax,(%esp)
f0105ab2:	e8 34 1d 00 00       	call   f01077eb <rx_packet>

		case SYS_pkt_send:
			return sys_pkt_send((void *)a1, a2);

		case SYS_pkt_recv:
			return sys_pkt_recv((void *)a1, (void *)a2);
f0105ab7:	eb 7a                	jmp    f0105b33 <syscall+0x863>
}

static int
sys_sleep(int channel)
{
	sys_env_set_status(curenv->env_id, ENV_NOT_RUNNABLE);
f0105ab9:	e8 6b 14 00 00       	call   f0106f29 <cpunum>
f0105abe:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ac1:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0105ac7:	8b 40 48             	mov    0x48(%eax),%eax
	// envid's status.

	// LAB 4: Your code here.

	struct Env temp;
	struct Env *env = &temp;
f0105aca:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
f0105ad0:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

	int ret_value = envid2env(envid, &env, 1);
f0105ad6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105add:	00 
f0105ade:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
f0105ae4:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105ae8:	89 04 24             	mov    %eax,(%esp)
f0105aeb:	e8 1c df ff ff       	call   f0103a0c <envid2env>
	if (ret_value < 0)
f0105af0:	85 c0                	test   %eax,%eax
f0105af2:	78 0d                	js     f0105b01 <syscall+0x831>
		return ret_value;

	if ((status != ENV_RUNNABLE) && (status != ENV_NOT_RUNNABLE))
		return -E_INVAL;

	env->env_status = status;
f0105af4:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f0105afa:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)

static int
sys_sleep(int channel)
{
	sys_env_set_status(curenv->env_id, ENV_NOT_RUNNABLE);
	return sleep(channel);
f0105b01:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105b04:	89 04 24             	mov    %eax,(%esp)
f0105b07:	e8 f2 e5 ff ff       	call   f01040fe <sleep>

		case SYS_pkt_recv:
			return sys_pkt_recv((void *)a1, (void *)a2);

		case SYS_sleep:
			return sys_sleep((enum EnvChannel) a1);
f0105b0c:	eb 25                	jmp    f0105b33 <syscall+0x863>
}

static int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	get_MAC_from_EEPROM(low, high);
f0105b0e:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b11:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105b15:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105b18:	89 04 24             	mov    %eax,(%esp)
f0105b1b:	e8 b6 18 00 00       	call   f01073d6 <get_MAC_from_EEPROM>

		case SYS_sleep:
			return sys_sleep((enum EnvChannel) a1);

		case SYS_get_mac_from_eeprom:
			return sys_get_mac_from_eeprom((uint32_t*) a1, (uint32_t*) a2);
f0105b20:	b8 00 00 00 00       	mov    $0x0,%eax
f0105b25:	eb 0c                	jmp    f0105b33 <syscall+0x863>

		default:
			return -E_INVAL;		//after merge with lab 5 for some reason they changed it to be -E_INVAL, for now I left it like it was.
f0105b27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105b2c:	eb 05                	jmp    f0105b33 <syscall+0x863>

		case SYS_ipc_try_send:
			return sys_ipc_try_send((envid_t) a1, (uint32_t) a2, (void *) a3, (unsigned) a4);

		case SYS_ipc_recv:
			return sys_ipc_recv((void *) a1);
f0105b2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			return sys_get_mac_from_eeprom((uint32_t*) a1, (uint32_t*) a2);

		default:
			return -E_INVAL;		//after merge with lab 5 for some reason they changed it to be -E_INVAL, for now I left it like it was.
	}
}
f0105b33:	81 c4 bc 00 00 00    	add    $0xbc,%esp
f0105b39:	5b                   	pop    %ebx
f0105b3a:	5e                   	pop    %esi
f0105b3b:	5f                   	pop    %edi
f0105b3c:	5d                   	pop    %ebp
f0105b3d:	c3                   	ret    

f0105b3e <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105b3e:	55                   	push   %ebp
f0105b3f:	89 e5                	mov    %esp,%ebp
f0105b41:	57                   	push   %edi
f0105b42:	56                   	push   %esi
f0105b43:	53                   	push   %ebx
f0105b44:	83 ec 14             	sub    $0x14,%esp
f0105b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105b4a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105b4d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105b50:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105b53:	8b 1a                	mov    (%edx),%ebx
f0105b55:	8b 01                	mov    (%ecx),%eax
f0105b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105b5a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105b61:	e9 88 00 00 00       	jmp    f0105bee <stab_binsearch+0xb0>
		int true_m = (l + r) / 2, m = true_m;
f0105b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105b69:	01 d8                	add    %ebx,%eax
f0105b6b:	89 c7                	mov    %eax,%edi
f0105b6d:	c1 ef 1f             	shr    $0x1f,%edi
f0105b70:	01 c7                	add    %eax,%edi
f0105b72:	d1 ff                	sar    %edi
f0105b74:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105b77:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105b7a:	8d 14 81             	lea    (%ecx,%eax,4),%edx
f0105b7d:	89 f8                	mov    %edi,%eax

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105b7f:	eb 03                	jmp    f0105b84 <stab_binsearch+0x46>
			m--;
f0105b81:	83 e8 01             	sub    $0x1,%eax

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105b84:	39 c3                	cmp    %eax,%ebx
f0105b86:	7f 1f                	jg     f0105ba7 <stab_binsearch+0x69>
f0105b88:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0105b8c:	83 ea 0c             	sub    $0xc,%edx
f0105b8f:	39 f1                	cmp    %esi,%ecx
f0105b91:	75 ee                	jne    f0105b81 <stab_binsearch+0x43>
f0105b93:	89 45 e8             	mov    %eax,-0x18(%ebp)
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105b96:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105b99:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105b9c:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105ba0:	39 55 0c             	cmp    %edx,0xc(%ebp)
f0105ba3:	76 18                	jbe    f0105bbd <stab_binsearch+0x7f>
f0105ba5:	eb 05                	jmp    f0105bac <stab_binsearch+0x6e>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105ba7:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105baa:	eb 42                	jmp    f0105bee <stab_binsearch+0xb0>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0105bac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105baf:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0105bb1:	8d 5f 01             	lea    0x1(%edi),%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105bb4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105bbb:	eb 31                	jmp    f0105bee <stab_binsearch+0xb0>
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
f0105bbd:	39 55 0c             	cmp    %edx,0xc(%ebp)
f0105bc0:	73 17                	jae    f0105bd9 <stab_binsearch+0x9b>
			*region_right = m - 1;
f0105bc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105bc5:	83 e8 01             	sub    $0x1,%eax
f0105bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105bcb:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105bce:	89 07                	mov    %eax,(%edi)
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105bd0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105bd7:	eb 15                	jmp    f0105bee <stab_binsearch+0xb0>
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105bd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105bdc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0105bdf:	89 1f                	mov    %ebx,(%edi)
			l = m;
			addr++;
f0105be1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105be5:	89 c3                	mov    %eax,%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105be7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f0105bee:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0105bf1:	0f 8e 6f ff ff ff    	jle    f0105b66 <stab_binsearch+0x28>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0105bf7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105bfb:	75 0f                	jne    f0105c0c <stab_binsearch+0xce>
		*region_right = *region_left - 1;
f0105bfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105c00:	8b 00                	mov    (%eax),%eax
f0105c02:	83 e8 01             	sub    $0x1,%eax
f0105c05:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105c08:	89 07                	mov    %eax,(%edi)
f0105c0a:	eb 2c                	jmp    f0105c38 <stab_binsearch+0xfa>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105c0f:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105c11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105c14:	8b 0f                	mov    (%edi),%ecx
f0105c16:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105c19:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0105c1c:	8d 14 97             	lea    (%edi,%edx,4),%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105c1f:	eb 03                	jmp    f0105c24 <stab_binsearch+0xe6>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
f0105c21:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105c24:	39 c8                	cmp    %ecx,%eax
f0105c26:	7e 0b                	jle    f0105c33 <stab_binsearch+0xf5>
		     l > *region_left && stabs[l].n_type != type;
f0105c28:	0f b6 5a 04          	movzbl 0x4(%edx),%ebx
f0105c2c:	83 ea 0c             	sub    $0xc,%edx
f0105c2f:	39 f3                	cmp    %esi,%ebx
f0105c31:	75 ee                	jne    f0105c21 <stab_binsearch+0xe3>
		     l--)
			/* do nothing */;
		*region_left = l;
f0105c33:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105c36:	89 07                	mov    %eax,(%edi)
	}
}
f0105c38:	83 c4 14             	add    $0x14,%esp
f0105c3b:	5b                   	pop    %ebx
f0105c3c:	5e                   	pop    %esi
f0105c3d:	5f                   	pop    %edi
f0105c3e:	5d                   	pop    %ebp
f0105c3f:	c3                   	ret    

f0105c40 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105c40:	55                   	push   %ebp
f0105c41:	89 e5                	mov    %esp,%ebp
f0105c43:	57                   	push   %edi
f0105c44:	56                   	push   %esi
f0105c45:	53                   	push   %ebx
f0105c46:	83 ec 4c             	sub    $0x4c,%esp
f0105c49:	8b 75 08             	mov    0x8(%ebp),%esi
f0105c4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105c4f:	c7 07 18 9b 10 f0    	movl   $0xf0109b18,(%edi)
	info->eip_line = 0;
f0105c55:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
	info->eip_fn_name = "<unknown>";
f0105c5c:	c7 47 08 18 9b 10 f0 	movl   $0xf0109b18,0x8(%edi)
	info->eip_fn_namelen = 9;
f0105c63:	c7 47 0c 09 00 00 00 	movl   $0x9,0xc(%edi)
	info->eip_fn_addr = addr;
f0105c6a:	89 77 10             	mov    %esi,0x10(%edi)
	info->eip_fn_narg = 0;
f0105c6d:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105c74:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0105c7a:	0f 87 c1 00 00 00    	ja     f0105d41 <debuginfo_eip+0x101>
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U)){
f0105c80:	e8 a4 12 00 00       	call   f0106f29 <cpunum>
f0105c85:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105c8c:	00 
f0105c8d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0105c94:	00 
f0105c95:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f0105c9c:	00 
f0105c9d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ca0:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0105ca6:	89 04 24             	mov    %eax,(%esp)
f0105ca9:	e8 01 dc ff ff       	call   f01038af <user_mem_check>
f0105cae:	85 c0                	test   %eax,%eax
f0105cb0:	0f 85 51 02 00 00    	jne    f0105f07 <debuginfo_eip+0x2c7>
			return -1;
		}

		stabs = usd->stabs;
f0105cb6:	a1 00 00 20 00       	mov    0x200000,%eax
f0105cbb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		stab_end = usd->stab_end;
f0105cbe:	8b 1d 04 00 20 00    	mov    0x200004,%ebx
		stabstr = usd->stabstr;
f0105cc4:	a1 08 00 20 00       	mov    0x200008,%eax
f0105cc9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		stabstr_end = usd->stabstr_end;
f0105ccc:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105cd2:	89 55 bc             	mov    %edx,-0x44(%ebp)

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		
		if ((user_mem_check(curenv, stabs, sizeof(struct Stab), PTE_U)) || (user_mem_check(curenv, stabstr, stabstr_end-stabstr, PTE_U))){
f0105cd5:	e8 4f 12 00 00       	call   f0106f29 <cpunum>
f0105cda:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105ce1:	00 
f0105ce2:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
f0105ce9:	00 
f0105cea:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0105ced:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105cf1:	6b c0 74             	imul   $0x74,%eax,%eax
f0105cf4:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0105cfa:	89 04 24             	mov    %eax,(%esp)
f0105cfd:	e8 ad db ff ff       	call   f01038af <user_mem_check>
f0105d02:	85 c0                	test   %eax,%eax
f0105d04:	0f 85 04 02 00 00    	jne    f0105f0e <debuginfo_eip+0x2ce>
f0105d0a:	e8 1a 12 00 00       	call   f0106f29 <cpunum>
f0105d0f:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105d16:	00 
f0105d17:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0105d1a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105d1d:	29 ca                	sub    %ecx,%edx
f0105d1f:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105d23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105d27:	6b c0 74             	imul   $0x74,%eax,%eax
f0105d2a:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f0105d30:	89 04 24             	mov    %eax,(%esp)
f0105d33:	e8 77 db ff ff       	call   f01038af <user_mem_check>
f0105d38:	85 c0                	test   %eax,%eax
f0105d3a:	74 1f                	je     f0105d5b <debuginfo_eip+0x11b>
f0105d3c:	e9 d4 01 00 00       	jmp    f0105f15 <debuginfo_eip+0x2d5>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105d41:	c7 45 bc 6d b6 11 f0 	movl   $0xf011b66d,-0x44(%ebp)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
f0105d48:	c7 45 c0 5d 6e 11 f0 	movl   $0xf0116e5d,-0x40(%ebp)
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
f0105d4f:	bb 5c 6e 11 f0       	mov    $0xf0116e5c,%ebx
	info->eip_fn_addr = addr;
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
f0105d54:	c7 45 c4 48 a4 10 f0 	movl   $0xf010a448,-0x3c(%ebp)
			return -1;
		}
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105d5b:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0105d5e:	39 45 c0             	cmp    %eax,-0x40(%ebp)
f0105d61:	0f 83 b5 01 00 00    	jae    f0105f1c <debuginfo_eip+0x2dc>
f0105d67:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0105d6b:	0f 85 b2 01 00 00    	jne    f0105f23 <debuginfo_eip+0x2e3>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105d71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0105d78:	2b 5d c4             	sub    -0x3c(%ebp),%ebx
f0105d7b:	c1 fb 02             	sar    $0x2,%ebx
f0105d7e:	69 c3 ab aa aa aa    	imul   $0xaaaaaaab,%ebx,%eax
f0105d84:	83 e8 01             	sub    $0x1,%eax
f0105d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105d8a:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105d8e:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0105d95:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0105d98:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105d9b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0105d9e:	89 d8                	mov    %ebx,%eax
f0105da0:	e8 99 fd ff ff       	call   f0105b3e <stab_binsearch>
	if (lfile == 0)
f0105da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105da8:	85 c0                	test   %eax,%eax
f0105daa:	0f 84 7a 01 00 00    	je     f0105f2a <debuginfo_eip+0x2ea>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105db0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105db6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105db9:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105dbd:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0105dc4:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0105dc7:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105dca:	89 d8                	mov    %ebx,%eax
f0105dcc:	e8 6d fd ff ff       	call   f0105b3e <stab_binsearch>

	if (lfun <= rfun) {
f0105dd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105dd4:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0105dd7:	39 d8                	cmp    %ebx,%eax
f0105dd9:	7f 32                	jg     f0105e0d <debuginfo_eip+0x1cd>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105ddb:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105dde:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0105de1:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0105de4:	8b 0a                	mov    (%edx),%ecx
f0105de6:	89 4d b8             	mov    %ecx,-0x48(%ebp)
f0105de9:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105dec:	2b 4d c0             	sub    -0x40(%ebp),%ecx
f0105def:	39 4d b8             	cmp    %ecx,-0x48(%ebp)
f0105df2:	73 09                	jae    f0105dfd <debuginfo_eip+0x1bd>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105df4:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0105df7:	03 4d c0             	add    -0x40(%ebp),%ecx
f0105dfa:	89 4f 08             	mov    %ecx,0x8(%edi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105dfd:	8b 52 08             	mov    0x8(%edx),%edx
f0105e00:	89 57 10             	mov    %edx,0x10(%edi)
		addr -= info->eip_fn_addr;
f0105e03:	29 d6                	sub    %edx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0105e05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105e08:	89 5d d0             	mov    %ebx,-0x30(%ebp)
f0105e0b:	eb 0f                	jmp    f0105e1c <debuginfo_eip+0x1dc>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0105e0d:	89 77 10             	mov    %esi,0x10(%edi)
		lline = lfile;
f0105e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e13:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105e16:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e19:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105e1c:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0105e23:	00 
f0105e24:	8b 47 08             	mov    0x8(%edi),%eax
f0105e27:	89 04 24             	mov    %eax,(%esp)
f0105e2a:	e8 8c 0a 00 00       	call   f01068bb <strfind>
f0105e2f:	2b 47 08             	sub    0x8(%edi),%eax
f0105e32:	89 47 0c             	mov    %eax,0xc(%edi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105e35:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105e39:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0105e40:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105e43:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105e46:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0105e49:	89 f0                	mov    %esi,%eax
f0105e4b:	e8 ee fc ff ff       	call   f0105b3e <stab_binsearch>
	if (lline > rline) {
f0105e50:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105e53:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0105e56:	0f 8f d5 00 00 00    	jg     f0105f31 <debuginfo_eip+0x2f1>
		return -1;
	}
	info->eip_line = stabs[rline].n_desc;
f0105e5c:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105e5f:	0f b7 44 86 06       	movzwl 0x6(%esi,%eax,4),%eax
f0105e64:	89 47 04             	mov    %eax,0x4(%edi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e6a:	89 c3                	mov    %eax,%ebx
f0105e6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105e6f:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105e72:	8d 14 96             	lea    (%esi,%edx,4),%edx
f0105e75:	89 7d 0c             	mov    %edi,0xc(%ebp)
f0105e78:	89 df                	mov    %ebx,%edi
f0105e7a:	eb 06                	jmp    f0105e82 <debuginfo_eip+0x242>
f0105e7c:	83 e8 01             	sub    $0x1,%eax
f0105e7f:	83 ea 0c             	sub    $0xc,%edx
f0105e82:	89 c6                	mov    %eax,%esi
f0105e84:	39 c7                	cmp    %eax,%edi
f0105e86:	7f 3c                	jg     f0105ec4 <debuginfo_eip+0x284>
	       && stabs[lline].n_type != N_SOL
f0105e88:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0105e8c:	80 f9 84             	cmp    $0x84,%cl
f0105e8f:	75 08                	jne    f0105e99 <debuginfo_eip+0x259>
f0105e91:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105e94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105e97:	eb 11                	jmp    f0105eaa <debuginfo_eip+0x26a>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105e99:	80 f9 64             	cmp    $0x64,%cl
f0105e9c:	75 de                	jne    f0105e7c <debuginfo_eip+0x23c>
f0105e9e:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
f0105ea2:	74 d8                	je     f0105e7c <debuginfo_eip+0x23c>
f0105ea4:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105ea7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105eaa:	8d 04 76             	lea    (%esi,%esi,2),%eax
f0105ead:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0105eb0:	8b 04 86             	mov    (%esi,%eax,4),%eax
f0105eb3:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0105eb6:	2b 55 c0             	sub    -0x40(%ebp),%edx
f0105eb9:	39 d0                	cmp    %edx,%eax
f0105ebb:	73 0a                	jae    f0105ec7 <debuginfo_eip+0x287>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105ebd:	03 45 c0             	add    -0x40(%ebp),%eax
f0105ec0:	89 07                	mov    %eax,(%edi)
f0105ec2:	eb 03                	jmp    f0105ec7 <debuginfo_eip+0x287>
f0105ec4:	8b 7d 0c             	mov    0xc(%ebp),%edi


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105ec7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105eca:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105ecd:	b8 00 00 00 00       	mov    $0x0,%eax
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105ed2:	39 da                	cmp    %ebx,%edx
f0105ed4:	7d 67                	jge    f0105f3d <debuginfo_eip+0x2fd>
		for (lline = lfun + 1;
f0105ed6:	83 c2 01             	add    $0x1,%edx
f0105ed9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105edc:	89 d0                	mov    %edx,%eax
f0105ede:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105ee1:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0105ee4:	8d 14 96             	lea    (%esi,%edx,4),%edx
f0105ee7:	eb 04                	jmp    f0105eed <debuginfo_eip+0x2ad>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0105ee9:	83 47 14 01          	addl   $0x1,0x14(%edi)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0105eed:	39 c3                	cmp    %eax,%ebx
f0105eef:	7e 47                	jle    f0105f38 <debuginfo_eip+0x2f8>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105ef1:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0105ef5:	83 c0 01             	add    $0x1,%eax
f0105ef8:	83 c2 0c             	add    $0xc,%edx
f0105efb:	80 f9 a0             	cmp    $0xa0,%cl
f0105efe:	74 e9                	je     f0105ee9 <debuginfo_eip+0x2a9>
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105f00:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f05:	eb 36                	jmp    f0105f3d <debuginfo_eip+0x2fd>

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U)){
			return -1;
f0105f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f0c:	eb 2f                	jmp    f0105f3d <debuginfo_eip+0x2fd>

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		
		if ((user_mem_check(curenv, stabs, sizeof(struct Stab), PTE_U)) || (user_mem_check(curenv, stabstr, stabstr_end-stabstr, PTE_U))){
			return -1;
f0105f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f13:	eb 28                	jmp    f0105f3d <debuginfo_eip+0x2fd>
f0105f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f1a:	eb 21                	jmp    f0105f3d <debuginfo_eip+0x2fd>
		}
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f0105f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f21:	eb 1a                	jmp    f0105f3d <debuginfo_eip+0x2fd>
f0105f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f28:	eb 13                	jmp    f0105f3d <debuginfo_eip+0x2fd>
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
	rfile = (stab_end - stabs) - 1;
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
	if (lfile == 0)
		return -1;
f0105f2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f2f:	eb 0c                	jmp    f0105f3d <debuginfo_eip+0x2fd>
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
	if (lline > rline) {
		return -1;
f0105f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f36:	eb 05                	jmp    f0105f3d <debuginfo_eip+0x2fd>
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105f3d:	83 c4 4c             	add    $0x4c,%esp
f0105f40:	5b                   	pop    %ebx
f0105f41:	5e                   	pop    %esi
f0105f42:	5f                   	pop    %edi
f0105f43:	5d                   	pop    %ebp
f0105f44:	c3                   	ret    
f0105f45:	66 90                	xchg   %ax,%ax
f0105f47:	66 90                	xchg   %ax,%ax
f0105f49:	66 90                	xchg   %ax,%ax
f0105f4b:	66 90                	xchg   %ax,%ax
f0105f4d:	66 90                	xchg   %ax,%ax
f0105f4f:	90                   	nop

f0105f50 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105f50:	55                   	push   %ebp
f0105f51:	89 e5                	mov    %esp,%ebp
f0105f53:	57                   	push   %edi
f0105f54:	56                   	push   %esi
f0105f55:	53                   	push   %ebx
f0105f56:	83 ec 3c             	sub    $0x3c,%esp
f0105f59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105f5c:	89 d7                	mov    %edx,%edi
f0105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f61:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105f64:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105f67:	89 c3                	mov    %eax,%ebx
f0105f69:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105f6c:	8b 45 10             	mov    0x10(%ebp),%eax
f0105f6f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105f72:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105f77:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f7a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105f7d:	39 d9                	cmp    %ebx,%ecx
f0105f7f:	72 05                	jb     f0105f86 <printnum+0x36>
f0105f81:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f0105f84:	77 69                	ja     f0105fef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105f86:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105f89:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0105f8d:	83 ee 01             	sub    $0x1,%esi
f0105f90:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105f94:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105f98:	8b 44 24 08          	mov    0x8(%esp),%eax
f0105f9c:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0105fa0:	89 c3                	mov    %eax,%ebx
f0105fa2:	89 d6                	mov    %edx,%esi
f0105fa4:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105fa7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105faa:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105fae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0105fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105fb5:	89 04 24             	mov    %eax,(%esp)
f0105fb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105fbf:	e8 0c 1f 00 00       	call   f0107ed0 <__udivdi3>
f0105fc4:	89 d9                	mov    %ebx,%ecx
f0105fc6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105fca:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105fce:	89 04 24             	mov    %eax,(%esp)
f0105fd1:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105fd5:	89 fa                	mov    %edi,%edx
f0105fd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105fda:	e8 71 ff ff ff       	call   f0105f50 <printnum>
f0105fdf:	eb 1b                	jmp    f0105ffc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0105fe1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105fe5:	8b 45 18             	mov    0x18(%ebp),%eax
f0105fe8:	89 04 24             	mov    %eax,(%esp)
f0105feb:	ff d3                	call   *%ebx
f0105fed:	eb 03                	jmp    f0105ff2 <printnum+0xa2>
f0105fef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105ff2:	83 ee 01             	sub    $0x1,%esi
f0105ff5:	85 f6                	test   %esi,%esi
f0105ff7:	7f e8                	jg     f0105fe1 <printnum+0x91>
f0105ff9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105ffc:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106000:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0106004:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106007:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010600a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010600e:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106012:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106015:	89 04 24             	mov    %eax,(%esp)
f0106018:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010601b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010601f:	e8 dc 1f 00 00       	call   f0108000 <__umoddi3>
f0106024:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106028:	0f be 80 22 9b 10 f0 	movsbl -0xfef64de(%eax),%eax
f010602f:	89 04 24             	mov    %eax,(%esp)
f0106032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106035:	ff d0                	call   *%eax
}
f0106037:	83 c4 3c             	add    $0x3c,%esp
f010603a:	5b                   	pop    %ebx
f010603b:	5e                   	pop    %esi
f010603c:	5f                   	pop    %edi
f010603d:	5d                   	pop    %ebp
f010603e:	c3                   	ret    

f010603f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f010603f:	55                   	push   %ebp
f0106040:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0106042:	83 fa 01             	cmp    $0x1,%edx
f0106045:	7e 0e                	jle    f0106055 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f0106047:	8b 10                	mov    (%eax),%edx
f0106049:	8d 4a 08             	lea    0x8(%edx),%ecx
f010604c:	89 08                	mov    %ecx,(%eax)
f010604e:	8b 02                	mov    (%edx),%eax
f0106050:	8b 52 04             	mov    0x4(%edx),%edx
f0106053:	eb 22                	jmp    f0106077 <getuint+0x38>
	else if (lflag)
f0106055:	85 d2                	test   %edx,%edx
f0106057:	74 10                	je     f0106069 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0106059:	8b 10                	mov    (%eax),%edx
f010605b:	8d 4a 04             	lea    0x4(%edx),%ecx
f010605e:	89 08                	mov    %ecx,(%eax)
f0106060:	8b 02                	mov    (%edx),%eax
f0106062:	ba 00 00 00 00       	mov    $0x0,%edx
f0106067:	eb 0e                	jmp    f0106077 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0106069:	8b 10                	mov    (%eax),%edx
f010606b:	8d 4a 04             	lea    0x4(%edx),%ecx
f010606e:	89 08                	mov    %ecx,(%eax)
f0106070:	8b 02                	mov    (%edx),%eax
f0106072:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0106077:	5d                   	pop    %ebp
f0106078:	c3                   	ret    

f0106079 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0106079:	55                   	push   %ebp
f010607a:	89 e5                	mov    %esp,%ebp
f010607c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010607f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0106083:	8b 10                	mov    (%eax),%edx
f0106085:	3b 50 04             	cmp    0x4(%eax),%edx
f0106088:	73 0a                	jae    f0106094 <sprintputch+0x1b>
		*b->buf++ = ch;
f010608a:	8d 4a 01             	lea    0x1(%edx),%ecx
f010608d:	89 08                	mov    %ecx,(%eax)
f010608f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106092:	88 02                	mov    %al,(%edx)
}
f0106094:	5d                   	pop    %ebp
f0106095:	c3                   	ret    

f0106096 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0106096:	55                   	push   %ebp
f0106097:	89 e5                	mov    %esp,%ebp
f0106099:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
f010609c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010609f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01060a3:	8b 45 10             	mov    0x10(%ebp),%eax
f01060a6:	89 44 24 08          	mov    %eax,0x8(%esp)
f01060aa:	8b 45 0c             	mov    0xc(%ebp),%eax
f01060ad:	89 44 24 04          	mov    %eax,0x4(%esp)
f01060b1:	8b 45 08             	mov    0x8(%ebp),%eax
f01060b4:	89 04 24             	mov    %eax,(%esp)
f01060b7:	e8 02 00 00 00       	call   f01060be <vprintfmt>
	va_end(ap);
}
f01060bc:	c9                   	leave  
f01060bd:	c3                   	ret    

f01060be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f01060be:	55                   	push   %ebp
f01060bf:	89 e5                	mov    %esp,%ebp
f01060c1:	57                   	push   %edi
f01060c2:	56                   	push   %esi
f01060c3:	53                   	push   %ebx
f01060c4:	83 ec 3c             	sub    $0x3c,%esp
f01060c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01060ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01060cd:	eb 14                	jmp    f01060e3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f01060cf:	85 c0                	test   %eax,%eax
f01060d1:	0f 84 b3 03 00 00    	je     f010648a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
f01060d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01060db:	89 04 24             	mov    %eax,(%esp)
f01060de:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01060e1:	89 f3                	mov    %esi,%ebx
f01060e3:	8d 73 01             	lea    0x1(%ebx),%esi
f01060e6:	0f b6 03             	movzbl (%ebx),%eax
f01060e9:	83 f8 25             	cmp    $0x25,%eax
f01060ec:	75 e1                	jne    f01060cf <vprintfmt+0x11>
f01060ee:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
f01060f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01060f9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
f0106100:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
f0106107:	ba 00 00 00 00       	mov    $0x0,%edx
f010610c:	eb 1d                	jmp    f010612b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010610e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
f0106110:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
f0106114:	eb 15                	jmp    f010612b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106116:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f0106118:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
f010611c:	eb 0d                	jmp    f010612b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f010611e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0106121:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0106124:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010612b:	8d 5e 01             	lea    0x1(%esi),%ebx
f010612e:	0f b6 0e             	movzbl (%esi),%ecx
f0106131:	0f b6 c1             	movzbl %cl,%eax
f0106134:	83 e9 23             	sub    $0x23,%ecx
f0106137:	80 f9 55             	cmp    $0x55,%cl
f010613a:	0f 87 2a 03 00 00    	ja     f010646a <vprintfmt+0x3ac>
f0106140:	0f b6 c9             	movzbl %cl,%ecx
f0106143:	ff 24 8d a0 9c 10 f0 	jmp    *-0xfef6360(,%ecx,4)
f010614a:	89 de                	mov    %ebx,%esi
f010614c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0106151:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
f0106154:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
f0106158:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
f010615b:	8d 58 d0             	lea    -0x30(%eax),%ebx
f010615e:	83 fb 09             	cmp    $0x9,%ebx
f0106161:	77 36                	ja     f0106199 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0106163:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
f0106166:	eb e9                	jmp    f0106151 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0106168:	8b 45 14             	mov    0x14(%ebp),%eax
f010616b:	8d 48 04             	lea    0x4(%eax),%ecx
f010616e:	89 4d 14             	mov    %ecx,0x14(%ebp)
f0106171:	8b 00                	mov    (%eax),%eax
f0106173:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106176:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0106178:	eb 22                	jmp    f010619c <vprintfmt+0xde>
f010617a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010617d:	85 c9                	test   %ecx,%ecx
f010617f:	b8 00 00 00 00       	mov    $0x0,%eax
f0106184:	0f 49 c1             	cmovns %ecx,%eax
f0106187:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010618a:	89 de                	mov    %ebx,%esi
f010618c:	eb 9d                	jmp    f010612b <vprintfmt+0x6d>
f010618e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f0106190:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
f0106197:	eb 92                	jmp    f010612b <vprintfmt+0x6d>
f0106199:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
f010619c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01061a0:	79 89                	jns    f010612b <vprintfmt+0x6d>
f01061a2:	e9 77 ff ff ff       	jmp    f010611e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f01061a7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01061aa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
f01061ac:	e9 7a ff ff ff       	jmp    f010612b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f01061b1:	8b 45 14             	mov    0x14(%ebp),%eax
f01061b4:	8d 50 04             	lea    0x4(%eax),%edx
f01061b7:	89 55 14             	mov    %edx,0x14(%ebp)
f01061ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01061be:	8b 00                	mov    (%eax),%eax
f01061c0:	89 04 24             	mov    %eax,(%esp)
f01061c3:	ff 55 08             	call   *0x8(%ebp)
			break;
f01061c6:	e9 18 ff ff ff       	jmp    f01060e3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
f01061cb:	8b 45 14             	mov    0x14(%ebp),%eax
f01061ce:	8d 50 04             	lea    0x4(%eax),%edx
f01061d1:	89 55 14             	mov    %edx,0x14(%ebp)
f01061d4:	8b 00                	mov    (%eax),%eax
f01061d6:	99                   	cltd   
f01061d7:	31 d0                	xor    %edx,%eax
f01061d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01061db:	83 f8 12             	cmp    $0x12,%eax
f01061de:	7f 0b                	jg     f01061eb <vprintfmt+0x12d>
f01061e0:	8b 14 85 00 9e 10 f0 	mov    -0xfef6200(,%eax,4),%edx
f01061e7:	85 d2                	test   %edx,%edx
f01061e9:	75 20                	jne    f010620b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
f01061eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01061ef:	c7 44 24 08 3a 9b 10 	movl   $0xf0109b3a,0x8(%esp)
f01061f6:	f0 
f01061f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01061fb:	8b 45 08             	mov    0x8(%ebp),%eax
f01061fe:	89 04 24             	mov    %eax,(%esp)
f0106201:	e8 90 fe ff ff       	call   f0106096 <printfmt>
f0106206:	e9 d8 fe ff ff       	jmp    f01060e3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
f010620b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010620f:	c7 44 24 08 f3 89 10 	movl   $0xf01089f3,0x8(%esp)
f0106216:	f0 
f0106217:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010621b:	8b 45 08             	mov    0x8(%ebp),%eax
f010621e:	89 04 24             	mov    %eax,(%esp)
f0106221:	e8 70 fe ff ff       	call   f0106096 <printfmt>
f0106226:	e9 b8 fe ff ff       	jmp    f01060e3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010622b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010622e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0106231:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0106234:	8b 45 14             	mov    0x14(%ebp),%eax
f0106237:	8d 50 04             	lea    0x4(%eax),%edx
f010623a:	89 55 14             	mov    %edx,0x14(%ebp)
f010623d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
f010623f:	85 f6                	test   %esi,%esi
f0106241:	b8 33 9b 10 f0       	mov    $0xf0109b33,%eax
f0106246:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
f0106249:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
f010624d:	0f 84 97 00 00 00    	je     f01062ea <vprintfmt+0x22c>
f0106253:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0106257:	0f 8e 9b 00 00 00    	jle    f01062f8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
f010625d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106261:	89 34 24             	mov    %esi,(%esp)
f0106264:	e8 ff 04 00 00       	call   f0106768 <strnlen>
f0106269:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010626c:	29 c2                	sub    %eax,%edx
f010626e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
f0106271:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
f0106275:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0106278:	89 75 d8             	mov    %esi,-0x28(%ebp)
f010627b:	8b 75 08             	mov    0x8(%ebp),%esi
f010627e:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106281:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0106283:	eb 0f                	jmp    f0106294 <vprintfmt+0x1d6>
					putch(padc, putdat);
f0106285:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106289:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010628c:	89 04 24             	mov    %eax,(%esp)
f010628f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0106291:	83 eb 01             	sub    $0x1,%ebx
f0106294:	85 db                	test   %ebx,%ebx
f0106296:	7f ed                	jg     f0106285 <vprintfmt+0x1c7>
f0106298:	8b 75 d8             	mov    -0x28(%ebp),%esi
f010629b:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010629e:	85 d2                	test   %edx,%edx
f01062a0:	b8 00 00 00 00       	mov    $0x0,%eax
f01062a5:	0f 49 c2             	cmovns %edx,%eax
f01062a8:	29 c2                	sub    %eax,%edx
f01062aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
f01062ad:	89 d7                	mov    %edx,%edi
f01062af:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01062b2:	eb 50                	jmp    f0106304 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01062b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01062b8:	74 1e                	je     f01062d8 <vprintfmt+0x21a>
f01062ba:	0f be d2             	movsbl %dl,%edx
f01062bd:	83 ea 20             	sub    $0x20,%edx
f01062c0:	83 fa 5e             	cmp    $0x5e,%edx
f01062c3:	76 13                	jbe    f01062d8 <vprintfmt+0x21a>
					putch('?', putdat);
f01062c5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01062c8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01062cc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f01062d3:	ff 55 08             	call   *0x8(%ebp)
f01062d6:	eb 0d                	jmp    f01062e5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
f01062d8:	8b 55 0c             	mov    0xc(%ebp),%edx
f01062db:	89 54 24 04          	mov    %edx,0x4(%esp)
f01062df:	89 04 24             	mov    %eax,(%esp)
f01062e2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01062e5:	83 ef 01             	sub    $0x1,%edi
f01062e8:	eb 1a                	jmp    f0106304 <vprintfmt+0x246>
f01062ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
f01062ed:	8b 7d dc             	mov    -0x24(%ebp),%edi
f01062f0:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01062f3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01062f6:	eb 0c                	jmp    f0106304 <vprintfmt+0x246>
f01062f8:	89 7d 0c             	mov    %edi,0xc(%ebp)
f01062fb:	8b 7d dc             	mov    -0x24(%ebp),%edi
f01062fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106301:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0106304:	83 c6 01             	add    $0x1,%esi
f0106307:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
f010630b:	0f be c2             	movsbl %dl,%eax
f010630e:	85 c0                	test   %eax,%eax
f0106310:	74 27                	je     f0106339 <vprintfmt+0x27b>
f0106312:	85 db                	test   %ebx,%ebx
f0106314:	78 9e                	js     f01062b4 <vprintfmt+0x1f6>
f0106316:	83 eb 01             	sub    $0x1,%ebx
f0106319:	79 99                	jns    f01062b4 <vprintfmt+0x1f6>
f010631b:	89 f8                	mov    %edi,%eax
f010631d:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0106320:	8b 75 08             	mov    0x8(%ebp),%esi
f0106323:	89 c3                	mov    %eax,%ebx
f0106325:	eb 1a                	jmp    f0106341 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0106327:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010632b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0106332:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0106334:	83 eb 01             	sub    $0x1,%ebx
f0106337:	eb 08                	jmp    f0106341 <vprintfmt+0x283>
f0106339:	89 fb                	mov    %edi,%ebx
f010633b:	8b 75 08             	mov    0x8(%ebp),%esi
f010633e:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0106341:	85 db                	test   %ebx,%ebx
f0106343:	7f e2                	jg     f0106327 <vprintfmt+0x269>
f0106345:	89 75 08             	mov    %esi,0x8(%ebp)
f0106348:	8b 5d 10             	mov    0x10(%ebp),%ebx
f010634b:	e9 93 fd ff ff       	jmp    f01060e3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0106350:	83 fa 01             	cmp    $0x1,%edx
f0106353:	7e 16                	jle    f010636b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
f0106355:	8b 45 14             	mov    0x14(%ebp),%eax
f0106358:	8d 50 08             	lea    0x8(%eax),%edx
f010635b:	89 55 14             	mov    %edx,0x14(%ebp)
f010635e:	8b 50 04             	mov    0x4(%eax),%edx
f0106361:	8b 00                	mov    (%eax),%eax
f0106363:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106366:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0106369:	eb 32                	jmp    f010639d <vprintfmt+0x2df>
	else if (lflag)
f010636b:	85 d2                	test   %edx,%edx
f010636d:	74 18                	je     f0106387 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
f010636f:	8b 45 14             	mov    0x14(%ebp),%eax
f0106372:	8d 50 04             	lea    0x4(%eax),%edx
f0106375:	89 55 14             	mov    %edx,0x14(%ebp)
f0106378:	8b 30                	mov    (%eax),%esi
f010637a:	89 75 e0             	mov    %esi,-0x20(%ebp)
f010637d:	89 f0                	mov    %esi,%eax
f010637f:	c1 f8 1f             	sar    $0x1f,%eax
f0106382:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106385:	eb 16                	jmp    f010639d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
f0106387:	8b 45 14             	mov    0x14(%ebp),%eax
f010638a:	8d 50 04             	lea    0x4(%eax),%edx
f010638d:	89 55 14             	mov    %edx,0x14(%ebp)
f0106390:	8b 30                	mov    (%eax),%esi
f0106392:	89 75 e0             	mov    %esi,-0x20(%ebp)
f0106395:	89 f0                	mov    %esi,%eax
f0106397:	c1 f8 1f             	sar    $0x1f,%eax
f010639a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f010639d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f01063a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f01063a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01063ac:	0f 89 80 00 00 00    	jns    f0106432 <vprintfmt+0x374>
				putch('-', putdat);
f01063b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01063b6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01063bd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01063c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01063c6:	f7 d8                	neg    %eax
f01063c8:	83 d2 00             	adc    $0x0,%edx
f01063cb:	f7 da                	neg    %edx
			}
			base = 10;
f01063cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01063d2:	eb 5e                	jmp    f0106432 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01063d4:	8d 45 14             	lea    0x14(%ebp),%eax
f01063d7:	e8 63 fc ff ff       	call   f010603f <getuint>
			base = 10;
f01063dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
f01063e1:	eb 4f                	jmp    f0106432 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
f01063e3:	8d 45 14             	lea    0x14(%ebp),%eax
f01063e6:	e8 54 fc ff ff       	call   f010603f <getuint>
			base = 8;
f01063eb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
f01063f0:	eb 40                	jmp    f0106432 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
f01063f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01063f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f01063fd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0106400:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106404:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f010640b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f010640e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106411:	8d 50 04             	lea    0x4(%eax),%edx
f0106414:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0106417:	8b 00                	mov    (%eax),%eax
f0106419:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f010641e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
f0106423:	eb 0d                	jmp    f0106432 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0106425:	8d 45 14             	lea    0x14(%ebp),%eax
f0106428:	e8 12 fc ff ff       	call   f010603f <getuint>
			base = 16;
f010642d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
f0106432:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
f0106436:	89 74 24 10          	mov    %esi,0x10(%esp)
f010643a:	8b 75 dc             	mov    -0x24(%ebp),%esi
f010643d:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106441:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106445:	89 04 24             	mov    %eax,(%esp)
f0106448:	89 54 24 04          	mov    %edx,0x4(%esp)
f010644c:	89 fa                	mov    %edi,%edx
f010644e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106451:	e8 fa fa ff ff       	call   f0105f50 <printnum>
			break;
f0106456:	e9 88 fc ff ff       	jmp    f01060e3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f010645b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010645f:	89 04 24             	mov    %eax,(%esp)
f0106462:	ff 55 08             	call   *0x8(%ebp)
			break;
f0106465:	e9 79 fc ff ff       	jmp    f01060e3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f010646a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010646e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0106475:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0106478:	89 f3                	mov    %esi,%ebx
f010647a:	eb 03                	jmp    f010647f <vprintfmt+0x3c1>
f010647c:	83 eb 01             	sub    $0x1,%ebx
f010647f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f0106483:	75 f7                	jne    f010647c <vprintfmt+0x3be>
f0106485:	e9 59 fc ff ff       	jmp    f01060e3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
f010648a:	83 c4 3c             	add    $0x3c,%esp
f010648d:	5b                   	pop    %ebx
f010648e:	5e                   	pop    %esi
f010648f:	5f                   	pop    %edi
f0106490:	5d                   	pop    %ebp
f0106491:	c3                   	ret    

f0106492 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0106492:	55                   	push   %ebp
f0106493:	89 e5                	mov    %esp,%ebp
f0106495:	83 ec 28             	sub    $0x28,%esp
f0106498:	8b 45 08             	mov    0x8(%ebp),%eax
f010649b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f010649e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01064a1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01064a5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01064a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01064af:	85 c0                	test   %eax,%eax
f01064b1:	74 30                	je     f01064e3 <vsnprintf+0x51>
f01064b3:	85 d2                	test   %edx,%edx
f01064b5:	7e 2c                	jle    f01064e3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01064b7:	8b 45 14             	mov    0x14(%ebp),%eax
f01064ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01064be:	8b 45 10             	mov    0x10(%ebp),%eax
f01064c1:	89 44 24 08          	mov    %eax,0x8(%esp)
f01064c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01064c8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01064cc:	c7 04 24 79 60 10 f0 	movl   $0xf0106079,(%esp)
f01064d3:	e8 e6 fb ff ff       	call   f01060be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01064d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01064db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01064de:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01064e1:	eb 05                	jmp    f01064e8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f01064e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f01064e8:	c9                   	leave  
f01064e9:	c3                   	ret    

f01064ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01064ea:	55                   	push   %ebp
f01064eb:	89 e5                	mov    %esp,%ebp
f01064ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01064f0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01064f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01064f7:	8b 45 10             	mov    0x10(%ebp),%eax
f01064fa:	89 44 24 08          	mov    %eax,0x8(%esp)
f01064fe:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106501:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106505:	8b 45 08             	mov    0x8(%ebp),%eax
f0106508:	89 04 24             	mov    %eax,(%esp)
f010650b:	e8 82 ff ff ff       	call   f0106492 <vsnprintf>
	va_end(ap);

	return rc;
}
f0106510:	c9                   	leave  
f0106511:	c3                   	ret    
f0106512:	66 90                	xchg   %ax,%ax
f0106514:	66 90                	xchg   %ax,%ax
f0106516:	66 90                	xchg   %ax,%ax
f0106518:	66 90                	xchg   %ax,%ax
f010651a:	66 90                	xchg   %ax,%ax
f010651c:	66 90                	xchg   %ax,%ax
f010651e:	66 90                	xchg   %ax,%ax

f0106520 <tab_handler>:
	}
}

int
tab_handler(int tab_pos)
{
f0106520:	55                   	push   %ebp
f0106521:	89 e5                	mov    %esp,%ebp
f0106523:	57                   	push   %edi
f0106524:	56                   	push   %esi
f0106525:	53                   	push   %ebx
f0106526:	83 ec 3c             	sub    $0x3c,%esp
f0106529:	8b 45 08             	mov    0x8(%ebp),%eax
	char* begin = buf + tab_pos;
f010652c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010652f:	05 80 4a 2c f0       	add    $0xf02c4a80,%eax
f0106534:	89 c6                	mov    %eax,%esi
	while ((begin > buf) && (*(begin -1) != ' '))
f0106536:	eb 03                	jmp    f010653b <tab_handler+0x1b>
		begin--;
f0106538:	83 ee 01             	sub    $0x1,%esi

int
tab_handler(int tab_pos)
{
	char* begin = buf + tab_pos;
	while ((begin > buf) && (*(begin -1) != ' '))
f010653b:	81 fe 80 4a 2c f0    	cmp    $0xf02c4a80,%esi
f0106541:	76 06                	jbe    f0106549 <tab_handler+0x29>
f0106543:	80 7e ff 20          	cmpb   $0x20,-0x1(%esi)
f0106547:	75 ef                	jne    f0106538 <tab_handler+0x18>
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
f0106549:	29 f0                	sub    %esi,%eax
f010654b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	char* cmd = 0;
f010654e:	bb 00 00 00 00       	mov    $0x0,%ebx

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
f0106553:	bf 00 00 00 00       	mov    $0x0,%edi
{
	char* begin = buf + tab_pos;
	while ((begin > buf) && (*(begin -1) != ' '))
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
f0106558:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010655f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0106566:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f0106569:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f010656c:	89 c6                	mov    %eax,%esi
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
f010656e:	eb 35                	jmp    f01065a5 <tab_handler+0x85>
      		if (strncmp(begin, commands[i], len) == 0) {
f0106570:	8b 1c bd 20 9f 10 f0 	mov    -0xfef60e0(,%edi,4),%ebx
f0106577:	89 74 24 08          	mov    %esi,0x8(%esp)
f010657b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010657f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106582:	89 04 24             	mov    %eax,(%esp)
f0106585:	e8 d8 02 00 00       	call   f0106862 <strncmp>
f010658a:	85 c0                	test   %eax,%eax
f010658c:	75 14                	jne    f01065a2 <tab_handler+0x82>
			found_num++;
f010658e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
         		cmd = commands[i];
         		cmd_append_len = strlen(cmd) - len;
f0106592:	89 1c 24             	mov    %ebx,(%esp)
f0106595:	e8 b6 01 00 00       	call   f0106750 <strlen>
f010659a:	29 f0                	sub    %esi,%eax
f010659c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
      		if (strncmp(begin, commands[i], len) == 0) {
			found_num++;
         		cmd = commands[i];
f010659f:	89 5d d8             	mov    %ebx,-0x28(%ebp)
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
f01065a2:	83 c7 01             	add    $0x1,%edi
f01065a5:	83 ff 10             	cmp    $0x10,%edi
f01065a8:	7f 04                	jg     f01065ae <tab_handler+0x8e>
f01065aa:	85 f6                	test   %esi,%esi
f01065ac:	7f c2                	jg     f0106570 <tab_handler+0x50>
f01065ae:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01065b1:	8b 5d d8             	mov    -0x28(%ebp),%ebx
         		cmd = commands[i];
         		cmd_append_len = strlen(cmd) - len;
      		}
   	}

	if (found_num > 1) {
f01065b4:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
f01065b8:	7e 5a                	jle    f0106614 <tab_handler+0xf4>
		#if JOS_KERNEL
			cprintf("\nYour options are:\n");
f01065ba:	c7 04 24 6b 9e 10 f0 	movl   $0xf0109e6b,(%esp)
f01065c1:	e8 10 dd ff ff       	call   f01042d6 <cprintf>
		#else
			fprintf(1, "\nYour options are:\n");
		#endif
		for (i = 0; i < NUM_CMDS; i++) {
f01065c6:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (strncmp(begin, commands[i], len) == 0) {
f01065cb:	8b 3c 9d 20 9f 10 f0 	mov    -0xfef60e0(,%ebx,4),%edi
f01065d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01065d5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01065d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01065dd:	89 34 24             	mov    %esi,(%esp)
f01065e0:	e8 7d 02 00 00       	call   f0106862 <strncmp>
f01065e5:	85 c0                	test   %eax,%eax
f01065e7:	75 10                	jne    f01065f9 <tab_handler+0xd9>
                    		#if JOS_KERNEL
                            		cprintf("%s\n", commands[i]);
f01065e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01065ed:	c7 04 24 85 84 10 f0 	movl   $0xf0108485,(%esp)
f01065f4:	e8 dd dc ff ff       	call   f01042d6 <cprintf>
		#if JOS_KERNEL
			cprintf("\nYour options are:\n");
		#else
			fprintf(1, "\nYour options are:\n");
		#endif
		for (i = 0; i < NUM_CMDS; i++) {
f01065f9:	83 c3 01             	add    $0x1,%ebx
f01065fc:	83 fb 11             	cmp    $0x11,%ebx
f01065ff:	75 ca                	jne    f01065cb <tab_handler+0xab>
                           		fprintf(1, "%s\n", commands[i]);
                   		 #endif
                 	}
            	}
		#if JOS_KERNEL
			cprintf("$ ");
f0106601:	c7 04 24 7f 9e 10 f0 	movl   $0xf0109e7f,(%esp)
f0106608:	e8 c9 dc ff ff       	call   f01042d6 <cprintf>
		#else
			fprintf(1, "$ ");
		#endif
		return -len;
f010660d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106610:	f7 d8                	neg    %eax
f0106612:	eb 3e                	jmp    f0106652 <tab_handler+0x132>
f0106614:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106617:	89 d0                	mov    %edx,%eax
	}

	int pos_to_write = tab_pos;

	if (cmd_append_len > 0){
f0106619:	85 d2                	test   %edx,%edx
f010661b:	7e 35                	jle    f0106652 <tab_handler+0x132>
f010661d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106620:	89 c6                	mov    %eax,%esi
f0106622:	8b 7d d0             	mov    -0x30(%ebp),%edi
f0106625:	29 c7                	sub    %eax,%edi
f0106627:	eb 1a                	jmp    f0106643 <tab_handler+0x123>
		for (i = len; i < strlen(cmd); i++) {
      			buf[pos_to_write] = cmd[i];
f0106629:	0f b6 04 33          	movzbl (%ebx,%esi,1),%eax
f010662d:	88 84 37 80 4a 2c f0 	mov    %al,-0xfd3b580(%edi,%esi,1)
			pos_to_write++;
      			cputchar(cmd[i]);
f0106634:	0f be 04 33          	movsbl (%ebx,%esi,1),%eax
f0106638:	89 04 24             	mov    %eax,(%esp)
f010663b:	e8 97 a1 ff ff       	call   f01007d7 <cputchar>
	}

	int pos_to_write = tab_pos;

	if (cmd_append_len > 0){
		for (i = len; i < strlen(cmd); i++) {
f0106640:	83 c6 01             	add    $0x1,%esi
f0106643:	89 1c 24             	mov    %ebx,(%esp)
f0106646:	e8 05 01 00 00       	call   f0106750 <strlen>
f010664b:	39 c6                	cmp    %eax,%esi
f010664d:	7c da                	jl     f0106629 <tab_handler+0x109>
f010664f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   		}

	}

	return cmd_append_len;
}
f0106652:	83 c4 3c             	add    $0x3c,%esp
f0106655:	5b                   	pop    %ebx
f0106656:	5e                   	pop    %esi
f0106657:	5f                   	pop    %edi
f0106658:	5d                   	pop    %ebp
f0106659:	c3                   	ret    

f010665a <readline>:
int tab_handler(int tab_pos);


char *
readline(const char *prompt)
{
f010665a:	55                   	push   %ebp
f010665b:	89 e5                	mov    %esp,%ebp
f010665d:	57                   	push   %edi
f010665e:	56                   	push   %esi
f010665f:	53                   	push   %ebx
f0106660:	83 ec 1c             	sub    $0x1c,%esp
f0106663:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106666:	85 c0                	test   %eax,%eax
f0106668:	74 10                	je     f010667a <readline+0x20>
		cprintf("%s", prompt);
f010666a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010666e:	c7 04 24 f3 89 10 f0 	movl   $0xf01089f3,(%esp)
f0106675:	e8 5c dc ff ff       	call   f01042d6 <cprintf>
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010667a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0106681:	e8 72 a1 ff ff       	call   f01007f8 <iscons>
f0106686:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f0106688:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
f010668d:	e8 55 a1 ff ff       	call   f01007e7 <getchar>
f0106692:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0106694:	85 c0                	test   %eax,%eax
f0106696:	79 28                	jns    f01066c0 <readline+0x66>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0106698:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
f010669d:	83 fb f8             	cmp    $0xfffffff8,%ebx
f01066a0:	0f 84 a1 00 00 00    	je     f0106747 <readline+0xed>
				cprintf("read error: %e\n", c);
f01066a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01066aa:	c7 04 24 82 9e 10 f0 	movl   $0xf0109e82,(%esp)
f01066b1:	e8 20 dc ff ff       	call   f01042d6 <cprintf>
			return NULL;
f01066b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01066bb:	e9 87 00 00 00       	jmp    f0106747 <readline+0xed>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01066c0:	83 f8 7f             	cmp    $0x7f,%eax
f01066c3:	74 05                	je     f01066ca <readline+0x70>
f01066c5:	83 f8 08             	cmp    $0x8,%eax
f01066c8:	75 19                	jne    f01066e3 <readline+0x89>
f01066ca:	85 f6                	test   %esi,%esi
f01066cc:	7e 15                	jle    f01066e3 <readline+0x89>
			if (echoing)
f01066ce:	85 ff                	test   %edi,%edi
f01066d0:	74 0c                	je     f01066de <readline+0x84>
				cputchar('\b');
f01066d2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f01066d9:	e8 f9 a0 ff ff       	call   f01007d7 <cputchar>
			i--;
f01066de:	83 ee 01             	sub    $0x1,%esi
f01066e1:	eb aa                	jmp    f010668d <readline+0x33>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01066e3:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01066e9:	7f 1c                	jg     f0106707 <readline+0xad>
f01066eb:	83 fb 1f             	cmp    $0x1f,%ebx
f01066ee:	7e 17                	jle    f0106707 <readline+0xad>
			if (echoing)
f01066f0:	85 ff                	test   %edi,%edi
f01066f2:	74 08                	je     f01066fc <readline+0xa2>
				cputchar(c);
f01066f4:	89 1c 24             	mov    %ebx,(%esp)
f01066f7:	e8 db a0 ff ff       	call   f01007d7 <cputchar>
			buf[i++] = c;
f01066fc:	88 9e 80 4a 2c f0    	mov    %bl,-0xfd3b580(%esi)
f0106702:	8d 76 01             	lea    0x1(%esi),%esi
f0106705:	eb 86                	jmp    f010668d <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0106707:	83 fb 0d             	cmp    $0xd,%ebx
f010670a:	74 05                	je     f0106711 <readline+0xb7>
f010670c:	83 fb 0a             	cmp    $0xa,%ebx
f010670f:	75 1e                	jne    f010672f <readline+0xd5>
			if (echoing)
f0106711:	85 ff                	test   %edi,%edi
f0106713:	74 0c                	je     f0106721 <readline+0xc7>
				cputchar('\n');
f0106715:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f010671c:	e8 b6 a0 ff ff       	call   f01007d7 <cputchar>
			buf[i] = 0;
f0106721:	c6 86 80 4a 2c f0 00 	movb   $0x0,-0xfd3b580(%esi)
			return buf;
f0106728:	b8 80 4a 2c f0       	mov    $0xf02c4a80,%eax
f010672d:	eb 18                	jmp    f0106747 <readline+0xed>
		} else if (c == '\t') {
f010672f:	83 fb 09             	cmp    $0x9,%ebx
f0106732:	0f 85 55 ff ff ff    	jne    f010668d <readline+0x33>
			i += tab_handler(i);
f0106738:	89 34 24             	mov    %esi,(%esp)
f010673b:	e8 e0 fd ff ff       	call   f0106520 <tab_handler>
f0106740:	01 c6                	add    %eax,%esi
f0106742:	e9 46 ff ff ff       	jmp    f010668d <readline+0x33>
		}
	}
}
f0106747:	83 c4 1c             	add    $0x1c,%esp
f010674a:	5b                   	pop    %ebx
f010674b:	5e                   	pop    %esi
f010674c:	5f                   	pop    %edi
f010674d:	5d                   	pop    %ebp
f010674e:	c3                   	ret    
f010674f:	90                   	nop

f0106750 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106750:	55                   	push   %ebp
f0106751:	89 e5                	mov    %esp,%ebp
f0106753:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0106756:	b8 00 00 00 00       	mov    $0x0,%eax
f010675b:	eb 03                	jmp    f0106760 <strlen+0x10>
		n++;
f010675d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0106760:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106764:	75 f7                	jne    f010675d <strlen+0xd>
		n++;
	return n;
}
f0106766:	5d                   	pop    %ebp
f0106767:	c3                   	ret    

f0106768 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106768:	55                   	push   %ebp
f0106769:	89 e5                	mov    %esp,%ebp
f010676b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010676e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106771:	b8 00 00 00 00       	mov    $0x0,%eax
f0106776:	eb 03                	jmp    f010677b <strnlen+0x13>
		n++;
f0106778:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010677b:	39 d0                	cmp    %edx,%eax
f010677d:	74 06                	je     f0106785 <strnlen+0x1d>
f010677f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0106783:	75 f3                	jne    f0106778 <strnlen+0x10>
		n++;
	return n;
}
f0106785:	5d                   	pop    %ebp
f0106786:	c3                   	ret    

f0106787 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106787:	55                   	push   %ebp
f0106788:	89 e5                	mov    %esp,%ebp
f010678a:	53                   	push   %ebx
f010678b:	8b 45 08             	mov    0x8(%ebp),%eax
f010678e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106791:	89 c2                	mov    %eax,%edx
f0106793:	83 c2 01             	add    $0x1,%edx
f0106796:	83 c1 01             	add    $0x1,%ecx
f0106799:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f010679d:	88 5a ff             	mov    %bl,-0x1(%edx)
f01067a0:	84 db                	test   %bl,%bl
f01067a2:	75 ef                	jne    f0106793 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f01067a4:	5b                   	pop    %ebx
f01067a5:	5d                   	pop    %ebp
f01067a6:	c3                   	ret    

f01067a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
f01067a7:	55                   	push   %ebp
f01067a8:	89 e5                	mov    %esp,%ebp
f01067aa:	53                   	push   %ebx
f01067ab:	83 ec 08             	sub    $0x8,%esp
f01067ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01067b1:	89 1c 24             	mov    %ebx,(%esp)
f01067b4:	e8 97 ff ff ff       	call   f0106750 <strlen>
	strcpy(dst + len, src);
f01067b9:	8b 55 0c             	mov    0xc(%ebp),%edx
f01067bc:	89 54 24 04          	mov    %edx,0x4(%esp)
f01067c0:	01 d8                	add    %ebx,%eax
f01067c2:	89 04 24             	mov    %eax,(%esp)
f01067c5:	e8 bd ff ff ff       	call   f0106787 <strcpy>
	return dst;
}
f01067ca:	89 d8                	mov    %ebx,%eax
f01067cc:	83 c4 08             	add    $0x8,%esp
f01067cf:	5b                   	pop    %ebx
f01067d0:	5d                   	pop    %ebp
f01067d1:	c3                   	ret    

f01067d2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01067d2:	55                   	push   %ebp
f01067d3:	89 e5                	mov    %esp,%ebp
f01067d5:	56                   	push   %esi
f01067d6:	53                   	push   %ebx
f01067d7:	8b 75 08             	mov    0x8(%ebp),%esi
f01067da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01067dd:	89 f3                	mov    %esi,%ebx
f01067df:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01067e2:	89 f2                	mov    %esi,%edx
f01067e4:	eb 0f                	jmp    f01067f5 <strncpy+0x23>
		*dst++ = *src;
f01067e6:	83 c2 01             	add    $0x1,%edx
f01067e9:	0f b6 01             	movzbl (%ecx),%eax
f01067ec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01067ef:	80 39 01             	cmpb   $0x1,(%ecx)
f01067f2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01067f5:	39 da                	cmp    %ebx,%edx
f01067f7:	75 ed                	jne    f01067e6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f01067f9:	89 f0                	mov    %esi,%eax
f01067fb:	5b                   	pop    %ebx
f01067fc:	5e                   	pop    %esi
f01067fd:	5d                   	pop    %ebp
f01067fe:	c3                   	ret    

f01067ff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01067ff:	55                   	push   %ebp
f0106800:	89 e5                	mov    %esp,%ebp
f0106802:	56                   	push   %esi
f0106803:	53                   	push   %ebx
f0106804:	8b 75 08             	mov    0x8(%ebp),%esi
f0106807:	8b 55 0c             	mov    0xc(%ebp),%edx
f010680a:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010680d:	89 f0                	mov    %esi,%eax
f010680f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0106813:	85 c9                	test   %ecx,%ecx
f0106815:	75 0b                	jne    f0106822 <strlcpy+0x23>
f0106817:	eb 1d                	jmp    f0106836 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0106819:	83 c0 01             	add    $0x1,%eax
f010681c:	83 c2 01             	add    $0x1,%edx
f010681f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0106822:	39 d8                	cmp    %ebx,%eax
f0106824:	74 0b                	je     f0106831 <strlcpy+0x32>
f0106826:	0f b6 0a             	movzbl (%edx),%ecx
f0106829:	84 c9                	test   %cl,%cl
f010682b:	75 ec                	jne    f0106819 <strlcpy+0x1a>
f010682d:	89 c2                	mov    %eax,%edx
f010682f:	eb 02                	jmp    f0106833 <strlcpy+0x34>
f0106831:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
f0106833:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
f0106836:	29 f0                	sub    %esi,%eax
}
f0106838:	5b                   	pop    %ebx
f0106839:	5e                   	pop    %esi
f010683a:	5d                   	pop    %ebp
f010683b:	c3                   	ret    

f010683c <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010683c:	55                   	push   %ebp
f010683d:	89 e5                	mov    %esp,%ebp
f010683f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106842:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106845:	eb 06                	jmp    f010684d <strcmp+0x11>
		p++, q++;
f0106847:	83 c1 01             	add    $0x1,%ecx
f010684a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f010684d:	0f b6 01             	movzbl (%ecx),%eax
f0106850:	84 c0                	test   %al,%al
f0106852:	74 04                	je     f0106858 <strcmp+0x1c>
f0106854:	3a 02                	cmp    (%edx),%al
f0106856:	74 ef                	je     f0106847 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106858:	0f b6 c0             	movzbl %al,%eax
f010685b:	0f b6 12             	movzbl (%edx),%edx
f010685e:	29 d0                	sub    %edx,%eax
}
f0106860:	5d                   	pop    %ebp
f0106861:	c3                   	ret    

f0106862 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106862:	55                   	push   %ebp
f0106863:	89 e5                	mov    %esp,%ebp
f0106865:	53                   	push   %ebx
f0106866:	8b 45 08             	mov    0x8(%ebp),%eax
f0106869:	8b 55 0c             	mov    0xc(%ebp),%edx
f010686c:	89 c3                	mov    %eax,%ebx
f010686e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0106871:	eb 06                	jmp    f0106879 <strncmp+0x17>
		n--, p++, q++;
f0106873:	83 c0 01             	add    $0x1,%eax
f0106876:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0106879:	39 d8                	cmp    %ebx,%eax
f010687b:	74 15                	je     f0106892 <strncmp+0x30>
f010687d:	0f b6 08             	movzbl (%eax),%ecx
f0106880:	84 c9                	test   %cl,%cl
f0106882:	74 04                	je     f0106888 <strncmp+0x26>
f0106884:	3a 0a                	cmp    (%edx),%cl
f0106886:	74 eb                	je     f0106873 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106888:	0f b6 00             	movzbl (%eax),%eax
f010688b:	0f b6 12             	movzbl (%edx),%edx
f010688e:	29 d0                	sub    %edx,%eax
f0106890:	eb 05                	jmp    f0106897 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f0106892:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0106897:	5b                   	pop    %ebx
f0106898:	5d                   	pop    %ebp
f0106899:	c3                   	ret    

f010689a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010689a:	55                   	push   %ebp
f010689b:	89 e5                	mov    %esp,%ebp
f010689d:	8b 45 08             	mov    0x8(%ebp),%eax
f01068a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01068a4:	eb 07                	jmp    f01068ad <strchr+0x13>
		if (*s == c)
f01068a6:	38 ca                	cmp    %cl,%dl
f01068a8:	74 0f                	je     f01068b9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f01068aa:	83 c0 01             	add    $0x1,%eax
f01068ad:	0f b6 10             	movzbl (%eax),%edx
f01068b0:	84 d2                	test   %dl,%dl
f01068b2:	75 f2                	jne    f01068a6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
f01068b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01068b9:	5d                   	pop    %ebp
f01068ba:	c3                   	ret    

f01068bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01068bb:	55                   	push   %ebp
f01068bc:	89 e5                	mov    %esp,%ebp
f01068be:	8b 45 08             	mov    0x8(%ebp),%eax
f01068c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01068c5:	eb 07                	jmp    f01068ce <strfind+0x13>
		if (*s == c)
f01068c7:	38 ca                	cmp    %cl,%dl
f01068c9:	74 0a                	je     f01068d5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01068cb:	83 c0 01             	add    $0x1,%eax
f01068ce:	0f b6 10             	movzbl (%eax),%edx
f01068d1:	84 d2                	test   %dl,%dl
f01068d3:	75 f2                	jne    f01068c7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
f01068d5:	5d                   	pop    %ebp
f01068d6:	c3                   	ret    

f01068d7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01068d7:	55                   	push   %ebp
f01068d8:	89 e5                	mov    %esp,%ebp
f01068da:	57                   	push   %edi
f01068db:	56                   	push   %esi
f01068dc:	53                   	push   %ebx
f01068dd:	8b 7d 08             	mov    0x8(%ebp),%edi
f01068e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01068e3:	85 c9                	test   %ecx,%ecx
f01068e5:	74 36                	je     f010691d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01068e7:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01068ed:	75 28                	jne    f0106917 <memset+0x40>
f01068ef:	f6 c1 03             	test   $0x3,%cl
f01068f2:	75 23                	jne    f0106917 <memset+0x40>
		c &= 0xFF;
f01068f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01068f8:	89 d3                	mov    %edx,%ebx
f01068fa:	c1 e3 08             	shl    $0x8,%ebx
f01068fd:	89 d6                	mov    %edx,%esi
f01068ff:	c1 e6 18             	shl    $0x18,%esi
f0106902:	89 d0                	mov    %edx,%eax
f0106904:	c1 e0 10             	shl    $0x10,%eax
f0106907:	09 f0                	or     %esi,%eax
f0106909:	09 c2                	or     %eax,%edx
f010690b:	89 d0                	mov    %edx,%eax
f010690d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f010690f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f0106912:	fc                   	cld    
f0106913:	f3 ab                	rep stos %eax,%es:(%edi)
f0106915:	eb 06                	jmp    f010691d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0106917:	8b 45 0c             	mov    0xc(%ebp),%eax
f010691a:	fc                   	cld    
f010691b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f010691d:	89 f8                	mov    %edi,%eax
f010691f:	5b                   	pop    %ebx
f0106920:	5e                   	pop    %esi
f0106921:	5f                   	pop    %edi
f0106922:	5d                   	pop    %ebp
f0106923:	c3                   	ret    

f0106924 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0106924:	55                   	push   %ebp
f0106925:	89 e5                	mov    %esp,%ebp
f0106927:	57                   	push   %edi
f0106928:	56                   	push   %esi
f0106929:	8b 45 08             	mov    0x8(%ebp),%eax
f010692c:	8b 75 0c             	mov    0xc(%ebp),%esi
f010692f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106932:	39 c6                	cmp    %eax,%esi
f0106934:	73 35                	jae    f010696b <memmove+0x47>
f0106936:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106939:	39 d0                	cmp    %edx,%eax
f010693b:	73 2e                	jae    f010696b <memmove+0x47>
		s += n;
		d += n;
f010693d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f0106940:	89 d6                	mov    %edx,%esi
f0106942:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106944:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010694a:	75 13                	jne    f010695f <memmove+0x3b>
f010694c:	f6 c1 03             	test   $0x3,%cl
f010694f:	75 0e                	jne    f010695f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106951:	83 ef 04             	sub    $0x4,%edi
f0106954:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106957:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f010695a:	fd                   	std    
f010695b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010695d:	eb 09                	jmp    f0106968 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f010695f:	83 ef 01             	sub    $0x1,%edi
f0106962:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0106965:	fd                   	std    
f0106966:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106968:	fc                   	cld    
f0106969:	eb 1d                	jmp    f0106988 <memmove+0x64>
f010696b:	89 f2                	mov    %esi,%edx
f010696d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010696f:	f6 c2 03             	test   $0x3,%dl
f0106972:	75 0f                	jne    f0106983 <memmove+0x5f>
f0106974:	f6 c1 03             	test   $0x3,%cl
f0106977:	75 0a                	jne    f0106983 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0106979:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f010697c:	89 c7                	mov    %eax,%edi
f010697e:	fc                   	cld    
f010697f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106981:	eb 05                	jmp    f0106988 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0106983:	89 c7                	mov    %eax,%edi
f0106985:	fc                   	cld    
f0106986:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106988:	5e                   	pop    %esi
f0106989:	5f                   	pop    %edi
f010698a:	5d                   	pop    %ebp
f010698b:	c3                   	ret    

f010698c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010698c:	55                   	push   %ebp
f010698d:	89 e5                	mov    %esp,%ebp
f010698f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106992:	8b 45 10             	mov    0x10(%ebp),%eax
f0106995:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106999:	8b 45 0c             	mov    0xc(%ebp),%eax
f010699c:	89 44 24 04          	mov    %eax,0x4(%esp)
f01069a0:	8b 45 08             	mov    0x8(%ebp),%eax
f01069a3:	89 04 24             	mov    %eax,(%esp)
f01069a6:	e8 79 ff ff ff       	call   f0106924 <memmove>
}
f01069ab:	c9                   	leave  
f01069ac:	c3                   	ret    

f01069ad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01069ad:	55                   	push   %ebp
f01069ae:	89 e5                	mov    %esp,%ebp
f01069b0:	56                   	push   %esi
f01069b1:	53                   	push   %ebx
f01069b2:	8b 55 08             	mov    0x8(%ebp),%edx
f01069b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01069b8:	89 d6                	mov    %edx,%esi
f01069ba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01069bd:	eb 1a                	jmp    f01069d9 <memcmp+0x2c>
		if (*s1 != *s2)
f01069bf:	0f b6 02             	movzbl (%edx),%eax
f01069c2:	0f b6 19             	movzbl (%ecx),%ebx
f01069c5:	38 d8                	cmp    %bl,%al
f01069c7:	74 0a                	je     f01069d3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
f01069c9:	0f b6 c0             	movzbl %al,%eax
f01069cc:	0f b6 db             	movzbl %bl,%ebx
f01069cf:	29 d8                	sub    %ebx,%eax
f01069d1:	eb 0f                	jmp    f01069e2 <memcmp+0x35>
		s1++, s2++;
f01069d3:	83 c2 01             	add    $0x1,%edx
f01069d6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01069d9:	39 f2                	cmp    %esi,%edx
f01069db:	75 e2                	jne    f01069bf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f01069dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01069e2:	5b                   	pop    %ebx
f01069e3:	5e                   	pop    %esi
f01069e4:	5d                   	pop    %ebp
f01069e5:	c3                   	ret    

f01069e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01069e6:	55                   	push   %ebp
f01069e7:	89 e5                	mov    %esp,%ebp
f01069e9:	8b 45 08             	mov    0x8(%ebp),%eax
f01069ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01069ef:	89 c2                	mov    %eax,%edx
f01069f1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01069f4:	eb 07                	jmp    f01069fd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
f01069f6:	38 08                	cmp    %cl,(%eax)
f01069f8:	74 07                	je     f0106a01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f01069fa:	83 c0 01             	add    $0x1,%eax
f01069fd:	39 d0                	cmp    %edx,%eax
f01069ff:	72 f5                	jb     f01069f6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0106a01:	5d                   	pop    %ebp
f0106a02:	c3                   	ret    

f0106a03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0106a03:	55                   	push   %ebp
f0106a04:	89 e5                	mov    %esp,%ebp
f0106a06:	57                   	push   %edi
f0106a07:	56                   	push   %esi
f0106a08:	53                   	push   %ebx
f0106a09:	8b 55 08             	mov    0x8(%ebp),%edx
f0106a0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106a0f:	eb 03                	jmp    f0106a14 <strtol+0x11>
		s++;
f0106a11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106a14:	0f b6 0a             	movzbl (%edx),%ecx
f0106a17:	80 f9 09             	cmp    $0x9,%cl
f0106a1a:	74 f5                	je     f0106a11 <strtol+0xe>
f0106a1c:	80 f9 20             	cmp    $0x20,%cl
f0106a1f:	74 f0                	je     f0106a11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
f0106a21:	80 f9 2b             	cmp    $0x2b,%cl
f0106a24:	75 0a                	jne    f0106a30 <strtol+0x2d>
		s++;
f0106a26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0106a29:	bf 00 00 00 00       	mov    $0x0,%edi
f0106a2e:	eb 11                	jmp    f0106a41 <strtol+0x3e>
f0106a30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f0106a35:	80 f9 2d             	cmp    $0x2d,%cl
f0106a38:	75 07                	jne    f0106a41 <strtol+0x3e>
		s++, neg = 1;
f0106a3a:	8d 52 01             	lea    0x1(%edx),%edx
f0106a3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106a41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
f0106a46:	75 15                	jne    f0106a5d <strtol+0x5a>
f0106a48:	80 3a 30             	cmpb   $0x30,(%edx)
f0106a4b:	75 10                	jne    f0106a5d <strtol+0x5a>
f0106a4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0106a51:	75 0a                	jne    f0106a5d <strtol+0x5a>
		s += 2, base = 16;
f0106a53:	83 c2 02             	add    $0x2,%edx
f0106a56:	b8 10 00 00 00       	mov    $0x10,%eax
f0106a5b:	eb 10                	jmp    f0106a6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
f0106a5d:	85 c0                	test   %eax,%eax
f0106a5f:	75 0c                	jne    f0106a6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0106a61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0106a63:	80 3a 30             	cmpb   $0x30,(%edx)
f0106a66:	75 05                	jne    f0106a6d <strtol+0x6a>
		s++, base = 8;
f0106a68:	83 c2 01             	add    $0x1,%edx
f0106a6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
f0106a6d:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106a72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0106a75:	0f b6 0a             	movzbl (%edx),%ecx
f0106a78:	8d 71 d0             	lea    -0x30(%ecx),%esi
f0106a7b:	89 f0                	mov    %esi,%eax
f0106a7d:	3c 09                	cmp    $0x9,%al
f0106a7f:	77 08                	ja     f0106a89 <strtol+0x86>
			dig = *s - '0';
f0106a81:	0f be c9             	movsbl %cl,%ecx
f0106a84:	83 e9 30             	sub    $0x30,%ecx
f0106a87:	eb 20                	jmp    f0106aa9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
f0106a89:	8d 71 9f             	lea    -0x61(%ecx),%esi
f0106a8c:	89 f0                	mov    %esi,%eax
f0106a8e:	3c 19                	cmp    $0x19,%al
f0106a90:	77 08                	ja     f0106a9a <strtol+0x97>
			dig = *s - 'a' + 10;
f0106a92:	0f be c9             	movsbl %cl,%ecx
f0106a95:	83 e9 57             	sub    $0x57,%ecx
f0106a98:	eb 0f                	jmp    f0106aa9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
f0106a9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
f0106a9d:	89 f0                	mov    %esi,%eax
f0106a9f:	3c 19                	cmp    $0x19,%al
f0106aa1:	77 16                	ja     f0106ab9 <strtol+0xb6>
			dig = *s - 'A' + 10;
f0106aa3:	0f be c9             	movsbl %cl,%ecx
f0106aa6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0106aa9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
f0106aac:	7d 0f                	jge    f0106abd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
f0106aae:	83 c2 01             	add    $0x1,%edx
f0106ab1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
f0106ab5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
f0106ab7:	eb bc                	jmp    f0106a75 <strtol+0x72>
f0106ab9:	89 d8                	mov    %ebx,%eax
f0106abb:	eb 02                	jmp    f0106abf <strtol+0xbc>
f0106abd:	89 d8                	mov    %ebx,%eax

	if (endptr)
f0106abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106ac3:	74 05                	je     f0106aca <strtol+0xc7>
		*endptr = (char *) s;
f0106ac5:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106ac8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f0106aca:	f7 d8                	neg    %eax
f0106acc:	85 ff                	test   %edi,%edi
f0106ace:	0f 44 c3             	cmove  %ebx,%eax
}
f0106ad1:	5b                   	pop    %ebx
f0106ad2:	5e                   	pop    %esi
f0106ad3:	5f                   	pop    %edi
f0106ad4:	5d                   	pop    %ebp
f0106ad5:	c3                   	ret    
f0106ad6:	66 90                	xchg   %ax,%ax

f0106ad8 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106ad8:	fa                   	cli    

	xorw    %ax, %ax
f0106ad9:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0106adb:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106add:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106adf:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106ae1:	0f 01 16             	lgdtl  (%esi)
f0106ae4:	74 70                	je     f0106b56 <mpentry_end+0x4>
	movl    %cr0, %eax
f0106ae6:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0106ae9:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106aed:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106af0:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0106af6:	08 00                	or     %al,(%eax)

f0106af8 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0106af8:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0106afc:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106afe:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106b00:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0106b02:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0106b06:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0106b08:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0106b0a:	b8 00 40 12 00       	mov    $0x124000,%eax
	movl    %eax, %cr3
f0106b0f:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0106b12:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0106b15:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0106b1a:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106b1d:	8b 25 90 4e 2c f0    	mov    0xf02c4e90,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106b23:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0106b28:	b8 1a 02 10 f0       	mov    $0xf010021a,%eax
	call    *%eax
f0106b2d:	ff d0                	call   *%eax

f0106b2f <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106b2f:	eb fe                	jmp    f0106b2f <spin>
f0106b31:	8d 76 00             	lea    0x0(%esi),%esi

f0106b34 <gdt>:
	...
f0106b3c:	ff                   	(bad)  
f0106b3d:	ff 00                	incl   (%eax)
f0106b3f:	00 00                	add    %al,(%eax)
f0106b41:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0106b48:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0106b4c <gdtdesc>:
f0106b4c:	17                   	pop    %ss
f0106b4d:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0106b52 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106b52:	90                   	nop
f0106b53:	66 90                	xchg   %ax,%ax
f0106b55:	66 90                	xchg   %ax,%ax
f0106b57:	66 90                	xchg   %ax,%ax
f0106b59:	66 90                	xchg   %ax,%ax
f0106b5b:	66 90                	xchg   %ax,%ax
f0106b5d:	66 90                	xchg   %ax,%ax
f0106b5f:	90                   	nop

f0106b60 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106b60:	55                   	push   %ebp
f0106b61:	89 e5                	mov    %esp,%ebp
f0106b63:	56                   	push   %esi
f0106b64:	53                   	push   %ebx
f0106b65:	83 ec 10             	sub    $0x10,%esp
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106b68:	8b 0d 94 4e 2c f0    	mov    0xf02c4e94,%ecx
f0106b6e:	89 c3                	mov    %eax,%ebx
f0106b70:	c1 eb 0c             	shr    $0xc,%ebx
f0106b73:	39 cb                	cmp    %ecx,%ebx
f0106b75:	72 20                	jb     f0106b97 <mpsearch1+0x37>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106b7b:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0106b82:	f0 
f0106b83:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f0106b8a:	00 
f0106b8b:	c7 04 24 f1 a0 10 f0 	movl   $0xf010a0f1,(%esp)
f0106b92:	e8 a9 94 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0106b97:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106b9d:	01 d0                	add    %edx,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106b9f:	89 c2                	mov    %eax,%edx
f0106ba1:	c1 ea 0c             	shr    $0xc,%edx
f0106ba4:	39 d1                	cmp    %edx,%ecx
f0106ba6:	77 20                	ja     f0106bc8 <mpsearch1+0x68>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106ba8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106bac:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0106bb3:	f0 
f0106bb4:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f0106bbb:	00 
f0106bbc:	c7 04 24 f1 a0 10 f0 	movl   $0xf010a0f1,(%esp)
f0106bc3:	e8 78 94 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0106bc8:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi

	for (; mp < end; mp++)
f0106bce:	eb 36                	jmp    f0106c06 <mpsearch1+0xa6>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106bd0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0106bd7:	00 
f0106bd8:	c7 44 24 04 01 a1 10 	movl   $0xf010a101,0x4(%esp)
f0106bdf:	f0 
f0106be0:	89 1c 24             	mov    %ebx,(%esp)
f0106be3:	e8 c5 fd ff ff       	call   f01069ad <memcmp>
f0106be8:	85 c0                	test   %eax,%eax
f0106bea:	75 17                	jne    f0106c03 <mpsearch1+0xa3>
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106bec:	ba 00 00 00 00       	mov    $0x0,%edx
		sum += ((uint8_t *)addr)[i];
f0106bf1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106bf5:	01 c8                	add    %ecx,%eax
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106bf7:	83 c2 01             	add    $0x1,%edx
f0106bfa:	83 fa 10             	cmp    $0x10,%edx
f0106bfd:	75 f2                	jne    f0106bf1 <mpsearch1+0x91>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106bff:	84 c0                	test   %al,%al
f0106c01:	74 0e                	je     f0106c11 <mpsearch1+0xb1>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f0106c03:	83 c3 10             	add    $0x10,%ebx
f0106c06:	39 f3                	cmp    %esi,%ebx
f0106c08:	72 c6                	jb     f0106bd0 <mpsearch1+0x70>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0106c0a:	b8 00 00 00 00       	mov    $0x0,%eax
f0106c0f:	eb 02                	jmp    f0106c13 <mpsearch1+0xb3>
f0106c11:	89 d8                	mov    %ebx,%eax
}
f0106c13:	83 c4 10             	add    $0x10,%esp
f0106c16:	5b                   	pop    %ebx
f0106c17:	5e                   	pop    %esi
f0106c18:	5d                   	pop    %ebp
f0106c19:	c3                   	ret    

f0106c1a <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106c1a:	55                   	push   %ebp
f0106c1b:	89 e5                	mov    %esp,%ebp
f0106c1d:	57                   	push   %edi
f0106c1e:	56                   	push   %esi
f0106c1f:	53                   	push   %ebx
f0106c20:	83 ec 2c             	sub    $0x2c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0106c23:	c7 05 c0 53 2c f0 20 	movl   $0xf02c5020,0xf02c53c0
f0106c2a:	50 2c f0 
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106c2d:	83 3d 94 4e 2c f0 00 	cmpl   $0x0,0xf02c4e94
f0106c34:	75 24                	jne    f0106c5a <mp_init+0x40>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106c36:	c7 44 24 0c 00 04 00 	movl   $0x400,0xc(%esp)
f0106c3d:	00 
f0106c3e:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0106c45:	f0 
f0106c46:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
f0106c4d:	00 
f0106c4e:	c7 04 24 f1 a0 10 f0 	movl   $0xf010a0f1,(%esp)
f0106c55:	e8 e6 93 ff ff       	call   f0100040 <_panic>
	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106c5a:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0106c61:	85 c0                	test   %eax,%eax
f0106c63:	74 16                	je     f0106c7b <mp_init+0x61>
		p <<= 4;	// Translate from segment to PA
f0106c65:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106c68:	ba 00 04 00 00       	mov    $0x400,%edx
f0106c6d:	e8 ee fe ff ff       	call   f0106b60 <mpsearch1>
f0106c72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106c75:	85 c0                	test   %eax,%eax
f0106c77:	75 3c                	jne    f0106cb5 <mp_init+0x9b>
f0106c79:	eb 20                	jmp    f0106c9b <mp_init+0x81>
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0106c7b:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0106c82:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0106c85:	2d 00 04 00 00       	sub    $0x400,%eax
f0106c8a:	ba 00 04 00 00       	mov    $0x400,%edx
f0106c8f:	e8 cc fe ff ff       	call   f0106b60 <mpsearch1>
f0106c94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106c97:	85 c0                	test   %eax,%eax
f0106c99:	75 1a                	jne    f0106cb5 <mp_init+0x9b>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f0106c9b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106ca0:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106ca5:	e8 b6 fe ff ff       	call   f0106b60 <mpsearch1>
f0106caa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f0106cad:	85 c0                	test   %eax,%eax
f0106caf:	0f 84 54 02 00 00    	je     f0106f09 <mp_init+0x2ef>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f0106cb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106cb8:	8b 70 04             	mov    0x4(%eax),%esi
f0106cbb:	85 f6                	test   %esi,%esi
f0106cbd:	74 06                	je     f0106cc5 <mp_init+0xab>
f0106cbf:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106cc3:	74 11                	je     f0106cd6 <mp_init+0xbc>
		cprintf("SMP: Default configurations not implemented\n");
f0106cc5:	c7 04 24 64 9f 10 f0 	movl   $0xf0109f64,(%esp)
f0106ccc:	e8 05 d6 ff ff       	call   f01042d6 <cprintf>
f0106cd1:	e9 33 02 00 00       	jmp    f0106f09 <mp_init+0x2ef>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106cd6:	89 f0                	mov    %esi,%eax
f0106cd8:	c1 e8 0c             	shr    $0xc,%eax
f0106cdb:	3b 05 94 4e 2c f0    	cmp    0xf02c4e94,%eax
f0106ce1:	72 20                	jb     f0106d03 <mp_init+0xe9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106ce3:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106ce7:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0106cee:	f0 
f0106cef:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
f0106cf6:	00 
f0106cf7:	c7 04 24 f1 a0 10 f0 	movl   $0xf010a0f1,(%esp)
f0106cfe:	e8 3d 93 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0106d03:	8d 9e 00 00 00 f0    	lea    -0x10000000(%esi),%ebx
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106d09:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0106d10:	00 
f0106d11:	c7 44 24 04 06 a1 10 	movl   $0xf010a106,0x4(%esp)
f0106d18:	f0 
f0106d19:	89 1c 24             	mov    %ebx,(%esp)
f0106d1c:	e8 8c fc ff ff       	call   f01069ad <memcmp>
f0106d21:	85 c0                	test   %eax,%eax
f0106d23:	74 11                	je     f0106d36 <mp_init+0x11c>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106d25:	c7 04 24 94 9f 10 f0 	movl   $0xf0109f94,(%esp)
f0106d2c:	e8 a5 d5 ff ff       	call   f01042d6 <cprintf>
f0106d31:	e9 d3 01 00 00       	jmp    f0106f09 <mp_init+0x2ef>
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0106d36:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
f0106d3a:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
f0106d3e:	0f b7 f8             	movzwl %ax,%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0106d41:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f0106d46:	b8 00 00 00 00       	mov    $0x0,%eax
f0106d4b:	eb 0d                	jmp    f0106d5a <mp_init+0x140>
		sum += ((uint8_t *)addr)[i];
f0106d4d:	0f b6 8c 30 00 00 00 	movzbl -0x10000000(%eax,%esi,1),%ecx
f0106d54:	f0 
f0106d55:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106d57:	83 c0 01             	add    $0x1,%eax
f0106d5a:	39 c7                	cmp    %eax,%edi
f0106d5c:	7f ef                	jg     f0106d4d <mp_init+0x133>
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
		cprintf("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0106d5e:	84 d2                	test   %dl,%dl
f0106d60:	74 11                	je     f0106d73 <mp_init+0x159>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106d62:	c7 04 24 c8 9f 10 f0 	movl   $0xf0109fc8,(%esp)
f0106d69:	e8 68 d5 ff ff       	call   f01042d6 <cprintf>
f0106d6e:	e9 96 01 00 00       	jmp    f0106f09 <mp_init+0x2ef>
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f0106d73:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
f0106d77:	3c 04                	cmp    $0x4,%al
f0106d79:	74 1f                	je     f0106d9a <mp_init+0x180>
f0106d7b:	3c 01                	cmp    $0x1,%al
f0106d7d:	8d 76 00             	lea    0x0(%esi),%esi
f0106d80:	74 18                	je     f0106d9a <mp_init+0x180>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106d82:	0f b6 c0             	movzbl %al,%eax
f0106d85:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d89:	c7 04 24 ec 9f 10 f0 	movl   $0xf0109fec,(%esp)
f0106d90:	e8 41 d5 ff ff       	call   f01042d6 <cprintf>
f0106d95:	e9 6f 01 00 00       	jmp    f0106f09 <mp_init+0x2ef>
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106d9a:	0f b7 73 28          	movzwl 0x28(%ebx),%esi
f0106d9e:	0f b7 7d e2          	movzwl -0x1e(%ebp),%edi
f0106da2:	01 df                	add    %ebx,%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0106da4:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f0106da9:	b8 00 00 00 00       	mov    $0x0,%eax
f0106dae:	eb 09                	jmp    f0106db9 <mp_init+0x19f>
		sum += ((uint8_t *)addr)[i];
f0106db0:	0f b6 0c 07          	movzbl (%edi,%eax,1),%ecx
f0106db4:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106db6:	83 c0 01             	add    $0x1,%eax
f0106db9:	39 c6                	cmp    %eax,%esi
f0106dbb:	7f f3                	jg     f0106db0 <mp_init+0x196>
	}
	if (conf->version != 1 && conf->version != 4) {
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106dbd:	02 53 2a             	add    0x2a(%ebx),%dl
f0106dc0:	84 d2                	test   %dl,%dl
f0106dc2:	74 11                	je     f0106dd5 <mp_init+0x1bb>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106dc4:	c7 04 24 0c a0 10 f0 	movl   $0xf010a00c,(%esp)
f0106dcb:	e8 06 d5 ff ff       	call   f01042d6 <cprintf>
f0106dd0:	e9 34 01 00 00       	jmp    f0106f09 <mp_init+0x2ef>
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
f0106dd5:	85 db                	test   %ebx,%ebx
f0106dd7:	0f 84 2c 01 00 00    	je     f0106f09 <mp_init+0x2ef>
		return;
	ismp = 1;
f0106ddd:	c7 05 00 50 2c f0 01 	movl   $0x1,0xf02c5000
f0106de4:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106de7:	8b 43 24             	mov    0x24(%ebx),%eax
f0106dea:	a3 00 60 30 f0       	mov    %eax,0xf0306000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106def:	8d 7b 2c             	lea    0x2c(%ebx),%edi
f0106df2:	be 00 00 00 00       	mov    $0x0,%esi
f0106df7:	e9 86 00 00 00       	jmp    f0106e82 <mp_init+0x268>
		switch (*p) {
f0106dfc:	0f b6 07             	movzbl (%edi),%eax
f0106dff:	84 c0                	test   %al,%al
f0106e01:	74 06                	je     f0106e09 <mp_init+0x1ef>
f0106e03:	3c 04                	cmp    $0x4,%al
f0106e05:	77 57                	ja     f0106e5e <mp_init+0x244>
f0106e07:	eb 50                	jmp    f0106e59 <mp_init+0x23f>
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106e09:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106e0d:	8d 76 00             	lea    0x0(%esi),%esi
f0106e10:	74 11                	je     f0106e23 <mp_init+0x209>
				bootcpu = &cpus[ncpu];
f0106e12:	6b 05 c4 53 2c f0 74 	imul   $0x74,0xf02c53c4,%eax
f0106e19:	05 20 50 2c f0       	add    $0xf02c5020,%eax
f0106e1e:	a3 c0 53 2c f0       	mov    %eax,0xf02c53c0
			if (ncpu < NCPU) {
f0106e23:	a1 c4 53 2c f0       	mov    0xf02c53c4,%eax
f0106e28:	83 f8 07             	cmp    $0x7,%eax
f0106e2b:	7f 13                	jg     f0106e40 <mp_init+0x226>
				cpus[ncpu].cpu_id = ncpu;
f0106e2d:	6b d0 74             	imul   $0x74,%eax,%edx
f0106e30:	88 82 20 50 2c f0    	mov    %al,-0xfd3afe0(%edx)
				ncpu++;
f0106e36:	83 c0 01             	add    $0x1,%eax
f0106e39:	a3 c4 53 2c f0       	mov    %eax,0xf02c53c4
f0106e3e:	eb 14                	jmp    f0106e54 <mp_init+0x23a>
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106e40:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106e44:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106e48:	c7 04 24 3c a0 10 f0 	movl   $0xf010a03c,(%esp)
f0106e4f:	e8 82 d4 ff ff       	call   f01042d6 <cprintf>
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106e54:	83 c7 14             	add    $0x14,%edi
			continue;
f0106e57:	eb 26                	jmp    f0106e7f <mp_init+0x265>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106e59:	83 c7 08             	add    $0x8,%edi
			continue;
f0106e5c:	eb 21                	jmp    f0106e7f <mp_init+0x265>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106e5e:	0f b6 c0             	movzbl %al,%eax
f0106e61:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106e65:	c7 04 24 64 a0 10 f0 	movl   $0xf010a064,(%esp)
f0106e6c:	e8 65 d4 ff ff       	call   f01042d6 <cprintf>
			ismp = 0;
f0106e71:	c7 05 00 50 2c f0 00 	movl   $0x0,0xf02c5000
f0106e78:	00 00 00 
			i = conf->entry;
f0106e7b:	0f b7 73 22          	movzwl 0x22(%ebx),%esi
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106e7f:	83 c6 01             	add    $0x1,%esi
f0106e82:	0f b7 43 22          	movzwl 0x22(%ebx),%eax
f0106e86:	39 c6                	cmp    %eax,%esi
f0106e88:	0f 82 6e ff ff ff    	jb     f0106dfc <mp_init+0x1e2>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106e8e:	a1 c0 53 2c f0       	mov    0xf02c53c0,%eax
f0106e93:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106e9a:	83 3d 00 50 2c f0 00 	cmpl   $0x0,0xf02c5000
f0106ea1:	75 22                	jne    f0106ec5 <mp_init+0x2ab>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0106ea3:	c7 05 c4 53 2c f0 01 	movl   $0x1,0xf02c53c4
f0106eaa:	00 00 00 
		lapicaddr = 0;
f0106ead:	c7 05 00 60 30 f0 00 	movl   $0x0,0xf0306000
f0106eb4:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106eb7:	c7 04 24 84 a0 10 f0 	movl   $0xf010a084,(%esp)
f0106ebe:	e8 13 d4 ff ff       	call   f01042d6 <cprintf>
		return;
f0106ec3:	eb 44                	jmp    f0106f09 <mp_init+0x2ef>
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106ec5:	8b 15 c4 53 2c f0    	mov    0xf02c53c4,%edx
f0106ecb:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106ecf:	0f b6 00             	movzbl (%eax),%eax
f0106ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106ed6:	c7 04 24 0b a1 10 f0 	movl   $0xf010a10b,(%esp)
f0106edd:	e8 f4 d3 ff ff       	call   f01042d6 <cprintf>

	if (mp->imcrp) {
f0106ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106ee5:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106ee9:	74 1e                	je     f0106f09 <mp_init+0x2ef>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106eeb:	c7 04 24 b0 a0 10 f0 	movl   $0xf010a0b0,(%esp)
f0106ef2:	e8 df d3 ff ff       	call   f01042d6 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106ef7:	ba 22 00 00 00       	mov    $0x22,%edx
f0106efc:	b8 70 00 00 00       	mov    $0x70,%eax
f0106f01:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106f02:	b2 23                	mov    $0x23,%dl
f0106f04:	ec                   	in     (%dx),%al
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106f05:	83 c8 01             	or     $0x1,%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106f08:	ee                   	out    %al,(%dx)
	}
}
f0106f09:	83 c4 2c             	add    $0x2c,%esp
f0106f0c:	5b                   	pop    %ebx
f0106f0d:	5e                   	pop    %esi
f0106f0e:	5f                   	pop    %edi
f0106f0f:	5d                   	pop    %ebp
f0106f10:	c3                   	ret    

f0106f11 <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f0106f11:	55                   	push   %ebp
f0106f12:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f0106f14:	8b 0d 04 60 30 f0    	mov    0xf0306004,%ecx
f0106f1a:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106f1d:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106f1f:	a1 04 60 30 f0       	mov    0xf0306004,%eax
f0106f24:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106f27:	5d                   	pop    %ebp
f0106f28:	c3                   	ret    

f0106f29 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0106f29:	55                   	push   %ebp
f0106f2a:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0106f2c:	a1 04 60 30 f0       	mov    0xf0306004,%eax
f0106f31:	85 c0                	test   %eax,%eax
f0106f33:	74 08                	je     f0106f3d <cpunum+0x14>
		return lapic[ID] >> 24;
f0106f35:	8b 40 20             	mov    0x20(%eax),%eax
f0106f38:	c1 e8 18             	shr    $0x18,%eax
f0106f3b:	eb 05                	jmp    f0106f42 <cpunum+0x19>
	return 0;
f0106f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106f42:	5d                   	pop    %ebp
f0106f43:	c3                   	ret    

f0106f44 <lapic_init>:
}

void
lapic_init(void)
{
	if (!lapicaddr)
f0106f44:	a1 00 60 30 f0       	mov    0xf0306000,%eax
f0106f49:	85 c0                	test   %eax,%eax
f0106f4b:	0f 84 23 01 00 00    	je     f0107074 <lapic_init+0x130>
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f0106f51:	55                   	push   %ebp
f0106f52:	89 e5                	mov    %esp,%ebp
f0106f54:	83 ec 18             	sub    $0x18,%esp
	if (!lapicaddr)
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	lapic = mmio_map_region(lapicaddr, 4096);
f0106f57:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0106f5e:	00 
f0106f5f:	89 04 24             	mov    %eax,(%esp)
f0106f62:	e8 c3 a8 ff ff       	call   f010182a <mmio_map_region>
f0106f67:	a3 04 60 30 f0       	mov    %eax,0xf0306004

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106f6c:	ba 27 01 00 00       	mov    $0x127,%edx
f0106f71:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106f76:	e8 96 ff ff ff       	call   f0106f11 <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f0106f7b:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106f80:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106f85:	e8 87 ff ff ff       	call   f0106f11 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106f8a:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106f8f:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106f94:	e8 78 ff ff ff       	call   f0106f11 <lapicw>
	lapicw(TICR, 10000000); 
f0106f99:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106f9e:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106fa3:	e8 69 ff ff ff       	call   f0106f11 <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
f0106fa8:	e8 7c ff ff ff       	call   f0106f29 <cpunum>
f0106fad:	6b c0 74             	imul   $0x74,%eax,%eax
f0106fb0:	05 20 50 2c f0       	add    $0xf02c5020,%eax
f0106fb5:	39 05 c0 53 2c f0    	cmp    %eax,0xf02c53c0
f0106fbb:	74 0f                	je     f0106fcc <lapic_init+0x88>
		lapicw(LINT0, MASKED);
f0106fbd:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106fc2:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106fc7:	e8 45 ff ff ff       	call   f0106f11 <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);
f0106fcc:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106fd1:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106fd6:	e8 36 ff ff ff       	call   f0106f11 <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106fdb:	a1 04 60 30 f0       	mov    0xf0306004,%eax
f0106fe0:	8b 40 30             	mov    0x30(%eax),%eax
f0106fe3:	c1 e8 10             	shr    $0x10,%eax
f0106fe6:	3c 03                	cmp    $0x3,%al
f0106fe8:	76 0f                	jbe    f0106ff9 <lapic_init+0xb5>
		lapicw(PCINT, MASKED);
f0106fea:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106fef:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106ff4:	e8 18 ff ff ff       	call   f0106f11 <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106ff9:	ba 33 00 00 00       	mov    $0x33,%edx
f0106ffe:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0107003:	e8 09 ff ff ff       	call   f0106f11 <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f0107008:	ba 00 00 00 00       	mov    $0x0,%edx
f010700d:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0107012:	e8 fa fe ff ff       	call   f0106f11 <lapicw>
	lapicw(ESR, 0);
f0107017:	ba 00 00 00 00       	mov    $0x0,%edx
f010701c:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0107021:	e8 eb fe ff ff       	call   f0106f11 <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f0107026:	ba 00 00 00 00       	mov    $0x0,%edx
f010702b:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0107030:	e8 dc fe ff ff       	call   f0106f11 <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f0107035:	ba 00 00 00 00       	mov    $0x0,%edx
f010703a:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010703f:	e8 cd fe ff ff       	call   f0106f11 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0107044:	ba 00 85 08 00       	mov    $0x88500,%edx
f0107049:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010704e:	e8 be fe ff ff       	call   f0106f11 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0107053:	8b 15 04 60 30 f0    	mov    0xf0306004,%edx
f0107059:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010705f:	f6 c4 10             	test   $0x10,%ah
f0107062:	75 f5                	jne    f0107059 <lapic_init+0x115>
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f0107064:	ba 00 00 00 00       	mov    $0x0,%edx
f0107069:	b8 20 00 00 00       	mov    $0x20,%eax
f010706e:	e8 9e fe ff ff       	call   f0106f11 <lapicw>
}
f0107073:	c9                   	leave  
f0107074:	f3 c3                	repz ret 

f0107076 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0107076:	83 3d 04 60 30 f0 00 	cmpl   $0x0,0xf0306004
f010707d:	74 13                	je     f0107092 <lapic_eoi+0x1c>
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f010707f:	55                   	push   %ebp
f0107080:	89 e5                	mov    %esp,%ebp
	if (lapic)
		lapicw(EOI, 0);
f0107082:	ba 00 00 00 00       	mov    $0x0,%edx
f0107087:	b8 2c 00 00 00       	mov    $0x2c,%eax
f010708c:	e8 80 fe ff ff       	call   f0106f11 <lapicw>
}
f0107091:	5d                   	pop    %ebp
f0107092:	f3 c3                	repz ret 

f0107094 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0107094:	55                   	push   %ebp
f0107095:	89 e5                	mov    %esp,%ebp
f0107097:	56                   	push   %esi
f0107098:	53                   	push   %ebx
f0107099:	83 ec 10             	sub    $0x10,%esp
f010709c:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010709f:	8b 75 0c             	mov    0xc(%ebp),%esi
f01070a2:	ba 70 00 00 00       	mov    $0x70,%edx
f01070a7:	b8 0f 00 00 00       	mov    $0xf,%eax
f01070ac:	ee                   	out    %al,(%dx)
f01070ad:	b2 71                	mov    $0x71,%dl
f01070af:	b8 0a 00 00 00       	mov    $0xa,%eax
f01070b4:	ee                   	out    %al,(%dx)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01070b5:	83 3d 94 4e 2c f0 00 	cmpl   $0x0,0xf02c4e94
f01070bc:	75 24                	jne    f01070e2 <lapic_startap+0x4e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01070be:	c7 44 24 0c 67 04 00 	movl   $0x467,0xc(%esp)
f01070c5:	00 
f01070c6:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f01070cd:	f0 
f01070ce:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
f01070d5:	00 
f01070d6:	c7 04 24 28 a1 10 f0 	movl   $0xf010a128,(%esp)
f01070dd:	e8 5e 8f ff ff       	call   f0100040 <_panic>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f01070e2:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f01070e9:	00 00 
	wrv[1] = addr >> 4;
f01070eb:	89 f0                	mov    %esi,%eax
f01070ed:	c1 e8 04             	shr    $0x4,%eax
f01070f0:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f01070f6:	c1 e3 18             	shl    $0x18,%ebx
f01070f9:	89 da                	mov    %ebx,%edx
f01070fb:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107100:	e8 0c fe ff ff       	call   f0106f11 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0107105:	ba 00 c5 00 00       	mov    $0xc500,%edx
f010710a:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010710f:	e8 fd fd ff ff       	call   f0106f11 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0107114:	ba 00 85 00 00       	mov    $0x8500,%edx
f0107119:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010711e:	e8 ee fd ff ff       	call   f0106f11 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107123:	c1 ee 0c             	shr    $0xc,%esi
f0107126:	81 ce 00 06 00 00    	or     $0x600,%esi
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f010712c:	89 da                	mov    %ebx,%edx
f010712e:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107133:	e8 d9 fd ff ff       	call   f0106f11 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107138:	89 f2                	mov    %esi,%edx
f010713a:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010713f:	e8 cd fd ff ff       	call   f0106f11 <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0107144:	89 da                	mov    %ebx,%edx
f0107146:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010714b:	e8 c1 fd ff ff       	call   f0106f11 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107150:	89 f2                	mov    %esi,%edx
f0107152:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107157:	e8 b5 fd ff ff       	call   f0106f11 <lapicw>
		microdelay(200);
	}
}
f010715c:	83 c4 10             	add    $0x10,%esp
f010715f:	5b                   	pop    %ebx
f0107160:	5e                   	pop    %esi
f0107161:	5d                   	pop    %ebp
f0107162:	c3                   	ret    

f0107163 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0107163:	55                   	push   %ebp
f0107164:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0107166:	8b 55 08             	mov    0x8(%ebp),%edx
f0107169:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f010716f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107174:	e8 98 fd ff ff       	call   f0106f11 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0107179:	8b 15 04 60 30 f0    	mov    0xf0306004,%edx
f010717f:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0107185:	f6 c4 10             	test   $0x10,%ah
f0107188:	75 f5                	jne    f010717f <lapic_ipi+0x1c>
		;
}
f010718a:	5d                   	pop    %ebp
f010718b:	c3                   	ret    

f010718c <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f010718c:	55                   	push   %ebp
f010718d:	89 e5                	mov    %esp,%ebp
f010718f:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0107192:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0107198:	8b 55 0c             	mov    0xc(%ebp),%edx
f010719b:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010719e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f01071a5:	5d                   	pop    %ebp
f01071a6:	c3                   	ret    

f01071a7 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f01071a7:	55                   	push   %ebp
f01071a8:	89 e5                	mov    %esp,%ebp
f01071aa:	56                   	push   %esi
f01071ab:	53                   	push   %ebx
f01071ac:	83 ec 20             	sub    $0x20,%esp
f01071af:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f01071b2:	83 3b 00             	cmpl   $0x0,(%ebx)
f01071b5:	75 07                	jne    f01071be <spin_lock+0x17>
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f01071b7:	ba 01 00 00 00       	mov    $0x1,%edx
f01071bc:	eb 42                	jmp    f0107200 <spin_lock+0x59>
f01071be:	8b 73 08             	mov    0x8(%ebx),%esi
f01071c1:	e8 63 fd ff ff       	call   f0106f29 <cpunum>
f01071c6:	6b c0 74             	imul   $0x74,%eax,%eax
f01071c9:	05 20 50 2c f0       	add    $0xf02c5020,%eax
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f01071ce:	39 c6                	cmp    %eax,%esi
f01071d0:	75 e5                	jne    f01071b7 <spin_lock+0x10>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f01071d2:	8b 5b 04             	mov    0x4(%ebx),%ebx
f01071d5:	e8 4f fd ff ff       	call   f0106f29 <cpunum>
f01071da:	89 5c 24 10          	mov    %ebx,0x10(%esp)
f01071de:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01071e2:	c7 44 24 08 38 a1 10 	movl   $0xf010a138,0x8(%esp)
f01071e9:	f0 
f01071ea:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
f01071f1:	00 
f01071f2:	c7 04 24 9a a1 10 f0 	movl   $0xf010a19a,(%esp)
f01071f9:	e8 42 8e ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f01071fe:	f3 90                	pause  
f0107200:	89 d0                	mov    %edx,%eax
f0107202:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0107205:	85 c0                	test   %eax,%eax
f0107207:	75 f5                	jne    f01071fe <spin_lock+0x57>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0107209:	e8 1b fd ff ff       	call   f0106f29 <cpunum>
f010720e:	6b c0 74             	imul   $0x74,%eax,%eax
f0107211:	05 20 50 2c f0       	add    $0xf02c5020,%eax
f0107216:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0107219:	83 c3 0c             	add    $0xc,%ebx
get_caller_pcs(uint32_t pcs[])
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
f010721c:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f010721e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0107223:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0107229:	76 12                	jbe    f010723d <spin_lock+0x96>
			break;
		pcs[i] = ebp[1];          // saved %eip
f010722b:	8b 4a 04             	mov    0x4(%edx),%ecx
f010722e:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0107231:	8b 12                	mov    (%edx),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0107233:	83 c0 01             	add    $0x1,%eax
f0107236:	83 f8 0a             	cmp    $0xa,%eax
f0107239:	75 e8                	jne    f0107223 <spin_lock+0x7c>
f010723b:	eb 0f                	jmp    f010724c <spin_lock+0xa5>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f010723d:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0107244:	83 c0 01             	add    $0x1,%eax
f0107247:	83 f8 09             	cmp    $0x9,%eax
f010724a:	7e f1                	jle    f010723d <spin_lock+0x96>
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}
f010724c:	83 c4 20             	add    $0x20,%esp
f010724f:	5b                   	pop    %ebx
f0107250:	5e                   	pop    %esi
f0107251:	5d                   	pop    %ebp
f0107252:	c3                   	ret    

f0107253 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0107253:	55                   	push   %ebp
f0107254:	89 e5                	mov    %esp,%ebp
f0107256:	57                   	push   %edi
f0107257:	56                   	push   %esi
f0107258:	53                   	push   %ebx
f0107259:	83 ec 6c             	sub    $0x6c,%esp
f010725c:	8b 75 08             	mov    0x8(%ebp),%esi

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f010725f:	83 3e 00             	cmpl   $0x0,(%esi)
f0107262:	74 18                	je     f010727c <spin_unlock+0x29>
f0107264:	8b 5e 08             	mov    0x8(%esi),%ebx
f0107267:	e8 bd fc ff ff       	call   f0106f29 <cpunum>
f010726c:	6b c0 74             	imul   $0x74,%eax,%eax
f010726f:	05 20 50 2c f0       	add    $0xf02c5020,%eax
// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f0107274:	39 c3                	cmp    %eax,%ebx
f0107276:	0f 84 ce 00 00 00    	je     f010734a <spin_unlock+0xf7>
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f010727c:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
f0107283:	00 
f0107284:	8d 46 0c             	lea    0xc(%esi),%eax
f0107287:	89 44 24 04          	mov    %eax,0x4(%esp)
f010728b:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f010728e:	89 1c 24             	mov    %ebx,(%esp)
f0107291:	e8 8e f6 ff ff       	call   f0106924 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0107296:	8b 46 08             	mov    0x8(%esi),%eax
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0107299:	0f b6 38             	movzbl (%eax),%edi
f010729c:	8b 76 04             	mov    0x4(%esi),%esi
f010729f:	e8 85 fc ff ff       	call   f0106f29 <cpunum>
f01072a4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01072a8:	89 74 24 08          	mov    %esi,0x8(%esp)
f01072ac:	89 44 24 04          	mov    %eax,0x4(%esp)
f01072b0:	c7 04 24 64 a1 10 f0 	movl   $0xf010a164,(%esp)
f01072b7:	e8 1a d0 ff ff       	call   f01042d6 <cprintf>
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01072bc:	8d 7d a8             	lea    -0x58(%ebp),%edi
f01072bf:	eb 65                	jmp    f0107326 <spin_unlock+0xd3>
f01072c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01072c5:	89 04 24             	mov    %eax,(%esp)
f01072c8:	e8 73 e9 ff ff       	call   f0105c40 <debuginfo_eip>
f01072cd:	85 c0                	test   %eax,%eax
f01072cf:	78 39                	js     f010730a <spin_unlock+0xb7>
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
f01072d1:	8b 06                	mov    (%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01072d3:	89 c2                	mov    %eax,%edx
f01072d5:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01072d8:	89 54 24 18          	mov    %edx,0x18(%esp)
f01072dc:	8b 55 b0             	mov    -0x50(%ebp),%edx
f01072df:	89 54 24 14          	mov    %edx,0x14(%esp)
f01072e3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
f01072e6:	89 54 24 10          	mov    %edx,0x10(%esp)
f01072ea:	8b 55 ac             	mov    -0x54(%ebp),%edx
f01072ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01072f1:	8b 55 a8             	mov    -0x58(%ebp),%edx
f01072f4:	89 54 24 08          	mov    %edx,0x8(%esp)
f01072f8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01072fc:	c7 04 24 aa a1 10 f0 	movl   $0xf010a1aa,(%esp)
f0107303:	e8 ce cf ff ff       	call   f01042d6 <cprintf>
f0107308:	eb 12                	jmp    f010731c <spin_unlock+0xc9>
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
f010730a:	8b 06                	mov    (%esi),%eax
f010730c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107310:	c7 04 24 c1 a1 10 f0 	movl   $0xf010a1c1,(%esp)
f0107317:	e8 ba cf ff ff       	call   f01042d6 <cprintf>
f010731c:	83 c3 04             	add    $0x4,%ebx
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f010731f:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0107322:	39 c3                	cmp    %eax,%ebx
f0107324:	74 08                	je     f010732e <spin_unlock+0xdb>
f0107326:	89 de                	mov    %ebx,%esi
f0107328:	8b 03                	mov    (%ebx),%eax
f010732a:	85 c0                	test   %eax,%eax
f010732c:	75 93                	jne    f01072c1 <spin_unlock+0x6e>
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
f010732e:	c7 44 24 08 c9 a1 10 	movl   $0xf010a1c9,0x8(%esp)
f0107335:	f0 
f0107336:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f010733d:	00 
f010733e:	c7 04 24 9a a1 10 f0 	movl   $0xf010a19a,(%esp)
f0107345:	e8 f6 8c ff ff       	call   f0100040 <_panic>
	}

	lk->pcs[0] = 0;
f010734a:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0107351:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
f0107358:	b8 00 00 00 00       	mov    $0x0,%eax
f010735d:	f0 87 06             	lock xchg %eax,(%esi)
	// Paper says that Intel 64 and IA-32 will not move a load
	// after a store. So lock->locked = 0 would work here.
	// The xchg being asm volatile ensures gcc emits it after
	// the above assignments (and after the critical section).
	xchg(&lk->locked, 0);
}
f0107360:	83 c4 6c             	add    $0x6c,%esp
f0107363:	5b                   	pop    %ebx
f0107364:	5e                   	pop    %esi
f0107365:	5f                   	pop    %edi
f0107366:	5d                   	pop    %ebp
f0107367:	c3                   	ret    

f0107368 <nicw>:



// Helper func to access and set NIC registers
static void
nicw(int index, int value) {
f0107368:	55                   	push   %ebp
f0107369:	89 e5                	mov    %esp,%ebp
	nic[index/4] = value;
f010736b:	8d 48 03             	lea    0x3(%eax),%ecx
f010736e:	85 c0                	test   %eax,%eax
f0107370:	0f 49 c8             	cmovns %eax,%ecx
f0107373:	83 e1 fc             	and    $0xfffffffc,%ecx
f0107376:	03 0d a0 e3 31 f0    	add    0xf031e3a0,%ecx
f010737c:	89 11                	mov    %edx,(%ecx)
	nic[index];  // wait for write to finish, by reading
f010737e:	8b 15 a0 e3 31 f0    	mov    0xf031e3a0,%edx
f0107384:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0107387:	8b 00                	mov    (%eax),%eax
}
f0107389:	5d                   	pop    %ebp
f010738a:	c3                   	ret    

f010738b <nic_get_reg>:

// Another helper func that returns NIC register's value
uint32_t
nic_get_reg(int index) {
f010738b:	55                   	push   %ebp
f010738c:	89 e5                	mov    %esp,%ebp
f010738e:	8b 45 08             	mov    0x8(%ebp),%eax
	return nic[index/4];
f0107391:	8d 50 03             	lea    0x3(%eax),%edx
f0107394:	85 c0                	test   %eax,%eax
f0107396:	0f 48 c2             	cmovs  %edx,%eax
f0107399:	83 e0 fc             	and    $0xfffffffc,%eax
f010739c:	03 05 a0 e3 31 f0    	add    0xf031e3a0,%eax
f01073a2:	8b 00                	mov    (%eax),%eax
}
f01073a4:	5d                   	pop    %ebp
f01073a5:	c3                   	ret    

f01073a6 <read_EEPROM_addr>:
// The following 2 functions were implemented due to 
// read MAC address from EEPROM challenge.
// This function reads addr from EEPROM, and 
// returns it.
uint32_t
read_EEPROM_addr(uint16_t addr) {
f01073a6:	55                   	push   %ebp
f01073a7:	89 e5                	mov    %esp,%ebp
	addr = addr << 8;
f01073a9:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
f01073ad:	c1 e2 08             	shl    $0x8,%edx
	uint16_t read_addr = E1000_EERC_ADDR & addr;
	nicw(E1000_EERD, E1000_EERD | E1000_EERC_START | read_addr);
f01073b0:	83 ca 15             	or     $0x15,%edx
f01073b3:	0f b7 d2             	movzwl %dx,%edx
f01073b6:	b8 14 00 00 00       	mov    $0x14,%eax
f01073bb:	e8 a8 ff ff ff       	call   f0107368 <nicw>
}

// Another helper func that returns NIC register's value
uint32_t
nic_get_reg(int index) {
	return nic[index/4];
f01073c0:	8b 15 a0 e3 31 f0    	mov    0xf031e3a0,%edx
f01073c6:	8b 42 14             	mov    0x14(%edx),%eax
uint32_t
read_EEPROM_addr(uint16_t addr) {
	addr = addr << 8;
	uint16_t read_addr = E1000_EERC_ADDR & addr;
	nicw(E1000_EERD, E1000_EERD | E1000_EERC_START | read_addr);
	while (!(nic_get_reg(E1000_EERD) & E1000_EERC_DONE));
f01073c9:	a8 10                	test   $0x10,%al
f01073cb:	74 f9                	je     f01073c6 <read_EEPROM_addr+0x20>
}

// Another helper func that returns NIC register's value
uint32_t
nic_get_reg(int index) {
	return nic[index/4];
f01073cd:	8b 42 14             	mov    0x14(%edx),%eax
read_EEPROM_addr(uint16_t addr) {
	addr = addr << 8;
	uint16_t read_addr = E1000_EERC_ADDR & addr;
	nicw(E1000_EERD, E1000_EERD | E1000_EERC_START | read_addr);
	while (!(nic_get_reg(E1000_EERD) & E1000_EERC_DONE));
	return (nic_get_reg(E1000_EERD) & E1000_EERC_DATA);
f01073d0:	66 b8 00 00          	mov    $0x0,%ax
}
f01073d4:	5d                   	pop    %ebp
f01073d5:	c3                   	ret    

f01073d6 <get_MAC_from_EEPROM>:

// This function receives pointers to two parameters,
// and writes into them the MAC address read from EEPROM.
void
get_MAC_from_EEPROM(uint32_t* low, uint32_t* high) {
f01073d6:	55                   	push   %ebp
f01073d7:	89 e5                	mov    %esp,%ebp
f01073d9:	53                   	push   %ebx
f01073da:	83 ec 04             	sub    $0x4,%esp
	uint32_t mac_low = read_EEPROM_addr(0);
f01073dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01073e4:	e8 bd ff ff ff       	call   f01073a6 <read_EEPROM_addr>
	mac_low = mac_low >> 16;
f01073e9:	c1 e8 10             	shr    $0x10,%eax
f01073ec:	89 c3                	mov    %eax,%ebx
	mac_low += read_EEPROM_addr(0x1);
f01073ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01073f5:	e8 ac ff ff ff       	call   f01073a6 <read_EEPROM_addr>
f01073fa:	01 c3                	add    %eax,%ebx
	uint32_t mac_high = read_EEPROM_addr(0x2);
f01073fc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
f0107403:	e8 9e ff ff ff       	call   f01073a6 <read_EEPROM_addr>
	mac_high = mac_high >> 16;
	*low = mac_low;
f0107408:	8b 55 08             	mov    0x8(%ebp),%edx
f010740b:	89 1a                	mov    %ebx,(%edx)
get_MAC_from_EEPROM(uint32_t* low, uint32_t* high) {
	uint32_t mac_low = read_EEPROM_addr(0);
	mac_low = mac_low >> 16;
	mac_low += read_EEPROM_addr(0x1);
	uint32_t mac_high = read_EEPROM_addr(0x2);
	mac_high = mac_high >> 16;
f010740d:	c1 e8 10             	shr    $0x10,%eax
f0107410:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107413:	89 02                	mov    %eax,(%edx)
	*low = mac_low;
	*high = mac_high;
}
f0107415:	83 c4 04             	add    $0x4,%esp
f0107418:	5b                   	pop    %ebx
f0107419:	5d                   	pop    %ebp
f010741a:	c3                   	ret    

f010741b <Tx_init>:
}

// Initializes memory, registers, transmit ring queue and transmit
// buffs array for transmit operation.
void
Tx_init() {
f010741b:	55                   	push   %ebp
f010741c:	89 e5                	mov    %esp,%ebp
f010741e:	53                   	push   %ebx
f010741f:	83 ec 14             	sub    $0x14,%esp
	memset(tx_desc_queue, 0, NUM_TX_DESC * sizeof(struct e1000_tx_desc));
f0107422:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
f0107429:	00 
f010742a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107431:	00 
f0107432:	c7 04 24 b0 e3 31 f0 	movl   $0xf031e3b0,(%esp)
f0107439:	e8 99 f4 ff ff       	call   f01068d7 <memset>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010743e:	b8 b0 e3 31 f0       	mov    $0xf031e3b0,%eax
f0107443:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0107448:	77 20                	ja     f010746a <Tx_init+0x4f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010744a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010744e:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f0107455:	f0 
f0107456:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
f010745d:	00 
f010745e:	c7 04 24 e1 a1 10 f0 	movl   $0xf010a1e1,(%esp)
f0107465:	e8 d6 8b ff ff       	call   f0100040 <_panic>

	nicw(E1000_TDBAL, PADDR(tx_desc_queue));
f010746a:	ba b0 e3 31 00       	mov    $0x31e3b0,%edx
f010746f:	b8 00 38 00 00       	mov    $0x3800,%eax
f0107474:	e8 ef fe ff ff       	call   f0107368 <nicw>
	nicw(E1000_TDBAH, 0);
f0107479:	ba 00 00 00 00       	mov    $0x0,%edx
f010747e:	b8 04 38 00 00       	mov    $0x3804,%eax
f0107483:	e8 e0 fe ff ff       	call   f0107368 <nicw>
	nicw(E1000_TDLEN, NUM_TX_DESC * sizeof(struct e1000_tx_desc));
f0107488:	ba 00 04 00 00       	mov    $0x400,%edx
f010748d:	b8 08 38 00 00       	mov    $0x3808,%eax
f0107492:	e8 d1 fe ff ff       	call   f0107368 <nicw>
	nicw(E1000_TDH, 0);
f0107497:	ba 00 00 00 00       	mov    $0x0,%edx
f010749c:	b8 10 38 00 00       	mov    $0x3810,%eax
f01074a1:	e8 c2 fe ff ff       	call   f0107368 <nicw>
	nicw(E1000_TDT, 0);
f01074a6:	ba 00 00 00 00       	mov    $0x0,%edx
f01074ab:	b8 18 38 00 00       	mov    $0x3818,%eax
f01074b0:	e8 b3 fe ff ff       	call   f0107368 <nicw>

	nicw(E1000_TCTL, E1000_TCTL | E1000_TCTL_EN | E1000_TCTL_PSP | (E1000_TCTL_CT & ( 0x10 << 4)) | (E1000_TCTL_COLD & ( 0x40 << 12)));
f01074b5:	ba 0a 05 04 00       	mov    $0x4050a,%edx
f01074ba:	b8 00 04 00 00       	mov    $0x400,%eax
f01074bf:	e8 a4 fe ff ff       	call   f0107368 <nicw>
	nicw(E1000_TIPG, (10 + (4 << 10) + (6 << 20)));
f01074c4:	ba 0a 10 60 00       	mov    $0x60100a,%edx
f01074c9:	b8 10 04 00 00       	mov    $0x410,%eax
f01074ce:	e8 95 fe ff ff       	call   f0107368 <nicw>
f01074d3:	ba 20 60 30 f0       	mov    $0xf0306020,%edx
f01074d8:	b8 bb e3 31 f0       	mov    $0xf031e3bb,%eax
f01074dd:	bb a0 db 31 f0       	mov    $0xf031dba0,%ebx

	int i;
	for(i = 0; i < NUM_TX_DESC; i++) {
		tx_desc_queue[i].cmd |= E1000_TXD_CMD_RS;
		tx_desc_queue[i].cmd |= E1000_TXD_CMD_EOP;
f01074e2:	80 08 09             	orb    $0x9,(%eax)

		// Mark DD = 1, meaning descriptor is free
		tx_desc_queue[i].status |= E1000_TXD_STAT_DD;			
f01074e5:	80 48 01 01          	orb    $0x1,0x1(%eax)
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01074e9:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01074ef:	77 20                	ja     f0107511 <Tx_init+0xf6>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01074f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01074f5:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f01074fc:	f0 
f01074fd:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
f0107504:	00 
f0107505:	c7 04 24 e1 a1 10 f0 	movl   $0xf010a1e1,(%esp)
f010750c:	e8 2f 8b ff ff       	call   f0100040 <_panic>
f0107511:	8d 8a 00 00 00 10    	lea    0x10000000(%edx),%ecx
		tx_desc_queue[i].buffer_addr = PADDR(&tx_buf_array[i]);
f0107517:	89 48 f5             	mov    %ecx,-0xb(%eax)
f010751a:	c7 40 f9 00 00 00 00 	movl   $0x0,-0x7(%eax)
f0107521:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f0107527:	83 c0 10             	add    $0x10,%eax

	nicw(E1000_TCTL, E1000_TCTL | E1000_TCTL_EN | E1000_TCTL_PSP | (E1000_TCTL_CT & ( 0x10 << 4)) | (E1000_TCTL_COLD & ( 0x40 << 12)));
	nicw(E1000_TIPG, (10 + (4 << 10) + (6 << 20)));

	int i;
	for(i = 0; i < NUM_TX_DESC; i++) {
f010752a:	39 da                	cmp    %ebx,%edx
f010752c:	75 b4                	jne    f01074e2 <Tx_init+0xc7>

		// Mark DD = 1, meaning descriptor is free
		tx_desc_queue[i].status |= E1000_TXD_STAT_DD;			
		tx_desc_queue[i].buffer_addr = PADDR(&tx_buf_array[i]);
	}
}
f010752e:	83 c4 14             	add    $0x14,%esp
f0107531:	5b                   	pop    %ebx
f0107532:	5d                   	pop    %ebp
f0107533:	c3                   	ret    

f0107534 <Rx_init>:


// Initializes memory, registers, receive ring queue and receive
// buffs array for receive operation.
void
Rx_init() {
f0107534:	55                   	push   %ebp
f0107535:	89 e5                	mov    %esp,%ebp
f0107537:	53                   	push   %ebx
f0107538:	83 ec 24             	sub    $0x24,%esp
	memset(rx_desc_queue, 0, NUM_RX_DESC * sizeof(struct e1000_rx_desc));
f010753b:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
f0107542:	00 
f0107543:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010754a:	00 
f010754b:	c7 04 24 a0 db 31 f0 	movl   $0xf031dba0,(%esp)
f0107552:	e8 80 f3 ff ff       	call   f01068d7 <memset>

	uint32_t mac_low = 0, mac_high = 0;
f0107557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f010755e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	get_MAC_from_EEPROM(&mac_low, &mac_high);
f0107565:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0107568:	89 44 24 04          	mov    %eax,0x4(%esp)
f010756c:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010756f:	89 04 24             	mov    %eax,(%esp)
f0107572:	e8 5f fe ff ff       	call   f01073d6 <get_MAC_from_EEPROM>

	nicw(E1000_RAL, mac_low);
f0107577:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010757a:	b8 00 54 00 00       	mov    $0x5400,%eax
f010757f:	e8 e4 fd ff ff       	call   f0107368 <nicw>
}

// Another helper func that returns NIC register's value
uint32_t
nic_get_reg(int index) {
	return nic[index/4];
f0107584:	a1 a0 e3 31 f0       	mov    0xf031e3a0,%eax
f0107589:	8b 90 04 54 00 00    	mov    0x5404(%eax),%edx

	uint32_t mac_low = 0, mac_high = 0;
	get_MAC_from_EEPROM(&mac_low, &mac_high);

	nicw(E1000_RAL, mac_low);
	nicw(E1000_RAH, (nic_get_reg(E1000_RAH) & mac_high) | E1000_RAH_AV);
f010758f:	23 55 f0             	and    -0x10(%ebp),%edx
f0107592:	81 ca 00 00 00 80    	or     $0x80000000,%edx
f0107598:	b8 04 54 00 00       	mov    $0x5404,%eax
f010759d:	e8 c6 fd ff ff       	call   f0107368 <nicw>

	nicw(E1000_MTA, 0);
f01075a2:	ba 00 00 00 00       	mov    $0x0,%edx
f01075a7:	b8 00 52 00 00       	mov    $0x5200,%eax
f01075ac:	e8 b7 fd ff ff       	call   f0107368 <nicw>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01075b1:	b8 a0 db 31 f0       	mov    $0xf031dba0,%eax
f01075b6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01075bb:	77 20                	ja     f01075dd <Rx_init+0xa9>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01075bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01075c1:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f01075c8:	f0 
f01075c9:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
f01075d0:	00 
f01075d1:	c7 04 24 e1 a1 10 f0 	movl   $0xf010a1e1,(%esp)
f01075d8:	e8 63 8a ff ff       	call   f0100040 <_panic>

	nicw(E1000_RDBAL,  PADDR(rx_desc_queue));
f01075dd:	ba a0 db 31 00       	mov    $0x31dba0,%edx
f01075e2:	b8 00 28 00 00       	mov    $0x2800,%eax
f01075e7:	e8 7c fd ff ff       	call   f0107368 <nicw>
	nicw(E1000_RDBAH, 0);
f01075ec:	ba 00 00 00 00       	mov    $0x0,%edx
f01075f1:	b8 04 28 00 00       	mov    $0x2804,%eax
f01075f6:	e8 6d fd ff ff       	call   f0107368 <nicw>
	nicw(E1000_RDLEN, NUM_RX_DESC * sizeof(struct e1000_rx_desc));
f01075fb:	ba 00 08 00 00       	mov    $0x800,%edx
f0107600:	b8 08 28 00 00       	mov    $0x2808,%eax
f0107605:	e8 5e fd ff ff       	call   f0107368 <nicw>
	nicw(E1000_RDH, 0);
f010760a:	ba 00 00 00 00       	mov    $0x0,%edx
f010760f:	b8 10 28 00 00       	mov    $0x2810,%eax
f0107614:	e8 4f fd ff ff       	call   f0107368 <nicw>
	nicw(E1000_RDT, NUM_RX_DESC-1);
f0107619:	ba 7f 00 00 00       	mov    $0x7f,%edx
f010761e:	b8 18 28 00 00       	mov    $0x2818,%eax
f0107623:	e8 40 fd ff ff       	call   f0107368 <nicw>
f0107628:	b8 c0 e7 31 f0       	mov    $0xf031e7c0,%eax
f010762d:	ba ac db 31 f0       	mov    $0xf031dbac,%edx
f0107632:	bb c0 e7 35 f0       	mov    $0xf035e7c0,%ebx

	int i;
	for(i = 0; i < NUM_RX_DESC; i++) {
		// Mark DD = 0, meaning no packet written to descriptor
		rx_desc_queue[i].status &= ~E1000_RXD_STAT_DD;
f0107637:	80 22 fe             	andb   $0xfe,(%edx)
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010763a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010763f:	77 20                	ja     f0107661 <Rx_init+0x12d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107641:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107645:	c7 44 24 08 a8 81 10 	movl   $0xf01081a8,0x8(%esp)
f010764c:	f0 
f010764d:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
f0107654:	00 
f0107655:	c7 04 24 e1 a1 10 f0 	movl   $0xf010a1e1,(%esp)
f010765c:	e8 df 89 ff ff       	call   f0100040 <_panic>
f0107661:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx
		rx_desc_queue[i].buffer_addr = PADDR(&rx_buf_array[i]);
f0107667:	89 4a f4             	mov    %ecx,-0xc(%edx)
f010766a:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
f0107671:	05 00 08 00 00       	add    $0x800,%eax
f0107676:	83 c2 10             	add    $0x10,%edx
	nicw(E1000_RDLEN, NUM_RX_DESC * sizeof(struct e1000_rx_desc));
	nicw(E1000_RDH, 0);
	nicw(E1000_RDT, NUM_RX_DESC-1);

	int i;
	for(i = 0; i < NUM_RX_DESC; i++) {
f0107679:	39 d8                	cmp    %ebx,%eax
f010767b:	75 ba                	jne    f0107637 <Rx_init+0x103>
		// Mark DD = 0, meaning no packet written to descriptor
		rx_desc_queue[i].status &= ~E1000_RXD_STAT_DD;
		rx_desc_queue[i].buffer_addr = PADDR(&rx_buf_array[i]);
	}

	nicw(E1000_RCTL, 0);
f010767d:	ba 00 00 00 00       	mov    $0x0,%edx
f0107682:	b8 00 01 00 00       	mov    $0x100,%eax
f0107687:	e8 dc fc ff ff       	call   f0107368 <nicw>
	nicw(E1000_RCTL, E1000_RCTL | E1000_RCTL_EN | E1000_RCTL_BAM | E1000_RCTL_SECRC | E1000_RCTL_LBM_NO | E1000_RCTL_SZ_2048);
f010768c:	ba 02 81 00 04       	mov    $0x4008102,%edx
f0107691:	b8 00 01 00 00       	mov    $0x100,%eax
f0107696:	e8 cd fc ff ff       	call   f0107368 <nicw>
}
f010769b:	83 c4 24             	add    $0x24,%esp
f010769e:	5b                   	pop    %ebx
f010769f:	5d                   	pop    %ebp
f01076a0:	c3                   	ret    

f01076a1 <e1000_attachfn>:
	*low = mac_low;
	*high = mac_high;
}

int
e1000_attachfn(struct pci_func *pcif) {
f01076a1:	55                   	push   %ebp
f01076a2:	89 e5                	mov    %esp,%ebp
f01076a4:	53                   	push   %ebx
f01076a5:	83 ec 14             	sub    $0x14,%esp
f01076a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pci_func_enable(pcif);
f01076ab:	89 1c 24             	mov    %ebx,(%esp)
f01076ae:	e8 2d 06 00 00       	call   f0107ce0 <pci_func_enable>
	if (!((physaddr_t)pcif->reg_base[0]))
f01076b3:	8b 43 14             	mov    0x14(%ebx),%eax
f01076b6:	85 c0                	test   %eax,%eax
f01076b8:	74 57                	je     f0107711 <e1000_attachfn+0x70>
		return -1;

	nic = mmio_map_region((physaddr_t)pcif->reg_base[0], pcif->reg_size[0]);
f01076ba:	8b 53 2c             	mov    0x2c(%ebx),%edx
f01076bd:	89 54 24 04          	mov    %edx,0x4(%esp)
f01076c1:	89 04 24             	mov    %eax,(%esp)
f01076c4:	e8 61 a1 ff ff       	call   f010182a <mmio_map_region>
f01076c9:	a3 a0 e3 31 f0       	mov    %eax,0xf031e3a0
	nicw(E1000_IMS, E1000_IMS | E1000_ICR_TXDW | E1000_ICR_RXT0);
f01076ce:	ba d1 00 00 00       	mov    $0xd1,%edx
f01076d3:	b8 d0 00 00 00       	mov    $0xd0,%eax
f01076d8:	e8 8b fc ff ff       	call   f0107368 <nicw>
	nicw(E1000_RDTR, 0);
f01076dd:	ba 00 00 00 00       	mov    $0x0,%edx
f01076e2:	b8 20 28 00 00       	mov    $0x2820,%eax
f01076e7:	e8 7c fc ff ff       	call   f0107368 <nicw>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<11));
f01076ec:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f01076f3:	25 ff f7 00 00       	and    $0xf7ff,%eax
f01076f8:	89 04 24             	mov    %eax,(%esp)
f01076fb:	e8 84 ca ff ff       	call   f0104184 <irq_setmask_8259A>

	Tx_init();
f0107700:	e8 16 fd ff ff       	call   f010741b <Tx_init>
	Rx_init();
f0107705:	e8 2a fe ff ff       	call   f0107534 <Rx_init>


	return 0;
f010770a:	b8 00 00 00 00       	mov    $0x0,%eax
f010770f:	eb 05                	jmp    f0107716 <e1000_attachfn+0x75>

int
e1000_attachfn(struct pci_func *pcif) {
	pci_func_enable(pcif);
	if (!((physaddr_t)pcif->reg_base[0]))
		return -1;
f0107711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	Tx_init();
	Rx_init();


	return 0;
}
f0107716:	83 c4 14             	add    $0x14,%esp
f0107719:	5b                   	pop    %ebx
f010771a:	5d                   	pop    %ebp
f010771b:	c3                   	ret    

f010771c <tx_packet>:
// Returns 0 on success.
// Possible errors:
// - if size argument is bigger then max allowed - return -E_PACKET_TOO_BIG
// - if ring desriptor queue is full - return -E_TX_FULL
int
tx_packet(char *buf, int size) {
f010771c:	55                   	push   %ebp
f010771d:	89 e5                	mov    %esp,%ebp
f010771f:	57                   	push   %edi
f0107720:	56                   	push   %esi
f0107721:	53                   	push   %ebx
f0107722:	83 ec 1c             	sub    $0x1c,%esp
f0107725:	8b 7d 08             	mov    0x8(%ebp),%edi
f0107728:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (size > MAX_TX_PACKET_SIZE) {
f010772b:	81 fe ee 05 00 00    	cmp    $0x5ee,%esi
f0107731:	0f 8f 99 00 00 00    	jg     f01077d0 <tx_packet+0xb4>
}

// Another helper func that returns NIC register's value
uint32_t
nic_get_reg(int index) {
	return nic[index/4];
f0107737:	a1 a0 e3 31 f0       	mov    0xf031e3a0,%eax
f010773c:	8b 98 18 38 00 00    	mov    0x3818(%eax),%ebx
	}

	uint32_t tail_index = nic_get_reg(E1000_TDT);

	// If DD = 0, then descriptor is not free. this means that tail = head index.
	if ((tx_desc_queue[tail_index].status & E1000_TXD_STAT_DD) == 0) {
f0107742:	89 d8                	mov    %ebx,%eax
f0107744:	c1 e0 04             	shl    $0x4,%eax
f0107747:	f6 80 bc e3 31 f0 01 	testb  $0x1,-0xfce1c44(%eax)
f010774e:	0f 84 83 00 00 00    	je     f01077d7 <tx_packet+0xbb>
	}

	//memcpy(&tx_buf_array[tail_index].buf, buf, size);
	// Because of Zero Copy challenge, the line above was replaced by the
	// following 4 lines.
	struct PageInfo* pg_buf = page_lookup(curenv->env_pgdir, buf, 0);
f0107754:	e8 d0 f7 ff ff       	call   f0106f29 <cpunum>
f0107759:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0107760:	00 
f0107761:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0107765:	6b c0 74             	imul   $0x74,%eax,%eax
f0107768:	8b 80 28 50 2c f0    	mov    -0xfd3afd8(%eax),%eax
f010776e:	8b 40 60             	mov    0x60(%eax),%eax
f0107771:	89 04 24             	mov    %eax,(%esp)
f0107774:	e8 3d 9f ff ff       	call   f01016b6 <page_lookup>
	if (pg_buf == NULL)
f0107779:	85 c0                	test   %eax,%eax
f010777b:	74 61                	je     f01077de <tx_packet+0xc2>
		return -E_FAULT;
	tx_desc_queue[tail_index].buffer_addr = page2pa(pg_buf) + PGOFF(buf);
f010777d:	89 d9                	mov    %ebx,%ecx
f010777f:	c1 e1 04             	shl    $0x4,%ecx
f0107782:	8d 91 b0 e3 31 f0    	lea    -0xfce1c50(%ecx),%edx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0107788:	2b 05 9c 4e 2c f0    	sub    0xf02c4e9c,%eax
f010778e:	c1 f8 03             	sar    $0x3,%eax
f0107791:	c1 e0 0c             	shl    $0xc,%eax
f0107794:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
f010779a:	01 c7                	add    %eax,%edi
f010779c:	89 b9 b0 e3 31 f0    	mov    %edi,-0xfce1c50(%ecx)
f01077a2:	c7 81 b4 e3 31 f0 00 	movl   $0x0,-0xfce1c4c(%ecx)
f01077a9:	00 00 00 
	

	tx_desc_queue[tail_index].length = size;
f01077ac:	66 89 b1 b8 e3 31 f0 	mov    %si,-0xfce1c48(%ecx)
	

	// Mark DD = 0, meaning descriptor is not free.
	tx_desc_queue[tail_index].status &= ~E1000_TXD_STAT_DD;
f01077b3:	80 62 0c fe          	andb   $0xfe,0xc(%edx)

	nicw(E1000_TDT, (tail_index + 1) % NUM_TX_DESC);
f01077b7:	83 c3 01             	add    $0x1,%ebx
f01077ba:	89 da                	mov    %ebx,%edx
f01077bc:	83 e2 3f             	and    $0x3f,%edx
f01077bf:	b8 18 38 00 00       	mov    $0x3818,%eax
f01077c4:	e8 9f fb ff ff       	call   f0107368 <nicw>
	return 0;
f01077c9:	b8 00 00 00 00       	mov    $0x0,%eax
f01077ce:	eb 13                	jmp    f01077e3 <tx_packet+0xc7>
// - if size argument is bigger then max allowed - return -E_PACKET_TOO_BIG
// - if ring desriptor queue is full - return -E_TX_FULL
int
tx_packet(char *buf, int size) {
	if (size > MAX_TX_PACKET_SIZE) {
		return -E_PACKET_TOO_BIG;
f01077d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
f01077d5:	eb 0c                	jmp    f01077e3 <tx_packet+0xc7>

	uint32_t tail_index = nic_get_reg(E1000_TDT);

	// If DD = 0, then descriptor is not free. this means that tail = head index.
	if ((tx_desc_queue[tail_index].status & E1000_TXD_STAT_DD) == 0) {
		return -E_TX_FULL;
f01077d7:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
f01077dc:	eb 05                	jmp    f01077e3 <tx_packet+0xc7>
	//memcpy(&tx_buf_array[tail_index].buf, buf, size);
	// Because of Zero Copy challenge, the line above was replaced by the
	// following 4 lines.
	struct PageInfo* pg_buf = page_lookup(curenv->env_pgdir, buf, 0);
	if (pg_buf == NULL)
		return -E_FAULT;
f01077de:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
	// Mark DD = 0, meaning descriptor is not free.
	tx_desc_queue[tail_index].status &= ~E1000_TXD_STAT_DD;

	nicw(E1000_TDT, (tail_index + 1) % NUM_TX_DESC);
	return 0;
}
f01077e3:	83 c4 1c             	add    $0x1c,%esp
f01077e6:	5b                   	pop    %ebx
f01077e7:	5e                   	pop    %esi
f01077e8:	5f                   	pop    %edi
f01077e9:	5d                   	pop    %ebp
f01077ea:	c3                   	ret    

f01077eb <rx_packet>:
// Returns the length of the packet written to buf on success.
// Possible errors:
// - if size argument is smaller then received packet size - return -E_PACKET_TOO_BIG
// - if ring desriptor queue is empty - return -E_RX_EMPTY
int
rx_packet(void *buf, uint32_t* size) {
f01077eb:	55                   	push   %ebp
f01077ec:	89 e5                	mov    %esp,%ebp
f01077ee:	56                   	push   %esi
f01077ef:	53                   	push   %ebx
f01077f0:	83 ec 10             	sub    $0x10,%esp
}

// Another helper func that returns NIC register's value
uint32_t
nic_get_reg(int index) {
	return nic[index/4];
f01077f3:	a1 a0 e3 31 f0       	mov    0xf031e3a0,%eax
f01077f8:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
// Possible errors:
// - if size argument is smaller then received packet size - return -E_PACKET_TOO_BIG
// - if ring desriptor queue is empty - return -E_RX_EMPTY
int
rx_packet(void *buf, uint32_t* size) {
	int tail_index = (nic_get_reg(E1000_RDT) + 1) % NUM_RX_DESC;
f01077fe:	83 c3 01             	add    $0x1,%ebx
f0107801:	83 e3 7f             	and    $0x7f,%ebx

	// If DD = 0, then descriptor doesnt contain packet. this means that tail = head index.
	if ((rx_desc_queue[tail_index].status & E1000_RXD_STAT_DD) == 0) {
f0107804:	89 d8                	mov    %ebx,%eax
f0107806:	c1 e0 04             	shl    $0x4,%eax
f0107809:	0f b6 80 ac db 31 f0 	movzbl -0xfce2454(%eax),%eax
f0107810:	83 e0 03             	and    $0x3,%eax
		return -E_RX_EMPTY;
	}

	if ((rx_desc_queue[tail_index].status & E1000_RXD_STAT_EOP) == 0) {
f0107813:	3c 03                	cmp    $0x3,%al
f0107815:	75 4b                	jne    f0107862 <rx_packet+0x77>
		return -E_RX_EMPTY;
	}

	int len = rx_desc_queue[tail_index].length;
f0107817:	89 de                	mov    %ebx,%esi
f0107819:	c1 e6 04             	shl    $0x4,%esi
	*size = len;
f010781c:	0f b7 86 a8 db 31 f0 	movzwl -0xfce2458(%esi),%eax

	if ((rx_desc_queue[tail_index].status & E1000_RXD_STAT_EOP) == 0) {
		return -E_RX_EMPTY;
	}

	int len = rx_desc_queue[tail_index].length;
f0107823:	81 c6 a0 db 31 f0    	add    $0xf031dba0,%esi
	*size = len;
f0107829:	8b 55 0c             	mov    0xc(%ebp),%edx
f010782c:	89 02                	mov    %eax,(%edx)
	memcpy(buf, rx_buf_array[tail_index].buf, len);
f010782e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107832:	89 d8                	mov    %ebx,%eax
f0107834:	c1 e0 0b             	shl    $0xb,%eax
f0107837:	05 c0 e7 31 f0       	add    $0xf031e7c0,%eax
f010783c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107840:	8b 45 08             	mov    0x8(%ebp),%eax
f0107843:	89 04 24             	mov    %eax,(%esp)
f0107846:	e8 41 f1 ff ff       	call   f010698c <memcpy>

	// Mark DD = 0, meaning no packet written to descriptor
	rx_desc_queue[tail_index].status &= ~E1000_RXD_STAT_DD;
f010784b:	80 66 0c fe          	andb   $0xfe,0xc(%esi)

	nicw(E1000_RDT, tail_index);
f010784f:	89 da                	mov    %ebx,%edx
f0107851:	b8 18 28 00 00       	mov    $0x2818,%eax
f0107856:	e8 0d fb ff ff       	call   f0107368 <nicw>
	return 0;
f010785b:	b8 00 00 00 00       	mov    $0x0,%eax
f0107860:	eb 05                	jmp    f0107867 <rx_packet+0x7c>
	if ((rx_desc_queue[tail_index].status & E1000_RXD_STAT_DD) == 0) {
		return -E_RX_EMPTY;
	}

	if ((rx_desc_queue[tail_index].status & E1000_RXD_STAT_EOP) == 0) {
		return -E_RX_EMPTY;
f0107862:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// Mark DD = 0, meaning no packet written to descriptor
	rx_desc_queue[tail_index].status &= ~E1000_RXD_STAT_DD;

	nicw(E1000_RDT, tail_index);
	return 0;
}
f0107867:	83 c4 10             	add    $0x10,%esp
f010786a:	5b                   	pop    %ebx
f010786b:	5e                   	pop    %esi
f010786c:	5d                   	pop    %ebp
f010786d:	c3                   	ret    

f010786e <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f010786e:	55                   	push   %ebp
f010786f:	89 e5                	mov    %esp,%ebp
f0107871:	57                   	push   %edi
f0107872:	56                   	push   %esi
f0107873:	53                   	push   %ebx
f0107874:	83 ec 2c             	sub    $0x2c,%esp
f0107877:	8b 7d 08             	mov    0x8(%ebp),%edi
f010787a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f010787d:	eb 41                	jmp    f01078c0 <pci_attach_match+0x52>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f010787f:	39 3b                	cmp    %edi,(%ebx)
f0107881:	75 3a                	jne    f01078bd <pci_attach_match+0x4f>
f0107883:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107886:	39 56 04             	cmp    %edx,0x4(%esi)
f0107889:	75 32                	jne    f01078bd <pci_attach_match+0x4f>
			int r = list[i].attachfn(pcif);
f010788b:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010788e:	89 0c 24             	mov    %ecx,(%esp)
f0107891:	ff d0                	call   *%eax
			if (r > 0)
f0107893:	85 c0                	test   %eax,%eax
f0107895:	7f 32                	jg     f01078c9 <pci_attach_match+0x5b>
				return r;
			if (r < 0)
f0107897:	85 c0                	test   %eax,%eax
f0107899:	79 22                	jns    f01078bd <pci_attach_match+0x4f>
				cprintf("pci_attach_match: attaching "
f010789b:	89 44 24 10          	mov    %eax,0x10(%esp)
f010789f:	8b 46 08             	mov    0x8(%esi),%eax
f01078a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01078a6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01078a9:	89 44 24 08          	mov    %eax,0x8(%esp)
f01078ad:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01078b1:	c7 04 24 f0 a1 10 f0 	movl   $0xf010a1f0,(%esp)
f01078b8:	e8 19 ca ff ff       	call   f01042d6 <cprintf>
f01078bd:	83 c3 0c             	add    $0xc,%ebx
f01078c0:	89 de                	mov    %ebx,%esi
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f01078c2:	8b 43 08             	mov    0x8(%ebx),%eax
f01078c5:	85 c0                	test   %eax,%eax
f01078c7:	75 b6                	jne    f010787f <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f01078c9:	83 c4 2c             	add    $0x2c,%esp
f01078cc:	5b                   	pop    %ebx
f01078cd:	5e                   	pop    %esi
f01078ce:	5f                   	pop    %edi
f01078cf:	5d                   	pop    %ebp
f01078d0:	c3                   	ret    

f01078d1 <pci_conf1_set_addr>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f01078d1:	55                   	push   %ebp
f01078d2:	89 e5                	mov    %esp,%ebp
f01078d4:	56                   	push   %esi
f01078d5:	53                   	push   %ebx
f01078d6:	83 ec 10             	sub    $0x10,%esp
f01078d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f01078dc:	3d ff 00 00 00       	cmp    $0xff,%eax
f01078e1:	76 24                	jbe    f0107907 <pci_conf1_set_addr+0x36>
f01078e3:	c7 44 24 0c 48 a3 10 	movl   $0xf010a348,0xc(%esp)
f01078ea:	f0 
f01078eb:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f01078f2:	f0 
f01078f3:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
f01078fa:	00 
f01078fb:	c7 04 24 52 a3 10 f0 	movl   $0xf010a352,(%esp)
f0107902:	e8 39 87 ff ff       	call   f0100040 <_panic>
	assert(dev < 32);
f0107907:	83 fa 1f             	cmp    $0x1f,%edx
f010790a:	76 24                	jbe    f0107930 <pci_conf1_set_addr+0x5f>
f010790c:	c7 44 24 0c 5d a3 10 	movl   $0xf010a35d,0xc(%esp)
f0107913:	f0 
f0107914:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f010791b:	f0 
f010791c:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
f0107923:	00 
f0107924:	c7 04 24 52 a3 10 f0 	movl   $0xf010a352,(%esp)
f010792b:	e8 10 87 ff ff       	call   f0100040 <_panic>
	assert(func < 8);
f0107930:	83 f9 07             	cmp    $0x7,%ecx
f0107933:	76 24                	jbe    f0107959 <pci_conf1_set_addr+0x88>
f0107935:	c7 44 24 0c 66 a3 10 	movl   $0xf010a366,0xc(%esp)
f010793c:	f0 
f010793d:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0107944:	f0 
f0107945:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
f010794c:	00 
f010794d:	c7 04 24 52 a3 10 f0 	movl   $0xf010a352,(%esp)
f0107954:	e8 e7 86 ff ff       	call   f0100040 <_panic>
	assert(offset < 256);
f0107959:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f010795f:	76 24                	jbe    f0107985 <pci_conf1_set_addr+0xb4>
f0107961:	c7 44 24 0c 6f a3 10 	movl   $0xf010a36f,0xc(%esp)
f0107968:	f0 
f0107969:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0107970:	f0 
f0107971:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
f0107978:	00 
f0107979:	c7 04 24 52 a3 10 f0 	movl   $0xf010a352,(%esp)
f0107980:	e8 bb 86 ff ff       	call   f0100040 <_panic>
	assert((offset & 0x3) == 0);
f0107985:	f6 c3 03             	test   $0x3,%bl
f0107988:	74 24                	je     f01079ae <pci_conf1_set_addr+0xdd>
f010798a:	c7 44 24 0c 7c a3 10 	movl   $0xf010a37c,0xc(%esp)
f0107991:	f0 
f0107992:	c7 44 24 08 e1 89 10 	movl   $0xf01089e1,0x8(%esp)
f0107999:	f0 
f010799a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
f01079a1:	00 
f01079a2:	c7 04 24 52 a3 10 f0 	movl   $0xf010a352,(%esp)
f01079a9:	e8 92 86 ff ff       	call   f0100040 <_panic>

	uint32_t v = (1 << 31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f01079ae:	81 cb 00 00 00 80    	or     $0x80000000,%ebx
f01079b4:	c1 e1 08             	shl    $0x8,%ecx
f01079b7:	09 cb                	or     %ecx,%ebx
f01079b9:	89 d6                	mov    %edx,%esi
f01079bb:	c1 e6 0b             	shl    $0xb,%esi
f01079be:	09 f3                	or     %esi,%ebx
f01079c0:	c1 e0 10             	shl    $0x10,%eax
f01079c3:	89 c6                	mov    %eax,%esi
	assert(dev < 32);
	assert(func < 8);
	assert(offset < 256);
	assert((offset & 0x3) == 0);

	uint32_t v = (1 << 31) |		// config-space
f01079c5:	89 d8                	mov    %ebx,%eax
f01079c7:	09 f0                	or     %esi,%eax
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01079c9:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f01079ce:	ef                   	out    %eax,(%dx)
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f01079cf:	83 c4 10             	add    $0x10,%esp
f01079d2:	5b                   	pop    %ebx
f01079d3:	5e                   	pop    %esi
f01079d4:	5d                   	pop    %ebp
f01079d5:	c3                   	ret    

f01079d6 <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f01079d6:	55                   	push   %ebp
f01079d7:	89 e5                	mov    %esp,%ebp
f01079d9:	53                   	push   %ebx
f01079da:	83 ec 14             	sub    $0x14,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01079dd:	8b 48 08             	mov    0x8(%eax),%ecx
f01079e0:	8b 58 04             	mov    0x4(%eax),%ebx
f01079e3:	8b 00                	mov    (%eax),%eax
f01079e5:	8b 40 04             	mov    0x4(%eax),%eax
f01079e8:	89 14 24             	mov    %edx,(%esp)
f01079eb:	89 da                	mov    %ebx,%edx
f01079ed:	e8 df fe ff ff       	call   f01078d1 <pci_conf1_set_addr>

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f01079f2:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f01079f7:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f01079f8:	83 c4 14             	add    $0x14,%esp
f01079fb:	5b                   	pop    %ebx
f01079fc:	5d                   	pop    %ebp
f01079fd:	c3                   	ret    

f01079fe <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f01079fe:	55                   	push   %ebp
f01079ff:	89 e5                	mov    %esp,%ebp
f0107a01:	57                   	push   %edi
f0107a02:	56                   	push   %esi
f0107a03:	53                   	push   %ebx
f0107a04:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
f0107a0a:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0107a0c:	c7 44 24 08 48 00 00 	movl   $0x48,0x8(%esp)
f0107a13:	00 
f0107a14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107a1b:	00 
f0107a1c:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107a1f:	89 04 24             	mov    %eax,(%esp)
f0107a22:	e8 b0 ee ff ff       	call   f01068d7 <memset>
	df.bus = bus;
f0107a27:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107a2a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
}

static int
pci_scan_bus(struct pci_bus *bus)
{
	int totaldev = 0;
f0107a31:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0107a38:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107a3b:	ba 0c 00 00 00       	mov    $0xc,%edx
f0107a40:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107a43:	e8 8e ff ff ff       	call   f01079d6 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107a48:	89 c2                	mov    %eax,%edx
f0107a4a:	c1 ea 10             	shr    $0x10,%edx
f0107a4d:	83 e2 7f             	and    $0x7f,%edx
f0107a50:	83 fa 01             	cmp    $0x1,%edx
f0107a53:	0f 87 6f 01 00 00    	ja     f0107bc8 <pci_scan_bus+0x1ca>
			continue;

		totaldev++;
f0107a59:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)

		struct pci_func f = df;
f0107a60:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107a65:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0107a6b:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0107a6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107a70:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0107a77:	00 00 00 
f0107a7a:	25 00 00 80 00       	and    $0x800000,%eax
f0107a7f:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
		     f.func++) {
			struct pci_func af = f;
f0107a85:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107a8b:	e9 1d 01 00 00       	jmp    f0107bad <pci_scan_bus+0x1af>
		     f.func++) {
			struct pci_func af = f;
f0107a90:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107a95:	89 df                	mov    %ebx,%edi
f0107a97:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0107a9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0107a9f:	ba 00 00 00 00       	mov    $0x0,%edx
f0107aa4:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107aaa:	e8 27 ff ff ff       	call   f01079d6 <pci_conf_read>
f0107aaf:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107ab5:	66 83 f8 ff          	cmp    $0xffff,%ax
f0107ab9:	0f 84 e7 00 00 00    	je     f0107ba6 <pci_scan_bus+0x1a8>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107abf:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107ac4:	89 d8                	mov    %ebx,%eax
f0107ac6:	e8 0b ff ff ff       	call   f01079d6 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107acb:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107ace:	ba 08 00 00 00       	mov    $0x8,%edx
f0107ad3:	89 d8                	mov    %ebx,%eax
f0107ad5:	e8 fc fe ff ff       	call   f01079d6 <pci_conf_read>
f0107ada:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f0107ae0:	89 c2                	mov    %eax,%edx
f0107ae2:	c1 ea 18             	shr    $0x18,%edx
};

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
f0107ae5:	b9 90 a3 10 f0       	mov    $0xf010a390,%ecx
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f0107aea:	83 fa 06             	cmp    $0x6,%edx
f0107aed:	77 07                	ja     f0107af6 <pci_scan_bus+0xf8>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107aef:	8b 0c 95 04 a4 10 f0 	mov    -0xfef5bfc(,%edx,4),%ecx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107af6:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107afc:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0107b00:	89 7c 24 24          	mov    %edi,0x24(%esp)
f0107b04:	89 4c 24 20          	mov    %ecx,0x20(%esp)
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f0107b08:	c1 e8 10             	shr    $0x10,%eax
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107b0b:	0f b6 c0             	movzbl %al,%eax
f0107b0e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0107b12:	89 54 24 18          	mov    %edx,0x18(%esp)
f0107b16:	89 f0                	mov    %esi,%eax
f0107b18:	c1 e8 10             	shr    $0x10,%eax
f0107b1b:	89 44 24 14          	mov    %eax,0x14(%esp)
f0107b1f:	0f b7 f6             	movzwl %si,%esi
f0107b22:	89 74 24 10          	mov    %esi,0x10(%esp)
f0107b26:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f0107b2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107b30:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
f0107b36:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107b3a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0107b40:	8b 40 04             	mov    0x4(%eax),%eax
f0107b43:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107b47:	c7 04 24 1c a2 10 f0 	movl   $0xf010a21c,(%esp)
f0107b4e:	e8 83 c7 ff ff       	call   f01042d6 <cprintf>
static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
f0107b53:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107b59:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107b5d:	c7 44 24 08 0c 64 12 	movl   $0xf012640c,0x8(%esp)
f0107b64:	f0 
				 PCI_SUBCLASS(f->dev_class),
f0107b65:	89 c2                	mov    %eax,%edx
f0107b67:	c1 ea 10             	shr    $0x10,%edx

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107b6a:	0f b6 d2             	movzbl %dl,%edx
f0107b6d:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107b71:	c1 e8 18             	shr    $0x18,%eax
f0107b74:	89 04 24             	mov    %eax,(%esp)
f0107b77:	e8 f2 fc ff ff       	call   f010786e <pci_attach_match>
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
f0107b7c:	85 c0                	test   %eax,%eax
f0107b7e:	75 26                	jne    f0107ba6 <pci_scan_bus+0x1a8>
		pci_attach_match(PCI_VENDOR(f->dev_id),
				 PCI_PRODUCT(f->dev_id),
f0107b80:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0107b86:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107b8a:	c7 44 24 08 f4 63 12 	movl   $0xf01263f4,0x8(%esp)
f0107b91:	f0 
f0107b92:	89 c2                	mov    %eax,%edx
f0107b94:	c1 ea 10             	shr    $0x10,%edx
f0107b97:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107b9b:	0f b7 c0             	movzwl %ax,%eax
f0107b9e:	89 04 24             	mov    %eax,(%esp)
f0107ba1:	e8 c8 fc ff ff       	call   f010786e <pci_attach_match>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0107ba6:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107bad:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
f0107bb4:	19 c0                	sbb    %eax,%eax
f0107bb6:	83 e0 f9             	and    $0xfffffff9,%eax
f0107bb9:	83 c0 08             	add    $0x8,%eax
f0107bbc:	3b 85 18 ff ff ff    	cmp    -0xe8(%ebp),%eax
f0107bc2:	0f 87 c8 fe ff ff    	ja     f0107a90 <pci_scan_bus+0x92>
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107bc8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0107bcb:	83 c0 01             	add    $0x1,%eax
f0107bce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107bd1:	83 f8 1f             	cmp    $0x1f,%eax
f0107bd4:	0f 86 61 fe ff ff    	jbe    f0107a3b <pci_scan_bus+0x3d>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0107bda:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107be0:	81 c4 1c 01 00 00    	add    $0x11c,%esp
f0107be6:	5b                   	pop    %ebx
f0107be7:	5e                   	pop    %esi
f0107be8:	5f                   	pop    %edi
f0107be9:	5d                   	pop    %ebp
f0107bea:	c3                   	ret    

f0107beb <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0107beb:	55                   	push   %ebp
f0107bec:	89 e5                	mov    %esp,%ebp
f0107bee:	57                   	push   %edi
f0107bef:	56                   	push   %esi
f0107bf0:	53                   	push   %ebx
f0107bf1:	83 ec 3c             	sub    $0x3c,%esp
f0107bf4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0107bf7:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0107bfc:	89 d8                	mov    %ebx,%eax
f0107bfe:	e8 d3 fd ff ff       	call   f01079d6 <pci_conf_read>
f0107c03:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0107c05:	ba 18 00 00 00       	mov    $0x18,%edx
f0107c0a:	89 d8                	mov    %ebx,%eax
f0107c0c:	e8 c5 fd ff ff       	call   f01079d6 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107c11:	83 e7 0f             	and    $0xf,%edi
f0107c14:	83 ff 01             	cmp    $0x1,%edi
f0107c17:	75 2a                	jne    f0107c43 <pci_bridge_attach+0x58>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0107c19:	8b 43 08             	mov    0x8(%ebx),%eax
f0107c1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107c20:	8b 43 04             	mov    0x4(%ebx),%eax
f0107c23:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107c27:	8b 03                	mov    (%ebx),%eax
f0107c29:	8b 40 04             	mov    0x4(%eax),%eax
f0107c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107c30:	c7 04 24 58 a2 10 f0 	movl   $0xf010a258,(%esp)
f0107c37:	e8 9a c6 ff ff       	call   f01042d6 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f0107c3c:	b8 00 00 00 00       	mov    $0x0,%eax
f0107c41:	eb 67                	jmp    f0107caa <pci_bridge_attach+0xbf>
f0107c43:	89 c6                	mov    %eax,%esi
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0107c45:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f0107c4c:	00 
f0107c4d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107c54:	00 
f0107c55:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0107c58:	89 3c 24             	mov    %edi,(%esp)
f0107c5b:	e8 77 ec ff ff       	call   f01068d7 <memset>
	nbus.parent_bridge = pcif;
f0107c60:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0107c63:	89 f0                	mov    %esi,%eax
f0107c65:	0f b6 c4             	movzbl %ah,%eax
f0107c68:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0107c6b:	89 f2                	mov    %esi,%edx
f0107c6d:	c1 ea 10             	shr    $0x10,%edx
	memset(&nbus, 0, sizeof(nbus));
	nbus.parent_bridge = pcif;
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107c70:	0f b6 f2             	movzbl %dl,%esi
f0107c73:	89 74 24 14          	mov    %esi,0x14(%esp)
f0107c77:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107c7b:	8b 43 08             	mov    0x8(%ebx),%eax
f0107c7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107c82:	8b 43 04             	mov    0x4(%ebx),%eax
f0107c85:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107c89:	8b 03                	mov    (%ebx),%eax
f0107c8b:	8b 40 04             	mov    0x4(%eax),%eax
f0107c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107c92:	c7 04 24 8c a2 10 f0 	movl   $0xf010a28c,(%esp)
f0107c99:	e8 38 c6 ff ff       	call   f01042d6 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);

	pci_scan_bus(&nbus);
f0107c9e:	89 f8                	mov    %edi,%eax
f0107ca0:	e8 59 fd ff ff       	call   f01079fe <pci_scan_bus>
	return 1;
f0107ca5:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0107caa:	83 c4 3c             	add    $0x3c,%esp
f0107cad:	5b                   	pop    %ebx
f0107cae:	5e                   	pop    %esi
f0107caf:	5f                   	pop    %edi
f0107cb0:	5d                   	pop    %ebp
f0107cb1:	c3                   	ret    

f0107cb2 <pci_conf_write>:
	return inl(pci_conf1_data_ioport);
}

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0107cb2:	55                   	push   %ebp
f0107cb3:	89 e5                	mov    %esp,%ebp
f0107cb5:	56                   	push   %esi
f0107cb6:	53                   	push   %ebx
f0107cb7:	83 ec 10             	sub    $0x10,%esp
f0107cba:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107cbc:	8b 48 08             	mov    0x8(%eax),%ecx
f0107cbf:	8b 70 04             	mov    0x4(%eax),%esi
f0107cc2:	8b 00                	mov    (%eax),%eax
f0107cc4:	8b 40 04             	mov    0x4(%eax),%eax
f0107cc7:	89 14 24             	mov    %edx,(%esp)
f0107cca:	89 f2                	mov    %esi,%edx
f0107ccc:	e8 00 fc ff ff       	call   f01078d1 <pci_conf1_set_addr>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107cd1:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107cd6:	89 d8                	mov    %ebx,%eax
f0107cd8:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f0107cd9:	83 c4 10             	add    $0x10,%esp
f0107cdc:	5b                   	pop    %ebx
f0107cdd:	5e                   	pop    %esi
f0107cde:	5d                   	pop    %ebp
f0107cdf:	c3                   	ret    

f0107ce0 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0107ce0:	55                   	push   %ebp
f0107ce1:	89 e5                	mov    %esp,%ebp
f0107ce3:	57                   	push   %edi
f0107ce4:	56                   	push   %esi
f0107ce5:	53                   	push   %ebx
f0107ce6:	83 ec 4c             	sub    $0x4c,%esp
f0107ce9:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0107cec:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107cf1:	ba 04 00 00 00       	mov    $0x4,%edx
f0107cf6:	89 f8                	mov    %edi,%eax
f0107cf8:	e8 b5 ff ff ff       	call   f0107cb2 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107cfd:	be 10 00 00 00       	mov    $0x10,%esi
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f0107d02:	89 f2                	mov    %esi,%edx
f0107d04:	89 f8                	mov    %edi,%eax
f0107d06:	e8 cb fc ff ff       	call   f01079d6 <pci_conf_read>
f0107d0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		bar_width = 4;
		pci_conf_write(f, bar, 0xffffffff);
f0107d0e:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0107d13:	89 f2                	mov    %esi,%edx
f0107d15:	89 f8                	mov    %edi,%eax
f0107d17:	e8 96 ff ff ff       	call   f0107cb2 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0107d1c:	89 f2                	mov    %esi,%edx
f0107d1e:	89 f8                	mov    %edi,%eax
f0107d20:	e8 b1 fc ff ff       	call   f01079d6 <pci_conf_read>
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0107d25:	bb 04 00 00 00       	mov    $0x4,%ebx
		pci_conf_write(f, bar, 0xffffffff);
		uint32_t rv = pci_conf_read(f, bar);

		if (rv == 0)
f0107d2a:	85 c0                	test   %eax,%eax
f0107d2c:	0f 84 c1 00 00 00    	je     f0107df3 <pci_func_enable+0x113>
			continue;

		int regnum = PCI_MAPREG_NUM(bar);
f0107d32:	8d 56 f0             	lea    -0x10(%esi),%edx
f0107d35:	c1 ea 02             	shr    $0x2,%edx
f0107d38:	89 55 dc             	mov    %edx,-0x24(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0107d3b:	a8 01                	test   $0x1,%al
f0107d3d:	75 2c                	jne    f0107d6b <pci_func_enable+0x8b>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0107d3f:	89 c2                	mov    %eax,%edx
f0107d41:	83 e2 06             	and    $0x6,%edx
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0107d44:	83 fa 04             	cmp    $0x4,%edx
f0107d47:	0f 94 c3             	sete   %bl
f0107d4a:	0f b6 db             	movzbl %bl,%ebx
f0107d4d:	8d 1c 9d 04 00 00 00 	lea    0x4(,%ebx,4),%ebx
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
				bar_width = 8;

			size = PCI_MAPREG_MEM_SIZE(rv);
f0107d54:	83 e0 f0             	and    $0xfffffff0,%eax
f0107d57:	89 c2                	mov    %eax,%edx
f0107d59:	f7 da                	neg    %edx
f0107d5b:	21 d0                	and    %edx,%eax
f0107d5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0107d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0107d63:	83 e0 f0             	and    $0xfffffff0,%eax
f0107d66:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0107d69:	eb 1a                	jmp    f0107d85 <pci_func_enable+0xa5>
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107d6b:	83 e0 fc             	and    $0xfffffffc,%eax
f0107d6e:	89 c2                	mov    %eax,%edx
f0107d70:	f7 da                	neg    %edx
f0107d72:	21 d0                	and    %edx,%eax
f0107d74:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f0107d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0107d7a:	83 e0 fc             	and    $0xfffffffc,%eax
f0107d7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0107d80:	bb 04 00 00 00       	mov    $0x4,%ebx
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107d85:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0107d88:	89 f2                	mov    %esi,%edx
f0107d8a:	89 f8                	mov    %edi,%eax
f0107d8c:	e8 21 ff ff ff       	call   f0107cb2 <pci_conf_write>
f0107d91:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0107d94:	8d 04 87             	lea    (%edi,%eax,4),%eax
		f->reg_base[regnum] = base;
f0107d97:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0107d9a:	89 48 14             	mov    %ecx,0x14(%eax)
		f->reg_size[regnum] = size;
f0107d9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0107da0:	89 50 2c             	mov    %edx,0x2c(%eax)

		if (size && !base)
f0107da3:	85 c9                	test   %ecx,%ecx
f0107da5:	75 4c                	jne    f0107df3 <pci_func_enable+0x113>
f0107da7:	85 d2                	test   %edx,%edx
f0107da9:	74 48                	je     f0107df3 <pci_func_enable+0x113>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107dab:	8b 47 0c             	mov    0xc(%edi),%eax
		pci_conf_write(f, bar, oldv);
		f->reg_base[regnum] = base;
		f->reg_size[regnum] = size;

		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0107dae:	89 54 24 20          	mov    %edx,0x20(%esp)
f0107db2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0107db5:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
f0107db9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0107dbc:	89 4c 24 18          	mov    %ecx,0x18(%esp)
f0107dc0:	89 c2                	mov    %eax,%edx
f0107dc2:	c1 ea 10             	shr    $0x10,%edx
f0107dc5:	89 54 24 14          	mov    %edx,0x14(%esp)
f0107dc9:	0f b7 c0             	movzwl %ax,%eax
f0107dcc:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107dd0:	8b 47 08             	mov    0x8(%edi),%eax
f0107dd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107dd7:	8b 47 04             	mov    0x4(%edi),%eax
f0107dda:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107dde:	8b 07                	mov    (%edi),%eax
f0107de0:	8b 40 04             	mov    0x4(%eax),%eax
f0107de3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107de7:	c7 04 24 bc a2 10 f0 	movl   $0xf010a2bc,(%esp)
f0107dee:	e8 e3 c4 ff ff       	call   f01042d6 <cprintf>
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
f0107df3:	01 de                	add    %ebx,%esi
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107df5:	83 fe 27             	cmp    $0x27,%esi
f0107df8:	0f 86 04 ff ff ff    	jbe    f0107d02 <pci_func_enable+0x22>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0107dfe:	8b 47 0c             	mov    0xc(%edi),%eax
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0107e01:	89 c2                	mov    %eax,%edx
f0107e03:	c1 ea 10             	shr    $0x10,%edx
f0107e06:	89 54 24 14          	mov    %edx,0x14(%esp)
f0107e0a:	0f b7 c0             	movzwl %ax,%eax
f0107e0d:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107e11:	8b 47 08             	mov    0x8(%edi),%eax
f0107e14:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107e18:	8b 47 04             	mov    0x4(%edi),%eax
f0107e1b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107e1f:	8b 07                	mov    (%edi),%eax
f0107e21:	8b 40 04             	mov    0x4(%eax),%eax
f0107e24:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107e28:	c7 04 24 18 a3 10 f0 	movl   $0xf010a318,(%esp)
f0107e2f:	e8 a2 c4 ff ff       	call   f01042d6 <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}
f0107e34:	83 c4 4c             	add    $0x4c,%esp
f0107e37:	5b                   	pop    %ebx
f0107e38:	5e                   	pop    %esi
f0107e39:	5f                   	pop    %edi
f0107e3a:	5d                   	pop    %ebp
f0107e3b:	c3                   	ret    

f0107e3c <pci_init>:

int
pci_init(void)
{
f0107e3c:	55                   	push   %ebp
f0107e3d:	89 e5                	mov    %esp,%ebp
f0107e3f:	83 ec 18             	sub    $0x18,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107e42:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f0107e49:	00 
f0107e4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107e51:	00 
f0107e52:	c7 04 24 80 4e 2c f0 	movl   $0xf02c4e80,(%esp)
f0107e59:	e8 79 ea ff ff       	call   f01068d7 <memset>

	return pci_scan_bus(&root_bus);
f0107e5e:	b8 80 4e 2c f0       	mov    $0xf02c4e80,%eax
f0107e63:	e8 96 fb ff ff       	call   f01079fe <pci_scan_bus>
}
f0107e68:	c9                   	leave  
f0107e69:	c3                   	ret    

f0107e6a <time_init>:

static unsigned int ticks;

void
time_init(void)
{
f0107e6a:	55                   	push   %ebp
f0107e6b:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f0107e6d:	c7 05 88 4e 2c f0 00 	movl   $0x0,0xf02c4e88
f0107e74:	00 00 00 
}
f0107e77:	5d                   	pop    %ebp
f0107e78:	c3                   	ret    

f0107e79 <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f0107e79:	a1 88 4e 2c f0       	mov    0xf02c4e88,%eax
f0107e7e:	83 c0 01             	add    $0x1,%eax
f0107e81:	a3 88 4e 2c f0       	mov    %eax,0xf02c4e88
	if (ticks * 10 < ticks)
f0107e86:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107e89:	01 d2                	add    %edx,%edx
f0107e8b:	39 d0                	cmp    %edx,%eax
f0107e8d:	76 22                	jbe    f0107eb1 <time_tick+0x38>

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
f0107e8f:	55                   	push   %ebp
f0107e90:	89 e5                	mov    %esp,%ebp
f0107e92:	83 ec 18             	sub    $0x18,%esp
	ticks++;
	if (ticks * 10 < ticks)
		panic("time_tick: time overflowed");
f0107e95:	c7 44 24 08 20 a4 10 	movl   $0xf010a420,0x8(%esp)
f0107e9c:	f0 
f0107e9d:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
f0107ea4:	00 
f0107ea5:	c7 04 24 3b a4 10 f0 	movl   $0xf010a43b,(%esp)
f0107eac:	e8 8f 81 ff ff       	call   f0100040 <_panic>
f0107eb1:	f3 c3                	repz ret 

f0107eb3 <time_msec>:
}

unsigned int
time_msec(void)
{
f0107eb3:	55                   	push   %ebp
f0107eb4:	89 e5                	mov    %esp,%ebp
	return ticks * 10;
f0107eb6:	a1 88 4e 2c f0       	mov    0xf02c4e88,%eax
f0107ebb:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0107ebe:	01 c0                	add    %eax,%eax
}
f0107ec0:	5d                   	pop    %ebp
f0107ec1:	c3                   	ret    
f0107ec2:	66 90                	xchg   %ax,%ax
f0107ec4:	66 90                	xchg   %ax,%ax
f0107ec6:	66 90                	xchg   %ax,%ax
f0107ec8:	66 90                	xchg   %ax,%ax
f0107eca:	66 90                	xchg   %ax,%ax
f0107ecc:	66 90                	xchg   %ax,%ax
f0107ece:	66 90                	xchg   %ax,%ax

f0107ed0 <__udivdi3>:
f0107ed0:	55                   	push   %ebp
f0107ed1:	57                   	push   %edi
f0107ed2:	56                   	push   %esi
f0107ed3:	83 ec 0c             	sub    $0xc,%esp
f0107ed6:	8b 44 24 28          	mov    0x28(%esp),%eax
f0107eda:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
f0107ede:	8b 6c 24 20          	mov    0x20(%esp),%ebp
f0107ee2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f0107ee6:	85 c0                	test   %eax,%eax
f0107ee8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0107eec:	89 ea                	mov    %ebp,%edx
f0107eee:	89 0c 24             	mov    %ecx,(%esp)
f0107ef1:	75 2d                	jne    f0107f20 <__udivdi3+0x50>
f0107ef3:	39 e9                	cmp    %ebp,%ecx
f0107ef5:	77 61                	ja     f0107f58 <__udivdi3+0x88>
f0107ef7:	85 c9                	test   %ecx,%ecx
f0107ef9:	89 ce                	mov    %ecx,%esi
f0107efb:	75 0b                	jne    f0107f08 <__udivdi3+0x38>
f0107efd:	b8 01 00 00 00       	mov    $0x1,%eax
f0107f02:	31 d2                	xor    %edx,%edx
f0107f04:	f7 f1                	div    %ecx
f0107f06:	89 c6                	mov    %eax,%esi
f0107f08:	31 d2                	xor    %edx,%edx
f0107f0a:	89 e8                	mov    %ebp,%eax
f0107f0c:	f7 f6                	div    %esi
f0107f0e:	89 c5                	mov    %eax,%ebp
f0107f10:	89 f8                	mov    %edi,%eax
f0107f12:	f7 f6                	div    %esi
f0107f14:	89 ea                	mov    %ebp,%edx
f0107f16:	83 c4 0c             	add    $0xc,%esp
f0107f19:	5e                   	pop    %esi
f0107f1a:	5f                   	pop    %edi
f0107f1b:	5d                   	pop    %ebp
f0107f1c:	c3                   	ret    
f0107f1d:	8d 76 00             	lea    0x0(%esi),%esi
f0107f20:	39 e8                	cmp    %ebp,%eax
f0107f22:	77 24                	ja     f0107f48 <__udivdi3+0x78>
f0107f24:	0f bd e8             	bsr    %eax,%ebp
f0107f27:	83 f5 1f             	xor    $0x1f,%ebp
f0107f2a:	75 3c                	jne    f0107f68 <__udivdi3+0x98>
f0107f2c:	8b 74 24 04          	mov    0x4(%esp),%esi
f0107f30:	39 34 24             	cmp    %esi,(%esp)
f0107f33:	0f 86 9f 00 00 00    	jbe    f0107fd8 <__udivdi3+0x108>
f0107f39:	39 d0                	cmp    %edx,%eax
f0107f3b:	0f 82 97 00 00 00    	jb     f0107fd8 <__udivdi3+0x108>
f0107f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107f48:	31 d2                	xor    %edx,%edx
f0107f4a:	31 c0                	xor    %eax,%eax
f0107f4c:	83 c4 0c             	add    $0xc,%esp
f0107f4f:	5e                   	pop    %esi
f0107f50:	5f                   	pop    %edi
f0107f51:	5d                   	pop    %ebp
f0107f52:	c3                   	ret    
f0107f53:	90                   	nop
f0107f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107f58:	89 f8                	mov    %edi,%eax
f0107f5a:	f7 f1                	div    %ecx
f0107f5c:	31 d2                	xor    %edx,%edx
f0107f5e:	83 c4 0c             	add    $0xc,%esp
f0107f61:	5e                   	pop    %esi
f0107f62:	5f                   	pop    %edi
f0107f63:	5d                   	pop    %ebp
f0107f64:	c3                   	ret    
f0107f65:	8d 76 00             	lea    0x0(%esi),%esi
f0107f68:	89 e9                	mov    %ebp,%ecx
f0107f6a:	8b 3c 24             	mov    (%esp),%edi
f0107f6d:	d3 e0                	shl    %cl,%eax
f0107f6f:	89 c6                	mov    %eax,%esi
f0107f71:	b8 20 00 00 00       	mov    $0x20,%eax
f0107f76:	29 e8                	sub    %ebp,%eax
f0107f78:	89 c1                	mov    %eax,%ecx
f0107f7a:	d3 ef                	shr    %cl,%edi
f0107f7c:	89 e9                	mov    %ebp,%ecx
f0107f7e:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0107f82:	8b 3c 24             	mov    (%esp),%edi
f0107f85:	09 74 24 08          	or     %esi,0x8(%esp)
f0107f89:	89 d6                	mov    %edx,%esi
f0107f8b:	d3 e7                	shl    %cl,%edi
f0107f8d:	89 c1                	mov    %eax,%ecx
f0107f8f:	89 3c 24             	mov    %edi,(%esp)
f0107f92:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0107f96:	d3 ee                	shr    %cl,%esi
f0107f98:	89 e9                	mov    %ebp,%ecx
f0107f9a:	d3 e2                	shl    %cl,%edx
f0107f9c:	89 c1                	mov    %eax,%ecx
f0107f9e:	d3 ef                	shr    %cl,%edi
f0107fa0:	09 d7                	or     %edx,%edi
f0107fa2:	89 f2                	mov    %esi,%edx
f0107fa4:	89 f8                	mov    %edi,%eax
f0107fa6:	f7 74 24 08          	divl   0x8(%esp)
f0107faa:	89 d6                	mov    %edx,%esi
f0107fac:	89 c7                	mov    %eax,%edi
f0107fae:	f7 24 24             	mull   (%esp)
f0107fb1:	39 d6                	cmp    %edx,%esi
f0107fb3:	89 14 24             	mov    %edx,(%esp)
f0107fb6:	72 30                	jb     f0107fe8 <__udivdi3+0x118>
f0107fb8:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107fbc:	89 e9                	mov    %ebp,%ecx
f0107fbe:	d3 e2                	shl    %cl,%edx
f0107fc0:	39 c2                	cmp    %eax,%edx
f0107fc2:	73 05                	jae    f0107fc9 <__udivdi3+0xf9>
f0107fc4:	3b 34 24             	cmp    (%esp),%esi
f0107fc7:	74 1f                	je     f0107fe8 <__udivdi3+0x118>
f0107fc9:	89 f8                	mov    %edi,%eax
f0107fcb:	31 d2                	xor    %edx,%edx
f0107fcd:	e9 7a ff ff ff       	jmp    f0107f4c <__udivdi3+0x7c>
f0107fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107fd8:	31 d2                	xor    %edx,%edx
f0107fda:	b8 01 00 00 00       	mov    $0x1,%eax
f0107fdf:	e9 68 ff ff ff       	jmp    f0107f4c <__udivdi3+0x7c>
f0107fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107fe8:	8d 47 ff             	lea    -0x1(%edi),%eax
f0107feb:	31 d2                	xor    %edx,%edx
f0107fed:	83 c4 0c             	add    $0xc,%esp
f0107ff0:	5e                   	pop    %esi
f0107ff1:	5f                   	pop    %edi
f0107ff2:	5d                   	pop    %ebp
f0107ff3:	c3                   	ret    
f0107ff4:	66 90                	xchg   %ax,%ax
f0107ff6:	66 90                	xchg   %ax,%ax
f0107ff8:	66 90                	xchg   %ax,%ax
f0107ffa:	66 90                	xchg   %ax,%ax
f0107ffc:	66 90                	xchg   %ax,%ax
f0107ffe:	66 90                	xchg   %ax,%ax

f0108000 <__umoddi3>:
f0108000:	55                   	push   %ebp
f0108001:	57                   	push   %edi
f0108002:	56                   	push   %esi
f0108003:	83 ec 14             	sub    $0x14,%esp
f0108006:	8b 44 24 28          	mov    0x28(%esp),%eax
f010800a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f010800e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
f0108012:	89 c7                	mov    %eax,%edi
f0108014:	89 44 24 04          	mov    %eax,0x4(%esp)
f0108018:	8b 44 24 30          	mov    0x30(%esp),%eax
f010801c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0108020:	89 34 24             	mov    %esi,(%esp)
f0108023:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0108027:	85 c0                	test   %eax,%eax
f0108029:	89 c2                	mov    %eax,%edx
f010802b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010802f:	75 17                	jne    f0108048 <__umoddi3+0x48>
f0108031:	39 fe                	cmp    %edi,%esi
f0108033:	76 4b                	jbe    f0108080 <__umoddi3+0x80>
f0108035:	89 c8                	mov    %ecx,%eax
f0108037:	89 fa                	mov    %edi,%edx
f0108039:	f7 f6                	div    %esi
f010803b:	89 d0                	mov    %edx,%eax
f010803d:	31 d2                	xor    %edx,%edx
f010803f:	83 c4 14             	add    $0x14,%esp
f0108042:	5e                   	pop    %esi
f0108043:	5f                   	pop    %edi
f0108044:	5d                   	pop    %ebp
f0108045:	c3                   	ret    
f0108046:	66 90                	xchg   %ax,%ax
f0108048:	39 f8                	cmp    %edi,%eax
f010804a:	77 54                	ja     f01080a0 <__umoddi3+0xa0>
f010804c:	0f bd e8             	bsr    %eax,%ebp
f010804f:	83 f5 1f             	xor    $0x1f,%ebp
f0108052:	75 5c                	jne    f01080b0 <__umoddi3+0xb0>
f0108054:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0108058:	39 3c 24             	cmp    %edi,(%esp)
f010805b:	0f 87 e7 00 00 00    	ja     f0108148 <__umoddi3+0x148>
f0108061:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0108065:	29 f1                	sub    %esi,%ecx
f0108067:	19 c7                	sbb    %eax,%edi
f0108069:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010806d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0108071:	8b 44 24 08          	mov    0x8(%esp),%eax
f0108075:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0108079:	83 c4 14             	add    $0x14,%esp
f010807c:	5e                   	pop    %esi
f010807d:	5f                   	pop    %edi
f010807e:	5d                   	pop    %ebp
f010807f:	c3                   	ret    
f0108080:	85 f6                	test   %esi,%esi
f0108082:	89 f5                	mov    %esi,%ebp
f0108084:	75 0b                	jne    f0108091 <__umoddi3+0x91>
f0108086:	b8 01 00 00 00       	mov    $0x1,%eax
f010808b:	31 d2                	xor    %edx,%edx
f010808d:	f7 f6                	div    %esi
f010808f:	89 c5                	mov    %eax,%ebp
f0108091:	8b 44 24 04          	mov    0x4(%esp),%eax
f0108095:	31 d2                	xor    %edx,%edx
f0108097:	f7 f5                	div    %ebp
f0108099:	89 c8                	mov    %ecx,%eax
f010809b:	f7 f5                	div    %ebp
f010809d:	eb 9c                	jmp    f010803b <__umoddi3+0x3b>
f010809f:	90                   	nop
f01080a0:	89 c8                	mov    %ecx,%eax
f01080a2:	89 fa                	mov    %edi,%edx
f01080a4:	83 c4 14             	add    $0x14,%esp
f01080a7:	5e                   	pop    %esi
f01080a8:	5f                   	pop    %edi
f01080a9:	5d                   	pop    %ebp
f01080aa:	c3                   	ret    
f01080ab:	90                   	nop
f01080ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01080b0:	8b 04 24             	mov    (%esp),%eax
f01080b3:	be 20 00 00 00       	mov    $0x20,%esi
f01080b8:	89 e9                	mov    %ebp,%ecx
f01080ba:	29 ee                	sub    %ebp,%esi
f01080bc:	d3 e2                	shl    %cl,%edx
f01080be:	89 f1                	mov    %esi,%ecx
f01080c0:	d3 e8                	shr    %cl,%eax
f01080c2:	89 e9                	mov    %ebp,%ecx
f01080c4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01080c8:	8b 04 24             	mov    (%esp),%eax
f01080cb:	09 54 24 04          	or     %edx,0x4(%esp)
f01080cf:	89 fa                	mov    %edi,%edx
f01080d1:	d3 e0                	shl    %cl,%eax
f01080d3:	89 f1                	mov    %esi,%ecx
f01080d5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01080d9:	8b 44 24 10          	mov    0x10(%esp),%eax
f01080dd:	d3 ea                	shr    %cl,%edx
f01080df:	89 e9                	mov    %ebp,%ecx
f01080e1:	d3 e7                	shl    %cl,%edi
f01080e3:	89 f1                	mov    %esi,%ecx
f01080e5:	d3 e8                	shr    %cl,%eax
f01080e7:	89 e9                	mov    %ebp,%ecx
f01080e9:	09 f8                	or     %edi,%eax
f01080eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01080ef:	f7 74 24 04          	divl   0x4(%esp)
f01080f3:	d3 e7                	shl    %cl,%edi
f01080f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01080f9:	89 d7                	mov    %edx,%edi
f01080fb:	f7 64 24 08          	mull   0x8(%esp)
f01080ff:	39 d7                	cmp    %edx,%edi
f0108101:	89 c1                	mov    %eax,%ecx
f0108103:	89 14 24             	mov    %edx,(%esp)
f0108106:	72 2c                	jb     f0108134 <__umoddi3+0x134>
f0108108:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f010810c:	72 22                	jb     f0108130 <__umoddi3+0x130>
f010810e:	8b 44 24 0c          	mov    0xc(%esp),%eax
f0108112:	29 c8                	sub    %ecx,%eax
f0108114:	19 d7                	sbb    %edx,%edi
f0108116:	89 e9                	mov    %ebp,%ecx
f0108118:	89 fa                	mov    %edi,%edx
f010811a:	d3 e8                	shr    %cl,%eax
f010811c:	89 f1                	mov    %esi,%ecx
f010811e:	d3 e2                	shl    %cl,%edx
f0108120:	89 e9                	mov    %ebp,%ecx
f0108122:	d3 ef                	shr    %cl,%edi
f0108124:	09 d0                	or     %edx,%eax
f0108126:	89 fa                	mov    %edi,%edx
f0108128:	83 c4 14             	add    $0x14,%esp
f010812b:	5e                   	pop    %esi
f010812c:	5f                   	pop    %edi
f010812d:	5d                   	pop    %ebp
f010812e:	c3                   	ret    
f010812f:	90                   	nop
f0108130:	39 d7                	cmp    %edx,%edi
f0108132:	75 da                	jne    f010810e <__umoddi3+0x10e>
f0108134:	8b 14 24             	mov    (%esp),%edx
f0108137:	89 c1                	mov    %eax,%ecx
f0108139:	2b 4c 24 08          	sub    0x8(%esp),%ecx
f010813d:	1b 54 24 04          	sbb    0x4(%esp),%edx
f0108141:	eb cb                	jmp    f010810e <__umoddi3+0x10e>
f0108143:	90                   	nop
f0108144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0108148:	3b 44 24 0c          	cmp    0xc(%esp),%eax
f010814c:	0f 82 0f ff ff ff    	jb     f0108061 <__umoddi3+0x61>
f0108152:	e9 1a ff ff ff       	jmp    f0108071 <__umoddi3+0x71>
