
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 8e 00 00 00       	call   8000bf <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800047:	c7 04 24 e0 2b 80 00 	movl   $0x802be0,(%esp)
  80004e:	e8 74 01 00 00       	call   8001c7 <cprintf>
	if ((env = fork()) == 0) {
  800053:	e8 12 11 00 00       	call   80116a <fork>
  800058:	89 c3                	mov    %eax,%ebx
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 0e                	jne    80006c <umain+0x2c>
		cprintf("I am the child.  Spinning...\n");
  80005e:	c7 04 24 58 2c 80 00 	movl   $0x802c58,(%esp)
  800065:	e8 5d 01 00 00       	call   8001c7 <cprintf>
  80006a:	eb fe                	jmp    80006a <umain+0x2a>
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  80006c:	c7 04 24 08 2c 80 00 	movl   $0x802c08,(%esp)
  800073:	e8 4f 01 00 00       	call   8001c7 <cprintf>
	sys_yield();
  800078:	e8 77 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  80007d:	e8 72 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  800082:	e8 6d 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  800087:	e8 68 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  80008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800090:	e8 5f 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  800095:	e8 5a 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  80009a:	e8 55 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  80009f:	90                   	nop
  8000a0:	e8 4f 0b 00 00       	call   800bf4 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  8000a5:	c7 04 24 30 2c 80 00 	movl   $0x802c30,(%esp)
  8000ac:	e8 16 01 00 00       	call   8001c7 <cprintf>
	sys_env_destroy(env);
  8000b1:	89 1c 24             	mov    %ebx,(%esp)
  8000b4:	e8 ca 0a 00 00       	call   800b83 <sys_env_destroy>
}
  8000b9:	83 c4 14             	add    $0x14,%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    

008000bf <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 10             	sub    $0x10,%esp
  8000c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8000cd:	e8 03 0b 00 00       	call   800bd5 <sys_getenvid>
  8000d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	c1 e2 07             	shl    $0x7,%edx
  8000dc:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8000e3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e8:	85 db                	test   %ebx,%ebx
  8000ea:	7e 07                	jle    8000f3 <libmain+0x34>
		binaryname = argv[0];
  8000ec:	8b 06                	mov    (%esi),%eax
  8000ee:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f7:	89 1c 24             	mov    %ebx,(%esp)
  8000fa:	e8 41 ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  8000ff:	e8 07 00 00 00       	call   80010b <exit>
}
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5d                   	pop    %ebp
  80010a:	c3                   	ret    

0080010b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800111:	e8 04 15 00 00       	call   80161a <close_all>
	sys_env_destroy(0);
  800116:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80011d:	e8 61 0a 00 00       	call   800b83 <sys_env_destroy>
}
  800122:	c9                   	leave  
  800123:	c3                   	ret    

00800124 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	53                   	push   %ebx
  800128:	83 ec 14             	sub    $0x14,%esp
  80012b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012e:	8b 13                	mov    (%ebx),%edx
  800130:	8d 42 01             	lea    0x1(%edx),%eax
  800133:	89 03                	mov    %eax,(%ebx)
  800135:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800138:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800141:	75 19                	jne    80015c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800143:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80014a:	00 
  80014b:	8d 43 08             	lea    0x8(%ebx),%eax
  80014e:	89 04 24             	mov    %eax,(%esp)
  800151:	e8 f0 09 00 00       	call   800b46 <sys_cputs>
		b->idx = 0;
  800156:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80015c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800160:	83 c4 14             	add    $0x14,%esp
  800163:	5b                   	pop    %ebx
  800164:	5d                   	pop    %ebp
  800165:	c3                   	ret    

00800166 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80016f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800176:	00 00 00 
	b.cnt = 0;
  800179:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800180:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800183:	8b 45 0c             	mov    0xc(%ebp),%eax
  800186:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018a:	8b 45 08             	mov    0x8(%ebp),%eax
  80018d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800191:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019b:	c7 04 24 24 01 80 00 	movl   $0x800124,(%esp)
  8001a2:	e8 b7 01 00 00       	call   80035e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b7:	89 04 24             	mov    %eax,(%esp)
  8001ba:	e8 87 09 00 00       	call   800b46 <sys_cputs>

	return b.cnt;
}
  8001bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c5:	c9                   	leave  
  8001c6:	c3                   	ret    

008001c7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001cd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	89 04 24             	mov    %eax,(%esp)
  8001da:	e8 87 ff ff ff       	call   800166 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    
  8001e1:	66 90                	xchg   %ax,%ax
  8001e3:	66 90                	xchg   %ax,%ax
  8001e5:	66 90                	xchg   %ax,%ax
  8001e7:	66 90                	xchg   %ax,%ax
  8001e9:	66 90                	xchg   %ax,%ax
  8001eb:	66 90                	xchg   %ax,%ax
  8001ed:	66 90                	xchg   %ax,%ax
  8001ef:	90                   	nop

008001f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 3c             	sub    $0x3c,%esp
  8001f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001fc:	89 d7                	mov    %edx,%edi
  8001fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800201:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800204:	8b 45 0c             	mov    0xc(%ebp),%eax
  800207:	89 c3                	mov    %eax,%ebx
  800209:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80020c:	8b 45 10             	mov    0x10(%ebp),%eax
  80020f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800212:	b9 00 00 00 00       	mov    $0x0,%ecx
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80021d:	39 d9                	cmp    %ebx,%ecx
  80021f:	72 05                	jb     800226 <printnum+0x36>
  800221:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800224:	77 69                	ja     80028f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800226:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800229:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80022d:	83 ee 01             	sub    $0x1,%esi
  800230:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800234:	89 44 24 08          	mov    %eax,0x8(%esp)
  800238:	8b 44 24 08          	mov    0x8(%esp),%eax
  80023c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800240:	89 c3                	mov    %eax,%ebx
  800242:	89 d6                	mov    %edx,%esi
  800244:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800247:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80024a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80024e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025f:	e8 dc 26 00 00       	call   802940 <__udivdi3>
  800264:	89 d9                	mov    %ebx,%ecx
  800266:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80026a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80026e:	89 04 24             	mov    %eax,(%esp)
  800271:	89 54 24 04          	mov    %edx,0x4(%esp)
  800275:	89 fa                	mov    %edi,%edx
  800277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027a:	e8 71 ff ff ff       	call   8001f0 <printnum>
  80027f:	eb 1b                	jmp    80029c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800281:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800285:	8b 45 18             	mov    0x18(%ebp),%eax
  800288:	89 04 24             	mov    %eax,(%esp)
  80028b:	ff d3                	call   *%ebx
  80028d:	eb 03                	jmp    800292 <printnum+0xa2>
  80028f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800292:	83 ee 01             	sub    $0x1,%esi
  800295:	85 f6                	test   %esi,%esi
  800297:	7f e8                	jg     800281 <printnum+0x91>
  800299:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002a0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b5:	89 04 24             	mov    %eax,(%esp)
  8002b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bf:	e8 ac 27 00 00       	call   802a70 <__umoddi3>
  8002c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c8:	0f be 80 80 2c 80 00 	movsbl 0x802c80(%eax),%eax
  8002cf:	89 04 24             	mov    %eax,(%esp)
  8002d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d5:	ff d0                	call   *%eax
}
  8002d7:	83 c4 3c             	add    $0x3c,%esp
  8002da:	5b                   	pop    %ebx
  8002db:	5e                   	pop    %esi
  8002dc:	5f                   	pop    %edi
  8002dd:	5d                   	pop    %ebp
  8002de:	c3                   	ret    

008002df <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002e2:	83 fa 01             	cmp    $0x1,%edx
  8002e5:	7e 0e                	jle    8002f5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002e7:	8b 10                	mov    (%eax),%edx
  8002e9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ec:	89 08                	mov    %ecx,(%eax)
  8002ee:	8b 02                	mov    (%edx),%eax
  8002f0:	8b 52 04             	mov    0x4(%edx),%edx
  8002f3:	eb 22                	jmp    800317 <getuint+0x38>
	else if (lflag)
  8002f5:	85 d2                	test   %edx,%edx
  8002f7:	74 10                	je     800309 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002f9:	8b 10                	mov    (%eax),%edx
  8002fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fe:	89 08                	mov    %ecx,(%eax)
  800300:	8b 02                	mov    (%edx),%eax
  800302:	ba 00 00 00 00       	mov    $0x0,%edx
  800307:	eb 0e                	jmp    800317 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800309:	8b 10                	mov    (%eax),%edx
  80030b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80030e:	89 08                	mov    %ecx,(%eax)
  800310:	8b 02                	mov    (%edx),%eax
  800312:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800317:	5d                   	pop    %ebp
  800318:	c3                   	ret    

00800319 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80031f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800323:	8b 10                	mov    (%eax),%edx
  800325:	3b 50 04             	cmp    0x4(%eax),%edx
  800328:	73 0a                	jae    800334 <sprintputch+0x1b>
		*b->buf++ = ch;
  80032a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80032d:	89 08                	mov    %ecx,(%eax)
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	88 02                	mov    %al,(%edx)
}
  800334:	5d                   	pop    %ebp
  800335:	c3                   	ret    

00800336 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80033c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800343:	8b 45 10             	mov    0x10(%ebp),%eax
  800346:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800351:	8b 45 08             	mov    0x8(%ebp),%eax
  800354:	89 04 24             	mov    %eax,(%esp)
  800357:	e8 02 00 00 00       	call   80035e <vprintfmt>
	va_end(ap);
}
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    

0080035e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	57                   	push   %edi
  800362:	56                   	push   %esi
  800363:	53                   	push   %ebx
  800364:	83 ec 3c             	sub    $0x3c,%esp
  800367:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80036a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80036d:	eb 14                	jmp    800383 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80036f:	85 c0                	test   %eax,%eax
  800371:	0f 84 b3 03 00 00    	je     80072a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800377:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80037b:	89 04 24             	mov    %eax,(%esp)
  80037e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800381:	89 f3                	mov    %esi,%ebx
  800383:	8d 73 01             	lea    0x1(%ebx),%esi
  800386:	0f b6 03             	movzbl (%ebx),%eax
  800389:	83 f8 25             	cmp    $0x25,%eax
  80038c:	75 e1                	jne    80036f <vprintfmt+0x11>
  80038e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800392:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800399:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003a0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8003a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ac:	eb 1d                	jmp    8003cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003b0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003b4:	eb 15                	jmp    8003cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003b8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003bc:	eb 0d                	jmp    8003cb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003ce:	0f b6 0e             	movzbl (%esi),%ecx
  8003d1:	0f b6 c1             	movzbl %cl,%eax
  8003d4:	83 e9 23             	sub    $0x23,%ecx
  8003d7:	80 f9 55             	cmp    $0x55,%cl
  8003da:	0f 87 2a 03 00 00    	ja     80070a <vprintfmt+0x3ac>
  8003e0:	0f b6 c9             	movzbl %cl,%ecx
  8003e3:	ff 24 8d 00 2e 80 00 	jmp    *0x802e00(,%ecx,4)
  8003ea:	89 de                	mov    %ebx,%esi
  8003ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003f1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003f4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003f8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003fb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003fe:	83 fb 09             	cmp    $0x9,%ebx
  800401:	77 36                	ja     800439 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800403:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800406:	eb e9                	jmp    8003f1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800408:	8b 45 14             	mov    0x14(%ebp),%eax
  80040b:	8d 48 04             	lea    0x4(%eax),%ecx
  80040e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800416:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800418:	eb 22                	jmp    80043c <vprintfmt+0xde>
  80041a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80041d:	85 c9                	test   %ecx,%ecx
  80041f:	b8 00 00 00 00       	mov    $0x0,%eax
  800424:	0f 49 c1             	cmovns %ecx,%eax
  800427:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	89 de                	mov    %ebx,%esi
  80042c:	eb 9d                	jmp    8003cb <vprintfmt+0x6d>
  80042e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800430:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800437:	eb 92                	jmp    8003cb <vprintfmt+0x6d>
  800439:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80043c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800440:	79 89                	jns    8003cb <vprintfmt+0x6d>
  800442:	e9 77 ff ff ff       	jmp    8003be <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800447:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80044c:	e9 7a ff ff ff       	jmp    8003cb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8d 50 04             	lea    0x4(%eax),%edx
  800457:	89 55 14             	mov    %edx,0x14(%ebp)
  80045a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	89 04 24             	mov    %eax,(%esp)
  800463:	ff 55 08             	call   *0x8(%ebp)
			break;
  800466:	e9 18 ff ff ff       	jmp    800383 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	8d 50 04             	lea    0x4(%eax),%edx
  800471:	89 55 14             	mov    %edx,0x14(%ebp)
  800474:	8b 00                	mov    (%eax),%eax
  800476:	99                   	cltd   
  800477:	31 d0                	xor    %edx,%eax
  800479:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047b:	83 f8 12             	cmp    $0x12,%eax
  80047e:	7f 0b                	jg     80048b <vprintfmt+0x12d>
  800480:	8b 14 85 60 2f 80 00 	mov    0x802f60(,%eax,4),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	75 20                	jne    8004ab <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80048b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80048f:	c7 44 24 08 98 2c 80 	movl   $0x802c98,0x8(%esp)
  800496:	00 
  800497:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	89 04 24             	mov    %eax,(%esp)
  8004a1:	e8 90 fe ff ff       	call   800336 <printfmt>
  8004a6:	e9 d8 fe ff ff       	jmp    800383 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004af:	c7 44 24 08 95 31 80 	movl   $0x803195,0x8(%esp)
  8004b6:	00 
  8004b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	e8 70 fe ff ff       	call   800336 <printfmt>
  8004c6:	e9 b8 fe ff ff       	jmp    800383 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004cb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 50 04             	lea    0x4(%eax),%edx
  8004da:	89 55 14             	mov    %edx,0x14(%ebp)
  8004dd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004df:	85 f6                	test   %esi,%esi
  8004e1:	b8 91 2c 80 00       	mov    $0x802c91,%eax
  8004e6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8004e9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004ed:	0f 84 97 00 00 00    	je     80058a <vprintfmt+0x22c>
  8004f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004f7:	0f 8e 9b 00 00 00    	jle    800598 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800501:	89 34 24             	mov    %esi,(%esp)
  800504:	e8 cf 02 00 00       	call   8007d8 <strnlen>
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	29 c2                	sub    %eax,%edx
  80050e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800511:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800515:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800518:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80051b:	8b 75 08             	mov    0x8(%ebp),%esi
  80051e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800521:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800523:	eb 0f                	jmp    800534 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800525:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800529:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80052c:	89 04 24             	mov    %eax,(%esp)
  80052f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800531:	83 eb 01             	sub    $0x1,%ebx
  800534:	85 db                	test   %ebx,%ebx
  800536:	7f ed                	jg     800525 <vprintfmt+0x1c7>
  800538:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80053b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80053e:	85 d2                	test   %edx,%edx
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	0f 49 c2             	cmovns %edx,%eax
  800548:	29 c2                	sub    %eax,%edx
  80054a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80054d:	89 d7                	mov    %edx,%edi
  80054f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800552:	eb 50                	jmp    8005a4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800554:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800558:	74 1e                	je     800578 <vprintfmt+0x21a>
  80055a:	0f be d2             	movsbl %dl,%edx
  80055d:	83 ea 20             	sub    $0x20,%edx
  800560:	83 fa 5e             	cmp    $0x5e,%edx
  800563:	76 13                	jbe    800578 <vprintfmt+0x21a>
					putch('?', putdat);
  800565:	8b 45 0c             	mov    0xc(%ebp),%eax
  800568:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800573:	ff 55 08             	call   *0x8(%ebp)
  800576:	eb 0d                	jmp    800585 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800578:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800585:	83 ef 01             	sub    $0x1,%edi
  800588:	eb 1a                	jmp    8005a4 <vprintfmt+0x246>
  80058a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80058d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800590:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800593:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800596:	eb 0c                	jmp    8005a4 <vprintfmt+0x246>
  800598:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80059b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80059e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005a1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005a4:	83 c6 01             	add    $0x1,%esi
  8005a7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005ab:	0f be c2             	movsbl %dl,%eax
  8005ae:	85 c0                	test   %eax,%eax
  8005b0:	74 27                	je     8005d9 <vprintfmt+0x27b>
  8005b2:	85 db                	test   %ebx,%ebx
  8005b4:	78 9e                	js     800554 <vprintfmt+0x1f6>
  8005b6:	83 eb 01             	sub    $0x1,%ebx
  8005b9:	79 99                	jns    800554 <vprintfmt+0x1f6>
  8005bb:	89 f8                	mov    %edi,%eax
  8005bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c3:	89 c3                	mov    %eax,%ebx
  8005c5:	eb 1a                	jmp    8005e1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005d2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d4:	83 eb 01             	sub    $0x1,%ebx
  8005d7:	eb 08                	jmp    8005e1 <vprintfmt+0x283>
  8005d9:	89 fb                	mov    %edi,%ebx
  8005db:	8b 75 08             	mov    0x8(%ebp),%esi
  8005de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005e1:	85 db                	test   %ebx,%ebx
  8005e3:	7f e2                	jg     8005c7 <vprintfmt+0x269>
  8005e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005eb:	e9 93 fd ff ff       	jmp    800383 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005f0:	83 fa 01             	cmp    $0x1,%edx
  8005f3:	7e 16                	jle    80060b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 50 08             	lea    0x8(%eax),%edx
  8005fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005fe:	8b 50 04             	mov    0x4(%eax),%edx
  800601:	8b 00                	mov    (%eax),%eax
  800603:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800606:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800609:	eb 32                	jmp    80063d <vprintfmt+0x2df>
	else if (lflag)
  80060b:	85 d2                	test   %edx,%edx
  80060d:	74 18                	je     800627 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8d 50 04             	lea    0x4(%eax),%edx
  800615:	89 55 14             	mov    %edx,0x14(%ebp)
  800618:	8b 30                	mov    (%eax),%esi
  80061a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80061d:	89 f0                	mov    %esi,%eax
  80061f:	c1 f8 1f             	sar    $0x1f,%eax
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800625:	eb 16                	jmp    80063d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 50 04             	lea    0x4(%eax),%edx
  80062d:	89 55 14             	mov    %edx,0x14(%ebp)
  800630:	8b 30                	mov    (%eax),%esi
  800632:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800635:	89 f0                	mov    %esi,%eax
  800637:	c1 f8 1f             	sar    $0x1f,%eax
  80063a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80063d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800643:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064c:	0f 89 80 00 00 00    	jns    8006d2 <vprintfmt+0x374>
				putch('-', putdat);
  800652:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800656:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80065d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800660:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800663:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800666:	f7 d8                	neg    %eax
  800668:	83 d2 00             	adc    $0x0,%edx
  80066b:	f7 da                	neg    %edx
			}
			base = 10;
  80066d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800672:	eb 5e                	jmp    8006d2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800674:	8d 45 14             	lea    0x14(%ebp),%eax
  800677:	e8 63 fc ff ff       	call   8002df <getuint>
			base = 10;
  80067c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800681:	eb 4f                	jmp    8006d2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800683:	8d 45 14             	lea    0x14(%ebp),%eax
  800686:	e8 54 fc ff ff       	call   8002df <getuint>
			base = 8;
  80068b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800690:	eb 40                	jmp    8006d2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800692:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800696:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80069d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006ab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 50 04             	lea    0x4(%eax),%edx
  8006b4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006be:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006c3:	eb 0d                	jmp    8006d2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c8:	e8 12 fc ff ff       	call   8002df <getuint>
			base = 16;
  8006cd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006d2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006d6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006da:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006dd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006e5:	89 04 24             	mov    %eax,(%esp)
  8006e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006ec:	89 fa                	mov    %edi,%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	e8 fa fa ff ff       	call   8001f0 <printnum>
			break;
  8006f6:	e9 88 fc ff ff       	jmp    800383 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	ff 55 08             	call   *0x8(%ebp)
			break;
  800705:	e9 79 fc ff ff       	jmp    800383 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80070a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800715:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800718:	89 f3                	mov    %esi,%ebx
  80071a:	eb 03                	jmp    80071f <vprintfmt+0x3c1>
  80071c:	83 eb 01             	sub    $0x1,%ebx
  80071f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800723:	75 f7                	jne    80071c <vprintfmt+0x3be>
  800725:	e9 59 fc ff ff       	jmp    800383 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80072a:	83 c4 3c             	add    $0x3c,%esp
  80072d:	5b                   	pop    %ebx
  80072e:	5e                   	pop    %esi
  80072f:	5f                   	pop    %edi
  800730:	5d                   	pop    %ebp
  800731:	c3                   	ret    

00800732 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	83 ec 28             	sub    $0x28,%esp
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80073e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800741:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800745:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800748:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80074f:	85 c0                	test   %eax,%eax
  800751:	74 30                	je     800783 <vsnprintf+0x51>
  800753:	85 d2                	test   %edx,%edx
  800755:	7e 2c                	jle    800783 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80075e:	8b 45 10             	mov    0x10(%ebp),%eax
  800761:	89 44 24 08          	mov    %eax,0x8(%esp)
  800765:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80076c:	c7 04 24 19 03 80 00 	movl   $0x800319,(%esp)
  800773:	e8 e6 fb ff ff       	call   80035e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80077e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800781:	eb 05                	jmp    800788 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800790:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800793:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	89 04 24             	mov    %eax,(%esp)
  8007ab:	e8 82 ff ff ff       	call   800732 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b0:	c9                   	leave  
  8007b1:	c3                   	ret    
  8007b2:	66 90                	xchg   %ax,%ax
  8007b4:	66 90                	xchg   %ax,%ax
  8007b6:	66 90                	xchg   %ax,%ax
  8007b8:	66 90                	xchg   %ax,%ax
  8007ba:	66 90                	xchg   %ax,%ax
  8007bc:	66 90                	xchg   %ax,%ax
  8007be:	66 90                	xchg   %ax,%ax

008007c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cb:	eb 03                	jmp    8007d0 <strlen+0x10>
		n++;
  8007cd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007d4:	75 f7                	jne    8007cd <strlen+0xd>
		n++;
	return n;
}
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e6:	eb 03                	jmp    8007eb <strnlen+0x13>
		n++;
  8007e8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007eb:	39 d0                	cmp    %edx,%eax
  8007ed:	74 06                	je     8007f5 <strnlen+0x1d>
  8007ef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f3:	75 f3                	jne    8007e8 <strnlen+0x10>
		n++;
	return n;
}
  8007f5:	5d                   	pop    %ebp
  8007f6:	c3                   	ret    

008007f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	53                   	push   %ebx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800801:	89 c2                	mov    %eax,%edx
  800803:	83 c2 01             	add    $0x1,%edx
  800806:	83 c1 01             	add    $0x1,%ecx
  800809:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80080d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800810:	84 db                	test   %bl,%bl
  800812:	75 ef                	jne    800803 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800814:	5b                   	pop    %ebx
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800821:	89 1c 24             	mov    %ebx,(%esp)
  800824:	e8 97 ff ff ff       	call   8007c0 <strlen>
	strcpy(dst + len, src);
  800829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800830:	01 d8                	add    %ebx,%eax
  800832:	89 04 24             	mov    %eax,(%esp)
  800835:	e8 bd ff ff ff       	call   8007f7 <strcpy>
	return dst;
}
  80083a:	89 d8                	mov    %ebx,%eax
  80083c:	83 c4 08             	add    $0x8,%esp
  80083f:	5b                   	pop    %ebx
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	56                   	push   %esi
  800846:	53                   	push   %ebx
  800847:	8b 75 08             	mov    0x8(%ebp),%esi
  80084a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084d:	89 f3                	mov    %esi,%ebx
  80084f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800852:	89 f2                	mov    %esi,%edx
  800854:	eb 0f                	jmp    800865 <strncpy+0x23>
		*dst++ = *src;
  800856:	83 c2 01             	add    $0x1,%edx
  800859:	0f b6 01             	movzbl (%ecx),%eax
  80085c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80085f:	80 39 01             	cmpb   $0x1,(%ecx)
  800862:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800865:	39 da                	cmp    %ebx,%edx
  800867:	75 ed                	jne    800856 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800869:	89 f0                	mov    %esi,%eax
  80086b:	5b                   	pop    %ebx
  80086c:	5e                   	pop    %esi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	56                   	push   %esi
  800873:	53                   	push   %ebx
  800874:	8b 75 08             	mov    0x8(%ebp),%esi
  800877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80087d:	89 f0                	mov    %esi,%eax
  80087f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800883:	85 c9                	test   %ecx,%ecx
  800885:	75 0b                	jne    800892 <strlcpy+0x23>
  800887:	eb 1d                	jmp    8008a6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800889:	83 c0 01             	add    $0x1,%eax
  80088c:	83 c2 01             	add    $0x1,%edx
  80088f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800892:	39 d8                	cmp    %ebx,%eax
  800894:	74 0b                	je     8008a1 <strlcpy+0x32>
  800896:	0f b6 0a             	movzbl (%edx),%ecx
  800899:	84 c9                	test   %cl,%cl
  80089b:	75 ec                	jne    800889 <strlcpy+0x1a>
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	eb 02                	jmp    8008a3 <strlcpy+0x34>
  8008a1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008a3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008a6:	29 f0                	sub    %esi,%eax
}
  8008a8:	5b                   	pop    %ebx
  8008a9:	5e                   	pop    %esi
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008b5:	eb 06                	jmp    8008bd <strcmp+0x11>
		p++, q++;
  8008b7:	83 c1 01             	add    $0x1,%ecx
  8008ba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008bd:	0f b6 01             	movzbl (%ecx),%eax
  8008c0:	84 c0                	test   %al,%al
  8008c2:	74 04                	je     8008c8 <strcmp+0x1c>
  8008c4:	3a 02                	cmp    (%edx),%al
  8008c6:	74 ef                	je     8008b7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c8:	0f b6 c0             	movzbl %al,%eax
  8008cb:	0f b6 12             	movzbl (%edx),%edx
  8008ce:	29 d0                	sub    %edx,%eax
}
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	53                   	push   %ebx
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	89 c3                	mov    %eax,%ebx
  8008de:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008e1:	eb 06                	jmp    8008e9 <strncmp+0x17>
		n--, p++, q++;
  8008e3:	83 c0 01             	add    $0x1,%eax
  8008e6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008e9:	39 d8                	cmp    %ebx,%eax
  8008eb:	74 15                	je     800902 <strncmp+0x30>
  8008ed:	0f b6 08             	movzbl (%eax),%ecx
  8008f0:	84 c9                	test   %cl,%cl
  8008f2:	74 04                	je     8008f8 <strncmp+0x26>
  8008f4:	3a 0a                	cmp    (%edx),%cl
  8008f6:	74 eb                	je     8008e3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f8:	0f b6 00             	movzbl (%eax),%eax
  8008fb:	0f b6 12             	movzbl (%edx),%edx
  8008fe:	29 d0                	sub    %edx,%eax
  800900:	eb 05                	jmp    800907 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800902:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800907:	5b                   	pop    %ebx
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800914:	eb 07                	jmp    80091d <strchr+0x13>
		if (*s == c)
  800916:	38 ca                	cmp    %cl,%dl
  800918:	74 0f                	je     800929 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	0f b6 10             	movzbl (%eax),%edx
  800920:	84 d2                	test   %dl,%dl
  800922:	75 f2                	jne    800916 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800935:	eb 07                	jmp    80093e <strfind+0x13>
		if (*s == c)
  800937:	38 ca                	cmp    %cl,%dl
  800939:	74 0a                	je     800945 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	0f b6 10             	movzbl (%eax),%edx
  800941:	84 d2                	test   %dl,%dl
  800943:	75 f2                	jne    800937 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	57                   	push   %edi
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800950:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800953:	85 c9                	test   %ecx,%ecx
  800955:	74 36                	je     80098d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800957:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80095d:	75 28                	jne    800987 <memset+0x40>
  80095f:	f6 c1 03             	test   $0x3,%cl
  800962:	75 23                	jne    800987 <memset+0x40>
		c &= 0xFF;
  800964:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800968:	89 d3                	mov    %edx,%ebx
  80096a:	c1 e3 08             	shl    $0x8,%ebx
  80096d:	89 d6                	mov    %edx,%esi
  80096f:	c1 e6 18             	shl    $0x18,%esi
  800972:	89 d0                	mov    %edx,%eax
  800974:	c1 e0 10             	shl    $0x10,%eax
  800977:	09 f0                	or     %esi,%eax
  800979:	09 c2                	or     %eax,%edx
  80097b:	89 d0                	mov    %edx,%eax
  80097d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80097f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800982:	fc                   	cld    
  800983:	f3 ab                	rep stos %eax,%es:(%edi)
  800985:	eb 06                	jmp    80098d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	fc                   	cld    
  80098b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80098d:	89 f8                	mov    %edi,%eax
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5f                   	pop    %edi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	57                   	push   %edi
  800998:	56                   	push   %esi
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80099f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a2:	39 c6                	cmp    %eax,%esi
  8009a4:	73 35                	jae    8009db <memmove+0x47>
  8009a6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a9:	39 d0                	cmp    %edx,%eax
  8009ab:	73 2e                	jae    8009db <memmove+0x47>
		s += n;
		d += n;
  8009ad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009b0:	89 d6                	mov    %edx,%esi
  8009b2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ba:	75 13                	jne    8009cf <memmove+0x3b>
  8009bc:	f6 c1 03             	test   $0x3,%cl
  8009bf:	75 0e                	jne    8009cf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c1:	83 ef 04             	sub    $0x4,%edi
  8009c4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ca:	fd                   	std    
  8009cb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009cd:	eb 09                	jmp    8009d8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009cf:	83 ef 01             	sub    $0x1,%edi
  8009d2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009d5:	fd                   	std    
  8009d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d8:	fc                   	cld    
  8009d9:	eb 1d                	jmp    8009f8 <memmove+0x64>
  8009db:	89 f2                	mov    %esi,%edx
  8009dd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009df:	f6 c2 03             	test   $0x3,%dl
  8009e2:	75 0f                	jne    8009f3 <memmove+0x5f>
  8009e4:	f6 c1 03             	test   $0x3,%cl
  8009e7:	75 0a                	jne    8009f3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009e9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009ec:	89 c7                	mov    %eax,%edi
  8009ee:	fc                   	cld    
  8009ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f1:	eb 05                	jmp    8009f8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009f3:	89 c7                	mov    %eax,%edi
  8009f5:	fc                   	cld    
  8009f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f8:	5e                   	pop    %esi
  8009f9:	5f                   	pop    %edi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	89 04 24             	mov    %eax,(%esp)
  800a16:	e8 79 ff ff ff       	call   800994 <memmove>
}
  800a1b:	c9                   	leave  
  800a1c:	c3                   	ret    

00800a1d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	56                   	push   %esi
  800a21:	53                   	push   %ebx
  800a22:	8b 55 08             	mov    0x8(%ebp),%edx
  800a25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a28:	89 d6                	mov    %edx,%esi
  800a2a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2d:	eb 1a                	jmp    800a49 <memcmp+0x2c>
		if (*s1 != *s2)
  800a2f:	0f b6 02             	movzbl (%edx),%eax
  800a32:	0f b6 19             	movzbl (%ecx),%ebx
  800a35:	38 d8                	cmp    %bl,%al
  800a37:	74 0a                	je     800a43 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a39:	0f b6 c0             	movzbl %al,%eax
  800a3c:	0f b6 db             	movzbl %bl,%ebx
  800a3f:	29 d8                	sub    %ebx,%eax
  800a41:	eb 0f                	jmp    800a52 <memcmp+0x35>
		s1++, s2++;
  800a43:	83 c2 01             	add    $0x1,%edx
  800a46:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a49:	39 f2                	cmp    %esi,%edx
  800a4b:	75 e2                	jne    800a2f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5f:	89 c2                	mov    %eax,%edx
  800a61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a64:	eb 07                	jmp    800a6d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a66:	38 08                	cmp    %cl,(%eax)
  800a68:	74 07                	je     800a71 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	39 d0                	cmp    %edx,%eax
  800a6f:	72 f5                	jb     800a66 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	57                   	push   %edi
  800a77:	56                   	push   %esi
  800a78:	53                   	push   %ebx
  800a79:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7f:	eb 03                	jmp    800a84 <strtol+0x11>
		s++;
  800a81:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a84:	0f b6 0a             	movzbl (%edx),%ecx
  800a87:	80 f9 09             	cmp    $0x9,%cl
  800a8a:	74 f5                	je     800a81 <strtol+0xe>
  800a8c:	80 f9 20             	cmp    $0x20,%cl
  800a8f:	74 f0                	je     800a81 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a91:	80 f9 2b             	cmp    $0x2b,%cl
  800a94:	75 0a                	jne    800aa0 <strtol+0x2d>
		s++;
  800a96:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a99:	bf 00 00 00 00       	mov    $0x0,%edi
  800a9e:	eb 11                	jmp    800ab1 <strtol+0x3e>
  800aa0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800aa5:	80 f9 2d             	cmp    $0x2d,%cl
  800aa8:	75 07                	jne    800ab1 <strtol+0x3e>
		s++, neg = 1;
  800aaa:	8d 52 01             	lea    0x1(%edx),%edx
  800aad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ab6:	75 15                	jne    800acd <strtol+0x5a>
  800ab8:	80 3a 30             	cmpb   $0x30,(%edx)
  800abb:	75 10                	jne    800acd <strtol+0x5a>
  800abd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ac1:	75 0a                	jne    800acd <strtol+0x5a>
		s += 2, base = 16;
  800ac3:	83 c2 02             	add    $0x2,%edx
  800ac6:	b8 10 00 00 00       	mov    $0x10,%eax
  800acb:	eb 10                	jmp    800add <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800acd:	85 c0                	test   %eax,%eax
  800acf:	75 0c                	jne    800add <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ad1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ad3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ad6:	75 05                	jne    800add <strtol+0x6a>
		s++, base = 8;
  800ad8:	83 c2 01             	add    $0x1,%edx
  800adb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800add:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ae2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ae5:	0f b6 0a             	movzbl (%edx),%ecx
  800ae8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800aeb:	89 f0                	mov    %esi,%eax
  800aed:	3c 09                	cmp    $0x9,%al
  800aef:	77 08                	ja     800af9 <strtol+0x86>
			dig = *s - '0';
  800af1:	0f be c9             	movsbl %cl,%ecx
  800af4:	83 e9 30             	sub    $0x30,%ecx
  800af7:	eb 20                	jmp    800b19 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800af9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800afc:	89 f0                	mov    %esi,%eax
  800afe:	3c 19                	cmp    $0x19,%al
  800b00:	77 08                	ja     800b0a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b02:	0f be c9             	movsbl %cl,%ecx
  800b05:	83 e9 57             	sub    $0x57,%ecx
  800b08:	eb 0f                	jmp    800b19 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b0a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b0d:	89 f0                	mov    %esi,%eax
  800b0f:	3c 19                	cmp    $0x19,%al
  800b11:	77 16                	ja     800b29 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b13:	0f be c9             	movsbl %cl,%ecx
  800b16:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b19:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b1c:	7d 0f                	jge    800b2d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b1e:	83 c2 01             	add    $0x1,%edx
  800b21:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b25:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b27:	eb bc                	jmp    800ae5 <strtol+0x72>
  800b29:	89 d8                	mov    %ebx,%eax
  800b2b:	eb 02                	jmp    800b2f <strtol+0xbc>
  800b2d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b33:	74 05                	je     800b3a <strtol+0xc7>
		*endptr = (char *) s;
  800b35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b38:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b3a:	f7 d8                	neg    %eax
  800b3c:	85 ff                	test   %edi,%edi
  800b3e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	57                   	push   %edi
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	89 c3                	mov    %eax,%ebx
  800b59:	89 c7                	mov    %eax,%edi
  800b5b:	89 c6                	mov    %eax,%esi
  800b5d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	57                   	push   %edi
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b74:	89 d1                	mov    %edx,%ecx
  800b76:	89 d3                	mov    %edx,%ebx
  800b78:	89 d7                	mov    %edx,%edi
  800b7a:	89 d6                	mov    %edx,%esi
  800b7c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b91:	b8 03 00 00 00       	mov    $0x3,%eax
  800b96:	8b 55 08             	mov    0x8(%ebp),%edx
  800b99:	89 cb                	mov    %ecx,%ebx
  800b9b:	89 cf                	mov    %ecx,%edi
  800b9d:	89 ce                	mov    %ecx,%esi
  800b9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	7e 28                	jle    800bcd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ba9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bb0:	00 
  800bb1:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800bb8:	00 
  800bb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bc0:	00 
  800bc1:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800bc8:	e8 29 1b 00 00       	call   8026f6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bcd:	83 c4 2c             	add    $0x2c,%esp
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800be0:	b8 02 00 00 00       	mov    $0x2,%eax
  800be5:	89 d1                	mov    %edx,%ecx
  800be7:	89 d3                	mov    %edx,%ebx
  800be9:	89 d7                	mov    %edx,%edi
  800beb:	89 d6                	mov    %edx,%esi
  800bed:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <sys_yield>:

void
sys_yield(void)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  800bff:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c04:	89 d1                	mov    %edx,%ecx
  800c06:	89 d3                	mov    %edx,%ebx
  800c08:	89 d7                	mov    %edx,%edi
  800c0a:	89 d6                	mov    %edx,%esi
  800c0c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1c:	be 00 00 00 00       	mov    $0x0,%esi
  800c21:	b8 04 00 00 00       	mov    $0x4,%eax
  800c26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2f:	89 f7                	mov    %esi,%edi
  800c31:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c33:	85 c0                	test   %eax,%eax
  800c35:	7e 28                	jle    800c5f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c37:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c3b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c42:	00 
  800c43:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800c4a:	00 
  800c4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c52:	00 
  800c53:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800c5a:	e8 97 1a 00 00       	call   8026f6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c5f:	83 c4 2c             	add    $0x2c,%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
  800c6d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c70:	b8 05 00 00 00       	mov    $0x5,%eax
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c7e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c81:	8b 75 18             	mov    0x18(%ebp),%esi
  800c84:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c86:	85 c0                	test   %eax,%eax
  800c88:	7e 28                	jle    800cb2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c8e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c95:	00 
  800c96:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800c9d:	00 
  800c9e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca5:	00 
  800ca6:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800cad:	e8 44 1a 00 00       	call   8026f6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb2:	83 c4 2c             	add    $0x2c,%esp
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
  800cc0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd3:	89 df                	mov    %ebx,%edi
  800cd5:	89 de                	mov    %ebx,%esi
  800cd7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	7e 28                	jle    800d05 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ce1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ce8:	00 
  800ce9:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800cf0:	00 
  800cf1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf8:	00 
  800cf9:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800d00:	e8 f1 19 00 00       	call   8026f6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d05:	83 c4 2c             	add    $0x2c,%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	89 df                	mov    %ebx,%edi
  800d28:	89 de                	mov    %ebx,%esi
  800d2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7e 28                	jle    800d58 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d34:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d3b:	00 
  800d3c:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800d43:	00 
  800d44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d4b:	00 
  800d4c:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800d53:	e8 9e 19 00 00       	call   8026f6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d58:	83 c4 2c             	add    $0x2c,%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	89 df                	mov    %ebx,%edi
  800d7b:	89 de                	mov    %ebx,%esi
  800d7d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	7e 28                	jle    800dab <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d87:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d8e:	00 
  800d8f:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800d96:	00 
  800d97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9e:	00 
  800d9f:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800da6:	e8 4b 19 00 00       	call   8026f6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dab:	83 c4 2c             	add    $0x2c,%esp
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	89 df                	mov    %ebx,%edi
  800dce:	89 de                	mov    %ebx,%esi
  800dd0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7e 28                	jle    800dfe <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dda:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800de1:	00 
  800de2:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800de9:	00 
  800dea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df1:	00 
  800df2:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800df9:	e8 f8 18 00 00       	call   8026f6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dfe:	83 c4 2c             	add    $0x2c,%esp
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0c:	be 00 00 00 00       	mov    $0x0,%esi
  800e11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e22:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e37:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	89 cb                	mov    %ecx,%ebx
  800e41:	89 cf                	mov    %ecx,%edi
  800e43:	89 ce                	mov    %ecx,%esi
  800e45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e47:	85 c0                	test   %eax,%eax
  800e49:	7e 28                	jle    800e73 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e56:	00 
  800e57:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e66:	00 
  800e67:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800e6e:	e8 83 18 00 00       	call   8026f6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e73:	83 c4 2c             	add    $0x2c,%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e81:	ba 00 00 00 00       	mov    $0x0,%edx
  800e86:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8b:	89 d1                	mov    %edx,%ecx
  800e8d:	89 d3                	mov    %edx,%ebx
  800e8f:	89 d7                	mov    %edx,%edi
  800e91:	89 d6                	mov    %edx,%esi
  800e93:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	89 de                	mov    %ebx,%esi
  800eb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7e 28                	jle    800ee5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ec8:	00 
  800ec9:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800ed0:	00 
  800ed1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed8:	00 
  800ed9:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800ee0:	e8 11 18 00 00       	call   8026f6 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800ee5:	83 c4 2c             	add    $0x2c,%esp
  800ee8:	5b                   	pop    %ebx
  800ee9:	5e                   	pop    %esi
  800eea:	5f                   	pop    %edi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efb:	b8 10 00 00 00       	mov    $0x10,%eax
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	89 df                	mov    %ebx,%edi
  800f08:	89 de                	mov    %ebx,%esi
  800f0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	7e 28                	jle    800f38 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f14:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f1b:	00 
  800f1c:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800f23:	00 
  800f24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f2b:	00 
  800f2c:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800f33:	e8 be 17 00 00       	call   8026f6 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800f38:	83 c4 2c             	add    $0x2c,%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4e:	b8 11 00 00 00       	mov    $0x11,%eax
  800f53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	89 df                	mov    %ebx,%edi
  800f5b:	89 de                	mov    %ebx,%esi
  800f5d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	7e 28                	jle    800f8b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f63:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f67:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800f6e:	00 
  800f6f:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800f76:	00 
  800f77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7e:	00 
  800f7f:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800f86:	e8 6b 17 00 00       	call   8026f6 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  800f8b:	83 c4 2c             	add    $0x2c,%esp
  800f8e:	5b                   	pop    %ebx
  800f8f:	5e                   	pop    %esi
  800f90:	5f                   	pop    %edi
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <sys_sleep>:

int
sys_sleep(int channel)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa1:	b8 12 00 00 00       	mov    $0x12,%eax
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	89 cb                	mov    %ecx,%ebx
  800fab:	89 cf                	mov    %ecx,%edi
  800fad:	89 ce                	mov    %ecx,%esi
  800faf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	7e 28                	jle    800fdd <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800fc8:	00 
  800fc9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd0:	00 
  800fd1:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800fd8:	e8 19 17 00 00       	call   8026f6 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  800fdd:	83 c4 2c             	add    $0x2c,%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
  800feb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff3:	b8 13 00 00 00       	mov    $0x13,%eax
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	89 df                	mov    %ebx,%edi
  801000:	89 de                	mov    %ebx,%esi
  801002:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801004:	85 c0                	test   %eax,%eax
  801006:	7e 28                	jle    801030 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801008:	89 44 24 10          	mov    %eax,0x10(%esp)
  80100c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801013:	00 
  801014:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  80101b:	00 
  80101c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801023:	00 
  801024:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  80102b:	e8 c6 16 00 00       	call   8026f6 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801030:	83 c4 2c             	add    $0x2c,%esp
  801033:	5b                   	pop    %ebx
  801034:	5e                   	pop    %esi
  801035:	5f                   	pop    %edi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	53                   	push   %ebx
  80103c:	83 ec 24             	sub    $0x24,%esp
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801042:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801044:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801048:	74 27                	je     801071 <pgfault+0x39>
  80104a:	89 c2                	mov    %eax,%edx
  80104c:	c1 ea 16             	shr    $0x16,%edx
  80104f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801056:	f6 c2 01             	test   $0x1,%dl
  801059:	74 16                	je     801071 <pgfault+0x39>
  80105b:	89 c2                	mov    %eax,%edx
  80105d:	c1 ea 0c             	shr    $0xc,%edx
  801060:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801067:	f7 d2                	not    %edx
  801069:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80106f:	74 1c                	je     80108d <pgfault+0x55>
		panic("pgfault");
  801071:	c7 44 24 08 f6 2f 80 	movl   $0x802ff6,0x8(%esp)
  801078:	00 
  801079:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801080:	00 
  801081:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  801088:	e8 69 16 00 00       	call   8026f6 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80108d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801092:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801094:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80109b:	00 
  80109c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010a3:	00 
  8010a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010ab:	e8 63 fb ff ff       	call   800c13 <sys_page_alloc>
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	79 1c                	jns    8010d0 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  8010b4:	c7 44 24 08 09 30 80 	movl   $0x803009,0x8(%esp)
  8010bb:	00 
  8010bc:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8010c3:	00 
  8010c4:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  8010cb:	e8 26 16 00 00       	call   8026f6 <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  8010d0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010d7:	00 
  8010d8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010dc:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010e3:	e8 14 f9 ff ff       	call   8009fc <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  8010e8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010ef:	00 
  8010f0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010fb:	00 
  8010fc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801103:	00 
  801104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80110b:	e8 57 fb ff ff       	call   800c67 <sys_page_map>
  801110:	85 c0                	test   %eax,%eax
  801112:	79 1c                	jns    801130 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  801114:	c7 44 24 08 23 30 80 	movl   $0x803023,0x8(%esp)
  80111b:	00 
  80111c:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801123:	00 
  801124:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80112b:	e8 c6 15 00 00       	call   8026f6 <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801130:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801137:	00 
  801138:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80113f:	e8 76 fb ff ff       	call   800cba <sys_page_unmap>
  801144:	85 c0                	test   %eax,%eax
  801146:	79 1c                	jns    801164 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801148:	c7 44 24 08 3b 30 80 	movl   $0x80303b,0x8(%esp)
  80114f:	00 
  801150:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801157:	00 
  801158:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80115f:	e8 92 15 00 00       	call   8026f6 <_panic>
	}
}
  801164:	83 c4 24             	add    $0x24,%esp
  801167:	5b                   	pop    %ebx
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	57                   	push   %edi
  80116e:	56                   	push   %esi
  80116f:	53                   	push   %ebx
  801170:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801173:	c7 04 24 38 10 80 00 	movl   $0x801038,(%esp)
  80117a:	e8 cd 15 00 00       	call   80274c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80117f:	b8 07 00 00 00       	mov    $0x7,%eax
  801184:	cd 30                	int    $0x30
  801186:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801189:	85 c0                	test   %eax,%eax
  80118b:	79 1c                	jns    8011a9 <fork+0x3f>
		panic("fork(): sys_exofork");
  80118d:	c7 44 24 08 55 30 80 	movl   $0x803055,0x8(%esp)
  801194:	00 
  801195:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80119c:	00 
  80119d:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  8011a4:	e8 4d 15 00 00       	call   8026f6 <_panic>
  8011a9:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  8011ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011af:	74 0a                	je     8011bb <fork+0x51>
  8011b1:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8011b6:	e9 9d 01 00 00       	jmp    801358 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  8011bb:	e8 15 fa ff ff       	call   800bd5 <sys_getenvid>
  8011c0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	c1 e2 07             	shl    $0x7,%edx
  8011ca:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8011d1:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  8011d6:	e9 2a 02 00 00       	jmp    801405 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  8011db:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8011e1:	0f 84 6b 01 00 00    	je     801352 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  8011e7:	89 d8                	mov    %ebx,%eax
  8011e9:	c1 e8 16             	shr    $0x16,%eax
  8011ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f3:	a8 01                	test   $0x1,%al
  8011f5:	0f 84 57 01 00 00    	je     801352 <fork+0x1e8>
  8011fb:	89 d8                	mov    %ebx,%eax
  8011fd:	c1 e8 0c             	shr    $0xc,%eax
  801200:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801207:	f7 d0                	not    %eax
  801209:	a8 05                	test   $0x5,%al
  80120b:	0f 85 41 01 00 00    	jne    801352 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  801211:	89 d8                	mov    %ebx,%eax
  801213:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  801216:	89 c6                	mov    %eax,%esi
  801218:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  80121b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801222:	f6 c6 04             	test   $0x4,%dh
  801225:	74 4c                	je     801273 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  801227:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80122e:	25 07 0e 00 00       	and    $0xe07,%eax
  801233:	89 44 24 10          	mov    %eax,0x10(%esp)
  801237:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80123b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80123f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801243:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80124a:	e8 18 fa ff ff       	call   800c67 <sys_page_map>
  80124f:	85 c0                	test   %eax,%eax
  801251:	0f 89 fb 00 00 00    	jns    801352 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801257:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  80125e:	00 
  80125f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801266:	00 
  801267:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80126e:	e8 83 14 00 00       	call   8026f6 <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801273:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80127a:	f6 c6 08             	test   $0x8,%dh
  80127d:	75 0f                	jne    80128e <fork+0x124>
  80127f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801286:	a8 02                	test   $0x2,%al
  801288:	0f 84 84 00 00 00    	je     801312 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80128e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801295:	00 
  801296:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80129a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80129e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a9:	e8 b9 f9 ff ff       	call   800c67 <sys_page_map>
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	79 1c                	jns    8012ce <fork+0x164>
			panic("duppage: sys_page_map");
  8012b2:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  8012b9:	00 
  8012ba:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8012c1:	00 
  8012c2:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  8012c9:	e8 28 14 00 00       	call   8026f6 <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  8012ce:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012d5:	00 
  8012d6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012e1:	00 
  8012e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ed:	e8 75 f9 ff ff       	call   800c67 <sys_page_map>
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	79 5c                	jns    801352 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8012f6:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  8012fd:	00 
  8012fe:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  801305:	00 
  801306:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80130d:	e8 e4 13 00 00       	call   8026f6 <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  801312:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801319:	00 
  80131a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80131e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801322:	89 74 24 04          	mov    %esi,0x4(%esp)
  801326:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80132d:	e8 35 f9 ff ff       	call   800c67 <sys_page_map>
  801332:	85 c0                	test   %eax,%eax
  801334:	79 1c                	jns    801352 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801336:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  80133d:	00 
  80133e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801345:	00 
  801346:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80134d:	e8 a4 13 00 00       	call   8026f6 <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801352:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801358:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80135e:	0f 85 77 fe ff ff    	jne    8011db <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801364:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80136b:	00 
  80136c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801373:	ee 
  801374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801377:	89 04 24             	mov    %eax,(%esp)
  80137a:	e8 94 f8 ff ff       	call   800c13 <sys_page_alloc>
  80137f:	85 c0                	test   %eax,%eax
  801381:	79 1c                	jns    80139f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801383:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  80138a:	00 
  80138b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801392:	00 
  801393:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80139a:	e8 57 13 00 00       	call   8026f6 <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80139f:	c7 44 24 04 d5 27 80 	movl   $0x8027d5,0x4(%esp)
  8013a6:	00 
  8013a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013aa:	89 04 24             	mov    %eax,(%esp)
  8013ad:	e8 01 fa ff ff       	call   800db3 <sys_env_set_pgfault_upcall>
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	79 1c                	jns    8013d2 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  8013b6:	c7 44 24 08 c8 30 80 	movl   $0x8030c8,0x8(%esp)
  8013bd:	00 
  8013be:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  8013c5:	00 
  8013c6:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  8013cd:	e8 24 13 00 00       	call   8026f6 <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  8013d2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013d9:	00 
  8013da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013dd:	89 04 24             	mov    %eax,(%esp)
  8013e0:	e8 28 f9 ff ff       	call   800d0d <sys_env_set_status>
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	79 1c                	jns    801405 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  8013e9:	c7 44 24 08 96 30 80 	movl   $0x803096,0x8(%esp)
  8013f0:	00 
  8013f1:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  8013f8:	00 
  8013f9:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  801400:	e8 f1 12 00 00       	call   8026f6 <_panic>
	}

	return env_id;
}
  801405:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801408:	83 c4 2c             	add    $0x2c,%esp
  80140b:	5b                   	pop    %ebx
  80140c:	5e                   	pop    %esi
  80140d:	5f                   	pop    %edi
  80140e:	5d                   	pop    %ebp
  80140f:	c3                   	ret    

00801410 <sfork>:

// Challenge!
int
sfork(void)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801416:	c7 44 24 08 b1 30 80 	movl   $0x8030b1,0x8(%esp)
  80141d:	00 
  80141e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  801425:	00 
  801426:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80142d:	e8 c4 12 00 00       	call   8026f6 <_panic>
  801432:	66 90                	xchg   %ax,%ax
  801434:	66 90                	xchg   %ax,%ax
  801436:	66 90                	xchg   %ax,%ax
  801438:	66 90                	xchg   %ax,%ax
  80143a:	66 90                	xchg   %ax,%ax
  80143c:	66 90                	xchg   %ax,%ax
  80143e:	66 90                	xchg   %ax,%ax

00801440 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	05 00 00 00 30       	add    $0x30000000,%eax
  80144b:	c1 e8 0c             	shr    $0xc,%eax
}
  80144e:	5d                   	pop    %ebp
  80144f:	c3                   	ret    

00801450 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80145b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801460:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    

00801467 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80146d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801472:	89 c2                	mov    %eax,%edx
  801474:	c1 ea 16             	shr    $0x16,%edx
  801477:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80147e:	f6 c2 01             	test   $0x1,%dl
  801481:	74 11                	je     801494 <fd_alloc+0x2d>
  801483:	89 c2                	mov    %eax,%edx
  801485:	c1 ea 0c             	shr    $0xc,%edx
  801488:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80148f:	f6 c2 01             	test   $0x1,%dl
  801492:	75 09                	jne    80149d <fd_alloc+0x36>
			*fd_store = fd;
  801494:	89 01                	mov    %eax,(%ecx)
			return 0;
  801496:	b8 00 00 00 00       	mov    $0x0,%eax
  80149b:	eb 17                	jmp    8014b4 <fd_alloc+0x4d>
  80149d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014a7:	75 c9                	jne    801472 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8014af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    

008014b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014bc:	83 f8 1f             	cmp    $0x1f,%eax
  8014bf:	77 36                	ja     8014f7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014c1:	c1 e0 0c             	shl    $0xc,%eax
  8014c4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014c9:	89 c2                	mov    %eax,%edx
  8014cb:	c1 ea 16             	shr    $0x16,%edx
  8014ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014d5:	f6 c2 01             	test   $0x1,%dl
  8014d8:	74 24                	je     8014fe <fd_lookup+0x48>
  8014da:	89 c2                	mov    %eax,%edx
  8014dc:	c1 ea 0c             	shr    $0xc,%edx
  8014df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014e6:	f6 c2 01             	test   $0x1,%dl
  8014e9:	74 1a                	je     801505 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 02                	mov    %eax,(%edx)
	return 0;
  8014f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f5:	eb 13                	jmp    80150a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fc:	eb 0c                	jmp    80150a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801503:	eb 05                	jmp    80150a <fd_lookup+0x54>
  801505:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80150a:	5d                   	pop    %ebp
  80150b:	c3                   	ret    

0080150c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	83 ec 18             	sub    $0x18,%esp
  801512:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801515:	ba 00 00 00 00       	mov    $0x0,%edx
  80151a:	eb 13                	jmp    80152f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80151c:	39 08                	cmp    %ecx,(%eax)
  80151e:	75 0c                	jne    80152c <dev_lookup+0x20>
			*dev = devtab[i];
  801520:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801523:	89 01                	mov    %eax,(%ecx)
			return 0;
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
  80152a:	eb 38                	jmp    801564 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80152c:	83 c2 01             	add    $0x1,%edx
  80152f:	8b 04 95 68 31 80 00 	mov    0x803168(,%edx,4),%eax
  801536:	85 c0                	test   %eax,%eax
  801538:	75 e2                	jne    80151c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80153a:	a1 08 50 80 00       	mov    0x805008,%eax
  80153f:	8b 40 48             	mov    0x48(%eax),%eax
  801542:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154a:	c7 04 24 ec 30 80 00 	movl   $0x8030ec,(%esp)
  801551:	e8 71 ec ff ff       	call   8001c7 <cprintf>
	*dev = 0;
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80155f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	56                   	push   %esi
  80156a:	53                   	push   %ebx
  80156b:	83 ec 20             	sub    $0x20,%esp
  80156e:	8b 75 08             	mov    0x8(%ebp),%esi
  801571:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801574:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801577:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80157b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801581:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	e8 2a ff ff ff       	call   8014b6 <fd_lookup>
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 05                	js     801595 <fd_close+0x2f>
	    || fd != fd2)
  801590:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801593:	74 0c                	je     8015a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801595:	84 db                	test   %bl,%bl
  801597:	ba 00 00 00 00       	mov    $0x0,%edx
  80159c:	0f 44 c2             	cmove  %edx,%eax
  80159f:	eb 3f                	jmp    8015e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a8:	8b 06                	mov    (%esi),%eax
  8015aa:	89 04 24             	mov    %eax,(%esp)
  8015ad:	e8 5a ff ff ff       	call   80150c <dev_lookup>
  8015b2:	89 c3                	mov    %eax,%ebx
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	78 16                	js     8015ce <fd_close+0x68>
		if (dev->dev_close)
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	74 07                	je     8015ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015c7:	89 34 24             	mov    %esi,(%esp)
  8015ca:	ff d0                	call   *%eax
  8015cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d9:	e8 dc f6 ff ff       	call   800cba <sys_page_unmap>
	return r;
  8015de:	89 d8                	mov    %ebx,%eax
}
  8015e0:	83 c4 20             	add    $0x20,%esp
  8015e3:	5b                   	pop    %ebx
  8015e4:	5e                   	pop    %esi
  8015e5:	5d                   	pop    %ebp
  8015e6:	c3                   	ret    

008015e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	89 04 24             	mov    %eax,(%esp)
  8015fa:	e8 b7 fe ff ff       	call   8014b6 <fd_lookup>
  8015ff:	89 c2                	mov    %eax,%edx
  801601:	85 d2                	test   %edx,%edx
  801603:	78 13                	js     801618 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801605:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80160c:	00 
  80160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801610:	89 04 24             	mov    %eax,(%esp)
  801613:	e8 4e ff ff ff       	call   801566 <fd_close>
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <close_all>:

void
close_all(void)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	53                   	push   %ebx
  80161e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801621:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801626:	89 1c 24             	mov    %ebx,(%esp)
  801629:	e8 b9 ff ff ff       	call   8015e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80162e:	83 c3 01             	add    $0x1,%ebx
  801631:	83 fb 20             	cmp    $0x20,%ebx
  801634:	75 f0                	jne    801626 <close_all+0xc>
		close(i);
}
  801636:	83 c4 14             	add    $0x14,%esp
  801639:	5b                   	pop    %ebx
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	57                   	push   %edi
  801640:	56                   	push   %esi
  801641:	53                   	push   %ebx
  801642:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801645:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	89 04 24             	mov    %eax,(%esp)
  801652:	e8 5f fe ff ff       	call   8014b6 <fd_lookup>
  801657:	89 c2                	mov    %eax,%edx
  801659:	85 d2                	test   %edx,%edx
  80165b:	0f 88 e1 00 00 00    	js     801742 <dup+0x106>
		return r;
	close(newfdnum);
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 04 24             	mov    %eax,(%esp)
  801667:	e8 7b ff ff ff       	call   8015e7 <close>

	newfd = INDEX2FD(newfdnum);
  80166c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80166f:	c1 e3 0c             	shl    $0xc,%ebx
  801672:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167b:	89 04 24             	mov    %eax,(%esp)
  80167e:	e8 cd fd ff ff       	call   801450 <fd2data>
  801683:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801685:	89 1c 24             	mov    %ebx,(%esp)
  801688:	e8 c3 fd ff ff       	call   801450 <fd2data>
  80168d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80168f:	89 f0                	mov    %esi,%eax
  801691:	c1 e8 16             	shr    $0x16,%eax
  801694:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80169b:	a8 01                	test   $0x1,%al
  80169d:	74 43                	je     8016e2 <dup+0xa6>
  80169f:	89 f0                	mov    %esi,%eax
  8016a1:	c1 e8 0c             	shr    $0xc,%eax
  8016a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016ab:	f6 c2 01             	test   $0x1,%dl
  8016ae:	74 32                	je     8016e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8016bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016cb:	00 
  8016cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d7:	e8 8b f5 ff ff       	call   800c67 <sys_page_map>
  8016dc:	89 c6                	mov    %eax,%esi
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	78 3e                	js     801720 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e5:	89 c2                	mov    %eax,%edx
  8016e7:	c1 ea 0c             	shr    $0xc,%edx
  8016ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801706:	00 
  801707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801712:	e8 50 f5 ff ff       	call   800c67 <sys_page_map>
  801717:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801719:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80171c:	85 f6                	test   %esi,%esi
  80171e:	79 22                	jns    801742 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801720:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801724:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80172b:	e8 8a f5 ff ff       	call   800cba <sys_page_unmap>
	sys_page_unmap(0, nva);
  801730:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801734:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80173b:	e8 7a f5 ff ff       	call   800cba <sys_page_unmap>
	return r;
  801740:	89 f0                	mov    %esi,%eax
}
  801742:	83 c4 3c             	add    $0x3c,%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5f                   	pop    %edi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    

0080174a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	53                   	push   %ebx
  80174e:	83 ec 24             	sub    $0x24,%esp
  801751:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801754:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801757:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175b:	89 1c 24             	mov    %ebx,(%esp)
  80175e:	e8 53 fd ff ff       	call   8014b6 <fd_lookup>
  801763:	89 c2                	mov    %eax,%edx
  801765:	85 d2                	test   %edx,%edx
  801767:	78 6d                	js     8017d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801769:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801773:	8b 00                	mov    (%eax),%eax
  801775:	89 04 24             	mov    %eax,(%esp)
  801778:	e8 8f fd ff ff       	call   80150c <dev_lookup>
  80177d:	85 c0                	test   %eax,%eax
  80177f:	78 55                	js     8017d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801784:	8b 50 08             	mov    0x8(%eax),%edx
  801787:	83 e2 03             	and    $0x3,%edx
  80178a:	83 fa 01             	cmp    $0x1,%edx
  80178d:	75 23                	jne    8017b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80178f:	a1 08 50 80 00       	mov    0x805008,%eax
  801794:	8b 40 48             	mov    0x48(%eax),%eax
  801797:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80179b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179f:	c7 04 24 2d 31 80 00 	movl   $0x80312d,(%esp)
  8017a6:	e8 1c ea ff ff       	call   8001c7 <cprintf>
		return -E_INVAL;
  8017ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b0:	eb 24                	jmp    8017d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8017b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b5:	8b 52 08             	mov    0x8(%edx),%edx
  8017b8:	85 d2                	test   %edx,%edx
  8017ba:	74 15                	je     8017d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017ca:	89 04 24             	mov    %eax,(%esp)
  8017cd:	ff d2                	call   *%edx
  8017cf:	eb 05                	jmp    8017d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017d6:	83 c4 24             	add    $0x24,%esp
  8017d9:	5b                   	pop    %ebx
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	57                   	push   %edi
  8017e0:	56                   	push   %esi
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 1c             	sub    $0x1c,%esp
  8017e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f0:	eb 23                	jmp    801815 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017f2:	89 f0                	mov    %esi,%eax
  8017f4:	29 d8                	sub    %ebx,%eax
  8017f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017fa:	89 d8                	mov    %ebx,%eax
  8017fc:	03 45 0c             	add    0xc(%ebp),%eax
  8017ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801803:	89 3c 24             	mov    %edi,(%esp)
  801806:	e8 3f ff ff ff       	call   80174a <read>
		if (m < 0)
  80180b:	85 c0                	test   %eax,%eax
  80180d:	78 10                	js     80181f <readn+0x43>
			return m;
		if (m == 0)
  80180f:	85 c0                	test   %eax,%eax
  801811:	74 0a                	je     80181d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801813:	01 c3                	add    %eax,%ebx
  801815:	39 f3                	cmp    %esi,%ebx
  801817:	72 d9                	jb     8017f2 <readn+0x16>
  801819:	89 d8                	mov    %ebx,%eax
  80181b:	eb 02                	jmp    80181f <readn+0x43>
  80181d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80181f:	83 c4 1c             	add    $0x1c,%esp
  801822:	5b                   	pop    %ebx
  801823:	5e                   	pop    %esi
  801824:	5f                   	pop    %edi
  801825:	5d                   	pop    %ebp
  801826:	c3                   	ret    

00801827 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	53                   	push   %ebx
  80182b:	83 ec 24             	sub    $0x24,%esp
  80182e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801831:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801834:	89 44 24 04          	mov    %eax,0x4(%esp)
  801838:	89 1c 24             	mov    %ebx,(%esp)
  80183b:	e8 76 fc ff ff       	call   8014b6 <fd_lookup>
  801840:	89 c2                	mov    %eax,%edx
  801842:	85 d2                	test   %edx,%edx
  801844:	78 68                	js     8018ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801846:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801849:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801850:	8b 00                	mov    (%eax),%eax
  801852:	89 04 24             	mov    %eax,(%esp)
  801855:	e8 b2 fc ff ff       	call   80150c <dev_lookup>
  80185a:	85 c0                	test   %eax,%eax
  80185c:	78 50                	js     8018ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80185e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801861:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801865:	75 23                	jne    80188a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801867:	a1 08 50 80 00       	mov    0x805008,%eax
  80186c:	8b 40 48             	mov    0x48(%eax),%eax
  80186f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801873:	89 44 24 04          	mov    %eax,0x4(%esp)
  801877:	c7 04 24 49 31 80 00 	movl   $0x803149,(%esp)
  80187e:	e8 44 e9 ff ff       	call   8001c7 <cprintf>
		return -E_INVAL;
  801883:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801888:	eb 24                	jmp    8018ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80188a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188d:	8b 52 0c             	mov    0xc(%edx),%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	74 15                	je     8018a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801894:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801897:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80189b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80189e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018a2:	89 04 24             	mov    %eax,(%esp)
  8018a5:	ff d2                	call   *%edx
  8018a7:	eb 05                	jmp    8018ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018ae:	83 c4 24             	add    $0x24,%esp
  8018b1:	5b                   	pop    %ebx
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    

008018b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	89 04 24             	mov    %eax,(%esp)
  8018c7:	e8 ea fb ff ff       	call   8014b6 <fd_lookup>
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 0e                	js     8018de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	53                   	push   %ebx
  8018e4:	83 ec 24             	sub    $0x24,%esp
  8018e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f1:	89 1c 24             	mov    %ebx,(%esp)
  8018f4:	e8 bd fb ff ff       	call   8014b6 <fd_lookup>
  8018f9:	89 c2                	mov    %eax,%edx
  8018fb:	85 d2                	test   %edx,%edx
  8018fd:	78 61                	js     801960 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801902:	89 44 24 04          	mov    %eax,0x4(%esp)
  801906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801909:	8b 00                	mov    (%eax),%eax
  80190b:	89 04 24             	mov    %eax,(%esp)
  80190e:	e8 f9 fb ff ff       	call   80150c <dev_lookup>
  801913:	85 c0                	test   %eax,%eax
  801915:	78 49                	js     801960 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80191e:	75 23                	jne    801943 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801920:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801925:	8b 40 48             	mov    0x48(%eax),%eax
  801928:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801930:	c7 04 24 0c 31 80 00 	movl   $0x80310c,(%esp)
  801937:	e8 8b e8 ff ff       	call   8001c7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80193c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801941:	eb 1d                	jmp    801960 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801943:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801946:	8b 52 18             	mov    0x18(%edx),%edx
  801949:	85 d2                	test   %edx,%edx
  80194b:	74 0e                	je     80195b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80194d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801950:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801954:	89 04 24             	mov    %eax,(%esp)
  801957:	ff d2                	call   *%edx
  801959:	eb 05                	jmp    801960 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80195b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801960:	83 c4 24             	add    $0x24,%esp
  801963:	5b                   	pop    %ebx
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	53                   	push   %ebx
  80196a:	83 ec 24             	sub    $0x24,%esp
  80196d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801970:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801973:	89 44 24 04          	mov    %eax,0x4(%esp)
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	89 04 24             	mov    %eax,(%esp)
  80197d:	e8 34 fb ff ff       	call   8014b6 <fd_lookup>
  801982:	89 c2                	mov    %eax,%edx
  801984:	85 d2                	test   %edx,%edx
  801986:	78 52                	js     8019da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801988:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801992:	8b 00                	mov    (%eax),%eax
  801994:	89 04 24             	mov    %eax,(%esp)
  801997:	e8 70 fb ff ff       	call   80150c <dev_lookup>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 3a                	js     8019da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019a7:	74 2c                	je     8019d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019b3:	00 00 00 
	stat->st_isdir = 0;
  8019b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019bd:	00 00 00 
	stat->st_dev = dev;
  8019c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019cd:	89 14 24             	mov    %edx,(%esp)
  8019d0:	ff 50 14             	call   *0x14(%eax)
  8019d3:	eb 05                	jmp    8019da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8019d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8019da:	83 c4 24             	add    $0x24,%esp
  8019dd:	5b                   	pop    %ebx
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    

008019e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	56                   	push   %esi
  8019e4:	53                   	push   %ebx
  8019e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019ef:	00 
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	89 04 24             	mov    %eax,(%esp)
  8019f6:	e8 1b 02 00 00       	call   801c16 <open>
  8019fb:	89 c3                	mov    %eax,%ebx
  8019fd:	85 db                	test   %ebx,%ebx
  8019ff:	78 1b                	js     801a1c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a08:	89 1c 24             	mov    %ebx,(%esp)
  801a0b:	e8 56 ff ff ff       	call   801966 <fstat>
  801a10:	89 c6                	mov    %eax,%esi
	close(fd);
  801a12:	89 1c 24             	mov    %ebx,(%esp)
  801a15:	e8 cd fb ff ff       	call   8015e7 <close>
	return r;
  801a1a:	89 f0                	mov    %esi,%eax
}
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5e                   	pop    %esi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
  801a28:	83 ec 10             	sub    $0x10,%esp
  801a2b:	89 c6                	mov    %eax,%esi
  801a2d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a2f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a36:	75 11                	jne    801a49 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a3f:	e8 7b 0e 00 00       	call   8028bf <ipc_find_env>
  801a44:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a49:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a50:	00 
  801a51:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a58:	00 
  801a59:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a5d:	a1 00 50 80 00       	mov    0x805000,%eax
  801a62:	89 04 24             	mov    %eax,(%esp)
  801a65:	e8 ea 0d 00 00       	call   802854 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a6a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a71:	00 
  801a72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7d:	e8 7e 0d 00 00       	call   802800 <ipc_recv>
}
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	5b                   	pop    %ebx
  801a86:	5e                   	pop    %esi
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	8b 40 0c             	mov    0xc(%eax),%eax
  801a95:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa7:	b8 02 00 00 00       	mov    $0x2,%eax
  801aac:	e8 72 ff ff ff       	call   801a23 <fsipc>
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8b 40 0c             	mov    0xc(%eax),%eax
  801abf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac9:	b8 06 00 00 00       	mov    $0x6,%eax
  801ace:	e8 50 ff ff ff       	call   801a23 <fsipc>
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
  801ad9:	83 ec 14             	sub    $0x14,%esp
  801adc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aea:	ba 00 00 00 00       	mov    $0x0,%edx
  801aef:	b8 05 00 00 00       	mov    $0x5,%eax
  801af4:	e8 2a ff ff ff       	call   801a23 <fsipc>
  801af9:	89 c2                	mov    %eax,%edx
  801afb:	85 d2                	test   %edx,%edx
  801afd:	78 2b                	js     801b2a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801aff:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b06:	00 
  801b07:	89 1c 24             	mov    %ebx,(%esp)
  801b0a:	e8 e8 ec ff ff       	call   8007f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b0f:	a1 80 60 80 00       	mov    0x806080,%eax
  801b14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b1a:	a1 84 60 80 00       	mov    0x806084,%eax
  801b1f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2a:	83 c4 14             	add    $0x14,%esp
  801b2d:	5b                   	pop    %ebx
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 18             	sub    $0x18,%esp
  801b36:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b39:	8b 55 08             	mov    0x8(%ebp),%edx
  801b3c:	8b 52 0c             	mov    0xc(%edx),%edx
  801b3f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801b45:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801b4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b55:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b5c:	e8 9b ee ff ff       	call   8009fc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801b61:	ba 00 00 00 00       	mov    $0x0,%edx
  801b66:	b8 04 00 00 00       	mov    $0x4,%eax
  801b6b:	e8 b3 fe ff ff       	call   801a23 <fsipc>
		return r;
	}

	return r;
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	56                   	push   %esi
  801b76:	53                   	push   %ebx
  801b77:	83 ec 10             	sub    $0x10,%esp
  801b7a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	8b 40 0c             	mov    0xc(%eax),%eax
  801b83:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b88:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	b8 03 00 00 00       	mov    $0x3,%eax
  801b98:	e8 86 fe ff ff       	call   801a23 <fsipc>
  801b9d:	89 c3                	mov    %eax,%ebx
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 6a                	js     801c0d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ba3:	39 c6                	cmp    %eax,%esi
  801ba5:	73 24                	jae    801bcb <devfile_read+0x59>
  801ba7:	c7 44 24 0c 7c 31 80 	movl   $0x80317c,0xc(%esp)
  801bae:	00 
  801baf:	c7 44 24 08 83 31 80 	movl   $0x803183,0x8(%esp)
  801bb6:	00 
  801bb7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801bbe:	00 
  801bbf:	c7 04 24 98 31 80 00 	movl   $0x803198,(%esp)
  801bc6:	e8 2b 0b 00 00       	call   8026f6 <_panic>
	assert(r <= PGSIZE);
  801bcb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bd0:	7e 24                	jle    801bf6 <devfile_read+0x84>
  801bd2:	c7 44 24 0c a3 31 80 	movl   $0x8031a3,0xc(%esp)
  801bd9:	00 
  801bda:	c7 44 24 08 83 31 80 	movl   $0x803183,0x8(%esp)
  801be1:	00 
  801be2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801be9:	00 
  801bea:	c7 04 24 98 31 80 00 	movl   $0x803198,(%esp)
  801bf1:	e8 00 0b 00 00       	call   8026f6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bf6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bfa:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c01:	00 
  801c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c05:	89 04 24             	mov    %eax,(%esp)
  801c08:	e8 87 ed ff ff       	call   800994 <memmove>
	return r;
}
  801c0d:	89 d8                	mov    %ebx,%eax
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    

00801c16 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 24             	sub    $0x24,%esp
  801c1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c20:	89 1c 24             	mov    %ebx,(%esp)
  801c23:	e8 98 eb ff ff       	call   8007c0 <strlen>
  801c28:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c2d:	7f 60                	jg     801c8f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c32:	89 04 24             	mov    %eax,(%esp)
  801c35:	e8 2d f8 ff ff       	call   801467 <fd_alloc>
  801c3a:	89 c2                	mov    %eax,%edx
  801c3c:	85 d2                	test   %edx,%edx
  801c3e:	78 54                	js     801c94 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c40:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c44:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c4b:	e8 a7 eb ff ff       	call   8007f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c53:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c60:	e8 be fd ff ff       	call   801a23 <fsipc>
  801c65:	89 c3                	mov    %eax,%ebx
  801c67:	85 c0                	test   %eax,%eax
  801c69:	79 17                	jns    801c82 <open+0x6c>
		fd_close(fd, 0);
  801c6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c72:	00 
  801c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c76:	89 04 24             	mov    %eax,(%esp)
  801c79:	e8 e8 f8 ff ff       	call   801566 <fd_close>
		return r;
  801c7e:	89 d8                	mov    %ebx,%eax
  801c80:	eb 12                	jmp    801c94 <open+0x7e>
	}

	return fd2num(fd);
  801c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c85:	89 04 24             	mov    %eax,(%esp)
  801c88:	e8 b3 f7 ff ff       	call   801440 <fd2num>
  801c8d:	eb 05                	jmp    801c94 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c8f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c94:	83 c4 24             	add    $0x24,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    

00801c9a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ca0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca5:	b8 08 00 00 00       	mov    $0x8,%eax
  801caa:	e8 74 fd ff ff       	call   801a23 <fsipc>
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    
  801cb1:	66 90                	xchg   %ax,%ax
  801cb3:	66 90                	xchg   %ax,%ax
  801cb5:	66 90                	xchg   %ax,%ax
  801cb7:	66 90                	xchg   %ax,%ax
  801cb9:	66 90                	xchg   %ax,%ax
  801cbb:	66 90                	xchg   %ax,%ax
  801cbd:	66 90                	xchg   %ax,%ax
  801cbf:	90                   	nop

00801cc0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801cc6:	c7 44 24 04 af 31 80 	movl   $0x8031af,0x4(%esp)
  801ccd:	00 
  801cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd1:	89 04 24             	mov    %eax,(%esp)
  801cd4:	e8 1e eb ff ff       	call   8007f7 <strcpy>
	return 0;
}
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 14             	sub    $0x14,%esp
  801ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cea:	89 1c 24             	mov    %ebx,(%esp)
  801ced:	e8 0c 0c 00 00       	call   8028fe <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801cf2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801cf7:	83 f8 01             	cmp    $0x1,%eax
  801cfa:	75 0d                	jne    801d09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801cfc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	e8 29 03 00 00       	call   802030 <nsipc_close>
  801d07:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d09:	89 d0                	mov    %edx,%eax
  801d0b:	83 c4 14             	add    $0x14,%esp
  801d0e:	5b                   	pop    %ebx
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    

00801d11 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d1e:	00 
  801d1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	8b 40 0c             	mov    0xc(%eax),%eax
  801d33:	89 04 24             	mov    %eax,(%esp)
  801d36:	e8 f0 03 00 00       	call   80212b <nsipc_send>
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d4a:	00 
  801d4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5f:	89 04 24             	mov    %eax,(%esp)
  801d62:	e8 44 03 00 00       	call   8020ab <nsipc_recv>
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d72:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d76:	89 04 24             	mov    %eax,(%esp)
  801d79:	e8 38 f7 ff ff       	call   8014b6 <fd_lookup>
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	78 17                	js     801d99 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d8b:	39 08                	cmp    %ecx,(%eax)
  801d8d:	75 05                	jne    801d94 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d92:	eb 05                	jmp    801d99 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	83 ec 20             	sub    $0x20,%esp
  801da3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801da5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da8:	89 04 24             	mov    %eax,(%esp)
  801dab:	e8 b7 f6 ff ff       	call   801467 <fd_alloc>
  801db0:	89 c3                	mov    %eax,%ebx
  801db2:	85 c0                	test   %eax,%eax
  801db4:	78 21                	js     801dd7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801db6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801dbd:	00 
  801dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dcc:	e8 42 ee ff ff       	call   800c13 <sys_page_alloc>
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	79 0c                	jns    801de3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801dd7:	89 34 24             	mov    %esi,(%esp)
  801dda:	e8 51 02 00 00       	call   802030 <nsipc_close>
		return r;
  801ddf:	89 d8                	mov    %ebx,%eax
  801de1:	eb 20                	jmp    801e03 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801de3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801df8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801dfb:	89 14 24             	mov    %edx,(%esp)
  801dfe:	e8 3d f6 ff ff       	call   801440 <fd2num>
}
  801e03:	83 c4 20             	add    $0x20,%esp
  801e06:	5b                   	pop    %ebx
  801e07:	5e                   	pop    %esi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    

00801e0a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	e8 51 ff ff ff       	call   801d69 <fd2sockid>
		return r;
  801e18:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 23                	js     801e41 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e1e:	8b 55 10             	mov    0x10(%ebp),%edx
  801e21:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e28:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e2c:	89 04 24             	mov    %eax,(%esp)
  801e2f:	e8 45 01 00 00       	call   801f79 <nsipc_accept>
		return r;
  801e34:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 07                	js     801e41 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e3a:	e8 5c ff ff ff       	call   801d9b <alloc_sockfd>
  801e3f:	89 c1                	mov    %eax,%ecx
}
  801e41:	89 c8                	mov    %ecx,%eax
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	e8 16 ff ff ff       	call   801d69 <fd2sockid>
  801e53:	89 c2                	mov    %eax,%edx
  801e55:	85 d2                	test   %edx,%edx
  801e57:	78 16                	js     801e6f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e59:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e67:	89 14 24             	mov    %edx,(%esp)
  801e6a:	e8 60 01 00 00       	call   801fcf <nsipc_bind>
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <shutdown>:

int
shutdown(int s, int how)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	e8 ea fe ff ff       	call   801d69 <fd2sockid>
  801e7f:	89 c2                	mov    %eax,%edx
  801e81:	85 d2                	test   %edx,%edx
  801e83:	78 0f                	js     801e94 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8c:	89 14 24             	mov    %edx,(%esp)
  801e8f:	e8 7a 01 00 00       	call   80200e <nsipc_shutdown>
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	e8 c5 fe ff ff       	call   801d69 <fd2sockid>
  801ea4:	89 c2                	mov    %eax,%edx
  801ea6:	85 d2                	test   %edx,%edx
  801ea8:	78 16                	js     801ec0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ead:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb8:	89 14 24             	mov    %edx,(%esp)
  801ebb:	e8 8a 01 00 00       	call   80204a <nsipc_connect>
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <listen>:

int
listen(int s, int backlog)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	e8 99 fe ff ff       	call   801d69 <fd2sockid>
  801ed0:	89 c2                	mov    %eax,%edx
  801ed2:	85 d2                	test   %edx,%edx
  801ed4:	78 0f                	js     801ee5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edd:	89 14 24             	mov    %edx,(%esp)
  801ee0:	e8 a4 01 00 00       	call   802089 <nsipc_listen>
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801eed:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	89 04 24             	mov    %eax,(%esp)
  801f01:	e8 98 02 00 00       	call   80219e <nsipc_socket>
  801f06:	89 c2                	mov    %eax,%edx
  801f08:	85 d2                	test   %edx,%edx
  801f0a:	78 05                	js     801f11 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f0c:	e8 8a fe ff ff       	call   801d9b <alloc_sockfd>
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	53                   	push   %ebx
  801f17:	83 ec 14             	sub    $0x14,%esp
  801f1a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f1c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f23:	75 11                	jne    801f36 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f25:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f2c:	e8 8e 09 00 00       	call   8028bf <ipc_find_env>
  801f31:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f3d:	00 
  801f3e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801f45:	00 
  801f46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f4a:	a1 04 50 80 00       	mov    0x805004,%eax
  801f4f:	89 04 24             	mov    %eax,(%esp)
  801f52:	e8 fd 08 00 00       	call   802854 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f5e:	00 
  801f5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f66:	00 
  801f67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f6e:	e8 8d 08 00 00       	call   802800 <ipc_recv>
}
  801f73:	83 c4 14             	add    $0x14,%esp
  801f76:	5b                   	pop    %ebx
  801f77:	5d                   	pop    %ebp
  801f78:	c3                   	ret    

00801f79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 10             	sub    $0x10,%esp
  801f81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f8c:	8b 06                	mov    (%esi),%eax
  801f8e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f93:	b8 01 00 00 00       	mov    $0x1,%eax
  801f98:	e8 76 ff ff ff       	call   801f13 <nsipc>
  801f9d:	89 c3                	mov    %eax,%ebx
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	78 23                	js     801fc6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fa3:	a1 10 70 80 00       	mov    0x807010,%eax
  801fa8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fac:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801fb3:	00 
  801fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb7:	89 04 24             	mov    %eax,(%esp)
  801fba:	e8 d5 e9 ff ff       	call   800994 <memmove>
		*addrlen = ret->ret_addrlen;
  801fbf:	a1 10 70 80 00       	mov    0x807010,%eax
  801fc4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801fc6:	89 d8                	mov    %ebx,%eax
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 14             	sub    $0x14,%esp
  801fd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fe1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fec:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801ff3:	e8 9c e9 ff ff       	call   800994 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ff8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801ffe:	b8 02 00 00 00       	mov    $0x2,%eax
  802003:	e8 0b ff ff ff       	call   801f13 <nsipc>
}
  802008:	83 c4 14             	add    $0x14,%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    

0080200e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80201c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802024:	b8 03 00 00 00       	mov    $0x3,%eax
  802029:	e8 e5 fe ff ff       	call   801f13 <nsipc>
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <nsipc_close>:

int
nsipc_close(int s)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80203e:	b8 04 00 00 00       	mov    $0x4,%eax
  802043:	e8 cb fe ff ff       	call   801f13 <nsipc>
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	53                   	push   %ebx
  80204e:	83 ec 14             	sub    $0x14,%esp
  802051:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80205c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802060:	8b 45 0c             	mov    0xc(%ebp),%eax
  802063:	89 44 24 04          	mov    %eax,0x4(%esp)
  802067:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80206e:	e8 21 e9 ff ff       	call   800994 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802073:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802079:	b8 05 00 00 00       	mov    $0x5,%eax
  80207e:	e8 90 fe ff ff       	call   801f13 <nsipc>
}
  802083:	83 c4 14             	add    $0x14,%esp
  802086:	5b                   	pop    %ebx
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    

00802089 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80209f:	b8 06 00 00 00       	mov    $0x6,%eax
  8020a4:	e8 6a fe ff ff       	call   801f13 <nsipc>
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	56                   	push   %esi
  8020af:	53                   	push   %ebx
  8020b0:	83 ec 10             	sub    $0x10,%esp
  8020b3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020be:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020cc:	b8 07 00 00 00       	mov    $0x7,%eax
  8020d1:	e8 3d fe ff ff       	call   801f13 <nsipc>
  8020d6:	89 c3                	mov    %eax,%ebx
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 46                	js     802122 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8020dc:	39 f0                	cmp    %esi,%eax
  8020de:	7f 07                	jg     8020e7 <nsipc_recv+0x3c>
  8020e0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020e5:	7e 24                	jle    80210b <nsipc_recv+0x60>
  8020e7:	c7 44 24 0c bb 31 80 	movl   $0x8031bb,0xc(%esp)
  8020ee:	00 
  8020ef:	c7 44 24 08 83 31 80 	movl   $0x803183,0x8(%esp)
  8020f6:	00 
  8020f7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8020fe:	00 
  8020ff:	c7 04 24 d0 31 80 00 	movl   $0x8031d0,(%esp)
  802106:	e8 eb 05 00 00       	call   8026f6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80210b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80210f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802116:	00 
  802117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211a:	89 04 24             	mov    %eax,(%esp)
  80211d:	e8 72 e8 ff ff       	call   800994 <memmove>
	}

	return r;
}
  802122:	89 d8                	mov    %ebx,%eax
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    

0080212b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	53                   	push   %ebx
  80212f:	83 ec 14             	sub    $0x14,%esp
  802132:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80213d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802143:	7e 24                	jle    802169 <nsipc_send+0x3e>
  802145:	c7 44 24 0c dc 31 80 	movl   $0x8031dc,0xc(%esp)
  80214c:	00 
  80214d:	c7 44 24 08 83 31 80 	movl   $0x803183,0x8(%esp)
  802154:	00 
  802155:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80215c:	00 
  80215d:	c7 04 24 d0 31 80 00 	movl   $0x8031d0,(%esp)
  802164:	e8 8d 05 00 00       	call   8026f6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802169:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80216d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802170:	89 44 24 04          	mov    %eax,0x4(%esp)
  802174:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80217b:	e8 14 e8 ff ff       	call   800994 <memmove>
	nsipcbuf.send.req_size = size;
  802180:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802186:	8b 45 14             	mov    0x14(%ebp),%eax
  802189:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80218e:	b8 08 00 00 00       	mov    $0x8,%eax
  802193:	e8 7b fd ff ff       	call   801f13 <nsipc>
}
  802198:	83 c4 14             	add    $0x14,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    

0080219e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021af:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8021c1:	e8 4d fd ff ff       	call   801f13 <nsipc>
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	56                   	push   %esi
  8021cc:	53                   	push   %ebx
  8021cd:	83 ec 10             	sub    $0x10,%esp
  8021d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	89 04 24             	mov    %eax,(%esp)
  8021d9:	e8 72 f2 ff ff       	call   801450 <fd2data>
  8021de:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021e0:	c7 44 24 04 e8 31 80 	movl   $0x8031e8,0x4(%esp)
  8021e7:	00 
  8021e8:	89 1c 24             	mov    %ebx,(%esp)
  8021eb:	e8 07 e6 ff ff       	call   8007f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021f0:	8b 46 04             	mov    0x4(%esi),%eax
  8021f3:	2b 06                	sub    (%esi),%eax
  8021f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802202:	00 00 00 
	stat->st_dev = &devpipe;
  802205:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80220c:	40 80 00 
	return 0;
}
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5d                   	pop    %ebp
  80221a:	c3                   	ret    

0080221b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	53                   	push   %ebx
  80221f:	83 ec 14             	sub    $0x14,%esp
  802222:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802225:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802229:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802230:	e8 85 ea ff ff       	call   800cba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802235:	89 1c 24             	mov    %ebx,(%esp)
  802238:	e8 13 f2 ff ff       	call   801450 <fd2data>
  80223d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802248:	e8 6d ea ff ff       	call   800cba <sys_page_unmap>
}
  80224d:	83 c4 14             	add    $0x14,%esp
  802250:	5b                   	pop    %ebx
  802251:	5d                   	pop    %ebp
  802252:	c3                   	ret    

00802253 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	57                   	push   %edi
  802257:	56                   	push   %esi
  802258:	53                   	push   %ebx
  802259:	83 ec 2c             	sub    $0x2c,%esp
  80225c:	89 c6                	mov    %eax,%esi
  80225e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802261:	a1 08 50 80 00       	mov    0x805008,%eax
  802266:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802269:	89 34 24             	mov    %esi,(%esp)
  80226c:	e8 8d 06 00 00       	call   8028fe <pageref>
  802271:	89 c7                	mov    %eax,%edi
  802273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802276:	89 04 24             	mov    %eax,(%esp)
  802279:	e8 80 06 00 00       	call   8028fe <pageref>
  80227e:	39 c7                	cmp    %eax,%edi
  802280:	0f 94 c2             	sete   %dl
  802283:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802286:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80228c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80228f:	39 fb                	cmp    %edi,%ebx
  802291:	74 21                	je     8022b4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802293:	84 d2                	test   %dl,%dl
  802295:	74 ca                	je     802261 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802297:	8b 51 58             	mov    0x58(%ecx),%edx
  80229a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80229e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022a6:	c7 04 24 ef 31 80 00 	movl   $0x8031ef,(%esp)
  8022ad:	e8 15 df ff ff       	call   8001c7 <cprintf>
  8022b2:	eb ad                	jmp    802261 <_pipeisclosed+0xe>
	}
}
  8022b4:	83 c4 2c             	add    $0x2c,%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	5f                   	pop    %edi
  8022ba:	5d                   	pop    %ebp
  8022bb:	c3                   	ret    

008022bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	57                   	push   %edi
  8022c0:	56                   	push   %esi
  8022c1:	53                   	push   %ebx
  8022c2:	83 ec 1c             	sub    $0x1c,%esp
  8022c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022c8:	89 34 24             	mov    %esi,(%esp)
  8022cb:	e8 80 f1 ff ff       	call   801450 <fd2data>
  8022d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d7:	eb 45                	jmp    80231e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022d9:	89 da                	mov    %ebx,%edx
  8022db:	89 f0                	mov    %esi,%eax
  8022dd:	e8 71 ff ff ff       	call   802253 <_pipeisclosed>
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	75 41                	jne    802327 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022e6:	e8 09 e9 ff ff       	call   800bf4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8022ee:	8b 0b                	mov    (%ebx),%ecx
  8022f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8022f3:	39 d0                	cmp    %edx,%eax
  8022f5:	73 e2                	jae    8022d9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802301:	99                   	cltd   
  802302:	c1 ea 1b             	shr    $0x1b,%edx
  802305:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802308:	83 e1 1f             	and    $0x1f,%ecx
  80230b:	29 d1                	sub    %edx,%ecx
  80230d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802311:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802315:	83 c0 01             	add    $0x1,%eax
  802318:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80231b:	83 c7 01             	add    $0x1,%edi
  80231e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802321:	75 c8                	jne    8022eb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802323:	89 f8                	mov    %edi,%eax
  802325:	eb 05                	jmp    80232c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80232c:	83 c4 1c             	add    $0x1c,%esp
  80232f:	5b                   	pop    %ebx
  802330:	5e                   	pop    %esi
  802331:	5f                   	pop    %edi
  802332:	5d                   	pop    %ebp
  802333:	c3                   	ret    

00802334 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	57                   	push   %edi
  802338:	56                   	push   %esi
  802339:	53                   	push   %ebx
  80233a:	83 ec 1c             	sub    $0x1c,%esp
  80233d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802340:	89 3c 24             	mov    %edi,(%esp)
  802343:	e8 08 f1 ff ff       	call   801450 <fd2data>
  802348:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80234a:	be 00 00 00 00       	mov    $0x0,%esi
  80234f:	eb 3d                	jmp    80238e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802351:	85 f6                	test   %esi,%esi
  802353:	74 04                	je     802359 <devpipe_read+0x25>
				return i;
  802355:	89 f0                	mov    %esi,%eax
  802357:	eb 43                	jmp    80239c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802359:	89 da                	mov    %ebx,%edx
  80235b:	89 f8                	mov    %edi,%eax
  80235d:	e8 f1 fe ff ff       	call   802253 <_pipeisclosed>
  802362:	85 c0                	test   %eax,%eax
  802364:	75 31                	jne    802397 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802366:	e8 89 e8 ff ff       	call   800bf4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80236b:	8b 03                	mov    (%ebx),%eax
  80236d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802370:	74 df                	je     802351 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802372:	99                   	cltd   
  802373:	c1 ea 1b             	shr    $0x1b,%edx
  802376:	01 d0                	add    %edx,%eax
  802378:	83 e0 1f             	and    $0x1f,%eax
  80237b:	29 d0                	sub    %edx,%eax
  80237d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802382:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802385:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802388:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80238b:	83 c6 01             	add    $0x1,%esi
  80238e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802391:	75 d8                	jne    80236b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802393:	89 f0                	mov    %esi,%eax
  802395:	eb 05                	jmp    80239c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80239c:	83 c4 1c             	add    $0x1c,%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5f                   	pop    %edi
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	56                   	push   %esi
  8023a8:	53                   	push   %ebx
  8023a9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023af:	89 04 24             	mov    %eax,(%esp)
  8023b2:	e8 b0 f0 ff ff       	call   801467 <fd_alloc>
  8023b7:	89 c2                	mov    %eax,%edx
  8023b9:	85 d2                	test   %edx,%edx
  8023bb:	0f 88 4d 01 00 00    	js     80250e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023c8:	00 
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d7:	e8 37 e8 ff ff       	call   800c13 <sys_page_alloc>
  8023dc:	89 c2                	mov    %eax,%edx
  8023de:	85 d2                	test   %edx,%edx
  8023e0:	0f 88 28 01 00 00    	js     80250e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023e9:	89 04 24             	mov    %eax,(%esp)
  8023ec:	e8 76 f0 ff ff       	call   801467 <fd_alloc>
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	0f 88 fe 00 00 00    	js     8024f9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802402:	00 
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802411:	e8 fd e7 ff ff       	call   800c13 <sys_page_alloc>
  802416:	89 c3                	mov    %eax,%ebx
  802418:	85 c0                	test   %eax,%eax
  80241a:	0f 88 d9 00 00 00    	js     8024f9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	89 04 24             	mov    %eax,(%esp)
  802426:	e8 25 f0 ff ff       	call   801450 <fd2data>
  80242b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802434:	00 
  802435:	89 44 24 04          	mov    %eax,0x4(%esp)
  802439:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802440:	e8 ce e7 ff ff       	call   800c13 <sys_page_alloc>
  802445:	89 c3                	mov    %eax,%ebx
  802447:	85 c0                	test   %eax,%eax
  802449:	0f 88 97 00 00 00    	js     8024e6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	89 04 24             	mov    %eax,(%esp)
  802455:	e8 f6 ef ff ff       	call   801450 <fd2data>
  80245a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802461:	00 
  802462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802466:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80246d:	00 
  80246e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802472:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802479:	e8 e9 e7 ff ff       	call   800c67 <sys_page_map>
  80247e:	89 c3                	mov    %eax,%ebx
  802480:	85 c0                	test   %eax,%eax
  802482:	78 52                	js     8024d6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802484:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802499:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80249f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	89 04 24             	mov    %eax,(%esp)
  8024b4:	e8 87 ef ff ff       	call   801440 <fd2num>
  8024b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c1:	89 04 24             	mov    %eax,(%esp)
  8024c4:	e8 77 ef ff ff       	call   801440 <fd2num>
  8024c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	eb 38                	jmp    80250e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8024d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e1:	e8 d4 e7 ff ff       	call   800cba <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024f4:	e8 c1 e7 ff ff       	call   800cba <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802500:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802507:	e8 ae e7 ff ff       	call   800cba <sys_page_unmap>
  80250c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80250e:	83 c4 30             	add    $0x30,%esp
  802511:	5b                   	pop    %ebx
  802512:	5e                   	pop    %esi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    

00802515 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80251b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	89 04 24             	mov    %eax,(%esp)
  802528:	e8 89 ef ff ff       	call   8014b6 <fd_lookup>
  80252d:	89 c2                	mov    %eax,%edx
  80252f:	85 d2                	test   %edx,%edx
  802531:	78 15                	js     802548 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	89 04 24             	mov    %eax,(%esp)
  802539:	e8 12 ef ff ff       	call   801450 <fd2data>
	return _pipeisclosed(fd, p);
  80253e:	89 c2                	mov    %eax,%edx
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	e8 0b fd ff ff       	call   802253 <_pipeisclosed>
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	5d                   	pop    %ebp
  802559:	c3                   	ret    

0080255a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802560:	c7 44 24 04 07 32 80 	movl   $0x803207,0x4(%esp)
  802567:	00 
  802568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256b:	89 04 24             	mov    %eax,(%esp)
  80256e:	e8 84 e2 ff ff       	call   8007f7 <strcpy>
	return 0;
}
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	57                   	push   %edi
  80257e:	56                   	push   %esi
  80257f:	53                   	push   %ebx
  802580:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802586:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80258b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802591:	eb 31                	jmp    8025c4 <devcons_write+0x4a>
		m = n - tot;
  802593:	8b 75 10             	mov    0x10(%ebp),%esi
  802596:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802598:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80259b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8025a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8025a7:	03 45 0c             	add    0xc(%ebp),%eax
  8025aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ae:	89 3c 24             	mov    %edi,(%esp)
  8025b1:	e8 de e3 ff ff       	call   800994 <memmove>
		sys_cputs(buf, m);
  8025b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025ba:	89 3c 24             	mov    %edi,(%esp)
  8025bd:	e8 84 e5 ff ff       	call   800b46 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025c2:	01 f3                	add    %esi,%ebx
  8025c4:	89 d8                	mov    %ebx,%eax
  8025c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8025c9:	72 c8                	jb     802593 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    

008025d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8025dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8025e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025e5:	75 07                	jne    8025ee <devcons_read+0x18>
  8025e7:	eb 2a                	jmp    802613 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025e9:	e8 06 e6 ff ff       	call   800bf4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025ee:	66 90                	xchg   %ax,%ax
  8025f0:	e8 6f e5 ff ff       	call   800b64 <sys_cgetc>
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	74 f0                	je     8025e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	78 16                	js     802613 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8025fd:	83 f8 04             	cmp    $0x4,%eax
  802600:	74 0c                	je     80260e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802602:	8b 55 0c             	mov    0xc(%ebp),%edx
  802605:	88 02                	mov    %al,(%edx)
	return 1;
  802607:	b8 01 00 00 00       	mov    $0x1,%eax
  80260c:	eb 05                	jmp    802613 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802621:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802628:	00 
  802629:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80262c:	89 04 24             	mov    %eax,(%esp)
  80262f:	e8 12 e5 ff ff       	call   800b46 <sys_cputs>
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <getchar>:

int
getchar(void)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80263c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802643:	00 
  802644:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802647:	89 44 24 04          	mov    %eax,0x4(%esp)
  80264b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802652:	e8 f3 f0 ff ff       	call   80174a <read>
	if (r < 0)
  802657:	85 c0                	test   %eax,%eax
  802659:	78 0f                	js     80266a <getchar+0x34>
		return r;
	if (r < 1)
  80265b:	85 c0                	test   %eax,%eax
  80265d:	7e 06                	jle    802665 <getchar+0x2f>
		return -E_EOF;
	return c;
  80265f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802663:	eb 05                	jmp    80266a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802665:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802672:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802675:	89 44 24 04          	mov    %eax,0x4(%esp)
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	89 04 24             	mov    %eax,(%esp)
  80267f:	e8 32 ee ff ff       	call   8014b6 <fd_lookup>
  802684:	85 c0                	test   %eax,%eax
  802686:	78 11                	js     802699 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802691:	39 10                	cmp    %edx,(%eax)
  802693:	0f 94 c0             	sete   %al
  802696:	0f b6 c0             	movzbl %al,%eax
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <opencons>:

int
opencons(void)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8026a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026a4:	89 04 24             	mov    %eax,(%esp)
  8026a7:	e8 bb ed ff ff       	call   801467 <fd_alloc>
		return r;
  8026ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	78 40                	js     8026f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026b9:	00 
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c8:	e8 46 e5 ff ff       	call   800c13 <sys_page_alloc>
		return r;
  8026cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	78 1f                	js     8026f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8026d3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026e8:	89 04 24             	mov    %eax,(%esp)
  8026eb:	e8 50 ed ff ff       	call   801440 <fd2num>
  8026f0:	89 c2                	mov    %eax,%edx
}
  8026f2:	89 d0                	mov    %edx,%eax
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	56                   	push   %esi
  8026fa:	53                   	push   %ebx
  8026fb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8026fe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802701:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802707:	e8 c9 e4 ff ff       	call   800bd5 <sys_getenvid>
  80270c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802713:	8b 55 08             	mov    0x8(%ebp),%edx
  802716:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80271a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80271e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802722:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  802729:	e8 99 da ff ff       	call   8001c7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80272e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802732:	8b 45 10             	mov    0x10(%ebp),%eax
  802735:	89 04 24             	mov    %eax,(%esp)
  802738:	e8 29 da ff ff       	call   800166 <vcprintf>
	cprintf("\n");
  80273d:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  802744:	e8 7e da ff ff       	call   8001c7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802749:	cc                   	int3   
  80274a:	eb fd                	jmp    802749 <_panic+0x53>

0080274c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
  80274f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802752:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802759:	75 70                	jne    8027cb <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  80275b:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  802762:	00 
  802763:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80276a:	ee 
  80276b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802772:	e8 9c e4 ff ff       	call   800c13 <sys_page_alloc>
		if (error < 0)
  802777:	85 c0                	test   %eax,%eax
  802779:	79 1c                	jns    802797 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  80277b:	c7 44 24 08 38 32 80 	movl   $0x803238,0x8(%esp)
  802782:	00 
  802783:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80278a:	00 
  80278b:	c7 04 24 8b 32 80 00 	movl   $0x80328b,(%esp)
  802792:	e8 5f ff ff ff       	call   8026f6 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802797:	c7 44 24 04 d5 27 80 	movl   $0x8027d5,0x4(%esp)
  80279e:	00 
  80279f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a6:	e8 08 e6 ff ff       	call   800db3 <sys_env_set_pgfault_upcall>
		if (error < 0)
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	79 1c                	jns    8027cb <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  8027af:	c7 44 24 08 60 32 80 	movl   $0x803260,0x8(%esp)
  8027b6:	00 
  8027b7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8027be:	00 
  8027bf:	c7 04 24 8b 32 80 00 	movl   $0x80328b,(%esp)
  8027c6:	e8 2b ff ff ff       	call   8026f6 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027d5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027d6:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027db:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027dd:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  8027e0:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  8027e4:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  8027e9:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  8027ed:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  8027ef:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8027f2:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8027f3:	83 c4 04             	add    $0x4,%esp
	popfl
  8027f6:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027f7:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8027f8:	c3                   	ret    
  8027f9:	66 90                	xchg   %ax,%ax
  8027fb:	66 90                	xchg   %ax,%ax
  8027fd:	66 90                	xchg   %ax,%ax
  8027ff:	90                   	nop

00802800 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	56                   	push   %esi
  802804:	53                   	push   %ebx
  802805:	83 ec 10             	sub    $0x10,%esp
  802808:	8b 75 08             	mov    0x8(%ebp),%esi
  80280b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802811:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802813:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802818:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80281b:	89 04 24             	mov    %eax,(%esp)
  80281e:	e8 06 e6 ff ff       	call   800e29 <sys_ipc_recv>
  802823:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802825:	85 d2                	test   %edx,%edx
  802827:	75 24                	jne    80284d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802829:	85 f6                	test   %esi,%esi
  80282b:	74 0a                	je     802837 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80282d:	a1 08 50 80 00       	mov    0x805008,%eax
  802832:	8b 40 74             	mov    0x74(%eax),%eax
  802835:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802837:	85 db                	test   %ebx,%ebx
  802839:	74 0a                	je     802845 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80283b:	a1 08 50 80 00       	mov    0x805008,%eax
  802840:	8b 40 78             	mov    0x78(%eax),%eax
  802843:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802845:	a1 08 50 80 00       	mov    0x805008,%eax
  80284a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80284d:	83 c4 10             	add    $0x10,%esp
  802850:	5b                   	pop    %ebx
  802851:	5e                   	pop    %esi
  802852:	5d                   	pop    %ebp
  802853:	c3                   	ret    

00802854 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
  802857:	57                   	push   %edi
  802858:	56                   	push   %esi
  802859:	53                   	push   %ebx
  80285a:	83 ec 1c             	sub    $0x1c,%esp
  80285d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802860:	8b 75 0c             	mov    0xc(%ebp),%esi
  802863:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802866:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802868:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80286d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802870:	8b 45 14             	mov    0x14(%ebp),%eax
  802873:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802877:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80287b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80287f:	89 3c 24             	mov    %edi,(%esp)
  802882:	e8 7f e5 ff ff       	call   800e06 <sys_ipc_try_send>

		if (ret == 0)
  802887:	85 c0                	test   %eax,%eax
  802889:	74 2c                	je     8028b7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80288b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80288e:	74 20                	je     8028b0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802890:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802894:	c7 44 24 08 9c 32 80 	movl   $0x80329c,0x8(%esp)
  80289b:	00 
  80289c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8028a3:	00 
  8028a4:	c7 04 24 cc 32 80 00 	movl   $0x8032cc,(%esp)
  8028ab:	e8 46 fe ff ff       	call   8026f6 <_panic>
		}

		sys_yield();
  8028b0:	e8 3f e3 ff ff       	call   800bf4 <sys_yield>
	}
  8028b5:	eb b9                	jmp    802870 <ipc_send+0x1c>
}
  8028b7:	83 c4 1c             	add    $0x1c,%esp
  8028ba:	5b                   	pop    %ebx
  8028bb:	5e                   	pop    %esi
  8028bc:	5f                   	pop    %edi
  8028bd:	5d                   	pop    %ebp
  8028be:	c3                   	ret    

008028bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028ca:	89 c2                	mov    %eax,%edx
  8028cc:	c1 e2 07             	shl    $0x7,%edx
  8028cf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8028d6:	8b 52 50             	mov    0x50(%edx),%edx
  8028d9:	39 ca                	cmp    %ecx,%edx
  8028db:	75 11                	jne    8028ee <ipc_find_env+0x2f>
			return envs[i].env_id;
  8028dd:	89 c2                	mov    %eax,%edx
  8028df:	c1 e2 07             	shl    $0x7,%edx
  8028e2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8028e9:	8b 40 40             	mov    0x40(%eax),%eax
  8028ec:	eb 0e                	jmp    8028fc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028ee:	83 c0 01             	add    $0x1,%eax
  8028f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028f6:	75 d2                	jne    8028ca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8028f8:	66 b8 00 00          	mov    $0x0,%ax
}
  8028fc:	5d                   	pop    %ebp
  8028fd:	c3                   	ret    

008028fe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
  802901:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802904:	89 d0                	mov    %edx,%eax
  802906:	c1 e8 16             	shr    $0x16,%eax
  802909:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802910:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802915:	f6 c1 01             	test   $0x1,%cl
  802918:	74 1d                	je     802937 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80291a:	c1 ea 0c             	shr    $0xc,%edx
  80291d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802924:	f6 c2 01             	test   $0x1,%dl
  802927:	74 0e                	je     802937 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802929:	c1 ea 0c             	shr    $0xc,%edx
  80292c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802933:	ef 
  802934:	0f b7 c0             	movzwl %ax,%eax
}
  802937:	5d                   	pop    %ebp
  802938:	c3                   	ret    
  802939:	66 90                	xchg   %ax,%ax
  80293b:	66 90                	xchg   %ax,%ax
  80293d:	66 90                	xchg   %ax,%ax
  80293f:	90                   	nop

00802940 <__udivdi3>:
  802940:	55                   	push   %ebp
  802941:	57                   	push   %edi
  802942:	56                   	push   %esi
  802943:	83 ec 0c             	sub    $0xc,%esp
  802946:	8b 44 24 28          	mov    0x28(%esp),%eax
  80294a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80294e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802952:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802956:	85 c0                	test   %eax,%eax
  802958:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80295c:	89 ea                	mov    %ebp,%edx
  80295e:	89 0c 24             	mov    %ecx,(%esp)
  802961:	75 2d                	jne    802990 <__udivdi3+0x50>
  802963:	39 e9                	cmp    %ebp,%ecx
  802965:	77 61                	ja     8029c8 <__udivdi3+0x88>
  802967:	85 c9                	test   %ecx,%ecx
  802969:	89 ce                	mov    %ecx,%esi
  80296b:	75 0b                	jne    802978 <__udivdi3+0x38>
  80296d:	b8 01 00 00 00       	mov    $0x1,%eax
  802972:	31 d2                	xor    %edx,%edx
  802974:	f7 f1                	div    %ecx
  802976:	89 c6                	mov    %eax,%esi
  802978:	31 d2                	xor    %edx,%edx
  80297a:	89 e8                	mov    %ebp,%eax
  80297c:	f7 f6                	div    %esi
  80297e:	89 c5                	mov    %eax,%ebp
  802980:	89 f8                	mov    %edi,%eax
  802982:	f7 f6                	div    %esi
  802984:	89 ea                	mov    %ebp,%edx
  802986:	83 c4 0c             	add    $0xc,%esp
  802989:	5e                   	pop    %esi
  80298a:	5f                   	pop    %edi
  80298b:	5d                   	pop    %ebp
  80298c:	c3                   	ret    
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	39 e8                	cmp    %ebp,%eax
  802992:	77 24                	ja     8029b8 <__udivdi3+0x78>
  802994:	0f bd e8             	bsr    %eax,%ebp
  802997:	83 f5 1f             	xor    $0x1f,%ebp
  80299a:	75 3c                	jne    8029d8 <__udivdi3+0x98>
  80299c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029a0:	39 34 24             	cmp    %esi,(%esp)
  8029a3:	0f 86 9f 00 00 00    	jbe    802a48 <__udivdi3+0x108>
  8029a9:	39 d0                	cmp    %edx,%eax
  8029ab:	0f 82 97 00 00 00    	jb     802a48 <__udivdi3+0x108>
  8029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	31 d2                	xor    %edx,%edx
  8029ba:	31 c0                	xor    %eax,%eax
  8029bc:	83 c4 0c             	add    $0xc,%esp
  8029bf:	5e                   	pop    %esi
  8029c0:	5f                   	pop    %edi
  8029c1:	5d                   	pop    %ebp
  8029c2:	c3                   	ret    
  8029c3:	90                   	nop
  8029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	89 f8                	mov    %edi,%eax
  8029ca:	f7 f1                	div    %ecx
  8029cc:	31 d2                	xor    %edx,%edx
  8029ce:	83 c4 0c             	add    $0xc,%esp
  8029d1:	5e                   	pop    %esi
  8029d2:	5f                   	pop    %edi
  8029d3:	5d                   	pop    %ebp
  8029d4:	c3                   	ret    
  8029d5:	8d 76 00             	lea    0x0(%esi),%esi
  8029d8:	89 e9                	mov    %ebp,%ecx
  8029da:	8b 3c 24             	mov    (%esp),%edi
  8029dd:	d3 e0                	shl    %cl,%eax
  8029df:	89 c6                	mov    %eax,%esi
  8029e1:	b8 20 00 00 00       	mov    $0x20,%eax
  8029e6:	29 e8                	sub    %ebp,%eax
  8029e8:	89 c1                	mov    %eax,%ecx
  8029ea:	d3 ef                	shr    %cl,%edi
  8029ec:	89 e9                	mov    %ebp,%ecx
  8029ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029f2:	8b 3c 24             	mov    (%esp),%edi
  8029f5:	09 74 24 08          	or     %esi,0x8(%esp)
  8029f9:	89 d6                	mov    %edx,%esi
  8029fb:	d3 e7                	shl    %cl,%edi
  8029fd:	89 c1                	mov    %eax,%ecx
  8029ff:	89 3c 24             	mov    %edi,(%esp)
  802a02:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a06:	d3 ee                	shr    %cl,%esi
  802a08:	89 e9                	mov    %ebp,%ecx
  802a0a:	d3 e2                	shl    %cl,%edx
  802a0c:	89 c1                	mov    %eax,%ecx
  802a0e:	d3 ef                	shr    %cl,%edi
  802a10:	09 d7                	or     %edx,%edi
  802a12:	89 f2                	mov    %esi,%edx
  802a14:	89 f8                	mov    %edi,%eax
  802a16:	f7 74 24 08          	divl   0x8(%esp)
  802a1a:	89 d6                	mov    %edx,%esi
  802a1c:	89 c7                	mov    %eax,%edi
  802a1e:	f7 24 24             	mull   (%esp)
  802a21:	39 d6                	cmp    %edx,%esi
  802a23:	89 14 24             	mov    %edx,(%esp)
  802a26:	72 30                	jb     802a58 <__udivdi3+0x118>
  802a28:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a2c:	89 e9                	mov    %ebp,%ecx
  802a2e:	d3 e2                	shl    %cl,%edx
  802a30:	39 c2                	cmp    %eax,%edx
  802a32:	73 05                	jae    802a39 <__udivdi3+0xf9>
  802a34:	3b 34 24             	cmp    (%esp),%esi
  802a37:	74 1f                	je     802a58 <__udivdi3+0x118>
  802a39:	89 f8                	mov    %edi,%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	e9 7a ff ff ff       	jmp    8029bc <__udivdi3+0x7c>
  802a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a48:	31 d2                	xor    %edx,%edx
  802a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4f:	e9 68 ff ff ff       	jmp    8029bc <__udivdi3+0x7c>
  802a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a58:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	83 c4 0c             	add    $0xc,%esp
  802a60:	5e                   	pop    %esi
  802a61:	5f                   	pop    %edi
  802a62:	5d                   	pop    %ebp
  802a63:	c3                   	ret    
  802a64:	66 90                	xchg   %ax,%ax
  802a66:	66 90                	xchg   %ax,%ax
  802a68:	66 90                	xchg   %ax,%ax
  802a6a:	66 90                	xchg   %ax,%ax
  802a6c:	66 90                	xchg   %ax,%ax
  802a6e:	66 90                	xchg   %ax,%ax

00802a70 <__umoddi3>:
  802a70:	55                   	push   %ebp
  802a71:	57                   	push   %edi
  802a72:	56                   	push   %esi
  802a73:	83 ec 14             	sub    $0x14,%esp
  802a76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a7a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a7e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a82:	89 c7                	mov    %eax,%edi
  802a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a88:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a8c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a90:	89 34 24             	mov    %esi,(%esp)
  802a93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a97:	85 c0                	test   %eax,%eax
  802a99:	89 c2                	mov    %eax,%edx
  802a9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a9f:	75 17                	jne    802ab8 <__umoddi3+0x48>
  802aa1:	39 fe                	cmp    %edi,%esi
  802aa3:	76 4b                	jbe    802af0 <__umoddi3+0x80>
  802aa5:	89 c8                	mov    %ecx,%eax
  802aa7:	89 fa                	mov    %edi,%edx
  802aa9:	f7 f6                	div    %esi
  802aab:	89 d0                	mov    %edx,%eax
  802aad:	31 d2                	xor    %edx,%edx
  802aaf:	83 c4 14             	add    $0x14,%esp
  802ab2:	5e                   	pop    %esi
  802ab3:	5f                   	pop    %edi
  802ab4:	5d                   	pop    %ebp
  802ab5:	c3                   	ret    
  802ab6:	66 90                	xchg   %ax,%ax
  802ab8:	39 f8                	cmp    %edi,%eax
  802aba:	77 54                	ja     802b10 <__umoddi3+0xa0>
  802abc:	0f bd e8             	bsr    %eax,%ebp
  802abf:	83 f5 1f             	xor    $0x1f,%ebp
  802ac2:	75 5c                	jne    802b20 <__umoddi3+0xb0>
  802ac4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ac8:	39 3c 24             	cmp    %edi,(%esp)
  802acb:	0f 87 e7 00 00 00    	ja     802bb8 <__umoddi3+0x148>
  802ad1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ad5:	29 f1                	sub    %esi,%ecx
  802ad7:	19 c7                	sbb    %eax,%edi
  802ad9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802add:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ae1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ae5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ae9:	83 c4 14             	add    $0x14,%esp
  802aec:	5e                   	pop    %esi
  802aed:	5f                   	pop    %edi
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    
  802af0:	85 f6                	test   %esi,%esi
  802af2:	89 f5                	mov    %esi,%ebp
  802af4:	75 0b                	jne    802b01 <__umoddi3+0x91>
  802af6:	b8 01 00 00 00       	mov    $0x1,%eax
  802afb:	31 d2                	xor    %edx,%edx
  802afd:	f7 f6                	div    %esi
  802aff:	89 c5                	mov    %eax,%ebp
  802b01:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b05:	31 d2                	xor    %edx,%edx
  802b07:	f7 f5                	div    %ebp
  802b09:	89 c8                	mov    %ecx,%eax
  802b0b:	f7 f5                	div    %ebp
  802b0d:	eb 9c                	jmp    802aab <__umoddi3+0x3b>
  802b0f:	90                   	nop
  802b10:	89 c8                	mov    %ecx,%eax
  802b12:	89 fa                	mov    %edi,%edx
  802b14:	83 c4 14             	add    $0x14,%esp
  802b17:	5e                   	pop    %esi
  802b18:	5f                   	pop    %edi
  802b19:	5d                   	pop    %ebp
  802b1a:	c3                   	ret    
  802b1b:	90                   	nop
  802b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b20:	8b 04 24             	mov    (%esp),%eax
  802b23:	be 20 00 00 00       	mov    $0x20,%esi
  802b28:	89 e9                	mov    %ebp,%ecx
  802b2a:	29 ee                	sub    %ebp,%esi
  802b2c:	d3 e2                	shl    %cl,%edx
  802b2e:	89 f1                	mov    %esi,%ecx
  802b30:	d3 e8                	shr    %cl,%eax
  802b32:	89 e9                	mov    %ebp,%ecx
  802b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b38:	8b 04 24             	mov    (%esp),%eax
  802b3b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b3f:	89 fa                	mov    %edi,%edx
  802b41:	d3 e0                	shl    %cl,%eax
  802b43:	89 f1                	mov    %esi,%ecx
  802b45:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b49:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b4d:	d3 ea                	shr    %cl,%edx
  802b4f:	89 e9                	mov    %ebp,%ecx
  802b51:	d3 e7                	shl    %cl,%edi
  802b53:	89 f1                	mov    %esi,%ecx
  802b55:	d3 e8                	shr    %cl,%eax
  802b57:	89 e9                	mov    %ebp,%ecx
  802b59:	09 f8                	or     %edi,%eax
  802b5b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b5f:	f7 74 24 04          	divl   0x4(%esp)
  802b63:	d3 e7                	shl    %cl,%edi
  802b65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b69:	89 d7                	mov    %edx,%edi
  802b6b:	f7 64 24 08          	mull   0x8(%esp)
  802b6f:	39 d7                	cmp    %edx,%edi
  802b71:	89 c1                	mov    %eax,%ecx
  802b73:	89 14 24             	mov    %edx,(%esp)
  802b76:	72 2c                	jb     802ba4 <__umoddi3+0x134>
  802b78:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b7c:	72 22                	jb     802ba0 <__umoddi3+0x130>
  802b7e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b82:	29 c8                	sub    %ecx,%eax
  802b84:	19 d7                	sbb    %edx,%edi
  802b86:	89 e9                	mov    %ebp,%ecx
  802b88:	89 fa                	mov    %edi,%edx
  802b8a:	d3 e8                	shr    %cl,%eax
  802b8c:	89 f1                	mov    %esi,%ecx
  802b8e:	d3 e2                	shl    %cl,%edx
  802b90:	89 e9                	mov    %ebp,%ecx
  802b92:	d3 ef                	shr    %cl,%edi
  802b94:	09 d0                	or     %edx,%eax
  802b96:	89 fa                	mov    %edi,%edx
  802b98:	83 c4 14             	add    $0x14,%esp
  802b9b:	5e                   	pop    %esi
  802b9c:	5f                   	pop    %edi
  802b9d:	5d                   	pop    %ebp
  802b9e:	c3                   	ret    
  802b9f:	90                   	nop
  802ba0:	39 d7                	cmp    %edx,%edi
  802ba2:	75 da                	jne    802b7e <__umoddi3+0x10e>
  802ba4:	8b 14 24             	mov    (%esp),%edx
  802ba7:	89 c1                	mov    %eax,%ecx
  802ba9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802bb1:	eb cb                	jmp    802b7e <__umoddi3+0x10e>
  802bb3:	90                   	nop
  802bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802bbc:	0f 82 0f ff ff ff    	jb     802ad1 <__umoddi3+0x61>
  802bc2:	e9 1a ff ff ff       	jmp    802ae1 <__umoddi3+0x71>
