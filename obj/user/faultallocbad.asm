
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
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
  80004a:	e8 ef 01 00 00       	call   80023e <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 15 0c 00 00       	call   800c83 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 20 28 80 	movl   $0x802820,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 0a 28 80 00 	movl   $0x80280a,(%esp)
  800091:	e8 af 00 00 00       	call   800145 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 4c 28 80 	movl   $0x80284c,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 48 07 00 00       	call   8007fa <snprintf>
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
  8000c5:	e8 de 0f 00 00       	call   8010a8 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ca:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000d1:	00 
  8000d2:	c7 04 24 ef be ad de 	movl   $0xdeadbeef,(%esp)
  8000d9:	e8 d8 0a 00 00       	call   800bb6 <sys_cputs>
}
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 10             	sub    $0x10,%esp
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8000ee:	e8 52 0b 00 00       	call   800c45 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	89 c2                	mov    %eax,%edx
  8000fa:	c1 e2 07             	shl    $0x7,%edx
  8000fd:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800104:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800109:	85 db                	test   %ebx,%ebx
  80010b:	7e 07                	jle    800114 <libmain+0x34>
		binaryname = argv[0];
  80010d:	8b 06                	mov    (%esi),%eax
  80010f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800114:	89 74 24 04          	mov    %esi,0x4(%esp)
  800118:	89 1c 24             	mov    %ebx,(%esp)
  80011b:	e8 98 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800120:	e8 07 00 00 00       	call   80012c <exit>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5d                   	pop    %ebp
  80012b:	c3                   	ret    

0080012c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800132:	e8 03 12 00 00       	call   80133a <close_all>
	sys_env_destroy(0);
  800137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80013e:	e8 b0 0a 00 00       	call   800bf3 <sys_env_destroy>
}
  800143:	c9                   	leave  
  800144:	c3                   	ret    

00800145 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	56                   	push   %esi
  800149:	53                   	push   %ebx
  80014a:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80014d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800150:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800156:	e8 ea 0a 00 00       	call   800c45 <sys_getenvid>
  80015b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80015e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800162:	8b 55 08             	mov    0x8(%ebp),%edx
  800165:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800169:	89 74 24 08          	mov    %esi,0x8(%esp)
  80016d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800171:	c7 04 24 78 28 80 00 	movl   $0x802878,(%esp)
  800178:	e8 c1 00 00 00       	call   80023e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800181:	8b 45 10             	mov    0x10(%ebp),%eax
  800184:	89 04 24             	mov    %eax,(%esp)
  800187:	e8 51 00 00 00       	call   8001dd <vcprintf>
	cprintf("\n");
  80018c:	c7 04 24 90 2d 80 00 	movl   $0x802d90,(%esp)
  800193:	e8 a6 00 00 00       	call   80023e <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800198:	cc                   	int3   
  800199:	eb fd                	jmp    800198 <_panic+0x53>

0080019b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	53                   	push   %ebx
  80019f:	83 ec 14             	sub    $0x14,%esp
  8001a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a5:	8b 13                	mov    (%ebx),%edx
  8001a7:	8d 42 01             	lea    0x1(%edx),%eax
  8001aa:	89 03                	mov    %eax,(%ebx)
  8001ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001af:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b8:	75 19                	jne    8001d3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ba:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001c1:	00 
  8001c2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c5:	89 04 24             	mov    %eax,(%esp)
  8001c8:	e8 e9 09 00 00       	call   800bb6 <sys_cputs>
		b->idx = 0;
  8001cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001d3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d7:	83 c4 14             	add    $0x14,%esp
  8001da:	5b                   	pop    %ebx
  8001db:	5d                   	pop    %ebp
  8001dc:	c3                   	ret    

008001dd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ed:	00 00 00 
	b.cnt = 0;
  8001f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800201:	8b 45 08             	mov    0x8(%ebp),%eax
  800204:	89 44 24 08          	mov    %eax,0x8(%esp)
  800208:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800212:	c7 04 24 9b 01 80 00 	movl   $0x80019b,(%esp)
  800219:	e8 b0 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80021e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800224:	89 44 24 04          	mov    %eax,0x4(%esp)
  800228:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022e:	89 04 24             	mov    %eax,(%esp)
  800231:	e8 80 09 00 00       	call   800bb6 <sys_cputs>

	return b.cnt;
}
  800236:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023c:	c9                   	leave  
  80023d:	c3                   	ret    

0080023e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023e:	55                   	push   %ebp
  80023f:	89 e5                	mov    %esp,%ebp
  800241:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800244:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	8b 45 08             	mov    0x8(%ebp),%eax
  80024e:	89 04 24             	mov    %eax,(%esp)
  800251:	e8 87 ff ff ff       	call   8001dd <vcprintf>
	va_end(ap);

	return cnt;
}
  800256:	c9                   	leave  
  800257:	c3                   	ret    
  800258:	66 90                	xchg   %ax,%ax
  80025a:	66 90                	xchg   %ax,%ax
  80025c:	66 90                	xchg   %ax,%ax
  80025e:	66 90                	xchg   %ax,%ax

00800260 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 3c             	sub    $0x3c,%esp
  800269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80026c:	89 d7                	mov    %edx,%edi
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
  800277:	89 c3                	mov    %eax,%ebx
  800279:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80027c:	8b 45 10             	mov    0x10(%ebp),%eax
  80027f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
  800287:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80028d:	39 d9                	cmp    %ebx,%ecx
  80028f:	72 05                	jb     800296 <printnum+0x36>
  800291:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800294:	77 69                	ja     8002ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800296:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800299:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80029d:	83 ee 01             	sub    $0x1,%esi
  8002a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002b0:	89 c3                	mov    %eax,%ebx
  8002b2:	89 d6                	mov    %edx,%esi
  8002b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c5:	89 04 24             	mov    %eax,(%esp)
  8002c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	e8 8c 22 00 00       	call   802560 <__udivdi3>
  8002d4:	89 d9                	mov    %ebx,%ecx
  8002d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002de:	89 04 24             	mov    %eax,(%esp)
  8002e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e5:	89 fa                	mov    %edi,%edx
  8002e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ea:	e8 71 ff ff ff       	call   800260 <printnum>
  8002ef:	eb 1b                	jmp    80030c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f8:	89 04 24             	mov    %eax,(%esp)
  8002fb:	ff d3                	call   *%ebx
  8002fd:	eb 03                	jmp    800302 <printnum+0xa2>
  8002ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800302:	83 ee 01             	sub    $0x1,%esi
  800305:	85 f6                	test   %esi,%esi
  800307:	7f e8                	jg     8002f1 <printnum+0x91>
  800309:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80030c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800310:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800317:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80031a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	e8 5c 23 00 00       	call   802690 <__umoddi3>
  800334:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800338:	0f be 80 9b 28 80 00 	movsbl 0x80289b(%eax),%eax
  80033f:	89 04 24             	mov    %eax,(%esp)
  800342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800345:	ff d0                	call   *%eax
}
  800347:	83 c4 3c             	add    $0x3c,%esp
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800352:	83 fa 01             	cmp    $0x1,%edx
  800355:	7e 0e                	jle    800365 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800357:	8b 10                	mov    (%eax),%edx
  800359:	8d 4a 08             	lea    0x8(%edx),%ecx
  80035c:	89 08                	mov    %ecx,(%eax)
  80035e:	8b 02                	mov    (%edx),%eax
  800360:	8b 52 04             	mov    0x4(%edx),%edx
  800363:	eb 22                	jmp    800387 <getuint+0x38>
	else if (lflag)
  800365:	85 d2                	test   %edx,%edx
  800367:	74 10                	je     800379 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800369:	8b 10                	mov    (%eax),%edx
  80036b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80036e:	89 08                	mov    %ecx,(%eax)
  800370:	8b 02                	mov    (%edx),%eax
  800372:	ba 00 00 00 00       	mov    $0x0,%edx
  800377:	eb 0e                	jmp    800387 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800387:	5d                   	pop    %ebp
  800388:	c3                   	ret    

00800389 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800393:	8b 10                	mov    (%eax),%edx
  800395:	3b 50 04             	cmp    0x4(%eax),%edx
  800398:	73 0a                	jae    8003a4 <sprintputch+0x1b>
		*b->buf++ = ch;
  80039a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80039d:	89 08                	mov    %ecx,(%eax)
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	88 02                	mov    %al,(%edx)
}
  8003a4:	5d                   	pop    %ebp
  8003a5:	c3                   	ret    

008003a6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	89 04 24             	mov    %eax,(%esp)
  8003c7:	e8 02 00 00 00       	call   8003ce <vprintfmt>
	va_end(ap);
}
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 3c             	sub    $0x3c,%esp
  8003d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003dd:	eb 14                	jmp    8003f3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	0f 84 b3 03 00 00    	je     80079a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003eb:	89 04 24             	mov    %eax,(%esp)
  8003ee:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003f1:	89 f3                	mov    %esi,%ebx
  8003f3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003f6:	0f b6 03             	movzbl (%ebx),%eax
  8003f9:	83 f8 25             	cmp    $0x25,%eax
  8003fc:	75 e1                	jne    8003df <vprintfmt+0x11>
  8003fe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800410:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
  80041c:	eb 1d                	jmp    80043b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800420:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800424:	eb 15                	jmp    80043b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800426:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800428:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80042c:	eb 0d                	jmp    80043b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80042e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800431:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800434:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80043e:	0f b6 0e             	movzbl (%esi),%ecx
  800441:	0f b6 c1             	movzbl %cl,%eax
  800444:	83 e9 23             	sub    $0x23,%ecx
  800447:	80 f9 55             	cmp    $0x55,%cl
  80044a:	0f 87 2a 03 00 00    	ja     80077a <vprintfmt+0x3ac>
  800450:	0f b6 c9             	movzbl %cl,%ecx
  800453:	ff 24 8d 20 2a 80 00 	jmp    *0x802a20(,%ecx,4)
  80045a:	89 de                	mov    %ebx,%esi
  80045c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800461:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800464:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800468:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80046b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80046e:	83 fb 09             	cmp    $0x9,%ebx
  800471:	77 36                	ja     8004a9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800473:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800476:	eb e9                	jmp    800461 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 48 04             	lea    0x4(%eax),%ecx
  80047e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800486:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800488:	eb 22                	jmp    8004ac <vprintfmt+0xde>
  80048a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80048d:	85 c9                	test   %ecx,%ecx
  80048f:	b8 00 00 00 00       	mov    $0x0,%eax
  800494:	0f 49 c1             	cmovns %ecx,%eax
  800497:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	89 de                	mov    %ebx,%esi
  80049c:	eb 9d                	jmp    80043b <vprintfmt+0x6d>
  80049e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004a0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004a7:	eb 92                	jmp    80043b <vprintfmt+0x6d>
  8004a9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004b0:	79 89                	jns    80043b <vprintfmt+0x6d>
  8004b2:	e9 77 ff ff ff       	jmp    80042e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004b7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004bc:	e9 7a ff ff ff       	jmp    80043b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8d 50 04             	lea    0x4(%eax),%edx
  8004c7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	89 04 24             	mov    %eax,(%esp)
  8004d3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004d6:	e9 18 ff ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	99                   	cltd   
  8004e7:	31 d0                	xor    %edx,%eax
  8004e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004eb:	83 f8 12             	cmp    $0x12,%eax
  8004ee:	7f 0b                	jg     8004fb <vprintfmt+0x12d>
  8004f0:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	75 20                	jne    80051b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ff:	c7 44 24 08 b3 28 80 	movl   $0x8028b3,0x8(%esp)
  800506:	00 
  800507:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	e8 90 fe ff ff       	call   8003a6 <printfmt>
  800516:	e9 d8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80051b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051f:	c7 44 24 08 25 2d 80 	movl   $0x802d25,0x8(%esp)
  800526:	00 
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	e8 70 fe ff ff       	call   8003a6 <printfmt>
  800536:	e9 b8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80053e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800541:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 50 04             	lea    0x4(%eax),%edx
  80054a:	89 55 14             	mov    %edx,0x14(%ebp)
  80054d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80054f:	85 f6                	test   %esi,%esi
  800551:	b8 ac 28 80 00       	mov    $0x8028ac,%eax
  800556:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800559:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80055d:	0f 84 97 00 00 00    	je     8005fa <vprintfmt+0x22c>
  800563:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800567:	0f 8e 9b 00 00 00    	jle    800608 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800571:	89 34 24             	mov    %esi,(%esp)
  800574:	e8 cf 02 00 00       	call   800848 <strnlen>
  800579:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80057c:	29 c2                	sub    %eax,%edx
  80057e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800581:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800585:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800588:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800591:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	eb 0f                	jmp    8005a4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800595:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800599:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80059c:	89 04 24             	mov    %eax,(%esp)
  80059f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a1:	83 eb 01             	sub    $0x1,%ebx
  8005a4:	85 db                	test   %ebx,%ebx
  8005a6:	7f ed                	jg     800595 <vprintfmt+0x1c7>
  8005a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ae:	85 d2                	test   %edx,%edx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	0f 49 c2             	cmovns %edx,%eax
  8005b8:	29 c2                	sub    %eax,%edx
  8005ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bd:	89 d7                	mov    %edx,%edi
  8005bf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c2:	eb 50                	jmp    800614 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c8:	74 1e                	je     8005e8 <vprintfmt+0x21a>
  8005ca:	0f be d2             	movsbl %dl,%edx
  8005cd:	83 ea 20             	sub    $0x20,%edx
  8005d0:	83 fa 5e             	cmp    $0x5e,%edx
  8005d3:	76 13                	jbe    8005e8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
  8005e6:	eb 0d                	jmp    8005f5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ef:	89 04 24             	mov    %eax,(%esp)
  8005f2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f5:	83 ef 01             	sub    $0x1,%edi
  8005f8:	eb 1a                	jmp    800614 <vprintfmt+0x246>
  8005fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005fd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800600:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800603:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800606:	eb 0c                	jmp    800614 <vprintfmt+0x246>
  800608:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80060b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80060e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800611:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800614:	83 c6 01             	add    $0x1,%esi
  800617:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80061b:	0f be c2             	movsbl %dl,%eax
  80061e:	85 c0                	test   %eax,%eax
  800620:	74 27                	je     800649 <vprintfmt+0x27b>
  800622:	85 db                	test   %ebx,%ebx
  800624:	78 9e                	js     8005c4 <vprintfmt+0x1f6>
  800626:	83 eb 01             	sub    $0x1,%ebx
  800629:	79 99                	jns    8005c4 <vprintfmt+0x1f6>
  80062b:	89 f8                	mov    %edi,%eax
  80062d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800630:	8b 75 08             	mov    0x8(%ebp),%esi
  800633:	89 c3                	mov    %eax,%ebx
  800635:	eb 1a                	jmp    800651 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800642:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800644:	83 eb 01             	sub    $0x1,%ebx
  800647:	eb 08                	jmp    800651 <vprintfmt+0x283>
  800649:	89 fb                	mov    %edi,%ebx
  80064b:	8b 75 08             	mov    0x8(%ebp),%esi
  80064e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800651:	85 db                	test   %ebx,%ebx
  800653:	7f e2                	jg     800637 <vprintfmt+0x269>
  800655:	89 75 08             	mov    %esi,0x8(%ebp)
  800658:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80065b:	e9 93 fd ff ff       	jmp    8003f3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800660:	83 fa 01             	cmp    $0x1,%edx
  800663:	7e 16                	jle    80067b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 50 08             	lea    0x8(%eax),%edx
  80066b:	89 55 14             	mov    %edx,0x14(%ebp)
  80066e:	8b 50 04             	mov    0x4(%eax),%edx
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800676:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800679:	eb 32                	jmp    8006ad <vprintfmt+0x2df>
	else if (lflag)
  80067b:	85 d2                	test   %edx,%edx
  80067d:	74 18                	je     800697 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	89 55 14             	mov    %edx,0x14(%ebp)
  800688:	8b 30                	mov    (%eax),%esi
  80068a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80068d:	89 f0                	mov    %esi,%eax
  80068f:	c1 f8 1f             	sar    $0x1f,%eax
  800692:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800695:	eb 16                	jmp    8006ad <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 50 04             	lea    0x4(%eax),%edx
  80069d:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a0:	8b 30                	mov    (%eax),%esi
  8006a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006a5:	89 f0                	mov    %esi,%eax
  8006a7:	c1 f8 1f             	sar    $0x1f,%eax
  8006aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bc:	0f 89 80 00 00 00    	jns    800742 <vprintfmt+0x374>
				putch('-', putdat);
  8006c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006d6:	f7 d8                	neg    %eax
  8006d8:	83 d2 00             	adc    $0x0,%edx
  8006db:	f7 da                	neg    %edx
			}
			base = 10;
  8006dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e2:	eb 5e                	jmp    800742 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e7:	e8 63 fc ff ff       	call   80034f <getuint>
			base = 10;
  8006ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006f1:	eb 4f                	jmp    800742 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f6:	e8 54 fc ff ff       	call   80034f <getuint>
			base = 8;
  8006fb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800700:	eb 40                	jmp    800742 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800702:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800706:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80070d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800714:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80071b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 50 04             	lea    0x4(%eax),%edx
  800724:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80072e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800733:	eb 0d                	jmp    800742 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800735:	8d 45 14             	lea    0x14(%ebp),%eax
  800738:	e8 12 fc ff ff       	call   80034f <getuint>
			base = 16;
  80073d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800742:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800746:	89 74 24 10          	mov    %esi,0x10(%esp)
  80074a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80074d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800751:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800755:	89 04 24             	mov    %eax,(%esp)
  800758:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075c:	89 fa                	mov    %edi,%edx
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	e8 fa fa ff ff       	call   800260 <printnum>
			break;
  800766:	e9 88 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80076b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076f:	89 04 24             	mov    %eax,(%esp)
  800772:	ff 55 08             	call   *0x8(%ebp)
			break;
  800775:	e9 79 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80077a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800785:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800788:	89 f3                	mov    %esi,%ebx
  80078a:	eb 03                	jmp    80078f <vprintfmt+0x3c1>
  80078c:	83 eb 01             	sub    $0x1,%ebx
  80078f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800793:	75 f7                	jne    80078c <vprintfmt+0x3be>
  800795:	e9 59 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80079a:	83 c4 3c             	add    $0x3c,%esp
  80079d:	5b                   	pop    %ebx
  80079e:	5e                   	pop    %esi
  80079f:	5f                   	pop    %edi
  8007a0:	5d                   	pop    %ebp
  8007a1:	c3                   	ret    

008007a2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 28             	sub    $0x28,%esp
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	74 30                	je     8007f3 <vsnprintf+0x51>
  8007c3:	85 d2                	test   %edx,%edx
  8007c5:	7e 2c                	jle    8007f3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dc:	c7 04 24 89 03 80 00 	movl   $0x800389,(%esp)
  8007e3:	e8 e6 fb ff ff       	call   8003ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f1:	eb 05                	jmp    8007f8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800803:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	89 44 24 04          	mov    %eax,0x4(%esp)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 04 24             	mov    %eax,(%esp)
  80081b:	e8 82 ff ff ff       	call   8007a2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800820:	c9                   	leave  
  800821:	c3                   	ret    
  800822:	66 90                	xchg   %ax,%ax
  800824:	66 90                	xchg   %ax,%ax
  800826:	66 90                	xchg   %ax,%ax
  800828:	66 90                	xchg   %ax,%ax
  80082a:	66 90                	xchg   %ax,%ax
  80082c:	66 90                	xchg   %ax,%ax
  80082e:	66 90                	xchg   %ax,%ax

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	eb 03                	jmp    800840 <strlen+0x10>
		n++;
  80083d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800840:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800844:	75 f7                	jne    80083d <strlen+0xd>
		n++;
	return n;
}
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
  800856:	eb 03                	jmp    80085b <strnlen+0x13>
		n++;
  800858:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085b:	39 d0                	cmp    %edx,%eax
  80085d:	74 06                	je     800865 <strnlen+0x1d>
  80085f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800863:	75 f3                	jne    800858 <strnlen+0x10>
		n++;
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800871:	89 c2                	mov    %eax,%edx
  800873:	83 c2 01             	add    $0x1,%edx
  800876:	83 c1 01             	add    $0x1,%ecx
  800879:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80087d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800880:	84 db                	test   %bl,%bl
  800882:	75 ef                	jne    800873 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800884:	5b                   	pop    %ebx
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	53                   	push   %ebx
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800891:	89 1c 24             	mov    %ebx,(%esp)
  800894:	e8 97 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a0:	01 d8                	add    %ebx,%eax
  8008a2:	89 04 24             	mov    %eax,(%esp)
  8008a5:	e8 bd ff ff ff       	call   800867 <strcpy>
	return dst;
}
  8008aa:	89 d8                	mov    %ebx,%eax
  8008ac:	83 c4 08             	add    $0x8,%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bd:	89 f3                	mov    %esi,%ebx
  8008bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c2:	89 f2                	mov    %esi,%edx
  8008c4:	eb 0f                	jmp    8008d5 <strncpy+0x23>
		*dst++ = *src;
  8008c6:	83 c2 01             	add    $0x1,%edx
  8008c9:	0f b6 01             	movzbl (%ecx),%eax
  8008cc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008cf:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d5:	39 da                	cmp    %ebx,%edx
  8008d7:	75 ed                	jne    8008c6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008d9:	89 f0                	mov    %esi,%eax
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	56                   	push   %esi
  8008e3:	53                   	push   %ebx
  8008e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ed:	89 f0                	mov    %esi,%eax
  8008ef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	75 0b                	jne    800902 <strlcpy+0x23>
  8008f7:	eb 1d                	jmp    800916 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800902:	39 d8                	cmp    %ebx,%eax
  800904:	74 0b                	je     800911 <strlcpy+0x32>
  800906:	0f b6 0a             	movzbl (%edx),%ecx
  800909:	84 c9                	test   %cl,%cl
  80090b:	75 ec                	jne    8008f9 <strlcpy+0x1a>
  80090d:	89 c2                	mov    %eax,%edx
  80090f:	eb 02                	jmp    800913 <strlcpy+0x34>
  800911:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800913:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800916:	29 f0                	sub    %esi,%eax
}
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800925:	eb 06                	jmp    80092d <strcmp+0x11>
		p++, q++;
  800927:	83 c1 01             	add    $0x1,%ecx
  80092a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80092d:	0f b6 01             	movzbl (%ecx),%eax
  800930:	84 c0                	test   %al,%al
  800932:	74 04                	je     800938 <strcmp+0x1c>
  800934:	3a 02                	cmp    (%edx),%al
  800936:	74 ef                	je     800927 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800951:	eb 06                	jmp    800959 <strncmp+0x17>
		n--, p++, q++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800959:	39 d8                	cmp    %ebx,%eax
  80095b:	74 15                	je     800972 <strncmp+0x30>
  80095d:	0f b6 08             	movzbl (%eax),%ecx
  800960:	84 c9                	test   %cl,%cl
  800962:	74 04                	je     800968 <strncmp+0x26>
  800964:	3a 0a                	cmp    (%edx),%cl
  800966:	74 eb                	je     800953 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
  800970:	eb 05                	jmp    800977 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800977:	5b                   	pop    %ebx
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800984:	eb 07                	jmp    80098d <strchr+0x13>
		if (*s == c)
  800986:	38 ca                	cmp    %cl,%dl
  800988:	74 0f                	je     800999 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	0f b6 10             	movzbl (%eax),%edx
  800990:	84 d2                	test   %dl,%dl
  800992:	75 f2                	jne    800986 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a5:	eb 07                	jmp    8009ae <strfind+0x13>
		if (*s == c)
  8009a7:	38 ca                	cmp    %cl,%dl
  8009a9:	74 0a                	je     8009b5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	0f b6 10             	movzbl (%eax),%edx
  8009b1:	84 d2                	test   %dl,%dl
  8009b3:	75 f2                	jne    8009a7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	57                   	push   %edi
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	74 36                	je     8009fd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009cd:	75 28                	jne    8009f7 <memset+0x40>
  8009cf:	f6 c1 03             	test   $0x3,%cl
  8009d2:	75 23                	jne    8009f7 <memset+0x40>
		c &= 0xFF;
  8009d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d8:	89 d3                	mov    %edx,%ebx
  8009da:	c1 e3 08             	shl    $0x8,%ebx
  8009dd:	89 d6                	mov    %edx,%esi
  8009df:	c1 e6 18             	shl    $0x18,%esi
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	c1 e0 10             	shl    $0x10,%eax
  8009e7:	09 f0                	or     %esi,%eax
  8009e9:	09 c2                	or     %eax,%edx
  8009eb:	89 d0                	mov    %edx,%eax
  8009ed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009f2:	fc                   	cld    
  8009f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f5:	eb 06                	jmp    8009fd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	fc                   	cld    
  8009fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	57                   	push   %edi
  800a08:	56                   	push   %esi
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a12:	39 c6                	cmp    %eax,%esi
  800a14:	73 35                	jae    800a4b <memmove+0x47>
  800a16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	73 2e                	jae    800a4b <memmove+0x47>
		s += n;
		d += n;
  800a1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a20:	89 d6                	mov    %edx,%esi
  800a22:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2a:	75 13                	jne    800a3f <memmove+0x3b>
  800a2c:	f6 c1 03             	test   $0x3,%cl
  800a2f:	75 0e                	jne    800a3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a31:	83 ef 04             	sub    $0x4,%edi
  800a34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a37:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a3a:	fd                   	std    
  800a3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3d:	eb 09                	jmp    800a48 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3f:	83 ef 01             	sub    $0x1,%edi
  800a42:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a45:	fd                   	std    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a48:	fc                   	cld    
  800a49:	eb 1d                	jmp    800a68 <memmove+0x64>
  800a4b:	89 f2                	mov    %esi,%edx
  800a4d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4f:	f6 c2 03             	test   $0x3,%dl
  800a52:	75 0f                	jne    800a63 <memmove+0x5f>
  800a54:	f6 c1 03             	test   $0x3,%cl
  800a57:	75 0a                	jne    800a63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a59:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb 05                	jmp    800a68 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
  800a75:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 04 24             	mov    %eax,(%esp)
  800a86:	e8 79 ff ff ff       	call   800a04 <memmove>
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a98:	89 d6                	mov    %edx,%esi
  800a9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9d:	eb 1a                	jmp    800ab9 <memcmp+0x2c>
		if (*s1 != *s2)
  800a9f:	0f b6 02             	movzbl (%edx),%eax
  800aa2:	0f b6 19             	movzbl (%ecx),%ebx
  800aa5:	38 d8                	cmp    %bl,%al
  800aa7:	74 0a                	je     800ab3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800aa9:	0f b6 c0             	movzbl %al,%eax
  800aac:	0f b6 db             	movzbl %bl,%ebx
  800aaf:	29 d8                	sub    %ebx,%eax
  800ab1:	eb 0f                	jmp    800ac2 <memcmp+0x35>
		s1++, s2++;
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ab9:	39 f2                	cmp    %esi,%edx
  800abb:	75 e2                	jne    800a9f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800abd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad4:	eb 07                	jmp    800add <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad6:	38 08                	cmp    %cl,(%eax)
  800ad8:	74 07                	je     800ae1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	39 d0                	cmp    %edx,%eax
  800adf:	72 f5                	jb     800ad6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	53                   	push   %ebx
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aef:	eb 03                	jmp    800af4 <strtol+0x11>
		s++;
  800af1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af4:	0f b6 0a             	movzbl (%edx),%ecx
  800af7:	80 f9 09             	cmp    $0x9,%cl
  800afa:	74 f5                	je     800af1 <strtol+0xe>
  800afc:	80 f9 20             	cmp    $0x20,%cl
  800aff:	74 f0                	je     800af1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b01:	80 f9 2b             	cmp    $0x2b,%cl
  800b04:	75 0a                	jne    800b10 <strtol+0x2d>
		s++;
  800b06:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b09:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0e:	eb 11                	jmp    800b21 <strtol+0x3e>
  800b10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b15:	80 f9 2d             	cmp    $0x2d,%cl
  800b18:	75 07                	jne    800b21 <strtol+0x3e>
		s++, neg = 1;
  800b1a:	8d 52 01             	lea    0x1(%edx),%edx
  800b1d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b21:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b26:	75 15                	jne    800b3d <strtol+0x5a>
  800b28:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2b:	75 10                	jne    800b3d <strtol+0x5a>
  800b2d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b31:	75 0a                	jne    800b3d <strtol+0x5a>
		s += 2, base = 16;
  800b33:	83 c2 02             	add    $0x2,%edx
  800b36:	b8 10 00 00 00       	mov    $0x10,%eax
  800b3b:	eb 10                	jmp    800b4d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	75 0c                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b41:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b43:	80 3a 30             	cmpb   $0x30,(%edx)
  800b46:	75 05                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
  800b48:	83 c2 01             	add    $0x1,%edx
  800b4b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b52:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b55:	0f b6 0a             	movzbl (%edx),%ecx
  800b58:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b5b:	89 f0                	mov    %esi,%eax
  800b5d:	3c 09                	cmp    $0x9,%al
  800b5f:	77 08                	ja     800b69 <strtol+0x86>
			dig = *s - '0';
  800b61:	0f be c9             	movsbl %cl,%ecx
  800b64:	83 e9 30             	sub    $0x30,%ecx
  800b67:	eb 20                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b69:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b6c:	89 f0                	mov    %esi,%eax
  800b6e:	3c 19                	cmp    $0x19,%al
  800b70:	77 08                	ja     800b7a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b72:	0f be c9             	movsbl %cl,%ecx
  800b75:	83 e9 57             	sub    $0x57,%ecx
  800b78:	eb 0f                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b7a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	3c 19                	cmp    $0x19,%al
  800b81:	77 16                	ja     800b99 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b83:	0f be c9             	movsbl %cl,%ecx
  800b86:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b89:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b8c:	7d 0f                	jge    800b9d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b95:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b97:	eb bc                	jmp    800b55 <strtol+0x72>
  800b99:	89 d8                	mov    %ebx,%eax
  800b9b:	eb 02                	jmp    800b9f <strtol+0xbc>
  800b9d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba3:	74 05                	je     800baa <strtol+0xc7>
		*endptr = (char *) s;
  800ba5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800baa:	f7 d8                	neg    %eax
  800bac:	85 ff                	test   %edi,%edi
  800bae:	0f 44 c3             	cmove  %ebx,%eax
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bda:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdf:	b8 01 00 00 00       	mov    $0x1,%eax
  800be4:	89 d1                	mov    %edx,%ecx
  800be6:	89 d3                	mov    %edx,%ebx
  800be8:	89 d7                	mov    %edx,%edi
  800bea:	89 d6                	mov    %edx,%esi
  800bec:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c01:	b8 03 00 00 00       	mov    $0x3,%eax
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	89 cb                	mov    %ecx,%ebx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	89 ce                	mov    %ecx,%esi
  800c0f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7e 28                	jle    800c3d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c19:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c20:	00 
  800c21:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800c28:	00 
  800c29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c30:	00 
  800c31:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800c38:	e8 08 f5 ff ff       	call   800145 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3d:	83 c4 2c             	add    $0x2c,%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c50:	b8 02 00 00 00       	mov    $0x2,%eax
  800c55:	89 d1                	mov    %edx,%ecx
  800c57:	89 d3                	mov    %edx,%ebx
  800c59:	89 d7                	mov    %edx,%edi
  800c5b:	89 d6                	mov    %edx,%esi
  800c5d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <sys_yield>:

void
sys_yield(void)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c74:	89 d1                	mov    %edx,%ecx
  800c76:	89 d3                	mov    %edx,%ebx
  800c78:	89 d7                	mov    %edx,%edi
  800c7a:	89 d6                	mov    %edx,%esi
  800c7c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8c:	be 00 00 00 00       	mov    $0x0,%esi
  800c91:	b8 04 00 00 00       	mov    $0x4,%eax
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9f:	89 f7                	mov    %esi,%edi
  800ca1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	7e 28                	jle    800ccf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cb2:	00 
  800cb3:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800cba:	00 
  800cbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc2:	00 
  800cc3:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800cca:	e8 76 f4 ff ff       	call   800145 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ccf:	83 c4 2c             	add    $0x2c,%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7e 28                	jle    800d22 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cfe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d05:	00 
  800d06:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800d0d:	00 
  800d0e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d15:	00 
  800d16:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800d1d:	e8 23 f4 ff ff       	call   800145 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d22:	83 c4 2c             	add    $0x2c,%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7e 28                	jle    800d75 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d51:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d58:	00 
  800d59:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800d60:	00 
  800d61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d68:	00 
  800d69:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800d70:	e8 d0 f3 ff ff       	call   800145 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d75:	83 c4 2c             	add    $0x2c,%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	89 df                	mov    %ebx,%edi
  800d98:	89 de                	mov    %ebx,%esi
  800d9a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7e 28                	jle    800dc8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dab:	00 
  800dac:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800db3:	00 
  800db4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbb:	00 
  800dbc:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800dc3:	e8 7d f3 ff ff       	call   800145 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc8:	83 c4 2c             	add    $0x2c,%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dde:	b8 09 00 00 00       	mov    $0x9,%eax
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7e 28                	jle    800e1b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dfe:	00 
  800dff:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800e06:	00 
  800e07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0e:	00 
  800e0f:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800e16:	e8 2a f3 ff ff       	call   800145 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e1b:	83 c4 2c             	add    $0x2c,%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	89 df                	mov    %ebx,%edi
  800e3e:	89 de                	mov    %ebx,%esi
  800e40:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e42:	85 c0                	test   %eax,%eax
  800e44:	7e 28                	jle    800e6e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e51:	00 
  800e52:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800e59:	00 
  800e5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e61:	00 
  800e62:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800e69:	e8 d7 f2 ff ff       	call   800145 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e6e:	83 c4 2c             	add    $0x2c,%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7c:	be 00 00 00 00       	mov    $0x0,%esi
  800e81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e92:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	89 cb                	mov    %ecx,%ebx
  800eb1:	89 cf                	mov    %ecx,%edi
  800eb3:	89 ce                	mov    %ecx,%esi
  800eb5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7e 28                	jle    800ee3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ebf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ec6:	00 
  800ec7:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800ece:	00 
  800ecf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed6:	00 
  800ed7:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800ede:	e8 62 f2 ff ff       	call   800145 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ee3:	83 c4 2c             	add    $0x2c,%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800efb:	89 d1                	mov    %edx,%ecx
  800efd:	89 d3                	mov    %edx,%ebx
  800eff:	89 d7                	mov    %edx,%edi
  800f01:	89 d6                	mov    %edx,%esi
  800f03:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f18:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	89 df                	mov    %ebx,%edi
  800f25:	89 de                	mov    %ebx,%esi
  800f27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7e 28                	jle    800f55 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800f50:	e8 f0 f1 ff ff       	call   800145 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800f55:	83 c4 2c             	add    $0x2c,%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
  800f63:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	89 df                	mov    %ebx,%edi
  800f78:	89 de                	mov    %ebx,%esi
  800f7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	7e 28                	jle    800fa8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800fa3:	e8 9d f1 ff ff       	call   800145 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800fa8:	83 c4 2c             	add    $0x2c,%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbe:	b8 11 00 00 00       	mov    $0x11,%eax
  800fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	89 df                	mov    %ebx,%edi
  800fcb:	89 de                	mov    %ebx,%esi
  800fcd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	7e 28                	jle    800ffb <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800fde:	00 
  800fdf:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  800fe6:	00 
  800fe7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fee:	00 
  800fef:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800ff6:	e8 4a f1 ff ff       	call   800145 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  800ffb:	83 c4 2c             	add    $0x2c,%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_sleep>:

int
sys_sleep(int channel)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801011:	b8 12 00 00 00       	mov    $0x12,%eax
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	89 cb                	mov    %ecx,%ebx
  80101b:	89 cf                	mov    %ecx,%edi
  80101d:	89 ce                	mov    %ecx,%esi
  80101f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801021:	85 c0                	test   %eax,%eax
  801023:	7e 28                	jle    80104d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801025:	89 44 24 10          	mov    %eax,0x10(%esp)
  801029:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801030:	00 
  801031:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  801038:	00 
  801039:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801040:	00 
  801041:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  801048:	e8 f8 f0 ff ff       	call   800145 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80104d:	83 c4 2c             	add    $0x2c,%esp
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	57                   	push   %edi
  801059:	56                   	push   %esi
  80105a:	53                   	push   %ebx
  80105b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801063:	b8 13 00 00 00       	mov    $0x13,%eax
  801068:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	89 df                	mov    %ebx,%edi
  801070:	89 de                	mov    %ebx,%esi
  801072:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801074:	85 c0                	test   %eax,%eax
  801076:	7e 28                	jle    8010a0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801078:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801083:	00 
  801084:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  80108b:	00 
  80108c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801093:	00 
  801094:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  80109b:	e8 a5 f0 ff ff       	call   800145 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8010a0:	83 c4 2c             	add    $0x2c,%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8010ae:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  8010b5:	75 70                	jne    801127 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  8010b7:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  8010be:	00 
  8010bf:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8010c6:	ee 
  8010c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010ce:	e8 b0 fb ff ff       	call   800c83 <sys_page_alloc>
		if (error < 0)
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	79 1c                	jns    8010f3 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  8010d7:	c7 44 24 08 18 2c 80 	movl   $0x802c18,0x8(%esp)
  8010de:	00 
  8010df:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010e6:	00 
  8010e7:	c7 04 24 6b 2c 80 00 	movl   $0x802c6b,(%esp)
  8010ee:	e8 52 f0 ff ff       	call   800145 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8010f3:	c7 44 24 04 31 11 80 	movl   $0x801131,0x4(%esp)
  8010fa:	00 
  8010fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801102:	e8 1c fd ff ff       	call   800e23 <sys_env_set_pgfault_upcall>
		if (error < 0)
  801107:	85 c0                	test   %eax,%eax
  801109:	79 1c                	jns    801127 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  80110b:	c7 44 24 08 40 2c 80 	movl   $0x802c40,0x8(%esp)
  801112:	00 
  801113:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80111a:	00 
  80111b:	c7 04 24 6b 2c 80 00 	movl   $0x802c6b,(%esp)
  801122:	e8 1e f0 ff ff       	call   800145 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80112f:	c9                   	leave  
  801130:	c3                   	ret    

00801131 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801131:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801132:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801137:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801139:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  80113c:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  801140:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  801145:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  801149:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  80114b:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80114e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80114f:	83 c4 04             	add    $0x4,%esp
	popfl
  801152:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801153:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801154:	c3                   	ret    
  801155:	66 90                	xchg   %ax,%ax
  801157:	66 90                	xchg   %ax,%ax
  801159:	66 90                	xchg   %ax,%ax
  80115b:	66 90                	xchg   %ax,%ax
  80115d:	66 90                	xchg   %ax,%ax
  80115f:	90                   	nop

00801160 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	05 00 00 00 30       	add    $0x30000000,%eax
  80116b:	c1 e8 0c             	shr    $0xc,%eax
}
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80117b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801180:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80118d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801192:	89 c2                	mov    %eax,%edx
  801194:	c1 ea 16             	shr    $0x16,%edx
  801197:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80119e:	f6 c2 01             	test   $0x1,%dl
  8011a1:	74 11                	je     8011b4 <fd_alloc+0x2d>
  8011a3:	89 c2                	mov    %eax,%edx
  8011a5:	c1 ea 0c             	shr    $0xc,%edx
  8011a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011af:	f6 c2 01             	test   $0x1,%dl
  8011b2:	75 09                	jne    8011bd <fd_alloc+0x36>
			*fd_store = fd;
  8011b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bb:	eb 17                	jmp    8011d4 <fd_alloc+0x4d>
  8011bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011c7:	75 c9                	jne    801192 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011dc:	83 f8 1f             	cmp    $0x1f,%eax
  8011df:	77 36                	ja     801217 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011e1:	c1 e0 0c             	shl    $0xc,%eax
  8011e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e9:	89 c2                	mov    %eax,%edx
  8011eb:	c1 ea 16             	shr    $0x16,%edx
  8011ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011f5:	f6 c2 01             	test   $0x1,%dl
  8011f8:	74 24                	je     80121e <fd_lookup+0x48>
  8011fa:	89 c2                	mov    %eax,%edx
  8011fc:	c1 ea 0c             	shr    $0xc,%edx
  8011ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801206:	f6 c2 01             	test   $0x1,%dl
  801209:	74 1a                	je     801225 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80120b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120e:	89 02                	mov    %eax,(%edx)
	return 0;
  801210:	b8 00 00 00 00       	mov    $0x0,%eax
  801215:	eb 13                	jmp    80122a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801217:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121c:	eb 0c                	jmp    80122a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80121e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801223:	eb 05                	jmp    80122a <fd_lookup+0x54>
  801225:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 18             	sub    $0x18,%esp
  801232:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801235:	ba 00 00 00 00       	mov    $0x0,%edx
  80123a:	eb 13                	jmp    80124f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80123c:	39 08                	cmp    %ecx,(%eax)
  80123e:	75 0c                	jne    80124c <dev_lookup+0x20>
			*dev = devtab[i];
  801240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801243:	89 01                	mov    %eax,(%ecx)
			return 0;
  801245:	b8 00 00 00 00       	mov    $0x0,%eax
  80124a:	eb 38                	jmp    801284 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80124c:	83 c2 01             	add    $0x1,%edx
  80124f:	8b 04 95 f8 2c 80 00 	mov    0x802cf8(,%edx,4),%eax
  801256:	85 c0                	test   %eax,%eax
  801258:	75 e2                	jne    80123c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80125a:	a1 08 40 80 00       	mov    0x804008,%eax
  80125f:	8b 40 48             	mov    0x48(%eax),%eax
  801262:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801266:	89 44 24 04          	mov    %eax,0x4(%esp)
  80126a:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  801271:	e8 c8 ef ff ff       	call   80023e <cprintf>
	*dev = 0;
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80127f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	56                   	push   %esi
  80128a:	53                   	push   %ebx
  80128b:	83 ec 20             	sub    $0x20,%esp
  80128e:	8b 75 08             	mov    0x8(%ebp),%esi
  801291:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801294:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801297:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80129b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012a4:	89 04 24             	mov    %eax,(%esp)
  8012a7:	e8 2a ff ff ff       	call   8011d6 <fd_lookup>
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	78 05                	js     8012b5 <fd_close+0x2f>
	    || fd != fd2)
  8012b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8012b3:	74 0c                	je     8012c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8012b5:	84 db                	test   %bl,%bl
  8012b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012bc:	0f 44 c2             	cmove  %edx,%eax
  8012bf:	eb 3f                	jmp    801300 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c8:	8b 06                	mov    (%esi),%eax
  8012ca:	89 04 24             	mov    %eax,(%esp)
  8012cd:	e8 5a ff ff ff       	call   80122c <dev_lookup>
  8012d2:	89 c3                	mov    %eax,%ebx
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	78 16                	js     8012ee <fd_close+0x68>
		if (dev->dev_close)
  8012d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	74 07                	je     8012ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8012e7:	89 34 24             	mov    %esi,(%esp)
  8012ea:	ff d0                	call   *%eax
  8012ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012f9:	e8 2c fa ff ff       	call   800d2a <sys_page_unmap>
	return r;
  8012fe:	89 d8                	mov    %ebx,%eax
}
  801300:	83 c4 20             	add    $0x20,%esp
  801303:	5b                   	pop    %ebx
  801304:	5e                   	pop    %esi
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    

00801307 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80130d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801310:	89 44 24 04          	mov    %eax,0x4(%esp)
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	89 04 24             	mov    %eax,(%esp)
  80131a:	e8 b7 fe ff ff       	call   8011d6 <fd_lookup>
  80131f:	89 c2                	mov    %eax,%edx
  801321:	85 d2                	test   %edx,%edx
  801323:	78 13                	js     801338 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801325:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80132c:	00 
  80132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801330:	89 04 24             	mov    %eax,(%esp)
  801333:	e8 4e ff ff ff       	call   801286 <fd_close>
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <close_all>:

void
close_all(void)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	53                   	push   %ebx
  80133e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801341:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801346:	89 1c 24             	mov    %ebx,(%esp)
  801349:	e8 b9 ff ff ff       	call   801307 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80134e:	83 c3 01             	add    $0x1,%ebx
  801351:	83 fb 20             	cmp    $0x20,%ebx
  801354:	75 f0                	jne    801346 <close_all+0xc>
		close(i);
}
  801356:	83 c4 14             	add    $0x14,%esp
  801359:	5b                   	pop    %ebx
  80135a:	5d                   	pop    %ebp
  80135b:	c3                   	ret    

0080135c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	57                   	push   %edi
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
  801362:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801365:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	89 04 24             	mov    %eax,(%esp)
  801372:	e8 5f fe ff ff       	call   8011d6 <fd_lookup>
  801377:	89 c2                	mov    %eax,%edx
  801379:	85 d2                	test   %edx,%edx
  80137b:	0f 88 e1 00 00 00    	js     801462 <dup+0x106>
		return r;
	close(newfdnum);
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	89 04 24             	mov    %eax,(%esp)
  801387:	e8 7b ff ff ff       	call   801307 <close>

	newfd = INDEX2FD(newfdnum);
  80138c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80138f:	c1 e3 0c             	shl    $0xc,%ebx
  801392:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139b:	89 04 24             	mov    %eax,(%esp)
  80139e:	e8 cd fd ff ff       	call   801170 <fd2data>
  8013a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8013a5:	89 1c 24             	mov    %ebx,(%esp)
  8013a8:	e8 c3 fd ff ff       	call   801170 <fd2data>
  8013ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013af:	89 f0                	mov    %esi,%eax
  8013b1:	c1 e8 16             	shr    $0x16,%eax
  8013b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013bb:	a8 01                	test   $0x1,%al
  8013bd:	74 43                	je     801402 <dup+0xa6>
  8013bf:	89 f0                	mov    %esi,%eax
  8013c1:	c1 e8 0c             	shr    $0xc,%eax
  8013c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013cb:	f6 c2 01             	test   $0x1,%dl
  8013ce:	74 32                	je     801402 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013eb:	00 
  8013ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f7:	e8 db f8 ff ff       	call   800cd7 <sys_page_map>
  8013fc:	89 c6                	mov    %eax,%esi
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 3e                	js     801440 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801405:	89 c2                	mov    %eax,%edx
  801407:	c1 ea 0c             	shr    $0xc,%edx
  80140a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801411:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801417:	89 54 24 10          	mov    %edx,0x10(%esp)
  80141b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80141f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801426:	00 
  801427:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801432:	e8 a0 f8 ff ff       	call   800cd7 <sys_page_map>
  801437:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801439:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80143c:	85 f6                	test   %esi,%esi
  80143e:	79 22                	jns    801462 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801440:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801444:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80144b:	e8 da f8 ff ff       	call   800d2a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801450:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801454:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80145b:	e8 ca f8 ff ff       	call   800d2a <sys_page_unmap>
	return r;
  801460:	89 f0                	mov    %esi,%eax
}
  801462:	83 c4 3c             	add    $0x3c,%esp
  801465:	5b                   	pop    %ebx
  801466:	5e                   	pop    %esi
  801467:	5f                   	pop    %edi
  801468:	5d                   	pop    %ebp
  801469:	c3                   	ret    

0080146a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	53                   	push   %ebx
  80146e:	83 ec 24             	sub    $0x24,%esp
  801471:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801474:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801477:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147b:	89 1c 24             	mov    %ebx,(%esp)
  80147e:	e8 53 fd ff ff       	call   8011d6 <fd_lookup>
  801483:	89 c2                	mov    %eax,%edx
  801485:	85 d2                	test   %edx,%edx
  801487:	78 6d                	js     8014f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801489:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	89 04 24             	mov    %eax,(%esp)
  801498:	e8 8f fd ff ff       	call   80122c <dev_lookup>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 55                	js     8014f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a4:	8b 50 08             	mov    0x8(%eax),%edx
  8014a7:	83 e2 03             	and    $0x3,%edx
  8014aa:	83 fa 01             	cmp    $0x1,%edx
  8014ad:	75 23                	jne    8014d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014af:	a1 08 40 80 00       	mov    0x804008,%eax
  8014b4:	8b 40 48             	mov    0x48(%eax),%eax
  8014b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014bf:	c7 04 24 bd 2c 80 00 	movl   $0x802cbd,(%esp)
  8014c6:	e8 73 ed ff ff       	call   80023e <cprintf>
		return -E_INVAL;
  8014cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d0:	eb 24                	jmp    8014f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8014d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d5:	8b 52 08             	mov    0x8(%edx),%edx
  8014d8:	85 d2                	test   %edx,%edx
  8014da:	74 15                	je     8014f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014ea:	89 04 24             	mov    %eax,(%esp)
  8014ed:	ff d2                	call   *%edx
  8014ef:	eb 05                	jmp    8014f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014f6:	83 c4 24             	add    $0x24,%esp
  8014f9:	5b                   	pop    %ebx
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    

008014fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	57                   	push   %edi
  801500:	56                   	push   %esi
  801501:	53                   	push   %ebx
  801502:	83 ec 1c             	sub    $0x1c,%esp
  801505:	8b 7d 08             	mov    0x8(%ebp),%edi
  801508:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80150b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801510:	eb 23                	jmp    801535 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801512:	89 f0                	mov    %esi,%eax
  801514:	29 d8                	sub    %ebx,%eax
  801516:	89 44 24 08          	mov    %eax,0x8(%esp)
  80151a:	89 d8                	mov    %ebx,%eax
  80151c:	03 45 0c             	add    0xc(%ebp),%eax
  80151f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801523:	89 3c 24             	mov    %edi,(%esp)
  801526:	e8 3f ff ff ff       	call   80146a <read>
		if (m < 0)
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 10                	js     80153f <readn+0x43>
			return m;
		if (m == 0)
  80152f:	85 c0                	test   %eax,%eax
  801531:	74 0a                	je     80153d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801533:	01 c3                	add    %eax,%ebx
  801535:	39 f3                	cmp    %esi,%ebx
  801537:	72 d9                	jb     801512 <readn+0x16>
  801539:	89 d8                	mov    %ebx,%eax
  80153b:	eb 02                	jmp    80153f <readn+0x43>
  80153d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80153f:	83 c4 1c             	add    $0x1c,%esp
  801542:	5b                   	pop    %ebx
  801543:	5e                   	pop    %esi
  801544:	5f                   	pop    %edi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	53                   	push   %ebx
  80154b:	83 ec 24             	sub    $0x24,%esp
  80154e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801551:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801554:	89 44 24 04          	mov    %eax,0x4(%esp)
  801558:	89 1c 24             	mov    %ebx,(%esp)
  80155b:	e8 76 fc ff ff       	call   8011d6 <fd_lookup>
  801560:	89 c2                	mov    %eax,%edx
  801562:	85 d2                	test   %edx,%edx
  801564:	78 68                	js     8015ce <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801566:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	89 04 24             	mov    %eax,(%esp)
  801575:	e8 b2 fc ff ff       	call   80122c <dev_lookup>
  80157a:	85 c0                	test   %eax,%eax
  80157c:	78 50                	js     8015ce <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80157e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801581:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801585:	75 23                	jne    8015aa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801587:	a1 08 40 80 00       	mov    0x804008,%eax
  80158c:	8b 40 48             	mov    0x48(%eax),%eax
  80158f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801593:	89 44 24 04          	mov    %eax,0x4(%esp)
  801597:	c7 04 24 d9 2c 80 00 	movl   $0x802cd9,(%esp)
  80159e:	e8 9b ec ff ff       	call   80023e <cprintf>
		return -E_INVAL;
  8015a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a8:	eb 24                	jmp    8015ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8015b0:	85 d2                	test   %edx,%edx
  8015b2:	74 15                	je     8015c9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015c2:	89 04 24             	mov    %eax,(%esp)
  8015c5:	ff d2                	call   *%edx
  8015c7:	eb 05                	jmp    8015ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015ce:	83 c4 24             	add    $0x24,%esp
  8015d1:	5b                   	pop    %ebx
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    

008015d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	89 04 24             	mov    %eax,(%esp)
  8015e7:	e8 ea fb ff ff       	call   8011d6 <fd_lookup>
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 0e                	js     8015fe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	53                   	push   %ebx
  801604:	83 ec 24             	sub    $0x24,%esp
  801607:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801611:	89 1c 24             	mov    %ebx,(%esp)
  801614:	e8 bd fb ff ff       	call   8011d6 <fd_lookup>
  801619:	89 c2                	mov    %eax,%edx
  80161b:	85 d2                	test   %edx,%edx
  80161d:	78 61                	js     801680 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801622:	89 44 24 04          	mov    %eax,0x4(%esp)
  801626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801629:	8b 00                	mov    (%eax),%eax
  80162b:	89 04 24             	mov    %eax,(%esp)
  80162e:	e8 f9 fb ff ff       	call   80122c <dev_lookup>
  801633:	85 c0                	test   %eax,%eax
  801635:	78 49                	js     801680 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80163e:	75 23                	jne    801663 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801640:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801645:	8b 40 48             	mov    0x48(%eax),%eax
  801648:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80164c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801650:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  801657:	e8 e2 eb ff ff       	call   80023e <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80165c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801661:	eb 1d                	jmp    801680 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801666:	8b 52 18             	mov    0x18(%edx),%edx
  801669:	85 d2                	test   %edx,%edx
  80166b:	74 0e                	je     80167b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80166d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801670:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801674:	89 04 24             	mov    %eax,(%esp)
  801677:	ff d2                	call   *%edx
  801679:	eb 05                	jmp    801680 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80167b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801680:	83 c4 24             	add    $0x24,%esp
  801683:	5b                   	pop    %ebx
  801684:	5d                   	pop    %ebp
  801685:	c3                   	ret    

00801686 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	53                   	push   %ebx
  80168a:	83 ec 24             	sub    $0x24,%esp
  80168d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801690:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801693:	89 44 24 04          	mov    %eax,0x4(%esp)
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	89 04 24             	mov    %eax,(%esp)
  80169d:	e8 34 fb ff ff       	call   8011d6 <fd_lookup>
  8016a2:	89 c2                	mov    %eax,%edx
  8016a4:	85 d2                	test   %edx,%edx
  8016a6:	78 52                	js     8016fa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	89 04 24             	mov    %eax,(%esp)
  8016b7:	e8 70 fb ff ff       	call   80122c <dev_lookup>
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 3a                	js     8016fa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8016c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c7:	74 2c                	je     8016f5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016d3:	00 00 00 
	stat->st_isdir = 0;
  8016d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016dd:	00 00 00 
	stat->st_dev = dev;
  8016e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ed:	89 14 24             	mov    %edx,(%esp)
  8016f0:	ff 50 14             	call   *0x14(%eax)
  8016f3:	eb 05                	jmp    8016fa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016fa:	83 c4 24             	add    $0x24,%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    

00801700 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	56                   	push   %esi
  801704:	53                   	push   %ebx
  801705:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801708:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80170f:	00 
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	89 04 24             	mov    %eax,(%esp)
  801716:	e8 1b 02 00 00       	call   801936 <open>
  80171b:	89 c3                	mov    %eax,%ebx
  80171d:	85 db                	test   %ebx,%ebx
  80171f:	78 1b                	js     80173c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801721:	8b 45 0c             	mov    0xc(%ebp),%eax
  801724:	89 44 24 04          	mov    %eax,0x4(%esp)
  801728:	89 1c 24             	mov    %ebx,(%esp)
  80172b:	e8 56 ff ff ff       	call   801686 <fstat>
  801730:	89 c6                	mov    %eax,%esi
	close(fd);
  801732:	89 1c 24             	mov    %ebx,(%esp)
  801735:	e8 cd fb ff ff       	call   801307 <close>
	return r;
  80173a:	89 f0                	mov    %esi,%eax
}
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    

00801743 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	56                   	push   %esi
  801747:	53                   	push   %ebx
  801748:	83 ec 10             	sub    $0x10,%esp
  80174b:	89 c6                	mov    %eax,%esi
  80174d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80174f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801756:	75 11                	jne    801769 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801758:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80175f:	e8 7b 0d 00 00       	call   8024df <ipc_find_env>
  801764:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801769:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801770:	00 
  801771:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801778:	00 
  801779:	89 74 24 04          	mov    %esi,0x4(%esp)
  80177d:	a1 00 40 80 00       	mov    0x804000,%eax
  801782:	89 04 24             	mov    %eax,(%esp)
  801785:	e8 ea 0c 00 00       	call   802474 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80178a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801791:	00 
  801792:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801796:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80179d:	e8 7e 0c 00 00       	call   802420 <ipc_recv>
}
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	5b                   	pop    %ebx
  8017a6:	5e                   	pop    %esi
  8017a7:	5d                   	pop    %ebp
  8017a8:	c3                   	ret    

008017a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017cc:	e8 72 ff ff ff       	call   801743 <fsipc>
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017df:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ee:	e8 50 ff ff ff       	call   801743 <fsipc>
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 14             	sub    $0x14,%esp
  8017fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8b 40 0c             	mov    0xc(%eax),%eax
  801805:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80180a:	ba 00 00 00 00       	mov    $0x0,%edx
  80180f:	b8 05 00 00 00       	mov    $0x5,%eax
  801814:	e8 2a ff ff ff       	call   801743 <fsipc>
  801819:	89 c2                	mov    %eax,%edx
  80181b:	85 d2                	test   %edx,%edx
  80181d:	78 2b                	js     80184a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80181f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801826:	00 
  801827:	89 1c 24             	mov    %ebx,(%esp)
  80182a:	e8 38 f0 ff ff       	call   800867 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80182f:	a1 80 50 80 00       	mov    0x805080,%eax
  801834:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80183a:	a1 84 50 80 00       	mov    0x805084,%eax
  80183f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184a:	83 c4 14             	add    $0x14,%esp
  80184d:	5b                   	pop    %ebx
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 18             	sub    $0x18,%esp
  801856:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801859:	8b 55 08             	mov    0x8(%ebp),%edx
  80185c:	8b 52 0c             	mov    0xc(%edx),%edx
  80185f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801865:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80186a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80186e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801871:	89 44 24 04          	mov    %eax,0x4(%esp)
  801875:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80187c:	e8 eb f1 ff ff       	call   800a6c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
  801886:	b8 04 00 00 00       	mov    $0x4,%eax
  80188b:	e8 b3 fe ff ff       	call   801743 <fsipc>
		return r;
	}

	return r;
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	56                   	push   %esi
  801896:	53                   	push   %ebx
  801897:	83 ec 10             	sub    $0x10,%esp
  80189a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018a8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8018b8:	e8 86 fe ff ff       	call   801743 <fsipc>
  8018bd:	89 c3                	mov    %eax,%ebx
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 6a                	js     80192d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018c3:	39 c6                	cmp    %eax,%esi
  8018c5:	73 24                	jae    8018eb <devfile_read+0x59>
  8018c7:	c7 44 24 0c 0c 2d 80 	movl   $0x802d0c,0xc(%esp)
  8018ce:	00 
  8018cf:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  8018d6:	00 
  8018d7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018de:	00 
  8018df:	c7 04 24 28 2d 80 00 	movl   $0x802d28,(%esp)
  8018e6:	e8 5a e8 ff ff       	call   800145 <_panic>
	assert(r <= PGSIZE);
  8018eb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018f0:	7e 24                	jle    801916 <devfile_read+0x84>
  8018f2:	c7 44 24 0c 33 2d 80 	movl   $0x802d33,0xc(%esp)
  8018f9:	00 
  8018fa:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  801901:	00 
  801902:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801909:	00 
  80190a:	c7 04 24 28 2d 80 00 	movl   $0x802d28,(%esp)
  801911:	e8 2f e8 ff ff       	call   800145 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801916:	89 44 24 08          	mov    %eax,0x8(%esp)
  80191a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801921:	00 
  801922:	8b 45 0c             	mov    0xc(%ebp),%eax
  801925:	89 04 24             	mov    %eax,(%esp)
  801928:	e8 d7 f0 ff ff       	call   800a04 <memmove>
	return r;
}
  80192d:	89 d8                	mov    %ebx,%eax
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    

00801936 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	53                   	push   %ebx
  80193a:	83 ec 24             	sub    $0x24,%esp
  80193d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801940:	89 1c 24             	mov    %ebx,(%esp)
  801943:	e8 e8 ee ff ff       	call   800830 <strlen>
  801948:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80194d:	7f 60                	jg     8019af <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	89 04 24             	mov    %eax,(%esp)
  801955:	e8 2d f8 ff ff       	call   801187 <fd_alloc>
  80195a:	89 c2                	mov    %eax,%edx
  80195c:	85 d2                	test   %edx,%edx
  80195e:	78 54                	js     8019b4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801960:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801964:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80196b:	e8 f7 ee ff ff       	call   800867 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801970:	8b 45 0c             	mov    0xc(%ebp),%eax
  801973:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801978:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197b:	b8 01 00 00 00       	mov    $0x1,%eax
  801980:	e8 be fd ff ff       	call   801743 <fsipc>
  801985:	89 c3                	mov    %eax,%ebx
  801987:	85 c0                	test   %eax,%eax
  801989:	79 17                	jns    8019a2 <open+0x6c>
		fd_close(fd, 0);
  80198b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801992:	00 
  801993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801996:	89 04 24             	mov    %eax,(%esp)
  801999:	e8 e8 f8 ff ff       	call   801286 <fd_close>
		return r;
  80199e:	89 d8                	mov    %ebx,%eax
  8019a0:	eb 12                	jmp    8019b4 <open+0x7e>
	}

	return fd2num(fd);
  8019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a5:	89 04 24             	mov    %eax,(%esp)
  8019a8:	e8 b3 f7 ff ff       	call   801160 <fd2num>
  8019ad:	eb 05                	jmp    8019b4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019af:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019b4:	83 c4 24             	add    $0x24,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    

008019ba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ca:	e8 74 fd ff ff       	call   801743 <fsipc>
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    
  8019d1:	66 90                	xchg   %ax,%ax
  8019d3:	66 90                	xchg   %ax,%ax
  8019d5:	66 90                	xchg   %ax,%ax
  8019d7:	66 90                	xchg   %ax,%ax
  8019d9:	66 90                	xchg   %ax,%ax
  8019db:	66 90                	xchg   %ax,%ax
  8019dd:	66 90                	xchg   %ax,%ax
  8019df:	90                   	nop

008019e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8019e6:	c7 44 24 04 3f 2d 80 	movl   $0x802d3f,0x4(%esp)
  8019ed:	00 
  8019ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f1:	89 04 24             	mov    %eax,(%esp)
  8019f4:	e8 6e ee ff ff       	call   800867 <strcpy>
	return 0;
}
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	53                   	push   %ebx
  801a04:	83 ec 14             	sub    $0x14,%esp
  801a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a0a:	89 1c 24             	mov    %ebx,(%esp)
  801a0d:	e8 0c 0b 00 00       	call   80251e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801a12:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801a17:	83 f8 01             	cmp    $0x1,%eax
  801a1a:	75 0d                	jne    801a29 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801a1c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801a1f:	89 04 24             	mov    %eax,(%esp)
  801a22:	e8 29 03 00 00       	call   801d50 <nsipc_close>
  801a27:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801a29:	89 d0                	mov    %edx,%eax
  801a2b:	83 c4 14             	add    $0x14,%esp
  801a2e:	5b                   	pop    %ebx
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    

00801a31 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a3e:	00 
  801a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	8b 40 0c             	mov    0xc(%eax),%eax
  801a53:	89 04 24             	mov    %eax,(%esp)
  801a56:	e8 f0 03 00 00       	call   801e4b <nsipc_send>
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a63:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a6a:	00 
  801a6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7f:	89 04 24             	mov    %eax,(%esp)
  801a82:	e8 44 03 00 00       	call   801dcb <nsipc_recv>
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a92:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a96:	89 04 24             	mov    %eax,(%esp)
  801a99:	e8 38 f7 ff ff       	call   8011d6 <fd_lookup>
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 17                	js     801ab9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801aab:	39 08                	cmp    %ecx,(%eax)
  801aad:	75 05                	jne    801ab4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801aaf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab2:	eb 05                	jmp    801ab9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ab4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 20             	sub    $0x20,%esp
  801ac3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ac5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac8:	89 04 24             	mov    %eax,(%esp)
  801acb:	e8 b7 f6 ff ff       	call   801187 <fd_alloc>
  801ad0:	89 c3                	mov    %eax,%ebx
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 21                	js     801af7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ad6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801add:	00 
  801ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aec:	e8 92 f1 ff ff       	call   800c83 <sys_page_alloc>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	85 c0                	test   %eax,%eax
  801af5:	79 0c                	jns    801b03 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801af7:	89 34 24             	mov    %esi,(%esp)
  801afa:	e8 51 02 00 00       	call   801d50 <nsipc_close>
		return r;
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	eb 20                	jmp    801b23 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b03:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b11:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801b18:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801b1b:	89 14 24             	mov    %edx,(%esp)
  801b1e:	e8 3d f6 ff ff       	call   801160 <fd2num>
}
  801b23:	83 c4 20             	add    $0x20,%esp
  801b26:	5b                   	pop    %ebx
  801b27:	5e                   	pop    %esi
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    

00801b2a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	e8 51 ff ff ff       	call   801a89 <fd2sockid>
		return r;
  801b38:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 23                	js     801b61 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b3e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b41:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b4c:	89 04 24             	mov    %eax,(%esp)
  801b4f:	e8 45 01 00 00       	call   801c99 <nsipc_accept>
		return r;
  801b54:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b56:	85 c0                	test   %eax,%eax
  801b58:	78 07                	js     801b61 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b5a:	e8 5c ff ff ff       	call   801abb <alloc_sockfd>
  801b5f:	89 c1                	mov    %eax,%ecx
}
  801b61:	89 c8                	mov    %ecx,%eax
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	e8 16 ff ff ff       	call   801a89 <fd2sockid>
  801b73:	89 c2                	mov    %eax,%edx
  801b75:	85 d2                	test   %edx,%edx
  801b77:	78 16                	js     801b8f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801b79:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b87:	89 14 24             	mov    %edx,(%esp)
  801b8a:	e8 60 01 00 00       	call   801cef <nsipc_bind>
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <shutdown>:

int
shutdown(int s, int how)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	e8 ea fe ff ff       	call   801a89 <fd2sockid>
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	85 d2                	test   %edx,%edx
  801ba3:	78 0f                	js     801bb4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bac:	89 14 24             	mov    %edx,(%esp)
  801baf:	e8 7a 01 00 00       	call   801d2e <nsipc_shutdown>
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	e8 c5 fe ff ff       	call   801a89 <fd2sockid>
  801bc4:	89 c2                	mov    %eax,%edx
  801bc6:	85 d2                	test   %edx,%edx
  801bc8:	78 16                	js     801be0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801bca:	8b 45 10             	mov    0x10(%ebp),%eax
  801bcd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd8:	89 14 24             	mov    %edx,(%esp)
  801bdb:	e8 8a 01 00 00       	call   801d6a <nsipc_connect>
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <listen>:

int
listen(int s, int backlog)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	e8 99 fe ff ff       	call   801a89 <fd2sockid>
  801bf0:	89 c2                	mov    %eax,%edx
  801bf2:	85 d2                	test   %edx,%edx
  801bf4:	78 0f                	js     801c05 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfd:	89 14 24             	mov    %edx,(%esp)
  801c00:	e8 a4 01 00 00       	call   801da9 <nsipc_listen>
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c10:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	89 04 24             	mov    %eax,(%esp)
  801c21:	e8 98 02 00 00       	call   801ebe <nsipc_socket>
  801c26:	89 c2                	mov    %eax,%edx
  801c28:	85 d2                	test   %edx,%edx
  801c2a:	78 05                	js     801c31 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801c2c:	e8 8a fe ff ff       	call   801abb <alloc_sockfd>
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	53                   	push   %ebx
  801c37:	83 ec 14             	sub    $0x14,%esp
  801c3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c3c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c43:	75 11                	jne    801c56 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c45:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c4c:	e8 8e 08 00 00       	call   8024df <ipc_find_env>
  801c51:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c56:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c5d:	00 
  801c5e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c65:	00 
  801c66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c6a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c6f:	89 04 24             	mov    %eax,(%esp)
  801c72:	e8 fd 07 00 00       	call   802474 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c7e:	00 
  801c7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c86:	00 
  801c87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c8e:	e8 8d 07 00 00       	call   802420 <ipc_recv>
}
  801c93:	83 c4 14             	add    $0x14,%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    

00801c99 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	56                   	push   %esi
  801c9d:	53                   	push   %ebx
  801c9e:	83 ec 10             	sub    $0x10,%esp
  801ca1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cac:	8b 06                	mov    (%esi),%eax
  801cae:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb8:	e8 76 ff ff ff       	call   801c33 <nsipc>
  801cbd:	89 c3                	mov    %eax,%ebx
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 23                	js     801ce6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cc3:	a1 10 60 80 00       	mov    0x806010,%eax
  801cc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ccc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cd3:	00 
  801cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd7:	89 04 24             	mov    %eax,(%esp)
  801cda:	e8 25 ed ff ff       	call   800a04 <memmove>
		*addrlen = ret->ret_addrlen;
  801cdf:	a1 10 60 80 00       	mov    0x806010,%eax
  801ce4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ce6:	89 d8                	mov    %ebx,%eax
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    

00801cef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	53                   	push   %ebx
  801cf3:	83 ec 14             	sub    $0x14,%esp
  801cf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d01:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d13:	e8 ec ec ff ff       	call   800a04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d18:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d1e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d23:	e8 0b ff ff ff       	call   801c33 <nsipc>
}
  801d28:	83 c4 14             	add    $0x14,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d44:	b8 03 00 00 00       	mov    $0x3,%eax
  801d49:	e8 e5 fe ff ff       	call   801c33 <nsipc>
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <nsipc_close>:

int
nsipc_close(int s)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d5e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d63:	e8 cb fe ff ff       	call   801c33 <nsipc>
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	53                   	push   %ebx
  801d6e:	83 ec 14             	sub    $0x14,%esp
  801d71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d87:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d8e:	e8 71 ec ff ff       	call   800a04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d93:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d99:	b8 05 00 00 00       	mov    $0x5,%eax
  801d9e:	e8 90 fe ff ff       	call   801c33 <nsipc>
}
  801da3:	83 c4 14             	add    $0x14,%esp
  801da6:	5b                   	pop    %ebx
  801da7:	5d                   	pop    %ebp
  801da8:	c3                   	ret    

00801da9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801dbf:	b8 06 00 00 00       	mov    $0x6,%eax
  801dc4:	e8 6a fe ff ff       	call   801c33 <nsipc>
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 10             	sub    $0x10,%esp
  801dd3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dde:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801de4:	8b 45 14             	mov    0x14(%ebp),%eax
  801de7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dec:	b8 07 00 00 00       	mov    $0x7,%eax
  801df1:	e8 3d fe ff ff       	call   801c33 <nsipc>
  801df6:	89 c3                	mov    %eax,%ebx
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 46                	js     801e42 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801dfc:	39 f0                	cmp    %esi,%eax
  801dfe:	7f 07                	jg     801e07 <nsipc_recv+0x3c>
  801e00:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e05:	7e 24                	jle    801e2b <nsipc_recv+0x60>
  801e07:	c7 44 24 0c 4b 2d 80 	movl   $0x802d4b,0xc(%esp)
  801e0e:	00 
  801e0f:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  801e16:	00 
  801e17:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801e1e:	00 
  801e1f:	c7 04 24 60 2d 80 00 	movl   $0x802d60,(%esp)
  801e26:	e8 1a e3 ff ff       	call   800145 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e2f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e36:	00 
  801e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3a:	89 04 24             	mov    %eax,(%esp)
  801e3d:	e8 c2 eb ff ff       	call   800a04 <memmove>
	}

	return r;
}
  801e42:	89 d8                	mov    %ebx,%eax
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    

00801e4b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	53                   	push   %ebx
  801e4f:	83 ec 14             	sub    $0x14,%esp
  801e52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e5d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e63:	7e 24                	jle    801e89 <nsipc_send+0x3e>
  801e65:	c7 44 24 0c 6c 2d 80 	movl   $0x802d6c,0xc(%esp)
  801e6c:	00 
  801e6d:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  801e74:	00 
  801e75:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801e7c:	00 
  801e7d:	c7 04 24 60 2d 80 00 	movl   $0x802d60,(%esp)
  801e84:	e8 bc e2 ff ff       	call   800145 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e94:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e9b:	e8 64 eb ff ff       	call   800a04 <memmove>
	nsipcbuf.send.req_size = size;
  801ea0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801eae:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb3:	e8 7b fd ff ff       	call   801c33 <nsipc>
}
  801eb8:	83 c4 14             	add    $0x14,%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801edc:	b8 09 00 00 00       	mov    $0x9,%eax
  801ee1:	e8 4d fd ff ff       	call   801c33 <nsipc>
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	83 ec 10             	sub    $0x10,%esp
  801ef0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	89 04 24             	mov    %eax,(%esp)
  801ef9:	e8 72 f2 ff ff       	call   801170 <fd2data>
  801efe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f00:	c7 44 24 04 78 2d 80 	movl   $0x802d78,0x4(%esp)
  801f07:	00 
  801f08:	89 1c 24             	mov    %ebx,(%esp)
  801f0b:	e8 57 e9 ff ff       	call   800867 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f10:	8b 46 04             	mov    0x4(%esi),%eax
  801f13:	2b 06                	sub    (%esi),%eax
  801f15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f1b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f22:	00 00 00 
	stat->st_dev = &devpipe;
  801f25:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f2c:	30 80 00 
	return 0;
}
  801f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 14             	sub    $0x14,%esp
  801f42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f45:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f50:	e8 d5 ed ff ff       	call   800d2a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f55:	89 1c 24             	mov    %ebx,(%esp)
  801f58:	e8 13 f2 ff ff       	call   801170 <fd2data>
  801f5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f68:	e8 bd ed ff ff       	call   800d2a <sys_page_unmap>
}
  801f6d:	83 c4 14             	add    $0x14,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    

00801f73 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	57                   	push   %edi
  801f77:	56                   	push   %esi
  801f78:	53                   	push   %ebx
  801f79:	83 ec 2c             	sub    $0x2c,%esp
  801f7c:	89 c6                	mov    %eax,%esi
  801f7e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f81:	a1 08 40 80 00       	mov    0x804008,%eax
  801f86:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f89:	89 34 24             	mov    %esi,(%esp)
  801f8c:	e8 8d 05 00 00       	call   80251e <pageref>
  801f91:	89 c7                	mov    %eax,%edi
  801f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	e8 80 05 00 00       	call   80251e <pageref>
  801f9e:	39 c7                	cmp    %eax,%edi
  801fa0:	0f 94 c2             	sete   %dl
  801fa3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801fa6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801fac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801faf:	39 fb                	cmp    %edi,%ebx
  801fb1:	74 21                	je     801fd4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801fb3:	84 d2                	test   %dl,%dl
  801fb5:	74 ca                	je     801f81 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fb7:	8b 51 58             	mov    0x58(%ecx),%edx
  801fba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fbe:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fc6:	c7 04 24 7f 2d 80 00 	movl   $0x802d7f,(%esp)
  801fcd:	e8 6c e2 ff ff       	call   80023e <cprintf>
  801fd2:	eb ad                	jmp    801f81 <_pipeisclosed+0xe>
	}
}
  801fd4:	83 c4 2c             	add    $0x2c,%esp
  801fd7:	5b                   	pop    %ebx
  801fd8:	5e                   	pop    %esi
  801fd9:	5f                   	pop    %edi
  801fda:	5d                   	pop    %ebp
  801fdb:	c3                   	ret    

00801fdc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	57                   	push   %edi
  801fe0:	56                   	push   %esi
  801fe1:	53                   	push   %ebx
  801fe2:	83 ec 1c             	sub    $0x1c,%esp
  801fe5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fe8:	89 34 24             	mov    %esi,(%esp)
  801feb:	e8 80 f1 ff ff       	call   801170 <fd2data>
  801ff0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ff2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff7:	eb 45                	jmp    80203e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ff9:	89 da                	mov    %ebx,%edx
  801ffb:	89 f0                	mov    %esi,%eax
  801ffd:	e8 71 ff ff ff       	call   801f73 <_pipeisclosed>
  802002:	85 c0                	test   %eax,%eax
  802004:	75 41                	jne    802047 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802006:	e8 59 ec ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80200b:	8b 43 04             	mov    0x4(%ebx),%eax
  80200e:	8b 0b                	mov    (%ebx),%ecx
  802010:	8d 51 20             	lea    0x20(%ecx),%edx
  802013:	39 d0                	cmp    %edx,%eax
  802015:	73 e2                	jae    801ff9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802017:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80201a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80201e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802021:	99                   	cltd   
  802022:	c1 ea 1b             	shr    $0x1b,%edx
  802025:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802028:	83 e1 1f             	and    $0x1f,%ecx
  80202b:	29 d1                	sub    %edx,%ecx
  80202d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802031:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802035:	83 c0 01             	add    $0x1,%eax
  802038:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80203b:	83 c7 01             	add    $0x1,%edi
  80203e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802041:	75 c8                	jne    80200b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802043:	89 f8                	mov    %edi,%eax
  802045:	eb 05                	jmp    80204c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80204c:	83 c4 1c             	add    $0x1c,%esp
  80204f:	5b                   	pop    %ebx
  802050:	5e                   	pop    %esi
  802051:	5f                   	pop    %edi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    

00802054 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	57                   	push   %edi
  802058:	56                   	push   %esi
  802059:	53                   	push   %ebx
  80205a:	83 ec 1c             	sub    $0x1c,%esp
  80205d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802060:	89 3c 24             	mov    %edi,(%esp)
  802063:	e8 08 f1 ff ff       	call   801170 <fd2data>
  802068:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80206a:	be 00 00 00 00       	mov    $0x0,%esi
  80206f:	eb 3d                	jmp    8020ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802071:	85 f6                	test   %esi,%esi
  802073:	74 04                	je     802079 <devpipe_read+0x25>
				return i;
  802075:	89 f0                	mov    %esi,%eax
  802077:	eb 43                	jmp    8020bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802079:	89 da                	mov    %ebx,%edx
  80207b:	89 f8                	mov    %edi,%eax
  80207d:	e8 f1 fe ff ff       	call   801f73 <_pipeisclosed>
  802082:	85 c0                	test   %eax,%eax
  802084:	75 31                	jne    8020b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802086:	e8 d9 eb ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80208b:	8b 03                	mov    (%ebx),%eax
  80208d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802090:	74 df                	je     802071 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802092:	99                   	cltd   
  802093:	c1 ea 1b             	shr    $0x1b,%edx
  802096:	01 d0                	add    %edx,%eax
  802098:	83 e0 1f             	and    $0x1f,%eax
  80209b:	29 d0                	sub    %edx,%eax
  80209d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020ab:	83 c6 01             	add    $0x1,%esi
  8020ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020b1:	75 d8                	jne    80208b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020b3:	89 f0                	mov    %esi,%eax
  8020b5:	eb 05                	jmp    8020bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020bc:	83 c4 1c             	add    $0x1c,%esp
  8020bf:	5b                   	pop    %ebx
  8020c0:	5e                   	pop    %esi
  8020c1:	5f                   	pop    %edi
  8020c2:	5d                   	pop    %ebp
  8020c3:	c3                   	ret    

008020c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	56                   	push   %esi
  8020c8:	53                   	push   %ebx
  8020c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cf:	89 04 24             	mov    %eax,(%esp)
  8020d2:	e8 b0 f0 ff ff       	call   801187 <fd_alloc>
  8020d7:	89 c2                	mov    %eax,%edx
  8020d9:	85 d2                	test   %edx,%edx
  8020db:	0f 88 4d 01 00 00    	js     80222e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020e8:	00 
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f7:	e8 87 eb ff ff       	call   800c83 <sys_page_alloc>
  8020fc:	89 c2                	mov    %eax,%edx
  8020fe:	85 d2                	test   %edx,%edx
  802100:	0f 88 28 01 00 00    	js     80222e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802106:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802109:	89 04 24             	mov    %eax,(%esp)
  80210c:	e8 76 f0 ff ff       	call   801187 <fd_alloc>
  802111:	89 c3                	mov    %eax,%ebx
  802113:	85 c0                	test   %eax,%eax
  802115:	0f 88 fe 00 00 00    	js     802219 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80211b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802122:	00 
  802123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802126:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802131:	e8 4d eb ff ff       	call   800c83 <sys_page_alloc>
  802136:	89 c3                	mov    %eax,%ebx
  802138:	85 c0                	test   %eax,%eax
  80213a:	0f 88 d9 00 00 00    	js     802219 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	89 04 24             	mov    %eax,(%esp)
  802146:	e8 25 f0 ff ff       	call   801170 <fd2data>
  80214b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80214d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802154:	00 
  802155:	89 44 24 04          	mov    %eax,0x4(%esp)
  802159:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802160:	e8 1e eb ff ff       	call   800c83 <sys_page_alloc>
  802165:	89 c3                	mov    %eax,%ebx
  802167:	85 c0                	test   %eax,%eax
  802169:	0f 88 97 00 00 00    	js     802206 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802172:	89 04 24             	mov    %eax,(%esp)
  802175:	e8 f6 ef ff ff       	call   801170 <fd2data>
  80217a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802181:	00 
  802182:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802186:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80218d:	00 
  80218e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802199:	e8 39 eb ff ff       	call   800cd7 <sys_page_map>
  80219e:	89 c3                	mov    %eax,%ebx
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	78 52                	js     8021f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021a4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021b9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	89 04 24             	mov    %eax,(%esp)
  8021d4:	e8 87 ef ff ff       	call   801160 <fd2num>
  8021d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e1:	89 04 24             	mov    %eax,(%esp)
  8021e4:	e8 77 ef ff ff       	call   801160 <fd2num>
  8021e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	eb 38                	jmp    80222e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8021f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802201:	e8 24 eb ff ff       	call   800d2a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802209:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802214:	e8 11 eb ff ff       	call   800d2a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802220:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802227:	e8 fe ea ff ff       	call   800d2a <sys_page_unmap>
  80222c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80222e:	83 c4 30             	add    $0x30,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    

00802235 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80223b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80223e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	89 04 24             	mov    %eax,(%esp)
  802248:	e8 89 ef ff ff       	call   8011d6 <fd_lookup>
  80224d:	89 c2                	mov    %eax,%edx
  80224f:	85 d2                	test   %edx,%edx
  802251:	78 15                	js     802268 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	89 04 24             	mov    %eax,(%esp)
  802259:	e8 12 ef ff ff       	call   801170 <fd2data>
	return _pipeisclosed(fd, p);
  80225e:	89 c2                	mov    %eax,%edx
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	e8 0b fd ff ff       	call   801f73 <_pipeisclosed>
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    
  80226a:	66 90                	xchg   %ax,%ax
  80226c:	66 90                	xchg   %ax,%ax
  80226e:	66 90                	xchg   %ax,%ax

00802270 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802273:	b8 00 00 00 00       	mov    $0x0,%eax
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    

0080227a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802280:	c7 44 24 04 97 2d 80 	movl   $0x802d97,0x4(%esp)
  802287:	00 
  802288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228b:	89 04 24             	mov    %eax,(%esp)
  80228e:	e8 d4 e5 ff ff       	call   800867 <strcpy>
	return 0;
}
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	57                   	push   %edi
  80229e:	56                   	push   %esi
  80229f:	53                   	push   %ebx
  8022a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022b1:	eb 31                	jmp    8022e4 <devcons_write+0x4a>
		m = n - tot;
  8022b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8022b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8022b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8022c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022c7:	03 45 0c             	add    0xc(%ebp),%eax
  8022ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ce:	89 3c 24             	mov    %edi,(%esp)
  8022d1:	e8 2e e7 ff ff       	call   800a04 <memmove>
		sys_cputs(buf, m);
  8022d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022da:	89 3c 24             	mov    %edi,(%esp)
  8022dd:	e8 d4 e8 ff ff       	call   800bb6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022e2:	01 f3                	add    %esi,%ebx
  8022e4:	89 d8                	mov    %ebx,%eax
  8022e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8022e9:	72 c8                	jb     8022b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8022eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    

008022f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802301:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802305:	75 07                	jne    80230e <devcons_read+0x18>
  802307:	eb 2a                	jmp    802333 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802309:	e8 56 e9 ff ff       	call   800c64 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80230e:	66 90                	xchg   %ax,%ax
  802310:	e8 bf e8 ff ff       	call   800bd4 <sys_cgetc>
  802315:	85 c0                	test   %eax,%eax
  802317:	74 f0                	je     802309 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802319:	85 c0                	test   %eax,%eax
  80231b:	78 16                	js     802333 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80231d:	83 f8 04             	cmp    $0x4,%eax
  802320:	74 0c                	je     80232e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802322:	8b 55 0c             	mov    0xc(%ebp),%edx
  802325:	88 02                	mov    %al,(%edx)
	return 1;
  802327:	b8 01 00 00 00       	mov    $0x1,%eax
  80232c:	eb 05                	jmp    802333 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80232e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802341:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802348:	00 
  802349:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80234c:	89 04 24             	mov    %eax,(%esp)
  80234f:	e8 62 e8 ff ff       	call   800bb6 <sys_cputs>
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <getchar>:

int
getchar(void)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80235c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802363:	00 
  802364:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802372:	e8 f3 f0 ff ff       	call   80146a <read>
	if (r < 0)
  802377:	85 c0                	test   %eax,%eax
  802379:	78 0f                	js     80238a <getchar+0x34>
		return r;
	if (r < 1)
  80237b:	85 c0                	test   %eax,%eax
  80237d:	7e 06                	jle    802385 <getchar+0x2f>
		return -E_EOF;
	return c;
  80237f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802383:	eb 05                	jmp    80238a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802385:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802392:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802395:	89 44 24 04          	mov    %eax,0x4(%esp)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	89 04 24             	mov    %eax,(%esp)
  80239f:	e8 32 ee ff ff       	call   8011d6 <fd_lookup>
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	78 11                	js     8023b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023b1:	39 10                	cmp    %edx,(%eax)
  8023b3:	0f 94 c0             	sete   %al
  8023b6:	0f b6 c0             	movzbl %al,%eax
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <opencons>:

int
opencons(void)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c4:	89 04 24             	mov    %eax,(%esp)
  8023c7:	e8 bb ed ff ff       	call   801187 <fd_alloc>
		return r;
  8023cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	78 40                	js     802412 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023d9:	00 
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e8:	e8 96 e8 ff ff       	call   800c83 <sys_page_alloc>
		return r;
  8023ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	78 1f                	js     802412 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8023f3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802408:	89 04 24             	mov    %eax,(%esp)
  80240b:	e8 50 ed ff ff       	call   801160 <fd2num>
  802410:	89 c2                	mov    %eax,%edx
}
  802412:	89 d0                	mov    %edx,%eax
  802414:	c9                   	leave  
  802415:	c3                   	ret    
  802416:	66 90                	xchg   %ax,%ax
  802418:	66 90                	xchg   %ax,%ax
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	66 90                	xchg   %ax,%ax
  80241e:	66 90                	xchg   %ax,%ax

00802420 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	56                   	push   %esi
  802424:	53                   	push   %ebx
  802425:	83 ec 10             	sub    $0x10,%esp
  802428:	8b 75 08             	mov    0x8(%ebp),%esi
  80242b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802431:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802433:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802438:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80243b:	89 04 24             	mov    %eax,(%esp)
  80243e:	e8 56 ea ff ff       	call   800e99 <sys_ipc_recv>
  802443:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802445:	85 d2                	test   %edx,%edx
  802447:	75 24                	jne    80246d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802449:	85 f6                	test   %esi,%esi
  80244b:	74 0a                	je     802457 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80244d:	a1 08 40 80 00       	mov    0x804008,%eax
  802452:	8b 40 74             	mov    0x74(%eax),%eax
  802455:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802457:	85 db                	test   %ebx,%ebx
  802459:	74 0a                	je     802465 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80245b:	a1 08 40 80 00       	mov    0x804008,%eax
  802460:	8b 40 78             	mov    0x78(%eax),%eax
  802463:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802465:	a1 08 40 80 00       	mov    0x804008,%eax
  80246a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80246d:	83 c4 10             	add    $0x10,%esp
  802470:	5b                   	pop    %ebx
  802471:	5e                   	pop    %esi
  802472:	5d                   	pop    %ebp
  802473:	c3                   	ret    

00802474 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	57                   	push   %edi
  802478:	56                   	push   %esi
  802479:	53                   	push   %ebx
  80247a:	83 ec 1c             	sub    $0x1c,%esp
  80247d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802480:	8b 75 0c             	mov    0xc(%ebp),%esi
  802483:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802486:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802488:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80248d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802490:	8b 45 14             	mov    0x14(%ebp),%eax
  802493:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802497:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80249b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80249f:	89 3c 24             	mov    %edi,(%esp)
  8024a2:	e8 cf e9 ff ff       	call   800e76 <sys_ipc_try_send>

		if (ret == 0)
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 2c                	je     8024d7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8024ab:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024ae:	74 20                	je     8024d0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8024b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024b4:	c7 44 24 08 a4 2d 80 	movl   $0x802da4,0x8(%esp)
  8024bb:	00 
  8024bc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8024c3:	00 
  8024c4:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  8024cb:	e8 75 dc ff ff       	call   800145 <_panic>
		}

		sys_yield();
  8024d0:	e8 8f e7 ff ff       	call   800c64 <sys_yield>
	}
  8024d5:	eb b9                	jmp    802490 <ipc_send+0x1c>
}
  8024d7:	83 c4 1c             	add    $0x1c,%esp
  8024da:	5b                   	pop    %ebx
  8024db:	5e                   	pop    %esi
  8024dc:	5f                   	pop    %edi
  8024dd:	5d                   	pop    %ebp
  8024de:	c3                   	ret    

008024df <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024e5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024ea:	89 c2                	mov    %eax,%edx
  8024ec:	c1 e2 07             	shl    $0x7,%edx
  8024ef:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8024f6:	8b 52 50             	mov    0x50(%edx),%edx
  8024f9:	39 ca                	cmp    %ecx,%edx
  8024fb:	75 11                	jne    80250e <ipc_find_env+0x2f>
			return envs[i].env_id;
  8024fd:	89 c2                	mov    %eax,%edx
  8024ff:	c1 e2 07             	shl    $0x7,%edx
  802502:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802509:	8b 40 40             	mov    0x40(%eax),%eax
  80250c:	eb 0e                	jmp    80251c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80250e:	83 c0 01             	add    $0x1,%eax
  802511:	3d 00 04 00 00       	cmp    $0x400,%eax
  802516:	75 d2                	jne    8024ea <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802518:	66 b8 00 00          	mov    $0x0,%ax
}
  80251c:	5d                   	pop    %ebp
  80251d:	c3                   	ret    

0080251e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802524:	89 d0                	mov    %edx,%eax
  802526:	c1 e8 16             	shr    $0x16,%eax
  802529:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802530:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802535:	f6 c1 01             	test   $0x1,%cl
  802538:	74 1d                	je     802557 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80253a:	c1 ea 0c             	shr    $0xc,%edx
  80253d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802544:	f6 c2 01             	test   $0x1,%dl
  802547:	74 0e                	je     802557 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802549:	c1 ea 0c             	shr    $0xc,%edx
  80254c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802553:	ef 
  802554:	0f b7 c0             	movzwl %ax,%eax
}
  802557:	5d                   	pop    %ebp
  802558:	c3                   	ret    
  802559:	66 90                	xchg   %ax,%ax
  80255b:	66 90                	xchg   %ax,%ax
  80255d:	66 90                	xchg   %ax,%ax
  80255f:	90                   	nop

00802560 <__udivdi3>:
  802560:	55                   	push   %ebp
  802561:	57                   	push   %edi
  802562:	56                   	push   %esi
  802563:	83 ec 0c             	sub    $0xc,%esp
  802566:	8b 44 24 28          	mov    0x28(%esp),%eax
  80256a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80256e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802572:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802576:	85 c0                	test   %eax,%eax
  802578:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80257c:	89 ea                	mov    %ebp,%edx
  80257e:	89 0c 24             	mov    %ecx,(%esp)
  802581:	75 2d                	jne    8025b0 <__udivdi3+0x50>
  802583:	39 e9                	cmp    %ebp,%ecx
  802585:	77 61                	ja     8025e8 <__udivdi3+0x88>
  802587:	85 c9                	test   %ecx,%ecx
  802589:	89 ce                	mov    %ecx,%esi
  80258b:	75 0b                	jne    802598 <__udivdi3+0x38>
  80258d:	b8 01 00 00 00       	mov    $0x1,%eax
  802592:	31 d2                	xor    %edx,%edx
  802594:	f7 f1                	div    %ecx
  802596:	89 c6                	mov    %eax,%esi
  802598:	31 d2                	xor    %edx,%edx
  80259a:	89 e8                	mov    %ebp,%eax
  80259c:	f7 f6                	div    %esi
  80259e:	89 c5                	mov    %eax,%ebp
  8025a0:	89 f8                	mov    %edi,%eax
  8025a2:	f7 f6                	div    %esi
  8025a4:	89 ea                	mov    %ebp,%edx
  8025a6:	83 c4 0c             	add    $0xc,%esp
  8025a9:	5e                   	pop    %esi
  8025aa:	5f                   	pop    %edi
  8025ab:	5d                   	pop    %ebp
  8025ac:	c3                   	ret    
  8025ad:	8d 76 00             	lea    0x0(%esi),%esi
  8025b0:	39 e8                	cmp    %ebp,%eax
  8025b2:	77 24                	ja     8025d8 <__udivdi3+0x78>
  8025b4:	0f bd e8             	bsr    %eax,%ebp
  8025b7:	83 f5 1f             	xor    $0x1f,%ebp
  8025ba:	75 3c                	jne    8025f8 <__udivdi3+0x98>
  8025bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8025c0:	39 34 24             	cmp    %esi,(%esp)
  8025c3:	0f 86 9f 00 00 00    	jbe    802668 <__udivdi3+0x108>
  8025c9:	39 d0                	cmp    %edx,%eax
  8025cb:	0f 82 97 00 00 00    	jb     802668 <__udivdi3+0x108>
  8025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	31 d2                	xor    %edx,%edx
  8025da:	31 c0                	xor    %eax,%eax
  8025dc:	83 c4 0c             	add    $0xc,%esp
  8025df:	5e                   	pop    %esi
  8025e0:	5f                   	pop    %edi
  8025e1:	5d                   	pop    %ebp
  8025e2:	c3                   	ret    
  8025e3:	90                   	nop
  8025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e8:	89 f8                	mov    %edi,%eax
  8025ea:	f7 f1                	div    %ecx
  8025ec:	31 d2                	xor    %edx,%edx
  8025ee:	83 c4 0c             	add    $0xc,%esp
  8025f1:	5e                   	pop    %esi
  8025f2:	5f                   	pop    %edi
  8025f3:	5d                   	pop    %ebp
  8025f4:	c3                   	ret    
  8025f5:	8d 76 00             	lea    0x0(%esi),%esi
  8025f8:	89 e9                	mov    %ebp,%ecx
  8025fa:	8b 3c 24             	mov    (%esp),%edi
  8025fd:	d3 e0                	shl    %cl,%eax
  8025ff:	89 c6                	mov    %eax,%esi
  802601:	b8 20 00 00 00       	mov    $0x20,%eax
  802606:	29 e8                	sub    %ebp,%eax
  802608:	89 c1                	mov    %eax,%ecx
  80260a:	d3 ef                	shr    %cl,%edi
  80260c:	89 e9                	mov    %ebp,%ecx
  80260e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802612:	8b 3c 24             	mov    (%esp),%edi
  802615:	09 74 24 08          	or     %esi,0x8(%esp)
  802619:	89 d6                	mov    %edx,%esi
  80261b:	d3 e7                	shl    %cl,%edi
  80261d:	89 c1                	mov    %eax,%ecx
  80261f:	89 3c 24             	mov    %edi,(%esp)
  802622:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802626:	d3 ee                	shr    %cl,%esi
  802628:	89 e9                	mov    %ebp,%ecx
  80262a:	d3 e2                	shl    %cl,%edx
  80262c:	89 c1                	mov    %eax,%ecx
  80262e:	d3 ef                	shr    %cl,%edi
  802630:	09 d7                	or     %edx,%edi
  802632:	89 f2                	mov    %esi,%edx
  802634:	89 f8                	mov    %edi,%eax
  802636:	f7 74 24 08          	divl   0x8(%esp)
  80263a:	89 d6                	mov    %edx,%esi
  80263c:	89 c7                	mov    %eax,%edi
  80263e:	f7 24 24             	mull   (%esp)
  802641:	39 d6                	cmp    %edx,%esi
  802643:	89 14 24             	mov    %edx,(%esp)
  802646:	72 30                	jb     802678 <__udivdi3+0x118>
  802648:	8b 54 24 04          	mov    0x4(%esp),%edx
  80264c:	89 e9                	mov    %ebp,%ecx
  80264e:	d3 e2                	shl    %cl,%edx
  802650:	39 c2                	cmp    %eax,%edx
  802652:	73 05                	jae    802659 <__udivdi3+0xf9>
  802654:	3b 34 24             	cmp    (%esp),%esi
  802657:	74 1f                	je     802678 <__udivdi3+0x118>
  802659:	89 f8                	mov    %edi,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	e9 7a ff ff ff       	jmp    8025dc <__udivdi3+0x7c>
  802662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802668:	31 d2                	xor    %edx,%edx
  80266a:	b8 01 00 00 00       	mov    $0x1,%eax
  80266f:	e9 68 ff ff ff       	jmp    8025dc <__udivdi3+0x7c>
  802674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802678:	8d 47 ff             	lea    -0x1(%edi),%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	83 c4 0c             	add    $0xc,%esp
  802680:	5e                   	pop    %esi
  802681:	5f                   	pop    %edi
  802682:	5d                   	pop    %ebp
  802683:	c3                   	ret    
  802684:	66 90                	xchg   %ax,%ax
  802686:	66 90                	xchg   %ax,%ax
  802688:	66 90                	xchg   %ax,%ax
  80268a:	66 90                	xchg   %ax,%ax
  80268c:	66 90                	xchg   %ax,%ax
  80268e:	66 90                	xchg   %ax,%ax

00802690 <__umoddi3>:
  802690:	55                   	push   %ebp
  802691:	57                   	push   %edi
  802692:	56                   	push   %esi
  802693:	83 ec 14             	sub    $0x14,%esp
  802696:	8b 44 24 28          	mov    0x28(%esp),%eax
  80269a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80269e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8026a2:	89 c7                	mov    %eax,%edi
  8026a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8026ac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8026b0:	89 34 24             	mov    %esi,(%esp)
  8026b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	89 c2                	mov    %eax,%edx
  8026bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026bf:	75 17                	jne    8026d8 <__umoddi3+0x48>
  8026c1:	39 fe                	cmp    %edi,%esi
  8026c3:	76 4b                	jbe    802710 <__umoddi3+0x80>
  8026c5:	89 c8                	mov    %ecx,%eax
  8026c7:	89 fa                	mov    %edi,%edx
  8026c9:	f7 f6                	div    %esi
  8026cb:	89 d0                	mov    %edx,%eax
  8026cd:	31 d2                	xor    %edx,%edx
  8026cf:	83 c4 14             	add    $0x14,%esp
  8026d2:	5e                   	pop    %esi
  8026d3:	5f                   	pop    %edi
  8026d4:	5d                   	pop    %ebp
  8026d5:	c3                   	ret    
  8026d6:	66 90                	xchg   %ax,%ax
  8026d8:	39 f8                	cmp    %edi,%eax
  8026da:	77 54                	ja     802730 <__umoddi3+0xa0>
  8026dc:	0f bd e8             	bsr    %eax,%ebp
  8026df:	83 f5 1f             	xor    $0x1f,%ebp
  8026e2:	75 5c                	jne    802740 <__umoddi3+0xb0>
  8026e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8026e8:	39 3c 24             	cmp    %edi,(%esp)
  8026eb:	0f 87 e7 00 00 00    	ja     8027d8 <__umoddi3+0x148>
  8026f1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026f5:	29 f1                	sub    %esi,%ecx
  8026f7:	19 c7                	sbb    %eax,%edi
  8026f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802701:	8b 44 24 08          	mov    0x8(%esp),%eax
  802705:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802709:	83 c4 14             	add    $0x14,%esp
  80270c:	5e                   	pop    %esi
  80270d:	5f                   	pop    %edi
  80270e:	5d                   	pop    %ebp
  80270f:	c3                   	ret    
  802710:	85 f6                	test   %esi,%esi
  802712:	89 f5                	mov    %esi,%ebp
  802714:	75 0b                	jne    802721 <__umoddi3+0x91>
  802716:	b8 01 00 00 00       	mov    $0x1,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	f7 f6                	div    %esi
  80271f:	89 c5                	mov    %eax,%ebp
  802721:	8b 44 24 04          	mov    0x4(%esp),%eax
  802725:	31 d2                	xor    %edx,%edx
  802727:	f7 f5                	div    %ebp
  802729:	89 c8                	mov    %ecx,%eax
  80272b:	f7 f5                	div    %ebp
  80272d:	eb 9c                	jmp    8026cb <__umoddi3+0x3b>
  80272f:	90                   	nop
  802730:	89 c8                	mov    %ecx,%eax
  802732:	89 fa                	mov    %edi,%edx
  802734:	83 c4 14             	add    $0x14,%esp
  802737:	5e                   	pop    %esi
  802738:	5f                   	pop    %edi
  802739:	5d                   	pop    %ebp
  80273a:	c3                   	ret    
  80273b:	90                   	nop
  80273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802740:	8b 04 24             	mov    (%esp),%eax
  802743:	be 20 00 00 00       	mov    $0x20,%esi
  802748:	89 e9                	mov    %ebp,%ecx
  80274a:	29 ee                	sub    %ebp,%esi
  80274c:	d3 e2                	shl    %cl,%edx
  80274e:	89 f1                	mov    %esi,%ecx
  802750:	d3 e8                	shr    %cl,%eax
  802752:	89 e9                	mov    %ebp,%ecx
  802754:	89 44 24 04          	mov    %eax,0x4(%esp)
  802758:	8b 04 24             	mov    (%esp),%eax
  80275b:	09 54 24 04          	or     %edx,0x4(%esp)
  80275f:	89 fa                	mov    %edi,%edx
  802761:	d3 e0                	shl    %cl,%eax
  802763:	89 f1                	mov    %esi,%ecx
  802765:	89 44 24 08          	mov    %eax,0x8(%esp)
  802769:	8b 44 24 10          	mov    0x10(%esp),%eax
  80276d:	d3 ea                	shr    %cl,%edx
  80276f:	89 e9                	mov    %ebp,%ecx
  802771:	d3 e7                	shl    %cl,%edi
  802773:	89 f1                	mov    %esi,%ecx
  802775:	d3 e8                	shr    %cl,%eax
  802777:	89 e9                	mov    %ebp,%ecx
  802779:	09 f8                	or     %edi,%eax
  80277b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80277f:	f7 74 24 04          	divl   0x4(%esp)
  802783:	d3 e7                	shl    %cl,%edi
  802785:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802789:	89 d7                	mov    %edx,%edi
  80278b:	f7 64 24 08          	mull   0x8(%esp)
  80278f:	39 d7                	cmp    %edx,%edi
  802791:	89 c1                	mov    %eax,%ecx
  802793:	89 14 24             	mov    %edx,(%esp)
  802796:	72 2c                	jb     8027c4 <__umoddi3+0x134>
  802798:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80279c:	72 22                	jb     8027c0 <__umoddi3+0x130>
  80279e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8027a2:	29 c8                	sub    %ecx,%eax
  8027a4:	19 d7                	sbb    %edx,%edi
  8027a6:	89 e9                	mov    %ebp,%ecx
  8027a8:	89 fa                	mov    %edi,%edx
  8027aa:	d3 e8                	shr    %cl,%eax
  8027ac:	89 f1                	mov    %esi,%ecx
  8027ae:	d3 e2                	shl    %cl,%edx
  8027b0:	89 e9                	mov    %ebp,%ecx
  8027b2:	d3 ef                	shr    %cl,%edi
  8027b4:	09 d0                	or     %edx,%eax
  8027b6:	89 fa                	mov    %edi,%edx
  8027b8:	83 c4 14             	add    $0x14,%esp
  8027bb:	5e                   	pop    %esi
  8027bc:	5f                   	pop    %edi
  8027bd:	5d                   	pop    %ebp
  8027be:	c3                   	ret    
  8027bf:	90                   	nop
  8027c0:	39 d7                	cmp    %edx,%edi
  8027c2:	75 da                	jne    80279e <__umoddi3+0x10e>
  8027c4:	8b 14 24             	mov    (%esp),%edx
  8027c7:	89 c1                	mov    %eax,%ecx
  8027c9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8027cd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8027d1:	eb cb                	jmp    80279e <__umoddi3+0x10e>
  8027d3:	90                   	nop
  8027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8027dc:	0f 82 0f ff ff ff    	jb     8026f1 <__umoddi3+0x61>
  8027e2:	e9 1a ff ff ff       	jmp    802701 <__umoddi3+0x71>
