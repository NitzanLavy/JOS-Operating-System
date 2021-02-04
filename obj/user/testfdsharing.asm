
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 e8 01 00 00       	call   800219 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800043:	00 
  800044:	c7 04 24 a0 2d 80 00 	movl   $0x802da0,(%esp)
  80004b:	e8 76 1d 00 00       	call   801dc6 <open>
  800050:	89 c3                	mov    %eax,%ebx
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("open motd: %e", fd);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 a5 2d 80 	movl   $0x802da5,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  800071:	e8 08 02 00 00       	call   80027e <_panic>
	seek(fd, 0);
  800076:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007d:	00 
  80007e:	89 04 24             	mov    %eax,(%esp)
  800081:	e8 de 19 00 00       	call   801a64 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800086:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 20 52 80 	movl   $0x805220,0x4(%esp)
  800095:	00 
  800096:	89 1c 24             	mov    %ebx,(%esp)
  800099:	e8 ee 18 00 00       	call   80198c <readn>
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	7f 20                	jg     8000c4 <umain+0x91>
		panic("readn: %e", n);
  8000a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a8:	c7 44 24 08 c8 2d 80 	movl   $0x802dc8,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b7:	00 
  8000b8:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  8000bf:	e8 ba 01 00 00       	call   80027e <_panic>

	if ((r = fork()) < 0)
  8000c4:	e8 51 12 00 00       	call   80131a <fork>
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	85 c0                	test   %eax,%eax
  8000cd:	79 20                	jns    8000ef <umain+0xbc>
		panic("fork: %e", r);
  8000cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d3:	c7 44 24 08 d2 2d 80 	movl   $0x802dd2,0x8(%esp)
  8000da:	00 
  8000db:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e2:	00 
  8000e3:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  8000ea:	e8 8f 01 00 00       	call   80027e <_panic>
	if (r == 0) {
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	0f 85 bd 00 00 00    	jne    8001b4 <umain+0x181>
		seek(fd, 0);
  8000f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fe:	00 
  8000ff:	89 1c 24             	mov    %ebx,(%esp)
  800102:	e8 5d 19 00 00       	call   801a64 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800107:	c7 04 24 10 2e 80 00 	movl   $0x802e10,(%esp)
  80010e:	e8 64 02 00 00       	call   800377 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800113:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011a:	00 
  80011b:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  800122:	00 
  800123:	89 1c 24             	mov    %ebx,(%esp)
  800126:	e8 61 18 00 00       	call   80198c <readn>
  80012b:	39 f8                	cmp    %edi,%eax
  80012d:	74 24                	je     800153 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  80012f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800133:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800137:	c7 44 24 08 54 2e 80 	movl   $0x802e54,0x8(%esp)
  80013e:	00 
  80013f:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800146:	00 
  800147:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  80014e:	e8 2b 01 00 00       	call   80027e <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800153:	89 44 24 08          	mov    %eax,0x8(%esp)
  800157:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  80015e:	00 
  80015f:	c7 04 24 20 52 80 00 	movl   $0x805220,(%esp)
  800166:	e8 62 0a 00 00       	call   800bcd <memcmp>
  80016b:	85 c0                	test   %eax,%eax
  80016d:	74 1c                	je     80018b <umain+0x158>
			panic("read in parent got different bytes from read in child");
  80016f:	c7 44 24 08 80 2e 80 	movl   $0x802e80,0x8(%esp)
  800176:	00 
  800177:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017e:	00 
  80017f:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  800186:	e8 f3 00 00 00       	call   80027e <_panic>
		cprintf("read in child succeeded\n");
  80018b:	c7 04 24 db 2d 80 00 	movl   $0x802ddb,(%esp)
  800192:	e8 e0 01 00 00       	call   800377 <cprintf>
		seek(fd, 0);
  800197:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019e:	00 
  80019f:	89 1c 24             	mov    %ebx,(%esp)
  8001a2:	e8 bd 18 00 00       	call   801a64 <seek>
		close(fd);
  8001a7:	89 1c 24             	mov    %ebx,(%esp)
  8001aa:	e8 e8 15 00 00       	call   801797 <close>
		exit();
  8001af:	e8 b1 00 00 00       	call   800265 <exit>
	}
	wait(r);
  8001b4:	89 34 24             	mov    %esi,(%esp)
  8001b7:	e8 3e 25 00 00       	call   8026fa <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c3:	00 
  8001c4:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  8001cb:	00 
  8001cc:	89 1c 24             	mov    %ebx,(%esp)
  8001cf:	e8 b8 17 00 00       	call   80198c <readn>
  8001d4:	39 f8                	cmp    %edi,%eax
  8001d6:	74 24                	je     8001fc <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e0:	c7 44 24 08 b8 2e 80 	movl   $0x802eb8,0x8(%esp)
  8001e7:	00 
  8001e8:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001ef:	00 
  8001f0:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  8001f7:	e8 82 00 00 00       	call   80027e <_panic>
	cprintf("read in parent succeeded\n");
  8001fc:	c7 04 24 f4 2d 80 00 	movl   $0x802df4,(%esp)
  800203:	e8 6f 01 00 00       	call   800377 <cprintf>
	close(fd);
  800208:	89 1c 24             	mov    %ebx,(%esp)
  80020b:	e8 87 15 00 00       	call   801797 <close>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800210:	cc                   	int3   

	breakpoint();
}
  800211:	83 c4 2c             	add    $0x2c,%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5f                   	pop    %edi
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    

00800219 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 10             	sub    $0x10,%esp
  800221:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800224:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800227:	e8 59 0b 00 00       	call   800d85 <sys_getenvid>
  80022c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800231:	89 c2                	mov    %eax,%edx
  800233:	c1 e2 07             	shl    $0x7,%edx
  800236:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80023d:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800242:	85 db                	test   %ebx,%ebx
  800244:	7e 07                	jle    80024d <libmain+0x34>
		binaryname = argv[0];
  800246:	8b 06                	mov    (%esi),%eax
  800248:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80024d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800251:	89 1c 24             	mov    %ebx,(%esp)
  800254:	e8 da fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800259:	e8 07 00 00 00       	call   800265 <exit>
}
  80025e:	83 c4 10             	add    $0x10,%esp
  800261:	5b                   	pop    %ebx
  800262:	5e                   	pop    %esi
  800263:	5d                   	pop    %ebp
  800264:	c3                   	ret    

00800265 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80026b:	e8 5a 15 00 00       	call   8017ca <close_all>
	sys_env_destroy(0);
  800270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800277:	e8 b7 0a 00 00       	call   800d33 <sys_env_destroy>
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	56                   	push   %esi
  800282:	53                   	push   %ebx
  800283:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800286:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800289:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80028f:	e8 f1 0a 00 00       	call   800d85 <sys_getenvid>
  800294:	8b 55 0c             	mov    0xc(%ebp),%edx
  800297:	89 54 24 10          	mov    %edx,0x10(%esp)
  80029b:	8b 55 08             	mov    0x8(%ebp),%edx
  80029e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a2:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002aa:	c7 04 24 e8 2e 80 00 	movl   $0x802ee8,(%esp)
  8002b1:	e8 c1 00 00 00       	call   800377 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bd:	89 04 24             	mov    %eax,(%esp)
  8002c0:	e8 51 00 00 00       	call   800316 <vcprintf>
	cprintf("\n");
  8002c5:	c7 04 24 f2 2d 80 00 	movl   $0x802df2,(%esp)
  8002cc:	e8 a6 00 00 00       	call   800377 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d1:	cc                   	int3   
  8002d2:	eb fd                	jmp    8002d1 <_panic+0x53>

008002d4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 14             	sub    $0x14,%esp
  8002db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002de:	8b 13                	mov    (%ebx),%edx
  8002e0:	8d 42 01             	lea    0x1(%edx),%eax
  8002e3:	89 03                	mov    %eax,(%ebx)
  8002e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f1:	75 19                	jne    80030c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002f3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002fa:	00 
  8002fb:	8d 43 08             	lea    0x8(%ebx),%eax
  8002fe:	89 04 24             	mov    %eax,(%esp)
  800301:	e8 f0 09 00 00       	call   800cf6 <sys_cputs>
		b->idx = 0;
  800306:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80030c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800310:	83 c4 14             	add    $0x14,%esp
  800313:	5b                   	pop    %ebx
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    

00800316 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80031f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800326:	00 00 00 
	b.cnt = 0;
  800329:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800330:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800341:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034b:	c7 04 24 d4 02 80 00 	movl   $0x8002d4,(%esp)
  800352:	e8 b7 01 00 00       	call   80050e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800357:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80035d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800361:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800367:	89 04 24             	mov    %eax,(%esp)
  80036a:	e8 87 09 00 00       	call   800cf6 <sys_cputs>

	return b.cnt;
}
  80036f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800375:	c9                   	leave  
  800376:	c3                   	ret    

00800377 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80037d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800380:	89 44 24 04          	mov    %eax,0x4(%esp)
  800384:	8b 45 08             	mov    0x8(%ebp),%eax
  800387:	89 04 24             	mov    %eax,(%esp)
  80038a:	e8 87 ff ff ff       	call   800316 <vcprintf>
	va_end(ap);

	return cnt;
}
  80038f:	c9                   	leave  
  800390:	c3                   	ret    
  800391:	66 90                	xchg   %ax,%ax
  800393:	66 90                	xchg   %ax,%ax
  800395:	66 90                	xchg   %ax,%ax
  800397:	66 90                	xchg   %ax,%ax
  800399:	66 90                	xchg   %ax,%ax
  80039b:	66 90                	xchg   %ax,%ax
  80039d:	66 90                	xchg   %ax,%ax
  80039f:	90                   	nop

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 3c             	sub    $0x3c,%esp
  8003a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ac:	89 d7                	mov    %edx,%edi
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	89 c3                	mov    %eax,%ebx
  8003b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003cd:	39 d9                	cmp    %ebx,%ecx
  8003cf:	72 05                	jb     8003d6 <printnum+0x36>
  8003d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d4:	77 69                	ja     80043f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003dd:	83 ee 01             	sub    $0x1,%esi
  8003e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003f0:	89 c3                	mov    %eax,%ebx
  8003f2:	89 d6                	mov    %edx,%esi
  8003f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 ec 26 00 00       	call   802b00 <__udivdi3>
  800414:	89 d9                	mov    %ebx,%ecx
  800416:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80041a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80041e:	89 04 24             	mov    %eax,(%esp)
  800421:	89 54 24 04          	mov    %edx,0x4(%esp)
  800425:	89 fa                	mov    %edi,%edx
  800427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80042a:	e8 71 ff ff ff       	call   8003a0 <printnum>
  80042f:	eb 1b                	jmp    80044c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800431:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800435:	8b 45 18             	mov    0x18(%ebp),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	ff d3                	call   *%ebx
  80043d:	eb 03                	jmp    800442 <printnum+0xa2>
  80043f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800442:	83 ee 01             	sub    $0x1,%esi
  800445:	85 f6                	test   %esi,%esi
  800447:	7f e8                	jg     800431 <printnum+0x91>
  800449:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80044c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800450:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800457:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80045a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80045e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800465:	89 04 24             	mov    %eax,(%esp)
  800468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046f:	e8 bc 27 00 00       	call   802c30 <__umoddi3>
  800474:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800478:	0f be 80 0b 2f 80 00 	movsbl 0x802f0b(%eax),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800485:	ff d0                	call   *%eax
}
  800487:	83 c4 3c             	add    $0x3c,%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 fa 01             	cmp    $0x1,%edx
  800495:	7e 0e                	jle    8004a5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800497:	8b 10                	mov    (%eax),%edx
  800499:	8d 4a 08             	lea    0x8(%edx),%ecx
  80049c:	89 08                	mov    %ecx,(%eax)
  80049e:	8b 02                	mov    (%edx),%eax
  8004a0:	8b 52 04             	mov    0x4(%edx),%edx
  8004a3:	eb 22                	jmp    8004c7 <getuint+0x38>
	else if (lflag)
  8004a5:	85 d2                	test   %edx,%edx
  8004a7:	74 10                	je     8004b9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004a9:	8b 10                	mov    (%eax),%edx
  8004ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ae:	89 08                	mov    %ecx,(%eax)
  8004b0:	8b 02                	mov    (%edx),%eax
  8004b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b7:	eb 0e                	jmp    8004c7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004b9:	8b 10                	mov    (%eax),%edx
  8004bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004be:	89 08                	mov    %ecx,(%eax)
  8004c0:	8b 02                	mov    (%edx),%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c7:	5d                   	pop    %ebp
  8004c8:	c3                   	ret    

008004c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d3:	8b 10                	mov    (%eax),%edx
  8004d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d8:	73 0a                	jae    8004e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004dd:	89 08                	mov    %ecx,(%eax)
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	88 02                	mov    %al,(%edx)
}
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	89 04 24             	mov    %eax,(%esp)
  800507:	e8 02 00 00 00       	call   80050e <vprintfmt>
	va_end(ap);
}
  80050c:	c9                   	leave  
  80050d:	c3                   	ret    

0080050e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	57                   	push   %edi
  800512:	56                   	push   %esi
  800513:	53                   	push   %ebx
  800514:	83 ec 3c             	sub    $0x3c,%esp
  800517:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80051a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80051d:	eb 14                	jmp    800533 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80051f:	85 c0                	test   %eax,%eax
  800521:	0f 84 b3 03 00 00    	je     8008da <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	89 04 24             	mov    %eax,(%esp)
  80052e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800531:	89 f3                	mov    %esi,%ebx
  800533:	8d 73 01             	lea    0x1(%ebx),%esi
  800536:	0f b6 03             	movzbl (%ebx),%eax
  800539:	83 f8 25             	cmp    $0x25,%eax
  80053c:	75 e1                	jne    80051f <vprintfmt+0x11>
  80053e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800542:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800549:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800550:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800557:	ba 00 00 00 00       	mov    $0x0,%edx
  80055c:	eb 1d                	jmp    80057b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800560:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800564:	eb 15                	jmp    80057b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800568:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80056c:	eb 0d                	jmp    80057b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80056e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800571:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800574:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80057e:	0f b6 0e             	movzbl (%esi),%ecx
  800581:	0f b6 c1             	movzbl %cl,%eax
  800584:	83 e9 23             	sub    $0x23,%ecx
  800587:	80 f9 55             	cmp    $0x55,%cl
  80058a:	0f 87 2a 03 00 00    	ja     8008ba <vprintfmt+0x3ac>
  800590:	0f b6 c9             	movzbl %cl,%ecx
  800593:	ff 24 8d 80 30 80 00 	jmp    *0x803080(,%ecx,4)
  80059a:	89 de                	mov    %ebx,%esi
  80059c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005a1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005a8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005ae:	83 fb 09             	cmp    $0x9,%ebx
  8005b1:	77 36                	ja     8005e9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005b6:	eb e9                	jmp    8005a1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8005be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005c8:	eb 22                	jmp    8005ec <vprintfmt+0xde>
  8005ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d4:	0f 49 c1             	cmovns %ecx,%eax
  8005d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	89 de                	mov    %ebx,%esi
  8005dc:	eb 9d                	jmp    80057b <vprintfmt+0x6d>
  8005de:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005e0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8005e7:	eb 92                	jmp    80057b <vprintfmt+0x6d>
  8005e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8005ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f0:	79 89                	jns    80057b <vprintfmt+0x6d>
  8005f2:	e9 77 ff ff ff       	jmp    80056e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005f7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005fc:	e9 7a ff ff ff       	jmp    80057b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 50 04             	lea    0x4(%eax),%edx
  800607:	89 55 14             	mov    %edx,0x14(%ebp)
  80060a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	89 04 24             	mov    %eax,(%esp)
  800613:	ff 55 08             	call   *0x8(%ebp)
			break;
  800616:	e9 18 ff ff ff       	jmp    800533 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8d 50 04             	lea    0x4(%eax),%edx
  800621:	89 55 14             	mov    %edx,0x14(%ebp)
  800624:	8b 00                	mov    (%eax),%eax
  800626:	99                   	cltd   
  800627:	31 d0                	xor    %edx,%eax
  800629:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062b:	83 f8 12             	cmp    $0x12,%eax
  80062e:	7f 0b                	jg     80063b <vprintfmt+0x12d>
  800630:	8b 14 85 e0 31 80 00 	mov    0x8031e0(,%eax,4),%edx
  800637:	85 d2                	test   %edx,%edx
  800639:	75 20                	jne    80065b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80063b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80063f:	c7 44 24 08 23 2f 80 	movl   $0x802f23,0x8(%esp)
  800646:	00 
  800647:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	89 04 24             	mov    %eax,(%esp)
  800651:	e8 90 fe ff ff       	call   8004e6 <printfmt>
  800656:	e9 d8 fe ff ff       	jmp    800533 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80065b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80065f:	c7 44 24 08 15 34 80 	movl   $0x803415,0x8(%esp)
  800666:	00 
  800667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	89 04 24             	mov    %eax,(%esp)
  800671:	e8 70 fe ff ff       	call   8004e6 <printfmt>
  800676:	e9 b8 fe ff ff       	jmp    800533 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80067e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800681:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	89 55 14             	mov    %edx,0x14(%ebp)
  80068d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80068f:	85 f6                	test   %esi,%esi
  800691:	b8 1c 2f 80 00       	mov    $0x802f1c,%eax
  800696:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800699:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80069d:	0f 84 97 00 00 00    	je     80073a <vprintfmt+0x22c>
  8006a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006a7:	0f 8e 9b 00 00 00    	jle    800748 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006b1:	89 34 24             	mov    %esi,(%esp)
  8006b4:	e8 cf 02 00 00       	call   800988 <strnlen>
  8006b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006bc:	29 c2                	sub    %eax,%edx
  8006be:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8006c1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d3:	eb 0f                	jmp    8006e4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8006d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006dc:	89 04 24             	mov    %eax,(%esp)
  8006df:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e1:	83 eb 01             	sub    $0x1,%ebx
  8006e4:	85 db                	test   %ebx,%ebx
  8006e6:	7f ed                	jg     8006d5 <vprintfmt+0x1c7>
  8006e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ee:	85 d2                	test   %edx,%edx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c2             	cmovns %edx,%eax
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006fd:	89 d7                	mov    %edx,%edi
  8006ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800702:	eb 50                	jmp    800754 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800704:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800708:	74 1e                	je     800728 <vprintfmt+0x21a>
  80070a:	0f be d2             	movsbl %dl,%edx
  80070d:	83 ea 20             	sub    $0x20,%edx
  800710:	83 fa 5e             	cmp    $0x5e,%edx
  800713:	76 13                	jbe    800728 <vprintfmt+0x21a>
					putch('?', putdat);
  800715:	8b 45 0c             	mov    0xc(%ebp),%eax
  800718:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800723:	ff 55 08             	call   *0x8(%ebp)
  800726:	eb 0d                	jmp    800735 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	83 ef 01             	sub    $0x1,%edi
  800738:	eb 1a                	jmp    800754 <vprintfmt+0x246>
  80073a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80073d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800740:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800743:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800746:	eb 0c                	jmp    800754 <vprintfmt+0x246>
  800748:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80074b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80074e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800751:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800754:	83 c6 01             	add    $0x1,%esi
  800757:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80075b:	0f be c2             	movsbl %dl,%eax
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 27                	je     800789 <vprintfmt+0x27b>
  800762:	85 db                	test   %ebx,%ebx
  800764:	78 9e                	js     800704 <vprintfmt+0x1f6>
  800766:	83 eb 01             	sub    $0x1,%ebx
  800769:	79 99                	jns    800704 <vprintfmt+0x1f6>
  80076b:	89 f8                	mov    %edi,%eax
  80076d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800770:	8b 75 08             	mov    0x8(%ebp),%esi
  800773:	89 c3                	mov    %eax,%ebx
  800775:	eb 1a                	jmp    800791 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800777:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800782:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800784:	83 eb 01             	sub    $0x1,%ebx
  800787:	eb 08                	jmp    800791 <vprintfmt+0x283>
  800789:	89 fb                	mov    %edi,%ebx
  80078b:	8b 75 08             	mov    0x8(%ebp),%esi
  80078e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800791:	85 db                	test   %ebx,%ebx
  800793:	7f e2                	jg     800777 <vprintfmt+0x269>
  800795:	89 75 08             	mov    %esi,0x8(%ebp)
  800798:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80079b:	e9 93 fd ff ff       	jmp    800533 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007a0:	83 fa 01             	cmp    $0x1,%edx
  8007a3:	7e 16                	jle    8007bb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8d 50 08             	lea    0x8(%eax),%edx
  8007ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ae:	8b 50 04             	mov    0x4(%eax),%edx
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007b9:	eb 32                	jmp    8007ed <vprintfmt+0x2df>
	else if (lflag)
  8007bb:	85 d2                	test   %edx,%edx
  8007bd:	74 18                	je     8007d7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 50 04             	lea    0x4(%eax),%edx
  8007c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c8:	8b 30                	mov    (%eax),%esi
  8007ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	c1 f8 1f             	sar    $0x1f,%eax
  8007d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d5:	eb 16                	jmp    8007ed <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 50 04             	lea    0x4(%eax),%edx
  8007dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e0:	8b 30                	mov    (%eax),%esi
  8007e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007e5:	89 f0                	mov    %esi,%eax
  8007e7:	c1 f8 1f             	sar    $0x1f,%eax
  8007ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fc:	0f 89 80 00 00 00    	jns    800882 <vprintfmt+0x374>
				putch('-', putdat);
  800802:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800806:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80080d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800816:	f7 d8                	neg    %eax
  800818:	83 d2 00             	adc    $0x0,%edx
  80081b:	f7 da                	neg    %edx
			}
			base = 10;
  80081d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800822:	eb 5e                	jmp    800882 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
  800827:	e8 63 fc ff ff       	call   80048f <getuint>
			base = 10;
  80082c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800831:	eb 4f                	jmp    800882 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800833:	8d 45 14             	lea    0x14(%ebp),%eax
  800836:	e8 54 fc ff ff       	call   80048f <getuint>
			base = 8;
  80083b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800840:	eb 40                	jmp    800882 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800842:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800846:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80084d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800850:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800854:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80085b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8d 50 04             	lea    0x4(%eax),%edx
  800864:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800867:	8b 00                	mov    (%eax),%eax
  800869:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80086e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800873:	eb 0d                	jmp    800882 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
  800878:	e8 12 fc ff ff       	call   80048f <getuint>
			base = 16;
  80087d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800882:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800886:	89 74 24 10          	mov    %esi,0x10(%esp)
  80088a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80088d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800891:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800895:	89 04 24             	mov    %eax,(%esp)
  800898:	89 54 24 04          	mov    %edx,0x4(%esp)
  80089c:	89 fa                	mov    %edi,%edx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	e8 fa fa ff ff       	call   8003a0 <printnum>
			break;
  8008a6:	e9 88 fc ff ff       	jmp    800533 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008af:	89 04 24             	mov    %eax,(%esp)
  8008b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008b5:	e9 79 fc ff ff       	jmp    800533 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008be:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c8:	89 f3                	mov    %esi,%ebx
  8008ca:	eb 03                	jmp    8008cf <vprintfmt+0x3c1>
  8008cc:	83 eb 01             	sub    $0x1,%ebx
  8008cf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008d3:	75 f7                	jne    8008cc <vprintfmt+0x3be>
  8008d5:	e9 59 fc ff ff       	jmp    800533 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008da:	83 c4 3c             	add    $0x3c,%esp
  8008dd:	5b                   	pop    %ebx
  8008de:	5e                   	pop    %esi
  8008df:	5f                   	pop    %edi
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 28             	sub    $0x28,%esp
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ff:	85 c0                	test   %eax,%eax
  800901:	74 30                	je     800933 <vsnprintf+0x51>
  800903:	85 d2                	test   %edx,%edx
  800905:	7e 2c                	jle    800933 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80090e:	8b 45 10             	mov    0x10(%ebp),%eax
  800911:	89 44 24 08          	mov    %eax,0x8(%esp)
  800915:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091c:	c7 04 24 c9 04 80 00 	movl   $0x8004c9,(%esp)
  800923:	e8 e6 fb ff ff       	call   80050e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800931:	eb 05                	jmp    800938 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800933:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800940:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800943:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800947:	8b 45 10             	mov    0x10(%ebp),%eax
  80094a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	89 44 24 04          	mov    %eax,0x4(%esp)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	89 04 24             	mov    %eax,(%esp)
  80095b:	e8 82 ff ff ff       	call   8008e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800960:	c9                   	leave  
  800961:	c3                   	ret    
  800962:	66 90                	xchg   %ax,%ax
  800964:	66 90                	xchg   %ax,%ax
  800966:	66 90                	xchg   %ax,%ax
  800968:	66 90                	xchg   %ax,%ax
  80096a:	66 90                	xchg   %ax,%ax
  80096c:	66 90                	xchg   %ax,%ax
  80096e:	66 90                	xchg   %ax,%ax

00800970 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	eb 03                	jmp    800980 <strlen+0x10>
		n++;
  80097d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800980:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800984:	75 f7                	jne    80097d <strlen+0xd>
		n++;
	return n;
}
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800991:	b8 00 00 00 00       	mov    $0x0,%eax
  800996:	eb 03                	jmp    80099b <strnlen+0x13>
		n++;
  800998:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099b:	39 d0                	cmp    %edx,%eax
  80099d:	74 06                	je     8009a5 <strnlen+0x1d>
  80099f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009a3:	75 f3                	jne    800998 <strnlen+0x10>
		n++;
	return n;
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	53                   	push   %ebx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b1:	89 c2                	mov    %eax,%edx
  8009b3:	83 c2 01             	add    $0x1,%edx
  8009b6:	83 c1 01             	add    $0x1,%ecx
  8009b9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009bd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c0:	84 db                	test   %bl,%bl
  8009c2:	75 ef                	jne    8009b3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009c4:	5b                   	pop    %ebx
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	53                   	push   %ebx
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d1:	89 1c 24             	mov    %ebx,(%esp)
  8009d4:	e8 97 ff ff ff       	call   800970 <strlen>
	strcpy(dst + len, src);
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009e0:	01 d8                	add    %ebx,%eax
  8009e2:	89 04 24             	mov    %eax,(%esp)
  8009e5:	e8 bd ff ff ff       	call   8009a7 <strcpy>
	return dst;
}
  8009ea:	89 d8                	mov    %ebx,%eax
  8009ec:	83 c4 08             	add    $0x8,%esp
  8009ef:	5b                   	pop    %ebx
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fd:	89 f3                	mov    %esi,%ebx
  8009ff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a02:	89 f2                	mov    %esi,%edx
  800a04:	eb 0f                	jmp    800a15 <strncpy+0x23>
		*dst++ = *src;
  800a06:	83 c2 01             	add    $0x1,%edx
  800a09:	0f b6 01             	movzbl (%ecx),%eax
  800a0c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a0f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a12:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a15:	39 da                	cmp    %ebx,%edx
  800a17:	75 ed                	jne    800a06 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a19:	89 f0                	mov    %esi,%eax
  800a1b:	5b                   	pop    %ebx
  800a1c:	5e                   	pop    %esi
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	56                   	push   %esi
  800a23:	53                   	push   %ebx
  800a24:	8b 75 08             	mov    0x8(%ebp),%esi
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a2d:	89 f0                	mov    %esi,%eax
  800a2f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	75 0b                	jne    800a42 <strlcpy+0x23>
  800a37:	eb 1d                	jmp    800a56 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a42:	39 d8                	cmp    %ebx,%eax
  800a44:	74 0b                	je     800a51 <strlcpy+0x32>
  800a46:	0f b6 0a             	movzbl (%edx),%ecx
  800a49:	84 c9                	test   %cl,%cl
  800a4b:	75 ec                	jne    800a39 <strlcpy+0x1a>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	eb 02                	jmp    800a53 <strlcpy+0x34>
  800a51:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a53:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a56:	29 f0                	sub    %esi,%eax
}
  800a58:	5b                   	pop    %ebx
  800a59:	5e                   	pop    %esi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a65:	eb 06                	jmp    800a6d <strcmp+0x11>
		p++, q++;
  800a67:	83 c1 01             	add    $0x1,%ecx
  800a6a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a6d:	0f b6 01             	movzbl (%ecx),%eax
  800a70:	84 c0                	test   %al,%al
  800a72:	74 04                	je     800a78 <strcmp+0x1c>
  800a74:	3a 02                	cmp    (%edx),%al
  800a76:	74 ef                	je     800a67 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a78:	0f b6 c0             	movzbl %al,%eax
  800a7b:	0f b6 12             	movzbl (%edx),%edx
  800a7e:	29 d0                	sub    %edx,%eax
}
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	53                   	push   %ebx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8c:	89 c3                	mov    %eax,%ebx
  800a8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a91:	eb 06                	jmp    800a99 <strncmp+0x17>
		n--, p++, q++;
  800a93:	83 c0 01             	add    $0x1,%eax
  800a96:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a99:	39 d8                	cmp    %ebx,%eax
  800a9b:	74 15                	je     800ab2 <strncmp+0x30>
  800a9d:	0f b6 08             	movzbl (%eax),%ecx
  800aa0:	84 c9                	test   %cl,%cl
  800aa2:	74 04                	je     800aa8 <strncmp+0x26>
  800aa4:	3a 0a                	cmp    (%edx),%cl
  800aa6:	74 eb                	je     800a93 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa8:	0f b6 00             	movzbl (%eax),%eax
  800aab:	0f b6 12             	movzbl (%edx),%edx
  800aae:	29 d0                	sub    %edx,%eax
  800ab0:	eb 05                	jmp    800ab7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac4:	eb 07                	jmp    800acd <strchr+0x13>
		if (*s == c)
  800ac6:	38 ca                	cmp    %cl,%dl
  800ac8:	74 0f                	je     800ad9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	0f b6 10             	movzbl (%eax),%edx
  800ad0:	84 d2                	test   %dl,%dl
  800ad2:	75 f2                	jne    800ac6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae5:	eb 07                	jmp    800aee <strfind+0x13>
		if (*s == c)
  800ae7:	38 ca                	cmp    %cl,%dl
  800ae9:	74 0a                	je     800af5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	0f b6 10             	movzbl (%eax),%edx
  800af1:	84 d2                	test   %dl,%dl
  800af3:	75 f2                	jne    800ae7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	57                   	push   %edi
  800afb:	56                   	push   %esi
  800afc:	53                   	push   %ebx
  800afd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b03:	85 c9                	test   %ecx,%ecx
  800b05:	74 36                	je     800b3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0d:	75 28                	jne    800b37 <memset+0x40>
  800b0f:	f6 c1 03             	test   $0x3,%cl
  800b12:	75 23                	jne    800b37 <memset+0x40>
		c &= 0xFF;
  800b14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b18:	89 d3                	mov    %edx,%ebx
  800b1a:	c1 e3 08             	shl    $0x8,%ebx
  800b1d:	89 d6                	mov    %edx,%esi
  800b1f:	c1 e6 18             	shl    $0x18,%esi
  800b22:	89 d0                	mov    %edx,%eax
  800b24:	c1 e0 10             	shl    $0x10,%eax
  800b27:	09 f0                	or     %esi,%eax
  800b29:	09 c2                	or     %eax,%edx
  800b2b:	89 d0                	mov    %edx,%eax
  800b2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b32:	fc                   	cld    
  800b33:	f3 ab                	rep stos %eax,%es:(%edi)
  800b35:	eb 06                	jmp    800b3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	fc                   	cld    
  800b3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b3d:	89 f8                	mov    %edi,%eax
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b52:	39 c6                	cmp    %eax,%esi
  800b54:	73 35                	jae    800b8b <memmove+0x47>
  800b56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b59:	39 d0                	cmp    %edx,%eax
  800b5b:	73 2e                	jae    800b8b <memmove+0x47>
		s += n;
		d += n;
  800b5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b60:	89 d6                	mov    %edx,%esi
  800b62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b6a:	75 13                	jne    800b7f <memmove+0x3b>
  800b6c:	f6 c1 03             	test   $0x3,%cl
  800b6f:	75 0e                	jne    800b7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b71:	83 ef 04             	sub    $0x4,%edi
  800b74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b7a:	fd                   	std    
  800b7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7d:	eb 09                	jmp    800b88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b7f:	83 ef 01             	sub    $0x1,%edi
  800b82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b85:	fd                   	std    
  800b86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b88:	fc                   	cld    
  800b89:	eb 1d                	jmp    800ba8 <memmove+0x64>
  800b8b:	89 f2                	mov    %esi,%edx
  800b8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8f:	f6 c2 03             	test   $0x3,%dl
  800b92:	75 0f                	jne    800ba3 <memmove+0x5f>
  800b94:	f6 c1 03             	test   $0x3,%cl
  800b97:	75 0a                	jne    800ba3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b9c:	89 c7                	mov    %eax,%edi
  800b9e:	fc                   	cld    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb 05                	jmp    800ba8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ba3:	89 c7                	mov    %eax,%edi
  800ba5:	fc                   	cld    
  800ba6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 04 24             	mov    %eax,(%esp)
  800bc6:	e8 79 ff ff ff       	call   800b44 <memmove>
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd8:	89 d6                	mov    %edx,%esi
  800bda:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdd:	eb 1a                	jmp    800bf9 <memcmp+0x2c>
		if (*s1 != *s2)
  800bdf:	0f b6 02             	movzbl (%edx),%eax
  800be2:	0f b6 19             	movzbl (%ecx),%ebx
  800be5:	38 d8                	cmp    %bl,%al
  800be7:	74 0a                	je     800bf3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800be9:	0f b6 c0             	movzbl %al,%eax
  800bec:	0f b6 db             	movzbl %bl,%ebx
  800bef:	29 d8                	sub    %ebx,%eax
  800bf1:	eb 0f                	jmp    800c02 <memcmp+0x35>
		s1++, s2++;
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf9:	39 f2                	cmp    %esi,%edx
  800bfb:	75 e2                	jne    800bdf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c14:	eb 07                	jmp    800c1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c16:	38 08                	cmp    %cl,(%eax)
  800c18:	74 07                	je     800c21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	39 d0                	cmp    %edx,%eax
  800c1f:	72 f5                	jb     800c16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2f:	eb 03                	jmp    800c34 <strtol+0x11>
		s++;
  800c31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c34:	0f b6 0a             	movzbl (%edx),%ecx
  800c37:	80 f9 09             	cmp    $0x9,%cl
  800c3a:	74 f5                	je     800c31 <strtol+0xe>
  800c3c:	80 f9 20             	cmp    $0x20,%cl
  800c3f:	74 f0                	je     800c31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c41:	80 f9 2b             	cmp    $0x2b,%cl
  800c44:	75 0a                	jne    800c50 <strtol+0x2d>
		s++;
  800c46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c49:	bf 00 00 00 00       	mov    $0x0,%edi
  800c4e:	eb 11                	jmp    800c61 <strtol+0x3e>
  800c50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c55:	80 f9 2d             	cmp    $0x2d,%cl
  800c58:	75 07                	jne    800c61 <strtol+0x3e>
		s++, neg = 1;
  800c5a:	8d 52 01             	lea    0x1(%edx),%edx
  800c5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c66:	75 15                	jne    800c7d <strtol+0x5a>
  800c68:	80 3a 30             	cmpb   $0x30,(%edx)
  800c6b:	75 10                	jne    800c7d <strtol+0x5a>
  800c6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c71:	75 0a                	jne    800c7d <strtol+0x5a>
		s += 2, base = 16;
  800c73:	83 c2 02             	add    $0x2,%edx
  800c76:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7b:	eb 10                	jmp    800c8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c7d:	85 c0                	test   %eax,%eax
  800c7f:	75 0c                	jne    800c8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c83:	80 3a 30             	cmpb   $0x30,(%edx)
  800c86:	75 05                	jne    800c8d <strtol+0x6a>
		s++, base = 8;
  800c88:	83 c2 01             	add    $0x1,%edx
  800c8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c95:	0f b6 0a             	movzbl (%edx),%ecx
  800c98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c9b:	89 f0                	mov    %esi,%eax
  800c9d:	3c 09                	cmp    $0x9,%al
  800c9f:	77 08                	ja     800ca9 <strtol+0x86>
			dig = *s - '0';
  800ca1:	0f be c9             	movsbl %cl,%ecx
  800ca4:	83 e9 30             	sub    $0x30,%ecx
  800ca7:	eb 20                	jmp    800cc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ca9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cac:	89 f0                	mov    %esi,%eax
  800cae:	3c 19                	cmp    $0x19,%al
  800cb0:	77 08                	ja     800cba <strtol+0x97>
			dig = *s - 'a' + 10;
  800cb2:	0f be c9             	movsbl %cl,%ecx
  800cb5:	83 e9 57             	sub    $0x57,%ecx
  800cb8:	eb 0f                	jmp    800cc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800cba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cbd:	89 f0                	mov    %esi,%eax
  800cbf:	3c 19                	cmp    $0x19,%al
  800cc1:	77 16                	ja     800cd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800cc3:	0f be c9             	movsbl %cl,%ecx
  800cc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ccc:	7d 0f                	jge    800cdd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cd7:	eb bc                	jmp    800c95 <strtol+0x72>
  800cd9:	89 d8                	mov    %ebx,%eax
  800cdb:	eb 02                	jmp    800cdf <strtol+0xbc>
  800cdd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 05                	je     800cea <strtol+0xc7>
		*endptr = (char *) s;
  800ce5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cea:	f7 d8                	neg    %eax
  800cec:	85 ff                	test   %edi,%edi
  800cee:	0f 44 c3             	cmove  %ebx,%eax
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	89 c3                	mov    %eax,%ebx
  800d09:	89 c7                	mov    %eax,%edi
  800d0b:	89 c6                	mov    %eax,%esi
  800d0d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d24:	89 d1                	mov    %edx,%ecx
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	89 d7                	mov    %edx,%edi
  800d2a:	89 d6                	mov    %edx,%esi
  800d2c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d41:	b8 03 00 00 00       	mov    $0x3,%eax
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	89 cb                	mov    %ecx,%ebx
  800d4b:	89 cf                	mov    %ecx,%edi
  800d4d:	89 ce                	mov    %ecx,%esi
  800d4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7e 28                	jle    800d7d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d59:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d60:	00 
  800d61:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  800d68:	00 
  800d69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d70:	00 
  800d71:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  800d78:	e8 01 f5 ff ff       	call   80027e <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7d:	83 c4 2c             	add    $0x2c,%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d90:	b8 02 00 00 00       	mov    $0x2,%eax
  800d95:	89 d1                	mov    %edx,%ecx
  800d97:	89 d3                	mov    %edx,%ebx
  800d99:	89 d7                	mov    %edx,%edi
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <sys_yield>:

void
sys_yield(void)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db4:	89 d1                	mov    %edx,%ecx
  800db6:	89 d3                	mov    %edx,%ebx
  800db8:	89 d7                	mov    %edx,%edi
  800dba:	89 d6                	mov    %edx,%esi
  800dbc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcc:	be 00 00 00 00       	mov    $0x0,%esi
  800dd1:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddf:	89 f7                	mov    %esi,%edi
  800de1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7e 28                	jle    800e0f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800deb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800df2:	00 
  800df3:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  800dfa:	00 
  800dfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e02:	00 
  800e03:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  800e0a:	e8 6f f4 ff ff       	call   80027e <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e0f:	83 c4 2c             	add    $0x2c,%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e20:	b8 05 00 00 00       	mov    $0x5,%eax
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e31:	8b 75 18             	mov    0x18(%ebp),%esi
  800e34:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	7e 28                	jle    800e62 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e45:	00 
  800e46:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  800e4d:	00 
  800e4e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e55:	00 
  800e56:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  800e5d:	e8 1c f4 ff ff       	call   80027e <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e62:	83 c4 2c             	add    $0x2c,%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
  800e70:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e78:	b8 06 00 00 00       	mov    $0x6,%eax
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	89 df                	mov    %ebx,%edi
  800e85:	89 de                	mov    %ebx,%esi
  800e87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	7e 28                	jle    800eb5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e91:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e98:	00 
  800e99:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea8:	00 
  800ea9:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  800eb0:	e8 c9 f3 ff ff       	call   80027e <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eb5:	83 c4 2c             	add    $0x2c,%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	57                   	push   %edi
  800ec1:	56                   	push   %esi
  800ec2:	53                   	push   %ebx
  800ec3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	89 df                	mov    %ebx,%edi
  800ed8:	89 de                	mov    %ebx,%esi
  800eda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	7e 28                	jle    800f08 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800eeb:	00 
  800eec:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efb:	00 
  800efc:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  800f03:	e8 76 f3 ff ff       	call   80027e <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f08:	83 c4 2c             	add    $0x2c,%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
  800f16:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	89 df                	mov    %ebx,%edi
  800f2b:	89 de                	mov    %ebx,%esi
  800f2d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	7e 28                	jle    800f5b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f37:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  800f46:	00 
  800f47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4e:	00 
  800f4f:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  800f56:	e8 23 f3 ff ff       	call   80027e <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f5b:	83 c4 2c             	add    $0x2c,%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	89 df                	mov    %ebx,%edi
  800f7e:	89 de                	mov    %ebx,%esi
  800f80:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	7e 28                	jle    800fae <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f86:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f91:	00 
  800f92:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  800f99:	00 
  800f9a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa1:	00 
  800fa2:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  800fa9:	e8 d0 f2 ff ff       	call   80027e <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fae:	83 c4 2c             	add    $0x2c,%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	be 00 00 00 00       	mov    $0x0,%esi
  800fc1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fcf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	89 cb                	mov    %ecx,%ebx
  800ff1:	89 cf                	mov    %ecx,%edi
  800ff3:	89 ce                	mov    %ecx,%esi
  800ff5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	7e 28                	jle    801023 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801006:	00 
  801007:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  80100e:	00 
  80100f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801016:	00 
  801017:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  80101e:	e8 5b f2 ff ff       	call   80027e <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801023:	83 c4 2c             	add    $0x2c,%esp
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801031:	ba 00 00 00 00       	mov    $0x0,%edx
  801036:	b8 0e 00 00 00       	mov    $0xe,%eax
  80103b:	89 d1                	mov    %edx,%ecx
  80103d:	89 d3                	mov    %edx,%ebx
  80103f:	89 d7                	mov    %edx,%edi
  801041:	89 d6                	mov    %edx,%esi
  801043:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
  801050:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801053:	bb 00 00 00 00       	mov    $0x0,%ebx
  801058:	b8 0f 00 00 00       	mov    $0xf,%eax
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	89 df                	mov    %ebx,%edi
  801065:	89 de                	mov    %ebx,%esi
  801067:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801069:	85 c0                	test   %eax,%eax
  80106b:	7e 28                	jle    801095 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801071:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801078:	00 
  801079:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  801090:	e8 e9 f1 ff ff       	call   80027e <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801095:	83 c4 2c             	add    $0x2c,%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	89 df                	mov    %ebx,%edi
  8010b8:	89 de                	mov    %ebx,%esi
  8010ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	7e 28                	jle    8010e8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010db:	00 
  8010dc:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  8010e3:	e8 96 f1 ff ff       	call   80027e <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8010e8:	83 c4 2c             	add    $0x2c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
  8010f6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fe:	b8 11 00 00 00       	mov    $0x11,%eax
  801103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801106:	8b 55 08             	mov    0x8(%ebp),%edx
  801109:	89 df                	mov    %ebx,%edi
  80110b:	89 de                	mov    %ebx,%esi
  80110d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80110f:	85 c0                	test   %eax,%eax
  801111:	7e 28                	jle    80113b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801113:	89 44 24 10          	mov    %eax,0x10(%esp)
  801117:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80111e:	00 
  80111f:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  801126:	00 
  801127:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80112e:	00 
  80112f:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  801136:	e8 43 f1 ff ff       	call   80027e <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80113b:	83 c4 2c             	add    $0x2c,%esp
  80113e:	5b                   	pop    %ebx
  80113f:	5e                   	pop    %esi
  801140:	5f                   	pop    %edi
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    

00801143 <sys_sleep>:

int
sys_sleep(int channel)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	57                   	push   %edi
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
  801149:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801151:	b8 12 00 00 00       	mov    $0x12,%eax
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	89 cb                	mov    %ecx,%ebx
  80115b:	89 cf                	mov    %ecx,%edi
  80115d:	89 ce                	mov    %ecx,%esi
  80115f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801161:	85 c0                	test   %eax,%eax
  801163:	7e 28                	jle    80118d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801165:	89 44 24 10          	mov    %eax,0x10(%esp)
  801169:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801170:	00 
  801171:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  801178:	00 
  801179:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801180:	00 
  801181:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  801188:	e8 f1 f0 ff ff       	call   80027e <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80118d:	83 c4 2c             	add    $0x2c,%esp
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5f                   	pop    %edi
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    

00801195 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	57                   	push   %edi
  801199:	56                   	push   %esi
  80119a:	53                   	push   %ebx
  80119b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a3:	b8 13 00 00 00       	mov    $0x13,%eax
  8011a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	89 df                	mov    %ebx,%edi
  8011b0:	89 de                	mov    %ebx,%esi
  8011b2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	7e 28                	jle    8011e0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011bc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8011c3:	00 
  8011c4:	c7 44 24 08 4b 32 80 	movl   $0x80324b,0x8(%esp)
  8011cb:	00 
  8011cc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d3:	00 
  8011d4:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  8011db:	e8 9e f0 ff ff       	call   80027e <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8011e0:	83 c4 2c             	add    $0x2c,%esp
  8011e3:	5b                   	pop    %ebx
  8011e4:	5e                   	pop    %esi
  8011e5:	5f                   	pop    %edi
  8011e6:	5d                   	pop    %ebp
  8011e7:	c3                   	ret    

008011e8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	53                   	push   %ebx
  8011ec:	83 ec 24             	sub    $0x24,%esp
  8011ef:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011f2:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  8011f4:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011f8:	74 27                	je     801221 <pgfault+0x39>
  8011fa:	89 c2                	mov    %eax,%edx
  8011fc:	c1 ea 16             	shr    $0x16,%edx
  8011ff:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801206:	f6 c2 01             	test   $0x1,%dl
  801209:	74 16                	je     801221 <pgfault+0x39>
  80120b:	89 c2                	mov    %eax,%edx
  80120d:	c1 ea 0c             	shr    $0xc,%edx
  801210:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801217:	f7 d2                	not    %edx
  801219:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80121f:	74 1c                	je     80123d <pgfault+0x55>
		panic("pgfault");
  801221:	c7 44 24 08 76 32 80 	movl   $0x803276,0x8(%esp)
  801228:	00 
  801229:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801230:	00 
  801231:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  801238:	e8 41 f0 ff ff       	call   80027e <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80123d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801242:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801244:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80124b:	00 
  80124c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801253:	00 
  801254:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125b:	e8 63 fb ff ff       	call   800dc3 <sys_page_alloc>
  801260:	85 c0                	test   %eax,%eax
  801262:	79 1c                	jns    801280 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801264:	c7 44 24 08 89 32 80 	movl   $0x803289,0x8(%esp)
  80126b:	00 
  80126c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801273:	00 
  801274:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  80127b:	e8 fe ef ff ff       	call   80027e <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801280:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801287:	00 
  801288:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80128c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801293:	e8 14 f9 ff ff       	call   800bac <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801298:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80129f:	00 
  8012a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012ab:	00 
  8012ac:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012b3:	00 
  8012b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012bb:	e8 57 fb ff ff       	call   800e17 <sys_page_map>
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	79 1c                	jns    8012e0 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  8012c4:	c7 44 24 08 a3 32 80 	movl   $0x8032a3,0x8(%esp)
  8012cb:	00 
  8012cc:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8012d3:	00 
  8012d4:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  8012db:	e8 9e ef ff ff       	call   80027e <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  8012e0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012e7:	00 
  8012e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ef:	e8 76 fb ff ff       	call   800e6a <sys_page_unmap>
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	79 1c                	jns    801314 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  8012f8:	c7 44 24 08 bb 32 80 	movl   $0x8032bb,0x8(%esp)
  8012ff:	00 
  801300:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801307:	00 
  801308:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  80130f:	e8 6a ef ff ff       	call   80027e <_panic>
	}
}
  801314:	83 c4 24             	add    $0x24,%esp
  801317:	5b                   	pop    %ebx
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    

0080131a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	57                   	push   %edi
  80131e:	56                   	push   %esi
  80131f:	53                   	push   %ebx
  801320:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801323:	c7 04 24 e8 11 80 00 	movl   $0x8011e8,(%esp)
  80132a:	e8 d7 15 00 00       	call   802906 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80132f:	b8 07 00 00 00       	mov    $0x7,%eax
  801334:	cd 30                	int    $0x30
  801336:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801339:	85 c0                	test   %eax,%eax
  80133b:	79 1c                	jns    801359 <fork+0x3f>
		panic("fork(): sys_exofork");
  80133d:	c7 44 24 08 d5 32 80 	movl   $0x8032d5,0x8(%esp)
  801344:	00 
  801345:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80134c:	00 
  80134d:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  801354:	e8 25 ef ff ff       	call   80027e <_panic>
  801359:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  80135b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80135f:	74 0a                	je     80136b <fork+0x51>
  801361:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801366:	e9 9d 01 00 00       	jmp    801508 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80136b:	e8 15 fa ff ff       	call   800d85 <sys_getenvid>
  801370:	25 ff 03 00 00       	and    $0x3ff,%eax
  801375:	89 c2                	mov    %eax,%edx
  801377:	c1 e2 07             	shl    $0x7,%edx
  80137a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801381:	a3 20 54 80 00       	mov    %eax,0x805420
		return env_id;
  801386:	e9 2a 02 00 00       	jmp    8015b5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80138b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801391:	0f 84 6b 01 00 00    	je     801502 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801397:	89 d8                	mov    %ebx,%eax
  801399:	c1 e8 16             	shr    $0x16,%eax
  80139c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013a3:	a8 01                	test   $0x1,%al
  8013a5:	0f 84 57 01 00 00    	je     801502 <fork+0x1e8>
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	c1 e8 0c             	shr    $0xc,%eax
  8013b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b7:	f7 d0                	not    %eax
  8013b9:	a8 05                	test   $0x5,%al
  8013bb:	0f 85 41 01 00 00    	jne    801502 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  8013c1:	89 d8                	mov    %ebx,%eax
  8013c3:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  8013c6:	89 c6                	mov    %eax,%esi
  8013c8:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  8013cb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d2:	f6 c6 04             	test   $0x4,%dh
  8013d5:	74 4c                	je     801423 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  8013d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013de:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013eb:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fa:	e8 18 fa ff ff       	call   800e17 <sys_page_map>
  8013ff:	85 c0                	test   %eax,%eax
  801401:	0f 89 fb 00 00 00    	jns    801502 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801407:	c7 44 24 08 e9 32 80 	movl   $0x8032e9,0x8(%esp)
  80140e:	00 
  80140f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801416:	00 
  801417:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  80141e:	e8 5b ee ff ff       	call   80027e <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801423:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80142a:	f6 c6 08             	test   $0x8,%dh
  80142d:	75 0f                	jne    80143e <fork+0x124>
  80142f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801436:	a8 02                	test   $0x2,%al
  801438:	0f 84 84 00 00 00    	je     8014c2 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80143e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801445:	00 
  801446:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80144a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80144e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801459:	e8 b9 f9 ff ff       	call   800e17 <sys_page_map>
  80145e:	85 c0                	test   %eax,%eax
  801460:	79 1c                	jns    80147e <fork+0x164>
			panic("duppage: sys_page_map");
  801462:	c7 44 24 08 e9 32 80 	movl   $0x8032e9,0x8(%esp)
  801469:	00 
  80146a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801471:	00 
  801472:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  801479:	e8 00 ee ff ff       	call   80027e <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80147e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801485:	00 
  801486:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80148a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801491:	00 
  801492:	89 74 24 04          	mov    %esi,0x4(%esp)
  801496:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80149d:	e8 75 f9 ff ff       	call   800e17 <sys_page_map>
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	79 5c                	jns    801502 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8014a6:	c7 44 24 08 e9 32 80 	movl   $0x8032e9,0x8(%esp)
  8014ad:	00 
  8014ae:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8014b5:	00 
  8014b6:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  8014bd:	e8 bc ed ff ff       	call   80027e <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  8014c2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8014c9:	00 
  8014ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014dd:	e8 35 f9 ff ff       	call   800e17 <sys_page_map>
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	79 1c                	jns    801502 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8014e6:	c7 44 24 08 e9 32 80 	movl   $0x8032e9,0x8(%esp)
  8014ed:	00 
  8014ee:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8014f5:	00 
  8014f6:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  8014fd:	e8 7c ed ff ff       	call   80027e <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801502:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801508:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80150e:	0f 85 77 fe ff ff    	jne    80138b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801514:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80151b:	00 
  80151c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801523:	ee 
  801524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801527:	89 04 24             	mov    %eax,(%esp)
  80152a:	e8 94 f8 ff ff       	call   800dc3 <sys_page_alloc>
  80152f:	85 c0                	test   %eax,%eax
  801531:	79 1c                	jns    80154f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801533:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  80153a:	00 
  80153b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801542:	00 
  801543:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  80154a:	e8 2f ed ff ff       	call   80027e <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80154f:	c7 44 24 04 8f 29 80 	movl   $0x80298f,0x4(%esp)
  801556:	00 
  801557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80155a:	89 04 24             	mov    %eax,(%esp)
  80155d:	e8 01 fa ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
  801562:	85 c0                	test   %eax,%eax
  801564:	79 1c                	jns    801582 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801566:	c7 44 24 08 48 33 80 	movl   $0x803348,0x8(%esp)
  80156d:	00 
  80156e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801575:	00 
  801576:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  80157d:	e8 fc ec ff ff       	call   80027e <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801582:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801589:	00 
  80158a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158d:	89 04 24             	mov    %eax,(%esp)
  801590:	e8 28 f9 ff ff       	call   800ebd <sys_env_set_status>
  801595:	85 c0                	test   %eax,%eax
  801597:	79 1c                	jns    8015b5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801599:	c7 44 24 08 16 33 80 	movl   $0x803316,0x8(%esp)
  8015a0:	00 
  8015a1:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  8015a8:	00 
  8015a9:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  8015b0:	e8 c9 ec ff ff       	call   80027e <_panic>
	}

	return env_id;
}
  8015b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b8:	83 c4 2c             	add    $0x2c,%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5f                   	pop    %edi
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    

008015c0 <sfork>:

// Challenge!
int
sfork(void)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8015c6:	c7 44 24 08 31 33 80 	movl   $0x803331,0x8(%esp)
  8015cd:	00 
  8015ce:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8015d5:	00 
  8015d6:	c7 04 24 7e 32 80 00 	movl   $0x80327e,(%esp)
  8015dd:	e8 9c ec ff ff       	call   80027e <_panic>
  8015e2:	66 90                	xchg   %ax,%ax
  8015e4:	66 90                	xchg   %ax,%ax
  8015e6:	66 90                	xchg   %ax,%ax
  8015e8:	66 90                	xchg   %ax,%ax
  8015ea:	66 90                	xchg   %ax,%ax
  8015ec:	66 90                	xchg   %ax,%ax
  8015ee:	66 90                	xchg   %ax,%ax

008015f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    

00801600 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80160b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801610:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801615:	5d                   	pop    %ebp
  801616:	c3                   	ret    

00801617 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801622:	89 c2                	mov    %eax,%edx
  801624:	c1 ea 16             	shr    $0x16,%edx
  801627:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80162e:	f6 c2 01             	test   $0x1,%dl
  801631:	74 11                	je     801644 <fd_alloc+0x2d>
  801633:	89 c2                	mov    %eax,%edx
  801635:	c1 ea 0c             	shr    $0xc,%edx
  801638:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80163f:	f6 c2 01             	test   $0x1,%dl
  801642:	75 09                	jne    80164d <fd_alloc+0x36>
			*fd_store = fd;
  801644:	89 01                	mov    %eax,(%ecx)
			return 0;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
  80164b:	eb 17                	jmp    801664 <fd_alloc+0x4d>
  80164d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801652:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801657:	75 c9                	jne    801622 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801659:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80165f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80166c:	83 f8 1f             	cmp    $0x1f,%eax
  80166f:	77 36                	ja     8016a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801671:	c1 e0 0c             	shl    $0xc,%eax
  801674:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801679:	89 c2                	mov    %eax,%edx
  80167b:	c1 ea 16             	shr    $0x16,%edx
  80167e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801685:	f6 c2 01             	test   $0x1,%dl
  801688:	74 24                	je     8016ae <fd_lookup+0x48>
  80168a:	89 c2                	mov    %eax,%edx
  80168c:	c1 ea 0c             	shr    $0xc,%edx
  80168f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801696:	f6 c2 01             	test   $0x1,%dl
  801699:	74 1a                	je     8016b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80169b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169e:	89 02                	mov    %eax,(%edx)
	return 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a5:	eb 13                	jmp    8016ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ac:	eb 0c                	jmp    8016ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b3:	eb 05                	jmp    8016ba <fd_lookup+0x54>
  8016b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8016ba:	5d                   	pop    %ebp
  8016bb:	c3                   	ret    

008016bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 18             	sub    $0x18,%esp
  8016c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ca:	eb 13                	jmp    8016df <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8016cc:	39 08                	cmp    %ecx,(%eax)
  8016ce:	75 0c                	jne    8016dc <dev_lookup+0x20>
			*dev = devtab[i];
  8016d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	eb 38                	jmp    801714 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016dc:	83 c2 01             	add    $0x1,%edx
  8016df:	8b 04 95 e8 33 80 00 	mov    0x8033e8(,%edx,4),%eax
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	75 e2                	jne    8016cc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016ea:	a1 20 54 80 00       	mov    0x805420,%eax
  8016ef:	8b 40 48             	mov    0x48(%eax),%eax
  8016f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fa:	c7 04 24 6c 33 80 00 	movl   $0x80336c,(%esp)
  801701:	e8 71 ec ff ff       	call   800377 <cprintf>
	*dev = 0;
  801706:	8b 45 0c             	mov    0xc(%ebp),%eax
  801709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80170f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	56                   	push   %esi
  80171a:	53                   	push   %ebx
  80171b:	83 ec 20             	sub    $0x20,%esp
  80171e:	8b 75 08             	mov    0x8(%ebp),%esi
  801721:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801724:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801727:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80172b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801731:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801734:	89 04 24             	mov    %eax,(%esp)
  801737:	e8 2a ff ff ff       	call   801666 <fd_lookup>
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 05                	js     801745 <fd_close+0x2f>
	    || fd != fd2)
  801740:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801743:	74 0c                	je     801751 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801745:	84 db                	test   %bl,%bl
  801747:	ba 00 00 00 00       	mov    $0x0,%edx
  80174c:	0f 44 c2             	cmove  %edx,%eax
  80174f:	eb 3f                	jmp    801790 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801751:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801754:	89 44 24 04          	mov    %eax,0x4(%esp)
  801758:	8b 06                	mov    (%esi),%eax
  80175a:	89 04 24             	mov    %eax,(%esp)
  80175d:	e8 5a ff ff ff       	call   8016bc <dev_lookup>
  801762:	89 c3                	mov    %eax,%ebx
  801764:	85 c0                	test   %eax,%eax
  801766:	78 16                	js     80177e <fd_close+0x68>
		if (dev->dev_close)
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80176e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801773:	85 c0                	test   %eax,%eax
  801775:	74 07                	je     80177e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801777:	89 34 24             	mov    %esi,(%esp)
  80177a:	ff d0                	call   *%eax
  80177c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80177e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801782:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801789:	e8 dc f6 ff ff       	call   800e6a <sys_page_unmap>
	return r;
  80178e:	89 d8                	mov    %ebx,%eax
}
  801790:	83 c4 20             	add    $0x20,%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80179d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 04 24             	mov    %eax,(%esp)
  8017aa:	e8 b7 fe ff ff       	call   801666 <fd_lookup>
  8017af:	89 c2                	mov    %eax,%edx
  8017b1:	85 d2                	test   %edx,%edx
  8017b3:	78 13                	js     8017c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8017b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017bc:	00 
  8017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c0:	89 04 24             	mov    %eax,(%esp)
  8017c3:	e8 4e ff ff ff       	call   801716 <fd_close>
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <close_all>:

void
close_all(void)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	53                   	push   %ebx
  8017ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017d6:	89 1c 24             	mov    %ebx,(%esp)
  8017d9:	e8 b9 ff ff ff       	call   801797 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017de:	83 c3 01             	add    $0x1,%ebx
  8017e1:	83 fb 20             	cmp    $0x20,%ebx
  8017e4:	75 f0                	jne    8017d6 <close_all+0xc>
		close(i);
}
  8017e6:	83 c4 14             	add    $0x14,%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5d                   	pop    %ebp
  8017eb:	c3                   	ret    

008017ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	57                   	push   %edi
  8017f0:	56                   	push   %esi
  8017f1:	53                   	push   %ebx
  8017f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	89 04 24             	mov    %eax,(%esp)
  801802:	e8 5f fe ff ff       	call   801666 <fd_lookup>
  801807:	89 c2                	mov    %eax,%edx
  801809:	85 d2                	test   %edx,%edx
  80180b:	0f 88 e1 00 00 00    	js     8018f2 <dup+0x106>
		return r;
	close(newfdnum);
  801811:	8b 45 0c             	mov    0xc(%ebp),%eax
  801814:	89 04 24             	mov    %eax,(%esp)
  801817:	e8 7b ff ff ff       	call   801797 <close>

	newfd = INDEX2FD(newfdnum);
  80181c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80181f:	c1 e3 0c             	shl    $0xc,%ebx
  801822:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80182b:	89 04 24             	mov    %eax,(%esp)
  80182e:	e8 cd fd ff ff       	call   801600 <fd2data>
  801833:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801835:	89 1c 24             	mov    %ebx,(%esp)
  801838:	e8 c3 fd ff ff       	call   801600 <fd2data>
  80183d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80183f:	89 f0                	mov    %esi,%eax
  801841:	c1 e8 16             	shr    $0x16,%eax
  801844:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80184b:	a8 01                	test   $0x1,%al
  80184d:	74 43                	je     801892 <dup+0xa6>
  80184f:	89 f0                	mov    %esi,%eax
  801851:	c1 e8 0c             	shr    $0xc,%eax
  801854:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80185b:	f6 c2 01             	test   $0x1,%dl
  80185e:	74 32                	je     801892 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801860:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801867:	25 07 0e 00 00       	and    $0xe07,%eax
  80186c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801870:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801874:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80187b:	00 
  80187c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801880:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801887:	e8 8b f5 ff ff       	call   800e17 <sys_page_map>
  80188c:	89 c6                	mov    %eax,%esi
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 3e                	js     8018d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801895:	89 c2                	mov    %eax,%edx
  801897:	c1 ea 0c             	shr    $0xc,%edx
  80189a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8018a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8018af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018b6:	00 
  8018b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018c2:	e8 50 f5 ff ff       	call   800e17 <sys_page_map>
  8018c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018cc:	85 f6                	test   %esi,%esi
  8018ce:	79 22                	jns    8018f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018db:	e8 8a f5 ff ff       	call   800e6a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018eb:	e8 7a f5 ff ff       	call   800e6a <sys_page_unmap>
	return r;
  8018f0:	89 f0                	mov    %esi,%eax
}
  8018f2:	83 c4 3c             	add    $0x3c,%esp
  8018f5:	5b                   	pop    %ebx
  8018f6:	5e                   	pop    %esi
  8018f7:	5f                   	pop    %edi
  8018f8:	5d                   	pop    %ebp
  8018f9:	c3                   	ret    

008018fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	53                   	push   %ebx
  8018fe:	83 ec 24             	sub    $0x24,%esp
  801901:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801904:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190b:	89 1c 24             	mov    %ebx,(%esp)
  80190e:	e8 53 fd ff ff       	call   801666 <fd_lookup>
  801913:	89 c2                	mov    %eax,%edx
  801915:	85 d2                	test   %edx,%edx
  801917:	78 6d                	js     801986 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801919:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801923:	8b 00                	mov    (%eax),%eax
  801925:	89 04 24             	mov    %eax,(%esp)
  801928:	e8 8f fd ff ff       	call   8016bc <dev_lookup>
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 55                	js     801986 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801934:	8b 50 08             	mov    0x8(%eax),%edx
  801937:	83 e2 03             	and    $0x3,%edx
  80193a:	83 fa 01             	cmp    $0x1,%edx
  80193d:	75 23                	jne    801962 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80193f:	a1 20 54 80 00       	mov    0x805420,%eax
  801944:	8b 40 48             	mov    0x48(%eax),%eax
  801947:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80194b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194f:	c7 04 24 ad 33 80 00 	movl   $0x8033ad,(%esp)
  801956:	e8 1c ea ff ff       	call   800377 <cprintf>
		return -E_INVAL;
  80195b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801960:	eb 24                	jmp    801986 <read+0x8c>
	}
	if (!dev->dev_read)
  801962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801965:	8b 52 08             	mov    0x8(%edx),%edx
  801968:	85 d2                	test   %edx,%edx
  80196a:	74 15                	je     801981 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80196c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801973:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801976:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80197a:	89 04 24             	mov    %eax,(%esp)
  80197d:	ff d2                	call   *%edx
  80197f:	eb 05                	jmp    801986 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801981:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801986:	83 c4 24             	add    $0x24,%esp
  801989:	5b                   	pop    %ebx
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    

0080198c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	57                   	push   %edi
  801990:	56                   	push   %esi
  801991:	53                   	push   %ebx
  801992:	83 ec 1c             	sub    $0x1c,%esp
  801995:	8b 7d 08             	mov    0x8(%ebp),%edi
  801998:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80199b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019a0:	eb 23                	jmp    8019c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019a2:	89 f0                	mov    %esi,%eax
  8019a4:	29 d8                	sub    %ebx,%eax
  8019a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019aa:	89 d8                	mov    %ebx,%eax
  8019ac:	03 45 0c             	add    0xc(%ebp),%eax
  8019af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b3:	89 3c 24             	mov    %edi,(%esp)
  8019b6:	e8 3f ff ff ff       	call   8018fa <read>
		if (m < 0)
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 10                	js     8019cf <readn+0x43>
			return m;
		if (m == 0)
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	74 0a                	je     8019cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019c3:	01 c3                	add    %eax,%ebx
  8019c5:	39 f3                	cmp    %esi,%ebx
  8019c7:	72 d9                	jb     8019a2 <readn+0x16>
  8019c9:	89 d8                	mov    %ebx,%eax
  8019cb:	eb 02                	jmp    8019cf <readn+0x43>
  8019cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8019cf:	83 c4 1c             	add    $0x1c,%esp
  8019d2:	5b                   	pop    %ebx
  8019d3:	5e                   	pop    %esi
  8019d4:	5f                   	pop    %edi
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    

008019d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	53                   	push   %ebx
  8019db:	83 ec 24             	sub    $0x24,%esp
  8019de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e8:	89 1c 24             	mov    %ebx,(%esp)
  8019eb:	e8 76 fc ff ff       	call   801666 <fd_lookup>
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	85 d2                	test   %edx,%edx
  8019f4:	78 68                	js     801a5e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	89 04 24             	mov    %eax,(%esp)
  801a05:	e8 b2 fc ff ff       	call   8016bc <dev_lookup>
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	78 50                	js     801a5e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a11:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a15:	75 23                	jne    801a3a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a17:	a1 20 54 80 00       	mov    0x805420,%eax
  801a1c:	8b 40 48             	mov    0x48(%eax),%eax
  801a1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a27:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
  801a2e:	e8 44 e9 ff ff       	call   800377 <cprintf>
		return -E_INVAL;
  801a33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a38:	eb 24                	jmp    801a5e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a3d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a40:	85 d2                	test   %edx,%edx
  801a42:	74 15                	je     801a59 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a52:	89 04 24             	mov    %eax,(%esp)
  801a55:	ff d2                	call   *%edx
  801a57:	eb 05                	jmp    801a5e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a59:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a5e:	83 c4 24             	add    $0x24,%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    

00801a64 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a6a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	e8 ea fb ff ff       	call   801666 <fd_lookup>
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 0e                	js     801a8e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a86:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	53                   	push   %ebx
  801a94:	83 ec 24             	sub    $0x24,%esp
  801a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa1:	89 1c 24             	mov    %ebx,(%esp)
  801aa4:	e8 bd fb ff ff       	call   801666 <fd_lookup>
  801aa9:	89 c2                	mov    %eax,%edx
  801aab:	85 d2                	test   %edx,%edx
  801aad:	78 61                	js     801b10 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aaf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab9:	8b 00                	mov    (%eax),%eax
  801abb:	89 04 24             	mov    %eax,(%esp)
  801abe:	e8 f9 fb ff ff       	call   8016bc <dev_lookup>
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 49                	js     801b10 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ace:	75 23                	jne    801af3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801ad0:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ad5:	8b 40 48             	mov    0x48(%eax),%eax
  801ad8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae0:	c7 04 24 8c 33 80 00 	movl   $0x80338c,(%esp)
  801ae7:	e8 8b e8 ff ff       	call   800377 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801aec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af1:	eb 1d                	jmp    801b10 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af6:	8b 52 18             	mov    0x18(%edx),%edx
  801af9:	85 d2                	test   %edx,%edx
  801afb:	74 0e                	je     801b0b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801afd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b00:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b04:	89 04 24             	mov    %eax,(%esp)
  801b07:	ff d2                	call   *%edx
  801b09:	eb 05                	jmp    801b10 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b10:	83 c4 24             	add    $0x24,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    

00801b16 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	53                   	push   %ebx
  801b1a:	83 ec 24             	sub    $0x24,%esp
  801b1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	89 04 24             	mov    %eax,(%esp)
  801b2d:	e8 34 fb ff ff       	call   801666 <fd_lookup>
  801b32:	89 c2                	mov    %eax,%edx
  801b34:	85 d2                	test   %edx,%edx
  801b36:	78 52                	js     801b8a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 00                	mov    (%eax),%eax
  801b44:	89 04 24             	mov    %eax,(%esp)
  801b47:	e8 70 fb ff ff       	call   8016bc <dev_lookup>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	78 3a                	js     801b8a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b53:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b57:	74 2c                	je     801b85 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b59:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b5c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b63:	00 00 00 
	stat->st_isdir = 0;
  801b66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b6d:	00 00 00 
	stat->st_dev = dev;
  801b70:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b7d:	89 14 24             	mov    %edx,(%esp)
  801b80:	ff 50 14             	call   *0x14(%eax)
  801b83:	eb 05                	jmp    801b8a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b8a:	83 c4 24             	add    $0x24,%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    

00801b90 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
  801b95:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b9f:	00 
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	89 04 24             	mov    %eax,(%esp)
  801ba6:	e8 1b 02 00 00       	call   801dc6 <open>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	85 db                	test   %ebx,%ebx
  801baf:	78 1b                	js     801bcc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb8:	89 1c 24             	mov    %ebx,(%esp)
  801bbb:	e8 56 ff ff ff       	call   801b16 <fstat>
  801bc0:	89 c6                	mov    %eax,%esi
	close(fd);
  801bc2:	89 1c 24             	mov    %ebx,(%esp)
  801bc5:	e8 cd fb ff ff       	call   801797 <close>
	return r;
  801bca:	89 f0                	mov    %esi,%eax
}
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5d                   	pop    %ebp
  801bd2:	c3                   	ret    

00801bd3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	56                   	push   %esi
  801bd7:	53                   	push   %ebx
  801bd8:	83 ec 10             	sub    $0x10,%esp
  801bdb:	89 c6                	mov    %eax,%esi
  801bdd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bdf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801be6:	75 11                	jne    801bf9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801be8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bef:	e8 8b 0e 00 00       	call   802a7f <ipc_find_env>
  801bf4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bf9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c00:	00 
  801c01:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c08:	00 
  801c09:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c0d:	a1 00 50 80 00       	mov    0x805000,%eax
  801c12:	89 04 24             	mov    %eax,(%esp)
  801c15:	e8 fa 0d 00 00       	call   802a14 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c21:	00 
  801c22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c2d:	e8 8e 0d 00 00       	call   8029c0 <ipc_recv>
}
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	5b                   	pop    %ebx
  801c36:	5e                   	pop    %esi
  801c37:	5d                   	pop    %ebp
  801c38:	c3                   	ret    

00801c39 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	8b 40 0c             	mov    0xc(%eax),%eax
  801c45:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c52:	ba 00 00 00 00       	mov    $0x0,%edx
  801c57:	b8 02 00 00 00       	mov    $0x2,%eax
  801c5c:	e8 72 ff ff ff       	call   801bd3 <fsipc>
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c74:	ba 00 00 00 00       	mov    $0x0,%edx
  801c79:	b8 06 00 00 00       	mov    $0x6,%eax
  801c7e:	e8 50 ff ff ff       	call   801bd3 <fsipc>
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	53                   	push   %ebx
  801c89:	83 ec 14             	sub    $0x14,%esp
  801c8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	8b 40 0c             	mov    0xc(%eax),%eax
  801c95:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9f:	b8 05 00 00 00       	mov    $0x5,%eax
  801ca4:	e8 2a ff ff ff       	call   801bd3 <fsipc>
  801ca9:	89 c2                	mov    %eax,%edx
  801cab:	85 d2                	test   %edx,%edx
  801cad:	78 2b                	js     801cda <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801caf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cb6:	00 
  801cb7:	89 1c 24             	mov    %ebx,(%esp)
  801cba:	e8 e8 ec ff ff       	call   8009a7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cbf:	a1 80 60 80 00       	mov    0x806080,%eax
  801cc4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cca:	a1 84 60 80 00       	mov    0x806084,%eax
  801ccf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cda:	83 c4 14             	add    $0x14,%esp
  801cdd:	5b                   	pop    %ebx
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    

00801ce0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 18             	sub    $0x18,%esp
  801ce6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  801cec:	8b 52 0c             	mov    0xc(%edx),%edx
  801cef:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801cf5:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801cfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d05:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d0c:	e8 9b ee ff ff       	call   800bac <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801d11:	ba 00 00 00 00       	mov    $0x0,%edx
  801d16:	b8 04 00 00 00       	mov    $0x4,%eax
  801d1b:	e8 b3 fe ff ff       	call   801bd3 <fsipc>
		return r;
	}

	return r;
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	56                   	push   %esi
  801d26:	53                   	push   %ebx
  801d27:	83 ec 10             	sub    $0x10,%esp
  801d2a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	8b 40 0c             	mov    0xc(%eax),%eax
  801d33:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d38:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d43:	b8 03 00 00 00       	mov    $0x3,%eax
  801d48:	e8 86 fe ff ff       	call   801bd3 <fsipc>
  801d4d:	89 c3                	mov    %eax,%ebx
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	78 6a                	js     801dbd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d53:	39 c6                	cmp    %eax,%esi
  801d55:	73 24                	jae    801d7b <devfile_read+0x59>
  801d57:	c7 44 24 0c fc 33 80 	movl   $0x8033fc,0xc(%esp)
  801d5e:	00 
  801d5f:	c7 44 24 08 03 34 80 	movl   $0x803403,0x8(%esp)
  801d66:	00 
  801d67:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d6e:	00 
  801d6f:	c7 04 24 18 34 80 00 	movl   $0x803418,(%esp)
  801d76:	e8 03 e5 ff ff       	call   80027e <_panic>
	assert(r <= PGSIZE);
  801d7b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d80:	7e 24                	jle    801da6 <devfile_read+0x84>
  801d82:	c7 44 24 0c 23 34 80 	movl   $0x803423,0xc(%esp)
  801d89:	00 
  801d8a:	c7 44 24 08 03 34 80 	movl   $0x803403,0x8(%esp)
  801d91:	00 
  801d92:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d99:	00 
  801d9a:	c7 04 24 18 34 80 00 	movl   $0x803418,(%esp)
  801da1:	e8 d8 e4 ff ff       	call   80027e <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801da6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801daa:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801db1:	00 
  801db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db5:	89 04 24             	mov    %eax,(%esp)
  801db8:	e8 87 ed ff ff       	call   800b44 <memmove>
	return r;
}
  801dbd:	89 d8                	mov    %ebx,%eax
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	5b                   	pop    %ebx
  801dc3:	5e                   	pop    %esi
  801dc4:	5d                   	pop    %ebp
  801dc5:	c3                   	ret    

00801dc6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	53                   	push   %ebx
  801dca:	83 ec 24             	sub    $0x24,%esp
  801dcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801dd0:	89 1c 24             	mov    %ebx,(%esp)
  801dd3:	e8 98 eb ff ff       	call   800970 <strlen>
  801dd8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ddd:	7f 60                	jg     801e3f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ddf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de2:	89 04 24             	mov    %eax,(%esp)
  801de5:	e8 2d f8 ff ff       	call   801617 <fd_alloc>
  801dea:	89 c2                	mov    %eax,%edx
  801dec:	85 d2                	test   %edx,%edx
  801dee:	78 54                	js     801e44 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801df0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801df4:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801dfb:	e8 a7 eb ff ff       	call   8009a7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e03:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e10:	e8 be fd ff ff       	call   801bd3 <fsipc>
  801e15:	89 c3                	mov    %eax,%ebx
  801e17:	85 c0                	test   %eax,%eax
  801e19:	79 17                	jns    801e32 <open+0x6c>
		fd_close(fd, 0);
  801e1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e22:	00 
  801e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e26:	89 04 24             	mov    %eax,(%esp)
  801e29:	e8 e8 f8 ff ff       	call   801716 <fd_close>
		return r;
  801e2e:	89 d8                	mov    %ebx,%eax
  801e30:	eb 12                	jmp    801e44 <open+0x7e>
	}

	return fd2num(fd);
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	89 04 24             	mov    %eax,(%esp)
  801e38:	e8 b3 f7 ff ff       	call   8015f0 <fd2num>
  801e3d:	eb 05                	jmp    801e44 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e3f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e44:	83 c4 24             	add    $0x24,%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    

00801e4a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e50:	ba 00 00 00 00       	mov    $0x0,%edx
  801e55:	b8 08 00 00 00       	mov    $0x8,%eax
  801e5a:	e8 74 fd ff ff       	call   801bd3 <fsipc>
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    
  801e61:	66 90                	xchg   %ax,%ax
  801e63:	66 90                	xchg   %ax,%ax
  801e65:	66 90                	xchg   %ax,%ax
  801e67:	66 90                	xchg   %ax,%ax
  801e69:	66 90                	xchg   %ax,%ax
  801e6b:	66 90                	xchg   %ax,%ax
  801e6d:	66 90                	xchg   %ax,%ax
  801e6f:	90                   	nop

00801e70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e76:	c7 44 24 04 2f 34 80 	movl   $0x80342f,0x4(%esp)
  801e7d:	00 
  801e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e81:	89 04 24             	mov    %eax,(%esp)
  801e84:	e8 1e eb ff ff       	call   8009a7 <strcpy>
	return 0;
}
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	53                   	push   %ebx
  801e94:	83 ec 14             	sub    $0x14,%esp
  801e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e9a:	89 1c 24             	mov    %ebx,(%esp)
  801e9d:	e8 1c 0c 00 00       	call   802abe <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801ea2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801ea7:	83 f8 01             	cmp    $0x1,%eax
  801eaa:	75 0d                	jne    801eb9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801eac:	8b 43 0c             	mov    0xc(%ebx),%eax
  801eaf:	89 04 24             	mov    %eax,(%esp)
  801eb2:	e8 29 03 00 00       	call   8021e0 <nsipc_close>
  801eb7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801eb9:	89 d0                	mov    %edx,%eax
  801ebb:	83 c4 14             	add    $0x14,%esp
  801ebe:	5b                   	pop    %ebx
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ec7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ece:	00 
  801ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee3:	89 04 24             	mov    %eax,(%esp)
  801ee6:	e8 f0 03 00 00       	call   8022db <nsipc_send>
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ef3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801efa:	00 
  801efb:	8b 45 10             	mov    0x10(%ebp),%eax
  801efe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0f:	89 04 24             	mov    %eax,(%esp)
  801f12:	e8 44 03 00 00       	call   80225b <nsipc_recv>
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f1f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f22:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f26:	89 04 24             	mov    %eax,(%esp)
  801f29:	e8 38 f7 ff ff       	call   801666 <fd_lookup>
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 17                	js     801f49 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f3b:	39 08                	cmp    %ecx,(%eax)
  801f3d:	75 05                	jne    801f44 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f42:	eb 05                	jmp    801f49 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	56                   	push   %esi
  801f4f:	53                   	push   %ebx
  801f50:	83 ec 20             	sub    $0x20,%esp
  801f53:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f58:	89 04 24             	mov    %eax,(%esp)
  801f5b:	e8 b7 f6 ff ff       	call   801617 <fd_alloc>
  801f60:	89 c3                	mov    %eax,%ebx
  801f62:	85 c0                	test   %eax,%eax
  801f64:	78 21                	js     801f87 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f6d:	00 
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7c:	e8 42 ee ff ff       	call   800dc3 <sys_page_alloc>
  801f81:	89 c3                	mov    %eax,%ebx
  801f83:	85 c0                	test   %eax,%eax
  801f85:	79 0c                	jns    801f93 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f87:	89 34 24             	mov    %esi,(%esp)
  801f8a:	e8 51 02 00 00       	call   8021e0 <nsipc_close>
		return r;
  801f8f:	89 d8                	mov    %ebx,%eax
  801f91:	eb 20                	jmp    801fb3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f93:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801fa8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801fab:	89 14 24             	mov    %edx,(%esp)
  801fae:	e8 3d f6 ff ff       	call   8015f0 <fd2num>
}
  801fb3:	83 c4 20             	add    $0x20,%esp
  801fb6:	5b                   	pop    %ebx
  801fb7:	5e                   	pop    %esi
  801fb8:	5d                   	pop    %ebp
  801fb9:	c3                   	ret    

00801fba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	e8 51 ff ff ff       	call   801f19 <fd2sockid>
		return r;
  801fc8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	78 23                	js     801ff1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fce:	8b 55 10             	mov    0x10(%ebp),%edx
  801fd1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fdc:	89 04 24             	mov    %eax,(%esp)
  801fdf:	e8 45 01 00 00       	call   802129 <nsipc_accept>
		return r;
  801fe4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 07                	js     801ff1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801fea:	e8 5c ff ff ff       	call   801f4b <alloc_sockfd>
  801fef:	89 c1                	mov    %eax,%ecx
}
  801ff1:	89 c8                	mov    %ecx,%eax
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	e8 16 ff ff ff       	call   801f19 <fd2sockid>
  802003:	89 c2                	mov    %eax,%edx
  802005:	85 d2                	test   %edx,%edx
  802007:	78 16                	js     80201f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802009:	8b 45 10             	mov    0x10(%ebp),%eax
  80200c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802010:	8b 45 0c             	mov    0xc(%ebp),%eax
  802013:	89 44 24 04          	mov    %eax,0x4(%esp)
  802017:	89 14 24             	mov    %edx,(%esp)
  80201a:	e8 60 01 00 00       	call   80217f <nsipc_bind>
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <shutdown>:

int
shutdown(int s, int how)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	e8 ea fe ff ff       	call   801f19 <fd2sockid>
  80202f:	89 c2                	mov    %eax,%edx
  802031:	85 d2                	test   %edx,%edx
  802033:	78 0f                	js     802044 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802035:	8b 45 0c             	mov    0xc(%ebp),%eax
  802038:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203c:	89 14 24             	mov    %edx,(%esp)
  80203f:	e8 7a 01 00 00       	call   8021be <nsipc_shutdown>
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	e8 c5 fe ff ff       	call   801f19 <fd2sockid>
  802054:	89 c2                	mov    %eax,%edx
  802056:	85 d2                	test   %edx,%edx
  802058:	78 16                	js     802070 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80205a:	8b 45 10             	mov    0x10(%ebp),%eax
  80205d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802061:	8b 45 0c             	mov    0xc(%ebp),%eax
  802064:	89 44 24 04          	mov    %eax,0x4(%esp)
  802068:	89 14 24             	mov    %edx,(%esp)
  80206b:	e8 8a 01 00 00       	call   8021fa <nsipc_connect>
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <listen>:

int
listen(int s, int backlog)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	e8 99 fe ff ff       	call   801f19 <fd2sockid>
  802080:	89 c2                	mov    %eax,%edx
  802082:	85 d2                	test   %edx,%edx
  802084:	78 0f                	js     802095 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802086:	8b 45 0c             	mov    0xc(%ebp),%eax
  802089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208d:	89 14 24             	mov    %edx,(%esp)
  802090:	e8 a4 01 00 00       	call   802239 <nsipc_listen>
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80209d:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	89 04 24             	mov    %eax,(%esp)
  8020b1:	e8 98 02 00 00       	call   80234e <nsipc_socket>
  8020b6:	89 c2                	mov    %eax,%edx
  8020b8:	85 d2                	test   %edx,%edx
  8020ba:	78 05                	js     8020c1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8020bc:	e8 8a fe ff ff       	call   801f4b <alloc_sockfd>
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	53                   	push   %ebx
  8020c7:	83 ec 14             	sub    $0x14,%esp
  8020ca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020cc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020d3:	75 11                	jne    8020e6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020dc:	e8 9e 09 00 00       	call   802a7f <ipc_find_env>
  8020e1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020e6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020ed:	00 
  8020ee:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8020f5:	00 
  8020f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020fa:	a1 04 50 80 00       	mov    0x805004,%eax
  8020ff:	89 04 24             	mov    %eax,(%esp)
  802102:	e8 0d 09 00 00       	call   802a14 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802107:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80210e:	00 
  80210f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802116:	00 
  802117:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80211e:	e8 9d 08 00 00       	call   8029c0 <ipc_recv>
}
  802123:	83 c4 14             	add    $0x14,%esp
  802126:	5b                   	pop    %ebx
  802127:	5d                   	pop    %ebp
  802128:	c3                   	ret    

00802129 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	56                   	push   %esi
  80212d:	53                   	push   %ebx
  80212e:	83 ec 10             	sub    $0x10,%esp
  802131:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80213c:	8b 06                	mov    (%esi),%eax
  80213e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802143:	b8 01 00 00 00       	mov    $0x1,%eax
  802148:	e8 76 ff ff ff       	call   8020c3 <nsipc>
  80214d:	89 c3                	mov    %eax,%ebx
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 23                	js     802176 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802153:	a1 10 70 80 00       	mov    0x807010,%eax
  802158:	89 44 24 08          	mov    %eax,0x8(%esp)
  80215c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802163:	00 
  802164:	8b 45 0c             	mov    0xc(%ebp),%eax
  802167:	89 04 24             	mov    %eax,(%esp)
  80216a:	e8 d5 e9 ff ff       	call   800b44 <memmove>
		*addrlen = ret->ret_addrlen;
  80216f:	a1 10 70 80 00       	mov    0x807010,%eax
  802174:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802176:	89 d8                	mov    %ebx,%eax
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	5b                   	pop    %ebx
  80217c:	5e                   	pop    %esi
  80217d:	5d                   	pop    %ebp
  80217e:	c3                   	ret    

0080217f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	53                   	push   %ebx
  802183:	83 ec 14             	sub    $0x14,%esp
  802186:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802191:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802195:	8b 45 0c             	mov    0xc(%ebp),%eax
  802198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021a3:	e8 9c e9 ff ff       	call   800b44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021a8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8021b3:	e8 0b ff ff ff       	call   8020c3 <nsipc>
}
  8021b8:	83 c4 14             	add    $0x14,%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5d                   	pop    %ebp
  8021bd:	c3                   	ret    

008021be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8021d9:	e8 e5 fe ff ff       	call   8020c3 <nsipc>
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <nsipc_close>:

int
nsipc_close(int s)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8021f3:	e8 cb fe ff ff       	call   8020c3 <nsipc>
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	53                   	push   %ebx
  8021fe:	83 ec 14             	sub    $0x14,%esp
  802201:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80220c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80221e:	e8 21 e9 ff ff       	call   800b44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802223:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802229:	b8 05 00 00 00       	mov    $0x5,%eax
  80222e:	e8 90 fe ff ff       	call   8020c3 <nsipc>
}
  802233:	83 c4 14             	add    $0x14,%esp
  802236:	5b                   	pop    %ebx
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    

00802239 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80224f:	b8 06 00 00 00       	mov    $0x6,%eax
  802254:	e8 6a fe ff ff       	call   8020c3 <nsipc>
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	56                   	push   %esi
  80225f:	53                   	push   %ebx
  802260:	83 ec 10             	sub    $0x10,%esp
  802263:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80226e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802274:	8b 45 14             	mov    0x14(%ebp),%eax
  802277:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80227c:	b8 07 00 00 00       	mov    $0x7,%eax
  802281:	e8 3d fe ff ff       	call   8020c3 <nsipc>
  802286:	89 c3                	mov    %eax,%ebx
  802288:	85 c0                	test   %eax,%eax
  80228a:	78 46                	js     8022d2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80228c:	39 f0                	cmp    %esi,%eax
  80228e:	7f 07                	jg     802297 <nsipc_recv+0x3c>
  802290:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802295:	7e 24                	jle    8022bb <nsipc_recv+0x60>
  802297:	c7 44 24 0c 3b 34 80 	movl   $0x80343b,0xc(%esp)
  80229e:	00 
  80229f:	c7 44 24 08 03 34 80 	movl   $0x803403,0x8(%esp)
  8022a6:	00 
  8022a7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022ae:	00 
  8022af:	c7 04 24 50 34 80 00 	movl   $0x803450,(%esp)
  8022b6:	e8 c3 df ff ff       	call   80027e <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022bf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022c6:	00 
  8022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ca:	89 04 24             	mov    %eax,(%esp)
  8022cd:	e8 72 e8 ff ff       	call   800b44 <memmove>
	}

	return r;
}
  8022d2:	89 d8                	mov    %ebx,%eax
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	5b                   	pop    %ebx
  8022d8:	5e                   	pop    %esi
  8022d9:	5d                   	pop    %ebp
  8022da:	c3                   	ret    

008022db <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	53                   	push   %ebx
  8022df:	83 ec 14             	sub    $0x14,%esp
  8022e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022ed:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022f3:	7e 24                	jle    802319 <nsipc_send+0x3e>
  8022f5:	c7 44 24 0c 5c 34 80 	movl   $0x80345c,0xc(%esp)
  8022fc:	00 
  8022fd:	c7 44 24 08 03 34 80 	movl   $0x803403,0x8(%esp)
  802304:	00 
  802305:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80230c:	00 
  80230d:	c7 04 24 50 34 80 00 	movl   $0x803450,(%esp)
  802314:	e8 65 df ff ff       	call   80027e <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802319:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80231d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802320:	89 44 24 04          	mov    %eax,0x4(%esp)
  802324:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80232b:	e8 14 e8 ff ff       	call   800b44 <memmove>
	nsipcbuf.send.req_size = size;
  802330:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802336:	8b 45 14             	mov    0x14(%ebp),%eax
  802339:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80233e:	b8 08 00 00 00       	mov    $0x8,%eax
  802343:	e8 7b fd ff ff       	call   8020c3 <nsipc>
}
  802348:	83 c4 14             	add    $0x14,%esp
  80234b:	5b                   	pop    %ebx
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    

0080234e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80235c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802364:	8b 45 10             	mov    0x10(%ebp),%eax
  802367:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80236c:	b8 09 00 00 00       	mov    $0x9,%eax
  802371:	e8 4d fd ff ff       	call   8020c3 <nsipc>
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	56                   	push   %esi
  80237c:	53                   	push   %ebx
  80237d:	83 ec 10             	sub    $0x10,%esp
  802380:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	89 04 24             	mov    %eax,(%esp)
  802389:	e8 72 f2 ff ff       	call   801600 <fd2data>
  80238e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802390:	c7 44 24 04 68 34 80 	movl   $0x803468,0x4(%esp)
  802397:	00 
  802398:	89 1c 24             	mov    %ebx,(%esp)
  80239b:	e8 07 e6 ff ff       	call   8009a7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023a0:	8b 46 04             	mov    0x4(%esi),%eax
  8023a3:	2b 06                	sub    (%esi),%eax
  8023a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023b2:	00 00 00 
	stat->st_dev = &devpipe;
  8023b5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023bc:	40 80 00 
	return 0;
}
  8023bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c4:	83 c4 10             	add    $0x10,%esp
  8023c7:	5b                   	pop    %ebx
  8023c8:	5e                   	pop    %esi
  8023c9:	5d                   	pop    %ebp
  8023ca:	c3                   	ret    

008023cb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	53                   	push   %ebx
  8023cf:	83 ec 14             	sub    $0x14,%esp
  8023d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e0:	e8 85 ea ff ff       	call   800e6a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023e5:	89 1c 24             	mov    %ebx,(%esp)
  8023e8:	e8 13 f2 ff ff       	call   801600 <fd2data>
  8023ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f8:	e8 6d ea ff ff       	call   800e6a <sys_page_unmap>
}
  8023fd:	83 c4 14             	add    $0x14,%esp
  802400:	5b                   	pop    %ebx
  802401:	5d                   	pop    %ebp
  802402:	c3                   	ret    

00802403 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	57                   	push   %edi
  802407:	56                   	push   %esi
  802408:	53                   	push   %ebx
  802409:	83 ec 2c             	sub    $0x2c,%esp
  80240c:	89 c6                	mov    %eax,%esi
  80240e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802411:	a1 20 54 80 00       	mov    0x805420,%eax
  802416:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802419:	89 34 24             	mov    %esi,(%esp)
  80241c:	e8 9d 06 00 00       	call   802abe <pageref>
  802421:	89 c7                	mov    %eax,%edi
  802423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802426:	89 04 24             	mov    %eax,(%esp)
  802429:	e8 90 06 00 00       	call   802abe <pageref>
  80242e:	39 c7                	cmp    %eax,%edi
  802430:	0f 94 c2             	sete   %dl
  802433:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802436:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  80243c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80243f:	39 fb                	cmp    %edi,%ebx
  802441:	74 21                	je     802464 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802443:	84 d2                	test   %dl,%dl
  802445:	74 ca                	je     802411 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802447:	8b 51 58             	mov    0x58(%ecx),%edx
  80244a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80244e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802452:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802456:	c7 04 24 6f 34 80 00 	movl   $0x80346f,(%esp)
  80245d:	e8 15 df ff ff       	call   800377 <cprintf>
  802462:	eb ad                	jmp    802411 <_pipeisclosed+0xe>
	}
}
  802464:	83 c4 2c             	add    $0x2c,%esp
  802467:	5b                   	pop    %ebx
  802468:	5e                   	pop    %esi
  802469:	5f                   	pop    %edi
  80246a:	5d                   	pop    %ebp
  80246b:	c3                   	ret    

0080246c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	57                   	push   %edi
  802470:	56                   	push   %esi
  802471:	53                   	push   %ebx
  802472:	83 ec 1c             	sub    $0x1c,%esp
  802475:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802478:	89 34 24             	mov    %esi,(%esp)
  80247b:	e8 80 f1 ff ff       	call   801600 <fd2data>
  802480:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802482:	bf 00 00 00 00       	mov    $0x0,%edi
  802487:	eb 45                	jmp    8024ce <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802489:	89 da                	mov    %ebx,%edx
  80248b:	89 f0                	mov    %esi,%eax
  80248d:	e8 71 ff ff ff       	call   802403 <_pipeisclosed>
  802492:	85 c0                	test   %eax,%eax
  802494:	75 41                	jne    8024d7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802496:	e8 09 e9 ff ff       	call   800da4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80249b:	8b 43 04             	mov    0x4(%ebx),%eax
  80249e:	8b 0b                	mov    (%ebx),%ecx
  8024a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024a3:	39 d0                	cmp    %edx,%eax
  8024a5:	73 e2                	jae    802489 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024b1:	99                   	cltd   
  8024b2:	c1 ea 1b             	shr    $0x1b,%edx
  8024b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8024b8:	83 e1 1f             	and    $0x1f,%ecx
  8024bb:	29 d1                	sub    %edx,%ecx
  8024bd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8024c1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8024c5:	83 c0 01             	add    $0x1,%eax
  8024c8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024cb:	83 c7 01             	add    $0x1,%edi
  8024ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024d1:	75 c8                	jne    80249b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024d3:	89 f8                	mov    %edi,%eax
  8024d5:	eb 05                	jmp    8024dc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024dc:	83 c4 1c             	add    $0x1c,%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	5f                   	pop    %edi
  8024e2:	5d                   	pop    %ebp
  8024e3:	c3                   	ret    

008024e4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	57                   	push   %edi
  8024e8:	56                   	push   %esi
  8024e9:	53                   	push   %ebx
  8024ea:	83 ec 1c             	sub    $0x1c,%esp
  8024ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8024f0:	89 3c 24             	mov    %edi,(%esp)
  8024f3:	e8 08 f1 ff ff       	call   801600 <fd2data>
  8024f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024fa:	be 00 00 00 00       	mov    $0x0,%esi
  8024ff:	eb 3d                	jmp    80253e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802501:	85 f6                	test   %esi,%esi
  802503:	74 04                	je     802509 <devpipe_read+0x25>
				return i;
  802505:	89 f0                	mov    %esi,%eax
  802507:	eb 43                	jmp    80254c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802509:	89 da                	mov    %ebx,%edx
  80250b:	89 f8                	mov    %edi,%eax
  80250d:	e8 f1 fe ff ff       	call   802403 <_pipeisclosed>
  802512:	85 c0                	test   %eax,%eax
  802514:	75 31                	jne    802547 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802516:	e8 89 e8 ff ff       	call   800da4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80251b:	8b 03                	mov    (%ebx),%eax
  80251d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802520:	74 df                	je     802501 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802522:	99                   	cltd   
  802523:	c1 ea 1b             	shr    $0x1b,%edx
  802526:	01 d0                	add    %edx,%eax
  802528:	83 e0 1f             	and    $0x1f,%eax
  80252b:	29 d0                	sub    %edx,%eax
  80252d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802535:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802538:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80253b:	83 c6 01             	add    $0x1,%esi
  80253e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802541:	75 d8                	jne    80251b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802543:	89 f0                	mov    %esi,%eax
  802545:	eb 05                	jmp    80254c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80254c:	83 c4 1c             	add    $0x1c,%esp
  80254f:	5b                   	pop    %ebx
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    

00802554 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	56                   	push   %esi
  802558:	53                   	push   %ebx
  802559:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80255c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80255f:	89 04 24             	mov    %eax,(%esp)
  802562:	e8 b0 f0 ff ff       	call   801617 <fd_alloc>
  802567:	89 c2                	mov    %eax,%edx
  802569:	85 d2                	test   %edx,%edx
  80256b:	0f 88 4d 01 00 00    	js     8026be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802571:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802578:	00 
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802587:	e8 37 e8 ff ff       	call   800dc3 <sys_page_alloc>
  80258c:	89 c2                	mov    %eax,%edx
  80258e:	85 d2                	test   %edx,%edx
  802590:	0f 88 28 01 00 00    	js     8026be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802596:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802599:	89 04 24             	mov    %eax,(%esp)
  80259c:	e8 76 f0 ff ff       	call   801617 <fd_alloc>
  8025a1:	89 c3                	mov    %eax,%ebx
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	0f 88 fe 00 00 00    	js     8026a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025b2:	00 
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c1:	e8 fd e7 ff ff       	call   800dc3 <sys_page_alloc>
  8025c6:	89 c3                	mov    %eax,%ebx
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	0f 88 d9 00 00 00    	js     8026a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	89 04 24             	mov    %eax,(%esp)
  8025d6:	e8 25 f0 ff ff       	call   801600 <fd2data>
  8025db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025dd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025e4:	00 
  8025e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f0:	e8 ce e7 ff ff       	call   800dc3 <sys_page_alloc>
  8025f5:	89 c3                	mov    %eax,%ebx
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	0f 88 97 00 00 00    	js     802696 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802602:	89 04 24             	mov    %eax,(%esp)
  802605:	e8 f6 ef ff ff       	call   801600 <fd2data>
  80260a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802611:	00 
  802612:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802616:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80261d:	00 
  80261e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802622:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802629:	e8 e9 e7 ff ff       	call   800e17 <sys_page_map>
  80262e:	89 c3                	mov    %eax,%ebx
  802630:	85 c0                	test   %eax,%eax
  802632:	78 52                	js     802686 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802634:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802649:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80264f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802652:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802657:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	89 04 24             	mov    %eax,(%esp)
  802664:	e8 87 ef ff ff       	call   8015f0 <fd2num>
  802669:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80266c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80266e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802671:	89 04 24             	mov    %eax,(%esp)
  802674:	e8 77 ef ff ff       	call   8015f0 <fd2num>
  802679:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80267c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80267f:	b8 00 00 00 00       	mov    $0x0,%eax
  802684:	eb 38                	jmp    8026be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802686:	89 74 24 04          	mov    %esi,0x4(%esp)
  80268a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802691:	e8 d4 e7 ff ff       	call   800e6a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802699:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a4:	e8 c1 e7 ff ff       	call   800e6a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b7:	e8 ae e7 ff ff       	call   800e6a <sys_page_unmap>
  8026bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8026be:	83 c4 30             	add    $0x30,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5d                   	pop    %ebp
  8026c4:	c3                   	ret    

008026c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
  8026c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	89 04 24             	mov    %eax,(%esp)
  8026d8:	e8 89 ef ff ff       	call   801666 <fd_lookup>
  8026dd:	89 c2                	mov    %eax,%edx
  8026df:	85 d2                	test   %edx,%edx
  8026e1:	78 15                	js     8026f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	89 04 24             	mov    %eax,(%esp)
  8026e9:	e8 12 ef ff ff       	call   801600 <fd2data>
	return _pipeisclosed(fd, p);
  8026ee:	89 c2                	mov    %eax,%edx
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	e8 0b fd ff ff       	call   802403 <_pipeisclosed>
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	56                   	push   %esi
  8026fe:	53                   	push   %ebx
  8026ff:	83 ec 10             	sub    $0x10,%esp
  802702:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802705:	85 f6                	test   %esi,%esi
  802707:	75 24                	jne    80272d <wait+0x33>
  802709:	c7 44 24 0c 87 34 80 	movl   $0x803487,0xc(%esp)
  802710:	00 
  802711:	c7 44 24 08 03 34 80 	movl   $0x803403,0x8(%esp)
  802718:	00 
  802719:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802720:	00 
  802721:	c7 04 24 92 34 80 00 	movl   $0x803492,(%esp)
  802728:	e8 51 db ff ff       	call   80027e <_panic>
	e = &envs[ENVX(envid)];
  80272d:	89 f0                	mov    %esi,%eax
  80272f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802734:	89 c2                	mov    %eax,%edx
  802736:	c1 e2 07             	shl    $0x7,%edx
  802739:	8d 9c 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802740:	eb 05                	jmp    802747 <wait+0x4d>
		sys_yield();
  802742:	e8 5d e6 ff ff       	call   800da4 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802747:	8b 43 48             	mov    0x48(%ebx),%eax
  80274a:	39 f0                	cmp    %esi,%eax
  80274c:	75 07                	jne    802755 <wait+0x5b>
  80274e:	8b 43 54             	mov    0x54(%ebx),%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	75 ed                	jne    802742 <wait+0x48>
		sys_yield();
}
  802755:	83 c4 10             	add    $0x10,%esp
  802758:	5b                   	pop    %ebx
  802759:	5e                   	pop    %esi
  80275a:	5d                   	pop    %ebp
  80275b:	c3                   	ret    
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    

0080276a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802770:	c7 44 24 04 9d 34 80 	movl   $0x80349d,0x4(%esp)
  802777:	00 
  802778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277b:	89 04 24             	mov    %eax,(%esp)
  80277e:	e8 24 e2 ff ff       	call   8009a7 <strcpy>
	return 0;
}
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	57                   	push   %edi
  80278e:	56                   	push   %esi
  80278f:	53                   	push   %ebx
  802790:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802796:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80279b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027a1:	eb 31                	jmp    8027d4 <devcons_write+0x4a>
		m = n - tot;
  8027a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8027a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8027a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027b7:	03 45 0c             	add    0xc(%ebp),%eax
  8027ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027be:	89 3c 24             	mov    %edi,(%esp)
  8027c1:	e8 7e e3 ff ff       	call   800b44 <memmove>
		sys_cputs(buf, m);
  8027c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027ca:	89 3c 24             	mov    %edi,(%esp)
  8027cd:	e8 24 e5 ff ff       	call   800cf6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027d2:	01 f3                	add    %esi,%ebx
  8027d4:	89 d8                	mov    %ebx,%eax
  8027d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8027d9:	72 c8                	jb     8027a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027e1:	5b                   	pop    %ebx
  8027e2:	5e                   	pop    %esi
  8027e3:	5f                   	pop    %edi
  8027e4:	5d                   	pop    %ebp
  8027e5:	c3                   	ret    

008027e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027e6:	55                   	push   %ebp
  8027e7:	89 e5                	mov    %esp,%ebp
  8027e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027f5:	75 07                	jne    8027fe <devcons_read+0x18>
  8027f7:	eb 2a                	jmp    802823 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027f9:	e8 a6 e5 ff ff       	call   800da4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027fe:	66 90                	xchg   %ax,%ax
  802800:	e8 0f e5 ff ff       	call   800d14 <sys_cgetc>
  802805:	85 c0                	test   %eax,%eax
  802807:	74 f0                	je     8027f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802809:	85 c0                	test   %eax,%eax
  80280b:	78 16                	js     802823 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80280d:	83 f8 04             	cmp    $0x4,%eax
  802810:	74 0c                	je     80281e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802812:	8b 55 0c             	mov    0xc(%ebp),%edx
  802815:	88 02                	mov    %al,(%edx)
	return 1;
  802817:	b8 01 00 00 00       	mov    $0x1,%eax
  80281c:	eb 05                	jmp    802823 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802831:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802838:	00 
  802839:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80283c:	89 04 24             	mov    %eax,(%esp)
  80283f:	e8 b2 e4 ff ff       	call   800cf6 <sys_cputs>
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <getchar>:

int
getchar(void)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80284c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802853:	00 
  802854:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802857:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802862:	e8 93 f0 ff ff       	call   8018fa <read>
	if (r < 0)
  802867:	85 c0                	test   %eax,%eax
  802869:	78 0f                	js     80287a <getchar+0x34>
		return r;
	if (r < 1)
  80286b:	85 c0                	test   %eax,%eax
  80286d:	7e 06                	jle    802875 <getchar+0x2f>
		return -E_EOF;
	return c;
  80286f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802873:	eb 05                	jmp    80287a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802875:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802882:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802885:	89 44 24 04          	mov    %eax,0x4(%esp)
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	89 04 24             	mov    %eax,(%esp)
  80288f:	e8 d2 ed ff ff       	call   801666 <fd_lookup>
  802894:	85 c0                	test   %eax,%eax
  802896:	78 11                	js     8028a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028a1:	39 10                	cmp    %edx,(%eax)
  8028a3:	0f 94 c0             	sete   %al
  8028a6:	0f b6 c0             	movzbl %al,%eax
}
  8028a9:	c9                   	leave  
  8028aa:	c3                   	ret    

008028ab <opencons>:

int
opencons(void)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028b4:	89 04 24             	mov    %eax,(%esp)
  8028b7:	e8 5b ed ff ff       	call   801617 <fd_alloc>
		return r;
  8028bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	78 40                	js     802902 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028c9:	00 
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d8:	e8 e6 e4 ff ff       	call   800dc3 <sys_page_alloc>
		return r;
  8028dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	78 1f                	js     802902 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028e3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028f8:	89 04 24             	mov    %eax,(%esp)
  8028fb:	e8 f0 ec ff ff       	call   8015f0 <fd2num>
  802900:	89 c2                	mov    %eax,%edx
}
  802902:	89 d0                	mov    %edx,%eax
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80290c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802913:	75 70                	jne    802985 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  802915:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  80291c:	00 
  80291d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802924:	ee 
  802925:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80292c:	e8 92 e4 ff ff       	call   800dc3 <sys_page_alloc>
		if (error < 0)
  802931:	85 c0                	test   %eax,%eax
  802933:	79 1c                	jns    802951 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  802935:	c7 44 24 08 ac 34 80 	movl   $0x8034ac,0x8(%esp)
  80293c:	00 
  80293d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802944:	00 
  802945:	c7 04 24 ff 34 80 00 	movl   $0x8034ff,(%esp)
  80294c:	e8 2d d9 ff ff       	call   80027e <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802951:	c7 44 24 04 8f 29 80 	movl   $0x80298f,0x4(%esp)
  802958:	00 
  802959:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802960:	e8 fe e5 ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
		if (error < 0)
  802965:	85 c0                	test   %eax,%eax
  802967:	79 1c                	jns    802985 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  802969:	c7 44 24 08 d4 34 80 	movl   $0x8034d4,0x8(%esp)
  802970:	00 
  802971:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802978:	00 
  802979:	c7 04 24 ff 34 80 00 	movl   $0x8034ff,(%esp)
  802980:	e8 f9 d8 ff ff       	call   80027e <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80298d:	c9                   	leave  
  80298e:	c3                   	ret    

0080298f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80298f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802990:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802995:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802997:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  80299a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  80299e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  8029a3:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  8029a7:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  8029a9:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8029ac:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029ad:	83 c4 04             	add    $0x4,%esp
	popfl
  8029b0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029b1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8029b2:	c3                   	ret    
  8029b3:	66 90                	xchg   %ax,%ax
  8029b5:	66 90                	xchg   %ax,%ax
  8029b7:	66 90                	xchg   %ax,%ax
  8029b9:	66 90                	xchg   %ax,%ax
  8029bb:	66 90                	xchg   %ax,%ax
  8029bd:	66 90                	xchg   %ax,%ax
  8029bf:	90                   	nop

008029c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
  8029c3:	56                   	push   %esi
  8029c4:	53                   	push   %ebx
  8029c5:	83 ec 10             	sub    $0x10,%esp
  8029c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8029cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8029d1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8029d3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029d8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8029db:	89 04 24             	mov    %eax,(%esp)
  8029de:	e8 f6 e5 ff ff       	call   800fd9 <sys_ipc_recv>
  8029e3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8029e5:	85 d2                	test   %edx,%edx
  8029e7:	75 24                	jne    802a0d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8029e9:	85 f6                	test   %esi,%esi
  8029eb:	74 0a                	je     8029f7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8029ed:	a1 20 54 80 00       	mov    0x805420,%eax
  8029f2:	8b 40 74             	mov    0x74(%eax),%eax
  8029f5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8029f7:	85 db                	test   %ebx,%ebx
  8029f9:	74 0a                	je     802a05 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8029fb:	a1 20 54 80 00       	mov    0x805420,%eax
  802a00:	8b 40 78             	mov    0x78(%eax),%eax
  802a03:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802a05:	a1 20 54 80 00       	mov    0x805420,%eax
  802a0a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  802a0d:	83 c4 10             	add    $0x10,%esp
  802a10:	5b                   	pop    %ebx
  802a11:	5e                   	pop    %esi
  802a12:	5d                   	pop    %ebp
  802a13:	c3                   	ret    

00802a14 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
  802a17:	57                   	push   %edi
  802a18:	56                   	push   %esi
  802a19:	53                   	push   %ebx
  802a1a:	83 ec 1c             	sub    $0x1c,%esp
  802a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a20:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802a26:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802a28:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a2d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802a30:	8b 45 14             	mov    0x14(%ebp),%eax
  802a33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a3b:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a3f:	89 3c 24             	mov    %edi,(%esp)
  802a42:	e8 6f e5 ff ff       	call   800fb6 <sys_ipc_try_send>

		if (ret == 0)
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 2c                	je     802a77 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  802a4b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a4e:	74 20                	je     802a70 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802a50:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a54:	c7 44 24 08 10 35 80 	movl   $0x803510,0x8(%esp)
  802a5b:	00 
  802a5c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802a63:	00 
  802a64:	c7 04 24 40 35 80 00 	movl   $0x803540,(%esp)
  802a6b:	e8 0e d8 ff ff       	call   80027e <_panic>
		}

		sys_yield();
  802a70:	e8 2f e3 ff ff       	call   800da4 <sys_yield>
	}
  802a75:	eb b9                	jmp    802a30 <ipc_send+0x1c>
}
  802a77:	83 c4 1c             	add    $0x1c,%esp
  802a7a:	5b                   	pop    %ebx
  802a7b:	5e                   	pop    %esi
  802a7c:	5f                   	pop    %edi
  802a7d:	5d                   	pop    %ebp
  802a7e:	c3                   	ret    

00802a7f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a7f:	55                   	push   %ebp
  802a80:	89 e5                	mov    %esp,%ebp
  802a82:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a8a:	89 c2                	mov    %eax,%edx
  802a8c:	c1 e2 07             	shl    $0x7,%edx
  802a8f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802a96:	8b 52 50             	mov    0x50(%edx),%edx
  802a99:	39 ca                	cmp    %ecx,%edx
  802a9b:	75 11                	jne    802aae <ipc_find_env+0x2f>
			return envs[i].env_id;
  802a9d:	89 c2                	mov    %eax,%edx
  802a9f:	c1 e2 07             	shl    $0x7,%edx
  802aa2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802aa9:	8b 40 40             	mov    0x40(%eax),%eax
  802aac:	eb 0e                	jmp    802abc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802aae:	83 c0 01             	add    $0x1,%eax
  802ab1:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ab6:	75 d2                	jne    802a8a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802ab8:	66 b8 00 00          	mov    $0x0,%ax
}
  802abc:	5d                   	pop    %ebp
  802abd:	c3                   	ret    

00802abe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802abe:	55                   	push   %ebp
  802abf:	89 e5                	mov    %esp,%ebp
  802ac1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ac4:	89 d0                	mov    %edx,%eax
  802ac6:	c1 e8 16             	shr    $0x16,%eax
  802ac9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ad0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ad5:	f6 c1 01             	test   $0x1,%cl
  802ad8:	74 1d                	je     802af7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802ada:	c1 ea 0c             	shr    $0xc,%edx
  802add:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802ae4:	f6 c2 01             	test   $0x1,%dl
  802ae7:	74 0e                	je     802af7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ae9:	c1 ea 0c             	shr    $0xc,%edx
  802aec:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802af3:	ef 
  802af4:	0f b7 c0             	movzwl %ax,%eax
}
  802af7:	5d                   	pop    %ebp
  802af8:	c3                   	ret    
  802af9:	66 90                	xchg   %ax,%ax
  802afb:	66 90                	xchg   %ax,%ax
  802afd:	66 90                	xchg   %ax,%ax
  802aff:	90                   	nop

00802b00 <__udivdi3>:
  802b00:	55                   	push   %ebp
  802b01:	57                   	push   %edi
  802b02:	56                   	push   %esi
  802b03:	83 ec 0c             	sub    $0xc,%esp
  802b06:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b0a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b0e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b12:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b16:	85 c0                	test   %eax,%eax
  802b18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b1c:	89 ea                	mov    %ebp,%edx
  802b1e:	89 0c 24             	mov    %ecx,(%esp)
  802b21:	75 2d                	jne    802b50 <__udivdi3+0x50>
  802b23:	39 e9                	cmp    %ebp,%ecx
  802b25:	77 61                	ja     802b88 <__udivdi3+0x88>
  802b27:	85 c9                	test   %ecx,%ecx
  802b29:	89 ce                	mov    %ecx,%esi
  802b2b:	75 0b                	jne    802b38 <__udivdi3+0x38>
  802b2d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b32:	31 d2                	xor    %edx,%edx
  802b34:	f7 f1                	div    %ecx
  802b36:	89 c6                	mov    %eax,%esi
  802b38:	31 d2                	xor    %edx,%edx
  802b3a:	89 e8                	mov    %ebp,%eax
  802b3c:	f7 f6                	div    %esi
  802b3e:	89 c5                	mov    %eax,%ebp
  802b40:	89 f8                	mov    %edi,%eax
  802b42:	f7 f6                	div    %esi
  802b44:	89 ea                	mov    %ebp,%edx
  802b46:	83 c4 0c             	add    $0xc,%esp
  802b49:	5e                   	pop    %esi
  802b4a:	5f                   	pop    %edi
  802b4b:	5d                   	pop    %ebp
  802b4c:	c3                   	ret    
  802b4d:	8d 76 00             	lea    0x0(%esi),%esi
  802b50:	39 e8                	cmp    %ebp,%eax
  802b52:	77 24                	ja     802b78 <__udivdi3+0x78>
  802b54:	0f bd e8             	bsr    %eax,%ebp
  802b57:	83 f5 1f             	xor    $0x1f,%ebp
  802b5a:	75 3c                	jne    802b98 <__udivdi3+0x98>
  802b5c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802b60:	39 34 24             	cmp    %esi,(%esp)
  802b63:	0f 86 9f 00 00 00    	jbe    802c08 <__udivdi3+0x108>
  802b69:	39 d0                	cmp    %edx,%eax
  802b6b:	0f 82 97 00 00 00    	jb     802c08 <__udivdi3+0x108>
  802b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b78:	31 d2                	xor    %edx,%edx
  802b7a:	31 c0                	xor    %eax,%eax
  802b7c:	83 c4 0c             	add    $0xc,%esp
  802b7f:	5e                   	pop    %esi
  802b80:	5f                   	pop    %edi
  802b81:	5d                   	pop    %ebp
  802b82:	c3                   	ret    
  802b83:	90                   	nop
  802b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b88:	89 f8                	mov    %edi,%eax
  802b8a:	f7 f1                	div    %ecx
  802b8c:	31 d2                	xor    %edx,%edx
  802b8e:	83 c4 0c             	add    $0xc,%esp
  802b91:	5e                   	pop    %esi
  802b92:	5f                   	pop    %edi
  802b93:	5d                   	pop    %ebp
  802b94:	c3                   	ret    
  802b95:	8d 76 00             	lea    0x0(%esi),%esi
  802b98:	89 e9                	mov    %ebp,%ecx
  802b9a:	8b 3c 24             	mov    (%esp),%edi
  802b9d:	d3 e0                	shl    %cl,%eax
  802b9f:	89 c6                	mov    %eax,%esi
  802ba1:	b8 20 00 00 00       	mov    $0x20,%eax
  802ba6:	29 e8                	sub    %ebp,%eax
  802ba8:	89 c1                	mov    %eax,%ecx
  802baa:	d3 ef                	shr    %cl,%edi
  802bac:	89 e9                	mov    %ebp,%ecx
  802bae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802bb2:	8b 3c 24             	mov    (%esp),%edi
  802bb5:	09 74 24 08          	or     %esi,0x8(%esp)
  802bb9:	89 d6                	mov    %edx,%esi
  802bbb:	d3 e7                	shl    %cl,%edi
  802bbd:	89 c1                	mov    %eax,%ecx
  802bbf:	89 3c 24             	mov    %edi,(%esp)
  802bc2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802bc6:	d3 ee                	shr    %cl,%esi
  802bc8:	89 e9                	mov    %ebp,%ecx
  802bca:	d3 e2                	shl    %cl,%edx
  802bcc:	89 c1                	mov    %eax,%ecx
  802bce:	d3 ef                	shr    %cl,%edi
  802bd0:	09 d7                	or     %edx,%edi
  802bd2:	89 f2                	mov    %esi,%edx
  802bd4:	89 f8                	mov    %edi,%eax
  802bd6:	f7 74 24 08          	divl   0x8(%esp)
  802bda:	89 d6                	mov    %edx,%esi
  802bdc:	89 c7                	mov    %eax,%edi
  802bde:	f7 24 24             	mull   (%esp)
  802be1:	39 d6                	cmp    %edx,%esi
  802be3:	89 14 24             	mov    %edx,(%esp)
  802be6:	72 30                	jb     802c18 <__udivdi3+0x118>
  802be8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bec:	89 e9                	mov    %ebp,%ecx
  802bee:	d3 e2                	shl    %cl,%edx
  802bf0:	39 c2                	cmp    %eax,%edx
  802bf2:	73 05                	jae    802bf9 <__udivdi3+0xf9>
  802bf4:	3b 34 24             	cmp    (%esp),%esi
  802bf7:	74 1f                	je     802c18 <__udivdi3+0x118>
  802bf9:	89 f8                	mov    %edi,%eax
  802bfb:	31 d2                	xor    %edx,%edx
  802bfd:	e9 7a ff ff ff       	jmp    802b7c <__udivdi3+0x7c>
  802c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c08:	31 d2                	xor    %edx,%edx
  802c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c0f:	e9 68 ff ff ff       	jmp    802b7c <__udivdi3+0x7c>
  802c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c18:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c1b:	31 d2                	xor    %edx,%edx
  802c1d:	83 c4 0c             	add    $0xc,%esp
  802c20:	5e                   	pop    %esi
  802c21:	5f                   	pop    %edi
  802c22:	5d                   	pop    %ebp
  802c23:	c3                   	ret    
  802c24:	66 90                	xchg   %ax,%ax
  802c26:	66 90                	xchg   %ax,%ax
  802c28:	66 90                	xchg   %ax,%ax
  802c2a:	66 90                	xchg   %ax,%ax
  802c2c:	66 90                	xchg   %ax,%ax
  802c2e:	66 90                	xchg   %ax,%ax

00802c30 <__umoddi3>:
  802c30:	55                   	push   %ebp
  802c31:	57                   	push   %edi
  802c32:	56                   	push   %esi
  802c33:	83 ec 14             	sub    $0x14,%esp
  802c36:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c3a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c3e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c42:	89 c7                	mov    %eax,%edi
  802c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c48:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c50:	89 34 24             	mov    %esi,(%esp)
  802c53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c57:	85 c0                	test   %eax,%eax
  802c59:	89 c2                	mov    %eax,%edx
  802c5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c5f:	75 17                	jne    802c78 <__umoddi3+0x48>
  802c61:	39 fe                	cmp    %edi,%esi
  802c63:	76 4b                	jbe    802cb0 <__umoddi3+0x80>
  802c65:	89 c8                	mov    %ecx,%eax
  802c67:	89 fa                	mov    %edi,%edx
  802c69:	f7 f6                	div    %esi
  802c6b:	89 d0                	mov    %edx,%eax
  802c6d:	31 d2                	xor    %edx,%edx
  802c6f:	83 c4 14             	add    $0x14,%esp
  802c72:	5e                   	pop    %esi
  802c73:	5f                   	pop    %edi
  802c74:	5d                   	pop    %ebp
  802c75:	c3                   	ret    
  802c76:	66 90                	xchg   %ax,%ax
  802c78:	39 f8                	cmp    %edi,%eax
  802c7a:	77 54                	ja     802cd0 <__umoddi3+0xa0>
  802c7c:	0f bd e8             	bsr    %eax,%ebp
  802c7f:	83 f5 1f             	xor    $0x1f,%ebp
  802c82:	75 5c                	jne    802ce0 <__umoddi3+0xb0>
  802c84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c88:	39 3c 24             	cmp    %edi,(%esp)
  802c8b:	0f 87 e7 00 00 00    	ja     802d78 <__umoddi3+0x148>
  802c91:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c95:	29 f1                	sub    %esi,%ecx
  802c97:	19 c7                	sbb    %eax,%edi
  802c99:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ca1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ca5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ca9:	83 c4 14             	add    $0x14,%esp
  802cac:	5e                   	pop    %esi
  802cad:	5f                   	pop    %edi
  802cae:	5d                   	pop    %ebp
  802caf:	c3                   	ret    
  802cb0:	85 f6                	test   %esi,%esi
  802cb2:	89 f5                	mov    %esi,%ebp
  802cb4:	75 0b                	jne    802cc1 <__umoddi3+0x91>
  802cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802cbb:	31 d2                	xor    %edx,%edx
  802cbd:	f7 f6                	div    %esi
  802cbf:	89 c5                	mov    %eax,%ebp
  802cc1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802cc5:	31 d2                	xor    %edx,%edx
  802cc7:	f7 f5                	div    %ebp
  802cc9:	89 c8                	mov    %ecx,%eax
  802ccb:	f7 f5                	div    %ebp
  802ccd:	eb 9c                	jmp    802c6b <__umoddi3+0x3b>
  802ccf:	90                   	nop
  802cd0:	89 c8                	mov    %ecx,%eax
  802cd2:	89 fa                	mov    %edi,%edx
  802cd4:	83 c4 14             	add    $0x14,%esp
  802cd7:	5e                   	pop    %esi
  802cd8:	5f                   	pop    %edi
  802cd9:	5d                   	pop    %ebp
  802cda:	c3                   	ret    
  802cdb:	90                   	nop
  802cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ce0:	8b 04 24             	mov    (%esp),%eax
  802ce3:	be 20 00 00 00       	mov    $0x20,%esi
  802ce8:	89 e9                	mov    %ebp,%ecx
  802cea:	29 ee                	sub    %ebp,%esi
  802cec:	d3 e2                	shl    %cl,%edx
  802cee:	89 f1                	mov    %esi,%ecx
  802cf0:	d3 e8                	shr    %cl,%eax
  802cf2:	89 e9                	mov    %ebp,%ecx
  802cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cf8:	8b 04 24             	mov    (%esp),%eax
  802cfb:	09 54 24 04          	or     %edx,0x4(%esp)
  802cff:	89 fa                	mov    %edi,%edx
  802d01:	d3 e0                	shl    %cl,%eax
  802d03:	89 f1                	mov    %esi,%ecx
  802d05:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d09:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d0d:	d3 ea                	shr    %cl,%edx
  802d0f:	89 e9                	mov    %ebp,%ecx
  802d11:	d3 e7                	shl    %cl,%edi
  802d13:	89 f1                	mov    %esi,%ecx
  802d15:	d3 e8                	shr    %cl,%eax
  802d17:	89 e9                	mov    %ebp,%ecx
  802d19:	09 f8                	or     %edi,%eax
  802d1b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d1f:	f7 74 24 04          	divl   0x4(%esp)
  802d23:	d3 e7                	shl    %cl,%edi
  802d25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d29:	89 d7                	mov    %edx,%edi
  802d2b:	f7 64 24 08          	mull   0x8(%esp)
  802d2f:	39 d7                	cmp    %edx,%edi
  802d31:	89 c1                	mov    %eax,%ecx
  802d33:	89 14 24             	mov    %edx,(%esp)
  802d36:	72 2c                	jb     802d64 <__umoddi3+0x134>
  802d38:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d3c:	72 22                	jb     802d60 <__umoddi3+0x130>
  802d3e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d42:	29 c8                	sub    %ecx,%eax
  802d44:	19 d7                	sbb    %edx,%edi
  802d46:	89 e9                	mov    %ebp,%ecx
  802d48:	89 fa                	mov    %edi,%edx
  802d4a:	d3 e8                	shr    %cl,%eax
  802d4c:	89 f1                	mov    %esi,%ecx
  802d4e:	d3 e2                	shl    %cl,%edx
  802d50:	89 e9                	mov    %ebp,%ecx
  802d52:	d3 ef                	shr    %cl,%edi
  802d54:	09 d0                	or     %edx,%eax
  802d56:	89 fa                	mov    %edi,%edx
  802d58:	83 c4 14             	add    $0x14,%esp
  802d5b:	5e                   	pop    %esi
  802d5c:	5f                   	pop    %edi
  802d5d:	5d                   	pop    %ebp
  802d5e:	c3                   	ret    
  802d5f:	90                   	nop
  802d60:	39 d7                	cmp    %edx,%edi
  802d62:	75 da                	jne    802d3e <__umoddi3+0x10e>
  802d64:	8b 14 24             	mov    (%esp),%edx
  802d67:	89 c1                	mov    %eax,%ecx
  802d69:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802d6d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d71:	eb cb                	jmp    802d3e <__umoddi3+0x10e>
  802d73:	90                   	nop
  802d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d78:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d7c:	0f 82 0f ff ff ff    	jb     802c91 <__umoddi3+0x61>
  802d82:	e9 1a ff ff ff       	jmp    802ca1 <__umoddi3+0x71>
