
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 2b 1c 00 00       	call   801c5c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
		return -1;
	return 0;
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	b2 f7                	mov    $0xf7,%dl
  800082:	eb 0b                	jmp    80008f <ide_probe_disk1+0x30>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  800084:	83 c1 01             	add    $0x1,%ecx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  800087:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  80008d:	74 05                	je     800094 <ide_probe_disk1+0x35>
  80008f:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800090:	a8 a1                	test   $0xa1,%al
  800092:	75 f0                	jne    800084 <ide_probe_disk1+0x25>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800094:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009e:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  80009f:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a5:	0f 9e c3             	setle  %bl
  8000a8:	0f b6 c3             	movzbl %bl,%eax
  8000ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000af:	c7 04 24 60 43 80 00 	movl   $0x804360,(%esp)
  8000b6:	e8 ff 1c 00 00       	call   801dba <cprintf>
	return (x < 1000);
}
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	83 c4 14             	add    $0x14,%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	83 ec 18             	sub    $0x18,%esp
  8000c9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000cc:	83 f8 01             	cmp    $0x1,%eax
  8000cf:	76 1c                	jbe    8000ed <ide_set_disk+0x2a>
		panic("bad disk number");
  8000d1:	c7 44 24 08 77 43 80 	movl   $0x804377,0x8(%esp)
  8000d8:	00 
  8000d9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8000e0:	00 
  8000e1:	c7 04 24 87 43 80 00 	movl   $0x804387,(%esp)
  8000e8:	e8 d4 1b 00 00       	call   801cc1 <_panic>
	diskno = d;
  8000ed:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 1c             	sub    $0x1c,%esp
  8000fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800100:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800103:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800106:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80010c:	76 24                	jbe    800132 <ide_read+0x3e>
  80010e:	c7 44 24 0c 90 43 80 	movl   $0x804390,0xc(%esp)
  800115:	00 
  800116:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 87 43 80 00 	movl   $0x804387,(%esp)
  80012d:	e8 8f 1b 00 00       	call   801cc1 <_panic>

	ide_wait_ready(0);
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
  800137:	e8 f7 fe ff ff       	call   800033 <ide_wait_ready>
  80013c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800141:	89 f0                	mov    %esi,%eax
  800143:	ee                   	out    %al,(%dx)
  800144:	b2 f3                	mov    $0xf3,%dl
  800146:	89 f8                	mov    %edi,%eax
  800148:	ee                   	out    %al,(%dx)
  800149:	89 f8                	mov    %edi,%eax
  80014b:	0f b6 c4             	movzbl %ah,%eax
  80014e:	b2 f4                	mov    $0xf4,%dl
  800150:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800151:	89 f8                	mov    %edi,%eax
  800153:	c1 e8 10             	shr    $0x10,%eax
  800156:	b2 f5                	mov    $0xf5,%dl
  800158:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800159:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800160:	83 e0 01             	and    $0x1,%eax
  800163:	c1 e0 04             	shl    $0x4,%eax
  800166:	83 c8 e0             	or     $0xffffffe0,%eax
  800169:	c1 ef 18             	shr    $0x18,%edi
  80016c:	83 e7 0f             	and    $0xf,%edi
  80016f:	09 f8                	or     %edi,%eax
  800171:	b2 f6                	mov    $0xf6,%dl
  800173:	ee                   	out    %al,(%dx)
  800174:	b2 f7                	mov    $0xf7,%dl
  800176:	b8 20 00 00 00       	mov    $0x20,%eax
  80017b:	ee                   	out    %al,(%dx)
  80017c:	c1 e6 09             	shl    $0x9,%esi
  80017f:	01 de                	add    %ebx,%esi
  800181:	eb 23                	jmp    8001a6 <ide_read+0xb2>
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800183:	b8 01 00 00 00       	mov    $0x1,%eax
  800188:	e8 a6 fe ff ff       	call   800033 <ide_wait_ready>
  80018d:	85 c0                	test   %eax,%eax
  80018f:	78 1e                	js     8001af <ide_read+0xbb>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  800191:	89 df                	mov    %ebx,%edi
  800193:	b9 80 00 00 00       	mov    $0x80,%ecx
  800198:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80019d:	fc                   	cld    
  80019e:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001a0:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8001a6:	39 f3                	cmp    %esi,%ebx
  8001a8:	75 d9                	jne    800183 <ide_read+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001af:	83 c4 1c             	add    $0x1c,%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	57                   	push   %edi
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 1c             	sub    $0x1c,%esp
  8001c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c9:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001cf:	76 24                	jbe    8001f5 <ide_write+0x3e>
  8001d1:	c7 44 24 0c 90 43 80 	movl   $0x804390,0xc(%esp)
  8001d8:	00 
  8001d9:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  8001e0:	00 
  8001e1:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8001e8:	00 
  8001e9:	c7 04 24 87 43 80 00 	movl   $0x804387,(%esp)
  8001f0:	e8 cc 1a 00 00       	call   801cc1 <_panic>

	ide_wait_ready(0);
  8001f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fa:	e8 34 fe ff ff       	call   800033 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001ff:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800204:	89 f8                	mov    %edi,%eax
  800206:	ee                   	out    %al,(%dx)
  800207:	b2 f3                	mov    $0xf3,%dl
  800209:	89 f0                	mov    %esi,%eax
  80020b:	ee                   	out    %al,(%dx)
  80020c:	89 f0                	mov    %esi,%eax
  80020e:	0f b6 c4             	movzbl %ah,%eax
  800211:	b2 f4                	mov    $0xf4,%dl
  800213:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800214:	89 f0                	mov    %esi,%eax
  800216:	c1 e8 10             	shr    $0x10,%eax
  800219:	b2 f5                	mov    $0xf5,%dl
  80021b:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80021c:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800223:	83 e0 01             	and    $0x1,%eax
  800226:	c1 e0 04             	shl    $0x4,%eax
  800229:	83 c8 e0             	or     $0xffffffe0,%eax
  80022c:	c1 ee 18             	shr    $0x18,%esi
  80022f:	83 e6 0f             	and    $0xf,%esi
  800232:	09 f0                	or     %esi,%eax
  800234:	b2 f6                	mov    $0xf6,%dl
  800236:	ee                   	out    %al,(%dx)
  800237:	b2 f7                	mov    $0xf7,%dl
  800239:	b8 30 00 00 00       	mov    $0x30,%eax
  80023e:	ee                   	out    %al,(%dx)
  80023f:	c1 e7 09             	shl    $0x9,%edi
  800242:	01 df                	add    %ebx,%edi
  800244:	eb 23                	jmp    800269 <ide_write+0xb2>
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800246:	b8 01 00 00 00       	mov    $0x1,%eax
  80024b:	e8 e3 fd ff ff       	call   800033 <ide_wait_ready>
  800250:	85 c0                	test   %eax,%eax
  800252:	78 1e                	js     800272 <ide_write+0xbb>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800254:	89 de                	mov    %ebx,%esi
  800256:	b9 80 00 00 00       	mov    $0x80,%ecx
  80025b:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800260:	fc                   	cld    
  800261:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800263:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800269:	39 fb                	cmp    %edi,%ebx
  80026b:	75 d9                	jne    800246 <ide_write+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	83 c4 1c             	add    $0x1c,%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	57                   	push   %edi
  80027e:	56                   	push   %esi
  80027f:	53                   	push   %ebx
  800280:	83 ec 2c             	sub    $0x2c,%esp
  800283:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800286:	8b 32                	mov    (%edx),%esi
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800288:	8d 86 00 00 00 f0    	lea    -0x10000000(%esi),%eax
  80028e:	89 c7                	mov    %eax,%edi
  800290:	c1 ef 0c             	shr    $0xc,%edi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800293:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800298:	76 2e                	jbe    8002c8 <bc_pgfault+0x4e>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80029a:	8b 42 04             	mov    0x4(%edx),%eax
  80029d:	89 44 24 14          	mov    %eax,0x14(%esp)
  8002a1:	89 74 24 10          	mov    %esi,0x10(%esp)
  8002a5:	8b 42 28             	mov    0x28(%edx),%eax
  8002a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ac:	c7 44 24 08 b4 43 80 	movl   $0x8043b4,0x8(%esp)
  8002b3:	00 
  8002b4:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  8002bb:	00 
  8002bc:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  8002c3:	e8 f9 19 00 00       	call   801cc1 <_panic>
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002c8:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8002cd:	85 c0                	test   %eax,%eax
  8002cf:	74 25                	je     8002f6 <bc_pgfault+0x7c>
  8002d1:	3b 78 04             	cmp    0x4(%eax),%edi
  8002d4:	72 20                	jb     8002f6 <bc_pgfault+0x7c>
		panic("reading non-existent block %08x\n", blockno);
  8002d6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8002da:	c7 44 24 08 e4 43 80 	movl   $0x8043e4,0x8(%esp)
  8002e1:	00 
  8002e2:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8002e9:	00 
  8002ea:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  8002f1:	e8 cb 19 00 00       	call   801cc1 <_panic>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	void* rounded_addr = ROUNDDOWN(addr, PGSIZE);
  8002f6:	89 f3                	mov    %esi,%ebx
  8002f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_alloc(0, rounded_addr, PTE_SYSCALL)) < 0)
  8002fe:	c7 44 24 08 07 0e 00 	movl   $0xe07,0x8(%esp)
  800305:	00 
  800306:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80030a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800311:	e8 ed 24 00 00       	call   802803 <sys_page_alloc>
  800316:	85 c0                	test   %eax,%eax
  800318:	79 20                	jns    80033a <bc_pgfault+0xc0>
		panic("in bc_pgfault, sys_page_alloc: %e", r);
  80031a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80031e:	c7 44 24 08 08 44 80 	movl   $0x804408,0x8(%esp)
  800325:	00 
  800326:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80032d:	00 
  80032e:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  800335:	e8 87 19 00 00       	call   801cc1 <_panic>
		
	if ((r = ide_read(blockno*BLKSECTS, rounded_addr, BLKSECTS)) < 0)
  80033a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800341:	00 
  800342:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800346:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
  80034d:	89 04 24             	mov    %eax,(%esp)
  800350:	e8 9f fd ff ff       	call   8000f4 <ide_read>
  800355:	85 c0                	test   %eax,%eax
  800357:	79 20                	jns    800379 <bc_pgfault+0xff>
		panic("in bc_pgfault, ide_read: %e", r);
  800359:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80035d:	c7 44 24 08 c0 44 80 	movl   $0x8044c0,0x8(%esp)
  800364:	00 
  800365:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80036c:	00 
  80036d:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  800374:	e8 48 19 00 00       	call   801cc1 <_panic>

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, rounded_addr, 0, rounded_addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800379:	c1 ee 0c             	shr    $0xc,%esi
  80037c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800383:	25 07 0e 00 00       	and    $0xe07,%eax
  800388:	89 44 24 10          	mov    %eax,0x10(%esp)
  80038c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800390:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800397:	00 
  800398:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80039c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003a3:	e8 af 24 00 00       	call   802857 <sys_page_map>
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	79 20                	jns    8003cc <bc_pgfault+0x152>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8003ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003b0:	c7 44 24 08 2c 44 80 	movl   $0x80442c,0x8(%esp)
  8003b7:	00 
  8003b8:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8003bf:	00 
  8003c0:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  8003c7:	e8 f5 18 00 00       	call   801cc1 <_panic>

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8003cc:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  8003d3:	74 2c                	je     800401 <bc_pgfault+0x187>
  8003d5:	89 3c 24             	mov    %edi,(%esp)
  8003d8:	e8 05 04 00 00       	call   8007e2 <block_is_free>
  8003dd:	84 c0                	test   %al,%al
  8003df:	74 20                	je     800401 <bc_pgfault+0x187>
		panic("reading free block %08x\n", blockno);
  8003e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8003e5:	c7 44 24 08 dc 44 80 	movl   $0x8044dc,0x8(%esp)
  8003ec:	00 
  8003ed:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  8003f4:	00 
  8003f5:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  8003fc:	e8 c0 18 00 00       	call   801cc1 <_panic>
}
  800401:	83 c4 2c             	add    $0x2c,%esp
  800404:	5b                   	pop    %ebx
  800405:	5e                   	pop    %esi
  800406:	5f                   	pop    %edi
  800407:	5d                   	pop    %ebp
  800408:	c3                   	ret    

00800409 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 18             	sub    $0x18,%esp
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800412:	85 c0                	test   %eax,%eax
  800414:	74 0f                	je     800425 <diskaddr+0x1c>
  800416:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  80041c:	85 d2                	test   %edx,%edx
  80041e:	74 25                	je     800445 <diskaddr+0x3c>
  800420:	3b 42 04             	cmp    0x4(%edx),%eax
  800423:	72 20                	jb     800445 <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  800425:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800429:	c7 44 24 08 4c 44 80 	movl   $0x80444c,0x8(%esp)
  800430:	00 
  800431:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800438:	00 
  800439:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  800440:	e8 7c 18 00 00       	call   801cc1 <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800445:	05 00 00 01 00       	add    $0x10000,%eax
  80044a:	c1 e0 0c             	shl    $0xc,%eax
}
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    

0080044f <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  800455:	89 d0                	mov    %edx,%eax
  800457:	c1 e8 16             	shr    $0x16,%eax
  80045a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  800461:	b8 00 00 00 00       	mov    $0x0,%eax
  800466:	f6 c1 01             	test   $0x1,%cl
  800469:	74 0d                	je     800478 <va_is_mapped+0x29>
  80046b:	c1 ea 0c             	shr    $0xc,%edx
  80046e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800475:	83 e0 01             	and    $0x1,%eax
  800478:	83 e0 01             	and    $0x1,%eax
}
  80047b:	5d                   	pop    %ebp
  80047c:	c3                   	ret    

0080047d <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	c1 e8 0c             	shr    $0xc,%eax
  800486:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80048d:	c1 e8 06             	shr    $0x6,%eax
  800490:	83 e0 01             	and    $0x1,%eax
}
  800493:	5d                   	pop    %ebp
  800494:	c3                   	ret    

00800495 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	56                   	push   %esi
  800499:	53                   	push   %ebx
  80049a:	83 ec 20             	sub    $0x20,%esp
  80049d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8004a0:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  8004a6:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8004ab:	76 20                	jbe    8004cd <flush_block+0x38>
		panic("flush_block of bad va %08x", addr);
  8004ad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004b1:	c7 44 24 08 f5 44 80 	movl   $0x8044f5,0x8(%esp)
  8004b8:	00 
  8004b9:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8004c0:	00 
  8004c1:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  8004c8:	e8 f4 17 00 00       	call   801cc1 <_panic>

	// LAB 5: Your code here.
	if ((va_is_mapped(addr) == true) && (va_is_dirty(addr))) {
  8004cd:	89 1c 24             	mov    %ebx,(%esp)
  8004d0:	e8 7a ff ff ff       	call   80044f <va_is_mapped>
  8004d5:	84 c0                	test   %al,%al
  8004d7:	0f 84 af 00 00 00    	je     80058c <flush_block+0xf7>
  8004dd:	89 1c 24             	mov    %ebx,(%esp)
  8004e0:	e8 98 ff ff ff       	call   80047d <va_is_dirty>
  8004e5:	84 c0                	test   %al,%al
  8004e7:	0f 84 9f 00 00 00    	je     80058c <flush_block+0xf7>
		void* rounded_addr = ROUNDDOWN(addr, PGSIZE);
  8004ed:	89 de                	mov    %ebx,%esi
  8004ef:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
		if ((r = ide_write(blockno*BLKSECTS, rounded_addr, BLKSECTS)) < 0)
  8004f5:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  8004fc:	00 
  8004fd:	89 74 24 04          	mov    %esi,0x4(%esp)
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800501:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800507:	c1 e8 0c             	shr    $0xc,%eax
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	if ((va_is_mapped(addr) == true) && (va_is_dirty(addr))) {
		void* rounded_addr = ROUNDDOWN(addr, PGSIZE);
		if ((r = ide_write(blockno*BLKSECTS, rounded_addr, BLKSECTS)) < 0)
  80050a:	c1 e0 03             	shl    $0x3,%eax
  80050d:	89 04 24             	mov    %eax,(%esp)
  800510:	e8 a2 fc ff ff       	call   8001b7 <ide_write>
  800515:	85 c0                	test   %eax,%eax
  800517:	79 20                	jns    800539 <flush_block+0xa4>
			panic("in flush_block, ide_write: %e", r);
  800519:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80051d:	c7 44 24 08 10 45 80 	movl   $0x804510,0x8(%esp)
  800524:	00 
  800525:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  80052c:	00 
  80052d:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  800534:	e8 88 17 00 00       	call   801cc1 <_panic>
		if ((r = sys_page_map(0, rounded_addr, 0, rounded_addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800539:	c1 eb 0c             	shr    $0xc,%ebx
  80053c:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800543:	25 07 0e 00 00       	and    $0xe07,%eax
  800548:	89 44 24 10          	mov    %eax,0x10(%esp)
  80054c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800550:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800557:	00 
  800558:	89 74 24 04          	mov    %esi,0x4(%esp)
  80055c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800563:	e8 ef 22 00 00       	call   802857 <sys_page_map>
  800568:	85 c0                	test   %eax,%eax
  80056a:	79 20                	jns    80058c <flush_block+0xf7>
			panic("in flush_block, sys_page_map: %e", r);
  80056c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800570:	c7 44 24 08 70 44 80 	movl   $0x804470,0x8(%esp)
  800577:	00 
  800578:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  80057f:	00 
  800580:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  800587:	e8 35 17 00 00       	call   801cc1 <_panic>
	}
}
  80058c:	83 c4 20             	add    $0x20,%esp
  80058f:	5b                   	pop    %ebx
  800590:	5e                   	pop    %esi
  800591:	5d                   	pop    %ebp
  800592:	c3                   	ret    

00800593 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	81 ec 28 02 00 00    	sub    $0x228,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  80059c:	c7 04 24 7a 02 80 00 	movl   $0x80027a,(%esp)
  8005a3:	e8 80 26 00 00       	call   802c28 <set_pgfault_handler>
check_bc(void)
{
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8005a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005af:	e8 55 fe ff ff       	call   800409 <diskaddr>
  8005b4:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  8005bb:	00 
  8005bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c0:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8005c6:	89 04 24             	mov    %eax,(%esp)
  8005c9:	e8 b6 1f 00 00       	call   802584 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8005ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d5:	e8 2f fe ff ff       	call   800409 <diskaddr>
  8005da:	c7 44 24 04 2e 45 80 	movl   $0x80452e,0x4(%esp)
  8005e1:	00 
  8005e2:	89 04 24             	mov    %eax,(%esp)
  8005e5:	e8 fd 1d 00 00       	call   8023e7 <strcpy>
	flush_block(diskaddr(1));
  8005ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005f1:	e8 13 fe ff ff       	call   800409 <diskaddr>
  8005f6:	89 04 24             	mov    %eax,(%esp)
  8005f9:	e8 97 fe ff ff       	call   800495 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  8005fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800605:	e8 ff fd ff ff       	call   800409 <diskaddr>
  80060a:	89 04 24             	mov    %eax,(%esp)
  80060d:	e8 3d fe ff ff       	call   80044f <va_is_mapped>
  800612:	84 c0                	test   %al,%al
  800614:	75 24                	jne    80063a <bc_init+0xa7>
  800616:	c7 44 24 0c 50 45 80 	movl   $0x804550,0xc(%esp)
  80061d:	00 
  80061e:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  800625:	00 
  800626:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80062d:	00 
  80062e:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  800635:	e8 87 16 00 00       	call   801cc1 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80063a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800641:	e8 c3 fd ff ff       	call   800409 <diskaddr>
  800646:	89 04 24             	mov    %eax,(%esp)
  800649:	e8 2f fe ff ff       	call   80047d <va_is_dirty>
  80064e:	84 c0                	test   %al,%al
  800650:	74 24                	je     800676 <bc_init+0xe3>
  800652:	c7 44 24 0c 35 45 80 	movl   $0x804535,0xc(%esp)
  800659:	00 
  80065a:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  800661:	00 
  800662:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  800669:	00 
  80066a:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  800671:	e8 4b 16 00 00       	call   801cc1 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800676:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80067d:	e8 87 fd ff ff       	call   800409 <diskaddr>
  800682:	89 44 24 04          	mov    %eax,0x4(%esp)
  800686:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80068d:	e8 18 22 00 00       	call   8028aa <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800692:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800699:	e8 6b fd ff ff       	call   800409 <diskaddr>
  80069e:	89 04 24             	mov    %eax,(%esp)
  8006a1:	e8 a9 fd ff ff       	call   80044f <va_is_mapped>
  8006a6:	84 c0                	test   %al,%al
  8006a8:	74 24                	je     8006ce <bc_init+0x13b>
  8006aa:	c7 44 24 0c 4f 45 80 	movl   $0x80454f,0xc(%esp)
  8006b1:	00 
  8006b2:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  8006b9:	00 
  8006ba:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
  8006c1:	00 
  8006c2:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  8006c9:	e8 f3 15 00 00       	call   801cc1 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006d5:	e8 2f fd ff ff       	call   800409 <diskaddr>
  8006da:	c7 44 24 04 2e 45 80 	movl   $0x80452e,0x4(%esp)
  8006e1:	00 
  8006e2:	89 04 24             	mov    %eax,(%esp)
  8006e5:	e8 b2 1d 00 00       	call   80249c <strcmp>
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	74 24                	je     800712 <bc_init+0x17f>
  8006ee:	c7 44 24 0c 94 44 80 	movl   $0x804494,0xc(%esp)
  8006f5:	00 
  8006f6:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  8006fd:	00 
  8006fe:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  800705:	00 
  800706:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  80070d:	e8 af 15 00 00       	call   801cc1 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800712:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800719:	e8 eb fc ff ff       	call   800409 <diskaddr>
  80071e:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800725:	00 
  800726:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  80072c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800730:	89 04 24             	mov    %eax,(%esp)
  800733:	e8 4c 1e 00 00       	call   802584 <memmove>
	flush_block(diskaddr(1));
  800738:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80073f:	e8 c5 fc ff ff       	call   800409 <diskaddr>
  800744:	89 04 24             	mov    %eax,(%esp)
  800747:	e8 49 fd ff ff       	call   800495 <flush_block>

	cprintf("block cache is good\n");
  80074c:	c7 04 24 6a 45 80 00 	movl   $0x80456a,(%esp)
  800753:	e8 62 16 00 00       	call   801dba <cprintf>
	struct Super super;
	set_pgfault_handler(bc_pgfault);
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800758:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80075f:	e8 a5 fc ff ff       	call   800409 <diskaddr>
  800764:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  80076b:	00 
  80076c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800770:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800776:	89 04 24             	mov    %eax,(%esp)
  800779:	e8 06 1e 00 00       	call   802584 <memmove>
}
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  800786:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80078b:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800791:	74 1c                	je     8007af <check_super+0x2f>
		panic("bad file system magic number");
  800793:	c7 44 24 08 7f 45 80 	movl   $0x80457f,0x8(%esp)
  80079a:	00 
  80079b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8007a2:	00 
  8007a3:	c7 04 24 9c 45 80 00 	movl   $0x80459c,(%esp)
  8007aa:	e8 12 15 00 00       	call   801cc1 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8007af:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007b6:	76 1c                	jbe    8007d4 <check_super+0x54>
		panic("file system is too large");
  8007b8:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  8007bf:	00 
  8007c0:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8007c7:	00 
  8007c8:	c7 04 24 9c 45 80 00 	movl   $0x80459c,(%esp)
  8007cf:	e8 ed 14 00 00       	call   801cc1 <_panic>

	cprintf("superblock is good\n");
  8007d4:	c7 04 24 bd 45 80 00 	movl   $0x8045bd,(%esp)
  8007db:	e8 da 15 00 00       	call   801dba <cprintf>
}
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    

008007e2 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  8007e8:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8007ee:	85 d2                	test   %edx,%edx
  8007f0:	74 22                	je     800814 <block_is_free+0x32>
		return 0;
  8007f2:	b8 00 00 00 00       	mov    $0x0,%eax
// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
  8007f7:	39 4a 04             	cmp    %ecx,0x4(%edx)
  8007fa:	76 1d                	jbe    800819 <block_is_free+0x37>
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  8007fc:	b8 01 00 00 00       	mov    $0x1,%eax
  800801:	d3 e0                	shl    %cl,%eax
  800803:	c1 e9 05             	shr    $0x5,%ecx
  800806:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  80080c:	85 04 8a             	test   %eax,(%edx,%ecx,4)
		return 1;
  80080f:	0f 95 c0             	setne  %al
  800812:	eb 05                	jmp    800819 <block_is_free+0x37>
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
		return 0;
  800814:	b8 00 00 00 00       	mov    $0x0,%eax
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	53                   	push   %ebx
  80081f:	83 ec 14             	sub    $0x14,%esp
  800822:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800825:	85 c9                	test   %ecx,%ecx
  800827:	75 1c                	jne    800845 <free_block+0x2a>
		panic("attempt to free zero block");
  800829:	c7 44 24 08 d1 45 80 	movl   $0x8045d1,0x8(%esp)
  800830:	00 
  800831:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800838:	00 
  800839:	c7 04 24 9c 45 80 00 	movl   $0x80459c,(%esp)
  800840:	e8 7c 14 00 00       	call   801cc1 <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  800845:	89 ca                	mov    %ecx,%edx
  800847:	c1 ea 05             	shr    $0x5,%edx
  80084a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80084f:	bb 01 00 00 00       	mov    $0x1,%ebx
  800854:	d3 e3                	shl    %cl,%ebx
  800856:	09 1c 90             	or     %ebx,(%eax,%edx,4)
}
  800859:	83 c4 14             	add    $0x14,%esp
  80085c:	5b                   	pop    %ebx
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	56                   	push   %esi
  800863:	53                   	push   %ebx
  800864:	83 ec 10             	sub    $0x10,%esp
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  800867:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80086c:	8b 70 04             	mov    0x4(%eax),%esi
  80086f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800874:	eb 38                	jmp    8008ae <alloc_block+0x4f>
		if (block_is_free(blockno) == true) {
  800876:	89 1c 24             	mov    %ebx,(%esp)
  800879:	e8 64 ff ff ff       	call   8007e2 <block_is_free>
  80087e:	84 c0                	test   %al,%al
  800880:	74 29                	je     8008ab <alloc_block+0x4c>
			bitmap[blockno/32] &= ~(1<<(blockno%32));
  800882:	89 da                	mov    %ebx,%edx
  800884:	c1 ea 05             	shr    $0x5,%edx
  800887:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80088c:	be 01 00 00 00       	mov    $0x1,%esi
  800891:	89 d9                	mov    %ebx,%ecx
  800893:	d3 e6                	shl    %cl,%esi
  800895:	f7 d6                	not    %esi
  800897:	21 34 90             	and    %esi,(%eax,%edx,4)
			flush_block(bitmap);
  80089a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80089f:	89 04 24             	mov    %eax,(%esp)
  8008a2:	e8 ee fb ff ff       	call   800495 <flush_block>
			return blockno;
  8008a7:	89 d8                	mov    %ebx,%eax
  8008a9:	eb 0c                	jmp    8008b7 <alloc_block+0x58>
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  8008ab:	83 c3 01             	add    $0x1,%ebx
  8008ae:	39 f3                	cmp    %esi,%ebx
  8008b0:	75 c4                	jne    800876 <alloc_block+0x17>
			flush_block(bitmap);
			return blockno;
		}
	}
	
	return -E_NO_DISK;
  8008b2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	5b                   	pop    %ebx
  8008bb:	5e                   	pop    %esi
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	57                   	push   %edi
  8008c2:	56                   	push   %esi
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 1c             	sub    $0x1c,%esp
  8008c7:	89 c7                	mov    %eax,%edi
  8008c9:	89 d3                	mov    %edx,%ebx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
       // LAB 5: Your code here.
	int r;

	if (filebno >= NDIRECT + NINDIRECT){
  8008ce:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  8008d4:	0f 87 98 00 00 00    	ja     800972 <file_block_walk+0xb4>
  8008da:	89 ce                	mov    %ecx,%esi
		return -E_INVAL;
	}

	if (filebno < NDIRECT) {
  8008dc:	83 fa 09             	cmp    $0x9,%edx
  8008df:	77 1b                	ja     8008fc <file_block_walk+0x3e>
		if (ppdiskbno){
  8008e1:	85 c9                	test   %ecx,%ecx
  8008e3:	0f 84 90 00 00 00    	je     800979 <file_block_walk+0xbb>
	 		*ppdiskbno = f->f_direct + filebno;
  8008e9:	8d 84 97 88 00 00 00 	lea    0x88(%edi,%edx,4),%eax
  8008f0:	89 01                	mov    %eax,(%ecx)
		}
		return 0;
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f7:	e9 90 00 00 00       	jmp    80098c <file_block_walk+0xce>
	}

	if (!f->f_indirect && !alloc){
  8008fc:	83 bf b0 00 00 00 00 	cmpl   $0x0,0xb0(%edi)
  800903:	75 49                	jne    80094e <file_block_walk+0x90>
  800905:	84 c0                	test   %al,%al
  800907:	74 77                	je     800980 <file_block_walk+0xc2>
		return -E_NOT_FOUND;
	}

	if (!f->f_indirect) {
		if ((r = alloc_block()) < 0){
  800909:	e8 51 ff ff ff       	call   80085f <alloc_block>
  80090e:	85 c0                	test   %eax,%eax
  800910:	78 75                	js     800987 <file_block_walk+0xc9>
		  	return -E_NO_DISK;
		}
		f->f_indirect = r;
  800912:	89 87 b0 00 00 00    	mov    %eax,0xb0(%edi)
		memset(diskaddr(r), 0, BLKSIZE);
  800918:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80091b:	89 04 24             	mov    %eax,(%esp)
  80091e:	e8 e6 fa ff ff       	call   800409 <diskaddr>
  800923:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80092a:	00 
  80092b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800932:	00 
  800933:	89 04 24             	mov    %eax,(%esp)
  800936:	e8 fc 1b 00 00       	call   802537 <memset>
		flush_block(diskaddr(r));
  80093b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093e:	89 04 24             	mov    %eax,(%esp)
  800941:	e8 c3 fa ff ff       	call   800409 <diskaddr>
  800946:	89 04 24             	mov    %eax,(%esp)
  800949:	e8 47 fb ff ff       	call   800495 <flush_block>
	}

	if (ppdiskbno){
		*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
	}
	return 0;
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
		f->f_indirect = r;
		memset(diskaddr(r), 0, BLKSIZE);
		flush_block(diskaddr(r));
	}

	if (ppdiskbno){
  800953:	85 f6                	test   %esi,%esi
  800955:	74 35                	je     80098c <file_block_walk+0xce>
		*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  800957:	8b 87 b0 00 00 00    	mov    0xb0(%edi),%eax
  80095d:	89 04 24             	mov    %eax,(%esp)
  800960:	e8 a4 fa ff ff       	call   800409 <diskaddr>
  800965:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800969:	89 06                	mov    %eax,(%esi)
	}
	return 0;
  80096b:	b8 00 00 00 00       	mov    $0x0,%eax
  800970:	eb 1a                	jmp    80098c <file_block_walk+0xce>
{
       // LAB 5: Your code here.
	int r;

	if (filebno >= NDIRECT + NINDIRECT){
		return -E_INVAL;
  800972:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800977:	eb 13                	jmp    80098c <file_block_walk+0xce>

	if (filebno < NDIRECT) {
		if (ppdiskbno){
	 		*ppdiskbno = f->f_direct + filebno;
		}
		return 0;
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
  80097e:	eb 0c                	jmp    80098c <file_block_walk+0xce>
	}

	if (!f->f_indirect && !alloc){
		return -E_NOT_FOUND;
  800980:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800985:	eb 05                	jmp    80098c <file_block_walk+0xce>
	}

	if (!f->f_indirect) {
		if ((r = alloc_block()) < 0){
		  	return -E_NO_DISK;
  800987:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax

	if (ppdiskbno){
		*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
	}
	return 0;
}
  80098c:	83 c4 1c             	add    $0x1c,%esp
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5f                   	pop    %edi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  80099c:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8009a1:	8b 70 04             	mov    0x4(%eax),%esi
  8009a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009a9:	eb 36                	jmp    8009e1 <check_bitmap+0x4d>
  8009ab:	8d 43 02             	lea    0x2(%ebx),%eax
		assert(!block_is_free(2+i));
  8009ae:	89 04 24             	mov    %eax,(%esp)
  8009b1:	e8 2c fe ff ff       	call   8007e2 <block_is_free>
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 24                	je     8009de <check_bitmap+0x4a>
  8009ba:	c7 44 24 0c ec 45 80 	movl   $0x8045ec,0xc(%esp)
  8009c1:	00 
  8009c2:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  8009c9:	00 
  8009ca:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  8009d1:	00 
  8009d2:	c7 04 24 9c 45 80 00 	movl   $0x80459c,(%esp)
  8009d9:	e8 e3 12 00 00       	call   801cc1 <_panic>
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009de:	83 c3 01             	add    $0x1,%ebx
  8009e1:	89 d8                	mov    %ebx,%eax
  8009e3:	c1 e0 0f             	shl    $0xf,%eax
  8009e6:	39 c6                	cmp    %eax,%esi
  8009e8:	77 c1                	ja     8009ab <check_bitmap+0x17>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  8009ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009f1:	e8 ec fd ff ff       	call   8007e2 <block_is_free>
  8009f6:	84 c0                	test   %al,%al
  8009f8:	74 24                	je     800a1e <check_bitmap+0x8a>
  8009fa:	c7 44 24 0c 00 46 80 	movl   $0x804600,0xc(%esp)
  800a01:	00 
  800a02:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  800a09:	00 
  800a0a:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  800a11:	00 
  800a12:	c7 04 24 9c 45 80 00 	movl   $0x80459c,(%esp)
  800a19:	e8 a3 12 00 00       	call   801cc1 <_panic>
	assert(!block_is_free(1));
  800a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a25:	e8 b8 fd ff ff       	call   8007e2 <block_is_free>
  800a2a:	84 c0                	test   %al,%al
  800a2c:	74 24                	je     800a52 <check_bitmap+0xbe>
  800a2e:	c7 44 24 0c 12 46 80 	movl   $0x804612,0xc(%esp)
  800a35:	00 
  800a36:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  800a3d:	00 
  800a3e:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800a45:	00 
  800a46:	c7 04 24 9c 45 80 00 	movl   $0x80459c,(%esp)
  800a4d:	e8 6f 12 00 00       	call   801cc1 <_panic>

	cprintf("bitmap is good\n");
  800a52:	c7 04 24 24 46 80 00 	movl   $0x804624,(%esp)
  800a59:	e8 5c 13 00 00       	call   801dba <cprintf>
}
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	5b                   	pop    %ebx
  800a62:	5e                   	pop    %esi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

       // Find a JOS disk.  Use the second IDE disk (number 1) if availabl
       if (ide_probe_disk1())
  800a6b:	e8 ef f5 ff ff       	call   80005f <ide_probe_disk1>
  800a70:	84 c0                	test   %al,%al
  800a72:	74 0e                	je     800a82 <fs_init+0x1d>
               ide_set_disk(1);
  800a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a7b:	e8 43 f6 ff ff       	call   8000c3 <ide_set_disk>
  800a80:	eb 0c                	jmp    800a8e <fs_init+0x29>
       else
               ide_set_disk(0);
  800a82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a89:	e8 35 f6 ff ff       	call   8000c3 <ide_set_disk>
	bc_init();
  800a8e:	e8 00 fb ff ff       	call   800593 <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  800a93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a9a:	e8 6a f9 ff ff       	call   800409 <diskaddr>
  800a9f:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  800aa4:	e8 d7 fc ff ff       	call   800780 <check_super>

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  800aa9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800ab0:	e8 54 f9 ff ff       	call   800409 <diskaddr>
  800ab5:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800aba:	e8 d5 fe ff ff       	call   800994 <check_bitmap>
	
}
  800abf:	c9                   	leave  
  800ac0:	c3                   	ret    

00800ac1 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	53                   	push   %ebx
  800ac5:	83 ec 24             	sub    $0x24,%esp
       // LAB 5: Your code here.
	int r;
	uint32_t *pdiskno;

	if ((r = file_block_walk(f, filebno, &pdiskno, 1)) < 0){
  800ac8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800acf:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	e8 e1 fd ff ff       	call   8008be <file_block_walk>
  800add:	85 c0                	test   %eax,%eax
  800adf:	78 66                	js     800b47 <file_get_block+0x86>
	    return r;
	}
	if (*pdiskno == 0) {
  800ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae4:	83 38 00             	cmpl   $0x0,(%eax)
  800ae7:	75 40                	jne    800b29 <file_get_block+0x68>
	    if ((r = alloc_block()) < 0)
  800ae9:	e8 71 fd ff ff       	call   80085f <alloc_block>
  800aee:	89 c3                	mov    %eax,%ebx
  800af0:	85 c0                	test   %eax,%eax
  800af2:	78 4e                	js     800b42 <file_get_block+0x81>
	        return -E_NO_DISK;
	    *pdiskno = r;
  800af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af7:	89 18                	mov    %ebx,(%eax)
		memset(diskaddr(r), 0, BLKSIZE);
  800af9:	89 1c 24             	mov    %ebx,(%esp)
  800afc:	e8 08 f9 ff ff       	call   800409 <diskaddr>
  800b01:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800b08:	00 
  800b09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800b10:	00 
  800b11:	89 04 24             	mov    %eax,(%esp)
  800b14:	e8 1e 1a 00 00       	call   802537 <memset>
		flush_block(diskaddr(r));
  800b19:	89 1c 24             	mov    %ebx,(%esp)
  800b1c:	e8 e8 f8 ff ff       	call   800409 <diskaddr>
  800b21:	89 04 24             	mov    %eax,(%esp)
  800b24:	e8 6c f9 ff ff       	call   800495 <flush_block>
	}

	*blk = diskaddr(*pdiskno);
  800b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	89 04 24             	mov    %eax,(%esp)
  800b31:	e8 d3 f8 ff ff       	call   800409 <diskaddr>
  800b36:	8b 55 10             	mov    0x10(%ebp),%edx
  800b39:	89 02                	mov    %eax,(%edx)
	return 0;
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	eb 05                	jmp    800b47 <file_get_block+0x86>
	if ((r = file_block_walk(f, filebno, &pdiskno, 1)) < 0){
	    return r;
	}
	if (*pdiskno == 0) {
	    if ((r = alloc_block()) < 0)
	        return -E_NO_DISK;
  800b42:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
		flush_block(diskaddr(r));
	}

	*blk = diskaddr(*pdiskno);
	return 0;
}
  800b47:	83 c4 24             	add    $0x24,%esp
  800b4a:	5b                   	pop    %ebx
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	57                   	push   %edi
  800b51:	56                   	push   %esi
  800b52:	53                   	push   %ebx
  800b53:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800b59:	89 95 44 ff ff ff    	mov    %edx,-0xbc(%ebp)
  800b5f:	89 8d 40 ff ff ff    	mov    %ecx,-0xc0(%ebp)
  800b65:	eb 03                	jmp    800b6a <walk_path+0x1d>
// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
  800b67:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800b6a:	80 38 2f             	cmpb   $0x2f,(%eax)
  800b6d:	74 f8                	je     800b67 <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800b6f:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800b75:	83 c1 08             	add    $0x8,%ecx
  800b78:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
	dir = 0;
	name[0] = 0;
  800b7e:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800b85:	8b 8d 44 ff ff ff    	mov    -0xbc(%ebp),%ecx
  800b8b:	85 c9                	test   %ecx,%ecx
  800b8d:	74 06                	je     800b95 <walk_path+0x48>
		*pdir = 0;
  800b8f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800b95:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800b9b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
	dir = 0;
  800ba1:	ba 00 00 00 00       	mov    $0x0,%edx
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800ba6:	e9 71 01 00 00       	jmp    800d1c <walk_path+0x1cf>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800bab:	83 c7 01             	add    $0x1,%edi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800bae:	0f b6 17             	movzbl (%edi),%edx
  800bb1:	84 d2                	test   %dl,%dl
  800bb3:	74 05                	je     800bba <walk_path+0x6d>
  800bb5:	80 fa 2f             	cmp    $0x2f,%dl
  800bb8:	75 f1                	jne    800bab <walk_path+0x5e>
			path++;
		if (path - p >= MAXNAMELEN)
  800bba:	89 fb                	mov    %edi,%ebx
  800bbc:	29 c3                	sub    %eax,%ebx
  800bbe:	83 fb 7f             	cmp    $0x7f,%ebx
  800bc1:	0f 8f 82 01 00 00    	jg     800d49 <walk_path+0x1fc>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800bc7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bcf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800bd5:	89 04 24             	mov    %eax,(%esp)
  800bd8:	e8 a7 19 00 00       	call   802584 <memmove>
		name[path - p] = '\0';
  800bdd:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800be4:	00 
  800be5:	eb 03                	jmp    800bea <walk_path+0x9d>
// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
  800be7:	83 c7 01             	add    $0x1,%edi

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800bea:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800bed:	74 f8                	je     800be7 <walk_path+0x9a>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800bef:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800bf5:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800bfc:	0f 85 4e 01 00 00    	jne    800d50 <walk_path+0x203>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800c02:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c08:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800c0d:	74 24                	je     800c33 <walk_path+0xe6>
  800c0f:	c7 44 24 0c 34 46 80 	movl   $0x804634,0xc(%esp)
  800c16:	00 
  800c17:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  800c1e:	00 
  800c1f:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  800c26:	00 
  800c27:	c7 04 24 9c 45 80 00 	movl   $0x80459c,(%esp)
  800c2e:	e8 8e 10 00 00       	call   801cc1 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800c33:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	0f 48 c2             	cmovs  %edx,%eax
  800c3e:	c1 f8 0c             	sar    $0xc,%eax
  800c41:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	for (i = 0; i < nblock; i++) {
  800c47:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  800c4e:	00 00 00 
  800c51:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
  800c57:	eb 61                	jmp    800cba <walk_path+0x16d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c59:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800c5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c63:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800c69:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c6d:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800c73:	89 04 24             	mov    %eax,(%esp)
  800c76:	e8 46 fe ff ff       	call   800ac1 <file_get_block>
  800c7b:	85 c0                	test   %eax,%eax
  800c7d:	0f 88 ea 00 00 00    	js     800d6d <walk_path+0x220>
  800c83:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
			return r;
		f = (struct File*) blk;
  800c89:	be 10 00 00 00       	mov    $0x10,%esi
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800c8e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c98:	89 1c 24             	mov    %ebx,(%esp)
  800c9b:	e8 fc 17 00 00       	call   80249c <strcmp>
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	0f 84 af 00 00 00    	je     800d57 <walk_path+0x20a>
  800ca8:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800cae:	83 ee 01             	sub    $0x1,%esi
  800cb1:	75 db                	jne    800c8e <walk_path+0x141>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800cb3:	83 85 54 ff ff ff 01 	addl   $0x1,-0xac(%ebp)
  800cba:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800cc0:	39 85 4c ff ff ff    	cmp    %eax,-0xb4(%ebp)
  800cc6:	75 91                	jne    800c59 <walk_path+0x10c>
  800cc8:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800cce:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800cd3:	80 3f 00             	cmpb   $0x0,(%edi)
  800cd6:	0f 85 a0 00 00 00    	jne    800d7c <walk_path+0x22f>
				if (pdir)
  800cdc:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	74 08                	je     800cee <walk_path+0x1a1>
					*pdir = dir;
  800ce6:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800cec:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800cee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cf2:	74 15                	je     800d09 <walk_path+0x1bc>
					strcpy(lastelem, name);
  800cf4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 04 24             	mov    %eax,(%esp)
  800d04:	e8 de 16 00 00       	call   8023e7 <strcpy>
				*pf = 0;
  800d09:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  800d15:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d1a:	eb 60                	jmp    800d7c <walk_path+0x22f>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800d1c:	80 38 00             	cmpb   $0x0,(%eax)
  800d1f:	74 07                	je     800d28 <walk_path+0x1db>
  800d21:	89 c7                	mov    %eax,%edi
  800d23:	e9 86 fe ff ff       	jmp    800bae <walk_path+0x61>
			}
			return r;
		}
	}

	if (pdir)
  800d28:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	74 02                	je     800d34 <walk_path+0x1e7>
		*pdir = dir;
  800d32:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d34:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d3a:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800d40:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
  800d47:	eb 33                	jmp    800d7c <walk_path+0x22f>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
  800d49:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d4e:	eb 2c                	jmp    800d7c <walk_path+0x22f>
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;
  800d50:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d55:	eb 25                	jmp    800d7c <walk_path+0x22f>
  800d57:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
  800d5d:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800d63:	89 9d 50 ff ff ff    	mov    %ebx,-0xb0(%ebp)
  800d69:	89 f8                	mov    %edi,%eax
  800d6b:	eb af                	jmp    800d1c <walk_path+0x1cf>
  800d6d:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d73:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d76:	0f 84 52 ff ff ff    	je     800cce <walk_path+0x181>

	if (pdir)
		*pdir = dir;
	*pf = f;
	return 0;
}
  800d7c:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 18             	sub    $0x18,%esp
	return walk_path(path, 0, pf, 0);
  800d8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d97:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	e8 a9 fd ff ff       	call   800b4d <walk_path>
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
  800dac:	83 ec 3c             	sub    $0x3c,%esp
  800daf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800db2:	8b 55 14             	mov    0x14(%ebp),%edx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
		return 0;
  800dbe:	b8 00 00 00 00       	mov    $0x0,%eax
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800dc3:	39 d1                	cmp    %edx,%ecx
  800dc5:	0f 8e 83 00 00 00    	jle    800e4e <file_read+0xa8>
		return 0;

	count = MIN(count, f->f_size - offset);
  800dcb:	29 d1                	sub    %edx,%ecx
  800dcd:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dd0:	0f 47 4d 10          	cmova  0x10(%ebp),%ecx
  800dd4:	89 4d d0             	mov    %ecx,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800dd7:	89 d3                	mov    %edx,%ebx
  800dd9:	01 ca                	add    %ecx,%edx
  800ddb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800dde:	eb 64                	jmp    800e44 <file_read+0x9e>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800de0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800de3:	89 44 24 08          	mov    %eax,0x8(%esp)
  800de7:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800ded:	85 db                	test   %ebx,%ebx
  800def:	0f 49 c3             	cmovns %ebx,%eax
  800df2:	c1 f8 0c             	sar    $0xc,%eax
  800df5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	89 04 24             	mov    %eax,(%esp)
  800dff:	e8 bd fc ff ff       	call   800ac1 <file_get_block>
  800e04:	85 c0                	test   %eax,%eax
  800e06:	78 46                	js     800e4e <file_read+0xa8>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800e08:	89 da                	mov    %ebx,%edx
  800e0a:	c1 fa 1f             	sar    $0x1f,%edx
  800e0d:	c1 ea 14             	shr    $0x14,%edx
  800e10:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800e13:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e18:	29 d0                	sub    %edx,%eax
  800e1a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800e1f:	29 c1                	sub    %eax,%ecx
  800e21:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e24:	29 f2                	sub    %esi,%edx
  800e26:	39 d1                	cmp    %edx,%ecx
  800e28:	89 d6                	mov    %edx,%esi
  800e2a:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e2d:	89 74 24 08          	mov    %esi,0x8(%esp)
  800e31:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e38:	89 3c 24             	mov    %edi,(%esp)
  800e3b:	e8 44 17 00 00       	call   802584 <memmove>
		pos += bn;
  800e40:	01 f3                	add    %esi,%ebx
		buf += bn;
  800e42:	01 f7                	add    %esi,%edi
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  800e44:	89 de                	mov    %ebx,%esi
  800e46:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  800e49:	72 95                	jb     800de0 <file_read+0x3a>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  800e4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e4e:	83 c4 3c             	add    $0x3c,%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
  800e5c:	83 ec 2c             	sub    $0x2c,%esp
  800e5f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800e62:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800e68:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e6b:	0f 8e 9a 00 00 00    	jle    800f0b <file_set_size+0xb5>
file_truncate_blocks(struct File *f, off_t newsize)
{
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800e71:	8d b8 fe 1f 00 00    	lea    0x1ffe(%eax),%edi
  800e77:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e7c:	0f 49 f8             	cmovns %eax,%edi
  800e7f:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800e8b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e90:	0f 48 c2             	cmovs  %edx,%eax
  800e93:	c1 f8 0c             	sar    $0xc,%eax
  800e96:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800e99:	89 c3                	mov    %eax,%ebx
  800e9b:	eb 34                	jmp    800ed1 <file_set_size+0x7b>
file_free_block(struct File *f, uint32_t filebno)
{
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800e9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ea4:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800ea7:	89 da                	mov    %ebx,%edx
  800ea9:	89 f0                	mov    %esi,%eax
  800eab:	e8 0e fa ff ff       	call   8008be <file_block_walk>
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	78 45                	js     800ef9 <file_set_size+0xa3>
		return r;
	if (*ptr) {
  800eb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	74 11                	je     800ece <file_set_size+0x78>
		free_block(*ptr);
  800ebd:	89 04 24             	mov    %eax,(%esp)
  800ec0:	e8 56 f9 ff ff       	call   80081b <free_block>
		*ptr = 0;
  800ec5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ec8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ece:	83 c3 01             	add    $0x1,%ebx
  800ed1:	39 df                	cmp    %ebx,%edi
  800ed3:	77 c8                	ja     800e9d <file_set_size+0x47>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800ed5:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800ed9:	77 30                	ja     800f0b <file_set_size+0xb5>
  800edb:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	74 26                	je     800f0b <file_set_size+0xb5>
		free_block(f->f_indirect);
  800ee5:	89 04 24             	mov    %eax,(%esp)
  800ee8:	e8 2e f9 ff ff       	call   80081b <free_block>
		f->f_indirect = 0;
  800eed:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800ef4:	00 00 00 
  800ef7:	eb 12                	jmp    800f0b <file_set_size+0xb5>

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);
  800ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800efd:	c7 04 24 51 46 80 00 	movl   $0x804651,(%esp)
  800f04:	e8 b1 0e 00 00       	call   801dba <cprintf>
  800f09:	eb c3                	jmp    800ece <file_set_size+0x78>
int
file_set_size(struct File *f, off_t newsize)
{
	if (f->f_size > newsize)
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800f14:	89 34 24             	mov    %esi,(%esp)
  800f17:	e8 79 f5 ff ff       	call   800495 <flush_block>
	return 0;
}
  800f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f21:	83 c4 2c             	add    $0x2c,%esp
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 2c             	sub    $0x2c,%esp
  800f32:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f35:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  800f38:	89 d8                	mov    %ebx,%eax
  800f3a:	03 45 10             	add    0x10(%ebp),%eax
  800f3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f43:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800f49:	76 7c                	jbe    800fc7 <file_write+0x9e>
		if ((r = file_set_size(f, offset + count)) < 0)
  800f4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	89 04 24             	mov    %eax,(%esp)
  800f58:	e8 f9 fe ff ff       	call   800e56 <file_set_size>
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	79 66                	jns    800fc7 <file_write+0x9e>
  800f61:	eb 6e                	jmp    800fd1 <file_write+0xa8>
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f63:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f66:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f6a:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800f70:	85 db                	test   %ebx,%ebx
  800f72:	0f 49 c3             	cmovns %ebx,%eax
  800f75:	c1 f8 0c             	sar    $0xc,%eax
  800f78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 04 24             	mov    %eax,(%esp)
  800f82:	e8 3a fb ff ff       	call   800ac1 <file_get_block>
  800f87:	85 c0                	test   %eax,%eax
  800f89:	78 46                	js     800fd1 <file_write+0xa8>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f8b:	89 da                	mov    %ebx,%edx
  800f8d:	c1 fa 1f             	sar    $0x1f,%edx
  800f90:	c1 ea 14             	shr    $0x14,%edx
  800f93:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800f96:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f9b:	29 d0                	sub    %edx,%eax
  800f9d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800fa2:	29 c1                	sub    %eax,%ecx
  800fa4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fa7:	29 f2                	sub    %esi,%edx
  800fa9:	39 d1                	cmp    %edx,%ecx
  800fab:	89 d6                	mov    %edx,%esi
  800fad:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800fb0:	89 74 24 08          	mov    %esi,0x8(%esp)
  800fb4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fb8:	03 45 e4             	add    -0x1c(%ebp),%eax
  800fbb:	89 04 24             	mov    %eax,(%esp)
  800fbe:	e8 c1 15 00 00       	call   802584 <memmove>
		pos += bn;
  800fc3:	01 f3                	add    %esi,%ebx
		buf += bn;
  800fc5:	01 f7                	add    %esi,%edi
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  800fc7:	89 de                	mov    %ebx,%esi
  800fc9:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800fcc:	77 95                	ja     800f63 <file_write+0x3a>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  800fce:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800fd1:	83 c4 2c             	add    $0x2c,%esp
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
  800fde:	83 ec 20             	sub    $0x20,%esp
  800fe1:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800fe4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe9:	eb 37                	jmp    801022 <file_flush+0x49>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800feb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ff2:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800ff5:	89 da                	mov    %ebx,%edx
  800ff7:	89 f0                	mov    %esi,%eax
  800ff9:	e8 c0 f8 ff ff       	call   8008be <file_block_walk>
  800ffe:	85 c0                	test   %eax,%eax
  801000:	78 1d                	js     80101f <file_flush+0x46>
		    pdiskbno == NULL || *pdiskbno == 0)
  801002:	8b 45 f4             	mov    -0xc(%ebp),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801005:	85 c0                	test   %eax,%eax
  801007:	74 16                	je     80101f <file_flush+0x46>
		    pdiskbno == NULL || *pdiskbno == 0)
  801009:	8b 00                	mov    (%eax),%eax
  80100b:	85 c0                	test   %eax,%eax
  80100d:	74 10                	je     80101f <file_flush+0x46>
			continue;
		flush_block(diskaddr(*pdiskbno));
  80100f:	89 04 24             	mov    %eax,(%esp)
  801012:	e8 f2 f3 ff ff       	call   800409 <diskaddr>
  801017:	89 04 24             	mov    %eax,(%esp)
  80101a:	e8 76 f4 ff ff       	call   800495 <flush_block>
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  80101f:	83 c3 01             	add    $0x1,%ebx
  801022:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  801028:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  80102e:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  801034:	85 c9                	test   %ecx,%ecx
  801036:	0f 49 c1             	cmovns %ecx,%eax
  801039:	c1 f8 0c             	sar    $0xc,%eax
  80103c:	39 c3                	cmp    %eax,%ebx
  80103e:	7c ab                	jl     800feb <file_flush+0x12>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801040:	89 34 24             	mov    %esi,(%esp)
  801043:	e8 4d f4 ff ff       	call   800495 <flush_block>
	if (f->f_indirect)
  801048:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  80104e:	85 c0                	test   %eax,%eax
  801050:	74 10                	je     801062 <file_flush+0x89>
		flush_block(diskaddr(f->f_indirect));
  801052:	89 04 24             	mov    %eax,(%esp)
  801055:	e8 af f3 ff ff       	call   800409 <diskaddr>
  80105a:	89 04 24             	mov    %eax,(%esp)
  80105d:	e8 33 f4 ff ff       	call   800495 <flush_block>
}
  801062:	83 c4 20             	add    $0x20,%esp
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
  80106f:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801075:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80107b:	89 04 24             	mov    %eax,(%esp)
  80107e:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  801084:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	e8 bb fa ff ff       	call   800b4d <walk_path>
  801092:	89 c2                	mov    %eax,%edx
  801094:	85 c0                	test   %eax,%eax
  801096:	0f 84 e0 00 00 00    	je     80117c <file_create+0x113>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  80109c:	83 fa f5             	cmp    $0xfffffff5,%edx
  80109f:	0f 85 1b 01 00 00    	jne    8011c0 <file_create+0x157>
  8010a5:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  8010ab:	85 f6                	test   %esi,%esi
  8010ad:	0f 84 d0 00 00 00    	je     801183 <file_create+0x11a>
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8010b3:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  8010b9:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8010be:	74 24                	je     8010e4 <file_create+0x7b>
  8010c0:	c7 44 24 0c 34 46 80 	movl   $0x804634,0xc(%esp)
  8010c7:	00 
  8010c8:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  8010cf:	00 
  8010d0:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  8010d7:	00 
  8010d8:	c7 04 24 9c 45 80 00 	movl   $0x80459c,(%esp)
  8010df:	e8 dd 0b 00 00       	call   801cc1 <_panic>
	nblock = dir->f_size / BLKSIZE;
  8010e4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	0f 48 c2             	cmovs  %edx,%eax
  8010ef:	c1 f8 0c             	sar    $0xc,%eax
  8010f2:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  8010f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010fd:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  801103:	eb 3d                	jmp    801142 <file_create+0xd9>
  801105:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801109:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80110d:	89 34 24             	mov    %esi,(%esp)
  801110:	e8 ac f9 ff ff       	call   800ac1 <file_get_block>
  801115:	85 c0                	test   %eax,%eax
  801117:	0f 88 a3 00 00 00    	js     8011c0 <file_create+0x157>
  80111d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
			return r;
		f = (struct File*) blk;
  801123:	ba 10 00 00 00       	mov    $0x10,%edx
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  801128:	80 38 00             	cmpb   $0x0,(%eax)
  80112b:	75 08                	jne    801135 <file_create+0xcc>
				*file = &f[j];
  80112d:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  801133:	eb 55                	jmp    80118a <file_create+0x121>
  801135:	05 00 01 00 00       	add    $0x100,%eax
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  80113a:	83 ea 01             	sub    $0x1,%edx
  80113d:	75 e9                	jne    801128 <file_create+0xbf>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  80113f:	83 c3 01             	add    $0x1,%ebx
  801142:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  801148:	75 bb                	jne    801105 <file_create+0x9c>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  80114a:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  801151:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801154:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  80115a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80115e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801162:	89 34 24             	mov    %esi,(%esp)
  801165:	e8 57 f9 ff ff       	call   800ac1 <file_get_block>
  80116a:	85 c0                	test   %eax,%eax
  80116c:	78 52                	js     8011c0 <file_create+0x157>
		return r;
	f = (struct File*) blk;
	*file = &f[0];
  80116e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801174:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  80117a:	eb 0e                	jmp    80118a <file_create+0x121>
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
		return -E_FILE_EXISTS;
  80117c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801181:	eb 3d                	jmp    8011c0 <file_create+0x157>
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
  801183:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  801188:	eb 36                	jmp    8011c0 <file_create+0x157>
	if ((r = dir_alloc_file(dir, &f)) < 0)
		return r;

	strcpy(f->f_name, name);
  80118a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801190:	89 44 24 04          	mov    %eax,0x4(%esp)
  801194:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80119a:	89 04 24             	mov    %eax,(%esp)
  80119d:	e8 45 12 00 00       	call   8023e7 <strcpy>
	*pf = f;
  8011a2:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  8011ad:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8011b3:	89 04 24             	mov    %eax,(%esp)
  8011b6:	e8 1e fe ff ff       	call   800fd9 <file_flush>
	return 0;
  8011bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c0:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  8011c6:	5b                   	pop    %ebx
  8011c7:	5e                   	pop    %esi
  8011c8:	5f                   	pop    %edi
  8011c9:	5d                   	pop    %ebp
  8011ca:	c3                   	ret    

008011cb <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	53                   	push   %ebx
  8011cf:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8011d2:	bb 01 00 00 00       	mov    $0x1,%ebx
  8011d7:	eb 13                	jmp    8011ec <fs_sync+0x21>
		flush_block(diskaddr(i));
  8011d9:	89 1c 24             	mov    %ebx,(%esp)
  8011dc:	e8 28 f2 ff ff       	call   800409 <diskaddr>
  8011e1:	89 04 24             	mov    %eax,(%esp)
  8011e4:	e8 ac f2 ff ff       	call   800495 <flush_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8011e9:	83 c3 01             	add    $0x1,%ebx
  8011ec:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8011f1:	3b 58 04             	cmp    0x4(%eax),%ebx
  8011f4:	72 e3                	jb     8011d9 <fs_sync+0xe>
		flush_block(diskaddr(i));
}
  8011f6:	83 c4 14             	add    $0x14,%esp
  8011f9:	5b                   	pop    %ebx
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    
  8011fc:	66 90                	xchg   %ax,%ax
  8011fe:	66 90                	xchg   %ax,%ax

00801200 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801206:	e8 c0 ff ff ff       	call   8011cb <fs_sync>
	return 0;
}
  80120b:	b8 00 00 00 00       	mov    $0x0,%eax
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	ba 60 50 80 00       	mov    $0x805060,%edx
	int i;
	uintptr_t va = FILEVA;
  80121a:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80121f:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801224:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801226:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801229:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80122f:	83 c0 01             	add    $0x1,%eax
  801232:	83 c2 10             	add    $0x10,%edx
  801235:	3d 00 04 00 00       	cmp    $0x400,%eax
  80123a:	75 e8                	jne    801224 <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    

0080123e <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	56                   	push   %esi
  801242:	53                   	push   %ebx
  801243:	83 ec 10             	sub    $0x10,%esp
  801246:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801249:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124e:	89 d8                	mov    %ebx,%eax
  801250:	c1 e0 04             	shl    $0x4,%eax
		switch (pageref(opentab[i].o_fd)) {
  801253:	8b 80 6c 50 80 00    	mov    0x80506c(%eax),%eax
  801259:	89 04 24             	mov    %eax,(%esp)
  80125c:	e8 f0 23 00 00       	call   803651 <pageref>
  801261:	85 c0                	test   %eax,%eax
  801263:	74 0d                	je     801272 <openfile_alloc+0x34>
  801265:	83 f8 01             	cmp    $0x1,%eax
  801268:	74 31                	je     80129b <openfile_alloc+0x5d>
  80126a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801270:	eb 62                	jmp    8012d4 <openfile_alloc+0x96>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801272:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801279:	00 
  80127a:	89 d8                	mov    %ebx,%eax
  80127c:	c1 e0 04             	shl    $0x4,%eax
  80127f:	8b 80 6c 50 80 00    	mov    0x80506c(%eax),%eax
  801285:	89 44 24 04          	mov    %eax,0x4(%esp)
  801289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801290:	e8 6e 15 00 00       	call   802803 <sys_page_alloc>
  801295:	89 c2                	mov    %eax,%edx
  801297:	85 d2                	test   %edx,%edx
  801299:	78 4d                	js     8012e8 <openfile_alloc+0xaa>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  80129b:	c1 e3 04             	shl    $0x4,%ebx
  80129e:	8d 83 60 50 80 00    	lea    0x805060(%ebx),%eax
  8012a4:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  8012ab:	04 00 00 
			*o = &opentab[i];
  8012ae:	89 06                	mov    %eax,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8012b0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012b7:	00 
  8012b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8012bf:	00 
  8012c0:	8b 83 6c 50 80 00    	mov    0x80506c(%ebx),%eax
  8012c6:	89 04 24             	mov    %eax,(%esp)
  8012c9:	e8 69 12 00 00       	call   802537 <memset>
			return (*o)->o_fileid;
  8012ce:	8b 06                	mov    (%esi),%eax
  8012d0:	8b 00                	mov    (%eax),%eax
  8012d2:	eb 14                	jmp    8012e8 <openfile_alloc+0xaa>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8012d4:	83 c3 01             	add    $0x1,%ebx
  8012d7:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8012dd:	0f 85 6b ff ff ff    	jne    80124e <openfile_alloc+0x10>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  8012e3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	57                   	push   %edi
  8012f3:	56                   	push   %esi
  8012f4:	53                   	push   %ebx
  8012f5:	83 ec 1c             	sub    $0x1c,%esp
  8012f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8012fb:	89 de                	mov    %ebx,%esi
  8012fd:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801303:	c1 e6 04             	shl    $0x4,%esi
  801306:	8d be 60 50 80 00    	lea    0x805060(%esi),%edi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  80130c:	8b 86 6c 50 80 00    	mov    0x80506c(%esi),%eax
  801312:	89 04 24             	mov    %eax,(%esp)
  801315:	e8 37 23 00 00       	call   803651 <pageref>
  80131a:	83 f8 01             	cmp    $0x1,%eax
  80131d:	7e 14                	jle    801333 <openfile_lookup+0x44>
  80131f:	39 9e 60 50 80 00    	cmp    %ebx,0x805060(%esi)
  801325:	75 13                	jne    80133a <openfile_lookup+0x4b>
		return -E_INVAL;
	*po = o;
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	89 38                	mov    %edi,(%eax)
	return 0;
  80132c:	b8 00 00 00 00       	mov    $0x0,%eax
  801331:	eb 0c                	jmp    80133f <openfile_lookup+0x50>
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
		return -E_INVAL;
  801333:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801338:	eb 05                	jmp    80133f <openfile_lookup+0x50>
  80133a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	*po = o;
	return 0;
}
  80133f:	83 c4 1c             	add    $0x1c,%esp
  801342:	5b                   	pop    %ebx
  801343:	5e                   	pop    %esi
  801344:	5f                   	pop    %edi
  801345:	5d                   	pop    %ebp
  801346:	c3                   	ret    

00801347 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	53                   	push   %ebx
  80134b:	83 ec 24             	sub    $0x24,%esp
  80134e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801351:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801354:	89 44 24 08          	mov    %eax,0x8(%esp)
  801358:	8b 03                	mov    (%ebx),%eax
  80135a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	89 04 24             	mov    %eax,(%esp)
  801364:	e8 86 ff ff ff       	call   8012ef <openfile_lookup>
  801369:	89 c2                	mov    %eax,%edx
  80136b:	85 d2                	test   %edx,%edx
  80136d:	78 15                	js     801384 <serve_set_size+0x3d>
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80136f:	8b 43 04             	mov    0x4(%ebx),%eax
  801372:	89 44 24 04          	mov    %eax,0x4(%esp)
  801376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801379:	8b 40 04             	mov    0x4(%eax),%eax
  80137c:	89 04 24             	mov    %eax,(%esp)
  80137f:	e8 d2 fa ff ff       	call   800e56 <file_set_size>
}
  801384:	83 c4 24             	add    $0x24,%esp
  801387:	5b                   	pop    %ebx
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	53                   	push   %ebx
  80138e:	83 ec 24             	sub    $0x24,%esp
  801391:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	struct OpenFile *of;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0){
  801394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801397:	89 44 24 08          	mov    %eax,0x8(%esp)
  80139b:	8b 03                	mov    (%ebx),%eax
  80139d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	89 04 24             	mov    %eax,(%esp)
  8013a7:	e8 43 ff ff ff       	call   8012ef <openfile_lookup>
		return r;
  8013ac:	89 c2                	mov    %eax,%edx
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	struct OpenFile *of;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0){
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 41                	js     8013f3 <serve_read+0x69>
		return r;
	}
	int req_n = req->req_n > BLKSIZE ? BLKSIZE : req->req_n;
	if ((r = file_read(of->o_file, ret->ret_buf, req_n, of->o_fd->fd_offset)) >= 0){
  8013b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8013b8:	8b 52 04             	mov    0x4(%edx),%edx
  8013bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
	struct OpenFile *of;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0){
		return r;
	}
	int req_n = req->req_n > BLKSIZE ? BLKSIZE : req->req_n;
  8013bf:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  8013c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013cb:	0f 46 53 04          	cmovbe 0x4(%ebx),%edx
	if ((r = file_read(of->o_file, ret->ret_buf, req_n, of->o_fd->fd_offset)) >= 0){
  8013cf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013d7:	8b 40 04             	mov    0x4(%eax),%eax
  8013da:	89 04 24             	mov    %eax,(%esp)
  8013dd:	e8 c4 f9 ff ff       	call   800da6 <file_read>
		of->o_fd->fd_offset += r;
	}
	
	return r;
  8013e2:	89 c2                	mov    %eax,%edx
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0){
		return r;
	}
	int req_n = req->req_n > BLKSIZE ? BLKSIZE : req->req_n;
	if ((r = file_read(of->o_file, ret->ret_buf, req_n, of->o_fd->fd_offset)) >= 0){
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 0b                	js     8013f3 <serve_read+0x69>
		of->o_fd->fd_offset += r;
  8013e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013eb:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ee:	01 42 04             	add    %eax,0x4(%edx)
	}
	
	return r;
  8013f1:	89 c2                	mov    %eax,%edx
}
  8013f3:	89 d0                	mov    %edx,%eax
  8013f5:	83 c4 24             	add    $0x24,%esp
  8013f8:	5b                   	pop    %ebx
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    

008013fb <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	53                   	push   %ebx
  8013ff:	83 ec 24             	sub    $0x24,%esp
  801402:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	struct OpenFile *of;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0){
  801405:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801408:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140c:	8b 03                	mov    (%ebx),%eax
  80140e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	89 04 24             	mov    %eax,(%esp)
  801418:	e8 d2 fe ff ff       	call   8012ef <openfile_lookup>
		return r;
  80141d:	89 c2                	mov    %eax,%edx
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	struct OpenFile *of;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0){
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 44                	js     801467 <serve_write+0x6c>
		return r;
	}

	int req_n = req->req_n > BLKSIZE ? BLKSIZE : req->req_n;
	if ((r = file_write(of->o_file, req->req_buf, req_n, of->o_fd->fd_offset)) >= 0){
  801423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801426:	8b 50 0c             	mov    0xc(%eax),%edx
  801429:	8b 52 04             	mov    0x4(%edx),%edx
  80142c:	89 54 24 0c          	mov    %edx,0xc(%esp)
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0){
		return r;
	}

	int req_n = req->req_n > BLKSIZE ? BLKSIZE : req->req_n;
  801430:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  801437:	ba 00 10 00 00       	mov    $0x1000,%edx
  80143c:	0f 46 53 04          	cmovbe 0x4(%ebx),%edx
	if ((r = file_write(of->o_file, req->req_buf, req_n, of->o_fd->fd_offset)) >= 0){
  801440:	89 54 24 08          	mov    %edx,0x8(%esp)
  801444:	83 c3 08             	add    $0x8,%ebx
  801447:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80144b:	8b 40 04             	mov    0x4(%eax),%eax
  80144e:	89 04 24             	mov    %eax,(%esp)
  801451:	e8 d3 fa ff ff       	call   800f29 <file_write>
		of->o_fd->fd_offset += r;
	}
	
	return r;
  801456:	89 c2                	mov    %eax,%edx
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0){
		return r;
	}

	int req_n = req->req_n > BLKSIZE ? BLKSIZE : req->req_n;
	if ((r = file_write(of->o_file, req->req_buf, req_n, of->o_fd->fd_offset)) >= 0){
  801458:	85 c0                	test   %eax,%eax
  80145a:	78 0b                	js     801467 <serve_write+0x6c>
		of->o_fd->fd_offset += r;
  80145c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145f:	8b 52 0c             	mov    0xc(%edx),%edx
  801462:	01 42 04             	add    %eax,0x4(%edx)
	}
	
	return r;
  801465:	89 c2                	mov    %eax,%edx
}
  801467:	89 d0                	mov    %edx,%eax
  801469:	83 c4 24             	add    $0x24,%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5d                   	pop    %ebp
  80146e:	c3                   	ret    

0080146f <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	53                   	push   %ebx
  801473:	83 ec 24             	sub    $0x24,%esp
  801476:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801479:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801480:	8b 03                	mov    (%ebx),%eax
  801482:	89 44 24 04          	mov    %eax,0x4(%esp)
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	89 04 24             	mov    %eax,(%esp)
  80148c:	e8 5e fe ff ff       	call   8012ef <openfile_lookup>
  801491:	89 c2                	mov    %eax,%edx
  801493:	85 d2                	test   %edx,%edx
  801495:	78 3f                	js     8014d6 <serve_stat+0x67>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  801497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149a:	8b 40 04             	mov    0x4(%eax),%eax
  80149d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a1:	89 1c 24             	mov    %ebx,(%esp)
  8014a4:	e8 3e 0f 00 00       	call   8023e7 <strcpy>
	ret->ret_size = o->o_file->f_size;
  8014a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ac:	8b 50 04             	mov    0x4(%eax),%edx
  8014af:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8014b5:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8014bb:	8b 40 04             	mov    0x4(%eax),%eax
  8014be:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8014c5:	0f 94 c0             	sete   %al
  8014c8:	0f b6 c0             	movzbl %al,%eax
  8014cb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d6:	83 c4 24             	add    $0x24,%esp
  8014d9:	5b                   	pop    %ebx
  8014da:	5d                   	pop    %ebp
  8014db:	c3                   	ret    

008014dc <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ec:	8b 00                	mov    (%eax),%eax
  8014ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	89 04 24             	mov    %eax,(%esp)
  8014f8:	e8 f2 fd ff ff       	call   8012ef <openfile_lookup>
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	85 d2                	test   %edx,%edx
  801501:	78 13                	js     801516 <serve_flush+0x3a>
		return r;
	file_flush(o->o_file);
  801503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801506:	8b 40 04             	mov    0x4(%eax),%eax
  801509:	89 04 24             	mov    %eax,(%esp)
  80150c:	e8 c8 fa ff ff       	call   800fd9 <file_flush>
	return 0;
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	53                   	push   %ebx
  80151c:	81 ec 24 04 00 00    	sub    $0x424,%esp
  801522:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  801525:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  80152c:	00 
  80152d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801531:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	e8 45 10 00 00       	call   802584 <memmove>
	path[MAXPATHLEN-1] = 0;
  80153f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  801543:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801549:	89 04 24             	mov    %eax,(%esp)
  80154c:	e8 ed fc ff ff       	call   80123e <openfile_alloc>
  801551:	85 c0                	test   %eax,%eax
  801553:	0f 88 f2 00 00 00    	js     80164b <serve_open+0x133>
		return r;
	}
	fileid = r;

	// Open the file
	if (req->req_omode & O_CREAT) {
  801559:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  801560:	74 34                	je     801596 <serve_open+0x7e>
		if ((r = file_create(path, &f)) < 0) {
  801562:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801568:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156c:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801572:	89 04 24             	mov    %eax,(%esp)
  801575:	e8 ef fa ff ff       	call   801069 <file_create>
  80157a:	89 c2                	mov    %eax,%edx
  80157c:	85 c0                	test   %eax,%eax
  80157e:	79 36                	jns    8015b6 <serve_open+0x9e>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  801580:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801587:	0f 85 be 00 00 00    	jne    80164b <serve_open+0x133>
  80158d:	83 fa f3             	cmp    $0xfffffff3,%edx
  801590:	0f 85 b5 00 00 00    	jne    80164b <serve_open+0x133>
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  801596:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80159c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a0:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015a6:	89 04 24             	mov    %eax,(%esp)
  8015a9:	e8 d9 f7 ff ff       	call   800d87 <file_open>
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	0f 88 95 00 00 00    	js     80164b <serve_open+0x133>
			return r;
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  8015b6:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8015bd:	74 1a                	je     8015d9 <serve_open+0xc1>
		if ((r = file_set_size(f, 0)) < 0) {
  8015bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015c6:	00 
  8015c7:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  8015cd:	89 04 24             	mov    %eax,(%esp)
  8015d0:	e8 81 f8 ff ff       	call   800e56 <file_set_size>
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 72                	js     80164b <serve_open+0x133>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
		}
	}
	if ((r = file_open(path, &f)) < 0) {
  8015d9:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e3:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015e9:	89 04 24             	mov    %eax,(%esp)
  8015ec:	e8 96 f7 ff ff       	call   800d87 <file_open>
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 56                	js     80164b <serve_open+0x133>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  8015f5:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015fb:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801601:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  801604:	8b 50 0c             	mov    0xc(%eax),%edx
  801607:	8b 08                	mov    (%eax),%ecx
  801609:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80160c:	8b 50 0c             	mov    0xc(%eax),%edx
  80160f:	8b 8b 00 04 00 00    	mov    0x400(%ebx),%ecx
  801615:	83 e1 03             	and    $0x3,%ecx
  801618:	89 4a 08             	mov    %ecx,0x8(%edx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  80161b:	8b 40 0c             	mov    0xc(%eax),%eax
  80161e:	8b 15 64 90 80 00    	mov    0x809064,%edx
  801624:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801626:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80162c:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801632:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  801635:	8b 50 0c             	mov    0xc(%eax),%edx
  801638:	8b 45 10             	mov    0x10(%ebp),%eax
  80163b:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  80163d:	8b 45 14             	mov    0x14(%ebp),%eax
  801640:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164b:	81 c4 24 04 00 00    	add    $0x424,%esp
  801651:	5b                   	pop    %ebx
  801652:	5d                   	pop    %ebp
  801653:	c3                   	ret    

00801654 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	56                   	push   %esi
  801658:	53                   	push   %ebx
  801659:	83 ec 20             	sub    $0x20,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80165c:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80165f:	8d 75 f4             	lea    -0xc(%ebp),%esi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  801662:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801669:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80166d:	a1 44 50 80 00       	mov    0x805044,%eax
  801672:	89 44 24 04          	mov    %eax,0x4(%esp)
  801676:	89 34 24             	mov    %esi,(%esp)
  801679:	e8 62 16 00 00       	call   802ce0 <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  80167e:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801682:	75 15                	jne    801699 <serve+0x45>
			cprintf("Invalid request from %08x: no argument page\n",
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168b:	c7 04 24 70 46 80 00 	movl   $0x804670,(%esp)
  801692:	e8 23 07 00 00       	call   801dba <cprintf>
				whom);
			continue; // just leave it hanging...
  801697:	eb c9                	jmp    801662 <serve+0xe>
		}

		pg = NULL;
  801699:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8016a0:	83 f8 01             	cmp    $0x1,%eax
  8016a3:	75 21                	jne    8016c6 <serve+0x72>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8016a5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016b0:	a1 44 50 80 00       	mov    0x805044,%eax
  8016b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bc:	89 04 24             	mov    %eax,(%esp)
  8016bf:	e8 54 fe ff ff       	call   801518 <serve_open>
  8016c4:	eb 3f                	jmp    801705 <serve+0xb1>
		} else if (req < NHANDLERS && handlers[req]) {
  8016c6:	83 f8 08             	cmp    $0x8,%eax
  8016c9:	77 1e                	ja     8016e9 <serve+0x95>
  8016cb:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8016d2:	85 d2                	test   %edx,%edx
  8016d4:	74 13                	je     8016e9 <serve+0x95>
			r = handlers[req](whom, fsreq);
  8016d6:	a1 44 50 80 00       	mov    0x805044,%eax
  8016db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e2:	89 04 24             	mov    %eax,(%esp)
  8016e5:	ff d2                	call   *%edx
  8016e7:	eb 1c                	jmp    801705 <serve+0xb1>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f4:	c7 04 24 a0 46 80 00 	movl   $0x8046a0,(%esp)
  8016fb:	e8 ba 06 00 00       	call   801dba <cprintf>
			r = -E_INVAL;
  801700:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  801705:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801708:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80170c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80170f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801713:	89 44 24 04          	mov    %eax,0x4(%esp)
  801717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171a:	89 04 24             	mov    %eax,(%esp)
  80171d:	e8 12 16 00 00       	call   802d34 <ipc_send>
		sys_page_unmap(0, fsreq);
  801722:	a1 44 50 80 00       	mov    0x805044,%eax
  801727:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801732:	e8 73 11 00 00       	call   8028aa <sys_page_unmap>
  801737:	e9 26 ff ff ff       	jmp    801662 <serve+0xe>

0080173c <umain>:
	}
}

void
umain(int argc, char **argv)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801742:	c7 05 60 90 80 00 c3 	movl   $0x8046c3,0x809060
  801749:	46 80 00 
	cprintf("FS is running\n");
  80174c:	c7 04 24 c6 46 80 00 	movl   $0x8046c6,(%esp)
  801753:	e8 62 06 00 00       	call   801dba <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  801758:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  80175d:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801762:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801764:	c7 04 24 d5 46 80 00 	movl   $0x8046d5,(%esp)
  80176b:	e8 4a 06 00 00       	call   801dba <cprintf>

	serve_init();
  801770:	e8 9d fa ff ff       	call   801212 <serve_init>
	fs_init();
  801775:	e8 eb f2 ff ff       	call   800a65 <fs_init>
	serve();
  80177a:	e8 d5 fe ff ff       	call   801654 <serve>

0080177f <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	53                   	push   %ebx
  801783:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801786:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80178d:	00 
  80178e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  801795:	00 
  801796:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80179d:	e8 61 10 00 00       	call   802803 <sys_page_alloc>
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	79 20                	jns    8017c6 <fs_test+0x47>
		panic("sys_page_alloc: %e", r);
  8017a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017aa:	c7 44 24 08 e4 46 80 	movl   $0x8046e4,0x8(%esp)
  8017b1:	00 
  8017b2:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8017b9:	00 
  8017ba:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  8017c1:	e8 fb 04 00 00       	call   801cc1 <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8017c6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8017cd:	00 
  8017ce:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8017d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d7:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  8017de:	e8 a1 0d 00 00       	call   802584 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8017e3:	e8 77 f0 ff ff       	call   80085f <alloc_block>
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	79 20                	jns    80180c <fs_test+0x8d>
		panic("alloc_block: %e", r);
  8017ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017f0:	c7 44 24 08 01 47 80 	movl   $0x804701,0x8(%esp)
  8017f7:	00 
  8017f8:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8017ff:	00 
  801800:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801807:	e8 b5 04 00 00       	call   801cc1 <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  80180c:	8d 58 1f             	lea    0x1f(%eax),%ebx
  80180f:	85 c0                	test   %eax,%eax
  801811:	0f 49 d8             	cmovns %eax,%ebx
  801814:	c1 fb 05             	sar    $0x5,%ebx
  801817:	99                   	cltd   
  801818:	c1 ea 1b             	shr    $0x1b,%edx
  80181b:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  80181e:	83 e1 1f             	and    $0x1f,%ecx
  801821:	29 d1                	sub    %edx,%ecx
  801823:	ba 01 00 00 00       	mov    $0x1,%edx
  801828:	d3 e2                	shl    %cl,%edx
  80182a:	85 14 9d 00 10 00 00 	test   %edx,0x1000(,%ebx,4)
  801831:	75 24                	jne    801857 <fs_test+0xd8>
  801833:	c7 44 24 0c 11 47 80 	movl   $0x804711,0xc(%esp)
  80183a:	00 
  80183b:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801842:	00 
  801843:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80184a:	00 
  80184b:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801852:	e8 6a 04 00 00       	call   801cc1 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801857:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80185c:	85 14 98             	test   %edx,(%eax,%ebx,4)
  80185f:	74 24                	je     801885 <fs_test+0x106>
  801861:	c7 44 24 0c 8c 48 80 	movl   $0x80488c,0xc(%esp)
  801868:	00 
  801869:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801870:	00 
  801871:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  801878:	00 
  801879:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801880:	e8 3c 04 00 00       	call   801cc1 <_panic>
	cprintf("alloc_block is good\n");
  801885:	c7 04 24 2c 47 80 00 	movl   $0x80472c,(%esp)
  80188c:	e8 29 05 00 00       	call   801dba <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801891:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801894:	89 44 24 04          	mov    %eax,0x4(%esp)
  801898:	c7 04 24 41 47 80 00 	movl   $0x804741,(%esp)
  80189f:	e8 e3 f4 ff ff       	call   800d87 <file_open>
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	79 25                	jns    8018cd <fs_test+0x14e>
  8018a8:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8018ab:	74 40                	je     8018ed <fs_test+0x16e>
		panic("file_open /not-found: %e", r);
  8018ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018b1:	c7 44 24 08 4c 47 80 	movl   $0x80474c,0x8(%esp)
  8018b8:	00 
  8018b9:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8018c0:	00 
  8018c1:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  8018c8:	e8 f4 03 00 00       	call   801cc1 <_panic>
	else if (r == 0)
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	75 1c                	jne    8018ed <fs_test+0x16e>
		panic("file_open /not-found succeeded!");
  8018d1:	c7 44 24 08 ac 48 80 	movl   $0x8048ac,0x8(%esp)
  8018d8:	00 
  8018d9:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8018e0:	00 
  8018e1:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  8018e8:	e8 d4 03 00 00       	call   801cc1 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  8018ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f4:	c7 04 24 65 47 80 00 	movl   $0x804765,(%esp)
  8018fb:	e8 87 f4 ff ff       	call   800d87 <file_open>
  801900:	85 c0                	test   %eax,%eax
  801902:	79 20                	jns    801924 <fs_test+0x1a5>
		panic("file_open /newmotd: %e", r);
  801904:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801908:	c7 44 24 08 6e 47 80 	movl   $0x80476e,0x8(%esp)
  80190f:	00 
  801910:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801917:	00 
  801918:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  80191f:	e8 9d 03 00 00       	call   801cc1 <_panic>
	cprintf("file_open is good\n");
  801924:	c7 04 24 85 47 80 00 	movl   $0x804785,(%esp)
  80192b:	e8 8a 04 00 00       	call   801dba <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801930:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801933:	89 44 24 08          	mov    %eax,0x8(%esp)
  801937:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80193e:	00 
  80193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801942:	89 04 24             	mov    %eax,(%esp)
  801945:	e8 77 f1 ff ff       	call   800ac1 <file_get_block>
  80194a:	85 c0                	test   %eax,%eax
  80194c:	79 20                	jns    80196e <fs_test+0x1ef>
		panic("file_get_block: %e", r);
  80194e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801952:	c7 44 24 08 98 47 80 	movl   $0x804798,0x8(%esp)
  801959:	00 
  80195a:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801961:	00 
  801962:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801969:	e8 53 03 00 00       	call   801cc1 <_panic>
	if (strcmp(blk, msg) != 0)
  80196e:	c7 44 24 04 cc 48 80 	movl   $0x8048cc,0x4(%esp)
  801975:	00 
  801976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801979:	89 04 24             	mov    %eax,(%esp)
  80197c:	e8 1b 0b 00 00       	call   80249c <strcmp>
  801981:	85 c0                	test   %eax,%eax
  801983:	74 1c                	je     8019a1 <fs_test+0x222>
		panic("file_get_block returned wrong data");
  801985:	c7 44 24 08 f4 48 80 	movl   $0x8048f4,0x8(%esp)
  80198c:	00 
  80198d:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  801994:	00 
  801995:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  80199c:	e8 20 03 00 00       	call   801cc1 <_panic>
	cprintf("file_get_block is good\n");
  8019a1:	c7 04 24 ab 47 80 00 	movl   $0x8047ab,(%esp)
  8019a8:	e8 0d 04 00 00       	call   801dba <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  8019ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b0:	0f b6 10             	movzbl (%eax),%edx
  8019b3:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8019b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b8:	c1 e8 0c             	shr    $0xc,%eax
  8019bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019c2:	a8 40                	test   $0x40,%al
  8019c4:	75 24                	jne    8019ea <fs_test+0x26b>
  8019c6:	c7 44 24 0c c4 47 80 	movl   $0x8047c4,0xc(%esp)
  8019cd:	00 
  8019ce:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  8019d5:	00 
  8019d6:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8019dd:	00 
  8019de:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  8019e5:	e8 d7 02 00 00       	call   801cc1 <_panic>
	file_flush(f);
  8019ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ed:	89 04 24             	mov    %eax,(%esp)
  8019f0:	e8 e4 f5 ff ff       	call   800fd9 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f8:	c1 e8 0c             	shr    $0xc,%eax
  8019fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a02:	a8 40                	test   $0x40,%al
  801a04:	74 24                	je     801a2a <fs_test+0x2ab>
  801a06:	c7 44 24 0c c3 47 80 	movl   $0x8047c3,0xc(%esp)
  801a0d:	00 
  801a0e:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801a15:	00 
  801a16:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801a1d:	00 
  801a1e:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801a25:	e8 97 02 00 00       	call   801cc1 <_panic>
	cprintf("file_flush is good\n");
  801a2a:	c7 04 24 df 47 80 00 	movl   $0x8047df,(%esp)
  801a31:	e8 84 03 00 00       	call   801dba <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801a36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a3d:	00 
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	89 04 24             	mov    %eax,(%esp)
  801a44:	e8 0d f4 ff ff       	call   800e56 <file_set_size>
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	79 20                	jns    801a6d <fs_test+0x2ee>
		panic("file_set_size: %e", r);
  801a4d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a51:	c7 44 24 08 f3 47 80 	movl   $0x8047f3,0x8(%esp)
  801a58:	00 
  801a59:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801a60:	00 
  801a61:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801a68:	e8 54 02 00 00       	call   801cc1 <_panic>
	assert(f->f_direct[0] == 0);
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801a77:	74 24                	je     801a9d <fs_test+0x31e>
  801a79:	c7 44 24 0c 05 48 80 	movl   $0x804805,0xc(%esp)
  801a80:	00 
  801a81:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801a88:	00 
  801a89:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801a90:	00 
  801a91:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801a98:	e8 24 02 00 00       	call   801cc1 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a9d:	c1 e8 0c             	shr    $0xc,%eax
  801aa0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aa7:	a8 40                	test   $0x40,%al
  801aa9:	74 24                	je     801acf <fs_test+0x350>
  801aab:	c7 44 24 0c 19 48 80 	movl   $0x804819,0xc(%esp)
  801ab2:	00 
  801ab3:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801aba:	00 
  801abb:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801ac2:	00 
  801ac3:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801aca:	e8 f2 01 00 00       	call   801cc1 <_panic>
	cprintf("file_truncate is good\n");
  801acf:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801ad6:	e8 df 02 00 00       	call   801dba <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801adb:	c7 04 24 cc 48 80 00 	movl   $0x8048cc,(%esp)
  801ae2:	e8 c9 08 00 00       	call   8023b0 <strlen>
  801ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aee:	89 04 24             	mov    %eax,(%esp)
  801af1:	e8 60 f3 ff ff       	call   800e56 <file_set_size>
  801af6:	85 c0                	test   %eax,%eax
  801af8:	79 20                	jns    801b1a <fs_test+0x39b>
		panic("file_set_size 2: %e", r);
  801afa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801afe:	c7 44 24 08 4a 48 80 	movl   $0x80484a,0x8(%esp)
  801b05:	00 
  801b06:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801b0d:	00 
  801b0e:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801b15:	e8 a7 01 00 00       	call   801cc1 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1d:	89 c2                	mov    %eax,%edx
  801b1f:	c1 ea 0c             	shr    $0xc,%edx
  801b22:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b29:	f6 c2 40             	test   $0x40,%dl
  801b2c:	74 24                	je     801b52 <fs_test+0x3d3>
  801b2e:	c7 44 24 0c 19 48 80 	movl   $0x804819,0xc(%esp)
  801b35:	00 
  801b36:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801b3d:	00 
  801b3e:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801b45:	00 
  801b46:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801b4d:	e8 6f 01 00 00       	call   801cc1 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801b52:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b55:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b60:	00 
  801b61:	89 04 24             	mov    %eax,(%esp)
  801b64:	e8 58 ef ff ff       	call   800ac1 <file_get_block>
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	79 20                	jns    801b8d <fs_test+0x40e>
		panic("file_get_block 2: %e", r);
  801b6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b71:	c7 44 24 08 5e 48 80 	movl   $0x80485e,0x8(%esp)
  801b78:	00 
  801b79:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  801b80:	00 
  801b81:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801b88:	e8 34 01 00 00       	call   801cc1 <_panic>
	strcpy(blk, msg);
  801b8d:	c7 44 24 04 cc 48 80 	movl   $0x8048cc,0x4(%esp)
  801b94:	00 
  801b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b98:	89 04 24             	mov    %eax,(%esp)
  801b9b:	e8 47 08 00 00       	call   8023e7 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba3:	c1 e8 0c             	shr    $0xc,%eax
  801ba6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bad:	a8 40                	test   $0x40,%al
  801baf:	75 24                	jne    801bd5 <fs_test+0x456>
  801bb1:	c7 44 24 0c c4 47 80 	movl   $0x8047c4,0xc(%esp)
  801bb8:	00 
  801bb9:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801bc0:	00 
  801bc1:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  801bc8:	00 
  801bc9:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801bd0:	e8 ec 00 00 00       	call   801cc1 <_panic>
	file_flush(f);
  801bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd8:	89 04 24             	mov    %eax,(%esp)
  801bdb:	e8 f9 f3 ff ff       	call   800fd9 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be3:	c1 e8 0c             	shr    $0xc,%eax
  801be6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bed:	a8 40                	test   $0x40,%al
  801bef:	74 24                	je     801c15 <fs_test+0x496>
  801bf1:	c7 44 24 0c c3 47 80 	movl   $0x8047c3,0xc(%esp)
  801bf8:	00 
  801bf9:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801c00:	00 
  801c01:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  801c08:	00 
  801c09:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801c10:	e8 ac 00 00 00       	call   801cc1 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c18:	c1 e8 0c             	shr    $0xc,%eax
  801c1b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c22:	a8 40                	test   $0x40,%al
  801c24:	74 24                	je     801c4a <fs_test+0x4cb>
  801c26:	c7 44 24 0c 19 48 80 	movl   $0x804819,0xc(%esp)
  801c2d:	00 
  801c2e:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  801c35:	00 
  801c36:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  801c3d:	00 
  801c3e:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  801c45:	e8 77 00 00 00       	call   801cc1 <_panic>
	cprintf("file rewrite is good\n");
  801c4a:	c7 04 24 73 48 80 00 	movl   $0x804873,(%esp)
  801c51:	e8 64 01 00 00       	call   801dba <cprintf>
}
  801c56:	83 c4 24             	add    $0x24,%esp
  801c59:	5b                   	pop    %ebx
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    

00801c5c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	56                   	push   %esi
  801c60:	53                   	push   %ebx
  801c61:	83 ec 10             	sub    $0x10,%esp
  801c64:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c67:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  801c6a:	e8 56 0b 00 00       	call   8027c5 <sys_getenvid>
  801c6f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c74:	89 c2                	mov    %eax,%edx
  801c76:	c1 e2 07             	shl    $0x7,%edx
  801c79:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801c80:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801c85:	85 db                	test   %ebx,%ebx
  801c87:	7e 07                	jle    801c90 <libmain+0x34>
		binaryname = argv[0];
  801c89:	8b 06                	mov    (%esi),%eax
  801c8b:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801c90:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c94:	89 1c 24             	mov    %ebx,(%esp)
  801c97:	e8 a0 fa ff ff       	call   80173c <umain>

	// exit gracefully
	exit();
  801c9c:	e8 07 00 00 00       	call   801ca8 <exit>
}
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    

00801ca8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 18             	sub    $0x18,%esp
	close_all();
  801cae:	e8 07 13 00 00       	call   802fba <close_all>
	sys_env_destroy(0);
  801cb3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cba:	e8 b4 0a 00 00       	call   802773 <sys_env_destroy>
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	56                   	push   %esi
  801cc5:	53                   	push   %ebx
  801cc6:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801cc9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ccc:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801cd2:	e8 ee 0a 00 00       	call   8027c5 <sys_getenvid>
  801cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cda:	89 54 24 10          	mov    %edx,0x10(%esp)
  801cde:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ce5:	89 74 24 08          	mov    %esi,0x8(%esp)
  801ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ced:	c7 04 24 24 49 80 00 	movl   $0x804924,(%esp)
  801cf4:	e8 c1 00 00 00       	call   801dba <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801cf9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801d00:	89 04 24             	mov    %eax,(%esp)
  801d03:	e8 51 00 00 00       	call   801d59 <vcprintf>
	cprintf("\n");
  801d08:	c7 04 24 33 45 80 00 	movl   $0x804533,(%esp)
  801d0f:	e8 a6 00 00 00       	call   801dba <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d14:	cc                   	int3   
  801d15:	eb fd                	jmp    801d14 <_panic+0x53>

00801d17 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	53                   	push   %ebx
  801d1b:	83 ec 14             	sub    $0x14,%esp
  801d1e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801d21:	8b 13                	mov    (%ebx),%edx
  801d23:	8d 42 01             	lea    0x1(%edx),%eax
  801d26:	89 03                	mov    %eax,(%ebx)
  801d28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d2b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801d2f:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d34:	75 19                	jne    801d4f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801d36:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801d3d:	00 
  801d3e:	8d 43 08             	lea    0x8(%ebx),%eax
  801d41:	89 04 24             	mov    %eax,(%esp)
  801d44:	e8 ed 09 00 00       	call   802736 <sys_cputs>
		b->idx = 0;
  801d49:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801d4f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801d53:	83 c4 14             	add    $0x14,%esp
  801d56:	5b                   	pop    %ebx
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    

00801d59 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801d62:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d69:	00 00 00 
	b.cnt = 0;
  801d6c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d73:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d79:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d84:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8e:	c7 04 24 17 1d 80 00 	movl   $0x801d17,(%esp)
  801d95:	e8 b4 01 00 00       	call   801f4e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801d9a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801da0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801daa:	89 04 24             	mov    %eax,(%esp)
  801dad:	e8 84 09 00 00       	call   802736 <sys_cputs>

	return b.cnt;
}
  801db2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801dc0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	89 04 24             	mov    %eax,(%esp)
  801dcd:	e8 87 ff ff ff       	call   801d59 <vcprintf>
	va_end(ap);

	return cnt;
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    
  801dd4:	66 90                	xchg   %ax,%ax
  801dd6:	66 90                	xchg   %ax,%ax
  801dd8:	66 90                	xchg   %ax,%ax
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	66 90                	xchg   %ax,%ax
  801dde:	66 90                	xchg   %ax,%ax

00801de0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	57                   	push   %edi
  801de4:	56                   	push   %esi
  801de5:	53                   	push   %ebx
  801de6:	83 ec 3c             	sub    $0x3c,%esp
  801de9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dec:	89 d7                	mov    %edx,%edi
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	89 c3                	mov    %eax,%ebx
  801df9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801dfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801dff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801e02:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e0a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801e0d:	39 d9                	cmp    %ebx,%ecx
  801e0f:	72 05                	jb     801e16 <printnum+0x36>
  801e11:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801e14:	77 69                	ja     801e7f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801e16:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801e19:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801e1d:	83 ee 01             	sub    $0x1,%esi
  801e20:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e24:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e2c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	89 d6                	mov    %edx,%esi
  801e34:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e37:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801e3a:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e3e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e45:	89 04 24             	mov    %eax,(%esp)
  801e48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4f:	e8 7c 22 00 00       	call   8040d0 <__udivdi3>
  801e54:	89 d9                	mov    %ebx,%ecx
  801e56:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e5a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e5e:	89 04 24             	mov    %eax,(%esp)
  801e61:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e65:	89 fa                	mov    %edi,%edx
  801e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e6a:	e8 71 ff ff ff       	call   801de0 <printnum>
  801e6f:	eb 1b                	jmp    801e8c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801e71:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e75:	8b 45 18             	mov    0x18(%ebp),%eax
  801e78:	89 04 24             	mov    %eax,(%esp)
  801e7b:	ff d3                	call   *%ebx
  801e7d:	eb 03                	jmp    801e82 <printnum+0xa2>
  801e7f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801e82:	83 ee 01             	sub    $0x1,%esi
  801e85:	85 f6                	test   %esi,%esi
  801e87:	7f e8                	jg     801e71 <printnum+0x91>
  801e89:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801e8c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e90:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801e94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e97:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ea2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea5:	89 04 24             	mov    %eax,(%esp)
  801ea8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801eab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eaf:	e8 4c 23 00 00       	call   804200 <__umoddi3>
  801eb4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801eb8:	0f be 80 47 49 80 00 	movsbl 0x804947(%eax),%eax
  801ebf:	89 04 24             	mov    %eax,(%esp)
  801ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec5:	ff d0                	call   *%eax
}
  801ec7:	83 c4 3c             	add    $0x3c,%esp
  801eca:	5b                   	pop    %ebx
  801ecb:	5e                   	pop    %esi
  801ecc:	5f                   	pop    %edi
  801ecd:	5d                   	pop    %ebp
  801ece:	c3                   	ret    

00801ecf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801ed2:	83 fa 01             	cmp    $0x1,%edx
  801ed5:	7e 0e                	jle    801ee5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801ed7:	8b 10                	mov    (%eax),%edx
  801ed9:	8d 4a 08             	lea    0x8(%edx),%ecx
  801edc:	89 08                	mov    %ecx,(%eax)
  801ede:	8b 02                	mov    (%edx),%eax
  801ee0:	8b 52 04             	mov    0x4(%edx),%edx
  801ee3:	eb 22                	jmp    801f07 <getuint+0x38>
	else if (lflag)
  801ee5:	85 d2                	test   %edx,%edx
  801ee7:	74 10                	je     801ef9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801ee9:	8b 10                	mov    (%eax),%edx
  801eeb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801eee:	89 08                	mov    %ecx,(%eax)
  801ef0:	8b 02                	mov    (%edx),%eax
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef7:	eb 0e                	jmp    801f07 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801ef9:	8b 10                	mov    (%eax),%edx
  801efb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801efe:	89 08                	mov    %ecx,(%eax)
  801f00:	8b 02                	mov    (%edx),%eax
  801f02:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801f07:	5d                   	pop    %ebp
  801f08:	c3                   	ret    

00801f09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801f0f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801f13:	8b 10                	mov    (%eax),%edx
  801f15:	3b 50 04             	cmp    0x4(%eax),%edx
  801f18:	73 0a                	jae    801f24 <sprintputch+0x1b>
		*b->buf++ = ch;
  801f1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f1d:	89 08                	mov    %ecx,(%eax)
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	88 02                	mov    %al,(%edx)
}
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    

00801f26 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801f2c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801f2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f33:	8b 45 10             	mov    0x10(%ebp),%eax
  801f36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	89 04 24             	mov    %eax,(%esp)
  801f47:	e8 02 00 00 00       	call   801f4e <vprintfmt>
	va_end(ap);
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	57                   	push   %edi
  801f52:	56                   	push   %esi
  801f53:	53                   	push   %ebx
  801f54:	83 ec 3c             	sub    $0x3c,%esp
  801f57:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f5d:	eb 14                	jmp    801f73 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	0f 84 b3 03 00 00    	je     80231a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801f67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f6b:	89 04 24             	mov    %eax,(%esp)
  801f6e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f71:	89 f3                	mov    %esi,%ebx
  801f73:	8d 73 01             	lea    0x1(%ebx),%esi
  801f76:	0f b6 03             	movzbl (%ebx),%eax
  801f79:	83 f8 25             	cmp    $0x25,%eax
  801f7c:	75 e1                	jne    801f5f <vprintfmt+0x11>
  801f7e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801f82:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f89:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801f90:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801f97:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9c:	eb 1d                	jmp    801fbb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f9e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801fa0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801fa4:	eb 15                	jmp    801fbb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801fa6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801fa8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801fac:	eb 0d                	jmp    801fbb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801fae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fb1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801fb4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801fbb:	8d 5e 01             	lea    0x1(%esi),%ebx
  801fbe:	0f b6 0e             	movzbl (%esi),%ecx
  801fc1:	0f b6 c1             	movzbl %cl,%eax
  801fc4:	83 e9 23             	sub    $0x23,%ecx
  801fc7:	80 f9 55             	cmp    $0x55,%cl
  801fca:	0f 87 2a 03 00 00    	ja     8022fa <vprintfmt+0x3ac>
  801fd0:	0f b6 c9             	movzbl %cl,%ecx
  801fd3:	ff 24 8d c0 4a 80 00 	jmp    *0x804ac0(,%ecx,4)
  801fda:	89 de                	mov    %ebx,%esi
  801fdc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801fe1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801fe4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801fe8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801feb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801fee:	83 fb 09             	cmp    $0x9,%ebx
  801ff1:	77 36                	ja     802029 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ff3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ff6:	eb e9                	jmp    801fe1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffb:	8d 48 04             	lea    0x4(%eax),%ecx
  801ffe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  802001:	8b 00                	mov    (%eax),%eax
  802003:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802006:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  802008:	eb 22                	jmp    80202c <vprintfmt+0xde>
  80200a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80200d:	85 c9                	test   %ecx,%ecx
  80200f:	b8 00 00 00 00       	mov    $0x0,%eax
  802014:	0f 49 c1             	cmovns %ecx,%eax
  802017:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80201a:	89 de                	mov    %ebx,%esi
  80201c:	eb 9d                	jmp    801fbb <vprintfmt+0x6d>
  80201e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  802020:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  802027:	eb 92                	jmp    801fbb <vprintfmt+0x6d>
  802029:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80202c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802030:	79 89                	jns    801fbb <vprintfmt+0x6d>
  802032:	e9 77 ff ff ff       	jmp    801fae <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802037:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80203a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80203c:	e9 7a ff ff ff       	jmp    801fbb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802041:	8b 45 14             	mov    0x14(%ebp),%eax
  802044:	8d 50 04             	lea    0x4(%eax),%edx
  802047:	89 55 14             	mov    %edx,0x14(%ebp)
  80204a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80204e:	8b 00                	mov    (%eax),%eax
  802050:	89 04 24             	mov    %eax,(%esp)
  802053:	ff 55 08             	call   *0x8(%ebp)
			break;
  802056:	e9 18 ff ff ff       	jmp    801f73 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80205b:	8b 45 14             	mov    0x14(%ebp),%eax
  80205e:	8d 50 04             	lea    0x4(%eax),%edx
  802061:	89 55 14             	mov    %edx,0x14(%ebp)
  802064:	8b 00                	mov    (%eax),%eax
  802066:	99                   	cltd   
  802067:	31 d0                	xor    %edx,%eax
  802069:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80206b:	83 f8 12             	cmp    $0x12,%eax
  80206e:	7f 0b                	jg     80207b <vprintfmt+0x12d>
  802070:	8b 14 85 20 4c 80 00 	mov    0x804c20(,%eax,4),%edx
  802077:	85 d2                	test   %edx,%edx
  802079:	75 20                	jne    80209b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80207b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80207f:	c7 44 24 08 5f 49 80 	movl   $0x80495f,0x8(%esp)
  802086:	00 
  802087:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	89 04 24             	mov    %eax,(%esp)
  802091:	e8 90 fe ff ff       	call   801f26 <printfmt>
  802096:	e9 d8 fe ff ff       	jmp    801f73 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80209b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80209f:	c7 44 24 08 af 43 80 	movl   $0x8043af,0x8(%esp)
  8020a6:	00 
  8020a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	89 04 24             	mov    %eax,(%esp)
  8020b1:	e8 70 fe ff ff       	call   801f26 <printfmt>
  8020b6:	e9 b8 fe ff ff       	jmp    801f73 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8020be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8020c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c7:	8d 50 04             	lea    0x4(%eax),%edx
  8020ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8020cd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8020cf:	85 f6                	test   %esi,%esi
  8020d1:	b8 58 49 80 00       	mov    $0x804958,%eax
  8020d6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8020d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8020dd:	0f 84 97 00 00 00    	je     80217a <vprintfmt+0x22c>
  8020e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8020e7:	0f 8e 9b 00 00 00    	jle    802188 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8020ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020f1:	89 34 24             	mov    %esi,(%esp)
  8020f4:	e8 cf 02 00 00       	call   8023c8 <strnlen>
  8020f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8020fc:	29 c2                	sub    %eax,%edx
  8020fe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  802101:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  802105:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802108:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80210b:	8b 75 08             	mov    0x8(%ebp),%esi
  80210e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802111:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802113:	eb 0f                	jmp    802124 <vprintfmt+0x1d6>
					putch(padc, putdat);
  802115:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802119:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80211c:	89 04 24             	mov    %eax,(%esp)
  80211f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802121:	83 eb 01             	sub    $0x1,%ebx
  802124:	85 db                	test   %ebx,%ebx
  802126:	7f ed                	jg     802115 <vprintfmt+0x1c7>
  802128:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80212b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80212e:	85 d2                	test   %edx,%edx
  802130:	b8 00 00 00 00       	mov    $0x0,%eax
  802135:	0f 49 c2             	cmovns %edx,%eax
  802138:	29 c2                	sub    %eax,%edx
  80213a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80213d:	89 d7                	mov    %edx,%edi
  80213f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802142:	eb 50                	jmp    802194 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802144:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802148:	74 1e                	je     802168 <vprintfmt+0x21a>
  80214a:	0f be d2             	movsbl %dl,%edx
  80214d:	83 ea 20             	sub    $0x20,%edx
  802150:	83 fa 5e             	cmp    $0x5e,%edx
  802153:	76 13                	jbe    802168 <vprintfmt+0x21a>
					putch('?', putdat);
  802155:	8b 45 0c             	mov    0xc(%ebp),%eax
  802158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802163:	ff 55 08             	call   *0x8(%ebp)
  802166:	eb 0d                	jmp    802175 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80216f:	89 04 24             	mov    %eax,(%esp)
  802172:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802175:	83 ef 01             	sub    $0x1,%edi
  802178:	eb 1a                	jmp    802194 <vprintfmt+0x246>
  80217a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80217d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  802180:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802183:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802186:	eb 0c                	jmp    802194 <vprintfmt+0x246>
  802188:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80218b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80218e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802191:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802194:	83 c6 01             	add    $0x1,%esi
  802197:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80219b:	0f be c2             	movsbl %dl,%eax
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	74 27                	je     8021c9 <vprintfmt+0x27b>
  8021a2:	85 db                	test   %ebx,%ebx
  8021a4:	78 9e                	js     802144 <vprintfmt+0x1f6>
  8021a6:	83 eb 01             	sub    $0x1,%ebx
  8021a9:	79 99                	jns    802144 <vprintfmt+0x1f6>
  8021ab:	89 f8                	mov    %edi,%eax
  8021ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8021b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8021b3:	89 c3                	mov    %eax,%ebx
  8021b5:	eb 1a                	jmp    8021d1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8021b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8021c2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8021c4:	83 eb 01             	sub    $0x1,%ebx
  8021c7:	eb 08                	jmp    8021d1 <vprintfmt+0x283>
  8021c9:	89 fb                	mov    %edi,%ebx
  8021cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8021ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8021d1:	85 db                	test   %ebx,%ebx
  8021d3:	7f e2                	jg     8021b7 <vprintfmt+0x269>
  8021d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8021d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021db:	e9 93 fd ff ff       	jmp    801f73 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8021e0:	83 fa 01             	cmp    $0x1,%edx
  8021e3:	7e 16                	jle    8021fb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8021e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e8:	8d 50 08             	lea    0x8(%eax),%edx
  8021eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8021ee:	8b 50 04             	mov    0x4(%eax),%edx
  8021f1:	8b 00                	mov    (%eax),%eax
  8021f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8021f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8021f9:	eb 32                	jmp    80222d <vprintfmt+0x2df>
	else if (lflag)
  8021fb:	85 d2                	test   %edx,%edx
  8021fd:	74 18                	je     802217 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8021ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802202:	8d 50 04             	lea    0x4(%eax),%edx
  802205:	89 55 14             	mov    %edx,0x14(%ebp)
  802208:	8b 30                	mov    (%eax),%esi
  80220a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80220d:	89 f0                	mov    %esi,%eax
  80220f:	c1 f8 1f             	sar    $0x1f,%eax
  802212:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802215:	eb 16                	jmp    80222d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  802217:	8b 45 14             	mov    0x14(%ebp),%eax
  80221a:	8d 50 04             	lea    0x4(%eax),%edx
  80221d:	89 55 14             	mov    %edx,0x14(%ebp)
  802220:	8b 30                	mov    (%eax),%esi
  802222:	89 75 e0             	mov    %esi,-0x20(%ebp)
  802225:	89 f0                	mov    %esi,%eax
  802227:	c1 f8 1f             	sar    $0x1f,%eax
  80222a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80222d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802230:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  802233:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  802238:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80223c:	0f 89 80 00 00 00    	jns    8022c2 <vprintfmt+0x374>
				putch('-', putdat);
  802242:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802246:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80224d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  802250:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802253:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802256:	f7 d8                	neg    %eax
  802258:	83 d2 00             	adc    $0x0,%edx
  80225b:	f7 da                	neg    %edx
			}
			base = 10;
  80225d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802262:	eb 5e                	jmp    8022c2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802264:	8d 45 14             	lea    0x14(%ebp),%eax
  802267:	e8 63 fc ff ff       	call   801ecf <getuint>
			base = 10;
  80226c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  802271:	eb 4f                	jmp    8022c2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  802273:	8d 45 14             	lea    0x14(%ebp),%eax
  802276:	e8 54 fc ff ff       	call   801ecf <getuint>
			base = 8;
  80227b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  802280:	eb 40                	jmp    8022c2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  802282:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802286:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80228d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  802290:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802294:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80229b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80229e:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a1:	8d 50 04             	lea    0x4(%eax),%edx
  8022a4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8022ae:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8022b3:	eb 0d                	jmp    8022c2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8022b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8022b8:	e8 12 fc ff ff       	call   801ecf <getuint>
			base = 16;
  8022bd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8022c2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8022c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8022ca:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8022cd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8022d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d5:	89 04 24             	mov    %eax,(%esp)
  8022d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022dc:	89 fa                	mov    %edi,%edx
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	e8 fa fa ff ff       	call   801de0 <printnum>
			break;
  8022e6:	e9 88 fc ff ff       	jmp    801f73 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8022eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8022ef:	89 04 24             	mov    %eax,(%esp)
  8022f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8022f5:	e9 79 fc ff ff       	jmp    801f73 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8022fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8022fe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802305:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  802308:	89 f3                	mov    %esi,%ebx
  80230a:	eb 03                	jmp    80230f <vprintfmt+0x3c1>
  80230c:	83 eb 01             	sub    $0x1,%ebx
  80230f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  802313:	75 f7                	jne    80230c <vprintfmt+0x3be>
  802315:	e9 59 fc ff ff       	jmp    801f73 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80231a:	83 c4 3c             	add    $0x3c,%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5f                   	pop    %edi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    

00802322 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 28             	sub    $0x28,%esp
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80232e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802331:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802335:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802338:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 30                	je     802373 <vsnprintf+0x51>
  802343:	85 d2                	test   %edx,%edx
  802345:	7e 2c                	jle    802373 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802347:	8b 45 14             	mov    0x14(%ebp),%eax
  80234a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80234e:	8b 45 10             	mov    0x10(%ebp),%eax
  802351:	89 44 24 08          	mov    %eax,0x8(%esp)
  802355:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235c:	c7 04 24 09 1f 80 00 	movl   $0x801f09,(%esp)
  802363:	e8 e6 fb ff ff       	call   801f4e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	eb 05                	jmp    802378 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  802373:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802380:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802383:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802387:	8b 45 10             	mov    0x10(%ebp),%eax
  80238a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80238e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802391:	89 44 24 04          	mov    %eax,0x4(%esp)
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	89 04 24             	mov    %eax,(%esp)
  80239b:	e8 82 ff ff ff       	call   802322 <vsnprintf>
	va_end(ap);

	return rc;
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    
  8023a2:	66 90                	xchg   %ax,%ax
  8023a4:	66 90                	xchg   %ax,%ax
  8023a6:	66 90                	xchg   %ax,%ax
  8023a8:	66 90                	xchg   %ax,%ax
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bb:	eb 03                	jmp    8023c0 <strlen+0x10>
		n++;
  8023bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8023c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8023c4:	75 f7                	jne    8023bd <strlen+0xd>
		n++;
	return n;
}
  8023c6:	5d                   	pop    %ebp
  8023c7:	c3                   	ret    

008023c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	eb 03                	jmp    8023db <strnlen+0x13>
		n++;
  8023d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8023db:	39 d0                	cmp    %edx,%eax
  8023dd:	74 06                	je     8023e5 <strnlen+0x1d>
  8023df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8023e3:	75 f3                	jne    8023d8 <strnlen+0x10>
		n++;
	return n;
}
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    

008023e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	53                   	push   %ebx
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8023f1:	89 c2                	mov    %eax,%edx
  8023f3:	83 c2 01             	add    $0x1,%edx
  8023f6:	83 c1 01             	add    $0x1,%ecx
  8023f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8023fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  802400:	84 db                	test   %bl,%bl
  802402:	75 ef                	jne    8023f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  802404:	5b                   	pop    %ebx
  802405:	5d                   	pop    %ebp
  802406:	c3                   	ret    

00802407 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	53                   	push   %ebx
  80240b:	83 ec 08             	sub    $0x8,%esp
  80240e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802411:	89 1c 24             	mov    %ebx,(%esp)
  802414:	e8 97 ff ff ff       	call   8023b0 <strlen>
	strcpy(dst + len, src);
  802419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802420:	01 d8                	add    %ebx,%eax
  802422:	89 04 24             	mov    %eax,(%esp)
  802425:	e8 bd ff ff ff       	call   8023e7 <strcpy>
	return dst;
}
  80242a:	89 d8                	mov    %ebx,%eax
  80242c:	83 c4 08             	add    $0x8,%esp
  80242f:	5b                   	pop    %ebx
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    

00802432 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	56                   	push   %esi
  802436:	53                   	push   %ebx
  802437:	8b 75 08             	mov    0x8(%ebp),%esi
  80243a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80243d:	89 f3                	mov    %esi,%ebx
  80243f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802442:	89 f2                	mov    %esi,%edx
  802444:	eb 0f                	jmp    802455 <strncpy+0x23>
		*dst++ = *src;
  802446:	83 c2 01             	add    $0x1,%edx
  802449:	0f b6 01             	movzbl (%ecx),%eax
  80244c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80244f:	80 39 01             	cmpb   $0x1,(%ecx)
  802452:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802455:	39 da                	cmp    %ebx,%edx
  802457:	75 ed                	jne    802446 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802459:	89 f0                	mov    %esi,%eax
  80245b:	5b                   	pop    %ebx
  80245c:	5e                   	pop    %esi
  80245d:	5d                   	pop    %ebp
  80245e:	c3                   	ret    

0080245f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	8b 75 08             	mov    0x8(%ebp),%esi
  802467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80246d:	89 f0                	mov    %esi,%eax
  80246f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802473:	85 c9                	test   %ecx,%ecx
  802475:	75 0b                	jne    802482 <strlcpy+0x23>
  802477:	eb 1d                	jmp    802496 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802479:	83 c0 01             	add    $0x1,%eax
  80247c:	83 c2 01             	add    $0x1,%edx
  80247f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802482:	39 d8                	cmp    %ebx,%eax
  802484:	74 0b                	je     802491 <strlcpy+0x32>
  802486:	0f b6 0a             	movzbl (%edx),%ecx
  802489:	84 c9                	test   %cl,%cl
  80248b:	75 ec                	jne    802479 <strlcpy+0x1a>
  80248d:	89 c2                	mov    %eax,%edx
  80248f:	eb 02                	jmp    802493 <strlcpy+0x34>
  802491:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802493:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802496:	29 f0                	sub    %esi,%eax
}
  802498:	5b                   	pop    %ebx
  802499:	5e                   	pop    %esi
  80249a:	5d                   	pop    %ebp
  80249b:	c3                   	ret    

0080249c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8024a5:	eb 06                	jmp    8024ad <strcmp+0x11>
		p++, q++;
  8024a7:	83 c1 01             	add    $0x1,%ecx
  8024aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8024ad:	0f b6 01             	movzbl (%ecx),%eax
  8024b0:	84 c0                	test   %al,%al
  8024b2:	74 04                	je     8024b8 <strcmp+0x1c>
  8024b4:	3a 02                	cmp    (%edx),%al
  8024b6:	74 ef                	je     8024a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8024b8:	0f b6 c0             	movzbl %al,%eax
  8024bb:	0f b6 12             	movzbl (%edx),%edx
  8024be:	29 d0                	sub    %edx,%eax
}
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    

008024c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	53                   	push   %ebx
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024cc:	89 c3                	mov    %eax,%ebx
  8024ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8024d1:	eb 06                	jmp    8024d9 <strncmp+0x17>
		n--, p++, q++;
  8024d3:	83 c0 01             	add    $0x1,%eax
  8024d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8024d9:	39 d8                	cmp    %ebx,%eax
  8024db:	74 15                	je     8024f2 <strncmp+0x30>
  8024dd:	0f b6 08             	movzbl (%eax),%ecx
  8024e0:	84 c9                	test   %cl,%cl
  8024e2:	74 04                	je     8024e8 <strncmp+0x26>
  8024e4:	3a 0a                	cmp    (%edx),%cl
  8024e6:	74 eb                	je     8024d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8024e8:	0f b6 00             	movzbl (%eax),%eax
  8024eb:	0f b6 12             	movzbl (%edx),%edx
  8024ee:	29 d0                	sub    %edx,%eax
  8024f0:	eb 05                	jmp    8024f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8024f7:	5b                   	pop    %ebx
  8024f8:	5d                   	pop    %ebp
  8024f9:	c3                   	ret    

008024fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802504:	eb 07                	jmp    80250d <strchr+0x13>
		if (*s == c)
  802506:	38 ca                	cmp    %cl,%dl
  802508:	74 0f                	je     802519 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80250a:	83 c0 01             	add    $0x1,%eax
  80250d:	0f b6 10             	movzbl (%eax),%edx
  802510:	84 d2                	test   %dl,%dl
  802512:	75 f2                	jne    802506 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802514:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802519:	5d                   	pop    %ebp
  80251a:	c3                   	ret    

0080251b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802525:	eb 07                	jmp    80252e <strfind+0x13>
		if (*s == c)
  802527:	38 ca                	cmp    %cl,%dl
  802529:	74 0a                	je     802535 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80252b:	83 c0 01             	add    $0x1,%eax
  80252e:	0f b6 10             	movzbl (%eax),%edx
  802531:	84 d2                	test   %dl,%dl
  802533:	75 f2                	jne    802527 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802535:	5d                   	pop    %ebp
  802536:	c3                   	ret    

00802537 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	57                   	push   %edi
  80253b:	56                   	push   %esi
  80253c:	53                   	push   %ebx
  80253d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802540:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802543:	85 c9                	test   %ecx,%ecx
  802545:	74 36                	je     80257d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802547:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80254d:	75 28                	jne    802577 <memset+0x40>
  80254f:	f6 c1 03             	test   $0x3,%cl
  802552:	75 23                	jne    802577 <memset+0x40>
		c &= 0xFF;
  802554:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802558:	89 d3                	mov    %edx,%ebx
  80255a:	c1 e3 08             	shl    $0x8,%ebx
  80255d:	89 d6                	mov    %edx,%esi
  80255f:	c1 e6 18             	shl    $0x18,%esi
  802562:	89 d0                	mov    %edx,%eax
  802564:	c1 e0 10             	shl    $0x10,%eax
  802567:	09 f0                	or     %esi,%eax
  802569:	09 c2                	or     %eax,%edx
  80256b:	89 d0                	mov    %edx,%eax
  80256d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80256f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802572:	fc                   	cld    
  802573:	f3 ab                	rep stos %eax,%es:(%edi)
  802575:	eb 06                	jmp    80257d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257a:	fc                   	cld    
  80257b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80257d:	89 f8                	mov    %edi,%eax
  80257f:	5b                   	pop    %ebx
  802580:	5e                   	pop    %esi
  802581:	5f                   	pop    %edi
  802582:	5d                   	pop    %ebp
  802583:	c3                   	ret    

00802584 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	57                   	push   %edi
  802588:	56                   	push   %esi
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80258f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802592:	39 c6                	cmp    %eax,%esi
  802594:	73 35                	jae    8025cb <memmove+0x47>
  802596:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802599:	39 d0                	cmp    %edx,%eax
  80259b:	73 2e                	jae    8025cb <memmove+0x47>
		s += n;
		d += n;
  80259d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8025a0:	89 d6                	mov    %edx,%esi
  8025a2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8025a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8025aa:	75 13                	jne    8025bf <memmove+0x3b>
  8025ac:	f6 c1 03             	test   $0x3,%cl
  8025af:	75 0e                	jne    8025bf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8025b1:	83 ef 04             	sub    $0x4,%edi
  8025b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8025b7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8025ba:	fd                   	std    
  8025bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8025bd:	eb 09                	jmp    8025c8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8025bf:	83 ef 01             	sub    $0x1,%edi
  8025c2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8025c5:	fd                   	std    
  8025c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8025c8:	fc                   	cld    
  8025c9:	eb 1d                	jmp    8025e8 <memmove+0x64>
  8025cb:	89 f2                	mov    %esi,%edx
  8025cd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8025cf:	f6 c2 03             	test   $0x3,%dl
  8025d2:	75 0f                	jne    8025e3 <memmove+0x5f>
  8025d4:	f6 c1 03             	test   $0x3,%cl
  8025d7:	75 0a                	jne    8025e3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8025d9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8025dc:	89 c7                	mov    %eax,%edi
  8025de:	fc                   	cld    
  8025df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8025e1:	eb 05                	jmp    8025e8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8025e3:	89 c7                	mov    %eax,%edi
  8025e5:	fc                   	cld    
  8025e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8025e8:	5e                   	pop    %esi
  8025e9:	5f                   	pop    %edi
  8025ea:	5d                   	pop    %ebp
  8025eb:	c3                   	ret    

008025ec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8025f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	89 04 24             	mov    %eax,(%esp)
  802606:	e8 79 ff ff ff       	call   802584 <memmove>
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
  802610:	56                   	push   %esi
  802611:	53                   	push   %ebx
  802612:	8b 55 08             	mov    0x8(%ebp),%edx
  802615:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802618:	89 d6                	mov    %edx,%esi
  80261a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80261d:	eb 1a                	jmp    802639 <memcmp+0x2c>
		if (*s1 != *s2)
  80261f:	0f b6 02             	movzbl (%edx),%eax
  802622:	0f b6 19             	movzbl (%ecx),%ebx
  802625:	38 d8                	cmp    %bl,%al
  802627:	74 0a                	je     802633 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802629:	0f b6 c0             	movzbl %al,%eax
  80262c:	0f b6 db             	movzbl %bl,%ebx
  80262f:	29 d8                	sub    %ebx,%eax
  802631:	eb 0f                	jmp    802642 <memcmp+0x35>
		s1++, s2++;
  802633:	83 c2 01             	add    $0x1,%edx
  802636:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802639:	39 f2                	cmp    %esi,%edx
  80263b:	75 e2                	jne    80261f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802642:	5b                   	pop    %ebx
  802643:	5e                   	pop    %esi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    

00802646 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80264f:	89 c2                	mov    %eax,%edx
  802651:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802654:	eb 07                	jmp    80265d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802656:	38 08                	cmp    %cl,(%eax)
  802658:	74 07                	je     802661 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80265a:	83 c0 01             	add    $0x1,%eax
  80265d:	39 d0                	cmp    %edx,%eax
  80265f:	72 f5                	jb     802656 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    

00802663 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	57                   	push   %edi
  802667:	56                   	push   %esi
  802668:	53                   	push   %ebx
  802669:	8b 55 08             	mov    0x8(%ebp),%edx
  80266c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80266f:	eb 03                	jmp    802674 <strtol+0x11>
		s++;
  802671:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802674:	0f b6 0a             	movzbl (%edx),%ecx
  802677:	80 f9 09             	cmp    $0x9,%cl
  80267a:	74 f5                	je     802671 <strtol+0xe>
  80267c:	80 f9 20             	cmp    $0x20,%cl
  80267f:	74 f0                	je     802671 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802681:	80 f9 2b             	cmp    $0x2b,%cl
  802684:	75 0a                	jne    802690 <strtol+0x2d>
		s++;
  802686:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802689:	bf 00 00 00 00       	mov    $0x0,%edi
  80268e:	eb 11                	jmp    8026a1 <strtol+0x3e>
  802690:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802695:	80 f9 2d             	cmp    $0x2d,%cl
  802698:	75 07                	jne    8026a1 <strtol+0x3e>
		s++, neg = 1;
  80269a:	8d 52 01             	lea    0x1(%edx),%edx
  80269d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8026a1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8026a6:	75 15                	jne    8026bd <strtol+0x5a>
  8026a8:	80 3a 30             	cmpb   $0x30,(%edx)
  8026ab:	75 10                	jne    8026bd <strtol+0x5a>
  8026ad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8026b1:	75 0a                	jne    8026bd <strtol+0x5a>
		s += 2, base = 16;
  8026b3:	83 c2 02             	add    $0x2,%edx
  8026b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8026bb:	eb 10                	jmp    8026cd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	75 0c                	jne    8026cd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8026c1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8026c3:	80 3a 30             	cmpb   $0x30,(%edx)
  8026c6:	75 05                	jne    8026cd <strtol+0x6a>
		s++, base = 8;
  8026c8:	83 c2 01             	add    $0x1,%edx
  8026cb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8026cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026d2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8026d5:	0f b6 0a             	movzbl (%edx),%ecx
  8026d8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8026db:	89 f0                	mov    %esi,%eax
  8026dd:	3c 09                	cmp    $0x9,%al
  8026df:	77 08                	ja     8026e9 <strtol+0x86>
			dig = *s - '0';
  8026e1:	0f be c9             	movsbl %cl,%ecx
  8026e4:	83 e9 30             	sub    $0x30,%ecx
  8026e7:	eb 20                	jmp    802709 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8026e9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8026ec:	89 f0                	mov    %esi,%eax
  8026ee:	3c 19                	cmp    $0x19,%al
  8026f0:	77 08                	ja     8026fa <strtol+0x97>
			dig = *s - 'a' + 10;
  8026f2:	0f be c9             	movsbl %cl,%ecx
  8026f5:	83 e9 57             	sub    $0x57,%ecx
  8026f8:	eb 0f                	jmp    802709 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8026fa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8026fd:	89 f0                	mov    %esi,%eax
  8026ff:	3c 19                	cmp    $0x19,%al
  802701:	77 16                	ja     802719 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802703:	0f be c9             	movsbl %cl,%ecx
  802706:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802709:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80270c:	7d 0f                	jge    80271d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80270e:	83 c2 01             	add    $0x1,%edx
  802711:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802715:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802717:	eb bc                	jmp    8026d5 <strtol+0x72>
  802719:	89 d8                	mov    %ebx,%eax
  80271b:	eb 02                	jmp    80271f <strtol+0xbc>
  80271d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80271f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802723:	74 05                	je     80272a <strtol+0xc7>
		*endptr = (char *) s;
  802725:	8b 75 0c             	mov    0xc(%ebp),%esi
  802728:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80272a:	f7 d8                	neg    %eax
  80272c:	85 ff                	test   %edi,%edi
  80272e:	0f 44 c3             	cmove  %ebx,%eax
}
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5f                   	pop    %edi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    

00802736 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	57                   	push   %edi
  80273a:	56                   	push   %esi
  80273b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
  802741:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802744:	8b 55 08             	mov    0x8(%ebp),%edx
  802747:	89 c3                	mov    %eax,%ebx
  802749:	89 c7                	mov    %eax,%edi
  80274b:	89 c6                	mov    %eax,%esi
  80274d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    

00802754 <sys_cgetc>:

int
sys_cgetc(void)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	57                   	push   %edi
  802758:	56                   	push   %esi
  802759:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80275a:	ba 00 00 00 00       	mov    $0x0,%edx
  80275f:	b8 01 00 00 00       	mov    $0x1,%eax
  802764:	89 d1                	mov    %edx,%ecx
  802766:	89 d3                	mov    %edx,%ebx
  802768:	89 d7                	mov    %edx,%edi
  80276a:	89 d6                	mov    %edx,%esi
  80276c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80276e:	5b                   	pop    %ebx
  80276f:	5e                   	pop    %esi
  802770:	5f                   	pop    %edi
  802771:	5d                   	pop    %ebp
  802772:	c3                   	ret    

00802773 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	57                   	push   %edi
  802777:	56                   	push   %esi
  802778:	53                   	push   %ebx
  802779:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80277c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802781:	b8 03 00 00 00       	mov    $0x3,%eax
  802786:	8b 55 08             	mov    0x8(%ebp),%edx
  802789:	89 cb                	mov    %ecx,%ebx
  80278b:	89 cf                	mov    %ecx,%edi
  80278d:	89 ce                	mov    %ecx,%esi
  80278f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802791:	85 c0                	test   %eax,%eax
  802793:	7e 28                	jle    8027bd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  802795:	89 44 24 10          	mov    %eax,0x10(%esp)
  802799:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8027a0:	00 
  8027a1:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  8027a8:	00 
  8027a9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8027b0:	00 
  8027b1:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  8027b8:	e8 04 f5 ff ff       	call   801cc1 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8027bd:	83 c4 2c             	add    $0x2c,%esp
  8027c0:	5b                   	pop    %ebx
  8027c1:	5e                   	pop    %esi
  8027c2:	5f                   	pop    %edi
  8027c3:	5d                   	pop    %ebp
  8027c4:	c3                   	ret    

008027c5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	57                   	push   %edi
  8027c9:	56                   	push   %esi
  8027ca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8027d5:	89 d1                	mov    %edx,%ecx
  8027d7:	89 d3                	mov    %edx,%ebx
  8027d9:	89 d7                	mov    %edx,%edi
  8027db:	89 d6                	mov    %edx,%esi
  8027dd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8027df:	5b                   	pop    %ebx
  8027e0:	5e                   	pop    %esi
  8027e1:	5f                   	pop    %edi
  8027e2:	5d                   	pop    %ebp
  8027e3:	c3                   	ret    

008027e4 <sys_yield>:

void
sys_yield(void)
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	57                   	push   %edi
  8027e8:	56                   	push   %esi
  8027e9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ef:	b8 0b 00 00 00       	mov    $0xb,%eax
  8027f4:	89 d1                	mov    %edx,%ecx
  8027f6:	89 d3                	mov    %edx,%ebx
  8027f8:	89 d7                	mov    %edx,%edi
  8027fa:	89 d6                	mov    %edx,%esi
  8027fc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8027fe:	5b                   	pop    %ebx
  8027ff:	5e                   	pop    %esi
  802800:	5f                   	pop    %edi
  802801:	5d                   	pop    %ebp
  802802:	c3                   	ret    

00802803 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	57                   	push   %edi
  802807:	56                   	push   %esi
  802808:	53                   	push   %ebx
  802809:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80280c:	be 00 00 00 00       	mov    $0x0,%esi
  802811:	b8 04 00 00 00       	mov    $0x4,%eax
  802816:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802819:	8b 55 08             	mov    0x8(%ebp),%edx
  80281c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80281f:	89 f7                	mov    %esi,%edi
  802821:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802823:	85 c0                	test   %eax,%eax
  802825:	7e 28                	jle    80284f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  802827:	89 44 24 10          	mov    %eax,0x10(%esp)
  80282b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  802832:	00 
  802833:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  80283a:	00 
  80283b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802842:	00 
  802843:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  80284a:	e8 72 f4 ff ff       	call   801cc1 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80284f:	83 c4 2c             	add    $0x2c,%esp
  802852:	5b                   	pop    %ebx
  802853:	5e                   	pop    %esi
  802854:	5f                   	pop    %edi
  802855:	5d                   	pop    %ebp
  802856:	c3                   	ret    

00802857 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
  80285a:	57                   	push   %edi
  80285b:	56                   	push   %esi
  80285c:	53                   	push   %ebx
  80285d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802860:	b8 05 00 00 00       	mov    $0x5,%eax
  802865:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802868:	8b 55 08             	mov    0x8(%ebp),%edx
  80286b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80286e:	8b 7d 14             	mov    0x14(%ebp),%edi
  802871:	8b 75 18             	mov    0x18(%ebp),%esi
  802874:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802876:	85 c0                	test   %eax,%eax
  802878:	7e 28                	jle    8028a2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80287a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80287e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  802885:	00 
  802886:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  80288d:	00 
  80288e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802895:	00 
  802896:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  80289d:	e8 1f f4 ff ff       	call   801cc1 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8028a2:	83 c4 2c             	add    $0x2c,%esp
  8028a5:	5b                   	pop    %ebx
  8028a6:	5e                   	pop    %esi
  8028a7:	5f                   	pop    %edi
  8028a8:	5d                   	pop    %ebp
  8028a9:	c3                   	ret    

008028aa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
  8028ad:	57                   	push   %edi
  8028ae:	56                   	push   %esi
  8028af:	53                   	push   %ebx
  8028b0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028b8:	b8 06 00 00 00       	mov    $0x6,%eax
  8028bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c3:	89 df                	mov    %ebx,%edi
  8028c5:	89 de                	mov    %ebx,%esi
  8028c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	7e 28                	jle    8028f5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8028cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8028d1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8028d8:	00 
  8028d9:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  8028e0:	00 
  8028e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8028e8:	00 
  8028e9:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  8028f0:	e8 cc f3 ff ff       	call   801cc1 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8028f5:	83 c4 2c             	add    $0x2c,%esp
  8028f8:	5b                   	pop    %ebx
  8028f9:	5e                   	pop    %esi
  8028fa:	5f                   	pop    %edi
  8028fb:	5d                   	pop    %ebp
  8028fc:	c3                   	ret    

008028fd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
  802900:	57                   	push   %edi
  802901:	56                   	push   %esi
  802902:	53                   	push   %ebx
  802903:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802906:	bb 00 00 00 00       	mov    $0x0,%ebx
  80290b:	b8 08 00 00 00       	mov    $0x8,%eax
  802910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802913:	8b 55 08             	mov    0x8(%ebp),%edx
  802916:	89 df                	mov    %ebx,%edi
  802918:	89 de                	mov    %ebx,%esi
  80291a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80291c:	85 c0                	test   %eax,%eax
  80291e:	7e 28                	jle    802948 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802920:	89 44 24 10          	mov    %eax,0x10(%esp)
  802924:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80292b:	00 
  80292c:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  802933:	00 
  802934:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80293b:	00 
  80293c:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802943:	e8 79 f3 ff ff       	call   801cc1 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802948:	83 c4 2c             	add    $0x2c,%esp
  80294b:	5b                   	pop    %ebx
  80294c:	5e                   	pop    %esi
  80294d:	5f                   	pop    %edi
  80294e:	5d                   	pop    %ebp
  80294f:	c3                   	ret    

00802950 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	57                   	push   %edi
  802954:	56                   	push   %esi
  802955:	53                   	push   %ebx
  802956:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802959:	bb 00 00 00 00       	mov    $0x0,%ebx
  80295e:	b8 09 00 00 00       	mov    $0x9,%eax
  802963:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802966:	8b 55 08             	mov    0x8(%ebp),%edx
  802969:	89 df                	mov    %ebx,%edi
  80296b:	89 de                	mov    %ebx,%esi
  80296d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80296f:	85 c0                	test   %eax,%eax
  802971:	7e 28                	jle    80299b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802973:	89 44 24 10          	mov    %eax,0x10(%esp)
  802977:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80297e:	00 
  80297f:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  802986:	00 
  802987:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80298e:	00 
  80298f:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802996:	e8 26 f3 ff ff       	call   801cc1 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80299b:	83 c4 2c             	add    $0x2c,%esp
  80299e:	5b                   	pop    %ebx
  80299f:	5e                   	pop    %esi
  8029a0:	5f                   	pop    %edi
  8029a1:	5d                   	pop    %ebp
  8029a2:	c3                   	ret    

008029a3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
  8029a6:	57                   	push   %edi
  8029a7:	56                   	push   %esi
  8029a8:	53                   	push   %ebx
  8029a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8029b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bc:	89 df                	mov    %ebx,%edi
  8029be:	89 de                	mov    %ebx,%esi
  8029c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	7e 28                	jle    8029ee <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8029c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8029ca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8029d1:	00 
  8029d2:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  8029d9:	00 
  8029da:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8029e1:	00 
  8029e2:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  8029e9:	e8 d3 f2 ff ff       	call   801cc1 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8029ee:	83 c4 2c             	add    $0x2c,%esp
  8029f1:	5b                   	pop    %ebx
  8029f2:	5e                   	pop    %esi
  8029f3:	5f                   	pop    %edi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    

008029f6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8029f6:	55                   	push   %ebp
  8029f7:	89 e5                	mov    %esp,%ebp
  8029f9:	57                   	push   %edi
  8029fa:	56                   	push   %esi
  8029fb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029fc:	be 00 00 00 00       	mov    $0x0,%esi
  802a01:	b8 0c 00 00 00       	mov    $0xc,%eax
  802a06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a09:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  802a12:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802a14:	5b                   	pop    %ebx
  802a15:	5e                   	pop    %esi
  802a16:	5f                   	pop    %edi
  802a17:	5d                   	pop    %ebp
  802a18:	c3                   	ret    

00802a19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
  802a1c:	57                   	push   %edi
  802a1d:	56                   	push   %esi
  802a1e:	53                   	push   %ebx
  802a1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a22:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a27:	b8 0d 00 00 00       	mov    $0xd,%eax
  802a2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2f:	89 cb                	mov    %ecx,%ebx
  802a31:	89 cf                	mov    %ecx,%edi
  802a33:	89 ce                	mov    %ecx,%esi
  802a35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802a37:	85 c0                	test   %eax,%eax
  802a39:	7e 28                	jle    802a63 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a3f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  802a46:	00 
  802a47:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  802a4e:	00 
  802a4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a56:	00 
  802a57:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802a5e:	e8 5e f2 ff ff       	call   801cc1 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802a63:	83 c4 2c             	add    $0x2c,%esp
  802a66:	5b                   	pop    %ebx
  802a67:	5e                   	pop    %esi
  802a68:	5f                   	pop    %edi
  802a69:	5d                   	pop    %ebp
  802a6a:	c3                   	ret    

00802a6b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802a6b:	55                   	push   %ebp
  802a6c:	89 e5                	mov    %esp,%ebp
  802a6e:	57                   	push   %edi
  802a6f:	56                   	push   %esi
  802a70:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a71:	ba 00 00 00 00       	mov    $0x0,%edx
  802a76:	b8 0e 00 00 00       	mov    $0xe,%eax
  802a7b:	89 d1                	mov    %edx,%ecx
  802a7d:	89 d3                	mov    %edx,%ebx
  802a7f:	89 d7                	mov    %edx,%edi
  802a81:	89 d6                	mov    %edx,%esi
  802a83:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802a85:	5b                   	pop    %ebx
  802a86:	5e                   	pop    %esi
  802a87:	5f                   	pop    %edi
  802a88:	5d                   	pop    %ebp
  802a89:	c3                   	ret    

00802a8a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  802a8a:	55                   	push   %ebp
  802a8b:	89 e5                	mov    %esp,%ebp
  802a8d:	57                   	push   %edi
  802a8e:	56                   	push   %esi
  802a8f:	53                   	push   %ebx
  802a90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a93:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a98:	b8 0f 00 00 00       	mov    $0xf,%eax
  802a9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa3:	89 df                	mov    %ebx,%edi
  802aa5:	89 de                	mov    %ebx,%esi
  802aa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	7e 28                	jle    802ad5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802aad:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ab1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  802ab8:	00 
  802ab9:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  802ac0:	00 
  802ac1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802ac8:	00 
  802ac9:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802ad0:	e8 ec f1 ff ff       	call   801cc1 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  802ad5:	83 c4 2c             	add    $0x2c,%esp
  802ad8:	5b                   	pop    %ebx
  802ad9:	5e                   	pop    %esi
  802ada:	5f                   	pop    %edi
  802adb:	5d                   	pop    %ebp
  802adc:	c3                   	ret    

00802add <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  802add:	55                   	push   %ebp
  802ade:	89 e5                	mov    %esp,%ebp
  802ae0:	57                   	push   %edi
  802ae1:	56                   	push   %esi
  802ae2:	53                   	push   %ebx
  802ae3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ae6:	bb 00 00 00 00       	mov    $0x0,%ebx
  802aeb:	b8 10 00 00 00       	mov    $0x10,%eax
  802af0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802af3:	8b 55 08             	mov    0x8(%ebp),%edx
  802af6:	89 df                	mov    %ebx,%edi
  802af8:	89 de                	mov    %ebx,%esi
  802afa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802afc:	85 c0                	test   %eax,%eax
  802afe:	7e 28                	jle    802b28 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802b00:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b04:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  802b0b:	00 
  802b0c:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  802b13:	00 
  802b14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b1b:	00 
  802b1c:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802b23:	e8 99 f1 ff ff       	call   801cc1 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  802b28:	83 c4 2c             	add    $0x2c,%esp
  802b2b:	5b                   	pop    %ebx
  802b2c:	5e                   	pop    %esi
  802b2d:	5f                   	pop    %edi
  802b2e:	5d                   	pop    %ebp
  802b2f:	c3                   	ret    

00802b30 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	57                   	push   %edi
  802b34:	56                   	push   %esi
  802b35:	53                   	push   %ebx
  802b36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b39:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b3e:	b8 11 00 00 00       	mov    $0x11,%eax
  802b43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b46:	8b 55 08             	mov    0x8(%ebp),%edx
  802b49:	89 df                	mov    %ebx,%edi
  802b4b:	89 de                	mov    %ebx,%esi
  802b4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	7e 28                	jle    802b7b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802b53:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b57:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  802b5e:	00 
  802b5f:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  802b66:	00 
  802b67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b6e:	00 
  802b6f:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802b76:	e8 46 f1 ff ff       	call   801cc1 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  802b7b:	83 c4 2c             	add    $0x2c,%esp
  802b7e:	5b                   	pop    %ebx
  802b7f:	5e                   	pop    %esi
  802b80:	5f                   	pop    %edi
  802b81:	5d                   	pop    %ebp
  802b82:	c3                   	ret    

00802b83 <sys_sleep>:

int
sys_sleep(int channel)
{
  802b83:	55                   	push   %ebp
  802b84:	89 e5                	mov    %esp,%ebp
  802b86:	57                   	push   %edi
  802b87:	56                   	push   %esi
  802b88:	53                   	push   %ebx
  802b89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b91:	b8 12 00 00 00       	mov    $0x12,%eax
  802b96:	8b 55 08             	mov    0x8(%ebp),%edx
  802b99:	89 cb                	mov    %ecx,%ebx
  802b9b:	89 cf                	mov    %ecx,%edi
  802b9d:	89 ce                	mov    %ecx,%esi
  802b9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	7e 28                	jle    802bcd <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  802ba5:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ba9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  802bb0:	00 
  802bb1:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  802bb8:	00 
  802bb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802bc0:	00 
  802bc1:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802bc8:	e8 f4 f0 ff ff       	call   801cc1 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  802bcd:	83 c4 2c             	add    $0x2c,%esp
  802bd0:	5b                   	pop    %ebx
  802bd1:	5e                   	pop    %esi
  802bd2:	5f                   	pop    %edi
  802bd3:	5d                   	pop    %ebp
  802bd4:	c3                   	ret    

00802bd5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  802bd5:	55                   	push   %ebp
  802bd6:	89 e5                	mov    %esp,%ebp
  802bd8:	57                   	push   %edi
  802bd9:	56                   	push   %esi
  802bda:	53                   	push   %ebx
  802bdb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802bde:	bb 00 00 00 00       	mov    $0x0,%ebx
  802be3:	b8 13 00 00 00       	mov    $0x13,%eax
  802be8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802beb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bee:	89 df                	mov    %ebx,%edi
  802bf0:	89 de                	mov    %ebx,%esi
  802bf2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	7e 28                	jle    802c20 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802bf8:	89 44 24 10          	mov    %eax,0x10(%esp)
  802bfc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  802c03:	00 
  802c04:	c7 44 24 08 8b 4c 80 	movl   $0x804c8b,0x8(%esp)
  802c0b:	00 
  802c0c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802c13:	00 
  802c14:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802c1b:	e8 a1 f0 ff ff       	call   801cc1 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  802c20:	83 c4 2c             	add    $0x2c,%esp
  802c23:	5b                   	pop    %ebx
  802c24:	5e                   	pop    %esi
  802c25:	5f                   	pop    %edi
  802c26:	5d                   	pop    %ebp
  802c27:	c3                   	ret    

00802c28 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802c28:	55                   	push   %ebp
  802c29:	89 e5                	mov    %esp,%ebp
  802c2b:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802c2e:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  802c35:	75 70                	jne    802ca7 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  802c37:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  802c3e:	00 
  802c3f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802c46:	ee 
  802c47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c4e:	e8 b0 fb ff ff       	call   802803 <sys_page_alloc>
		if (error < 0)
  802c53:	85 c0                	test   %eax,%eax
  802c55:	79 1c                	jns    802c73 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  802c57:	c7 44 24 08 b8 4c 80 	movl   $0x804cb8,0x8(%esp)
  802c5e:	00 
  802c5f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802c66:	00 
  802c67:	c7 04 24 0b 4d 80 00 	movl   $0x804d0b,(%esp)
  802c6e:	e8 4e f0 ff ff       	call   801cc1 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802c73:	c7 44 24 04 b1 2c 80 	movl   $0x802cb1,0x4(%esp)
  802c7a:	00 
  802c7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c82:	e8 1c fd ff ff       	call   8029a3 <sys_env_set_pgfault_upcall>
		if (error < 0)
  802c87:	85 c0                	test   %eax,%eax
  802c89:	79 1c                	jns    802ca7 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  802c8b:	c7 44 24 08 e0 4c 80 	movl   $0x804ce0,0x8(%esp)
  802c92:	00 
  802c93:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802c9a:	00 
  802c9b:	c7 04 24 0b 4d 80 00 	movl   $0x804d0b,(%esp)
  802ca2:	e8 1a f0 ff ff       	call   801cc1 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  802caf:	c9                   	leave  
  802cb0:	c3                   	ret    

00802cb1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802cb1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802cb2:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  802cb7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802cb9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  802cbc:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  802cc0:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802cc5:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802cc9:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802ccb:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802cce:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802ccf:	83 c4 04             	add    $0x4,%esp
	popfl
  802cd2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802cd3:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802cd4:	c3                   	ret    
  802cd5:	66 90                	xchg   %ax,%ax
  802cd7:	66 90                	xchg   %ax,%ax
  802cd9:	66 90                	xchg   %ax,%ax
  802cdb:	66 90                	xchg   %ax,%ax
  802cdd:	66 90                	xchg   %ax,%ax
  802cdf:	90                   	nop

00802ce0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	56                   	push   %esi
  802ce4:	53                   	push   %ebx
  802ce5:	83 ec 10             	sub    $0x10,%esp
  802ce8:	8b 75 08             	mov    0x8(%ebp),%esi
  802ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802cf1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802cf3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802cf8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  802cfb:	89 04 24             	mov    %eax,(%esp)
  802cfe:	e8 16 fd ff ff       	call   802a19 <sys_ipc_recv>
  802d03:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802d05:	85 d2                	test   %edx,%edx
  802d07:	75 24                	jne    802d2d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802d09:	85 f6                	test   %esi,%esi
  802d0b:	74 0a                	je     802d17 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  802d0d:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d12:	8b 40 74             	mov    0x74(%eax),%eax
  802d15:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802d17:	85 db                	test   %ebx,%ebx
  802d19:	74 0a                	je     802d25 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  802d1b:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d20:	8b 40 78             	mov    0x78(%eax),%eax
  802d23:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802d25:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d2a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  802d2d:	83 c4 10             	add    $0x10,%esp
  802d30:	5b                   	pop    %ebx
  802d31:	5e                   	pop    %esi
  802d32:	5d                   	pop    %ebp
  802d33:	c3                   	ret    

00802d34 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802d34:	55                   	push   %ebp
  802d35:	89 e5                	mov    %esp,%ebp
  802d37:	57                   	push   %edi
  802d38:	56                   	push   %esi
  802d39:	53                   	push   %ebx
  802d3a:	83 ec 1c             	sub    $0x1c,%esp
  802d3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802d40:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802d46:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802d48:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802d4d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802d50:	8b 45 14             	mov    0x14(%ebp),%eax
  802d53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d5b:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d5f:	89 3c 24             	mov    %edi,(%esp)
  802d62:	e8 8f fc ff ff       	call   8029f6 <sys_ipc_try_send>

		if (ret == 0)
  802d67:	85 c0                	test   %eax,%eax
  802d69:	74 2c                	je     802d97 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  802d6b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d6e:	74 20                	je     802d90 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802d70:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d74:	c7 44 24 08 1c 4d 80 	movl   $0x804d1c,0x8(%esp)
  802d7b:	00 
  802d7c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802d83:	00 
  802d84:	c7 04 24 4a 4d 80 00 	movl   $0x804d4a,(%esp)
  802d8b:	e8 31 ef ff ff       	call   801cc1 <_panic>
		}

		sys_yield();
  802d90:	e8 4f fa ff ff       	call   8027e4 <sys_yield>
	}
  802d95:	eb b9                	jmp    802d50 <ipc_send+0x1c>
}
  802d97:	83 c4 1c             	add    $0x1c,%esp
  802d9a:	5b                   	pop    %ebx
  802d9b:	5e                   	pop    %esi
  802d9c:	5f                   	pop    %edi
  802d9d:	5d                   	pop    %ebp
  802d9e:	c3                   	ret    

00802d9f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d9f:	55                   	push   %ebp
  802da0:	89 e5                	mov    %esp,%ebp
  802da2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802da5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802daa:	89 c2                	mov    %eax,%edx
  802dac:	c1 e2 07             	shl    $0x7,%edx
  802daf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802db6:	8b 52 50             	mov    0x50(%edx),%edx
  802db9:	39 ca                	cmp    %ecx,%edx
  802dbb:	75 11                	jne    802dce <ipc_find_env+0x2f>
			return envs[i].env_id;
  802dbd:	89 c2                	mov    %eax,%edx
  802dbf:	c1 e2 07             	shl    $0x7,%edx
  802dc2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802dc9:	8b 40 40             	mov    0x40(%eax),%eax
  802dcc:	eb 0e                	jmp    802ddc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802dce:	83 c0 01             	add    $0x1,%eax
  802dd1:	3d 00 04 00 00       	cmp    $0x400,%eax
  802dd6:	75 d2                	jne    802daa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802dd8:	66 b8 00 00          	mov    $0x0,%ax
}
  802ddc:	5d                   	pop    %ebp
  802ddd:	c3                   	ret    
  802dde:	66 90                	xchg   %ax,%ax

00802de0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802de0:	55                   	push   %ebp
  802de1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	05 00 00 00 30       	add    $0x30000000,%eax
  802deb:	c1 e8 0c             	shr    $0xc,%eax
}
  802dee:	5d                   	pop    %ebp
  802def:	c3                   	ret    

00802df0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  802dfb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e00:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802e05:	5d                   	pop    %ebp
  802e06:	c3                   	ret    

00802e07 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802e07:	55                   	push   %ebp
  802e08:	89 e5                	mov    %esp,%ebp
  802e0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e0d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802e12:	89 c2                	mov    %eax,%edx
  802e14:	c1 ea 16             	shr    $0x16,%edx
  802e17:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802e1e:	f6 c2 01             	test   $0x1,%dl
  802e21:	74 11                	je     802e34 <fd_alloc+0x2d>
  802e23:	89 c2                	mov    %eax,%edx
  802e25:	c1 ea 0c             	shr    $0xc,%edx
  802e28:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e2f:	f6 c2 01             	test   $0x1,%dl
  802e32:	75 09                	jne    802e3d <fd_alloc+0x36>
			*fd_store = fd;
  802e34:	89 01                	mov    %eax,(%ecx)
			return 0;
  802e36:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3b:	eb 17                	jmp    802e54 <fd_alloc+0x4d>
  802e3d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802e42:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802e47:	75 c9                	jne    802e12 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802e49:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  802e4f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  802e54:	5d                   	pop    %ebp
  802e55:	c3                   	ret    

00802e56 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802e56:	55                   	push   %ebp
  802e57:	89 e5                	mov    %esp,%ebp
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802e5c:	83 f8 1f             	cmp    $0x1f,%eax
  802e5f:	77 36                	ja     802e97 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802e61:	c1 e0 0c             	shl    $0xc,%eax
  802e64:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802e69:	89 c2                	mov    %eax,%edx
  802e6b:	c1 ea 16             	shr    $0x16,%edx
  802e6e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802e75:	f6 c2 01             	test   $0x1,%dl
  802e78:	74 24                	je     802e9e <fd_lookup+0x48>
  802e7a:	89 c2                	mov    %eax,%edx
  802e7c:	c1 ea 0c             	shr    $0xc,%edx
  802e7f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e86:	f6 c2 01             	test   $0x1,%dl
  802e89:	74 1a                	je     802ea5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8e:	89 02                	mov    %eax,(%edx)
	return 0;
  802e90:	b8 00 00 00 00       	mov    $0x0,%eax
  802e95:	eb 13                	jmp    802eaa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802e97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e9c:	eb 0c                	jmp    802eaa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802e9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ea3:	eb 05                	jmp    802eaa <fd_lookup+0x54>
  802ea5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  802eaa:	5d                   	pop    %ebp
  802eab:	c3                   	ret    

00802eac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802eac:	55                   	push   %ebp
  802ead:	89 e5                	mov    %esp,%ebp
  802eaf:	83 ec 18             	sub    $0x18,%esp
  802eb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  802eba:	eb 13                	jmp    802ecf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  802ebc:	39 08                	cmp    %ecx,(%eax)
  802ebe:	75 0c                	jne    802ecc <dev_lookup+0x20>
			*dev = devtab[i];
  802ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ec3:	89 01                	mov    %eax,(%ecx)
			return 0;
  802ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eca:	eb 38                	jmp    802f04 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802ecc:	83 c2 01             	add    $0x1,%edx
  802ecf:	8b 04 95 d4 4d 80 00 	mov    0x804dd4(,%edx,4),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	75 e2                	jne    802ebc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802eda:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802edf:	8b 40 48             	mov    0x48(%eax),%eax
  802ee2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eea:	c7 04 24 54 4d 80 00 	movl   $0x804d54,(%esp)
  802ef1:	e8 c4 ee ff ff       	call   801dba <cprintf>
	*dev = 0;
  802ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802eff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802f04:	c9                   	leave  
  802f05:	c3                   	ret    

00802f06 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802f06:	55                   	push   %ebp
  802f07:	89 e5                	mov    %esp,%ebp
  802f09:	56                   	push   %esi
  802f0a:	53                   	push   %ebx
  802f0b:	83 ec 20             	sub    $0x20,%esp
  802f0e:	8b 75 08             	mov    0x8(%ebp),%esi
  802f11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802f14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f17:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802f1b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802f21:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802f24:	89 04 24             	mov    %eax,(%esp)
  802f27:	e8 2a ff ff ff       	call   802e56 <fd_lookup>
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	78 05                	js     802f35 <fd_close+0x2f>
	    || fd != fd2)
  802f30:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802f33:	74 0c                	je     802f41 <fd_close+0x3b>
		return (must_exist ? r : 0);
  802f35:	84 db                	test   %bl,%bl
  802f37:	ba 00 00 00 00       	mov    $0x0,%edx
  802f3c:	0f 44 c2             	cmove  %edx,%eax
  802f3f:	eb 3f                	jmp    802f80 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802f41:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f48:	8b 06                	mov    (%esi),%eax
  802f4a:	89 04 24             	mov    %eax,(%esp)
  802f4d:	e8 5a ff ff ff       	call   802eac <dev_lookup>
  802f52:	89 c3                	mov    %eax,%ebx
  802f54:	85 c0                	test   %eax,%eax
  802f56:	78 16                	js     802f6e <fd_close+0x68>
		if (dev->dev_close)
  802f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  802f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802f63:	85 c0                	test   %eax,%eax
  802f65:	74 07                	je     802f6e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  802f67:	89 34 24             	mov    %esi,(%esp)
  802f6a:	ff d0                	call   *%eax
  802f6c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802f6e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f79:	e8 2c f9 ff ff       	call   8028aa <sys_page_unmap>
	return r;
  802f7e:	89 d8                	mov    %ebx,%eax
}
  802f80:	83 c4 20             	add    $0x20,%esp
  802f83:	5b                   	pop    %ebx
  802f84:	5e                   	pop    %esi
  802f85:	5d                   	pop    %ebp
  802f86:	c3                   	ret    

00802f87 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  802f87:	55                   	push   %ebp
  802f88:	89 e5                	mov    %esp,%ebp
  802f8a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f90:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	89 04 24             	mov    %eax,(%esp)
  802f9a:	e8 b7 fe ff ff       	call   802e56 <fd_lookup>
  802f9f:	89 c2                	mov    %eax,%edx
  802fa1:	85 d2                	test   %edx,%edx
  802fa3:	78 13                	js     802fb8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  802fa5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802fac:	00 
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	89 04 24             	mov    %eax,(%esp)
  802fb3:	e8 4e ff ff ff       	call   802f06 <fd_close>
}
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <close_all>:

void
close_all(void)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
  802fbd:	53                   	push   %ebx
  802fbe:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802fc1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802fc6:	89 1c 24             	mov    %ebx,(%esp)
  802fc9:	e8 b9 ff ff ff       	call   802f87 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802fce:	83 c3 01             	add    $0x1,%ebx
  802fd1:	83 fb 20             	cmp    $0x20,%ebx
  802fd4:	75 f0                	jne    802fc6 <close_all+0xc>
		close(i);
}
  802fd6:	83 c4 14             	add    $0x14,%esp
  802fd9:	5b                   	pop    %ebx
  802fda:	5d                   	pop    %ebp
  802fdb:	c3                   	ret    

00802fdc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802fdc:	55                   	push   %ebp
  802fdd:	89 e5                	mov    %esp,%ebp
  802fdf:	57                   	push   %edi
  802fe0:	56                   	push   %esi
  802fe1:	53                   	push   %ebx
  802fe2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802fe5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	89 04 24             	mov    %eax,(%esp)
  802ff2:	e8 5f fe ff ff       	call   802e56 <fd_lookup>
  802ff7:	89 c2                	mov    %eax,%edx
  802ff9:	85 d2                	test   %edx,%edx
  802ffb:	0f 88 e1 00 00 00    	js     8030e2 <dup+0x106>
		return r;
	close(newfdnum);
  803001:	8b 45 0c             	mov    0xc(%ebp),%eax
  803004:	89 04 24             	mov    %eax,(%esp)
  803007:	e8 7b ff ff ff       	call   802f87 <close>

	newfd = INDEX2FD(newfdnum);
  80300c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80300f:	c1 e3 0c             	shl    $0xc,%ebx
  803012:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  803018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301b:	89 04 24             	mov    %eax,(%esp)
  80301e:	e8 cd fd ff ff       	call   802df0 <fd2data>
  803023:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  803025:	89 1c 24             	mov    %ebx,(%esp)
  803028:	e8 c3 fd ff ff       	call   802df0 <fd2data>
  80302d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80302f:	89 f0                	mov    %esi,%eax
  803031:	c1 e8 16             	shr    $0x16,%eax
  803034:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80303b:	a8 01                	test   $0x1,%al
  80303d:	74 43                	je     803082 <dup+0xa6>
  80303f:	89 f0                	mov    %esi,%eax
  803041:	c1 e8 0c             	shr    $0xc,%eax
  803044:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80304b:	f6 c2 01             	test   $0x1,%dl
  80304e:	74 32                	je     803082 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803050:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803057:	25 07 0e 00 00       	and    $0xe07,%eax
  80305c:	89 44 24 10          	mov    %eax,0x10(%esp)
  803060:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803064:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80306b:	00 
  80306c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803070:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803077:	e8 db f7 ff ff       	call   802857 <sys_page_map>
  80307c:	89 c6                	mov    %eax,%esi
  80307e:	85 c0                	test   %eax,%eax
  803080:	78 3e                	js     8030c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803082:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803085:	89 c2                	mov    %eax,%edx
  803087:	c1 ea 0c             	shr    $0xc,%edx
  80308a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  803091:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  803097:	89 54 24 10          	mov    %edx,0x10(%esp)
  80309b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80309f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8030a6:	00 
  8030a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030b2:	e8 a0 f7 ff ff       	call   802857 <sys_page_map>
  8030b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8030b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8030bc:	85 f6                	test   %esi,%esi
  8030be:	79 22                	jns    8030e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8030c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8030c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030cb:	e8 da f7 ff ff       	call   8028aa <sys_page_unmap>
	sys_page_unmap(0, nva);
  8030d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8030d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030db:	e8 ca f7 ff ff       	call   8028aa <sys_page_unmap>
	return r;
  8030e0:	89 f0                	mov    %esi,%eax
}
  8030e2:	83 c4 3c             	add    $0x3c,%esp
  8030e5:	5b                   	pop    %ebx
  8030e6:	5e                   	pop    %esi
  8030e7:	5f                   	pop    %edi
  8030e8:	5d                   	pop    %ebp
  8030e9:	c3                   	ret    

008030ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8030ea:	55                   	push   %ebp
  8030eb:	89 e5                	mov    %esp,%ebp
  8030ed:	53                   	push   %ebx
  8030ee:	83 ec 24             	sub    $0x24,%esp
  8030f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8030f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030fb:	89 1c 24             	mov    %ebx,(%esp)
  8030fe:	e8 53 fd ff ff       	call   802e56 <fd_lookup>
  803103:	89 c2                	mov    %eax,%edx
  803105:	85 d2                	test   %edx,%edx
  803107:	78 6d                	js     803176 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803109:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80310c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	89 04 24             	mov    %eax,(%esp)
  803118:	e8 8f fd ff ff       	call   802eac <dev_lookup>
  80311d:	85 c0                	test   %eax,%eax
  80311f:	78 55                	js     803176 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	8b 50 08             	mov    0x8(%eax),%edx
  803127:	83 e2 03             	and    $0x3,%edx
  80312a:	83 fa 01             	cmp    $0x1,%edx
  80312d:	75 23                	jne    803152 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80312f:	a1 10 a0 80 00       	mov    0x80a010,%eax
  803134:	8b 40 48             	mov    0x48(%eax),%eax
  803137:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80313b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80313f:	c7 04 24 98 4d 80 00 	movl   $0x804d98,(%esp)
  803146:	e8 6f ec ff ff       	call   801dba <cprintf>
		return -E_INVAL;
  80314b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803150:	eb 24                	jmp    803176 <read+0x8c>
	}
	if (!dev->dev_read)
  803152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803155:	8b 52 08             	mov    0x8(%edx),%edx
  803158:	85 d2                	test   %edx,%edx
  80315a:	74 15                	je     803171 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80315c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80315f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803166:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80316a:	89 04 24             	mov    %eax,(%esp)
  80316d:	ff d2                	call   *%edx
  80316f:	eb 05                	jmp    803176 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  803171:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  803176:	83 c4 24             	add    $0x24,%esp
  803179:	5b                   	pop    %ebx
  80317a:	5d                   	pop    %ebp
  80317b:	c3                   	ret    

0080317c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80317c:	55                   	push   %ebp
  80317d:	89 e5                	mov    %esp,%ebp
  80317f:	57                   	push   %edi
  803180:	56                   	push   %esi
  803181:	53                   	push   %ebx
  803182:	83 ec 1c             	sub    $0x1c,%esp
  803185:	8b 7d 08             	mov    0x8(%ebp),%edi
  803188:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80318b:	bb 00 00 00 00       	mov    $0x0,%ebx
  803190:	eb 23                	jmp    8031b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803192:	89 f0                	mov    %esi,%eax
  803194:	29 d8                	sub    %ebx,%eax
  803196:	89 44 24 08          	mov    %eax,0x8(%esp)
  80319a:	89 d8                	mov    %ebx,%eax
  80319c:	03 45 0c             	add    0xc(%ebp),%eax
  80319f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031a3:	89 3c 24             	mov    %edi,(%esp)
  8031a6:	e8 3f ff ff ff       	call   8030ea <read>
		if (m < 0)
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	78 10                	js     8031bf <readn+0x43>
			return m;
		if (m == 0)
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	74 0a                	je     8031bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8031b3:	01 c3                	add    %eax,%ebx
  8031b5:	39 f3                	cmp    %esi,%ebx
  8031b7:	72 d9                	jb     803192 <readn+0x16>
  8031b9:	89 d8                	mov    %ebx,%eax
  8031bb:	eb 02                	jmp    8031bf <readn+0x43>
  8031bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8031bf:	83 c4 1c             	add    $0x1c,%esp
  8031c2:	5b                   	pop    %ebx
  8031c3:	5e                   	pop    %esi
  8031c4:	5f                   	pop    %edi
  8031c5:	5d                   	pop    %ebp
  8031c6:	c3                   	ret    

008031c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8031c7:	55                   	push   %ebp
  8031c8:	89 e5                	mov    %esp,%ebp
  8031ca:	53                   	push   %ebx
  8031cb:	83 ec 24             	sub    $0x24,%esp
  8031ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031d8:	89 1c 24             	mov    %ebx,(%esp)
  8031db:	e8 76 fc ff ff       	call   802e56 <fd_lookup>
  8031e0:	89 c2                	mov    %eax,%edx
  8031e2:	85 d2                	test   %edx,%edx
  8031e4:	78 68                	js     80324e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	89 04 24             	mov    %eax,(%esp)
  8031f5:	e8 b2 fc ff ff       	call   802eac <dev_lookup>
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	78 50                	js     80324e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803201:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  803205:	75 23                	jne    80322a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803207:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80320c:	8b 40 48             	mov    0x48(%eax),%eax
  80320f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803213:	89 44 24 04          	mov    %eax,0x4(%esp)
  803217:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  80321e:	e8 97 eb ff ff       	call   801dba <cprintf>
		return -E_INVAL;
  803223:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803228:	eb 24                	jmp    80324e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80322a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322d:	8b 52 0c             	mov    0xc(%edx),%edx
  803230:	85 d2                	test   %edx,%edx
  803232:	74 15                	je     803249 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  803234:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803237:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80323b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80323e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803242:	89 04 24             	mov    %eax,(%esp)
  803245:	ff d2                	call   *%edx
  803247:	eb 05                	jmp    80324e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  803249:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80324e:	83 c4 24             	add    $0x24,%esp
  803251:	5b                   	pop    %ebx
  803252:	5d                   	pop    %ebp
  803253:	c3                   	ret    

00803254 <seek>:

int
seek(int fdnum, off_t offset)
{
  803254:	55                   	push   %ebp
  803255:	89 e5                	mov    %esp,%ebp
  803257:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80325a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80325d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	89 04 24             	mov    %eax,(%esp)
  803267:	e8 ea fb ff ff       	call   802e56 <fd_lookup>
  80326c:	85 c0                	test   %eax,%eax
  80326e:	78 0e                	js     80327e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  803270:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803273:	8b 55 0c             	mov    0xc(%ebp),%edx
  803276:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  803279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80327e:	c9                   	leave  
  80327f:	c3                   	ret    

00803280 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803280:	55                   	push   %ebp
  803281:	89 e5                	mov    %esp,%ebp
  803283:	53                   	push   %ebx
  803284:	83 ec 24             	sub    $0x24,%esp
  803287:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80328a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80328d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803291:	89 1c 24             	mov    %ebx,(%esp)
  803294:	e8 bd fb ff ff       	call   802e56 <fd_lookup>
  803299:	89 c2                	mov    %eax,%edx
  80329b:	85 d2                	test   %edx,%edx
  80329d:	78 61                	js     803300 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80329f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	89 04 24             	mov    %eax,(%esp)
  8032ae:	e8 f9 fb ff ff       	call   802eac <dev_lookup>
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	78 49                	js     803300 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8032b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8032be:	75 23                	jne    8032e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8032c0:	a1 10 a0 80 00       	mov    0x80a010,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8032c5:	8b 40 48             	mov    0x48(%eax),%eax
  8032c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d0:	c7 04 24 74 4d 80 00 	movl   $0x804d74,(%esp)
  8032d7:	e8 de ea ff ff       	call   801dba <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8032dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032e1:	eb 1d                	jmp    803300 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8032e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e6:	8b 52 18             	mov    0x18(%edx),%edx
  8032e9:	85 d2                	test   %edx,%edx
  8032eb:	74 0e                	je     8032fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8032ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8032f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032f4:	89 04 24             	mov    %eax,(%esp)
  8032f7:	ff d2                	call   *%edx
  8032f9:	eb 05                	jmp    803300 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8032fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  803300:	83 c4 24             	add    $0x24,%esp
  803303:	5b                   	pop    %ebx
  803304:	5d                   	pop    %ebp
  803305:	c3                   	ret    

00803306 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803306:	55                   	push   %ebp
  803307:	89 e5                	mov    %esp,%ebp
  803309:	53                   	push   %ebx
  80330a:	83 ec 24             	sub    $0x24,%esp
  80330d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803310:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803313:	89 44 24 04          	mov    %eax,0x4(%esp)
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	89 04 24             	mov    %eax,(%esp)
  80331d:	e8 34 fb ff ff       	call   802e56 <fd_lookup>
  803322:	89 c2                	mov    %eax,%edx
  803324:	85 d2                	test   %edx,%edx
  803326:	78 52                	js     80337a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803328:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80332b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80332f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	89 04 24             	mov    %eax,(%esp)
  803337:	e8 70 fb ff ff       	call   802eac <dev_lookup>
  80333c:	85 c0                	test   %eax,%eax
  80333e:	78 3a                	js     80337a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  803347:	74 2c                	je     803375 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  803349:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80334c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  803353:	00 00 00 
	stat->st_isdir = 0;
  803356:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80335d:	00 00 00 
	stat->st_dev = dev;
  803360:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  803366:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80336a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80336d:	89 14 24             	mov    %edx,(%esp)
  803370:	ff 50 14             	call   *0x14(%eax)
  803373:	eb 05                	jmp    80337a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  803375:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80337a:	83 c4 24             	add    $0x24,%esp
  80337d:	5b                   	pop    %ebx
  80337e:	5d                   	pop    %ebp
  80337f:	c3                   	ret    

00803380 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803380:	55                   	push   %ebp
  803381:	89 e5                	mov    %esp,%ebp
  803383:	56                   	push   %esi
  803384:	53                   	push   %ebx
  803385:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803388:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80338f:	00 
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	89 04 24             	mov    %eax,(%esp)
  803396:	e8 1b 02 00 00       	call   8035b6 <open>
  80339b:	89 c3                	mov    %eax,%ebx
  80339d:	85 db                	test   %ebx,%ebx
  80339f:	78 1b                	js     8033bc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8033a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a8:	89 1c 24             	mov    %ebx,(%esp)
  8033ab:	e8 56 ff ff ff       	call   803306 <fstat>
  8033b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8033b2:	89 1c 24             	mov    %ebx,(%esp)
  8033b5:	e8 cd fb ff ff       	call   802f87 <close>
	return r;
  8033ba:	89 f0                	mov    %esi,%eax
}
  8033bc:	83 c4 10             	add    $0x10,%esp
  8033bf:	5b                   	pop    %ebx
  8033c0:	5e                   	pop    %esi
  8033c1:	5d                   	pop    %ebp
  8033c2:	c3                   	ret    

008033c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8033c3:	55                   	push   %ebp
  8033c4:	89 e5                	mov    %esp,%ebp
  8033c6:	56                   	push   %esi
  8033c7:	53                   	push   %ebx
  8033c8:	83 ec 10             	sub    $0x10,%esp
  8033cb:	89 c6                	mov    %eax,%esi
  8033cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8033cf:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  8033d6:	75 11                	jne    8033e9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8033df:	e8 bb f9 ff ff       	call   802d9f <ipc_find_env>
  8033e4:	a3 00 a0 80 00       	mov    %eax,0x80a000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8033e9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8033f0:	00 
  8033f1:	c7 44 24 08 00 b0 80 	movl   $0x80b000,0x8(%esp)
  8033f8:	00 
  8033f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033fd:	a1 00 a0 80 00       	mov    0x80a000,%eax
  803402:	89 04 24             	mov    %eax,(%esp)
  803405:	e8 2a f9 ff ff       	call   802d34 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80340a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803411:	00 
  803412:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803416:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80341d:	e8 be f8 ff ff       	call   802ce0 <ipc_recv>
}
  803422:	83 c4 10             	add    $0x10,%esp
  803425:	5b                   	pop    %ebx
  803426:	5e                   	pop    %esi
  803427:	5d                   	pop    %ebp
  803428:	c3                   	ret    

00803429 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803429:	55                   	push   %ebp
  80342a:	89 e5                	mov    %esp,%ebp
  80342c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	8b 40 0c             	mov    0xc(%eax),%eax
  803435:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  80343a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343d:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803442:	ba 00 00 00 00       	mov    $0x0,%edx
  803447:	b8 02 00 00 00       	mov    $0x2,%eax
  80344c:	e8 72 ff ff ff       	call   8033c3 <fsipc>
}
  803451:	c9                   	leave  
  803452:	c3                   	ret    

00803453 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803453:	55                   	push   %ebp
  803454:	89 e5                	mov    %esp,%ebp
  803456:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 40 0c             	mov    0xc(%eax),%eax
  80345f:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803464:	ba 00 00 00 00       	mov    $0x0,%edx
  803469:	b8 06 00 00 00       	mov    $0x6,%eax
  80346e:	e8 50 ff ff ff       	call   8033c3 <fsipc>
}
  803473:	c9                   	leave  
  803474:	c3                   	ret    

00803475 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803475:	55                   	push   %ebp
  803476:	89 e5                	mov    %esp,%ebp
  803478:	53                   	push   %ebx
  803479:	83 ec 14             	sub    $0x14,%esp
  80347c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	8b 40 0c             	mov    0xc(%eax),%eax
  803485:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80348a:	ba 00 00 00 00       	mov    $0x0,%edx
  80348f:	b8 05 00 00 00       	mov    $0x5,%eax
  803494:	e8 2a ff ff ff       	call   8033c3 <fsipc>
  803499:	89 c2                	mov    %eax,%edx
  80349b:	85 d2                	test   %edx,%edx
  80349d:	78 2b                	js     8034ca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80349f:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  8034a6:	00 
  8034a7:	89 1c 24             	mov    %ebx,(%esp)
  8034aa:	e8 38 ef ff ff       	call   8023e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8034af:	a1 80 b0 80 00       	mov    0x80b080,%eax
  8034b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8034ba:	a1 84 b0 80 00       	mov    0x80b084,%eax
  8034bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8034c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ca:	83 c4 14             	add    $0x14,%esp
  8034cd:	5b                   	pop    %ebx
  8034ce:	5d                   	pop    %ebp
  8034cf:	c3                   	ret    

008034d0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8034d0:	55                   	push   %ebp
  8034d1:	89 e5                	mov    %esp,%ebp
  8034d3:	83 ec 18             	sub    $0x18,%esp
  8034d6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8034d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8034df:	89 15 00 b0 80 00    	mov    %edx,0x80b000
	fsipcbuf.write.req_n = n;
  8034e5:	a3 04 b0 80 00       	mov    %eax,0x80b004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8034ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034f5:	c7 04 24 08 b0 80 00 	movl   $0x80b008,(%esp)
  8034fc:	e8 eb f0 ff ff       	call   8025ec <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  803501:	ba 00 00 00 00       	mov    $0x0,%edx
  803506:	b8 04 00 00 00       	mov    $0x4,%eax
  80350b:	e8 b3 fe ff ff       	call   8033c3 <fsipc>
		return r;
	}

	return r;
}
  803510:	c9                   	leave  
  803511:	c3                   	ret    

00803512 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803512:	55                   	push   %ebp
  803513:	89 e5                	mov    %esp,%ebp
  803515:	56                   	push   %esi
  803516:	53                   	push   %ebx
  803517:	83 ec 10             	sub    $0x10,%esp
  80351a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	8b 40 0c             	mov    0xc(%eax),%eax
  803523:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803528:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80352e:	ba 00 00 00 00       	mov    $0x0,%edx
  803533:	b8 03 00 00 00       	mov    $0x3,%eax
  803538:	e8 86 fe ff ff       	call   8033c3 <fsipc>
  80353d:	89 c3                	mov    %eax,%ebx
  80353f:	85 c0                	test   %eax,%eax
  803541:	78 6a                	js     8035ad <devfile_read+0x9b>
		return r;
	assert(r <= n);
  803543:	39 c6                	cmp    %eax,%esi
  803545:	73 24                	jae    80356b <devfile_read+0x59>
  803547:	c7 44 24 0c e8 4d 80 	movl   $0x804de8,0xc(%esp)
  80354e:	00 
  80354f:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  803556:	00 
  803557:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80355e:	00 
  80355f:	c7 04 24 ef 4d 80 00 	movl   $0x804def,(%esp)
  803566:	e8 56 e7 ff ff       	call   801cc1 <_panic>
	assert(r <= PGSIZE);
  80356b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803570:	7e 24                	jle    803596 <devfile_read+0x84>
  803572:	c7 44 24 0c fa 4d 80 	movl   $0x804dfa,0xc(%esp)
  803579:	00 
  80357a:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  803581:	00 
  803582:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  803589:	00 
  80358a:	c7 04 24 ef 4d 80 00 	movl   $0x804def,(%esp)
  803591:	e8 2b e7 ff ff       	call   801cc1 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803596:	89 44 24 08          	mov    %eax,0x8(%esp)
  80359a:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  8035a1:	00 
  8035a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a5:	89 04 24             	mov    %eax,(%esp)
  8035a8:	e8 d7 ef ff ff       	call   802584 <memmove>
	return r;
}
  8035ad:	89 d8                	mov    %ebx,%eax
  8035af:	83 c4 10             	add    $0x10,%esp
  8035b2:	5b                   	pop    %ebx
  8035b3:	5e                   	pop    %esi
  8035b4:	5d                   	pop    %ebp
  8035b5:	c3                   	ret    

008035b6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8035b6:	55                   	push   %ebp
  8035b7:	89 e5                	mov    %esp,%ebp
  8035b9:	53                   	push   %ebx
  8035ba:	83 ec 24             	sub    $0x24,%esp
  8035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8035c0:	89 1c 24             	mov    %ebx,(%esp)
  8035c3:	e8 e8 ed ff ff       	call   8023b0 <strlen>
  8035c8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8035cd:	7f 60                	jg     80362f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8035cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035d2:	89 04 24             	mov    %eax,(%esp)
  8035d5:	e8 2d f8 ff ff       	call   802e07 <fd_alloc>
  8035da:	89 c2                	mov    %eax,%edx
  8035dc:	85 d2                	test   %edx,%edx
  8035de:	78 54                	js     803634 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8035e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8035e4:	c7 04 24 00 b0 80 00 	movl   $0x80b000,(%esp)
  8035eb:	e8 f7 ed ff ff       	call   8023e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f3:	a3 00 b4 80 00       	mov    %eax,0x80b400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8035f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035fb:	b8 01 00 00 00       	mov    $0x1,%eax
  803600:	e8 be fd ff ff       	call   8033c3 <fsipc>
  803605:	89 c3                	mov    %eax,%ebx
  803607:	85 c0                	test   %eax,%eax
  803609:	79 17                	jns    803622 <open+0x6c>
		fd_close(fd, 0);
  80360b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803612:	00 
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	89 04 24             	mov    %eax,(%esp)
  803619:	e8 e8 f8 ff ff       	call   802f06 <fd_close>
		return r;
  80361e:	89 d8                	mov    %ebx,%eax
  803620:	eb 12                	jmp    803634 <open+0x7e>
	}

	return fd2num(fd);
  803622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803625:	89 04 24             	mov    %eax,(%esp)
  803628:	e8 b3 f7 ff ff       	call   802de0 <fd2num>
  80362d:	eb 05                	jmp    803634 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80362f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  803634:	83 c4 24             	add    $0x24,%esp
  803637:	5b                   	pop    %ebx
  803638:	5d                   	pop    %ebp
  803639:	c3                   	ret    

0080363a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80363a:	55                   	push   %ebp
  80363b:	89 e5                	mov    %esp,%ebp
  80363d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803640:	ba 00 00 00 00       	mov    $0x0,%edx
  803645:	b8 08 00 00 00       	mov    $0x8,%eax
  80364a:	e8 74 fd ff ff       	call   8033c3 <fsipc>
}
  80364f:	c9                   	leave  
  803650:	c3                   	ret    

00803651 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803651:	55                   	push   %ebp
  803652:	89 e5                	mov    %esp,%ebp
  803654:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803657:	89 d0                	mov    %edx,%eax
  803659:	c1 e8 16             	shr    $0x16,%eax
  80365c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803663:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803668:	f6 c1 01             	test   $0x1,%cl
  80366b:	74 1d                	je     80368a <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80366d:	c1 ea 0c             	shr    $0xc,%edx
  803670:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803677:	f6 c2 01             	test   $0x1,%dl
  80367a:	74 0e                	je     80368a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80367c:	c1 ea 0c             	shr    $0xc,%edx
  80367f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803686:	ef 
  803687:	0f b7 c0             	movzwl %ax,%eax
}
  80368a:	5d                   	pop    %ebp
  80368b:	c3                   	ret    
  80368c:	66 90                	xchg   %ax,%ax
  80368e:	66 90                	xchg   %ax,%ax

00803690 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803690:	55                   	push   %ebp
  803691:	89 e5                	mov    %esp,%ebp
  803693:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803696:	c7 44 24 04 06 4e 80 	movl   $0x804e06,0x4(%esp)
  80369d:	00 
  80369e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a1:	89 04 24             	mov    %eax,(%esp)
  8036a4:	e8 3e ed ff ff       	call   8023e7 <strcpy>
	return 0;
}
  8036a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ae:	c9                   	leave  
  8036af:	c3                   	ret    

008036b0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8036b0:	55                   	push   %ebp
  8036b1:	89 e5                	mov    %esp,%ebp
  8036b3:	53                   	push   %ebx
  8036b4:	83 ec 14             	sub    $0x14,%esp
  8036b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8036ba:	89 1c 24             	mov    %ebx,(%esp)
  8036bd:	e8 8f ff ff ff       	call   803651 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8036c2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8036c7:	83 f8 01             	cmp    $0x1,%eax
  8036ca:	75 0d                	jne    8036d9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8036cc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8036cf:	89 04 24             	mov    %eax,(%esp)
  8036d2:	e8 29 03 00 00       	call   803a00 <nsipc_close>
  8036d7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8036d9:	89 d0                	mov    %edx,%eax
  8036db:	83 c4 14             	add    $0x14,%esp
  8036de:	5b                   	pop    %ebx
  8036df:	5d                   	pop    %ebp
  8036e0:	c3                   	ret    

008036e1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8036e1:	55                   	push   %ebp
  8036e2:	89 e5                	mov    %esp,%ebp
  8036e4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8036e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8036ee:	00 
  8036ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8036f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8036f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803700:	8b 40 0c             	mov    0xc(%eax),%eax
  803703:	89 04 24             	mov    %eax,(%esp)
  803706:	e8 f0 03 00 00       	call   803afb <nsipc_send>
}
  80370b:	c9                   	leave  
  80370c:	c3                   	ret    

0080370d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80370d:	55                   	push   %ebp
  80370e:	89 e5                	mov    %esp,%ebp
  803710:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803713:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80371a:	00 
  80371b:	8b 45 10             	mov    0x10(%ebp),%eax
  80371e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803722:	8b 45 0c             	mov    0xc(%ebp),%eax
  803725:	89 44 24 04          	mov    %eax,0x4(%esp)
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	8b 40 0c             	mov    0xc(%eax),%eax
  80372f:	89 04 24             	mov    %eax,(%esp)
  803732:	e8 44 03 00 00       	call   803a7b <nsipc_recv>
}
  803737:	c9                   	leave  
  803738:	c3                   	ret    

00803739 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803739:	55                   	push   %ebp
  80373a:	89 e5                	mov    %esp,%ebp
  80373c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80373f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803742:	89 54 24 04          	mov    %edx,0x4(%esp)
  803746:	89 04 24             	mov    %eax,(%esp)
  803749:	e8 08 f7 ff ff       	call   802e56 <fd_lookup>
  80374e:	85 c0                	test   %eax,%eax
  803750:	78 17                	js     803769 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  80375b:	39 08                	cmp    %ecx,(%eax)
  80375d:	75 05                	jne    803764 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80375f:	8b 40 0c             	mov    0xc(%eax),%eax
  803762:	eb 05                	jmp    803769 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  803764:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  803769:	c9                   	leave  
  80376a:	c3                   	ret    

0080376b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80376b:	55                   	push   %ebp
  80376c:	89 e5                	mov    %esp,%ebp
  80376e:	56                   	push   %esi
  80376f:	53                   	push   %ebx
  803770:	83 ec 20             	sub    $0x20,%esp
  803773:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803778:	89 04 24             	mov    %eax,(%esp)
  80377b:	e8 87 f6 ff ff       	call   802e07 <fd_alloc>
  803780:	89 c3                	mov    %eax,%ebx
  803782:	85 c0                	test   %eax,%eax
  803784:	78 21                	js     8037a7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803786:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80378d:	00 
  80378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803791:	89 44 24 04          	mov    %eax,0x4(%esp)
  803795:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80379c:	e8 62 f0 ff ff       	call   802803 <sys_page_alloc>
  8037a1:	89 c3                	mov    %eax,%ebx
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	79 0c                	jns    8037b3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8037a7:	89 34 24             	mov    %esi,(%esp)
  8037aa:	e8 51 02 00 00       	call   803a00 <nsipc_close>
		return r;
  8037af:	89 d8                	mov    %ebx,%eax
  8037b1:	eb 20                	jmp    8037d3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8037b3:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8037b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8037be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8037c8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8037cb:	89 14 24             	mov    %edx,(%esp)
  8037ce:	e8 0d f6 ff ff       	call   802de0 <fd2num>
}
  8037d3:	83 c4 20             	add    $0x20,%esp
  8037d6:	5b                   	pop    %ebx
  8037d7:	5e                   	pop    %esi
  8037d8:	5d                   	pop    %ebp
  8037d9:	c3                   	ret    

008037da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037da:	55                   	push   %ebp
  8037db:	89 e5                	mov    %esp,%ebp
  8037dd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	e8 51 ff ff ff       	call   803739 <fd2sockid>
		return r;
  8037e8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037ea:	85 c0                	test   %eax,%eax
  8037ec:	78 23                	js     803811 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8037ee:	8b 55 10             	mov    0x10(%ebp),%edx
  8037f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8037f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8037fc:	89 04 24             	mov    %eax,(%esp)
  8037ff:	e8 45 01 00 00       	call   803949 <nsipc_accept>
		return r;
  803804:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803806:	85 c0                	test   %eax,%eax
  803808:	78 07                	js     803811 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80380a:	e8 5c ff ff ff       	call   80376b <alloc_sockfd>
  80380f:	89 c1                	mov    %eax,%ecx
}
  803811:	89 c8                	mov    %ecx,%eax
  803813:	c9                   	leave  
  803814:	c3                   	ret    

00803815 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803815:	55                   	push   %ebp
  803816:	89 e5                	mov    %esp,%ebp
  803818:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	e8 16 ff ff ff       	call   803739 <fd2sockid>
  803823:	89 c2                	mov    %eax,%edx
  803825:	85 d2                	test   %edx,%edx
  803827:	78 16                	js     80383f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  803829:	8b 45 10             	mov    0x10(%ebp),%eax
  80382c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803830:	8b 45 0c             	mov    0xc(%ebp),%eax
  803833:	89 44 24 04          	mov    %eax,0x4(%esp)
  803837:	89 14 24             	mov    %edx,(%esp)
  80383a:	e8 60 01 00 00       	call   80399f <nsipc_bind>
}
  80383f:	c9                   	leave  
  803840:	c3                   	ret    

00803841 <shutdown>:

int
shutdown(int s, int how)
{
  803841:	55                   	push   %ebp
  803842:	89 e5                	mov    %esp,%ebp
  803844:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803847:	8b 45 08             	mov    0x8(%ebp),%eax
  80384a:	e8 ea fe ff ff       	call   803739 <fd2sockid>
  80384f:	89 c2                	mov    %eax,%edx
  803851:	85 d2                	test   %edx,%edx
  803853:	78 0f                	js     803864 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  803855:	8b 45 0c             	mov    0xc(%ebp),%eax
  803858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80385c:	89 14 24             	mov    %edx,(%esp)
  80385f:	e8 7a 01 00 00       	call   8039de <nsipc_shutdown>
}
  803864:	c9                   	leave  
  803865:	c3                   	ret    

00803866 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803866:	55                   	push   %ebp
  803867:	89 e5                	mov    %esp,%ebp
  803869:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80386c:	8b 45 08             	mov    0x8(%ebp),%eax
  80386f:	e8 c5 fe ff ff       	call   803739 <fd2sockid>
  803874:	89 c2                	mov    %eax,%edx
  803876:	85 d2                	test   %edx,%edx
  803878:	78 16                	js     803890 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80387a:	8b 45 10             	mov    0x10(%ebp),%eax
  80387d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803881:	8b 45 0c             	mov    0xc(%ebp),%eax
  803884:	89 44 24 04          	mov    %eax,0x4(%esp)
  803888:	89 14 24             	mov    %edx,(%esp)
  80388b:	e8 8a 01 00 00       	call   803a1a <nsipc_connect>
}
  803890:	c9                   	leave  
  803891:	c3                   	ret    

00803892 <listen>:

int
listen(int s, int backlog)
{
  803892:	55                   	push   %ebp
  803893:	89 e5                	mov    %esp,%ebp
  803895:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	e8 99 fe ff ff       	call   803739 <fd2sockid>
  8038a0:	89 c2                	mov    %eax,%edx
  8038a2:	85 d2                	test   %edx,%edx
  8038a4:	78 0f                	js     8038b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8038a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038ad:	89 14 24             	mov    %edx,(%esp)
  8038b0:	e8 a4 01 00 00       	call   803a59 <nsipc_listen>
}
  8038b5:	c9                   	leave  
  8038b6:	c3                   	ret    

008038b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8038b7:	55                   	push   %ebp
  8038b8:	89 e5                	mov    %esp,%ebp
  8038ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8038c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	89 04 24             	mov    %eax,(%esp)
  8038d1:	e8 98 02 00 00       	call   803b6e <nsipc_socket>
  8038d6:	89 c2                	mov    %eax,%edx
  8038d8:	85 d2                	test   %edx,%edx
  8038da:	78 05                	js     8038e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8038dc:	e8 8a fe ff ff       	call   80376b <alloc_sockfd>
}
  8038e1:	c9                   	leave  
  8038e2:	c3                   	ret    

008038e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8038e3:	55                   	push   %ebp
  8038e4:	89 e5                	mov    %esp,%ebp
  8038e6:	53                   	push   %ebx
  8038e7:	83 ec 14             	sub    $0x14,%esp
  8038ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8038ec:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  8038f3:	75 11                	jne    803906 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8038f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8038fc:	e8 9e f4 ff ff       	call   802d9f <ipc_find_env>
  803901:	a3 04 a0 80 00       	mov    %eax,0x80a004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803906:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80390d:	00 
  80390e:	c7 44 24 08 00 c0 80 	movl   $0x80c000,0x8(%esp)
  803915:	00 
  803916:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80391a:	a1 04 a0 80 00       	mov    0x80a004,%eax
  80391f:	89 04 24             	mov    %eax,(%esp)
  803922:	e8 0d f4 ff ff       	call   802d34 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80392e:	00 
  80392f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803936:	00 
  803937:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80393e:	e8 9d f3 ff ff       	call   802ce0 <ipc_recv>
}
  803943:	83 c4 14             	add    $0x14,%esp
  803946:	5b                   	pop    %ebx
  803947:	5d                   	pop    %ebp
  803948:	c3                   	ret    

00803949 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803949:	55                   	push   %ebp
  80394a:	89 e5                	mov    %esp,%ebp
  80394c:	56                   	push   %esi
  80394d:	53                   	push   %ebx
  80394e:	83 ec 10             	sub    $0x10,%esp
  803951:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80395c:	8b 06                	mov    (%esi),%eax
  80395e:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803963:	b8 01 00 00 00       	mov    $0x1,%eax
  803968:	e8 76 ff ff ff       	call   8038e3 <nsipc>
  80396d:	89 c3                	mov    %eax,%ebx
  80396f:	85 c0                	test   %eax,%eax
  803971:	78 23                	js     803996 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803973:	a1 10 c0 80 00       	mov    0x80c010,%eax
  803978:	89 44 24 08          	mov    %eax,0x8(%esp)
  80397c:	c7 44 24 04 00 c0 80 	movl   $0x80c000,0x4(%esp)
  803983:	00 
  803984:	8b 45 0c             	mov    0xc(%ebp),%eax
  803987:	89 04 24             	mov    %eax,(%esp)
  80398a:	e8 f5 eb ff ff       	call   802584 <memmove>
		*addrlen = ret->ret_addrlen;
  80398f:	a1 10 c0 80 00       	mov    0x80c010,%eax
  803994:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  803996:	89 d8                	mov    %ebx,%eax
  803998:	83 c4 10             	add    $0x10,%esp
  80399b:	5b                   	pop    %ebx
  80399c:	5e                   	pop    %esi
  80399d:	5d                   	pop    %ebp
  80399e:	c3                   	ret    

0080399f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80399f:	55                   	push   %ebp
  8039a0:	89 e5                	mov    %esp,%ebp
  8039a2:	53                   	push   %ebx
  8039a3:	83 ec 14             	sub    $0x14,%esp
  8039a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8039a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ac:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8039b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039bc:	c7 04 24 04 c0 80 00 	movl   $0x80c004,(%esp)
  8039c3:	e8 bc eb ff ff       	call   802584 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8039c8:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  8039ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8039d3:	e8 0b ff ff ff       	call   8038e3 <nsipc>
}
  8039d8:	83 c4 14             	add    $0x14,%esp
  8039db:	5b                   	pop    %ebx
  8039dc:	5d                   	pop    %ebp
  8039dd:	c3                   	ret    

008039de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8039de:	55                   	push   %ebp
  8039df:	89 e5                	mov    %esp,%ebp
  8039e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8039e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e7:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  8039ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ef:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  8039f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8039f9:	e8 e5 fe ff ff       	call   8038e3 <nsipc>
}
  8039fe:	c9                   	leave  
  8039ff:	c3                   	ret    

00803a00 <nsipc_close>:

int
nsipc_close(int s)
{
  803a00:	55                   	push   %ebp
  803a01:	89 e5                	mov    %esp,%ebp
  803a03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803a06:	8b 45 08             	mov    0x8(%ebp),%eax
  803a09:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  803a0e:	b8 04 00 00 00       	mov    $0x4,%eax
  803a13:	e8 cb fe ff ff       	call   8038e3 <nsipc>
}
  803a18:	c9                   	leave  
  803a19:	c3                   	ret    

00803a1a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a1a:	55                   	push   %ebp
  803a1b:	89 e5                	mov    %esp,%ebp
  803a1d:	53                   	push   %ebx
  803a1e:	83 ec 14             	sub    $0x14,%esp
  803a21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a37:	c7 04 24 04 c0 80 00 	movl   $0x80c004,(%esp)
  803a3e:	e8 41 eb ff ff       	call   802584 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803a43:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803a49:	b8 05 00 00 00       	mov    $0x5,%eax
  803a4e:	e8 90 fe ff ff       	call   8038e3 <nsipc>
}
  803a53:	83 c4 14             	add    $0x14,%esp
  803a56:	5b                   	pop    %ebx
  803a57:	5d                   	pop    %ebp
  803a58:	c3                   	ret    

00803a59 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a59:	55                   	push   %ebp
  803a5a:	89 e5                	mov    %esp,%ebp
  803a5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a62:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  803a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a6a:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  803a6f:	b8 06 00 00 00       	mov    $0x6,%eax
  803a74:	e8 6a fe ff ff       	call   8038e3 <nsipc>
}
  803a79:	c9                   	leave  
  803a7a:	c3                   	ret    

00803a7b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a7b:	55                   	push   %ebp
  803a7c:	89 e5                	mov    %esp,%ebp
  803a7e:	56                   	push   %esi
  803a7f:	53                   	push   %ebx
  803a80:	83 ec 10             	sub    $0x10,%esp
  803a83:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803a86:	8b 45 08             	mov    0x8(%ebp),%eax
  803a89:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  803a8e:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  803a94:	8b 45 14             	mov    0x14(%ebp),%eax
  803a97:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a9c:	b8 07 00 00 00       	mov    $0x7,%eax
  803aa1:	e8 3d fe ff ff       	call   8038e3 <nsipc>
  803aa6:	89 c3                	mov    %eax,%ebx
  803aa8:	85 c0                	test   %eax,%eax
  803aaa:	78 46                	js     803af2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  803aac:	39 f0                	cmp    %esi,%eax
  803aae:	7f 07                	jg     803ab7 <nsipc_recv+0x3c>
  803ab0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803ab5:	7e 24                	jle    803adb <nsipc_recv+0x60>
  803ab7:	c7 44 24 0c 12 4e 80 	movl   $0x804e12,0xc(%esp)
  803abe:	00 
  803abf:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  803ac6:	00 
  803ac7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  803ace:	00 
  803acf:	c7 04 24 27 4e 80 00 	movl   $0x804e27,(%esp)
  803ad6:	e8 e6 e1 ff ff       	call   801cc1 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803adb:	89 44 24 08          	mov    %eax,0x8(%esp)
  803adf:	c7 44 24 04 00 c0 80 	movl   $0x80c000,0x4(%esp)
  803ae6:	00 
  803ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aea:	89 04 24             	mov    %eax,(%esp)
  803aed:	e8 92 ea ff ff       	call   802584 <memmove>
	}

	return r;
}
  803af2:	89 d8                	mov    %ebx,%eax
  803af4:	83 c4 10             	add    $0x10,%esp
  803af7:	5b                   	pop    %ebx
  803af8:	5e                   	pop    %esi
  803af9:	5d                   	pop    %ebp
  803afa:	c3                   	ret    

00803afb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803afb:	55                   	push   %ebp
  803afc:	89 e5                	mov    %esp,%ebp
  803afe:	53                   	push   %ebx
  803aff:	83 ec 14             	sub    $0x14,%esp
  803b02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803b05:	8b 45 08             	mov    0x8(%ebp),%eax
  803b08:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  803b0d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803b13:	7e 24                	jle    803b39 <nsipc_send+0x3e>
  803b15:	c7 44 24 0c 33 4e 80 	movl   $0x804e33,0xc(%esp)
  803b1c:	00 
  803b1d:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  803b24:	00 
  803b25:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  803b2c:	00 
  803b2d:	c7 04 24 27 4e 80 00 	movl   $0x804e27,(%esp)
  803b34:	e8 88 e1 ff ff       	call   801cc1 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b39:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b44:	c7 04 24 0c c0 80 00 	movl   $0x80c00c,(%esp)
  803b4b:	e8 34 ea ff ff       	call   802584 <memmove>
	nsipcbuf.send.req_size = size;
  803b50:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  803b56:	8b 45 14             	mov    0x14(%ebp),%eax
  803b59:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803b5e:	b8 08 00 00 00       	mov    $0x8,%eax
  803b63:	e8 7b fd ff ff       	call   8038e3 <nsipc>
}
  803b68:	83 c4 14             	add    $0x14,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5d                   	pop    %ebp
  803b6d:	c3                   	ret    

00803b6e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b6e:	55                   	push   %ebp
  803b6f:	89 e5                	mov    %esp,%ebp
  803b71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803b74:	8b 45 08             	mov    0x8(%ebp),%eax
  803b77:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7f:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803b84:	8b 45 10             	mov    0x10(%ebp),%eax
  803b87:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803b8c:	b8 09 00 00 00       	mov    $0x9,%eax
  803b91:	e8 4d fd ff ff       	call   8038e3 <nsipc>
}
  803b96:	c9                   	leave  
  803b97:	c3                   	ret    

00803b98 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b98:	55                   	push   %ebp
  803b99:	89 e5                	mov    %esp,%ebp
  803b9b:	56                   	push   %esi
  803b9c:	53                   	push   %ebx
  803b9d:	83 ec 10             	sub    $0x10,%esp
  803ba0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba6:	89 04 24             	mov    %eax,(%esp)
  803ba9:	e8 42 f2 ff ff       	call   802df0 <fd2data>
  803bae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803bb0:	c7 44 24 04 3f 4e 80 	movl   $0x804e3f,0x4(%esp)
  803bb7:	00 
  803bb8:	89 1c 24             	mov    %ebx,(%esp)
  803bbb:	e8 27 e8 ff ff       	call   8023e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803bc0:	8b 46 04             	mov    0x4(%esi),%eax
  803bc3:	2b 06                	sub    (%esi),%eax
  803bc5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803bcb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803bd2:	00 00 00 
	stat->st_dev = &devpipe;
  803bd5:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  803bdc:	90 80 00 
	return 0;
}
  803bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  803be4:	83 c4 10             	add    $0x10,%esp
  803be7:	5b                   	pop    %ebx
  803be8:	5e                   	pop    %esi
  803be9:	5d                   	pop    %ebp
  803bea:	c3                   	ret    

00803beb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803beb:	55                   	push   %ebp
  803bec:	89 e5                	mov    %esp,%ebp
  803bee:	53                   	push   %ebx
  803bef:	83 ec 14             	sub    $0x14,%esp
  803bf2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803bf5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803bf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c00:	e8 a5 ec ff ff       	call   8028aa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803c05:	89 1c 24             	mov    %ebx,(%esp)
  803c08:	e8 e3 f1 ff ff       	call   802df0 <fd2data>
  803c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c18:	e8 8d ec ff ff       	call   8028aa <sys_page_unmap>
}
  803c1d:	83 c4 14             	add    $0x14,%esp
  803c20:	5b                   	pop    %ebx
  803c21:	5d                   	pop    %ebp
  803c22:	c3                   	ret    

00803c23 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c23:	55                   	push   %ebp
  803c24:	89 e5                	mov    %esp,%ebp
  803c26:	57                   	push   %edi
  803c27:	56                   	push   %esi
  803c28:	53                   	push   %ebx
  803c29:	83 ec 2c             	sub    $0x2c,%esp
  803c2c:	89 c6                	mov    %eax,%esi
  803c2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c31:	a1 10 a0 80 00       	mov    0x80a010,%eax
  803c36:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803c39:	89 34 24             	mov    %esi,(%esp)
  803c3c:	e8 10 fa ff ff       	call   803651 <pageref>
  803c41:	89 c7                	mov    %eax,%edi
  803c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c46:	89 04 24             	mov    %eax,(%esp)
  803c49:	e8 03 fa ff ff       	call   803651 <pageref>
  803c4e:	39 c7                	cmp    %eax,%edi
  803c50:	0f 94 c2             	sete   %dl
  803c53:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  803c56:	8b 0d 10 a0 80 00    	mov    0x80a010,%ecx
  803c5c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  803c5f:	39 fb                	cmp    %edi,%ebx
  803c61:	74 21                	je     803c84 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803c63:	84 d2                	test   %dl,%dl
  803c65:	74 ca                	je     803c31 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c67:	8b 51 58             	mov    0x58(%ecx),%edx
  803c6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803c72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803c76:	c7 04 24 46 4e 80 00 	movl   $0x804e46,(%esp)
  803c7d:	e8 38 e1 ff ff       	call   801dba <cprintf>
  803c82:	eb ad                	jmp    803c31 <_pipeisclosed+0xe>
	}
}
  803c84:	83 c4 2c             	add    $0x2c,%esp
  803c87:	5b                   	pop    %ebx
  803c88:	5e                   	pop    %esi
  803c89:	5f                   	pop    %edi
  803c8a:	5d                   	pop    %ebp
  803c8b:	c3                   	ret    

00803c8c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c8c:	55                   	push   %ebp
  803c8d:	89 e5                	mov    %esp,%ebp
  803c8f:	57                   	push   %edi
  803c90:	56                   	push   %esi
  803c91:	53                   	push   %ebx
  803c92:	83 ec 1c             	sub    $0x1c,%esp
  803c95:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c98:	89 34 24             	mov    %esi,(%esp)
  803c9b:	e8 50 f1 ff ff       	call   802df0 <fd2data>
  803ca0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ca2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca7:	eb 45                	jmp    803cee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ca9:	89 da                	mov    %ebx,%edx
  803cab:	89 f0                	mov    %esi,%eax
  803cad:	e8 71 ff ff ff       	call   803c23 <_pipeisclosed>
  803cb2:	85 c0                	test   %eax,%eax
  803cb4:	75 41                	jne    803cf7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803cb6:	e8 29 eb ff ff       	call   8027e4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803cbb:	8b 43 04             	mov    0x4(%ebx),%eax
  803cbe:	8b 0b                	mov    (%ebx),%ecx
  803cc0:	8d 51 20             	lea    0x20(%ecx),%edx
  803cc3:	39 d0                	cmp    %edx,%eax
  803cc5:	73 e2                	jae    803ca9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803cca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803cce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803cd1:	99                   	cltd   
  803cd2:	c1 ea 1b             	shr    $0x1b,%edx
  803cd5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803cd8:	83 e1 1f             	and    $0x1f,%ecx
  803cdb:	29 d1                	sub    %edx,%ecx
  803cdd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  803ce1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803ce5:	83 c0 01             	add    $0x1,%eax
  803ce8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ceb:	83 c7 01             	add    $0x1,%edi
  803cee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803cf1:	75 c8                	jne    803cbb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803cf3:	89 f8                	mov    %edi,%eax
  803cf5:	eb 05                	jmp    803cfc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803cf7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  803cfc:	83 c4 1c             	add    $0x1c,%esp
  803cff:	5b                   	pop    %ebx
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    

00803d04 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d04:	55                   	push   %ebp
  803d05:	89 e5                	mov    %esp,%ebp
  803d07:	57                   	push   %edi
  803d08:	56                   	push   %esi
  803d09:	53                   	push   %ebx
  803d0a:	83 ec 1c             	sub    $0x1c,%esp
  803d0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d10:	89 3c 24             	mov    %edi,(%esp)
  803d13:	e8 d8 f0 ff ff       	call   802df0 <fd2data>
  803d18:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d1a:	be 00 00 00 00       	mov    $0x0,%esi
  803d1f:	eb 3d                	jmp    803d5e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d21:	85 f6                	test   %esi,%esi
  803d23:	74 04                	je     803d29 <devpipe_read+0x25>
				return i;
  803d25:	89 f0                	mov    %esi,%eax
  803d27:	eb 43                	jmp    803d6c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d29:	89 da                	mov    %ebx,%edx
  803d2b:	89 f8                	mov    %edi,%eax
  803d2d:	e8 f1 fe ff ff       	call   803c23 <_pipeisclosed>
  803d32:	85 c0                	test   %eax,%eax
  803d34:	75 31                	jne    803d67 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d36:	e8 a9 ea ff ff       	call   8027e4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d3b:	8b 03                	mov    (%ebx),%eax
  803d3d:	3b 43 04             	cmp    0x4(%ebx),%eax
  803d40:	74 df                	je     803d21 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d42:	99                   	cltd   
  803d43:	c1 ea 1b             	shr    $0x1b,%edx
  803d46:	01 d0                	add    %edx,%eax
  803d48:	83 e0 1f             	and    $0x1f,%eax
  803d4b:	29 d0                	sub    %edx,%eax
  803d4d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803d55:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803d58:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d5b:	83 c6 01             	add    $0x1,%esi
  803d5e:	3b 75 10             	cmp    0x10(%ebp),%esi
  803d61:	75 d8                	jne    803d3b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803d63:	89 f0                	mov    %esi,%eax
  803d65:	eb 05                	jmp    803d6c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803d67:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  803d6c:	83 c4 1c             	add    $0x1c,%esp
  803d6f:	5b                   	pop    %ebx
  803d70:	5e                   	pop    %esi
  803d71:	5f                   	pop    %edi
  803d72:	5d                   	pop    %ebp
  803d73:	c3                   	ret    

00803d74 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d74:	55                   	push   %ebp
  803d75:	89 e5                	mov    %esp,%ebp
  803d77:	56                   	push   %esi
  803d78:	53                   	push   %ebx
  803d79:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d7f:	89 04 24             	mov    %eax,(%esp)
  803d82:	e8 80 f0 ff ff       	call   802e07 <fd_alloc>
  803d87:	89 c2                	mov    %eax,%edx
  803d89:	85 d2                	test   %edx,%edx
  803d8b:	0f 88 4d 01 00 00    	js     803ede <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d91:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803d98:	00 
  803d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803da0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803da7:	e8 57 ea ff ff       	call   802803 <sys_page_alloc>
  803dac:	89 c2                	mov    %eax,%edx
  803dae:	85 d2                	test   %edx,%edx
  803db0:	0f 88 28 01 00 00    	js     803ede <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803db6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803db9:	89 04 24             	mov    %eax,(%esp)
  803dbc:	e8 46 f0 ff ff       	call   802e07 <fd_alloc>
  803dc1:	89 c3                	mov    %eax,%ebx
  803dc3:	85 c0                	test   %eax,%eax
  803dc5:	0f 88 fe 00 00 00    	js     803ec9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dcb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803dd2:	00 
  803dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803de1:	e8 1d ea ff ff       	call   802803 <sys_page_alloc>
  803de6:	89 c3                	mov    %eax,%ebx
  803de8:	85 c0                	test   %eax,%eax
  803dea:	0f 88 d9 00 00 00    	js     803ec9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df3:	89 04 24             	mov    %eax,(%esp)
  803df6:	e8 f5 ef ff ff       	call   802df0 <fd2data>
  803dfb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dfd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803e04:	00 
  803e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e10:	e8 ee e9 ff ff       	call   802803 <sys_page_alloc>
  803e15:	89 c3                	mov    %eax,%ebx
  803e17:	85 c0                	test   %eax,%eax
  803e19:	0f 88 97 00 00 00    	js     803eb6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e22:	89 04 24             	mov    %eax,(%esp)
  803e25:	e8 c6 ef ff ff       	call   802df0 <fd2data>
  803e2a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803e31:	00 
  803e32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803e3d:	00 
  803e3e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803e42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e49:	e8 09 ea ff ff       	call   802857 <sys_page_map>
  803e4e:	89 c3                	mov    %eax,%ebx
  803e50:	85 c0                	test   %eax,%eax
  803e52:	78 52                	js     803ea6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e54:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e69:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e72:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e77:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e81:	89 04 24             	mov    %eax,(%esp)
  803e84:	e8 57 ef ff ff       	call   802de0 <fd2num>
  803e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803e8c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e91:	89 04 24             	mov    %eax,(%esp)
  803e94:	e8 47 ef ff ff       	call   802de0 <fd2num>
  803e99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803e9c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea4:	eb 38                	jmp    803ede <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
  803eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803eb1:	e8 f4 e9 ff ff       	call   8028aa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ebd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ec4:	e8 e1 e9 ff ff       	call   8028aa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ed0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ed7:	e8 ce e9 ff ff       	call   8028aa <sys_page_unmap>
  803edc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  803ede:	83 c4 30             	add    $0x30,%esp
  803ee1:	5b                   	pop    %ebx
  803ee2:	5e                   	pop    %esi
  803ee3:	5d                   	pop    %ebp
  803ee4:	c3                   	ret    

00803ee5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803ee5:	55                   	push   %ebp
  803ee6:	89 e5                	mov    %esp,%ebp
  803ee8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803eee:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef5:	89 04 24             	mov    %eax,(%esp)
  803ef8:	e8 59 ef ff ff       	call   802e56 <fd_lookup>
  803efd:	89 c2                	mov    %eax,%edx
  803eff:	85 d2                	test   %edx,%edx
  803f01:	78 15                	js     803f18 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f06:	89 04 24             	mov    %eax,(%esp)
  803f09:	e8 e2 ee ff ff       	call   802df0 <fd2data>
	return _pipeisclosed(fd, p);
  803f0e:	89 c2                	mov    %eax,%edx
  803f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f13:	e8 0b fd ff ff       	call   803c23 <_pipeisclosed>
}
  803f18:	c9                   	leave  
  803f19:	c3                   	ret    
  803f1a:	66 90                	xchg   %ax,%ax
  803f1c:	66 90                	xchg   %ax,%ax
  803f1e:	66 90                	xchg   %ax,%ax

00803f20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803f20:	55                   	push   %ebp
  803f21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803f23:	b8 00 00 00 00       	mov    $0x0,%eax
  803f28:	5d                   	pop    %ebp
  803f29:	c3                   	ret    

00803f2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f2a:	55                   	push   %ebp
  803f2b:	89 e5                	mov    %esp,%ebp
  803f2d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803f30:	c7 44 24 04 5e 4e 80 	movl   $0x804e5e,0x4(%esp)
  803f37:	00 
  803f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f3b:	89 04 24             	mov    %eax,(%esp)
  803f3e:	e8 a4 e4 ff ff       	call   8023e7 <strcpy>
	return 0;
}
  803f43:	b8 00 00 00 00       	mov    $0x0,%eax
  803f48:	c9                   	leave  
  803f49:	c3                   	ret    

00803f4a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f4a:	55                   	push   %ebp
  803f4b:	89 e5                	mov    %esp,%ebp
  803f4d:	57                   	push   %edi
  803f4e:	56                   	push   %esi
  803f4f:	53                   	push   %ebx
  803f50:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f56:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803f5b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f61:	eb 31                	jmp    803f94 <devcons_write+0x4a>
		m = n - tot;
  803f63:	8b 75 10             	mov    0x10(%ebp),%esi
  803f66:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  803f68:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803f6b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  803f70:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803f73:	89 74 24 08          	mov    %esi,0x8(%esp)
  803f77:	03 45 0c             	add    0xc(%ebp),%eax
  803f7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f7e:	89 3c 24             	mov    %edi,(%esp)
  803f81:	e8 fe e5 ff ff       	call   802584 <memmove>
		sys_cputs(buf, m);
  803f86:	89 74 24 04          	mov    %esi,0x4(%esp)
  803f8a:	89 3c 24             	mov    %edi,(%esp)
  803f8d:	e8 a4 e7 ff ff       	call   802736 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f92:	01 f3                	add    %esi,%ebx
  803f94:	89 d8                	mov    %ebx,%eax
  803f96:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  803f99:	72 c8                	jb     803f63 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803f9b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803fa1:	5b                   	pop    %ebx
  803fa2:	5e                   	pop    %esi
  803fa3:	5f                   	pop    %edi
  803fa4:	5d                   	pop    %ebp
  803fa5:	c3                   	ret    

00803fa6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fa6:	55                   	push   %ebp
  803fa7:	89 e5                	mov    %esp,%ebp
  803fa9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803fac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803fb5:	75 07                	jne    803fbe <devcons_read+0x18>
  803fb7:	eb 2a                	jmp    803fe3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803fb9:	e8 26 e8 ff ff       	call   8027e4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803fbe:	66 90                	xchg   %ax,%ax
  803fc0:	e8 8f e7 ff ff       	call   802754 <sys_cgetc>
  803fc5:	85 c0                	test   %eax,%eax
  803fc7:	74 f0                	je     803fb9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  803fc9:	85 c0                	test   %eax,%eax
  803fcb:	78 16                	js     803fe3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803fcd:	83 f8 04             	cmp    $0x4,%eax
  803fd0:	74 0c                	je     803fde <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  803fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  803fd5:	88 02                	mov    %al,(%edx)
	return 1;
  803fd7:	b8 01 00 00 00       	mov    $0x1,%eax
  803fdc:	eb 05                	jmp    803fe3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803fde:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803fe3:	c9                   	leave  
  803fe4:	c3                   	ret    

00803fe5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fe5:	55                   	push   %ebp
  803fe6:	89 e5                	mov    %esp,%ebp
  803fe8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803feb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ff1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803ff8:	00 
  803ff9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803ffc:	89 04 24             	mov    %eax,(%esp)
  803fff:	e8 32 e7 ff ff       	call   802736 <sys_cputs>
}
  804004:	c9                   	leave  
  804005:	c3                   	ret    

00804006 <getchar>:

int
getchar(void)
{
  804006:	55                   	push   %ebp
  804007:	89 e5                	mov    %esp,%ebp
  804009:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80400c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804013:	00 
  804014:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804017:	89 44 24 04          	mov    %eax,0x4(%esp)
  80401b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804022:	e8 c3 f0 ff ff       	call   8030ea <read>
	if (r < 0)
  804027:	85 c0                	test   %eax,%eax
  804029:	78 0f                	js     80403a <getchar+0x34>
		return r;
	if (r < 1)
  80402b:	85 c0                	test   %eax,%eax
  80402d:	7e 06                	jle    804035 <getchar+0x2f>
		return -E_EOF;
	return c;
  80402f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804033:	eb 05                	jmp    80403a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  804035:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80403a:	c9                   	leave  
  80403b:	c3                   	ret    

0080403c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80403c:	55                   	push   %ebp
  80403d:	89 e5                	mov    %esp,%ebp
  80403f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804042:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804045:	89 44 24 04          	mov    %eax,0x4(%esp)
  804049:	8b 45 08             	mov    0x8(%ebp),%eax
  80404c:	89 04 24             	mov    %eax,(%esp)
  80404f:	e8 02 ee ff ff       	call   802e56 <fd_lookup>
  804054:	85 c0                	test   %eax,%eax
  804056:	78 11                	js     804069 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  804058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80405b:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  804061:	39 10                	cmp    %edx,(%eax)
  804063:	0f 94 c0             	sete   %al
  804066:	0f b6 c0             	movzbl %al,%eax
}
  804069:	c9                   	leave  
  80406a:	c3                   	ret    

0080406b <opencons>:

int
opencons(void)
{
  80406b:	55                   	push   %ebp
  80406c:	89 e5                	mov    %esp,%ebp
  80406e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804071:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804074:	89 04 24             	mov    %eax,(%esp)
  804077:	e8 8b ed ff ff       	call   802e07 <fd_alloc>
		return r;
  80407c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80407e:	85 c0                	test   %eax,%eax
  804080:	78 40                	js     8040c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804082:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804089:	00 
  80408a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80408d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804098:	e8 66 e7 ff ff       	call   802803 <sys_page_alloc>
		return r;
  80409d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80409f:	85 c0                	test   %eax,%eax
  8040a1:	78 1f                	js     8040c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8040a3:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  8040a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8040ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8040b8:	89 04 24             	mov    %eax,(%esp)
  8040bb:	e8 20 ed ff ff       	call   802de0 <fd2num>
  8040c0:	89 c2                	mov    %eax,%edx
}
  8040c2:	89 d0                	mov    %edx,%eax
  8040c4:	c9                   	leave  
  8040c5:	c3                   	ret    
  8040c6:	66 90                	xchg   %ax,%ax
  8040c8:	66 90                	xchg   %ax,%ax
  8040ca:	66 90                	xchg   %ax,%ax
  8040cc:	66 90                	xchg   %ax,%ax
  8040ce:	66 90                	xchg   %ax,%ax

008040d0 <__udivdi3>:
  8040d0:	55                   	push   %ebp
  8040d1:	57                   	push   %edi
  8040d2:	56                   	push   %esi
  8040d3:	83 ec 0c             	sub    $0xc,%esp
  8040d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8040da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8040de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8040e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8040e6:	85 c0                	test   %eax,%eax
  8040e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8040ec:	89 ea                	mov    %ebp,%edx
  8040ee:	89 0c 24             	mov    %ecx,(%esp)
  8040f1:	75 2d                	jne    804120 <__udivdi3+0x50>
  8040f3:	39 e9                	cmp    %ebp,%ecx
  8040f5:	77 61                	ja     804158 <__udivdi3+0x88>
  8040f7:	85 c9                	test   %ecx,%ecx
  8040f9:	89 ce                	mov    %ecx,%esi
  8040fb:	75 0b                	jne    804108 <__udivdi3+0x38>
  8040fd:	b8 01 00 00 00       	mov    $0x1,%eax
  804102:	31 d2                	xor    %edx,%edx
  804104:	f7 f1                	div    %ecx
  804106:	89 c6                	mov    %eax,%esi
  804108:	31 d2                	xor    %edx,%edx
  80410a:	89 e8                	mov    %ebp,%eax
  80410c:	f7 f6                	div    %esi
  80410e:	89 c5                	mov    %eax,%ebp
  804110:	89 f8                	mov    %edi,%eax
  804112:	f7 f6                	div    %esi
  804114:	89 ea                	mov    %ebp,%edx
  804116:	83 c4 0c             	add    $0xc,%esp
  804119:	5e                   	pop    %esi
  80411a:	5f                   	pop    %edi
  80411b:	5d                   	pop    %ebp
  80411c:	c3                   	ret    
  80411d:	8d 76 00             	lea    0x0(%esi),%esi
  804120:	39 e8                	cmp    %ebp,%eax
  804122:	77 24                	ja     804148 <__udivdi3+0x78>
  804124:	0f bd e8             	bsr    %eax,%ebp
  804127:	83 f5 1f             	xor    $0x1f,%ebp
  80412a:	75 3c                	jne    804168 <__udivdi3+0x98>
  80412c:	8b 74 24 04          	mov    0x4(%esp),%esi
  804130:	39 34 24             	cmp    %esi,(%esp)
  804133:	0f 86 9f 00 00 00    	jbe    8041d8 <__udivdi3+0x108>
  804139:	39 d0                	cmp    %edx,%eax
  80413b:	0f 82 97 00 00 00    	jb     8041d8 <__udivdi3+0x108>
  804141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804148:	31 d2                	xor    %edx,%edx
  80414a:	31 c0                	xor    %eax,%eax
  80414c:	83 c4 0c             	add    $0xc,%esp
  80414f:	5e                   	pop    %esi
  804150:	5f                   	pop    %edi
  804151:	5d                   	pop    %ebp
  804152:	c3                   	ret    
  804153:	90                   	nop
  804154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804158:	89 f8                	mov    %edi,%eax
  80415a:	f7 f1                	div    %ecx
  80415c:	31 d2                	xor    %edx,%edx
  80415e:	83 c4 0c             	add    $0xc,%esp
  804161:	5e                   	pop    %esi
  804162:	5f                   	pop    %edi
  804163:	5d                   	pop    %ebp
  804164:	c3                   	ret    
  804165:	8d 76 00             	lea    0x0(%esi),%esi
  804168:	89 e9                	mov    %ebp,%ecx
  80416a:	8b 3c 24             	mov    (%esp),%edi
  80416d:	d3 e0                	shl    %cl,%eax
  80416f:	89 c6                	mov    %eax,%esi
  804171:	b8 20 00 00 00       	mov    $0x20,%eax
  804176:	29 e8                	sub    %ebp,%eax
  804178:	89 c1                	mov    %eax,%ecx
  80417a:	d3 ef                	shr    %cl,%edi
  80417c:	89 e9                	mov    %ebp,%ecx
  80417e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  804182:	8b 3c 24             	mov    (%esp),%edi
  804185:	09 74 24 08          	or     %esi,0x8(%esp)
  804189:	89 d6                	mov    %edx,%esi
  80418b:	d3 e7                	shl    %cl,%edi
  80418d:	89 c1                	mov    %eax,%ecx
  80418f:	89 3c 24             	mov    %edi,(%esp)
  804192:	8b 7c 24 04          	mov    0x4(%esp),%edi
  804196:	d3 ee                	shr    %cl,%esi
  804198:	89 e9                	mov    %ebp,%ecx
  80419a:	d3 e2                	shl    %cl,%edx
  80419c:	89 c1                	mov    %eax,%ecx
  80419e:	d3 ef                	shr    %cl,%edi
  8041a0:	09 d7                	or     %edx,%edi
  8041a2:	89 f2                	mov    %esi,%edx
  8041a4:	89 f8                	mov    %edi,%eax
  8041a6:	f7 74 24 08          	divl   0x8(%esp)
  8041aa:	89 d6                	mov    %edx,%esi
  8041ac:	89 c7                	mov    %eax,%edi
  8041ae:	f7 24 24             	mull   (%esp)
  8041b1:	39 d6                	cmp    %edx,%esi
  8041b3:	89 14 24             	mov    %edx,(%esp)
  8041b6:	72 30                	jb     8041e8 <__udivdi3+0x118>
  8041b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041bc:	89 e9                	mov    %ebp,%ecx
  8041be:	d3 e2                	shl    %cl,%edx
  8041c0:	39 c2                	cmp    %eax,%edx
  8041c2:	73 05                	jae    8041c9 <__udivdi3+0xf9>
  8041c4:	3b 34 24             	cmp    (%esp),%esi
  8041c7:	74 1f                	je     8041e8 <__udivdi3+0x118>
  8041c9:	89 f8                	mov    %edi,%eax
  8041cb:	31 d2                	xor    %edx,%edx
  8041cd:	e9 7a ff ff ff       	jmp    80414c <__udivdi3+0x7c>
  8041d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8041d8:	31 d2                	xor    %edx,%edx
  8041da:	b8 01 00 00 00       	mov    $0x1,%eax
  8041df:	e9 68 ff ff ff       	jmp    80414c <__udivdi3+0x7c>
  8041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8041e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8041eb:	31 d2                	xor    %edx,%edx
  8041ed:	83 c4 0c             	add    $0xc,%esp
  8041f0:	5e                   	pop    %esi
  8041f1:	5f                   	pop    %edi
  8041f2:	5d                   	pop    %ebp
  8041f3:	c3                   	ret    
  8041f4:	66 90                	xchg   %ax,%ax
  8041f6:	66 90                	xchg   %ax,%ax
  8041f8:	66 90                	xchg   %ax,%ax
  8041fa:	66 90                	xchg   %ax,%ax
  8041fc:	66 90                	xchg   %ax,%ax
  8041fe:	66 90                	xchg   %ax,%ax

00804200 <__umoddi3>:
  804200:	55                   	push   %ebp
  804201:	57                   	push   %edi
  804202:	56                   	push   %esi
  804203:	83 ec 14             	sub    $0x14,%esp
  804206:	8b 44 24 28          	mov    0x28(%esp),%eax
  80420a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80420e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  804212:	89 c7                	mov    %eax,%edi
  804214:	89 44 24 04          	mov    %eax,0x4(%esp)
  804218:	8b 44 24 30          	mov    0x30(%esp),%eax
  80421c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  804220:	89 34 24             	mov    %esi,(%esp)
  804223:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804227:	85 c0                	test   %eax,%eax
  804229:	89 c2                	mov    %eax,%edx
  80422b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80422f:	75 17                	jne    804248 <__umoddi3+0x48>
  804231:	39 fe                	cmp    %edi,%esi
  804233:	76 4b                	jbe    804280 <__umoddi3+0x80>
  804235:	89 c8                	mov    %ecx,%eax
  804237:	89 fa                	mov    %edi,%edx
  804239:	f7 f6                	div    %esi
  80423b:	89 d0                	mov    %edx,%eax
  80423d:	31 d2                	xor    %edx,%edx
  80423f:	83 c4 14             	add    $0x14,%esp
  804242:	5e                   	pop    %esi
  804243:	5f                   	pop    %edi
  804244:	5d                   	pop    %ebp
  804245:	c3                   	ret    
  804246:	66 90                	xchg   %ax,%ax
  804248:	39 f8                	cmp    %edi,%eax
  80424a:	77 54                	ja     8042a0 <__umoddi3+0xa0>
  80424c:	0f bd e8             	bsr    %eax,%ebp
  80424f:	83 f5 1f             	xor    $0x1f,%ebp
  804252:	75 5c                	jne    8042b0 <__umoddi3+0xb0>
  804254:	8b 7c 24 08          	mov    0x8(%esp),%edi
  804258:	39 3c 24             	cmp    %edi,(%esp)
  80425b:	0f 87 e7 00 00 00    	ja     804348 <__umoddi3+0x148>
  804261:	8b 7c 24 04          	mov    0x4(%esp),%edi
  804265:	29 f1                	sub    %esi,%ecx
  804267:	19 c7                	sbb    %eax,%edi
  804269:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80426d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804271:	8b 44 24 08          	mov    0x8(%esp),%eax
  804275:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804279:	83 c4 14             	add    $0x14,%esp
  80427c:	5e                   	pop    %esi
  80427d:	5f                   	pop    %edi
  80427e:	5d                   	pop    %ebp
  80427f:	c3                   	ret    
  804280:	85 f6                	test   %esi,%esi
  804282:	89 f5                	mov    %esi,%ebp
  804284:	75 0b                	jne    804291 <__umoddi3+0x91>
  804286:	b8 01 00 00 00       	mov    $0x1,%eax
  80428b:	31 d2                	xor    %edx,%edx
  80428d:	f7 f6                	div    %esi
  80428f:	89 c5                	mov    %eax,%ebp
  804291:	8b 44 24 04          	mov    0x4(%esp),%eax
  804295:	31 d2                	xor    %edx,%edx
  804297:	f7 f5                	div    %ebp
  804299:	89 c8                	mov    %ecx,%eax
  80429b:	f7 f5                	div    %ebp
  80429d:	eb 9c                	jmp    80423b <__umoddi3+0x3b>
  80429f:	90                   	nop
  8042a0:	89 c8                	mov    %ecx,%eax
  8042a2:	89 fa                	mov    %edi,%edx
  8042a4:	83 c4 14             	add    $0x14,%esp
  8042a7:	5e                   	pop    %esi
  8042a8:	5f                   	pop    %edi
  8042a9:	5d                   	pop    %ebp
  8042aa:	c3                   	ret    
  8042ab:	90                   	nop
  8042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8042b0:	8b 04 24             	mov    (%esp),%eax
  8042b3:	be 20 00 00 00       	mov    $0x20,%esi
  8042b8:	89 e9                	mov    %ebp,%ecx
  8042ba:	29 ee                	sub    %ebp,%esi
  8042bc:	d3 e2                	shl    %cl,%edx
  8042be:	89 f1                	mov    %esi,%ecx
  8042c0:	d3 e8                	shr    %cl,%eax
  8042c2:	89 e9                	mov    %ebp,%ecx
  8042c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042c8:	8b 04 24             	mov    (%esp),%eax
  8042cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8042cf:	89 fa                	mov    %edi,%edx
  8042d1:	d3 e0                	shl    %cl,%eax
  8042d3:	89 f1                	mov    %esi,%ecx
  8042d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8042d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8042dd:	d3 ea                	shr    %cl,%edx
  8042df:	89 e9                	mov    %ebp,%ecx
  8042e1:	d3 e7                	shl    %cl,%edi
  8042e3:	89 f1                	mov    %esi,%ecx
  8042e5:	d3 e8                	shr    %cl,%eax
  8042e7:	89 e9                	mov    %ebp,%ecx
  8042e9:	09 f8                	or     %edi,%eax
  8042eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8042ef:	f7 74 24 04          	divl   0x4(%esp)
  8042f3:	d3 e7                	shl    %cl,%edi
  8042f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042f9:	89 d7                	mov    %edx,%edi
  8042fb:	f7 64 24 08          	mull   0x8(%esp)
  8042ff:	39 d7                	cmp    %edx,%edi
  804301:	89 c1                	mov    %eax,%ecx
  804303:	89 14 24             	mov    %edx,(%esp)
  804306:	72 2c                	jb     804334 <__umoddi3+0x134>
  804308:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80430c:	72 22                	jb     804330 <__umoddi3+0x130>
  80430e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  804312:	29 c8                	sub    %ecx,%eax
  804314:	19 d7                	sbb    %edx,%edi
  804316:	89 e9                	mov    %ebp,%ecx
  804318:	89 fa                	mov    %edi,%edx
  80431a:	d3 e8                	shr    %cl,%eax
  80431c:	89 f1                	mov    %esi,%ecx
  80431e:	d3 e2                	shl    %cl,%edx
  804320:	89 e9                	mov    %ebp,%ecx
  804322:	d3 ef                	shr    %cl,%edi
  804324:	09 d0                	or     %edx,%eax
  804326:	89 fa                	mov    %edi,%edx
  804328:	83 c4 14             	add    $0x14,%esp
  80432b:	5e                   	pop    %esi
  80432c:	5f                   	pop    %edi
  80432d:	5d                   	pop    %ebp
  80432e:	c3                   	ret    
  80432f:	90                   	nop
  804330:	39 d7                	cmp    %edx,%edi
  804332:	75 da                	jne    80430e <__umoddi3+0x10e>
  804334:	8b 14 24             	mov    (%esp),%edx
  804337:	89 c1                	mov    %eax,%ecx
  804339:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80433d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  804341:	eb cb                	jmp    80430e <__umoddi3+0x10e>
  804343:	90                   	nop
  804344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804348:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80434c:	0f 82 0f ff ff ff    	jb     804261 <__umoddi3+0x61>
  804352:	e9 1a ff ff ff       	jmp    804271 <__umoddi3+0x71>
