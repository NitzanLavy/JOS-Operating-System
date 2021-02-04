
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 ca 00 00 00       	call   8000fb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 59 11 00 00       	call   80119a <fork>
  800041:	89 c3                	mov    %eax,%ebx
  800043:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800046:	85 c0                	test   %eax,%eax
  800048:	75 05                	jne    80004f <umain+0x1c>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80004a:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004d:	eb 3e                	jmp    80008d <umain+0x5a>
{
	envid_t who;

	if ((who = fork()) != 0) {
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004f:	e8 b1 0b 00 00       	call   800c05 <sys_getenvid>
  800054:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005c:	c7 04 24 00 2c 80 00 	movl   $0x802c00,(%esp)
  800063:	e8 9b 01 00 00       	call   800203 <cprintf>
		ipc_send(who, 0, 0, 0);
  800068:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006f:	00 
  800070:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007f:	00 
  800080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800083:	89 04 24             	mov    %eax,(%esp)
  800086:	e8 39 14 00 00       	call   8014c4 <ipc_send>
  80008b:	eb bd                	jmp    80004a <umain+0x17>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80008d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800094:	00 
  800095:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009c:	00 
  80009d:	89 34 24             	mov    %esi,(%esp)
  8000a0:	e8 cb 13 00 00       	call   801470 <ipc_recv>
  8000a5:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8000aa:	e8 56 0b 00 00       	call   800c05 <sys_getenvid>
  8000af:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bb:	c7 04 24 16 2c 80 00 	movl   $0x802c16,(%esp)
  8000c2:	e8 3c 01 00 00       	call   800203 <cprintf>
		if (i == 10)
  8000c7:	83 fb 0a             	cmp    $0xa,%ebx
  8000ca:	74 27                	je     8000f3 <umain+0xc0>
			return;
		i++;
  8000cc:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d6:	00 
  8000d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000de:	00 
  8000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e6:	89 04 24             	mov    %eax,(%esp)
  8000e9:	e8 d6 13 00 00       	call   8014c4 <ipc_send>
		if (i == 10)
  8000ee:	83 fb 0a             	cmp    $0xa,%ebx
  8000f1:	75 9a                	jne    80008d <umain+0x5a>
			return;
	}

}
  8000f3:	83 c4 2c             	add    $0x2c,%esp
  8000f6:	5b                   	pop    %ebx
  8000f7:	5e                   	pop    %esi
  8000f8:	5f                   	pop    %edi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	83 ec 10             	sub    $0x10,%esp
  800103:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800106:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800109:	e8 f7 0a 00 00       	call   800c05 <sys_getenvid>
  80010e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800113:	89 c2                	mov    %eax,%edx
  800115:	c1 e2 07             	shl    $0x7,%edx
  800118:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80011f:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	85 db                	test   %ebx,%ebx
  800126:	7e 07                	jle    80012f <libmain+0x34>
		binaryname = argv[0];
  800128:	8b 06                	mov    (%esi),%eax
  80012a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80012f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800133:	89 1c 24             	mov    %ebx,(%esp)
  800136:	e8 f8 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013b:	e8 07 00 00 00       	call   800147 <exit>
}
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	5b                   	pop    %ebx
  800144:	5e                   	pop    %esi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80014d:	e8 f8 15 00 00       	call   80174a <close_all>
	sys_env_destroy(0);
  800152:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800159:	e8 55 0a 00 00       	call   800bb3 <sys_env_destroy>
}
  80015e:	c9                   	leave  
  80015f:	c3                   	ret    

00800160 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	53                   	push   %ebx
  800164:	83 ec 14             	sub    $0x14,%esp
  800167:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016a:	8b 13                	mov    (%ebx),%edx
  80016c:	8d 42 01             	lea    0x1(%edx),%eax
  80016f:	89 03                	mov    %eax,(%ebx)
  800171:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800174:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800178:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017d:	75 19                	jne    800198 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80017f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800186:	00 
  800187:	8d 43 08             	lea    0x8(%ebx),%eax
  80018a:	89 04 24             	mov    %eax,(%esp)
  80018d:	e8 e4 09 00 00       	call   800b76 <sys_cputs>
		b->idx = 0;
  800192:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800198:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019c:	83 c4 14             	add    $0x14,%esp
  80019f:	5b                   	pop    %ebx
  8001a0:	5d                   	pop    %ebp
  8001a1:	c3                   	ret    

008001a2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b2:	00 00 00 
	b.cnt = 0;
  8001b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d7:	c7 04 24 60 01 80 00 	movl   $0x800160,(%esp)
  8001de:	e8 ab 01 00 00       	call   80038e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ed:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 7b 09 00 00       	call   800b76 <sys_cputs>

	return b.cnt;
}
  8001fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800201:	c9                   	leave  
  800202:	c3                   	ret    

00800203 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800209:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800210:	8b 45 08             	mov    0x8(%ebp),%eax
  800213:	89 04 24             	mov    %eax,(%esp)
  800216:	e8 87 ff ff ff       	call   8001a2 <vcprintf>
	va_end(ap);

	return cnt;
}
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    
  80021d:	66 90                	xchg   %ax,%ax
  80021f:	90                   	nop

00800220 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	57                   	push   %edi
  800224:	56                   	push   %esi
  800225:	53                   	push   %ebx
  800226:	83 ec 3c             	sub    $0x3c,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80022c:	89 d7                	mov    %edx,%edi
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	89 c3                	mov    %eax,%ebx
  800239:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023c:	8b 45 10             	mov    0x10(%ebp),%eax
  80023f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80024d:	39 d9                	cmp    %ebx,%ecx
  80024f:	72 05                	jb     800256 <printnum+0x36>
  800251:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800254:	77 69                	ja     8002bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800256:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800259:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80025d:	83 ee 01             	sub    $0x1,%esi
  800260:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800264:	89 44 24 08          	mov    %eax,0x8(%esp)
  800268:	8b 44 24 08          	mov    0x8(%esp),%eax
  80026c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800270:	89 c3                	mov    %eax,%ebx
  800272:	89 d6                	mov    %edx,%esi
  800274:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800277:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80027a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 dc 26 00 00       	call   802970 <__udivdi3>
  800294:	89 d9                	mov    %ebx,%ecx
  800296:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80029a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80029e:	89 04 24             	mov    %eax,(%esp)
  8002a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a5:	89 fa                	mov    %edi,%edx
  8002a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002aa:	e8 71 ff ff ff       	call   800220 <printnum>
  8002af:	eb 1b                	jmp    8002cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	ff d3                	call   *%ebx
  8002bd:	eb 03                	jmp    8002c2 <printnum+0xa2>
  8002bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c2:	83 ee 01             	sub    $0x1,%esi
  8002c5:	85 f6                	test   %esi,%esi
  8002c7:	7f e8                	jg     8002b1 <printnum+0x91>
  8002c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	e8 ac 27 00 00       	call   802aa0 <__umoddi3>
  8002f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f8:	0f be 80 33 2c 80 00 	movsbl 0x802c33(%eax),%eax
  8002ff:	89 04 24             	mov    %eax,(%esp)
  800302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800305:	ff d0                	call   *%eax
}
  800307:	83 c4 3c             	add    $0x3c,%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800312:	83 fa 01             	cmp    $0x1,%edx
  800315:	7e 0e                	jle    800325 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800317:	8b 10                	mov    (%eax),%edx
  800319:	8d 4a 08             	lea    0x8(%edx),%ecx
  80031c:	89 08                	mov    %ecx,(%eax)
  80031e:	8b 02                	mov    (%edx),%eax
  800320:	8b 52 04             	mov    0x4(%edx),%edx
  800323:	eb 22                	jmp    800347 <getuint+0x38>
	else if (lflag)
  800325:	85 d2                	test   %edx,%edx
  800327:	74 10                	je     800339 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032e:	89 08                	mov    %ecx,(%eax)
  800330:	8b 02                	mov    (%edx),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
  800337:	eb 0e                	jmp    800347 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800339:	8b 10                	mov    (%eax),%edx
  80033b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80033e:	89 08                	mov    %ecx,(%eax)
  800340:	8b 02                	mov    (%edx),%eax
  800342:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800353:	8b 10                	mov    (%eax),%edx
  800355:	3b 50 04             	cmp    0x4(%eax),%edx
  800358:	73 0a                	jae    800364 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035d:	89 08                	mov    %ecx,(%eax)
  80035f:	8b 45 08             	mov    0x8(%ebp),%eax
  800362:	88 02                	mov    %al,(%edx)
}
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80036c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80036f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800373:	8b 45 10             	mov    0x10(%ebp),%eax
  800376:	89 44 24 08          	mov    %eax,0x8(%esp)
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	89 04 24             	mov    %eax,(%esp)
  800387:	e8 02 00 00 00       	call   80038e <vprintfmt>
	va_end(ap);
}
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
  800394:	83 ec 3c             	sub    $0x3c,%esp
  800397:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80039a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80039d:	eb 14                	jmp    8003b3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80039f:	85 c0                	test   %eax,%eax
  8003a1:	0f 84 b3 03 00 00    	je     80075a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ab:	89 04 24             	mov    %eax,(%esp)
  8003ae:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003b1:	89 f3                	mov    %esi,%ebx
  8003b3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003b6:	0f b6 03             	movzbl (%ebx),%eax
  8003b9:	83 f8 25             	cmp    $0x25,%eax
  8003bc:	75 e1                	jne    80039f <vprintfmt+0x11>
  8003be:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003c9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003d0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8003d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dc:	eb 1d                	jmp    8003fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003e0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003e4:	eb 15                	jmp    8003fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003e8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003ec:	eb 0d                	jmp    8003fb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003fe:	0f b6 0e             	movzbl (%esi),%ecx
  800401:	0f b6 c1             	movzbl %cl,%eax
  800404:	83 e9 23             	sub    $0x23,%ecx
  800407:	80 f9 55             	cmp    $0x55,%cl
  80040a:	0f 87 2a 03 00 00    	ja     80073a <vprintfmt+0x3ac>
  800410:	0f b6 c9             	movzbl %cl,%ecx
  800413:	ff 24 8d a0 2d 80 00 	jmp    *0x802da0(,%ecx,4)
  80041a:	89 de                	mov    %ebx,%esi
  80041c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800421:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800424:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800428:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80042b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80042e:	83 fb 09             	cmp    $0x9,%ebx
  800431:	77 36                	ja     800469 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800433:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800436:	eb e9                	jmp    800421 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 48 04             	lea    0x4(%eax),%ecx
  80043e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800448:	eb 22                	jmp    80046c <vprintfmt+0xde>
  80044a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80044d:	85 c9                	test   %ecx,%ecx
  80044f:	b8 00 00 00 00       	mov    $0x0,%eax
  800454:	0f 49 c1             	cmovns %ecx,%eax
  800457:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	89 de                	mov    %ebx,%esi
  80045c:	eb 9d                	jmp    8003fb <vprintfmt+0x6d>
  80045e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800460:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800467:	eb 92                	jmp    8003fb <vprintfmt+0x6d>
  800469:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80046c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800470:	79 89                	jns    8003fb <vprintfmt+0x6d>
  800472:	e9 77 ff ff ff       	jmp    8003ee <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800477:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80047c:	e9 7a ff ff ff       	jmp    8003fb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800481:	8b 45 14             	mov    0x14(%ebp),%eax
  800484:	8d 50 04             	lea    0x4(%eax),%edx
  800487:	89 55 14             	mov    %edx,0x14(%ebp)
  80048a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	89 04 24             	mov    %eax,(%esp)
  800493:	ff 55 08             	call   *0x8(%ebp)
			break;
  800496:	e9 18 ff ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	8d 50 04             	lea    0x4(%eax),%edx
  8004a1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	99                   	cltd   
  8004a7:	31 d0                	xor    %edx,%eax
  8004a9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ab:	83 f8 12             	cmp    $0x12,%eax
  8004ae:	7f 0b                	jg     8004bb <vprintfmt+0x12d>
  8004b0:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  8004b7:	85 d2                	test   %edx,%edx
  8004b9:	75 20                	jne    8004db <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004bf:	c7 44 24 08 4b 2c 80 	movl   $0x802c4b,0x8(%esp)
  8004c6:	00 
  8004c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	89 04 24             	mov    %eax,(%esp)
  8004d1:	e8 90 fe ff ff       	call   800366 <printfmt>
  8004d6:	e9 d8 fe ff ff       	jmp    8003b3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004df:	c7 44 24 08 6d 31 80 	movl   $0x80316d,0x8(%esp)
  8004e6:	00 
  8004e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	89 04 24             	mov    %eax,(%esp)
  8004f1:	e8 70 fe ff ff       	call   800366 <printfmt>
  8004f6:	e9 b8 fe ff ff       	jmp    8003b3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800501:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8d 50 04             	lea    0x4(%eax),%edx
  80050a:	89 55 14             	mov    %edx,0x14(%ebp)
  80050d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80050f:	85 f6                	test   %esi,%esi
  800511:	b8 44 2c 80 00       	mov    $0x802c44,%eax
  800516:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800519:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80051d:	0f 84 97 00 00 00    	je     8005ba <vprintfmt+0x22c>
  800523:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800527:	0f 8e 9b 00 00 00    	jle    8005c8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800531:	89 34 24             	mov    %esi,(%esp)
  800534:	e8 cf 02 00 00       	call   800808 <strnlen>
  800539:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80053c:	29 c2                	sub    %eax,%edx
  80053e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800541:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800545:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800548:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80054b:	8b 75 08             	mov    0x8(%ebp),%esi
  80054e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800551:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800553:	eb 0f                	jmp    800564 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800555:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800559:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055c:	89 04 24             	mov    %eax,(%esp)
  80055f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800561:	83 eb 01             	sub    $0x1,%ebx
  800564:	85 db                	test   %ebx,%ebx
  800566:	7f ed                	jg     800555 <vprintfmt+0x1c7>
  800568:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80056b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80056e:	85 d2                	test   %edx,%edx
  800570:	b8 00 00 00 00       	mov    $0x0,%eax
  800575:	0f 49 c2             	cmovns %edx,%eax
  800578:	29 c2                	sub    %eax,%edx
  80057a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80057d:	89 d7                	mov    %edx,%edi
  80057f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800582:	eb 50                	jmp    8005d4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800584:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800588:	74 1e                	je     8005a8 <vprintfmt+0x21a>
  80058a:	0f be d2             	movsbl %dl,%edx
  80058d:	83 ea 20             	sub    $0x20,%edx
  800590:	83 fa 5e             	cmp    $0x5e,%edx
  800593:	76 13                	jbe    8005a8 <vprintfmt+0x21a>
					putch('?', putdat);
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005a3:	ff 55 08             	call   *0x8(%ebp)
  8005a6:	eb 0d                	jmp    8005b5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005af:	89 04 24             	mov    %eax,(%esp)
  8005b2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b5:	83 ef 01             	sub    $0x1,%edi
  8005b8:	eb 1a                	jmp    8005d4 <vprintfmt+0x246>
  8005ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005c0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c6:	eb 0c                	jmp    8005d4 <vprintfmt+0x246>
  8005c8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005d1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005d4:	83 c6 01             	add    $0x1,%esi
  8005d7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005db:	0f be c2             	movsbl %dl,%eax
  8005de:	85 c0                	test   %eax,%eax
  8005e0:	74 27                	je     800609 <vprintfmt+0x27b>
  8005e2:	85 db                	test   %ebx,%ebx
  8005e4:	78 9e                	js     800584 <vprintfmt+0x1f6>
  8005e6:	83 eb 01             	sub    $0x1,%ebx
  8005e9:	79 99                	jns    800584 <vprintfmt+0x1f6>
  8005eb:	89 f8                	mov    %edi,%eax
  8005ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f3:	89 c3                	mov    %eax,%ebx
  8005f5:	eb 1a                	jmp    800611 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800602:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800604:	83 eb 01             	sub    $0x1,%ebx
  800607:	eb 08                	jmp    800611 <vprintfmt+0x283>
  800609:	89 fb                	mov    %edi,%ebx
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800611:	85 db                	test   %ebx,%ebx
  800613:	7f e2                	jg     8005f7 <vprintfmt+0x269>
  800615:	89 75 08             	mov    %esi,0x8(%ebp)
  800618:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061b:	e9 93 fd ff ff       	jmp    8003b3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800620:	83 fa 01             	cmp    $0x1,%edx
  800623:	7e 16                	jle    80063b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 50 08             	lea    0x8(%eax),%edx
  80062b:	89 55 14             	mov    %edx,0x14(%ebp)
  80062e:	8b 50 04             	mov    0x4(%eax),%edx
  800631:	8b 00                	mov    (%eax),%eax
  800633:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800636:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800639:	eb 32                	jmp    80066d <vprintfmt+0x2df>
	else if (lflag)
  80063b:	85 d2                	test   %edx,%edx
  80063d:	74 18                	je     800657 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 50 04             	lea    0x4(%eax),%edx
  800645:	89 55 14             	mov    %edx,0x14(%ebp)
  800648:	8b 30                	mov    (%eax),%esi
  80064a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80064d:	89 f0                	mov    %esi,%eax
  80064f:	c1 f8 1f             	sar    $0x1f,%eax
  800652:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800655:	eb 16                	jmp    80066d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 50 04             	lea    0x4(%eax),%edx
  80065d:	89 55 14             	mov    %edx,0x14(%ebp)
  800660:	8b 30                	mov    (%eax),%esi
  800662:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800665:	89 f0                	mov    %esi,%eax
  800667:	c1 f8 1f             	sar    $0x1f,%eax
  80066a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80066d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800670:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800673:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067c:	0f 89 80 00 00 00    	jns    800702 <vprintfmt+0x374>
				putch('-', putdat);
  800682:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800686:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80068d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800696:	f7 d8                	neg    %eax
  800698:	83 d2 00             	adc    $0x0,%edx
  80069b:	f7 da                	neg    %edx
			}
			base = 10;
  80069d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006a2:	eb 5e                	jmp    800702 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a7:	e8 63 fc ff ff       	call   80030f <getuint>
			base = 10;
  8006ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006b1:	eb 4f                	jmp    800702 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b6:	e8 54 fc ff ff       	call   80030f <getuint>
			base = 8;
  8006bb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006c0:	eb 40                	jmp    800702 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8006c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006db:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ee:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006f3:	eb 0d                	jmp    800702 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f8:	e8 12 fc ff ff       	call   80030f <getuint>
			base = 16;
  8006fd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800702:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800706:	89 74 24 10          	mov    %esi,0x10(%esp)
  80070a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80070d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800711:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800715:	89 04 24             	mov    %eax,(%esp)
  800718:	89 54 24 04          	mov    %edx,0x4(%esp)
  80071c:	89 fa                	mov    %edi,%edx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	e8 fa fa ff ff       	call   800220 <printnum>
			break;
  800726:	e9 88 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	ff 55 08             	call   *0x8(%ebp)
			break;
  800735:	e9 79 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80073a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800745:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800748:	89 f3                	mov    %esi,%ebx
  80074a:	eb 03                	jmp    80074f <vprintfmt+0x3c1>
  80074c:	83 eb 01             	sub    $0x1,%ebx
  80074f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800753:	75 f7                	jne    80074c <vprintfmt+0x3be>
  800755:	e9 59 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80075a:	83 c4 3c             	add    $0x3c,%esp
  80075d:	5b                   	pop    %ebx
  80075e:	5e                   	pop    %esi
  80075f:	5f                   	pop    %edi
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 28             	sub    $0x28,%esp
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800771:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800775:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077f:	85 c0                	test   %eax,%eax
  800781:	74 30                	je     8007b3 <vsnprintf+0x51>
  800783:	85 d2                	test   %edx,%edx
  800785:	7e 2c                	jle    8007b3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80078e:	8b 45 10             	mov    0x10(%ebp),%eax
  800791:	89 44 24 08          	mov    %eax,0x8(%esp)
  800795:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079c:	c7 04 24 49 03 80 00 	movl   $0x800349,(%esp)
  8007a3:	e8 e6 fb ff ff       	call   80038e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b1:	eb 05                	jmp    8007b8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 04 24             	mov    %eax,(%esp)
  8007db:	e8 82 ff ff ff       	call   800762 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    
  8007e2:	66 90                	xchg   %ax,%ax
  8007e4:	66 90                	xchg   %ax,%ax
  8007e6:	66 90                	xchg   %ax,%ax
  8007e8:	66 90                	xchg   %ax,%ax
  8007ea:	66 90                	xchg   %ax,%ax
  8007ec:	66 90                	xchg   %ax,%ax
  8007ee:	66 90                	xchg   %ax,%ax

008007f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fb:	eb 03                	jmp    800800 <strlen+0x10>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800800:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800804:	75 f7                	jne    8007fd <strlen+0xd>
		n++;
	return n;
}
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	eb 03                	jmp    80081b <strnlen+0x13>
		n++;
  800818:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081b:	39 d0                	cmp    %edx,%eax
  80081d:	74 06                	je     800825 <strnlen+0x1d>
  80081f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800823:	75 f3                	jne    800818 <strnlen+0x10>
		n++;
	return n;
}
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800831:	89 c2                	mov    %eax,%edx
  800833:	83 c2 01             	add    $0x1,%edx
  800836:	83 c1 01             	add    $0x1,%ecx
  800839:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80083d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800840:	84 db                	test   %bl,%bl
  800842:	75 ef                	jne    800833 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800844:	5b                   	pop    %ebx
  800845:	5d                   	pop    %ebp
  800846:	c3                   	ret    

00800847 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	53                   	push   %ebx
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800851:	89 1c 24             	mov    %ebx,(%esp)
  800854:	e8 97 ff ff ff       	call   8007f0 <strlen>
	strcpy(dst + len, src);
  800859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800860:	01 d8                	add    %ebx,%eax
  800862:	89 04 24             	mov    %eax,(%esp)
  800865:	e8 bd ff ff ff       	call   800827 <strcpy>
	return dst;
}
  80086a:	89 d8                	mov    %ebx,%eax
  80086c:	83 c4 08             	add    $0x8,%esp
  80086f:	5b                   	pop    %ebx
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	56                   	push   %esi
  800876:	53                   	push   %ebx
  800877:	8b 75 08             	mov    0x8(%ebp),%esi
  80087a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087d:	89 f3                	mov    %esi,%ebx
  80087f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800882:	89 f2                	mov    %esi,%edx
  800884:	eb 0f                	jmp    800895 <strncpy+0x23>
		*dst++ = *src;
  800886:	83 c2 01             	add    $0x1,%edx
  800889:	0f b6 01             	movzbl (%ecx),%eax
  80088c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80088f:	80 39 01             	cmpb   $0x1,(%ecx)
  800892:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800895:	39 da                	cmp    %ebx,%edx
  800897:	75 ed                	jne    800886 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800899:	89 f0                	mov    %esi,%eax
  80089b:	5b                   	pop    %ebx
  80089c:	5e                   	pop    %esi
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	56                   	push   %esi
  8008a3:	53                   	push   %ebx
  8008a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ad:	89 f0                	mov    %esi,%eax
  8008af:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b3:	85 c9                	test   %ecx,%ecx
  8008b5:	75 0b                	jne    8008c2 <strlcpy+0x23>
  8008b7:	eb 1d                	jmp    8008d6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	83 c2 01             	add    $0x1,%edx
  8008bf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008c2:	39 d8                	cmp    %ebx,%eax
  8008c4:	74 0b                	je     8008d1 <strlcpy+0x32>
  8008c6:	0f b6 0a             	movzbl (%edx),%ecx
  8008c9:	84 c9                	test   %cl,%cl
  8008cb:	75 ec                	jne    8008b9 <strlcpy+0x1a>
  8008cd:	89 c2                	mov    %eax,%edx
  8008cf:	eb 02                	jmp    8008d3 <strlcpy+0x34>
  8008d1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008d3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008d6:	29 f0                	sub    %esi,%eax
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5d                   	pop    %ebp
  8008db:	c3                   	ret    

008008dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e5:	eb 06                	jmp    8008ed <strcmp+0x11>
		p++, q++;
  8008e7:	83 c1 01             	add    $0x1,%ecx
  8008ea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008ed:	0f b6 01             	movzbl (%ecx),%eax
  8008f0:	84 c0                	test   %al,%al
  8008f2:	74 04                	je     8008f8 <strcmp+0x1c>
  8008f4:	3a 02                	cmp    (%edx),%al
  8008f6:	74 ef                	je     8008e7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f8:	0f b6 c0             	movzbl %al,%eax
  8008fb:	0f b6 12             	movzbl (%edx),%edx
  8008fe:	29 d0                	sub    %edx,%eax
}
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	53                   	push   %ebx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	89 c3                	mov    %eax,%ebx
  80090e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800911:	eb 06                	jmp    800919 <strncmp+0x17>
		n--, p++, q++;
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800919:	39 d8                	cmp    %ebx,%eax
  80091b:	74 15                	je     800932 <strncmp+0x30>
  80091d:	0f b6 08             	movzbl (%eax),%ecx
  800920:	84 c9                	test   %cl,%cl
  800922:	74 04                	je     800928 <strncmp+0x26>
  800924:	3a 0a                	cmp    (%edx),%cl
  800926:	74 eb                	je     800913 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800928:	0f b6 00             	movzbl (%eax),%eax
  80092b:	0f b6 12             	movzbl (%edx),%edx
  80092e:	29 d0                	sub    %edx,%eax
  800930:	eb 05                	jmp    800937 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800932:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800937:	5b                   	pop    %ebx
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800944:	eb 07                	jmp    80094d <strchr+0x13>
		if (*s == c)
  800946:	38 ca                	cmp    %cl,%dl
  800948:	74 0f                	je     800959 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80094a:	83 c0 01             	add    $0x1,%eax
  80094d:	0f b6 10             	movzbl (%eax),%edx
  800950:	84 d2                	test   %dl,%dl
  800952:	75 f2                	jne    800946 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800965:	eb 07                	jmp    80096e <strfind+0x13>
		if (*s == c)
  800967:	38 ca                	cmp    %cl,%dl
  800969:	74 0a                	je     800975 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	0f b6 10             	movzbl (%eax),%edx
  800971:	84 d2                	test   %dl,%dl
  800973:	75 f2                	jne    800967 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	57                   	push   %edi
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800980:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800983:	85 c9                	test   %ecx,%ecx
  800985:	74 36                	je     8009bd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800987:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80098d:	75 28                	jne    8009b7 <memset+0x40>
  80098f:	f6 c1 03             	test   $0x3,%cl
  800992:	75 23                	jne    8009b7 <memset+0x40>
		c &= 0xFF;
  800994:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800998:	89 d3                	mov    %edx,%ebx
  80099a:	c1 e3 08             	shl    $0x8,%ebx
  80099d:	89 d6                	mov    %edx,%esi
  80099f:	c1 e6 18             	shl    $0x18,%esi
  8009a2:	89 d0                	mov    %edx,%eax
  8009a4:	c1 e0 10             	shl    $0x10,%eax
  8009a7:	09 f0                	or     %esi,%eax
  8009a9:	09 c2                	or     %eax,%edx
  8009ab:	89 d0                	mov    %edx,%eax
  8009ad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009af:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009b2:	fc                   	cld    
  8009b3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b5:	eb 06                	jmp    8009bd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009bd:	89 f8                	mov    %edi,%eax
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	57                   	push   %edi
  8009c8:	56                   	push   %esi
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d2:	39 c6                	cmp    %eax,%esi
  8009d4:	73 35                	jae    800a0b <memmove+0x47>
  8009d6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d9:	39 d0                	cmp    %edx,%eax
  8009db:	73 2e                	jae    800a0b <memmove+0x47>
		s += n;
		d += n;
  8009dd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009e0:	89 d6                	mov    %edx,%esi
  8009e2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ea:	75 13                	jne    8009ff <memmove+0x3b>
  8009ec:	f6 c1 03             	test   $0x3,%cl
  8009ef:	75 0e                	jne    8009ff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f1:	83 ef 04             	sub    $0x4,%edi
  8009f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009fa:	fd                   	std    
  8009fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fd:	eb 09                	jmp    800a08 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ff:	83 ef 01             	sub    $0x1,%edi
  800a02:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a05:	fd                   	std    
  800a06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a08:	fc                   	cld    
  800a09:	eb 1d                	jmp    800a28 <memmove+0x64>
  800a0b:	89 f2                	mov    %esi,%edx
  800a0d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0f:	f6 c2 03             	test   $0x3,%dl
  800a12:	75 0f                	jne    800a23 <memmove+0x5f>
  800a14:	f6 c1 03             	test   $0x3,%cl
  800a17:	75 0a                	jne    800a23 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a19:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a1c:	89 c7                	mov    %eax,%edi
  800a1e:	fc                   	cld    
  800a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a21:	eb 05                	jmp    800a28 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a23:	89 c7                	mov    %eax,%edi
  800a25:	fc                   	cld    
  800a26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a28:	5e                   	pop    %esi
  800a29:	5f                   	pop    %edi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
  800a35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	89 04 24             	mov    %eax,(%esp)
  800a46:	e8 79 ff ff ff       	call   8009c4 <memmove>
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a58:	89 d6                	mov    %edx,%esi
  800a5a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5d:	eb 1a                	jmp    800a79 <memcmp+0x2c>
		if (*s1 != *s2)
  800a5f:	0f b6 02             	movzbl (%edx),%eax
  800a62:	0f b6 19             	movzbl (%ecx),%ebx
  800a65:	38 d8                	cmp    %bl,%al
  800a67:	74 0a                	je     800a73 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a69:	0f b6 c0             	movzbl %al,%eax
  800a6c:	0f b6 db             	movzbl %bl,%ebx
  800a6f:	29 d8                	sub    %ebx,%eax
  800a71:	eb 0f                	jmp    800a82 <memcmp+0x35>
		s1++, s2++;
  800a73:	83 c2 01             	add    $0x1,%edx
  800a76:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a79:	39 f2                	cmp    %esi,%edx
  800a7b:	75 e2                	jne    800a5f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a94:	eb 07                	jmp    800a9d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a96:	38 08                	cmp    %cl,(%eax)
  800a98:	74 07                	je     800aa1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	39 d0                	cmp    %edx,%eax
  800a9f:	72 f5                	jb     800a96 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	57                   	push   %edi
  800aa7:	56                   	push   %esi
  800aa8:	53                   	push   %ebx
  800aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aaf:	eb 03                	jmp    800ab4 <strtol+0x11>
		s++;
  800ab1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab4:	0f b6 0a             	movzbl (%edx),%ecx
  800ab7:	80 f9 09             	cmp    $0x9,%cl
  800aba:	74 f5                	je     800ab1 <strtol+0xe>
  800abc:	80 f9 20             	cmp    $0x20,%cl
  800abf:	74 f0                	je     800ab1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ac1:	80 f9 2b             	cmp    $0x2b,%cl
  800ac4:	75 0a                	jne    800ad0 <strtol+0x2d>
		s++;
  800ac6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ace:	eb 11                	jmp    800ae1 <strtol+0x3e>
  800ad0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ad5:	80 f9 2d             	cmp    $0x2d,%cl
  800ad8:	75 07                	jne    800ae1 <strtol+0x3e>
		s++, neg = 1;
  800ada:	8d 52 01             	lea    0x1(%edx),%edx
  800add:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ae6:	75 15                	jne    800afd <strtol+0x5a>
  800ae8:	80 3a 30             	cmpb   $0x30,(%edx)
  800aeb:	75 10                	jne    800afd <strtol+0x5a>
  800aed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800af1:	75 0a                	jne    800afd <strtol+0x5a>
		s += 2, base = 16;
  800af3:	83 c2 02             	add    $0x2,%edx
  800af6:	b8 10 00 00 00       	mov    $0x10,%eax
  800afb:	eb 10                	jmp    800b0d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800afd:	85 c0                	test   %eax,%eax
  800aff:	75 0c                	jne    800b0d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b01:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b03:	80 3a 30             	cmpb   $0x30,(%edx)
  800b06:	75 05                	jne    800b0d <strtol+0x6a>
		s++, base = 8;
  800b08:	83 c2 01             	add    $0x1,%edx
  800b0b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b12:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b15:	0f b6 0a             	movzbl (%edx),%ecx
  800b18:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b1b:	89 f0                	mov    %esi,%eax
  800b1d:	3c 09                	cmp    $0x9,%al
  800b1f:	77 08                	ja     800b29 <strtol+0x86>
			dig = *s - '0';
  800b21:	0f be c9             	movsbl %cl,%ecx
  800b24:	83 e9 30             	sub    $0x30,%ecx
  800b27:	eb 20                	jmp    800b49 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b29:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b2c:	89 f0                	mov    %esi,%eax
  800b2e:	3c 19                	cmp    $0x19,%al
  800b30:	77 08                	ja     800b3a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b32:	0f be c9             	movsbl %cl,%ecx
  800b35:	83 e9 57             	sub    $0x57,%ecx
  800b38:	eb 0f                	jmp    800b49 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b3a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	3c 19                	cmp    $0x19,%al
  800b41:	77 16                	ja     800b59 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b43:	0f be c9             	movsbl %cl,%ecx
  800b46:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b49:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b4c:	7d 0f                	jge    800b5d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b4e:	83 c2 01             	add    $0x1,%edx
  800b51:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b55:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b57:	eb bc                	jmp    800b15 <strtol+0x72>
  800b59:	89 d8                	mov    %ebx,%eax
  800b5b:	eb 02                	jmp    800b5f <strtol+0xbc>
  800b5d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b63:	74 05                	je     800b6a <strtol+0xc7>
		*endptr = (char *) s;
  800b65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b68:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b6a:	f7 d8                	neg    %eax
  800b6c:	85 ff                	test   %edi,%edi
  800b6e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b71:	5b                   	pop    %ebx
  800b72:	5e                   	pop    %esi
  800b73:	5f                   	pop    %edi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	57                   	push   %edi
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b84:	8b 55 08             	mov    0x8(%ebp),%edx
  800b87:	89 c3                	mov    %eax,%ebx
  800b89:	89 c7                	mov    %eax,%edi
  800b8b:	89 c6                	mov    %eax,%esi
  800b8d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <sys_cgetc>:

int
sys_cgetc(void)
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
  800b9f:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba4:	89 d1                	mov    %edx,%ecx
  800ba6:	89 d3                	mov    %edx,%ebx
  800ba8:	89 d7                	mov    %edx,%edi
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800bbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc9:	89 cb                	mov    %ecx,%ebx
  800bcb:	89 cf                	mov    %ecx,%edi
  800bcd:	89 ce                	mov    %ecx,%esi
  800bcf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bd1:	85 c0                	test   %eax,%eax
  800bd3:	7e 28                	jle    800bfd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bd9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800be0:	00 
  800be1:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800be8:	00 
  800be9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bf0:	00 
  800bf1:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800bf8:	e8 29 1c 00 00       	call   802826 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bfd:	83 c4 2c             	add    $0x2c,%esp
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	57                   	push   %edi
  800c09:	56                   	push   %esi
  800c0a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c10:	b8 02 00 00 00       	mov    $0x2,%eax
  800c15:	89 d1                	mov    %edx,%ecx
  800c17:	89 d3                	mov    %edx,%ebx
  800c19:	89 d7                	mov    %edx,%edi
  800c1b:	89 d6                	mov    %edx,%esi
  800c1d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <sys_yield>:

void
sys_yield(void)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c34:	89 d1                	mov    %edx,%ecx
  800c36:	89 d3                	mov    %edx,%ebx
  800c38:	89 d7                	mov    %edx,%edi
  800c3a:	89 d6                	mov    %edx,%esi
  800c3c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4c:	be 00 00 00 00       	mov    $0x0,%esi
  800c51:	b8 04 00 00 00       	mov    $0x4,%eax
  800c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5f:	89 f7                	mov    %esi,%edi
  800c61:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c63:	85 c0                	test   %eax,%eax
  800c65:	7e 28                	jle    800c8f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c67:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c6b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c72:	00 
  800c73:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800c7a:	00 
  800c7b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c82:	00 
  800c83:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800c8a:	e8 97 1b 00 00       	call   802826 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8f:	83 c4 2c             	add    $0x2c,%esp
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cb1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	7e 28                	jle    800ce2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cba:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cc5:	00 
  800cc6:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800ccd:	00 
  800cce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd5:	00 
  800cd6:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800cdd:	e8 44 1b 00 00       	call   802826 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce2:	83 c4 2c             	add    $0x2c,%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf8:	b8 06 00 00 00       	mov    $0x6,%eax
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	89 df                	mov    %ebx,%edi
  800d05:	89 de                	mov    %ebx,%esi
  800d07:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	7e 28                	jle    800d35 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d11:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d18:	00 
  800d19:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800d20:	00 
  800d21:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d28:	00 
  800d29:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800d30:	e8 f1 1a 00 00       	call   802826 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d35:	83 c4 2c             	add    $0x2c,%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	89 df                	mov    %ebx,%edi
  800d58:	89 de                	mov    %ebx,%esi
  800d5a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d5c:	85 c0                	test   %eax,%eax
  800d5e:	7e 28                	jle    800d88 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d64:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d6b:	00 
  800d6c:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800d73:	00 
  800d74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d7b:	00 
  800d7c:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800d83:	e8 9e 1a 00 00       	call   802826 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d88:	83 c4 2c             	add    $0x2c,%esp
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	89 de                	mov    %ebx,%esi
  800dad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7e 28                	jle    800ddb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dbe:	00 
  800dbf:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800dc6:	00 
  800dc7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dce:	00 
  800dcf:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800dd6:	e8 4b 1a 00 00       	call   802826 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ddb:	83 c4 2c             	add    $0x2c,%esp
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	89 df                	mov    %ebx,%edi
  800dfe:	89 de                	mov    %ebx,%esi
  800e00:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7e 28                	jle    800e2e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e11:	00 
  800e12:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800e19:	00 
  800e1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e21:	00 
  800e22:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800e29:	e8 f8 19 00 00       	call   802826 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e2e:	83 c4 2c             	add    $0x2c,%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	be 00 00 00 00       	mov    $0x0,%esi
  800e41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e52:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e67:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	89 cb                	mov    %ecx,%ebx
  800e71:	89 cf                	mov    %ecx,%edi
  800e73:	89 ce                	mov    %ecx,%esi
  800e75:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	7e 28                	jle    800ea3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e86:	00 
  800e87:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800e8e:	00 
  800e8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e96:	00 
  800e97:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800e9e:	e8 83 19 00 00       	call   802826 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea3:	83 c4 2c             	add    $0x2c,%esp
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5f                   	pop    %edi
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebb:	89 d1                	mov    %edx,%ecx
  800ebd:	89 d3                	mov    %edx,%ebx
  800ebf:	89 d7                	mov    %edx,%edi
  800ec1:	89 d6                	mov    %edx,%esi
  800ec3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    

00800eca <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
  800ed0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	89 df                	mov    %ebx,%edi
  800ee5:	89 de                	mov    %ebx,%esi
  800ee7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	7e 28                	jle    800f15 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eed:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ef8:	00 
  800ef9:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800f00:	00 
  800f01:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f08:	00 
  800f09:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800f10:	e8 11 19 00 00       	call   802826 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800f15:	83 c4 2c             	add    $0x2c,%esp
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
  800f23:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	89 df                	mov    %ebx,%edi
  800f38:	89 de                	mov    %ebx,%esi
  800f3a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	7e 28                	jle    800f68 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f40:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f44:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f4b:	00 
  800f4c:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800f53:	00 
  800f54:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f5b:	00 
  800f5c:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800f63:	e8 be 18 00 00       	call   802826 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800f68:	83 c4 2c             	add    $0x2c,%esp
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
  800f76:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7e:	b8 11 00 00 00       	mov    $0x11,%eax
  800f83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	89 df                	mov    %ebx,%edi
  800f8b:	89 de                	mov    %ebx,%esi
  800f8d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	7e 28                	jle    800fbb <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f93:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f97:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800f9e:	00 
  800f9f:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800fa6:	00 
  800fa7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fae:	00 
  800faf:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  800fb6:	e8 6b 18 00 00       	call   802826 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  800fbb:	83 c4 2c             	add    $0x2c,%esp
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <sys_sleep>:

int
sys_sleep(int channel)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd1:	b8 12 00 00 00       	mov    $0x12,%eax
  800fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd9:	89 cb                	mov    %ecx,%ebx
  800fdb:	89 cf                	mov    %ecx,%edi
  800fdd:	89 ce                	mov    %ecx,%esi
  800fdf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	7e 28                	jle    80100d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800ff0:	00 
  800ff1:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  800ff8:	00 
  800ff9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801000:	00 
  801001:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  801008:	e8 19 18 00 00       	call   802826 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80100d:	83 c4 2c             	add    $0x2c,%esp
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	57                   	push   %edi
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
  80101b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801023:	b8 13 00 00 00       	mov    $0x13,%eax
  801028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	89 df                	mov    %ebx,%edi
  801030:	89 de                	mov    %ebx,%esi
  801032:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801034:	85 c0                	test   %eax,%eax
  801036:	7e 28                	jle    801060 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801038:	89 44 24 10          	mov    %eax,0x10(%esp)
  80103c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801043:	00 
  801044:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  80104b:	00 
  80104c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801053:	00 
  801054:	c7 04 24 88 2f 80 00 	movl   $0x802f88,(%esp)
  80105b:	e8 c6 17 00 00       	call   802826 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801060:	83 c4 2c             	add    $0x2c,%esp
  801063:	5b                   	pop    %ebx
  801064:	5e                   	pop    %esi
  801065:	5f                   	pop    %edi
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	53                   	push   %ebx
  80106c:	83 ec 24             	sub    $0x24,%esp
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801072:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801074:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801078:	74 27                	je     8010a1 <pgfault+0x39>
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	c1 ea 16             	shr    $0x16,%edx
  80107f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801086:	f6 c2 01             	test   $0x1,%dl
  801089:	74 16                	je     8010a1 <pgfault+0x39>
  80108b:	89 c2                	mov    %eax,%edx
  80108d:	c1 ea 0c             	shr    $0xc,%edx
  801090:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801097:	f7 d2                	not    %edx
  801099:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80109f:	74 1c                	je     8010bd <pgfault+0x55>
		panic("pgfault");
  8010a1:	c7 44 24 08 96 2f 80 	movl   $0x802f96,0x8(%esp)
  8010a8:	00 
  8010a9:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8010b0:	00 
  8010b1:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  8010b8:	e8 69 17 00 00       	call   802826 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  8010bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c2:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  8010c4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010d3:	00 
  8010d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010db:	e8 63 fb ff ff       	call   800c43 <sys_page_alloc>
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	79 1c                	jns    801100 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  8010e4:	c7 44 24 08 a9 2f 80 	movl   $0x802fa9,0x8(%esp)
  8010eb:	00 
  8010ec:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8010f3:	00 
  8010f4:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  8010fb:	e8 26 17 00 00       	call   802826 <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801100:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801107:	00 
  801108:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80110c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801113:	e8 14 f9 ff ff       	call   800a2c <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801118:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80111f:	00 
  801120:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801124:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80112b:	00 
  80112c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801133:	00 
  801134:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80113b:	e8 57 fb ff ff       	call   800c97 <sys_page_map>
  801140:	85 c0                	test   %eax,%eax
  801142:	79 1c                	jns    801160 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  801144:	c7 44 24 08 c3 2f 80 	movl   $0x802fc3,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  80115b:	e8 c6 16 00 00       	call   802826 <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801160:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801167:	00 
  801168:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80116f:	e8 76 fb ff ff       	call   800cea <sys_page_unmap>
  801174:	85 c0                	test   %eax,%eax
  801176:	79 1c                	jns    801194 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801178:	c7 44 24 08 db 2f 80 	movl   $0x802fdb,0x8(%esp)
  80117f:	00 
  801180:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801187:	00 
  801188:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  80118f:	e8 92 16 00 00       	call   802826 <_panic>
	}
}
  801194:	83 c4 24             	add    $0x24,%esp
  801197:	5b                   	pop    %ebx
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	53                   	push   %ebx
  8011a0:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  8011a3:	c7 04 24 68 10 80 00 	movl   $0x801068,(%esp)
  8011aa:	e8 cd 16 00 00       	call   80287c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011af:	b8 07 00 00 00       	mov    $0x7,%eax
  8011b4:	cd 30                	int    $0x30
  8011b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	79 1c                	jns    8011d9 <fork+0x3f>
		panic("fork(): sys_exofork");
  8011bd:	c7 44 24 08 f5 2f 80 	movl   $0x802ff5,0x8(%esp)
  8011c4:	00 
  8011c5:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8011cc:	00 
  8011cd:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  8011d4:	e8 4d 16 00 00       	call   802826 <_panic>
  8011d9:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  8011db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011df:	74 0a                	je     8011eb <fork+0x51>
  8011e1:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8011e6:	e9 9d 01 00 00       	jmp    801388 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  8011eb:	e8 15 fa ff ff       	call   800c05 <sys_getenvid>
  8011f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011f5:	89 c2                	mov    %eax,%edx
  8011f7:	c1 e2 07             	shl    $0x7,%edx
  8011fa:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801201:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  801206:	e9 2a 02 00 00       	jmp    801435 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80120b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801211:	0f 84 6b 01 00 00    	je     801382 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801217:	89 d8                	mov    %ebx,%eax
  801219:	c1 e8 16             	shr    $0x16,%eax
  80121c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801223:	a8 01                	test   $0x1,%al
  801225:	0f 84 57 01 00 00    	je     801382 <fork+0x1e8>
  80122b:	89 d8                	mov    %ebx,%eax
  80122d:	c1 e8 0c             	shr    $0xc,%eax
  801230:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801237:	f7 d0                	not    %eax
  801239:	a8 05                	test   $0x5,%al
  80123b:	0f 85 41 01 00 00    	jne    801382 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  801241:	89 d8                	mov    %ebx,%eax
  801243:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  801246:	89 c6                	mov    %eax,%esi
  801248:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  80124b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801252:	f6 c6 04             	test   $0x4,%dh
  801255:	74 4c                	je     8012a3 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  801257:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80125e:	25 07 0e 00 00       	and    $0xe07,%eax
  801263:	89 44 24 10          	mov    %eax,0x10(%esp)
  801267:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80126b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80126f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801273:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127a:	e8 18 fa ff ff       	call   800c97 <sys_page_map>
  80127f:	85 c0                	test   %eax,%eax
  801281:	0f 89 fb 00 00 00    	jns    801382 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801287:	c7 44 24 08 09 30 80 	movl   $0x803009,0x8(%esp)
  80128e:	00 
  80128f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801296:	00 
  801297:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  80129e:	e8 83 15 00 00       	call   802826 <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  8012a3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012aa:	f6 c6 08             	test   $0x8,%dh
  8012ad:	75 0f                	jne    8012be <fork+0x124>
  8012af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b6:	a8 02                	test   $0x2,%al
  8012b8:	0f 84 84 00 00 00    	je     801342 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  8012be:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012c5:	00 
  8012c6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012ca:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d9:	e8 b9 f9 ff ff       	call   800c97 <sys_page_map>
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	79 1c                	jns    8012fe <fork+0x164>
			panic("duppage: sys_page_map");
  8012e2:	c7 44 24 08 09 30 80 	movl   $0x803009,0x8(%esp)
  8012e9:	00 
  8012ea:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8012f1:	00 
  8012f2:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  8012f9:	e8 28 15 00 00       	call   802826 <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  8012fe:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801305:	00 
  801306:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80130a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801311:	00 
  801312:	89 74 24 04          	mov    %esi,0x4(%esp)
  801316:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80131d:	e8 75 f9 ff ff       	call   800c97 <sys_page_map>
  801322:	85 c0                	test   %eax,%eax
  801324:	79 5c                	jns    801382 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801326:	c7 44 24 08 09 30 80 	movl   $0x803009,0x8(%esp)
  80132d:	00 
  80132e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  801335:	00 
  801336:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  80133d:	e8 e4 14 00 00       	call   802826 <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  801342:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801349:	00 
  80134a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80134e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801352:	89 74 24 04          	mov    %esi,0x4(%esp)
  801356:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80135d:	e8 35 f9 ff ff       	call   800c97 <sys_page_map>
  801362:	85 c0                	test   %eax,%eax
  801364:	79 1c                	jns    801382 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801366:	c7 44 24 08 09 30 80 	movl   $0x803009,0x8(%esp)
  80136d:	00 
  80136e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801375:	00 
  801376:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  80137d:	e8 a4 14 00 00       	call   802826 <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801382:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801388:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80138e:	0f 85 77 fe ff ff    	jne    80120b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801394:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80139b:	00 
  80139c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013a3:	ee 
  8013a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a7:	89 04 24             	mov    %eax,(%esp)
  8013aa:	e8 94 f8 ff ff       	call   800c43 <sys_page_alloc>
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	79 1c                	jns    8013cf <fork+0x235>
		panic("fork(): sys_page_alloc");
  8013b3:	c7 44 24 08 1f 30 80 	movl   $0x80301f,0x8(%esp)
  8013ba:	00 
  8013bb:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8013c2:	00 
  8013c3:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  8013ca:	e8 57 14 00 00       	call   802826 <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  8013cf:	c7 44 24 04 05 29 80 	movl   $0x802905,0x4(%esp)
  8013d6:	00 
  8013d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013da:	89 04 24             	mov    %eax,(%esp)
  8013dd:	e8 01 fa ff ff       	call   800de3 <sys_env_set_pgfault_upcall>
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	79 1c                	jns    801402 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  8013e6:	c7 44 24 08 68 30 80 	movl   $0x803068,0x8(%esp)
  8013ed:	00 
  8013ee:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  8013f5:	00 
  8013f6:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  8013fd:	e8 24 14 00 00       	call   802826 <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801402:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801409:	00 
  80140a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80140d:	89 04 24             	mov    %eax,(%esp)
  801410:	e8 28 f9 ff ff       	call   800d3d <sys_env_set_status>
  801415:	85 c0                	test   %eax,%eax
  801417:	79 1c                	jns    801435 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801419:	c7 44 24 08 36 30 80 	movl   $0x803036,0x8(%esp)
  801420:	00 
  801421:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801428:	00 
  801429:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  801430:	e8 f1 13 00 00       	call   802826 <_panic>
	}

	return env_id;
}
  801435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801438:	83 c4 2c             	add    $0x2c,%esp
  80143b:	5b                   	pop    %ebx
  80143c:	5e                   	pop    %esi
  80143d:	5f                   	pop    %edi
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    

00801440 <sfork>:

// Challenge!
int
sfork(void)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801446:	c7 44 24 08 51 30 80 	movl   $0x803051,0x8(%esp)
  80144d:	00 
  80144e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  801455:	00 
  801456:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  80145d:	e8 c4 13 00 00       	call   802826 <_panic>
  801462:	66 90                	xchg   %ax,%ax
  801464:	66 90                	xchg   %ax,%ax
  801466:	66 90                	xchg   %ax,%ax
  801468:	66 90                	xchg   %ax,%ax
  80146a:	66 90                	xchg   %ax,%ax
  80146c:	66 90                	xchg   %ax,%ax
  80146e:	66 90                	xchg   %ax,%ax

00801470 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	56                   	push   %esi
  801474:	53                   	push   %ebx
  801475:	83 ec 10             	sub    $0x10,%esp
  801478:	8b 75 08             	mov    0x8(%ebp),%esi
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801481:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  801483:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801488:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80148b:	89 04 24             	mov    %eax,(%esp)
  80148e:	e8 c6 f9 ff ff       	call   800e59 <sys_ipc_recv>
  801493:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  801495:	85 d2                	test   %edx,%edx
  801497:	75 24                	jne    8014bd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  801499:	85 f6                	test   %esi,%esi
  80149b:	74 0a                	je     8014a7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80149d:	a1 08 50 80 00       	mov    0x805008,%eax
  8014a2:	8b 40 74             	mov    0x74(%eax),%eax
  8014a5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8014a7:	85 db                	test   %ebx,%ebx
  8014a9:	74 0a                	je     8014b5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8014ab:	a1 08 50 80 00       	mov    0x805008,%eax
  8014b0:	8b 40 78             	mov    0x78(%eax),%eax
  8014b3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8014b5:	a1 08 50 80 00       	mov    0x805008,%eax
  8014ba:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	5b                   	pop    %ebx
  8014c1:	5e                   	pop    %esi
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	57                   	push   %edi
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
  8014ca:	83 ec 1c             	sub    $0x1c,%esp
  8014cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8014d6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8014d8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8014dd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8014e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014ef:	89 3c 24             	mov    %edi,(%esp)
  8014f2:	e8 3f f9 ff ff       	call   800e36 <sys_ipc_try_send>

		if (ret == 0)
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	74 2c                	je     801527 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8014fb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014fe:	74 20                	je     801520 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  801500:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801504:	c7 44 24 08 8c 30 80 	movl   $0x80308c,0x8(%esp)
  80150b:	00 
  80150c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801513:	00 
  801514:	c7 04 24 ba 30 80 00 	movl   $0x8030ba,(%esp)
  80151b:	e8 06 13 00 00       	call   802826 <_panic>
		}

		sys_yield();
  801520:	e8 ff f6 ff ff       	call   800c24 <sys_yield>
	}
  801525:	eb b9                	jmp    8014e0 <ipc_send+0x1c>
}
  801527:	83 c4 1c             	add    $0x1c,%esp
  80152a:	5b                   	pop    %ebx
  80152b:	5e                   	pop    %esi
  80152c:	5f                   	pop    %edi
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	c1 e2 07             	shl    $0x7,%edx
  80153f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  801546:	8b 52 50             	mov    0x50(%edx),%edx
  801549:	39 ca                	cmp    %ecx,%edx
  80154b:	75 11                	jne    80155e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80154d:	89 c2                	mov    %eax,%edx
  80154f:	c1 e2 07             	shl    $0x7,%edx
  801552:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  801559:	8b 40 40             	mov    0x40(%eax),%eax
  80155c:	eb 0e                	jmp    80156c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80155e:	83 c0 01             	add    $0x1,%eax
  801561:	3d 00 04 00 00       	cmp    $0x400,%eax
  801566:	75 d2                	jne    80153a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801568:	66 b8 00 00          	mov    $0x0,%ax
}
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    
  80156e:	66 90                	xchg   %ax,%ax

00801570 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	05 00 00 00 30       	add    $0x30000000,%eax
  80157b:	c1 e8 0c             	shr    $0xc,%eax
}
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80158b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801590:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801595:	5d                   	pop    %ebp
  801596:	c3                   	ret    

00801597 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015a2:	89 c2                	mov    %eax,%edx
  8015a4:	c1 ea 16             	shr    $0x16,%edx
  8015a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015ae:	f6 c2 01             	test   $0x1,%dl
  8015b1:	74 11                	je     8015c4 <fd_alloc+0x2d>
  8015b3:	89 c2                	mov    %eax,%edx
  8015b5:	c1 ea 0c             	shr    $0xc,%edx
  8015b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015bf:	f6 c2 01             	test   $0x1,%dl
  8015c2:	75 09                	jne    8015cd <fd_alloc+0x36>
			*fd_store = fd;
  8015c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cb:	eb 17                	jmp    8015e4 <fd_alloc+0x4d>
  8015cd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015d2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015d7:	75 c9                	jne    8015a2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015d9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015df:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015e4:	5d                   	pop    %ebp
  8015e5:	c3                   	ret    

008015e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015ec:	83 f8 1f             	cmp    $0x1f,%eax
  8015ef:	77 36                	ja     801627 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015f1:	c1 e0 0c             	shl    $0xc,%eax
  8015f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015f9:	89 c2                	mov    %eax,%edx
  8015fb:	c1 ea 16             	shr    $0x16,%edx
  8015fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801605:	f6 c2 01             	test   $0x1,%dl
  801608:	74 24                	je     80162e <fd_lookup+0x48>
  80160a:	89 c2                	mov    %eax,%edx
  80160c:	c1 ea 0c             	shr    $0xc,%edx
  80160f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801616:	f6 c2 01             	test   $0x1,%dl
  801619:	74 1a                	je     801635 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80161b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161e:	89 02                	mov    %eax,(%edx)
	return 0;
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	eb 13                	jmp    80163a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801627:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162c:	eb 0c                	jmp    80163a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80162e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801633:	eb 05                	jmp    80163a <fd_lookup+0x54>
  801635:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 18             	sub    $0x18,%esp
  801642:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801645:	ba 00 00 00 00       	mov    $0x0,%edx
  80164a:	eb 13                	jmp    80165f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80164c:	39 08                	cmp    %ecx,(%eax)
  80164e:	75 0c                	jne    80165c <dev_lookup+0x20>
			*dev = devtab[i];
  801650:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801653:	89 01                	mov    %eax,(%ecx)
			return 0;
  801655:	b8 00 00 00 00       	mov    $0x0,%eax
  80165a:	eb 38                	jmp    801694 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80165c:	83 c2 01             	add    $0x1,%edx
  80165f:	8b 04 95 40 31 80 00 	mov    0x803140(,%edx,4),%eax
  801666:	85 c0                	test   %eax,%eax
  801668:	75 e2                	jne    80164c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80166a:	a1 08 50 80 00       	mov    0x805008,%eax
  80166f:	8b 40 48             	mov    0x48(%eax),%eax
  801672:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801676:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167a:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  801681:	e8 7d eb ff ff       	call   800203 <cprintf>
	*dev = 0;
  801686:	8b 45 0c             	mov    0xc(%ebp),%eax
  801689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80168f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	56                   	push   %esi
  80169a:	53                   	push   %ebx
  80169b:	83 ec 20             	sub    $0x20,%esp
  80169e:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016b1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016b4:	89 04 24             	mov    %eax,(%esp)
  8016b7:	e8 2a ff ff ff       	call   8015e6 <fd_lookup>
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 05                	js     8016c5 <fd_close+0x2f>
	    || fd != fd2)
  8016c0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016c3:	74 0c                	je     8016d1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016c5:	84 db                	test   %bl,%bl
  8016c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cc:	0f 44 c2             	cmove  %edx,%eax
  8016cf:	eb 3f                	jmp    801710 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d8:	8b 06                	mov    (%esi),%eax
  8016da:	89 04 24             	mov    %eax,(%esp)
  8016dd:	e8 5a ff ff ff       	call   80163c <dev_lookup>
  8016e2:	89 c3                	mov    %eax,%ebx
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 16                	js     8016fe <fd_close+0x68>
		if (dev->dev_close)
  8016e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	74 07                	je     8016fe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8016f7:	89 34 24             	mov    %esi,(%esp)
  8016fa:	ff d0                	call   *%eax
  8016fc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801702:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801709:	e8 dc f5 ff ff       	call   800cea <sys_page_unmap>
	return r;
  80170e:	89 d8                	mov    %ebx,%eax
}
  801710:	83 c4 20             	add    $0x20,%esp
  801713:	5b                   	pop    %ebx
  801714:	5e                   	pop    %esi
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801720:	89 44 24 04          	mov    %eax,0x4(%esp)
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	89 04 24             	mov    %eax,(%esp)
  80172a:	e8 b7 fe ff ff       	call   8015e6 <fd_lookup>
  80172f:	89 c2                	mov    %eax,%edx
  801731:	85 d2                	test   %edx,%edx
  801733:	78 13                	js     801748 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801735:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80173c:	00 
  80173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801740:	89 04 24             	mov    %eax,(%esp)
  801743:	e8 4e ff ff ff       	call   801696 <fd_close>
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <close_all>:

void
close_all(void)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	53                   	push   %ebx
  80174e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801751:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801756:	89 1c 24             	mov    %ebx,(%esp)
  801759:	e8 b9 ff ff ff       	call   801717 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80175e:	83 c3 01             	add    $0x1,%ebx
  801761:	83 fb 20             	cmp    $0x20,%ebx
  801764:	75 f0                	jne    801756 <close_all+0xc>
		close(i);
}
  801766:	83 c4 14             	add    $0x14,%esp
  801769:	5b                   	pop    %ebx
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	57                   	push   %edi
  801770:	56                   	push   %esi
  801771:	53                   	push   %ebx
  801772:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801775:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801778:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 04 24             	mov    %eax,(%esp)
  801782:	e8 5f fe ff ff       	call   8015e6 <fd_lookup>
  801787:	89 c2                	mov    %eax,%edx
  801789:	85 d2                	test   %edx,%edx
  80178b:	0f 88 e1 00 00 00    	js     801872 <dup+0x106>
		return r;
	close(newfdnum);
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	89 04 24             	mov    %eax,(%esp)
  801797:	e8 7b ff ff ff       	call   801717 <close>

	newfd = INDEX2FD(newfdnum);
  80179c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80179f:	c1 e3 0c             	shl    $0xc,%ebx
  8017a2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ab:	89 04 24             	mov    %eax,(%esp)
  8017ae:	e8 cd fd ff ff       	call   801580 <fd2data>
  8017b3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017b5:	89 1c 24             	mov    %ebx,(%esp)
  8017b8:	e8 c3 fd ff ff       	call   801580 <fd2data>
  8017bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017bf:	89 f0                	mov    %esi,%eax
  8017c1:	c1 e8 16             	shr    $0x16,%eax
  8017c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017cb:	a8 01                	test   $0x1,%al
  8017cd:	74 43                	je     801812 <dup+0xa6>
  8017cf:	89 f0                	mov    %esi,%eax
  8017d1:	c1 e8 0c             	shr    $0xc,%eax
  8017d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017db:	f6 c2 01             	test   $0x1,%dl
  8017de:	74 32                	je     801812 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017fb:	00 
  8017fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801800:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801807:	e8 8b f4 ff ff       	call   800c97 <sys_page_map>
  80180c:	89 c6                	mov    %eax,%esi
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 3e                	js     801850 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801815:	89 c2                	mov    %eax,%edx
  801817:	c1 ea 0c             	shr    $0xc,%edx
  80181a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801821:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801827:	89 54 24 10          	mov    %edx,0x10(%esp)
  80182b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80182f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801836:	00 
  801837:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801842:	e8 50 f4 ff ff       	call   800c97 <sys_page_map>
  801847:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80184c:	85 f6                	test   %esi,%esi
  80184e:	79 22                	jns    801872 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801850:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801854:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80185b:	e8 8a f4 ff ff       	call   800cea <sys_page_unmap>
	sys_page_unmap(0, nva);
  801860:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801864:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80186b:	e8 7a f4 ff ff       	call   800cea <sys_page_unmap>
	return r;
  801870:	89 f0                	mov    %esi,%eax
}
  801872:	83 c4 3c             	add    $0x3c,%esp
  801875:	5b                   	pop    %ebx
  801876:	5e                   	pop    %esi
  801877:	5f                   	pop    %edi
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    

0080187a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	53                   	push   %ebx
  80187e:	83 ec 24             	sub    $0x24,%esp
  801881:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801884:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801887:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188b:	89 1c 24             	mov    %ebx,(%esp)
  80188e:	e8 53 fd ff ff       	call   8015e6 <fd_lookup>
  801893:	89 c2                	mov    %eax,%edx
  801895:	85 d2                	test   %edx,%edx
  801897:	78 6d                	js     801906 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801899:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a3:	8b 00                	mov    (%eax),%eax
  8018a5:	89 04 24             	mov    %eax,(%esp)
  8018a8:	e8 8f fd ff ff       	call   80163c <dev_lookup>
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	78 55                	js     801906 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b4:	8b 50 08             	mov    0x8(%eax),%edx
  8018b7:	83 e2 03             	and    $0x3,%edx
  8018ba:	83 fa 01             	cmp    $0x1,%edx
  8018bd:	75 23                	jne    8018e2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8018c4:	8b 40 48             	mov    0x48(%eax),%eax
  8018c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cf:	c7 04 24 05 31 80 00 	movl   $0x803105,(%esp)
  8018d6:	e8 28 e9 ff ff       	call   800203 <cprintf>
		return -E_INVAL;
  8018db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e0:	eb 24                	jmp    801906 <read+0x8c>
	}
	if (!dev->dev_read)
  8018e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e5:	8b 52 08             	mov    0x8(%edx),%edx
  8018e8:	85 d2                	test   %edx,%edx
  8018ea:	74 15                	je     801901 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018fa:	89 04 24             	mov    %eax,(%esp)
  8018fd:	ff d2                	call   *%edx
  8018ff:	eb 05                	jmp    801906 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801901:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801906:	83 c4 24             	add    $0x24,%esp
  801909:	5b                   	pop    %ebx
  80190a:	5d                   	pop    %ebp
  80190b:	c3                   	ret    

0080190c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	57                   	push   %edi
  801910:	56                   	push   %esi
  801911:	53                   	push   %ebx
  801912:	83 ec 1c             	sub    $0x1c,%esp
  801915:	8b 7d 08             	mov    0x8(%ebp),%edi
  801918:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80191b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801920:	eb 23                	jmp    801945 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801922:	89 f0                	mov    %esi,%eax
  801924:	29 d8                	sub    %ebx,%eax
  801926:	89 44 24 08          	mov    %eax,0x8(%esp)
  80192a:	89 d8                	mov    %ebx,%eax
  80192c:	03 45 0c             	add    0xc(%ebp),%eax
  80192f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801933:	89 3c 24             	mov    %edi,(%esp)
  801936:	e8 3f ff ff ff       	call   80187a <read>
		if (m < 0)
  80193b:	85 c0                	test   %eax,%eax
  80193d:	78 10                	js     80194f <readn+0x43>
			return m;
		if (m == 0)
  80193f:	85 c0                	test   %eax,%eax
  801941:	74 0a                	je     80194d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801943:	01 c3                	add    %eax,%ebx
  801945:	39 f3                	cmp    %esi,%ebx
  801947:	72 d9                	jb     801922 <readn+0x16>
  801949:	89 d8                	mov    %ebx,%eax
  80194b:	eb 02                	jmp    80194f <readn+0x43>
  80194d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80194f:	83 c4 1c             	add    $0x1c,%esp
  801952:	5b                   	pop    %ebx
  801953:	5e                   	pop    %esi
  801954:	5f                   	pop    %edi
  801955:	5d                   	pop    %ebp
  801956:	c3                   	ret    

00801957 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	53                   	push   %ebx
  80195b:	83 ec 24             	sub    $0x24,%esp
  80195e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801961:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801964:	89 44 24 04          	mov    %eax,0x4(%esp)
  801968:	89 1c 24             	mov    %ebx,(%esp)
  80196b:	e8 76 fc ff ff       	call   8015e6 <fd_lookup>
  801970:	89 c2                	mov    %eax,%edx
  801972:	85 d2                	test   %edx,%edx
  801974:	78 68                	js     8019de <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801976:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801979:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	89 04 24             	mov    %eax,(%esp)
  801985:	e8 b2 fc ff ff       	call   80163c <dev_lookup>
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 50                	js     8019de <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801991:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801995:	75 23                	jne    8019ba <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801997:	a1 08 50 80 00       	mov    0x805008,%eax
  80199c:	8b 40 48             	mov    0x48(%eax),%eax
  80199f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a7:	c7 04 24 21 31 80 00 	movl   $0x803121,(%esp)
  8019ae:	e8 50 e8 ff ff       	call   800203 <cprintf>
		return -E_INVAL;
  8019b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019b8:	eb 24                	jmp    8019de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8019c0:	85 d2                	test   %edx,%edx
  8019c2:	74 15                	je     8019d9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019d2:	89 04 24             	mov    %eax,(%esp)
  8019d5:	ff d2                	call   *%edx
  8019d7:	eb 05                	jmp    8019de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019de:	83 c4 24             	add    $0x24,%esp
  8019e1:	5b                   	pop    %ebx
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	89 04 24             	mov    %eax,(%esp)
  8019f7:	e8 ea fb ff ff       	call   8015e6 <fd_lookup>
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 0e                	js     801a0e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	53                   	push   %ebx
  801a14:	83 ec 24             	sub    $0x24,%esp
  801a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a21:	89 1c 24             	mov    %ebx,(%esp)
  801a24:	e8 bd fb ff ff       	call   8015e6 <fd_lookup>
  801a29:	89 c2                	mov    %eax,%edx
  801a2b:	85 d2                	test   %edx,%edx
  801a2d:	78 61                	js     801a90 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a39:	8b 00                	mov    (%eax),%eax
  801a3b:	89 04 24             	mov    %eax,(%esp)
  801a3e:	e8 f9 fb ff ff       	call   80163c <dev_lookup>
  801a43:	85 c0                	test   %eax,%eax
  801a45:	78 49                	js     801a90 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a4e:	75 23                	jne    801a73 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a50:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a55:	8b 40 48             	mov    0x48(%eax),%eax
  801a58:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a60:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  801a67:	e8 97 e7 ff ff       	call   800203 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a71:	eb 1d                	jmp    801a90 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a76:	8b 52 18             	mov    0x18(%edx),%edx
  801a79:	85 d2                	test   %edx,%edx
  801a7b:	74 0e                	je     801a8b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a80:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a84:	89 04 24             	mov    %eax,(%esp)
  801a87:	ff d2                	call   *%edx
  801a89:	eb 05                	jmp    801a90 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a8b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a90:	83 c4 24             	add    $0x24,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5d                   	pop    %ebp
  801a95:	c3                   	ret    

00801a96 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	53                   	push   %ebx
  801a9a:	83 ec 24             	sub    $0x24,%esp
  801a9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	89 04 24             	mov    %eax,(%esp)
  801aad:	e8 34 fb ff ff       	call   8015e6 <fd_lookup>
  801ab2:	89 c2                	mov    %eax,%edx
  801ab4:	85 d2                	test   %edx,%edx
  801ab6:	78 52                	js     801b0a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac2:	8b 00                	mov    (%eax),%eax
  801ac4:	89 04 24             	mov    %eax,(%esp)
  801ac7:	e8 70 fb ff ff       	call   80163c <dev_lookup>
  801acc:	85 c0                	test   %eax,%eax
  801ace:	78 3a                	js     801b0a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ad7:	74 2c                	je     801b05 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ad9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801adc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ae3:	00 00 00 
	stat->st_isdir = 0;
  801ae6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aed:	00 00 00 
	stat->st_dev = dev;
  801af0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801af6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801afa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801afd:	89 14 24             	mov    %edx,(%esp)
  801b00:	ff 50 14             	call   *0x14(%eax)
  801b03:	eb 05                	jmp    801b0a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b05:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b0a:	83 c4 24             	add    $0x24,%esp
  801b0d:	5b                   	pop    %ebx
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	56                   	push   %esi
  801b14:	53                   	push   %ebx
  801b15:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b1f:	00 
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	89 04 24             	mov    %eax,(%esp)
  801b26:	e8 1b 02 00 00       	call   801d46 <open>
  801b2b:	89 c3                	mov    %eax,%ebx
  801b2d:	85 db                	test   %ebx,%ebx
  801b2f:	78 1b                	js     801b4c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b38:	89 1c 24             	mov    %ebx,(%esp)
  801b3b:	e8 56 ff ff ff       	call   801a96 <fstat>
  801b40:	89 c6                	mov    %eax,%esi
	close(fd);
  801b42:	89 1c 24             	mov    %ebx,(%esp)
  801b45:	e8 cd fb ff ff       	call   801717 <close>
	return r;
  801b4a:	89 f0                	mov    %esi,%eax
}
  801b4c:	83 c4 10             	add    $0x10,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	83 ec 10             	sub    $0x10,%esp
  801b5b:	89 c6                	mov    %eax,%esi
  801b5d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b5f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b66:	75 11                	jne    801b79 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b6f:	e8 bb f9 ff ff       	call   80152f <ipc_find_env>
  801b74:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b79:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b80:	00 
  801b81:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b88:	00 
  801b89:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b8d:	a1 00 50 80 00       	mov    0x805000,%eax
  801b92:	89 04 24             	mov    %eax,(%esp)
  801b95:	e8 2a f9 ff ff       	call   8014c4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ba1:	00 
  801ba2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ba6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bad:	e8 be f8 ff ff       	call   801470 <ipc_recv>
}
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	5b                   	pop    %ebx
  801bb6:	5e                   	pop    %esi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    

00801bb9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd7:	b8 02 00 00 00       	mov    $0x2,%eax
  801bdc:	e8 72 ff ff ff       	call   801b53 <fsipc>
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	8b 40 0c             	mov    0xc(%eax),%eax
  801bef:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bf4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bfe:	e8 50 ff ff ff       	call   801b53 <fsipc>
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	53                   	push   %ebx
  801c09:	83 ec 14             	sub    $0x14,%esp
  801c0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	8b 40 0c             	mov    0xc(%eax),%eax
  801c15:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c24:	e8 2a ff ff ff       	call   801b53 <fsipc>
  801c29:	89 c2                	mov    %eax,%edx
  801c2b:	85 d2                	test   %edx,%edx
  801c2d:	78 2b                	js     801c5a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c2f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c36:	00 
  801c37:	89 1c 24             	mov    %ebx,(%esp)
  801c3a:	e8 e8 eb ff ff       	call   800827 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c3f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c44:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c4a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c4f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5a:	83 c4 14             	add    $0x14,%esp
  801c5d:	5b                   	pop    %ebx
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    

00801c60 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 18             	sub    $0x18,%esp
  801c66:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c69:	8b 55 08             	mov    0x8(%ebp),%edx
  801c6c:	8b 52 0c             	mov    0xc(%edx),%edx
  801c6f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801c75:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c85:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c8c:	e8 9b ed ff ff       	call   800a2c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801c91:	ba 00 00 00 00       	mov    $0x0,%edx
  801c96:	b8 04 00 00 00       	mov    $0x4,%eax
  801c9b:	e8 b3 fe ff ff       	call   801b53 <fsipc>
		return r;
	}

	return r;
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	56                   	push   %esi
  801ca6:	53                   	push   %ebx
  801ca7:	83 ec 10             	sub    $0x10,%esp
  801caa:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cb8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc3:	b8 03 00 00 00       	mov    $0x3,%eax
  801cc8:	e8 86 fe ff ff       	call   801b53 <fsipc>
  801ccd:	89 c3                	mov    %eax,%ebx
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	78 6a                	js     801d3d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cd3:	39 c6                	cmp    %eax,%esi
  801cd5:	73 24                	jae    801cfb <devfile_read+0x59>
  801cd7:	c7 44 24 0c 54 31 80 	movl   $0x803154,0xc(%esp)
  801cde:	00 
  801cdf:	c7 44 24 08 5b 31 80 	movl   $0x80315b,0x8(%esp)
  801ce6:	00 
  801ce7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801cee:	00 
  801cef:	c7 04 24 70 31 80 00 	movl   $0x803170,(%esp)
  801cf6:	e8 2b 0b 00 00       	call   802826 <_panic>
	assert(r <= PGSIZE);
  801cfb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d00:	7e 24                	jle    801d26 <devfile_read+0x84>
  801d02:	c7 44 24 0c 7b 31 80 	movl   $0x80317b,0xc(%esp)
  801d09:	00 
  801d0a:	c7 44 24 08 5b 31 80 	movl   $0x80315b,0x8(%esp)
  801d11:	00 
  801d12:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d19:	00 
  801d1a:	c7 04 24 70 31 80 00 	movl   $0x803170,(%esp)
  801d21:	e8 00 0b 00 00       	call   802826 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d26:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d2a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d31:	00 
  801d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d35:	89 04 24             	mov    %eax,(%esp)
  801d38:	e8 87 ec ff ff       	call   8009c4 <memmove>
	return r;
}
  801d3d:	89 d8                	mov    %ebx,%eax
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5d                   	pop    %ebp
  801d45:	c3                   	ret    

00801d46 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	53                   	push   %ebx
  801d4a:	83 ec 24             	sub    $0x24,%esp
  801d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d50:	89 1c 24             	mov    %ebx,(%esp)
  801d53:	e8 98 ea ff ff       	call   8007f0 <strlen>
  801d58:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d5d:	7f 60                	jg     801dbf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d62:	89 04 24             	mov    %eax,(%esp)
  801d65:	e8 2d f8 ff ff       	call   801597 <fd_alloc>
  801d6a:	89 c2                	mov    %eax,%edx
  801d6c:	85 d2                	test   %edx,%edx
  801d6e:	78 54                	js     801dc4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d74:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d7b:	e8 a7 ea ff ff       	call   800827 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d83:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d90:	e8 be fd ff ff       	call   801b53 <fsipc>
  801d95:	89 c3                	mov    %eax,%ebx
  801d97:	85 c0                	test   %eax,%eax
  801d99:	79 17                	jns    801db2 <open+0x6c>
		fd_close(fd, 0);
  801d9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801da2:	00 
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	89 04 24             	mov    %eax,(%esp)
  801da9:	e8 e8 f8 ff ff       	call   801696 <fd_close>
		return r;
  801dae:	89 d8                	mov    %ebx,%eax
  801db0:	eb 12                	jmp    801dc4 <open+0x7e>
	}

	return fd2num(fd);
  801db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db5:	89 04 24             	mov    %eax,(%esp)
  801db8:	e8 b3 f7 ff ff       	call   801570 <fd2num>
  801dbd:	eb 05                	jmp    801dc4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801dbf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801dc4:	83 c4 24             	add    $0x24,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd5:	b8 08 00 00 00       	mov    $0x8,%eax
  801dda:	e8 74 fd ff ff       	call   801b53 <fsipc>
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    
  801de1:	66 90                	xchg   %ax,%ax
  801de3:	66 90                	xchg   %ax,%ax
  801de5:	66 90                	xchg   %ax,%ax
  801de7:	66 90                	xchg   %ax,%ax
  801de9:	66 90                	xchg   %ax,%ax
  801deb:	66 90                	xchg   %ax,%ax
  801ded:	66 90                	xchg   %ax,%ax
  801def:	90                   	nop

00801df0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801df6:	c7 44 24 04 87 31 80 	movl   $0x803187,0x4(%esp)
  801dfd:	00 
  801dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e01:	89 04 24             	mov    %eax,(%esp)
  801e04:	e8 1e ea ff ff       	call   800827 <strcpy>
	return 0;
}
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	53                   	push   %ebx
  801e14:	83 ec 14             	sub    $0x14,%esp
  801e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e1a:	89 1c 24             	mov    %ebx,(%esp)
  801e1d:	e8 07 0b 00 00       	call   802929 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e22:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e27:	83 f8 01             	cmp    $0x1,%eax
  801e2a:	75 0d                	jne    801e39 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e2c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e2f:	89 04 24             	mov    %eax,(%esp)
  801e32:	e8 29 03 00 00       	call   802160 <nsipc_close>
  801e37:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e39:	89 d0                	mov    %edx,%eax
  801e3b:	83 c4 14             	add    $0x14,%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    

00801e41 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e4e:	00 
  801e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8b 40 0c             	mov    0xc(%eax),%eax
  801e63:	89 04 24             	mov    %eax,(%esp)
  801e66:	e8 f0 03 00 00       	call   80225b <nsipc_send>
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e7a:	00 
  801e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8f:	89 04 24             	mov    %eax,(%esp)
  801e92:	e8 44 03 00 00       	call   8021db <nsipc_recv>
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ea2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ea6:	89 04 24             	mov    %eax,(%esp)
  801ea9:	e8 38 f7 ff ff       	call   8015e6 <fd_lookup>
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 17                	js     801ec9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ebb:	39 08                	cmp    %ecx,(%eax)
  801ebd:	75 05                	jne    801ec4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec2:	eb 05                	jmp    801ec9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ec4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	56                   	push   %esi
  801ecf:	53                   	push   %ebx
  801ed0:	83 ec 20             	sub    $0x20,%esp
  801ed3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed8:	89 04 24             	mov    %eax,(%esp)
  801edb:	e8 b7 f6 ff ff       	call   801597 <fd_alloc>
  801ee0:	89 c3                	mov    %eax,%ebx
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	78 21                	js     801f07 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ee6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801eed:	00 
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801efc:	e8 42 ed ff ff       	call   800c43 <sys_page_alloc>
  801f01:	89 c3                	mov    %eax,%ebx
  801f03:	85 c0                	test   %eax,%eax
  801f05:	79 0c                	jns    801f13 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f07:	89 34 24             	mov    %esi,(%esp)
  801f0a:	e8 51 02 00 00       	call   802160 <nsipc_close>
		return r;
  801f0f:	89 d8                	mov    %ebx,%eax
  801f11:	eb 20                	jmp    801f33 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f13:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f21:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f28:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f2b:	89 14 24             	mov    %edx,(%esp)
  801f2e:	e8 3d f6 ff ff       	call   801570 <fd2num>
}
  801f33:	83 c4 20             	add    $0x20,%esp
  801f36:	5b                   	pop    %ebx
  801f37:	5e                   	pop    %esi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	e8 51 ff ff ff       	call   801e99 <fd2sockid>
		return r;
  801f48:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	78 23                	js     801f71 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f4e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f51:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f58:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f5c:	89 04 24             	mov    %eax,(%esp)
  801f5f:	e8 45 01 00 00       	call   8020a9 <nsipc_accept>
		return r;
  801f64:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f66:	85 c0                	test   %eax,%eax
  801f68:	78 07                	js     801f71 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f6a:	e8 5c ff ff ff       	call   801ecb <alloc_sockfd>
  801f6f:	89 c1                	mov    %eax,%ecx
}
  801f71:	89 c8                	mov    %ecx,%eax
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	e8 16 ff ff ff       	call   801e99 <fd2sockid>
  801f83:	89 c2                	mov    %eax,%edx
  801f85:	85 d2                	test   %edx,%edx
  801f87:	78 16                	js     801f9f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f89:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f97:	89 14 24             	mov    %edx,(%esp)
  801f9a:	e8 60 01 00 00       	call   8020ff <nsipc_bind>
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <shutdown>:

int
shutdown(int s, int how)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	e8 ea fe ff ff       	call   801e99 <fd2sockid>
  801faf:	89 c2                	mov    %eax,%edx
  801fb1:	85 d2                	test   %edx,%edx
  801fb3:	78 0f                	js     801fc4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbc:	89 14 24             	mov    %edx,(%esp)
  801fbf:	e8 7a 01 00 00       	call   80213e <nsipc_shutdown>
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	e8 c5 fe ff ff       	call   801e99 <fd2sockid>
  801fd4:	89 c2                	mov    %eax,%edx
  801fd6:	85 d2                	test   %edx,%edx
  801fd8:	78 16                	js     801ff0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801fda:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe8:	89 14 24             	mov    %edx,(%esp)
  801feb:	e8 8a 01 00 00       	call   80217a <nsipc_connect>
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <listen>:

int
listen(int s, int backlog)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	e8 99 fe ff ff       	call   801e99 <fd2sockid>
  802000:	89 c2                	mov    %eax,%edx
  802002:	85 d2                	test   %edx,%edx
  802004:	78 0f                	js     802015 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802006:	8b 45 0c             	mov    0xc(%ebp),%eax
  802009:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200d:	89 14 24             	mov    %edx,(%esp)
  802010:	e8 a4 01 00 00       	call   8021b9 <nsipc_listen>
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80201d:	8b 45 10             	mov    0x10(%ebp),%eax
  802020:	89 44 24 08          	mov    %eax,0x8(%esp)
  802024:	8b 45 0c             	mov    0xc(%ebp),%eax
  802027:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	89 04 24             	mov    %eax,(%esp)
  802031:	e8 98 02 00 00       	call   8022ce <nsipc_socket>
  802036:	89 c2                	mov    %eax,%edx
  802038:	85 d2                	test   %edx,%edx
  80203a:	78 05                	js     802041 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80203c:	e8 8a fe ff ff       	call   801ecb <alloc_sockfd>
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	53                   	push   %ebx
  802047:	83 ec 14             	sub    $0x14,%esp
  80204a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80204c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802053:	75 11                	jne    802066 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802055:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80205c:	e8 ce f4 ff ff       	call   80152f <ipc_find_env>
  802061:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802066:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80206d:	00 
  80206e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802075:	00 
  802076:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80207a:	a1 04 50 80 00       	mov    0x805004,%eax
  80207f:	89 04 24             	mov    %eax,(%esp)
  802082:	e8 3d f4 ff ff       	call   8014c4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802087:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80208e:	00 
  80208f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802096:	00 
  802097:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209e:	e8 cd f3 ff ff       	call   801470 <ipc_recv>
}
  8020a3:	83 c4 14             	add    $0x14,%esp
  8020a6:	5b                   	pop    %ebx
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    

008020a9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	56                   	push   %esi
  8020ad:	53                   	push   %ebx
  8020ae:	83 ec 10             	sub    $0x10,%esp
  8020b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020bc:	8b 06                	mov    (%esi),%eax
  8020be:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c8:	e8 76 ff ff ff       	call   802043 <nsipc>
  8020cd:	89 c3                	mov    %eax,%ebx
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	78 23                	js     8020f6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020d3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020dc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020e3:	00 
  8020e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e7:	89 04 24             	mov    %eax,(%esp)
  8020ea:	e8 d5 e8 ff ff       	call   8009c4 <memmove>
		*addrlen = ret->ret_addrlen;
  8020ef:	a1 10 70 80 00       	mov    0x807010,%eax
  8020f4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8020f6:	89 d8                	mov    %ebx,%eax
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    

008020ff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	53                   	push   %ebx
  802103:	83 ec 14             	sub    $0x14,%esp
  802106:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802111:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802115:	8b 45 0c             	mov    0xc(%ebp),%eax
  802118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802123:	e8 9c e8 ff ff       	call   8009c4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802128:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80212e:	b8 02 00 00 00       	mov    $0x2,%eax
  802133:	e8 0b ff ff ff       	call   802043 <nsipc>
}
  802138:	83 c4 14             	add    $0x14,%esp
  80213b:	5b                   	pop    %ebx
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    

0080213e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802154:	b8 03 00 00 00       	mov    $0x3,%eax
  802159:	e8 e5 fe ff ff       	call   802043 <nsipc>
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <nsipc_close>:

int
nsipc_close(int s)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80216e:	b8 04 00 00 00       	mov    $0x4,%eax
  802173:	e8 cb fe ff ff       	call   802043 <nsipc>
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	53                   	push   %ebx
  80217e:	83 ec 14             	sub    $0x14,%esp
  802181:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80218c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802190:	8b 45 0c             	mov    0xc(%ebp),%eax
  802193:	89 44 24 04          	mov    %eax,0x4(%esp)
  802197:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80219e:	e8 21 e8 ff ff       	call   8009c4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021a3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021ae:	e8 90 fe ff ff       	call   802043 <nsipc>
}
  8021b3:	83 c4 14             	add    $0x14,%esp
  8021b6:	5b                   	pop    %ebx
  8021b7:	5d                   	pop    %ebp
  8021b8:	c3                   	ret    

008021b9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ca:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021cf:	b8 06 00 00 00       	mov    $0x6,%eax
  8021d4:	e8 6a fe ff ff       	call   802043 <nsipc>
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	83 ec 10             	sub    $0x10,%esp
  8021e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021ee:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021fc:	b8 07 00 00 00       	mov    $0x7,%eax
  802201:	e8 3d fe ff ff       	call   802043 <nsipc>
  802206:	89 c3                	mov    %eax,%ebx
  802208:	85 c0                	test   %eax,%eax
  80220a:	78 46                	js     802252 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80220c:	39 f0                	cmp    %esi,%eax
  80220e:	7f 07                	jg     802217 <nsipc_recv+0x3c>
  802210:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802215:	7e 24                	jle    80223b <nsipc_recv+0x60>
  802217:	c7 44 24 0c 93 31 80 	movl   $0x803193,0xc(%esp)
  80221e:	00 
  80221f:	c7 44 24 08 5b 31 80 	movl   $0x80315b,0x8(%esp)
  802226:	00 
  802227:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80222e:	00 
  80222f:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  802236:	e8 eb 05 00 00       	call   802826 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80223b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80223f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802246:	00 
  802247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224a:	89 04 24             	mov    %eax,(%esp)
  80224d:	e8 72 e7 ff ff       	call   8009c4 <memmove>
	}

	return r;
}
  802252:	89 d8                	mov    %ebx,%eax
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5d                   	pop    %ebp
  80225a:	c3                   	ret    

0080225b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	53                   	push   %ebx
  80225f:	83 ec 14             	sub    $0x14,%esp
  802262:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80226d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802273:	7e 24                	jle    802299 <nsipc_send+0x3e>
  802275:	c7 44 24 0c b4 31 80 	movl   $0x8031b4,0xc(%esp)
  80227c:	00 
  80227d:	c7 44 24 08 5b 31 80 	movl   $0x80315b,0x8(%esp)
  802284:	00 
  802285:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80228c:	00 
  80228d:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  802294:	e8 8d 05 00 00       	call   802826 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802299:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80229d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022ab:	e8 14 e7 ff ff       	call   8009c4 <memmove>
	nsipcbuf.send.req_size = size;
  8022b0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022be:	b8 08 00 00 00       	mov    $0x8,%eax
  8022c3:	e8 7b fd ff ff       	call   802043 <nsipc>
}
  8022c8:	83 c4 14             	add    $0x14,%esp
  8022cb:	5b                   	pop    %ebx
  8022cc:	5d                   	pop    %ebp
  8022cd:	c3                   	ret    

008022ce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022df:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8022f1:	e8 4d fd ff ff       	call   802043 <nsipc>
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	56                   	push   %esi
  8022fc:	53                   	push   %ebx
  8022fd:	83 ec 10             	sub    $0x10,%esp
  802300:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	89 04 24             	mov    %eax,(%esp)
  802309:	e8 72 f2 ff ff       	call   801580 <fd2data>
  80230e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802310:	c7 44 24 04 c0 31 80 	movl   $0x8031c0,0x4(%esp)
  802317:	00 
  802318:	89 1c 24             	mov    %ebx,(%esp)
  80231b:	e8 07 e5 ff ff       	call   800827 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802320:	8b 46 04             	mov    0x4(%esi),%eax
  802323:	2b 06                	sub    (%esi),%eax
  802325:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80232b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802332:	00 00 00 
	stat->st_dev = &devpipe;
  802335:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80233c:	40 80 00 
	return 0;
}
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
  802344:	83 c4 10             	add    $0x10,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5d                   	pop    %ebp
  80234a:	c3                   	ret    

0080234b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	53                   	push   %ebx
  80234f:	83 ec 14             	sub    $0x14,%esp
  802352:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802355:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802359:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802360:	e8 85 e9 ff ff       	call   800cea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802365:	89 1c 24             	mov    %ebx,(%esp)
  802368:	e8 13 f2 ff ff       	call   801580 <fd2data>
  80236d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802371:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802378:	e8 6d e9 ff ff       	call   800cea <sys_page_unmap>
}
  80237d:	83 c4 14             	add    $0x14,%esp
  802380:	5b                   	pop    %ebx
  802381:	5d                   	pop    %ebp
  802382:	c3                   	ret    

00802383 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	57                   	push   %edi
  802387:	56                   	push   %esi
  802388:	53                   	push   %ebx
  802389:	83 ec 2c             	sub    $0x2c,%esp
  80238c:	89 c6                	mov    %eax,%esi
  80238e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802391:	a1 08 50 80 00       	mov    0x805008,%eax
  802396:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802399:	89 34 24             	mov    %esi,(%esp)
  80239c:	e8 88 05 00 00       	call   802929 <pageref>
  8023a1:	89 c7                	mov    %eax,%edi
  8023a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 7b 05 00 00       	call   802929 <pageref>
  8023ae:	39 c7                	cmp    %eax,%edi
  8023b0:	0f 94 c2             	sete   %dl
  8023b3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023b6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8023bc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8023bf:	39 fb                	cmp    %edi,%ebx
  8023c1:	74 21                	je     8023e4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023c3:	84 d2                	test   %dl,%dl
  8023c5:	74 ca                	je     802391 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023c7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ce:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023d6:	c7 04 24 c7 31 80 00 	movl   $0x8031c7,(%esp)
  8023dd:	e8 21 de ff ff       	call   800203 <cprintf>
  8023e2:	eb ad                	jmp    802391 <_pipeisclosed+0xe>
	}
}
  8023e4:	83 c4 2c             	add    $0x2c,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5f                   	pop    %edi
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    

008023ec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	57                   	push   %edi
  8023f0:	56                   	push   %esi
  8023f1:	53                   	push   %ebx
  8023f2:	83 ec 1c             	sub    $0x1c,%esp
  8023f5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8023f8:	89 34 24             	mov    %esi,(%esp)
  8023fb:	e8 80 f1 ff ff       	call   801580 <fd2data>
  802400:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802402:	bf 00 00 00 00       	mov    $0x0,%edi
  802407:	eb 45                	jmp    80244e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802409:	89 da                	mov    %ebx,%edx
  80240b:	89 f0                	mov    %esi,%eax
  80240d:	e8 71 ff ff ff       	call   802383 <_pipeisclosed>
  802412:	85 c0                	test   %eax,%eax
  802414:	75 41                	jne    802457 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802416:	e8 09 e8 ff ff       	call   800c24 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80241b:	8b 43 04             	mov    0x4(%ebx),%eax
  80241e:	8b 0b                	mov    (%ebx),%ecx
  802420:	8d 51 20             	lea    0x20(%ecx),%edx
  802423:	39 d0                	cmp    %edx,%eax
  802425:	73 e2                	jae    802409 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80242a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80242e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802431:	99                   	cltd   
  802432:	c1 ea 1b             	shr    $0x1b,%edx
  802435:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802438:	83 e1 1f             	and    $0x1f,%ecx
  80243b:	29 d1                	sub    %edx,%ecx
  80243d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802441:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802445:	83 c0 01             	add    $0x1,%eax
  802448:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80244b:	83 c7 01             	add    $0x1,%edi
  80244e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802451:	75 c8                	jne    80241b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802453:	89 f8                	mov    %edi,%eax
  802455:	eb 05                	jmp    80245c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80245c:	83 c4 1c             	add    $0x1c,%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    

00802464 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	57                   	push   %edi
  802468:	56                   	push   %esi
  802469:	53                   	push   %ebx
  80246a:	83 ec 1c             	sub    $0x1c,%esp
  80246d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802470:	89 3c 24             	mov    %edi,(%esp)
  802473:	e8 08 f1 ff ff       	call   801580 <fd2data>
  802478:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80247a:	be 00 00 00 00       	mov    $0x0,%esi
  80247f:	eb 3d                	jmp    8024be <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802481:	85 f6                	test   %esi,%esi
  802483:	74 04                	je     802489 <devpipe_read+0x25>
				return i;
  802485:	89 f0                	mov    %esi,%eax
  802487:	eb 43                	jmp    8024cc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802489:	89 da                	mov    %ebx,%edx
  80248b:	89 f8                	mov    %edi,%eax
  80248d:	e8 f1 fe ff ff       	call   802383 <_pipeisclosed>
  802492:	85 c0                	test   %eax,%eax
  802494:	75 31                	jne    8024c7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802496:	e8 89 e7 ff ff       	call   800c24 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80249b:	8b 03                	mov    (%ebx),%eax
  80249d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024a0:	74 df                	je     802481 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024a2:	99                   	cltd   
  8024a3:	c1 ea 1b             	shr    $0x1b,%edx
  8024a6:	01 d0                	add    %edx,%eax
  8024a8:	83 e0 1f             	and    $0x1f,%eax
  8024ab:	29 d0                	sub    %edx,%eax
  8024ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024b8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024bb:	83 c6 01             	add    $0x1,%esi
  8024be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024c1:	75 d8                	jne    80249b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024c3:	89 f0                	mov    %esi,%eax
  8024c5:	eb 05                	jmp    8024cc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024cc:	83 c4 1c             	add    $0x1c,%esp
  8024cf:	5b                   	pop    %ebx
  8024d0:	5e                   	pop    %esi
  8024d1:	5f                   	pop    %edi
  8024d2:	5d                   	pop    %ebp
  8024d3:	c3                   	ret    

008024d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	56                   	push   %esi
  8024d8:	53                   	push   %ebx
  8024d9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024df:	89 04 24             	mov    %eax,(%esp)
  8024e2:	e8 b0 f0 ff ff       	call   801597 <fd_alloc>
  8024e7:	89 c2                	mov    %eax,%edx
  8024e9:	85 d2                	test   %edx,%edx
  8024eb:	0f 88 4d 01 00 00    	js     80263e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024f8:	00 
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802500:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802507:	e8 37 e7 ff ff       	call   800c43 <sys_page_alloc>
  80250c:	89 c2                	mov    %eax,%edx
  80250e:	85 d2                	test   %edx,%edx
  802510:	0f 88 28 01 00 00    	js     80263e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802516:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802519:	89 04 24             	mov    %eax,(%esp)
  80251c:	e8 76 f0 ff ff       	call   801597 <fd_alloc>
  802521:	89 c3                	mov    %eax,%ebx
  802523:	85 c0                	test   %eax,%eax
  802525:	0f 88 fe 00 00 00    	js     802629 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80252b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802532:	00 
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802541:	e8 fd e6 ff ff       	call   800c43 <sys_page_alloc>
  802546:	89 c3                	mov    %eax,%ebx
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 88 d9 00 00 00    	js     802629 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	89 04 24             	mov    %eax,(%esp)
  802556:	e8 25 f0 ff ff       	call   801580 <fd2data>
  80255b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80255d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802564:	00 
  802565:	89 44 24 04          	mov    %eax,0x4(%esp)
  802569:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802570:	e8 ce e6 ff ff       	call   800c43 <sys_page_alloc>
  802575:	89 c3                	mov    %eax,%ebx
  802577:	85 c0                	test   %eax,%eax
  802579:	0f 88 97 00 00 00    	js     802616 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	89 04 24             	mov    %eax,(%esp)
  802585:	e8 f6 ef ff ff       	call   801580 <fd2data>
  80258a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802591:	00 
  802592:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802596:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80259d:	00 
  80259e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a9:	e8 e9 e6 ff ff       	call   800c97 <sys_page_map>
  8025ae:	89 c3                	mov    %eax,%ebx
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	78 52                	js     802606 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025b4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025c9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	89 04 24             	mov    %eax,(%esp)
  8025e4:	e8 87 ef ff ff       	call   801570 <fd2num>
  8025e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f1:	89 04 24             	mov    %eax,(%esp)
  8025f4:	e8 77 ef ff ff       	call   801570 <fd2num>
  8025f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802604:	eb 38                	jmp    80263e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802606:	89 74 24 04          	mov    %esi,0x4(%esp)
  80260a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802611:	e8 d4 e6 ff ff       	call   800cea <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802619:	89 44 24 04          	mov    %eax,0x4(%esp)
  80261d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802624:	e8 c1 e6 ff ff       	call   800cea <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802630:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802637:	e8 ae e6 ff ff       	call   800cea <sys_page_unmap>
  80263c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80263e:	83 c4 30             	add    $0x30,%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    

00802645 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	89 04 24             	mov    %eax,(%esp)
  802658:	e8 89 ef ff ff       	call   8015e6 <fd_lookup>
  80265d:	89 c2                	mov    %eax,%edx
  80265f:	85 d2                	test   %edx,%edx
  802661:	78 15                	js     802678 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	89 04 24             	mov    %eax,(%esp)
  802669:	e8 12 ef ff ff       	call   801580 <fd2data>
	return _pipeisclosed(fd, p);
  80266e:	89 c2                	mov    %eax,%edx
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	e8 0b fd ff ff       	call   802383 <_pipeisclosed>
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    
  80267a:	66 90                	xchg   %ax,%ax
  80267c:	66 90                	xchg   %ax,%ax
  80267e:	66 90                	xchg   %ax,%ax

00802680 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    

0080268a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802690:	c7 44 24 04 df 31 80 	movl   $0x8031df,0x4(%esp)
  802697:	00 
  802698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80269b:	89 04 24             	mov    %eax,(%esp)
  80269e:	e8 84 e1 ff ff       	call   800827 <strcpy>
	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	57                   	push   %edi
  8026ae:	56                   	push   %esi
  8026af:	53                   	push   %ebx
  8026b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026c1:	eb 31                	jmp    8026f4 <devcons_write+0x4a>
		m = n - tot;
  8026c3:	8b 75 10             	mov    0x10(%ebp),%esi
  8026c6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8026c8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8026cb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8026d0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026d7:	03 45 0c             	add    0xc(%ebp),%eax
  8026da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026de:	89 3c 24             	mov    %edi,(%esp)
  8026e1:	e8 de e2 ff ff       	call   8009c4 <memmove>
		sys_cputs(buf, m);
  8026e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026ea:	89 3c 24             	mov    %edi,(%esp)
  8026ed:	e8 84 e4 ff ff       	call   800b76 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026f2:	01 f3                	add    %esi,%ebx
  8026f4:	89 d8                	mov    %ebx,%eax
  8026f6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8026f9:	72 c8                	jb     8026c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8026fb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802701:	5b                   	pop    %ebx
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    

00802706 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802711:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802715:	75 07                	jne    80271e <devcons_read+0x18>
  802717:	eb 2a                	jmp    802743 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802719:	e8 06 e5 ff ff       	call   800c24 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80271e:	66 90                	xchg   %ax,%ax
  802720:	e8 6f e4 ff ff       	call   800b94 <sys_cgetc>
  802725:	85 c0                	test   %eax,%eax
  802727:	74 f0                	je     802719 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802729:	85 c0                	test   %eax,%eax
  80272b:	78 16                	js     802743 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80272d:	83 f8 04             	cmp    $0x4,%eax
  802730:	74 0c                	je     80273e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802732:	8b 55 0c             	mov    0xc(%ebp),%edx
  802735:	88 02                	mov    %al,(%edx)
	return 1;
  802737:	b8 01 00 00 00       	mov    $0x1,%eax
  80273c:	eb 05                	jmp    802743 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802751:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802758:	00 
  802759:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80275c:	89 04 24             	mov    %eax,(%esp)
  80275f:	e8 12 e4 ff ff       	call   800b76 <sys_cputs>
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <getchar>:

int
getchar(void)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80276c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802773:	00 
  802774:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802782:	e8 f3 f0 ff ff       	call   80187a <read>
	if (r < 0)
  802787:	85 c0                	test   %eax,%eax
  802789:	78 0f                	js     80279a <getchar+0x34>
		return r;
	if (r < 1)
  80278b:	85 c0                	test   %eax,%eax
  80278d:	7e 06                	jle    802795 <getchar+0x2f>
		return -E_EOF;
	return c;
  80278f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802793:	eb 05                	jmp    80279a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802795:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	89 04 24             	mov    %eax,(%esp)
  8027af:	e8 32 ee ff ff       	call   8015e6 <fd_lookup>
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	78 11                	js     8027c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027c1:	39 10                	cmp    %edx,(%eax)
  8027c3:	0f 94 c0             	sete   %al
  8027c6:	0f b6 c0             	movzbl %al,%eax
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <opencons>:

int
opencons(void)
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
  8027ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027d4:	89 04 24             	mov    %eax,(%esp)
  8027d7:	e8 bb ed ff ff       	call   801597 <fd_alloc>
		return r;
  8027dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	78 40                	js     802822 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027e9:	00 
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f8:	e8 46 e4 ff ff       	call   800c43 <sys_page_alloc>
		return r;
  8027fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027ff:	85 c0                	test   %eax,%eax
  802801:	78 1f                	js     802822 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802803:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802818:	89 04 24             	mov    %eax,(%esp)
  80281b:	e8 50 ed ff ff       	call   801570 <fd2num>
  802820:	89 c2                	mov    %eax,%edx
}
  802822:	89 d0                	mov    %edx,%eax
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	56                   	push   %esi
  80282a:	53                   	push   %ebx
  80282b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80282e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802831:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802837:	e8 c9 e3 ff ff       	call   800c05 <sys_getenvid>
  80283c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802843:	8b 55 08             	mov    0x8(%ebp),%edx
  802846:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80284a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80284e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802852:	c7 04 24 ec 31 80 00 	movl   $0x8031ec,(%esp)
  802859:	e8 a5 d9 ff ff       	call   800203 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80285e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802862:	8b 45 10             	mov    0x10(%ebp),%eax
  802865:	89 04 24             	mov    %eax,(%esp)
  802868:	e8 35 d9 ff ff       	call   8001a2 <vcprintf>
	cprintf("\n");
  80286d:	c7 04 24 d8 31 80 00 	movl   $0x8031d8,(%esp)
  802874:	e8 8a d9 ff ff       	call   800203 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802879:	cc                   	int3   
  80287a:	eb fd                	jmp    802879 <_panic+0x53>

0080287c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802882:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802889:	75 70                	jne    8028fb <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  80288b:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  802892:	00 
  802893:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80289a:	ee 
  80289b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a2:	e8 9c e3 ff ff       	call   800c43 <sys_page_alloc>
		if (error < 0)
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	79 1c                	jns    8028c7 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  8028ab:	c7 44 24 08 10 32 80 	movl   $0x803210,0x8(%esp)
  8028b2:	00 
  8028b3:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8028ba:	00 
  8028bb:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  8028c2:	e8 5f ff ff ff       	call   802826 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8028c7:	c7 44 24 04 05 29 80 	movl   $0x802905,0x4(%esp)
  8028ce:	00 
  8028cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d6:	e8 08 e5 ff ff       	call   800de3 <sys_env_set_pgfault_upcall>
		if (error < 0)
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	79 1c                	jns    8028fb <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  8028df:	c7 44 24 08 38 32 80 	movl   $0x803238,0x8(%esp)
  8028e6:	00 
  8028e7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8028ee:	00 
  8028ef:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  8028f6:	e8 2b ff ff ff       	call   802826 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802903:	c9                   	leave  
  802904:	c3                   	ret    

00802905 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802905:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802906:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80290b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80290d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  802910:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  802914:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802919:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  80291d:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  80291f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802922:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802923:	83 c4 04             	add    $0x4,%esp
	popfl
  802926:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802927:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802928:	c3                   	ret    

00802929 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
  80292c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80292f:	89 d0                	mov    %edx,%eax
  802931:	c1 e8 16             	shr    $0x16,%eax
  802934:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80293b:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802940:	f6 c1 01             	test   $0x1,%cl
  802943:	74 1d                	je     802962 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802945:	c1 ea 0c             	shr    $0xc,%edx
  802948:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80294f:	f6 c2 01             	test   $0x1,%dl
  802952:	74 0e                	je     802962 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802954:	c1 ea 0c             	shr    $0xc,%edx
  802957:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80295e:	ef 
  80295f:	0f b7 c0             	movzwl %ax,%eax
}
  802962:	5d                   	pop    %ebp
  802963:	c3                   	ret    
  802964:	66 90                	xchg   %ax,%ax
  802966:	66 90                	xchg   %ax,%ax
  802968:	66 90                	xchg   %ax,%ax
  80296a:	66 90                	xchg   %ax,%ax
  80296c:	66 90                	xchg   %ax,%ax
  80296e:	66 90                	xchg   %ax,%ax

00802970 <__udivdi3>:
  802970:	55                   	push   %ebp
  802971:	57                   	push   %edi
  802972:	56                   	push   %esi
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	8b 44 24 28          	mov    0x28(%esp),%eax
  80297a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80297e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802982:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802986:	85 c0                	test   %eax,%eax
  802988:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80298c:	89 ea                	mov    %ebp,%edx
  80298e:	89 0c 24             	mov    %ecx,(%esp)
  802991:	75 2d                	jne    8029c0 <__udivdi3+0x50>
  802993:	39 e9                	cmp    %ebp,%ecx
  802995:	77 61                	ja     8029f8 <__udivdi3+0x88>
  802997:	85 c9                	test   %ecx,%ecx
  802999:	89 ce                	mov    %ecx,%esi
  80299b:	75 0b                	jne    8029a8 <__udivdi3+0x38>
  80299d:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a2:	31 d2                	xor    %edx,%edx
  8029a4:	f7 f1                	div    %ecx
  8029a6:	89 c6                	mov    %eax,%esi
  8029a8:	31 d2                	xor    %edx,%edx
  8029aa:	89 e8                	mov    %ebp,%eax
  8029ac:	f7 f6                	div    %esi
  8029ae:	89 c5                	mov    %eax,%ebp
  8029b0:	89 f8                	mov    %edi,%eax
  8029b2:	f7 f6                	div    %esi
  8029b4:	89 ea                	mov    %ebp,%edx
  8029b6:	83 c4 0c             	add    $0xc,%esp
  8029b9:	5e                   	pop    %esi
  8029ba:	5f                   	pop    %edi
  8029bb:	5d                   	pop    %ebp
  8029bc:	c3                   	ret    
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	39 e8                	cmp    %ebp,%eax
  8029c2:	77 24                	ja     8029e8 <__udivdi3+0x78>
  8029c4:	0f bd e8             	bsr    %eax,%ebp
  8029c7:	83 f5 1f             	xor    $0x1f,%ebp
  8029ca:	75 3c                	jne    802a08 <__udivdi3+0x98>
  8029cc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029d0:	39 34 24             	cmp    %esi,(%esp)
  8029d3:	0f 86 9f 00 00 00    	jbe    802a78 <__udivdi3+0x108>
  8029d9:	39 d0                	cmp    %edx,%eax
  8029db:	0f 82 97 00 00 00    	jb     802a78 <__udivdi3+0x108>
  8029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	31 d2                	xor    %edx,%edx
  8029ea:	31 c0                	xor    %eax,%eax
  8029ec:	83 c4 0c             	add    $0xc,%esp
  8029ef:	5e                   	pop    %esi
  8029f0:	5f                   	pop    %edi
  8029f1:	5d                   	pop    %ebp
  8029f2:	c3                   	ret    
  8029f3:	90                   	nop
  8029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	89 f8                	mov    %edi,%eax
  8029fa:	f7 f1                	div    %ecx
  8029fc:	31 d2                	xor    %edx,%edx
  8029fe:	83 c4 0c             	add    $0xc,%esp
  802a01:	5e                   	pop    %esi
  802a02:	5f                   	pop    %edi
  802a03:	5d                   	pop    %ebp
  802a04:	c3                   	ret    
  802a05:	8d 76 00             	lea    0x0(%esi),%esi
  802a08:	89 e9                	mov    %ebp,%ecx
  802a0a:	8b 3c 24             	mov    (%esp),%edi
  802a0d:	d3 e0                	shl    %cl,%eax
  802a0f:	89 c6                	mov    %eax,%esi
  802a11:	b8 20 00 00 00       	mov    $0x20,%eax
  802a16:	29 e8                	sub    %ebp,%eax
  802a18:	89 c1                	mov    %eax,%ecx
  802a1a:	d3 ef                	shr    %cl,%edi
  802a1c:	89 e9                	mov    %ebp,%ecx
  802a1e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a22:	8b 3c 24             	mov    (%esp),%edi
  802a25:	09 74 24 08          	or     %esi,0x8(%esp)
  802a29:	89 d6                	mov    %edx,%esi
  802a2b:	d3 e7                	shl    %cl,%edi
  802a2d:	89 c1                	mov    %eax,%ecx
  802a2f:	89 3c 24             	mov    %edi,(%esp)
  802a32:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a36:	d3 ee                	shr    %cl,%esi
  802a38:	89 e9                	mov    %ebp,%ecx
  802a3a:	d3 e2                	shl    %cl,%edx
  802a3c:	89 c1                	mov    %eax,%ecx
  802a3e:	d3 ef                	shr    %cl,%edi
  802a40:	09 d7                	or     %edx,%edi
  802a42:	89 f2                	mov    %esi,%edx
  802a44:	89 f8                	mov    %edi,%eax
  802a46:	f7 74 24 08          	divl   0x8(%esp)
  802a4a:	89 d6                	mov    %edx,%esi
  802a4c:	89 c7                	mov    %eax,%edi
  802a4e:	f7 24 24             	mull   (%esp)
  802a51:	39 d6                	cmp    %edx,%esi
  802a53:	89 14 24             	mov    %edx,(%esp)
  802a56:	72 30                	jb     802a88 <__udivdi3+0x118>
  802a58:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a5c:	89 e9                	mov    %ebp,%ecx
  802a5e:	d3 e2                	shl    %cl,%edx
  802a60:	39 c2                	cmp    %eax,%edx
  802a62:	73 05                	jae    802a69 <__udivdi3+0xf9>
  802a64:	3b 34 24             	cmp    (%esp),%esi
  802a67:	74 1f                	je     802a88 <__udivdi3+0x118>
  802a69:	89 f8                	mov    %edi,%eax
  802a6b:	31 d2                	xor    %edx,%edx
  802a6d:	e9 7a ff ff ff       	jmp    8029ec <__udivdi3+0x7c>
  802a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a78:	31 d2                	xor    %edx,%edx
  802a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a7f:	e9 68 ff ff ff       	jmp    8029ec <__udivdi3+0x7c>
  802a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a88:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a8b:	31 d2                	xor    %edx,%edx
  802a8d:	83 c4 0c             	add    $0xc,%esp
  802a90:	5e                   	pop    %esi
  802a91:	5f                   	pop    %edi
  802a92:	5d                   	pop    %ebp
  802a93:	c3                   	ret    
  802a94:	66 90                	xchg   %ax,%ax
  802a96:	66 90                	xchg   %ax,%ax
  802a98:	66 90                	xchg   %ax,%ax
  802a9a:	66 90                	xchg   %ax,%ax
  802a9c:	66 90                	xchg   %ax,%ax
  802a9e:	66 90                	xchg   %ax,%ax

00802aa0 <__umoddi3>:
  802aa0:	55                   	push   %ebp
  802aa1:	57                   	push   %edi
  802aa2:	56                   	push   %esi
  802aa3:	83 ec 14             	sub    $0x14,%esp
  802aa6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aaa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802aae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ab2:	89 c7                	mov    %eax,%edi
  802ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802abc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ac0:	89 34 24             	mov    %esi,(%esp)
  802ac3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	89 c2                	mov    %eax,%edx
  802acb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802acf:	75 17                	jne    802ae8 <__umoddi3+0x48>
  802ad1:	39 fe                	cmp    %edi,%esi
  802ad3:	76 4b                	jbe    802b20 <__umoddi3+0x80>
  802ad5:	89 c8                	mov    %ecx,%eax
  802ad7:	89 fa                	mov    %edi,%edx
  802ad9:	f7 f6                	div    %esi
  802adb:	89 d0                	mov    %edx,%eax
  802add:	31 d2                	xor    %edx,%edx
  802adf:	83 c4 14             	add    $0x14,%esp
  802ae2:	5e                   	pop    %esi
  802ae3:	5f                   	pop    %edi
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    
  802ae6:	66 90                	xchg   %ax,%ax
  802ae8:	39 f8                	cmp    %edi,%eax
  802aea:	77 54                	ja     802b40 <__umoddi3+0xa0>
  802aec:	0f bd e8             	bsr    %eax,%ebp
  802aef:	83 f5 1f             	xor    $0x1f,%ebp
  802af2:	75 5c                	jne    802b50 <__umoddi3+0xb0>
  802af4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802af8:	39 3c 24             	cmp    %edi,(%esp)
  802afb:	0f 87 e7 00 00 00    	ja     802be8 <__umoddi3+0x148>
  802b01:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b05:	29 f1                	sub    %esi,%ecx
  802b07:	19 c7                	sbb    %eax,%edi
  802b09:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b11:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b15:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b19:	83 c4 14             	add    $0x14,%esp
  802b1c:	5e                   	pop    %esi
  802b1d:	5f                   	pop    %edi
  802b1e:	5d                   	pop    %ebp
  802b1f:	c3                   	ret    
  802b20:	85 f6                	test   %esi,%esi
  802b22:	89 f5                	mov    %esi,%ebp
  802b24:	75 0b                	jne    802b31 <__umoddi3+0x91>
  802b26:	b8 01 00 00 00       	mov    $0x1,%eax
  802b2b:	31 d2                	xor    %edx,%edx
  802b2d:	f7 f6                	div    %esi
  802b2f:	89 c5                	mov    %eax,%ebp
  802b31:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b35:	31 d2                	xor    %edx,%edx
  802b37:	f7 f5                	div    %ebp
  802b39:	89 c8                	mov    %ecx,%eax
  802b3b:	f7 f5                	div    %ebp
  802b3d:	eb 9c                	jmp    802adb <__umoddi3+0x3b>
  802b3f:	90                   	nop
  802b40:	89 c8                	mov    %ecx,%eax
  802b42:	89 fa                	mov    %edi,%edx
  802b44:	83 c4 14             	add    $0x14,%esp
  802b47:	5e                   	pop    %esi
  802b48:	5f                   	pop    %edi
  802b49:	5d                   	pop    %ebp
  802b4a:	c3                   	ret    
  802b4b:	90                   	nop
  802b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b50:	8b 04 24             	mov    (%esp),%eax
  802b53:	be 20 00 00 00       	mov    $0x20,%esi
  802b58:	89 e9                	mov    %ebp,%ecx
  802b5a:	29 ee                	sub    %ebp,%esi
  802b5c:	d3 e2                	shl    %cl,%edx
  802b5e:	89 f1                	mov    %esi,%ecx
  802b60:	d3 e8                	shr    %cl,%eax
  802b62:	89 e9                	mov    %ebp,%ecx
  802b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b68:	8b 04 24             	mov    (%esp),%eax
  802b6b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b6f:	89 fa                	mov    %edi,%edx
  802b71:	d3 e0                	shl    %cl,%eax
  802b73:	89 f1                	mov    %esi,%ecx
  802b75:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b79:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b7d:	d3 ea                	shr    %cl,%edx
  802b7f:	89 e9                	mov    %ebp,%ecx
  802b81:	d3 e7                	shl    %cl,%edi
  802b83:	89 f1                	mov    %esi,%ecx
  802b85:	d3 e8                	shr    %cl,%eax
  802b87:	89 e9                	mov    %ebp,%ecx
  802b89:	09 f8                	or     %edi,%eax
  802b8b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b8f:	f7 74 24 04          	divl   0x4(%esp)
  802b93:	d3 e7                	shl    %cl,%edi
  802b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b99:	89 d7                	mov    %edx,%edi
  802b9b:	f7 64 24 08          	mull   0x8(%esp)
  802b9f:	39 d7                	cmp    %edx,%edi
  802ba1:	89 c1                	mov    %eax,%ecx
  802ba3:	89 14 24             	mov    %edx,(%esp)
  802ba6:	72 2c                	jb     802bd4 <__umoddi3+0x134>
  802ba8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802bac:	72 22                	jb     802bd0 <__umoddi3+0x130>
  802bae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802bb2:	29 c8                	sub    %ecx,%eax
  802bb4:	19 d7                	sbb    %edx,%edi
  802bb6:	89 e9                	mov    %ebp,%ecx
  802bb8:	89 fa                	mov    %edi,%edx
  802bba:	d3 e8                	shr    %cl,%eax
  802bbc:	89 f1                	mov    %esi,%ecx
  802bbe:	d3 e2                	shl    %cl,%edx
  802bc0:	89 e9                	mov    %ebp,%ecx
  802bc2:	d3 ef                	shr    %cl,%edi
  802bc4:	09 d0                	or     %edx,%eax
  802bc6:	89 fa                	mov    %edi,%edx
  802bc8:	83 c4 14             	add    $0x14,%esp
  802bcb:	5e                   	pop    %esi
  802bcc:	5f                   	pop    %edi
  802bcd:	5d                   	pop    %ebp
  802bce:	c3                   	ret    
  802bcf:	90                   	nop
  802bd0:	39 d7                	cmp    %edx,%edi
  802bd2:	75 da                	jne    802bae <__umoddi3+0x10e>
  802bd4:	8b 14 24             	mov    (%esp),%edx
  802bd7:	89 c1                	mov    %eax,%ecx
  802bd9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bdd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802be1:	eb cb                	jmp    802bae <__umoddi3+0x10e>
  802be3:	90                   	nop
  802be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802be8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802bec:	0f 82 0f ff ff ff    	jb     802b01 <__umoddi3+0x61>
  802bf2:	e9 1a ff ff ff       	jmp    802b11 <__umoddi3+0x71>
