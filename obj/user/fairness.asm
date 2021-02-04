
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 91 00 00 00       	call   8000c2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 20             	sub    $0x20,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 95 0b 00 00       	call   800bd5 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 84 	cmpl   $0xeec00084,0x804008
  800049:	00 c0 ee 
  80004c:	75 34                	jne    800082 <umain+0x4f>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800060:	00 
  800061:	89 34 24             	mov    %esi,(%esp)
  800064:	e8 d7 0f 00 00       	call   801040 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  800069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80006c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800070:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800074:	c7 04 24 20 27 80 00 	movl   $0x802720,(%esp)
  80007b:	e8 4a 01 00 00       	call   8001ca <cprintf>
  800080:	eb cf                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800082:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  800087:	89 44 24 08          	mov    %eax,0x8(%esp)
  80008b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008f:	c7 04 24 31 27 80 00 	movl   $0x802731,(%esp)
  800096:	e8 2f 01 00 00       	call   8001ca <cprintf>
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80009b:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  8000a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000a7:	00 
  8000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b7:	00 
  8000b8:	89 04 24             	mov    %eax,(%esp)
  8000bb:	e8 d4 0f 00 00       	call   801094 <ipc_send>
  8000c0:	eb d9                	jmp    80009b <umain+0x68>

008000c2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c2:	55                   	push   %ebp
  8000c3:	89 e5                	mov    %esp,%ebp
  8000c5:	56                   	push   %esi
  8000c6:	53                   	push   %ebx
  8000c7:	83 ec 10             	sub    $0x10,%esp
  8000ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000cd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8000d0:	e8 00 0b 00 00       	call   800bd5 <sys_getenvid>
  8000d5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000da:	89 c2                	mov    %eax,%edx
  8000dc:	c1 e2 07             	shl    $0x7,%edx
  8000df:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8000e6:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000eb:	85 db                	test   %ebx,%ebx
  8000ed:	7e 07                	jle    8000f6 <libmain+0x34>
		binaryname = argv[0];
  8000ef:	8b 06                	mov    (%esi),%eax
  8000f1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000fa:	89 1c 24             	mov    %ebx,(%esp)
  8000fd:	e8 31 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800102:	e8 07 00 00 00       	call   80010e <exit>
}
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	5b                   	pop    %ebx
  80010b:	5e                   	pop    %esi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800114:	e8 01 12 00 00       	call   80131a <close_all>
	sys_env_destroy(0);
  800119:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800120:	e8 5e 0a 00 00       	call   800b83 <sys_env_destroy>
}
  800125:	c9                   	leave  
  800126:	c3                   	ret    

00800127 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	53                   	push   %ebx
  80012b:	83 ec 14             	sub    $0x14,%esp
  80012e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800131:	8b 13                	mov    (%ebx),%edx
  800133:	8d 42 01             	lea    0x1(%edx),%eax
  800136:	89 03                	mov    %eax,(%ebx)
  800138:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80013b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800144:	75 19                	jne    80015f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800146:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80014d:	00 
  80014e:	8d 43 08             	lea    0x8(%ebx),%eax
  800151:	89 04 24             	mov    %eax,(%esp)
  800154:	e8 ed 09 00 00       	call   800b46 <sys_cputs>
		b->idx = 0;
  800159:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80015f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800163:	83 c4 14             	add    $0x14,%esp
  800166:	5b                   	pop    %ebx
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    

00800169 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800172:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800179:	00 00 00 
	b.cnt = 0;
  80017c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800183:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800186:	8b 45 0c             	mov    0xc(%ebp),%eax
  800189:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018d:	8b 45 08             	mov    0x8(%ebp),%eax
  800190:	89 44 24 08          	mov    %eax,0x8(%esp)
  800194:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	c7 04 24 27 01 80 00 	movl   $0x800127,(%esp)
  8001a5:	e8 b4 01 00 00       	call   80035e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001aa:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ba:	89 04 24             	mov    %eax,(%esp)
  8001bd:	e8 84 09 00 00       	call   800b46 <sys_cputs>

	return b.cnt;
}
  8001c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	89 04 24             	mov    %eax,(%esp)
  8001dd:	e8 87 ff ff ff       	call   800169 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e2:	c9                   	leave  
  8001e3:	c3                   	ret    
  8001e4:	66 90                	xchg   %ax,%ax
  8001e6:	66 90                	xchg   %ax,%ax
  8001e8:	66 90                	xchg   %ax,%ax
  8001ea:	66 90                	xchg   %ax,%ax
  8001ec:	66 90                	xchg   %ax,%ax
  8001ee:	66 90                	xchg   %ax,%ax

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
  80025f:	e8 2c 22 00 00       	call   802490 <__udivdi3>
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
  8002bf:	e8 fc 22 00 00       	call   8025c0 <__umoddi3>
  8002c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c8:	0f be 80 52 27 80 00 	movsbl 0x802752(%eax),%eax
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
  8003e3:	ff 24 8d c0 28 80 00 	jmp    *0x8028c0(,%ecx,4)
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
  800480:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	75 20                	jne    8004ab <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80048b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80048f:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  800496:	00 
  800497:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	89 04 24             	mov    %eax,(%esp)
  8004a1:	e8 90 fe ff ff       	call   800336 <printfmt>
  8004a6:	e9 d8 fe ff ff       	jmp    800383 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004af:	c7 44 24 08 99 2b 80 	movl   $0x802b99,0x8(%esp)
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
  8004e1:	b8 63 27 80 00       	mov    $0x802763,%eax
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
  800bb1:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800bb8:	00 
  800bb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bc0:	00 
  800bc1:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800bc8:	e8 29 18 00 00       	call   8023f6 <_panic>

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
  800c43:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800c4a:	00 
  800c4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c52:	00 
  800c53:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800c5a:	e8 97 17 00 00       	call   8023f6 <_panic>

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
  800c96:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800c9d:	00 
  800c9e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca5:	00 
  800ca6:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800cad:	e8 44 17 00 00       	call   8023f6 <_panic>

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
  800ce9:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800cf0:	00 
  800cf1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf8:	00 
  800cf9:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800d00:	e8 f1 16 00 00       	call   8023f6 <_panic>

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
  800d3c:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800d43:	00 
  800d44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d4b:	00 
  800d4c:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800d53:	e8 9e 16 00 00       	call   8023f6 <_panic>

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
  800d8f:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800d96:	00 
  800d97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9e:	00 
  800d9f:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800da6:	e8 4b 16 00 00       	call   8023f6 <_panic>

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
  800de2:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800de9:	00 
  800dea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df1:	00 
  800df2:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800df9:	e8 f8 15 00 00       	call   8023f6 <_panic>

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
  800e57:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e66:	00 
  800e67:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800e6e:	e8 83 15 00 00       	call   8023f6 <_panic>

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
  800ec9:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800ed0:	00 
  800ed1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed8:	00 
  800ed9:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800ee0:	e8 11 15 00 00       	call   8023f6 <_panic>

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
  800f1c:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800f23:	00 
  800f24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f2b:	00 
  800f2c:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800f33:	e8 be 14 00 00       	call   8023f6 <_panic>

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
  800f6f:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800f76:	00 
  800f77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7e:	00 
  800f7f:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800f86:	e8 6b 14 00 00       	call   8023f6 <_panic>

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
  800fc1:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  800fc8:	00 
  800fc9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd0:	00 
  800fd1:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  800fd8:	e8 19 14 00 00       	call   8023f6 <_panic>

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
  801014:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  80101b:	00 
  80101c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801023:	00 
  801024:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  80102b:	e8 c6 13 00 00       	call   8023f6 <_panic>

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
  801038:	66 90                	xchg   %ax,%ax
  80103a:	66 90                	xchg   %ax,%ax
  80103c:	66 90                	xchg   %ax,%ax
  80103e:	66 90                	xchg   %ax,%ax

00801040 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	56                   	push   %esi
  801044:	53                   	push   %ebx
  801045:	83 ec 10             	sub    $0x10,%esp
  801048:	8b 75 08             	mov    0x8(%ebp),%esi
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801051:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  801053:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801058:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80105b:	89 04 24             	mov    %eax,(%esp)
  80105e:	e8 c6 fd ff ff       	call   800e29 <sys_ipc_recv>
  801063:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  801065:	85 d2                	test   %edx,%edx
  801067:	75 24                	jne    80108d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  801069:	85 f6                	test   %esi,%esi
  80106b:	74 0a                	je     801077 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80106d:	a1 08 40 80 00       	mov    0x804008,%eax
  801072:	8b 40 74             	mov    0x74(%eax),%eax
  801075:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  801077:	85 db                	test   %ebx,%ebx
  801079:	74 0a                	je     801085 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80107b:	a1 08 40 80 00       	mov    0x804008,%eax
  801080:	8b 40 78             	mov    0x78(%eax),%eax
  801083:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801085:	a1 08 40 80 00       	mov    0x804008,%eax
  80108a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80108d:	83 c4 10             	add    $0x10,%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    

00801094 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 1c             	sub    $0x1c,%esp
  80109d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8010a6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8010a8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8010ad:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8010b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010bf:	89 3c 24             	mov    %edi,(%esp)
  8010c2:	e8 3f fd ff ff       	call   800e06 <sys_ipc_try_send>

		if (ret == 0)
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	74 2c                	je     8010f7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8010cb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8010ce:	74 20                	je     8010f0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8010d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010d4:	c7 44 24 08 b8 2a 80 	movl   $0x802ab8,0x8(%esp)
  8010db:	00 
  8010dc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8010e3:	00 
  8010e4:	c7 04 24 e6 2a 80 00 	movl   $0x802ae6,(%esp)
  8010eb:	e8 06 13 00 00       	call   8023f6 <_panic>
		}

		sys_yield();
  8010f0:	e8 ff fa ff ff       	call   800bf4 <sys_yield>
	}
  8010f5:	eb b9                	jmp    8010b0 <ipc_send+0x1c>
}
  8010f7:	83 c4 1c             	add    $0x1c,%esp
  8010fa:	5b                   	pop    %ebx
  8010fb:	5e                   	pop    %esi
  8010fc:	5f                   	pop    %edi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    

008010ff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801105:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80110a:	89 c2                	mov    %eax,%edx
  80110c:	c1 e2 07             	shl    $0x7,%edx
  80110f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  801116:	8b 52 50             	mov    0x50(%edx),%edx
  801119:	39 ca                	cmp    %ecx,%edx
  80111b:	75 11                	jne    80112e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80111d:	89 c2                	mov    %eax,%edx
  80111f:	c1 e2 07             	shl    $0x7,%edx
  801122:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  801129:	8b 40 40             	mov    0x40(%eax),%eax
  80112c:	eb 0e                	jmp    80113c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80112e:	83 c0 01             	add    $0x1,%eax
  801131:	3d 00 04 00 00       	cmp    $0x400,%eax
  801136:	75 d2                	jne    80110a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801138:	66 b8 00 00          	mov    $0x0,%ax
}
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    
  80113e:	66 90                	xchg   %ax,%ax

00801140 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	05 00 00 00 30       	add    $0x30000000,%eax
  80114b:	c1 e8 0c             	shr    $0xc,%eax
}
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80115b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801160:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    

00801167 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801172:	89 c2                	mov    %eax,%edx
  801174:	c1 ea 16             	shr    $0x16,%edx
  801177:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80117e:	f6 c2 01             	test   $0x1,%dl
  801181:	74 11                	je     801194 <fd_alloc+0x2d>
  801183:	89 c2                	mov    %eax,%edx
  801185:	c1 ea 0c             	shr    $0xc,%edx
  801188:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80118f:	f6 c2 01             	test   $0x1,%dl
  801192:	75 09                	jne    80119d <fd_alloc+0x36>
			*fd_store = fd;
  801194:	89 01                	mov    %eax,(%ecx)
			return 0;
  801196:	b8 00 00 00 00       	mov    $0x0,%eax
  80119b:	eb 17                	jmp    8011b4 <fd_alloc+0x4d>
  80119d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011a7:	75 c9                	jne    801172 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011bc:	83 f8 1f             	cmp    $0x1f,%eax
  8011bf:	77 36                	ja     8011f7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011c1:	c1 e0 0c             	shl    $0xc,%eax
  8011c4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	c1 ea 16             	shr    $0x16,%edx
  8011ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011d5:	f6 c2 01             	test   $0x1,%dl
  8011d8:	74 24                	je     8011fe <fd_lookup+0x48>
  8011da:	89 c2                	mov    %eax,%edx
  8011dc:	c1 ea 0c             	shr    $0xc,%edx
  8011df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e6:	f6 c2 01             	test   $0x1,%dl
  8011e9:	74 1a                	je     801205 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ee:	89 02                	mov    %eax,(%edx)
	return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f5:	eb 13                	jmp    80120a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fc:	eb 0c                	jmp    80120a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801203:	eb 05                	jmp    80120a <fd_lookup+0x54>
  801205:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 18             	sub    $0x18,%esp
  801212:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801215:	ba 00 00 00 00       	mov    $0x0,%edx
  80121a:	eb 13                	jmp    80122f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80121c:	39 08                	cmp    %ecx,(%eax)
  80121e:	75 0c                	jne    80122c <dev_lookup+0x20>
			*dev = devtab[i];
  801220:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801223:	89 01                	mov    %eax,(%ecx)
			return 0;
  801225:	b8 00 00 00 00       	mov    $0x0,%eax
  80122a:	eb 38                	jmp    801264 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80122c:	83 c2 01             	add    $0x1,%edx
  80122f:	8b 04 95 6c 2b 80 00 	mov    0x802b6c(,%edx,4),%eax
  801236:	85 c0                	test   %eax,%eax
  801238:	75 e2                	jne    80121c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80123a:	a1 08 40 80 00       	mov    0x804008,%eax
  80123f:	8b 40 48             	mov    0x48(%eax),%eax
  801242:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801246:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124a:	c7 04 24 f0 2a 80 00 	movl   $0x802af0,(%esp)
  801251:	e8 74 ef ff ff       	call   8001ca <cprintf>
	*dev = 0;
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80125f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	56                   	push   %esi
  80126a:	53                   	push   %ebx
  80126b:	83 ec 20             	sub    $0x20,%esp
  80126e:	8b 75 08             	mov    0x8(%ebp),%esi
  801271:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801274:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801277:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80127b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801281:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801284:	89 04 24             	mov    %eax,(%esp)
  801287:	e8 2a ff ff ff       	call   8011b6 <fd_lookup>
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 05                	js     801295 <fd_close+0x2f>
	    || fd != fd2)
  801290:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801293:	74 0c                	je     8012a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801295:	84 db                	test   %bl,%bl
  801297:	ba 00 00 00 00       	mov    $0x0,%edx
  80129c:	0f 44 c2             	cmove  %edx,%eax
  80129f:	eb 3f                	jmp    8012e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a8:	8b 06                	mov    (%esi),%eax
  8012aa:	89 04 24             	mov    %eax,(%esp)
  8012ad:	e8 5a ff ff ff       	call   80120c <dev_lookup>
  8012b2:	89 c3                	mov    %eax,%ebx
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	78 16                	js     8012ce <fd_close+0x68>
		if (dev->dev_close)
  8012b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	74 07                	je     8012ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8012c7:	89 34 24             	mov    %esi,(%esp)
  8012ca:	ff d0                	call   *%eax
  8012cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d9:	e8 dc f9 ff ff       	call   800cba <sys_page_unmap>
	return r;
  8012de:	89 d8                	mov    %ebx,%eax
}
  8012e0:	83 c4 20             	add    $0x20,%esp
  8012e3:	5b                   	pop    %ebx
  8012e4:	5e                   	pop    %esi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	89 04 24             	mov    %eax,(%esp)
  8012fa:	e8 b7 fe ff ff       	call   8011b6 <fd_lookup>
  8012ff:	89 c2                	mov    %eax,%edx
  801301:	85 d2                	test   %edx,%edx
  801303:	78 13                	js     801318 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801305:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80130c:	00 
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	89 04 24             	mov    %eax,(%esp)
  801313:	e8 4e ff ff ff       	call   801266 <fd_close>
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <close_all>:

void
close_all(void)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	53                   	push   %ebx
  80131e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801321:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801326:	89 1c 24             	mov    %ebx,(%esp)
  801329:	e8 b9 ff ff ff       	call   8012e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80132e:	83 c3 01             	add    $0x1,%ebx
  801331:	83 fb 20             	cmp    $0x20,%ebx
  801334:	75 f0                	jne    801326 <close_all+0xc>
		close(i);
}
  801336:	83 c4 14             	add    $0x14,%esp
  801339:	5b                   	pop    %ebx
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    

0080133c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	57                   	push   %edi
  801340:	56                   	push   %esi
  801341:	53                   	push   %ebx
  801342:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801345:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	89 04 24             	mov    %eax,(%esp)
  801352:	e8 5f fe ff ff       	call   8011b6 <fd_lookup>
  801357:	89 c2                	mov    %eax,%edx
  801359:	85 d2                	test   %edx,%edx
  80135b:	0f 88 e1 00 00 00    	js     801442 <dup+0x106>
		return r;
	close(newfdnum);
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	89 04 24             	mov    %eax,(%esp)
  801367:	e8 7b ff ff ff       	call   8012e7 <close>

	newfd = INDEX2FD(newfdnum);
  80136c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80136f:	c1 e3 0c             	shl    $0xc,%ebx
  801372:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137b:	89 04 24             	mov    %eax,(%esp)
  80137e:	e8 cd fd ff ff       	call   801150 <fd2data>
  801383:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801385:	89 1c 24             	mov    %ebx,(%esp)
  801388:	e8 c3 fd ff ff       	call   801150 <fd2data>
  80138d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80138f:	89 f0                	mov    %esi,%eax
  801391:	c1 e8 16             	shr    $0x16,%eax
  801394:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80139b:	a8 01                	test   $0x1,%al
  80139d:	74 43                	je     8013e2 <dup+0xa6>
  80139f:	89 f0                	mov    %esi,%eax
  8013a1:	c1 e8 0c             	shr    $0xc,%eax
  8013a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013ab:	f6 c2 01             	test   $0x1,%dl
  8013ae:	74 32                	je     8013e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013cb:	00 
  8013cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d7:	e8 8b f8 ff ff       	call   800c67 <sys_page_map>
  8013dc:	89 c6                	mov    %eax,%esi
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 3e                	js     801420 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	c1 ea 0c             	shr    $0xc,%edx
  8013ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801406:	00 
  801407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801412:	e8 50 f8 ff ff       	call   800c67 <sys_page_map>
  801417:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80141c:	85 f6                	test   %esi,%esi
  80141e:	79 22                	jns    801442 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801420:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801424:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142b:	e8 8a f8 ff ff       	call   800cba <sys_page_unmap>
	sys_page_unmap(0, nva);
  801430:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801434:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143b:	e8 7a f8 ff ff       	call   800cba <sys_page_unmap>
	return r;
  801440:	89 f0                	mov    %esi,%eax
}
  801442:	83 c4 3c             	add    $0x3c,%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    

0080144a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	53                   	push   %ebx
  80144e:	83 ec 24             	sub    $0x24,%esp
  801451:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801454:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145b:	89 1c 24             	mov    %ebx,(%esp)
  80145e:	e8 53 fd ff ff       	call   8011b6 <fd_lookup>
  801463:	89 c2                	mov    %eax,%edx
  801465:	85 d2                	test   %edx,%edx
  801467:	78 6d                	js     8014d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801469:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801473:	8b 00                	mov    (%eax),%eax
  801475:	89 04 24             	mov    %eax,(%esp)
  801478:	e8 8f fd ff ff       	call   80120c <dev_lookup>
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 55                	js     8014d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801484:	8b 50 08             	mov    0x8(%eax),%edx
  801487:	83 e2 03             	and    $0x3,%edx
  80148a:	83 fa 01             	cmp    $0x1,%edx
  80148d:	75 23                	jne    8014b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80148f:	a1 08 40 80 00       	mov    0x804008,%eax
  801494:	8b 40 48             	mov    0x48(%eax),%eax
  801497:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80149b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149f:	c7 04 24 31 2b 80 00 	movl   $0x802b31,(%esp)
  8014a6:	e8 1f ed ff ff       	call   8001ca <cprintf>
		return -E_INVAL;
  8014ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b0:	eb 24                	jmp    8014d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8014b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b5:	8b 52 08             	mov    0x8(%edx),%edx
  8014b8:	85 d2                	test   %edx,%edx
  8014ba:	74 15                	je     8014d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014ca:	89 04 24             	mov    %eax,(%esp)
  8014cd:	ff d2                	call   *%edx
  8014cf:	eb 05                	jmp    8014d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014d6:	83 c4 24             	add    $0x24,%esp
  8014d9:	5b                   	pop    %ebx
  8014da:	5d                   	pop    %ebp
  8014db:	c3                   	ret    

008014dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	57                   	push   %edi
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	83 ec 1c             	sub    $0x1c,%esp
  8014e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f0:	eb 23                	jmp    801515 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014f2:	89 f0                	mov    %esi,%eax
  8014f4:	29 d8                	sub    %ebx,%eax
  8014f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014fa:	89 d8                	mov    %ebx,%eax
  8014fc:	03 45 0c             	add    0xc(%ebp),%eax
  8014ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801503:	89 3c 24             	mov    %edi,(%esp)
  801506:	e8 3f ff ff ff       	call   80144a <read>
		if (m < 0)
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 10                	js     80151f <readn+0x43>
			return m;
		if (m == 0)
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 0a                	je     80151d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801513:	01 c3                	add    %eax,%ebx
  801515:	39 f3                	cmp    %esi,%ebx
  801517:	72 d9                	jb     8014f2 <readn+0x16>
  801519:	89 d8                	mov    %ebx,%eax
  80151b:	eb 02                	jmp    80151f <readn+0x43>
  80151d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80151f:	83 c4 1c             	add    $0x1c,%esp
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5f                   	pop    %edi
  801525:	5d                   	pop    %ebp
  801526:	c3                   	ret    

00801527 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	53                   	push   %ebx
  80152b:	83 ec 24             	sub    $0x24,%esp
  80152e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801531:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801534:	89 44 24 04          	mov    %eax,0x4(%esp)
  801538:	89 1c 24             	mov    %ebx,(%esp)
  80153b:	e8 76 fc ff ff       	call   8011b6 <fd_lookup>
  801540:	89 c2                	mov    %eax,%edx
  801542:	85 d2                	test   %edx,%edx
  801544:	78 68                	js     8015ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801549:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	89 04 24             	mov    %eax,(%esp)
  801555:	e8 b2 fc ff ff       	call   80120c <dev_lookup>
  80155a:	85 c0                	test   %eax,%eax
  80155c:	78 50                	js     8015ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801561:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801565:	75 23                	jne    80158a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801567:	a1 08 40 80 00       	mov    0x804008,%eax
  80156c:	8b 40 48             	mov    0x48(%eax),%eax
  80156f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801573:	89 44 24 04          	mov    %eax,0x4(%esp)
  801577:	c7 04 24 4d 2b 80 00 	movl   $0x802b4d,(%esp)
  80157e:	e8 47 ec ff ff       	call   8001ca <cprintf>
		return -E_INVAL;
  801583:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801588:	eb 24                	jmp    8015ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80158a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158d:	8b 52 0c             	mov    0xc(%edx),%edx
  801590:	85 d2                	test   %edx,%edx
  801592:	74 15                	je     8015a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801594:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801597:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80159b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80159e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015a2:	89 04 24             	mov    %eax,(%esp)
  8015a5:	ff d2                	call   *%edx
  8015a7:	eb 05                	jmp    8015ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015ae:	83 c4 24             	add    $0x24,%esp
  8015b1:	5b                   	pop    %ebx
  8015b2:	5d                   	pop    %ebp
  8015b3:	c3                   	ret    

008015b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	e8 ea fb ff ff       	call   8011b6 <fd_lookup>
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 0e                	js     8015de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 24             	sub    $0x24,%esp
  8015e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f1:	89 1c 24             	mov    %ebx,(%esp)
  8015f4:	e8 bd fb ff ff       	call   8011b6 <fd_lookup>
  8015f9:	89 c2                	mov    %eax,%edx
  8015fb:	85 d2                	test   %edx,%edx
  8015fd:	78 61                	js     801660 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801602:	89 44 24 04          	mov    %eax,0x4(%esp)
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	8b 00                	mov    (%eax),%eax
  80160b:	89 04 24             	mov    %eax,(%esp)
  80160e:	e8 f9 fb ff ff       	call   80120c <dev_lookup>
  801613:	85 c0                	test   %eax,%eax
  801615:	78 49                	js     801660 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80161e:	75 23                	jne    801643 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801620:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801625:	8b 40 48             	mov    0x48(%eax),%eax
  801628:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80162c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801630:	c7 04 24 10 2b 80 00 	movl   $0x802b10,(%esp)
  801637:	e8 8e eb ff ff       	call   8001ca <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80163c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801641:	eb 1d                	jmp    801660 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801646:	8b 52 18             	mov    0x18(%edx),%edx
  801649:	85 d2                	test   %edx,%edx
  80164b:	74 0e                	je     80165b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80164d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801650:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801654:	89 04 24             	mov    %eax,(%esp)
  801657:	ff d2                	call   *%edx
  801659:	eb 05                	jmp    801660 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80165b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801660:	83 c4 24             	add    $0x24,%esp
  801663:	5b                   	pop    %ebx
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	53                   	push   %ebx
  80166a:	83 ec 24             	sub    $0x24,%esp
  80166d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801670:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801673:	89 44 24 04          	mov    %eax,0x4(%esp)
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	89 04 24             	mov    %eax,(%esp)
  80167d:	e8 34 fb ff ff       	call   8011b6 <fd_lookup>
  801682:	89 c2                	mov    %eax,%edx
  801684:	85 d2                	test   %edx,%edx
  801686:	78 52                	js     8016da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801688:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	8b 00                	mov    (%eax),%eax
  801694:	89 04 24             	mov    %eax,(%esp)
  801697:	e8 70 fb ff ff       	call   80120c <dev_lookup>
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 3a                	js     8016da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016a7:	74 2c                	je     8016d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016b3:	00 00 00 
	stat->st_isdir = 0;
  8016b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016bd:	00 00 00 
	stat->st_dev = dev;
  8016c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016cd:	89 14 24             	mov    %edx,(%esp)
  8016d0:	ff 50 14             	call   *0x14(%eax)
  8016d3:	eb 05                	jmp    8016da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016da:	83 c4 24             	add    $0x24,%esp
  8016dd:	5b                   	pop    %ebx
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	56                   	push   %esi
  8016e4:	53                   	push   %ebx
  8016e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016ef:	00 
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	89 04 24             	mov    %eax,(%esp)
  8016f6:	e8 1b 02 00 00       	call   801916 <open>
  8016fb:	89 c3                	mov    %eax,%ebx
  8016fd:	85 db                	test   %ebx,%ebx
  8016ff:	78 1b                	js     80171c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801701:	8b 45 0c             	mov    0xc(%ebp),%eax
  801704:	89 44 24 04          	mov    %eax,0x4(%esp)
  801708:	89 1c 24             	mov    %ebx,(%esp)
  80170b:	e8 56 ff ff ff       	call   801666 <fstat>
  801710:	89 c6                	mov    %eax,%esi
	close(fd);
  801712:	89 1c 24             	mov    %ebx,(%esp)
  801715:	e8 cd fb ff ff       	call   8012e7 <close>
	return r;
  80171a:	89 f0                	mov    %esi,%eax
}
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	5b                   	pop    %ebx
  801720:	5e                   	pop    %esi
  801721:	5d                   	pop    %ebp
  801722:	c3                   	ret    

00801723 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	83 ec 10             	sub    $0x10,%esp
  80172b:	89 c6                	mov    %eax,%esi
  80172d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80172f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801736:	75 11                	jne    801749 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801738:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80173f:	e8 bb f9 ff ff       	call   8010ff <ipc_find_env>
  801744:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801749:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801750:	00 
  801751:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801758:	00 
  801759:	89 74 24 04          	mov    %esi,0x4(%esp)
  80175d:	a1 00 40 80 00       	mov    0x804000,%eax
  801762:	89 04 24             	mov    %eax,(%esp)
  801765:	e8 2a f9 ff ff       	call   801094 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80176a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801771:	00 
  801772:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801776:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80177d:	e8 be f8 ff ff       	call   801040 <ipc_recv>
}
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5d                   	pop    %ebp
  801788:	c3                   	ret    

00801789 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 40 0c             	mov    0xc(%eax),%eax
  801795:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ac:	e8 72 ff ff ff       	call   801723 <fsipc>
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ce:	e8 50 ff ff ff       	call   801723 <fsipc>
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 14             	sub    $0x14,%esp
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8017f4:	e8 2a ff ff ff       	call   801723 <fsipc>
  8017f9:	89 c2                	mov    %eax,%edx
  8017fb:	85 d2                	test   %edx,%edx
  8017fd:	78 2b                	js     80182a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ff:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801806:	00 
  801807:	89 1c 24             	mov    %ebx,(%esp)
  80180a:	e8 e8 ef ff ff       	call   8007f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80180f:	a1 80 50 80 00       	mov    0x805080,%eax
  801814:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80181a:	a1 84 50 80 00       	mov    0x805084,%eax
  80181f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182a:	83 c4 14             	add    $0x14,%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    

00801830 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 18             	sub    $0x18,%esp
  801836:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801839:	8b 55 08             	mov    0x8(%ebp),%edx
  80183c:	8b 52 0c             	mov    0xc(%edx),%edx
  80183f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801845:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80184a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	89 44 24 04          	mov    %eax,0x4(%esp)
  801855:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80185c:	e8 9b f1 ff ff       	call   8009fc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801861:	ba 00 00 00 00       	mov    $0x0,%edx
  801866:	b8 04 00 00 00       	mov    $0x4,%eax
  80186b:	e8 b3 fe ff ff       	call   801723 <fsipc>
		return r;
	}

	return r;
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	56                   	push   %esi
  801876:	53                   	push   %ebx
  801877:	83 ec 10             	sub    $0x10,%esp
  80187a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	8b 40 0c             	mov    0xc(%eax),%eax
  801883:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801888:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	b8 03 00 00 00       	mov    $0x3,%eax
  801898:	e8 86 fe ff ff       	call   801723 <fsipc>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 6a                	js     80190d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018a3:	39 c6                	cmp    %eax,%esi
  8018a5:	73 24                	jae    8018cb <devfile_read+0x59>
  8018a7:	c7 44 24 0c 80 2b 80 	movl   $0x802b80,0xc(%esp)
  8018ae:	00 
  8018af:	c7 44 24 08 87 2b 80 	movl   $0x802b87,0x8(%esp)
  8018b6:	00 
  8018b7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018be:	00 
  8018bf:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  8018c6:	e8 2b 0b 00 00       	call   8023f6 <_panic>
	assert(r <= PGSIZE);
  8018cb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018d0:	7e 24                	jle    8018f6 <devfile_read+0x84>
  8018d2:	c7 44 24 0c a7 2b 80 	movl   $0x802ba7,0xc(%esp)
  8018d9:	00 
  8018da:	c7 44 24 08 87 2b 80 	movl   $0x802b87,0x8(%esp)
  8018e1:	00 
  8018e2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018e9:	00 
  8018ea:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  8018f1:	e8 00 0b 00 00       	call   8023f6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018fa:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801901:	00 
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	89 04 24             	mov    %eax,(%esp)
  801908:	e8 87 f0 ff ff       	call   800994 <memmove>
	return r;
}
  80190d:	89 d8                	mov    %ebx,%eax
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	5b                   	pop    %ebx
  801913:	5e                   	pop    %esi
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    

00801916 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	53                   	push   %ebx
  80191a:	83 ec 24             	sub    $0x24,%esp
  80191d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801920:	89 1c 24             	mov    %ebx,(%esp)
  801923:	e8 98 ee ff ff       	call   8007c0 <strlen>
  801928:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80192d:	7f 60                	jg     80198f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80192f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801932:	89 04 24             	mov    %eax,(%esp)
  801935:	e8 2d f8 ff ff       	call   801167 <fd_alloc>
  80193a:	89 c2                	mov    %eax,%edx
  80193c:	85 d2                	test   %edx,%edx
  80193e:	78 54                	js     801994 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801940:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801944:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80194b:	e8 a7 ee ff ff       	call   8007f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801950:	8b 45 0c             	mov    0xc(%ebp),%eax
  801953:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801958:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195b:	b8 01 00 00 00       	mov    $0x1,%eax
  801960:	e8 be fd ff ff       	call   801723 <fsipc>
  801965:	89 c3                	mov    %eax,%ebx
  801967:	85 c0                	test   %eax,%eax
  801969:	79 17                	jns    801982 <open+0x6c>
		fd_close(fd, 0);
  80196b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801972:	00 
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	89 04 24             	mov    %eax,(%esp)
  801979:	e8 e8 f8 ff ff       	call   801266 <fd_close>
		return r;
  80197e:	89 d8                	mov    %ebx,%eax
  801980:	eb 12                	jmp    801994 <open+0x7e>
	}

	return fd2num(fd);
  801982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801985:	89 04 24             	mov    %eax,(%esp)
  801988:	e8 b3 f7 ff ff       	call   801140 <fd2num>
  80198d:	eb 05                	jmp    801994 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80198f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801994:	83 c4 24             	add    $0x24,%esp
  801997:	5b                   	pop    %ebx
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019aa:	e8 74 fd ff ff       	call   801723 <fsipc>
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    
  8019b1:	66 90                	xchg   %ax,%ax
  8019b3:	66 90                	xchg   %ax,%ax
  8019b5:	66 90                	xchg   %ax,%ax
  8019b7:	66 90                	xchg   %ax,%ax
  8019b9:	66 90                	xchg   %ax,%ax
  8019bb:	66 90                	xchg   %ax,%ax
  8019bd:	66 90                	xchg   %ax,%ax
  8019bf:	90                   	nop

008019c0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8019c6:	c7 44 24 04 b3 2b 80 	movl   $0x802bb3,0x4(%esp)
  8019cd:	00 
  8019ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d1:	89 04 24             	mov    %eax,(%esp)
  8019d4:	e8 1e ee ff ff       	call   8007f7 <strcpy>
	return 0;
}
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 14             	sub    $0x14,%esp
  8019e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019ea:	89 1c 24             	mov    %ebx,(%esp)
  8019ed:	e8 5a 0a 00 00       	call   80244c <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8019f7:	83 f8 01             	cmp    $0x1,%eax
  8019fa:	75 0d                	jne    801a09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8019fc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8019ff:	89 04 24             	mov    %eax,(%esp)
  801a02:	e8 29 03 00 00       	call   801d30 <nsipc_close>
  801a07:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801a09:	89 d0                	mov    %edx,%eax
  801a0b:	83 c4 14             	add    $0x14,%esp
  801a0e:	5b                   	pop    %ebx
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    

00801a11 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a1e:	00 
  801a1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8b 40 0c             	mov    0xc(%eax),%eax
  801a33:	89 04 24             	mov    %eax,(%esp)
  801a36:	e8 f0 03 00 00       	call   801e2b <nsipc_send>
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a4a:	00 
  801a4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	e8 44 03 00 00       	call   801dab <nsipc_recv>
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a72:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a76:	89 04 24             	mov    %eax,(%esp)
  801a79:	e8 38 f7 ff ff       	call   8011b6 <fd_lookup>
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 17                	js     801a99 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a85:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a8b:	39 08                	cmp    %ecx,(%eax)
  801a8d:	75 05                	jne    801a94 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a92:	eb 05                	jmp    801a99 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 20             	sub    $0x20,%esp
  801aa3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801aa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa8:	89 04 24             	mov    %eax,(%esp)
  801aab:	e8 b7 f6 ff ff       	call   801167 <fd_alloc>
  801ab0:	89 c3                	mov    %eax,%ebx
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 21                	js     801ad7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ab6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801abd:	00 
  801abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801acc:	e8 42 f1 ff ff       	call   800c13 <sys_page_alloc>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	79 0c                	jns    801ae3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ad7:	89 34 24             	mov    %esi,(%esp)
  801ada:	e8 51 02 00 00       	call   801d30 <nsipc_close>
		return r;
  801adf:	89 d8                	mov    %ebx,%eax
  801ae1:	eb 20                	jmp    801b03 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ae3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801af8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801afb:	89 14 24             	mov    %edx,(%esp)
  801afe:	e8 3d f6 ff ff       	call   801140 <fd2num>
}
  801b03:	83 c4 20             	add    $0x20,%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5e                   	pop    %esi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	e8 51 ff ff ff       	call   801a69 <fd2sockid>
		return r;
  801b18:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 23                	js     801b41 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b1e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b21:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b2c:	89 04 24             	mov    %eax,(%esp)
  801b2f:	e8 45 01 00 00       	call   801c79 <nsipc_accept>
		return r;
  801b34:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 07                	js     801b41 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b3a:	e8 5c ff ff ff       	call   801a9b <alloc_sockfd>
  801b3f:	89 c1                	mov    %eax,%ecx
}
  801b41:	89 c8                	mov    %ecx,%eax
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	e8 16 ff ff ff       	call   801a69 <fd2sockid>
  801b53:	89 c2                	mov    %eax,%edx
  801b55:	85 d2                	test   %edx,%edx
  801b57:	78 16                	js     801b6f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801b59:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b67:	89 14 24             	mov    %edx,(%esp)
  801b6a:	e8 60 01 00 00       	call   801ccf <nsipc_bind>
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <shutdown>:

int
shutdown(int s, int how)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	e8 ea fe ff ff       	call   801a69 <fd2sockid>
  801b7f:	89 c2                	mov    %eax,%edx
  801b81:	85 d2                	test   %edx,%edx
  801b83:	78 0f                	js     801b94 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8c:	89 14 24             	mov    %edx,(%esp)
  801b8f:	e8 7a 01 00 00       	call   801d0e <nsipc_shutdown>
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	e8 c5 fe ff ff       	call   801a69 <fd2sockid>
  801ba4:	89 c2                	mov    %eax,%edx
  801ba6:	85 d2                	test   %edx,%edx
  801ba8:	78 16                	js     801bc0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801baa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bad:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb8:	89 14 24             	mov    %edx,(%esp)
  801bbb:	e8 8a 01 00 00       	call   801d4a <nsipc_connect>
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <listen>:

int
listen(int s, int backlog)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	e8 99 fe ff ff       	call   801a69 <fd2sockid>
  801bd0:	89 c2                	mov    %eax,%edx
  801bd2:	85 d2                	test   %edx,%edx
  801bd4:	78 0f                	js     801be5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdd:	89 14 24             	mov    %edx,(%esp)
  801be0:	e8 a4 01 00 00       	call   801d89 <nsipc_listen>
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bed:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	89 04 24             	mov    %eax,(%esp)
  801c01:	e8 98 02 00 00       	call   801e9e <nsipc_socket>
  801c06:	89 c2                	mov    %eax,%edx
  801c08:	85 d2                	test   %edx,%edx
  801c0a:	78 05                	js     801c11 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801c0c:	e8 8a fe ff ff       	call   801a9b <alloc_sockfd>
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	53                   	push   %ebx
  801c17:	83 ec 14             	sub    $0x14,%esp
  801c1a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c1c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c23:	75 11                	jne    801c36 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c25:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c2c:	e8 ce f4 ff ff       	call   8010ff <ipc_find_env>
  801c31:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c3d:	00 
  801c3e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c45:	00 
  801c46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c4a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c4f:	89 04 24             	mov    %eax,(%esp)
  801c52:	e8 3d f4 ff ff       	call   801094 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c5e:	00 
  801c5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c66:	00 
  801c67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6e:	e8 cd f3 ff ff       	call   801040 <ipc_recv>
}
  801c73:	83 c4 14             	add    $0x14,%esp
  801c76:	5b                   	pop    %ebx
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    

00801c79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	56                   	push   %esi
  801c7d:	53                   	push   %ebx
  801c7e:	83 ec 10             	sub    $0x10,%esp
  801c81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c8c:	8b 06                	mov    (%esi),%eax
  801c8e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c93:	b8 01 00 00 00       	mov    $0x1,%eax
  801c98:	e8 76 ff ff ff       	call   801c13 <nsipc>
  801c9d:	89 c3                	mov    %eax,%ebx
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 23                	js     801cc6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ca3:	a1 10 60 80 00       	mov    0x806010,%eax
  801ca8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cac:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cb3:	00 
  801cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb7:	89 04 24             	mov    %eax,(%esp)
  801cba:	e8 d5 ec ff ff       	call   800994 <memmove>
		*addrlen = ret->ret_addrlen;
  801cbf:	a1 10 60 80 00       	mov    0x806010,%eax
  801cc4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801cc6:	89 d8                	mov    %ebx,%eax
  801cc8:	83 c4 10             	add    $0x10,%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5e                   	pop    %esi
  801ccd:	5d                   	pop    %ebp
  801cce:	c3                   	ret    

00801ccf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	53                   	push   %ebx
  801cd3:	83 ec 14             	sub    $0x14,%esp
  801cd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ce1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801cf3:	e8 9c ec ff ff       	call   800994 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cf8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cfe:	b8 02 00 00 00       	mov    $0x2,%eax
  801d03:	e8 0b ff ff ff       	call   801c13 <nsipc>
}
  801d08:	83 c4 14             	add    $0x14,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5d                   	pop    %ebp
  801d0d:	c3                   	ret    

00801d0e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d24:	b8 03 00 00 00       	mov    $0x3,%eax
  801d29:	e8 e5 fe ff ff       	call   801c13 <nsipc>
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <nsipc_close>:

int
nsipc_close(int s)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d3e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d43:	e8 cb fe ff ff       	call   801c13 <nsipc>
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	53                   	push   %ebx
  801d4e:	83 ec 14             	sub    $0x14,%esp
  801d51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d5c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d67:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d6e:	e8 21 ec ff ff       	call   800994 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d73:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d79:	b8 05 00 00 00       	mov    $0x5,%eax
  801d7e:	e8 90 fe ff ff       	call   801c13 <nsipc>
}
  801d83:	83 c4 14             	add    $0x14,%esp
  801d86:	5b                   	pop    %ebx
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d9f:	b8 06 00 00 00       	mov    $0x6,%eax
  801da4:	e8 6a fe ff ff       	call   801c13 <nsipc>
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 10             	sub    $0x10,%esp
  801db3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dbe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dcc:	b8 07 00 00 00       	mov    $0x7,%eax
  801dd1:	e8 3d fe ff ff       	call   801c13 <nsipc>
  801dd6:	89 c3                	mov    %eax,%ebx
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	78 46                	js     801e22 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801ddc:	39 f0                	cmp    %esi,%eax
  801dde:	7f 07                	jg     801de7 <nsipc_recv+0x3c>
  801de0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801de5:	7e 24                	jle    801e0b <nsipc_recv+0x60>
  801de7:	c7 44 24 0c bf 2b 80 	movl   $0x802bbf,0xc(%esp)
  801dee:	00 
  801def:	c7 44 24 08 87 2b 80 	movl   $0x802b87,0x8(%esp)
  801df6:	00 
  801df7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801dfe:	00 
  801dff:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  801e06:	e8 eb 05 00 00       	call   8023f6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e16:	00 
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	89 04 24             	mov    %eax,(%esp)
  801e1d:	e8 72 eb ff ff       	call   800994 <memmove>
	}

	return r;
}
  801e22:	89 d8                	mov    %ebx,%eax
  801e24:	83 c4 10             	add    $0x10,%esp
  801e27:	5b                   	pop    %ebx
  801e28:	5e                   	pop    %esi
  801e29:	5d                   	pop    %ebp
  801e2a:	c3                   	ret    

00801e2b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	53                   	push   %ebx
  801e2f:	83 ec 14             	sub    $0x14,%esp
  801e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e3d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e43:	7e 24                	jle    801e69 <nsipc_send+0x3e>
  801e45:	c7 44 24 0c e0 2b 80 	movl   $0x802be0,0xc(%esp)
  801e4c:	00 
  801e4d:	c7 44 24 08 87 2b 80 	movl   $0x802b87,0x8(%esp)
  801e54:	00 
  801e55:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801e5c:	00 
  801e5d:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  801e64:	e8 8d 05 00 00       	call   8023f6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e69:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e74:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e7b:	e8 14 eb ff ff       	call   800994 <memmove>
	nsipcbuf.send.req_size = size;
  801e80:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e86:	8b 45 14             	mov    0x14(%ebp),%eax
  801e89:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e8e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e93:	e8 7b fd ff ff       	call   801c13 <nsipc>
}
  801e98:	83 c4 14             	add    $0x14,%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5d                   	pop    %ebp
  801e9d:	c3                   	ret    

00801e9e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eaf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801eb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ebc:	b8 09 00 00 00       	mov    $0x9,%eax
  801ec1:	e8 4d fd ff ff       	call   801c13 <nsipc>
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	56                   	push   %esi
  801ecc:	53                   	push   %ebx
  801ecd:	83 ec 10             	sub    $0x10,%esp
  801ed0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	89 04 24             	mov    %eax,(%esp)
  801ed9:	e8 72 f2 ff ff       	call   801150 <fd2data>
  801ede:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ee0:	c7 44 24 04 ec 2b 80 	movl   $0x802bec,0x4(%esp)
  801ee7:	00 
  801ee8:	89 1c 24             	mov    %ebx,(%esp)
  801eeb:	e8 07 e9 ff ff       	call   8007f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ef0:	8b 46 04             	mov    0x4(%esi),%eax
  801ef3:	2b 06                	sub    (%esi),%eax
  801ef5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801efb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f02:	00 00 00 
	stat->st_dev = &devpipe;
  801f05:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f0c:	30 80 00 
	return 0;
}
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	5b                   	pop    %ebx
  801f18:	5e                   	pop    %esi
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    

00801f1b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	53                   	push   %ebx
  801f1f:	83 ec 14             	sub    $0x14,%esp
  801f22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f25:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f30:	e8 85 ed ff ff       	call   800cba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f35:	89 1c 24             	mov    %ebx,(%esp)
  801f38:	e8 13 f2 ff ff       	call   801150 <fd2data>
  801f3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f48:	e8 6d ed ff ff       	call   800cba <sys_page_unmap>
}
  801f4d:	83 c4 14             	add    $0x14,%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5d                   	pop    %ebp
  801f52:	c3                   	ret    

00801f53 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	57                   	push   %edi
  801f57:	56                   	push   %esi
  801f58:	53                   	push   %ebx
  801f59:	83 ec 2c             	sub    $0x2c,%esp
  801f5c:	89 c6                	mov    %eax,%esi
  801f5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f61:	a1 08 40 80 00       	mov    0x804008,%eax
  801f66:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f69:	89 34 24             	mov    %esi,(%esp)
  801f6c:	e8 db 04 00 00       	call   80244c <pageref>
  801f71:	89 c7                	mov    %eax,%edi
  801f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f76:	89 04 24             	mov    %eax,(%esp)
  801f79:	e8 ce 04 00 00       	call   80244c <pageref>
  801f7e:	39 c7                	cmp    %eax,%edi
  801f80:	0f 94 c2             	sete   %dl
  801f83:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f86:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801f8c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f8f:	39 fb                	cmp    %edi,%ebx
  801f91:	74 21                	je     801fb4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f93:	84 d2                	test   %dl,%dl
  801f95:	74 ca                	je     801f61 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f97:	8b 51 58             	mov    0x58(%ecx),%edx
  801f9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f9e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fa2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fa6:	c7 04 24 f3 2b 80 00 	movl   $0x802bf3,(%esp)
  801fad:	e8 18 e2 ff ff       	call   8001ca <cprintf>
  801fb2:	eb ad                	jmp    801f61 <_pipeisclosed+0xe>
	}
}
  801fb4:	83 c4 2c             	add    $0x2c,%esp
  801fb7:	5b                   	pop    %ebx
  801fb8:	5e                   	pop    %esi
  801fb9:	5f                   	pop    %edi
  801fba:	5d                   	pop    %ebp
  801fbb:	c3                   	ret    

00801fbc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	57                   	push   %edi
  801fc0:	56                   	push   %esi
  801fc1:	53                   	push   %ebx
  801fc2:	83 ec 1c             	sub    $0x1c,%esp
  801fc5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fc8:	89 34 24             	mov    %esi,(%esp)
  801fcb:	e8 80 f1 ff ff       	call   801150 <fd2data>
  801fd0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fd2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd7:	eb 45                	jmp    80201e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fd9:	89 da                	mov    %ebx,%edx
  801fdb:	89 f0                	mov    %esi,%eax
  801fdd:	e8 71 ff ff ff       	call   801f53 <_pipeisclosed>
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	75 41                	jne    802027 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801fe6:	e8 09 ec ff ff       	call   800bf4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801feb:	8b 43 04             	mov    0x4(%ebx),%eax
  801fee:	8b 0b                	mov    (%ebx),%ecx
  801ff0:	8d 51 20             	lea    0x20(%ecx),%edx
  801ff3:	39 d0                	cmp    %edx,%eax
  801ff5:	73 e2                	jae    801fd9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ffa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ffe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802001:	99                   	cltd   
  802002:	c1 ea 1b             	shr    $0x1b,%edx
  802005:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802008:	83 e1 1f             	and    $0x1f,%ecx
  80200b:	29 d1                	sub    %edx,%ecx
  80200d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802011:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802015:	83 c0 01             	add    $0x1,%eax
  802018:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80201b:	83 c7 01             	add    $0x1,%edi
  80201e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802021:	75 c8                	jne    801feb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802023:	89 f8                	mov    %edi,%eax
  802025:	eb 05                	jmp    80202c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80202c:	83 c4 1c             	add    $0x1c,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    

00802034 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	57                   	push   %edi
  802038:	56                   	push   %esi
  802039:	53                   	push   %ebx
  80203a:	83 ec 1c             	sub    $0x1c,%esp
  80203d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802040:	89 3c 24             	mov    %edi,(%esp)
  802043:	e8 08 f1 ff ff       	call   801150 <fd2data>
  802048:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80204a:	be 00 00 00 00       	mov    $0x0,%esi
  80204f:	eb 3d                	jmp    80208e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802051:	85 f6                	test   %esi,%esi
  802053:	74 04                	je     802059 <devpipe_read+0x25>
				return i;
  802055:	89 f0                	mov    %esi,%eax
  802057:	eb 43                	jmp    80209c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802059:	89 da                	mov    %ebx,%edx
  80205b:	89 f8                	mov    %edi,%eax
  80205d:	e8 f1 fe ff ff       	call   801f53 <_pipeisclosed>
  802062:	85 c0                	test   %eax,%eax
  802064:	75 31                	jne    802097 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802066:	e8 89 eb ff ff       	call   800bf4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80206b:	8b 03                	mov    (%ebx),%eax
  80206d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802070:	74 df                	je     802051 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802072:	99                   	cltd   
  802073:	c1 ea 1b             	shr    $0x1b,%edx
  802076:	01 d0                	add    %edx,%eax
  802078:	83 e0 1f             	and    $0x1f,%eax
  80207b:	29 d0                	sub    %edx,%eax
  80207d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802082:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802085:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802088:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80208b:	83 c6 01             	add    $0x1,%esi
  80208e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802091:	75 d8                	jne    80206b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802093:	89 f0                	mov    %esi,%eax
  802095:	eb 05                	jmp    80209c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80209c:	83 c4 1c             	add    $0x1c,%esp
  80209f:	5b                   	pop    %ebx
  8020a0:	5e                   	pop    %esi
  8020a1:	5f                   	pop    %edi
  8020a2:	5d                   	pop    %ebp
  8020a3:	c3                   	ret    

008020a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	56                   	push   %esi
  8020a8:	53                   	push   %ebx
  8020a9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020af:	89 04 24             	mov    %eax,(%esp)
  8020b2:	e8 b0 f0 ff ff       	call   801167 <fd_alloc>
  8020b7:	89 c2                	mov    %eax,%edx
  8020b9:	85 d2                	test   %edx,%edx
  8020bb:	0f 88 4d 01 00 00    	js     80220e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020c8:	00 
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d7:	e8 37 eb ff ff       	call   800c13 <sys_page_alloc>
  8020dc:	89 c2                	mov    %eax,%edx
  8020de:	85 d2                	test   %edx,%edx
  8020e0:	0f 88 28 01 00 00    	js     80220e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8020e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020e9:	89 04 24             	mov    %eax,(%esp)
  8020ec:	e8 76 f0 ff ff       	call   801167 <fd_alloc>
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	0f 88 fe 00 00 00    	js     8021f9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802102:	00 
  802103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802106:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802111:	e8 fd ea ff ff       	call   800c13 <sys_page_alloc>
  802116:	89 c3                	mov    %eax,%ebx
  802118:	85 c0                	test   %eax,%eax
  80211a:	0f 88 d9 00 00 00    	js     8021f9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	89 04 24             	mov    %eax,(%esp)
  802126:	e8 25 f0 ff ff       	call   801150 <fd2data>
  80212b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80212d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802134:	00 
  802135:	89 44 24 04          	mov    %eax,0x4(%esp)
  802139:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802140:	e8 ce ea ff ff       	call   800c13 <sys_page_alloc>
  802145:	89 c3                	mov    %eax,%ebx
  802147:	85 c0                	test   %eax,%eax
  802149:	0f 88 97 00 00 00    	js     8021e6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80214f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802152:	89 04 24             	mov    %eax,(%esp)
  802155:	e8 f6 ef ff ff       	call   801150 <fd2data>
  80215a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802161:	00 
  802162:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802166:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80216d:	00 
  80216e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802179:	e8 e9 ea ff ff       	call   800c67 <sys_page_map>
  80217e:	89 c3                	mov    %eax,%ebx
  802180:	85 c0                	test   %eax,%eax
  802182:	78 52                	js     8021d6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802184:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802199:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	89 04 24             	mov    %eax,(%esp)
  8021b4:	e8 87 ef ff ff       	call   801140 <fd2num>
  8021b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c1:	89 04 24             	mov    %eax,(%esp)
  8021c4:	e8 77 ef ff ff       	call   801140 <fd2num>
  8021c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	eb 38                	jmp    80220e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8021d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e1:	e8 d4 ea ff ff       	call   800cba <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f4:	e8 c1 ea ff ff       	call   800cba <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802207:	e8 ae ea ff ff       	call   800cba <sys_page_unmap>
  80220c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80220e:	83 c4 30             	add    $0x30,%esp
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    

00802215 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80221b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	89 04 24             	mov    %eax,(%esp)
  802228:	e8 89 ef ff ff       	call   8011b6 <fd_lookup>
  80222d:	89 c2                	mov    %eax,%edx
  80222f:	85 d2                	test   %edx,%edx
  802231:	78 15                	js     802248 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 12 ef ff ff       	call   801150 <fd2data>
	return _pipeisclosed(fd, p);
  80223e:	89 c2                	mov    %eax,%edx
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	e8 0b fd ff ff       	call   801f53 <_pipeisclosed>
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    
  80224a:	66 90                	xchg   %ax,%ax
  80224c:	66 90                	xchg   %ax,%ax
  80224e:	66 90                	xchg   %ax,%ax

00802250 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    

0080225a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802260:	c7 44 24 04 0b 2c 80 	movl   $0x802c0b,0x4(%esp)
  802267:	00 
  802268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226b:	89 04 24             	mov    %eax,(%esp)
  80226e:	e8 84 e5 ff ff       	call   8007f7 <strcpy>
	return 0;
}
  802273:	b8 00 00 00 00       	mov    $0x0,%eax
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	57                   	push   %edi
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802286:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80228b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802291:	eb 31                	jmp    8022c4 <devcons_write+0x4a>
		m = n - tot;
  802293:	8b 75 10             	mov    0x10(%ebp),%esi
  802296:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802298:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80229b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8022a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022a7:	03 45 0c             	add    0xc(%ebp),%eax
  8022aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ae:	89 3c 24             	mov    %edi,(%esp)
  8022b1:	e8 de e6 ff ff       	call   800994 <memmove>
		sys_cputs(buf, m);
  8022b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ba:	89 3c 24             	mov    %edi,(%esp)
  8022bd:	e8 84 e8 ff ff       	call   800b46 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022c2:	01 f3                	add    %esi,%ebx
  8022c4:	89 d8                	mov    %ebx,%eax
  8022c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8022c9:	72 c8                	jb     802293 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8022cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8022d1:	5b                   	pop    %ebx
  8022d2:	5e                   	pop    %esi
  8022d3:	5f                   	pop    %edi
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    

008022d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8022e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022e5:	75 07                	jne    8022ee <devcons_read+0x18>
  8022e7:	eb 2a                	jmp    802313 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8022e9:	e8 06 e9 ff ff       	call   800bf4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8022ee:	66 90                	xchg   %ax,%ax
  8022f0:	e8 6f e8 ff ff       	call   800b64 <sys_cgetc>
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	74 f0                	je     8022e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	78 16                	js     802313 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8022fd:	83 f8 04             	cmp    $0x4,%eax
  802300:	74 0c                	je     80230e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802302:	8b 55 0c             	mov    0xc(%ebp),%edx
  802305:	88 02                	mov    %al,(%edx)
	return 1;
  802307:	b8 01 00 00 00       	mov    $0x1,%eax
  80230c:	eb 05                	jmp    802313 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802321:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802328:	00 
  802329:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80232c:	89 04 24             	mov    %eax,(%esp)
  80232f:	e8 12 e8 ff ff       	call   800b46 <sys_cputs>
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <getchar>:

int
getchar(void)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80233c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802343:	00 
  802344:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802352:	e8 f3 f0 ff ff       	call   80144a <read>
	if (r < 0)
  802357:	85 c0                	test   %eax,%eax
  802359:	78 0f                	js     80236a <getchar+0x34>
		return r;
	if (r < 1)
  80235b:	85 c0                	test   %eax,%eax
  80235d:	7e 06                	jle    802365 <getchar+0x2f>
		return -E_EOF;
	return c;
  80235f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802363:	eb 05                	jmp    80236a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802365:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802372:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802375:	89 44 24 04          	mov    %eax,0x4(%esp)
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	89 04 24             	mov    %eax,(%esp)
  80237f:	e8 32 ee ff ff       	call   8011b6 <fd_lookup>
  802384:	85 c0                	test   %eax,%eax
  802386:	78 11                	js     802399 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802391:	39 10                	cmp    %edx,(%eax)
  802393:	0f 94 c0             	sete   %al
  802396:	0f b6 c0             	movzbl %al,%eax
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <opencons>:

int
opencons(void)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023a4:	89 04 24             	mov    %eax,(%esp)
  8023a7:	e8 bb ed ff ff       	call   801167 <fd_alloc>
		return r;
  8023ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	78 40                	js     8023f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023b9:	00 
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c8:	e8 46 e8 ff ff       	call   800c13 <sys_page_alloc>
		return r;
  8023cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	78 1f                	js     8023f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8023d3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023e8:	89 04 24             	mov    %eax,(%esp)
  8023eb:	e8 50 ed ff ff       	call   801140 <fd2num>
  8023f0:	89 c2                	mov    %eax,%edx
}
  8023f2:	89 d0                	mov    %edx,%eax
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	56                   	push   %esi
  8023fa:	53                   	push   %ebx
  8023fb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8023fe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802401:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802407:	e8 c9 e7 ff ff       	call   800bd5 <sys_getenvid>
  80240c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802413:	8b 55 08             	mov    0x8(%ebp),%edx
  802416:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80241a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80241e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802422:	c7 04 24 18 2c 80 00 	movl   $0x802c18,(%esp)
  802429:	e8 9c dd ff ff       	call   8001ca <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80242e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802432:	8b 45 10             	mov    0x10(%ebp),%eax
  802435:	89 04 24             	mov    %eax,(%esp)
  802438:	e8 2c dd ff ff       	call   800169 <vcprintf>
	cprintf("\n");
  80243d:	c7 04 24 04 2c 80 00 	movl   $0x802c04,(%esp)
  802444:	e8 81 dd ff ff       	call   8001ca <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802449:	cc                   	int3   
  80244a:	eb fd                	jmp    802449 <_panic+0x53>

0080244c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802452:	89 d0                	mov    %edx,%eax
  802454:	c1 e8 16             	shr    $0x16,%eax
  802457:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802463:	f6 c1 01             	test   $0x1,%cl
  802466:	74 1d                	je     802485 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802468:	c1 ea 0c             	shr    $0xc,%edx
  80246b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802472:	f6 c2 01             	test   $0x1,%dl
  802475:	74 0e                	je     802485 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802477:	c1 ea 0c             	shr    $0xc,%edx
  80247a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802481:	ef 
  802482:	0f b7 c0             	movzwl %ax,%eax
}
  802485:	5d                   	pop    %ebp
  802486:	c3                   	ret    
  802487:	66 90                	xchg   %ax,%ax
  802489:	66 90                	xchg   %ax,%ax
  80248b:	66 90                	xchg   %ax,%ax
  80248d:	66 90                	xchg   %ax,%ax
  80248f:	90                   	nop

00802490 <__udivdi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	83 ec 0c             	sub    $0xc,%esp
  802496:	8b 44 24 28          	mov    0x28(%esp),%eax
  80249a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80249e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024ac:	89 ea                	mov    %ebp,%edx
  8024ae:	89 0c 24             	mov    %ecx,(%esp)
  8024b1:	75 2d                	jne    8024e0 <__udivdi3+0x50>
  8024b3:	39 e9                	cmp    %ebp,%ecx
  8024b5:	77 61                	ja     802518 <__udivdi3+0x88>
  8024b7:	85 c9                	test   %ecx,%ecx
  8024b9:	89 ce                	mov    %ecx,%esi
  8024bb:	75 0b                	jne    8024c8 <__udivdi3+0x38>
  8024bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c2:	31 d2                	xor    %edx,%edx
  8024c4:	f7 f1                	div    %ecx
  8024c6:	89 c6                	mov    %eax,%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	89 e8                	mov    %ebp,%eax
  8024cc:	f7 f6                	div    %esi
  8024ce:	89 c5                	mov    %eax,%ebp
  8024d0:	89 f8                	mov    %edi,%eax
  8024d2:	f7 f6                	div    %esi
  8024d4:	89 ea                	mov    %ebp,%edx
  8024d6:	83 c4 0c             	add    $0xc,%esp
  8024d9:	5e                   	pop    %esi
  8024da:	5f                   	pop    %edi
  8024db:	5d                   	pop    %ebp
  8024dc:	c3                   	ret    
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	39 e8                	cmp    %ebp,%eax
  8024e2:	77 24                	ja     802508 <__udivdi3+0x78>
  8024e4:	0f bd e8             	bsr    %eax,%ebp
  8024e7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ea:	75 3c                	jne    802528 <__udivdi3+0x98>
  8024ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024f0:	39 34 24             	cmp    %esi,(%esp)
  8024f3:	0f 86 9f 00 00 00    	jbe    802598 <__udivdi3+0x108>
  8024f9:	39 d0                	cmp    %edx,%eax
  8024fb:	0f 82 97 00 00 00    	jb     802598 <__udivdi3+0x108>
  802501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	31 c0                	xor    %eax,%eax
  80250c:	83 c4 0c             	add    $0xc,%esp
  80250f:	5e                   	pop    %esi
  802510:	5f                   	pop    %edi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    
  802513:	90                   	nop
  802514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802518:	89 f8                	mov    %edi,%eax
  80251a:	f7 f1                	div    %ecx
  80251c:	31 d2                	xor    %edx,%edx
  80251e:	83 c4 0c             	add    $0xc,%esp
  802521:	5e                   	pop    %esi
  802522:	5f                   	pop    %edi
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    
  802525:	8d 76 00             	lea    0x0(%esi),%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	8b 3c 24             	mov    (%esp),%edi
  80252d:	d3 e0                	shl    %cl,%eax
  80252f:	89 c6                	mov    %eax,%esi
  802531:	b8 20 00 00 00       	mov    $0x20,%eax
  802536:	29 e8                	sub    %ebp,%eax
  802538:	89 c1                	mov    %eax,%ecx
  80253a:	d3 ef                	shr    %cl,%edi
  80253c:	89 e9                	mov    %ebp,%ecx
  80253e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802542:	8b 3c 24             	mov    (%esp),%edi
  802545:	09 74 24 08          	or     %esi,0x8(%esp)
  802549:	89 d6                	mov    %edx,%esi
  80254b:	d3 e7                	shl    %cl,%edi
  80254d:	89 c1                	mov    %eax,%ecx
  80254f:	89 3c 24             	mov    %edi,(%esp)
  802552:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802556:	d3 ee                	shr    %cl,%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	d3 e2                	shl    %cl,%edx
  80255c:	89 c1                	mov    %eax,%ecx
  80255e:	d3 ef                	shr    %cl,%edi
  802560:	09 d7                	or     %edx,%edi
  802562:	89 f2                	mov    %esi,%edx
  802564:	89 f8                	mov    %edi,%eax
  802566:	f7 74 24 08          	divl   0x8(%esp)
  80256a:	89 d6                	mov    %edx,%esi
  80256c:	89 c7                	mov    %eax,%edi
  80256e:	f7 24 24             	mull   (%esp)
  802571:	39 d6                	cmp    %edx,%esi
  802573:	89 14 24             	mov    %edx,(%esp)
  802576:	72 30                	jb     8025a8 <__udivdi3+0x118>
  802578:	8b 54 24 04          	mov    0x4(%esp),%edx
  80257c:	89 e9                	mov    %ebp,%ecx
  80257e:	d3 e2                	shl    %cl,%edx
  802580:	39 c2                	cmp    %eax,%edx
  802582:	73 05                	jae    802589 <__udivdi3+0xf9>
  802584:	3b 34 24             	cmp    (%esp),%esi
  802587:	74 1f                	je     8025a8 <__udivdi3+0x118>
  802589:	89 f8                	mov    %edi,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	e9 7a ff ff ff       	jmp    80250c <__udivdi3+0x7c>
  802592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802598:	31 d2                	xor    %edx,%edx
  80259a:	b8 01 00 00 00       	mov    $0x1,%eax
  80259f:	e9 68 ff ff ff       	jmp    80250c <__udivdi3+0x7c>
  8025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	83 c4 0c             	add    $0xc,%esp
  8025b0:	5e                   	pop    %esi
  8025b1:	5f                   	pop    %edi
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    
  8025b4:	66 90                	xchg   %ax,%ax
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	66 90                	xchg   %ax,%ax
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__umoddi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	83 ec 14             	sub    $0x14,%esp
  8025c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025d2:	89 c7                	mov    %eax,%edi
  8025d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025e0:	89 34 24             	mov    %esi,(%esp)
  8025e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	89 c2                	mov    %eax,%edx
  8025eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ef:	75 17                	jne    802608 <__umoddi3+0x48>
  8025f1:	39 fe                	cmp    %edi,%esi
  8025f3:	76 4b                	jbe    802640 <__umoddi3+0x80>
  8025f5:	89 c8                	mov    %ecx,%eax
  8025f7:	89 fa                	mov    %edi,%edx
  8025f9:	f7 f6                	div    %esi
  8025fb:	89 d0                	mov    %edx,%eax
  8025fd:	31 d2                	xor    %edx,%edx
  8025ff:	83 c4 14             	add    $0x14,%esp
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	66 90                	xchg   %ax,%ax
  802608:	39 f8                	cmp    %edi,%eax
  80260a:	77 54                	ja     802660 <__umoddi3+0xa0>
  80260c:	0f bd e8             	bsr    %eax,%ebp
  80260f:	83 f5 1f             	xor    $0x1f,%ebp
  802612:	75 5c                	jne    802670 <__umoddi3+0xb0>
  802614:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802618:	39 3c 24             	cmp    %edi,(%esp)
  80261b:	0f 87 e7 00 00 00    	ja     802708 <__umoddi3+0x148>
  802621:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802625:	29 f1                	sub    %esi,%ecx
  802627:	19 c7                	sbb    %eax,%edi
  802629:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80262d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802631:	8b 44 24 08          	mov    0x8(%esp),%eax
  802635:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802639:	83 c4 14             	add    $0x14,%esp
  80263c:	5e                   	pop    %esi
  80263d:	5f                   	pop    %edi
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    
  802640:	85 f6                	test   %esi,%esi
  802642:	89 f5                	mov    %esi,%ebp
  802644:	75 0b                	jne    802651 <__umoddi3+0x91>
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	f7 f6                	div    %esi
  80264f:	89 c5                	mov    %eax,%ebp
  802651:	8b 44 24 04          	mov    0x4(%esp),%eax
  802655:	31 d2                	xor    %edx,%edx
  802657:	f7 f5                	div    %ebp
  802659:	89 c8                	mov    %ecx,%eax
  80265b:	f7 f5                	div    %ebp
  80265d:	eb 9c                	jmp    8025fb <__umoddi3+0x3b>
  80265f:	90                   	nop
  802660:	89 c8                	mov    %ecx,%eax
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 14             	add    $0x14,%esp
  802667:	5e                   	pop    %esi
  802668:	5f                   	pop    %edi
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    
  80266b:	90                   	nop
  80266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802670:	8b 04 24             	mov    (%esp),%eax
  802673:	be 20 00 00 00       	mov    $0x20,%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	29 ee                	sub    %ebp,%esi
  80267c:	d3 e2                	shl    %cl,%edx
  80267e:	89 f1                	mov    %esi,%ecx
  802680:	d3 e8                	shr    %cl,%eax
  802682:	89 e9                	mov    %ebp,%ecx
  802684:	89 44 24 04          	mov    %eax,0x4(%esp)
  802688:	8b 04 24             	mov    (%esp),%eax
  80268b:	09 54 24 04          	or     %edx,0x4(%esp)
  80268f:	89 fa                	mov    %edi,%edx
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 f1                	mov    %esi,%ecx
  802695:	89 44 24 08          	mov    %eax,0x8(%esp)
  802699:	8b 44 24 10          	mov    0x10(%esp),%eax
  80269d:	d3 ea                	shr    %cl,%edx
  80269f:	89 e9                	mov    %ebp,%ecx
  8026a1:	d3 e7                	shl    %cl,%edi
  8026a3:	89 f1                	mov    %esi,%ecx
  8026a5:	d3 e8                	shr    %cl,%eax
  8026a7:	89 e9                	mov    %ebp,%ecx
  8026a9:	09 f8                	or     %edi,%eax
  8026ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026af:	f7 74 24 04          	divl   0x4(%esp)
  8026b3:	d3 e7                	shl    %cl,%edi
  8026b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026b9:	89 d7                	mov    %edx,%edi
  8026bb:	f7 64 24 08          	mull   0x8(%esp)
  8026bf:	39 d7                	cmp    %edx,%edi
  8026c1:	89 c1                	mov    %eax,%ecx
  8026c3:	89 14 24             	mov    %edx,(%esp)
  8026c6:	72 2c                	jb     8026f4 <__umoddi3+0x134>
  8026c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026cc:	72 22                	jb     8026f0 <__umoddi3+0x130>
  8026ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026d2:	29 c8                	sub    %ecx,%eax
  8026d4:	19 d7                	sbb    %edx,%edi
  8026d6:	89 e9                	mov    %ebp,%ecx
  8026d8:	89 fa                	mov    %edi,%edx
  8026da:	d3 e8                	shr    %cl,%eax
  8026dc:	89 f1                	mov    %esi,%ecx
  8026de:	d3 e2                	shl    %cl,%edx
  8026e0:	89 e9                	mov    %ebp,%ecx
  8026e2:	d3 ef                	shr    %cl,%edi
  8026e4:	09 d0                	or     %edx,%eax
  8026e6:	89 fa                	mov    %edi,%edx
  8026e8:	83 c4 14             	add    $0x14,%esp
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    
  8026ef:	90                   	nop
  8026f0:	39 d7                	cmp    %edx,%edi
  8026f2:	75 da                	jne    8026ce <__umoddi3+0x10e>
  8026f4:	8b 14 24             	mov    (%esp),%edx
  8026f7:	89 c1                	mov    %eax,%ecx
  8026f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802701:	eb cb                	jmp    8026ce <__umoddi3+0x10e>
  802703:	90                   	nop
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80270c:	0f 82 0f ff ff ff    	jb     802621 <__umoddi3+0x61>
  802712:	e9 1a ff ff ff       	jmp    802631 <__umoddi3+0x71>
