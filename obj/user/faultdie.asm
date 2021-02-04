
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 61 00 00 00       	call   800092 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
  800046:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800049:	8b 50 04             	mov    0x4(%eax),%edx
  80004c:	83 e2 07             	and    $0x7,%edx
  80004f:	89 54 24 08          	mov    %edx,0x8(%esp)
  800053:	8b 00                	mov    (%eax),%eax
  800055:	89 44 24 04          	mov    %eax,0x4(%esp)
  800059:	c7 04 24 a0 27 80 00 	movl   $0x8027a0,(%esp)
  800060:	e8 35 01 00 00       	call   80019a <cprintf>
	sys_env_destroy(sys_getenvid());
  800065:	e8 3b 0b 00 00       	call   800ba5 <sys_getenvid>
  80006a:	89 04 24             	mov    %eax,(%esp)
  80006d:	e8 e1 0a 00 00       	call   800b53 <sys_env_destroy>
}
  800072:	c9                   	leave  
  800073:	c3                   	ret    

00800074 <umain>:

void
umain(int argc, char **argv)
{
  800074:	55                   	push   %ebp
  800075:	89 e5                	mov    %esp,%ebp
  800077:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  80007a:	c7 04 24 40 00 80 00 	movl   $0x800040,(%esp)
  800081:	e8 82 0f 00 00       	call   801008 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800086:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  80008d:	00 00 00 
}
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	83 ec 10             	sub    $0x10,%esp
  80009a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8000a0:	e8 00 0b 00 00       	call   800ba5 <sys_getenvid>
  8000a5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000aa:	89 c2                	mov    %eax,%edx
  8000ac:	c1 e2 07             	shl    $0x7,%edx
  8000af:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8000b6:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bb:	85 db                	test   %ebx,%ebx
  8000bd:	7e 07                	jle    8000c6 <libmain+0x34>
		binaryname = argv[0];
  8000bf:	8b 06                	mov    (%esi),%eax
  8000c1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000ca:	89 1c 24             	mov    %ebx,(%esp)
  8000cd:	e8 a2 ff ff ff       	call   800074 <umain>

	// exit gracefully
	exit();
  8000d2:	e8 07 00 00 00       	call   8000de <exit>
}
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5d                   	pop    %ebp
  8000dd:	c3                   	ret    

008000de <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000de:	55                   	push   %ebp
  8000df:	89 e5                	mov    %esp,%ebp
  8000e1:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000e4:	e8 b1 11 00 00       	call   80129a <close_all>
	sys_env_destroy(0);
  8000e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f0:	e8 5e 0a 00 00       	call   800b53 <sys_env_destroy>
}
  8000f5:	c9                   	leave  
  8000f6:	c3                   	ret    

008000f7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	53                   	push   %ebx
  8000fb:	83 ec 14             	sub    $0x14,%esp
  8000fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800101:	8b 13                	mov    (%ebx),%edx
  800103:	8d 42 01             	lea    0x1(%edx),%eax
  800106:	89 03                	mov    %eax,(%ebx)
  800108:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800114:	75 19                	jne    80012f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800116:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80011d:	00 
  80011e:	8d 43 08             	lea    0x8(%ebx),%eax
  800121:	89 04 24             	mov    %eax,(%esp)
  800124:	e8 ed 09 00 00       	call   800b16 <sys_cputs>
		b->idx = 0;
  800129:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80012f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800133:	83 c4 14             	add    $0x14,%esp
  800136:	5b                   	pop    %ebx
  800137:	5d                   	pop    %ebp
  800138:	c3                   	ret    

00800139 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800142:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800149:	00 00 00 
	b.cnt = 0;
  80014c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800153:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800156:	8b 45 0c             	mov    0xc(%ebp),%eax
  800159:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015d:	8b 45 08             	mov    0x8(%ebp),%eax
  800160:	89 44 24 08          	mov    %eax,0x8(%esp)
  800164:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016e:	c7 04 24 f7 00 80 00 	movl   $0x8000f7,(%esp)
  800175:	e8 b4 01 00 00       	call   80032e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800180:	89 44 24 04          	mov    %eax,0x4(%esp)
  800184:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018a:	89 04 24             	mov    %eax,(%esp)
  80018d:	e8 84 09 00 00       	call   800b16 <sys_cputs>

	return b.cnt;
}
  800192:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800198:	c9                   	leave  
  800199:	c3                   	ret    

0080019a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001aa:	89 04 24             	mov    %eax,(%esp)
  8001ad:	e8 87 ff ff ff       	call   800139 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    
  8001b4:	66 90                	xchg   %ax,%ax
  8001b6:	66 90                	xchg   %ax,%ax
  8001b8:	66 90                	xchg   %ax,%ax
  8001ba:	66 90                	xchg   %ax,%ax
  8001bc:	66 90                	xchg   %ax,%ax
  8001be:	66 90                	xchg   %ax,%ax

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 3c             	sub    $0x3c,%esp
  8001c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001cc:	89 d7                	mov    %edx,%edi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	89 c3                	mov    %eax,%ebx
  8001d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ed:	39 d9                	cmp    %ebx,%ecx
  8001ef:	72 05                	jb     8001f6 <printnum+0x36>
  8001f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001f4:	77 69                	ja     80025f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001fd:	83 ee 01             	sub    $0x1,%esi
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	89 44 24 08          	mov    %eax,0x8(%esp)
  800208:	8b 44 24 08          	mov    0x8(%esp),%eax
  80020c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800210:	89 c3                	mov    %eax,%ebx
  800212:	89 d6                	mov    %edx,%esi
  800214:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800217:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80021a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80021e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	89 04 24             	mov    %eax,(%esp)
  800228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022f:	e8 dc 22 00 00       	call   802510 <__udivdi3>
  800234:	89 d9                	mov    %ebx,%ecx
  800236:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80023a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80023e:	89 04 24             	mov    %eax,(%esp)
  800241:	89 54 24 04          	mov    %edx,0x4(%esp)
  800245:	89 fa                	mov    %edi,%edx
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	e8 71 ff ff ff       	call   8001c0 <printnum>
  80024f:	eb 1b                	jmp    80026c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800251:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800255:	8b 45 18             	mov    0x18(%ebp),%eax
  800258:	89 04 24             	mov    %eax,(%esp)
  80025b:	ff d3                	call   *%ebx
  80025d:	eb 03                	jmp    800262 <printnum+0xa2>
  80025f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800262:	83 ee 01             	sub    $0x1,%esi
  800265:	85 f6                	test   %esi,%esi
  800267:	7f e8                	jg     800251 <printnum+0x91>
  800269:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800270:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800274:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800277:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80027a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80027e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 ac 23 00 00       	call   802640 <__umoddi3>
  800294:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800298:	0f be 80 c6 27 80 00 	movsbl 0x8027c6(%eax),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	ff d0                	call   *%eax
}
  8002a7:	83 c4 3c             	add    $0x3c,%esp
  8002aa:	5b                   	pop    %ebx
  8002ab:	5e                   	pop    %esi
  8002ac:	5f                   	pop    %edi
  8002ad:	5d                   	pop    %ebp
  8002ae:	c3                   	ret    

008002af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002b2:	83 fa 01             	cmp    $0x1,%edx
  8002b5:	7e 0e                	jle    8002c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002b7:	8b 10                	mov    (%eax),%edx
  8002b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002bc:	89 08                	mov    %ecx,(%eax)
  8002be:	8b 02                	mov    (%edx),%eax
  8002c0:	8b 52 04             	mov    0x4(%edx),%edx
  8002c3:	eb 22                	jmp    8002e7 <getuint+0x38>
	else if (lflag)
  8002c5:	85 d2                	test   %edx,%edx
  8002c7:	74 10                	je     8002d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002c9:	8b 10                	mov    (%eax),%edx
  8002cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ce:	89 08                	mov    %ecx,(%eax)
  8002d0:	8b 02                	mov    (%edx),%eax
  8002d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d7:	eb 0e                	jmp    8002e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002d9:	8b 10                	mov    (%eax),%edx
  8002db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002de:	89 08                	mov    %ecx,(%eax)
  8002e0:	8b 02                	mov    (%edx),%eax
  8002e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f3:	8b 10                	mov    (%eax),%edx
  8002f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f8:	73 0a                	jae    800304 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fd:	89 08                	mov    %ecx,(%eax)
  8002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800302:	88 02                	mov    %al,(%edx)
}
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80030c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800313:	8b 45 10             	mov    0x10(%ebp),%eax
  800316:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	89 04 24             	mov    %eax,(%esp)
  800327:	e8 02 00 00 00       	call   80032e <vprintfmt>
	va_end(ap);
}
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	57                   	push   %edi
  800332:	56                   	push   %esi
  800333:	53                   	push   %ebx
  800334:	83 ec 3c             	sub    $0x3c,%esp
  800337:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80033a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80033d:	eb 14                	jmp    800353 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80033f:	85 c0                	test   %eax,%eax
  800341:	0f 84 b3 03 00 00    	je     8006fa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800347:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80034b:	89 04 24             	mov    %eax,(%esp)
  80034e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800351:	89 f3                	mov    %esi,%ebx
  800353:	8d 73 01             	lea    0x1(%ebx),%esi
  800356:	0f b6 03             	movzbl (%ebx),%eax
  800359:	83 f8 25             	cmp    $0x25,%eax
  80035c:	75 e1                	jne    80033f <vprintfmt+0x11>
  80035e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800362:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800369:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800370:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800377:	ba 00 00 00 00       	mov    $0x0,%edx
  80037c:	eb 1d                	jmp    80039b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80037e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800380:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800384:	eb 15                	jmp    80039b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800386:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800388:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80038c:	eb 0d                	jmp    80039b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800394:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80039b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80039e:	0f b6 0e             	movzbl (%esi),%ecx
  8003a1:	0f b6 c1             	movzbl %cl,%eax
  8003a4:	83 e9 23             	sub    $0x23,%ecx
  8003a7:	80 f9 55             	cmp    $0x55,%cl
  8003aa:	0f 87 2a 03 00 00    	ja     8006da <vprintfmt+0x3ac>
  8003b0:	0f b6 c9             	movzbl %cl,%ecx
  8003b3:	ff 24 8d 40 29 80 00 	jmp    *0x802940(,%ecx,4)
  8003ba:	89 de                	mov    %ebx,%esi
  8003bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003c1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003c8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003ce:	83 fb 09             	cmp    $0x9,%ebx
  8003d1:	77 36                	ja     800409 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003d3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003d6:	eb e9                	jmp    8003c1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	8d 48 04             	lea    0x4(%eax),%ecx
  8003de:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003e8:	eb 22                	jmp    80040c <vprintfmt+0xde>
  8003ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ed:	85 c9                	test   %ecx,%ecx
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	0f 49 c1             	cmovns %ecx,%eax
  8003f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	89 de                	mov    %ebx,%esi
  8003fc:	eb 9d                	jmp    80039b <vprintfmt+0x6d>
  8003fe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800400:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800407:	eb 92                	jmp    80039b <vprintfmt+0x6d>
  800409:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80040c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800410:	79 89                	jns    80039b <vprintfmt+0x6d>
  800412:	e9 77 ff ff ff       	jmp    80038e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800417:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80041c:	e9 7a ff ff ff       	jmp    80039b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	89 55 14             	mov    %edx,0x14(%ebp)
  80042a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 04 24             	mov    %eax,(%esp)
  800433:	ff 55 08             	call   *0x8(%ebp)
			break;
  800436:	e9 18 ff ff ff       	jmp    800353 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80043b:	8b 45 14             	mov    0x14(%ebp),%eax
  80043e:	8d 50 04             	lea    0x4(%eax),%edx
  800441:	89 55 14             	mov    %edx,0x14(%ebp)
  800444:	8b 00                	mov    (%eax),%eax
  800446:	99                   	cltd   
  800447:	31 d0                	xor    %edx,%eax
  800449:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044b:	83 f8 12             	cmp    $0x12,%eax
  80044e:	7f 0b                	jg     80045b <vprintfmt+0x12d>
  800450:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  800457:	85 d2                	test   %edx,%edx
  800459:	75 20                	jne    80047b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80045b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045f:	c7 44 24 08 de 27 80 	movl   $0x8027de,0x8(%esp)
  800466:	00 
  800467:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	89 04 24             	mov    %eax,(%esp)
  800471:	e8 90 fe ff ff       	call   800306 <printfmt>
  800476:	e9 d8 fe ff ff       	jmp    800353 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80047b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80047f:	c7 44 24 08 45 2c 80 	movl   $0x802c45,0x8(%esp)
  800486:	00 
  800487:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 04 24             	mov    %eax,(%esp)
  800491:	e8 70 fe ff ff       	call   800306 <printfmt>
  800496:	e9 b8 fe ff ff       	jmp    800353 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80049e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 50 04             	lea    0x4(%eax),%edx
  8004aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004af:	85 f6                	test   %esi,%esi
  8004b1:	b8 d7 27 80 00       	mov    $0x8027d7,%eax
  8004b6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8004b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004bd:	0f 84 97 00 00 00    	je     80055a <vprintfmt+0x22c>
  8004c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004c7:	0f 8e 9b 00 00 00    	jle    800568 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004d1:	89 34 24             	mov    %esi,(%esp)
  8004d4:	e8 cf 02 00 00       	call   8007a8 <strnlen>
  8004d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004dc:	29 c2                	sub    %eax,%edx
  8004de:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004f1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f3:	eb 0f                	jmp    800504 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004fc:	89 04 24             	mov    %eax,(%esp)
  8004ff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800501:	83 eb 01             	sub    $0x1,%ebx
  800504:	85 db                	test   %ebx,%ebx
  800506:	7f ed                	jg     8004f5 <vprintfmt+0x1c7>
  800508:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80050b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	0f 49 c2             	cmovns %edx,%eax
  800518:	29 c2                	sub    %eax,%edx
  80051a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80051d:	89 d7                	mov    %edx,%edi
  80051f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800522:	eb 50                	jmp    800574 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800524:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800528:	74 1e                	je     800548 <vprintfmt+0x21a>
  80052a:	0f be d2             	movsbl %dl,%edx
  80052d:	83 ea 20             	sub    $0x20,%edx
  800530:	83 fa 5e             	cmp    $0x5e,%edx
  800533:	76 13                	jbe    800548 <vprintfmt+0x21a>
					putch('?', putdat);
  800535:	8b 45 0c             	mov    0xc(%ebp),%eax
  800538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800543:	ff 55 08             	call   *0x8(%ebp)
  800546:	eb 0d                	jmp    800555 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80054f:	89 04 24             	mov    %eax,(%esp)
  800552:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800555:	83 ef 01             	sub    $0x1,%edi
  800558:	eb 1a                	jmp    800574 <vprintfmt+0x246>
  80055a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80055d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800560:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800563:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800566:	eb 0c                	jmp    800574 <vprintfmt+0x246>
  800568:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80056b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80056e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800571:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800574:	83 c6 01             	add    $0x1,%esi
  800577:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80057b:	0f be c2             	movsbl %dl,%eax
  80057e:	85 c0                	test   %eax,%eax
  800580:	74 27                	je     8005a9 <vprintfmt+0x27b>
  800582:	85 db                	test   %ebx,%ebx
  800584:	78 9e                	js     800524 <vprintfmt+0x1f6>
  800586:	83 eb 01             	sub    $0x1,%ebx
  800589:	79 99                	jns    800524 <vprintfmt+0x1f6>
  80058b:	89 f8                	mov    %edi,%eax
  80058d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800590:	8b 75 08             	mov    0x8(%ebp),%esi
  800593:	89 c3                	mov    %eax,%ebx
  800595:	eb 1a                	jmp    8005b1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800597:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005a2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a4:	83 eb 01             	sub    $0x1,%ebx
  8005a7:	eb 08                	jmp    8005b1 <vprintfmt+0x283>
  8005a9:	89 fb                	mov    %edi,%ebx
  8005ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005b1:	85 db                	test   %ebx,%ebx
  8005b3:	7f e2                	jg     800597 <vprintfmt+0x269>
  8005b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005bb:	e9 93 fd ff ff       	jmp    800353 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005c0:	83 fa 01             	cmp    $0x1,%edx
  8005c3:	7e 16                	jle    8005db <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8d 50 08             	lea    0x8(%eax),%edx
  8005cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ce:	8b 50 04             	mov    0x4(%eax),%edx
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005d9:	eb 32                	jmp    80060d <vprintfmt+0x2df>
	else if (lflag)
  8005db:	85 d2                	test   %edx,%edx
  8005dd:	74 18                	je     8005f7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 50 04             	lea    0x4(%eax),%edx
  8005e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e8:	8b 30                	mov    (%eax),%esi
  8005ea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005ed:	89 f0                	mov    %esi,%eax
  8005ef:	c1 f8 1f             	sar    $0x1f,%eax
  8005f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005f5:	eb 16                	jmp    80060d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 50 04             	lea    0x4(%eax),%edx
  8005fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800600:	8b 30                	mov    (%eax),%esi
  800602:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800605:	89 f0                	mov    %esi,%eax
  800607:	c1 f8 1f             	sar    $0x1f,%eax
  80060a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800613:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061c:	0f 89 80 00 00 00    	jns    8006a2 <vprintfmt+0x374>
				putch('-', putdat);
  800622:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800626:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80062d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800630:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800636:	f7 d8                	neg    %eax
  800638:	83 d2 00             	adc    $0x0,%edx
  80063b:	f7 da                	neg    %edx
			}
			base = 10;
  80063d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800642:	eb 5e                	jmp    8006a2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800644:	8d 45 14             	lea    0x14(%ebp),%eax
  800647:	e8 63 fc ff ff       	call   8002af <getuint>
			base = 10;
  80064c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800651:	eb 4f                	jmp    8006a2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800653:	8d 45 14             	lea    0x14(%ebp),%eax
  800656:	e8 54 fc ff ff       	call   8002af <getuint>
			base = 8;
  80065b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800660:	eb 40                	jmp    8006a2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800662:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800666:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80066d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800670:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800674:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80067b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 50 04             	lea    0x4(%eax),%edx
  800684:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80068e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800693:	eb 0d                	jmp    8006a2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800695:	8d 45 14             	lea    0x14(%ebp),%eax
  800698:	e8 12 fc ff ff       	call   8002af <getuint>
			base = 16;
  80069d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006aa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006b5:	89 04 24             	mov    %eax,(%esp)
  8006b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006bc:	89 fa                	mov    %edi,%edx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	e8 fa fa ff ff       	call   8001c0 <printnum>
			break;
  8006c6:	e9 88 fc ff ff       	jmp    800353 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006cb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006d5:	e9 79 fc ff ff       	jmp    800353 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006de:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006e5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e8:	89 f3                	mov    %esi,%ebx
  8006ea:	eb 03                	jmp    8006ef <vprintfmt+0x3c1>
  8006ec:	83 eb 01             	sub    $0x1,%ebx
  8006ef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006f3:	75 f7                	jne    8006ec <vprintfmt+0x3be>
  8006f5:	e9 59 fc ff ff       	jmp    800353 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006fa:	83 c4 3c             	add    $0x3c,%esp
  8006fd:	5b                   	pop    %ebx
  8006fe:	5e                   	pop    %esi
  8006ff:	5f                   	pop    %edi
  800700:	5d                   	pop    %ebp
  800701:	c3                   	ret    

00800702 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 28             	sub    $0x28,%esp
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800711:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800715:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800718:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071f:	85 c0                	test   %eax,%eax
  800721:	74 30                	je     800753 <vsnprintf+0x51>
  800723:	85 d2                	test   %edx,%edx
  800725:	7e 2c                	jle    800753 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	89 44 24 08          	mov    %eax,0x8(%esp)
  800735:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800738:	89 44 24 04          	mov    %eax,0x4(%esp)
  80073c:	c7 04 24 e9 02 80 00 	movl   $0x8002e9,(%esp)
  800743:	e8 e6 fb ff ff       	call   80032e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80074b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800751:	eb 05                	jmp    800758 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800760:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800763:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800767:	8b 45 10             	mov    0x10(%ebp),%eax
  80076a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800771:	89 44 24 04          	mov    %eax,0x4(%esp)
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 04 24             	mov    %eax,(%esp)
  80077b:	e8 82 ff ff ff       	call   800702 <vsnprintf>
	va_end(ap);

	return rc;
}
  800780:	c9                   	leave  
  800781:	c3                   	ret    
  800782:	66 90                	xchg   %ax,%ax
  800784:	66 90                	xchg   %ax,%ax
  800786:	66 90                	xchg   %ax,%ax
  800788:	66 90                	xchg   %ax,%ax
  80078a:	66 90                	xchg   %ax,%ax
  80078c:	66 90                	xchg   %ax,%ax
  80078e:	66 90                	xchg   %ax,%ax

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
  80079b:	eb 03                	jmp    8007a0 <strlen+0x10>
		n++;
  80079d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a4:	75 f7                	jne    80079d <strlen+0xd>
		n++;
	return n;
}
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b6:	eb 03                	jmp    8007bb <strnlen+0x13>
		n++;
  8007b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bb:	39 d0                	cmp    %edx,%eax
  8007bd:	74 06                	je     8007c5 <strnlen+0x1d>
  8007bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c3:	75 f3                	jne    8007b8 <strnlen+0x10>
		n++;
	return n;
}
  8007c5:	5d                   	pop    %ebp
  8007c6:	c3                   	ret    

008007c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	53                   	push   %ebx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d1:	89 c2                	mov    %eax,%edx
  8007d3:	83 c2 01             	add    $0x1,%edx
  8007d6:	83 c1 01             	add    $0x1,%ecx
  8007d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e0:	84 db                	test   %bl,%bl
  8007e2:	75 ef                	jne    8007d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007e4:	5b                   	pop    %ebx
  8007e5:	5d                   	pop    %ebp
  8007e6:	c3                   	ret    

008007e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f1:	89 1c 24             	mov    %ebx,(%esp)
  8007f4:	e8 97 ff ff ff       	call   800790 <strlen>
	strcpy(dst + len, src);
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800800:	01 d8                	add    %ebx,%eax
  800802:	89 04 24             	mov    %eax,(%esp)
  800805:	e8 bd ff ff ff       	call   8007c7 <strcpy>
	return dst;
}
  80080a:	89 d8                	mov    %ebx,%eax
  80080c:	83 c4 08             	add    $0x8,%esp
  80080f:	5b                   	pop    %ebx
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	56                   	push   %esi
  800816:	53                   	push   %ebx
  800817:	8b 75 08             	mov    0x8(%ebp),%esi
  80081a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081d:	89 f3                	mov    %esi,%ebx
  80081f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800822:	89 f2                	mov    %esi,%edx
  800824:	eb 0f                	jmp    800835 <strncpy+0x23>
		*dst++ = *src;
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	0f b6 01             	movzbl (%ecx),%eax
  80082c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80082f:	80 39 01             	cmpb   $0x1,(%ecx)
  800832:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800835:	39 da                	cmp    %ebx,%edx
  800837:	75 ed                	jne    800826 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800839:	89 f0                	mov    %esi,%eax
  80083b:	5b                   	pop    %ebx
  80083c:	5e                   	pop    %esi
  80083d:	5d                   	pop    %ebp
  80083e:	c3                   	ret    

0080083f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	56                   	push   %esi
  800843:	53                   	push   %ebx
  800844:	8b 75 08             	mov    0x8(%ebp),%esi
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800853:	85 c9                	test   %ecx,%ecx
  800855:	75 0b                	jne    800862 <strlcpy+0x23>
  800857:	eb 1d                	jmp    800876 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800859:	83 c0 01             	add    $0x1,%eax
  80085c:	83 c2 01             	add    $0x1,%edx
  80085f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800862:	39 d8                	cmp    %ebx,%eax
  800864:	74 0b                	je     800871 <strlcpy+0x32>
  800866:	0f b6 0a             	movzbl (%edx),%ecx
  800869:	84 c9                	test   %cl,%cl
  80086b:	75 ec                	jne    800859 <strlcpy+0x1a>
  80086d:	89 c2                	mov    %eax,%edx
  80086f:	eb 02                	jmp    800873 <strlcpy+0x34>
  800871:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800873:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800876:	29 f0                	sub    %esi,%eax
}
  800878:	5b                   	pop    %ebx
  800879:	5e                   	pop    %esi
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800885:	eb 06                	jmp    80088d <strcmp+0x11>
		p++, q++;
  800887:	83 c1 01             	add    $0x1,%ecx
  80088a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80088d:	0f b6 01             	movzbl (%ecx),%eax
  800890:	84 c0                	test   %al,%al
  800892:	74 04                	je     800898 <strcmp+0x1c>
  800894:	3a 02                	cmp    (%edx),%al
  800896:	74 ef                	je     800887 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800898:	0f b6 c0             	movzbl %al,%eax
  80089b:	0f b6 12             	movzbl (%edx),%edx
  80089e:	29 d0                	sub    %edx,%eax
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	53                   	push   %ebx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 c3                	mov    %eax,%ebx
  8008ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b1:	eb 06                	jmp    8008b9 <strncmp+0x17>
		n--, p++, q++;
  8008b3:	83 c0 01             	add    $0x1,%eax
  8008b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008b9:	39 d8                	cmp    %ebx,%eax
  8008bb:	74 15                	je     8008d2 <strncmp+0x30>
  8008bd:	0f b6 08             	movzbl (%eax),%ecx
  8008c0:	84 c9                	test   %cl,%cl
  8008c2:	74 04                	je     8008c8 <strncmp+0x26>
  8008c4:	3a 0a                	cmp    (%edx),%cl
  8008c6:	74 eb                	je     8008b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c8:	0f b6 00             	movzbl (%eax),%eax
  8008cb:	0f b6 12             	movzbl (%edx),%edx
  8008ce:	29 d0                	sub    %edx,%eax
  8008d0:	eb 05                	jmp    8008d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008d7:	5b                   	pop    %ebx
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e4:	eb 07                	jmp    8008ed <strchr+0x13>
		if (*s == c)
  8008e6:	38 ca                	cmp    %cl,%dl
  8008e8:	74 0f                	je     8008f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	0f b6 10             	movzbl (%eax),%edx
  8008f0:	84 d2                	test   %dl,%dl
  8008f2:	75 f2                	jne    8008e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800905:	eb 07                	jmp    80090e <strfind+0x13>
		if (*s == c)
  800907:	38 ca                	cmp    %cl,%dl
  800909:	74 0a                	je     800915 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	0f b6 10             	movzbl (%eax),%edx
  800911:	84 d2                	test   %dl,%dl
  800913:	75 f2                	jne    800907 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	57                   	push   %edi
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800920:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800923:	85 c9                	test   %ecx,%ecx
  800925:	74 36                	je     80095d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800927:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80092d:	75 28                	jne    800957 <memset+0x40>
  80092f:	f6 c1 03             	test   $0x3,%cl
  800932:	75 23                	jne    800957 <memset+0x40>
		c &= 0xFF;
  800934:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800938:	89 d3                	mov    %edx,%ebx
  80093a:	c1 e3 08             	shl    $0x8,%ebx
  80093d:	89 d6                	mov    %edx,%esi
  80093f:	c1 e6 18             	shl    $0x18,%esi
  800942:	89 d0                	mov    %edx,%eax
  800944:	c1 e0 10             	shl    $0x10,%eax
  800947:	09 f0                	or     %esi,%eax
  800949:	09 c2                	or     %eax,%edx
  80094b:	89 d0                	mov    %edx,%eax
  80094d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80094f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800952:	fc                   	cld    
  800953:	f3 ab                	rep stos %eax,%es:(%edi)
  800955:	eb 06                	jmp    80095d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	fc                   	cld    
  80095b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095d:	89 f8                	mov    %edi,%eax
  80095f:	5b                   	pop    %ebx
  800960:	5e                   	pop    %esi
  800961:	5f                   	pop    %edi
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	57                   	push   %edi
  800968:	56                   	push   %esi
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800972:	39 c6                	cmp    %eax,%esi
  800974:	73 35                	jae    8009ab <memmove+0x47>
  800976:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800979:	39 d0                	cmp    %edx,%eax
  80097b:	73 2e                	jae    8009ab <memmove+0x47>
		s += n;
		d += n;
  80097d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800980:	89 d6                	mov    %edx,%esi
  800982:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800984:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098a:	75 13                	jne    80099f <memmove+0x3b>
  80098c:	f6 c1 03             	test   $0x3,%cl
  80098f:	75 0e                	jne    80099f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800991:	83 ef 04             	sub    $0x4,%edi
  800994:	8d 72 fc             	lea    -0x4(%edx),%esi
  800997:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80099a:	fd                   	std    
  80099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099d:	eb 09                	jmp    8009a8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099f:	83 ef 01             	sub    $0x1,%edi
  8009a2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a8:	fc                   	cld    
  8009a9:	eb 1d                	jmp    8009c8 <memmove+0x64>
  8009ab:	89 f2                	mov    %esi,%edx
  8009ad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009af:	f6 c2 03             	test   $0x3,%dl
  8009b2:	75 0f                	jne    8009c3 <memmove+0x5f>
  8009b4:	f6 c1 03             	test   $0x3,%cl
  8009b7:	75 0a                	jne    8009c3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009bc:	89 c7                	mov    %eax,%edi
  8009be:	fc                   	cld    
  8009bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c1:	eb 05                	jmp    8009c8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009c3:	89 c7                	mov    %eax,%edi
  8009c5:	fc                   	cld    
  8009c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 04 24             	mov    %eax,(%esp)
  8009e6:	e8 79 ff ff ff       	call   800964 <memmove>
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	56                   	push   %esi
  8009f1:	53                   	push   %ebx
  8009f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f8:	89 d6                	mov    %edx,%esi
  8009fa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fd:	eb 1a                	jmp    800a19 <memcmp+0x2c>
		if (*s1 != *s2)
  8009ff:	0f b6 02             	movzbl (%edx),%eax
  800a02:	0f b6 19             	movzbl (%ecx),%ebx
  800a05:	38 d8                	cmp    %bl,%al
  800a07:	74 0a                	je     800a13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a09:	0f b6 c0             	movzbl %al,%eax
  800a0c:	0f b6 db             	movzbl %bl,%ebx
  800a0f:	29 d8                	sub    %ebx,%eax
  800a11:	eb 0f                	jmp    800a22 <memcmp+0x35>
		s1++, s2++;
  800a13:	83 c2 01             	add    $0x1,%edx
  800a16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a19:	39 f2                	cmp    %esi,%edx
  800a1b:	75 e2                	jne    8009ff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a22:	5b                   	pop    %ebx
  800a23:	5e                   	pop    %esi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a34:	eb 07                	jmp    800a3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a36:	38 08                	cmp    %cl,(%eax)
  800a38:	74 07                	je     800a41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	39 d0                	cmp    %edx,%eax
  800a3f:	72 f5                	jb     800a36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	57                   	push   %edi
  800a47:	56                   	push   %esi
  800a48:	53                   	push   %ebx
  800a49:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4f:	eb 03                	jmp    800a54 <strtol+0x11>
		s++;
  800a51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a54:	0f b6 0a             	movzbl (%edx),%ecx
  800a57:	80 f9 09             	cmp    $0x9,%cl
  800a5a:	74 f5                	je     800a51 <strtol+0xe>
  800a5c:	80 f9 20             	cmp    $0x20,%cl
  800a5f:	74 f0                	je     800a51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a61:	80 f9 2b             	cmp    $0x2b,%cl
  800a64:	75 0a                	jne    800a70 <strtol+0x2d>
		s++;
  800a66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a69:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6e:	eb 11                	jmp    800a81 <strtol+0x3e>
  800a70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a75:	80 f9 2d             	cmp    $0x2d,%cl
  800a78:	75 07                	jne    800a81 <strtol+0x3e>
		s++, neg = 1;
  800a7a:	8d 52 01             	lea    0x1(%edx),%edx
  800a7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a86:	75 15                	jne    800a9d <strtol+0x5a>
  800a88:	80 3a 30             	cmpb   $0x30,(%edx)
  800a8b:	75 10                	jne    800a9d <strtol+0x5a>
  800a8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a91:	75 0a                	jne    800a9d <strtol+0x5a>
		s += 2, base = 16;
  800a93:	83 c2 02             	add    $0x2,%edx
  800a96:	b8 10 00 00 00       	mov    $0x10,%eax
  800a9b:	eb 10                	jmp    800aad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a9d:	85 c0                	test   %eax,%eax
  800a9f:	75 0c                	jne    800aad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa3:	80 3a 30             	cmpb   $0x30,(%edx)
  800aa6:	75 05                	jne    800aad <strtol+0x6a>
		s++, base = 8;
  800aa8:	83 c2 01             	add    $0x1,%edx
  800aab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800aad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ab5:	0f b6 0a             	movzbl (%edx),%ecx
  800ab8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800abb:	89 f0                	mov    %esi,%eax
  800abd:	3c 09                	cmp    $0x9,%al
  800abf:	77 08                	ja     800ac9 <strtol+0x86>
			dig = *s - '0';
  800ac1:	0f be c9             	movsbl %cl,%ecx
  800ac4:	83 e9 30             	sub    $0x30,%ecx
  800ac7:	eb 20                	jmp    800ae9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ac9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800acc:	89 f0                	mov    %esi,%eax
  800ace:	3c 19                	cmp    $0x19,%al
  800ad0:	77 08                	ja     800ada <strtol+0x97>
			dig = *s - 'a' + 10;
  800ad2:	0f be c9             	movsbl %cl,%ecx
  800ad5:	83 e9 57             	sub    $0x57,%ecx
  800ad8:	eb 0f                	jmp    800ae9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800ada:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800add:	89 f0                	mov    %esi,%eax
  800adf:	3c 19                	cmp    $0x19,%al
  800ae1:	77 16                	ja     800af9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ae3:	0f be c9             	movsbl %cl,%ecx
  800ae6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ae9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800aec:	7d 0f                	jge    800afd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800aee:	83 c2 01             	add    $0x1,%edx
  800af1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800af5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800af7:	eb bc                	jmp    800ab5 <strtol+0x72>
  800af9:	89 d8                	mov    %ebx,%eax
  800afb:	eb 02                	jmp    800aff <strtol+0xbc>
  800afd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b03:	74 05                	je     800b0a <strtol+0xc7>
		*endptr = (char *) s;
  800b05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b0a:	f7 d8                	neg    %eax
  800b0c:	85 ff                	test   %edi,%edi
  800b0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	57                   	push   %edi
  800b1a:	56                   	push   %esi
  800b1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b24:	8b 55 08             	mov    0x8(%ebp),%edx
  800b27:	89 c3                	mov    %eax,%ebx
  800b29:	89 c7                	mov    %eax,%edi
  800b2b:	89 c6                	mov    %eax,%esi
  800b2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b44:	89 d1                	mov    %edx,%ecx
  800b46:	89 d3                	mov    %edx,%ebx
  800b48:	89 d7                	mov    %edx,%edi
  800b4a:	89 d6                	mov    %edx,%esi
  800b4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b61:	b8 03 00 00 00       	mov    $0x3,%eax
  800b66:	8b 55 08             	mov    0x8(%ebp),%edx
  800b69:	89 cb                	mov    %ecx,%ebx
  800b6b:	89 cf                	mov    %ecx,%edi
  800b6d:	89 ce                	mov    %ecx,%esi
  800b6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800b71:	85 c0                	test   %eax,%eax
  800b73:	7e 28                	jle    800b9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b80:	00 
  800b81:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800b88:	00 
  800b89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b90:	00 
  800b91:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800b98:	e8 d9 17 00 00       	call   802376 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b9d:	83 c4 2c             	add    $0x2c,%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb5:	89 d1                	mov    %edx,%ecx
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_yield>:

void
sys_yield(void)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bca:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bd4:	89 d1                	mov    %edx,%ecx
  800bd6:	89 d3                	mov    %edx,%ebx
  800bd8:	89 d7                	mov    %edx,%edi
  800bda:	89 d6                	mov    %edx,%esi
  800bdc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bec:	be 00 00 00 00       	mov    $0x0,%esi
  800bf1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bff:	89 f7                	mov    %esi,%edi
  800c01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c03:	85 c0                	test   %eax,%eax
  800c05:	7e 28                	jle    800c2f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c0b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c12:	00 
  800c13:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800c1a:	00 
  800c1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c22:	00 
  800c23:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800c2a:	e8 47 17 00 00       	call   802376 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c2f:	83 c4 2c             	add    $0x2c,%esp
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c40:	b8 05 00 00 00       	mov    $0x5,%eax
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c51:	8b 75 18             	mov    0x18(%ebp),%esi
  800c54:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c56:	85 c0                	test   %eax,%eax
  800c58:	7e 28                	jle    800c82 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c5e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c65:	00 
  800c66:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800c6d:	00 
  800c6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c75:	00 
  800c76:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800c7d:	e8 f4 16 00 00       	call   802376 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c82:	83 c4 2c             	add    $0x2c,%esp
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	b8 06 00 00 00       	mov    $0x6,%eax
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	89 df                	mov    %ebx,%edi
  800ca5:	89 de                	mov    %ebx,%esi
  800ca7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	7e 28                	jle    800cd5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800cb8:	00 
  800cb9:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800cc0:	00 
  800cc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc8:	00 
  800cc9:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800cd0:	e8 a1 16 00 00       	call   802376 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cd5:	83 c4 2c             	add    $0x2c,%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    

00800cdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
  800ce3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ceb:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	89 df                	mov    %ebx,%edi
  800cf8:	89 de                	mov    %ebx,%esi
  800cfa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7e 28                	jle    800d28 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d04:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d0b:	00 
  800d0c:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800d13:	00 
  800d14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d1b:	00 
  800d1c:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800d23:	e8 4e 16 00 00       	call   802376 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d28:	83 c4 2c             	add    $0x2c,%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	89 df                	mov    %ebx,%edi
  800d4b:	89 de                	mov    %ebx,%esi
  800d4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7e 28                	jle    800d7b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d57:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d5e:	00 
  800d5f:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800d66:	00 
  800d67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6e:	00 
  800d6f:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800d76:	e8 fb 15 00 00       	call   802376 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d7b:	83 c4 2c             	add    $0x2c,%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	89 df                	mov    %ebx,%edi
  800d9e:	89 de                	mov    %ebx,%esi
  800da0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7e 28                	jle    800dce <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800daa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800db1:	00 
  800db2:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800db9:	00 
  800dba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc1:	00 
  800dc2:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800dc9:	e8 a8 15 00 00       	call   802376 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dce:	83 c4 2c             	add    $0x2c,%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	be 00 00 00 00       	mov    $0x0,%esi
  800de1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800def:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e07:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0f:	89 cb                	mov    %ecx,%ebx
  800e11:	89 cf                	mov    %ecx,%edi
  800e13:	89 ce                	mov    %ecx,%esi
  800e15:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	7e 28                	jle    800e43 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e26:	00 
  800e27:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800e2e:	00 
  800e2f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e36:	00 
  800e37:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800e3e:	e8 33 15 00 00       	call   802376 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e43:	83 c4 2c             	add    $0x2c,%esp
  800e46:	5b                   	pop    %ebx
  800e47:	5e                   	pop    %esi
  800e48:	5f                   	pop    %edi
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e51:	ba 00 00 00 00       	mov    $0x0,%edx
  800e56:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e5b:	89 d1                	mov    %edx,%ecx
  800e5d:	89 d3                	mov    %edx,%ebx
  800e5f:	89 d7                	mov    %edx,%edi
  800e61:	89 d6                	mov    %edx,%esi
  800e63:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
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
  800e78:	b8 0f 00 00 00       	mov    $0xf,%eax
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
  800e8b:	7e 28                	jle    800eb5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e91:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e98:	00 
  800e99:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea8:	00 
  800ea9:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800eb0:	e8 c1 14 00 00       	call   802376 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800eb5:	83 c4 2c             	add    $0x2c,%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
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
  800ecb:	b8 10 00 00 00       	mov    $0x10,%eax
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
  800ede:	7e 28                	jle    800f08 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800eeb:	00 
  800eec:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efb:	00 
  800efc:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800f03:	e8 6e 14 00 00       	call   802376 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800f08:	83 c4 2c             	add    $0x2c,%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
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
  800f1e:	b8 11 00 00 00       	mov    $0x11,%eax
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
  800f31:	7e 28                	jle    800f5b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f37:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800f46:	00 
  800f47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4e:	00 
  800f4f:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800f56:	e8 1b 14 00 00       	call   802376 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  800f5b:	83 c4 2c             	add    $0x2c,%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_sleep>:

int
sys_sleep(int channel)
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
  800f6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f71:	b8 12 00 00 00       	mov    $0x12,%eax
  800f76:	8b 55 08             	mov    0x8(%ebp),%edx
  800f79:	89 cb                	mov    %ecx,%ebx
  800f7b:	89 cf                	mov    %ecx,%edi
  800f7d:	89 ce                	mov    %ecx,%esi
  800f7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	7e 28                	jle    800fad <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f89:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f90:	00 
  800f91:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800f98:	00 
  800f99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa0:	00 
  800fa1:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800fa8:	e8 c9 13 00 00       	call   802376 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  800fad:	83 c4 2c             	add    $0x2c,%esp
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
  800fbb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc3:	b8 13 00 00 00       	mov    $0x13,%eax
  800fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	89 df                	mov    %ebx,%edi
  800fd0:	89 de                	mov    %ebx,%esi
  800fd2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7e 28                	jle    801000 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fdc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  800fe3:	00 
  800fe4:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800feb:	00 
  800fec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff3:	00 
  800ff4:	c7 04 24 28 2b 80 00 	movl   $0x802b28,(%esp)
  800ffb:	e8 76 13 00 00       	call   802376 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801000:	83 c4 2c             	add    $0x2c,%esp
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5f                   	pop    %edi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80100e:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801015:	75 70                	jne    801087 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  801017:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  80101e:	00 
  80101f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801026:	ee 
  801027:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80102e:	e8 b0 fb ff ff       	call   800be3 <sys_page_alloc>
		if (error < 0)
  801033:	85 c0                	test   %eax,%eax
  801035:	79 1c                	jns    801053 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  801037:	c7 44 24 08 38 2b 80 	movl   $0x802b38,0x8(%esp)
  80103e:	00 
  80103f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801046:	00 
  801047:	c7 04 24 8b 2b 80 00 	movl   $0x802b8b,(%esp)
  80104e:	e8 23 13 00 00       	call   802376 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801053:	c7 44 24 04 91 10 80 	movl   $0x801091,0x4(%esp)
  80105a:	00 
  80105b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801062:	e8 1c fd ff ff       	call   800d83 <sys_env_set_pgfault_upcall>
		if (error < 0)
  801067:	85 c0                	test   %eax,%eax
  801069:	79 1c                	jns    801087 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  80106b:	c7 44 24 08 60 2b 80 	movl   $0x802b60,0x8(%esp)
  801072:	00 
  801073:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80107a:	00 
  80107b:	c7 04 24 8b 2b 80 00 	movl   $0x802b8b,(%esp)
  801082:	e8 ef 12 00 00       	call   802376 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    

00801091 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801091:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801092:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801097:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801099:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  80109c:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  8010a0:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  8010a5:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  8010a9:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  8010ab:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8010ae:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8010af:	83 c4 04             	add    $0x4,%esp
	popfl
  8010b2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8010b3:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8010b4:	c3                   	ret    
  8010b5:	66 90                	xchg   %ax,%ax
  8010b7:	66 90                	xchg   %ax,%ax
  8010b9:	66 90                	xchg   %ax,%ax
  8010bb:	66 90                	xchg   %ax,%ax
  8010bd:	66 90                	xchg   %ax,%ax
  8010bf:	90                   	nop

008010c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010e0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010f2:	89 c2                	mov    %eax,%edx
  8010f4:	c1 ea 16             	shr    $0x16,%edx
  8010f7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010fe:	f6 c2 01             	test   $0x1,%dl
  801101:	74 11                	je     801114 <fd_alloc+0x2d>
  801103:	89 c2                	mov    %eax,%edx
  801105:	c1 ea 0c             	shr    $0xc,%edx
  801108:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80110f:	f6 c2 01             	test   $0x1,%dl
  801112:	75 09                	jne    80111d <fd_alloc+0x36>
			*fd_store = fd;
  801114:	89 01                	mov    %eax,(%ecx)
			return 0;
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
  80111b:	eb 17                	jmp    801134 <fd_alloc+0x4d>
  80111d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801122:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801127:	75 c9                	jne    8010f2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801129:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80112f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    

00801136 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80113c:	83 f8 1f             	cmp    $0x1f,%eax
  80113f:	77 36                	ja     801177 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801141:	c1 e0 0c             	shl    $0xc,%eax
  801144:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801149:	89 c2                	mov    %eax,%edx
  80114b:	c1 ea 16             	shr    $0x16,%edx
  80114e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801155:	f6 c2 01             	test   $0x1,%dl
  801158:	74 24                	je     80117e <fd_lookup+0x48>
  80115a:	89 c2                	mov    %eax,%edx
  80115c:	c1 ea 0c             	shr    $0xc,%edx
  80115f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801166:	f6 c2 01             	test   $0x1,%dl
  801169:	74 1a                	je     801185 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80116b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116e:	89 02                	mov    %eax,(%edx)
	return 0;
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
  801175:	eb 13                	jmp    80118a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801177:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117c:	eb 0c                	jmp    80118a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80117e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801183:	eb 05                	jmp    80118a <fd_lookup+0x54>
  801185:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	83 ec 18             	sub    $0x18,%esp
  801192:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801195:	ba 00 00 00 00       	mov    $0x0,%edx
  80119a:	eb 13                	jmp    8011af <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80119c:	39 08                	cmp    %ecx,(%eax)
  80119e:	75 0c                	jne    8011ac <dev_lookup+0x20>
			*dev = devtab[i];
  8011a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011aa:	eb 38                	jmp    8011e4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011ac:	83 c2 01             	add    $0x1,%edx
  8011af:	8b 04 95 18 2c 80 00 	mov    0x802c18(,%edx,4),%eax
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 e2                	jne    80119c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8011bf:	8b 40 48             	mov    0x48(%eax),%eax
  8011c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ca:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  8011d1:	e8 c4 ef ff ff       	call   80019a <cprintf>
	*dev = 0;
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	56                   	push   %esi
  8011ea:	53                   	push   %ebx
  8011eb:	83 ec 20             	sub    $0x20,%esp
  8011ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8011f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801201:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801204:	89 04 24             	mov    %eax,(%esp)
  801207:	e8 2a ff ff ff       	call   801136 <fd_lookup>
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 05                	js     801215 <fd_close+0x2f>
	    || fd != fd2)
  801210:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801213:	74 0c                	je     801221 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801215:	84 db                	test   %bl,%bl
  801217:	ba 00 00 00 00       	mov    $0x0,%edx
  80121c:	0f 44 c2             	cmove  %edx,%eax
  80121f:	eb 3f                	jmp    801260 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801221:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801224:	89 44 24 04          	mov    %eax,0x4(%esp)
  801228:	8b 06                	mov    (%esi),%eax
  80122a:	89 04 24             	mov    %eax,(%esp)
  80122d:	e8 5a ff ff ff       	call   80118c <dev_lookup>
  801232:	89 c3                	mov    %eax,%ebx
  801234:	85 c0                	test   %eax,%eax
  801236:	78 16                	js     80124e <fd_close+0x68>
		if (dev->dev_close)
  801238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80123e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801243:	85 c0                	test   %eax,%eax
  801245:	74 07                	je     80124e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801247:	89 34 24             	mov    %esi,(%esp)
  80124a:	ff d0                	call   *%eax
  80124c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80124e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801252:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801259:	e8 2c fa ff ff       	call   800c8a <sys_page_unmap>
	return r;
  80125e:	89 d8                	mov    %ebx,%eax
}
  801260:	83 c4 20             	add    $0x20,%esp
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    

00801267 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80126d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801270:	89 44 24 04          	mov    %eax,0x4(%esp)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	89 04 24             	mov    %eax,(%esp)
  80127a:	e8 b7 fe ff ff       	call   801136 <fd_lookup>
  80127f:	89 c2                	mov    %eax,%edx
  801281:	85 d2                	test   %edx,%edx
  801283:	78 13                	js     801298 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801285:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80128c:	00 
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	89 04 24             	mov    %eax,(%esp)
  801293:	e8 4e ff ff ff       	call   8011e6 <fd_close>
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <close_all>:

void
close_all(void)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	53                   	push   %ebx
  80129e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012a6:	89 1c 24             	mov    %ebx,(%esp)
  8012a9:	e8 b9 ff ff ff       	call   801267 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ae:	83 c3 01             	add    $0x1,%ebx
  8012b1:	83 fb 20             	cmp    $0x20,%ebx
  8012b4:	75 f0                	jne    8012a6 <close_all+0xc>
		close(i);
}
  8012b6:	83 c4 14             	add    $0x14,%esp
  8012b9:	5b                   	pop    %ebx
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	57                   	push   %edi
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	89 04 24             	mov    %eax,(%esp)
  8012d2:	e8 5f fe ff ff       	call   801136 <fd_lookup>
  8012d7:	89 c2                	mov    %eax,%edx
  8012d9:	85 d2                	test   %edx,%edx
  8012db:	0f 88 e1 00 00 00    	js     8013c2 <dup+0x106>
		return r;
	close(newfdnum);
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e4:	89 04 24             	mov    %eax,(%esp)
  8012e7:	e8 7b ff ff ff       	call   801267 <close>

	newfd = INDEX2FD(newfdnum);
  8012ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012ef:	c1 e3 0c             	shl    $0xc,%ebx
  8012f2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012fb:	89 04 24             	mov    %eax,(%esp)
  8012fe:	e8 cd fd ff ff       	call   8010d0 <fd2data>
  801303:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801305:	89 1c 24             	mov    %ebx,(%esp)
  801308:	e8 c3 fd ff ff       	call   8010d0 <fd2data>
  80130d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80130f:	89 f0                	mov    %esi,%eax
  801311:	c1 e8 16             	shr    $0x16,%eax
  801314:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80131b:	a8 01                	test   $0x1,%al
  80131d:	74 43                	je     801362 <dup+0xa6>
  80131f:	89 f0                	mov    %esi,%eax
  801321:	c1 e8 0c             	shr    $0xc,%eax
  801324:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80132b:	f6 c2 01             	test   $0x1,%dl
  80132e:	74 32                	je     801362 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801330:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801337:	25 07 0e 00 00       	and    $0xe07,%eax
  80133c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801340:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801344:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80134b:	00 
  80134c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801350:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801357:	e8 db f8 ff ff       	call   800c37 <sys_page_map>
  80135c:	89 c6                	mov    %eax,%esi
  80135e:	85 c0                	test   %eax,%eax
  801360:	78 3e                	js     8013a0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801365:	89 c2                	mov    %eax,%edx
  801367:	c1 ea 0c             	shr    $0xc,%edx
  80136a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801371:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801377:	89 54 24 10          	mov    %edx,0x10(%esp)
  80137b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80137f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801386:	00 
  801387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801392:	e8 a0 f8 ff ff       	call   800c37 <sys_page_map>
  801397:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801399:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80139c:	85 f6                	test   %esi,%esi
  80139e:	79 22                	jns    8013c2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ab:	e8 da f8 ff ff       	call   800c8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013bb:	e8 ca f8 ff ff       	call   800c8a <sys_page_unmap>
	return r;
  8013c0:	89 f0                	mov    %esi,%eax
}
  8013c2:	83 c4 3c             	add    $0x3c,%esp
  8013c5:	5b                   	pop    %ebx
  8013c6:	5e                   	pop    %esi
  8013c7:	5f                   	pop    %edi
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 24             	sub    $0x24,%esp
  8013d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013db:	89 1c 24             	mov    %ebx,(%esp)
  8013de:	e8 53 fd ff ff       	call   801136 <fd_lookup>
  8013e3:	89 c2                	mov    %eax,%edx
  8013e5:	85 d2                	test   %edx,%edx
  8013e7:	78 6d                	js     801456 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f3:	8b 00                	mov    (%eax),%eax
  8013f5:	89 04 24             	mov    %eax,(%esp)
  8013f8:	e8 8f fd ff ff       	call   80118c <dev_lookup>
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 55                	js     801456 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801404:	8b 50 08             	mov    0x8(%eax),%edx
  801407:	83 e2 03             	and    $0x3,%edx
  80140a:	83 fa 01             	cmp    $0x1,%edx
  80140d:	75 23                	jne    801432 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80140f:	a1 08 40 80 00       	mov    0x804008,%eax
  801414:	8b 40 48             	mov    0x48(%eax),%eax
  801417:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80141b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141f:	c7 04 24 dd 2b 80 00 	movl   $0x802bdd,(%esp)
  801426:	e8 6f ed ff ff       	call   80019a <cprintf>
		return -E_INVAL;
  80142b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801430:	eb 24                	jmp    801456 <read+0x8c>
	}
	if (!dev->dev_read)
  801432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801435:	8b 52 08             	mov    0x8(%edx),%edx
  801438:	85 d2                	test   %edx,%edx
  80143a:	74 15                	je     801451 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80143c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801443:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801446:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80144a:	89 04 24             	mov    %eax,(%esp)
  80144d:	ff d2                	call   *%edx
  80144f:	eb 05                	jmp    801456 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801451:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801456:	83 c4 24             	add    $0x24,%esp
  801459:	5b                   	pop    %ebx
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	57                   	push   %edi
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
  801462:	83 ec 1c             	sub    $0x1c,%esp
  801465:	8b 7d 08             	mov    0x8(%ebp),%edi
  801468:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80146b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801470:	eb 23                	jmp    801495 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801472:	89 f0                	mov    %esi,%eax
  801474:	29 d8                	sub    %ebx,%eax
  801476:	89 44 24 08          	mov    %eax,0x8(%esp)
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	03 45 0c             	add    0xc(%ebp),%eax
  80147f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801483:	89 3c 24             	mov    %edi,(%esp)
  801486:	e8 3f ff ff ff       	call   8013ca <read>
		if (m < 0)
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 10                	js     80149f <readn+0x43>
			return m;
		if (m == 0)
  80148f:	85 c0                	test   %eax,%eax
  801491:	74 0a                	je     80149d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801493:	01 c3                	add    %eax,%ebx
  801495:	39 f3                	cmp    %esi,%ebx
  801497:	72 d9                	jb     801472 <readn+0x16>
  801499:	89 d8                	mov    %ebx,%eax
  80149b:	eb 02                	jmp    80149f <readn+0x43>
  80149d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80149f:	83 c4 1c             	add    $0x1c,%esp
  8014a2:	5b                   	pop    %ebx
  8014a3:	5e                   	pop    %esi
  8014a4:	5f                   	pop    %edi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    

008014a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	53                   	push   %ebx
  8014ab:	83 ec 24             	sub    $0x24,%esp
  8014ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b8:	89 1c 24             	mov    %ebx,(%esp)
  8014bb:	e8 76 fc ff ff       	call   801136 <fd_lookup>
  8014c0:	89 c2                	mov    %eax,%edx
  8014c2:	85 d2                	test   %edx,%edx
  8014c4:	78 68                	js     80152e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d0:	8b 00                	mov    (%eax),%eax
  8014d2:	89 04 24             	mov    %eax,(%esp)
  8014d5:	e8 b2 fc ff ff       	call   80118c <dev_lookup>
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 50                	js     80152e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e5:	75 23                	jne    80150a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8014ec:	8b 40 48             	mov    0x48(%eax),%eax
  8014ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f7:	c7 04 24 f9 2b 80 00 	movl   $0x802bf9,(%esp)
  8014fe:	e8 97 ec ff ff       	call   80019a <cprintf>
		return -E_INVAL;
  801503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801508:	eb 24                	jmp    80152e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80150a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150d:	8b 52 0c             	mov    0xc(%edx),%edx
  801510:	85 d2                	test   %edx,%edx
  801512:	74 15                	je     801529 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801514:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801517:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80151b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80151e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801522:	89 04 24             	mov    %eax,(%esp)
  801525:	ff d2                	call   *%edx
  801527:	eb 05                	jmp    80152e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801529:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80152e:	83 c4 24             	add    $0x24,%esp
  801531:	5b                   	pop    %ebx
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <seek>:

int
seek(int fdnum, off_t offset)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80153a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80153d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 04 24             	mov    %eax,(%esp)
  801547:	e8 ea fb ff ff       	call   801136 <fd_lookup>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 0e                	js     80155e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801550:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	53                   	push   %ebx
  801564:	83 ec 24             	sub    $0x24,%esp
  801567:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801571:	89 1c 24             	mov    %ebx,(%esp)
  801574:	e8 bd fb ff ff       	call   801136 <fd_lookup>
  801579:	89 c2                	mov    %eax,%edx
  80157b:	85 d2                	test   %edx,%edx
  80157d:	78 61                	js     8015e0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801582:	89 44 24 04          	mov    %eax,0x4(%esp)
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801589:	8b 00                	mov    (%eax),%eax
  80158b:	89 04 24             	mov    %eax,(%esp)
  80158e:	e8 f9 fb ff ff       	call   80118c <dev_lookup>
  801593:	85 c0                	test   %eax,%eax
  801595:	78 49                	js     8015e0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80159e:	75 23                	jne    8015c3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015a0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015a5:	8b 40 48             	mov    0x48(%eax),%eax
  8015a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b0:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  8015b7:	e8 de eb ff ff       	call   80019a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c1:	eb 1d                	jmp    8015e0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c6:	8b 52 18             	mov    0x18(%edx),%edx
  8015c9:	85 d2                	test   %edx,%edx
  8015cb:	74 0e                	je     8015db <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015d4:	89 04 24             	mov    %eax,(%esp)
  8015d7:	ff d2                	call   *%edx
  8015d9:	eb 05                	jmp    8015e0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015e0:	83 c4 24             	add    $0x24,%esp
  8015e3:	5b                   	pop    %ebx
  8015e4:	5d                   	pop    %ebp
  8015e5:	c3                   	ret    

008015e6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	53                   	push   %ebx
  8015ea:	83 ec 24             	sub    $0x24,%esp
  8015ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	89 04 24             	mov    %eax,(%esp)
  8015fd:	e8 34 fb ff ff       	call   801136 <fd_lookup>
  801602:	89 c2                	mov    %eax,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	78 52                	js     80165a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801608:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	89 04 24             	mov    %eax,(%esp)
  801617:	e8 70 fb ff ff       	call   80118c <dev_lookup>
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 3a                	js     80165a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801627:	74 2c                	je     801655 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801629:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80162c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801633:	00 00 00 
	stat->st_isdir = 0;
  801636:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80163d:	00 00 00 
	stat->st_dev = dev;
  801640:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801646:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80164a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80164d:	89 14 24             	mov    %edx,(%esp)
  801650:	ff 50 14             	call   *0x14(%eax)
  801653:	eb 05                	jmp    80165a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801655:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80165a:	83 c4 24             	add    $0x24,%esp
  80165d:	5b                   	pop    %ebx
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801668:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80166f:	00 
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	89 04 24             	mov    %eax,(%esp)
  801676:	e8 1b 02 00 00       	call   801896 <open>
  80167b:	89 c3                	mov    %eax,%ebx
  80167d:	85 db                	test   %ebx,%ebx
  80167f:	78 1b                	js     80169c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801681:	8b 45 0c             	mov    0xc(%ebp),%eax
  801684:	89 44 24 04          	mov    %eax,0x4(%esp)
  801688:	89 1c 24             	mov    %ebx,(%esp)
  80168b:	e8 56 ff ff ff       	call   8015e6 <fstat>
  801690:	89 c6                	mov    %eax,%esi
	close(fd);
  801692:	89 1c 24             	mov    %ebx,(%esp)
  801695:	e8 cd fb ff ff       	call   801267 <close>
	return r;
  80169a:	89 f0                	mov    %esi,%eax
}
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	5b                   	pop    %ebx
  8016a0:	5e                   	pop    %esi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    

008016a3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	56                   	push   %esi
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 10             	sub    $0x10,%esp
  8016ab:	89 c6                	mov    %eax,%esi
  8016ad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016af:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016b6:	75 11                	jne    8016c9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016bf:	e8 cb 0d 00 00       	call   80248f <ipc_find_env>
  8016c4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016c9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016d0:	00 
  8016d1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8016d8:	00 
  8016d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016dd:	a1 00 40 80 00       	mov    0x804000,%eax
  8016e2:	89 04 24             	mov    %eax,(%esp)
  8016e5:	e8 3a 0d 00 00       	call   802424 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016f1:	00 
  8016f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fd:	e8 ce 0c 00 00       	call   8023d0 <ipc_recv>
}
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5d                   	pop    %ebp
  801708:	c3                   	ret    

00801709 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8b 40 0c             	mov    0xc(%eax),%eax
  801715:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	b8 02 00 00 00       	mov    $0x2,%eax
  80172c:	e8 72 ff ff ff       	call   8016a3 <fsipc>
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8b 40 0c             	mov    0xc(%eax),%eax
  80173f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	b8 06 00 00 00       	mov    $0x6,%eax
  80174e:	e8 50 ff ff ff       	call   8016a3 <fsipc>
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	53                   	push   %ebx
  801759:	83 ec 14             	sub    $0x14,%esp
  80175c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8b 40 0c             	mov    0xc(%eax),%eax
  801765:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80176a:	ba 00 00 00 00       	mov    $0x0,%edx
  80176f:	b8 05 00 00 00       	mov    $0x5,%eax
  801774:	e8 2a ff ff ff       	call   8016a3 <fsipc>
  801779:	89 c2                	mov    %eax,%edx
  80177b:	85 d2                	test   %edx,%edx
  80177d:	78 2b                	js     8017aa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80177f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801786:	00 
  801787:	89 1c 24             	mov    %ebx,(%esp)
  80178a:	e8 38 f0 ff ff       	call   8007c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80178f:	a1 80 50 80 00       	mov    0x805080,%eax
  801794:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80179a:	a1 84 50 80 00       	mov    0x805084,%eax
  80179f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	83 c4 14             	add    $0x14,%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 18             	sub    $0x18,%esp
  8017b6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8017bf:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8017c5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8017dc:	e8 eb f1 ff ff       	call   8009cc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  8017e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e6:	b8 04 00 00 00       	mov    $0x4,%eax
  8017eb:	e8 b3 fe ff ff       	call   8016a3 <fsipc>
		return r;
	}

	return r;
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	56                   	push   %esi
  8017f6:	53                   	push   %ebx
  8017f7:	83 ec 10             	sub    $0x10,%esp
  8017fa:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 40 0c             	mov    0xc(%eax),%eax
  801803:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801808:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80180e:	ba 00 00 00 00       	mov    $0x0,%edx
  801813:	b8 03 00 00 00       	mov    $0x3,%eax
  801818:	e8 86 fe ff ff       	call   8016a3 <fsipc>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 6a                	js     80188d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801823:	39 c6                	cmp    %eax,%esi
  801825:	73 24                	jae    80184b <devfile_read+0x59>
  801827:	c7 44 24 0c 2c 2c 80 	movl   $0x802c2c,0xc(%esp)
  80182e:	00 
  80182f:	c7 44 24 08 33 2c 80 	movl   $0x802c33,0x8(%esp)
  801836:	00 
  801837:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80183e:	00 
  80183f:	c7 04 24 48 2c 80 00 	movl   $0x802c48,(%esp)
  801846:	e8 2b 0b 00 00       	call   802376 <_panic>
	assert(r <= PGSIZE);
  80184b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801850:	7e 24                	jle    801876 <devfile_read+0x84>
  801852:	c7 44 24 0c 53 2c 80 	movl   $0x802c53,0xc(%esp)
  801859:	00 
  80185a:	c7 44 24 08 33 2c 80 	movl   $0x802c33,0x8(%esp)
  801861:	00 
  801862:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801869:	00 
  80186a:	c7 04 24 48 2c 80 00 	movl   $0x802c48,(%esp)
  801871:	e8 00 0b 00 00       	call   802376 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801876:	89 44 24 08          	mov    %eax,0x8(%esp)
  80187a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801881:	00 
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	89 04 24             	mov    %eax,(%esp)
  801888:	e8 d7 f0 ff ff       	call   800964 <memmove>
	return r;
}
  80188d:	89 d8                	mov    %ebx,%eax
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	5b                   	pop    %ebx
  801893:	5e                   	pop    %esi
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    

00801896 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	53                   	push   %ebx
  80189a:	83 ec 24             	sub    $0x24,%esp
  80189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018a0:	89 1c 24             	mov    %ebx,(%esp)
  8018a3:	e8 e8 ee ff ff       	call   800790 <strlen>
  8018a8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018ad:	7f 60                	jg     80190f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b2:	89 04 24             	mov    %eax,(%esp)
  8018b5:	e8 2d f8 ff ff       	call   8010e7 <fd_alloc>
  8018ba:	89 c2                	mov    %eax,%edx
  8018bc:	85 d2                	test   %edx,%edx
  8018be:	78 54                	js     801914 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018cb:	e8 f7 ee ff ff       	call   8007c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018db:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e0:	e8 be fd ff ff       	call   8016a3 <fsipc>
  8018e5:	89 c3                	mov    %eax,%ebx
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	79 17                	jns    801902 <open+0x6c>
		fd_close(fd, 0);
  8018eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018f2:	00 
  8018f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f6:	89 04 24             	mov    %eax,(%esp)
  8018f9:	e8 e8 f8 ff ff       	call   8011e6 <fd_close>
		return r;
  8018fe:	89 d8                	mov    %ebx,%eax
  801900:	eb 12                	jmp    801914 <open+0x7e>
	}

	return fd2num(fd);
  801902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801905:	89 04 24             	mov    %eax,(%esp)
  801908:	e8 b3 f7 ff ff       	call   8010c0 <fd2num>
  80190d:	eb 05                	jmp    801914 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80190f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801914:	83 c4 24             	add    $0x24,%esp
  801917:	5b                   	pop    %ebx
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801920:	ba 00 00 00 00       	mov    $0x0,%edx
  801925:	b8 08 00 00 00       	mov    $0x8,%eax
  80192a:	e8 74 fd ff ff       	call   8016a3 <fsipc>
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    
  801931:	66 90                	xchg   %ax,%ax
  801933:	66 90                	xchg   %ax,%ax
  801935:	66 90                	xchg   %ax,%ax
  801937:	66 90                	xchg   %ax,%ax
  801939:	66 90                	xchg   %ax,%ax
  80193b:	66 90                	xchg   %ax,%ax
  80193d:	66 90                	xchg   %ax,%ax
  80193f:	90                   	nop

00801940 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801946:	c7 44 24 04 5f 2c 80 	movl   $0x802c5f,0x4(%esp)
  80194d:	00 
  80194e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801951:	89 04 24             	mov    %eax,(%esp)
  801954:	e8 6e ee ff ff       	call   8007c7 <strcpy>
	return 0;
}
  801959:	b8 00 00 00 00       	mov    $0x0,%eax
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	53                   	push   %ebx
  801964:	83 ec 14             	sub    $0x14,%esp
  801967:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80196a:	89 1c 24             	mov    %ebx,(%esp)
  80196d:	e8 5c 0b 00 00       	call   8024ce <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801972:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801977:	83 f8 01             	cmp    $0x1,%eax
  80197a:	75 0d                	jne    801989 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80197c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80197f:	89 04 24             	mov    %eax,(%esp)
  801982:	e8 29 03 00 00       	call   801cb0 <nsipc_close>
  801987:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801989:	89 d0                	mov    %edx,%eax
  80198b:	83 c4 14             	add    $0x14,%esp
  80198e:	5b                   	pop    %ebx
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    

00801991 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801997:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80199e:	00 
  80199f:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b3:	89 04 24             	mov    %eax,(%esp)
  8019b6:	e8 f0 03 00 00       	call   801dab <nsipc_send>
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ca:	00 
  8019cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019df:	89 04 24             	mov    %eax,(%esp)
  8019e2:	e8 44 03 00 00       	call   801d2b <nsipc_recv>
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019ef:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019f2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019f6:	89 04 24             	mov    %eax,(%esp)
  8019f9:	e8 38 f7 ff ff       	call   801136 <fd_lookup>
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 17                	js     801a19 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a05:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a0b:	39 08                	cmp    %ecx,(%eax)
  801a0d:	75 05                	jne    801a14 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a12:	eb 05                	jmp    801a19 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	56                   	push   %esi
  801a1f:	53                   	push   %ebx
  801a20:	83 ec 20             	sub    $0x20,%esp
  801a23:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a28:	89 04 24             	mov    %eax,(%esp)
  801a2b:	e8 b7 f6 ff ff       	call   8010e7 <fd_alloc>
  801a30:	89 c3                	mov    %eax,%ebx
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 21                	js     801a57 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a36:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a3d:	00 
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a4c:	e8 92 f1 ff ff       	call   800be3 <sys_page_alloc>
  801a51:	89 c3                	mov    %eax,%ebx
  801a53:	85 c0                	test   %eax,%eax
  801a55:	79 0c                	jns    801a63 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a57:	89 34 24             	mov    %esi,(%esp)
  801a5a:	e8 51 02 00 00       	call   801cb0 <nsipc_close>
		return r;
  801a5f:	89 d8                	mov    %ebx,%eax
  801a61:	eb 20                	jmp    801a83 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a63:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a71:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a78:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a7b:	89 14 24             	mov    %edx,(%esp)
  801a7e:	e8 3d f6 ff ff       	call   8010c0 <fd2num>
}
  801a83:	83 c4 20             	add    $0x20,%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5e                   	pop    %esi
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    

00801a8a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	e8 51 ff ff ff       	call   8019e9 <fd2sockid>
		return r;
  801a98:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	78 23                	js     801ac1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a9e:	8b 55 10             	mov    0x10(%ebp),%edx
  801aa1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aac:	89 04 24             	mov    %eax,(%esp)
  801aaf:	e8 45 01 00 00       	call   801bf9 <nsipc_accept>
		return r;
  801ab4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	78 07                	js     801ac1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801aba:	e8 5c ff ff ff       	call   801a1b <alloc_sockfd>
  801abf:	89 c1                	mov    %eax,%ecx
}
  801ac1:	89 c8                	mov    %ecx,%eax
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	e8 16 ff ff ff       	call   8019e9 <fd2sockid>
  801ad3:	89 c2                	mov    %eax,%edx
  801ad5:	85 d2                	test   %edx,%edx
  801ad7:	78 16                	js     801aef <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  801adc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae7:	89 14 24             	mov    %edx,(%esp)
  801aea:	e8 60 01 00 00       	call   801c4f <nsipc_bind>
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <shutdown>:

int
shutdown(int s, int how)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	e8 ea fe ff ff       	call   8019e9 <fd2sockid>
  801aff:	89 c2                	mov    %eax,%edx
  801b01:	85 d2                	test   %edx,%edx
  801b03:	78 0f                	js     801b14 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0c:	89 14 24             	mov    %edx,(%esp)
  801b0f:	e8 7a 01 00 00       	call   801c8e <nsipc_shutdown>
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	e8 c5 fe ff ff       	call   8019e9 <fd2sockid>
  801b24:	89 c2                	mov    %eax,%edx
  801b26:	85 d2                	test   %edx,%edx
  801b28:	78 16                	js     801b40 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b38:	89 14 24             	mov    %edx,(%esp)
  801b3b:	e8 8a 01 00 00       	call   801cca <nsipc_connect>
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <listen>:

int
listen(int s, int backlog)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	e8 99 fe ff ff       	call   8019e9 <fd2sockid>
  801b50:	89 c2                	mov    %eax,%edx
  801b52:	85 d2                	test   %edx,%edx
  801b54:	78 0f                	js     801b65 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5d:	89 14 24             	mov    %edx,(%esp)
  801b60:	e8 a4 01 00 00       	call   801d09 <nsipc_listen>
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b70:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	89 04 24             	mov    %eax,(%esp)
  801b81:	e8 98 02 00 00       	call   801e1e <nsipc_socket>
  801b86:	89 c2                	mov    %eax,%edx
  801b88:	85 d2                	test   %edx,%edx
  801b8a:	78 05                	js     801b91 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801b8c:	e8 8a fe ff ff       	call   801a1b <alloc_sockfd>
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	53                   	push   %ebx
  801b97:	83 ec 14             	sub    $0x14,%esp
  801b9a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b9c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ba3:	75 11                	jne    801bb6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ba5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801bac:	e8 de 08 00 00       	call   80248f <ipc_find_env>
  801bb1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bb6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bbd:	00 
  801bbe:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801bc5:	00 
  801bc6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bca:	a1 04 40 80 00       	mov    0x804004,%eax
  801bcf:	89 04 24             	mov    %eax,(%esp)
  801bd2:	e8 4d 08 00 00       	call   802424 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bd7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bde:	00 
  801bdf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801be6:	00 
  801be7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bee:	e8 dd 07 00 00       	call   8023d0 <ipc_recv>
}
  801bf3:	83 c4 14             	add    $0x14,%esp
  801bf6:	5b                   	pop    %ebx
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    

00801bf9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	56                   	push   %esi
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 10             	sub    $0x10,%esp
  801c01:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c0c:	8b 06                	mov    (%esi),%eax
  801c0e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c13:	b8 01 00 00 00       	mov    $0x1,%eax
  801c18:	e8 76 ff ff ff       	call   801b93 <nsipc>
  801c1d:	89 c3                	mov    %eax,%ebx
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 23                	js     801c46 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c23:	a1 10 60 80 00       	mov    0x806010,%eax
  801c28:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c2c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c33:	00 
  801c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c37:	89 04 24             	mov    %eax,(%esp)
  801c3a:	e8 25 ed ff ff       	call   800964 <memmove>
		*addrlen = ret->ret_addrlen;
  801c3f:	a1 10 60 80 00       	mov    0x806010,%eax
  801c44:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801c46:	89 d8                	mov    %ebx,%eax
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    

00801c4f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	53                   	push   %ebx
  801c53:	83 ec 14             	sub    $0x14,%esp
  801c56:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c61:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c73:	e8 ec ec ff ff       	call   800964 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c78:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c7e:	b8 02 00 00 00       	mov    $0x2,%eax
  801c83:	e8 0b ff ff ff       	call   801b93 <nsipc>
}
  801c88:	83 c4 14             	add    $0x14,%esp
  801c8b:	5b                   	pop    %ebx
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    

00801c8e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ca4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ca9:	e8 e5 fe ff ff       	call   801b93 <nsipc>
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <nsipc_close>:

int
nsipc_close(int s)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cbe:	b8 04 00 00 00       	mov    $0x4,%eax
  801cc3:	e8 cb fe ff ff       	call   801b93 <nsipc>
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	53                   	push   %ebx
  801cce:	83 ec 14             	sub    $0x14,%esp
  801cd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cdc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801cee:	e8 71 ec ff ff       	call   800964 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cf3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cf9:	b8 05 00 00 00       	mov    $0x5,%eax
  801cfe:	e8 90 fe ff ff       	call   801b93 <nsipc>
}
  801d03:	83 c4 14             	add    $0x14,%esp
  801d06:	5b                   	pop    %ebx
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d1f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d24:	e8 6a fe ff ff       	call   801b93 <nsipc>
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	56                   	push   %esi
  801d2f:	53                   	push   %ebx
  801d30:	83 ec 10             	sub    $0x10,%esp
  801d33:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d3e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d44:	8b 45 14             	mov    0x14(%ebp),%eax
  801d47:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d4c:	b8 07 00 00 00       	mov    $0x7,%eax
  801d51:	e8 3d fe ff ff       	call   801b93 <nsipc>
  801d56:	89 c3                	mov    %eax,%ebx
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	78 46                	js     801da2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d5c:	39 f0                	cmp    %esi,%eax
  801d5e:	7f 07                	jg     801d67 <nsipc_recv+0x3c>
  801d60:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d65:	7e 24                	jle    801d8b <nsipc_recv+0x60>
  801d67:	c7 44 24 0c 6b 2c 80 	movl   $0x802c6b,0xc(%esp)
  801d6e:	00 
  801d6f:	c7 44 24 08 33 2c 80 	movl   $0x802c33,0x8(%esp)
  801d76:	00 
  801d77:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d7e:	00 
  801d7f:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  801d86:	e8 eb 05 00 00       	call   802376 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d8f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d96:	00 
  801d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9a:	89 04 24             	mov    %eax,(%esp)
  801d9d:	e8 c2 eb ff ff       	call   800964 <memmove>
	}

	return r;
}
  801da2:	89 d8                	mov    %ebx,%eax
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5d                   	pop    %ebp
  801daa:	c3                   	ret    

00801dab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	53                   	push   %ebx
  801daf:	83 ec 14             	sub    $0x14,%esp
  801db2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dbd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dc3:	7e 24                	jle    801de9 <nsipc_send+0x3e>
  801dc5:	c7 44 24 0c 8c 2c 80 	movl   $0x802c8c,0xc(%esp)
  801dcc:	00 
  801dcd:	c7 44 24 08 33 2c 80 	movl   $0x802c33,0x8(%esp)
  801dd4:	00 
  801dd5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801ddc:	00 
  801ddd:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  801de4:	e8 8d 05 00 00       	call   802376 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801de9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801dfb:	e8 64 eb ff ff       	call   800964 <memmove>
	nsipcbuf.send.req_size = size;
  801e00:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e06:	8b 45 14             	mov    0x14(%ebp),%eax
  801e09:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e0e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e13:	e8 7b fd ff ff       	call   801b93 <nsipc>
}
  801e18:	83 c4 14             	add    $0x14,%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5d                   	pop    %ebp
  801e1d:	c3                   	ret    

00801e1e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e34:	8b 45 10             	mov    0x10(%ebp),%eax
  801e37:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e3c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e41:	e8 4d fd ff ff       	call   801b93 <nsipc>
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	56                   	push   %esi
  801e4c:	53                   	push   %ebx
  801e4d:	83 ec 10             	sub    $0x10,%esp
  801e50:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	89 04 24             	mov    %eax,(%esp)
  801e59:	e8 72 f2 ff ff       	call   8010d0 <fd2data>
  801e5e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e60:	c7 44 24 04 98 2c 80 	movl   $0x802c98,0x4(%esp)
  801e67:	00 
  801e68:	89 1c 24             	mov    %ebx,(%esp)
  801e6b:	e8 57 e9 ff ff       	call   8007c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e70:	8b 46 04             	mov    0x4(%esi),%eax
  801e73:	2b 06                	sub    (%esi),%eax
  801e75:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e7b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e82:	00 00 00 
	stat->st_dev = &devpipe;
  801e85:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e8c:	30 80 00 
	return 0;
}
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    

00801e9b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	53                   	push   %ebx
  801e9f:	83 ec 14             	sub    $0x14,%esp
  801ea2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ea5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ea9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb0:	e8 d5 ed ff ff       	call   800c8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801eb5:	89 1c 24             	mov    %ebx,(%esp)
  801eb8:	e8 13 f2 ff ff       	call   8010d0 <fd2data>
  801ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec8:	e8 bd ed ff ff       	call   800c8a <sys_page_unmap>
}
  801ecd:	83 c4 14             	add    $0x14,%esp
  801ed0:	5b                   	pop    %ebx
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    

00801ed3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	57                   	push   %edi
  801ed7:	56                   	push   %esi
  801ed8:	53                   	push   %ebx
  801ed9:	83 ec 2c             	sub    $0x2c,%esp
  801edc:	89 c6                	mov    %eax,%esi
  801ede:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ee1:	a1 08 40 80 00       	mov    0x804008,%eax
  801ee6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ee9:	89 34 24             	mov    %esi,(%esp)
  801eec:	e8 dd 05 00 00       	call   8024ce <pageref>
  801ef1:	89 c7                	mov    %eax,%edi
  801ef3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ef6:	89 04 24             	mov    %eax,(%esp)
  801ef9:	e8 d0 05 00 00       	call   8024ce <pageref>
  801efe:	39 c7                	cmp    %eax,%edi
  801f00:	0f 94 c2             	sete   %dl
  801f03:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f06:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801f0c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f0f:	39 fb                	cmp    %edi,%ebx
  801f11:	74 21                	je     801f34 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f13:	84 d2                	test   %dl,%dl
  801f15:	74 ca                	je     801ee1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f17:	8b 51 58             	mov    0x58(%ecx),%edx
  801f1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f1e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f26:	c7 04 24 9f 2c 80 00 	movl   $0x802c9f,(%esp)
  801f2d:	e8 68 e2 ff ff       	call   80019a <cprintf>
  801f32:	eb ad                	jmp    801ee1 <_pipeisclosed+0xe>
	}
}
  801f34:	83 c4 2c             	add    $0x2c,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5f                   	pop    %edi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    

00801f3c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	57                   	push   %edi
  801f40:	56                   	push   %esi
  801f41:	53                   	push   %ebx
  801f42:	83 ec 1c             	sub    $0x1c,%esp
  801f45:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f48:	89 34 24             	mov    %esi,(%esp)
  801f4b:	e8 80 f1 ff ff       	call   8010d0 <fd2data>
  801f50:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f52:	bf 00 00 00 00       	mov    $0x0,%edi
  801f57:	eb 45                	jmp    801f9e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f59:	89 da                	mov    %ebx,%edx
  801f5b:	89 f0                	mov    %esi,%eax
  801f5d:	e8 71 ff ff ff       	call   801ed3 <_pipeisclosed>
  801f62:	85 c0                	test   %eax,%eax
  801f64:	75 41                	jne    801fa7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f66:	e8 59 ec ff ff       	call   800bc4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f6b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f6e:	8b 0b                	mov    (%ebx),%ecx
  801f70:	8d 51 20             	lea    0x20(%ecx),%edx
  801f73:	39 d0                	cmp    %edx,%eax
  801f75:	73 e2                	jae    801f59 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f7a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f7e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f81:	99                   	cltd   
  801f82:	c1 ea 1b             	shr    $0x1b,%edx
  801f85:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f88:	83 e1 1f             	and    $0x1f,%ecx
  801f8b:	29 d1                	sub    %edx,%ecx
  801f8d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f91:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f95:	83 c0 01             	add    $0x1,%eax
  801f98:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f9b:	83 c7 01             	add    $0x1,%edi
  801f9e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fa1:	75 c8                	jne    801f6b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fa3:	89 f8                	mov    %edi,%eax
  801fa5:	eb 05                	jmp    801fac <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fac:	83 c4 1c             	add    $0x1c,%esp
  801faf:	5b                   	pop    %ebx
  801fb0:	5e                   	pop    %esi
  801fb1:	5f                   	pop    %edi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    

00801fb4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	57                   	push   %edi
  801fb8:	56                   	push   %esi
  801fb9:	53                   	push   %ebx
  801fba:	83 ec 1c             	sub    $0x1c,%esp
  801fbd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fc0:	89 3c 24             	mov    %edi,(%esp)
  801fc3:	e8 08 f1 ff ff       	call   8010d0 <fd2data>
  801fc8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fca:	be 00 00 00 00       	mov    $0x0,%esi
  801fcf:	eb 3d                	jmp    80200e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801fd1:	85 f6                	test   %esi,%esi
  801fd3:	74 04                	je     801fd9 <devpipe_read+0x25>
				return i;
  801fd5:	89 f0                	mov    %esi,%eax
  801fd7:	eb 43                	jmp    80201c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801fd9:	89 da                	mov    %ebx,%edx
  801fdb:	89 f8                	mov    %edi,%eax
  801fdd:	e8 f1 fe ff ff       	call   801ed3 <_pipeisclosed>
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	75 31                	jne    802017 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801fe6:	e8 d9 eb ff ff       	call   800bc4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801feb:	8b 03                	mov    (%ebx),%eax
  801fed:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ff0:	74 df                	je     801fd1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ff2:	99                   	cltd   
  801ff3:	c1 ea 1b             	shr    $0x1b,%edx
  801ff6:	01 d0                	add    %edx,%eax
  801ff8:	83 e0 1f             	and    $0x1f,%eax
  801ffb:	29 d0                	sub    %edx,%eax
  801ffd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802002:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802005:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802008:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80200b:	83 c6 01             	add    $0x1,%esi
  80200e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802011:	75 d8                	jne    801feb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802013:	89 f0                	mov    %esi,%eax
  802015:	eb 05                	jmp    80201c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80201c:	83 c4 1c             	add    $0x1c,%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5f                   	pop    %edi
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    

00802024 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	56                   	push   %esi
  802028:	53                   	push   %ebx
  802029:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80202c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202f:	89 04 24             	mov    %eax,(%esp)
  802032:	e8 b0 f0 ff ff       	call   8010e7 <fd_alloc>
  802037:	89 c2                	mov    %eax,%edx
  802039:	85 d2                	test   %edx,%edx
  80203b:	0f 88 4d 01 00 00    	js     80218e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802041:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802048:	00 
  802049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802050:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802057:	e8 87 eb ff ff       	call   800be3 <sys_page_alloc>
  80205c:	89 c2                	mov    %eax,%edx
  80205e:	85 d2                	test   %edx,%edx
  802060:	0f 88 28 01 00 00    	js     80218e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802066:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802069:	89 04 24             	mov    %eax,(%esp)
  80206c:	e8 76 f0 ff ff       	call   8010e7 <fd_alloc>
  802071:	89 c3                	mov    %eax,%ebx
  802073:	85 c0                	test   %eax,%eax
  802075:	0f 88 fe 00 00 00    	js     802179 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80207b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802082:	00 
  802083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802086:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802091:	e8 4d eb ff ff       	call   800be3 <sys_page_alloc>
  802096:	89 c3                	mov    %eax,%ebx
  802098:	85 c0                	test   %eax,%eax
  80209a:	0f 88 d9 00 00 00    	js     802179 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	89 04 24             	mov    %eax,(%esp)
  8020a6:	e8 25 f0 ff ff       	call   8010d0 <fd2data>
  8020ab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ad:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020b4:	00 
  8020b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c0:	e8 1e eb ff ff       	call   800be3 <sys_page_alloc>
  8020c5:	89 c3                	mov    %eax,%ebx
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	0f 88 97 00 00 00    	js     802166 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d2:	89 04 24             	mov    %eax,(%esp)
  8020d5:	e8 f6 ef ff ff       	call   8010d0 <fd2data>
  8020da:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8020e1:	00 
  8020e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020ed:	00 
  8020ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f9:	e8 39 eb ff ff       	call   800c37 <sys_page_map>
  8020fe:	89 c3                	mov    %eax,%ebx
  802100:	85 c0                	test   %eax,%eax
  802102:	78 52                	js     802156 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802104:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802119:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80211f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802122:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802127:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	89 04 24             	mov    %eax,(%esp)
  802134:	e8 87 ef ff ff       	call   8010c0 <fd2num>
  802139:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80213c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80213e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802141:	89 04 24             	mov    %eax,(%esp)
  802144:	e8 77 ef ff ff       	call   8010c0 <fd2num>
  802149:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80214c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
  802154:	eb 38                	jmp    80218e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802156:	89 74 24 04          	mov    %esi,0x4(%esp)
  80215a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802161:	e8 24 eb ff ff       	call   800c8a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802169:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802174:	e8 11 eb ff ff       	call   800c8a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802180:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802187:	e8 fe ea ff ff       	call   800c8a <sys_page_unmap>
  80218c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80218e:	83 c4 30             	add    $0x30,%esp
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    

00802195 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80219b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80219e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	89 04 24             	mov    %eax,(%esp)
  8021a8:	e8 89 ef ff ff       	call   801136 <fd_lookup>
  8021ad:	89 c2                	mov    %eax,%edx
  8021af:	85 d2                	test   %edx,%edx
  8021b1:	78 15                	js     8021c8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	89 04 24             	mov    %eax,(%esp)
  8021b9:	e8 12 ef ff ff       	call   8010d0 <fd2data>
	return _pipeisclosed(fd, p);
  8021be:	89 c2                	mov    %eax,%edx
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	e8 0b fd ff ff       	call   801ed3 <_pipeisclosed>
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d8:	5d                   	pop    %ebp
  8021d9:	c3                   	ret    

008021da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021e0:	c7 44 24 04 b7 2c 80 	movl   $0x802cb7,0x4(%esp)
  8021e7:	00 
  8021e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021eb:	89 04 24             	mov    %eax,(%esp)
  8021ee:	e8 d4 e5 ff ff       	call   8007c7 <strcpy>
	return 0;
}
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	57                   	push   %edi
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
  802200:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802206:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80220b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802211:	eb 31                	jmp    802244 <devcons_write+0x4a>
		m = n - tot;
  802213:	8b 75 10             	mov    0x10(%ebp),%esi
  802216:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802218:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80221b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802220:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802223:	89 74 24 08          	mov    %esi,0x8(%esp)
  802227:	03 45 0c             	add    0xc(%ebp),%eax
  80222a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80222e:	89 3c 24             	mov    %edi,(%esp)
  802231:	e8 2e e7 ff ff       	call   800964 <memmove>
		sys_cputs(buf, m);
  802236:	89 74 24 04          	mov    %esi,0x4(%esp)
  80223a:	89 3c 24             	mov    %edi,(%esp)
  80223d:	e8 d4 e8 ff ff       	call   800b16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802242:	01 f3                	add    %esi,%ebx
  802244:	89 d8                	mov    %ebx,%eax
  802246:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802249:	72 c8                	jb     802213 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80224b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    

00802256 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80225c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802265:	75 07                	jne    80226e <devcons_read+0x18>
  802267:	eb 2a                	jmp    802293 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802269:	e8 56 e9 ff ff       	call   800bc4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80226e:	66 90                	xchg   %ax,%ax
  802270:	e8 bf e8 ff ff       	call   800b34 <sys_cgetc>
  802275:	85 c0                	test   %eax,%eax
  802277:	74 f0                	je     802269 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802279:	85 c0                	test   %eax,%eax
  80227b:	78 16                	js     802293 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80227d:	83 f8 04             	cmp    $0x4,%eax
  802280:	74 0c                	je     80228e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802282:	8b 55 0c             	mov    0xc(%ebp),%edx
  802285:	88 02                	mov    %al,(%edx)
	return 1;
  802287:	b8 01 00 00 00       	mov    $0x1,%eax
  80228c:	eb 05                	jmp    802293 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022a8:	00 
  8022a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022ac:	89 04 24             	mov    %eax,(%esp)
  8022af:	e8 62 e8 ff ff       	call   800b16 <sys_cputs>
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <getchar>:

int
getchar(void)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022c3:	00 
  8022c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d2:	e8 f3 f0 ff ff       	call   8013ca <read>
	if (r < 0)
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	78 0f                	js     8022ea <getchar+0x34>
		return r;
	if (r < 1)
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	7e 06                	jle    8022e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022e3:	eb 05                	jmp    8022ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	89 04 24             	mov    %eax,(%esp)
  8022ff:	e8 32 ee ff ff       	call   801136 <fd_lookup>
  802304:	85 c0                	test   %eax,%eax
  802306:	78 11                	js     802319 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802311:	39 10                	cmp    %edx,(%eax)
  802313:	0f 94 c0             	sete   %al
  802316:	0f b6 c0             	movzbl %al,%eax
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <opencons>:

int
opencons(void)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802321:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802324:	89 04 24             	mov    %eax,(%esp)
  802327:	e8 bb ed ff ff       	call   8010e7 <fd_alloc>
		return r;
  80232c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80232e:	85 c0                	test   %eax,%eax
  802330:	78 40                	js     802372 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802332:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802339:	00 
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802341:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802348:	e8 96 e8 ff ff       	call   800be3 <sys_page_alloc>
		return r;
  80234d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 1f                	js     802372 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802353:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802368:	89 04 24             	mov    %eax,(%esp)
  80236b:	e8 50 ed ff ff       	call   8010c0 <fd2num>
  802370:	89 c2                	mov    %eax,%edx
}
  802372:	89 d0                	mov    %edx,%eax
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	56                   	push   %esi
  80237a:	53                   	push   %ebx
  80237b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80237e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802381:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802387:	e8 19 e8 ff ff       	call   800ba5 <sys_getenvid>
  80238c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802393:	8b 55 08             	mov    0x8(%ebp),%edx
  802396:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80239a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80239e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a2:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  8023a9:	e8 ec dd ff ff       	call   80019a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b5:	89 04 24             	mov    %eax,(%esp)
  8023b8:	e8 7c dd ff ff       	call   800139 <vcprintf>
	cprintf("\n");
  8023bd:	c7 04 24 b0 2c 80 00 	movl   $0x802cb0,(%esp)
  8023c4:	e8 d1 dd ff ff       	call   80019a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023c9:	cc                   	int3   
  8023ca:	eb fd                	jmp    8023c9 <_panic+0x53>
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	56                   	push   %esi
  8023d4:	53                   	push   %ebx
  8023d5:	83 ec 10             	sub    $0x10,%esp
  8023d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023e1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8023e3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023e8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8023eb:	89 04 24             	mov    %eax,(%esp)
  8023ee:	e8 06 ea ff ff       	call   800df9 <sys_ipc_recv>
  8023f3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8023f5:	85 d2                	test   %edx,%edx
  8023f7:	75 24                	jne    80241d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8023f9:	85 f6                	test   %esi,%esi
  8023fb:	74 0a                	je     802407 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8023fd:	a1 08 40 80 00       	mov    0x804008,%eax
  802402:	8b 40 74             	mov    0x74(%eax),%eax
  802405:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802407:	85 db                	test   %ebx,%ebx
  802409:	74 0a                	je     802415 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80240b:	a1 08 40 80 00       	mov    0x804008,%eax
  802410:	8b 40 78             	mov    0x78(%eax),%eax
  802413:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802415:	a1 08 40 80 00       	mov    0x804008,%eax
  80241a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80241d:	83 c4 10             	add    $0x10,%esp
  802420:	5b                   	pop    %ebx
  802421:	5e                   	pop    %esi
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    

00802424 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	57                   	push   %edi
  802428:	56                   	push   %esi
  802429:	53                   	push   %ebx
  80242a:	83 ec 1c             	sub    $0x1c,%esp
  80242d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802430:	8b 75 0c             	mov    0xc(%ebp),%esi
  802433:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802436:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802438:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80243d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802440:	8b 45 14             	mov    0x14(%ebp),%eax
  802443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802447:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80244b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80244f:	89 3c 24             	mov    %edi,(%esp)
  802452:	e8 7f e9 ff ff       	call   800dd6 <sys_ipc_try_send>

		if (ret == 0)
  802457:	85 c0                	test   %eax,%eax
  802459:	74 2c                	je     802487 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80245b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80245e:	74 20                	je     802480 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802460:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802464:	c7 44 24 08 e8 2c 80 	movl   $0x802ce8,0x8(%esp)
  80246b:	00 
  80246c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802473:	00 
  802474:	c7 04 24 18 2d 80 00 	movl   $0x802d18,(%esp)
  80247b:	e8 f6 fe ff ff       	call   802376 <_panic>
		}

		sys_yield();
  802480:	e8 3f e7 ff ff       	call   800bc4 <sys_yield>
	}
  802485:	eb b9                	jmp    802440 <ipc_send+0x1c>
}
  802487:	83 c4 1c             	add    $0x1c,%esp
  80248a:	5b                   	pop    %ebx
  80248b:	5e                   	pop    %esi
  80248c:	5f                   	pop    %edi
  80248d:	5d                   	pop    %ebp
  80248e:	c3                   	ret    

0080248f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80249a:	89 c2                	mov    %eax,%edx
  80249c:	c1 e2 07             	shl    $0x7,%edx
  80249f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8024a6:	8b 52 50             	mov    0x50(%edx),%edx
  8024a9:	39 ca                	cmp    %ecx,%edx
  8024ab:	75 11                	jne    8024be <ipc_find_env+0x2f>
			return envs[i].env_id;
  8024ad:	89 c2                	mov    %eax,%edx
  8024af:	c1 e2 07             	shl    $0x7,%edx
  8024b2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8024b9:	8b 40 40             	mov    0x40(%eax),%eax
  8024bc:	eb 0e                	jmp    8024cc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024be:	83 c0 01             	add    $0x1,%eax
  8024c1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024c6:	75 d2                	jne    80249a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024c8:	66 b8 00 00          	mov    $0x0,%ax
}
  8024cc:	5d                   	pop    %ebp
  8024cd:	c3                   	ret    

008024ce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024d4:	89 d0                	mov    %edx,%eax
  8024d6:	c1 e8 16             	shr    $0x16,%eax
  8024d9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024e5:	f6 c1 01             	test   $0x1,%cl
  8024e8:	74 1d                	je     802507 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024ea:	c1 ea 0c             	shr    $0xc,%edx
  8024ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024f4:	f6 c2 01             	test   $0x1,%dl
  8024f7:	74 0e                	je     802507 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024f9:	c1 ea 0c             	shr    $0xc,%edx
  8024fc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802503:	ef 
  802504:	0f b7 c0             	movzwl %ax,%eax
}
  802507:	5d                   	pop    %ebp
  802508:	c3                   	ret    
  802509:	66 90                	xchg   %ax,%ax
  80250b:	66 90                	xchg   %ax,%ax
  80250d:	66 90                	xchg   %ax,%ax
  80250f:	90                   	nop

00802510 <__udivdi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	8b 44 24 28          	mov    0x28(%esp),%eax
  80251a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80251e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802522:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802526:	85 c0                	test   %eax,%eax
  802528:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80252c:	89 ea                	mov    %ebp,%edx
  80252e:	89 0c 24             	mov    %ecx,(%esp)
  802531:	75 2d                	jne    802560 <__udivdi3+0x50>
  802533:	39 e9                	cmp    %ebp,%ecx
  802535:	77 61                	ja     802598 <__udivdi3+0x88>
  802537:	85 c9                	test   %ecx,%ecx
  802539:	89 ce                	mov    %ecx,%esi
  80253b:	75 0b                	jne    802548 <__udivdi3+0x38>
  80253d:	b8 01 00 00 00       	mov    $0x1,%eax
  802542:	31 d2                	xor    %edx,%edx
  802544:	f7 f1                	div    %ecx
  802546:	89 c6                	mov    %eax,%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	89 e8                	mov    %ebp,%eax
  80254c:	f7 f6                	div    %esi
  80254e:	89 c5                	mov    %eax,%ebp
  802550:	89 f8                	mov    %edi,%eax
  802552:	f7 f6                	div    %esi
  802554:	89 ea                	mov    %ebp,%edx
  802556:	83 c4 0c             	add    $0xc,%esp
  802559:	5e                   	pop    %esi
  80255a:	5f                   	pop    %edi
  80255b:	5d                   	pop    %ebp
  80255c:	c3                   	ret    
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	39 e8                	cmp    %ebp,%eax
  802562:	77 24                	ja     802588 <__udivdi3+0x78>
  802564:	0f bd e8             	bsr    %eax,%ebp
  802567:	83 f5 1f             	xor    $0x1f,%ebp
  80256a:	75 3c                	jne    8025a8 <__udivdi3+0x98>
  80256c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802570:	39 34 24             	cmp    %esi,(%esp)
  802573:	0f 86 9f 00 00 00    	jbe    802618 <__udivdi3+0x108>
  802579:	39 d0                	cmp    %edx,%eax
  80257b:	0f 82 97 00 00 00    	jb     802618 <__udivdi3+0x108>
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	31 d2                	xor    %edx,%edx
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	83 c4 0c             	add    $0xc,%esp
  80258f:	5e                   	pop    %esi
  802590:	5f                   	pop    %edi
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    
  802593:	90                   	nop
  802594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802598:	89 f8                	mov    %edi,%eax
  80259a:	f7 f1                	div    %ecx
  80259c:	31 d2                	xor    %edx,%edx
  80259e:	83 c4 0c             	add    $0xc,%esp
  8025a1:	5e                   	pop    %esi
  8025a2:	5f                   	pop    %edi
  8025a3:	5d                   	pop    %ebp
  8025a4:	c3                   	ret    
  8025a5:	8d 76 00             	lea    0x0(%esi),%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	8b 3c 24             	mov    (%esp),%edi
  8025ad:	d3 e0                	shl    %cl,%eax
  8025af:	89 c6                	mov    %eax,%esi
  8025b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025b6:	29 e8                	sub    %ebp,%eax
  8025b8:	89 c1                	mov    %eax,%ecx
  8025ba:	d3 ef                	shr    %cl,%edi
  8025bc:	89 e9                	mov    %ebp,%ecx
  8025be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025c2:	8b 3c 24             	mov    (%esp),%edi
  8025c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025c9:	89 d6                	mov    %edx,%esi
  8025cb:	d3 e7                	shl    %cl,%edi
  8025cd:	89 c1                	mov    %eax,%ecx
  8025cf:	89 3c 24             	mov    %edi,(%esp)
  8025d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025d6:	d3 ee                	shr    %cl,%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	d3 e2                	shl    %cl,%edx
  8025dc:	89 c1                	mov    %eax,%ecx
  8025de:	d3 ef                	shr    %cl,%edi
  8025e0:	09 d7                	or     %edx,%edi
  8025e2:	89 f2                	mov    %esi,%edx
  8025e4:	89 f8                	mov    %edi,%eax
  8025e6:	f7 74 24 08          	divl   0x8(%esp)
  8025ea:	89 d6                	mov    %edx,%esi
  8025ec:	89 c7                	mov    %eax,%edi
  8025ee:	f7 24 24             	mull   (%esp)
  8025f1:	39 d6                	cmp    %edx,%esi
  8025f3:	89 14 24             	mov    %edx,(%esp)
  8025f6:	72 30                	jb     802628 <__udivdi3+0x118>
  8025f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025fc:	89 e9                	mov    %ebp,%ecx
  8025fe:	d3 e2                	shl    %cl,%edx
  802600:	39 c2                	cmp    %eax,%edx
  802602:	73 05                	jae    802609 <__udivdi3+0xf9>
  802604:	3b 34 24             	cmp    (%esp),%esi
  802607:	74 1f                	je     802628 <__udivdi3+0x118>
  802609:	89 f8                	mov    %edi,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	e9 7a ff ff ff       	jmp    80258c <__udivdi3+0x7c>
  802612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802618:	31 d2                	xor    %edx,%edx
  80261a:	b8 01 00 00 00       	mov    $0x1,%eax
  80261f:	e9 68 ff ff ff       	jmp    80258c <__udivdi3+0x7c>
  802624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802628:	8d 47 ff             	lea    -0x1(%edi),%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	83 c4 0c             	add    $0xc,%esp
  802630:	5e                   	pop    %esi
  802631:	5f                   	pop    %edi
  802632:	5d                   	pop    %ebp
  802633:	c3                   	ret    
  802634:	66 90                	xchg   %ax,%ax
  802636:	66 90                	xchg   %ax,%ax
  802638:	66 90                	xchg   %ax,%ax
  80263a:	66 90                	xchg   %ax,%ax
  80263c:	66 90                	xchg   %ax,%ax
  80263e:	66 90                	xchg   %ax,%ax

00802640 <__umoddi3>:
  802640:	55                   	push   %ebp
  802641:	57                   	push   %edi
  802642:	56                   	push   %esi
  802643:	83 ec 14             	sub    $0x14,%esp
  802646:	8b 44 24 28          	mov    0x28(%esp),%eax
  80264a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80264e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802652:	89 c7                	mov    %eax,%edi
  802654:	89 44 24 04          	mov    %eax,0x4(%esp)
  802658:	8b 44 24 30          	mov    0x30(%esp),%eax
  80265c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802660:	89 34 24             	mov    %esi,(%esp)
  802663:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802667:	85 c0                	test   %eax,%eax
  802669:	89 c2                	mov    %eax,%edx
  80266b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80266f:	75 17                	jne    802688 <__umoddi3+0x48>
  802671:	39 fe                	cmp    %edi,%esi
  802673:	76 4b                	jbe    8026c0 <__umoddi3+0x80>
  802675:	89 c8                	mov    %ecx,%eax
  802677:	89 fa                	mov    %edi,%edx
  802679:	f7 f6                	div    %esi
  80267b:	89 d0                	mov    %edx,%eax
  80267d:	31 d2                	xor    %edx,%edx
  80267f:	83 c4 14             	add    $0x14,%esp
  802682:	5e                   	pop    %esi
  802683:	5f                   	pop    %edi
  802684:	5d                   	pop    %ebp
  802685:	c3                   	ret    
  802686:	66 90                	xchg   %ax,%ax
  802688:	39 f8                	cmp    %edi,%eax
  80268a:	77 54                	ja     8026e0 <__umoddi3+0xa0>
  80268c:	0f bd e8             	bsr    %eax,%ebp
  80268f:	83 f5 1f             	xor    $0x1f,%ebp
  802692:	75 5c                	jne    8026f0 <__umoddi3+0xb0>
  802694:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802698:	39 3c 24             	cmp    %edi,(%esp)
  80269b:	0f 87 e7 00 00 00    	ja     802788 <__umoddi3+0x148>
  8026a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026a5:	29 f1                	sub    %esi,%ecx
  8026a7:	19 c7                	sbb    %eax,%edi
  8026a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026b9:	83 c4 14             	add    $0x14,%esp
  8026bc:	5e                   	pop    %esi
  8026bd:	5f                   	pop    %edi
  8026be:	5d                   	pop    %ebp
  8026bf:	c3                   	ret    
  8026c0:	85 f6                	test   %esi,%esi
  8026c2:	89 f5                	mov    %esi,%ebp
  8026c4:	75 0b                	jne    8026d1 <__umoddi3+0x91>
  8026c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	f7 f6                	div    %esi
  8026cf:	89 c5                	mov    %eax,%ebp
  8026d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026d5:	31 d2                	xor    %edx,%edx
  8026d7:	f7 f5                	div    %ebp
  8026d9:	89 c8                	mov    %ecx,%eax
  8026db:	f7 f5                	div    %ebp
  8026dd:	eb 9c                	jmp    80267b <__umoddi3+0x3b>
  8026df:	90                   	nop
  8026e0:	89 c8                	mov    %ecx,%eax
  8026e2:	89 fa                	mov    %edi,%edx
  8026e4:	83 c4 14             	add    $0x14,%esp
  8026e7:	5e                   	pop    %esi
  8026e8:	5f                   	pop    %edi
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    
  8026eb:	90                   	nop
  8026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	8b 04 24             	mov    (%esp),%eax
  8026f3:	be 20 00 00 00       	mov    $0x20,%esi
  8026f8:	89 e9                	mov    %ebp,%ecx
  8026fa:	29 ee                	sub    %ebp,%esi
  8026fc:	d3 e2                	shl    %cl,%edx
  8026fe:	89 f1                	mov    %esi,%ecx
  802700:	d3 e8                	shr    %cl,%eax
  802702:	89 e9                	mov    %ebp,%ecx
  802704:	89 44 24 04          	mov    %eax,0x4(%esp)
  802708:	8b 04 24             	mov    (%esp),%eax
  80270b:	09 54 24 04          	or     %edx,0x4(%esp)
  80270f:	89 fa                	mov    %edi,%edx
  802711:	d3 e0                	shl    %cl,%eax
  802713:	89 f1                	mov    %esi,%ecx
  802715:	89 44 24 08          	mov    %eax,0x8(%esp)
  802719:	8b 44 24 10          	mov    0x10(%esp),%eax
  80271d:	d3 ea                	shr    %cl,%edx
  80271f:	89 e9                	mov    %ebp,%ecx
  802721:	d3 e7                	shl    %cl,%edi
  802723:	89 f1                	mov    %esi,%ecx
  802725:	d3 e8                	shr    %cl,%eax
  802727:	89 e9                	mov    %ebp,%ecx
  802729:	09 f8                	or     %edi,%eax
  80272b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80272f:	f7 74 24 04          	divl   0x4(%esp)
  802733:	d3 e7                	shl    %cl,%edi
  802735:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802739:	89 d7                	mov    %edx,%edi
  80273b:	f7 64 24 08          	mull   0x8(%esp)
  80273f:	39 d7                	cmp    %edx,%edi
  802741:	89 c1                	mov    %eax,%ecx
  802743:	89 14 24             	mov    %edx,(%esp)
  802746:	72 2c                	jb     802774 <__umoddi3+0x134>
  802748:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80274c:	72 22                	jb     802770 <__umoddi3+0x130>
  80274e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802752:	29 c8                	sub    %ecx,%eax
  802754:	19 d7                	sbb    %edx,%edi
  802756:	89 e9                	mov    %ebp,%ecx
  802758:	89 fa                	mov    %edi,%edx
  80275a:	d3 e8                	shr    %cl,%eax
  80275c:	89 f1                	mov    %esi,%ecx
  80275e:	d3 e2                	shl    %cl,%edx
  802760:	89 e9                	mov    %ebp,%ecx
  802762:	d3 ef                	shr    %cl,%edi
  802764:	09 d0                	or     %edx,%eax
  802766:	89 fa                	mov    %edi,%edx
  802768:	83 c4 14             	add    $0x14,%esp
  80276b:	5e                   	pop    %esi
  80276c:	5f                   	pop    %edi
  80276d:	5d                   	pop    %ebp
  80276e:	c3                   	ret    
  80276f:	90                   	nop
  802770:	39 d7                	cmp    %edx,%edi
  802772:	75 da                	jne    80274e <__umoddi3+0x10e>
  802774:	8b 14 24             	mov    (%esp),%edx
  802777:	89 c1                	mov    %eax,%ecx
  802779:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80277d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802781:	eb cb                	jmp    80274e <__umoddi3+0x10e>
  802783:	90                   	nop
  802784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802788:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80278c:	0f 82 0f ff ff ff    	jb     8026a1 <__umoddi3+0x61>
  802792:	e9 1a ff ff ff       	jmp    8026b1 <__umoddi3+0x71>
