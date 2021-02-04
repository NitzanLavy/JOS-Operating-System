
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	a1 00 00 10 f0       	mov    0xf0100000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 c0 26 80 00 	movl   $0x8026c0,(%esp)
  800049:	e8 0a 01 00 00       	call   800158 <cprintf>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	56                   	push   %esi
  800054:	53                   	push   %ebx
  800055:	83 ec 10             	sub    $0x10,%esp
  800058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  80005e:	e8 02 0b 00 00       	call   800b65 <sys_getenvid>
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	89 c2                	mov    %eax,%edx
  80006a:	c1 e2 07             	shl    $0x7,%edx
  80006d:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800074:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800079:	85 db                	test   %ebx,%ebx
  80007b:	7e 07                	jle    800084 <libmain+0x34>
		binaryname = argv[0];
  80007d:	8b 06                	mov    (%esi),%eax
  80007f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800084:	89 74 24 04          	mov    %esi,0x4(%esp)
  800088:	89 1c 24             	mov    %ebx,(%esp)
  80008b:	e8 a3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800090:	e8 07 00 00 00       	call   80009c <exit>
}
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	5b                   	pop    %ebx
  800099:	5e                   	pop    %esi
  80009a:	5d                   	pop    %ebp
  80009b:	c3                   	ret    

0080009c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009c:	55                   	push   %ebp
  80009d:	89 e5                	mov    %esp,%ebp
  80009f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000a2:	e8 03 11 00 00       	call   8011aa <close_all>
	sys_env_destroy(0);
  8000a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ae:	e8 60 0a 00 00       	call   800b13 <sys_env_destroy>
}
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	53                   	push   %ebx
  8000b9:	83 ec 14             	sub    $0x14,%esp
  8000bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000bf:	8b 13                	mov    (%ebx),%edx
  8000c1:	8d 42 01             	lea    0x1(%edx),%eax
  8000c4:	89 03                	mov    %eax,(%ebx)
  8000c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d2:	75 19                	jne    8000ed <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000d4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000db:	00 
  8000dc:	8d 43 08             	lea    0x8(%ebx),%eax
  8000df:	89 04 24             	mov    %eax,(%esp)
  8000e2:	e8 ef 09 00 00       	call   800ad6 <sys_cputs>
		b->idx = 0;
  8000e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8000ed:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f1:	83 c4 14             	add    $0x14,%esp
  8000f4:	5b                   	pop    %ebx
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800100:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800107:	00 00 00 
	b.cnt = 0;
  80010a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800111:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800114:	8b 45 0c             	mov    0xc(%ebp),%eax
  800117:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80011b:	8b 45 08             	mov    0x8(%ebp),%eax
  80011e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800122:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012c:	c7 04 24 b5 00 80 00 	movl   $0x8000b5,(%esp)
  800133:	e8 b6 01 00 00       	call   8002ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800138:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80013e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800142:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800148:	89 04 24             	mov    %eax,(%esp)
  80014b:	e8 86 09 00 00       	call   800ad6 <sys_cputs>

	return b.cnt;
}
  800150:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800161:	89 44 24 04          	mov    %eax,0x4(%esp)
  800165:	8b 45 08             	mov    0x8(%ebp),%eax
  800168:	89 04 24             	mov    %eax,(%esp)
  80016b:	e8 87 ff ff ff       	call   8000f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800170:	c9                   	leave  
  800171:	c3                   	ret    
  800172:	66 90                	xchg   %ax,%ax
  800174:	66 90                	xchg   %ax,%ax
  800176:	66 90                	xchg   %ax,%ax
  800178:	66 90                	xchg   %ax,%ax
  80017a:	66 90                	xchg   %ax,%ax
  80017c:	66 90                	xchg   %ax,%ax
  80017e:	66 90                	xchg   %ax,%ax

00800180 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 3c             	sub    $0x3c,%esp
  800189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80018c:	89 d7                	mov    %edx,%edi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800194:	8b 45 0c             	mov    0xc(%ebp),%eax
  800197:	89 c3                	mov    %eax,%ebx
  800199:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ad:	39 d9                	cmp    %ebx,%ecx
  8001af:	72 05                	jb     8001b6 <printnum+0x36>
  8001b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001b4:	77 69                	ja     80021f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001bd:	83 ee 01             	sub    $0x1,%esi
  8001c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8001d0:	89 c3                	mov    %eax,%ebx
  8001d2:	89 d6                	mov    %edx,%esi
  8001d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8001da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8001e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e5:	89 04 24             	mov    %eax,(%esp)
  8001e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ef:	e8 2c 22 00 00       	call   802420 <__udivdi3>
  8001f4:	89 d9                	mov    %ebx,%ecx
  8001f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8001fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001fe:	89 04 24             	mov    %eax,(%esp)
  800201:	89 54 24 04          	mov    %edx,0x4(%esp)
  800205:	89 fa                	mov    %edi,%edx
  800207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020a:	e8 71 ff ff ff       	call   800180 <printnum>
  80020f:	eb 1b                	jmp    80022c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800211:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800215:	8b 45 18             	mov    0x18(%ebp),%eax
  800218:	89 04 24             	mov    %eax,(%esp)
  80021b:	ff d3                	call   *%ebx
  80021d:	eb 03                	jmp    800222 <printnum+0xa2>
  80021f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800222:	83 ee 01             	sub    $0x1,%esi
  800225:	85 f6                	test   %esi,%esi
  800227:	7f e8                	jg     800211 <printnum+0x91>
  800229:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800230:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800237:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80023a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800242:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80024b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024f:	e8 fc 22 00 00       	call   802550 <__umoddi3>
  800254:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800258:	0f be 80 f1 26 80 00 	movsbl 0x8026f1(%eax),%eax
  80025f:	89 04 24             	mov    %eax,(%esp)
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	ff d0                	call   *%eax
}
  800267:	83 c4 3c             	add    $0x3c,%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5e                   	pop    %esi
  80026c:	5f                   	pop    %edi
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800272:	83 fa 01             	cmp    $0x1,%edx
  800275:	7e 0e                	jle    800285 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800277:	8b 10                	mov    (%eax),%edx
  800279:	8d 4a 08             	lea    0x8(%edx),%ecx
  80027c:	89 08                	mov    %ecx,(%eax)
  80027e:	8b 02                	mov    (%edx),%eax
  800280:	8b 52 04             	mov    0x4(%edx),%edx
  800283:	eb 22                	jmp    8002a7 <getuint+0x38>
	else if (lflag)
  800285:	85 d2                	test   %edx,%edx
  800287:	74 10                	je     800299 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800289:	8b 10                	mov    (%eax),%edx
  80028b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028e:	89 08                	mov    %ecx,(%eax)
  800290:	8b 02                	mov    (%edx),%eax
  800292:	ba 00 00 00 00       	mov    $0x0,%edx
  800297:	eb 0e                	jmp    8002a7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800299:	8b 10                	mov    (%eax),%edx
  80029b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029e:	89 08                	mov    %ecx,(%eax)
  8002a0:	8b 02                	mov    (%edx),%eax
  8002a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b8:	73 0a                	jae    8002c4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002bd:	89 08                	mov    %ecx,(%eax)
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	88 02                	mov    %al,(%edx)
}
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	89 04 24             	mov    %eax,(%esp)
  8002e7:	e8 02 00 00 00       	call   8002ee <vprintfmt>
	va_end(ap);
}
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	57                   	push   %edi
  8002f2:	56                   	push   %esi
  8002f3:	53                   	push   %ebx
  8002f4:	83 ec 3c             	sub    $0x3c,%esp
  8002f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fd:	eb 14                	jmp    800313 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002ff:	85 c0                	test   %eax,%eax
  800301:	0f 84 b3 03 00 00    	je     8006ba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800307:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80030b:	89 04 24             	mov    %eax,(%esp)
  80030e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800311:	89 f3                	mov    %esi,%ebx
  800313:	8d 73 01             	lea    0x1(%ebx),%esi
  800316:	0f b6 03             	movzbl (%ebx),%eax
  800319:	83 f8 25             	cmp    $0x25,%eax
  80031c:	75 e1                	jne    8002ff <vprintfmt+0x11>
  80031e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800322:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800329:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800330:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800337:	ba 00 00 00 00       	mov    $0x0,%edx
  80033c:	eb 1d                	jmp    80035b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80033e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800340:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800344:	eb 15                	jmp    80035b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800346:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800348:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80034c:	eb 0d                	jmp    80035b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80034e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800351:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800354:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80035b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80035e:	0f b6 0e             	movzbl (%esi),%ecx
  800361:	0f b6 c1             	movzbl %cl,%eax
  800364:	83 e9 23             	sub    $0x23,%ecx
  800367:	80 f9 55             	cmp    $0x55,%cl
  80036a:	0f 87 2a 03 00 00    	ja     80069a <vprintfmt+0x3ac>
  800370:	0f b6 c9             	movzbl %cl,%ecx
  800373:	ff 24 8d 60 28 80 00 	jmp    *0x802860(,%ecx,4)
  80037a:	89 de                	mov    %ebx,%esi
  80037c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800381:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800384:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800388:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80038b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80038e:	83 fb 09             	cmp    $0x9,%ebx
  800391:	77 36                	ja     8003c9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800393:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800396:	eb e9                	jmp    800381 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800398:	8b 45 14             	mov    0x14(%ebp),%eax
  80039b:	8d 48 04             	lea    0x4(%eax),%ecx
  80039e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003a8:	eb 22                	jmp    8003cc <vprintfmt+0xde>
  8003aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ad:	85 c9                	test   %ecx,%ecx
  8003af:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b4:	0f 49 c1             	cmovns %ecx,%eax
  8003b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	89 de                	mov    %ebx,%esi
  8003bc:	eb 9d                	jmp    80035b <vprintfmt+0x6d>
  8003be:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003c0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8003c7:	eb 92                	jmp    80035b <vprintfmt+0x6d>
  8003c9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8003cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8003d0:	79 89                	jns    80035b <vprintfmt+0x6d>
  8003d2:	e9 77 ff ff ff       	jmp    80034e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003d7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003dc:	e9 7a ff ff ff       	jmp    80035b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8d 50 04             	lea    0x4(%eax),%edx
  8003e7:	89 55 14             	mov    %edx,0x14(%ebp)
  8003ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ee:	8b 00                	mov    (%eax),%eax
  8003f0:	89 04 24             	mov    %eax,(%esp)
  8003f3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8003f6:	e9 18 ff ff ff       	jmp    800313 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8d 50 04             	lea    0x4(%eax),%edx
  800401:	89 55 14             	mov    %edx,0x14(%ebp)
  800404:	8b 00                	mov    (%eax),%eax
  800406:	99                   	cltd   
  800407:	31 d0                	xor    %edx,%eax
  800409:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040b:	83 f8 12             	cmp    $0x12,%eax
  80040e:	7f 0b                	jg     80041b <vprintfmt+0x12d>
  800410:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  800417:	85 d2                	test   %edx,%edx
  800419:	75 20                	jne    80043b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80041b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80041f:	c7 44 24 08 09 27 80 	movl   $0x802709,0x8(%esp)
  800426:	00 
  800427:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	89 04 24             	mov    %eax,(%esp)
  800431:	e8 90 fe ff ff       	call   8002c6 <printfmt>
  800436:	e9 d8 fe ff ff       	jmp    800313 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80043b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80043f:	c7 44 24 08 01 2b 80 	movl   $0x802b01,0x8(%esp)
  800446:	00 
  800447:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 04 24             	mov    %eax,(%esp)
  800451:	e8 70 fe ff ff       	call   8002c6 <printfmt>
  800456:	e9 b8 fe ff ff       	jmp    800313 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80045e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800461:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8d 50 04             	lea    0x4(%eax),%edx
  80046a:	89 55 14             	mov    %edx,0x14(%ebp)
  80046d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80046f:	85 f6                	test   %esi,%esi
  800471:	b8 02 27 80 00       	mov    $0x802702,%eax
  800476:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800479:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80047d:	0f 84 97 00 00 00    	je     80051a <vprintfmt+0x22c>
  800483:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800487:	0f 8e 9b 00 00 00    	jle    800528 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800491:	89 34 24             	mov    %esi,(%esp)
  800494:	e8 cf 02 00 00       	call   800768 <strnlen>
  800499:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80049c:	29 c2                	sub    %eax,%edx
  80049e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004b1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b3:	eb 0f                	jmp    8004c4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004bc:	89 04 24             	mov    %eax,(%esp)
  8004bf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c1:	83 eb 01             	sub    $0x1,%ebx
  8004c4:	85 db                	test   %ebx,%ebx
  8004c6:	7f ed                	jg     8004b5 <vprintfmt+0x1c7>
  8004c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004ce:	85 d2                	test   %edx,%edx
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d5:	0f 49 c2             	cmovns %edx,%eax
  8004d8:	29 c2                	sub    %eax,%edx
  8004da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8004dd:	89 d7                	mov    %edx,%edi
  8004df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004e2:	eb 50                	jmp    800534 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e8:	74 1e                	je     800508 <vprintfmt+0x21a>
  8004ea:	0f be d2             	movsbl %dl,%edx
  8004ed:	83 ea 20             	sub    $0x20,%edx
  8004f0:	83 fa 5e             	cmp    $0x5e,%edx
  8004f3:	76 13                	jbe    800508 <vprintfmt+0x21a>
					putch('?', putdat);
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800503:	ff 55 08             	call   *0x8(%ebp)
  800506:	eb 0d                	jmp    800515 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80050f:	89 04 24             	mov    %eax,(%esp)
  800512:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800515:	83 ef 01             	sub    $0x1,%edi
  800518:	eb 1a                	jmp    800534 <vprintfmt+0x246>
  80051a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80051d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800520:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800523:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800526:	eb 0c                	jmp    800534 <vprintfmt+0x246>
  800528:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80052b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80052e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800531:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800534:	83 c6 01             	add    $0x1,%esi
  800537:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80053b:	0f be c2             	movsbl %dl,%eax
  80053e:	85 c0                	test   %eax,%eax
  800540:	74 27                	je     800569 <vprintfmt+0x27b>
  800542:	85 db                	test   %ebx,%ebx
  800544:	78 9e                	js     8004e4 <vprintfmt+0x1f6>
  800546:	83 eb 01             	sub    $0x1,%ebx
  800549:	79 99                	jns    8004e4 <vprintfmt+0x1f6>
  80054b:	89 f8                	mov    %edi,%eax
  80054d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800550:	8b 75 08             	mov    0x8(%ebp),%esi
  800553:	89 c3                	mov    %eax,%ebx
  800555:	eb 1a                	jmp    800571 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800557:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800562:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800564:	83 eb 01             	sub    $0x1,%ebx
  800567:	eb 08                	jmp    800571 <vprintfmt+0x283>
  800569:	89 fb                	mov    %edi,%ebx
  80056b:	8b 75 08             	mov    0x8(%ebp),%esi
  80056e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800571:	85 db                	test   %ebx,%ebx
  800573:	7f e2                	jg     800557 <vprintfmt+0x269>
  800575:	89 75 08             	mov    %esi,0x8(%ebp)
  800578:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80057b:	e9 93 fd ff ff       	jmp    800313 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800580:	83 fa 01             	cmp    $0x1,%edx
  800583:	7e 16                	jle    80059b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 50 08             	lea    0x8(%eax),%edx
  80058b:	89 55 14             	mov    %edx,0x14(%ebp)
  80058e:	8b 50 04             	mov    0x4(%eax),%edx
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800596:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800599:	eb 32                	jmp    8005cd <vprintfmt+0x2df>
	else if (lflag)
  80059b:	85 d2                	test   %edx,%edx
  80059d:	74 18                	je     8005b7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8d 50 04             	lea    0x4(%eax),%edx
  8005a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a8:	8b 30                	mov    (%eax),%esi
  8005aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005ad:	89 f0                	mov    %esi,%eax
  8005af:	c1 f8 1f             	sar    $0x1f,%eax
  8005b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b5:	eb 16                	jmp    8005cd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 50 04             	lea    0x4(%eax),%edx
  8005bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c0:	8b 30                	mov    (%eax),%esi
  8005c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005c5:	89 f0                	mov    %esi,%eax
  8005c7:	c1 f8 1f             	sar    $0x1f,%eax
  8005ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005dc:	0f 89 80 00 00 00    	jns    800662 <vprintfmt+0x374>
				putch('-', putdat);
  8005e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005ed:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005f6:	f7 d8                	neg    %eax
  8005f8:	83 d2 00             	adc    $0x0,%edx
  8005fb:	f7 da                	neg    %edx
			}
			base = 10;
  8005fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800602:	eb 5e                	jmp    800662 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800604:	8d 45 14             	lea    0x14(%ebp),%eax
  800607:	e8 63 fc ff ff       	call   80026f <getuint>
			base = 10;
  80060c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800611:	eb 4f                	jmp    800662 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800613:	8d 45 14             	lea    0x14(%ebp),%eax
  800616:	e8 54 fc ff ff       	call   80026f <getuint>
			base = 8;
  80061b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800620:	eb 40                	jmp    800662 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800622:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800626:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80062d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800630:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800634:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80063b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 50 04             	lea    0x4(%eax),%edx
  800644:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800647:	8b 00                	mov    (%eax),%eax
  800649:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80064e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800653:	eb 0d                	jmp    800662 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800655:	8d 45 14             	lea    0x14(%ebp),%eax
  800658:	e8 12 fc ff ff       	call   80026f <getuint>
			base = 16;
  80065d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800662:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800666:	89 74 24 10          	mov    %esi,0x10(%esp)
  80066a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80066d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800671:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800675:	89 04 24             	mov    %eax,(%esp)
  800678:	89 54 24 04          	mov    %edx,0x4(%esp)
  80067c:	89 fa                	mov    %edi,%edx
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	e8 fa fa ff ff       	call   800180 <printnum>
			break;
  800686:	e9 88 fc ff ff       	jmp    800313 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80068b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80068f:	89 04 24             	mov    %eax,(%esp)
  800692:	ff 55 08             	call   *0x8(%ebp)
			break;
  800695:	e9 79 fc ff ff       	jmp    800313 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80069a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80069e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006a5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a8:	89 f3                	mov    %esi,%ebx
  8006aa:	eb 03                	jmp    8006af <vprintfmt+0x3c1>
  8006ac:	83 eb 01             	sub    $0x1,%ebx
  8006af:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006b3:	75 f7                	jne    8006ac <vprintfmt+0x3be>
  8006b5:	e9 59 fc ff ff       	jmp    800313 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006ba:	83 c4 3c             	add    $0x3c,%esp
  8006bd:	5b                   	pop    %ebx
  8006be:	5e                   	pop    %esi
  8006bf:	5f                   	pop    %edi
  8006c0:	5d                   	pop    %ebp
  8006c1:	c3                   	ret    

008006c2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 28             	sub    $0x28,%esp
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	74 30                	je     800713 <vsnprintf+0x51>
  8006e3:	85 d2                	test   %edx,%edx
  8006e5:	7e 2c                	jle    800713 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fc:	c7 04 24 a9 02 80 00 	movl   $0x8002a9,(%esp)
  800703:	e8 e6 fb ff ff       	call   8002ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80070e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800711:	eb 05                	jmp    800718 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800713:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800720:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800723:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800727:	8b 45 10             	mov    0x10(%ebp),%eax
  80072a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80072e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800731:	89 44 24 04          	mov    %eax,0x4(%esp)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	89 04 24             	mov    %eax,(%esp)
  80073b:	e8 82 ff ff ff       	call   8006c2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800740:	c9                   	leave  
  800741:	c3                   	ret    
  800742:	66 90                	xchg   %ax,%ax
  800744:	66 90                	xchg   %ax,%ax
  800746:	66 90                	xchg   %ax,%ax
  800748:	66 90                	xchg   %ax,%ax
  80074a:	66 90                	xchg   %ax,%ax
  80074c:	66 90                	xchg   %ax,%ax
  80074e:	66 90                	xchg   %ax,%ax

00800750 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800756:	b8 00 00 00 00       	mov    $0x0,%eax
  80075b:	eb 03                	jmp    800760 <strlen+0x10>
		n++;
  80075d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800760:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800764:	75 f7                	jne    80075d <strlen+0xd>
		n++;
	return n;
}
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800771:	b8 00 00 00 00       	mov    $0x0,%eax
  800776:	eb 03                	jmp    80077b <strnlen+0x13>
		n++;
  800778:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077b:	39 d0                	cmp    %edx,%eax
  80077d:	74 06                	je     800785 <strnlen+0x1d>
  80077f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800783:	75 f3                	jne    800778 <strnlen+0x10>
		n++;
	return n;
}
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    

00800787 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	53                   	push   %ebx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800791:	89 c2                	mov    %eax,%edx
  800793:	83 c2 01             	add    $0x1,%edx
  800796:	83 c1 01             	add    $0x1,%ecx
  800799:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80079d:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007a0:	84 db                	test   %bl,%bl
  8007a2:	75 ef                	jne    800793 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007a4:	5b                   	pop    %ebx
  8007a5:	5d                   	pop    %ebp
  8007a6:	c3                   	ret    

008007a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	53                   	push   %ebx
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b1:	89 1c 24             	mov    %ebx,(%esp)
  8007b4:	e8 97 ff ff ff       	call   800750 <strlen>
	strcpy(dst + len, src);
  8007b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007c0:	01 d8                	add    %ebx,%eax
  8007c2:	89 04 24             	mov    %eax,(%esp)
  8007c5:	e8 bd ff ff ff       	call   800787 <strcpy>
	return dst;
}
  8007ca:	89 d8                	mov    %ebx,%eax
  8007cc:	83 c4 08             	add    $0x8,%esp
  8007cf:	5b                   	pop    %ebx
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	56                   	push   %esi
  8007d6:	53                   	push   %ebx
  8007d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007dd:	89 f3                	mov    %esi,%ebx
  8007df:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e2:	89 f2                	mov    %esi,%edx
  8007e4:	eb 0f                	jmp    8007f5 <strncpy+0x23>
		*dst++ = *src;
  8007e6:	83 c2 01             	add    $0x1,%edx
  8007e9:	0f b6 01             	movzbl (%ecx),%eax
  8007ec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ef:	80 39 01             	cmpb   $0x1,(%ecx)
  8007f2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f5:	39 da                	cmp    %ebx,%edx
  8007f7:	75 ed                	jne    8007e6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007f9:	89 f0                	mov    %esi,%eax
  8007fb:	5b                   	pop    %ebx
  8007fc:	5e                   	pop    %esi
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	56                   	push   %esi
  800803:	53                   	push   %ebx
  800804:	8b 75 08             	mov    0x8(%ebp),%esi
  800807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80080d:	89 f0                	mov    %esi,%eax
  80080f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800813:	85 c9                	test   %ecx,%ecx
  800815:	75 0b                	jne    800822 <strlcpy+0x23>
  800817:	eb 1d                	jmp    800836 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800819:	83 c0 01             	add    $0x1,%eax
  80081c:	83 c2 01             	add    $0x1,%edx
  80081f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800822:	39 d8                	cmp    %ebx,%eax
  800824:	74 0b                	je     800831 <strlcpy+0x32>
  800826:	0f b6 0a             	movzbl (%edx),%ecx
  800829:	84 c9                	test   %cl,%cl
  80082b:	75 ec                	jne    800819 <strlcpy+0x1a>
  80082d:	89 c2                	mov    %eax,%edx
  80082f:	eb 02                	jmp    800833 <strlcpy+0x34>
  800831:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800833:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800836:	29 f0                	sub    %esi,%eax
}
  800838:	5b                   	pop    %ebx
  800839:	5e                   	pop    %esi
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800845:	eb 06                	jmp    80084d <strcmp+0x11>
		p++, q++;
  800847:	83 c1 01             	add    $0x1,%ecx
  80084a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80084d:	0f b6 01             	movzbl (%ecx),%eax
  800850:	84 c0                	test   %al,%al
  800852:	74 04                	je     800858 <strcmp+0x1c>
  800854:	3a 02                	cmp    (%edx),%al
  800856:	74 ef                	je     800847 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800858:	0f b6 c0             	movzbl %al,%eax
  80085b:	0f b6 12             	movzbl (%edx),%edx
  80085e:	29 d0                	sub    %edx,%eax
}
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	53                   	push   %ebx
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086c:	89 c3                	mov    %eax,%ebx
  80086e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800871:	eb 06                	jmp    800879 <strncmp+0x17>
		n--, p++, q++;
  800873:	83 c0 01             	add    $0x1,%eax
  800876:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800879:	39 d8                	cmp    %ebx,%eax
  80087b:	74 15                	je     800892 <strncmp+0x30>
  80087d:	0f b6 08             	movzbl (%eax),%ecx
  800880:	84 c9                	test   %cl,%cl
  800882:	74 04                	je     800888 <strncmp+0x26>
  800884:	3a 0a                	cmp    (%edx),%cl
  800886:	74 eb                	je     800873 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800888:	0f b6 00             	movzbl (%eax),%eax
  80088b:	0f b6 12             	movzbl (%edx),%edx
  80088e:	29 d0                	sub    %edx,%eax
  800890:	eb 05                	jmp    800897 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800892:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800897:	5b                   	pop    %ebx
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a4:	eb 07                	jmp    8008ad <strchr+0x13>
		if (*s == c)
  8008a6:	38 ca                	cmp    %cl,%dl
  8008a8:	74 0f                	je     8008b9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008aa:	83 c0 01             	add    $0x1,%eax
  8008ad:	0f b6 10             	movzbl (%eax),%edx
  8008b0:	84 d2                	test   %dl,%dl
  8008b2:	75 f2                	jne    8008a6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c5:	eb 07                	jmp    8008ce <strfind+0x13>
		if (*s == c)
  8008c7:	38 ca                	cmp    %cl,%dl
  8008c9:	74 0a                	je     8008d5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008cb:	83 c0 01             	add    $0x1,%eax
  8008ce:	0f b6 10             	movzbl (%eax),%edx
  8008d1:	84 d2                	test   %dl,%dl
  8008d3:	75 f2                	jne    8008c7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	57                   	push   %edi
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e3:	85 c9                	test   %ecx,%ecx
  8008e5:	74 36                	je     80091d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008ed:	75 28                	jne    800917 <memset+0x40>
  8008ef:	f6 c1 03             	test   $0x3,%cl
  8008f2:	75 23                	jne    800917 <memset+0x40>
		c &= 0xFF;
  8008f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008f8:	89 d3                	mov    %edx,%ebx
  8008fa:	c1 e3 08             	shl    $0x8,%ebx
  8008fd:	89 d6                	mov    %edx,%esi
  8008ff:	c1 e6 18             	shl    $0x18,%esi
  800902:	89 d0                	mov    %edx,%eax
  800904:	c1 e0 10             	shl    $0x10,%eax
  800907:	09 f0                	or     %esi,%eax
  800909:	09 c2                	or     %eax,%edx
  80090b:	89 d0                	mov    %edx,%eax
  80090d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80090f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800912:	fc                   	cld    
  800913:	f3 ab                	rep stos %eax,%es:(%edi)
  800915:	eb 06                	jmp    80091d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091a:	fc                   	cld    
  80091b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80091d:	89 f8                	mov    %edi,%eax
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5f                   	pop    %edi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	57                   	push   %edi
  800928:	56                   	push   %esi
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800932:	39 c6                	cmp    %eax,%esi
  800934:	73 35                	jae    80096b <memmove+0x47>
  800936:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800939:	39 d0                	cmp    %edx,%eax
  80093b:	73 2e                	jae    80096b <memmove+0x47>
		s += n;
		d += n;
  80093d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800940:	89 d6                	mov    %edx,%esi
  800942:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800944:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80094a:	75 13                	jne    80095f <memmove+0x3b>
  80094c:	f6 c1 03             	test   $0x3,%cl
  80094f:	75 0e                	jne    80095f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800951:	83 ef 04             	sub    $0x4,%edi
  800954:	8d 72 fc             	lea    -0x4(%edx),%esi
  800957:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80095a:	fd                   	std    
  80095b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80095d:	eb 09                	jmp    800968 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80095f:	83 ef 01             	sub    $0x1,%edi
  800962:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800965:	fd                   	std    
  800966:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800968:	fc                   	cld    
  800969:	eb 1d                	jmp    800988 <memmove+0x64>
  80096b:	89 f2                	mov    %esi,%edx
  80096d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096f:	f6 c2 03             	test   $0x3,%dl
  800972:	75 0f                	jne    800983 <memmove+0x5f>
  800974:	f6 c1 03             	test   $0x3,%cl
  800977:	75 0a                	jne    800983 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800979:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80097c:	89 c7                	mov    %eax,%edi
  80097e:	fc                   	cld    
  80097f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800981:	eb 05                	jmp    800988 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800983:	89 c7                	mov    %eax,%edi
  800985:	fc                   	cld    
  800986:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800988:	5e                   	pop    %esi
  800989:	5f                   	pop    %edi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800992:	8b 45 10             	mov    0x10(%ebp),%eax
  800995:	89 44 24 08          	mov    %eax,0x8(%esp)
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	89 04 24             	mov    %eax,(%esp)
  8009a6:	e8 79 ff ff ff       	call   800924 <memmove>
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	56                   	push   %esi
  8009b1:	53                   	push   %ebx
  8009b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b8:	89 d6                	mov    %edx,%esi
  8009ba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009bd:	eb 1a                	jmp    8009d9 <memcmp+0x2c>
		if (*s1 != *s2)
  8009bf:	0f b6 02             	movzbl (%edx),%eax
  8009c2:	0f b6 19             	movzbl (%ecx),%ebx
  8009c5:	38 d8                	cmp    %bl,%al
  8009c7:	74 0a                	je     8009d3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009c9:	0f b6 c0             	movzbl %al,%eax
  8009cc:	0f b6 db             	movzbl %bl,%ebx
  8009cf:	29 d8                	sub    %ebx,%eax
  8009d1:	eb 0f                	jmp    8009e2 <memcmp+0x35>
		s1++, s2++;
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009d9:	39 f2                	cmp    %esi,%edx
  8009db:	75 e2                	jne    8009bf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ef:	89 c2                	mov    %eax,%edx
  8009f1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f4:	eb 07                	jmp    8009fd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009f6:	38 08                	cmp    %cl,(%eax)
  8009f8:	74 07                	je     800a01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	39 d0                	cmp    %edx,%eax
  8009ff:	72 f5                	jb     8009f6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	57                   	push   %edi
  800a07:	56                   	push   %esi
  800a08:	53                   	push   %ebx
  800a09:	8b 55 08             	mov    0x8(%ebp),%edx
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a0f:	eb 03                	jmp    800a14 <strtol+0x11>
		s++;
  800a11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a14:	0f b6 0a             	movzbl (%edx),%ecx
  800a17:	80 f9 09             	cmp    $0x9,%cl
  800a1a:	74 f5                	je     800a11 <strtol+0xe>
  800a1c:	80 f9 20             	cmp    $0x20,%cl
  800a1f:	74 f0                	je     800a11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a21:	80 f9 2b             	cmp    $0x2b,%cl
  800a24:	75 0a                	jne    800a30 <strtol+0x2d>
		s++;
  800a26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a29:	bf 00 00 00 00       	mov    $0x0,%edi
  800a2e:	eb 11                	jmp    800a41 <strtol+0x3e>
  800a30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a35:	80 f9 2d             	cmp    $0x2d,%cl
  800a38:	75 07                	jne    800a41 <strtol+0x3e>
		s++, neg = 1;
  800a3a:	8d 52 01             	lea    0x1(%edx),%edx
  800a3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a46:	75 15                	jne    800a5d <strtol+0x5a>
  800a48:	80 3a 30             	cmpb   $0x30,(%edx)
  800a4b:	75 10                	jne    800a5d <strtol+0x5a>
  800a4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a51:	75 0a                	jne    800a5d <strtol+0x5a>
		s += 2, base = 16;
  800a53:	83 c2 02             	add    $0x2,%edx
  800a56:	b8 10 00 00 00       	mov    $0x10,%eax
  800a5b:	eb 10                	jmp    800a6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	75 0c                	jne    800a6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a63:	80 3a 30             	cmpb   $0x30,(%edx)
  800a66:	75 05                	jne    800a6d <strtol+0x6a>
		s++, base = 8;
  800a68:	83 c2 01             	add    $0x1,%edx
  800a6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800a6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a75:	0f b6 0a             	movzbl (%edx),%ecx
  800a78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800a7b:	89 f0                	mov    %esi,%eax
  800a7d:	3c 09                	cmp    $0x9,%al
  800a7f:	77 08                	ja     800a89 <strtol+0x86>
			dig = *s - '0';
  800a81:	0f be c9             	movsbl %cl,%ecx
  800a84:	83 e9 30             	sub    $0x30,%ecx
  800a87:	eb 20                	jmp    800aa9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800a89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800a8c:	89 f0                	mov    %esi,%eax
  800a8e:	3c 19                	cmp    $0x19,%al
  800a90:	77 08                	ja     800a9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800a92:	0f be c9             	movsbl %cl,%ecx
  800a95:	83 e9 57             	sub    $0x57,%ecx
  800a98:	eb 0f                	jmp    800aa9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800a9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800a9d:	89 f0                	mov    %esi,%eax
  800a9f:	3c 19                	cmp    $0x19,%al
  800aa1:	77 16                	ja     800ab9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800aa3:	0f be c9             	movsbl %cl,%ecx
  800aa6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800aa9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800aac:	7d 0f                	jge    800abd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800aae:	83 c2 01             	add    $0x1,%edx
  800ab1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ab5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ab7:	eb bc                	jmp    800a75 <strtol+0x72>
  800ab9:	89 d8                	mov    %ebx,%eax
  800abb:	eb 02                	jmp    800abf <strtol+0xbc>
  800abd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac3:	74 05                	je     800aca <strtol+0xc7>
		*endptr = (char *) s;
  800ac5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800aca:	f7 d8                	neg    %eax
  800acc:	85 ff                	test   %edi,%edi
  800ace:	0f 44 c3             	cmove  %ebx,%eax
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800adc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae7:	89 c3                	mov    %eax,%ebx
  800ae9:	89 c7                	mov    %eax,%edi
  800aeb:	89 c6                	mov    %eax,%esi
  800aed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800afa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aff:	b8 01 00 00 00       	mov    $0x1,%eax
  800b04:	89 d1                	mov    %edx,%ecx
  800b06:	89 d3                	mov    %edx,%ebx
  800b08:	89 d7                	mov    %edx,%edi
  800b0a:	89 d6                	mov    %edx,%esi
  800b0c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b0e:	5b                   	pop    %ebx
  800b0f:	5e                   	pop    %esi
  800b10:	5f                   	pop    %edi
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b21:	b8 03 00 00 00       	mov    $0x3,%eax
  800b26:	8b 55 08             	mov    0x8(%ebp),%edx
  800b29:	89 cb                	mov    %ecx,%ebx
  800b2b:	89 cf                	mov    %ecx,%edi
  800b2d:	89 ce                	mov    %ecx,%esi
  800b2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800b31:	85 c0                	test   %eax,%eax
  800b33:	7e 28                	jle    800b5d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b39:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b40:	00 
  800b41:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800b48:	00 
  800b49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b50:	00 
  800b51:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800b58:	e8 29 17 00 00       	call   802286 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b5d:	83 c4 2c             	add    $0x2c,%esp
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5f                   	pop    %edi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	57                   	push   %edi
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b70:	b8 02 00 00 00       	mov    $0x2,%eax
  800b75:	89 d1                	mov    %edx,%ecx
  800b77:	89 d3                	mov    %edx,%ebx
  800b79:	89 d7                	mov    %edx,%edi
  800b7b:	89 d6                	mov    %edx,%esi
  800b7d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <sys_yield>:

void
sys_yield(void)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bac:	be 00 00 00 00       	mov    $0x0,%esi
  800bb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bbf:	89 f7                	mov    %esi,%edi
  800bc1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bc3:	85 c0                	test   %eax,%eax
  800bc5:	7e 28                	jle    800bef <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bcb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800bd2:	00 
  800bd3:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800bda:	00 
  800bdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800be2:	00 
  800be3:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800bea:	e8 97 16 00 00       	call   802286 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bef:	83 c4 2c             	add    $0x2c,%esp
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c00:	b8 05 00 00 00       	mov    $0x5,%eax
  800c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c11:	8b 75 18             	mov    0x18(%ebp),%esi
  800c14:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c16:	85 c0                	test   %eax,%eax
  800c18:	7e 28                	jle    800c42 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c1e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c25:	00 
  800c26:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800c2d:	00 
  800c2e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c35:	00 
  800c36:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800c3d:	e8 44 16 00 00       	call   802286 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c42:	83 c4 2c             	add    $0x2c,%esp
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c58:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c60:	8b 55 08             	mov    0x8(%ebp),%edx
  800c63:	89 df                	mov    %ebx,%edi
  800c65:	89 de                	mov    %ebx,%esi
  800c67:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c69:	85 c0                	test   %eax,%eax
  800c6b:	7e 28                	jle    800c95 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c71:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800c78:	00 
  800c79:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800c80:	00 
  800c81:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c88:	00 
  800c89:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800c90:	e8 f1 15 00 00       	call   802286 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c95:	83 c4 2c             	add    $0x2c,%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cab:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb6:	89 df                	mov    %ebx,%edi
  800cb8:	89 de                	mov    %ebx,%esi
  800cba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cbc:	85 c0                	test   %eax,%eax
  800cbe:	7e 28                	jle    800ce8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ccb:	00 
  800ccc:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800cd3:	00 
  800cd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cdb:	00 
  800cdc:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800ce3:	e8 9e 15 00 00       	call   802286 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce8:	83 c4 2c             	add    $0x2c,%esp
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfe:	b8 09 00 00 00       	mov    $0x9,%eax
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	8b 55 08             	mov    0x8(%ebp),%edx
  800d09:	89 df                	mov    %ebx,%edi
  800d0b:	89 de                	mov    %ebx,%esi
  800d0d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	7e 28                	jle    800d3b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d13:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d17:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d1e:	00 
  800d1f:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800d26:	00 
  800d27:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d2e:	00 
  800d2f:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800d36:	e8 4b 15 00 00       	call   802286 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d3b:	83 c4 2c             	add    $0x2c,%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	89 df                	mov    %ebx,%edi
  800d5e:	89 de                	mov    %ebx,%esi
  800d60:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d62:	85 c0                	test   %eax,%eax
  800d64:	7e 28                	jle    800d8e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d66:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d71:	00 
  800d72:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800d79:	00 
  800d7a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d81:	00 
  800d82:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800d89:	e8 f8 14 00 00       	call   802286 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d8e:	83 c4 2c             	add    $0x2c,%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9c:	be 00 00 00 00       	mov    $0x0,%esi
  800da1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800daf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	89 cb                	mov    %ecx,%ebx
  800dd1:	89 cf                	mov    %ecx,%edi
  800dd3:	89 ce                	mov    %ecx,%esi
  800dd5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7e 28                	jle    800e03 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800de6:	00 
  800de7:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800dee:	00 
  800def:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df6:	00 
  800df7:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800dfe:	e8 83 14 00 00       	call   802286 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e03:	83 c4 2c             	add    $0x2c,%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e1b:	89 d1                	mov    %edx,%ecx
  800e1d:	89 d3                	mov    %edx,%ebx
  800e1f:	89 d7                	mov    %edx,%edi
  800e21:	89 d6                	mov    %edx,%esi
  800e23:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e38:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	89 df                	mov    %ebx,%edi
  800e45:	89 de                	mov    %ebx,%esi
  800e47:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	7e 28                	jle    800e75 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e51:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e58:	00 
  800e59:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800e60:	00 
  800e61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e68:	00 
  800e69:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800e70:	e8 11 14 00 00       	call   802286 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800e75:	83 c4 2c             	add    $0x2c,%esp
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
  800e83:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8b:	b8 10 00 00 00       	mov    $0x10,%eax
  800e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	89 df                	mov    %ebx,%edi
  800e98:	89 de                	mov    %ebx,%esi
  800e9a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	7e 28                	jle    800ec8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800eab:	00 
  800eac:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800eb3:	00 
  800eb4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ebb:	00 
  800ebc:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800ec3:	e8 be 13 00 00       	call   802286 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800ec8:	83 c4 2c             	add    $0x2c,%esp
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	57                   	push   %edi
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
  800ed6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ede:	b8 11 00 00 00       	mov    $0x11,%eax
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	89 df                	mov    %ebx,%edi
  800eeb:	89 de                	mov    %ebx,%esi
  800eed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	7e 28                	jle    800f1b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800efe:	00 
  800eff:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800f06:	00 
  800f07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0e:	00 
  800f0f:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800f16:	e8 6b 13 00 00       	call   802286 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  800f1b:	83 c4 2c             	add    $0x2c,%esp
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <sys_sleep>:

int
sys_sleep(int channel)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f31:	b8 12 00 00 00       	mov    $0x12,%eax
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	89 cb                	mov    %ecx,%ebx
  800f3b:	89 cf                	mov    %ecx,%edi
  800f3d:	89 ce                	mov    %ecx,%esi
  800f3f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f41:	85 c0                	test   %eax,%eax
  800f43:	7e 28                	jle    800f6d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f49:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f50:	00 
  800f51:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800f58:	00 
  800f59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f60:	00 
  800f61:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800f68:	e8 19 13 00 00       	call   802286 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  800f6d:	83 c4 2c             	add    $0x2c,%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	57                   	push   %edi
  800f79:	56                   	push   %esi
  800f7a:	53                   	push   %ebx
  800f7b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f83:	b8 13 00 00 00       	mov    $0x13,%eax
  800f88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	89 df                	mov    %ebx,%edi
  800f90:	89 de                	mov    %ebx,%esi
  800f92:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f94:	85 c0                	test   %eax,%eax
  800f96:	7e 28                	jle    800fc0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f98:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  800fa3:	00 
  800fa4:	c7 44 24 08 2b 2a 80 	movl   $0x802a2b,0x8(%esp)
  800fab:	00 
  800fac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb3:	00 
  800fb4:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800fbb:	e8 c6 12 00 00       	call   802286 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  800fc0:	83 c4 2c             	add    $0x2c,%esp
  800fc3:	5b                   	pop    %ebx
  800fc4:	5e                   	pop    %esi
  800fc5:	5f                   	pop    %edi
  800fc6:	5d                   	pop    %ebp
  800fc7:	c3                   	ret    
  800fc8:	66 90                	xchg   %ax,%ax
  800fca:	66 90                	xchg   %ax,%ax
  800fcc:	66 90                	xchg   %ax,%ax
  800fce:	66 90                	xchg   %ax,%ax

00800fd0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	05 00 00 00 30       	add    $0x30000000,%eax
  800fdb:	c1 e8 0c             	shr    $0xc,%eax
}
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800feb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ff0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    

00800ff7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801002:	89 c2                	mov    %eax,%edx
  801004:	c1 ea 16             	shr    $0x16,%edx
  801007:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80100e:	f6 c2 01             	test   $0x1,%dl
  801011:	74 11                	je     801024 <fd_alloc+0x2d>
  801013:	89 c2                	mov    %eax,%edx
  801015:	c1 ea 0c             	shr    $0xc,%edx
  801018:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80101f:	f6 c2 01             	test   $0x1,%dl
  801022:	75 09                	jne    80102d <fd_alloc+0x36>
			*fd_store = fd;
  801024:	89 01                	mov    %eax,(%ecx)
			return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
  80102b:	eb 17                	jmp    801044 <fd_alloc+0x4d>
  80102d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801032:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801037:	75 c9                	jne    801002 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801039:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80103f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80104c:	83 f8 1f             	cmp    $0x1f,%eax
  80104f:	77 36                	ja     801087 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801051:	c1 e0 0c             	shl    $0xc,%eax
  801054:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801059:	89 c2                	mov    %eax,%edx
  80105b:	c1 ea 16             	shr    $0x16,%edx
  80105e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801065:	f6 c2 01             	test   $0x1,%dl
  801068:	74 24                	je     80108e <fd_lookup+0x48>
  80106a:	89 c2                	mov    %eax,%edx
  80106c:	c1 ea 0c             	shr    $0xc,%edx
  80106f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801076:	f6 c2 01             	test   $0x1,%dl
  801079:	74 1a                	je     801095 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80107b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107e:	89 02                	mov    %eax,(%edx)
	return 0;
  801080:	b8 00 00 00 00       	mov    $0x0,%eax
  801085:	eb 13                	jmp    80109a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801087:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108c:	eb 0c                	jmp    80109a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80108e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801093:	eb 05                	jmp    80109a <fd_lookup+0x54>
  801095:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 18             	sub    $0x18,%esp
  8010a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010aa:	eb 13                	jmp    8010bf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8010ac:	39 08                	cmp    %ecx,(%eax)
  8010ae:	75 0c                	jne    8010bc <dev_lookup+0x20>
			*dev = devtab[i];
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ba:	eb 38                	jmp    8010f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010bc:	83 c2 01             	add    $0x1,%edx
  8010bf:	8b 04 95 d4 2a 80 00 	mov    0x802ad4(,%edx,4),%eax
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	75 e2                	jne    8010ac <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8010cf:	8b 40 48             	mov    0x48(%eax),%eax
  8010d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010da:	c7 04 24 58 2a 80 00 	movl   $0x802a58,(%esp)
  8010e1:	e8 72 f0 ff ff       	call   800158 <cprintf>
	*dev = 0;
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
  8010fb:	83 ec 20             	sub    $0x20,%esp
  8010fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801101:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801104:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801107:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801111:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801114:	89 04 24             	mov    %eax,(%esp)
  801117:	e8 2a ff ff ff       	call   801046 <fd_lookup>
  80111c:	85 c0                	test   %eax,%eax
  80111e:	78 05                	js     801125 <fd_close+0x2f>
	    || fd != fd2)
  801120:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801123:	74 0c                	je     801131 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801125:	84 db                	test   %bl,%bl
  801127:	ba 00 00 00 00       	mov    $0x0,%edx
  80112c:	0f 44 c2             	cmove  %edx,%eax
  80112f:	eb 3f                	jmp    801170 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801131:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801134:	89 44 24 04          	mov    %eax,0x4(%esp)
  801138:	8b 06                	mov    (%esi),%eax
  80113a:	89 04 24             	mov    %eax,(%esp)
  80113d:	e8 5a ff ff ff       	call   80109c <dev_lookup>
  801142:	89 c3                	mov    %eax,%ebx
  801144:	85 c0                	test   %eax,%eax
  801146:	78 16                	js     80115e <fd_close+0x68>
		if (dev->dev_close)
  801148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80114e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801153:	85 c0                	test   %eax,%eax
  801155:	74 07                	je     80115e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801157:	89 34 24             	mov    %esi,(%esp)
  80115a:	ff d0                	call   *%eax
  80115c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80115e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801162:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801169:	e8 dc fa ff ff       	call   800c4a <sys_page_unmap>
	return r;
  80116e:	89 d8                	mov    %ebx,%eax
}
  801170:	83 c4 20             	add    $0x20,%esp
  801173:	5b                   	pop    %ebx
  801174:	5e                   	pop    %esi
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    

00801177 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80117d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801180:	89 44 24 04          	mov    %eax,0x4(%esp)
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	89 04 24             	mov    %eax,(%esp)
  80118a:	e8 b7 fe ff ff       	call   801046 <fd_lookup>
  80118f:	89 c2                	mov    %eax,%edx
  801191:	85 d2                	test   %edx,%edx
  801193:	78 13                	js     8011a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801195:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80119c:	00 
  80119d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a0:	89 04 24             	mov    %eax,(%esp)
  8011a3:	e8 4e ff ff ff       	call   8010f6 <fd_close>
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <close_all>:

void
close_all(void)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011b6:	89 1c 24             	mov    %ebx,(%esp)
  8011b9:	e8 b9 ff ff ff       	call   801177 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011be:	83 c3 01             	add    $0x1,%ebx
  8011c1:	83 fb 20             	cmp    $0x20,%ebx
  8011c4:	75 f0                	jne    8011b6 <close_all+0xc>
		close(i);
}
  8011c6:	83 c4 14             	add    $0x14,%esp
  8011c9:	5b                   	pop    %ebx
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	57                   	push   %edi
  8011d0:	56                   	push   %esi
  8011d1:	53                   	push   %ebx
  8011d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	89 04 24             	mov    %eax,(%esp)
  8011e2:	e8 5f fe ff ff       	call   801046 <fd_lookup>
  8011e7:	89 c2                	mov    %eax,%edx
  8011e9:	85 d2                	test   %edx,%edx
  8011eb:	0f 88 e1 00 00 00    	js     8012d2 <dup+0x106>
		return r;
	close(newfdnum);
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	89 04 24             	mov    %eax,(%esp)
  8011f7:	e8 7b ff ff ff       	call   801177 <close>

	newfd = INDEX2FD(newfdnum);
  8011fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011ff:	c1 e3 0c             	shl    $0xc,%ebx
  801202:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80120b:	89 04 24             	mov    %eax,(%esp)
  80120e:	e8 cd fd ff ff       	call   800fe0 <fd2data>
  801213:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801215:	89 1c 24             	mov    %ebx,(%esp)
  801218:	e8 c3 fd ff ff       	call   800fe0 <fd2data>
  80121d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80121f:	89 f0                	mov    %esi,%eax
  801221:	c1 e8 16             	shr    $0x16,%eax
  801224:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80122b:	a8 01                	test   $0x1,%al
  80122d:	74 43                	je     801272 <dup+0xa6>
  80122f:	89 f0                	mov    %esi,%eax
  801231:	c1 e8 0c             	shr    $0xc,%eax
  801234:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80123b:	f6 c2 01             	test   $0x1,%dl
  80123e:	74 32                	je     801272 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801240:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801247:	25 07 0e 00 00       	and    $0xe07,%eax
  80124c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801250:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801254:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80125b:	00 
  80125c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801267:	e8 8b f9 ff ff       	call   800bf7 <sys_page_map>
  80126c:	89 c6                	mov    %eax,%esi
  80126e:	85 c0                	test   %eax,%eax
  801270:	78 3e                	js     8012b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801275:	89 c2                	mov    %eax,%edx
  801277:	c1 ea 0c             	shr    $0xc,%edx
  80127a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801281:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801287:	89 54 24 10          	mov    %edx,0x10(%esp)
  80128b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80128f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801296:	00 
  801297:	89 44 24 04          	mov    %eax,0x4(%esp)
  80129b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a2:	e8 50 f9 ff ff       	call   800bf7 <sys_page_map>
  8012a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012ac:	85 f6                	test   %esi,%esi
  8012ae:	79 22                	jns    8012d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012bb:	e8 8a f9 ff ff       	call   800c4a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012cb:	e8 7a f9 ff ff       	call   800c4a <sys_page_unmap>
	return r;
  8012d0:	89 f0                	mov    %esi,%eax
}
  8012d2:	83 c4 3c             	add    $0x3c,%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5f                   	pop    %edi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 24             	sub    $0x24,%esp
  8012e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012eb:	89 1c 24             	mov    %ebx,(%esp)
  8012ee:	e8 53 fd ff ff       	call   801046 <fd_lookup>
  8012f3:	89 c2                	mov    %eax,%edx
  8012f5:	85 d2                	test   %edx,%edx
  8012f7:	78 6d                	js     801366 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801303:	8b 00                	mov    (%eax),%eax
  801305:	89 04 24             	mov    %eax,(%esp)
  801308:	e8 8f fd ff ff       	call   80109c <dev_lookup>
  80130d:	85 c0                	test   %eax,%eax
  80130f:	78 55                	js     801366 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801314:	8b 50 08             	mov    0x8(%eax),%edx
  801317:	83 e2 03             	and    $0x3,%edx
  80131a:	83 fa 01             	cmp    $0x1,%edx
  80131d:	75 23                	jne    801342 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80131f:	a1 08 40 80 00       	mov    0x804008,%eax
  801324:	8b 40 48             	mov    0x48(%eax),%eax
  801327:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80132b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132f:	c7 04 24 99 2a 80 00 	movl   $0x802a99,(%esp)
  801336:	e8 1d ee ff ff       	call   800158 <cprintf>
		return -E_INVAL;
  80133b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801340:	eb 24                	jmp    801366 <read+0x8c>
	}
	if (!dev->dev_read)
  801342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801345:	8b 52 08             	mov    0x8(%edx),%edx
  801348:	85 d2                	test   %edx,%edx
  80134a:	74 15                	je     801361 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80134c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80134f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801353:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801356:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80135a:	89 04 24             	mov    %eax,(%esp)
  80135d:	ff d2                	call   *%edx
  80135f:	eb 05                	jmp    801366 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801361:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801366:	83 c4 24             	add    $0x24,%esp
  801369:	5b                   	pop    %ebx
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 1c             	sub    $0x1c,%esp
  801375:	8b 7d 08             	mov    0x8(%ebp),%edi
  801378:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80137b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801380:	eb 23                	jmp    8013a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801382:	89 f0                	mov    %esi,%eax
  801384:	29 d8                	sub    %ebx,%eax
  801386:	89 44 24 08          	mov    %eax,0x8(%esp)
  80138a:	89 d8                	mov    %ebx,%eax
  80138c:	03 45 0c             	add    0xc(%ebp),%eax
  80138f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801393:	89 3c 24             	mov    %edi,(%esp)
  801396:	e8 3f ff ff ff       	call   8012da <read>
		if (m < 0)
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 10                	js     8013af <readn+0x43>
			return m;
		if (m == 0)
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	74 0a                	je     8013ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a3:	01 c3                	add    %eax,%ebx
  8013a5:	39 f3                	cmp    %esi,%ebx
  8013a7:	72 d9                	jb     801382 <readn+0x16>
  8013a9:	89 d8                	mov    %ebx,%eax
  8013ab:	eb 02                	jmp    8013af <readn+0x43>
  8013ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013af:	83 c4 1c             	add    $0x1c,%esp
  8013b2:	5b                   	pop    %ebx
  8013b3:	5e                   	pop    %esi
  8013b4:	5f                   	pop    %edi
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 24             	sub    $0x24,%esp
  8013be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c8:	89 1c 24             	mov    %ebx,(%esp)
  8013cb:	e8 76 fc ff ff       	call   801046 <fd_lookup>
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	85 d2                	test   %edx,%edx
  8013d4:	78 68                	js     80143e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e0:	8b 00                	mov    (%eax),%eax
  8013e2:	89 04 24             	mov    %eax,(%esp)
  8013e5:	e8 b2 fc ff ff       	call   80109c <dev_lookup>
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 50                	js     80143e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013f5:	75 23                	jne    80141a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8013fc:	8b 40 48             	mov    0x48(%eax),%eax
  8013ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801403:	89 44 24 04          	mov    %eax,0x4(%esp)
  801407:	c7 04 24 b5 2a 80 00 	movl   $0x802ab5,(%esp)
  80140e:	e8 45 ed ff ff       	call   800158 <cprintf>
		return -E_INVAL;
  801413:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801418:	eb 24                	jmp    80143e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80141a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141d:	8b 52 0c             	mov    0xc(%edx),%edx
  801420:	85 d2                	test   %edx,%edx
  801422:	74 15                	je     801439 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801424:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801427:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80142b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801432:	89 04 24             	mov    %eax,(%esp)
  801435:	ff d2                	call   *%edx
  801437:	eb 05                	jmp    80143e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801439:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80143e:	83 c4 24             	add    $0x24,%esp
  801441:	5b                   	pop    %ebx
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    

00801444 <seek>:

int
seek(int fdnum, off_t offset)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80144d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	89 04 24             	mov    %eax,(%esp)
  801457:	e8 ea fb ff ff       	call   801046 <fd_lookup>
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 0e                	js     80146e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	8b 55 0c             	mov    0xc(%ebp),%edx
  801466:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801469:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	53                   	push   %ebx
  801474:	83 ec 24             	sub    $0x24,%esp
  801477:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801481:	89 1c 24             	mov    %ebx,(%esp)
  801484:	e8 bd fb ff ff       	call   801046 <fd_lookup>
  801489:	89 c2                	mov    %eax,%edx
  80148b:	85 d2                	test   %edx,%edx
  80148d:	78 61                	js     8014f0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801492:	89 44 24 04          	mov    %eax,0x4(%esp)
  801496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801499:	8b 00                	mov    (%eax),%eax
  80149b:	89 04 24             	mov    %eax,(%esp)
  80149e:	e8 f9 fb ff ff       	call   80109c <dev_lookup>
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	78 49                	js     8014f0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ae:	75 23                	jne    8014d3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014b0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014b5:	8b 40 48             	mov    0x48(%eax),%eax
  8014b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c0:	c7 04 24 78 2a 80 00 	movl   $0x802a78,(%esp)
  8014c7:	e8 8c ec ff ff       	call   800158 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d1:	eb 1d                	jmp    8014f0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8014d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d6:	8b 52 18             	mov    0x18(%edx),%edx
  8014d9:	85 d2                	test   %edx,%edx
  8014db:	74 0e                	je     8014eb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014e4:	89 04 24             	mov    %eax,(%esp)
  8014e7:	ff d2                	call   *%edx
  8014e9:	eb 05                	jmp    8014f0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014f0:	83 c4 24             	add    $0x24,%esp
  8014f3:	5b                   	pop    %ebx
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    

008014f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	53                   	push   %ebx
  8014fa:	83 ec 24             	sub    $0x24,%esp
  8014fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801500:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801503:	89 44 24 04          	mov    %eax,0x4(%esp)
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	89 04 24             	mov    %eax,(%esp)
  80150d:	e8 34 fb ff ff       	call   801046 <fd_lookup>
  801512:	89 c2                	mov    %eax,%edx
  801514:	85 d2                	test   %edx,%edx
  801516:	78 52                	js     80156a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801518:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	8b 00                	mov    (%eax),%eax
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	e8 70 fb ff ff       	call   80109c <dev_lookup>
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 3a                	js     80156a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801533:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801537:	74 2c                	je     801565 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801539:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80153c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801543:	00 00 00 
	stat->st_isdir = 0;
  801546:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80154d:	00 00 00 
	stat->st_dev = dev;
  801550:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801556:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80155a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80155d:	89 14 24             	mov    %edx,(%esp)
  801560:	ff 50 14             	call   *0x14(%eax)
  801563:	eb 05                	jmp    80156a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801565:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80156a:	83 c4 24             	add    $0x24,%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	56                   	push   %esi
  801574:	53                   	push   %ebx
  801575:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801578:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80157f:	00 
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	89 04 24             	mov    %eax,(%esp)
  801586:	e8 1b 02 00 00       	call   8017a6 <open>
  80158b:	89 c3                	mov    %eax,%ebx
  80158d:	85 db                	test   %ebx,%ebx
  80158f:	78 1b                	js     8015ac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801591:	8b 45 0c             	mov    0xc(%ebp),%eax
  801594:	89 44 24 04          	mov    %eax,0x4(%esp)
  801598:	89 1c 24             	mov    %ebx,(%esp)
  80159b:	e8 56 ff ff ff       	call   8014f6 <fstat>
  8015a0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a2:	89 1c 24             	mov    %ebx,(%esp)
  8015a5:	e8 cd fb ff ff       	call   801177 <close>
	return r;
  8015aa:	89 f0                	mov    %esi,%eax
}
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	5b                   	pop    %ebx
  8015b0:	5e                   	pop    %esi
  8015b1:	5d                   	pop    %ebp
  8015b2:	c3                   	ret    

008015b3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	56                   	push   %esi
  8015b7:	53                   	push   %ebx
  8015b8:	83 ec 10             	sub    $0x10,%esp
  8015bb:	89 c6                	mov    %eax,%esi
  8015bd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015bf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015c6:	75 11                	jne    8015d9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015cf:	e8 cb 0d 00 00       	call   80239f <ipc_find_env>
  8015d4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015d9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015e0:	00 
  8015e1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015e8:	00 
  8015e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015ed:	a1 00 40 80 00       	mov    0x804000,%eax
  8015f2:	89 04 24             	mov    %eax,(%esp)
  8015f5:	e8 3a 0d 00 00       	call   802334 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801601:	00 
  801602:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801606:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80160d:	e8 ce 0c 00 00       	call   8022e0 <ipc_recv>
}
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	5b                   	pop    %ebx
  801616:	5e                   	pop    %esi
  801617:	5d                   	pop    %ebp
  801618:	c3                   	ret    

00801619 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	8b 40 0c             	mov    0xc(%eax),%eax
  801625:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80162a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801632:	ba 00 00 00 00       	mov    $0x0,%edx
  801637:	b8 02 00 00 00       	mov    $0x2,%eax
  80163c:	e8 72 ff ff ff       	call   8015b3 <fsipc>
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	8b 40 0c             	mov    0xc(%eax),%eax
  80164f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801654:	ba 00 00 00 00       	mov    $0x0,%edx
  801659:	b8 06 00 00 00       	mov    $0x6,%eax
  80165e:	e8 50 ff ff ff       	call   8015b3 <fsipc>
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	53                   	push   %ebx
  801669:	83 ec 14             	sub    $0x14,%esp
  80166c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8b 40 0c             	mov    0xc(%eax),%eax
  801675:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80167a:	ba 00 00 00 00       	mov    $0x0,%edx
  80167f:	b8 05 00 00 00       	mov    $0x5,%eax
  801684:	e8 2a ff ff ff       	call   8015b3 <fsipc>
  801689:	89 c2                	mov    %eax,%edx
  80168b:	85 d2                	test   %edx,%edx
  80168d:	78 2b                	js     8016ba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80168f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801696:	00 
  801697:	89 1c 24             	mov    %ebx,(%esp)
  80169a:	e8 e8 f0 ff ff       	call   800787 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80169f:	a1 80 50 80 00       	mov    0x805080,%eax
  8016a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016aa:	a1 84 50 80 00       	mov    0x805084,%eax
  8016af:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ba:	83 c4 14             	add    $0x14,%esp
  8016bd:	5b                   	pop    %ebx
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    

008016c0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 18             	sub    $0x18,%esp
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8016cf:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8016d5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8016ec:	e8 9b f2 ff ff       	call   80098c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  8016f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f6:	b8 04 00 00 00       	mov    $0x4,%eax
  8016fb:	e8 b3 fe ff ff       	call   8015b3 <fsipc>
		return r;
	}

	return r;
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	56                   	push   %esi
  801706:	53                   	push   %ebx
  801707:	83 ec 10             	sub    $0x10,%esp
  80170a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8b 40 0c             	mov    0xc(%eax),%eax
  801713:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801718:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80171e:	ba 00 00 00 00       	mov    $0x0,%edx
  801723:	b8 03 00 00 00       	mov    $0x3,%eax
  801728:	e8 86 fe ff ff       	call   8015b3 <fsipc>
  80172d:	89 c3                	mov    %eax,%ebx
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 6a                	js     80179d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801733:	39 c6                	cmp    %eax,%esi
  801735:	73 24                	jae    80175b <devfile_read+0x59>
  801737:	c7 44 24 0c e8 2a 80 	movl   $0x802ae8,0xc(%esp)
  80173e:	00 
  80173f:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  801746:	00 
  801747:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80174e:	00 
  80174f:	c7 04 24 04 2b 80 00 	movl   $0x802b04,(%esp)
  801756:	e8 2b 0b 00 00       	call   802286 <_panic>
	assert(r <= PGSIZE);
  80175b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801760:	7e 24                	jle    801786 <devfile_read+0x84>
  801762:	c7 44 24 0c 0f 2b 80 	movl   $0x802b0f,0xc(%esp)
  801769:	00 
  80176a:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  801771:	00 
  801772:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801779:	00 
  80177a:	c7 04 24 04 2b 80 00 	movl   $0x802b04,(%esp)
  801781:	e8 00 0b 00 00       	call   802286 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801786:	89 44 24 08          	mov    %eax,0x8(%esp)
  80178a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801791:	00 
  801792:	8b 45 0c             	mov    0xc(%ebp),%eax
  801795:	89 04 24             	mov    %eax,(%esp)
  801798:	e8 87 f1 ff ff       	call   800924 <memmove>
	return r;
}
  80179d:	89 d8                	mov    %ebx,%eax
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	5b                   	pop    %ebx
  8017a3:	5e                   	pop    %esi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    

008017a6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 24             	sub    $0x24,%esp
  8017ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017b0:	89 1c 24             	mov    %ebx,(%esp)
  8017b3:	e8 98 ef ff ff       	call   800750 <strlen>
  8017b8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017bd:	7f 60                	jg     80181f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c2:	89 04 24             	mov    %eax,(%esp)
  8017c5:	e8 2d f8 ff ff       	call   800ff7 <fd_alloc>
  8017ca:	89 c2                	mov    %eax,%edx
  8017cc:	85 d2                	test   %edx,%edx
  8017ce:	78 54                	js     801824 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017d4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017db:	e8 a7 ef ff ff       	call   800787 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f0:	e8 be fd ff ff       	call   8015b3 <fsipc>
  8017f5:	89 c3                	mov    %eax,%ebx
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	79 17                	jns    801812 <open+0x6c>
		fd_close(fd, 0);
  8017fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801802:	00 
  801803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801806:	89 04 24             	mov    %eax,(%esp)
  801809:	e8 e8 f8 ff ff       	call   8010f6 <fd_close>
		return r;
  80180e:	89 d8                	mov    %ebx,%eax
  801810:	eb 12                	jmp    801824 <open+0x7e>
	}

	return fd2num(fd);
  801812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801815:	89 04 24             	mov    %eax,(%esp)
  801818:	e8 b3 f7 ff ff       	call   800fd0 <fd2num>
  80181d:	eb 05                	jmp    801824 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80181f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801824:	83 c4 24             	add    $0x24,%esp
  801827:	5b                   	pop    %ebx
  801828:	5d                   	pop    %ebp
  801829:	c3                   	ret    

0080182a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801830:	ba 00 00 00 00       	mov    $0x0,%edx
  801835:	b8 08 00 00 00       	mov    $0x8,%eax
  80183a:	e8 74 fd ff ff       	call   8015b3 <fsipc>
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    
  801841:	66 90                	xchg   %ax,%ax
  801843:	66 90                	xchg   %ax,%ax
  801845:	66 90                	xchg   %ax,%ax
  801847:	66 90                	xchg   %ax,%ax
  801849:	66 90                	xchg   %ax,%ax
  80184b:	66 90                	xchg   %ax,%ax
  80184d:	66 90                	xchg   %ax,%ax
  80184f:	90                   	nop

00801850 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801856:	c7 44 24 04 1b 2b 80 	movl   $0x802b1b,0x4(%esp)
  80185d:	00 
  80185e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801861:	89 04 24             	mov    %eax,(%esp)
  801864:	e8 1e ef ff ff       	call   800787 <strcpy>
	return 0;
}
  801869:	b8 00 00 00 00       	mov    $0x0,%eax
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	53                   	push   %ebx
  801874:	83 ec 14             	sub    $0x14,%esp
  801877:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80187a:	89 1c 24             	mov    %ebx,(%esp)
  80187d:	e8 5c 0b 00 00       	call   8023de <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801882:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801887:	83 f8 01             	cmp    $0x1,%eax
  80188a:	75 0d                	jne    801899 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80188c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80188f:	89 04 24             	mov    %eax,(%esp)
  801892:	e8 29 03 00 00       	call   801bc0 <nsipc_close>
  801897:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801899:	89 d0                	mov    %edx,%eax
  80189b:	83 c4 14             	add    $0x14,%esp
  80189e:	5b                   	pop    %ebx
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    

008018a1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018ae:	00 
  8018af:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c3:	89 04 24             	mov    %eax,(%esp)
  8018c6:	e8 f0 03 00 00       	call   801cbb <nsipc_send>
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018da:	00 
  8018db:	8b 45 10             	mov    0x10(%ebp),%eax
  8018de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ef:	89 04 24             	mov    %eax,(%esp)
  8018f2:	e8 44 03 00 00       	call   801c3b <nsipc_recv>
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018ff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801902:	89 54 24 04          	mov    %edx,0x4(%esp)
  801906:	89 04 24             	mov    %eax,(%esp)
  801909:	e8 38 f7 ff ff       	call   801046 <fd_lookup>
  80190e:	85 c0                	test   %eax,%eax
  801910:	78 17                	js     801929 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801915:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80191b:	39 08                	cmp    %ecx,(%eax)
  80191d:	75 05                	jne    801924 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80191f:	8b 40 0c             	mov    0xc(%eax),%eax
  801922:	eb 05                	jmp    801929 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801924:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	83 ec 20             	sub    $0x20,%esp
  801933:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801935:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801938:	89 04 24             	mov    %eax,(%esp)
  80193b:	e8 b7 f6 ff ff       	call   800ff7 <fd_alloc>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	85 c0                	test   %eax,%eax
  801944:	78 21                	js     801967 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801946:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80194d:	00 
  80194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801951:	89 44 24 04          	mov    %eax,0x4(%esp)
  801955:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80195c:	e8 42 f2 ff ff       	call   800ba3 <sys_page_alloc>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	85 c0                	test   %eax,%eax
  801965:	79 0c                	jns    801973 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801967:	89 34 24             	mov    %esi,(%esp)
  80196a:	e8 51 02 00 00       	call   801bc0 <nsipc_close>
		return r;
  80196f:	89 d8                	mov    %ebx,%eax
  801971:	eb 20                	jmp    801993 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801973:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80197e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801981:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801988:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80198b:	89 14 24             	mov    %edx,(%esp)
  80198e:	e8 3d f6 ff ff       	call   800fd0 <fd2num>
}
  801993:	83 c4 20             	add    $0x20,%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	e8 51 ff ff ff       	call   8018f9 <fd2sockid>
		return r;
  8019a8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 23                	js     8019d1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8019b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019bc:	89 04 24             	mov    %eax,(%esp)
  8019bf:	e8 45 01 00 00       	call   801b09 <nsipc_accept>
		return r;
  8019c4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 07                	js     8019d1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8019ca:	e8 5c ff ff ff       	call   80192b <alloc_sockfd>
  8019cf:	89 c1                	mov    %eax,%ecx
}
  8019d1:	89 c8                	mov    %ecx,%eax
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	e8 16 ff ff ff       	call   8018f9 <fd2sockid>
  8019e3:	89 c2                	mov    %eax,%edx
  8019e5:	85 d2                	test   %edx,%edx
  8019e7:	78 16                	js     8019ff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8019e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f7:	89 14 24             	mov    %edx,(%esp)
  8019fa:	e8 60 01 00 00       	call   801b5f <nsipc_bind>
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <shutdown>:

int
shutdown(int s, int how)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	e8 ea fe ff ff       	call   8018f9 <fd2sockid>
  801a0f:	89 c2                	mov    %eax,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	78 0f                	js     801a24 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1c:	89 14 24             	mov    %edx,(%esp)
  801a1f:	e8 7a 01 00 00       	call   801b9e <nsipc_shutdown>
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	e8 c5 fe ff ff       	call   8018f9 <fd2sockid>
  801a34:	89 c2                	mov    %eax,%edx
  801a36:	85 d2                	test   %edx,%edx
  801a38:	78 16                	js     801a50 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a48:	89 14 24             	mov    %edx,(%esp)
  801a4b:	e8 8a 01 00 00       	call   801bda <nsipc_connect>
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <listen>:

int
listen(int s, int backlog)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	e8 99 fe ff ff       	call   8018f9 <fd2sockid>
  801a60:	89 c2                	mov    %eax,%edx
  801a62:	85 d2                	test   %edx,%edx
  801a64:	78 0f                	js     801a75 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6d:	89 14 24             	mov    %edx,(%esp)
  801a70:	e8 a4 01 00 00       	call   801c19 <nsipc_listen>
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	89 04 24             	mov    %eax,(%esp)
  801a91:	e8 98 02 00 00       	call   801d2e <nsipc_socket>
  801a96:	89 c2                	mov    %eax,%edx
  801a98:	85 d2                	test   %edx,%edx
  801a9a:	78 05                	js     801aa1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801a9c:	e8 8a fe ff ff       	call   80192b <alloc_sockfd>
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	53                   	push   %ebx
  801aa7:	83 ec 14             	sub    $0x14,%esp
  801aaa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aac:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ab3:	75 11                	jne    801ac6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ab5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801abc:	e8 de 08 00 00       	call   80239f <ipc_find_env>
  801ac1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ac6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801acd:	00 
  801ace:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ad5:	00 
  801ad6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ada:	a1 04 40 80 00       	mov    0x804004,%eax
  801adf:	89 04 24             	mov    %eax,(%esp)
  801ae2:	e8 4d 08 00 00       	call   802334 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ae7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aee:	00 
  801aef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801af6:	00 
  801af7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801afe:	e8 dd 07 00 00       	call   8022e0 <ipc_recv>
}
  801b03:	83 c4 14             	add    $0x14,%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5d                   	pop    %ebp
  801b08:	c3                   	ret    

00801b09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
  801b0e:	83 ec 10             	sub    $0x10,%esp
  801b11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b1c:	8b 06                	mov    (%esi),%eax
  801b1e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b23:	b8 01 00 00 00       	mov    $0x1,%eax
  801b28:	e8 76 ff ff ff       	call   801aa3 <nsipc>
  801b2d:	89 c3                	mov    %eax,%ebx
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	78 23                	js     801b56 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b33:	a1 10 60 80 00       	mov    0x806010,%eax
  801b38:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b3c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b43:	00 
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	89 04 24             	mov    %eax,(%esp)
  801b4a:	e8 d5 ed ff ff       	call   800924 <memmove>
		*addrlen = ret->ret_addrlen;
  801b4f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b54:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801b56:	89 d8                	mov    %ebx,%eax
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    

00801b5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	53                   	push   %ebx
  801b63:	83 ec 14             	sub    $0x14,%esp
  801b66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b83:	e8 9c ed ff ff       	call   800924 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b88:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b8e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b93:	e8 0b ff ff ff       	call   801aa3 <nsipc>
}
  801b98:	83 c4 14             	add    $0x14,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    

00801b9e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801baf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bb4:	b8 03 00 00 00       	mov    $0x3,%eax
  801bb9:	e8 e5 fe ff ff       	call   801aa3 <nsipc>
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <nsipc_close>:

int
nsipc_close(int s)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bce:	b8 04 00 00 00       	mov    $0x4,%eax
  801bd3:	e8 cb fe ff ff       	call   801aa3 <nsipc>
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	53                   	push   %ebx
  801bde:	83 ec 14             	sub    $0x14,%esp
  801be1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801bfe:	e8 21 ed ff ff       	call   800924 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c03:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c09:	b8 05 00 00 00       	mov    $0x5,%eax
  801c0e:	e8 90 fe ff ff       	call   801aa3 <nsipc>
}
  801c13:	83 c4 14             	add    $0x14,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c2f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c34:	e8 6a fe ff ff       	call   801aa3 <nsipc>
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	56                   	push   %esi
  801c3f:	53                   	push   %ebx
  801c40:	83 ec 10             	sub    $0x10,%esp
  801c43:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c4e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c54:	8b 45 14             	mov    0x14(%ebp),%eax
  801c57:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c5c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c61:	e8 3d fe ff ff       	call   801aa3 <nsipc>
  801c66:	89 c3                	mov    %eax,%ebx
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	78 46                	js     801cb2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801c6c:	39 f0                	cmp    %esi,%eax
  801c6e:	7f 07                	jg     801c77 <nsipc_recv+0x3c>
  801c70:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c75:	7e 24                	jle    801c9b <nsipc_recv+0x60>
  801c77:	c7 44 24 0c 27 2b 80 	movl   $0x802b27,0xc(%esp)
  801c7e:	00 
  801c7f:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  801c86:	00 
  801c87:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c8e:	00 
  801c8f:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801c96:	e8 eb 05 00 00       	call   802286 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c9f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ca6:	00 
  801ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801caa:	89 04 24             	mov    %eax,(%esp)
  801cad:	e8 72 ec ff ff       	call   800924 <memmove>
	}

	return r;
}
  801cb2:	89 d8                	mov    %ebx,%eax
  801cb4:	83 c4 10             	add    $0x10,%esp
  801cb7:	5b                   	pop    %ebx
  801cb8:	5e                   	pop    %esi
  801cb9:	5d                   	pop    %ebp
  801cba:	c3                   	ret    

00801cbb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	53                   	push   %ebx
  801cbf:	83 ec 14             	sub    $0x14,%esp
  801cc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ccd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cd3:	7e 24                	jle    801cf9 <nsipc_send+0x3e>
  801cd5:	c7 44 24 0c 48 2b 80 	movl   $0x802b48,0xc(%esp)
  801cdc:	00 
  801cdd:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  801ce4:	00 
  801ce5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801cec:	00 
  801ced:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801cf4:	e8 8d 05 00 00       	call   802286 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cf9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d04:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d0b:	e8 14 ec ff ff       	call   800924 <memmove>
	nsipcbuf.send.req_size = size;
  801d10:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d16:	8b 45 14             	mov    0x14(%ebp),%eax
  801d19:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d1e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d23:	e8 7b fd ff ff       	call   801aa3 <nsipc>
}
  801d28:	83 c4 14             	add    $0x14,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d44:	8b 45 10             	mov    0x10(%ebp),%eax
  801d47:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d4c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d51:	e8 4d fd ff ff       	call   801aa3 <nsipc>
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
  801d5d:	83 ec 10             	sub    $0x10,%esp
  801d60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	89 04 24             	mov    %eax,(%esp)
  801d69:	e8 72 f2 ff ff       	call   800fe0 <fd2data>
  801d6e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d70:	c7 44 24 04 54 2b 80 	movl   $0x802b54,0x4(%esp)
  801d77:	00 
  801d78:	89 1c 24             	mov    %ebx,(%esp)
  801d7b:	e8 07 ea ff ff       	call   800787 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d80:	8b 46 04             	mov    0x4(%esi),%eax
  801d83:	2b 06                	sub    (%esi),%eax
  801d85:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d8b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d92:	00 00 00 
	stat->st_dev = &devpipe;
  801d95:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d9c:	30 80 00 
	return 0;
}
  801d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5d                   	pop    %ebp
  801daa:	c3                   	ret    

00801dab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	53                   	push   %ebx
  801daf:	83 ec 14             	sub    $0x14,%esp
  801db2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801db5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801db9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dc0:	e8 85 ee ff ff       	call   800c4a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dc5:	89 1c 24             	mov    %ebx,(%esp)
  801dc8:	e8 13 f2 ff ff       	call   800fe0 <fd2data>
  801dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd8:	e8 6d ee ff ff       	call   800c4a <sys_page_unmap>
}
  801ddd:	83 c4 14             	add    $0x14,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	57                   	push   %edi
  801de7:	56                   	push   %esi
  801de8:	53                   	push   %ebx
  801de9:	83 ec 2c             	sub    $0x2c,%esp
  801dec:	89 c6                	mov    %eax,%esi
  801dee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801df1:	a1 08 40 80 00       	mov    0x804008,%eax
  801df6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801df9:	89 34 24             	mov    %esi,(%esp)
  801dfc:	e8 dd 05 00 00       	call   8023de <pageref>
  801e01:	89 c7                	mov    %eax,%edi
  801e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e06:	89 04 24             	mov    %eax,(%esp)
  801e09:	e8 d0 05 00 00       	call   8023de <pageref>
  801e0e:	39 c7                	cmp    %eax,%edi
  801e10:	0f 94 c2             	sete   %dl
  801e13:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e16:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801e1c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e1f:	39 fb                	cmp    %edi,%ebx
  801e21:	74 21                	je     801e44 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e23:	84 d2                	test   %dl,%dl
  801e25:	74 ca                	je     801df1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e27:	8b 51 58             	mov    0x58(%ecx),%edx
  801e2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e2e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e36:	c7 04 24 5b 2b 80 00 	movl   $0x802b5b,(%esp)
  801e3d:	e8 16 e3 ff ff       	call   800158 <cprintf>
  801e42:	eb ad                	jmp    801df1 <_pipeisclosed+0xe>
	}
}
  801e44:	83 c4 2c             	add    $0x2c,%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5f                   	pop    %edi
  801e4a:	5d                   	pop    %ebp
  801e4b:	c3                   	ret    

00801e4c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	57                   	push   %edi
  801e50:	56                   	push   %esi
  801e51:	53                   	push   %ebx
  801e52:	83 ec 1c             	sub    $0x1c,%esp
  801e55:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e58:	89 34 24             	mov    %esi,(%esp)
  801e5b:	e8 80 f1 ff ff       	call   800fe0 <fd2data>
  801e60:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e62:	bf 00 00 00 00       	mov    $0x0,%edi
  801e67:	eb 45                	jmp    801eae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e69:	89 da                	mov    %ebx,%edx
  801e6b:	89 f0                	mov    %esi,%eax
  801e6d:	e8 71 ff ff ff       	call   801de3 <_pipeisclosed>
  801e72:	85 c0                	test   %eax,%eax
  801e74:	75 41                	jne    801eb7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e76:	e8 09 ed ff ff       	call   800b84 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e7b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e7e:	8b 0b                	mov    (%ebx),%ecx
  801e80:	8d 51 20             	lea    0x20(%ecx),%edx
  801e83:	39 d0                	cmp    %edx,%eax
  801e85:	73 e2                	jae    801e69 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e8e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e91:	99                   	cltd   
  801e92:	c1 ea 1b             	shr    $0x1b,%edx
  801e95:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e98:	83 e1 1f             	and    $0x1f,%ecx
  801e9b:	29 d1                	sub    %edx,%ecx
  801e9d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ea1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ea5:	83 c0 01             	add    $0x1,%eax
  801ea8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eab:	83 c7 01             	add    $0x1,%edi
  801eae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eb1:	75 c8                	jne    801e7b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801eb3:	89 f8                	mov    %edi,%eax
  801eb5:	eb 05                	jmp    801ebc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ebc:	83 c4 1c             	add    $0x1c,%esp
  801ebf:	5b                   	pop    %ebx
  801ec0:	5e                   	pop    %esi
  801ec1:	5f                   	pop    %edi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    

00801ec4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	57                   	push   %edi
  801ec8:	56                   	push   %esi
  801ec9:	53                   	push   %ebx
  801eca:	83 ec 1c             	sub    $0x1c,%esp
  801ecd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ed0:	89 3c 24             	mov    %edi,(%esp)
  801ed3:	e8 08 f1 ff ff       	call   800fe0 <fd2data>
  801ed8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eda:	be 00 00 00 00       	mov    $0x0,%esi
  801edf:	eb 3d                	jmp    801f1e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ee1:	85 f6                	test   %esi,%esi
  801ee3:	74 04                	je     801ee9 <devpipe_read+0x25>
				return i;
  801ee5:	89 f0                	mov    %esi,%eax
  801ee7:	eb 43                	jmp    801f2c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ee9:	89 da                	mov    %ebx,%edx
  801eeb:	89 f8                	mov    %edi,%eax
  801eed:	e8 f1 fe ff ff       	call   801de3 <_pipeisclosed>
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	75 31                	jne    801f27 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ef6:	e8 89 ec ff ff       	call   800b84 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801efb:	8b 03                	mov    (%ebx),%eax
  801efd:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f00:	74 df                	je     801ee1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f02:	99                   	cltd   
  801f03:	c1 ea 1b             	shr    $0x1b,%edx
  801f06:	01 d0                	add    %edx,%eax
  801f08:	83 e0 1f             	and    $0x1f,%eax
  801f0b:	29 d0                	sub    %edx,%eax
  801f0d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f15:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f18:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f1b:	83 c6 01             	add    $0x1,%esi
  801f1e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f21:	75 d8                	jne    801efb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f23:	89 f0                	mov    %esi,%eax
  801f25:	eb 05                	jmp    801f2c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f2c:	83 c4 1c             	add    $0x1c,%esp
  801f2f:	5b                   	pop    %ebx
  801f30:	5e                   	pop    %esi
  801f31:	5f                   	pop    %edi
  801f32:	5d                   	pop    %ebp
  801f33:	c3                   	ret    

00801f34 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	56                   	push   %esi
  801f38:	53                   	push   %ebx
  801f39:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3f:	89 04 24             	mov    %eax,(%esp)
  801f42:	e8 b0 f0 ff ff       	call   800ff7 <fd_alloc>
  801f47:	89 c2                	mov    %eax,%edx
  801f49:	85 d2                	test   %edx,%edx
  801f4b:	0f 88 4d 01 00 00    	js     80209e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f51:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f58:	00 
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f67:	e8 37 ec ff ff       	call   800ba3 <sys_page_alloc>
  801f6c:	89 c2                	mov    %eax,%edx
  801f6e:	85 d2                	test   %edx,%edx
  801f70:	0f 88 28 01 00 00    	js     80209e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f76:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f79:	89 04 24             	mov    %eax,(%esp)
  801f7c:	e8 76 f0 ff ff       	call   800ff7 <fd_alloc>
  801f81:	89 c3                	mov    %eax,%ebx
  801f83:	85 c0                	test   %eax,%eax
  801f85:	0f 88 fe 00 00 00    	js     802089 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f8b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f92:	00 
  801f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa1:	e8 fd eb ff ff       	call   800ba3 <sys_page_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	0f 88 d9 00 00 00    	js     802089 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	89 04 24             	mov    %eax,(%esp)
  801fb6:	e8 25 f0 ff ff       	call   800fe0 <fd2data>
  801fbb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fc4:	00 
  801fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd0:	e8 ce eb ff ff       	call   800ba3 <sys_page_alloc>
  801fd5:	89 c3                	mov    %eax,%ebx
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	0f 88 97 00 00 00    	js     802076 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe2:	89 04 24             	mov    %eax,(%esp)
  801fe5:	e8 f6 ef ff ff       	call   800fe0 <fd2data>
  801fea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801ff1:	00 
  801ff2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ff6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ffd:	00 
  801ffe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802002:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802009:	e8 e9 eb ff ff       	call   800bf7 <sys_page_map>
  80200e:	89 c3                	mov    %eax,%ebx
  802010:	85 c0                	test   %eax,%eax
  802012:	78 52                	js     802066 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802014:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802029:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80202f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802032:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802037:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	89 04 24             	mov    %eax,(%esp)
  802044:	e8 87 ef ff ff       	call   800fd0 <fd2num>
  802049:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80204c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802051:	89 04 24             	mov    %eax,(%esp)
  802054:	e8 77 ef ff ff       	call   800fd0 <fd2num>
  802059:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80205c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
  802064:	eb 38                	jmp    80209e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802066:	89 74 24 04          	mov    %esi,0x4(%esp)
  80206a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802071:	e8 d4 eb ff ff       	call   800c4a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802079:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802084:	e8 c1 eb ff ff       	call   800c4a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802090:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802097:	e8 ae eb ff ff       	call   800c4a <sys_page_unmap>
  80209c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80209e:	83 c4 30             	add    $0x30,%esp
  8020a1:	5b                   	pop    %ebx
  8020a2:	5e                   	pop    %esi
  8020a3:	5d                   	pop    %ebp
  8020a4:	c3                   	ret    

008020a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	89 04 24             	mov    %eax,(%esp)
  8020b8:	e8 89 ef ff ff       	call   801046 <fd_lookup>
  8020bd:	89 c2                	mov    %eax,%edx
  8020bf:	85 d2                	test   %edx,%edx
  8020c1:	78 15                	js     8020d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	89 04 24             	mov    %eax,(%esp)
  8020c9:	e8 12 ef ff ff       	call   800fe0 <fd2data>
	return _pipeisclosed(fd, p);
  8020ce:	89 c2                	mov    %eax,%edx
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	e8 0b fd ff ff       	call   801de3 <_pipeisclosed>
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	66 90                	xchg   %ax,%ax
  8020de:	66 90                	xchg   %ax,%ax

008020e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    

008020ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8020f0:	c7 44 24 04 73 2b 80 	movl   $0x802b73,0x4(%esp)
  8020f7:	00 
  8020f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fb:	89 04 24             	mov    %eax,(%esp)
  8020fe:	e8 84 e6 ff ff       	call   800787 <strcpy>
	return 0;
}
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	57                   	push   %edi
  80210e:	56                   	push   %esi
  80210f:	53                   	push   %ebx
  802110:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802116:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80211b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802121:	eb 31                	jmp    802154 <devcons_write+0x4a>
		m = n - tot;
  802123:	8b 75 10             	mov    0x10(%ebp),%esi
  802126:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802128:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80212b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802130:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802133:	89 74 24 08          	mov    %esi,0x8(%esp)
  802137:	03 45 0c             	add    0xc(%ebp),%eax
  80213a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213e:	89 3c 24             	mov    %edi,(%esp)
  802141:	e8 de e7 ff ff       	call   800924 <memmove>
		sys_cputs(buf, m);
  802146:	89 74 24 04          	mov    %esi,0x4(%esp)
  80214a:	89 3c 24             	mov    %edi,(%esp)
  80214d:	e8 84 e9 ff ff       	call   800ad6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802152:	01 f3                	add    %esi,%ebx
  802154:	89 d8                	mov    %ebx,%eax
  802156:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802159:	72 c8                	jb     802123 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80215b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5f                   	pop    %edi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    

00802166 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802171:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802175:	75 07                	jne    80217e <devcons_read+0x18>
  802177:	eb 2a                	jmp    8021a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802179:	e8 06 ea ff ff       	call   800b84 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80217e:	66 90                	xchg   %ax,%ax
  802180:	e8 6f e9 ff ff       	call   800af4 <sys_cgetc>
  802185:	85 c0                	test   %eax,%eax
  802187:	74 f0                	je     802179 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802189:	85 c0                	test   %eax,%eax
  80218b:	78 16                	js     8021a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80218d:	83 f8 04             	cmp    $0x4,%eax
  802190:	74 0c                	je     80219e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802192:	8b 55 0c             	mov    0xc(%ebp),%edx
  802195:	88 02                	mov    %al,(%edx)
	return 1;
  802197:	b8 01 00 00 00       	mov    $0x1,%eax
  80219c:	eb 05                	jmp    8021a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021b8:	00 
  8021b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021bc:	89 04 24             	mov    %eax,(%esp)
  8021bf:	e8 12 e9 ff ff       	call   800ad6 <sys_cputs>
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <getchar>:

int
getchar(void)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021d3:	00 
  8021d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e2:	e8 f3 f0 ff ff       	call   8012da <read>
	if (r < 0)
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	78 0f                	js     8021fa <getchar+0x34>
		return r;
	if (r < 1)
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	7e 06                	jle    8021f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8021ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8021f3:	eb 05                	jmp    8021fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8021f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802202:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802205:	89 44 24 04          	mov    %eax,0x4(%esp)
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	89 04 24             	mov    %eax,(%esp)
  80220f:	e8 32 ee ff ff       	call   801046 <fd_lookup>
  802214:	85 c0                	test   %eax,%eax
  802216:	78 11                	js     802229 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802221:	39 10                	cmp    %edx,(%eax)
  802223:	0f 94 c0             	sete   %al
  802226:	0f b6 c0             	movzbl %al,%eax
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <opencons>:

int
opencons(void)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802231:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802234:	89 04 24             	mov    %eax,(%esp)
  802237:	e8 bb ed ff ff       	call   800ff7 <fd_alloc>
		return r;
  80223c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 40                	js     802282 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802242:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802249:	00 
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802258:	e8 46 e9 ff ff       	call   800ba3 <sys_page_alloc>
		return r;
  80225d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80225f:	85 c0                	test   %eax,%eax
  802261:	78 1f                	js     802282 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802263:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802278:	89 04 24             	mov    %eax,(%esp)
  80227b:	e8 50 ed ff ff       	call   800fd0 <fd2num>
  802280:	89 c2                	mov    %eax,%edx
}
  802282:	89 d0                	mov    %edx,%eax
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
  802289:	56                   	push   %esi
  80228a:	53                   	push   %ebx
  80228b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80228e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802291:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802297:	e8 c9 e8 ff ff       	call   800b65 <sys_getenvid>
  80229c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229f:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022aa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b2:	c7 04 24 80 2b 80 00 	movl   $0x802b80,(%esp)
  8022b9:	e8 9a de ff ff       	call   800158 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c5:	89 04 24             	mov    %eax,(%esp)
  8022c8:	e8 2a de ff ff       	call   8000f7 <vcprintf>
	cprintf("\n");
  8022cd:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  8022d4:	e8 7f de ff ff       	call   800158 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022d9:	cc                   	int3   
  8022da:	eb fd                	jmp    8022d9 <_panic+0x53>
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	56                   	push   %esi
  8022e4:	53                   	push   %ebx
  8022e5:	83 ec 10             	sub    $0x10,%esp
  8022e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8022f1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8022f3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022f8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8022fb:	89 04 24             	mov    %eax,(%esp)
  8022fe:	e8 b6 ea ff ff       	call   800db9 <sys_ipc_recv>
  802303:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802305:	85 d2                	test   %edx,%edx
  802307:	75 24                	jne    80232d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802309:	85 f6                	test   %esi,%esi
  80230b:	74 0a                	je     802317 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80230d:	a1 08 40 80 00       	mov    0x804008,%eax
  802312:	8b 40 74             	mov    0x74(%eax),%eax
  802315:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802317:	85 db                	test   %ebx,%ebx
  802319:	74 0a                	je     802325 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80231b:	a1 08 40 80 00       	mov    0x804008,%eax
  802320:	8b 40 78             	mov    0x78(%eax),%eax
  802323:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802325:	a1 08 40 80 00       	mov    0x804008,%eax
  80232a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80232d:	83 c4 10             	add    $0x10,%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5d                   	pop    %ebp
  802333:	c3                   	ret    

00802334 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	57                   	push   %edi
  802338:	56                   	push   %esi
  802339:	53                   	push   %ebx
  80233a:	83 ec 1c             	sub    $0x1c,%esp
  80233d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802340:	8b 75 0c             	mov    0xc(%ebp),%esi
  802343:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802346:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802348:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80234d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802350:	8b 45 14             	mov    0x14(%ebp),%eax
  802353:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802357:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80235b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80235f:	89 3c 24             	mov    %edi,(%esp)
  802362:	e8 2f ea ff ff       	call   800d96 <sys_ipc_try_send>

		if (ret == 0)
  802367:	85 c0                	test   %eax,%eax
  802369:	74 2c                	je     802397 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80236b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80236e:	74 20                	je     802390 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802370:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802374:	c7 44 24 08 a4 2b 80 	movl   $0x802ba4,0x8(%esp)
  80237b:	00 
  80237c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802383:	00 
  802384:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  80238b:	e8 f6 fe ff ff       	call   802286 <_panic>
		}

		sys_yield();
  802390:	e8 ef e7 ff ff       	call   800b84 <sys_yield>
	}
  802395:	eb b9                	jmp    802350 <ipc_send+0x1c>
}
  802397:	83 c4 1c             	add    $0x1c,%esp
  80239a:	5b                   	pop    %ebx
  80239b:	5e                   	pop    %esi
  80239c:	5f                   	pop    %edi
  80239d:	5d                   	pop    %ebp
  80239e:	c3                   	ret    

0080239f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023aa:	89 c2                	mov    %eax,%edx
  8023ac:	c1 e2 07             	shl    $0x7,%edx
  8023af:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8023b6:	8b 52 50             	mov    0x50(%edx),%edx
  8023b9:	39 ca                	cmp    %ecx,%edx
  8023bb:	75 11                	jne    8023ce <ipc_find_env+0x2f>
			return envs[i].env_id;
  8023bd:	89 c2                	mov    %eax,%edx
  8023bf:	c1 e2 07             	shl    $0x7,%edx
  8023c2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8023c9:	8b 40 40             	mov    0x40(%eax),%eax
  8023cc:	eb 0e                	jmp    8023dc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023ce:	83 c0 01             	add    $0x1,%eax
  8023d1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023d6:	75 d2                	jne    8023aa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023d8:	66 b8 00 00          	mov    $0x0,%ax
}
  8023dc:	5d                   	pop    %ebp
  8023dd:	c3                   	ret    

008023de <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023e4:	89 d0                	mov    %edx,%eax
  8023e6:	c1 e8 16             	shr    $0x16,%eax
  8023e9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023f0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023f5:	f6 c1 01             	test   $0x1,%cl
  8023f8:	74 1d                	je     802417 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023fa:	c1 ea 0c             	shr    $0xc,%edx
  8023fd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802404:	f6 c2 01             	test   $0x1,%dl
  802407:	74 0e                	je     802417 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802409:	c1 ea 0c             	shr    $0xc,%edx
  80240c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802413:	ef 
  802414:	0f b7 c0             	movzwl %ax,%eax
}
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    
  802419:	66 90                	xchg   %ax,%ax
  80241b:	66 90                	xchg   %ax,%ax
  80241d:	66 90                	xchg   %ax,%ax
  80241f:	90                   	nop

00802420 <__udivdi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	83 ec 0c             	sub    $0xc,%esp
  802426:	8b 44 24 28          	mov    0x28(%esp),%eax
  80242a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80242e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802432:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802436:	85 c0                	test   %eax,%eax
  802438:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80243c:	89 ea                	mov    %ebp,%edx
  80243e:	89 0c 24             	mov    %ecx,(%esp)
  802441:	75 2d                	jne    802470 <__udivdi3+0x50>
  802443:	39 e9                	cmp    %ebp,%ecx
  802445:	77 61                	ja     8024a8 <__udivdi3+0x88>
  802447:	85 c9                	test   %ecx,%ecx
  802449:	89 ce                	mov    %ecx,%esi
  80244b:	75 0b                	jne    802458 <__udivdi3+0x38>
  80244d:	b8 01 00 00 00       	mov    $0x1,%eax
  802452:	31 d2                	xor    %edx,%edx
  802454:	f7 f1                	div    %ecx
  802456:	89 c6                	mov    %eax,%esi
  802458:	31 d2                	xor    %edx,%edx
  80245a:	89 e8                	mov    %ebp,%eax
  80245c:	f7 f6                	div    %esi
  80245e:	89 c5                	mov    %eax,%ebp
  802460:	89 f8                	mov    %edi,%eax
  802462:	f7 f6                	div    %esi
  802464:	89 ea                	mov    %ebp,%edx
  802466:	83 c4 0c             	add    $0xc,%esp
  802469:	5e                   	pop    %esi
  80246a:	5f                   	pop    %edi
  80246b:	5d                   	pop    %ebp
  80246c:	c3                   	ret    
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	39 e8                	cmp    %ebp,%eax
  802472:	77 24                	ja     802498 <__udivdi3+0x78>
  802474:	0f bd e8             	bsr    %eax,%ebp
  802477:	83 f5 1f             	xor    $0x1f,%ebp
  80247a:	75 3c                	jne    8024b8 <__udivdi3+0x98>
  80247c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802480:	39 34 24             	cmp    %esi,(%esp)
  802483:	0f 86 9f 00 00 00    	jbe    802528 <__udivdi3+0x108>
  802489:	39 d0                	cmp    %edx,%eax
  80248b:	0f 82 97 00 00 00    	jb     802528 <__udivdi3+0x108>
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	31 d2                	xor    %edx,%edx
  80249a:	31 c0                	xor    %eax,%eax
  80249c:	83 c4 0c             	add    $0xc,%esp
  80249f:	5e                   	pop    %esi
  8024a0:	5f                   	pop    %edi
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    
  8024a3:	90                   	nop
  8024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	89 f8                	mov    %edi,%eax
  8024aa:	f7 f1                	div    %ecx
  8024ac:	31 d2                	xor    %edx,%edx
  8024ae:	83 c4 0c             	add    $0xc,%esp
  8024b1:	5e                   	pop    %esi
  8024b2:	5f                   	pop    %edi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    
  8024b5:	8d 76 00             	lea    0x0(%esi),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	8b 3c 24             	mov    (%esp),%edi
  8024bd:	d3 e0                	shl    %cl,%eax
  8024bf:	89 c6                	mov    %eax,%esi
  8024c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024c6:	29 e8                	sub    %ebp,%eax
  8024c8:	89 c1                	mov    %eax,%ecx
  8024ca:	d3 ef                	shr    %cl,%edi
  8024cc:	89 e9                	mov    %ebp,%ecx
  8024ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024d2:	8b 3c 24             	mov    (%esp),%edi
  8024d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024d9:	89 d6                	mov    %edx,%esi
  8024db:	d3 e7                	shl    %cl,%edi
  8024dd:	89 c1                	mov    %eax,%ecx
  8024df:	89 3c 24             	mov    %edi,(%esp)
  8024e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024e6:	d3 ee                	shr    %cl,%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	d3 e2                	shl    %cl,%edx
  8024ec:	89 c1                	mov    %eax,%ecx
  8024ee:	d3 ef                	shr    %cl,%edi
  8024f0:	09 d7                	or     %edx,%edi
  8024f2:	89 f2                	mov    %esi,%edx
  8024f4:	89 f8                	mov    %edi,%eax
  8024f6:	f7 74 24 08          	divl   0x8(%esp)
  8024fa:	89 d6                	mov    %edx,%esi
  8024fc:	89 c7                	mov    %eax,%edi
  8024fe:	f7 24 24             	mull   (%esp)
  802501:	39 d6                	cmp    %edx,%esi
  802503:	89 14 24             	mov    %edx,(%esp)
  802506:	72 30                	jb     802538 <__udivdi3+0x118>
  802508:	8b 54 24 04          	mov    0x4(%esp),%edx
  80250c:	89 e9                	mov    %ebp,%ecx
  80250e:	d3 e2                	shl    %cl,%edx
  802510:	39 c2                	cmp    %eax,%edx
  802512:	73 05                	jae    802519 <__udivdi3+0xf9>
  802514:	3b 34 24             	cmp    (%esp),%esi
  802517:	74 1f                	je     802538 <__udivdi3+0x118>
  802519:	89 f8                	mov    %edi,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	e9 7a ff ff ff       	jmp    80249c <__udivdi3+0x7c>
  802522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802528:	31 d2                	xor    %edx,%edx
  80252a:	b8 01 00 00 00       	mov    $0x1,%eax
  80252f:	e9 68 ff ff ff       	jmp    80249c <__udivdi3+0x7c>
  802534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802538:	8d 47 ff             	lea    -0x1(%edi),%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	83 c4 0c             	add    $0xc,%esp
  802540:	5e                   	pop    %esi
  802541:	5f                   	pop    %edi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
  802544:	66 90                	xchg   %ax,%ax
  802546:	66 90                	xchg   %ax,%ax
  802548:	66 90                	xchg   %ax,%ax
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__umoddi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	83 ec 14             	sub    $0x14,%esp
  802556:	8b 44 24 28          	mov    0x28(%esp),%eax
  80255a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80255e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802562:	89 c7                	mov    %eax,%edi
  802564:	89 44 24 04          	mov    %eax,0x4(%esp)
  802568:	8b 44 24 30          	mov    0x30(%esp),%eax
  80256c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802570:	89 34 24             	mov    %esi,(%esp)
  802573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802577:	85 c0                	test   %eax,%eax
  802579:	89 c2                	mov    %eax,%edx
  80257b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80257f:	75 17                	jne    802598 <__umoddi3+0x48>
  802581:	39 fe                	cmp    %edi,%esi
  802583:	76 4b                	jbe    8025d0 <__umoddi3+0x80>
  802585:	89 c8                	mov    %ecx,%eax
  802587:	89 fa                	mov    %edi,%edx
  802589:	f7 f6                	div    %esi
  80258b:	89 d0                	mov    %edx,%eax
  80258d:	31 d2                	xor    %edx,%edx
  80258f:	83 c4 14             	add    $0x14,%esp
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	66 90                	xchg   %ax,%ax
  802598:	39 f8                	cmp    %edi,%eax
  80259a:	77 54                	ja     8025f0 <__umoddi3+0xa0>
  80259c:	0f bd e8             	bsr    %eax,%ebp
  80259f:	83 f5 1f             	xor    $0x1f,%ebp
  8025a2:	75 5c                	jne    802600 <__umoddi3+0xb0>
  8025a4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025a8:	39 3c 24             	cmp    %edi,(%esp)
  8025ab:	0f 87 e7 00 00 00    	ja     802698 <__umoddi3+0x148>
  8025b1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025b5:	29 f1                	sub    %esi,%ecx
  8025b7:	19 c7                	sbb    %eax,%edi
  8025b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025c1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025c5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025c9:	83 c4 14             	add    $0x14,%esp
  8025cc:	5e                   	pop    %esi
  8025cd:	5f                   	pop    %edi
  8025ce:	5d                   	pop    %ebp
  8025cf:	c3                   	ret    
  8025d0:	85 f6                	test   %esi,%esi
  8025d2:	89 f5                	mov    %esi,%ebp
  8025d4:	75 0b                	jne    8025e1 <__umoddi3+0x91>
  8025d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	f7 f6                	div    %esi
  8025df:	89 c5                	mov    %eax,%ebp
  8025e1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025e5:	31 d2                	xor    %edx,%edx
  8025e7:	f7 f5                	div    %ebp
  8025e9:	89 c8                	mov    %ecx,%eax
  8025eb:	f7 f5                	div    %ebp
  8025ed:	eb 9c                	jmp    80258b <__umoddi3+0x3b>
  8025ef:	90                   	nop
  8025f0:	89 c8                	mov    %ecx,%eax
  8025f2:	89 fa                	mov    %edi,%edx
  8025f4:	83 c4 14             	add    $0x14,%esp
  8025f7:	5e                   	pop    %esi
  8025f8:	5f                   	pop    %edi
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    
  8025fb:	90                   	nop
  8025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802600:	8b 04 24             	mov    (%esp),%eax
  802603:	be 20 00 00 00       	mov    $0x20,%esi
  802608:	89 e9                	mov    %ebp,%ecx
  80260a:	29 ee                	sub    %ebp,%esi
  80260c:	d3 e2                	shl    %cl,%edx
  80260e:	89 f1                	mov    %esi,%ecx
  802610:	d3 e8                	shr    %cl,%eax
  802612:	89 e9                	mov    %ebp,%ecx
  802614:	89 44 24 04          	mov    %eax,0x4(%esp)
  802618:	8b 04 24             	mov    (%esp),%eax
  80261b:	09 54 24 04          	or     %edx,0x4(%esp)
  80261f:	89 fa                	mov    %edi,%edx
  802621:	d3 e0                	shl    %cl,%eax
  802623:	89 f1                	mov    %esi,%ecx
  802625:	89 44 24 08          	mov    %eax,0x8(%esp)
  802629:	8b 44 24 10          	mov    0x10(%esp),%eax
  80262d:	d3 ea                	shr    %cl,%edx
  80262f:	89 e9                	mov    %ebp,%ecx
  802631:	d3 e7                	shl    %cl,%edi
  802633:	89 f1                	mov    %esi,%ecx
  802635:	d3 e8                	shr    %cl,%eax
  802637:	89 e9                	mov    %ebp,%ecx
  802639:	09 f8                	or     %edi,%eax
  80263b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80263f:	f7 74 24 04          	divl   0x4(%esp)
  802643:	d3 e7                	shl    %cl,%edi
  802645:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802649:	89 d7                	mov    %edx,%edi
  80264b:	f7 64 24 08          	mull   0x8(%esp)
  80264f:	39 d7                	cmp    %edx,%edi
  802651:	89 c1                	mov    %eax,%ecx
  802653:	89 14 24             	mov    %edx,(%esp)
  802656:	72 2c                	jb     802684 <__umoddi3+0x134>
  802658:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80265c:	72 22                	jb     802680 <__umoddi3+0x130>
  80265e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802662:	29 c8                	sub    %ecx,%eax
  802664:	19 d7                	sbb    %edx,%edi
  802666:	89 e9                	mov    %ebp,%ecx
  802668:	89 fa                	mov    %edi,%edx
  80266a:	d3 e8                	shr    %cl,%eax
  80266c:	89 f1                	mov    %esi,%ecx
  80266e:	d3 e2                	shl    %cl,%edx
  802670:	89 e9                	mov    %ebp,%ecx
  802672:	d3 ef                	shr    %cl,%edi
  802674:	09 d0                	or     %edx,%eax
  802676:	89 fa                	mov    %edi,%edx
  802678:	83 c4 14             	add    $0x14,%esp
  80267b:	5e                   	pop    %esi
  80267c:	5f                   	pop    %edi
  80267d:	5d                   	pop    %ebp
  80267e:	c3                   	ret    
  80267f:	90                   	nop
  802680:	39 d7                	cmp    %edx,%edi
  802682:	75 da                	jne    80265e <__umoddi3+0x10e>
  802684:	8b 14 24             	mov    (%esp),%edx
  802687:	89 c1                	mov    %eax,%ecx
  802689:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80268d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802691:	eb cb                	jmp    80265e <__umoddi3+0x10e>
  802693:	90                   	nop
  802694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802698:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80269c:	0f 82 0f ff ff ff    	jb     8025b1 <__umoddi3+0x61>
  8026a2:	e9 1a ff ff ff       	jmp    8025c1 <__umoddi3+0x71>
