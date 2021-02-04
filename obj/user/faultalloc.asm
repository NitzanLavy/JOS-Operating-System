
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800043:	c7 04 24 00 28 80 00 	movl   $0x802800,(%esp)
  80004a:	e8 03 02 00 00       	call   800252 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 25 0c 00 00       	call   800c93 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 20 28 80 	movl   $0x802820,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 0a 28 80 00 	movl   $0x80280a,(%esp)
  800091:	e8 c3 00 00 00       	call   800159 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 4c 28 80 	movl   $0x80284c,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 58 07 00 00       	call   80080a <snprintf>
}
  8000b2:	83 c4 24             	add    $0x24,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  8000be:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000c5:	e8 ee 0f 00 00       	call   8010b8 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000ca:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  8000d1:	de 
  8000d2:	c7 04 24 1c 28 80 00 	movl   $0x80281c,(%esp)
  8000d9:	e8 74 01 00 00       	call   800252 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000de:	c7 44 24 04 fe bf fe 	movl   $0xcafebffe,0x4(%esp)
  8000e5:	ca 
  8000e6:	c7 04 24 1c 28 80 00 	movl   $0x80281c,(%esp)
  8000ed:	e8 60 01 00 00       	call   800252 <cprintf>
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 10             	sub    $0x10,%esp
  8000fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800102:	e8 4e 0b 00 00       	call   800c55 <sys_getenvid>
  800107:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010c:	89 c2                	mov    %eax,%edx
  80010e:	c1 e2 07             	shl    $0x7,%edx
  800111:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800118:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011d:	85 db                	test   %ebx,%ebx
  80011f:	7e 07                	jle    800128 <libmain+0x34>
		binaryname = argv[0];
  800121:	8b 06                	mov    (%esi),%eax
  800123:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800128:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012c:	89 1c 24             	mov    %ebx,(%esp)
  80012f:	e8 84 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800134:	e8 07 00 00 00       	call   800140 <exit>
}
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	5b                   	pop    %ebx
  80013d:	5e                   	pop    %esi
  80013e:	5d                   	pop    %ebp
  80013f:	c3                   	ret    

00800140 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800146:	e8 ff 11 00 00       	call   80134a <close_all>
	sys_env_destroy(0);
  80014b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800152:	e8 ac 0a 00 00       	call   800c03 <sys_env_destroy>
}
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	56                   	push   %esi
  80015d:	53                   	push   %ebx
  80015e:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800161:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800164:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80016a:	e8 e6 0a 00 00       	call   800c55 <sys_getenvid>
  80016f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800172:	89 54 24 10          	mov    %edx,0x10(%esp)
  800176:	8b 55 08             	mov    0x8(%ebp),%edx
  800179:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80017d:	89 74 24 08          	mov    %esi,0x8(%esp)
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 78 28 80 00 	movl   $0x802878,(%esp)
  80018c:	e8 c1 00 00 00       	call   800252 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800191:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800195:	8b 45 10             	mov    0x10(%ebp),%eax
  800198:	89 04 24             	mov    %eax,(%esp)
  80019b:	e8 51 00 00 00       	call   8001f1 <vcprintf>
	cprintf("\n");
  8001a0:	c7 04 24 90 2d 80 00 	movl   $0x802d90,(%esp)
  8001a7:	e8 a6 00 00 00       	call   800252 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ac:	cc                   	int3   
  8001ad:	eb fd                	jmp    8001ac <_panic+0x53>

008001af <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 14             	sub    $0x14,%esp
  8001b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b9:	8b 13                	mov    (%ebx),%edx
  8001bb:	8d 42 01             	lea    0x1(%edx),%eax
  8001be:	89 03                	mov    %eax,(%ebx)
  8001c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cc:	75 19                	jne    8001e7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ce:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001d5:	00 
  8001d6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d9:	89 04 24             	mov    %eax,(%esp)
  8001dc:	e8 e5 09 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  8001e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001e7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001eb:	83 c4 14             	add    $0x14,%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5d                   	pop    %ebp
  8001f0:	c3                   	ret    

008001f1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001fa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800201:	00 00 00 
	b.cnt = 0;
  800204:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80020e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800211:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800215:	8b 45 08             	mov    0x8(%ebp),%eax
  800218:	89 44 24 08          	mov    %eax,0x8(%esp)
  80021c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800222:	89 44 24 04          	mov    %eax,0x4(%esp)
  800226:	c7 04 24 af 01 80 00 	movl   $0x8001af,(%esp)
  80022d:	e8 ac 01 00 00       	call   8003de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800232:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800238:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800242:	89 04 24             	mov    %eax,(%esp)
  800245:	e8 7c 09 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  80024a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800258:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80025b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025f:	8b 45 08             	mov    0x8(%ebp),%eax
  800262:	89 04 24             	mov    %eax,(%esp)
  800265:	e8 87 ff ff ff       	call   8001f1 <vcprintf>
	va_end(ap);

	return cnt;
}
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    
  80026c:	66 90                	xchg   %ax,%ax
  80026e:	66 90                	xchg   %ax,%ax

00800270 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d7                	mov    %edx,%edi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 c3                	mov    %eax,%ebx
  800289:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80028c:	8b 45 10             	mov    0x10(%ebp),%eax
  80028f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800292:	b9 00 00 00 00       	mov    $0x0,%ecx
  800297:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80029d:	39 d9                	cmp    %ebx,%ecx
  80029f:	72 05                	jb     8002a6 <printnum+0x36>
  8002a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a4:	77 69                	ja     80030f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002ad:	83 ee 01             	sub    $0x1,%esi
  8002b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002c0:	89 c3                	mov    %eax,%ebx
  8002c2:	89 d6                	mov    %edx,%esi
  8002c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	e8 8c 22 00 00       	call   802570 <__udivdi3>
  8002e4:	89 d9                	mov    %ebx,%ecx
  8002e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002f5:	89 fa                	mov    %edi,%edx
  8002f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fa:	e8 71 ff ff ff       	call   800270 <printnum>
  8002ff:	eb 1b                	jmp    80031c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800301:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800305:	8b 45 18             	mov    0x18(%ebp),%eax
  800308:	89 04 24             	mov    %eax,(%esp)
  80030b:	ff d3                	call   *%ebx
  80030d:	eb 03                	jmp    800312 <printnum+0xa2>
  80030f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800312:	83 ee 01             	sub    $0x1,%esi
  800315:	85 f6                	test   %esi,%esi
  800317:	7f e8                	jg     800301 <printnum+0x91>
  800319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800320:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800324:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800327:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80032a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 5c 23 00 00       	call   8026a0 <__umoddi3>
  800344:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800348:	0f be 80 9b 28 80 00 	movsbl 0x80289b(%eax),%eax
  80034f:	89 04 24             	mov    %eax,(%esp)
  800352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800355:	ff d0                	call   *%eax
}
  800357:	83 c4 3c             	add    $0x3c,%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800362:	83 fa 01             	cmp    $0x1,%edx
  800365:	7e 0e                	jle    800375 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8d 4a 08             	lea    0x8(%edx),%ecx
  80036c:	89 08                	mov    %ecx,(%eax)
  80036e:	8b 02                	mov    (%edx),%eax
  800370:	8b 52 04             	mov    0x4(%edx),%edx
  800373:	eb 22                	jmp    800397 <getuint+0x38>
	else if (lflag)
  800375:	85 d2                	test   %edx,%edx
  800377:	74 10                	je     800389 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
  800387:	eb 0e                	jmp    800397 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038e:	89 08                	mov    %ecx,(%eax)
  800390:	8b 02                	mov    (%edx),%eax
  800392:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a3:	8b 10                	mov    (%eax),%edx
  8003a5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a8:	73 0a                	jae    8003b4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ad:	89 08                	mov    %ecx,(%eax)
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	88 02                	mov    %al,(%edx)
}
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003bc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	89 04 24             	mov    %eax,(%esp)
  8003d7:	e8 02 00 00 00       	call   8003de <vprintfmt>
	va_end(ap);
}
  8003dc:	c9                   	leave  
  8003dd:	c3                   	ret    

008003de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003de:	55                   	push   %ebp
  8003df:	89 e5                	mov    %esp,%ebp
  8003e1:	57                   	push   %edi
  8003e2:	56                   	push   %esi
  8003e3:	53                   	push   %ebx
  8003e4:	83 ec 3c             	sub    $0x3c,%esp
  8003e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003ed:	eb 14                	jmp    800403 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ef:	85 c0                	test   %eax,%eax
  8003f1:	0f 84 b3 03 00 00    	je     8007aa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003fb:	89 04 24             	mov    %eax,(%esp)
  8003fe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800401:	89 f3                	mov    %esi,%ebx
  800403:	8d 73 01             	lea    0x1(%ebx),%esi
  800406:	0f b6 03             	movzbl (%ebx),%eax
  800409:	83 f8 25             	cmp    $0x25,%eax
  80040c:	75 e1                	jne    8003ef <vprintfmt+0x11>
  80040e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800412:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800419:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800420:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800427:	ba 00 00 00 00       	mov    $0x0,%edx
  80042c:	eb 1d                	jmp    80044b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800430:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800434:	eb 15                	jmp    80044b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800436:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800438:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80043c:	eb 0d                	jmp    80044b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80043e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800441:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800444:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80044e:	0f b6 0e             	movzbl (%esi),%ecx
  800451:	0f b6 c1             	movzbl %cl,%eax
  800454:	83 e9 23             	sub    $0x23,%ecx
  800457:	80 f9 55             	cmp    $0x55,%cl
  80045a:	0f 87 2a 03 00 00    	ja     80078a <vprintfmt+0x3ac>
  800460:	0f b6 c9             	movzbl %cl,%ecx
  800463:	ff 24 8d 20 2a 80 00 	jmp    *0x802a20(,%ecx,4)
  80046a:	89 de                	mov    %ebx,%esi
  80046c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800471:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800474:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800478:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80047b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80047e:	83 fb 09             	cmp    $0x9,%ebx
  800481:	77 36                	ja     8004b9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800483:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800486:	eb e9                	jmp    800471 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8d 48 04             	lea    0x4(%eax),%ecx
  80048e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800491:	8b 00                	mov    (%eax),%eax
  800493:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800496:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800498:	eb 22                	jmp    8004bc <vprintfmt+0xde>
  80049a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80049d:	85 c9                	test   %ecx,%ecx
  80049f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a4:	0f 49 c1             	cmovns %ecx,%eax
  8004a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004aa:	89 de                	mov    %ebx,%esi
  8004ac:	eb 9d                	jmp    80044b <vprintfmt+0x6d>
  8004ae:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004b0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004b7:	eb 92                	jmp    80044b <vprintfmt+0x6d>
  8004b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004c0:	79 89                	jns    80044b <vprintfmt+0x6d>
  8004c2:	e9 77 ff ff ff       	jmp    80043e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004c7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004cc:	e9 7a ff ff ff       	jmp    80044b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d4:	8d 50 04             	lea    0x4(%eax),%edx
  8004d7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	89 04 24             	mov    %eax,(%esp)
  8004e3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004e6:	e9 18 ff ff ff       	jmp    800403 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8d 50 04             	lea    0x4(%eax),%edx
  8004f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	99                   	cltd   
  8004f7:	31 d0                	xor    %edx,%eax
  8004f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004fb:	83 f8 12             	cmp    $0x12,%eax
  8004fe:	7f 0b                	jg     80050b <vprintfmt+0x12d>
  800500:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  800507:	85 d2                	test   %edx,%edx
  800509:	75 20                	jne    80052b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80050b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80050f:	c7 44 24 08 b3 28 80 	movl   $0x8028b3,0x8(%esp)
  800516:	00 
  800517:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	e8 90 fe ff ff       	call   8003b6 <printfmt>
  800526:	e9 d8 fe ff ff       	jmp    800403 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80052b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80052f:	c7 44 24 08 25 2d 80 	movl   $0x802d25,0x8(%esp)
  800536:	00 
  800537:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	e8 70 fe ff ff       	call   8003b6 <printfmt>
  800546:	e9 b8 fe ff ff       	jmp    800403 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80054e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800551:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8d 50 04             	lea    0x4(%eax),%edx
  80055a:	89 55 14             	mov    %edx,0x14(%ebp)
  80055d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80055f:	85 f6                	test   %esi,%esi
  800561:	b8 ac 28 80 00       	mov    $0x8028ac,%eax
  800566:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800569:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80056d:	0f 84 97 00 00 00    	je     80060a <vprintfmt+0x22c>
  800573:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800577:	0f 8e 9b 00 00 00    	jle    800618 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800581:	89 34 24             	mov    %esi,(%esp)
  800584:	e8 cf 02 00 00       	call   800858 <strnlen>
  800589:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80058c:	29 c2                	sub    %eax,%edx
  80058e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800591:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800595:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800598:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80059b:	8b 75 08             	mov    0x8(%ebp),%esi
  80059e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005a1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a3:	eb 0f                	jmp    8005b4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ac:	89 04 24             	mov    %eax,(%esp)
  8005af:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	83 eb 01             	sub    $0x1,%ebx
  8005b4:	85 db                	test   %ebx,%ebx
  8005b6:	7f ed                	jg     8005a5 <vprintfmt+0x1c7>
  8005b8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005be:	85 d2                	test   %edx,%edx
  8005c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c5:	0f 49 c2             	cmovns %edx,%eax
  8005c8:	29 c2                	sub    %eax,%edx
  8005ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005cd:	89 d7                	mov    %edx,%edi
  8005cf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005d2:	eb 50                	jmp    800624 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d8:	74 1e                	je     8005f8 <vprintfmt+0x21a>
  8005da:	0f be d2             	movsbl %dl,%edx
  8005dd:	83 ea 20             	sub    $0x20,%edx
  8005e0:	83 fa 5e             	cmp    $0x5e,%edx
  8005e3:	76 13                	jbe    8005f8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005f3:	ff 55 08             	call   *0x8(%ebp)
  8005f6:	eb 0d                	jmp    800605 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ff:	89 04 24             	mov    %eax,(%esp)
  800602:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800605:	83 ef 01             	sub    $0x1,%edi
  800608:	eb 1a                	jmp    800624 <vprintfmt+0x246>
  80060a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80060d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800610:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800613:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800616:	eb 0c                	jmp    800624 <vprintfmt+0x246>
  800618:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80061e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800621:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800624:	83 c6 01             	add    $0x1,%esi
  800627:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80062b:	0f be c2             	movsbl %dl,%eax
  80062e:	85 c0                	test   %eax,%eax
  800630:	74 27                	je     800659 <vprintfmt+0x27b>
  800632:	85 db                	test   %ebx,%ebx
  800634:	78 9e                	js     8005d4 <vprintfmt+0x1f6>
  800636:	83 eb 01             	sub    $0x1,%ebx
  800639:	79 99                	jns    8005d4 <vprintfmt+0x1f6>
  80063b:	89 f8                	mov    %edi,%eax
  80063d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800640:	8b 75 08             	mov    0x8(%ebp),%esi
  800643:	89 c3                	mov    %eax,%ebx
  800645:	eb 1a                	jmp    800661 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800647:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800652:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800654:	83 eb 01             	sub    $0x1,%ebx
  800657:	eb 08                	jmp    800661 <vprintfmt+0x283>
  800659:	89 fb                	mov    %edi,%ebx
  80065b:	8b 75 08             	mov    0x8(%ebp),%esi
  80065e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800661:	85 db                	test   %ebx,%ebx
  800663:	7f e2                	jg     800647 <vprintfmt+0x269>
  800665:	89 75 08             	mov    %esi,0x8(%ebp)
  800668:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80066b:	e9 93 fd ff ff       	jmp    800403 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800670:	83 fa 01             	cmp    $0x1,%edx
  800673:	7e 16                	jle    80068b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 50 08             	lea    0x8(%eax),%edx
  80067b:	89 55 14             	mov    %edx,0x14(%ebp)
  80067e:	8b 50 04             	mov    0x4(%eax),%edx
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800686:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800689:	eb 32                	jmp    8006bd <vprintfmt+0x2df>
	else if (lflag)
  80068b:	85 d2                	test   %edx,%edx
  80068d:	74 18                	je     8006a7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 50 04             	lea    0x4(%eax),%edx
  800695:	89 55 14             	mov    %edx,0x14(%ebp)
  800698:	8b 30                	mov    (%eax),%esi
  80069a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80069d:	89 f0                	mov    %esi,%eax
  80069f:	c1 f8 1f             	sar    $0x1f,%eax
  8006a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a5:	eb 16                	jmp    8006bd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b0:	8b 30                	mov    (%eax),%esi
  8006b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006b5:	89 f0                	mov    %esi,%eax
  8006b7:	c1 f8 1f             	sar    $0x1f,%eax
  8006ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	0f 89 80 00 00 00    	jns    800752 <vprintfmt+0x374>
				putch('-', putdat);
  8006d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006dd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e6:	f7 d8                	neg    %eax
  8006e8:	83 d2 00             	adc    $0x0,%edx
  8006eb:	f7 da                	neg    %edx
			}
			base = 10;
  8006ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006f2:	eb 5e                	jmp    800752 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f7:	e8 63 fc ff ff       	call   80035f <getuint>
			base = 10;
  8006fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800701:	eb 4f                	jmp    800752 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800703:	8d 45 14             	lea    0x14(%ebp),%eax
  800706:	e8 54 fc ff ff       	call   80035f <getuint>
			base = 8;
  80070b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800710:	eb 40                	jmp    800752 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800712:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800716:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80071d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800720:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800724:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80072b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 50 04             	lea    0x4(%eax),%edx
  800734:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800737:	8b 00                	mov    (%eax),%eax
  800739:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80073e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800743:	eb 0d                	jmp    800752 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800745:	8d 45 14             	lea    0x14(%ebp),%eax
  800748:	e8 12 fc ff ff       	call   80035f <getuint>
			base = 16;
  80074d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800752:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800756:	89 74 24 10          	mov    %esi,0x10(%esp)
  80075a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80075d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800761:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800765:	89 04 24             	mov    %eax,(%esp)
  800768:	89 54 24 04          	mov    %edx,0x4(%esp)
  80076c:	89 fa                	mov    %edi,%edx
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	e8 fa fa ff ff       	call   800270 <printnum>
			break;
  800776:	e9 88 fc ff ff       	jmp    800403 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80077b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077f:	89 04 24             	mov    %eax,(%esp)
  800782:	ff 55 08             	call   *0x8(%ebp)
			break;
  800785:	e9 79 fc ff ff       	jmp    800403 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80078a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800795:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800798:	89 f3                	mov    %esi,%ebx
  80079a:	eb 03                	jmp    80079f <vprintfmt+0x3c1>
  80079c:	83 eb 01             	sub    $0x1,%ebx
  80079f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007a3:	75 f7                	jne    80079c <vprintfmt+0x3be>
  8007a5:	e9 59 fc ff ff       	jmp    800403 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007aa:	83 c4 3c             	add    $0x3c,%esp
  8007ad:	5b                   	pop    %ebx
  8007ae:	5e                   	pop    %esi
  8007af:	5f                   	pop    %edi
  8007b0:	5d                   	pop    %ebp
  8007b1:	c3                   	ret    

008007b2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	83 ec 28             	sub    $0x28,%esp
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	74 30                	je     800803 <vsnprintf+0x51>
  8007d3:	85 d2                	test   %edx,%edx
  8007d5:	7e 2c                	jle    800803 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ec:	c7 04 24 99 03 80 00 	movl   $0x800399,(%esp)
  8007f3:	e8 e6 fb ff ff       	call   8003de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800801:	eb 05                	jmp    800808 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800808:	c9                   	leave  
  800809:	c3                   	ret    

0080080a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800810:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800813:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800821:	89 44 24 04          	mov    %eax,0x4(%esp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	89 04 24             	mov    %eax,(%esp)
  80082b:	e8 82 ff ff ff       	call   8007b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800830:	c9                   	leave  
  800831:	c3                   	ret    
  800832:	66 90                	xchg   %ax,%ax
  800834:	66 90                	xchg   %ax,%ax
  800836:	66 90                	xchg   %ax,%ax
  800838:	66 90                	xchg   %ax,%ax
  80083a:	66 90                	xchg   %ax,%ax
  80083c:	66 90                	xchg   %ax,%ax
  80083e:	66 90                	xchg   %ax,%ax

00800840 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	eb 03                	jmp    800850 <strlen+0x10>
		n++;
  80084d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800850:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800854:	75 f7                	jne    80084d <strlen+0xd>
		n++;
	return n;
}
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800861:	b8 00 00 00 00       	mov    $0x0,%eax
  800866:	eb 03                	jmp    80086b <strnlen+0x13>
		n++;
  800868:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086b:	39 d0                	cmp    %edx,%eax
  80086d:	74 06                	je     800875 <strnlen+0x1d>
  80086f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800873:	75 f3                	jne    800868 <strnlen+0x10>
		n++;
	return n;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800881:	89 c2                	mov    %eax,%edx
  800883:	83 c2 01             	add    $0x1,%edx
  800886:	83 c1 01             	add    $0x1,%ecx
  800889:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80088d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800890:	84 db                	test   %bl,%bl
  800892:	75 ef                	jne    800883 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800894:	5b                   	pop    %ebx
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a1:	89 1c 24             	mov    %ebx,(%esp)
  8008a4:	e8 97 ff ff ff       	call   800840 <strlen>
	strcpy(dst + len, src);
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b0:	01 d8                	add    %ebx,%eax
  8008b2:	89 04 24             	mov    %eax,(%esp)
  8008b5:	e8 bd ff ff ff       	call   800877 <strcpy>
	return dst;
}
  8008ba:	89 d8                	mov    %ebx,%eax
  8008bc:	83 c4 08             	add    $0x8,%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	56                   	push   %esi
  8008c6:	53                   	push   %ebx
  8008c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cd:	89 f3                	mov    %esi,%ebx
  8008cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d2:	89 f2                	mov    %esi,%edx
  8008d4:	eb 0f                	jmp    8008e5 <strncpy+0x23>
		*dst++ = *src;
  8008d6:	83 c2 01             	add    $0x1,%edx
  8008d9:	0f b6 01             	movzbl (%ecx),%eax
  8008dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008df:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e5:	39 da                	cmp    %ebx,%edx
  8008e7:	75 ed                	jne    8008d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008e9:	89 f0                	mov    %esi,%eax
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	56                   	push   %esi
  8008f3:	53                   	push   %ebx
  8008f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008fd:	89 f0                	mov    %esi,%eax
  8008ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800903:	85 c9                	test   %ecx,%ecx
  800905:	75 0b                	jne    800912 <strlcpy+0x23>
  800907:	eb 1d                	jmp    800926 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	83 c2 01             	add    $0x1,%edx
  80090f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800912:	39 d8                	cmp    %ebx,%eax
  800914:	74 0b                	je     800921 <strlcpy+0x32>
  800916:	0f b6 0a             	movzbl (%edx),%ecx
  800919:	84 c9                	test   %cl,%cl
  80091b:	75 ec                	jne    800909 <strlcpy+0x1a>
  80091d:	89 c2                	mov    %eax,%edx
  80091f:	eb 02                	jmp    800923 <strlcpy+0x34>
  800921:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800923:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800926:	29 f0                	sub    %esi,%eax
}
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800935:	eb 06                	jmp    80093d <strcmp+0x11>
		p++, q++;
  800937:	83 c1 01             	add    $0x1,%ecx
  80093a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80093d:	0f b6 01             	movzbl (%ecx),%eax
  800940:	84 c0                	test   %al,%al
  800942:	74 04                	je     800948 <strcmp+0x1c>
  800944:	3a 02                	cmp    (%edx),%al
  800946:	74 ef                	je     800937 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800948:	0f b6 c0             	movzbl %al,%eax
  80094b:	0f b6 12             	movzbl (%edx),%edx
  80094e:	29 d0                	sub    %edx,%eax
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	53                   	push   %ebx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 c3                	mov    %eax,%ebx
  80095e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800961:	eb 06                	jmp    800969 <strncmp+0x17>
		n--, p++, q++;
  800963:	83 c0 01             	add    $0x1,%eax
  800966:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800969:	39 d8                	cmp    %ebx,%eax
  80096b:	74 15                	je     800982 <strncmp+0x30>
  80096d:	0f b6 08             	movzbl (%eax),%ecx
  800970:	84 c9                	test   %cl,%cl
  800972:	74 04                	je     800978 <strncmp+0x26>
  800974:	3a 0a                	cmp    (%edx),%cl
  800976:	74 eb                	je     800963 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 00             	movzbl (%eax),%eax
  80097b:	0f b6 12             	movzbl (%edx),%edx
  80097e:	29 d0                	sub    %edx,%eax
  800980:	eb 05                	jmp    800987 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800994:	eb 07                	jmp    80099d <strchr+0x13>
		if (*s == c)
  800996:	38 ca                	cmp    %cl,%dl
  800998:	74 0f                	je     8009a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80099a:	83 c0 01             	add    $0x1,%eax
  80099d:	0f b6 10             	movzbl (%eax),%edx
  8009a0:	84 d2                	test   %dl,%dl
  8009a2:	75 f2                	jne    800996 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b5:	eb 07                	jmp    8009be <strfind+0x13>
		if (*s == c)
  8009b7:	38 ca                	cmp    %cl,%dl
  8009b9:	74 0a                	je     8009c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	0f b6 10             	movzbl (%eax),%edx
  8009c1:	84 d2                	test   %dl,%dl
  8009c3:	75 f2                	jne    8009b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	74 36                	je     800a0d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009dd:	75 28                	jne    800a07 <memset+0x40>
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	75 23                	jne    800a07 <memset+0x40>
		c &= 0xFF;
  8009e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e8:	89 d3                	mov    %edx,%ebx
  8009ea:	c1 e3 08             	shl    $0x8,%ebx
  8009ed:	89 d6                	mov    %edx,%esi
  8009ef:	c1 e6 18             	shl    $0x18,%esi
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	c1 e0 10             	shl    $0x10,%eax
  8009f7:	09 f0                	or     %esi,%eax
  8009f9:	09 c2                	or     %eax,%edx
  8009fb:	89 d0                	mov    %edx,%eax
  8009fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a02:	fc                   	cld    
  800a03:	f3 ab                	rep stos %eax,%es:(%edi)
  800a05:	eb 06                	jmp    800a0d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	fc                   	cld    
  800a0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5f                   	pop    %edi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a22:	39 c6                	cmp    %eax,%esi
  800a24:	73 35                	jae    800a5b <memmove+0x47>
  800a26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a29:	39 d0                	cmp    %edx,%eax
  800a2b:	73 2e                	jae    800a5b <memmove+0x47>
		s += n;
		d += n;
  800a2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a30:	89 d6                	mov    %edx,%esi
  800a32:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3a:	75 13                	jne    800a4f <memmove+0x3b>
  800a3c:	f6 c1 03             	test   $0x3,%cl
  800a3f:	75 0e                	jne    800a4f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a41:	83 ef 04             	sub    $0x4,%edi
  800a44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a4a:	fd                   	std    
  800a4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4d:	eb 09                	jmp    800a58 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4f:	83 ef 01             	sub    $0x1,%edi
  800a52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a55:	fd                   	std    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a58:	fc                   	cld    
  800a59:	eb 1d                	jmp    800a78 <memmove+0x64>
  800a5b:	89 f2                	mov    %esi,%edx
  800a5d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5f:	f6 c2 03             	test   $0x3,%dl
  800a62:	75 0f                	jne    800a73 <memmove+0x5f>
  800a64:	f6 c1 03             	test   $0x3,%cl
  800a67:	75 0a                	jne    800a73 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a69:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a6c:	89 c7                	mov    %eax,%edi
  800a6e:	fc                   	cld    
  800a6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a71:	eb 05                	jmp    800a78 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a73:	89 c7                	mov    %eax,%edi
  800a75:	fc                   	cld    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
  800a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	89 04 24             	mov    %eax,(%esp)
  800a96:	e8 79 ff ff ff       	call   800a14 <memmove>
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa8:	89 d6                	mov    %edx,%esi
  800aaa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aad:	eb 1a                	jmp    800ac9 <memcmp+0x2c>
		if (*s1 != *s2)
  800aaf:	0f b6 02             	movzbl (%edx),%eax
  800ab2:	0f b6 19             	movzbl (%ecx),%ebx
  800ab5:	38 d8                	cmp    %bl,%al
  800ab7:	74 0a                	je     800ac3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ab9:	0f b6 c0             	movzbl %al,%eax
  800abc:	0f b6 db             	movzbl %bl,%ebx
  800abf:	29 d8                	sub    %ebx,%eax
  800ac1:	eb 0f                	jmp    800ad2 <memcmp+0x35>
		s1++, s2++;
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac9:	39 f2                	cmp    %esi,%edx
  800acb:	75 e2                	jne    800aaf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800adf:	89 c2                	mov    %eax,%edx
  800ae1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae4:	eb 07                	jmp    800aed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae6:	38 08                	cmp    %cl,(%eax)
  800ae8:	74 07                	je     800af1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aea:	83 c0 01             	add    $0x1,%eax
  800aed:	39 d0                	cmp    %edx,%eax
  800aef:	72 f5                	jb     800ae6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	57                   	push   %edi
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	8b 55 08             	mov    0x8(%ebp),%edx
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aff:	eb 03                	jmp    800b04 <strtol+0x11>
		s++;
  800b01:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b04:	0f b6 0a             	movzbl (%edx),%ecx
  800b07:	80 f9 09             	cmp    $0x9,%cl
  800b0a:	74 f5                	je     800b01 <strtol+0xe>
  800b0c:	80 f9 20             	cmp    $0x20,%cl
  800b0f:	74 f0                	je     800b01 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b11:	80 f9 2b             	cmp    $0x2b,%cl
  800b14:	75 0a                	jne    800b20 <strtol+0x2d>
		s++;
  800b16:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1e:	eb 11                	jmp    800b31 <strtol+0x3e>
  800b20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b25:	80 f9 2d             	cmp    $0x2d,%cl
  800b28:	75 07                	jne    800b31 <strtol+0x3e>
		s++, neg = 1;
  800b2a:	8d 52 01             	lea    0x1(%edx),%edx
  800b2d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b31:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b36:	75 15                	jne    800b4d <strtol+0x5a>
  800b38:	80 3a 30             	cmpb   $0x30,(%edx)
  800b3b:	75 10                	jne    800b4d <strtol+0x5a>
  800b3d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b41:	75 0a                	jne    800b4d <strtol+0x5a>
		s += 2, base = 16;
  800b43:	83 c2 02             	add    $0x2,%edx
  800b46:	b8 10 00 00 00       	mov    $0x10,%eax
  800b4b:	eb 10                	jmp    800b5d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	75 0c                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b51:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b53:	80 3a 30             	cmpb   $0x30,(%edx)
  800b56:	75 05                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b62:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b65:	0f b6 0a             	movzbl (%edx),%ecx
  800b68:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b6b:	89 f0                	mov    %esi,%eax
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	77 08                	ja     800b79 <strtol+0x86>
			dig = *s - '0';
  800b71:	0f be c9             	movsbl %cl,%ecx
  800b74:	83 e9 30             	sub    $0x30,%ecx
  800b77:	eb 20                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b79:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	3c 19                	cmp    $0x19,%al
  800b80:	77 08                	ja     800b8a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b82:	0f be c9             	movsbl %cl,%ecx
  800b85:	83 e9 57             	sub    $0x57,%ecx
  800b88:	eb 0f                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b8a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	3c 19                	cmp    $0x19,%al
  800b91:	77 16                	ja     800ba9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b93:	0f be c9             	movsbl %cl,%ecx
  800b96:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b99:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b9c:	7d 0f                	jge    800bad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ba5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ba7:	eb bc                	jmp    800b65 <strtol+0x72>
  800ba9:	89 d8                	mov    %ebx,%eax
  800bab:	eb 02                	jmp    800baf <strtol+0xbc>
  800bad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb3:	74 05                	je     800bba <strtol+0xc7>
		*endptr = (char *) s;
  800bb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bba:	f7 d8                	neg    %eax
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	0f 44 c3             	cmove  %ebx,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	89 c3                	mov    %eax,%ebx
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	89 c6                	mov    %eax,%esi
  800bdd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c11:	b8 03 00 00 00       	mov    $0x3,%eax
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	89 cb                	mov    %ecx,%ebx
  800c1b:	89 cf                	mov    %ecx,%edi
  800c1d:	89 ce                	mov    %ecx,%esi
  800c1f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	7e 28                	jle    800c4d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c29:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c30:	00 
  800c31:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800c38:	00 
  800c39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c40:	00 
  800c41:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800c48:	e8 0c f5 ff ff       	call   800159 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4d:	83 c4 2c             	add    $0x2c,%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c60:	b8 02 00 00 00       	mov    $0x2,%eax
  800c65:	89 d1                	mov    %edx,%ecx
  800c67:	89 d3                	mov    %edx,%ebx
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	89 d6                	mov    %edx,%esi
  800c6d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <sys_yield>:

void
sys_yield(void)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c84:	89 d1                	mov    %edx,%ecx
  800c86:	89 d3                	mov    %edx,%ebx
  800c88:	89 d7                	mov    %edx,%edi
  800c8a:	89 d6                	mov    %edx,%esi
  800c8c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ca1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800caf:	89 f7                	mov    %esi,%edi
  800cb1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	7e 28                	jle    800cdf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cc2:	00 
  800cc3:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800cca:	00 
  800ccb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd2:	00 
  800cd3:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800cda:	e8 7a f4 ff ff       	call   800159 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cdf:	83 c4 2c             	add    $0x2c,%esp
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf0:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d01:	8b 75 18             	mov    0x18(%ebp),%esi
  800d04:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7e 28                	jle    800d32 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d15:	00 
  800d16:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800d1d:	00 
  800d1e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d25:	00 
  800d26:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800d2d:	e8 27 f4 ff ff       	call   800159 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d32:	83 c4 2c             	add    $0x2c,%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
  800d40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d48:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	89 df                	mov    %ebx,%edi
  800d55:	89 de                	mov    %ebx,%esi
  800d57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	7e 28                	jle    800d85 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d61:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d68:	00 
  800d69:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800d70:	00 
  800d71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d78:	00 
  800d79:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800d80:	e8 d4 f3 ff ff       	call   800159 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d85:	83 c4 2c             	add    $0x2c,%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	89 df                	mov    %ebx,%edi
  800da8:	89 de                	mov    %ebx,%esi
  800daa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	7e 28                	jle    800dd8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800dc3:	00 
  800dc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcb:	00 
  800dcc:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800dd3:	e8 81 f3 ff ff       	call   800159 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd8:	83 c4 2c             	add    $0x2c,%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	b8 09 00 00 00       	mov    $0x9,%eax
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7e 28                	jle    800e2b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e07:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e0e:	00 
  800e0f:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800e16:	00 
  800e17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1e:	00 
  800e1f:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800e26:	e8 2e f3 ff ff       	call   800159 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2b:	83 c4 2c             	add    $0x2c,%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7e 28                	jle    800e7e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e61:	00 
  800e62:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800e69:	00 
  800e6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e71:	00 
  800e72:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800e79:	e8 db f2 ff ff       	call   800159 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e7e:	83 c4 2c             	add    $0x2c,%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	be 00 00 00 00       	mov    $0x0,%esi
  800e91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	89 cb                	mov    %ecx,%ebx
  800ec1:	89 cf                	mov    %ecx,%edi
  800ec3:	89 ce                	mov    %ecx,%esi
  800ec5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	7e 28                	jle    800ef3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800ede:	00 
  800edf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee6:	00 
  800ee7:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800eee:	e8 66 f2 ff ff       	call   800159 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef3:	83 c4 2c             	add    $0x2c,%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f01:	ba 00 00 00 00       	mov    $0x0,%edx
  800f06:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f0b:	89 d1                	mov    %edx,%ecx
  800f0d:	89 d3                	mov    %edx,%ebx
  800f0f:	89 d7                	mov    %edx,%edi
  800f11:	89 d6                	mov    %edx,%esi
  800f13:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    

00800f1a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
  800f20:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f28:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	89 df                	mov    %ebx,%edi
  800f35:	89 de                	mov    %ebx,%esi
  800f37:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7e 28                	jle    800f65 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f41:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f48:	00 
  800f49:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800f50:	00 
  800f51:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f58:	00 
  800f59:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800f60:	e8 f4 f1 ff ff       	call   800159 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800f65:	83 c4 2c             	add    $0x2c,%esp
  800f68:	5b                   	pop    %ebx
  800f69:	5e                   	pop    %esi
  800f6a:	5f                   	pop    %edi
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	57                   	push   %edi
  800f71:	56                   	push   %esi
  800f72:	53                   	push   %ebx
  800f73:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	89 df                	mov    %ebx,%edi
  800f88:	89 de                	mov    %ebx,%esi
  800f8a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	7e 28                	jle    800fb8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f90:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f94:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f9b:	00 
  800f9c:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800fa3:	00 
  800fa4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fab:	00 
  800fac:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800fb3:	e8 a1 f1 ff ff       	call   800159 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800fb8:	83 c4 2c             	add    $0x2c,%esp
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
  800fc6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fce:	b8 11 00 00 00       	mov    $0x11,%eax
  800fd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd9:	89 df                	mov    %ebx,%edi
  800fdb:	89 de                	mov    %ebx,%esi
  800fdd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	7e 28                	jle    80100b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800fee:	00 
  800fef:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800ff6:	00 
  800ff7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffe:	00 
  800fff:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  801006:	e8 4e f1 ff ff       	call   800159 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80100b:	83 c4 2c             	add    $0x2c,%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <sys_sleep>:

int
sys_sleep(int channel)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	57                   	push   %edi
  801017:	56                   	push   %esi
  801018:	53                   	push   %ebx
  801019:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801021:	b8 12 00 00 00       	mov    $0x12,%eax
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	89 cb                	mov    %ecx,%ebx
  80102b:	89 cf                	mov    %ecx,%edi
  80102d:	89 ce                	mov    %ecx,%esi
  80102f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801031:	85 c0                	test   %eax,%eax
  801033:	7e 28                	jle    80105d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801035:	89 44 24 10          	mov    %eax,0x10(%esp)
  801039:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801040:	00 
  801041:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  801048:	00 
  801049:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801050:	00 
  801051:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  801058:	e8 fc f0 ff ff       	call   800159 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80105d:	83 c4 2c             	add    $0x2c,%esp
  801060:	5b                   	pop    %ebx
  801061:	5e                   	pop    %esi
  801062:	5f                   	pop    %edi
  801063:	5d                   	pop    %ebp
  801064:	c3                   	ret    

00801065 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	57                   	push   %edi
  801069:	56                   	push   %esi
  80106a:	53                   	push   %ebx
  80106b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801073:	b8 13 00 00 00       	mov    $0x13,%eax
  801078:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 df                	mov    %ebx,%edi
  801080:	89 de                	mov    %ebx,%esi
  801082:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801084:	85 c0                	test   %eax,%eax
  801086:	7e 28                	jle    8010b0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801088:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801093:	00 
  801094:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  80109b:	00 
  80109c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a3:	00 
  8010a4:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  8010ab:	e8 a9 f0 ff ff       	call   800159 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8010b0:	83 c4 2c             	add    $0x2c,%esp
  8010b3:	5b                   	pop    %ebx
  8010b4:	5e                   	pop    %esi
  8010b5:	5f                   	pop    %edi
  8010b6:	5d                   	pop    %ebp
  8010b7:	c3                   	ret    

008010b8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8010be:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  8010c5:	75 70                	jne    801137 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  8010c7:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  8010ce:	00 
  8010cf:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8010d6:	ee 
  8010d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010de:	e8 b0 fb ff ff       	call   800c93 <sys_page_alloc>
		if (error < 0)
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	79 1c                	jns    801103 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  8010e7:	c7 44 24 08 18 2c 80 	movl   $0x802c18,0x8(%esp)
  8010ee:	00 
  8010ef:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010f6:	00 
  8010f7:	c7 04 24 6b 2c 80 00 	movl   $0x802c6b,(%esp)
  8010fe:	e8 56 f0 ff ff       	call   800159 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801103:	c7 44 24 04 41 11 80 	movl   $0x801141,0x4(%esp)
  80110a:	00 
  80110b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801112:	e8 1c fd ff ff       	call   800e33 <sys_env_set_pgfault_upcall>
		if (error < 0)
  801117:	85 c0                	test   %eax,%eax
  801119:	79 1c                	jns    801137 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  80111b:	c7 44 24 08 40 2c 80 	movl   $0x802c40,0x8(%esp)
  801122:	00 
  801123:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80112a:	00 
  80112b:	c7 04 24 6b 2c 80 00 	movl   $0x802c6b,(%esp)
  801132:	e8 22 f0 ff ff       	call   800159 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801141:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801142:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801147:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801149:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  80114c:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  801150:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  801155:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  801159:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  80115b:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80115e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80115f:	83 c4 04             	add    $0x4,%esp
	popfl
  801162:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801163:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801164:	c3                   	ret    
  801165:	66 90                	xchg   %ax,%ax
  801167:	66 90                	xchg   %ax,%ax
  801169:	66 90                	xchg   %ax,%ax
  80116b:	66 90                	xchg   %ax,%ax
  80116d:	66 90                	xchg   %ax,%ax
  80116f:	90                   	nop

00801170 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	05 00 00 00 30       	add    $0x30000000,%eax
  80117b:	c1 e8 0c             	shr    $0xc,%eax
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80118b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801190:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011a2:	89 c2                	mov    %eax,%edx
  8011a4:	c1 ea 16             	shr    $0x16,%edx
  8011a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ae:	f6 c2 01             	test   $0x1,%dl
  8011b1:	74 11                	je     8011c4 <fd_alloc+0x2d>
  8011b3:	89 c2                	mov    %eax,%edx
  8011b5:	c1 ea 0c             	shr    $0xc,%edx
  8011b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011bf:	f6 c2 01             	test   $0x1,%dl
  8011c2:	75 09                	jne    8011cd <fd_alloc+0x36>
			*fd_store = fd;
  8011c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cb:	eb 17                	jmp    8011e4 <fd_alloc+0x4d>
  8011cd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011d2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011d7:	75 c9                	jne    8011a2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011d9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011df:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011ec:	83 f8 1f             	cmp    $0x1f,%eax
  8011ef:	77 36                	ja     801227 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011f1:	c1 e0 0c             	shl    $0xc,%eax
  8011f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011f9:	89 c2                	mov    %eax,%edx
  8011fb:	c1 ea 16             	shr    $0x16,%edx
  8011fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801205:	f6 c2 01             	test   $0x1,%dl
  801208:	74 24                	je     80122e <fd_lookup+0x48>
  80120a:	89 c2                	mov    %eax,%edx
  80120c:	c1 ea 0c             	shr    $0xc,%edx
  80120f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801216:	f6 c2 01             	test   $0x1,%dl
  801219:	74 1a                	je     801235 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80121b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121e:	89 02                	mov    %eax,(%edx)
	return 0;
  801220:	b8 00 00 00 00       	mov    $0x0,%eax
  801225:	eb 13                	jmp    80123a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801227:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80122c:	eb 0c                	jmp    80123a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80122e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801233:	eb 05                	jmp    80123a <fd_lookup+0x54>
  801235:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    

0080123c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	83 ec 18             	sub    $0x18,%esp
  801242:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801245:	ba 00 00 00 00       	mov    $0x0,%edx
  80124a:	eb 13                	jmp    80125f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80124c:	39 08                	cmp    %ecx,(%eax)
  80124e:	75 0c                	jne    80125c <dev_lookup+0x20>
			*dev = devtab[i];
  801250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801253:	89 01                	mov    %eax,(%ecx)
			return 0;
  801255:	b8 00 00 00 00       	mov    $0x0,%eax
  80125a:	eb 38                	jmp    801294 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80125c:	83 c2 01             	add    $0x1,%edx
  80125f:	8b 04 95 f8 2c 80 00 	mov    0x802cf8(,%edx,4),%eax
  801266:	85 c0                	test   %eax,%eax
  801268:	75 e2                	jne    80124c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80126a:	a1 08 40 80 00       	mov    0x804008,%eax
  80126f:	8b 40 48             	mov    0x48(%eax),%eax
  801272:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801276:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127a:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  801281:	e8 cc ef ff ff       	call   800252 <cprintf>
	*dev = 0;
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80128f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	56                   	push   %esi
  80129a:	53                   	push   %ebx
  80129b:	83 ec 20             	sub    $0x20,%esp
  80129e:	8b 75 08             	mov    0x8(%ebp),%esi
  8012a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012b1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b4:	89 04 24             	mov    %eax,(%esp)
  8012b7:	e8 2a ff ff ff       	call   8011e6 <fd_lookup>
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	78 05                	js     8012c5 <fd_close+0x2f>
	    || fd != fd2)
  8012c0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8012c3:	74 0c                	je     8012d1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8012c5:	84 db                	test   %bl,%bl
  8012c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012cc:	0f 44 c2             	cmove  %edx,%eax
  8012cf:	eb 3f                	jmp    801310 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d8:	8b 06                	mov    (%esi),%eax
  8012da:	89 04 24             	mov    %eax,(%esp)
  8012dd:	e8 5a ff ff ff       	call   80123c <dev_lookup>
  8012e2:	89 c3                	mov    %eax,%ebx
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	78 16                	js     8012fe <fd_close+0x68>
		if (dev->dev_close)
  8012e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	74 07                	je     8012fe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8012f7:	89 34 24             	mov    %esi,(%esp)
  8012fa:	ff d0                	call   *%eax
  8012fc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801302:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801309:	e8 2c fa ff ff       	call   800d3a <sys_page_unmap>
	return r;
  80130e:	89 d8                	mov    %ebx,%eax
}
  801310:	83 c4 20             	add    $0x20,%esp
  801313:	5b                   	pop    %ebx
  801314:	5e                   	pop    %esi
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80131d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801320:	89 44 24 04          	mov    %eax,0x4(%esp)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 04 24             	mov    %eax,(%esp)
  80132a:	e8 b7 fe ff ff       	call   8011e6 <fd_lookup>
  80132f:	89 c2                	mov    %eax,%edx
  801331:	85 d2                	test   %edx,%edx
  801333:	78 13                	js     801348 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801335:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80133c:	00 
  80133d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801340:	89 04 24             	mov    %eax,(%esp)
  801343:	e8 4e ff ff ff       	call   801296 <fd_close>
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <close_all>:

void
close_all(void)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801351:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801356:	89 1c 24             	mov    %ebx,(%esp)
  801359:	e8 b9 ff ff ff       	call   801317 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80135e:	83 c3 01             	add    $0x1,%ebx
  801361:	83 fb 20             	cmp    $0x20,%ebx
  801364:	75 f0                	jne    801356 <close_all+0xc>
		close(i);
}
  801366:	83 c4 14             	add    $0x14,%esp
  801369:	5b                   	pop    %ebx
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801375:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801378:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	89 04 24             	mov    %eax,(%esp)
  801382:	e8 5f fe ff ff       	call   8011e6 <fd_lookup>
  801387:	89 c2                	mov    %eax,%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	0f 88 e1 00 00 00    	js     801472 <dup+0x106>
		return r;
	close(newfdnum);
  801391:	8b 45 0c             	mov    0xc(%ebp),%eax
  801394:	89 04 24             	mov    %eax,(%esp)
  801397:	e8 7b ff ff ff       	call   801317 <close>

	newfd = INDEX2FD(newfdnum);
  80139c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80139f:	c1 e3 0c             	shl    $0xc,%ebx
  8013a2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8013a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ab:	89 04 24             	mov    %eax,(%esp)
  8013ae:	e8 cd fd ff ff       	call   801180 <fd2data>
  8013b3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8013b5:	89 1c 24             	mov    %ebx,(%esp)
  8013b8:	e8 c3 fd ff ff       	call   801180 <fd2data>
  8013bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013bf:	89 f0                	mov    %esi,%eax
  8013c1:	c1 e8 16             	shr    $0x16,%eax
  8013c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013cb:	a8 01                	test   $0x1,%al
  8013cd:	74 43                	je     801412 <dup+0xa6>
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	c1 e8 0c             	shr    $0xc,%eax
  8013d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013db:	f6 c2 01             	test   $0x1,%dl
  8013de:	74 32                	je     801412 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013fb:	00 
  8013fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801400:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801407:	e8 db f8 ff ff       	call   800ce7 <sys_page_map>
  80140c:	89 c6                	mov    %eax,%esi
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 3e                	js     801450 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801415:	89 c2                	mov    %eax,%edx
  801417:	c1 ea 0c             	shr    $0xc,%edx
  80141a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801421:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801427:	89 54 24 10          	mov    %edx,0x10(%esp)
  80142b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80142f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801436:	00 
  801437:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801442:	e8 a0 f8 ff ff       	call   800ce7 <sys_page_map>
  801447:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80144c:	85 f6                	test   %esi,%esi
  80144e:	79 22                	jns    801472 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801450:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801454:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80145b:	e8 da f8 ff ff       	call   800d3a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801460:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801464:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80146b:	e8 ca f8 ff ff       	call   800d3a <sys_page_unmap>
	return r;
  801470:	89 f0                	mov    %esi,%eax
}
  801472:	83 c4 3c             	add    $0x3c,%esp
  801475:	5b                   	pop    %ebx
  801476:	5e                   	pop    %esi
  801477:	5f                   	pop    %edi
  801478:	5d                   	pop    %ebp
  801479:	c3                   	ret    

0080147a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	53                   	push   %ebx
  80147e:	83 ec 24             	sub    $0x24,%esp
  801481:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801484:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801487:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148b:	89 1c 24             	mov    %ebx,(%esp)
  80148e:	e8 53 fd ff ff       	call   8011e6 <fd_lookup>
  801493:	89 c2                	mov    %eax,%edx
  801495:	85 d2                	test   %edx,%edx
  801497:	78 6d                	js     801506 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801499:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a3:	8b 00                	mov    (%eax),%eax
  8014a5:	89 04 24             	mov    %eax,(%esp)
  8014a8:	e8 8f fd ff ff       	call   80123c <dev_lookup>
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 55                	js     801506 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b4:	8b 50 08             	mov    0x8(%eax),%edx
  8014b7:	83 e2 03             	and    $0x3,%edx
  8014ba:	83 fa 01             	cmp    $0x1,%edx
  8014bd:	75 23                	jne    8014e2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8014c4:	8b 40 48             	mov    0x48(%eax),%eax
  8014c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cf:	c7 04 24 bd 2c 80 00 	movl   $0x802cbd,(%esp)
  8014d6:	e8 77 ed ff ff       	call   800252 <cprintf>
		return -E_INVAL;
  8014db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e0:	eb 24                	jmp    801506 <read+0x8c>
	}
	if (!dev->dev_read)
  8014e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e5:	8b 52 08             	mov    0x8(%edx),%edx
  8014e8:	85 d2                	test   %edx,%edx
  8014ea:	74 15                	je     801501 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014fa:	89 04 24             	mov    %eax,(%esp)
  8014fd:	ff d2                	call   *%edx
  8014ff:	eb 05                	jmp    801506 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801501:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801506:	83 c4 24             	add    $0x24,%esp
  801509:	5b                   	pop    %ebx
  80150a:	5d                   	pop    %ebp
  80150b:	c3                   	ret    

0080150c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	57                   	push   %edi
  801510:	56                   	push   %esi
  801511:	53                   	push   %ebx
  801512:	83 ec 1c             	sub    $0x1c,%esp
  801515:	8b 7d 08             	mov    0x8(%ebp),%edi
  801518:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80151b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801520:	eb 23                	jmp    801545 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801522:	89 f0                	mov    %esi,%eax
  801524:	29 d8                	sub    %ebx,%eax
  801526:	89 44 24 08          	mov    %eax,0x8(%esp)
  80152a:	89 d8                	mov    %ebx,%eax
  80152c:	03 45 0c             	add    0xc(%ebp),%eax
  80152f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801533:	89 3c 24             	mov    %edi,(%esp)
  801536:	e8 3f ff ff ff       	call   80147a <read>
		if (m < 0)
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 10                	js     80154f <readn+0x43>
			return m;
		if (m == 0)
  80153f:	85 c0                	test   %eax,%eax
  801541:	74 0a                	je     80154d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801543:	01 c3                	add    %eax,%ebx
  801545:	39 f3                	cmp    %esi,%ebx
  801547:	72 d9                	jb     801522 <readn+0x16>
  801549:	89 d8                	mov    %ebx,%eax
  80154b:	eb 02                	jmp    80154f <readn+0x43>
  80154d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80154f:	83 c4 1c             	add    $0x1c,%esp
  801552:	5b                   	pop    %ebx
  801553:	5e                   	pop    %esi
  801554:	5f                   	pop    %edi
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	53                   	push   %ebx
  80155b:	83 ec 24             	sub    $0x24,%esp
  80155e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801561:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801564:	89 44 24 04          	mov    %eax,0x4(%esp)
  801568:	89 1c 24             	mov    %ebx,(%esp)
  80156b:	e8 76 fc ff ff       	call   8011e6 <fd_lookup>
  801570:	89 c2                	mov    %eax,%edx
  801572:	85 d2                	test   %edx,%edx
  801574:	78 68                	js     8015de <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801576:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801580:	8b 00                	mov    (%eax),%eax
  801582:	89 04 24             	mov    %eax,(%esp)
  801585:	e8 b2 fc ff ff       	call   80123c <dev_lookup>
  80158a:	85 c0                	test   %eax,%eax
  80158c:	78 50                	js     8015de <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80158e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801591:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801595:	75 23                	jne    8015ba <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801597:	a1 08 40 80 00       	mov    0x804008,%eax
  80159c:	8b 40 48             	mov    0x48(%eax),%eax
  80159f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a7:	c7 04 24 d9 2c 80 00 	movl   $0x802cd9,(%esp)
  8015ae:	e8 9f ec ff ff       	call   800252 <cprintf>
		return -E_INVAL;
  8015b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b8:	eb 24                	jmp    8015de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c0:	85 d2                	test   %edx,%edx
  8015c2:	74 15                	je     8015d9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015d2:	89 04 24             	mov    %eax,(%esp)
  8015d5:	ff d2                	call   *%edx
  8015d7:	eb 05                	jmp    8015de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015de:	83 c4 24             	add    $0x24,%esp
  8015e1:	5b                   	pop    %ebx
  8015e2:	5d                   	pop    %ebp
  8015e3:	c3                   	ret    

008015e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	89 04 24             	mov    %eax,(%esp)
  8015f7:	e8 ea fb ff ff       	call   8011e6 <fd_lookup>
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 0e                	js     80160e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801600:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801603:	8b 55 0c             	mov    0xc(%ebp),%edx
  801606:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801609:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	53                   	push   %ebx
  801614:	83 ec 24             	sub    $0x24,%esp
  801617:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80161d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801621:	89 1c 24             	mov    %ebx,(%esp)
  801624:	e8 bd fb ff ff       	call   8011e6 <fd_lookup>
  801629:	89 c2                	mov    %eax,%edx
  80162b:	85 d2                	test   %edx,%edx
  80162d:	78 61                	js     801690 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80162f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801632:	89 44 24 04          	mov    %eax,0x4(%esp)
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	8b 00                	mov    (%eax),%eax
  80163b:	89 04 24             	mov    %eax,(%esp)
  80163e:	e8 f9 fb ff ff       	call   80123c <dev_lookup>
  801643:	85 c0                	test   %eax,%eax
  801645:	78 49                	js     801690 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80164e:	75 23                	jne    801673 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801650:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801655:	8b 40 48             	mov    0x48(%eax),%eax
  801658:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80165c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801660:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  801667:	e8 e6 eb ff ff       	call   800252 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80166c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801671:	eb 1d                	jmp    801690 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801676:	8b 52 18             	mov    0x18(%edx),%edx
  801679:	85 d2                	test   %edx,%edx
  80167b:	74 0e                	je     80168b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80167d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801680:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801684:	89 04 24             	mov    %eax,(%esp)
  801687:	ff d2                	call   *%edx
  801689:	eb 05                	jmp    801690 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80168b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801690:	83 c4 24             	add    $0x24,%esp
  801693:	5b                   	pop    %ebx
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    

00801696 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	53                   	push   %ebx
  80169a:	83 ec 24             	sub    $0x24,%esp
  80169d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	89 04 24             	mov    %eax,(%esp)
  8016ad:	e8 34 fb ff ff       	call   8011e6 <fd_lookup>
  8016b2:	89 c2                	mov    %eax,%edx
  8016b4:	85 d2                	test   %edx,%edx
  8016b6:	78 52                	js     80170a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c2:	8b 00                	mov    (%eax),%eax
  8016c4:	89 04 24             	mov    %eax,(%esp)
  8016c7:	e8 70 fb ff ff       	call   80123c <dev_lookup>
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 3a                	js     80170a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8016d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016d7:	74 2c                	je     801705 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016e3:	00 00 00 
	stat->st_isdir = 0;
  8016e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ed:	00 00 00 
	stat->st_dev = dev;
  8016f0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fd:	89 14 24             	mov    %edx,(%esp)
  801700:	ff 50 14             	call   *0x14(%eax)
  801703:	eb 05                	jmp    80170a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801705:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80170a:	83 c4 24             	add    $0x24,%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5d                   	pop    %ebp
  80170f:	c3                   	ret    

00801710 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	56                   	push   %esi
  801714:	53                   	push   %ebx
  801715:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801718:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80171f:	00 
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	89 04 24             	mov    %eax,(%esp)
  801726:	e8 1b 02 00 00       	call   801946 <open>
  80172b:	89 c3                	mov    %eax,%ebx
  80172d:	85 db                	test   %ebx,%ebx
  80172f:	78 1b                	js     80174c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801731:	8b 45 0c             	mov    0xc(%ebp),%eax
  801734:	89 44 24 04          	mov    %eax,0x4(%esp)
  801738:	89 1c 24             	mov    %ebx,(%esp)
  80173b:	e8 56 ff ff ff       	call   801696 <fstat>
  801740:	89 c6                	mov    %eax,%esi
	close(fd);
  801742:	89 1c 24             	mov    %ebx,(%esp)
  801745:	e8 cd fb ff ff       	call   801317 <close>
	return r;
  80174a:	89 f0                	mov    %esi,%eax
}
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	56                   	push   %esi
  801757:	53                   	push   %ebx
  801758:	83 ec 10             	sub    $0x10,%esp
  80175b:	89 c6                	mov    %eax,%esi
  80175d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80175f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801766:	75 11                	jne    801779 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801768:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80176f:	e8 7b 0d 00 00       	call   8024ef <ipc_find_env>
  801774:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801779:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801780:	00 
  801781:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801788:	00 
  801789:	89 74 24 04          	mov    %esi,0x4(%esp)
  80178d:	a1 00 40 80 00       	mov    0x804000,%eax
  801792:	89 04 24             	mov    %eax,(%esp)
  801795:	e8 ea 0c 00 00       	call   802484 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80179a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017a1:	00 
  8017a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017ad:	e8 7e 0c 00 00       	call   802430 <ipc_recv>
}
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	5b                   	pop    %ebx
  8017b6:	5e                   	pop    %esi
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    

008017b9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017dc:	e8 72 ff ff ff       	call   801753 <fsipc>
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ef:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017fe:	e8 50 ff ff ff       	call   801753 <fsipc>
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	53                   	push   %ebx
  801809:	83 ec 14             	sub    $0x14,%esp
  80180c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	8b 40 0c             	mov    0xc(%eax),%eax
  801815:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80181a:	ba 00 00 00 00       	mov    $0x0,%edx
  80181f:	b8 05 00 00 00       	mov    $0x5,%eax
  801824:	e8 2a ff ff ff       	call   801753 <fsipc>
  801829:	89 c2                	mov    %eax,%edx
  80182b:	85 d2                	test   %edx,%edx
  80182d:	78 2b                	js     80185a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80182f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801836:	00 
  801837:	89 1c 24             	mov    %ebx,(%esp)
  80183a:	e8 38 f0 ff ff       	call   800877 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80183f:	a1 80 50 80 00       	mov    0x805080,%eax
  801844:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80184a:	a1 84 50 80 00       	mov    0x805084,%eax
  80184f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185a:	83 c4 14             	add    $0x14,%esp
  80185d:	5b                   	pop    %ebx
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 18             	sub    $0x18,%esp
  801866:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801869:	8b 55 08             	mov    0x8(%ebp),%edx
  80186c:	8b 52 0c             	mov    0xc(%edx),%edx
  80186f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801875:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80187a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80187e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801881:	89 44 24 04          	mov    %eax,0x4(%esp)
  801885:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80188c:	e8 eb f1 ff ff       	call   800a7c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801891:	ba 00 00 00 00       	mov    $0x0,%edx
  801896:	b8 04 00 00 00       	mov    $0x4,%eax
  80189b:	e8 b3 fe ff ff       	call   801753 <fsipc>
		return r;
	}

	return r;
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	56                   	push   %esi
  8018a6:	53                   	push   %ebx
  8018a7:	83 ec 10             	sub    $0x10,%esp
  8018aa:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018b8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018be:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c3:	b8 03 00 00 00       	mov    $0x3,%eax
  8018c8:	e8 86 fe ff ff       	call   801753 <fsipc>
  8018cd:	89 c3                	mov    %eax,%ebx
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	78 6a                	js     80193d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018d3:	39 c6                	cmp    %eax,%esi
  8018d5:	73 24                	jae    8018fb <devfile_read+0x59>
  8018d7:	c7 44 24 0c 0c 2d 80 	movl   $0x802d0c,0xc(%esp)
  8018de:	00 
  8018df:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  8018e6:	00 
  8018e7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018ee:	00 
  8018ef:	c7 04 24 28 2d 80 00 	movl   $0x802d28,(%esp)
  8018f6:	e8 5e e8 ff ff       	call   800159 <_panic>
	assert(r <= PGSIZE);
  8018fb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801900:	7e 24                	jle    801926 <devfile_read+0x84>
  801902:	c7 44 24 0c 33 2d 80 	movl   $0x802d33,0xc(%esp)
  801909:	00 
  80190a:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  801911:	00 
  801912:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801919:	00 
  80191a:	c7 04 24 28 2d 80 00 	movl   $0x802d28,(%esp)
  801921:	e8 33 e8 ff ff       	call   800159 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801926:	89 44 24 08          	mov    %eax,0x8(%esp)
  80192a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801931:	00 
  801932:	8b 45 0c             	mov    0xc(%ebp),%eax
  801935:	89 04 24             	mov    %eax,(%esp)
  801938:	e8 d7 f0 ff ff       	call   800a14 <memmove>
	return r;
}
  80193d:	89 d8                	mov    %ebx,%eax
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	5b                   	pop    %ebx
  801943:	5e                   	pop    %esi
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	53                   	push   %ebx
  80194a:	83 ec 24             	sub    $0x24,%esp
  80194d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801950:	89 1c 24             	mov    %ebx,(%esp)
  801953:	e8 e8 ee ff ff       	call   800840 <strlen>
  801958:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80195d:	7f 60                	jg     8019bf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80195f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801962:	89 04 24             	mov    %eax,(%esp)
  801965:	e8 2d f8 ff ff       	call   801197 <fd_alloc>
  80196a:	89 c2                	mov    %eax,%edx
  80196c:	85 d2                	test   %edx,%edx
  80196e:	78 54                	js     8019c4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801970:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801974:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80197b:	e8 f7 ee ff ff       	call   800877 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80198b:	b8 01 00 00 00       	mov    $0x1,%eax
  801990:	e8 be fd ff ff       	call   801753 <fsipc>
  801995:	89 c3                	mov    %eax,%ebx
  801997:	85 c0                	test   %eax,%eax
  801999:	79 17                	jns    8019b2 <open+0x6c>
		fd_close(fd, 0);
  80199b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019a2:	00 
  8019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a6:	89 04 24             	mov    %eax,(%esp)
  8019a9:	e8 e8 f8 ff ff       	call   801296 <fd_close>
		return r;
  8019ae:	89 d8                	mov    %ebx,%eax
  8019b0:	eb 12                	jmp    8019c4 <open+0x7e>
	}

	return fd2num(fd);
  8019b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b5:	89 04 24             	mov    %eax,(%esp)
  8019b8:	e8 b3 f7 ff ff       	call   801170 <fd2num>
  8019bd:	eb 05                	jmp    8019c4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019bf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019c4:	83 c4 24             	add    $0x24,%esp
  8019c7:	5b                   	pop    %ebx
  8019c8:	5d                   	pop    %ebp
  8019c9:	c3                   	ret    

008019ca <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019da:	e8 74 fd ff ff       	call   801753 <fsipc>
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    
  8019e1:	66 90                	xchg   %ax,%ax
  8019e3:	66 90                	xchg   %ax,%ax
  8019e5:	66 90                	xchg   %ax,%ax
  8019e7:	66 90                	xchg   %ax,%ax
  8019e9:	66 90                	xchg   %ax,%ax
  8019eb:	66 90                	xchg   %ax,%ax
  8019ed:	66 90                	xchg   %ax,%ax
  8019ef:	90                   	nop

008019f0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8019f6:	c7 44 24 04 3f 2d 80 	movl   $0x802d3f,0x4(%esp)
  8019fd:	00 
  8019fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a01:	89 04 24             	mov    %eax,(%esp)
  801a04:	e8 6e ee ff ff       	call   800877 <strcpy>
	return 0;
}
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	53                   	push   %ebx
  801a14:	83 ec 14             	sub    $0x14,%esp
  801a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a1a:	89 1c 24             	mov    %ebx,(%esp)
  801a1d:	e8 0c 0b 00 00       	call   80252e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801a22:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801a27:	83 f8 01             	cmp    $0x1,%eax
  801a2a:	75 0d                	jne    801a39 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801a2c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801a2f:	89 04 24             	mov    %eax,(%esp)
  801a32:	e8 29 03 00 00       	call   801d60 <nsipc_close>
  801a37:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801a39:	89 d0                	mov    %edx,%eax
  801a3b:	83 c4 14             	add    $0x14,%esp
  801a3e:	5b                   	pop    %ebx
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    

00801a41 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a4e:	00 
  801a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	8b 40 0c             	mov    0xc(%eax),%eax
  801a63:	89 04 24             	mov    %eax,(%esp)
  801a66:	e8 f0 03 00 00       	call   801e5b <nsipc_send>
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a7a:	00 
  801a7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8f:	89 04 24             	mov    %eax,(%esp)
  801a92:	e8 44 03 00 00       	call   801ddb <nsipc_recv>
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801aa2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aa6:	89 04 24             	mov    %eax,(%esp)
  801aa9:	e8 38 f7 ff ff       	call   8011e6 <fd_lookup>
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 17                	js     801ac9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801abb:	39 08                	cmp    %ecx,(%eax)
  801abd:	75 05                	jne    801ac4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801abf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac2:	eb 05                	jmp    801ac9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ac4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	56                   	push   %esi
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 20             	sub    $0x20,%esp
  801ad3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ad5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad8:	89 04 24             	mov    %eax,(%esp)
  801adb:	e8 b7 f6 ff ff       	call   801197 <fd_alloc>
  801ae0:	89 c3                	mov    %eax,%ebx
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	78 21                	js     801b07 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ae6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801aed:	00 
  801aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801afc:	e8 92 f1 ff ff       	call   800c93 <sys_page_alloc>
  801b01:	89 c3                	mov    %eax,%ebx
  801b03:	85 c0                	test   %eax,%eax
  801b05:	79 0c                	jns    801b13 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801b07:	89 34 24             	mov    %esi,(%esp)
  801b0a:	e8 51 02 00 00       	call   801d60 <nsipc_close>
		return r;
  801b0f:	89 d8                	mov    %ebx,%eax
  801b11:	eb 20                	jmp    801b33 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b13:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801b28:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801b2b:	89 14 24             	mov    %edx,(%esp)
  801b2e:	e8 3d f6 ff ff       	call   801170 <fd2num>
}
  801b33:	83 c4 20             	add    $0x20,%esp
  801b36:	5b                   	pop    %ebx
  801b37:	5e                   	pop    %esi
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    

00801b3a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	e8 51 ff ff ff       	call   801a99 <fd2sockid>
		return r;
  801b48:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	78 23                	js     801b71 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b4e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b51:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b5c:	89 04 24             	mov    %eax,(%esp)
  801b5f:	e8 45 01 00 00       	call   801ca9 <nsipc_accept>
		return r;
  801b64:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 07                	js     801b71 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b6a:	e8 5c ff ff ff       	call   801acb <alloc_sockfd>
  801b6f:	89 c1                	mov    %eax,%ecx
}
  801b71:	89 c8                	mov    %ecx,%eax
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	e8 16 ff ff ff       	call   801a99 <fd2sockid>
  801b83:	89 c2                	mov    %eax,%edx
  801b85:	85 d2                	test   %edx,%edx
  801b87:	78 16                	js     801b9f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801b89:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b97:	89 14 24             	mov    %edx,(%esp)
  801b9a:	e8 60 01 00 00       	call   801cff <nsipc_bind>
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <shutdown>:

int
shutdown(int s, int how)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	e8 ea fe ff ff       	call   801a99 <fd2sockid>
  801baf:	89 c2                	mov    %eax,%edx
  801bb1:	85 d2                	test   %edx,%edx
  801bb3:	78 0f                	js     801bc4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbc:	89 14 24             	mov    %edx,(%esp)
  801bbf:	e8 7a 01 00 00       	call   801d3e <nsipc_shutdown>
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	e8 c5 fe ff ff       	call   801a99 <fd2sockid>
  801bd4:	89 c2                	mov    %eax,%edx
  801bd6:	85 d2                	test   %edx,%edx
  801bd8:	78 16                	js     801bf0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801bda:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be8:	89 14 24             	mov    %edx,(%esp)
  801beb:	e8 8a 01 00 00       	call   801d7a <nsipc_connect>
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <listen>:

int
listen(int s, int backlog)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	e8 99 fe ff ff       	call   801a99 <fd2sockid>
  801c00:	89 c2                	mov    %eax,%edx
  801c02:	85 d2                	test   %edx,%edx
  801c04:	78 0f                	js     801c15 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0d:	89 14 24             	mov    %edx,(%esp)
  801c10:	e8 a4 01 00 00       	call   801db9 <nsipc_listen>
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c20:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	89 04 24             	mov    %eax,(%esp)
  801c31:	e8 98 02 00 00       	call   801ece <nsipc_socket>
  801c36:	89 c2                	mov    %eax,%edx
  801c38:	85 d2                	test   %edx,%edx
  801c3a:	78 05                	js     801c41 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801c3c:	e8 8a fe ff ff       	call   801acb <alloc_sockfd>
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	53                   	push   %ebx
  801c47:	83 ec 14             	sub    $0x14,%esp
  801c4a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c4c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c53:	75 11                	jne    801c66 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c55:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c5c:	e8 8e 08 00 00       	call   8024ef <ipc_find_env>
  801c61:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c66:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c6d:	00 
  801c6e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c75:	00 
  801c76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c7a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c7f:	89 04 24             	mov    %eax,(%esp)
  801c82:	e8 fd 07 00 00       	call   802484 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c8e:	00 
  801c8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c96:	00 
  801c97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c9e:	e8 8d 07 00 00       	call   802430 <ipc_recv>
}
  801ca3:	83 c4 14             	add    $0x14,%esp
  801ca6:	5b                   	pop    %ebx
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    

00801ca9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	56                   	push   %esi
  801cad:	53                   	push   %ebx
  801cae:	83 ec 10             	sub    $0x10,%esp
  801cb1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cbc:	8b 06                	mov    (%esi),%eax
  801cbe:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc8:	e8 76 ff ff ff       	call   801c43 <nsipc>
  801ccd:	89 c3                	mov    %eax,%ebx
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	78 23                	js     801cf6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cd3:	a1 10 60 80 00       	mov    0x806010,%eax
  801cd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cdc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ce3:	00 
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	89 04 24             	mov    %eax,(%esp)
  801cea:	e8 25 ed ff ff       	call   800a14 <memmove>
		*addrlen = ret->ret_addrlen;
  801cef:	a1 10 60 80 00       	mov    0x806010,%eax
  801cf4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801cf6:	89 d8                	mov    %ebx,%eax
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    

00801cff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	53                   	push   %ebx
  801d03:	83 ec 14             	sub    $0x14,%esp
  801d06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d11:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d23:	e8 ec ec ff ff       	call   800a14 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d28:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d2e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d33:	e8 0b ff ff ff       	call   801c43 <nsipc>
}
  801d38:	83 c4 14             	add    $0x14,%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    

00801d3e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d54:	b8 03 00 00 00       	mov    $0x3,%eax
  801d59:	e8 e5 fe ff ff       	call   801c43 <nsipc>
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <nsipc_close>:

int
nsipc_close(int s)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d6e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d73:	e8 cb fe ff ff       	call   801c43 <nsipc>
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	53                   	push   %ebx
  801d7e:	83 ec 14             	sub    $0x14,%esp
  801d81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d8c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d97:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d9e:	e8 71 ec ff ff       	call   800a14 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801da3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801da9:	b8 05 00 00 00       	mov    $0x5,%eax
  801dae:	e8 90 fe ff ff       	call   801c43 <nsipc>
}
  801db3:	83 c4 14             	add    $0x14,%esp
  801db6:	5b                   	pop    %ebx
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dca:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801dcf:	b8 06 00 00 00       	mov    $0x6,%eax
  801dd4:	e8 6a fe ff ff       	call   801c43 <nsipc>
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	56                   	push   %esi
  801ddf:	53                   	push   %ebx
  801de0:	83 ec 10             	sub    $0x10,%esp
  801de3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dee:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801df4:	8b 45 14             	mov    0x14(%ebp),%eax
  801df7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dfc:	b8 07 00 00 00       	mov    $0x7,%eax
  801e01:	e8 3d fe ff ff       	call   801c43 <nsipc>
  801e06:	89 c3                	mov    %eax,%ebx
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	78 46                	js     801e52 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801e0c:	39 f0                	cmp    %esi,%eax
  801e0e:	7f 07                	jg     801e17 <nsipc_recv+0x3c>
  801e10:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e15:	7e 24                	jle    801e3b <nsipc_recv+0x60>
  801e17:	c7 44 24 0c 4b 2d 80 	movl   $0x802d4b,0xc(%esp)
  801e1e:	00 
  801e1f:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  801e26:	00 
  801e27:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801e2e:	00 
  801e2f:	c7 04 24 60 2d 80 00 	movl   $0x802d60,(%esp)
  801e36:	e8 1e e3 ff ff       	call   800159 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e3f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e46:	00 
  801e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4a:	89 04 24             	mov    %eax,(%esp)
  801e4d:	e8 c2 eb ff ff       	call   800a14 <memmove>
	}

	return r;
}
  801e52:	89 d8                	mov    %ebx,%eax
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5d                   	pop    %ebp
  801e5a:	c3                   	ret    

00801e5b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	53                   	push   %ebx
  801e5f:	83 ec 14             	sub    $0x14,%esp
  801e62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e6d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e73:	7e 24                	jle    801e99 <nsipc_send+0x3e>
  801e75:	c7 44 24 0c 6c 2d 80 	movl   $0x802d6c,0xc(%esp)
  801e7c:	00 
  801e7d:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  801e84:	00 
  801e85:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801e8c:	00 
  801e8d:	c7 04 24 60 2d 80 00 	movl   $0x802d60,(%esp)
  801e94:	e8 c0 e2 ff ff       	call   800159 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801eab:	e8 64 eb ff ff       	call   800a14 <memmove>
	nsipcbuf.send.req_size = size;
  801eb0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801eb6:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ebe:	b8 08 00 00 00       	mov    $0x8,%eax
  801ec3:	e8 7b fd ff ff       	call   801c43 <nsipc>
}
  801ec8:	83 c4 14             	add    $0x14,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    

00801ece <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801eec:	b8 09 00 00 00       	mov    $0x9,%eax
  801ef1:	e8 4d fd ff ff       	call   801c43 <nsipc>
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	56                   	push   %esi
  801efc:	53                   	push   %ebx
  801efd:	83 ec 10             	sub    $0x10,%esp
  801f00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	89 04 24             	mov    %eax,(%esp)
  801f09:	e8 72 f2 ff ff       	call   801180 <fd2data>
  801f0e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f10:	c7 44 24 04 78 2d 80 	movl   $0x802d78,0x4(%esp)
  801f17:	00 
  801f18:	89 1c 24             	mov    %ebx,(%esp)
  801f1b:	e8 57 e9 ff ff       	call   800877 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f20:	8b 46 04             	mov    0x4(%esi),%eax
  801f23:	2b 06                	sub    (%esi),%eax
  801f25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f2b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f32:	00 00 00 
	stat->st_dev = &devpipe;
  801f35:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f3c:	30 80 00 
	return 0;
}
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5d                   	pop    %ebp
  801f4a:	c3                   	ret    

00801f4b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	53                   	push   %ebx
  801f4f:	83 ec 14             	sub    $0x14,%esp
  801f52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f60:	e8 d5 ed ff ff       	call   800d3a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f65:	89 1c 24             	mov    %ebx,(%esp)
  801f68:	e8 13 f2 ff ff       	call   801180 <fd2data>
  801f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f78:	e8 bd ed ff ff       	call   800d3a <sys_page_unmap>
}
  801f7d:	83 c4 14             	add    $0x14,%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5d                   	pop    %ebp
  801f82:	c3                   	ret    

00801f83 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	57                   	push   %edi
  801f87:	56                   	push   %esi
  801f88:	53                   	push   %ebx
  801f89:	83 ec 2c             	sub    $0x2c,%esp
  801f8c:	89 c6                	mov    %eax,%esi
  801f8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f91:	a1 08 40 80 00       	mov    0x804008,%eax
  801f96:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f99:	89 34 24             	mov    %esi,(%esp)
  801f9c:	e8 8d 05 00 00       	call   80252e <pageref>
  801fa1:	89 c7                	mov    %eax,%edi
  801fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fa6:	89 04 24             	mov    %eax,(%esp)
  801fa9:	e8 80 05 00 00       	call   80252e <pageref>
  801fae:	39 c7                	cmp    %eax,%edi
  801fb0:	0f 94 c2             	sete   %dl
  801fb3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801fb6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801fbc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801fbf:	39 fb                	cmp    %edi,%ebx
  801fc1:	74 21                	je     801fe4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801fc3:	84 d2                	test   %dl,%dl
  801fc5:	74 ca                	je     801f91 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fc7:	8b 51 58             	mov    0x58(%ecx),%edx
  801fca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fce:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fd6:	c7 04 24 7f 2d 80 00 	movl   $0x802d7f,(%esp)
  801fdd:	e8 70 e2 ff ff       	call   800252 <cprintf>
  801fe2:	eb ad                	jmp    801f91 <_pipeisclosed+0xe>
	}
}
  801fe4:	83 c4 2c             	add    $0x2c,%esp
  801fe7:	5b                   	pop    %ebx
  801fe8:	5e                   	pop    %esi
  801fe9:	5f                   	pop    %edi
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    

00801fec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	57                   	push   %edi
  801ff0:	56                   	push   %esi
  801ff1:	53                   	push   %ebx
  801ff2:	83 ec 1c             	sub    $0x1c,%esp
  801ff5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ff8:	89 34 24             	mov    %esi,(%esp)
  801ffb:	e8 80 f1 ff ff       	call   801180 <fd2data>
  802000:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802002:	bf 00 00 00 00       	mov    $0x0,%edi
  802007:	eb 45                	jmp    80204e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802009:	89 da                	mov    %ebx,%edx
  80200b:	89 f0                	mov    %esi,%eax
  80200d:	e8 71 ff ff ff       	call   801f83 <_pipeisclosed>
  802012:	85 c0                	test   %eax,%eax
  802014:	75 41                	jne    802057 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802016:	e8 59 ec ff ff       	call   800c74 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80201b:	8b 43 04             	mov    0x4(%ebx),%eax
  80201e:	8b 0b                	mov    (%ebx),%ecx
  802020:	8d 51 20             	lea    0x20(%ecx),%edx
  802023:	39 d0                	cmp    %edx,%eax
  802025:	73 e2                	jae    802009 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802027:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80202a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80202e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802031:	99                   	cltd   
  802032:	c1 ea 1b             	shr    $0x1b,%edx
  802035:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802038:	83 e1 1f             	and    $0x1f,%ecx
  80203b:	29 d1                	sub    %edx,%ecx
  80203d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802041:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802045:	83 c0 01             	add    $0x1,%eax
  802048:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80204b:	83 c7 01             	add    $0x1,%edi
  80204e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802051:	75 c8                	jne    80201b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802053:	89 f8                	mov    %edi,%eax
  802055:	eb 05                	jmp    80205c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80205c:	83 c4 1c             	add    $0x1c,%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5f                   	pop    %edi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    

00802064 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	57                   	push   %edi
  802068:	56                   	push   %esi
  802069:	53                   	push   %ebx
  80206a:	83 ec 1c             	sub    $0x1c,%esp
  80206d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802070:	89 3c 24             	mov    %edi,(%esp)
  802073:	e8 08 f1 ff ff       	call   801180 <fd2data>
  802078:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80207a:	be 00 00 00 00       	mov    $0x0,%esi
  80207f:	eb 3d                	jmp    8020be <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802081:	85 f6                	test   %esi,%esi
  802083:	74 04                	je     802089 <devpipe_read+0x25>
				return i;
  802085:	89 f0                	mov    %esi,%eax
  802087:	eb 43                	jmp    8020cc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802089:	89 da                	mov    %ebx,%edx
  80208b:	89 f8                	mov    %edi,%eax
  80208d:	e8 f1 fe ff ff       	call   801f83 <_pipeisclosed>
  802092:	85 c0                	test   %eax,%eax
  802094:	75 31                	jne    8020c7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802096:	e8 d9 eb ff ff       	call   800c74 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80209b:	8b 03                	mov    (%ebx),%eax
  80209d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020a0:	74 df                	je     802081 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020a2:	99                   	cltd   
  8020a3:	c1 ea 1b             	shr    $0x1b,%edx
  8020a6:	01 d0                	add    %edx,%eax
  8020a8:	83 e0 1f             	and    $0x1f,%eax
  8020ab:	29 d0                	sub    %edx,%eax
  8020ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020b8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020bb:	83 c6 01             	add    $0x1,%esi
  8020be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020c1:	75 d8                	jne    80209b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020c3:	89 f0                	mov    %esi,%eax
  8020c5:	eb 05                	jmp    8020cc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    

008020d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	56                   	push   %esi
  8020d8:	53                   	push   %ebx
  8020d9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020df:	89 04 24             	mov    %eax,(%esp)
  8020e2:	e8 b0 f0 ff ff       	call   801197 <fd_alloc>
  8020e7:	89 c2                	mov    %eax,%edx
  8020e9:	85 d2                	test   %edx,%edx
  8020eb:	0f 88 4d 01 00 00    	js     80223e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020f8:	00 
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802100:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802107:	e8 87 eb ff ff       	call   800c93 <sys_page_alloc>
  80210c:	89 c2                	mov    %eax,%edx
  80210e:	85 d2                	test   %edx,%edx
  802110:	0f 88 28 01 00 00    	js     80223e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802116:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802119:	89 04 24             	mov    %eax,(%esp)
  80211c:	e8 76 f0 ff ff       	call   801197 <fd_alloc>
  802121:	89 c3                	mov    %eax,%ebx
  802123:	85 c0                	test   %eax,%eax
  802125:	0f 88 fe 00 00 00    	js     802229 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80212b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802132:	00 
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802141:	e8 4d eb ff ff       	call   800c93 <sys_page_alloc>
  802146:	89 c3                	mov    %eax,%ebx
  802148:	85 c0                	test   %eax,%eax
  80214a:	0f 88 d9 00 00 00    	js     802229 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	89 04 24             	mov    %eax,(%esp)
  802156:	e8 25 f0 ff ff       	call   801180 <fd2data>
  80215b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80215d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802164:	00 
  802165:	89 44 24 04          	mov    %eax,0x4(%esp)
  802169:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802170:	e8 1e eb ff ff       	call   800c93 <sys_page_alloc>
  802175:	89 c3                	mov    %eax,%ebx
  802177:	85 c0                	test   %eax,%eax
  802179:	0f 88 97 00 00 00    	js     802216 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	89 04 24             	mov    %eax,(%esp)
  802185:	e8 f6 ef ff ff       	call   801180 <fd2data>
  80218a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802191:	00 
  802192:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802196:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80219d:	00 
  80219e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a9:	e8 39 eb ff ff       	call   800ce7 <sys_page_map>
  8021ae:	89 c3                	mov    %eax,%ebx
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	78 52                	js     802206 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021b4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021c9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	89 04 24             	mov    %eax,(%esp)
  8021e4:	e8 87 ef ff ff       	call   801170 <fd2num>
  8021e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	89 04 24             	mov    %eax,(%esp)
  8021f4:	e8 77 ef ff ff       	call   801170 <fd2num>
  8021f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802204:	eb 38                	jmp    80223e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802206:	89 74 24 04          	mov    %esi,0x4(%esp)
  80220a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802211:	e8 24 eb ff ff       	call   800d3a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802219:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802224:	e8 11 eb ff ff       	call   800d3a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802230:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802237:	e8 fe ea ff ff       	call   800d3a <sys_page_unmap>
  80223c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80223e:	83 c4 30             	add    $0x30,%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    

00802245 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80224b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80224e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	89 04 24             	mov    %eax,(%esp)
  802258:	e8 89 ef ff ff       	call   8011e6 <fd_lookup>
  80225d:	89 c2                	mov    %eax,%edx
  80225f:	85 d2                	test   %edx,%edx
  802261:	78 15                	js     802278 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	89 04 24             	mov    %eax,(%esp)
  802269:	e8 12 ef ff ff       	call   801180 <fd2data>
	return _pipeisclosed(fd, p);
  80226e:	89 c2                	mov    %eax,%edx
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	e8 0b fd ff ff       	call   801f83 <_pipeisclosed>
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	5d                   	pop    %ebp
  802289:	c3                   	ret    

0080228a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802290:	c7 44 24 04 97 2d 80 	movl   $0x802d97,0x4(%esp)
  802297:	00 
  802298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229b:	89 04 24             	mov    %eax,(%esp)
  80229e:	e8 d4 e5 ff ff       	call   800877 <strcpy>
	return 0;
}
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	57                   	push   %edi
  8022ae:	56                   	push   %esi
  8022af:	53                   	push   %ebx
  8022b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022c1:	eb 31                	jmp    8022f4 <devcons_write+0x4a>
		m = n - tot;
  8022c3:	8b 75 10             	mov    0x10(%ebp),%esi
  8022c6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8022c8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022cb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8022d0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022d7:	03 45 0c             	add    0xc(%ebp),%eax
  8022da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022de:	89 3c 24             	mov    %edi,(%esp)
  8022e1:	e8 2e e7 ff ff       	call   800a14 <memmove>
		sys_cputs(buf, m);
  8022e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ea:	89 3c 24             	mov    %edi,(%esp)
  8022ed:	e8 d4 e8 ff ff       	call   800bc6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022f2:	01 f3                	add    %esi,%ebx
  8022f4:	89 d8                	mov    %ebx,%eax
  8022f6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8022f9:	72 c8                	jb     8022c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8022fb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    

00802306 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80230c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802311:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802315:	75 07                	jne    80231e <devcons_read+0x18>
  802317:	eb 2a                	jmp    802343 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802319:	e8 56 e9 ff ff       	call   800c74 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80231e:	66 90                	xchg   %ax,%ax
  802320:	e8 bf e8 ff ff       	call   800be4 <sys_cgetc>
  802325:	85 c0                	test   %eax,%eax
  802327:	74 f0                	je     802319 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802329:	85 c0                	test   %eax,%eax
  80232b:	78 16                	js     802343 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80232d:	83 f8 04             	cmp    $0x4,%eax
  802330:	74 0c                	je     80233e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802332:	8b 55 0c             	mov    0xc(%ebp),%edx
  802335:	88 02                	mov    %al,(%edx)
	return 1;
  802337:	b8 01 00 00 00       	mov    $0x1,%eax
  80233c:	eb 05                	jmp    802343 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802351:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802358:	00 
  802359:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80235c:	89 04 24             	mov    %eax,(%esp)
  80235f:	e8 62 e8 ff ff       	call   800bc6 <sys_cputs>
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <getchar>:

int
getchar(void)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80236c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802373:	00 
  802374:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802382:	e8 f3 f0 ff ff       	call   80147a <read>
	if (r < 0)
  802387:	85 c0                	test   %eax,%eax
  802389:	78 0f                	js     80239a <getchar+0x34>
		return r;
	if (r < 1)
  80238b:	85 c0                	test   %eax,%eax
  80238d:	7e 06                	jle    802395 <getchar+0x2f>
		return -E_EOF;
	return c;
  80238f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802393:	eb 05                	jmp    80239a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802395:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	89 04 24             	mov    %eax,(%esp)
  8023af:	e8 32 ee ff ff       	call   8011e6 <fd_lookup>
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	78 11                	js     8023c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023c1:	39 10                	cmp    %edx,(%eax)
  8023c3:	0f 94 c0             	sete   %al
  8023c6:	0f b6 c0             	movzbl %al,%eax
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <opencons>:

int
opencons(void)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d4:	89 04 24             	mov    %eax,(%esp)
  8023d7:	e8 bb ed ff ff       	call   801197 <fd_alloc>
		return r;
  8023dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	78 40                	js     802422 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023e9:	00 
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f8:	e8 96 e8 ff ff       	call   800c93 <sys_page_alloc>
		return r;
  8023fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023ff:	85 c0                	test   %eax,%eax
  802401:	78 1f                	js     802422 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802403:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802418:	89 04 24             	mov    %eax,(%esp)
  80241b:	e8 50 ed ff ff       	call   801170 <fd2num>
  802420:	89 c2                	mov    %eax,%edx
}
  802422:	89 d0                	mov    %edx,%eax
  802424:	c9                   	leave  
  802425:	c3                   	ret    
  802426:	66 90                	xchg   %ax,%ax
  802428:	66 90                	xchg   %ax,%ax
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	66 90                	xchg   %ax,%ax
  80242e:	66 90                	xchg   %ax,%ax

00802430 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	56                   	push   %esi
  802434:	53                   	push   %ebx
  802435:	83 ec 10             	sub    $0x10,%esp
  802438:	8b 75 08             	mov    0x8(%ebp),%esi
  80243b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802441:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802443:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802448:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80244b:	89 04 24             	mov    %eax,(%esp)
  80244e:	e8 56 ea ff ff       	call   800ea9 <sys_ipc_recv>
  802453:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802455:	85 d2                	test   %edx,%edx
  802457:	75 24                	jne    80247d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802459:	85 f6                	test   %esi,%esi
  80245b:	74 0a                	je     802467 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80245d:	a1 08 40 80 00       	mov    0x804008,%eax
  802462:	8b 40 74             	mov    0x74(%eax),%eax
  802465:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802467:	85 db                	test   %ebx,%ebx
  802469:	74 0a                	je     802475 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80246b:	a1 08 40 80 00       	mov    0x804008,%eax
  802470:	8b 40 78             	mov    0x78(%eax),%eax
  802473:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802475:	a1 08 40 80 00       	mov    0x804008,%eax
  80247a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80247d:	83 c4 10             	add    $0x10,%esp
  802480:	5b                   	pop    %ebx
  802481:	5e                   	pop    %esi
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    

00802484 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	57                   	push   %edi
  802488:	56                   	push   %esi
  802489:	53                   	push   %ebx
  80248a:	83 ec 1c             	sub    $0x1c,%esp
  80248d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802490:	8b 75 0c             	mov    0xc(%ebp),%esi
  802493:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802496:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802498:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80249d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8024a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024af:	89 3c 24             	mov    %edi,(%esp)
  8024b2:	e8 cf e9 ff ff       	call   800e86 <sys_ipc_try_send>

		if (ret == 0)
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	74 2c                	je     8024e7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8024bb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024be:	74 20                	je     8024e0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8024c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c4:	c7 44 24 08 a4 2d 80 	movl   $0x802da4,0x8(%esp)
  8024cb:	00 
  8024cc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8024d3:	00 
  8024d4:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  8024db:	e8 79 dc ff ff       	call   800159 <_panic>
		}

		sys_yield();
  8024e0:	e8 8f e7 ff ff       	call   800c74 <sys_yield>
	}
  8024e5:	eb b9                	jmp    8024a0 <ipc_send+0x1c>
}
  8024e7:	83 c4 1c             	add    $0x1c,%esp
  8024ea:	5b                   	pop    %ebx
  8024eb:	5e                   	pop    %esi
  8024ec:	5f                   	pop    %edi
  8024ed:	5d                   	pop    %ebp
  8024ee:	c3                   	ret    

008024ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024f5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024fa:	89 c2                	mov    %eax,%edx
  8024fc:	c1 e2 07             	shl    $0x7,%edx
  8024ff:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802506:	8b 52 50             	mov    0x50(%edx),%edx
  802509:	39 ca                	cmp    %ecx,%edx
  80250b:	75 11                	jne    80251e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80250d:	89 c2                	mov    %eax,%edx
  80250f:	c1 e2 07             	shl    $0x7,%edx
  802512:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802519:	8b 40 40             	mov    0x40(%eax),%eax
  80251c:	eb 0e                	jmp    80252c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80251e:	83 c0 01             	add    $0x1,%eax
  802521:	3d 00 04 00 00       	cmp    $0x400,%eax
  802526:	75 d2                	jne    8024fa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802528:	66 b8 00 00          	mov    $0x0,%ax
}
  80252c:	5d                   	pop    %ebp
  80252d:	c3                   	ret    

0080252e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802534:	89 d0                	mov    %edx,%eax
  802536:	c1 e8 16             	shr    $0x16,%eax
  802539:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802545:	f6 c1 01             	test   $0x1,%cl
  802548:	74 1d                	je     802567 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80254a:	c1 ea 0c             	shr    $0xc,%edx
  80254d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802554:	f6 c2 01             	test   $0x1,%dl
  802557:	74 0e                	je     802567 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802559:	c1 ea 0c             	shr    $0xc,%edx
  80255c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802563:	ef 
  802564:	0f b7 c0             	movzwl %ax,%eax
}
  802567:	5d                   	pop    %ebp
  802568:	c3                   	ret    
  802569:	66 90                	xchg   %ax,%ax
  80256b:	66 90                	xchg   %ax,%ax
  80256d:	66 90                	xchg   %ax,%ax
  80256f:	90                   	nop

00802570 <__udivdi3>:
  802570:	55                   	push   %ebp
  802571:	57                   	push   %edi
  802572:	56                   	push   %esi
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	8b 44 24 28          	mov    0x28(%esp),%eax
  80257a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80257e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802582:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802586:	85 c0                	test   %eax,%eax
  802588:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80258c:	89 ea                	mov    %ebp,%edx
  80258e:	89 0c 24             	mov    %ecx,(%esp)
  802591:	75 2d                	jne    8025c0 <__udivdi3+0x50>
  802593:	39 e9                	cmp    %ebp,%ecx
  802595:	77 61                	ja     8025f8 <__udivdi3+0x88>
  802597:	85 c9                	test   %ecx,%ecx
  802599:	89 ce                	mov    %ecx,%esi
  80259b:	75 0b                	jne    8025a8 <__udivdi3+0x38>
  80259d:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a2:	31 d2                	xor    %edx,%edx
  8025a4:	f7 f1                	div    %ecx
  8025a6:	89 c6                	mov    %eax,%esi
  8025a8:	31 d2                	xor    %edx,%edx
  8025aa:	89 e8                	mov    %ebp,%eax
  8025ac:	f7 f6                	div    %esi
  8025ae:	89 c5                	mov    %eax,%ebp
  8025b0:	89 f8                	mov    %edi,%eax
  8025b2:	f7 f6                	div    %esi
  8025b4:	89 ea                	mov    %ebp,%edx
  8025b6:	83 c4 0c             	add    $0xc,%esp
  8025b9:	5e                   	pop    %esi
  8025ba:	5f                   	pop    %edi
  8025bb:	5d                   	pop    %ebp
  8025bc:	c3                   	ret    
  8025bd:	8d 76 00             	lea    0x0(%esi),%esi
  8025c0:	39 e8                	cmp    %ebp,%eax
  8025c2:	77 24                	ja     8025e8 <__udivdi3+0x78>
  8025c4:	0f bd e8             	bsr    %eax,%ebp
  8025c7:	83 f5 1f             	xor    $0x1f,%ebp
  8025ca:	75 3c                	jne    802608 <__udivdi3+0x98>
  8025cc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8025d0:	39 34 24             	cmp    %esi,(%esp)
  8025d3:	0f 86 9f 00 00 00    	jbe    802678 <__udivdi3+0x108>
  8025d9:	39 d0                	cmp    %edx,%eax
  8025db:	0f 82 97 00 00 00    	jb     802678 <__udivdi3+0x108>
  8025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025e8:	31 d2                	xor    %edx,%edx
  8025ea:	31 c0                	xor    %eax,%eax
  8025ec:	83 c4 0c             	add    $0xc,%esp
  8025ef:	5e                   	pop    %esi
  8025f0:	5f                   	pop    %edi
  8025f1:	5d                   	pop    %ebp
  8025f2:	c3                   	ret    
  8025f3:	90                   	nop
  8025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025f8:	89 f8                	mov    %edi,%eax
  8025fa:	f7 f1                	div    %ecx
  8025fc:	31 d2                	xor    %edx,%edx
  8025fe:	83 c4 0c             	add    $0xc,%esp
  802601:	5e                   	pop    %esi
  802602:	5f                   	pop    %edi
  802603:	5d                   	pop    %ebp
  802604:	c3                   	ret    
  802605:	8d 76 00             	lea    0x0(%esi),%esi
  802608:	89 e9                	mov    %ebp,%ecx
  80260a:	8b 3c 24             	mov    (%esp),%edi
  80260d:	d3 e0                	shl    %cl,%eax
  80260f:	89 c6                	mov    %eax,%esi
  802611:	b8 20 00 00 00       	mov    $0x20,%eax
  802616:	29 e8                	sub    %ebp,%eax
  802618:	89 c1                	mov    %eax,%ecx
  80261a:	d3 ef                	shr    %cl,%edi
  80261c:	89 e9                	mov    %ebp,%ecx
  80261e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802622:	8b 3c 24             	mov    (%esp),%edi
  802625:	09 74 24 08          	or     %esi,0x8(%esp)
  802629:	89 d6                	mov    %edx,%esi
  80262b:	d3 e7                	shl    %cl,%edi
  80262d:	89 c1                	mov    %eax,%ecx
  80262f:	89 3c 24             	mov    %edi,(%esp)
  802632:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802636:	d3 ee                	shr    %cl,%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	d3 e2                	shl    %cl,%edx
  80263c:	89 c1                	mov    %eax,%ecx
  80263e:	d3 ef                	shr    %cl,%edi
  802640:	09 d7                	or     %edx,%edi
  802642:	89 f2                	mov    %esi,%edx
  802644:	89 f8                	mov    %edi,%eax
  802646:	f7 74 24 08          	divl   0x8(%esp)
  80264a:	89 d6                	mov    %edx,%esi
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	f7 24 24             	mull   (%esp)
  802651:	39 d6                	cmp    %edx,%esi
  802653:	89 14 24             	mov    %edx,(%esp)
  802656:	72 30                	jb     802688 <__udivdi3+0x118>
  802658:	8b 54 24 04          	mov    0x4(%esp),%edx
  80265c:	89 e9                	mov    %ebp,%ecx
  80265e:	d3 e2                	shl    %cl,%edx
  802660:	39 c2                	cmp    %eax,%edx
  802662:	73 05                	jae    802669 <__udivdi3+0xf9>
  802664:	3b 34 24             	cmp    (%esp),%esi
  802667:	74 1f                	je     802688 <__udivdi3+0x118>
  802669:	89 f8                	mov    %edi,%eax
  80266b:	31 d2                	xor    %edx,%edx
  80266d:	e9 7a ff ff ff       	jmp    8025ec <__udivdi3+0x7c>
  802672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802678:	31 d2                	xor    %edx,%edx
  80267a:	b8 01 00 00 00       	mov    $0x1,%eax
  80267f:	e9 68 ff ff ff       	jmp    8025ec <__udivdi3+0x7c>
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	8d 47 ff             	lea    -0x1(%edi),%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	83 c4 0c             	add    $0xc,%esp
  802690:	5e                   	pop    %esi
  802691:	5f                   	pop    %edi
  802692:	5d                   	pop    %ebp
  802693:	c3                   	ret    
  802694:	66 90                	xchg   %ax,%ax
  802696:	66 90                	xchg   %ax,%ax
  802698:	66 90                	xchg   %ax,%ax
  80269a:	66 90                	xchg   %ax,%ax
  80269c:	66 90                	xchg   %ax,%ax
  80269e:	66 90                	xchg   %ax,%ax

008026a0 <__umoddi3>:
  8026a0:	55                   	push   %ebp
  8026a1:	57                   	push   %edi
  8026a2:	56                   	push   %esi
  8026a3:	83 ec 14             	sub    $0x14,%esp
  8026a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026aa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026ae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8026b2:	89 c7                	mov    %eax,%edi
  8026b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8026bc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8026c0:	89 34 24             	mov    %esi,(%esp)
  8026c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	89 c2                	mov    %eax,%edx
  8026cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026cf:	75 17                	jne    8026e8 <__umoddi3+0x48>
  8026d1:	39 fe                	cmp    %edi,%esi
  8026d3:	76 4b                	jbe    802720 <__umoddi3+0x80>
  8026d5:	89 c8                	mov    %ecx,%eax
  8026d7:	89 fa                	mov    %edi,%edx
  8026d9:	f7 f6                	div    %esi
  8026db:	89 d0                	mov    %edx,%eax
  8026dd:	31 d2                	xor    %edx,%edx
  8026df:	83 c4 14             	add    $0x14,%esp
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	66 90                	xchg   %ax,%ax
  8026e8:	39 f8                	cmp    %edi,%eax
  8026ea:	77 54                	ja     802740 <__umoddi3+0xa0>
  8026ec:	0f bd e8             	bsr    %eax,%ebp
  8026ef:	83 f5 1f             	xor    $0x1f,%ebp
  8026f2:	75 5c                	jne    802750 <__umoddi3+0xb0>
  8026f4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8026f8:	39 3c 24             	cmp    %edi,(%esp)
  8026fb:	0f 87 e7 00 00 00    	ja     8027e8 <__umoddi3+0x148>
  802701:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802705:	29 f1                	sub    %esi,%ecx
  802707:	19 c7                	sbb    %eax,%edi
  802709:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80270d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802711:	8b 44 24 08          	mov    0x8(%esp),%eax
  802715:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802719:	83 c4 14             	add    $0x14,%esp
  80271c:	5e                   	pop    %esi
  80271d:	5f                   	pop    %edi
  80271e:	5d                   	pop    %ebp
  80271f:	c3                   	ret    
  802720:	85 f6                	test   %esi,%esi
  802722:	89 f5                	mov    %esi,%ebp
  802724:	75 0b                	jne    802731 <__umoddi3+0x91>
  802726:	b8 01 00 00 00       	mov    $0x1,%eax
  80272b:	31 d2                	xor    %edx,%edx
  80272d:	f7 f6                	div    %esi
  80272f:	89 c5                	mov    %eax,%ebp
  802731:	8b 44 24 04          	mov    0x4(%esp),%eax
  802735:	31 d2                	xor    %edx,%edx
  802737:	f7 f5                	div    %ebp
  802739:	89 c8                	mov    %ecx,%eax
  80273b:	f7 f5                	div    %ebp
  80273d:	eb 9c                	jmp    8026db <__umoddi3+0x3b>
  80273f:	90                   	nop
  802740:	89 c8                	mov    %ecx,%eax
  802742:	89 fa                	mov    %edi,%edx
  802744:	83 c4 14             	add    $0x14,%esp
  802747:	5e                   	pop    %esi
  802748:	5f                   	pop    %edi
  802749:	5d                   	pop    %ebp
  80274a:	c3                   	ret    
  80274b:	90                   	nop
  80274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802750:	8b 04 24             	mov    (%esp),%eax
  802753:	be 20 00 00 00       	mov    $0x20,%esi
  802758:	89 e9                	mov    %ebp,%ecx
  80275a:	29 ee                	sub    %ebp,%esi
  80275c:	d3 e2                	shl    %cl,%edx
  80275e:	89 f1                	mov    %esi,%ecx
  802760:	d3 e8                	shr    %cl,%eax
  802762:	89 e9                	mov    %ebp,%ecx
  802764:	89 44 24 04          	mov    %eax,0x4(%esp)
  802768:	8b 04 24             	mov    (%esp),%eax
  80276b:	09 54 24 04          	or     %edx,0x4(%esp)
  80276f:	89 fa                	mov    %edi,%edx
  802771:	d3 e0                	shl    %cl,%eax
  802773:	89 f1                	mov    %esi,%ecx
  802775:	89 44 24 08          	mov    %eax,0x8(%esp)
  802779:	8b 44 24 10          	mov    0x10(%esp),%eax
  80277d:	d3 ea                	shr    %cl,%edx
  80277f:	89 e9                	mov    %ebp,%ecx
  802781:	d3 e7                	shl    %cl,%edi
  802783:	89 f1                	mov    %esi,%ecx
  802785:	d3 e8                	shr    %cl,%eax
  802787:	89 e9                	mov    %ebp,%ecx
  802789:	09 f8                	or     %edi,%eax
  80278b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80278f:	f7 74 24 04          	divl   0x4(%esp)
  802793:	d3 e7                	shl    %cl,%edi
  802795:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802799:	89 d7                	mov    %edx,%edi
  80279b:	f7 64 24 08          	mull   0x8(%esp)
  80279f:	39 d7                	cmp    %edx,%edi
  8027a1:	89 c1                	mov    %eax,%ecx
  8027a3:	89 14 24             	mov    %edx,(%esp)
  8027a6:	72 2c                	jb     8027d4 <__umoddi3+0x134>
  8027a8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8027ac:	72 22                	jb     8027d0 <__umoddi3+0x130>
  8027ae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8027b2:	29 c8                	sub    %ecx,%eax
  8027b4:	19 d7                	sbb    %edx,%edi
  8027b6:	89 e9                	mov    %ebp,%ecx
  8027b8:	89 fa                	mov    %edi,%edx
  8027ba:	d3 e8                	shr    %cl,%eax
  8027bc:	89 f1                	mov    %esi,%ecx
  8027be:	d3 e2                	shl    %cl,%edx
  8027c0:	89 e9                	mov    %ebp,%ecx
  8027c2:	d3 ef                	shr    %cl,%edi
  8027c4:	09 d0                	or     %edx,%eax
  8027c6:	89 fa                	mov    %edi,%edx
  8027c8:	83 c4 14             	add    $0x14,%esp
  8027cb:	5e                   	pop    %esi
  8027cc:	5f                   	pop    %edi
  8027cd:	5d                   	pop    %ebp
  8027ce:	c3                   	ret    
  8027cf:	90                   	nop
  8027d0:	39 d7                	cmp    %edx,%edi
  8027d2:	75 da                	jne    8027ae <__umoddi3+0x10e>
  8027d4:	8b 14 24             	mov    (%esp),%edx
  8027d7:	89 c1                	mov    %eax,%ecx
  8027d9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8027dd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8027e1:	eb cb                	jmp    8027ae <__umoddi3+0x10e>
  8027e3:	90                   	nop
  8027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027e8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8027ec:	0f 82 0f ff ff ff    	jb     802701 <__umoddi3+0x61>
  8027f2:	e9 1a ff ff ff       	jmp    802711 <__umoddi3+0x71>
