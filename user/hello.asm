
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2e 00 00 00       	call   80005f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("hello, world\n");
  800039:	c7 04 24 c0 26 80 00 	movl   $0x8026c0,(%esp)
  800040:	e8 22 01 00 00       	call   800167 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800045:	a1 08 40 80 00       	mov    0x804008,%eax
  80004a:	8b 40 48             	mov    0x48(%eax),%eax
  80004d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800051:	c7 04 24 ce 26 80 00 	movl   $0x8026ce,(%esp)
  800058:	e8 0a 01 00 00       	call   800167 <cprintf>
}
  80005d:	c9                   	leave  
  80005e:	c3                   	ret    

0080005f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	83 ec 10             	sub    $0x10,%esp
  800067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  80006d:	e8 03 0b 00 00       	call   800b75 <sys_getenvid>
  800072:	25 ff 03 00 00       	and    $0x3ff,%eax
  800077:	89 c2                	mov    %eax,%edx
  800079:	c1 e2 07             	shl    $0x7,%edx
  80007c:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800083:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800088:	85 db                	test   %ebx,%ebx
  80008a:	7e 07                	jle    800093 <libmain+0x34>
		binaryname = argv[0];
  80008c:	8b 06                	mov    (%esi),%eax
  80008e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800093:	89 74 24 04          	mov    %esi,0x4(%esp)
  800097:	89 1c 24             	mov    %ebx,(%esp)
  80009a:	e8 94 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009f:	e8 07 00 00 00       	call   8000ab <exit>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000b1:	e8 04 11 00 00       	call   8011ba <close_all>
	sys_env_destroy(0);
  8000b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000bd:	e8 61 0a 00 00       	call   800b23 <sys_env_destroy>
}
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	53                   	push   %ebx
  8000c8:	83 ec 14             	sub    $0x14,%esp
  8000cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ce:	8b 13                	mov    (%ebx),%edx
  8000d0:	8d 42 01             	lea    0x1(%edx),%eax
  8000d3:	89 03                	mov    %eax,(%ebx)
  8000d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e1:	75 19                	jne    8000fc <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000e3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000ea:	00 
  8000eb:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ee:	89 04 24             	mov    %eax,(%esp)
  8000f1:	e8 f0 09 00 00       	call   800ae6 <sys_cputs>
		b->idx = 0;
  8000f6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8000fc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800100:	83 c4 14             	add    $0x14,%esp
  800103:	5b                   	pop    %ebx
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    

00800106 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80010f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800116:	00 00 00 
	b.cnt = 0;
  800119:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800120:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800123:	8b 45 0c             	mov    0xc(%ebp),%eax
  800126:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80012a:	8b 45 08             	mov    0x8(%ebp),%eax
  80012d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800131:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800137:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013b:	c7 04 24 c4 00 80 00 	movl   $0x8000c4,(%esp)
  800142:	e8 b7 01 00 00       	call   8002fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800147:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80014d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800151:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800157:	89 04 24             	mov    %eax,(%esp)
  80015a:	e8 87 09 00 00       	call   800ae6 <sys_cputs>

	return b.cnt;
}
  80015f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80016d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800170:	89 44 24 04          	mov    %eax,0x4(%esp)
  800174:	8b 45 08             	mov    0x8(%ebp),%eax
  800177:	89 04 24             	mov    %eax,(%esp)
  80017a:	e8 87 ff ff ff       	call   800106 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    
  800181:	66 90                	xchg   %ax,%ax
  800183:	66 90                	xchg   %ax,%ax
  800185:	66 90                	xchg   %ax,%ax
  800187:	66 90                	xchg   %ax,%ax
  800189:	66 90                	xchg   %ax,%ax
  80018b:	66 90                	xchg   %ax,%ax
  80018d:	66 90                	xchg   %ax,%ax
  80018f:	90                   	nop

00800190 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 3c             	sub    $0x3c,%esp
  800199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80019c:	89 d7                	mov    %edx,%edi
  80019e:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a7:	89 c3                	mov    %eax,%ebx
  8001a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8001af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001bd:	39 d9                	cmp    %ebx,%ecx
  8001bf:	72 05                	jb     8001c6 <printnum+0x36>
  8001c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001c4:	77 69                	ja     80022f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001cd:	83 ee 01             	sub    $0x1,%esi
  8001d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8001e0:	89 c3                	mov    %eax,%ebx
  8001e2:	89 d6                	mov    %edx,%esi
  8001e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8001f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001f5:	89 04 24             	mov    %eax,(%esp)
  8001f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ff:	e8 2c 22 00 00       	call   802430 <__udivdi3>
  800204:	89 d9                	mov    %ebx,%ecx
  800206:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80020a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	89 54 24 04          	mov    %edx,0x4(%esp)
  800215:	89 fa                	mov    %edi,%edx
  800217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80021a:	e8 71 ff ff ff       	call   800190 <printnum>
  80021f:	eb 1b                	jmp    80023c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800221:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800225:	8b 45 18             	mov    0x18(%ebp),%eax
  800228:	89 04 24             	mov    %eax,(%esp)
  80022b:	ff d3                	call   *%ebx
  80022d:	eb 03                	jmp    800232 <printnum+0xa2>
  80022f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800232:	83 ee 01             	sub    $0x1,%esi
  800235:	85 f6                	test   %esi,%esi
  800237:	7f e8                	jg     800221 <printnum+0x91>
  800239:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800240:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800244:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800247:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80024a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80024e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025f:	e8 fc 22 00 00       	call   802560 <__umoddi3>
  800264:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800268:	0f be 80 ef 26 80 00 	movsbl 0x8026ef(%eax),%eax
  80026f:	89 04 24             	mov    %eax,(%esp)
  800272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800275:	ff d0                	call   *%eax
}
  800277:	83 c4 3c             	add    $0x3c,%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5e                   	pop    %esi
  80027c:	5f                   	pop    %edi
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    

0080027f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800282:	83 fa 01             	cmp    $0x1,%edx
  800285:	7e 0e                	jle    800295 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800287:	8b 10                	mov    (%eax),%edx
  800289:	8d 4a 08             	lea    0x8(%edx),%ecx
  80028c:	89 08                	mov    %ecx,(%eax)
  80028e:	8b 02                	mov    (%edx),%eax
  800290:	8b 52 04             	mov    0x4(%edx),%edx
  800293:	eb 22                	jmp    8002b7 <getuint+0x38>
	else if (lflag)
  800295:	85 d2                	test   %edx,%edx
  800297:	74 10                	je     8002a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800299:	8b 10                	mov    (%eax),%edx
  80029b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029e:	89 08                	mov    %ecx,(%eax)
  8002a0:	8b 02                	mov    (%edx),%eax
  8002a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a7:	eb 0e                	jmp    8002b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002a9:	8b 10                	mov    (%eax),%edx
  8002ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ae:	89 08                	mov    %ecx,(%eax)
  8002b0:	8b 02                	mov    (%edx),%eax
  8002b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    

008002b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c3:	8b 10                	mov    (%eax),%edx
  8002c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c8:	73 0a                	jae    8002d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cd:	89 08                	mov    %ecx,(%eax)
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	88 02                	mov    %al,(%edx)
}
  8002d4:	5d                   	pop    %ebp
  8002d5:	c3                   	ret    

008002d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f4:	89 04 24             	mov    %eax,(%esp)
  8002f7:	e8 02 00 00 00       	call   8002fe <vprintfmt>
	va_end(ap);
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	57                   	push   %edi
  800302:	56                   	push   %esi
  800303:	53                   	push   %ebx
  800304:	83 ec 3c             	sub    $0x3c,%esp
  800307:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80030a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80030d:	eb 14                	jmp    800323 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80030f:	85 c0                	test   %eax,%eax
  800311:	0f 84 b3 03 00 00    	je     8006ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800317:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80031b:	89 04 24             	mov    %eax,(%esp)
  80031e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800321:	89 f3                	mov    %esi,%ebx
  800323:	8d 73 01             	lea    0x1(%ebx),%esi
  800326:	0f b6 03             	movzbl (%ebx),%eax
  800329:	83 f8 25             	cmp    $0x25,%eax
  80032c:	75 e1                	jne    80030f <vprintfmt+0x11>
  80032e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800332:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800339:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800340:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800347:	ba 00 00 00 00       	mov    $0x0,%edx
  80034c:	eb 1d                	jmp    80036b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800350:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800354:	eb 15                	jmp    80036b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800356:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800358:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80035c:	eb 0d                	jmp    80036b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80035e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800361:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800364:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80036e:	0f b6 0e             	movzbl (%esi),%ecx
  800371:	0f b6 c1             	movzbl %cl,%eax
  800374:	83 e9 23             	sub    $0x23,%ecx
  800377:	80 f9 55             	cmp    $0x55,%cl
  80037a:	0f 87 2a 03 00 00    	ja     8006aa <vprintfmt+0x3ac>
  800380:	0f b6 c9             	movzbl %cl,%ecx
  800383:	ff 24 8d 60 28 80 00 	jmp    *0x802860(,%ecx,4)
  80038a:	89 de                	mov    %ebx,%esi
  80038c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800391:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800394:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800398:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80039b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80039e:	83 fb 09             	cmp    $0x9,%ebx
  8003a1:	77 36                	ja     8003d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003a6:	eb e9                	jmp    800391 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8003ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003b8:	eb 22                	jmp    8003dc <vprintfmt+0xde>
  8003ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003bd:	85 c9                	test   %ecx,%ecx
  8003bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c4:	0f 49 c1             	cmovns %ecx,%eax
  8003c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	89 de                	mov    %ebx,%esi
  8003cc:	eb 9d                	jmp    80036b <vprintfmt+0x6d>
  8003ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8003d7:	eb 92                	jmp    80036b <vprintfmt+0x6d>
  8003d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8003dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8003e0:	79 89                	jns    80036b <vprintfmt+0x6d>
  8003e2:	e9 77 ff ff ff       	jmp    80035e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003ec:	e9 7a ff ff ff       	jmp    80036b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8d 50 04             	lea    0x4(%eax),%edx
  8003f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8003fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003fe:	8b 00                	mov    (%eax),%eax
  800400:	89 04 24             	mov    %eax,(%esp)
  800403:	ff 55 08             	call   *0x8(%ebp)
			break;
  800406:	e9 18 ff ff ff       	jmp    800323 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80040b:	8b 45 14             	mov    0x14(%ebp),%eax
  80040e:	8d 50 04             	lea    0x4(%eax),%edx
  800411:	89 55 14             	mov    %edx,0x14(%ebp)
  800414:	8b 00                	mov    (%eax),%eax
  800416:	99                   	cltd   
  800417:	31 d0                	xor    %edx,%eax
  800419:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041b:	83 f8 12             	cmp    $0x12,%eax
  80041e:	7f 0b                	jg     80042b <vprintfmt+0x12d>
  800420:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  800427:	85 d2                	test   %edx,%edx
  800429:	75 20                	jne    80044b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80042b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80042f:	c7 44 24 08 07 27 80 	movl   $0x802707,0x8(%esp)
  800436:	00 
  800437:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	89 04 24             	mov    %eax,(%esp)
  800441:	e8 90 fe ff ff       	call   8002d6 <printfmt>
  800446:	e9 d8 fe ff ff       	jmp    800323 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80044b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80044f:	c7 44 24 08 01 2b 80 	movl   $0x802b01,0x8(%esp)
  800456:	00 
  800457:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	89 04 24             	mov    %eax,(%esp)
  800461:	e8 70 fe ff ff       	call   8002d6 <printfmt>
  800466:	e9 b8 fe ff ff       	jmp    800323 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80046e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800471:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 50 04             	lea    0x4(%eax),%edx
  80047a:	89 55 14             	mov    %edx,0x14(%ebp)
  80047d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80047f:	85 f6                	test   %esi,%esi
  800481:	b8 00 27 80 00       	mov    $0x802700,%eax
  800486:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800489:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80048d:	0f 84 97 00 00 00    	je     80052a <vprintfmt+0x22c>
  800493:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800497:	0f 8e 9b 00 00 00    	jle    800538 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004a1:	89 34 24             	mov    %esi,(%esp)
  8004a4:	e8 cf 02 00 00       	call   800778 <strnlen>
  8004a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004ac:	29 c2                	sub    %eax,%edx
  8004ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c3:	eb 0f                	jmp    8004d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004cc:	89 04 24             	mov    %eax,(%esp)
  8004cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d1:	83 eb 01             	sub    $0x1,%ebx
  8004d4:	85 db                	test   %ebx,%ebx
  8004d6:	7f ed                	jg     8004c5 <vprintfmt+0x1c7>
  8004d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004de:	85 d2                	test   %edx,%edx
  8004e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e5:	0f 49 c2             	cmovns %edx,%eax
  8004e8:	29 c2                	sub    %eax,%edx
  8004ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8004ed:	89 d7                	mov    %edx,%edi
  8004ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004f2:	eb 50                	jmp    800544 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f8:	74 1e                	je     800518 <vprintfmt+0x21a>
  8004fa:	0f be d2             	movsbl %dl,%edx
  8004fd:	83 ea 20             	sub    $0x20,%edx
  800500:	83 fa 5e             	cmp    $0x5e,%edx
  800503:	76 13                	jbe    800518 <vprintfmt+0x21a>
					putch('?', putdat);
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800513:	ff 55 08             	call   *0x8(%ebp)
  800516:	eb 0d                	jmp    800525 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800525:	83 ef 01             	sub    $0x1,%edi
  800528:	eb 1a                	jmp    800544 <vprintfmt+0x246>
  80052a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80052d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800530:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800533:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800536:	eb 0c                	jmp    800544 <vprintfmt+0x246>
  800538:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80053b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80053e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800541:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800544:	83 c6 01             	add    $0x1,%esi
  800547:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80054b:	0f be c2             	movsbl %dl,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	74 27                	je     800579 <vprintfmt+0x27b>
  800552:	85 db                	test   %ebx,%ebx
  800554:	78 9e                	js     8004f4 <vprintfmt+0x1f6>
  800556:	83 eb 01             	sub    $0x1,%ebx
  800559:	79 99                	jns    8004f4 <vprintfmt+0x1f6>
  80055b:	89 f8                	mov    %edi,%eax
  80055d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800560:	8b 75 08             	mov    0x8(%ebp),%esi
  800563:	89 c3                	mov    %eax,%ebx
  800565:	eb 1a                	jmp    800581 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800567:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800572:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800574:	83 eb 01             	sub    $0x1,%ebx
  800577:	eb 08                	jmp    800581 <vprintfmt+0x283>
  800579:	89 fb                	mov    %edi,%ebx
  80057b:	8b 75 08             	mov    0x8(%ebp),%esi
  80057e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800581:	85 db                	test   %ebx,%ebx
  800583:	7f e2                	jg     800567 <vprintfmt+0x269>
  800585:	89 75 08             	mov    %esi,0x8(%ebp)
  800588:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80058b:	e9 93 fd ff ff       	jmp    800323 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800590:	83 fa 01             	cmp    $0x1,%edx
  800593:	7e 16                	jle    8005ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 50 08             	lea    0x8(%eax),%edx
  80059b:	89 55 14             	mov    %edx,0x14(%ebp)
  80059e:	8b 50 04             	mov    0x4(%eax),%edx
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005a9:	eb 32                	jmp    8005dd <vprintfmt+0x2df>
	else if (lflag)
  8005ab:	85 d2                	test   %edx,%edx
  8005ad:	74 18                	je     8005c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 50 04             	lea    0x4(%eax),%edx
  8005b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b8:	8b 30                	mov    (%eax),%esi
  8005ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005bd:	89 f0                	mov    %esi,%eax
  8005bf:	c1 f8 1f             	sar    $0x1f,%eax
  8005c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c5:	eb 16                	jmp    8005dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d0:	8b 30                	mov    (%eax),%esi
  8005d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005d5:	89 f0                	mov    %esi,%eax
  8005d7:	c1 f8 1f             	sar    $0x1f,%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ec:	0f 89 80 00 00 00    	jns    800672 <vprintfmt+0x374>
				putch('-', putdat);
  8005f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800603:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800606:	f7 d8                	neg    %eax
  800608:	83 d2 00             	adc    $0x0,%edx
  80060b:	f7 da                	neg    %edx
			}
			base = 10;
  80060d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800612:	eb 5e                	jmp    800672 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800614:	8d 45 14             	lea    0x14(%ebp),%eax
  800617:	e8 63 fc ff ff       	call   80027f <getuint>
			base = 10;
  80061c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800621:	eb 4f                	jmp    800672 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800623:	8d 45 14             	lea    0x14(%ebp),%eax
  800626:	e8 54 fc ff ff       	call   80027f <getuint>
			base = 8;
  80062b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800630:	eb 40                	jmp    800672 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800632:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800636:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80063d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800640:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800644:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80064b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 50 04             	lea    0x4(%eax),%edx
  800654:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800657:	8b 00                	mov    (%eax),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80065e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800663:	eb 0d                	jmp    800672 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800665:	8d 45 14             	lea    0x14(%ebp),%eax
  800668:	e8 12 fc ff ff       	call   80027f <getuint>
			base = 16;
  80066d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800672:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800676:	89 74 24 10          	mov    %esi,0x10(%esp)
  80067a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80067d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800681:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800685:	89 04 24             	mov    %eax,(%esp)
  800688:	89 54 24 04          	mov    %edx,0x4(%esp)
  80068c:	89 fa                	mov    %edi,%edx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	e8 fa fa ff ff       	call   800190 <printnum>
			break;
  800696:	e9 88 fc ff ff       	jmp    800323 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80069b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80069f:	89 04 24             	mov    %eax,(%esp)
  8006a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006a5:	e9 79 fc ff ff       	jmp    800323 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006b8:	89 f3                	mov    %esi,%ebx
  8006ba:	eb 03                	jmp    8006bf <vprintfmt+0x3c1>
  8006bc:	83 eb 01             	sub    $0x1,%ebx
  8006bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006c3:	75 f7                	jne    8006bc <vprintfmt+0x3be>
  8006c5:	e9 59 fc ff ff       	jmp    800323 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006ca:	83 c4 3c             	add    $0x3c,%esp
  8006cd:	5b                   	pop    %ebx
  8006ce:	5e                   	pop    %esi
  8006cf:	5f                   	pop    %edi
  8006d0:	5d                   	pop    %ebp
  8006d1:	c3                   	ret    

008006d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 28             	sub    $0x28,%esp
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006ef:	85 c0                	test   %eax,%eax
  8006f1:	74 30                	je     800723 <vsnprintf+0x51>
  8006f3:	85 d2                	test   %edx,%edx
  8006f5:	7e 2c                	jle    800723 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800701:	89 44 24 08          	mov    %eax,0x8(%esp)
  800705:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070c:	c7 04 24 b9 02 80 00 	movl   $0x8002b9,(%esp)
  800713:	e8 e6 fb ff ff       	call   8002fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80071e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800721:	eb 05                	jmp    800728 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800723:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800730:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800733:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800737:	8b 45 10             	mov    0x10(%ebp),%eax
  80073a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	89 44 24 04          	mov    %eax,0x4(%esp)
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	89 04 24             	mov    %eax,(%esp)
  80074b:	e8 82 ff ff ff       	call   8006d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800750:	c9                   	leave  
  800751:	c3                   	ret    
  800752:	66 90                	xchg   %ax,%ax
  800754:	66 90                	xchg   %ax,%ax
  800756:	66 90                	xchg   %ax,%ax
  800758:	66 90                	xchg   %ax,%ax
  80075a:	66 90                	xchg   %ax,%ax
  80075c:	66 90                	xchg   %ax,%ax
  80075e:	66 90                	xchg   %ax,%ax

00800760 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800766:	b8 00 00 00 00       	mov    $0x0,%eax
  80076b:	eb 03                	jmp    800770 <strlen+0x10>
		n++;
  80076d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800770:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800774:	75 f7                	jne    80076d <strlen+0xd>
		n++;
	return n;
}
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800781:	b8 00 00 00 00       	mov    $0x0,%eax
  800786:	eb 03                	jmp    80078b <strnlen+0x13>
		n++;
  800788:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078b:	39 d0                	cmp    %edx,%eax
  80078d:	74 06                	je     800795 <strnlen+0x1d>
  80078f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800793:	75 f3                	jne    800788 <strnlen+0x10>
		n++;
	return n;
}
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	53                   	push   %ebx
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	83 c2 01             	add    $0x1,%edx
  8007a6:	83 c1 01             	add    $0x1,%ecx
  8007a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007b0:	84 db                	test   %bl,%bl
  8007b2:	75 ef                	jne    8007a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007b4:	5b                   	pop    %ebx
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	53                   	push   %ebx
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c1:	89 1c 24             	mov    %ebx,(%esp)
  8007c4:	e8 97 ff ff ff       	call   800760 <strlen>
	strcpy(dst + len, src);
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007d0:	01 d8                	add    %ebx,%eax
  8007d2:	89 04 24             	mov    %eax,(%esp)
  8007d5:	e8 bd ff ff ff       	call   800797 <strcpy>
	return dst;
}
  8007da:	89 d8                	mov    %ebx,%eax
  8007dc:	83 c4 08             	add    $0x8,%esp
  8007df:	5b                   	pop    %ebx
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	56                   	push   %esi
  8007e6:	53                   	push   %ebx
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ed:	89 f3                	mov    %esi,%ebx
  8007ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f2:	89 f2                	mov    %esi,%edx
  8007f4:	eb 0f                	jmp    800805 <strncpy+0x23>
		*dst++ = *src;
  8007f6:	83 c2 01             	add    $0x1,%edx
  8007f9:	0f b6 01             	movzbl (%ecx),%eax
  8007fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800802:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800805:	39 da                	cmp    %ebx,%edx
  800807:	75 ed                	jne    8007f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800809:	89 f0                	mov    %esi,%eax
  80080b:	5b                   	pop    %ebx
  80080c:	5e                   	pop    %esi
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	56                   	push   %esi
  800813:	53                   	push   %ebx
  800814:	8b 75 08             	mov    0x8(%ebp),%esi
  800817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80081d:	89 f0                	mov    %esi,%eax
  80081f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800823:	85 c9                	test   %ecx,%ecx
  800825:	75 0b                	jne    800832 <strlcpy+0x23>
  800827:	eb 1d                	jmp    800846 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800829:	83 c0 01             	add    $0x1,%eax
  80082c:	83 c2 01             	add    $0x1,%edx
  80082f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800832:	39 d8                	cmp    %ebx,%eax
  800834:	74 0b                	je     800841 <strlcpy+0x32>
  800836:	0f b6 0a             	movzbl (%edx),%ecx
  800839:	84 c9                	test   %cl,%cl
  80083b:	75 ec                	jne    800829 <strlcpy+0x1a>
  80083d:	89 c2                	mov    %eax,%edx
  80083f:	eb 02                	jmp    800843 <strlcpy+0x34>
  800841:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800843:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800846:	29 f0                	sub    %esi,%eax
}
  800848:	5b                   	pop    %ebx
  800849:	5e                   	pop    %esi
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800852:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800855:	eb 06                	jmp    80085d <strcmp+0x11>
		p++, q++;
  800857:	83 c1 01             	add    $0x1,%ecx
  80085a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80085d:	0f b6 01             	movzbl (%ecx),%eax
  800860:	84 c0                	test   %al,%al
  800862:	74 04                	je     800868 <strcmp+0x1c>
  800864:	3a 02                	cmp    (%edx),%al
  800866:	74 ef                	je     800857 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800868:	0f b6 c0             	movzbl %al,%eax
  80086b:	0f b6 12             	movzbl (%edx),%edx
  80086e:	29 d0                	sub    %edx,%eax
}
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087c:	89 c3                	mov    %eax,%ebx
  80087e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800881:	eb 06                	jmp    800889 <strncmp+0x17>
		n--, p++, q++;
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800889:	39 d8                	cmp    %ebx,%eax
  80088b:	74 15                	je     8008a2 <strncmp+0x30>
  80088d:	0f b6 08             	movzbl (%eax),%ecx
  800890:	84 c9                	test   %cl,%cl
  800892:	74 04                	je     800898 <strncmp+0x26>
  800894:	3a 0a                	cmp    (%edx),%cl
  800896:	74 eb                	je     800883 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800898:	0f b6 00             	movzbl (%eax),%eax
  80089b:	0f b6 12             	movzbl (%edx),%edx
  80089e:	29 d0                	sub    %edx,%eax
  8008a0:	eb 05                	jmp    8008a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b4:	eb 07                	jmp    8008bd <strchr+0x13>
		if (*s == c)
  8008b6:	38 ca                	cmp    %cl,%dl
  8008b8:	74 0f                	je     8008c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008ba:	83 c0 01             	add    $0x1,%eax
  8008bd:	0f b6 10             	movzbl (%eax),%edx
  8008c0:	84 d2                	test   %dl,%dl
  8008c2:	75 f2                	jne    8008b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d5:	eb 07                	jmp    8008de <strfind+0x13>
		if (*s == c)
  8008d7:	38 ca                	cmp    %cl,%dl
  8008d9:	74 0a                	je     8008e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008db:	83 c0 01             	add    $0x1,%eax
  8008de:	0f b6 10             	movzbl (%eax),%edx
  8008e1:	84 d2                	test   %dl,%dl
  8008e3:	75 f2                	jne    8008d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	57                   	push   %edi
  8008eb:	56                   	push   %esi
  8008ec:	53                   	push   %ebx
  8008ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	74 36                	je     80092d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008fd:	75 28                	jne    800927 <memset+0x40>
  8008ff:	f6 c1 03             	test   $0x3,%cl
  800902:	75 23                	jne    800927 <memset+0x40>
		c &= 0xFF;
  800904:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800908:	89 d3                	mov    %edx,%ebx
  80090a:	c1 e3 08             	shl    $0x8,%ebx
  80090d:	89 d6                	mov    %edx,%esi
  80090f:	c1 e6 18             	shl    $0x18,%esi
  800912:	89 d0                	mov    %edx,%eax
  800914:	c1 e0 10             	shl    $0x10,%eax
  800917:	09 f0                	or     %esi,%eax
  800919:	09 c2                	or     %eax,%edx
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80091f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800922:	fc                   	cld    
  800923:	f3 ab                	rep stos %eax,%es:(%edi)
  800925:	eb 06                	jmp    80092d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092a:	fc                   	cld    
  80092b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80092d:	89 f8                	mov    %edi,%eax
  80092f:	5b                   	pop    %ebx
  800930:	5e                   	pop    %esi
  800931:	5f                   	pop    %edi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	57                   	push   %edi
  800938:	56                   	push   %esi
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80093f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800942:	39 c6                	cmp    %eax,%esi
  800944:	73 35                	jae    80097b <memmove+0x47>
  800946:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800949:	39 d0                	cmp    %edx,%eax
  80094b:	73 2e                	jae    80097b <memmove+0x47>
		s += n;
		d += n;
  80094d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800950:	89 d6                	mov    %edx,%esi
  800952:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800954:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80095a:	75 13                	jne    80096f <memmove+0x3b>
  80095c:	f6 c1 03             	test   $0x3,%cl
  80095f:	75 0e                	jne    80096f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800961:	83 ef 04             	sub    $0x4,%edi
  800964:	8d 72 fc             	lea    -0x4(%edx),%esi
  800967:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80096a:	fd                   	std    
  80096b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096d:	eb 09                	jmp    800978 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80096f:	83 ef 01             	sub    $0x1,%edi
  800972:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800975:	fd                   	std    
  800976:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800978:	fc                   	cld    
  800979:	eb 1d                	jmp    800998 <memmove+0x64>
  80097b:	89 f2                	mov    %esi,%edx
  80097d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097f:	f6 c2 03             	test   $0x3,%dl
  800982:	75 0f                	jne    800993 <memmove+0x5f>
  800984:	f6 c1 03             	test   $0x3,%cl
  800987:	75 0a                	jne    800993 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800989:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80098c:	89 c7                	mov    %eax,%edi
  80098e:	fc                   	cld    
  80098f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800991:	eb 05                	jmp    800998 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800993:	89 c7                	mov    %eax,%edi
  800995:	fc                   	cld    
  800996:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800998:	5e                   	pop    %esi
  800999:	5f                   	pop    %edi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	89 04 24             	mov    %eax,(%esp)
  8009b6:	e8 79 ff ff ff       	call   800934 <memmove>
}
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    

008009bd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c8:	89 d6                	mov    %edx,%esi
  8009ca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009cd:	eb 1a                	jmp    8009e9 <memcmp+0x2c>
		if (*s1 != *s2)
  8009cf:	0f b6 02             	movzbl (%edx),%eax
  8009d2:	0f b6 19             	movzbl (%ecx),%ebx
  8009d5:	38 d8                	cmp    %bl,%al
  8009d7:	74 0a                	je     8009e3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009d9:	0f b6 c0             	movzbl %al,%eax
  8009dc:	0f b6 db             	movzbl %bl,%ebx
  8009df:	29 d8                	sub    %ebx,%eax
  8009e1:	eb 0f                	jmp    8009f2 <memcmp+0x35>
		s1++, s2++;
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e9:	39 f2                	cmp    %esi,%edx
  8009eb:	75 e2                	jne    8009cf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ff:	89 c2                	mov    %eax,%edx
  800a01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a04:	eb 07                	jmp    800a0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a06:	38 08                	cmp    %cl,(%eax)
  800a08:	74 07                	je     800a11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	39 d0                	cmp    %edx,%eax
  800a0f:	72 f5                	jb     800a06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	57                   	push   %edi
  800a17:	56                   	push   %esi
  800a18:	53                   	push   %ebx
  800a19:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a1f:	eb 03                	jmp    800a24 <strtol+0x11>
		s++;
  800a21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a24:	0f b6 0a             	movzbl (%edx),%ecx
  800a27:	80 f9 09             	cmp    $0x9,%cl
  800a2a:	74 f5                	je     800a21 <strtol+0xe>
  800a2c:	80 f9 20             	cmp    $0x20,%cl
  800a2f:	74 f0                	je     800a21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a31:	80 f9 2b             	cmp    $0x2b,%cl
  800a34:	75 0a                	jne    800a40 <strtol+0x2d>
		s++;
  800a36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a39:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3e:	eb 11                	jmp    800a51 <strtol+0x3e>
  800a40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a45:	80 f9 2d             	cmp    $0x2d,%cl
  800a48:	75 07                	jne    800a51 <strtol+0x3e>
		s++, neg = 1;
  800a4a:	8d 52 01             	lea    0x1(%edx),%edx
  800a4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a56:	75 15                	jne    800a6d <strtol+0x5a>
  800a58:	80 3a 30             	cmpb   $0x30,(%edx)
  800a5b:	75 10                	jne    800a6d <strtol+0x5a>
  800a5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a61:	75 0a                	jne    800a6d <strtol+0x5a>
		s += 2, base = 16;
  800a63:	83 c2 02             	add    $0x2,%edx
  800a66:	b8 10 00 00 00       	mov    $0x10,%eax
  800a6b:	eb 10                	jmp    800a7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a6d:	85 c0                	test   %eax,%eax
  800a6f:	75 0c                	jne    800a7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a73:	80 3a 30             	cmpb   $0x30,(%edx)
  800a76:	75 05                	jne    800a7d <strtol+0x6a>
		s++, base = 8;
  800a78:	83 c2 01             	add    $0x1,%edx
  800a7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800a7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a85:	0f b6 0a             	movzbl (%edx),%ecx
  800a88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800a8b:	89 f0                	mov    %esi,%eax
  800a8d:	3c 09                	cmp    $0x9,%al
  800a8f:	77 08                	ja     800a99 <strtol+0x86>
			dig = *s - '0';
  800a91:	0f be c9             	movsbl %cl,%ecx
  800a94:	83 e9 30             	sub    $0x30,%ecx
  800a97:	eb 20                	jmp    800ab9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800a99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	3c 19                	cmp    $0x19,%al
  800aa0:	77 08                	ja     800aaa <strtol+0x97>
			dig = *s - 'a' + 10;
  800aa2:	0f be c9             	movsbl %cl,%ecx
  800aa5:	83 e9 57             	sub    $0x57,%ecx
  800aa8:	eb 0f                	jmp    800ab9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800aaa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800aad:	89 f0                	mov    %esi,%eax
  800aaf:	3c 19                	cmp    $0x19,%al
  800ab1:	77 16                	ja     800ac9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ab3:	0f be c9             	movsbl %cl,%ecx
  800ab6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ab9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800abc:	7d 0f                	jge    800acd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800abe:	83 c2 01             	add    $0x1,%edx
  800ac1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ac5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ac7:	eb bc                	jmp    800a85 <strtol+0x72>
  800ac9:	89 d8                	mov    %ebx,%eax
  800acb:	eb 02                	jmp    800acf <strtol+0xbc>
  800acd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800acf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad3:	74 05                	je     800ada <strtol+0xc7>
		*endptr = (char *) s;
  800ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ada:	f7 d8                	neg    %eax
  800adc:	85 ff                	test   %edi,%edi
  800ade:	0f 44 c3             	cmove  %ebx,%eax
}
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5f                   	pop    %edi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	57                   	push   %edi
  800aea:	56                   	push   %esi
  800aeb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
  800af1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	89 c3                	mov    %eax,%ebx
  800af9:	89 c7                	mov    %eax,%edi
  800afb:	89 c6                	mov    %eax,%esi
  800afd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	57                   	push   %edi
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b14:	89 d1                	mov    %edx,%ecx
  800b16:	89 d3                	mov    %edx,%ebx
  800b18:	89 d7                	mov    %edx,%edi
  800b1a:	89 d6                	mov    %edx,%esi
  800b1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b31:	b8 03 00 00 00       	mov    $0x3,%eax
  800b36:	8b 55 08             	mov    0x8(%ebp),%edx
  800b39:	89 cb                	mov    %ecx,%ebx
  800b3b:	89 cf                	mov    %ecx,%edi
  800b3d:	89 ce                	mov    %ecx,%esi
  800b3f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800b41:	85 c0                	test   %eax,%eax
  800b43:	7e 28                	jle    800b6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b50:	00 
  800b51:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800b58:	00 
  800b59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b60:	00 
  800b61:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800b68:	e8 29 17 00 00       	call   802296 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b6d:	83 c4 2c             	add    $0x2c,%esp
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5f                   	pop    %edi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	b8 02 00 00 00       	mov    $0x2,%eax
  800b85:	89 d1                	mov    %edx,%ecx
  800b87:	89 d3                	mov    %edx,%ebx
  800b89:	89 d7                	mov    %edx,%edi
  800b8b:	89 d6                	mov    %edx,%esi
  800b8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <sys_yield>:

void
sys_yield(void)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ba4:	89 d1                	mov    %edx,%ecx
  800ba6:	89 d3                	mov    %edx,%ebx
  800ba8:	89 d7                	mov    %edx,%edi
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbc:	be 00 00 00 00       	mov    $0x0,%esi
  800bc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bcf:	89 f7                	mov    %esi,%edi
  800bd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bd3:	85 c0                	test   %eax,%eax
  800bd5:	7e 28                	jle    800bff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800be2:	00 
  800be3:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800bea:	00 
  800beb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bf2:	00 
  800bf3:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800bfa:	e8 97 16 00 00       	call   802296 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bff:	83 c4 2c             	add    $0x2c,%esp
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c10:	b8 05 00 00 00       	mov    $0x5,%eax
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c21:	8b 75 18             	mov    0x18(%ebp),%esi
  800c24:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	7e 28                	jle    800c52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c35:	00 
  800c36:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800c3d:	00 
  800c3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c45:	00 
  800c46:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800c4d:	e8 44 16 00 00       	call   802296 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c52:	83 c4 2c             	add    $0x2c,%esp
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
  800c60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c68:	b8 06 00 00 00       	mov    $0x6,%eax
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	8b 55 08             	mov    0x8(%ebp),%edx
  800c73:	89 df                	mov    %ebx,%edi
  800c75:	89 de                	mov    %ebx,%esi
  800c77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c79:	85 c0                	test   %eax,%eax
  800c7b:	7e 28                	jle    800ca5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800c88:	00 
  800c89:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800c90:	00 
  800c91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c98:	00 
  800c99:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800ca0:	e8 f1 15 00 00       	call   802296 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca5:	83 c4 2c             	add    $0x2c,%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
  800cb3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	89 df                	mov    %ebx,%edi
  800cc8:	89 de                	mov    %ebx,%esi
  800cca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	7e 28                	jle    800cf8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800cdb:	00 
  800cdc:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800ce3:	00 
  800ce4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ceb:	00 
  800cec:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800cf3:	e8 9e 15 00 00       	call   802296 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf8:	83 c4 2c             	add    $0x2c,%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	89 df                	mov    %ebx,%edi
  800d1b:	89 de                	mov    %ebx,%esi
  800d1d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	7e 28                	jle    800d4b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d27:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d2e:	00 
  800d2f:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800d36:	00 
  800d37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3e:	00 
  800d3f:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800d46:	e8 4b 15 00 00       	call   802296 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d4b:	83 c4 2c             	add    $0x2c,%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	89 df                	mov    %ebx,%edi
  800d6e:	89 de                	mov    %ebx,%esi
  800d70:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7e 28                	jle    800d9e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d81:	00 
  800d82:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800d89:	00 
  800d8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d91:	00 
  800d92:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800d99:	e8 f8 14 00 00       	call   802296 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9e:	83 c4 2c             	add    $0x2c,%esp
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dac:	be 00 00 00 00       	mov    $0x0,%esi
  800db1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	89 cb                	mov    %ecx,%ebx
  800de1:	89 cf                	mov    %ecx,%edi
  800de3:	89 ce                	mov    %ecx,%esi
  800de5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7e 28                	jle    800e13 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800def:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800df6:	00 
  800df7:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800dfe:	00 
  800dff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e06:	00 
  800e07:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800e0e:	e8 83 14 00 00       	call   802296 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e13:	83 c4 2c             	add    $0x2c,%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e21:	ba 00 00 00 00       	mov    $0x0,%edx
  800e26:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e2b:	89 d1                	mov    %edx,%ecx
  800e2d:	89 d3                	mov    %edx,%ebx
  800e2f:	89 d7                	mov    %edx,%edi
  800e31:	89 d6                	mov    %edx,%esi
  800e33:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e48:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	89 df                	mov    %ebx,%edi
  800e55:	89 de                	mov    %ebx,%esi
  800e57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	7e 28                	jle    800e85 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e61:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e68:	00 
  800e69:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800e70:	00 
  800e71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e78:	00 
  800e79:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800e80:	e8 11 14 00 00       	call   802296 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800e85:	83 c4 2c             	add    $0x2c,%esp
  800e88:	5b                   	pop    %ebx
  800e89:	5e                   	pop    %esi
  800e8a:	5f                   	pop    %edi
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9b:	b8 10 00 00 00       	mov    $0x10,%eax
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7e 28                	jle    800ed8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800ebb:	00 
  800ebc:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800ec3:	00 
  800ec4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ecb:	00 
  800ecc:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800ed3:	e8 be 13 00 00       	call   802296 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800ed8:	83 c4 2c             	add    $0x2c,%esp
  800edb:	5b                   	pop    %ebx
  800edc:	5e                   	pop    %esi
  800edd:	5f                   	pop    %edi
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
  800ee6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eee:	b8 11 00 00 00       	mov    $0x11,%eax
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	89 df                	mov    %ebx,%edi
  800efb:	89 de                	mov    %ebx,%esi
  800efd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	7e 28                	jle    800f2b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f07:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800f0e:	00 
  800f0f:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800f16:	00 
  800f17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1e:	00 
  800f1f:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800f26:	e8 6b 13 00 00       	call   802296 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  800f2b:	83 c4 2c             	add    $0x2c,%esp
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <sys_sleep>:

int
sys_sleep(int channel)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
  800f39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f41:	b8 12 00 00 00       	mov    $0x12,%eax
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	89 cb                	mov    %ecx,%ebx
  800f4b:	89 cf                	mov    %ecx,%edi
  800f4d:	89 ce                	mov    %ecx,%esi
  800f4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f51:	85 c0                	test   %eax,%eax
  800f53:	7e 28                	jle    800f7d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f59:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f60:	00 
  800f61:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800f68:	00 
  800f69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f70:	00 
  800f71:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800f78:	e8 19 13 00 00       	call   802296 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  800f7d:	83 c4 2c             	add    $0x2c,%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f93:	b8 13 00 00 00       	mov    $0x13,%eax
  800f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	89 df                	mov    %ebx,%edi
  800fa0:	89 de                	mov    %ebx,%esi
  800fa2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	7e 28                	jle    800fd0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fac:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  800fb3:	00 
  800fb4:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800fbb:	00 
  800fbc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc3:	00 
  800fc4:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800fcb:	e8 c6 12 00 00       	call   802296 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  800fd0:	83 c4 2c             	add    $0x2c,%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5f                   	pop    %edi
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    
  800fd8:	66 90                	xchg   %ax,%ax
  800fda:	66 90                	xchg   %ax,%ax
  800fdc:	66 90                	xchg   %ax,%ax
  800fde:	66 90                	xchg   %ax,%ax

00800fe0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	05 00 00 00 30       	add    $0x30000000,%eax
  800feb:	c1 e8 0c             	shr    $0xc,%eax
}
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800ffb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801000:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801012:	89 c2                	mov    %eax,%edx
  801014:	c1 ea 16             	shr    $0x16,%edx
  801017:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80101e:	f6 c2 01             	test   $0x1,%dl
  801021:	74 11                	je     801034 <fd_alloc+0x2d>
  801023:	89 c2                	mov    %eax,%edx
  801025:	c1 ea 0c             	shr    $0xc,%edx
  801028:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80102f:	f6 c2 01             	test   $0x1,%dl
  801032:	75 09                	jne    80103d <fd_alloc+0x36>
			*fd_store = fd;
  801034:	89 01                	mov    %eax,(%ecx)
			return 0;
  801036:	b8 00 00 00 00       	mov    $0x0,%eax
  80103b:	eb 17                	jmp    801054 <fd_alloc+0x4d>
  80103d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801042:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801047:	75 c9                	jne    801012 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801049:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80104f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80105c:	83 f8 1f             	cmp    $0x1f,%eax
  80105f:	77 36                	ja     801097 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801061:	c1 e0 0c             	shl    $0xc,%eax
  801064:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801069:	89 c2                	mov    %eax,%edx
  80106b:	c1 ea 16             	shr    $0x16,%edx
  80106e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801075:	f6 c2 01             	test   $0x1,%dl
  801078:	74 24                	je     80109e <fd_lookup+0x48>
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	c1 ea 0c             	shr    $0xc,%edx
  80107f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801086:	f6 c2 01             	test   $0x1,%dl
  801089:	74 1a                	je     8010a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	89 02                	mov    %eax,(%edx)
	return 0;
  801090:	b8 00 00 00 00       	mov    $0x0,%eax
  801095:	eb 13                	jmp    8010aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801097:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109c:	eb 0c                	jmp    8010aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80109e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a3:	eb 05                	jmp    8010aa <fd_lookup+0x54>
  8010a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    

008010ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	83 ec 18             	sub    $0x18,%esp
  8010b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ba:	eb 13                	jmp    8010cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8010bc:	39 08                	cmp    %ecx,(%eax)
  8010be:	75 0c                	jne    8010cc <dev_lookup+0x20>
			*dev = devtab[i];
  8010c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ca:	eb 38                	jmp    801104 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010cc:	83 c2 01             	add    $0x1,%edx
  8010cf:	8b 04 95 d4 2a 80 00 	mov    0x802ad4(,%edx,4),%eax
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	75 e2                	jne    8010bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010da:	a1 08 40 80 00       	mov    0x804008,%eax
  8010df:	8b 40 48             	mov    0x48(%eax),%eax
  8010e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ea:	c7 04 24 58 2a 80 00 	movl   $0x802a58,(%esp)
  8010f1:	e8 71 f0 ff ff       	call   800167 <cprintf>
	*dev = 0;
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
  80110b:	83 ec 20             	sub    $0x20,%esp
  80110e:	8b 75 08             	mov    0x8(%ebp),%esi
  801111:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801114:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801117:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801121:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801124:	89 04 24             	mov    %eax,(%esp)
  801127:	e8 2a ff ff ff       	call   801056 <fd_lookup>
  80112c:	85 c0                	test   %eax,%eax
  80112e:	78 05                	js     801135 <fd_close+0x2f>
	    || fd != fd2)
  801130:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801133:	74 0c                	je     801141 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801135:	84 db                	test   %bl,%bl
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	0f 44 c2             	cmove  %edx,%eax
  80113f:	eb 3f                	jmp    801180 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801141:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801144:	89 44 24 04          	mov    %eax,0x4(%esp)
  801148:	8b 06                	mov    (%esi),%eax
  80114a:	89 04 24             	mov    %eax,(%esp)
  80114d:	e8 5a ff ff ff       	call   8010ac <dev_lookup>
  801152:	89 c3                	mov    %eax,%ebx
  801154:	85 c0                	test   %eax,%eax
  801156:	78 16                	js     80116e <fd_close+0x68>
		if (dev->dev_close)
  801158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80115e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801163:	85 c0                	test   %eax,%eax
  801165:	74 07                	je     80116e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801167:	89 34 24             	mov    %esi,(%esp)
  80116a:	ff d0                	call   *%eax
  80116c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80116e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801179:	e8 dc fa ff ff       	call   800c5a <sys_page_unmap>
	return r;
  80117e:	89 d8                	mov    %ebx,%eax
}
  801180:	83 c4 20             	add    $0x20,%esp
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80118d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801190:	89 44 24 04          	mov    %eax,0x4(%esp)
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	89 04 24             	mov    %eax,(%esp)
  80119a:	e8 b7 fe ff ff       	call   801056 <fd_lookup>
  80119f:	89 c2                	mov    %eax,%edx
  8011a1:	85 d2                	test   %edx,%edx
  8011a3:	78 13                	js     8011b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8011a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011ac:	00 
  8011ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b0:	89 04 24             	mov    %eax,(%esp)
  8011b3:	e8 4e ff ff ff       	call   801106 <fd_close>
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <close_all>:

void
close_all(void)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011c6:	89 1c 24             	mov    %ebx,(%esp)
  8011c9:	e8 b9 ff ff ff       	call   801187 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ce:	83 c3 01             	add    $0x1,%ebx
  8011d1:	83 fb 20             	cmp    $0x20,%ebx
  8011d4:	75 f0                	jne    8011c6 <close_all+0xc>
		close(i);
}
  8011d6:	83 c4 14             	add    $0x14,%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	57                   	push   %edi
  8011e0:	56                   	push   %esi
  8011e1:	53                   	push   %ebx
  8011e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	89 04 24             	mov    %eax,(%esp)
  8011f2:	e8 5f fe ff ff       	call   801056 <fd_lookup>
  8011f7:	89 c2                	mov    %eax,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	0f 88 e1 00 00 00    	js     8012e2 <dup+0x106>
		return r;
	close(newfdnum);
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	89 04 24             	mov    %eax,(%esp)
  801207:	e8 7b ff ff ff       	call   801187 <close>

	newfd = INDEX2FD(newfdnum);
  80120c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80120f:	c1 e3 0c             	shl    $0xc,%ebx
  801212:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121b:	89 04 24             	mov    %eax,(%esp)
  80121e:	e8 cd fd ff ff       	call   800ff0 <fd2data>
  801223:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801225:	89 1c 24             	mov    %ebx,(%esp)
  801228:	e8 c3 fd ff ff       	call   800ff0 <fd2data>
  80122d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80122f:	89 f0                	mov    %esi,%eax
  801231:	c1 e8 16             	shr    $0x16,%eax
  801234:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80123b:	a8 01                	test   $0x1,%al
  80123d:	74 43                	je     801282 <dup+0xa6>
  80123f:	89 f0                	mov    %esi,%eax
  801241:	c1 e8 0c             	shr    $0xc,%eax
  801244:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80124b:	f6 c2 01             	test   $0x1,%dl
  80124e:	74 32                	je     801282 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801250:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801257:	25 07 0e 00 00       	and    $0xe07,%eax
  80125c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801260:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801264:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80126b:	00 
  80126c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801277:	e8 8b f9 ff ff       	call   800c07 <sys_page_map>
  80127c:	89 c6                	mov    %eax,%esi
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 3e                	js     8012c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801285:	89 c2                	mov    %eax,%edx
  801287:	c1 ea 0c             	shr    $0xc,%edx
  80128a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801291:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801297:	89 54 24 10          	mov    %edx,0x10(%esp)
  80129b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80129f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012a6:	00 
  8012a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b2:	e8 50 f9 ff ff       	call   800c07 <sys_page_map>
  8012b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012bc:	85 f6                	test   %esi,%esi
  8012be:	79 22                	jns    8012e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012cb:	e8 8a f9 ff ff       	call   800c5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012db:	e8 7a f9 ff ff       	call   800c5a <sys_page_unmap>
	return r;
  8012e0:	89 f0                	mov    %esi,%eax
}
  8012e2:	83 c4 3c             	add    $0x3c,%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 24             	sub    $0x24,%esp
  8012f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fb:	89 1c 24             	mov    %ebx,(%esp)
  8012fe:	e8 53 fd ff ff       	call   801056 <fd_lookup>
  801303:	89 c2                	mov    %eax,%edx
  801305:	85 d2                	test   %edx,%edx
  801307:	78 6d                	js     801376 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801309:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801313:	8b 00                	mov    (%eax),%eax
  801315:	89 04 24             	mov    %eax,(%esp)
  801318:	e8 8f fd ff ff       	call   8010ac <dev_lookup>
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 55                	js     801376 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801324:	8b 50 08             	mov    0x8(%eax),%edx
  801327:	83 e2 03             	and    $0x3,%edx
  80132a:	83 fa 01             	cmp    $0x1,%edx
  80132d:	75 23                	jne    801352 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80132f:	a1 08 40 80 00       	mov    0x804008,%eax
  801334:	8b 40 48             	mov    0x48(%eax),%eax
  801337:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80133b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133f:	c7 04 24 99 2a 80 00 	movl   $0x802a99,(%esp)
  801346:	e8 1c ee ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  80134b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801350:	eb 24                	jmp    801376 <read+0x8c>
	}
	if (!dev->dev_read)
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 52 08             	mov    0x8(%edx),%edx
  801358:	85 d2                	test   %edx,%edx
  80135a:	74 15                	je     801371 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80135c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80135f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801363:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801366:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80136a:	89 04 24             	mov    %eax,(%esp)
  80136d:	ff d2                	call   *%edx
  80136f:	eb 05                	jmp    801376 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801371:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801376:	83 c4 24             	add    $0x24,%esp
  801379:	5b                   	pop    %ebx
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	57                   	push   %edi
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	83 ec 1c             	sub    $0x1c,%esp
  801385:	8b 7d 08             	mov    0x8(%ebp),%edi
  801388:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80138b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801390:	eb 23                	jmp    8013b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801392:	89 f0                	mov    %esi,%eax
  801394:	29 d8                	sub    %ebx,%eax
  801396:	89 44 24 08          	mov    %eax,0x8(%esp)
  80139a:	89 d8                	mov    %ebx,%eax
  80139c:	03 45 0c             	add    0xc(%ebp),%eax
  80139f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a3:	89 3c 24             	mov    %edi,(%esp)
  8013a6:	e8 3f ff ff ff       	call   8012ea <read>
		if (m < 0)
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	78 10                	js     8013bf <readn+0x43>
			return m;
		if (m == 0)
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	74 0a                	je     8013bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013b3:	01 c3                	add    %eax,%ebx
  8013b5:	39 f3                	cmp    %esi,%ebx
  8013b7:	72 d9                	jb     801392 <readn+0x16>
  8013b9:	89 d8                	mov    %ebx,%eax
  8013bb:	eb 02                	jmp    8013bf <readn+0x43>
  8013bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013bf:	83 c4 1c             	add    $0x1c,%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 24             	sub    $0x24,%esp
  8013ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d8:	89 1c 24             	mov    %ebx,(%esp)
  8013db:	e8 76 fc ff ff       	call   801056 <fd_lookup>
  8013e0:	89 c2                	mov    %eax,%edx
  8013e2:	85 d2                	test   %edx,%edx
  8013e4:	78 68                	js     80144e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f0:	8b 00                	mov    (%eax),%eax
  8013f2:	89 04 24             	mov    %eax,(%esp)
  8013f5:	e8 b2 fc ff ff       	call   8010ac <dev_lookup>
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 50                	js     80144e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801401:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801405:	75 23                	jne    80142a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801407:	a1 08 40 80 00       	mov    0x804008,%eax
  80140c:	8b 40 48             	mov    0x48(%eax),%eax
  80140f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801413:	89 44 24 04          	mov    %eax,0x4(%esp)
  801417:	c7 04 24 b5 2a 80 00 	movl   $0x802ab5,(%esp)
  80141e:	e8 44 ed ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  801423:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801428:	eb 24                	jmp    80144e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80142a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142d:	8b 52 0c             	mov    0xc(%edx),%edx
  801430:	85 d2                	test   %edx,%edx
  801432:	74 15                	je     801449 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801434:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801437:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80143b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801442:	89 04 24             	mov    %eax,(%esp)
  801445:	ff d2                	call   *%edx
  801447:	eb 05                	jmp    80144e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801449:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80144e:	83 c4 24             	add    $0x24,%esp
  801451:	5b                   	pop    %ebx
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    

00801454 <seek>:

int
seek(int fdnum, off_t offset)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80145d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	89 04 24             	mov    %eax,(%esp)
  801467:	e8 ea fb ff ff       	call   801056 <fd_lookup>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 0e                	js     80147e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801470:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801473:	8b 55 0c             	mov    0xc(%ebp),%edx
  801476:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	53                   	push   %ebx
  801484:	83 ec 24             	sub    $0x24,%esp
  801487:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801491:	89 1c 24             	mov    %ebx,(%esp)
  801494:	e8 bd fb ff ff       	call   801056 <fd_lookup>
  801499:	89 c2                	mov    %eax,%edx
  80149b:	85 d2                	test   %edx,%edx
  80149d:	78 61                	js     801500 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a9:	8b 00                	mov    (%eax),%eax
  8014ab:	89 04 24             	mov    %eax,(%esp)
  8014ae:	e8 f9 fb ff ff       	call   8010ac <dev_lookup>
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 49                	js     801500 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014be:	75 23                	jne    8014e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014c0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014c5:	8b 40 48             	mov    0x48(%eax),%eax
  8014c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d0:	c7 04 24 78 2a 80 00 	movl   $0x802a78,(%esp)
  8014d7:	e8 8b ec ff ff       	call   800167 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e1:	eb 1d                	jmp    801500 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8014e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e6:	8b 52 18             	mov    0x18(%edx),%edx
  8014e9:	85 d2                	test   %edx,%edx
  8014eb:	74 0e                	je     8014fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014f4:	89 04 24             	mov    %eax,(%esp)
  8014f7:	ff d2                	call   *%edx
  8014f9:	eb 05                	jmp    801500 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801500:	83 c4 24             	add    $0x24,%esp
  801503:	5b                   	pop    %ebx
  801504:	5d                   	pop    %ebp
  801505:	c3                   	ret    

00801506 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	53                   	push   %ebx
  80150a:	83 ec 24             	sub    $0x24,%esp
  80150d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801510:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801513:	89 44 24 04          	mov    %eax,0x4(%esp)
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	89 04 24             	mov    %eax,(%esp)
  80151d:	e8 34 fb ff ff       	call   801056 <fd_lookup>
  801522:	89 c2                	mov    %eax,%edx
  801524:	85 d2                	test   %edx,%edx
  801526:	78 52                	js     80157a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801528:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801532:	8b 00                	mov    (%eax),%eax
  801534:	89 04 24             	mov    %eax,(%esp)
  801537:	e8 70 fb ff ff       	call   8010ac <dev_lookup>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 3a                	js     80157a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801547:	74 2c                	je     801575 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801549:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80154c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801553:	00 00 00 
	stat->st_isdir = 0;
  801556:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80155d:	00 00 00 
	stat->st_dev = dev;
  801560:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801566:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80156a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156d:	89 14 24             	mov    %edx,(%esp)
  801570:	ff 50 14             	call   *0x14(%eax)
  801573:	eb 05                	jmp    80157a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801575:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80157a:	83 c4 24             	add    $0x24,%esp
  80157d:	5b                   	pop    %ebx
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	56                   	push   %esi
  801584:	53                   	push   %ebx
  801585:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801588:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80158f:	00 
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	89 04 24             	mov    %eax,(%esp)
  801596:	e8 1b 02 00 00       	call   8017b6 <open>
  80159b:	89 c3                	mov    %eax,%ebx
  80159d:	85 db                	test   %ebx,%ebx
  80159f:	78 1b                	js     8015bc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a8:	89 1c 24             	mov    %ebx,(%esp)
  8015ab:	e8 56 ff ff ff       	call   801506 <fstat>
  8015b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015b2:	89 1c 24             	mov    %ebx,(%esp)
  8015b5:	e8 cd fb ff ff       	call   801187 <close>
	return r;
  8015ba:	89 f0                	mov    %esi,%eax
}
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5e                   	pop    %esi
  8015c1:	5d                   	pop    %ebp
  8015c2:	c3                   	ret    

008015c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
  8015c8:	83 ec 10             	sub    $0x10,%esp
  8015cb:	89 c6                	mov    %eax,%esi
  8015cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015cf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015d6:	75 11                	jne    8015e9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015df:	e8 cb 0d 00 00       	call   8023af <ipc_find_env>
  8015e4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015e9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015f0:	00 
  8015f1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015f8:	00 
  8015f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015fd:	a1 00 40 80 00       	mov    0x804000,%eax
  801602:	89 04 24             	mov    %eax,(%esp)
  801605:	e8 3a 0d 00 00       	call   802344 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80160a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801611:	00 
  801612:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801616:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80161d:	e8 ce 0c 00 00       	call   8022f0 <ipc_recv>
}
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	5b                   	pop    %ebx
  801626:	5e                   	pop    %esi
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    

00801629 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 40 0c             	mov    0xc(%eax),%eax
  801635:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801642:	ba 00 00 00 00       	mov    $0x0,%edx
  801647:	b8 02 00 00 00       	mov    $0x2,%eax
  80164c:	e8 72 ff ff ff       	call   8015c3 <fsipc>
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8b 40 0c             	mov    0xc(%eax),%eax
  80165f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	b8 06 00 00 00       	mov    $0x6,%eax
  80166e:	e8 50 ff ff ff       	call   8015c3 <fsipc>
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	53                   	push   %ebx
  801679:	83 ec 14             	sub    $0x14,%esp
  80167c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80168a:	ba 00 00 00 00       	mov    $0x0,%edx
  80168f:	b8 05 00 00 00       	mov    $0x5,%eax
  801694:	e8 2a ff ff ff       	call   8015c3 <fsipc>
  801699:	89 c2                	mov    %eax,%edx
  80169b:	85 d2                	test   %edx,%edx
  80169d:	78 2b                	js     8016ca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80169f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016a6:	00 
  8016a7:	89 1c 24             	mov    %ebx,(%esp)
  8016aa:	e8 e8 f0 ff ff       	call   800797 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016af:	a1 80 50 80 00       	mov    0x805080,%eax
  8016b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ba:	a1 84 50 80 00       	mov    0x805084,%eax
  8016bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ca:	83 c4 14             	add    $0x14,%esp
  8016cd:	5b                   	pop    %ebx
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    

008016d0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 18             	sub    $0x18,%esp
  8016d6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8016df:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8016e5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8016fc:	e8 9b f2 ff ff       	call   80099c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801701:	ba 00 00 00 00       	mov    $0x0,%edx
  801706:	b8 04 00 00 00       	mov    $0x4,%eax
  80170b:	e8 b3 fe ff ff       	call   8015c3 <fsipc>
		return r;
	}

	return r;
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	56                   	push   %esi
  801716:	53                   	push   %ebx
  801717:	83 ec 10             	sub    $0x10,%esp
  80171a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	8b 40 0c             	mov    0xc(%eax),%eax
  801723:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801728:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80172e:	ba 00 00 00 00       	mov    $0x0,%edx
  801733:	b8 03 00 00 00       	mov    $0x3,%eax
  801738:	e8 86 fe ff ff       	call   8015c3 <fsipc>
  80173d:	89 c3                	mov    %eax,%ebx
  80173f:	85 c0                	test   %eax,%eax
  801741:	78 6a                	js     8017ad <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801743:	39 c6                	cmp    %eax,%esi
  801745:	73 24                	jae    80176b <devfile_read+0x59>
  801747:	c7 44 24 0c e8 2a 80 	movl   $0x802ae8,0xc(%esp)
  80174e:	00 
  80174f:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  801756:	00 
  801757:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80175e:	00 
  80175f:	c7 04 24 04 2b 80 00 	movl   $0x802b04,(%esp)
  801766:	e8 2b 0b 00 00       	call   802296 <_panic>
	assert(r <= PGSIZE);
  80176b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801770:	7e 24                	jle    801796 <devfile_read+0x84>
  801772:	c7 44 24 0c 0f 2b 80 	movl   $0x802b0f,0xc(%esp)
  801779:	00 
  80177a:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  801781:	00 
  801782:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801789:	00 
  80178a:	c7 04 24 04 2b 80 00 	movl   $0x802b04,(%esp)
  801791:	e8 00 0b 00 00       	call   802296 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801796:	89 44 24 08          	mov    %eax,0x8(%esp)
  80179a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017a1:	00 
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	89 04 24             	mov    %eax,(%esp)
  8017a8:	e8 87 f1 ff ff       	call   800934 <memmove>
	return r;
}
  8017ad:	89 d8                	mov    %ebx,%eax
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	5b                   	pop    %ebx
  8017b3:	5e                   	pop    %esi
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    

008017b6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	53                   	push   %ebx
  8017ba:	83 ec 24             	sub    $0x24,%esp
  8017bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017c0:	89 1c 24             	mov    %ebx,(%esp)
  8017c3:	e8 98 ef ff ff       	call   800760 <strlen>
  8017c8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017cd:	7f 60                	jg     80182f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d2:	89 04 24             	mov    %eax,(%esp)
  8017d5:	e8 2d f8 ff ff       	call   801007 <fd_alloc>
  8017da:	89 c2                	mov    %eax,%edx
  8017dc:	85 d2                	test   %edx,%edx
  8017de:	78 54                	js     801834 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017e4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017eb:	e8 a7 ef ff ff       	call   800797 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801800:	e8 be fd ff ff       	call   8015c3 <fsipc>
  801805:	89 c3                	mov    %eax,%ebx
  801807:	85 c0                	test   %eax,%eax
  801809:	79 17                	jns    801822 <open+0x6c>
		fd_close(fd, 0);
  80180b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801812:	00 
  801813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801816:	89 04 24             	mov    %eax,(%esp)
  801819:	e8 e8 f8 ff ff       	call   801106 <fd_close>
		return r;
  80181e:	89 d8                	mov    %ebx,%eax
  801820:	eb 12                	jmp    801834 <open+0x7e>
	}

	return fd2num(fd);
  801822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801825:	89 04 24             	mov    %eax,(%esp)
  801828:	e8 b3 f7 ff ff       	call   800fe0 <fd2num>
  80182d:	eb 05                	jmp    801834 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80182f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801834:	83 c4 24             	add    $0x24,%esp
  801837:	5b                   	pop    %ebx
  801838:	5d                   	pop    %ebp
  801839:	c3                   	ret    

0080183a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801840:	ba 00 00 00 00       	mov    $0x0,%edx
  801845:	b8 08 00 00 00       	mov    $0x8,%eax
  80184a:	e8 74 fd ff ff       	call   8015c3 <fsipc>
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    
  801851:	66 90                	xchg   %ax,%ax
  801853:	66 90                	xchg   %ax,%ax
  801855:	66 90                	xchg   %ax,%ax
  801857:	66 90                	xchg   %ax,%ax
  801859:	66 90                	xchg   %ax,%ax
  80185b:	66 90                	xchg   %ax,%ax
  80185d:	66 90                	xchg   %ax,%ax
  80185f:	90                   	nop

00801860 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801866:	c7 44 24 04 1b 2b 80 	movl   $0x802b1b,0x4(%esp)
  80186d:	00 
  80186e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801871:	89 04 24             	mov    %eax,(%esp)
  801874:	e8 1e ef ff ff       	call   800797 <strcpy>
	return 0;
}
  801879:	b8 00 00 00 00       	mov    $0x0,%eax
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	53                   	push   %ebx
  801884:	83 ec 14             	sub    $0x14,%esp
  801887:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80188a:	89 1c 24             	mov    %ebx,(%esp)
  80188d:	e8 5c 0b 00 00       	call   8023ee <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801892:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801897:	83 f8 01             	cmp    $0x1,%eax
  80189a:	75 0d                	jne    8018a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80189c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80189f:	89 04 24             	mov    %eax,(%esp)
  8018a2:	e8 29 03 00 00       	call   801bd0 <nsipc_close>
  8018a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8018a9:	89 d0                	mov    %edx,%eax
  8018ab:	83 c4 14             	add    $0x14,%esp
  8018ae:	5b                   	pop    %ebx
  8018af:	5d                   	pop    %ebp
  8018b0:	c3                   	ret    

008018b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018be:	00 
  8018bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d3:	89 04 24             	mov    %eax,(%esp)
  8018d6:	e8 f0 03 00 00       	call   801ccb <nsipc_send>
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018ea:	00 
  8018eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ff:	89 04 24             	mov    %eax,(%esp)
  801902:	e8 44 03 00 00       	call   801c4b <nsipc_recv>
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80190f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801912:	89 54 24 04          	mov    %edx,0x4(%esp)
  801916:	89 04 24             	mov    %eax,(%esp)
  801919:	e8 38 f7 ff ff       	call   801056 <fd_lookup>
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 17                	js     801939 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801925:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80192b:	39 08                	cmp    %ecx,(%eax)
  80192d:	75 05                	jne    801934 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80192f:	8b 40 0c             	mov    0xc(%eax),%eax
  801932:	eb 05                	jmp    801939 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801934:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	83 ec 20             	sub    $0x20,%esp
  801943:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801945:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801948:	89 04 24             	mov    %eax,(%esp)
  80194b:	e8 b7 f6 ff ff       	call   801007 <fd_alloc>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	85 c0                	test   %eax,%eax
  801954:	78 21                	js     801977 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801956:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80195d:	00 
  80195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801961:	89 44 24 04          	mov    %eax,0x4(%esp)
  801965:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80196c:	e8 42 f2 ff ff       	call   800bb3 <sys_page_alloc>
  801971:	89 c3                	mov    %eax,%ebx
  801973:	85 c0                	test   %eax,%eax
  801975:	79 0c                	jns    801983 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801977:	89 34 24             	mov    %esi,(%esp)
  80197a:	e8 51 02 00 00       	call   801bd0 <nsipc_close>
		return r;
  80197f:	89 d8                	mov    %ebx,%eax
  801981:	eb 20                	jmp    8019a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801983:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80198e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801991:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801998:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80199b:	89 14 24             	mov    %edx,(%esp)
  80199e:	e8 3d f6 ff ff       	call   800fe0 <fd2num>
}
  8019a3:	83 c4 20             	add    $0x20,%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	e8 51 ff ff ff       	call   801909 <fd2sockid>
		return r;
  8019b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 23                	js     8019e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019be:	8b 55 10             	mov    0x10(%ebp),%edx
  8019c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019cc:	89 04 24             	mov    %eax,(%esp)
  8019cf:	e8 45 01 00 00       	call   801b19 <nsipc_accept>
		return r;
  8019d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 07                	js     8019e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8019da:	e8 5c ff ff ff       	call   80193b <alloc_sockfd>
  8019df:	89 c1                	mov    %eax,%ecx
}
  8019e1:	89 c8                	mov    %ecx,%eax
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	e8 16 ff ff ff       	call   801909 <fd2sockid>
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	85 d2                	test   %edx,%edx
  8019f7:	78 16                	js     801a0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a07:	89 14 24             	mov    %edx,(%esp)
  801a0a:	e8 60 01 00 00       	call   801b6f <nsipc_bind>
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <shutdown>:

int
shutdown(int s, int how)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	e8 ea fe ff ff       	call   801909 <fd2sockid>
  801a1f:	89 c2                	mov    %eax,%edx
  801a21:	85 d2                	test   %edx,%edx
  801a23:	78 0f                	js     801a34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2c:	89 14 24             	mov    %edx,(%esp)
  801a2f:	e8 7a 01 00 00       	call   801bae <nsipc_shutdown>
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	e8 c5 fe ff ff       	call   801909 <fd2sockid>
  801a44:	89 c2                	mov    %eax,%edx
  801a46:	85 d2                	test   %edx,%edx
  801a48:	78 16                	js     801a60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a58:	89 14 24             	mov    %edx,(%esp)
  801a5b:	e8 8a 01 00 00       	call   801bea <nsipc_connect>
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <listen>:

int
listen(int s, int backlog)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	e8 99 fe ff ff       	call   801909 <fd2sockid>
  801a70:	89 c2                	mov    %eax,%edx
  801a72:	85 d2                	test   %edx,%edx
  801a74:	78 0f                	js     801a85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7d:	89 14 24             	mov    %edx,(%esp)
  801a80:	e8 a4 01 00 00       	call   801c29 <nsipc_listen>
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	89 04 24             	mov    %eax,(%esp)
  801aa1:	e8 98 02 00 00       	call   801d3e <nsipc_socket>
  801aa6:	89 c2                	mov    %eax,%edx
  801aa8:	85 d2                	test   %edx,%edx
  801aaa:	78 05                	js     801ab1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801aac:	e8 8a fe ff ff       	call   80193b <alloc_sockfd>
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 14             	sub    $0x14,%esp
  801aba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801abc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ac3:	75 11                	jne    801ad6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ac5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801acc:	e8 de 08 00 00       	call   8023af <ipc_find_env>
  801ad1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ad6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801add:	00 
  801ade:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ae5:	00 
  801ae6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aea:	a1 04 40 80 00       	mov    0x804004,%eax
  801aef:	89 04 24             	mov    %eax,(%esp)
  801af2:	e8 4d 08 00 00       	call   802344 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801af7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801afe:	00 
  801aff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b06:	00 
  801b07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0e:	e8 dd 07 00 00       	call   8022f0 <ipc_recv>
}
  801b13:	83 c4 14             	add    $0x14,%esp
  801b16:	5b                   	pop    %ebx
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    

00801b19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	56                   	push   %esi
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 10             	sub    $0x10,%esp
  801b21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b2c:	8b 06                	mov    (%esi),%eax
  801b2e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b33:	b8 01 00 00 00       	mov    $0x1,%eax
  801b38:	e8 76 ff ff ff       	call   801ab3 <nsipc>
  801b3d:	89 c3                	mov    %eax,%ebx
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 23                	js     801b66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b43:	a1 10 60 80 00       	mov    0x806010,%eax
  801b48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b53:	00 
  801b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b57:	89 04 24             	mov    %eax,(%esp)
  801b5a:	e8 d5 ed ff ff       	call   800934 <memmove>
		*addrlen = ret->ret_addrlen;
  801b5f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801b66:	89 d8                	mov    %ebx,%eax
  801b68:	83 c4 10             	add    $0x10,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    

00801b6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	53                   	push   %ebx
  801b73:	83 ec 14             	sub    $0x14,%esp
  801b76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b93:	e8 9c ed ff ff       	call   800934 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801ba3:	e8 0b ff ff ff       	call   801ab3 <nsipc>
}
  801ba8:	83 c4 14             	add    $0x14,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    

00801bae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801bc9:	e8 e5 fe ff ff       	call   801ab3 <nsipc>
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <nsipc_close>:

int
nsipc_close(int s)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bde:	b8 04 00 00 00       	mov    $0x4,%eax
  801be3:	e8 cb fe ff ff       	call   801ab3 <nsipc>
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	53                   	push   %ebx
  801bee:	83 ec 14             	sub    $0x14,%esp
  801bf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c07:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c0e:	e8 21 ed ff ff       	call   800934 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c13:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c19:	b8 05 00 00 00       	mov    $0x5,%eax
  801c1e:	e8 90 fe ff ff       	call   801ab3 <nsipc>
}
  801c23:	83 c4 14             	add    $0x14,%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    

00801c29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c44:	e8 6a fe ff ff       	call   801ab3 <nsipc>
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 10             	sub    $0x10,%esp
  801c53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c6c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c71:	e8 3d fe ff ff       	call   801ab3 <nsipc>
  801c76:	89 c3                	mov    %eax,%ebx
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 46                	js     801cc2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801c7c:	39 f0                	cmp    %esi,%eax
  801c7e:	7f 07                	jg     801c87 <nsipc_recv+0x3c>
  801c80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c85:	7e 24                	jle    801cab <nsipc_recv+0x60>
  801c87:	c7 44 24 0c 27 2b 80 	movl   $0x802b27,0xc(%esp)
  801c8e:	00 
  801c8f:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  801c96:	00 
  801c97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c9e:	00 
  801c9f:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801ca6:	e8 eb 05 00 00       	call   802296 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cab:	89 44 24 08          	mov    %eax,0x8(%esp)
  801caf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cb6:	00 
  801cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cba:	89 04 24             	mov    %eax,(%esp)
  801cbd:	e8 72 ec ff ff       	call   800934 <memmove>
	}

	return r;
}
  801cc2:	89 d8                	mov    %ebx,%eax
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    

00801ccb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 14             	sub    $0x14,%esp
  801cd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cdd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ce3:	7e 24                	jle    801d09 <nsipc_send+0x3e>
  801ce5:	c7 44 24 0c 48 2b 80 	movl   $0x802b48,0xc(%esp)
  801cec:	00 
  801ced:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  801cf4:	00 
  801cf5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801cfc:	00 
  801cfd:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801d04:	e8 8d 05 00 00       	call   802296 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d14:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d1b:	e8 14 ec ff ff       	call   800934 <memmove>
	nsipcbuf.send.req_size = size;
  801d20:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d26:	8b 45 14             	mov    0x14(%ebp),%eax
  801d29:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d2e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d33:	e8 7b fd ff ff       	call   801ab3 <nsipc>
}
  801d38:	83 c4 14             	add    $0x14,%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    

00801d3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d5c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d61:	e8 4d fd ff ff       	call   801ab3 <nsipc>
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
  801d6d:	83 ec 10             	sub    $0x10,%esp
  801d70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	89 04 24             	mov    %eax,(%esp)
  801d79:	e8 72 f2 ff ff       	call   800ff0 <fd2data>
  801d7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d80:	c7 44 24 04 54 2b 80 	movl   $0x802b54,0x4(%esp)
  801d87:	00 
  801d88:	89 1c 24             	mov    %ebx,(%esp)
  801d8b:	e8 07 ea ff ff       	call   800797 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d90:	8b 46 04             	mov    0x4(%esi),%eax
  801d93:	2b 06                	sub    (%esi),%eax
  801d95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801da2:	00 00 00 
	stat->st_dev = &devpipe;
  801da5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dac:	30 80 00 
	return 0;
}
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    

00801dbb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	53                   	push   %ebx
  801dbf:	83 ec 14             	sub    $0x14,%esp
  801dc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dc5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd0:	e8 85 ee ff ff       	call   800c5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dd5:	89 1c 24             	mov    %ebx,(%esp)
  801dd8:	e8 13 f2 ff ff       	call   800ff0 <fd2data>
  801ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801de8:	e8 6d ee ff ff       	call   800c5a <sys_page_unmap>
}
  801ded:	83 c4 14             	add    $0x14,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    

00801df3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	57                   	push   %edi
  801df7:	56                   	push   %esi
  801df8:	53                   	push   %ebx
  801df9:	83 ec 2c             	sub    $0x2c,%esp
  801dfc:	89 c6                	mov    %eax,%esi
  801dfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e01:	a1 08 40 80 00       	mov    0x804008,%eax
  801e06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e09:	89 34 24             	mov    %esi,(%esp)
  801e0c:	e8 dd 05 00 00       	call   8023ee <pageref>
  801e11:	89 c7                	mov    %eax,%edi
  801e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e16:	89 04 24             	mov    %eax,(%esp)
  801e19:	e8 d0 05 00 00       	call   8023ee <pageref>
  801e1e:	39 c7                	cmp    %eax,%edi
  801e20:	0f 94 c2             	sete   %dl
  801e23:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e26:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801e2c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e2f:	39 fb                	cmp    %edi,%ebx
  801e31:	74 21                	je     801e54 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e33:	84 d2                	test   %dl,%dl
  801e35:	74 ca                	je     801e01 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e37:	8b 51 58             	mov    0x58(%ecx),%edx
  801e3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e46:	c7 04 24 5b 2b 80 00 	movl   $0x802b5b,(%esp)
  801e4d:	e8 15 e3 ff ff       	call   800167 <cprintf>
  801e52:	eb ad                	jmp    801e01 <_pipeisclosed+0xe>
	}
}
  801e54:	83 c4 2c             	add    $0x2c,%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5f                   	pop    %edi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    

00801e5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	57                   	push   %edi
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
  801e62:	83 ec 1c             	sub    $0x1c,%esp
  801e65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e68:	89 34 24             	mov    %esi,(%esp)
  801e6b:	e8 80 f1 ff ff       	call   800ff0 <fd2data>
  801e70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e72:	bf 00 00 00 00       	mov    $0x0,%edi
  801e77:	eb 45                	jmp    801ebe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e79:	89 da                	mov    %ebx,%edx
  801e7b:	89 f0                	mov    %esi,%eax
  801e7d:	e8 71 ff ff ff       	call   801df3 <_pipeisclosed>
  801e82:	85 c0                	test   %eax,%eax
  801e84:	75 41                	jne    801ec7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e86:	e8 09 ed ff ff       	call   800b94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e8e:	8b 0b                	mov    (%ebx),%ecx
  801e90:	8d 51 20             	lea    0x20(%ecx),%edx
  801e93:	39 d0                	cmp    %edx,%eax
  801e95:	73 e2                	jae    801e79 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ea1:	99                   	cltd   
  801ea2:	c1 ea 1b             	shr    $0x1b,%edx
  801ea5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ea8:	83 e1 1f             	and    $0x1f,%ecx
  801eab:	29 d1                	sub    %edx,%ecx
  801ead:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801eb1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801eb5:	83 c0 01             	add    $0x1,%eax
  801eb8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ebb:	83 c7 01             	add    $0x1,%edi
  801ebe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ec1:	75 c8                	jne    801e8b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ec3:	89 f8                	mov    %edi,%eax
  801ec5:	eb 05                	jmp    801ecc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ecc:	83 c4 1c             	add    $0x1c,%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5f                   	pop    %edi
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    

00801ed4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	57                   	push   %edi
  801ed8:	56                   	push   %esi
  801ed9:	53                   	push   %ebx
  801eda:	83 ec 1c             	sub    $0x1c,%esp
  801edd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ee0:	89 3c 24             	mov    %edi,(%esp)
  801ee3:	e8 08 f1 ff ff       	call   800ff0 <fd2data>
  801ee8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eea:	be 00 00 00 00       	mov    $0x0,%esi
  801eef:	eb 3d                	jmp    801f2e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ef1:	85 f6                	test   %esi,%esi
  801ef3:	74 04                	je     801ef9 <devpipe_read+0x25>
				return i;
  801ef5:	89 f0                	mov    %esi,%eax
  801ef7:	eb 43                	jmp    801f3c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ef9:	89 da                	mov    %ebx,%edx
  801efb:	89 f8                	mov    %edi,%eax
  801efd:	e8 f1 fe ff ff       	call   801df3 <_pipeisclosed>
  801f02:	85 c0                	test   %eax,%eax
  801f04:	75 31                	jne    801f37 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f06:	e8 89 ec ff ff       	call   800b94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f0b:	8b 03                	mov    (%ebx),%eax
  801f0d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f10:	74 df                	je     801ef1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f12:	99                   	cltd   
  801f13:	c1 ea 1b             	shr    $0x1b,%edx
  801f16:	01 d0                	add    %edx,%eax
  801f18:	83 e0 1f             	and    $0x1f,%eax
  801f1b:	29 d0                	sub    %edx,%eax
  801f1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f28:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f2b:	83 c6 01             	add    $0x1,%esi
  801f2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f31:	75 d8                	jne    801f0b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f33:	89 f0                	mov    %esi,%eax
  801f35:	eb 05                	jmp    801f3c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f3c:	83 c4 1c             	add    $0x1c,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5f                   	pop    %edi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	56                   	push   %esi
  801f48:	53                   	push   %ebx
  801f49:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4f:	89 04 24             	mov    %eax,(%esp)
  801f52:	e8 b0 f0 ff ff       	call   801007 <fd_alloc>
  801f57:	89 c2                	mov    %eax,%edx
  801f59:	85 d2                	test   %edx,%edx
  801f5b:	0f 88 4d 01 00 00    	js     8020ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f61:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f68:	00 
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f77:	e8 37 ec ff ff       	call   800bb3 <sys_page_alloc>
  801f7c:	89 c2                	mov    %eax,%edx
  801f7e:	85 d2                	test   %edx,%edx
  801f80:	0f 88 28 01 00 00    	js     8020ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f89:	89 04 24             	mov    %eax,(%esp)
  801f8c:	e8 76 f0 ff ff       	call   801007 <fd_alloc>
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	85 c0                	test   %eax,%eax
  801f95:	0f 88 fe 00 00 00    	js     802099 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fa2:	00 
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801faa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb1:	e8 fd eb ff ff       	call   800bb3 <sys_page_alloc>
  801fb6:	89 c3                	mov    %eax,%ebx
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	0f 88 d9 00 00 00    	js     802099 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	89 04 24             	mov    %eax,(%esp)
  801fc6:	e8 25 f0 ff ff       	call   800ff0 <fd2data>
  801fcb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fcd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fd4:	00 
  801fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe0:	e8 ce eb ff ff       	call   800bb3 <sys_page_alloc>
  801fe5:	89 c3                	mov    %eax,%ebx
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	0f 88 97 00 00 00    	js     802086 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	89 04 24             	mov    %eax,(%esp)
  801ff5:	e8 f6 ef ff ff       	call   800ff0 <fd2data>
  801ffa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802001:	00 
  802002:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802006:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80200d:	00 
  80200e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802012:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802019:	e8 e9 eb ff ff       	call   800c07 <sys_page_map>
  80201e:	89 c3                	mov    %eax,%ebx
  802020:	85 c0                	test   %eax,%eax
  802022:	78 52                	js     802076 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802024:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802039:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80203f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802042:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802047:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	89 04 24             	mov    %eax,(%esp)
  802054:	e8 87 ef ff ff       	call   800fe0 <fd2num>
  802059:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80205c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80205e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802061:	89 04 24             	mov    %eax,(%esp)
  802064:	e8 77 ef ff ff       	call   800fe0 <fd2num>
  802069:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	eb 38                	jmp    8020ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802076:	89 74 24 04          	mov    %esi,0x4(%esp)
  80207a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802081:	e8 d4 eb ff ff       	call   800c5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802094:	e8 c1 eb ff ff       	call   800c5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a7:	e8 ae eb ff ff       	call   800c5a <sys_page_unmap>
  8020ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8020ae:	83 c4 30             	add    $0x30,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5d                   	pop    %ebp
  8020b4:	c3                   	ret    

008020b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	89 04 24             	mov    %eax,(%esp)
  8020c8:	e8 89 ef ff ff       	call   801056 <fd_lookup>
  8020cd:	89 c2                	mov    %eax,%edx
  8020cf:	85 d2                	test   %edx,%edx
  8020d1:	78 15                	js     8020e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	89 04 24             	mov    %eax,(%esp)
  8020d9:	e8 12 ef ff ff       	call   800ff0 <fd2data>
	return _pipeisclosed(fd, p);
  8020de:	89 c2                	mov    %eax,%edx
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	e8 0b fd ff ff       	call   801df3 <_pipeisclosed>
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    
  8020ea:	66 90                	xchg   %ax,%ax
  8020ec:	66 90                	xchg   %ax,%ax
  8020ee:	66 90                	xchg   %ax,%ax

008020f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	5d                   	pop    %ebp
  8020f9:	c3                   	ret    

008020fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802100:	c7 44 24 04 73 2b 80 	movl   $0x802b73,0x4(%esp)
  802107:	00 
  802108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210b:	89 04 24             	mov    %eax,(%esp)
  80210e:	e8 84 e6 ff ff       	call   800797 <strcpy>
	return 0;
}
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	57                   	push   %edi
  80211e:	56                   	push   %esi
  80211f:	53                   	push   %ebx
  802120:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802126:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80212b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802131:	eb 31                	jmp    802164 <devcons_write+0x4a>
		m = n - tot;
  802133:	8b 75 10             	mov    0x10(%ebp),%esi
  802136:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802138:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80213b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802140:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802143:	89 74 24 08          	mov    %esi,0x8(%esp)
  802147:	03 45 0c             	add    0xc(%ebp),%eax
  80214a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214e:	89 3c 24             	mov    %edi,(%esp)
  802151:	e8 de e7 ff ff       	call   800934 <memmove>
		sys_cputs(buf, m);
  802156:	89 74 24 04          	mov    %esi,0x4(%esp)
  80215a:	89 3c 24             	mov    %edi,(%esp)
  80215d:	e8 84 e9 ff ff       	call   800ae6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802162:	01 f3                	add    %esi,%ebx
  802164:	89 d8                	mov    %ebx,%eax
  802166:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802169:	72 c8                	jb     802133 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80216b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    

00802176 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802185:	75 07                	jne    80218e <devcons_read+0x18>
  802187:	eb 2a                	jmp    8021b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802189:	e8 06 ea ff ff       	call   800b94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80218e:	66 90                	xchg   %ax,%ax
  802190:	e8 6f e9 ff ff       	call   800b04 <sys_cgetc>
  802195:	85 c0                	test   %eax,%eax
  802197:	74 f0                	je     802189 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802199:	85 c0                	test   %eax,%eax
  80219b:	78 16                	js     8021b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80219d:	83 f8 04             	cmp    $0x4,%eax
  8021a0:	74 0c                	je     8021ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8021a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a5:	88 02                	mov    %al,(%edx)
	return 1;
  8021a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ac:	eb 05                	jmp    8021b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021c8:	00 
  8021c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021cc:	89 04 24             	mov    %eax,(%esp)
  8021cf:	e8 12 e9 ff ff       	call   800ae6 <sys_cputs>
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <getchar>:

int
getchar(void)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021e3:	00 
  8021e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f2:	e8 f3 f0 ff ff       	call   8012ea <read>
	if (r < 0)
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	78 0f                	js     80220a <getchar+0x34>
		return r;
	if (r < 1)
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	7e 06                	jle    802205 <getchar+0x2f>
		return -E_EOF;
	return c;
  8021ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802203:	eb 05                	jmp    80220a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802205:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802212:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802215:	89 44 24 04          	mov    %eax,0x4(%esp)
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	89 04 24             	mov    %eax,(%esp)
  80221f:	e8 32 ee ff ff       	call   801056 <fd_lookup>
  802224:	85 c0                	test   %eax,%eax
  802226:	78 11                	js     802239 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802231:	39 10                	cmp    %edx,(%eax)
  802233:	0f 94 c0             	sete   %al
  802236:	0f b6 c0             	movzbl %al,%eax
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <opencons>:

int
opencons(void)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802241:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802244:	89 04 24             	mov    %eax,(%esp)
  802247:	e8 bb ed ff ff       	call   801007 <fd_alloc>
		return r;
  80224c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80224e:	85 c0                	test   %eax,%eax
  802250:	78 40                	js     802292 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802252:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802259:	00 
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802261:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802268:	e8 46 e9 ff ff       	call   800bb3 <sys_page_alloc>
		return r;
  80226d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80226f:	85 c0                	test   %eax,%eax
  802271:	78 1f                	js     802292 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802273:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802288:	89 04 24             	mov    %eax,(%esp)
  80228b:	e8 50 ed ff ff       	call   800fe0 <fd2num>
  802290:	89 c2                	mov    %eax,%edx
}
  802292:	89 d0                	mov    %edx,%eax
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	56                   	push   %esi
  80229a:	53                   	push   %ebx
  80229b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80229e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022a1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022a7:	e8 c9 e8 ff ff       	call   800b75 <sys_getenvid>
  8022ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022af:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022ba:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c2:	c7 04 24 80 2b 80 00 	movl   $0x802b80,(%esp)
  8022c9:	e8 99 de ff ff       	call   800167 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d5:	89 04 24             	mov    %eax,(%esp)
  8022d8:	e8 29 de ff ff       	call   800106 <vcprintf>
	cprintf("\n");
  8022dd:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  8022e4:	e8 7e de ff ff       	call   800167 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022e9:	cc                   	int3   
  8022ea:	eb fd                	jmp    8022e9 <_panic+0x53>
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	56                   	push   %esi
  8022f4:	53                   	push   %ebx
  8022f5:	83 ec 10             	sub    $0x10,%esp
  8022f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802301:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802303:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802308:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80230b:	89 04 24             	mov    %eax,(%esp)
  80230e:	e8 b6 ea ff ff       	call   800dc9 <sys_ipc_recv>
  802313:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802315:	85 d2                	test   %edx,%edx
  802317:	75 24                	jne    80233d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802319:	85 f6                	test   %esi,%esi
  80231b:	74 0a                	je     802327 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80231d:	a1 08 40 80 00       	mov    0x804008,%eax
  802322:	8b 40 74             	mov    0x74(%eax),%eax
  802325:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802327:	85 db                	test   %ebx,%ebx
  802329:	74 0a                	je     802335 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80232b:	a1 08 40 80 00       	mov    0x804008,%eax
  802330:	8b 40 78             	mov    0x78(%eax),%eax
  802333:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802335:	a1 08 40 80 00       	mov    0x804008,%eax
  80233a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80233d:	83 c4 10             	add    $0x10,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	57                   	push   %edi
  802348:	56                   	push   %esi
  802349:	53                   	push   %ebx
  80234a:	83 ec 1c             	sub    $0x1c,%esp
  80234d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802350:	8b 75 0c             	mov    0xc(%ebp),%esi
  802353:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802356:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802358:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80235d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802360:	8b 45 14             	mov    0x14(%ebp),%eax
  802363:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802367:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80236b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80236f:	89 3c 24             	mov    %edi,(%esp)
  802372:	e8 2f ea ff ff       	call   800da6 <sys_ipc_try_send>

		if (ret == 0)
  802377:	85 c0                	test   %eax,%eax
  802379:	74 2c                	je     8023a7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80237b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80237e:	74 20                	je     8023a0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802380:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802384:	c7 44 24 08 a4 2b 80 	movl   $0x802ba4,0x8(%esp)
  80238b:	00 
  80238c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802393:	00 
  802394:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  80239b:	e8 f6 fe ff ff       	call   802296 <_panic>
		}

		sys_yield();
  8023a0:	e8 ef e7 ff ff       	call   800b94 <sys_yield>
	}
  8023a5:	eb b9                	jmp    802360 <ipc_send+0x1c>
}
  8023a7:	83 c4 1c             	add    $0x1c,%esp
  8023aa:	5b                   	pop    %ebx
  8023ab:	5e                   	pop    %esi
  8023ac:	5f                   	pop    %edi
  8023ad:	5d                   	pop    %ebp
  8023ae:	c3                   	ret    

008023af <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ba:	89 c2                	mov    %eax,%edx
  8023bc:	c1 e2 07             	shl    $0x7,%edx
  8023bf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8023c6:	8b 52 50             	mov    0x50(%edx),%edx
  8023c9:	39 ca                	cmp    %ecx,%edx
  8023cb:	75 11                	jne    8023de <ipc_find_env+0x2f>
			return envs[i].env_id;
  8023cd:	89 c2                	mov    %eax,%edx
  8023cf:	c1 e2 07             	shl    $0x7,%edx
  8023d2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8023d9:	8b 40 40             	mov    0x40(%eax),%eax
  8023dc:	eb 0e                	jmp    8023ec <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023de:	83 c0 01             	add    $0x1,%eax
  8023e1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023e6:	75 d2                	jne    8023ba <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023e8:	66 b8 00 00          	mov    $0x0,%ax
}
  8023ec:	5d                   	pop    %ebp
  8023ed:	c3                   	ret    

008023ee <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023f4:	89 d0                	mov    %edx,%eax
  8023f6:	c1 e8 16             	shr    $0x16,%eax
  8023f9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802400:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802405:	f6 c1 01             	test   $0x1,%cl
  802408:	74 1d                	je     802427 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80240a:	c1 ea 0c             	shr    $0xc,%edx
  80240d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802414:	f6 c2 01             	test   $0x1,%dl
  802417:	74 0e                	je     802427 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802419:	c1 ea 0c             	shr    $0xc,%edx
  80241c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802423:	ef 
  802424:	0f b7 c0             	movzwl %ax,%eax
}
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    
  802429:	66 90                	xchg   %ax,%ax
  80242b:	66 90                	xchg   %ax,%ax
  80242d:	66 90                	xchg   %ax,%ax
  80242f:	90                   	nop

00802430 <__udivdi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	8b 44 24 28          	mov    0x28(%esp),%eax
  80243a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80243e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802442:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802446:	85 c0                	test   %eax,%eax
  802448:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80244c:	89 ea                	mov    %ebp,%edx
  80244e:	89 0c 24             	mov    %ecx,(%esp)
  802451:	75 2d                	jne    802480 <__udivdi3+0x50>
  802453:	39 e9                	cmp    %ebp,%ecx
  802455:	77 61                	ja     8024b8 <__udivdi3+0x88>
  802457:	85 c9                	test   %ecx,%ecx
  802459:	89 ce                	mov    %ecx,%esi
  80245b:	75 0b                	jne    802468 <__udivdi3+0x38>
  80245d:	b8 01 00 00 00       	mov    $0x1,%eax
  802462:	31 d2                	xor    %edx,%edx
  802464:	f7 f1                	div    %ecx
  802466:	89 c6                	mov    %eax,%esi
  802468:	31 d2                	xor    %edx,%edx
  80246a:	89 e8                	mov    %ebp,%eax
  80246c:	f7 f6                	div    %esi
  80246e:	89 c5                	mov    %eax,%ebp
  802470:	89 f8                	mov    %edi,%eax
  802472:	f7 f6                	div    %esi
  802474:	89 ea                	mov    %ebp,%edx
  802476:	83 c4 0c             	add    $0xc,%esp
  802479:	5e                   	pop    %esi
  80247a:	5f                   	pop    %edi
  80247b:	5d                   	pop    %ebp
  80247c:	c3                   	ret    
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	39 e8                	cmp    %ebp,%eax
  802482:	77 24                	ja     8024a8 <__udivdi3+0x78>
  802484:	0f bd e8             	bsr    %eax,%ebp
  802487:	83 f5 1f             	xor    $0x1f,%ebp
  80248a:	75 3c                	jne    8024c8 <__udivdi3+0x98>
  80248c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802490:	39 34 24             	cmp    %esi,(%esp)
  802493:	0f 86 9f 00 00 00    	jbe    802538 <__udivdi3+0x108>
  802499:	39 d0                	cmp    %edx,%eax
  80249b:	0f 82 97 00 00 00    	jb     802538 <__udivdi3+0x108>
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	31 d2                	xor    %edx,%edx
  8024aa:	31 c0                	xor    %eax,%eax
  8024ac:	83 c4 0c             	add    $0xc,%esp
  8024af:	5e                   	pop    %esi
  8024b0:	5f                   	pop    %edi
  8024b1:	5d                   	pop    %ebp
  8024b2:	c3                   	ret    
  8024b3:	90                   	nop
  8024b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 f8                	mov    %edi,%eax
  8024ba:	f7 f1                	div    %ecx
  8024bc:	31 d2                	xor    %edx,%edx
  8024be:	83 c4 0c             	add    $0xc,%esp
  8024c1:	5e                   	pop    %esi
  8024c2:	5f                   	pop    %edi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    
  8024c5:	8d 76 00             	lea    0x0(%esi),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	8b 3c 24             	mov    (%esp),%edi
  8024cd:	d3 e0                	shl    %cl,%eax
  8024cf:	89 c6                	mov    %eax,%esi
  8024d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024d6:	29 e8                	sub    %ebp,%eax
  8024d8:	89 c1                	mov    %eax,%ecx
  8024da:	d3 ef                	shr    %cl,%edi
  8024dc:	89 e9                	mov    %ebp,%ecx
  8024de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024e2:	8b 3c 24             	mov    (%esp),%edi
  8024e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024e9:	89 d6                	mov    %edx,%esi
  8024eb:	d3 e7                	shl    %cl,%edi
  8024ed:	89 c1                	mov    %eax,%ecx
  8024ef:	89 3c 24             	mov    %edi,(%esp)
  8024f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024f6:	d3 ee                	shr    %cl,%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	d3 e2                	shl    %cl,%edx
  8024fc:	89 c1                	mov    %eax,%ecx
  8024fe:	d3 ef                	shr    %cl,%edi
  802500:	09 d7                	or     %edx,%edi
  802502:	89 f2                	mov    %esi,%edx
  802504:	89 f8                	mov    %edi,%eax
  802506:	f7 74 24 08          	divl   0x8(%esp)
  80250a:	89 d6                	mov    %edx,%esi
  80250c:	89 c7                	mov    %eax,%edi
  80250e:	f7 24 24             	mull   (%esp)
  802511:	39 d6                	cmp    %edx,%esi
  802513:	89 14 24             	mov    %edx,(%esp)
  802516:	72 30                	jb     802548 <__udivdi3+0x118>
  802518:	8b 54 24 04          	mov    0x4(%esp),%edx
  80251c:	89 e9                	mov    %ebp,%ecx
  80251e:	d3 e2                	shl    %cl,%edx
  802520:	39 c2                	cmp    %eax,%edx
  802522:	73 05                	jae    802529 <__udivdi3+0xf9>
  802524:	3b 34 24             	cmp    (%esp),%esi
  802527:	74 1f                	je     802548 <__udivdi3+0x118>
  802529:	89 f8                	mov    %edi,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	e9 7a ff ff ff       	jmp    8024ac <__udivdi3+0x7c>
  802532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802538:	31 d2                	xor    %edx,%edx
  80253a:	b8 01 00 00 00       	mov    $0x1,%eax
  80253f:	e9 68 ff ff ff       	jmp    8024ac <__udivdi3+0x7c>
  802544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802548:	8d 47 ff             	lea    -0x1(%edi),%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	83 c4 0c             	add    $0xc,%esp
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
  802554:	66 90                	xchg   %ax,%ax
  802556:	66 90                	xchg   %ax,%ax
  802558:	66 90                	xchg   %ax,%ax
  80255a:	66 90                	xchg   %ax,%ax
  80255c:	66 90                	xchg   %ax,%ax
  80255e:	66 90                	xchg   %ax,%ax

00802560 <__umoddi3>:
  802560:	55                   	push   %ebp
  802561:	57                   	push   %edi
  802562:	56                   	push   %esi
  802563:	83 ec 14             	sub    $0x14,%esp
  802566:	8b 44 24 28          	mov    0x28(%esp),%eax
  80256a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80256e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802572:	89 c7                	mov    %eax,%edi
  802574:	89 44 24 04          	mov    %eax,0x4(%esp)
  802578:	8b 44 24 30          	mov    0x30(%esp),%eax
  80257c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802580:	89 34 24             	mov    %esi,(%esp)
  802583:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802587:	85 c0                	test   %eax,%eax
  802589:	89 c2                	mov    %eax,%edx
  80258b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258f:	75 17                	jne    8025a8 <__umoddi3+0x48>
  802591:	39 fe                	cmp    %edi,%esi
  802593:	76 4b                	jbe    8025e0 <__umoddi3+0x80>
  802595:	89 c8                	mov    %ecx,%eax
  802597:	89 fa                	mov    %edi,%edx
  802599:	f7 f6                	div    %esi
  80259b:	89 d0                	mov    %edx,%eax
  80259d:	31 d2                	xor    %edx,%edx
  80259f:	83 c4 14             	add    $0x14,%esp
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	66 90                	xchg   %ax,%ax
  8025a8:	39 f8                	cmp    %edi,%eax
  8025aa:	77 54                	ja     802600 <__umoddi3+0xa0>
  8025ac:	0f bd e8             	bsr    %eax,%ebp
  8025af:	83 f5 1f             	xor    $0x1f,%ebp
  8025b2:	75 5c                	jne    802610 <__umoddi3+0xb0>
  8025b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025b8:	39 3c 24             	cmp    %edi,(%esp)
  8025bb:	0f 87 e7 00 00 00    	ja     8026a8 <__umoddi3+0x148>
  8025c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025c5:	29 f1                	sub    %esi,%ecx
  8025c7:	19 c7                	sbb    %eax,%edi
  8025c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025d9:	83 c4 14             	add    $0x14,%esp
  8025dc:	5e                   	pop    %esi
  8025dd:	5f                   	pop    %edi
  8025de:	5d                   	pop    %ebp
  8025df:	c3                   	ret    
  8025e0:	85 f6                	test   %esi,%esi
  8025e2:	89 f5                	mov    %esi,%ebp
  8025e4:	75 0b                	jne    8025f1 <__umoddi3+0x91>
  8025e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	f7 f6                	div    %esi
  8025ef:	89 c5                	mov    %eax,%ebp
  8025f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025f5:	31 d2                	xor    %edx,%edx
  8025f7:	f7 f5                	div    %ebp
  8025f9:	89 c8                	mov    %ecx,%eax
  8025fb:	f7 f5                	div    %ebp
  8025fd:	eb 9c                	jmp    80259b <__umoddi3+0x3b>
  8025ff:	90                   	nop
  802600:	89 c8                	mov    %ecx,%eax
  802602:	89 fa                	mov    %edi,%edx
  802604:	83 c4 14             	add    $0x14,%esp
  802607:	5e                   	pop    %esi
  802608:	5f                   	pop    %edi
  802609:	5d                   	pop    %ebp
  80260a:	c3                   	ret    
  80260b:	90                   	nop
  80260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802610:	8b 04 24             	mov    (%esp),%eax
  802613:	be 20 00 00 00       	mov    $0x20,%esi
  802618:	89 e9                	mov    %ebp,%ecx
  80261a:	29 ee                	sub    %ebp,%esi
  80261c:	d3 e2                	shl    %cl,%edx
  80261e:	89 f1                	mov    %esi,%ecx
  802620:	d3 e8                	shr    %cl,%eax
  802622:	89 e9                	mov    %ebp,%ecx
  802624:	89 44 24 04          	mov    %eax,0x4(%esp)
  802628:	8b 04 24             	mov    (%esp),%eax
  80262b:	09 54 24 04          	or     %edx,0x4(%esp)
  80262f:	89 fa                	mov    %edi,%edx
  802631:	d3 e0                	shl    %cl,%eax
  802633:	89 f1                	mov    %esi,%ecx
  802635:	89 44 24 08          	mov    %eax,0x8(%esp)
  802639:	8b 44 24 10          	mov    0x10(%esp),%eax
  80263d:	d3 ea                	shr    %cl,%edx
  80263f:	89 e9                	mov    %ebp,%ecx
  802641:	d3 e7                	shl    %cl,%edi
  802643:	89 f1                	mov    %esi,%ecx
  802645:	d3 e8                	shr    %cl,%eax
  802647:	89 e9                	mov    %ebp,%ecx
  802649:	09 f8                	or     %edi,%eax
  80264b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80264f:	f7 74 24 04          	divl   0x4(%esp)
  802653:	d3 e7                	shl    %cl,%edi
  802655:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802659:	89 d7                	mov    %edx,%edi
  80265b:	f7 64 24 08          	mull   0x8(%esp)
  80265f:	39 d7                	cmp    %edx,%edi
  802661:	89 c1                	mov    %eax,%ecx
  802663:	89 14 24             	mov    %edx,(%esp)
  802666:	72 2c                	jb     802694 <__umoddi3+0x134>
  802668:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80266c:	72 22                	jb     802690 <__umoddi3+0x130>
  80266e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802672:	29 c8                	sub    %ecx,%eax
  802674:	19 d7                	sbb    %edx,%edi
  802676:	89 e9                	mov    %ebp,%ecx
  802678:	89 fa                	mov    %edi,%edx
  80267a:	d3 e8                	shr    %cl,%eax
  80267c:	89 f1                	mov    %esi,%ecx
  80267e:	d3 e2                	shl    %cl,%edx
  802680:	89 e9                	mov    %ebp,%ecx
  802682:	d3 ef                	shr    %cl,%edi
  802684:	09 d0                	or     %edx,%eax
  802686:	89 fa                	mov    %edi,%edx
  802688:	83 c4 14             	add    $0x14,%esp
  80268b:	5e                   	pop    %esi
  80268c:	5f                   	pop    %edi
  80268d:	5d                   	pop    %ebp
  80268e:	c3                   	ret    
  80268f:	90                   	nop
  802690:	39 d7                	cmp    %edx,%edi
  802692:	75 da                	jne    80266e <__umoddi3+0x10e>
  802694:	8b 14 24             	mov    (%esp),%edx
  802697:	89 c1                	mov    %eax,%ecx
  802699:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80269d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026a1:	eb cb                	jmp    80266e <__umoddi3+0x10e>
  8026a3:	90                   	nop
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026ac:	0f 82 0f ff ff ff    	jb     8025c1 <__umoddi3+0x61>
  8026b2:	e9 1a ff ff ff       	jmp    8025d1 <__umoddi3+0x71>
