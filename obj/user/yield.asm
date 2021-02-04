
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 6d 00 00 00       	call   80009e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	89 44 24 04          	mov    %eax,0x4(%esp)
  800046:	c7 04 24 00 27 80 00 	movl   $0x802700,(%esp)
  80004d:	e8 54 01 00 00       	call   8001a6 <cprintf>
	for (i = 0; i < 5; i++) {
  800052:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800057:	e8 68 0b 00 00       	call   800bc4 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005c:	a1 08 40 80 00       	mov    0x804008,%eax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  800061:	8b 40 48             	mov    0x48(%eax),%eax
  800064:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006c:	c7 04 24 20 27 80 00 	movl   $0x802720,(%esp)
  800073:	e8 2e 01 00 00       	call   8001a6 <cprintf>
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  800078:	83 c3 01             	add    $0x1,%ebx
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d7                	jne    800057 <umain+0x24>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 08 40 80 00       	mov    0x804008,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008c:	c7 04 24 4c 27 80 00 	movl   $0x80274c,(%esp)
  800093:	e8 0e 01 00 00       	call   8001a6 <cprintf>
}
  800098:	83 c4 14             	add    $0x14,%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5d                   	pop    %ebp
  80009d:	c3                   	ret    

0080009e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	56                   	push   %esi
  8000a2:	53                   	push   %ebx
  8000a3:	83 ec 10             	sub    $0x10,%esp
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8000ac:	e8 f4 0a 00 00       	call   800ba5 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	89 c2                	mov    %eax,%edx
  8000b8:	c1 e2 07             	shl    $0x7,%edx
  8000bb:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8000c2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	85 db                	test   %ebx,%ebx
  8000c9:	7e 07                	jle    8000d2 <libmain+0x34>
		binaryname = argv[0];
  8000cb:	8b 06                	mov    (%esi),%eax
  8000cd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000d6:	89 1c 24             	mov    %ebx,(%esp)
  8000d9:	e8 55 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000de:	e8 07 00 00 00       	call   8000ea <exit>
}
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5d                   	pop    %ebp
  8000e9:	c3                   	ret    

008000ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000f0:	e8 f5 10 00 00       	call   8011ea <close_all>
	sys_env_destroy(0);
  8000f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000fc:	e8 52 0a 00 00       	call   800b53 <sys_env_destroy>
}
  800101:	c9                   	leave  
  800102:	c3                   	ret    

00800103 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	53                   	push   %ebx
  800107:	83 ec 14             	sub    $0x14,%esp
  80010a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010d:	8b 13                	mov    (%ebx),%edx
  80010f:	8d 42 01             	lea    0x1(%edx),%eax
  800112:	89 03                	mov    %eax,(%ebx)
  800114:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800117:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800120:	75 19                	jne    80013b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800122:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800129:	00 
  80012a:	8d 43 08             	lea    0x8(%ebx),%eax
  80012d:	89 04 24             	mov    %eax,(%esp)
  800130:	e8 e1 09 00 00       	call   800b16 <sys_cputs>
		b->idx = 0;
  800135:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80013b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013f:	83 c4 14             	add    $0x14,%esp
  800142:	5b                   	pop    %ebx
  800143:	5d                   	pop    %ebp
  800144:	c3                   	ret    

00800145 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80014e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800155:	00 00 00 
	b.cnt = 0;
  800158:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800162:	8b 45 0c             	mov    0xc(%ebp),%eax
  800165:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800169:	8b 45 08             	mov    0x8(%ebp),%eax
  80016c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800170:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800176:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017a:	c7 04 24 03 01 80 00 	movl   $0x800103,(%esp)
  800181:	e8 a8 01 00 00       	call   80032e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800186:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800190:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800196:	89 04 24             	mov    %eax,(%esp)
  800199:	e8 78 09 00 00       	call   800b16 <sys_cputs>

	return b.cnt;
}
  80019e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 87 ff ff ff       	call   800145 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    

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
  80022f:	e8 2c 22 00 00       	call   802460 <__udivdi3>
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
  80028f:	e8 fc 22 00 00       	call   802590 <__umoddi3>
  800294:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800298:	0f be 80 75 27 80 00 	movsbl 0x802775(%eax),%eax
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
  8003b3:	ff 24 8d 00 29 80 00 	jmp    *0x802900(,%ecx,4)
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
  800450:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  800457:	85 d2                	test   %edx,%edx
  800459:	75 20                	jne    80047b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80045b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045f:	c7 44 24 08 8d 27 80 	movl   $0x80278d,0x8(%esp)
  800466:	00 
  800467:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	89 04 24             	mov    %eax,(%esp)
  800471:	e8 90 fe ff ff       	call   800306 <printfmt>
  800476:	e9 d8 fe ff ff       	jmp    800353 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80047b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80047f:	c7 44 24 08 a1 2b 80 	movl   $0x802ba1,0x8(%esp)
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
  8004b1:	b8 86 27 80 00       	mov    $0x802786,%eax
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
  800b81:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800b88:	00 
  800b89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b90:	00 
  800b91:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800b98:	e8 29 17 00 00       	call   8022c6 <_panic>

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
  800c13:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800c1a:	00 
  800c1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c22:	00 
  800c23:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800c2a:	e8 97 16 00 00       	call   8022c6 <_panic>

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
  800c66:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800c6d:	00 
  800c6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c75:	00 
  800c76:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800c7d:	e8 44 16 00 00       	call   8022c6 <_panic>

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
  800cb9:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800cc0:	00 
  800cc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc8:	00 
  800cc9:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800cd0:	e8 f1 15 00 00       	call   8022c6 <_panic>

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
  800d0c:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800d13:	00 
  800d14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d1b:	00 
  800d1c:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800d23:	e8 9e 15 00 00       	call   8022c6 <_panic>

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
  800d5f:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800d66:	00 
  800d67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6e:	00 
  800d6f:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800d76:	e8 4b 15 00 00       	call   8022c6 <_panic>

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
  800db2:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800db9:	00 
  800dba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc1:	00 
  800dc2:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800dc9:	e8 f8 14 00 00       	call   8022c6 <_panic>

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
  800e27:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800e2e:	00 
  800e2f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e36:	00 
  800e37:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800e3e:	e8 83 14 00 00       	call   8022c6 <_panic>

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
  800e99:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea8:	00 
  800ea9:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800eb0:	e8 11 14 00 00       	call   8022c6 <_panic>

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
  800eec:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efb:	00 
  800efc:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800f03:	e8 be 13 00 00       	call   8022c6 <_panic>

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
  800f3f:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800f46:	00 
  800f47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4e:	00 
  800f4f:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800f56:	e8 6b 13 00 00       	call   8022c6 <_panic>

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
  800f91:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800f98:	00 
  800f99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa0:	00 
  800fa1:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800fa8:	e8 19 13 00 00       	call   8022c6 <_panic>

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
  800fe4:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  800feb:	00 
  800fec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff3:	00 
  800ff4:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  800ffb:	e8 c6 12 00 00       	call   8022c6 <_panic>

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
  801008:	66 90                	xchg   %ax,%ax
  80100a:	66 90                	xchg   %ax,%ax
  80100c:	66 90                	xchg   %ax,%ax
  80100e:	66 90                	xchg   %ax,%ax

00801010 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	05 00 00 00 30       	add    $0x30000000,%eax
  80101b:	c1 e8 0c             	shr    $0xc,%eax
}
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80102b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801030:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801035:	5d                   	pop    %ebp
  801036:	c3                   	ret    

00801037 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80103d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801042:	89 c2                	mov    %eax,%edx
  801044:	c1 ea 16             	shr    $0x16,%edx
  801047:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104e:	f6 c2 01             	test   $0x1,%dl
  801051:	74 11                	je     801064 <fd_alloc+0x2d>
  801053:	89 c2                	mov    %eax,%edx
  801055:	c1 ea 0c             	shr    $0xc,%edx
  801058:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80105f:	f6 c2 01             	test   $0x1,%dl
  801062:	75 09                	jne    80106d <fd_alloc+0x36>
			*fd_store = fd;
  801064:	89 01                	mov    %eax,(%ecx)
			return 0;
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
  80106b:	eb 17                	jmp    801084 <fd_alloc+0x4d>
  80106d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801072:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801077:	75 c9                	jne    801042 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801079:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80107f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    

00801086 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80108c:	83 f8 1f             	cmp    $0x1f,%eax
  80108f:	77 36                	ja     8010c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801091:	c1 e0 0c             	shl    $0xc,%eax
  801094:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801099:	89 c2                	mov    %eax,%edx
  80109b:	c1 ea 16             	shr    $0x16,%edx
  80109e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010a5:	f6 c2 01             	test   $0x1,%dl
  8010a8:	74 24                	je     8010ce <fd_lookup+0x48>
  8010aa:	89 c2                	mov    %eax,%edx
  8010ac:	c1 ea 0c             	shr    $0xc,%edx
  8010af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b6:	f6 c2 01             	test   $0x1,%dl
  8010b9:	74 1a                	je     8010d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010be:	89 02                	mov    %eax,(%edx)
	return 0;
  8010c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c5:	eb 13                	jmp    8010da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cc:	eb 0c                	jmp    8010da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d3:	eb 05                	jmp    8010da <fd_lookup+0x54>
  8010d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 18             	sub    $0x18,%esp
  8010e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ea:	eb 13                	jmp    8010ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8010ec:	39 08                	cmp    %ecx,(%eax)
  8010ee:	75 0c                	jne    8010fc <dev_lookup+0x20>
			*dev = devtab[i];
  8010f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fa:	eb 38                	jmp    801134 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010fc:	83 c2 01             	add    $0x1,%edx
  8010ff:	8b 04 95 74 2b 80 00 	mov    0x802b74(,%edx,4),%eax
  801106:	85 c0                	test   %eax,%eax
  801108:	75 e2                	jne    8010ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80110a:	a1 08 40 80 00       	mov    0x804008,%eax
  80110f:	8b 40 48             	mov    0x48(%eax),%eax
  801112:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801116:	89 44 24 04          	mov    %eax,0x4(%esp)
  80111a:	c7 04 24 f8 2a 80 00 	movl   $0x802af8,(%esp)
  801121:	e8 80 f0 ff ff       	call   8001a6 <cprintf>
	*dev = 0;
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80112f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	83 ec 20             	sub    $0x20,%esp
  80113e:	8b 75 08             	mov    0x8(%ebp),%esi
  801141:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801144:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801147:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80114b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801151:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801154:	89 04 24             	mov    %eax,(%esp)
  801157:	e8 2a ff ff ff       	call   801086 <fd_lookup>
  80115c:	85 c0                	test   %eax,%eax
  80115e:	78 05                	js     801165 <fd_close+0x2f>
	    || fd != fd2)
  801160:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801163:	74 0c                	je     801171 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801165:	84 db                	test   %bl,%bl
  801167:	ba 00 00 00 00       	mov    $0x0,%edx
  80116c:	0f 44 c2             	cmove  %edx,%eax
  80116f:	eb 3f                	jmp    8011b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801171:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801174:	89 44 24 04          	mov    %eax,0x4(%esp)
  801178:	8b 06                	mov    (%esi),%eax
  80117a:	89 04 24             	mov    %eax,(%esp)
  80117d:	e8 5a ff ff ff       	call   8010dc <dev_lookup>
  801182:	89 c3                	mov    %eax,%ebx
  801184:	85 c0                	test   %eax,%eax
  801186:	78 16                	js     80119e <fd_close+0x68>
		if (dev->dev_close)
  801188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80118e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801193:	85 c0                	test   %eax,%eax
  801195:	74 07                	je     80119e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801197:	89 34 24             	mov    %esi,(%esp)
  80119a:	ff d0                	call   *%eax
  80119c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80119e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a9:	e8 dc fa ff ff       	call   800c8a <sys_page_unmap>
	return r;
  8011ae:	89 d8                	mov    %ebx,%eax
}
  8011b0:	83 c4 20             	add    $0x20,%esp
  8011b3:	5b                   	pop    %ebx
  8011b4:	5e                   	pop    %esi
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    

008011b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	89 04 24             	mov    %eax,(%esp)
  8011ca:	e8 b7 fe ff ff       	call   801086 <fd_lookup>
  8011cf:	89 c2                	mov    %eax,%edx
  8011d1:	85 d2                	test   %edx,%edx
  8011d3:	78 13                	js     8011e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8011d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011dc:	00 
  8011dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e0:	89 04 24             	mov    %eax,(%esp)
  8011e3:	e8 4e ff ff ff       	call   801136 <fd_close>
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <close_all>:

void
close_all(void)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011f6:	89 1c 24             	mov    %ebx,(%esp)
  8011f9:	e8 b9 ff ff ff       	call   8011b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011fe:	83 c3 01             	add    $0x1,%ebx
  801201:	83 fb 20             	cmp    $0x20,%ebx
  801204:	75 f0                	jne    8011f6 <close_all+0xc>
		close(i);
}
  801206:	83 c4 14             	add    $0x14,%esp
  801209:	5b                   	pop    %ebx
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	57                   	push   %edi
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
  801212:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801215:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	89 04 24             	mov    %eax,(%esp)
  801222:	e8 5f fe ff ff       	call   801086 <fd_lookup>
  801227:	89 c2                	mov    %eax,%edx
  801229:	85 d2                	test   %edx,%edx
  80122b:	0f 88 e1 00 00 00    	js     801312 <dup+0x106>
		return r;
	close(newfdnum);
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	89 04 24             	mov    %eax,(%esp)
  801237:	e8 7b ff ff ff       	call   8011b7 <close>

	newfd = INDEX2FD(newfdnum);
  80123c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80123f:	c1 e3 0c             	shl    $0xc,%ebx
  801242:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80124b:	89 04 24             	mov    %eax,(%esp)
  80124e:	e8 cd fd ff ff       	call   801020 <fd2data>
  801253:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801255:	89 1c 24             	mov    %ebx,(%esp)
  801258:	e8 c3 fd ff ff       	call   801020 <fd2data>
  80125d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80125f:	89 f0                	mov    %esi,%eax
  801261:	c1 e8 16             	shr    $0x16,%eax
  801264:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80126b:	a8 01                	test   $0x1,%al
  80126d:	74 43                	je     8012b2 <dup+0xa6>
  80126f:	89 f0                	mov    %esi,%eax
  801271:	c1 e8 0c             	shr    $0xc,%eax
  801274:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80127b:	f6 c2 01             	test   $0x1,%dl
  80127e:	74 32                	je     8012b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801280:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801287:	25 07 0e 00 00       	and    $0xe07,%eax
  80128c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801290:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801294:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80129b:	00 
  80129c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a7:	e8 8b f9 ff ff       	call   800c37 <sys_page_map>
  8012ac:	89 c6                	mov    %eax,%esi
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 3e                	js     8012f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b5:	89 c2                	mov    %eax,%edx
  8012b7:	c1 ea 0c             	shr    $0xc,%edx
  8012ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012d6:	00 
  8012d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e2:	e8 50 f9 ff ff       	call   800c37 <sys_page_map>
  8012e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012ec:	85 f6                	test   %esi,%esi
  8012ee:	79 22                	jns    801312 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012fb:	e8 8a f9 ff ff       	call   800c8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801300:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801304:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80130b:	e8 7a f9 ff ff       	call   800c8a <sys_page_unmap>
	return r;
  801310:	89 f0                	mov    %esi,%eax
}
  801312:	83 c4 3c             	add    $0x3c,%esp
  801315:	5b                   	pop    %ebx
  801316:	5e                   	pop    %esi
  801317:	5f                   	pop    %edi
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    

0080131a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	53                   	push   %ebx
  80131e:	83 ec 24             	sub    $0x24,%esp
  801321:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801324:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801327:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132b:	89 1c 24             	mov    %ebx,(%esp)
  80132e:	e8 53 fd ff ff       	call   801086 <fd_lookup>
  801333:	89 c2                	mov    %eax,%edx
  801335:	85 d2                	test   %edx,%edx
  801337:	78 6d                	js     8013a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801339:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	89 04 24             	mov    %eax,(%esp)
  801348:	e8 8f fd ff ff       	call   8010dc <dev_lookup>
  80134d:	85 c0                	test   %eax,%eax
  80134f:	78 55                	js     8013a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801354:	8b 50 08             	mov    0x8(%eax),%edx
  801357:	83 e2 03             	and    $0x3,%edx
  80135a:	83 fa 01             	cmp    $0x1,%edx
  80135d:	75 23                	jne    801382 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80135f:	a1 08 40 80 00       	mov    0x804008,%eax
  801364:	8b 40 48             	mov    0x48(%eax),%eax
  801367:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80136b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136f:	c7 04 24 39 2b 80 00 	movl   $0x802b39,(%esp)
  801376:	e8 2b ee ff ff       	call   8001a6 <cprintf>
		return -E_INVAL;
  80137b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801380:	eb 24                	jmp    8013a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801385:	8b 52 08             	mov    0x8(%edx),%edx
  801388:	85 d2                	test   %edx,%edx
  80138a:	74 15                	je     8013a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80138c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80138f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801393:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801396:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80139a:	89 04 24             	mov    %eax,(%esp)
  80139d:	ff d2                	call   *%edx
  80139f:	eb 05                	jmp    8013a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013a6:	83 c4 24             	add    $0x24,%esp
  8013a9:	5b                   	pop    %ebx
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    

008013ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	57                   	push   %edi
  8013b0:	56                   	push   %esi
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 1c             	sub    $0x1c,%esp
  8013b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c0:	eb 23                	jmp    8013e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013c2:	89 f0                	mov    %esi,%eax
  8013c4:	29 d8                	sub    %ebx,%eax
  8013c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013ca:	89 d8                	mov    %ebx,%eax
  8013cc:	03 45 0c             	add    0xc(%ebp),%eax
  8013cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d3:	89 3c 24             	mov    %edi,(%esp)
  8013d6:	e8 3f ff ff ff       	call   80131a <read>
		if (m < 0)
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	78 10                	js     8013ef <readn+0x43>
			return m;
		if (m == 0)
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	74 0a                	je     8013ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e3:	01 c3                	add    %eax,%ebx
  8013e5:	39 f3                	cmp    %esi,%ebx
  8013e7:	72 d9                	jb     8013c2 <readn+0x16>
  8013e9:	89 d8                	mov    %ebx,%eax
  8013eb:	eb 02                	jmp    8013ef <readn+0x43>
  8013ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013ef:	83 c4 1c             	add    $0x1c,%esp
  8013f2:	5b                   	pop    %ebx
  8013f3:	5e                   	pop    %esi
  8013f4:	5f                   	pop    %edi
  8013f5:	5d                   	pop    %ebp
  8013f6:	c3                   	ret    

008013f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 24             	sub    $0x24,%esp
  8013fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801401:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801404:	89 44 24 04          	mov    %eax,0x4(%esp)
  801408:	89 1c 24             	mov    %ebx,(%esp)
  80140b:	e8 76 fc ff ff       	call   801086 <fd_lookup>
  801410:	89 c2                	mov    %eax,%edx
  801412:	85 d2                	test   %edx,%edx
  801414:	78 68                	js     80147e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801416:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801419:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	89 04 24             	mov    %eax,(%esp)
  801425:	e8 b2 fc ff ff       	call   8010dc <dev_lookup>
  80142a:	85 c0                	test   %eax,%eax
  80142c:	78 50                	js     80147e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80142e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801431:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801435:	75 23                	jne    80145a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801437:	a1 08 40 80 00       	mov    0x804008,%eax
  80143c:	8b 40 48             	mov    0x48(%eax),%eax
  80143f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801443:	89 44 24 04          	mov    %eax,0x4(%esp)
  801447:	c7 04 24 55 2b 80 00 	movl   $0x802b55,(%esp)
  80144e:	e8 53 ed ff ff       	call   8001a6 <cprintf>
		return -E_INVAL;
  801453:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801458:	eb 24                	jmp    80147e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80145a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145d:	8b 52 0c             	mov    0xc(%edx),%edx
  801460:	85 d2                	test   %edx,%edx
  801462:	74 15                	je     801479 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801464:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801467:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80146b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801472:	89 04 24             	mov    %eax,(%esp)
  801475:	ff d2                	call   *%edx
  801477:	eb 05                	jmp    80147e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801479:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80147e:	83 c4 24             	add    $0x24,%esp
  801481:	5b                   	pop    %ebx
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <seek>:

int
seek(int fdnum, off_t offset)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80148a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80148d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	89 04 24             	mov    %eax,(%esp)
  801497:	e8 ea fb ff ff       	call   801086 <fd_lookup>
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 0e                	js     8014ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	53                   	push   %ebx
  8014b4:	83 ec 24             	sub    $0x24,%esp
  8014b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c1:	89 1c 24             	mov    %ebx,(%esp)
  8014c4:	e8 bd fb ff ff       	call   801086 <fd_lookup>
  8014c9:	89 c2                	mov    %eax,%edx
  8014cb:	85 d2                	test   %edx,%edx
  8014cd:	78 61                	js     801530 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d9:	8b 00                	mov    (%eax),%eax
  8014db:	89 04 24             	mov    %eax,(%esp)
  8014de:	e8 f9 fb ff ff       	call   8010dc <dev_lookup>
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	78 49                	js     801530 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ee:	75 23                	jne    801513 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014f0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014f5:	8b 40 48             	mov    0x48(%eax),%eax
  8014f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801500:	c7 04 24 18 2b 80 00 	movl   $0x802b18,(%esp)
  801507:	e8 9a ec ff ff       	call   8001a6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80150c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801511:	eb 1d                	jmp    801530 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801513:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801516:	8b 52 18             	mov    0x18(%edx),%edx
  801519:	85 d2                	test   %edx,%edx
  80151b:	74 0e                	je     80152b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80151d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801520:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	ff d2                	call   *%edx
  801529:	eb 05                	jmp    801530 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80152b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801530:	83 c4 24             	add    $0x24,%esp
  801533:	5b                   	pop    %ebx
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    

00801536 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	53                   	push   %ebx
  80153a:	83 ec 24             	sub    $0x24,%esp
  80153d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801540:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801543:	89 44 24 04          	mov    %eax,0x4(%esp)
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	89 04 24             	mov    %eax,(%esp)
  80154d:	e8 34 fb ff ff       	call   801086 <fd_lookup>
  801552:	89 c2                	mov    %eax,%edx
  801554:	85 d2                	test   %edx,%edx
  801556:	78 52                	js     8015aa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801558:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	8b 00                	mov    (%eax),%eax
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 70 fb ff ff       	call   8010dc <dev_lookup>
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 3a                	js     8015aa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801573:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801577:	74 2c                	je     8015a5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801579:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80157c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801583:	00 00 00 
	stat->st_isdir = 0;
  801586:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80158d:	00 00 00 
	stat->st_dev = dev;
  801590:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801596:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80159a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80159d:	89 14 24             	mov    %edx,(%esp)
  8015a0:	ff 50 14             	call   *0x14(%eax)
  8015a3:	eb 05                	jmp    8015aa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015aa:	83 c4 24             	add    $0x24,%esp
  8015ad:	5b                   	pop    %ebx
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    

008015b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	56                   	push   %esi
  8015b4:	53                   	push   %ebx
  8015b5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015bf:	00 
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	89 04 24             	mov    %eax,(%esp)
  8015c6:	e8 1b 02 00 00       	call   8017e6 <open>
  8015cb:	89 c3                	mov    %eax,%ebx
  8015cd:	85 db                	test   %ebx,%ebx
  8015cf:	78 1b                	js     8015ec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8015d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d8:	89 1c 24             	mov    %ebx,(%esp)
  8015db:	e8 56 ff ff ff       	call   801536 <fstat>
  8015e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015e2:	89 1c 24             	mov    %ebx,(%esp)
  8015e5:	e8 cd fb ff ff       	call   8011b7 <close>
	return r;
  8015ea:	89 f0                	mov    %esi,%eax
}
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	5b                   	pop    %ebx
  8015f0:	5e                   	pop    %esi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    

008015f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	56                   	push   %esi
  8015f7:	53                   	push   %ebx
  8015f8:	83 ec 10             	sub    $0x10,%esp
  8015fb:	89 c6                	mov    %eax,%esi
  8015fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ff:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801606:	75 11                	jne    801619 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801608:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80160f:	e8 cb 0d 00 00       	call   8023df <ipc_find_env>
  801614:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801619:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801620:	00 
  801621:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801628:	00 
  801629:	89 74 24 04          	mov    %esi,0x4(%esp)
  80162d:	a1 00 40 80 00       	mov    0x804000,%eax
  801632:	89 04 24             	mov    %eax,(%esp)
  801635:	e8 3a 0d 00 00       	call   802374 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80163a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801641:	00 
  801642:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801646:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80164d:	e8 ce 0c 00 00       	call   802320 <ipc_recv>
}
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	5b                   	pop    %ebx
  801656:	5e                   	pop    %esi
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	8b 40 0c             	mov    0xc(%eax),%eax
  801665:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801672:	ba 00 00 00 00       	mov    $0x0,%edx
  801677:	b8 02 00 00 00       	mov    $0x2,%eax
  80167c:	e8 72 ff ff ff       	call   8015f3 <fsipc>
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8b 40 0c             	mov    0xc(%eax),%eax
  80168f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801694:	ba 00 00 00 00       	mov    $0x0,%edx
  801699:	b8 06 00 00 00       	mov    $0x6,%eax
  80169e:	e8 50 ff ff ff       	call   8015f3 <fsipc>
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	53                   	push   %ebx
  8016a9:	83 ec 14             	sub    $0x14,%esp
  8016ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8016c4:	e8 2a ff ff ff       	call   8015f3 <fsipc>
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	85 d2                	test   %edx,%edx
  8016cd:	78 2b                	js     8016fa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016cf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016d6:	00 
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 e8 f0 ff ff       	call   8007c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016df:	a1 80 50 80 00       	mov    0x805080,%eax
  8016e4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ea:	a1 84 50 80 00       	mov    0x805084,%eax
  8016ef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fa:	83 c4 14             	add    $0x14,%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    

00801700 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 18             	sub    $0x18,%esp
  801706:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801709:	8b 55 08             	mov    0x8(%ebp),%edx
  80170c:	8b 52 0c             	mov    0xc(%edx),%edx
  80170f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801715:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80171a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80171e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801721:	89 44 24 04          	mov    %eax,0x4(%esp)
  801725:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80172c:	e8 9b f2 ff ff       	call   8009cc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801731:	ba 00 00 00 00       	mov    $0x0,%edx
  801736:	b8 04 00 00 00       	mov    $0x4,%eax
  80173b:	e8 b3 fe ff ff       	call   8015f3 <fsipc>
		return r;
	}

	return r;
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	56                   	push   %esi
  801746:	53                   	push   %ebx
  801747:	83 ec 10             	sub    $0x10,%esp
  80174a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	8b 40 0c             	mov    0xc(%eax),%eax
  801753:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801758:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80175e:	ba 00 00 00 00       	mov    $0x0,%edx
  801763:	b8 03 00 00 00       	mov    $0x3,%eax
  801768:	e8 86 fe ff ff       	call   8015f3 <fsipc>
  80176d:	89 c3                	mov    %eax,%ebx
  80176f:	85 c0                	test   %eax,%eax
  801771:	78 6a                	js     8017dd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801773:	39 c6                	cmp    %eax,%esi
  801775:	73 24                	jae    80179b <devfile_read+0x59>
  801777:	c7 44 24 0c 88 2b 80 	movl   $0x802b88,0xc(%esp)
  80177e:	00 
  80177f:	c7 44 24 08 8f 2b 80 	movl   $0x802b8f,0x8(%esp)
  801786:	00 
  801787:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80178e:	00 
  80178f:	c7 04 24 a4 2b 80 00 	movl   $0x802ba4,(%esp)
  801796:	e8 2b 0b 00 00       	call   8022c6 <_panic>
	assert(r <= PGSIZE);
  80179b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017a0:	7e 24                	jle    8017c6 <devfile_read+0x84>
  8017a2:	c7 44 24 0c af 2b 80 	movl   $0x802baf,0xc(%esp)
  8017a9:	00 
  8017aa:	c7 44 24 08 8f 2b 80 	movl   $0x802b8f,0x8(%esp)
  8017b1:	00 
  8017b2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8017b9:	00 
  8017ba:	c7 04 24 a4 2b 80 00 	movl   $0x802ba4,(%esp)
  8017c1:	e8 00 0b 00 00       	call   8022c6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ca:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017d1:	00 
  8017d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d5:	89 04 24             	mov    %eax,(%esp)
  8017d8:	e8 87 f1 ff ff       	call   800964 <memmove>
	return r;
}
  8017dd:	89 d8                	mov    %ebx,%eax
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	5b                   	pop    %ebx
  8017e3:	5e                   	pop    %esi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	53                   	push   %ebx
  8017ea:	83 ec 24             	sub    $0x24,%esp
  8017ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017f0:	89 1c 24             	mov    %ebx,(%esp)
  8017f3:	e8 98 ef ff ff       	call   800790 <strlen>
  8017f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017fd:	7f 60                	jg     80185f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801802:	89 04 24             	mov    %eax,(%esp)
  801805:	e8 2d f8 ff ff       	call   801037 <fd_alloc>
  80180a:	89 c2                	mov    %eax,%edx
  80180c:	85 d2                	test   %edx,%edx
  80180e:	78 54                	js     801864 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801810:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801814:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80181b:	e8 a7 ef ff ff       	call   8007c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801828:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182b:	b8 01 00 00 00       	mov    $0x1,%eax
  801830:	e8 be fd ff ff       	call   8015f3 <fsipc>
  801835:	89 c3                	mov    %eax,%ebx
  801837:	85 c0                	test   %eax,%eax
  801839:	79 17                	jns    801852 <open+0x6c>
		fd_close(fd, 0);
  80183b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801842:	00 
  801843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801846:	89 04 24             	mov    %eax,(%esp)
  801849:	e8 e8 f8 ff ff       	call   801136 <fd_close>
		return r;
  80184e:	89 d8                	mov    %ebx,%eax
  801850:	eb 12                	jmp    801864 <open+0x7e>
	}

	return fd2num(fd);
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	89 04 24             	mov    %eax,(%esp)
  801858:	e8 b3 f7 ff ff       	call   801010 <fd2num>
  80185d:	eb 05                	jmp    801864 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80185f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801864:	83 c4 24             	add    $0x24,%esp
  801867:	5b                   	pop    %ebx
  801868:	5d                   	pop    %ebp
  801869:	c3                   	ret    

0080186a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801870:	ba 00 00 00 00       	mov    $0x0,%edx
  801875:	b8 08 00 00 00       	mov    $0x8,%eax
  80187a:	e8 74 fd ff ff       	call   8015f3 <fsipc>
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    
  801881:	66 90                	xchg   %ax,%ax
  801883:	66 90                	xchg   %ax,%ax
  801885:	66 90                	xchg   %ax,%ax
  801887:	66 90                	xchg   %ax,%ax
  801889:	66 90                	xchg   %ax,%ax
  80188b:	66 90                	xchg   %ax,%ax
  80188d:	66 90                	xchg   %ax,%ax
  80188f:	90                   	nop

00801890 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801896:	c7 44 24 04 bb 2b 80 	movl   $0x802bbb,0x4(%esp)
  80189d:	00 
  80189e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a1:	89 04 24             	mov    %eax,(%esp)
  8018a4:	e8 1e ef ff ff       	call   8007c7 <strcpy>
	return 0;
}
  8018a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 14             	sub    $0x14,%esp
  8018b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018ba:	89 1c 24             	mov    %ebx,(%esp)
  8018bd:	e8 5c 0b 00 00       	call   80241e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8018c2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8018c7:	83 f8 01             	cmp    $0x1,%eax
  8018ca:	75 0d                	jne    8018d9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8018cc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8018cf:	89 04 24             	mov    %eax,(%esp)
  8018d2:	e8 29 03 00 00       	call   801c00 <nsipc_close>
  8018d7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8018d9:	89 d0                	mov    %edx,%eax
  8018db:	83 c4 14             	add    $0x14,%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5d                   	pop    %ebp
  8018e0:	c3                   	ret    

008018e1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018ee:	00 
  8018ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8b 40 0c             	mov    0xc(%eax),%eax
  801903:	89 04 24             	mov    %eax,(%esp)
  801906:	e8 f0 03 00 00       	call   801cfb <nsipc_send>
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801913:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80191a:	00 
  80191b:	8b 45 10             	mov    0x10(%ebp),%eax
  80191e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801922:	8b 45 0c             	mov    0xc(%ebp),%eax
  801925:	89 44 24 04          	mov    %eax,0x4(%esp)
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8b 40 0c             	mov    0xc(%eax),%eax
  80192f:	89 04 24             	mov    %eax,(%esp)
  801932:	e8 44 03 00 00       	call   801c7b <nsipc_recv>
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80193f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801942:	89 54 24 04          	mov    %edx,0x4(%esp)
  801946:	89 04 24             	mov    %eax,(%esp)
  801949:	e8 38 f7 ff ff       	call   801086 <fd_lookup>
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 17                	js     801969 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801955:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80195b:	39 08                	cmp    %ecx,(%eax)
  80195d:	75 05                	jne    801964 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80195f:	8b 40 0c             	mov    0xc(%eax),%eax
  801962:	eb 05                	jmp    801969 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801964:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	83 ec 20             	sub    $0x20,%esp
  801973:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801975:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801978:	89 04 24             	mov    %eax,(%esp)
  80197b:	e8 b7 f6 ff ff       	call   801037 <fd_alloc>
  801980:	89 c3                	mov    %eax,%ebx
  801982:	85 c0                	test   %eax,%eax
  801984:	78 21                	js     8019a7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801986:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80198d:	00 
  80198e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801991:	89 44 24 04          	mov    %eax,0x4(%esp)
  801995:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80199c:	e8 42 f2 ff ff       	call   800be3 <sys_page_alloc>
  8019a1:	89 c3                	mov    %eax,%ebx
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	79 0c                	jns    8019b3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8019a7:	89 34 24             	mov    %esi,(%esp)
  8019aa:	e8 51 02 00 00       	call   801c00 <nsipc_close>
		return r;
  8019af:	89 d8                	mov    %ebx,%eax
  8019b1:	eb 20                	jmp    8019d3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8019b3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8019c8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8019cb:	89 14 24             	mov    %edx,(%esp)
  8019ce:	e8 3d f6 ff ff       	call   801010 <fd2num>
}
  8019d3:	83 c4 20             	add    $0x20,%esp
  8019d6:	5b                   	pop    %ebx
  8019d7:	5e                   	pop    %esi
  8019d8:	5d                   	pop    %ebp
  8019d9:	c3                   	ret    

008019da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	e8 51 ff ff ff       	call   801939 <fd2sockid>
		return r;
  8019e8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	78 23                	js     801a11 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019ee:	8b 55 10             	mov    0x10(%ebp),%edx
  8019f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019fc:	89 04 24             	mov    %eax,(%esp)
  8019ff:	e8 45 01 00 00       	call   801b49 <nsipc_accept>
		return r;
  801a04:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 07                	js     801a11 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801a0a:	e8 5c ff ff ff       	call   80196b <alloc_sockfd>
  801a0f:	89 c1                	mov    %eax,%ecx
}
  801a11:	89 c8                	mov    %ecx,%eax
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	e8 16 ff ff ff       	call   801939 <fd2sockid>
  801a23:	89 c2                	mov    %eax,%edx
  801a25:	85 d2                	test   %edx,%edx
  801a27:	78 16                	js     801a3f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801a29:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a37:	89 14 24             	mov    %edx,(%esp)
  801a3a:	e8 60 01 00 00       	call   801b9f <nsipc_bind>
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <shutdown>:

int
shutdown(int s, int how)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	e8 ea fe ff ff       	call   801939 <fd2sockid>
  801a4f:	89 c2                	mov    %eax,%edx
  801a51:	85 d2                	test   %edx,%edx
  801a53:	78 0f                	js     801a64 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5c:	89 14 24             	mov    %edx,(%esp)
  801a5f:	e8 7a 01 00 00       	call   801bde <nsipc_shutdown>
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	e8 c5 fe ff ff       	call   801939 <fd2sockid>
  801a74:	89 c2                	mov    %eax,%edx
  801a76:	85 d2                	test   %edx,%edx
  801a78:	78 16                	js     801a90 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a88:	89 14 24             	mov    %edx,(%esp)
  801a8b:	e8 8a 01 00 00       	call   801c1a <nsipc_connect>
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <listen>:

int
listen(int s, int backlog)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	e8 99 fe ff ff       	call   801939 <fd2sockid>
  801aa0:	89 c2                	mov    %eax,%edx
  801aa2:	85 d2                	test   %edx,%edx
  801aa4:	78 0f                	js     801ab5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aad:	89 14 24             	mov    %edx,(%esp)
  801ab0:	e8 a4 01 00 00       	call   801c59 <nsipc_listen>
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801abd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	89 04 24             	mov    %eax,(%esp)
  801ad1:	e8 98 02 00 00       	call   801d6e <nsipc_socket>
  801ad6:	89 c2                	mov    %eax,%edx
  801ad8:	85 d2                	test   %edx,%edx
  801ada:	78 05                	js     801ae1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801adc:	e8 8a fe ff ff       	call   80196b <alloc_sockfd>
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 14             	sub    $0x14,%esp
  801aea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aec:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801af3:	75 11                	jne    801b06 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801af5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801afc:	e8 de 08 00 00       	call   8023df <ipc_find_env>
  801b01:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b06:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b0d:	00 
  801b0e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b15:	00 
  801b16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b1a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b1f:	89 04 24             	mov    %eax,(%esp)
  801b22:	e8 4d 08 00 00       	call   802374 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b2e:	00 
  801b2f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b36:	00 
  801b37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b3e:	e8 dd 07 00 00       	call   802320 <ipc_recv>
}
  801b43:	83 c4 14             	add    $0x14,%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    

00801b49 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	56                   	push   %esi
  801b4d:	53                   	push   %ebx
  801b4e:	83 ec 10             	sub    $0x10,%esp
  801b51:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b5c:	8b 06                	mov    (%esi),%eax
  801b5e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b63:	b8 01 00 00 00       	mov    $0x1,%eax
  801b68:	e8 76 ff ff ff       	call   801ae3 <nsipc>
  801b6d:	89 c3                	mov    %eax,%ebx
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 23                	js     801b96 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b73:	a1 10 60 80 00       	mov    0x806010,%eax
  801b78:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b7c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b83:	00 
  801b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b87:	89 04 24             	mov    %eax,(%esp)
  801b8a:	e8 d5 ed ff ff       	call   800964 <memmove>
		*addrlen = ret->ret_addrlen;
  801b8f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b94:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801b96:	89 d8                	mov    %ebx,%eax
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    

00801b9f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	53                   	push   %ebx
  801ba3:	83 ec 14             	sub    $0x14,%esp
  801ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bb1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801bc3:	e8 9c ed ff ff       	call   800964 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bc8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bce:	b8 02 00 00 00       	mov    $0x2,%eax
  801bd3:	e8 0b ff ff ff       	call   801ae3 <nsipc>
}
  801bd8:	83 c4 14             	add    $0x14,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5d                   	pop    %ebp
  801bdd:	c3                   	ret    

00801bde <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bef:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bf4:	b8 03 00 00 00       	mov    $0x3,%eax
  801bf9:	e8 e5 fe ff ff       	call   801ae3 <nsipc>
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <nsipc_close>:

int
nsipc_close(int s)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c0e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c13:	e8 cb fe ff ff       	call   801ae3 <nsipc>
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 14             	sub    $0x14,%esp
  801c21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c37:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c3e:	e8 21 ed ff ff       	call   800964 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c43:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c49:	b8 05 00 00 00       	mov    $0x5,%eax
  801c4e:	e8 90 fe ff ff       	call   801ae3 <nsipc>
}
  801c53:	83 c4 14             	add    $0x14,%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c6f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c74:	e8 6a fe ff ff       	call   801ae3 <nsipc>
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	56                   	push   %esi
  801c7f:	53                   	push   %ebx
  801c80:	83 ec 10             	sub    $0x10,%esp
  801c83:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c8e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c94:	8b 45 14             	mov    0x14(%ebp),%eax
  801c97:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c9c:	b8 07 00 00 00       	mov    $0x7,%eax
  801ca1:	e8 3d fe ff ff       	call   801ae3 <nsipc>
  801ca6:	89 c3                	mov    %eax,%ebx
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	78 46                	js     801cf2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801cac:	39 f0                	cmp    %esi,%eax
  801cae:	7f 07                	jg     801cb7 <nsipc_recv+0x3c>
  801cb0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cb5:	7e 24                	jle    801cdb <nsipc_recv+0x60>
  801cb7:	c7 44 24 0c c7 2b 80 	movl   $0x802bc7,0xc(%esp)
  801cbe:	00 
  801cbf:	c7 44 24 08 8f 2b 80 	movl   $0x802b8f,0x8(%esp)
  801cc6:	00 
  801cc7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801cce:	00 
  801ccf:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  801cd6:	e8 eb 05 00 00       	call   8022c6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cdb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cdf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ce6:	00 
  801ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cea:	89 04 24             	mov    %eax,(%esp)
  801ced:	e8 72 ec ff ff       	call   800964 <memmove>
	}

	return r;
}
  801cf2:	89 d8                	mov    %ebx,%eax
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	53                   	push   %ebx
  801cff:	83 ec 14             	sub    $0x14,%esp
  801d02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d0d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d13:	7e 24                	jle    801d39 <nsipc_send+0x3e>
  801d15:	c7 44 24 0c e8 2b 80 	movl   $0x802be8,0xc(%esp)
  801d1c:	00 
  801d1d:	c7 44 24 08 8f 2b 80 	movl   $0x802b8f,0x8(%esp)
  801d24:	00 
  801d25:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801d2c:	00 
  801d2d:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  801d34:	e8 8d 05 00 00       	call   8022c6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d39:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d44:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d4b:	e8 14 ec ff ff       	call   800964 <memmove>
	nsipcbuf.send.req_size = size;
  801d50:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d56:	8b 45 14             	mov    0x14(%ebp),%eax
  801d59:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d5e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d63:	e8 7b fd ff ff       	call   801ae3 <nsipc>
}
  801d68:	83 c4 14             	add    $0x14,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5d                   	pop    %ebp
  801d6d:	c3                   	ret    

00801d6e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d84:	8b 45 10             	mov    0x10(%ebp),%eax
  801d87:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d8c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d91:	e8 4d fd ff ff       	call   801ae3 <nsipc>
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	56                   	push   %esi
  801d9c:	53                   	push   %ebx
  801d9d:	83 ec 10             	sub    $0x10,%esp
  801da0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	89 04 24             	mov    %eax,(%esp)
  801da9:	e8 72 f2 ff ff       	call   801020 <fd2data>
  801dae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801db0:	c7 44 24 04 f4 2b 80 	movl   $0x802bf4,0x4(%esp)
  801db7:	00 
  801db8:	89 1c 24             	mov    %ebx,(%esp)
  801dbb:	e8 07 ea ff ff       	call   8007c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dc0:	8b 46 04             	mov    0x4(%esi),%eax
  801dc3:	2b 06                	sub    (%esi),%eax
  801dc5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dcb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dd2:	00 00 00 
	stat->st_dev = &devpipe;
  801dd5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ddc:	30 80 00 
	return 0;
}
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	53                   	push   %ebx
  801def:	83 ec 14             	sub    $0x14,%esp
  801df2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801df5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801df9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e00:	e8 85 ee ff ff       	call   800c8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e05:	89 1c 24             	mov    %ebx,(%esp)
  801e08:	e8 13 f2 ff ff       	call   801020 <fd2data>
  801e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e18:	e8 6d ee ff ff       	call   800c8a <sys_page_unmap>
}
  801e1d:	83 c4 14             	add    $0x14,%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    

00801e23 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	57                   	push   %edi
  801e27:	56                   	push   %esi
  801e28:	53                   	push   %ebx
  801e29:	83 ec 2c             	sub    $0x2c,%esp
  801e2c:	89 c6                	mov    %eax,%esi
  801e2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e31:	a1 08 40 80 00       	mov    0x804008,%eax
  801e36:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e39:	89 34 24             	mov    %esi,(%esp)
  801e3c:	e8 dd 05 00 00       	call   80241e <pageref>
  801e41:	89 c7                	mov    %eax,%edi
  801e43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e46:	89 04 24             	mov    %eax,(%esp)
  801e49:	e8 d0 05 00 00       	call   80241e <pageref>
  801e4e:	39 c7                	cmp    %eax,%edi
  801e50:	0f 94 c2             	sete   %dl
  801e53:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e56:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801e5c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e5f:	39 fb                	cmp    %edi,%ebx
  801e61:	74 21                	je     801e84 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e63:	84 d2                	test   %dl,%dl
  801e65:	74 ca                	je     801e31 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e67:	8b 51 58             	mov    0x58(%ecx),%edx
  801e6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e76:	c7 04 24 fb 2b 80 00 	movl   $0x802bfb,(%esp)
  801e7d:	e8 24 e3 ff ff       	call   8001a6 <cprintf>
  801e82:	eb ad                	jmp    801e31 <_pipeisclosed+0xe>
	}
}
  801e84:	83 c4 2c             	add    $0x2c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    

00801e8c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	57                   	push   %edi
  801e90:	56                   	push   %esi
  801e91:	53                   	push   %ebx
  801e92:	83 ec 1c             	sub    $0x1c,%esp
  801e95:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e98:	89 34 24             	mov    %esi,(%esp)
  801e9b:	e8 80 f1 ff ff       	call   801020 <fd2data>
  801ea0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ea2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea7:	eb 45                	jmp    801eee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ea9:	89 da                	mov    %ebx,%edx
  801eab:	89 f0                	mov    %esi,%eax
  801ead:	e8 71 ff ff ff       	call   801e23 <_pipeisclosed>
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	75 41                	jne    801ef7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801eb6:	e8 09 ed ff ff       	call   800bc4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ebb:	8b 43 04             	mov    0x4(%ebx),%eax
  801ebe:	8b 0b                	mov    (%ebx),%ecx
  801ec0:	8d 51 20             	lea    0x20(%ecx),%edx
  801ec3:	39 d0                	cmp    %edx,%eax
  801ec5:	73 e2                	jae    801ea9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ec7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ece:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ed1:	99                   	cltd   
  801ed2:	c1 ea 1b             	shr    $0x1b,%edx
  801ed5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ed8:	83 e1 1f             	and    $0x1f,%ecx
  801edb:	29 d1                	sub    %edx,%ecx
  801edd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ee1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ee5:	83 c0 01             	add    $0x1,%eax
  801ee8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eeb:	83 c7 01             	add    $0x1,%edi
  801eee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ef1:	75 c8                	jne    801ebb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ef3:	89 f8                	mov    %edi,%eax
  801ef5:	eb 05                	jmp    801efc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801efc:	83 c4 1c             	add    $0x1c,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    

00801f04 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	57                   	push   %edi
  801f08:	56                   	push   %esi
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 1c             	sub    $0x1c,%esp
  801f0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f10:	89 3c 24             	mov    %edi,(%esp)
  801f13:	e8 08 f1 ff ff       	call   801020 <fd2data>
  801f18:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f1a:	be 00 00 00 00       	mov    $0x0,%esi
  801f1f:	eb 3d                	jmp    801f5e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f21:	85 f6                	test   %esi,%esi
  801f23:	74 04                	je     801f29 <devpipe_read+0x25>
				return i;
  801f25:	89 f0                	mov    %esi,%eax
  801f27:	eb 43                	jmp    801f6c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f29:	89 da                	mov    %ebx,%edx
  801f2b:	89 f8                	mov    %edi,%eax
  801f2d:	e8 f1 fe ff ff       	call   801e23 <_pipeisclosed>
  801f32:	85 c0                	test   %eax,%eax
  801f34:	75 31                	jne    801f67 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f36:	e8 89 ec ff ff       	call   800bc4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f3b:	8b 03                	mov    (%ebx),%eax
  801f3d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f40:	74 df                	je     801f21 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f42:	99                   	cltd   
  801f43:	c1 ea 1b             	shr    $0x1b,%edx
  801f46:	01 d0                	add    %edx,%eax
  801f48:	83 e0 1f             	and    $0x1f,%eax
  801f4b:	29 d0                	sub    %edx,%eax
  801f4d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f55:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f58:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f5b:	83 c6 01             	add    $0x1,%esi
  801f5e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f61:	75 d8                	jne    801f3b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f63:	89 f0                	mov    %esi,%eax
  801f65:	eb 05                	jmp    801f6c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f6c:	83 c4 1c             	add    $0x1c,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5f                   	pop    %edi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    

00801f74 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	56                   	push   %esi
  801f78:	53                   	push   %ebx
  801f79:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7f:	89 04 24             	mov    %eax,(%esp)
  801f82:	e8 b0 f0 ff ff       	call   801037 <fd_alloc>
  801f87:	89 c2                	mov    %eax,%edx
  801f89:	85 d2                	test   %edx,%edx
  801f8b:	0f 88 4d 01 00 00    	js     8020de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f91:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f98:	00 
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa7:	e8 37 ec ff ff       	call   800be3 <sys_page_alloc>
  801fac:	89 c2                	mov    %eax,%edx
  801fae:	85 d2                	test   %edx,%edx
  801fb0:	0f 88 28 01 00 00    	js     8020de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fb9:	89 04 24             	mov    %eax,(%esp)
  801fbc:	e8 76 f0 ff ff       	call   801037 <fd_alloc>
  801fc1:	89 c3                	mov    %eax,%ebx
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	0f 88 fe 00 00 00    	js     8020c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fcb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fd2:	00 
  801fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe1:	e8 fd eb ff ff       	call   800be3 <sys_page_alloc>
  801fe6:	89 c3                	mov    %eax,%ebx
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	0f 88 d9 00 00 00    	js     8020c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	89 04 24             	mov    %eax,(%esp)
  801ff6:	e8 25 f0 ff ff       	call   801020 <fd2data>
  801ffb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ffd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802004:	00 
  802005:	89 44 24 04          	mov    %eax,0x4(%esp)
  802009:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802010:	e8 ce eb ff ff       	call   800be3 <sys_page_alloc>
  802015:	89 c3                	mov    %eax,%ebx
  802017:	85 c0                	test   %eax,%eax
  802019:	0f 88 97 00 00 00    	js     8020b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802022:	89 04 24             	mov    %eax,(%esp)
  802025:	e8 f6 ef ff ff       	call   801020 <fd2data>
  80202a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802031:	00 
  802032:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802036:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80203d:	00 
  80203e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802042:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802049:	e8 e9 eb ff ff       	call   800c37 <sys_page_map>
  80204e:	89 c3                	mov    %eax,%ebx
  802050:	85 c0                	test   %eax,%eax
  802052:	78 52                	js     8020a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802054:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802069:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80206f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802072:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802077:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 87 ef ff ff       	call   801010 <fd2num>
  802089:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80208e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 77 ef ff ff       	call   801010 <fd2num>
  802099:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a4:	eb 38                	jmp    8020de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8020a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b1:	e8 d4 eb ff ff       	call   800c8a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c4:	e8 c1 eb ff ff       	call   800c8a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d7:	e8 ae eb ff ff       	call   800c8a <sys_page_unmap>
  8020dc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8020de:	83 c4 30             	add    $0x30,%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    

008020e5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	89 04 24             	mov    %eax,(%esp)
  8020f8:	e8 89 ef ff ff       	call   801086 <fd_lookup>
  8020fd:	89 c2                	mov    %eax,%edx
  8020ff:	85 d2                	test   %edx,%edx
  802101:	78 15                	js     802118 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	89 04 24             	mov    %eax,(%esp)
  802109:	e8 12 ef ff ff       	call   801020 <fd2data>
	return _pipeisclosed(fd, p);
  80210e:	89 c2                	mov    %eax,%edx
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	e8 0b fd ff ff       	call   801e23 <_pipeisclosed>
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    
  80211a:	66 90                	xchg   %ax,%ax
  80211c:	66 90                	xchg   %ax,%ax
  80211e:	66 90                	xchg   %ax,%ax

00802120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	5d                   	pop    %ebp
  802129:	c3                   	ret    

0080212a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802130:	c7 44 24 04 13 2c 80 	movl   $0x802c13,0x4(%esp)
  802137:	00 
  802138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213b:	89 04 24             	mov    %eax,(%esp)
  80213e:	e8 84 e6 ff ff       	call   8007c7 <strcpy>
	return 0;
}
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	57                   	push   %edi
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802156:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80215b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802161:	eb 31                	jmp    802194 <devcons_write+0x4a>
		m = n - tot;
  802163:	8b 75 10             	mov    0x10(%ebp),%esi
  802166:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802168:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80216b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802170:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802173:	89 74 24 08          	mov    %esi,0x8(%esp)
  802177:	03 45 0c             	add    0xc(%ebp),%eax
  80217a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217e:	89 3c 24             	mov    %edi,(%esp)
  802181:	e8 de e7 ff ff       	call   800964 <memmove>
		sys_cputs(buf, m);
  802186:	89 74 24 04          	mov    %esi,0x4(%esp)
  80218a:	89 3c 24             	mov    %edi,(%esp)
  80218d:	e8 84 e9 ff ff       	call   800b16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802192:	01 f3                	add    %esi,%ebx
  802194:	89 d8                	mov    %ebx,%eax
  802196:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802199:	72 c8                	jb     802163 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80219b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5f                   	pop    %edi
  8021a4:	5d                   	pop    %ebp
  8021a5:	c3                   	ret    

008021a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021b5:	75 07                	jne    8021be <devcons_read+0x18>
  8021b7:	eb 2a                	jmp    8021e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021b9:	e8 06 ea ff ff       	call   800bc4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021be:	66 90                	xchg   %ax,%ax
  8021c0:	e8 6f e9 ff ff       	call   800b34 <sys_cgetc>
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	74 f0                	je     8021b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	78 16                	js     8021e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021cd:	83 f8 04             	cmp    $0x4,%eax
  8021d0:	74 0c                	je     8021de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8021d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d5:	88 02                	mov    %al,(%edx)
	return 1;
  8021d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021dc:	eb 05                	jmp    8021e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021f8:	00 
  8021f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021fc:	89 04 24             	mov    %eax,(%esp)
  8021ff:	e8 12 e9 ff ff       	call   800b16 <sys_cputs>
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <getchar>:

int
getchar(void)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80220c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802213:	00 
  802214:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802222:	e8 f3 f0 ff ff       	call   80131a <read>
	if (r < 0)
  802227:	85 c0                	test   %eax,%eax
  802229:	78 0f                	js     80223a <getchar+0x34>
		return r;
	if (r < 1)
  80222b:	85 c0                	test   %eax,%eax
  80222d:	7e 06                	jle    802235 <getchar+0x2f>
		return -E_EOF;
	return c;
  80222f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802233:	eb 05                	jmp    80223a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802235:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802242:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802245:	89 44 24 04          	mov    %eax,0x4(%esp)
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	89 04 24             	mov    %eax,(%esp)
  80224f:	e8 32 ee ff ff       	call   801086 <fd_lookup>
  802254:	85 c0                	test   %eax,%eax
  802256:	78 11                	js     802269 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802261:	39 10                	cmp    %edx,(%eax)
  802263:	0f 94 c0             	sete   %al
  802266:	0f b6 c0             	movzbl %al,%eax
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <opencons>:

int
opencons(void)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802271:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802274:	89 04 24             	mov    %eax,(%esp)
  802277:	e8 bb ed ff ff       	call   801037 <fd_alloc>
		return r;
  80227c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80227e:	85 c0                	test   %eax,%eax
  802280:	78 40                	js     8022c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802282:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802289:	00 
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802291:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802298:	e8 46 e9 ff ff       	call   800be3 <sys_page_alloc>
		return r;
  80229d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	78 1f                	js     8022c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022a3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022b8:	89 04 24             	mov    %eax,(%esp)
  8022bb:	e8 50 ed ff ff       	call   801010 <fd2num>
  8022c0:	89 c2                	mov    %eax,%edx
}
  8022c2:	89 d0                	mov    %edx,%eax
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	56                   	push   %esi
  8022ca:	53                   	push   %ebx
  8022cb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8022ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022d7:	e8 c9 e8 ff ff       	call   800ba5 <sys_getenvid>
  8022dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022df:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022ea:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f2:	c7 04 24 20 2c 80 00 	movl   $0x802c20,(%esp)
  8022f9:	e8 a8 de ff ff       	call   8001a6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802302:	8b 45 10             	mov    0x10(%ebp),%eax
  802305:	89 04 24             	mov    %eax,(%esp)
  802308:	e8 38 de ff ff       	call   800145 <vcprintf>
	cprintf("\n");
  80230d:	c7 04 24 0c 2c 80 00 	movl   $0x802c0c,(%esp)
  802314:	e8 8d de ff ff       	call   8001a6 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802319:	cc                   	int3   
  80231a:	eb fd                	jmp    802319 <_panic+0x53>
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	56                   	push   %esi
  802324:	53                   	push   %ebx
  802325:	83 ec 10             	sub    $0x10,%esp
  802328:	8b 75 08             	mov    0x8(%ebp),%esi
  80232b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802331:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802333:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802338:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80233b:	89 04 24             	mov    %eax,(%esp)
  80233e:	e8 b6 ea ff ff       	call   800df9 <sys_ipc_recv>
  802343:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802345:	85 d2                	test   %edx,%edx
  802347:	75 24                	jne    80236d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802349:	85 f6                	test   %esi,%esi
  80234b:	74 0a                	je     802357 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80234d:	a1 08 40 80 00       	mov    0x804008,%eax
  802352:	8b 40 74             	mov    0x74(%eax),%eax
  802355:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802357:	85 db                	test   %ebx,%ebx
  802359:	74 0a                	je     802365 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80235b:	a1 08 40 80 00       	mov    0x804008,%eax
  802360:	8b 40 78             	mov    0x78(%eax),%eax
  802363:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802365:	a1 08 40 80 00       	mov    0x804008,%eax
  80236a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80236d:	83 c4 10             	add    $0x10,%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5d                   	pop    %ebp
  802373:	c3                   	ret    

00802374 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	57                   	push   %edi
  802378:	56                   	push   %esi
  802379:	53                   	push   %ebx
  80237a:	83 ec 1c             	sub    $0x1c,%esp
  80237d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802380:	8b 75 0c             	mov    0xc(%ebp),%esi
  802383:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802386:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802388:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80238d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802390:	8b 45 14             	mov    0x14(%ebp),%eax
  802393:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802397:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80239b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80239f:	89 3c 24             	mov    %edi,(%esp)
  8023a2:	e8 2f ea ff ff       	call   800dd6 <sys_ipc_try_send>

		if (ret == 0)
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	74 2c                	je     8023d7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8023ab:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023ae:	74 20                	je     8023d0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8023b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023b4:	c7 44 24 08 44 2c 80 	movl   $0x802c44,0x8(%esp)
  8023bb:	00 
  8023bc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8023c3:	00 
  8023c4:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  8023cb:	e8 f6 fe ff ff       	call   8022c6 <_panic>
		}

		sys_yield();
  8023d0:	e8 ef e7 ff ff       	call   800bc4 <sys_yield>
	}
  8023d5:	eb b9                	jmp    802390 <ipc_send+0x1c>
}
  8023d7:	83 c4 1c             	add    $0x1c,%esp
  8023da:	5b                   	pop    %ebx
  8023db:	5e                   	pop    %esi
  8023dc:	5f                   	pop    %edi
  8023dd:	5d                   	pop    %ebp
  8023de:	c3                   	ret    

008023df <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ea:	89 c2                	mov    %eax,%edx
  8023ec:	c1 e2 07             	shl    $0x7,%edx
  8023ef:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8023f6:	8b 52 50             	mov    0x50(%edx),%edx
  8023f9:	39 ca                	cmp    %ecx,%edx
  8023fb:	75 11                	jne    80240e <ipc_find_env+0x2f>
			return envs[i].env_id;
  8023fd:	89 c2                	mov    %eax,%edx
  8023ff:	c1 e2 07             	shl    $0x7,%edx
  802402:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802409:	8b 40 40             	mov    0x40(%eax),%eax
  80240c:	eb 0e                	jmp    80241c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80240e:	83 c0 01             	add    $0x1,%eax
  802411:	3d 00 04 00 00       	cmp    $0x400,%eax
  802416:	75 d2                	jne    8023ea <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802418:	66 b8 00 00          	mov    $0x0,%ax
}
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    

0080241e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802424:	89 d0                	mov    %edx,%eax
  802426:	c1 e8 16             	shr    $0x16,%eax
  802429:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802430:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802435:	f6 c1 01             	test   $0x1,%cl
  802438:	74 1d                	je     802457 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80243a:	c1 ea 0c             	shr    $0xc,%edx
  80243d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802444:	f6 c2 01             	test   $0x1,%dl
  802447:	74 0e                	je     802457 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802449:	c1 ea 0c             	shr    $0xc,%edx
  80244c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802453:	ef 
  802454:	0f b7 c0             	movzwl %ax,%eax
}
  802457:	5d                   	pop    %ebp
  802458:	c3                   	ret    
  802459:	66 90                	xchg   %ax,%ax
  80245b:	66 90                	xchg   %ax,%ax
  80245d:	66 90                	xchg   %ax,%ax
  80245f:	90                   	nop

00802460 <__udivdi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	83 ec 0c             	sub    $0xc,%esp
  802466:	8b 44 24 28          	mov    0x28(%esp),%eax
  80246a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80246e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802472:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802476:	85 c0                	test   %eax,%eax
  802478:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80247c:	89 ea                	mov    %ebp,%edx
  80247e:	89 0c 24             	mov    %ecx,(%esp)
  802481:	75 2d                	jne    8024b0 <__udivdi3+0x50>
  802483:	39 e9                	cmp    %ebp,%ecx
  802485:	77 61                	ja     8024e8 <__udivdi3+0x88>
  802487:	85 c9                	test   %ecx,%ecx
  802489:	89 ce                	mov    %ecx,%esi
  80248b:	75 0b                	jne    802498 <__udivdi3+0x38>
  80248d:	b8 01 00 00 00       	mov    $0x1,%eax
  802492:	31 d2                	xor    %edx,%edx
  802494:	f7 f1                	div    %ecx
  802496:	89 c6                	mov    %eax,%esi
  802498:	31 d2                	xor    %edx,%edx
  80249a:	89 e8                	mov    %ebp,%eax
  80249c:	f7 f6                	div    %esi
  80249e:	89 c5                	mov    %eax,%ebp
  8024a0:	89 f8                	mov    %edi,%eax
  8024a2:	f7 f6                	div    %esi
  8024a4:	89 ea                	mov    %ebp,%edx
  8024a6:	83 c4 0c             	add    $0xc,%esp
  8024a9:	5e                   	pop    %esi
  8024aa:	5f                   	pop    %edi
  8024ab:	5d                   	pop    %ebp
  8024ac:	c3                   	ret    
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	39 e8                	cmp    %ebp,%eax
  8024b2:	77 24                	ja     8024d8 <__udivdi3+0x78>
  8024b4:	0f bd e8             	bsr    %eax,%ebp
  8024b7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ba:	75 3c                	jne    8024f8 <__udivdi3+0x98>
  8024bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024c0:	39 34 24             	cmp    %esi,(%esp)
  8024c3:	0f 86 9f 00 00 00    	jbe    802568 <__udivdi3+0x108>
  8024c9:	39 d0                	cmp    %edx,%eax
  8024cb:	0f 82 97 00 00 00    	jb     802568 <__udivdi3+0x108>
  8024d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	31 d2                	xor    %edx,%edx
  8024da:	31 c0                	xor    %eax,%eax
  8024dc:	83 c4 0c             	add    $0xc,%esp
  8024df:	5e                   	pop    %esi
  8024e0:	5f                   	pop    %edi
  8024e1:	5d                   	pop    %ebp
  8024e2:	c3                   	ret    
  8024e3:	90                   	nop
  8024e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	89 f8                	mov    %edi,%eax
  8024ea:	f7 f1                	div    %ecx
  8024ec:	31 d2                	xor    %edx,%edx
  8024ee:	83 c4 0c             	add    $0xc,%esp
  8024f1:	5e                   	pop    %esi
  8024f2:	5f                   	pop    %edi
  8024f3:	5d                   	pop    %ebp
  8024f4:	c3                   	ret    
  8024f5:	8d 76 00             	lea    0x0(%esi),%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	8b 3c 24             	mov    (%esp),%edi
  8024fd:	d3 e0                	shl    %cl,%eax
  8024ff:	89 c6                	mov    %eax,%esi
  802501:	b8 20 00 00 00       	mov    $0x20,%eax
  802506:	29 e8                	sub    %ebp,%eax
  802508:	89 c1                	mov    %eax,%ecx
  80250a:	d3 ef                	shr    %cl,%edi
  80250c:	89 e9                	mov    %ebp,%ecx
  80250e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802512:	8b 3c 24             	mov    (%esp),%edi
  802515:	09 74 24 08          	or     %esi,0x8(%esp)
  802519:	89 d6                	mov    %edx,%esi
  80251b:	d3 e7                	shl    %cl,%edi
  80251d:	89 c1                	mov    %eax,%ecx
  80251f:	89 3c 24             	mov    %edi,(%esp)
  802522:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802526:	d3 ee                	shr    %cl,%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	d3 e2                	shl    %cl,%edx
  80252c:	89 c1                	mov    %eax,%ecx
  80252e:	d3 ef                	shr    %cl,%edi
  802530:	09 d7                	or     %edx,%edi
  802532:	89 f2                	mov    %esi,%edx
  802534:	89 f8                	mov    %edi,%eax
  802536:	f7 74 24 08          	divl   0x8(%esp)
  80253a:	89 d6                	mov    %edx,%esi
  80253c:	89 c7                	mov    %eax,%edi
  80253e:	f7 24 24             	mull   (%esp)
  802541:	39 d6                	cmp    %edx,%esi
  802543:	89 14 24             	mov    %edx,(%esp)
  802546:	72 30                	jb     802578 <__udivdi3+0x118>
  802548:	8b 54 24 04          	mov    0x4(%esp),%edx
  80254c:	89 e9                	mov    %ebp,%ecx
  80254e:	d3 e2                	shl    %cl,%edx
  802550:	39 c2                	cmp    %eax,%edx
  802552:	73 05                	jae    802559 <__udivdi3+0xf9>
  802554:	3b 34 24             	cmp    (%esp),%esi
  802557:	74 1f                	je     802578 <__udivdi3+0x118>
  802559:	89 f8                	mov    %edi,%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	e9 7a ff ff ff       	jmp    8024dc <__udivdi3+0x7c>
  802562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802568:	31 d2                	xor    %edx,%edx
  80256a:	b8 01 00 00 00       	mov    $0x1,%eax
  80256f:	e9 68 ff ff ff       	jmp    8024dc <__udivdi3+0x7c>
  802574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802578:	8d 47 ff             	lea    -0x1(%edi),%eax
  80257b:	31 d2                	xor    %edx,%edx
  80257d:	83 c4 0c             	add    $0xc,%esp
  802580:	5e                   	pop    %esi
  802581:	5f                   	pop    %edi
  802582:	5d                   	pop    %ebp
  802583:	c3                   	ret    
  802584:	66 90                	xchg   %ax,%ax
  802586:	66 90                	xchg   %ax,%ax
  802588:	66 90                	xchg   %ax,%ax
  80258a:	66 90                	xchg   %ax,%ax
  80258c:	66 90                	xchg   %ax,%ax
  80258e:	66 90                	xchg   %ax,%ax

00802590 <__umoddi3>:
  802590:	55                   	push   %ebp
  802591:	57                   	push   %edi
  802592:	56                   	push   %esi
  802593:	83 ec 14             	sub    $0x14,%esp
  802596:	8b 44 24 28          	mov    0x28(%esp),%eax
  80259a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80259e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025a2:	89 c7                	mov    %eax,%edi
  8025a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025ac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025b0:	89 34 24             	mov    %esi,(%esp)
  8025b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025b7:	85 c0                	test   %eax,%eax
  8025b9:	89 c2                	mov    %eax,%edx
  8025bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025bf:	75 17                	jne    8025d8 <__umoddi3+0x48>
  8025c1:	39 fe                	cmp    %edi,%esi
  8025c3:	76 4b                	jbe    802610 <__umoddi3+0x80>
  8025c5:	89 c8                	mov    %ecx,%eax
  8025c7:	89 fa                	mov    %edi,%edx
  8025c9:	f7 f6                	div    %esi
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	31 d2                	xor    %edx,%edx
  8025cf:	83 c4 14             	add    $0x14,%esp
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	66 90                	xchg   %ax,%ax
  8025d8:	39 f8                	cmp    %edi,%eax
  8025da:	77 54                	ja     802630 <__umoddi3+0xa0>
  8025dc:	0f bd e8             	bsr    %eax,%ebp
  8025df:	83 f5 1f             	xor    $0x1f,%ebp
  8025e2:	75 5c                	jne    802640 <__umoddi3+0xb0>
  8025e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025e8:	39 3c 24             	cmp    %edi,(%esp)
  8025eb:	0f 87 e7 00 00 00    	ja     8026d8 <__umoddi3+0x148>
  8025f1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025f5:	29 f1                	sub    %esi,%ecx
  8025f7:	19 c7                	sbb    %eax,%edi
  8025f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802601:	8b 44 24 08          	mov    0x8(%esp),%eax
  802605:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802609:	83 c4 14             	add    $0x14,%esp
  80260c:	5e                   	pop    %esi
  80260d:	5f                   	pop    %edi
  80260e:	5d                   	pop    %ebp
  80260f:	c3                   	ret    
  802610:	85 f6                	test   %esi,%esi
  802612:	89 f5                	mov    %esi,%ebp
  802614:	75 0b                	jne    802621 <__umoddi3+0x91>
  802616:	b8 01 00 00 00       	mov    $0x1,%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	f7 f6                	div    %esi
  80261f:	89 c5                	mov    %eax,%ebp
  802621:	8b 44 24 04          	mov    0x4(%esp),%eax
  802625:	31 d2                	xor    %edx,%edx
  802627:	f7 f5                	div    %ebp
  802629:	89 c8                	mov    %ecx,%eax
  80262b:	f7 f5                	div    %ebp
  80262d:	eb 9c                	jmp    8025cb <__umoddi3+0x3b>
  80262f:	90                   	nop
  802630:	89 c8                	mov    %ecx,%eax
  802632:	89 fa                	mov    %edi,%edx
  802634:	83 c4 14             	add    $0x14,%esp
  802637:	5e                   	pop    %esi
  802638:	5f                   	pop    %edi
  802639:	5d                   	pop    %ebp
  80263a:	c3                   	ret    
  80263b:	90                   	nop
  80263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802640:	8b 04 24             	mov    (%esp),%eax
  802643:	be 20 00 00 00       	mov    $0x20,%esi
  802648:	89 e9                	mov    %ebp,%ecx
  80264a:	29 ee                	sub    %ebp,%esi
  80264c:	d3 e2                	shl    %cl,%edx
  80264e:	89 f1                	mov    %esi,%ecx
  802650:	d3 e8                	shr    %cl,%eax
  802652:	89 e9                	mov    %ebp,%ecx
  802654:	89 44 24 04          	mov    %eax,0x4(%esp)
  802658:	8b 04 24             	mov    (%esp),%eax
  80265b:	09 54 24 04          	or     %edx,0x4(%esp)
  80265f:	89 fa                	mov    %edi,%edx
  802661:	d3 e0                	shl    %cl,%eax
  802663:	89 f1                	mov    %esi,%ecx
  802665:	89 44 24 08          	mov    %eax,0x8(%esp)
  802669:	8b 44 24 10          	mov    0x10(%esp),%eax
  80266d:	d3 ea                	shr    %cl,%edx
  80266f:	89 e9                	mov    %ebp,%ecx
  802671:	d3 e7                	shl    %cl,%edi
  802673:	89 f1                	mov    %esi,%ecx
  802675:	d3 e8                	shr    %cl,%eax
  802677:	89 e9                	mov    %ebp,%ecx
  802679:	09 f8                	or     %edi,%eax
  80267b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80267f:	f7 74 24 04          	divl   0x4(%esp)
  802683:	d3 e7                	shl    %cl,%edi
  802685:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802689:	89 d7                	mov    %edx,%edi
  80268b:	f7 64 24 08          	mull   0x8(%esp)
  80268f:	39 d7                	cmp    %edx,%edi
  802691:	89 c1                	mov    %eax,%ecx
  802693:	89 14 24             	mov    %edx,(%esp)
  802696:	72 2c                	jb     8026c4 <__umoddi3+0x134>
  802698:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80269c:	72 22                	jb     8026c0 <__umoddi3+0x130>
  80269e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026a2:	29 c8                	sub    %ecx,%eax
  8026a4:	19 d7                	sbb    %edx,%edi
  8026a6:	89 e9                	mov    %ebp,%ecx
  8026a8:	89 fa                	mov    %edi,%edx
  8026aa:	d3 e8                	shr    %cl,%eax
  8026ac:	89 f1                	mov    %esi,%ecx
  8026ae:	d3 e2                	shl    %cl,%edx
  8026b0:	89 e9                	mov    %ebp,%ecx
  8026b2:	d3 ef                	shr    %cl,%edi
  8026b4:	09 d0                	or     %edx,%eax
  8026b6:	89 fa                	mov    %edi,%edx
  8026b8:	83 c4 14             	add    $0x14,%esp
  8026bb:	5e                   	pop    %esi
  8026bc:	5f                   	pop    %edi
  8026bd:	5d                   	pop    %ebp
  8026be:	c3                   	ret    
  8026bf:	90                   	nop
  8026c0:	39 d7                	cmp    %edx,%edi
  8026c2:	75 da                	jne    80269e <__umoddi3+0x10e>
  8026c4:	8b 14 24             	mov    (%esp),%edx
  8026c7:	89 c1                	mov    %eax,%ecx
  8026c9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026cd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026d1:	eb cb                	jmp    80269e <__umoddi3+0x10e>
  8026d3:	90                   	nop
  8026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026d8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026dc:	0f 82 0f ff ff ff    	jb     8025f1 <__umoddi3+0x61>
  8026e2:	e9 1a ff ff ff       	jmp    802601 <__umoddi3+0x71>