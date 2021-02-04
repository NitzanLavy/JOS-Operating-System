
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 62 00 00 00       	call   800093 <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 50 80 00       	mov    0x805008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	89 44 24 04          	mov    %eax,0x4(%esp)
  800045:	c7 04 24 60 2d 80 00 	movl   $0x802d60,(%esp)
  80004c:	e8 a0 01 00 00       	call   8001f1 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 7e 2d 80 	movl   $0x802d7e,0x4(%esp)
  800060:	00 
  800061:	c7 04 24 7e 2d 80 00 	movl   $0x802d7e,(%esp)
  800068:	e8 5a 1e 00 00       	call   801ec7 <spawnl>
  80006d:	85 c0                	test   %eax,%eax
  80006f:	79 20                	jns    800091 <umain+0x5e>
		panic("spawn(hello) failed: %e", r);
  800071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800075:	c7 44 24 08 84 2d 80 	movl   $0x802d84,0x8(%esp)
  80007c:	00 
  80007d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 9c 2d 80 00 	movl   $0x802d9c,(%esp)
  80008c:	e8 67 00 00 00       	call   8000f8 <_panic>
}
  800091:	c9                   	leave  
  800092:	c3                   	ret    

00800093 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 10             	sub    $0x10,%esp
  80009b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8000a1:	e8 4f 0b 00 00       	call   800bf5 <sys_getenvid>
  8000a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ab:	89 c2                	mov    %eax,%edx
  8000ad:	c1 e2 07             	shl    $0x7,%edx
  8000b0:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8000b7:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bc:	85 db                	test   %ebx,%ebx
  8000be:	7e 07                	jle    8000c7 <libmain+0x34>
		binaryname = argv[0];
  8000c0:	8b 06                	mov    (%esi),%eax
  8000c2:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000cb:	89 1c 24             	mov    %ebx,(%esp)
  8000ce:	e8 60 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d3:	e8 07 00 00 00       	call   8000df <exit>
}
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000e5:	e8 50 11 00 00       	call   80123a <close_all>
	sys_env_destroy(0);
  8000ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f1:	e8 ad 0a 00 00       	call   800ba3 <sys_env_destroy>
}
  8000f6:	c9                   	leave  
  8000f7:	c3                   	ret    

008000f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800100:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800103:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800109:	e8 e7 0a 00 00       	call   800bf5 <sys_getenvid>
  80010e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800111:	89 54 24 10          	mov    %edx,0x10(%esp)
  800115:	8b 55 08             	mov    0x8(%ebp),%edx
  800118:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80011c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800120:	89 44 24 04          	mov    %eax,0x4(%esp)
  800124:	c7 04 24 b8 2d 80 00 	movl   $0x802db8,(%esp)
  80012b:	e8 c1 00 00 00       	call   8001f1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800130:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800134:	8b 45 10             	mov    0x10(%ebp),%eax
  800137:	89 04 24             	mov    %eax,(%esp)
  80013a:	e8 51 00 00 00       	call   800190 <vcprintf>
	cprintf("\n");
  80013f:	c7 04 24 1f 33 80 00 	movl   $0x80331f,(%esp)
  800146:	e8 a6 00 00 00       	call   8001f1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80014b:	cc                   	int3   
  80014c:	eb fd                	jmp    80014b <_panic+0x53>

0080014e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	53                   	push   %ebx
  800152:	83 ec 14             	sub    $0x14,%esp
  800155:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800158:	8b 13                	mov    (%ebx),%edx
  80015a:	8d 42 01             	lea    0x1(%edx),%eax
  80015d:	89 03                	mov    %eax,(%ebx)
  80015f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800162:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800166:	3d ff 00 00 00       	cmp    $0xff,%eax
  80016b:	75 19                	jne    800186 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80016d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800174:	00 
  800175:	8d 43 08             	lea    0x8(%ebx),%eax
  800178:	89 04 24             	mov    %eax,(%esp)
  80017b:	e8 e6 09 00 00       	call   800b66 <sys_cputs>
		b->idx = 0;
  800180:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800186:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018a:	83 c4 14             	add    $0x14,%esp
  80018d:	5b                   	pop    %ebx
  80018e:	5d                   	pop    %ebp
  80018f:	c3                   	ret    

00800190 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800199:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a0:	00 00 00 
	b.cnt = 0;
  8001a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001aa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c5:	c7 04 24 4e 01 80 00 	movl   $0x80014e,(%esp)
  8001cc:	e8 ad 01 00 00       	call   80037e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001db:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e1:	89 04 24             	mov    %eax,(%esp)
  8001e4:	e8 7d 09 00 00       	call   800b66 <sys_cputs>

	return b.cnt;
}
  8001e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800201:	89 04 24             	mov    %eax,(%esp)
  800204:	e8 87 ff ff ff       	call   800190 <vcprintf>
	va_end(ap);

	return cnt;
}
  800209:	c9                   	leave  
  80020a:	c3                   	ret    
  80020b:	66 90                	xchg   %ax,%ax
  80020d:	66 90                	xchg   %ax,%ax
  80020f:	90                   	nop

00800210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 3c             	sub    $0x3c,%esp
  800219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80021c:	89 d7                	mov    %edx,%edi
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	89 c3                	mov    %eax,%ebx
  800229:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80022c:	8b 45 10             	mov    0x10(%ebp),%eax
  80022f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800232:	b9 00 00 00 00       	mov    $0x0,%ecx
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80023d:	39 d9                	cmp    %ebx,%ecx
  80023f:	72 05                	jb     800246 <printnum+0x36>
  800241:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800244:	77 69                	ja     8002af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800246:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800249:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80024d:	83 ee 01             	sub    $0x1,%esi
  800250:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800254:	89 44 24 08          	mov    %eax,0x8(%esp)
  800258:	8b 44 24 08          	mov    0x8(%esp),%eax
  80025c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800260:	89 c3                	mov    %eax,%ebx
  800262:	89 d6                	mov    %edx,%esi
  800264:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800267:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80026a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80026e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	89 04 24             	mov    %eax,(%esp)
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027f:	e8 3c 28 00 00       	call   802ac0 <__udivdi3>
  800284:	89 d9                	mov    %ebx,%ecx
  800286:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80028a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80028e:	89 04 24             	mov    %eax,(%esp)
  800291:	89 54 24 04          	mov    %edx,0x4(%esp)
  800295:	89 fa                	mov    %edi,%edx
  800297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029a:	e8 71 ff ff ff       	call   800210 <printnum>
  80029f:	eb 1b                	jmp    8002bc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002a8:	89 04 24             	mov    %eax,(%esp)
  8002ab:	ff d3                	call   *%ebx
  8002ad:	eb 03                	jmp    8002b2 <printnum+0xa2>
  8002af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b2:	83 ee 01             	sub    $0x1,%esi
  8002b5:	85 f6                	test   %esi,%esi
  8002b7:	7f e8                	jg     8002a1 <printnum+0x91>
  8002b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	e8 0c 29 00 00       	call   802bf0 <__umoddi3>
  8002e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002e8:	0f be 80 db 2d 80 00 	movsbl 0x802ddb(%eax),%eax
  8002ef:	89 04 24             	mov    %eax,(%esp)
  8002f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002f5:	ff d0                	call   *%eax
}
  8002f7:	83 c4 3c             	add    $0x3c,%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800302:	83 fa 01             	cmp    $0x1,%edx
  800305:	7e 0e                	jle    800315 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800307:	8b 10                	mov    (%eax),%edx
  800309:	8d 4a 08             	lea    0x8(%edx),%ecx
  80030c:	89 08                	mov    %ecx,(%eax)
  80030e:	8b 02                	mov    (%edx),%eax
  800310:	8b 52 04             	mov    0x4(%edx),%edx
  800313:	eb 22                	jmp    800337 <getuint+0x38>
	else if (lflag)
  800315:	85 d2                	test   %edx,%edx
  800317:	74 10                	je     800329 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80031e:	89 08                	mov    %ecx,(%eax)
  800320:	8b 02                	mov    (%edx),%eax
  800322:	ba 00 00 00 00       	mov    $0x0,%edx
  800327:	eb 0e                	jmp    800337 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032e:	89 08                	mov    %ecx,(%eax)
  800330:	8b 02                	mov    (%edx),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800337:	5d                   	pop    %ebp
  800338:	c3                   	ret    

00800339 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80033f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800343:	8b 10                	mov    (%eax),%edx
  800345:	3b 50 04             	cmp    0x4(%eax),%edx
  800348:	73 0a                	jae    800354 <sprintputch+0x1b>
		*b->buf++ = ch;
  80034a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80034d:	89 08                	mov    %ecx,(%eax)
  80034f:	8b 45 08             	mov    0x8(%ebp),%eax
  800352:	88 02                	mov    %al,(%edx)
}
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80035c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80035f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800363:	8b 45 10             	mov    0x10(%ebp),%eax
  800366:	89 44 24 08          	mov    %eax,0x8(%esp)
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800371:	8b 45 08             	mov    0x8(%ebp),%eax
  800374:	89 04 24             	mov    %eax,(%esp)
  800377:	e8 02 00 00 00       	call   80037e <vprintfmt>
	va_end(ap);
}
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	57                   	push   %edi
  800382:	56                   	push   %esi
  800383:	53                   	push   %ebx
  800384:	83 ec 3c             	sub    $0x3c,%esp
  800387:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80038a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80038d:	eb 14                	jmp    8003a3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80038f:	85 c0                	test   %eax,%eax
  800391:	0f 84 b3 03 00 00    	je     80074a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800397:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80039b:	89 04 24             	mov    %eax,(%esp)
  80039e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a1:	89 f3                	mov    %esi,%ebx
  8003a3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003a6:	0f b6 03             	movzbl (%ebx),%eax
  8003a9:	83 f8 25             	cmp    $0x25,%eax
  8003ac:	75 e1                	jne    80038f <vprintfmt+0x11>
  8003ae:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003b9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003c0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8003c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cc:	eb 1d                	jmp    8003eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ce:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003d0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003d4:	eb 15                	jmp    8003eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003d8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003dc:	eb 0d                	jmp    8003eb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003ee:	0f b6 0e             	movzbl (%esi),%ecx
  8003f1:	0f b6 c1             	movzbl %cl,%eax
  8003f4:	83 e9 23             	sub    $0x23,%ecx
  8003f7:	80 f9 55             	cmp    $0x55,%cl
  8003fa:	0f 87 2a 03 00 00    	ja     80072a <vprintfmt+0x3ac>
  800400:	0f b6 c9             	movzbl %cl,%ecx
  800403:	ff 24 8d 60 2f 80 00 	jmp    *0x802f60(,%ecx,4)
  80040a:	89 de                	mov    %ebx,%esi
  80040c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800411:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800414:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800418:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80041b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80041e:	83 fb 09             	cmp    $0x9,%ebx
  800421:	77 36                	ja     800459 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800423:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800426:	eb e9                	jmp    800411 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800428:	8b 45 14             	mov    0x14(%ebp),%eax
  80042b:	8d 48 04             	lea    0x4(%eax),%ecx
  80042e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800431:	8b 00                	mov    (%eax),%eax
  800433:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800436:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800438:	eb 22                	jmp    80045c <vprintfmt+0xde>
  80043a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80043d:	85 c9                	test   %ecx,%ecx
  80043f:	b8 00 00 00 00       	mov    $0x0,%eax
  800444:	0f 49 c1             	cmovns %ecx,%eax
  800447:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	89 de                	mov    %ebx,%esi
  80044c:	eb 9d                	jmp    8003eb <vprintfmt+0x6d>
  80044e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800450:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800457:	eb 92                	jmp    8003eb <vprintfmt+0x6d>
  800459:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80045c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800460:	79 89                	jns    8003eb <vprintfmt+0x6d>
  800462:	e9 77 ff ff ff       	jmp    8003de <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800467:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80046c:	e9 7a ff ff ff       	jmp    8003eb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800471:	8b 45 14             	mov    0x14(%ebp),%eax
  800474:	8d 50 04             	lea    0x4(%eax),%edx
  800477:	89 55 14             	mov    %edx,0x14(%ebp)
  80047a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 04 24             	mov    %eax,(%esp)
  800483:	ff 55 08             	call   *0x8(%ebp)
			break;
  800486:	e9 18 ff ff ff       	jmp    8003a3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80048b:	8b 45 14             	mov    0x14(%ebp),%eax
  80048e:	8d 50 04             	lea    0x4(%eax),%edx
  800491:	89 55 14             	mov    %edx,0x14(%ebp)
  800494:	8b 00                	mov    (%eax),%eax
  800496:	99                   	cltd   
  800497:	31 d0                	xor    %edx,%eax
  800499:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049b:	83 f8 12             	cmp    $0x12,%eax
  80049e:	7f 0b                	jg     8004ab <vprintfmt+0x12d>
  8004a0:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  8004a7:	85 d2                	test   %edx,%edx
  8004a9:	75 20                	jne    8004cb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004af:	c7 44 24 08 f3 2d 80 	movl   $0x802df3,0x8(%esp)
  8004b6:	00 
  8004b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	e8 90 fe ff ff       	call   800356 <printfmt>
  8004c6:	e9 d8 fe ff ff       	jmp    8003a3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004cf:	c7 44 24 08 01 32 80 	movl   $0x803201,0x8(%esp)
  8004d6:	00 
  8004d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	89 04 24             	mov    %eax,(%esp)
  8004e1:	e8 70 fe ff ff       	call   800356 <printfmt>
  8004e6:	e9 b8 fe ff ff       	jmp    8003a3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8d 50 04             	lea    0x4(%eax),%edx
  8004fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004fd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004ff:	85 f6                	test   %esi,%esi
  800501:	b8 ec 2d 80 00       	mov    $0x802dec,%eax
  800506:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800509:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80050d:	0f 84 97 00 00 00    	je     8005aa <vprintfmt+0x22c>
  800513:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800517:	0f 8e 9b 00 00 00    	jle    8005b8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800521:	89 34 24             	mov    %esi,(%esp)
  800524:	e8 cf 02 00 00       	call   8007f8 <strnlen>
  800529:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80052c:	29 c2                	sub    %eax,%edx
  80052e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800531:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800535:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800538:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80053b:	8b 75 08             	mov    0x8(%ebp),%esi
  80053e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800541:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800543:	eb 0f                	jmp    800554 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800545:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800549:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054c:	89 04 24             	mov    %eax,(%esp)
  80054f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800551:	83 eb 01             	sub    $0x1,%ebx
  800554:	85 db                	test   %ebx,%ebx
  800556:	7f ed                	jg     800545 <vprintfmt+0x1c7>
  800558:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80055b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80055e:	85 d2                	test   %edx,%edx
  800560:	b8 00 00 00 00       	mov    $0x0,%eax
  800565:	0f 49 c2             	cmovns %edx,%eax
  800568:	29 c2                	sub    %eax,%edx
  80056a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80056d:	89 d7                	mov    %edx,%edi
  80056f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800572:	eb 50                	jmp    8005c4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800574:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800578:	74 1e                	je     800598 <vprintfmt+0x21a>
  80057a:	0f be d2             	movsbl %dl,%edx
  80057d:	83 ea 20             	sub    $0x20,%edx
  800580:	83 fa 5e             	cmp    $0x5e,%edx
  800583:	76 13                	jbe    800598 <vprintfmt+0x21a>
					putch('?', putdat);
  800585:	8b 45 0c             	mov    0xc(%ebp),%eax
  800588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80058c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800593:	ff 55 08             	call   *0x8(%ebp)
  800596:	eb 0d                	jmp    8005a5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80059f:	89 04 24             	mov    %eax,(%esp)
  8005a2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a5:	83 ef 01             	sub    $0x1,%edi
  8005a8:	eb 1a                	jmp    8005c4 <vprintfmt+0x246>
  8005aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005ad:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005b0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005b3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005b6:	eb 0c                	jmp    8005c4 <vprintfmt+0x246>
  8005b8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c4:	83 c6 01             	add    $0x1,%esi
  8005c7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005cb:	0f be c2             	movsbl %dl,%eax
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	74 27                	je     8005f9 <vprintfmt+0x27b>
  8005d2:	85 db                	test   %ebx,%ebx
  8005d4:	78 9e                	js     800574 <vprintfmt+0x1f6>
  8005d6:	83 eb 01             	sub    $0x1,%ebx
  8005d9:	79 99                	jns    800574 <vprintfmt+0x1f6>
  8005db:	89 f8                	mov    %edi,%eax
  8005dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e3:	89 c3                	mov    %eax,%ebx
  8005e5:	eb 1a                	jmp    800601 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005f2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005f4:	83 eb 01             	sub    $0x1,%ebx
  8005f7:	eb 08                	jmp    800601 <vprintfmt+0x283>
  8005f9:	89 fb                	mov    %edi,%ebx
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800601:	85 db                	test   %ebx,%ebx
  800603:	7f e2                	jg     8005e7 <vprintfmt+0x269>
  800605:	89 75 08             	mov    %esi,0x8(%ebp)
  800608:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80060b:	e9 93 fd ff ff       	jmp    8003a3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800610:	83 fa 01             	cmp    $0x1,%edx
  800613:	7e 16                	jle    80062b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 50 08             	lea    0x8(%eax),%edx
  80061b:	89 55 14             	mov    %edx,0x14(%ebp)
  80061e:	8b 50 04             	mov    0x4(%eax),%edx
  800621:	8b 00                	mov    (%eax),%eax
  800623:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800626:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800629:	eb 32                	jmp    80065d <vprintfmt+0x2df>
	else if (lflag)
  80062b:	85 d2                	test   %edx,%edx
  80062d:	74 18                	je     800647 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 50 04             	lea    0x4(%eax),%edx
  800635:	89 55 14             	mov    %edx,0x14(%ebp)
  800638:	8b 30                	mov    (%eax),%esi
  80063a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80063d:	89 f0                	mov    %esi,%eax
  80063f:	c1 f8 1f             	sar    $0x1f,%eax
  800642:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800645:	eb 16                	jmp    80065d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 50 04             	lea    0x4(%eax),%edx
  80064d:	89 55 14             	mov    %edx,0x14(%ebp)
  800650:	8b 30                	mov    (%eax),%esi
  800652:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800655:	89 f0                	mov    %esi,%eax
  800657:	c1 f8 1f             	sar    $0x1f,%eax
  80065a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80065d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800660:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800663:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800668:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066c:	0f 89 80 00 00 00    	jns    8006f2 <vprintfmt+0x374>
				putch('-', putdat);
  800672:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800676:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80067d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800680:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800683:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800686:	f7 d8                	neg    %eax
  800688:	83 d2 00             	adc    $0x0,%edx
  80068b:	f7 da                	neg    %edx
			}
			base = 10;
  80068d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800692:	eb 5e                	jmp    8006f2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800694:	8d 45 14             	lea    0x14(%ebp),%eax
  800697:	e8 63 fc ff ff       	call   8002ff <getuint>
			base = 10;
  80069c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006a1:	eb 4f                	jmp    8006f2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a6:	e8 54 fc ff ff       	call   8002ff <getuint>
			base = 8;
  8006ab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006b0:	eb 40                	jmp    8006f2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8006b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006bd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006cb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 50 04             	lea    0x4(%eax),%edx
  8006d4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006de:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006e3:	eb 0d                	jmp    8006f2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e8:	e8 12 fc ff ff       	call   8002ff <getuint>
			base = 16;
  8006ed:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006f2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006f6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006fa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800701:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800705:	89 04 24             	mov    %eax,(%esp)
  800708:	89 54 24 04          	mov    %edx,0x4(%esp)
  80070c:	89 fa                	mov    %edi,%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	e8 fa fa ff ff       	call   800210 <printnum>
			break;
  800716:	e9 88 fc ff ff       	jmp    8003a3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80071b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071f:	89 04 24             	mov    %eax,(%esp)
  800722:	ff 55 08             	call   *0x8(%ebp)
			break;
  800725:	e9 79 fc ff ff       	jmp    8003a3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80072a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800735:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800738:	89 f3                	mov    %esi,%ebx
  80073a:	eb 03                	jmp    80073f <vprintfmt+0x3c1>
  80073c:	83 eb 01             	sub    $0x1,%ebx
  80073f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800743:	75 f7                	jne    80073c <vprintfmt+0x3be>
  800745:	e9 59 fc ff ff       	jmp    8003a3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80074a:	83 c4 3c             	add    $0x3c,%esp
  80074d:	5b                   	pop    %ebx
  80074e:	5e                   	pop    %esi
  80074f:	5f                   	pop    %edi
  800750:	5d                   	pop    %ebp
  800751:	c3                   	ret    

00800752 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
  800755:	83 ec 28             	sub    $0x28,%esp
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800761:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800765:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800768:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076f:	85 c0                	test   %eax,%eax
  800771:	74 30                	je     8007a3 <vsnprintf+0x51>
  800773:	85 d2                	test   %edx,%edx
  800775:	7e 2c                	jle    8007a3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80077e:	8b 45 10             	mov    0x10(%ebp),%eax
  800781:	89 44 24 08          	mov    %eax,0x8(%esp)
  800785:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078c:	c7 04 24 39 03 80 00 	movl   $0x800339,(%esp)
  800793:	e8 e6 fb ff ff       	call   80037e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80079e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a1:	eb 05                	jmp    8007a8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	89 04 24             	mov    %eax,(%esp)
  8007cb:	e8 82 ff ff ff       	call   800752 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    
  8007d2:	66 90                	xchg   %ax,%ax
  8007d4:	66 90                	xchg   %ax,%ax
  8007d6:	66 90                	xchg   %ax,%ax
  8007d8:	66 90                	xchg   %ax,%ax
  8007da:	66 90                	xchg   %ax,%ax
  8007dc:	66 90                	xchg   %ax,%ax
  8007de:	66 90                	xchg   %ax,%ax

008007e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	eb 03                	jmp    8007f0 <strlen+0x10>
		n++;
  8007ed:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f4:	75 f7                	jne    8007ed <strlen+0xd>
		n++;
	return n;
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800801:	b8 00 00 00 00       	mov    $0x0,%eax
  800806:	eb 03                	jmp    80080b <strnlen+0x13>
		n++;
  800808:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080b:	39 d0                	cmp    %edx,%eax
  80080d:	74 06                	je     800815 <strnlen+0x1d>
  80080f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800813:	75 f3                	jne    800808 <strnlen+0x10>
		n++;
	return n;
}
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800821:	89 c2                	mov    %eax,%edx
  800823:	83 c2 01             	add    $0x1,%edx
  800826:	83 c1 01             	add    $0x1,%ecx
  800829:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80082d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800830:	84 db                	test   %bl,%bl
  800832:	75 ef                	jne    800823 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800834:	5b                   	pop    %ebx
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	53                   	push   %ebx
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800841:	89 1c 24             	mov    %ebx,(%esp)
  800844:	e8 97 ff ff ff       	call   8007e0 <strlen>
	strcpy(dst + len, src);
  800849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800850:	01 d8                	add    %ebx,%eax
  800852:	89 04 24             	mov    %eax,(%esp)
  800855:	e8 bd ff ff ff       	call   800817 <strcpy>
	return dst;
}
  80085a:	89 d8                	mov    %ebx,%eax
  80085c:	83 c4 08             	add    $0x8,%esp
  80085f:	5b                   	pop    %ebx
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	56                   	push   %esi
  800866:	53                   	push   %ebx
  800867:	8b 75 08             	mov    0x8(%ebp),%esi
  80086a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086d:	89 f3                	mov    %esi,%ebx
  80086f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800872:	89 f2                	mov    %esi,%edx
  800874:	eb 0f                	jmp    800885 <strncpy+0x23>
		*dst++ = *src;
  800876:	83 c2 01             	add    $0x1,%edx
  800879:	0f b6 01             	movzbl (%ecx),%eax
  80087c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80087f:	80 39 01             	cmpb   $0x1,(%ecx)
  800882:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800885:	39 da                	cmp    %ebx,%edx
  800887:	75 ed                	jne    800876 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800889:	89 f0                	mov    %esi,%eax
  80088b:	5b                   	pop    %ebx
  80088c:	5e                   	pop    %esi
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	56                   	push   %esi
  800893:	53                   	push   %ebx
  800894:	8b 75 08             	mov    0x8(%ebp),%esi
  800897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80089d:	89 f0                	mov    %esi,%eax
  80089f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a3:	85 c9                	test   %ecx,%ecx
  8008a5:	75 0b                	jne    8008b2 <strlcpy+0x23>
  8008a7:	eb 1d                	jmp    8008c6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	83 c2 01             	add    $0x1,%edx
  8008af:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008b2:	39 d8                	cmp    %ebx,%eax
  8008b4:	74 0b                	je     8008c1 <strlcpy+0x32>
  8008b6:	0f b6 0a             	movzbl (%edx),%ecx
  8008b9:	84 c9                	test   %cl,%cl
  8008bb:	75 ec                	jne    8008a9 <strlcpy+0x1a>
  8008bd:	89 c2                	mov    %eax,%edx
  8008bf:	eb 02                	jmp    8008c3 <strlcpy+0x34>
  8008c1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008c3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008c6:	29 f0                	sub    %esi,%eax
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d5:	eb 06                	jmp    8008dd <strcmp+0x11>
		p++, q++;
  8008d7:	83 c1 01             	add    $0x1,%ecx
  8008da:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008dd:	0f b6 01             	movzbl (%ecx),%eax
  8008e0:	84 c0                	test   %al,%al
  8008e2:	74 04                	je     8008e8 <strcmp+0x1c>
  8008e4:	3a 02                	cmp    (%edx),%al
  8008e6:	74 ef                	je     8008d7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e8:	0f b6 c0             	movzbl %al,%eax
  8008eb:	0f b6 12             	movzbl (%edx),%edx
  8008ee:	29 d0                	sub    %edx,%eax
}
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	53                   	push   %ebx
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	89 c3                	mov    %eax,%ebx
  8008fe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800901:	eb 06                	jmp    800909 <strncmp+0x17>
		n--, p++, q++;
  800903:	83 c0 01             	add    $0x1,%eax
  800906:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800909:	39 d8                	cmp    %ebx,%eax
  80090b:	74 15                	je     800922 <strncmp+0x30>
  80090d:	0f b6 08             	movzbl (%eax),%ecx
  800910:	84 c9                	test   %cl,%cl
  800912:	74 04                	je     800918 <strncmp+0x26>
  800914:	3a 0a                	cmp    (%edx),%cl
  800916:	74 eb                	je     800903 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800918:	0f b6 00             	movzbl (%eax),%eax
  80091b:	0f b6 12             	movzbl (%edx),%edx
  80091e:	29 d0                	sub    %edx,%eax
  800920:	eb 05                	jmp    800927 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800922:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800927:	5b                   	pop    %ebx
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800934:	eb 07                	jmp    80093d <strchr+0x13>
		if (*s == c)
  800936:	38 ca                	cmp    %cl,%dl
  800938:	74 0f                	je     800949 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80093a:	83 c0 01             	add    $0x1,%eax
  80093d:	0f b6 10             	movzbl (%eax),%edx
  800940:	84 d2                	test   %dl,%dl
  800942:	75 f2                	jne    800936 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800955:	eb 07                	jmp    80095e <strfind+0x13>
		if (*s == c)
  800957:	38 ca                	cmp    %cl,%dl
  800959:	74 0a                	je     800965 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	0f b6 10             	movzbl (%eax),%edx
  800961:	84 d2                	test   %dl,%dl
  800963:	75 f2                	jne    800957 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	57                   	push   %edi
  80096b:	56                   	push   %esi
  80096c:	53                   	push   %ebx
  80096d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800970:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800973:	85 c9                	test   %ecx,%ecx
  800975:	74 36                	je     8009ad <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800977:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80097d:	75 28                	jne    8009a7 <memset+0x40>
  80097f:	f6 c1 03             	test   $0x3,%cl
  800982:	75 23                	jne    8009a7 <memset+0x40>
		c &= 0xFF;
  800984:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800988:	89 d3                	mov    %edx,%ebx
  80098a:	c1 e3 08             	shl    $0x8,%ebx
  80098d:	89 d6                	mov    %edx,%esi
  80098f:	c1 e6 18             	shl    $0x18,%esi
  800992:	89 d0                	mov    %edx,%eax
  800994:	c1 e0 10             	shl    $0x10,%eax
  800997:	09 f0                	or     %esi,%eax
  800999:	09 c2                	or     %eax,%edx
  80099b:	89 d0                	mov    %edx,%eax
  80099d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80099f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009a2:	fc                   	cld    
  8009a3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a5:	eb 06                	jmp    8009ad <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	fc                   	cld    
  8009ab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ad:	89 f8                	mov    %edi,%eax
  8009af:	5b                   	pop    %ebx
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	57                   	push   %edi
  8009b8:	56                   	push   %esi
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c2:	39 c6                	cmp    %eax,%esi
  8009c4:	73 35                	jae    8009fb <memmove+0x47>
  8009c6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c9:	39 d0                	cmp    %edx,%eax
  8009cb:	73 2e                	jae    8009fb <memmove+0x47>
		s += n;
		d += n;
  8009cd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009d0:	89 d6                	mov    %edx,%esi
  8009d2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009da:	75 13                	jne    8009ef <memmove+0x3b>
  8009dc:	f6 c1 03             	test   $0x3,%cl
  8009df:	75 0e                	jne    8009ef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e1:	83 ef 04             	sub    $0x4,%edi
  8009e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ea:	fd                   	std    
  8009eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ed:	eb 09                	jmp    8009f8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ef:	83 ef 01             	sub    $0x1,%edi
  8009f2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009f5:	fd                   	std    
  8009f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f8:	fc                   	cld    
  8009f9:	eb 1d                	jmp    800a18 <memmove+0x64>
  8009fb:	89 f2                	mov    %esi,%edx
  8009fd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ff:	f6 c2 03             	test   $0x3,%dl
  800a02:	75 0f                	jne    800a13 <memmove+0x5f>
  800a04:	f6 c1 03             	test   $0x3,%cl
  800a07:	75 0a                	jne    800a13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a09:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a0c:	89 c7                	mov    %eax,%edi
  800a0e:	fc                   	cld    
  800a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a11:	eb 05                	jmp    800a18 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a13:	89 c7                	mov    %eax,%edi
  800a15:	fc                   	cld    
  800a16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a18:	5e                   	pop    %esi
  800a19:	5f                   	pop    %edi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a22:	8b 45 10             	mov    0x10(%ebp),%eax
  800a25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	89 04 24             	mov    %eax,(%esp)
  800a36:	e8 79 ff ff ff       	call   8009b4 <memmove>
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	8b 55 08             	mov    0x8(%ebp),%edx
  800a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a48:	89 d6                	mov    %edx,%esi
  800a4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a4d:	eb 1a                	jmp    800a69 <memcmp+0x2c>
		if (*s1 != *s2)
  800a4f:	0f b6 02             	movzbl (%edx),%eax
  800a52:	0f b6 19             	movzbl (%ecx),%ebx
  800a55:	38 d8                	cmp    %bl,%al
  800a57:	74 0a                	je     800a63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a59:	0f b6 c0             	movzbl %al,%eax
  800a5c:	0f b6 db             	movzbl %bl,%ebx
  800a5f:	29 d8                	sub    %ebx,%eax
  800a61:	eb 0f                	jmp    800a72 <memcmp+0x35>
		s1++, s2++;
  800a63:	83 c2 01             	add    $0x1,%edx
  800a66:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a69:	39 f2                	cmp    %esi,%edx
  800a6b:	75 e2                	jne    800a4f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a84:	eb 07                	jmp    800a8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a86:	38 08                	cmp    %cl,(%eax)
  800a88:	74 07                	je     800a91 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	39 d0                	cmp    %edx,%eax
  800a8f:	72 f5                	jb     800a86 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	57                   	push   %edi
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9f:	eb 03                	jmp    800aa4 <strtol+0x11>
		s++;
  800aa1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa4:	0f b6 0a             	movzbl (%edx),%ecx
  800aa7:	80 f9 09             	cmp    $0x9,%cl
  800aaa:	74 f5                	je     800aa1 <strtol+0xe>
  800aac:	80 f9 20             	cmp    $0x20,%cl
  800aaf:	74 f0                	je     800aa1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ab1:	80 f9 2b             	cmp    $0x2b,%cl
  800ab4:	75 0a                	jne    800ac0 <strtol+0x2d>
		s++;
  800ab6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ab9:	bf 00 00 00 00       	mov    $0x0,%edi
  800abe:	eb 11                	jmp    800ad1 <strtol+0x3e>
  800ac0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ac5:	80 f9 2d             	cmp    $0x2d,%cl
  800ac8:	75 07                	jne    800ad1 <strtol+0x3e>
		s++, neg = 1;
  800aca:	8d 52 01             	lea    0x1(%edx),%edx
  800acd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ad6:	75 15                	jne    800aed <strtol+0x5a>
  800ad8:	80 3a 30             	cmpb   $0x30,(%edx)
  800adb:	75 10                	jne    800aed <strtol+0x5a>
  800add:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ae1:	75 0a                	jne    800aed <strtol+0x5a>
		s += 2, base = 16;
  800ae3:	83 c2 02             	add    $0x2,%edx
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aeb:	eb 10                	jmp    800afd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800aed:	85 c0                	test   %eax,%eax
  800aef:	75 0c                	jne    800afd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800af3:	80 3a 30             	cmpb   $0x30,(%edx)
  800af6:	75 05                	jne    800afd <strtol+0x6a>
		s++, base = 8;
  800af8:	83 c2 01             	add    $0x1,%edx
  800afb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800afd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b02:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b05:	0f b6 0a             	movzbl (%edx),%ecx
  800b08:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b0b:	89 f0                	mov    %esi,%eax
  800b0d:	3c 09                	cmp    $0x9,%al
  800b0f:	77 08                	ja     800b19 <strtol+0x86>
			dig = *s - '0';
  800b11:	0f be c9             	movsbl %cl,%ecx
  800b14:	83 e9 30             	sub    $0x30,%ecx
  800b17:	eb 20                	jmp    800b39 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b19:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b1c:	89 f0                	mov    %esi,%eax
  800b1e:	3c 19                	cmp    $0x19,%al
  800b20:	77 08                	ja     800b2a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b22:	0f be c9             	movsbl %cl,%ecx
  800b25:	83 e9 57             	sub    $0x57,%ecx
  800b28:	eb 0f                	jmp    800b39 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b2a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b2d:	89 f0                	mov    %esi,%eax
  800b2f:	3c 19                	cmp    $0x19,%al
  800b31:	77 16                	ja     800b49 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b33:	0f be c9             	movsbl %cl,%ecx
  800b36:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b39:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b3c:	7d 0f                	jge    800b4d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b3e:	83 c2 01             	add    $0x1,%edx
  800b41:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b45:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b47:	eb bc                	jmp    800b05 <strtol+0x72>
  800b49:	89 d8                	mov    %ebx,%eax
  800b4b:	eb 02                	jmp    800b4f <strtol+0xbc>
  800b4d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b53:	74 05                	je     800b5a <strtol+0xc7>
		*endptr = (char *) s;
  800b55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b58:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b5a:	f7 d8                	neg    %eax
  800b5c:	85 ff                	test   %edi,%edi
  800b5e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b74:	8b 55 08             	mov    0x8(%ebp),%edx
  800b77:	89 c3                	mov    %eax,%ebx
  800b79:	89 c7                	mov    %eax,%edi
  800b7b:	89 c6                	mov    %eax,%esi
  800b7d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <sys_cgetc>:

int
sys_cgetc(void)
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
  800b8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800bac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb9:	89 cb                	mov    %ecx,%ebx
  800bbb:	89 cf                	mov    %ecx,%edi
  800bbd:	89 ce                	mov    %ecx,%esi
  800bbf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bc1:	85 c0                	test   %eax,%eax
  800bc3:	7e 28                	jle    800bed <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bc9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bd0:	00 
  800bd1:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800bd8:	00 
  800bd9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800be0:	00 
  800be1:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800be8:	e8 0b f5 ff ff       	call   8000f8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bed:	83 c4 2c             	add    $0x2c,%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800c00:	b8 02 00 00 00       	mov    $0x2,%eax
  800c05:	89 d1                	mov    %edx,%ecx
  800c07:	89 d3                	mov    %edx,%ebx
  800c09:	89 d7                	mov    %edx,%edi
  800c0b:	89 d6                	mov    %edx,%esi
  800c0d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <sys_yield>:

void
sys_yield(void)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c24:	89 d1                	mov    %edx,%ecx
  800c26:	89 d3                	mov    %edx,%ebx
  800c28:	89 d7                	mov    %edx,%edi
  800c2a:	89 d6                	mov    %edx,%esi
  800c2c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	be 00 00 00 00       	mov    $0x0,%esi
  800c41:	b8 04 00 00 00       	mov    $0x4,%eax
  800c46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4f:	89 f7                	mov    %esi,%edi
  800c51:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	7e 28                	jle    800c7f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c5b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c62:	00 
  800c63:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800c6a:	00 
  800c6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c72:	00 
  800c73:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800c7a:	e8 79 f4 ff ff       	call   8000f8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c7f:	83 c4 2c             	add    $0x2c,%esp
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c90:	b8 05 00 00 00       	mov    $0x5,%eax
  800c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca1:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7e 28                	jle    800cd2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800caa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cae:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cb5:	00 
  800cb6:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800cbd:	00 
  800cbe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc5:	00 
  800cc6:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800ccd:	e8 26 f4 ff ff       	call   8000f8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd2:	83 c4 2c             	add    $0x2c,%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
  800ce0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	89 df                	mov    %ebx,%edi
  800cf5:	89 de                	mov    %ebx,%esi
  800cf7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf9:	85 c0                	test   %eax,%eax
  800cfb:	7e 28                	jle    800d25 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d01:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d08:	00 
  800d09:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800d10:	00 
  800d11:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d18:	00 
  800d19:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800d20:	e8 d3 f3 ff ff       	call   8000f8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d25:	83 c4 2c             	add    $0x2c,%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
  800d46:	89 df                	mov    %ebx,%edi
  800d48:	89 de                	mov    %ebx,%esi
  800d4a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	7e 28                	jle    800d78 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d50:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d54:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d5b:	00 
  800d5c:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800d63:	00 
  800d64:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6b:	00 
  800d6c:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800d73:	e8 80 f3 ff ff       	call   8000f8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d78:	83 c4 2c             	add    $0x2c,%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	89 df                	mov    %ebx,%edi
  800d9b:	89 de                	mov    %ebx,%esi
  800d9d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7e 28                	jle    800dcb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dae:	00 
  800daf:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800db6:	00 
  800db7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbe:	00 
  800dbf:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800dc6:	e8 2d f3 ff ff       	call   8000f8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dcb:	83 c4 2c             	add    $0x2c,%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	89 df                	mov    %ebx,%edi
  800dee:	89 de                	mov    %ebx,%esi
  800df0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7e 28                	jle    800e1e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dfa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e01:	00 
  800e02:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800e09:	00 
  800e0a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e11:	00 
  800e12:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800e19:	e8 da f2 ff ff       	call   8000f8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1e:	83 c4 2c             	add    $0x2c,%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2c:	be 00 00 00 00       	mov    $0x0,%esi
  800e31:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e42:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e57:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	89 cb                	mov    %ecx,%ebx
  800e61:	89 cf                	mov    %ecx,%edi
  800e63:	89 ce                	mov    %ecx,%esi
  800e65:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7e 28                	jle    800e93 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e76:	00 
  800e77:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e86:	00 
  800e87:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800e8e:	e8 65 f2 ff ff       	call   8000f8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e93:	83 c4 2c             	add    $0x2c,%esp
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eab:	89 d1                	mov    %edx,%ecx
  800ead:	89 d3                	mov    %edx,%ebx
  800eaf:	89 d7                	mov    %edx,%edi
  800eb1:	89 d6                	mov    %edx,%esi
  800eb3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    

00800eba <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
  800ec0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ecd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	89 df                	mov    %ebx,%edi
  800ed5:	89 de                	mov    %ebx,%esi
  800ed7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7e 28                	jle    800f05 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ee8:	00 
  800ee9:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800ef0:	00 
  800ef1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef8:	00 
  800ef9:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800f00:	e8 f3 f1 ff ff       	call   8000f8 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800f05:	83 c4 2c             	add    $0x2c,%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	89 df                	mov    %ebx,%edi
  800f28:	89 de                	mov    %ebx,%esi
  800f2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7e 28                	jle    800f58 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f34:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f3b:	00 
  800f3c:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800f43:	00 
  800f44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4b:	00 
  800f4c:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800f53:	e8 a0 f1 ff ff       	call   8000f8 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800f58:	83 c4 2c             	add    $0x2c,%esp
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6e:	b8 11 00 00 00       	mov    $0x11,%eax
  800f73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f76:	8b 55 08             	mov    0x8(%ebp),%edx
  800f79:	89 df                	mov    %ebx,%edi
  800f7b:	89 de                	mov    %ebx,%esi
  800f7d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7e 28                	jle    800fab <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f87:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800f8e:	00 
  800f8f:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800f96:	00 
  800f97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9e:	00 
  800f9f:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800fa6:	e8 4d f1 ff ff       	call   8000f8 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  800fab:	83 c4 2c             	add    $0x2c,%esp
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <sys_sleep>:

int
sys_sleep(int channel)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	57                   	push   %edi
  800fb7:	56                   	push   %esi
  800fb8:	53                   	push   %ebx
  800fb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc1:	b8 12 00 00 00       	mov    $0x12,%eax
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	89 cb                	mov    %ecx,%ebx
  800fcb:	89 cf                	mov    %ecx,%edi
  800fcd:	89 ce                	mov    %ecx,%esi
  800fcf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	7e 28                	jle    800ffd <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800fe0:	00 
  800fe1:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  800fe8:	00 
  800fe9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff0:	00 
  800ff1:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  800ff8:	e8 fb f0 ff ff       	call   8000f8 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  800ffd:	83 c4 2c             	add    $0x2c,%esp
  801000:	5b                   	pop    %ebx
  801001:	5e                   	pop    %esi
  801002:	5f                   	pop    %edi
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    

00801005 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	57                   	push   %edi
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
  80100b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801013:	b8 13 00 00 00       	mov    $0x13,%eax
  801018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101b:	8b 55 08             	mov    0x8(%ebp),%edx
  80101e:	89 df                	mov    %ebx,%edi
  801020:	89 de                	mov    %ebx,%esi
  801022:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801024:	85 c0                	test   %eax,%eax
  801026:	7e 28                	jle    801050 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801028:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801033:	00 
  801034:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  80103b:	00 
  80103c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801043:	00 
  801044:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  80104b:	e8 a8 f0 ff ff       	call   8000f8 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801050:	83 c4 2c             	add    $0x2c,%esp
  801053:	5b                   	pop    %ebx
  801054:	5e                   	pop    %esi
  801055:	5f                   	pop    %edi
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    
  801058:	66 90                	xchg   %ax,%ax
  80105a:	66 90                	xchg   %ax,%ax
  80105c:	66 90                	xchg   %ax,%ax
  80105e:	66 90                	xchg   %ax,%ax

00801060 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	05 00 00 00 30       	add    $0x30000000,%eax
  80106b:	c1 e8 0c             	shr    $0xc,%eax
}
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80107b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801080:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801092:	89 c2                	mov    %eax,%edx
  801094:	c1 ea 16             	shr    $0x16,%edx
  801097:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80109e:	f6 c2 01             	test   $0x1,%dl
  8010a1:	74 11                	je     8010b4 <fd_alloc+0x2d>
  8010a3:	89 c2                	mov    %eax,%edx
  8010a5:	c1 ea 0c             	shr    $0xc,%edx
  8010a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010af:	f6 c2 01             	test   $0x1,%dl
  8010b2:	75 09                	jne    8010bd <fd_alloc+0x36>
			*fd_store = fd;
  8010b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bb:	eb 17                	jmp    8010d4 <fd_alloc+0x4d>
  8010bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010c7:	75 c9                	jne    801092 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010dc:	83 f8 1f             	cmp    $0x1f,%eax
  8010df:	77 36                	ja     801117 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010e1:	c1 e0 0c             	shl    $0xc,%eax
  8010e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010e9:	89 c2                	mov    %eax,%edx
  8010eb:	c1 ea 16             	shr    $0x16,%edx
  8010ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010f5:	f6 c2 01             	test   $0x1,%dl
  8010f8:	74 24                	je     80111e <fd_lookup+0x48>
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	c1 ea 0c             	shr    $0xc,%edx
  8010ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801106:	f6 c2 01             	test   $0x1,%dl
  801109:	74 1a                	je     801125 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80110b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110e:	89 02                	mov    %eax,(%edx)
	return 0;
  801110:	b8 00 00 00 00       	mov    $0x0,%eax
  801115:	eb 13                	jmp    80112a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111c:	eb 0c                	jmp    80112a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80111e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801123:	eb 05                	jmp    80112a <fd_lookup+0x54>
  801125:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 18             	sub    $0x18,%esp
  801132:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801135:	ba 00 00 00 00       	mov    $0x0,%edx
  80113a:	eb 13                	jmp    80114f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80113c:	39 08                	cmp    %ecx,(%eax)
  80113e:	75 0c                	jne    80114c <dev_lookup+0x20>
			*dev = devtab[i];
  801140:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801143:	89 01                	mov    %eax,(%ecx)
			return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb 38                	jmp    801184 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80114c:	83 c2 01             	add    $0x1,%edx
  80114f:	8b 04 95 d4 31 80 00 	mov    0x8031d4(,%edx,4),%eax
  801156:	85 c0                	test   %eax,%eax
  801158:	75 e2                	jne    80113c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80115a:	a1 08 50 80 00       	mov    0x805008,%eax
  80115f:	8b 40 48             	mov    0x48(%eax),%eax
  801162:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80116a:	c7 04 24 58 31 80 00 	movl   $0x803158,(%esp)
  801171:	e8 7b f0 ff ff       	call   8001f1 <cprintf>
	*dev = 0;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80117f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	56                   	push   %esi
  80118a:	53                   	push   %ebx
  80118b:	83 ec 20             	sub    $0x20,%esp
  80118e:	8b 75 08             	mov    0x8(%ebp),%esi
  801191:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801194:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801197:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a4:	89 04 24             	mov    %eax,(%esp)
  8011a7:	e8 2a ff ff ff       	call   8010d6 <fd_lookup>
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 05                	js     8011b5 <fd_close+0x2f>
	    || fd != fd2)
  8011b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011b3:	74 0c                	je     8011c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011b5:	84 db                	test   %bl,%bl
  8011b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bc:	0f 44 c2             	cmove  %edx,%eax
  8011bf:	eb 3f                	jmp    801200 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c8:	8b 06                	mov    (%esi),%eax
  8011ca:	89 04 24             	mov    %eax,(%esp)
  8011cd:	e8 5a ff ff ff       	call   80112c <dev_lookup>
  8011d2:	89 c3                	mov    %eax,%ebx
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	78 16                	js     8011ee <fd_close+0x68>
		if (dev->dev_close)
  8011d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	74 07                	je     8011ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011e7:	89 34 24             	mov    %esi,(%esp)
  8011ea:	ff d0                	call   *%eax
  8011ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011f9:	e8 dc fa ff ff       	call   800cda <sys_page_unmap>
	return r;
  8011fe:	89 d8                	mov    %ebx,%eax
}
  801200:	83 c4 20             	add    $0x20,%esp
  801203:	5b                   	pop    %ebx
  801204:	5e                   	pop    %esi
  801205:	5d                   	pop    %ebp
  801206:	c3                   	ret    

00801207 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80120d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801210:	89 44 24 04          	mov    %eax,0x4(%esp)
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	89 04 24             	mov    %eax,(%esp)
  80121a:	e8 b7 fe ff ff       	call   8010d6 <fd_lookup>
  80121f:	89 c2                	mov    %eax,%edx
  801221:	85 d2                	test   %edx,%edx
  801223:	78 13                	js     801238 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801225:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80122c:	00 
  80122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801230:	89 04 24             	mov    %eax,(%esp)
  801233:	e8 4e ff ff ff       	call   801186 <fd_close>
}
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <close_all>:

void
close_all(void)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	53                   	push   %ebx
  80123e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801241:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801246:	89 1c 24             	mov    %ebx,(%esp)
  801249:	e8 b9 ff ff ff       	call   801207 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80124e:	83 c3 01             	add    $0x1,%ebx
  801251:	83 fb 20             	cmp    $0x20,%ebx
  801254:	75 f0                	jne    801246 <close_all+0xc>
		close(i);
}
  801256:	83 c4 14             	add    $0x14,%esp
  801259:	5b                   	pop    %ebx
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	57                   	push   %edi
  801260:	56                   	push   %esi
  801261:	53                   	push   %ebx
  801262:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801265:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	89 04 24             	mov    %eax,(%esp)
  801272:	e8 5f fe ff ff       	call   8010d6 <fd_lookup>
  801277:	89 c2                	mov    %eax,%edx
  801279:	85 d2                	test   %edx,%edx
  80127b:	0f 88 e1 00 00 00    	js     801362 <dup+0x106>
		return r;
	close(newfdnum);
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	89 04 24             	mov    %eax,(%esp)
  801287:	e8 7b ff ff ff       	call   801207 <close>

	newfd = INDEX2FD(newfdnum);
  80128c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80128f:	c1 e3 0c             	shl    $0xc,%ebx
  801292:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80129b:	89 04 24             	mov    %eax,(%esp)
  80129e:	e8 cd fd ff ff       	call   801070 <fd2data>
  8012a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012a5:	89 1c 24             	mov    %ebx,(%esp)
  8012a8:	e8 c3 fd ff ff       	call   801070 <fd2data>
  8012ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012af:	89 f0                	mov    %esi,%eax
  8012b1:	c1 e8 16             	shr    $0x16,%eax
  8012b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012bb:	a8 01                	test   $0x1,%al
  8012bd:	74 43                	je     801302 <dup+0xa6>
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	c1 e8 0c             	shr    $0xc,%eax
  8012c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012cb:	f6 c2 01             	test   $0x1,%dl
  8012ce:	74 32                	je     801302 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012eb:	00 
  8012ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012f7:	e8 8b f9 ff ff       	call   800c87 <sys_page_map>
  8012fc:	89 c6                	mov    %eax,%esi
  8012fe:	85 c0                	test   %eax,%eax
  801300:	78 3e                	js     801340 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801305:	89 c2                	mov    %eax,%edx
  801307:	c1 ea 0c             	shr    $0xc,%edx
  80130a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801311:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801317:	89 54 24 10          	mov    %edx,0x10(%esp)
  80131b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80131f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801326:	00 
  801327:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801332:	e8 50 f9 ff ff       	call   800c87 <sys_page_map>
  801337:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80133c:	85 f6                	test   %esi,%esi
  80133e:	79 22                	jns    801362 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801340:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134b:	e8 8a f9 ff ff       	call   800cda <sys_page_unmap>
	sys_page_unmap(0, nva);
  801350:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801354:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80135b:	e8 7a f9 ff ff       	call   800cda <sys_page_unmap>
	return r;
  801360:	89 f0                	mov    %esi,%eax
}
  801362:	83 c4 3c             	add    $0x3c,%esp
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	83 ec 24             	sub    $0x24,%esp
  801371:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801374:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137b:	89 1c 24             	mov    %ebx,(%esp)
  80137e:	e8 53 fd ff ff       	call   8010d6 <fd_lookup>
  801383:	89 c2                	mov    %eax,%edx
  801385:	85 d2                	test   %edx,%edx
  801387:	78 6d                	js     8013f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801389:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801393:	8b 00                	mov    (%eax),%eax
  801395:	89 04 24             	mov    %eax,(%esp)
  801398:	e8 8f fd ff ff       	call   80112c <dev_lookup>
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 55                	js     8013f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a4:	8b 50 08             	mov    0x8(%eax),%edx
  8013a7:	83 e2 03             	and    $0x3,%edx
  8013aa:	83 fa 01             	cmp    $0x1,%edx
  8013ad:	75 23                	jne    8013d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013af:	a1 08 50 80 00       	mov    0x805008,%eax
  8013b4:	8b 40 48             	mov    0x48(%eax),%eax
  8013b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bf:	c7 04 24 99 31 80 00 	movl   $0x803199,(%esp)
  8013c6:	e8 26 ee ff ff       	call   8001f1 <cprintf>
		return -E_INVAL;
  8013cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d0:	eb 24                	jmp    8013f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d5:	8b 52 08             	mov    0x8(%edx),%edx
  8013d8:	85 d2                	test   %edx,%edx
  8013da:	74 15                	je     8013f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013ea:	89 04 24             	mov    %eax,(%esp)
  8013ed:	ff d2                	call   *%edx
  8013ef:	eb 05                	jmp    8013f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013f6:	83 c4 24             	add    $0x24,%esp
  8013f9:	5b                   	pop    %ebx
  8013fa:	5d                   	pop    %ebp
  8013fb:	c3                   	ret    

008013fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	57                   	push   %edi
  801400:	56                   	push   %esi
  801401:	53                   	push   %ebx
  801402:	83 ec 1c             	sub    $0x1c,%esp
  801405:	8b 7d 08             	mov    0x8(%ebp),%edi
  801408:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80140b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801410:	eb 23                	jmp    801435 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801412:	89 f0                	mov    %esi,%eax
  801414:	29 d8                	sub    %ebx,%eax
  801416:	89 44 24 08          	mov    %eax,0x8(%esp)
  80141a:	89 d8                	mov    %ebx,%eax
  80141c:	03 45 0c             	add    0xc(%ebp),%eax
  80141f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801423:	89 3c 24             	mov    %edi,(%esp)
  801426:	e8 3f ff ff ff       	call   80136a <read>
		if (m < 0)
  80142b:	85 c0                	test   %eax,%eax
  80142d:	78 10                	js     80143f <readn+0x43>
			return m;
		if (m == 0)
  80142f:	85 c0                	test   %eax,%eax
  801431:	74 0a                	je     80143d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801433:	01 c3                	add    %eax,%ebx
  801435:	39 f3                	cmp    %esi,%ebx
  801437:	72 d9                	jb     801412 <readn+0x16>
  801439:	89 d8                	mov    %ebx,%eax
  80143b:	eb 02                	jmp    80143f <readn+0x43>
  80143d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80143f:	83 c4 1c             	add    $0x1c,%esp
  801442:	5b                   	pop    %ebx
  801443:	5e                   	pop    %esi
  801444:	5f                   	pop    %edi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	53                   	push   %ebx
  80144b:	83 ec 24             	sub    $0x24,%esp
  80144e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801451:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801454:	89 44 24 04          	mov    %eax,0x4(%esp)
  801458:	89 1c 24             	mov    %ebx,(%esp)
  80145b:	e8 76 fc ff ff       	call   8010d6 <fd_lookup>
  801460:	89 c2                	mov    %eax,%edx
  801462:	85 d2                	test   %edx,%edx
  801464:	78 68                	js     8014ce <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801466:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801469:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801470:	8b 00                	mov    (%eax),%eax
  801472:	89 04 24             	mov    %eax,(%esp)
  801475:	e8 b2 fc ff ff       	call   80112c <dev_lookup>
  80147a:	85 c0                	test   %eax,%eax
  80147c:	78 50                	js     8014ce <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80147e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801481:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801485:	75 23                	jne    8014aa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801487:	a1 08 50 80 00       	mov    0x805008,%eax
  80148c:	8b 40 48             	mov    0x48(%eax),%eax
  80148f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801493:	89 44 24 04          	mov    %eax,0x4(%esp)
  801497:	c7 04 24 b5 31 80 00 	movl   $0x8031b5,(%esp)
  80149e:	e8 4e ed ff ff       	call   8001f1 <cprintf>
		return -E_INVAL;
  8014a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a8:	eb 24                	jmp    8014ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8014b0:	85 d2                	test   %edx,%edx
  8014b2:	74 15                	je     8014c9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014c2:	89 04 24             	mov    %eax,(%esp)
  8014c5:	ff d2                	call   *%edx
  8014c7:	eb 05                	jmp    8014ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014ce:	83 c4 24             	add    $0x24,%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5d                   	pop    %ebp
  8014d3:	c3                   	ret    

008014d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 04 24             	mov    %eax,(%esp)
  8014e7:	e8 ea fb ff ff       	call   8010d6 <fd_lookup>
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 0e                	js     8014fe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	53                   	push   %ebx
  801504:	83 ec 24             	sub    $0x24,%esp
  801507:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801511:	89 1c 24             	mov    %ebx,(%esp)
  801514:	e8 bd fb ff ff       	call   8010d6 <fd_lookup>
  801519:	89 c2                	mov    %eax,%edx
  80151b:	85 d2                	test   %edx,%edx
  80151d:	78 61                	js     801580 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801522:	89 44 24 04          	mov    %eax,0x4(%esp)
  801526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	89 04 24             	mov    %eax,(%esp)
  80152e:	e8 f9 fb ff ff       	call   80112c <dev_lookup>
  801533:	85 c0                	test   %eax,%eax
  801535:	78 49                	js     801580 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80153e:	75 23                	jne    801563 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801540:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801545:	8b 40 48             	mov    0x48(%eax),%eax
  801548:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80154c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801550:	c7 04 24 78 31 80 00 	movl   $0x803178,(%esp)
  801557:	e8 95 ec ff ff       	call   8001f1 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80155c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801561:	eb 1d                	jmp    801580 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801566:	8b 52 18             	mov    0x18(%edx),%edx
  801569:	85 d2                	test   %edx,%edx
  80156b:	74 0e                	je     80157b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80156d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801570:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801574:	89 04 24             	mov    %eax,(%esp)
  801577:	ff d2                	call   *%edx
  801579:	eb 05                	jmp    801580 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80157b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801580:	83 c4 24             	add    $0x24,%esp
  801583:	5b                   	pop    %ebx
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	53                   	push   %ebx
  80158a:	83 ec 24             	sub    $0x24,%esp
  80158d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801590:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801593:	89 44 24 04          	mov    %eax,0x4(%esp)
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	89 04 24             	mov    %eax,(%esp)
  80159d:	e8 34 fb ff ff       	call   8010d6 <fd_lookup>
  8015a2:	89 c2                	mov    %eax,%edx
  8015a4:	85 d2                	test   %edx,%edx
  8015a6:	78 52                	js     8015fa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	8b 00                	mov    (%eax),%eax
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	e8 70 fb ff ff       	call   80112c <dev_lookup>
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 3a                	js     8015fa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015c7:	74 2c                	je     8015f5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015d3:	00 00 00 
	stat->st_isdir = 0;
  8015d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015dd:	00 00 00 
	stat->st_dev = dev;
  8015e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ed:	89 14 24             	mov    %edx,(%esp)
  8015f0:	ff 50 14             	call   *0x14(%eax)
  8015f3:	eb 05                	jmp    8015fa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015fa:	83 c4 24             	add    $0x24,%esp
  8015fd:	5b                   	pop    %ebx
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    

00801600 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	56                   	push   %esi
  801604:	53                   	push   %ebx
  801605:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801608:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80160f:	00 
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	89 04 24             	mov    %eax,(%esp)
  801616:	e8 1b 02 00 00       	call   801836 <open>
  80161b:	89 c3                	mov    %eax,%ebx
  80161d:	85 db                	test   %ebx,%ebx
  80161f:	78 1b                	js     80163c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	89 44 24 04          	mov    %eax,0x4(%esp)
  801628:	89 1c 24             	mov    %ebx,(%esp)
  80162b:	e8 56 ff ff ff       	call   801586 <fstat>
  801630:	89 c6                	mov    %eax,%esi
	close(fd);
  801632:	89 1c 24             	mov    %ebx,(%esp)
  801635:	e8 cd fb ff ff       	call   801207 <close>
	return r;
  80163a:	89 f0                	mov    %esi,%eax
}
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    

00801643 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	56                   	push   %esi
  801647:	53                   	push   %ebx
  801648:	83 ec 10             	sub    $0x10,%esp
  80164b:	89 c6                	mov    %eax,%esi
  80164d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80164f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801656:	75 11                	jne    801669 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801658:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80165f:	e8 db 13 00 00       	call   802a3f <ipc_find_env>
  801664:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801669:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801670:	00 
  801671:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801678:	00 
  801679:	89 74 24 04          	mov    %esi,0x4(%esp)
  80167d:	a1 00 50 80 00       	mov    0x805000,%eax
  801682:	89 04 24             	mov    %eax,(%esp)
  801685:	e8 4a 13 00 00       	call   8029d4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80168a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801691:	00 
  801692:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801696:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80169d:	e8 de 12 00 00       	call   802980 <ipc_recv>
}
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    

008016a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8016ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016cc:	e8 72 ff ff ff       	call   801643 <fsipc>
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016df:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ee:	e8 50 ff ff ff       	call   801643 <fsipc>
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	53                   	push   %ebx
  8016f9:	83 ec 14             	sub    $0x14,%esp
  8016fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8b 40 0c             	mov    0xc(%eax),%eax
  801705:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80170a:	ba 00 00 00 00       	mov    $0x0,%edx
  80170f:	b8 05 00 00 00       	mov    $0x5,%eax
  801714:	e8 2a ff ff ff       	call   801643 <fsipc>
  801719:	89 c2                	mov    %eax,%edx
  80171b:	85 d2                	test   %edx,%edx
  80171d:	78 2b                	js     80174a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80171f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801726:	00 
  801727:	89 1c 24             	mov    %ebx,(%esp)
  80172a:	e8 e8 f0 ff ff       	call   800817 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80172f:	a1 80 60 80 00       	mov    0x806080,%eax
  801734:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80173a:	a1 84 60 80 00       	mov    0x806084,%eax
  80173f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174a:	83 c4 14             	add    $0x14,%esp
  80174d:	5b                   	pop    %ebx
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 18             	sub    $0x18,%esp
  801756:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801759:	8b 55 08             	mov    0x8(%ebp),%edx
  80175c:	8b 52 0c             	mov    0xc(%edx),%edx
  80175f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801765:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80176a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801771:	89 44 24 04          	mov    %eax,0x4(%esp)
  801775:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80177c:	e8 9b f2 ff ff       	call   800a1c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801781:	ba 00 00 00 00       	mov    $0x0,%edx
  801786:	b8 04 00 00 00       	mov    $0x4,%eax
  80178b:	e8 b3 fe ff ff       	call   801643 <fsipc>
		return r;
	}

	return r;
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	56                   	push   %esi
  801796:	53                   	push   %ebx
  801797:	83 ec 10             	sub    $0x10,%esp
  80179a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8017a8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017b8:	e8 86 fe ff ff       	call   801643 <fsipc>
  8017bd:	89 c3                	mov    %eax,%ebx
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	78 6a                	js     80182d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017c3:	39 c6                	cmp    %eax,%esi
  8017c5:	73 24                	jae    8017eb <devfile_read+0x59>
  8017c7:	c7 44 24 0c e8 31 80 	movl   $0x8031e8,0xc(%esp)
  8017ce:	00 
  8017cf:	c7 44 24 08 ef 31 80 	movl   $0x8031ef,0x8(%esp)
  8017d6:	00 
  8017d7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8017de:	00 
  8017df:	c7 04 24 04 32 80 00 	movl   $0x803204,(%esp)
  8017e6:	e8 0d e9 ff ff       	call   8000f8 <_panic>
	assert(r <= PGSIZE);
  8017eb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f0:	7e 24                	jle    801816 <devfile_read+0x84>
  8017f2:	c7 44 24 0c 0f 32 80 	movl   $0x80320f,0xc(%esp)
  8017f9:	00 
  8017fa:	c7 44 24 08 ef 31 80 	movl   $0x8031ef,0x8(%esp)
  801801:	00 
  801802:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801809:	00 
  80180a:	c7 04 24 04 32 80 00 	movl   $0x803204,(%esp)
  801811:	e8 e2 e8 ff ff       	call   8000f8 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801816:	89 44 24 08          	mov    %eax,0x8(%esp)
  80181a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801821:	00 
  801822:	8b 45 0c             	mov    0xc(%ebp),%eax
  801825:	89 04 24             	mov    %eax,(%esp)
  801828:	e8 87 f1 ff ff       	call   8009b4 <memmove>
	return r;
}
  80182d:	89 d8                	mov    %ebx,%eax
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	53                   	push   %ebx
  80183a:	83 ec 24             	sub    $0x24,%esp
  80183d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801840:	89 1c 24             	mov    %ebx,(%esp)
  801843:	e8 98 ef ff ff       	call   8007e0 <strlen>
  801848:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80184d:	7f 60                	jg     8018af <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80184f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801852:	89 04 24             	mov    %eax,(%esp)
  801855:	e8 2d f8 ff ff       	call   801087 <fd_alloc>
  80185a:	89 c2                	mov    %eax,%edx
  80185c:	85 d2                	test   %edx,%edx
  80185e:	78 54                	js     8018b4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801860:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801864:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80186b:	e8 a7 ef ff ff       	call   800817 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801870:	8b 45 0c             	mov    0xc(%ebp),%eax
  801873:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187b:	b8 01 00 00 00       	mov    $0x1,%eax
  801880:	e8 be fd ff ff       	call   801643 <fsipc>
  801885:	89 c3                	mov    %eax,%ebx
  801887:	85 c0                	test   %eax,%eax
  801889:	79 17                	jns    8018a2 <open+0x6c>
		fd_close(fd, 0);
  80188b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801892:	00 
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	89 04 24             	mov    %eax,(%esp)
  801899:	e8 e8 f8 ff ff       	call   801186 <fd_close>
		return r;
  80189e:	89 d8                	mov    %ebx,%eax
  8018a0:	eb 12                	jmp    8018b4 <open+0x7e>
	}

	return fd2num(fd);
  8018a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a5:	89 04 24             	mov    %eax,(%esp)
  8018a8:	e8 b3 f7 ff ff       	call   801060 <fd2num>
  8018ad:	eb 05                	jmp    8018b4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018af:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018b4:	83 c4 24             	add    $0x24,%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    

008018ba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8018ca:	e8 74 fd ff ff       	call   801643 <fsipc>
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    
  8018d1:	66 90                	xchg   %ax,%ax
  8018d3:	66 90                	xchg   %ax,%ax
  8018d5:	66 90                	xchg   %ax,%ax
  8018d7:	66 90                	xchg   %ax,%ax
  8018d9:	66 90                	xchg   %ax,%ax
  8018db:	66 90                	xchg   %ax,%ax
  8018dd:	66 90                	xchg   %ax,%ax
  8018df:	90                   	nop

008018e0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	57                   	push   %edi
  8018e4:	56                   	push   %esi
  8018e5:	53                   	push   %ebx
  8018e6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8018ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018f3:	00 
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	89 04 24             	mov    %eax,(%esp)
  8018fa:	e8 37 ff ff ff       	call   801836 <open>
  8018ff:	89 c1                	mov    %eax,%ecx
  801901:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801907:	85 c0                	test   %eax,%eax
  801909:	0f 88 fd 04 00 00    	js     801e0c <spawn+0x52c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80190f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801916:	00 
  801917:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80191d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801921:	89 0c 24             	mov    %ecx,(%esp)
  801924:	e8 d3 fa ff ff       	call   8013fc <readn>
  801929:	3d 00 02 00 00       	cmp    $0x200,%eax
  80192e:	75 0c                	jne    80193c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801930:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801937:	45 4c 46 
  80193a:	74 36                	je     801972 <spawn+0x92>
		close(fd);
  80193c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801942:	89 04 24             	mov    %eax,(%esp)
  801945:	e8 bd f8 ff ff       	call   801207 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80194a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801951:	46 
  801952:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195c:	c7 04 24 1b 32 80 00 	movl   $0x80321b,(%esp)
  801963:	e8 89 e8 ff ff       	call   8001f1 <cprintf>
		return -E_NOT_EXEC;
  801968:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80196d:	e9 4a 05 00 00       	jmp    801ebc <spawn+0x5dc>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801972:	b8 07 00 00 00       	mov    $0x7,%eax
  801977:	cd 30                	int    $0x30
  801979:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80197f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801985:	85 c0                	test   %eax,%eax
  801987:	0f 88 8a 04 00 00    	js     801e17 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80198d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801992:	89 c2                	mov    %eax,%edx
  801994:	c1 e2 07             	shl    $0x7,%edx
  801997:	8d b4 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%esi
  80199e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8019a4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8019a9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8019ab:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8019b1:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019b7:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8019bc:	be 00 00 00 00       	mov    $0x0,%esi
  8019c1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8019c4:	eb 0f                	jmp    8019d5 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8019c6:	89 04 24             	mov    %eax,(%esp)
  8019c9:	e8 12 ee ff ff       	call   8007e0 <strlen>
  8019ce:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019d2:	83 c3 01             	add    $0x1,%ebx
  8019d5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8019dc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 e3                	jne    8019c6 <spawn+0xe6>
  8019e3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8019e9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8019ef:	bf 00 10 40 00       	mov    $0x401000,%edi
  8019f4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8019f6:	89 fa                	mov    %edi,%edx
  8019f8:	83 e2 fc             	and    $0xfffffffc,%edx
  8019fb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a0a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a0d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a12:	0f 86 15 04 00 00    	jbe    801e2d <spawn+0x54d>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a18:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a1f:	00 
  801a20:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a27:	00 
  801a28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a2f:	e8 ff f1 ff ff       	call   800c33 <sys_page_alloc>
  801a34:	85 c0                	test   %eax,%eax
  801a36:	0f 88 80 04 00 00    	js     801ebc <spawn+0x5dc>
  801a3c:	be 00 00 00 00       	mov    $0x0,%esi
  801a41:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801a47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a4a:	eb 30                	jmp    801a7c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801a4c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a52:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801a58:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a5b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a62:	89 3c 24             	mov    %edi,(%esp)
  801a65:	e8 ad ed ff ff       	call   800817 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a6a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801a6d:	89 04 24             	mov    %eax,(%esp)
  801a70:	e8 6b ed ff ff       	call   8007e0 <strlen>
  801a75:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a79:	83 c6 01             	add    $0x1,%esi
  801a7c:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801a82:	7f c8                	jg     801a4c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801a84:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a8a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801a90:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a97:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801a9d:	74 24                	je     801ac3 <spawn+0x1e3>
  801a9f:	c7 44 24 0c a8 32 80 	movl   $0x8032a8,0xc(%esp)
  801aa6:	00 
  801aa7:	c7 44 24 08 ef 31 80 	movl   $0x8031ef,0x8(%esp)
  801aae:	00 
  801aaf:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801ab6:	00 
  801ab7:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  801abe:	e8 35 e6 ff ff       	call   8000f8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ac3:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801ac9:	89 c8                	mov    %ecx,%eax
  801acb:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801ad0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801ad3:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801ad9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801adc:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801ae2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ae8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801aef:	00 
  801af0:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801af7:	ee 
  801af8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801afe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b02:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b09:	00 
  801b0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b11:	e8 71 f1 ff ff       	call   800c87 <sys_page_map>
  801b16:	89 c3                	mov    %eax,%ebx
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	0f 88 86 03 00 00    	js     801ea6 <spawn+0x5c6>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b20:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b27:	00 
  801b28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2f:	e8 a6 f1 ff ff       	call   800cda <sys_page_unmap>
  801b34:	89 c3                	mov    %eax,%ebx
  801b36:	85 c0                	test   %eax,%eax
  801b38:	0f 88 68 03 00 00    	js     801ea6 <spawn+0x5c6>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b3e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b44:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801b4b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b51:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801b58:	00 00 00 
  801b5b:	e9 b6 01 00 00       	jmp    801d16 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801b60:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801b66:	83 38 01             	cmpl   $0x1,(%eax)
  801b69:	0f 85 99 01 00 00    	jne    801d08 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b6f:	89 c1                	mov    %eax,%ecx
  801b71:	8b 40 18             	mov    0x18(%eax),%eax
  801b74:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801b77:	83 f8 01             	cmp    $0x1,%eax
  801b7a:	19 c0                	sbb    %eax,%eax
  801b7c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b82:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801b89:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b90:	89 c8                	mov    %ecx,%eax
  801b92:	8b 49 04             	mov    0x4(%ecx),%ecx
  801b95:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801b9b:	8b 48 10             	mov    0x10(%eax),%ecx
  801b9e:	89 8d 94 fd ff ff    	mov    %ecx,-0x26c(%ebp)
  801ba4:	8b 50 14             	mov    0x14(%eax),%edx
  801ba7:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  801bad:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801bb0:	89 f0                	mov    %esi,%eax
  801bb2:	25 ff 0f 00 00       	and    $0xfff,%eax
  801bb7:	74 14                	je     801bcd <spawn+0x2ed>
		va -= i;
  801bb9:	29 c6                	sub    %eax,%esi
		memsz += i;
  801bbb:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801bc1:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801bc7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801bcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bd2:	e9 23 01 00 00       	jmp    801cfa <spawn+0x41a>
		if (i >= filesz) {
  801bd7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801bdd:	77 2b                	ja     801c0a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801bdf:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801be5:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bed:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801bf3:	89 04 24             	mov    %eax,(%esp)
  801bf6:	e8 38 f0 ff ff       	call   800c33 <sys_page_alloc>
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	0f 89 eb 00 00 00    	jns    801cee <spawn+0x40e>
  801c03:	89 c3                	mov    %eax,%ebx
  801c05:	e9 37 02 00 00       	jmp    801e41 <spawn+0x561>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c0a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c11:	00 
  801c12:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c19:	00 
  801c1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c21:	e8 0d f0 ff ff       	call   800c33 <sys_page_alloc>
  801c26:	85 c0                	test   %eax,%eax
  801c28:	0f 88 09 02 00 00    	js     801e37 <spawn+0x557>
  801c2e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c34:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c40:	89 04 24             	mov    %eax,(%esp)
  801c43:	e8 8c f8 ff ff       	call   8014d4 <seek>
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	0f 88 eb 01 00 00    	js     801e3b <spawn+0x55b>
  801c50:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801c56:	29 f9                	sub    %edi,%ecx
  801c58:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c5a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801c60:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c65:	0f 47 c2             	cmova  %edx,%eax
  801c68:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c6c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c73:	00 
  801c74:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c7a:	89 04 24             	mov    %eax,(%esp)
  801c7d:	e8 7a f7 ff ff       	call   8013fc <readn>
  801c82:	85 c0                	test   %eax,%eax
  801c84:	0f 88 b5 01 00 00    	js     801e3f <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c8a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c90:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c94:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c98:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ca9:	00 
  801caa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb1:	e8 d1 ef ff ff       	call   800c87 <sys_page_map>
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	79 20                	jns    801cda <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  801cba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cbe:	c7 44 24 08 41 32 80 	movl   $0x803241,0x8(%esp)
  801cc5:	00 
  801cc6:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  801ccd:	00 
  801cce:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  801cd5:	e8 1e e4 ff ff       	call   8000f8 <_panic>
			sys_page_unmap(0, UTEMP);
  801cda:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ce1:	00 
  801ce2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce9:	e8 ec ef ff ff       	call   800cda <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801cee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cf4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801cfa:	89 df                	mov    %ebx,%edi
  801cfc:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801d02:	0f 87 cf fe ff ff    	ja     801bd7 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d08:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801d0f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801d16:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d1d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801d23:	0f 8c 37 fe ff ff    	jl     801b60 <spawn+0x280>
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	
	close(fd);
  801d29:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d2f:	89 04 24             	mov    %eax,(%esp)
  801d32:	e8 d0 f4 ff ff       	call   801207 <close>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801d37:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d3c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
		if(((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_SHARE))
  801d42:	89 d8                	mov    %ebx,%eax
  801d44:	c1 e8 16             	shr    $0x16,%eax
  801d47:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d4e:	a8 01                	test   $0x1,%al
  801d50:	74 4d                	je     801d9f <spawn+0x4bf>
  801d52:	89 d8                	mov    %ebx,%eax
  801d54:	c1 e8 0c             	shr    $0xc,%eax
  801d57:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801d5e:	f6 c2 01             	test   $0x1,%dl
  801d61:	74 3c                	je     801d9f <spawn+0x4bf>
  801d63:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801d6a:	f6 c6 04             	test   $0x4,%dh
  801d6d:	74 30                	je     801d9f <spawn+0x4bf>
		&& ((r = sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)]&PTE_SYSCALL)) < 0)){
  801d6f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d76:	25 07 0e 00 00       	and    $0xe07,%eax
  801d7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d7f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d83:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d87:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d8b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d92:	e8 f0 ee ff ff       	call   800c87 <sys_page_map>
  801d97:	85 c0                	test   %eax,%eax
  801d99:	0f 88 e7 00 00 00    	js     801e86 <spawn+0x5a6>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801d9f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801da5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801dab:	75 95                	jne    801d42 <spawn+0x462>
  801dad:	e9 af 00 00 00       	jmp    801e61 <spawn+0x581>
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  801db2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801db6:	c7 44 24 08 5e 32 80 	movl   $0x80325e,0x8(%esp)
  801dbd:	00 
  801dbe:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  801dc5:	00 
  801dc6:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  801dcd:	e8 26 e3 ff ff       	call   8000f8 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801dd2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801dd9:	00 
  801dda:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801de0:	89 04 24             	mov    %eax,(%esp)
  801de3:	e8 45 ef ff ff       	call   800d2d <sys_env_set_status>
  801de8:	85 c0                	test   %eax,%eax
  801dea:	79 36                	jns    801e22 <spawn+0x542>
		panic("sys_env_set_status: %e", r);
  801dec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df0:	c7 44 24 08 78 32 80 	movl   $0x803278,0x8(%esp)
  801df7:	00 
  801df8:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  801dff:	00 
  801e00:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  801e07:	e8 ec e2 ff ff       	call   8000f8 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801e0c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e12:	e9 a5 00 00 00       	jmp    801ebc <spawn+0x5dc>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801e17:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e1d:	e9 9a 00 00 00       	jmp    801ebc <spawn+0x5dc>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801e22:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e28:	e9 8f 00 00 00       	jmp    801ebc <spawn+0x5dc>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801e2d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801e32:	e9 85 00 00 00       	jmp    801ebc <spawn+0x5dc>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	eb 06                	jmp    801e41 <spawn+0x561>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e3b:	89 c3                	mov    %eax,%ebx
  801e3d:	eb 02                	jmp    801e41 <spawn+0x561>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e3f:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  801e41:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e47:	89 04 24             	mov    %eax,(%esp)
  801e4a:	e8 54 ed ff ff       	call   800ba3 <sys_env_destroy>
	close(fd);
  801e4f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e55:	89 04 24             	mov    %eax,(%esp)
  801e58:	e8 aa f3 ff ff       	call   801207 <close>
	return r;
  801e5d:	89 d8                	mov    %ebx,%eax
  801e5f:	eb 5b                	jmp    801ebc <spawn+0x5dc>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e61:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e71:	89 04 24             	mov    %eax,(%esp)
  801e74:	e8 07 ef ff ff       	call   800d80 <sys_env_set_trapframe>
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	0f 89 51 ff ff ff    	jns    801dd2 <spawn+0x4f2>
  801e81:	e9 2c ff ff ff       	jmp    801db2 <spawn+0x4d2>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  801e86:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e8a:	c7 44 24 08 8f 32 80 	movl   $0x80328f,0x8(%esp)
  801e91:	00 
  801e92:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  801e99:	00 
  801e9a:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  801ea1:	e8 52 e2 ff ff       	call   8000f8 <_panic>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801ea6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ead:	00 
  801eae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb5:	e8 20 ee ff ff       	call   800cda <sys_page_unmap>
  801eba:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801ebc:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5f                   	pop    %edi
  801ec5:	5d                   	pop    %ebp
  801ec6:	c3                   	ret    

00801ec7 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	56                   	push   %esi
  801ecb:	53                   	push   %ebx
  801ecc:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801ecf:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801ed2:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801ed7:	eb 03                	jmp    801edc <spawnl+0x15>
		argc++;
  801ed9:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801edc:	83 c0 04             	add    $0x4,%eax
  801edf:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801ee3:	75 f4                	jne    801ed9 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801ee5:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  801eec:	83 e0 f0             	and    $0xfffffff0,%eax
  801eef:	29 c4                	sub    %eax,%esp
  801ef1:	8d 44 24 0b          	lea    0xb(%esp),%eax
  801ef5:	c1 e8 02             	shr    $0x2,%eax
  801ef8:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  801eff:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f04:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  801f0b:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  801f12:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	eb 0a                	jmp    801f24 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  801f1a:	83 c0 01             	add    $0x1,%eax
  801f1d:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801f21:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801f24:	39 d0                	cmp    %edx,%eax
  801f26:	75 f2                	jne    801f1a <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801f28:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	89 04 24             	mov    %eax,(%esp)
  801f32:	e8 a9 f9 ff ff       	call   8018e0 <spawn>
}
  801f37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3a:	5b                   	pop    %ebx
  801f3b:	5e                   	pop    %esi
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    
  801f3e:	66 90                	xchg   %ax,%ax

00801f40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f46:	c7 44 24 04 ce 32 80 	movl   $0x8032ce,0x4(%esp)
  801f4d:	00 
  801f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f51:	89 04 24             	mov    %eax,(%esp)
  801f54:	e8 be e8 ff ff       	call   800817 <strcpy>
	return 0;
}
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	53                   	push   %ebx
  801f64:	83 ec 14             	sub    $0x14,%esp
  801f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f6a:	89 1c 24             	mov    %ebx,(%esp)
  801f6d:	e8 0c 0b 00 00       	call   802a7e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f72:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f77:	83 f8 01             	cmp    $0x1,%eax
  801f7a:	75 0d                	jne    801f89 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f7c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f7f:	89 04 24             	mov    %eax,(%esp)
  801f82:	e8 29 03 00 00       	call   8022b0 <nsipc_close>
  801f87:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f89:	89 d0                	mov    %edx,%eax
  801f8b:	83 c4 14             	add    $0x14,%esp
  801f8e:	5b                   	pop    %ebx
  801f8f:	5d                   	pop    %ebp
  801f90:	c3                   	ret    

00801f91 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f97:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f9e:	00 
  801f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb3:	89 04 24             	mov    %eax,(%esp)
  801fb6:	e8 f0 03 00 00       	call   8023ab <nsipc_send>
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fc3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fca:	00 
  801fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fce:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fdf:	89 04 24             	mov    %eax,(%esp)
  801fe2:	e8 44 03 00 00       	call   80232b <nsipc_recv>
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fef:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ff2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ff6:	89 04 24             	mov    %eax,(%esp)
  801ff9:	e8 d8 f0 ff ff       	call   8010d6 <fd_lookup>
  801ffe:	85 c0                	test   %eax,%eax
  802000:	78 17                	js     802019 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80200b:	39 08                	cmp    %ecx,(%eax)
  80200d:	75 05                	jne    802014 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80200f:	8b 40 0c             	mov    0xc(%eax),%eax
  802012:	eb 05                	jmp    802019 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802014:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	56                   	push   %esi
  80201f:	53                   	push   %ebx
  802020:	83 ec 20             	sub    $0x20,%esp
  802023:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802025:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802028:	89 04 24             	mov    %eax,(%esp)
  80202b:	e8 57 f0 ff ff       	call   801087 <fd_alloc>
  802030:	89 c3                	mov    %eax,%ebx
  802032:	85 c0                	test   %eax,%eax
  802034:	78 21                	js     802057 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802036:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80203d:	00 
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	89 44 24 04          	mov    %eax,0x4(%esp)
  802045:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80204c:	e8 e2 eb ff ff       	call   800c33 <sys_page_alloc>
  802051:	89 c3                	mov    %eax,%ebx
  802053:	85 c0                	test   %eax,%eax
  802055:	79 0c                	jns    802063 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802057:	89 34 24             	mov    %esi,(%esp)
  80205a:	e8 51 02 00 00       	call   8022b0 <nsipc_close>
		return r;
  80205f:	89 d8                	mov    %ebx,%eax
  802061:	eb 20                	jmp    802083 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802063:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80206e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802071:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802078:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80207b:	89 14 24             	mov    %edx,(%esp)
  80207e:	e8 dd ef ff ff       	call   801060 <fd2num>
}
  802083:	83 c4 20             	add    $0x20,%esp
  802086:	5b                   	pop    %ebx
  802087:	5e                   	pop    %esi
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	e8 51 ff ff ff       	call   801fe9 <fd2sockid>
		return r;
  802098:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80209a:	85 c0                	test   %eax,%eax
  80209c:	78 23                	js     8020c1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80209e:	8b 55 10             	mov    0x10(%ebp),%edx
  8020a1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ac:	89 04 24             	mov    %eax,(%esp)
  8020af:	e8 45 01 00 00       	call   8021f9 <nsipc_accept>
		return r;
  8020b4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	78 07                	js     8020c1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8020ba:	e8 5c ff ff ff       	call   80201b <alloc_sockfd>
  8020bf:	89 c1                	mov    %eax,%ecx
}
  8020c1:	89 c8                	mov    %ecx,%eax
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	e8 16 ff ff ff       	call   801fe9 <fd2sockid>
  8020d3:	89 c2                	mov    %eax,%edx
  8020d5:	85 d2                	test   %edx,%edx
  8020d7:	78 16                	js     8020ef <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8020d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e7:	89 14 24             	mov    %edx,(%esp)
  8020ea:	e8 60 01 00 00       	call   80224f <nsipc_bind>
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <shutdown>:

int
shutdown(int s, int how)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	e8 ea fe ff ff       	call   801fe9 <fd2sockid>
  8020ff:	89 c2                	mov    %eax,%edx
  802101:	85 d2                	test   %edx,%edx
  802103:	78 0f                	js     802114 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802105:	8b 45 0c             	mov    0xc(%ebp),%eax
  802108:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210c:	89 14 24             	mov    %edx,(%esp)
  80210f:	e8 7a 01 00 00       	call   80228e <nsipc_shutdown>
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	e8 c5 fe ff ff       	call   801fe9 <fd2sockid>
  802124:	89 c2                	mov    %eax,%edx
  802126:	85 d2                	test   %edx,%edx
  802128:	78 16                	js     802140 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80212a:	8b 45 10             	mov    0x10(%ebp),%eax
  80212d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802131:	8b 45 0c             	mov    0xc(%ebp),%eax
  802134:	89 44 24 04          	mov    %eax,0x4(%esp)
  802138:	89 14 24             	mov    %edx,(%esp)
  80213b:	e8 8a 01 00 00       	call   8022ca <nsipc_connect>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <listen>:

int
listen(int s, int backlog)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	e8 99 fe ff ff       	call   801fe9 <fd2sockid>
  802150:	89 c2                	mov    %eax,%edx
  802152:	85 d2                	test   %edx,%edx
  802154:	78 0f                	js     802165 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802156:	8b 45 0c             	mov    0xc(%ebp),%eax
  802159:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215d:	89 14 24             	mov    %edx,(%esp)
  802160:	e8 a4 01 00 00       	call   802309 <nsipc_listen>
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80216d:	8b 45 10             	mov    0x10(%ebp),%eax
  802170:	89 44 24 08          	mov    %eax,0x8(%esp)
  802174:	8b 45 0c             	mov    0xc(%ebp),%eax
  802177:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	89 04 24             	mov    %eax,(%esp)
  802181:	e8 98 02 00 00       	call   80241e <nsipc_socket>
  802186:	89 c2                	mov    %eax,%edx
  802188:	85 d2                	test   %edx,%edx
  80218a:	78 05                	js     802191 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80218c:	e8 8a fe ff ff       	call   80201b <alloc_sockfd>
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	53                   	push   %ebx
  802197:	83 ec 14             	sub    $0x14,%esp
  80219a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80219c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021a3:	75 11                	jne    8021b6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021a5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8021ac:	e8 8e 08 00 00       	call   802a3f <ipc_find_env>
  8021b1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021b6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8021bd:	00 
  8021be:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8021c5:	00 
  8021c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8021cf:	89 04 24             	mov    %eax,(%esp)
  8021d2:	e8 fd 07 00 00       	call   8029d4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021de:	00 
  8021df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021e6:	00 
  8021e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ee:	e8 8d 07 00 00       	call   802980 <ipc_recv>
}
  8021f3:	83 c4 14             	add    $0x14,%esp
  8021f6:	5b                   	pop    %ebx
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    

008021f9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	56                   	push   %esi
  8021fd:	53                   	push   %ebx
  8021fe:	83 ec 10             	sub    $0x10,%esp
  802201:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80220c:	8b 06                	mov    (%esi),%eax
  80220e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802213:	b8 01 00 00 00       	mov    $0x1,%eax
  802218:	e8 76 ff ff ff       	call   802193 <nsipc>
  80221d:	89 c3                	mov    %eax,%ebx
  80221f:	85 c0                	test   %eax,%eax
  802221:	78 23                	js     802246 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802223:	a1 10 70 80 00       	mov    0x807010,%eax
  802228:	89 44 24 08          	mov    %eax,0x8(%esp)
  80222c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802233:	00 
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	89 04 24             	mov    %eax,(%esp)
  80223a:	e8 75 e7 ff ff       	call   8009b4 <memmove>
		*addrlen = ret->ret_addrlen;
  80223f:	a1 10 70 80 00       	mov    0x807010,%eax
  802244:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802246:	89 d8                	mov    %ebx,%eax
  802248:	83 c4 10             	add    $0x10,%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5d                   	pop    %ebp
  80224e:	c3                   	ret    

0080224f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	53                   	push   %ebx
  802253:	83 ec 14             	sub    $0x14,%esp
  802256:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802261:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802265:	8b 45 0c             	mov    0xc(%ebp),%eax
  802268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802273:	e8 3c e7 ff ff       	call   8009b4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802278:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80227e:	b8 02 00 00 00       	mov    $0x2,%eax
  802283:	e8 0b ff ff ff       	call   802193 <nsipc>
}
  802288:	83 c4 14             	add    $0x14,%esp
  80228b:	5b                   	pop    %ebx
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    

0080228e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80229c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8022a9:	e8 e5 fe ff ff       	call   802193 <nsipc>
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <nsipc_close>:

int
nsipc_close(int s)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022be:	b8 04 00 00 00       	mov    $0x4,%eax
  8022c3:	e8 cb fe ff ff       	call   802193 <nsipc>
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	53                   	push   %ebx
  8022ce:	83 ec 14             	sub    $0x14,%esp
  8022d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8022ee:	e8 c1 e6 ff ff       	call   8009b4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022f3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022f9:	b8 05 00 00 00       	mov    $0x5,%eax
  8022fe:	e8 90 fe ff ff       	call   802193 <nsipc>
}
  802303:	83 c4 14             	add    $0x14,%esp
  802306:	5b                   	pop    %ebx
  802307:	5d                   	pop    %ebp
  802308:	c3                   	ret    

00802309 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80231f:	b8 06 00 00 00       	mov    $0x6,%eax
  802324:	e8 6a fe ff ff       	call   802193 <nsipc>
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	56                   	push   %esi
  80232f:	53                   	push   %ebx
  802330:	83 ec 10             	sub    $0x10,%esp
  802333:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80233e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802344:	8b 45 14             	mov    0x14(%ebp),%eax
  802347:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80234c:	b8 07 00 00 00       	mov    $0x7,%eax
  802351:	e8 3d fe ff ff       	call   802193 <nsipc>
  802356:	89 c3                	mov    %eax,%ebx
  802358:	85 c0                	test   %eax,%eax
  80235a:	78 46                	js     8023a2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80235c:	39 f0                	cmp    %esi,%eax
  80235e:	7f 07                	jg     802367 <nsipc_recv+0x3c>
  802360:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802365:	7e 24                	jle    80238b <nsipc_recv+0x60>
  802367:	c7 44 24 0c da 32 80 	movl   $0x8032da,0xc(%esp)
  80236e:	00 
  80236f:	c7 44 24 08 ef 31 80 	movl   $0x8031ef,0x8(%esp)
  802376:	00 
  802377:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80237e:	00 
  80237f:	c7 04 24 ef 32 80 00 	movl   $0x8032ef,(%esp)
  802386:	e8 6d dd ff ff       	call   8000f8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80238b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80238f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802396:	00 
  802397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239a:	89 04 24             	mov    %eax,(%esp)
  80239d:	e8 12 e6 ff ff       	call   8009b4 <memmove>
	}

	return r;
}
  8023a2:	89 d8                	mov    %ebx,%eax
  8023a4:	83 c4 10             	add    $0x10,%esp
  8023a7:	5b                   	pop    %ebx
  8023a8:	5e                   	pop    %esi
  8023a9:	5d                   	pop    %ebp
  8023aa:	c3                   	ret    

008023ab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	53                   	push   %ebx
  8023af:	83 ec 14             	sub    $0x14,%esp
  8023b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023bd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023c3:	7e 24                	jle    8023e9 <nsipc_send+0x3e>
  8023c5:	c7 44 24 0c fb 32 80 	movl   $0x8032fb,0xc(%esp)
  8023cc:	00 
  8023cd:	c7 44 24 08 ef 31 80 	movl   $0x8031ef,0x8(%esp)
  8023d4:	00 
  8023d5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8023dc:	00 
  8023dd:	c7 04 24 ef 32 80 00 	movl   $0x8032ef,(%esp)
  8023e4:	e8 0f dd ff ff       	call   8000f8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8023fb:	e8 b4 e5 ff ff       	call   8009b4 <memmove>
	nsipcbuf.send.req_size = size;
  802400:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802406:	8b 45 14             	mov    0x14(%ebp),%eax
  802409:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80240e:	b8 08 00 00 00       	mov    $0x8,%eax
  802413:	e8 7b fd ff ff       	call   802193 <nsipc>
}
  802418:	83 c4 14             	add    $0x14,%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    

0080241e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802434:	8b 45 10             	mov    0x10(%ebp),%eax
  802437:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80243c:	b8 09 00 00 00       	mov    $0x9,%eax
  802441:	e8 4d fd ff ff       	call   802193 <nsipc>
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
  80244b:	56                   	push   %esi
  80244c:	53                   	push   %ebx
  80244d:	83 ec 10             	sub    $0x10,%esp
  802450:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	89 04 24             	mov    %eax,(%esp)
  802459:	e8 12 ec ff ff       	call   801070 <fd2data>
  80245e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802460:	c7 44 24 04 07 33 80 	movl   $0x803307,0x4(%esp)
  802467:	00 
  802468:	89 1c 24             	mov    %ebx,(%esp)
  80246b:	e8 a7 e3 ff ff       	call   800817 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802470:	8b 46 04             	mov    0x4(%esi),%eax
  802473:	2b 06                	sub    (%esi),%eax
  802475:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80247b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802482:	00 00 00 
	stat->st_dev = &devpipe;
  802485:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80248c:	40 80 00 
	return 0;
}
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
  802494:	83 c4 10             	add    $0x10,%esp
  802497:	5b                   	pop    %ebx
  802498:	5e                   	pop    %esi
  802499:	5d                   	pop    %ebp
  80249a:	c3                   	ret    

0080249b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	53                   	push   %ebx
  80249f:	83 ec 14             	sub    $0x14,%esp
  8024a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b0:	e8 25 e8 ff ff       	call   800cda <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024b5:	89 1c 24             	mov    %ebx,(%esp)
  8024b8:	e8 b3 eb ff ff       	call   801070 <fd2data>
  8024bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c8:	e8 0d e8 ff ff       	call   800cda <sys_page_unmap>
}
  8024cd:	83 c4 14             	add    $0x14,%esp
  8024d0:	5b                   	pop    %ebx
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    

008024d3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	57                   	push   %edi
  8024d7:	56                   	push   %esi
  8024d8:	53                   	push   %ebx
  8024d9:	83 ec 2c             	sub    $0x2c,%esp
  8024dc:	89 c6                	mov    %eax,%esi
  8024de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8024e1:	a1 08 50 80 00       	mov    0x805008,%eax
  8024e6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024e9:	89 34 24             	mov    %esi,(%esp)
  8024ec:	e8 8d 05 00 00       	call   802a7e <pageref>
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f6:	89 04 24             	mov    %eax,(%esp)
  8024f9:	e8 80 05 00 00       	call   802a7e <pageref>
  8024fe:	39 c7                	cmp    %eax,%edi
  802500:	0f 94 c2             	sete   %dl
  802503:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802506:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80250c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80250f:	39 fb                	cmp    %edi,%ebx
  802511:	74 21                	je     802534 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802513:	84 d2                	test   %dl,%dl
  802515:	74 ca                	je     8024e1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802517:	8b 51 58             	mov    0x58(%ecx),%edx
  80251a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80251e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802522:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802526:	c7 04 24 0e 33 80 00 	movl   $0x80330e,(%esp)
  80252d:	e8 bf dc ff ff       	call   8001f1 <cprintf>
  802532:	eb ad                	jmp    8024e1 <_pipeisclosed+0xe>
	}
}
  802534:	83 c4 2c             	add    $0x2c,%esp
  802537:	5b                   	pop    %ebx
  802538:	5e                   	pop    %esi
  802539:	5f                   	pop    %edi
  80253a:	5d                   	pop    %ebp
  80253b:	c3                   	ret    

0080253c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	57                   	push   %edi
  802540:	56                   	push   %esi
  802541:	53                   	push   %ebx
  802542:	83 ec 1c             	sub    $0x1c,%esp
  802545:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802548:	89 34 24             	mov    %esi,(%esp)
  80254b:	e8 20 eb ff ff       	call   801070 <fd2data>
  802550:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802552:	bf 00 00 00 00       	mov    $0x0,%edi
  802557:	eb 45                	jmp    80259e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802559:	89 da                	mov    %ebx,%edx
  80255b:	89 f0                	mov    %esi,%eax
  80255d:	e8 71 ff ff ff       	call   8024d3 <_pipeisclosed>
  802562:	85 c0                	test   %eax,%eax
  802564:	75 41                	jne    8025a7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802566:	e8 a9 e6 ff ff       	call   800c14 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80256b:	8b 43 04             	mov    0x4(%ebx),%eax
  80256e:	8b 0b                	mov    (%ebx),%ecx
  802570:	8d 51 20             	lea    0x20(%ecx),%edx
  802573:	39 d0                	cmp    %edx,%eax
  802575:	73 e2                	jae    802559 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802577:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80257a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80257e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802581:	99                   	cltd   
  802582:	c1 ea 1b             	shr    $0x1b,%edx
  802585:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802588:	83 e1 1f             	and    $0x1f,%ecx
  80258b:	29 d1                	sub    %edx,%ecx
  80258d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802591:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802595:	83 c0 01             	add    $0x1,%eax
  802598:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80259b:	83 c7 01             	add    $0x1,%edi
  80259e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025a1:	75 c8                	jne    80256b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8025a3:	89 f8                	mov    %edi,%eax
  8025a5:	eb 05                	jmp    8025ac <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025a7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8025ac:	83 c4 1c             	add    $0x1c,%esp
  8025af:	5b                   	pop    %ebx
  8025b0:	5e                   	pop    %esi
  8025b1:	5f                   	pop    %edi
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    

008025b4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
  8025b7:	57                   	push   %edi
  8025b8:	56                   	push   %esi
  8025b9:	53                   	push   %ebx
  8025ba:	83 ec 1c             	sub    $0x1c,%esp
  8025bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8025c0:	89 3c 24             	mov    %edi,(%esp)
  8025c3:	e8 a8 ea ff ff       	call   801070 <fd2data>
  8025c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025ca:	be 00 00 00 00       	mov    $0x0,%esi
  8025cf:	eb 3d                	jmp    80260e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8025d1:	85 f6                	test   %esi,%esi
  8025d3:	74 04                	je     8025d9 <devpipe_read+0x25>
				return i;
  8025d5:	89 f0                	mov    %esi,%eax
  8025d7:	eb 43                	jmp    80261c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025d9:	89 da                	mov    %ebx,%edx
  8025db:	89 f8                	mov    %edi,%eax
  8025dd:	e8 f1 fe ff ff       	call   8024d3 <_pipeisclosed>
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	75 31                	jne    802617 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8025e6:	e8 29 e6 ff ff       	call   800c14 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8025eb:	8b 03                	mov    (%ebx),%eax
  8025ed:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025f0:	74 df                	je     8025d1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025f2:	99                   	cltd   
  8025f3:	c1 ea 1b             	shr    $0x1b,%edx
  8025f6:	01 d0                	add    %edx,%eax
  8025f8:	83 e0 1f             	and    $0x1f,%eax
  8025fb:	29 d0                	sub    %edx,%eax
  8025fd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802602:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802605:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802608:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80260b:	83 c6 01             	add    $0x1,%esi
  80260e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802611:	75 d8                	jne    8025eb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802613:	89 f0                	mov    %esi,%eax
  802615:	eb 05                	jmp    80261c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802617:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80261c:	83 c4 1c             	add    $0x1c,%esp
  80261f:	5b                   	pop    %ebx
  802620:	5e                   	pop    %esi
  802621:	5f                   	pop    %edi
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    

00802624 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	56                   	push   %esi
  802628:	53                   	push   %ebx
  802629:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80262c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80262f:	89 04 24             	mov    %eax,(%esp)
  802632:	e8 50 ea ff ff       	call   801087 <fd_alloc>
  802637:	89 c2                	mov    %eax,%edx
  802639:	85 d2                	test   %edx,%edx
  80263b:	0f 88 4d 01 00 00    	js     80278e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802641:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802648:	00 
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802650:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802657:	e8 d7 e5 ff ff       	call   800c33 <sys_page_alloc>
  80265c:	89 c2                	mov    %eax,%edx
  80265e:	85 d2                	test   %edx,%edx
  802660:	0f 88 28 01 00 00    	js     80278e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802666:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802669:	89 04 24             	mov    %eax,(%esp)
  80266c:	e8 16 ea ff ff       	call   801087 <fd_alloc>
  802671:	89 c3                	mov    %eax,%ebx
  802673:	85 c0                	test   %eax,%eax
  802675:	0f 88 fe 00 00 00    	js     802779 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802682:	00 
  802683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802686:	89 44 24 04          	mov    %eax,0x4(%esp)
  80268a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802691:	e8 9d e5 ff ff       	call   800c33 <sys_page_alloc>
  802696:	89 c3                	mov    %eax,%ebx
  802698:	85 c0                	test   %eax,%eax
  80269a:	0f 88 d9 00 00 00    	js     802779 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	89 04 24             	mov    %eax,(%esp)
  8026a6:	e8 c5 e9 ff ff       	call   801070 <fd2data>
  8026ab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026ad:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026b4:	00 
  8026b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c0:	e8 6e e5 ff ff       	call   800c33 <sys_page_alloc>
  8026c5:	89 c3                	mov    %eax,%ebx
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	0f 88 97 00 00 00    	js     802766 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d2:	89 04 24             	mov    %eax,(%esp)
  8026d5:	e8 96 e9 ff ff       	call   801070 <fd2data>
  8026da:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026e1:	00 
  8026e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026ed:	00 
  8026ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f9:	e8 89 e5 ff ff       	call   800c87 <sys_page_map>
  8026fe:	89 c3                	mov    %eax,%ebx
  802700:	85 c0                	test   %eax,%eax
  802702:	78 52                	js     802756 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802704:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802719:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802727:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	89 04 24             	mov    %eax,(%esp)
  802734:	e8 27 e9 ff ff       	call   801060 <fd2num>
  802739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80273c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	89 04 24             	mov    %eax,(%esp)
  802744:	e8 17 e9 ff ff       	call   801060 <fd2num>
  802749:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80274c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80274f:	b8 00 00 00 00       	mov    $0x0,%eax
  802754:	eb 38                	jmp    80278e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802756:	89 74 24 04          	mov    %esi,0x4(%esp)
  80275a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802761:	e8 74 e5 ff ff       	call   800cda <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802769:	89 44 24 04          	mov    %eax,0x4(%esp)
  80276d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802774:	e8 61 e5 ff ff       	call   800cda <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802780:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802787:	e8 4e e5 ff ff       	call   800cda <sys_page_unmap>
  80278c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80278e:	83 c4 30             	add    $0x30,%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    

00802795 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80279b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80279e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	89 04 24             	mov    %eax,(%esp)
  8027a8:	e8 29 e9 ff ff       	call   8010d6 <fd_lookup>
  8027ad:	89 c2                	mov    %eax,%edx
  8027af:	85 d2                	test   %edx,%edx
  8027b1:	78 15                	js     8027c8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	89 04 24             	mov    %eax,(%esp)
  8027b9:	e8 b2 e8 ff ff       	call   801070 <fd2data>
	return _pipeisclosed(fd, p);
  8027be:	89 c2                	mov    %eax,%edx
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	e8 0b fd ff ff       	call   8024d3 <_pipeisclosed>
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    
  8027ca:	66 90                	xchg   %ax,%ax
  8027cc:	66 90                	xchg   %ax,%ax
  8027ce:	66 90                	xchg   %ax,%ax

008027d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    

008027da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8027e0:	c7 44 24 04 26 33 80 	movl   $0x803326,0x4(%esp)
  8027e7:	00 
  8027e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027eb:	89 04 24             	mov    %eax,(%esp)
  8027ee:	e8 24 e0 ff ff       	call   800817 <strcpy>
	return 0;
}
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	57                   	push   %edi
  8027fe:	56                   	push   %esi
  8027ff:	53                   	push   %ebx
  802800:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802806:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80280b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802811:	eb 31                	jmp    802844 <devcons_write+0x4a>
		m = n - tot;
  802813:	8b 75 10             	mov    0x10(%ebp),%esi
  802816:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802818:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80281b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802820:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802823:	89 74 24 08          	mov    %esi,0x8(%esp)
  802827:	03 45 0c             	add    0xc(%ebp),%eax
  80282a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80282e:	89 3c 24             	mov    %edi,(%esp)
  802831:	e8 7e e1 ff ff       	call   8009b4 <memmove>
		sys_cputs(buf, m);
  802836:	89 74 24 04          	mov    %esi,0x4(%esp)
  80283a:	89 3c 24             	mov    %edi,(%esp)
  80283d:	e8 24 e3 ff ff       	call   800b66 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802842:	01 f3                	add    %esi,%ebx
  802844:	89 d8                	mov    %ebx,%eax
  802846:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802849:	72 c8                	jb     802813 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80284b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802851:	5b                   	pop    %ebx
  802852:	5e                   	pop    %esi
  802853:	5f                   	pop    %edi
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    

00802856 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80285c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802861:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802865:	75 07                	jne    80286e <devcons_read+0x18>
  802867:	eb 2a                	jmp    802893 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802869:	e8 a6 e3 ff ff       	call   800c14 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80286e:	66 90                	xchg   %ax,%ax
  802870:	e8 0f e3 ff ff       	call   800b84 <sys_cgetc>
  802875:	85 c0                	test   %eax,%eax
  802877:	74 f0                	je     802869 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802879:	85 c0                	test   %eax,%eax
  80287b:	78 16                	js     802893 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80287d:	83 f8 04             	cmp    $0x4,%eax
  802880:	74 0c                	je     80288e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802882:	8b 55 0c             	mov    0xc(%ebp),%edx
  802885:	88 02                	mov    %al,(%edx)
	return 1;
  802887:	b8 01 00 00 00       	mov    $0x1,%eax
  80288c:	eb 05                	jmp    802893 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802893:	c9                   	leave  
  802894:	c3                   	ret    

00802895 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
  802898:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028a8:	00 
  8028a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028ac:	89 04 24             	mov    %eax,(%esp)
  8028af:	e8 b2 e2 ff ff       	call   800b66 <sys_cputs>
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <getchar>:

int
getchar(void)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028c3:	00 
  8028c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d2:	e8 93 ea ff ff       	call   80136a <read>
	if (r < 0)
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	78 0f                	js     8028ea <getchar+0x34>
		return r;
	if (r < 1)
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	7e 06                	jle    8028e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8028df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8028e3:	eb 05                	jmp    8028ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8028e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8028ea:	c9                   	leave  
  8028eb:	c3                   	ret    

008028ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	89 04 24             	mov    %eax,(%esp)
  8028ff:	e8 d2 e7 ff ff       	call   8010d6 <fd_lookup>
  802904:	85 c0                	test   %eax,%eax
  802906:	78 11                	js     802919 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802911:	39 10                	cmp    %edx,(%eax)
  802913:	0f 94 c0             	sete   %al
  802916:	0f b6 c0             	movzbl %al,%eax
}
  802919:	c9                   	leave  
  80291a:	c3                   	ret    

0080291b <opencons>:

int
opencons(void)
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802921:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802924:	89 04 24             	mov    %eax,(%esp)
  802927:	e8 5b e7 ff ff       	call   801087 <fd_alloc>
		return r;
  80292c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80292e:	85 c0                	test   %eax,%eax
  802930:	78 40                	js     802972 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802932:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802939:	00 
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802941:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802948:	e8 e6 e2 ff ff       	call   800c33 <sys_page_alloc>
		return r;
  80294d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80294f:	85 c0                	test   %eax,%eax
  802951:	78 1f                	js     802972 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802953:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802968:	89 04 24             	mov    %eax,(%esp)
  80296b:	e8 f0 e6 ff ff       	call   801060 <fd2num>
  802970:	89 c2                	mov    %eax,%edx
}
  802972:	89 d0                	mov    %edx,%eax
  802974:	c9                   	leave  
  802975:	c3                   	ret    
  802976:	66 90                	xchg   %ax,%ax
  802978:	66 90                	xchg   %ax,%ax
  80297a:	66 90                	xchg   %ax,%ax
  80297c:	66 90                	xchg   %ax,%ax
  80297e:	66 90                	xchg   %ax,%ax

00802980 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
  802983:	56                   	push   %esi
  802984:	53                   	push   %ebx
  802985:	83 ec 10             	sub    $0x10,%esp
  802988:	8b 75 08             	mov    0x8(%ebp),%esi
  80298b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80298e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802991:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802993:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802998:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80299b:	89 04 24             	mov    %eax,(%esp)
  80299e:	e8 a6 e4 ff ff       	call   800e49 <sys_ipc_recv>
  8029a3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8029a5:	85 d2                	test   %edx,%edx
  8029a7:	75 24                	jne    8029cd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8029a9:	85 f6                	test   %esi,%esi
  8029ab:	74 0a                	je     8029b7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8029ad:	a1 08 50 80 00       	mov    0x805008,%eax
  8029b2:	8b 40 74             	mov    0x74(%eax),%eax
  8029b5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8029b7:	85 db                	test   %ebx,%ebx
  8029b9:	74 0a                	je     8029c5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8029bb:	a1 08 50 80 00       	mov    0x805008,%eax
  8029c0:	8b 40 78             	mov    0x78(%eax),%eax
  8029c3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8029c5:	a1 08 50 80 00       	mov    0x805008,%eax
  8029ca:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8029cd:	83 c4 10             	add    $0x10,%esp
  8029d0:	5b                   	pop    %ebx
  8029d1:	5e                   	pop    %esi
  8029d2:	5d                   	pop    %ebp
  8029d3:	c3                   	ret    

008029d4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029d4:	55                   	push   %ebp
  8029d5:	89 e5                	mov    %esp,%ebp
  8029d7:	57                   	push   %edi
  8029d8:	56                   	push   %esi
  8029d9:	53                   	push   %ebx
  8029da:	83 ec 1c             	sub    $0x1c,%esp
  8029dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8029e6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8029e8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029ed:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8029f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8029f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029ff:	89 3c 24             	mov    %edi,(%esp)
  802a02:	e8 1f e4 ff ff       	call   800e26 <sys_ipc_try_send>

		if (ret == 0)
  802a07:	85 c0                	test   %eax,%eax
  802a09:	74 2c                	je     802a37 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  802a0b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a0e:	74 20                	je     802a30 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802a10:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a14:	c7 44 24 08 34 33 80 	movl   $0x803334,0x8(%esp)
  802a1b:	00 
  802a1c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802a23:	00 
  802a24:	c7 04 24 64 33 80 00 	movl   $0x803364,(%esp)
  802a2b:	e8 c8 d6 ff ff       	call   8000f8 <_panic>
		}

		sys_yield();
  802a30:	e8 df e1 ff ff       	call   800c14 <sys_yield>
	}
  802a35:	eb b9                	jmp    8029f0 <ipc_send+0x1c>
}
  802a37:	83 c4 1c             	add    $0x1c,%esp
  802a3a:	5b                   	pop    %ebx
  802a3b:	5e                   	pop    %esi
  802a3c:	5f                   	pop    %edi
  802a3d:	5d                   	pop    %ebp
  802a3e:	c3                   	ret    

00802a3f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
  802a42:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a4a:	89 c2                	mov    %eax,%edx
  802a4c:	c1 e2 07             	shl    $0x7,%edx
  802a4f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802a56:	8b 52 50             	mov    0x50(%edx),%edx
  802a59:	39 ca                	cmp    %ecx,%edx
  802a5b:	75 11                	jne    802a6e <ipc_find_env+0x2f>
			return envs[i].env_id;
  802a5d:	89 c2                	mov    %eax,%edx
  802a5f:	c1 e2 07             	shl    $0x7,%edx
  802a62:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802a69:	8b 40 40             	mov    0x40(%eax),%eax
  802a6c:	eb 0e                	jmp    802a7c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a6e:	83 c0 01             	add    $0x1,%eax
  802a71:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a76:	75 d2                	jne    802a4a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802a78:	66 b8 00 00          	mov    $0x0,%ax
}
  802a7c:	5d                   	pop    %ebp
  802a7d:	c3                   	ret    

00802a7e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a7e:	55                   	push   %ebp
  802a7f:	89 e5                	mov    %esp,%ebp
  802a81:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a84:	89 d0                	mov    %edx,%eax
  802a86:	c1 e8 16             	shr    $0x16,%eax
  802a89:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a90:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a95:	f6 c1 01             	test   $0x1,%cl
  802a98:	74 1d                	je     802ab7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a9a:	c1 ea 0c             	shr    $0xc,%edx
  802a9d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802aa4:	f6 c2 01             	test   $0x1,%dl
  802aa7:	74 0e                	je     802ab7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802aa9:	c1 ea 0c             	shr    $0xc,%edx
  802aac:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802ab3:	ef 
  802ab4:	0f b7 c0             	movzwl %ax,%eax
}
  802ab7:	5d                   	pop    %ebp
  802ab8:	c3                   	ret    
  802ab9:	66 90                	xchg   %ax,%ax
  802abb:	66 90                	xchg   %ax,%ax
  802abd:	66 90                	xchg   %ax,%ax
  802abf:	90                   	nop

00802ac0 <__udivdi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	57                   	push   %edi
  802ac2:	56                   	push   %esi
  802ac3:	83 ec 0c             	sub    $0xc,%esp
  802ac6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802ace:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ad2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802adc:	89 ea                	mov    %ebp,%edx
  802ade:	89 0c 24             	mov    %ecx,(%esp)
  802ae1:	75 2d                	jne    802b10 <__udivdi3+0x50>
  802ae3:	39 e9                	cmp    %ebp,%ecx
  802ae5:	77 61                	ja     802b48 <__udivdi3+0x88>
  802ae7:	85 c9                	test   %ecx,%ecx
  802ae9:	89 ce                	mov    %ecx,%esi
  802aeb:	75 0b                	jne    802af8 <__udivdi3+0x38>
  802aed:	b8 01 00 00 00       	mov    $0x1,%eax
  802af2:	31 d2                	xor    %edx,%edx
  802af4:	f7 f1                	div    %ecx
  802af6:	89 c6                	mov    %eax,%esi
  802af8:	31 d2                	xor    %edx,%edx
  802afa:	89 e8                	mov    %ebp,%eax
  802afc:	f7 f6                	div    %esi
  802afe:	89 c5                	mov    %eax,%ebp
  802b00:	89 f8                	mov    %edi,%eax
  802b02:	f7 f6                	div    %esi
  802b04:	89 ea                	mov    %ebp,%edx
  802b06:	83 c4 0c             	add    $0xc,%esp
  802b09:	5e                   	pop    %esi
  802b0a:	5f                   	pop    %edi
  802b0b:	5d                   	pop    %ebp
  802b0c:	c3                   	ret    
  802b0d:	8d 76 00             	lea    0x0(%esi),%esi
  802b10:	39 e8                	cmp    %ebp,%eax
  802b12:	77 24                	ja     802b38 <__udivdi3+0x78>
  802b14:	0f bd e8             	bsr    %eax,%ebp
  802b17:	83 f5 1f             	xor    $0x1f,%ebp
  802b1a:	75 3c                	jne    802b58 <__udivdi3+0x98>
  802b1c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802b20:	39 34 24             	cmp    %esi,(%esp)
  802b23:	0f 86 9f 00 00 00    	jbe    802bc8 <__udivdi3+0x108>
  802b29:	39 d0                	cmp    %edx,%eax
  802b2b:	0f 82 97 00 00 00    	jb     802bc8 <__udivdi3+0x108>
  802b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b38:	31 d2                	xor    %edx,%edx
  802b3a:	31 c0                	xor    %eax,%eax
  802b3c:	83 c4 0c             	add    $0xc,%esp
  802b3f:	5e                   	pop    %esi
  802b40:	5f                   	pop    %edi
  802b41:	5d                   	pop    %ebp
  802b42:	c3                   	ret    
  802b43:	90                   	nop
  802b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b48:	89 f8                	mov    %edi,%eax
  802b4a:	f7 f1                	div    %ecx
  802b4c:	31 d2                	xor    %edx,%edx
  802b4e:	83 c4 0c             	add    $0xc,%esp
  802b51:	5e                   	pop    %esi
  802b52:	5f                   	pop    %edi
  802b53:	5d                   	pop    %ebp
  802b54:	c3                   	ret    
  802b55:	8d 76 00             	lea    0x0(%esi),%esi
  802b58:	89 e9                	mov    %ebp,%ecx
  802b5a:	8b 3c 24             	mov    (%esp),%edi
  802b5d:	d3 e0                	shl    %cl,%eax
  802b5f:	89 c6                	mov    %eax,%esi
  802b61:	b8 20 00 00 00       	mov    $0x20,%eax
  802b66:	29 e8                	sub    %ebp,%eax
  802b68:	89 c1                	mov    %eax,%ecx
  802b6a:	d3 ef                	shr    %cl,%edi
  802b6c:	89 e9                	mov    %ebp,%ecx
  802b6e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b72:	8b 3c 24             	mov    (%esp),%edi
  802b75:	09 74 24 08          	or     %esi,0x8(%esp)
  802b79:	89 d6                	mov    %edx,%esi
  802b7b:	d3 e7                	shl    %cl,%edi
  802b7d:	89 c1                	mov    %eax,%ecx
  802b7f:	89 3c 24             	mov    %edi,(%esp)
  802b82:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b86:	d3 ee                	shr    %cl,%esi
  802b88:	89 e9                	mov    %ebp,%ecx
  802b8a:	d3 e2                	shl    %cl,%edx
  802b8c:	89 c1                	mov    %eax,%ecx
  802b8e:	d3 ef                	shr    %cl,%edi
  802b90:	09 d7                	or     %edx,%edi
  802b92:	89 f2                	mov    %esi,%edx
  802b94:	89 f8                	mov    %edi,%eax
  802b96:	f7 74 24 08          	divl   0x8(%esp)
  802b9a:	89 d6                	mov    %edx,%esi
  802b9c:	89 c7                	mov    %eax,%edi
  802b9e:	f7 24 24             	mull   (%esp)
  802ba1:	39 d6                	cmp    %edx,%esi
  802ba3:	89 14 24             	mov    %edx,(%esp)
  802ba6:	72 30                	jb     802bd8 <__udivdi3+0x118>
  802ba8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bac:	89 e9                	mov    %ebp,%ecx
  802bae:	d3 e2                	shl    %cl,%edx
  802bb0:	39 c2                	cmp    %eax,%edx
  802bb2:	73 05                	jae    802bb9 <__udivdi3+0xf9>
  802bb4:	3b 34 24             	cmp    (%esp),%esi
  802bb7:	74 1f                	je     802bd8 <__udivdi3+0x118>
  802bb9:	89 f8                	mov    %edi,%eax
  802bbb:	31 d2                	xor    %edx,%edx
  802bbd:	e9 7a ff ff ff       	jmp    802b3c <__udivdi3+0x7c>
  802bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bc8:	31 d2                	xor    %edx,%edx
  802bca:	b8 01 00 00 00       	mov    $0x1,%eax
  802bcf:	e9 68 ff ff ff       	jmp    802b3c <__udivdi3+0x7c>
  802bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802bdb:	31 d2                	xor    %edx,%edx
  802bdd:	83 c4 0c             	add    $0xc,%esp
  802be0:	5e                   	pop    %esi
  802be1:	5f                   	pop    %edi
  802be2:	5d                   	pop    %ebp
  802be3:	c3                   	ret    
  802be4:	66 90                	xchg   %ax,%ax
  802be6:	66 90                	xchg   %ax,%ax
  802be8:	66 90                	xchg   %ax,%ax
  802bea:	66 90                	xchg   %ax,%ax
  802bec:	66 90                	xchg   %ax,%ax
  802bee:	66 90                	xchg   %ax,%ax

00802bf0 <__umoddi3>:
  802bf0:	55                   	push   %ebp
  802bf1:	57                   	push   %edi
  802bf2:	56                   	push   %esi
  802bf3:	83 ec 14             	sub    $0x14,%esp
  802bf6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bfa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bfe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c02:	89 c7                	mov    %eax,%edi
  802c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c08:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c0c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c10:	89 34 24             	mov    %esi,(%esp)
  802c13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c17:	85 c0                	test   %eax,%eax
  802c19:	89 c2                	mov    %eax,%edx
  802c1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c1f:	75 17                	jne    802c38 <__umoddi3+0x48>
  802c21:	39 fe                	cmp    %edi,%esi
  802c23:	76 4b                	jbe    802c70 <__umoddi3+0x80>
  802c25:	89 c8                	mov    %ecx,%eax
  802c27:	89 fa                	mov    %edi,%edx
  802c29:	f7 f6                	div    %esi
  802c2b:	89 d0                	mov    %edx,%eax
  802c2d:	31 d2                	xor    %edx,%edx
  802c2f:	83 c4 14             	add    $0x14,%esp
  802c32:	5e                   	pop    %esi
  802c33:	5f                   	pop    %edi
  802c34:	5d                   	pop    %ebp
  802c35:	c3                   	ret    
  802c36:	66 90                	xchg   %ax,%ax
  802c38:	39 f8                	cmp    %edi,%eax
  802c3a:	77 54                	ja     802c90 <__umoddi3+0xa0>
  802c3c:	0f bd e8             	bsr    %eax,%ebp
  802c3f:	83 f5 1f             	xor    $0x1f,%ebp
  802c42:	75 5c                	jne    802ca0 <__umoddi3+0xb0>
  802c44:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c48:	39 3c 24             	cmp    %edi,(%esp)
  802c4b:	0f 87 e7 00 00 00    	ja     802d38 <__umoddi3+0x148>
  802c51:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c55:	29 f1                	sub    %esi,%ecx
  802c57:	19 c7                	sbb    %eax,%edi
  802c59:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c61:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c65:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c69:	83 c4 14             	add    $0x14,%esp
  802c6c:	5e                   	pop    %esi
  802c6d:	5f                   	pop    %edi
  802c6e:	5d                   	pop    %ebp
  802c6f:	c3                   	ret    
  802c70:	85 f6                	test   %esi,%esi
  802c72:	89 f5                	mov    %esi,%ebp
  802c74:	75 0b                	jne    802c81 <__umoddi3+0x91>
  802c76:	b8 01 00 00 00       	mov    $0x1,%eax
  802c7b:	31 d2                	xor    %edx,%edx
  802c7d:	f7 f6                	div    %esi
  802c7f:	89 c5                	mov    %eax,%ebp
  802c81:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c85:	31 d2                	xor    %edx,%edx
  802c87:	f7 f5                	div    %ebp
  802c89:	89 c8                	mov    %ecx,%eax
  802c8b:	f7 f5                	div    %ebp
  802c8d:	eb 9c                	jmp    802c2b <__umoddi3+0x3b>
  802c8f:	90                   	nop
  802c90:	89 c8                	mov    %ecx,%eax
  802c92:	89 fa                	mov    %edi,%edx
  802c94:	83 c4 14             	add    $0x14,%esp
  802c97:	5e                   	pop    %esi
  802c98:	5f                   	pop    %edi
  802c99:	5d                   	pop    %ebp
  802c9a:	c3                   	ret    
  802c9b:	90                   	nop
  802c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ca0:	8b 04 24             	mov    (%esp),%eax
  802ca3:	be 20 00 00 00       	mov    $0x20,%esi
  802ca8:	89 e9                	mov    %ebp,%ecx
  802caa:	29 ee                	sub    %ebp,%esi
  802cac:	d3 e2                	shl    %cl,%edx
  802cae:	89 f1                	mov    %esi,%ecx
  802cb0:	d3 e8                	shr    %cl,%eax
  802cb2:	89 e9                	mov    %ebp,%ecx
  802cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cb8:	8b 04 24             	mov    (%esp),%eax
  802cbb:	09 54 24 04          	or     %edx,0x4(%esp)
  802cbf:	89 fa                	mov    %edi,%edx
  802cc1:	d3 e0                	shl    %cl,%eax
  802cc3:	89 f1                	mov    %esi,%ecx
  802cc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cc9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802ccd:	d3 ea                	shr    %cl,%edx
  802ccf:	89 e9                	mov    %ebp,%ecx
  802cd1:	d3 e7                	shl    %cl,%edi
  802cd3:	89 f1                	mov    %esi,%ecx
  802cd5:	d3 e8                	shr    %cl,%eax
  802cd7:	89 e9                	mov    %ebp,%ecx
  802cd9:	09 f8                	or     %edi,%eax
  802cdb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802cdf:	f7 74 24 04          	divl   0x4(%esp)
  802ce3:	d3 e7                	shl    %cl,%edi
  802ce5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ce9:	89 d7                	mov    %edx,%edi
  802ceb:	f7 64 24 08          	mull   0x8(%esp)
  802cef:	39 d7                	cmp    %edx,%edi
  802cf1:	89 c1                	mov    %eax,%ecx
  802cf3:	89 14 24             	mov    %edx,(%esp)
  802cf6:	72 2c                	jb     802d24 <__umoddi3+0x134>
  802cf8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802cfc:	72 22                	jb     802d20 <__umoddi3+0x130>
  802cfe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d02:	29 c8                	sub    %ecx,%eax
  802d04:	19 d7                	sbb    %edx,%edi
  802d06:	89 e9                	mov    %ebp,%ecx
  802d08:	89 fa                	mov    %edi,%edx
  802d0a:	d3 e8                	shr    %cl,%eax
  802d0c:	89 f1                	mov    %esi,%ecx
  802d0e:	d3 e2                	shl    %cl,%edx
  802d10:	89 e9                	mov    %ebp,%ecx
  802d12:	d3 ef                	shr    %cl,%edi
  802d14:	09 d0                	or     %edx,%eax
  802d16:	89 fa                	mov    %edi,%edx
  802d18:	83 c4 14             	add    $0x14,%esp
  802d1b:	5e                   	pop    %esi
  802d1c:	5f                   	pop    %edi
  802d1d:	5d                   	pop    %ebp
  802d1e:	c3                   	ret    
  802d1f:	90                   	nop
  802d20:	39 d7                	cmp    %edx,%edi
  802d22:	75 da                	jne    802cfe <__umoddi3+0x10e>
  802d24:	8b 14 24             	mov    (%esp),%edx
  802d27:	89 c1                	mov    %eax,%ecx
  802d29:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802d2d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d31:	eb cb                	jmp    802cfe <__umoddi3+0x10e>
  802d33:	90                   	nop
  802d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d38:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d3c:	0f 82 0f ff ff ff    	jb     802c51 <__umoddi3+0x61>
  802d42:	e9 1a ff ff ff       	jmp    802c61 <__umoddi3+0x71>
