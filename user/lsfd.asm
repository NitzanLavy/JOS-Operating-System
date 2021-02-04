
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 01 01 00 00       	call   800132 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	c7 04 24 20 2a 80 00 	movl   $0x802a20,(%esp)
  800040:	e8 f5 01 00 00       	call   80023a <cprintf>
	exit();
  800045:	e8 34 01 00 00       	call   80017e <exit>
}
  80004a:	c9                   	leave  
  80004b:	c3                   	ret    

0080004c <umain>:

void
umain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	57                   	push   %edi
  800050:	56                   	push   %esi
  800051:	53                   	push   %ebx
  800052:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800058:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800062:	8b 45 0c             	mov    0xc(%ebp),%eax
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	8d 45 08             	lea    0x8(%ebp),%eax
  80006c:	89 04 24             	mov    %eax,(%esp)
  80006f:	e8 34 10 00 00       	call   8010a8 <argstart>
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
  800074:	be 00 00 00 00       	mov    $0x0,%esi
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800079:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
  80007f:	eb 11                	jmp    800092 <umain+0x46>
		if (i == '1')
  800081:	83 f8 31             	cmp    $0x31,%eax
  800084:	75 07                	jne    80008d <umain+0x41>
			usefprint = 1;
  800086:	be 01 00 00 00       	mov    $0x1,%esi
  80008b:	eb 05                	jmp    800092 <umain+0x46>
		else
			usage();
  80008d:	e8 a1 ff ff ff       	call   800033 <usage>
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800092:	89 1c 24             	mov    %ebx,(%esp)
  800095:	e8 46 10 00 00       	call   8010e0 <argnext>
  80009a:	85 c0                	test   %eax,%eax
  80009c:	79 e3                	jns    800081 <umain+0x35>
  80009e:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000a3:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000ad:	89 1c 24             	mov    %ebx,(%esp)
  8000b0:	e8 81 16 00 00       	call   801736 <fstat>
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	78 66                	js     80011f <umain+0xd3>
			if (usefprint)
  8000b9:	85 f6                	test   %esi,%esi
  8000bb:	74 36                	je     8000f3 <umain+0xa7>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c0:	8b 40 04             	mov    0x4(%eax),%eax
  8000c3:	89 44 24 18          	mov    %eax,0x18(%esp)
  8000c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000ca:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000dd:	c7 44 24 04 34 2a 80 	movl   $0x802a34,0x4(%esp)
  8000e4:	00 
  8000e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ec:	e8 84 1a 00 00       	call   801b75 <fprintf>
  8000f1:	eb 2c                	jmp    80011f <umain+0xd3>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f6:	8b 40 04             	mov    0x4(%eax),%eax
  8000f9:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800100:	89 44 24 10          	mov    %eax,0x10(%esp)
  800104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800107:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80010b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80010f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800113:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  80011a:	e8 1b 01 00 00       	call   80023a <cprintf>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  80011f:	83 c3 01             	add    $0x1,%ebx
  800122:	83 fb 20             	cmp    $0x20,%ebx
  800125:	75 82                	jne    8000a9 <umain+0x5d>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800127:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	56                   	push   %esi
  800136:	53                   	push   %ebx
  800137:	83 ec 10             	sub    $0x10,%esp
  80013a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800140:	e8 00 0b 00 00       	call   800c45 <sys_getenvid>
  800145:	25 ff 03 00 00       	and    $0x3ff,%eax
  80014a:	89 c2                	mov    %eax,%edx
  80014c:	c1 e2 07             	shl    $0x7,%edx
  80014f:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800156:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015b:	85 db                	test   %ebx,%ebx
  80015d:	7e 07                	jle    800166 <libmain+0x34>
		binaryname = argv[0];
  80015f:	8b 06                	mov    (%esi),%eax
  800161:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800166:	89 74 24 04          	mov    %esi,0x4(%esp)
  80016a:	89 1c 24             	mov    %ebx,(%esp)
  80016d:	e8 da fe ff ff       	call   80004c <umain>

	// exit gracefully
	exit();
  800172:	e8 07 00 00 00       	call   80017e <exit>
}
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	5b                   	pop    %ebx
  80017b:	5e                   	pop    %esi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    

0080017e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800184:	e8 61 12 00 00       	call   8013ea <close_all>
	sys_env_destroy(0);
  800189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800190:	e8 5e 0a 00 00       	call   800bf3 <sys_env_destroy>
}
  800195:	c9                   	leave  
  800196:	c3                   	ret    

00800197 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	83 ec 14             	sub    $0x14,%esp
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a1:	8b 13                	mov    (%ebx),%edx
  8001a3:	8d 42 01             	lea    0x1(%edx),%eax
  8001a6:	89 03                	mov    %eax,(%ebx)
  8001a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	75 19                	jne    8001cf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001b6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001bd:	00 
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	89 04 24             	mov    %eax,(%esp)
  8001c4:	e8 ed 09 00 00       	call   800bb6 <sys_cputs>
		b->idx = 0;
  8001c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d3:	83 c4 14             	add    $0x14,%esp
  8001d6:	5b                   	pop    %ebx
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    

008001d9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e9:	00 00 00 
	b.cnt = 0;
  8001ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800200:	89 44 24 08          	mov    %eax,0x8(%esp)
  800204:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020e:	c7 04 24 97 01 80 00 	movl   $0x800197,(%esp)
  800215:	e8 b4 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80021a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800220:	89 44 24 04          	mov    %eax,0x4(%esp)
  800224:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022a:	89 04 24             	mov    %eax,(%esp)
  80022d:	e8 84 09 00 00       	call   800bb6 <sys_cputs>

	return b.cnt;
}
  800232:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800240:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800243:	89 44 24 04          	mov    %eax,0x4(%esp)
  800247:	8b 45 08             	mov    0x8(%ebp),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 87 ff ff ff       	call   8001d9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800252:	c9                   	leave  
  800253:	c3                   	ret    
  800254:	66 90                	xchg   %ax,%ax
  800256:	66 90                	xchg   %ax,%ax
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
  8002cf:	e8 bc 24 00 00       	call   802790 <__udivdi3>
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
  80032f:	e8 8c 25 00 00       	call   8028c0 <__umoddi3>
  800334:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800338:	0f be 80 66 2a 80 00 	movsbl 0x802a66(%eax),%eax
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
  800453:	ff 24 8d e0 2b 80 00 	jmp    *0x802be0(,%ecx,4)
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
  8004f0:	8b 14 85 40 2d 80 00 	mov    0x802d40(,%eax,4),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	75 20                	jne    80051b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ff:	c7 44 24 08 7e 2a 80 	movl   $0x802a7e,0x8(%esp)
  800506:	00 
  800507:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	e8 90 fe ff ff       	call   8003a6 <printfmt>
  800516:	e9 d8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80051b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051f:	c7 44 24 08 81 2e 80 	movl   $0x802e81,0x8(%esp)
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
  800551:	b8 77 2a 80 00       	mov    $0x802a77,%eax
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
  800c21:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800c28:	00 
  800c29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c30:	00 
  800c31:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800c38:	e8 b9 19 00 00       	call   8025f6 <_panic>

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
  800cb3:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800cba:	00 
  800cbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc2:	00 
  800cc3:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800cca:	e8 27 19 00 00       	call   8025f6 <_panic>

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
  800d06:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800d0d:	00 
  800d0e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d15:	00 
  800d16:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800d1d:	e8 d4 18 00 00       	call   8025f6 <_panic>

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
  800d59:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800d60:	00 
  800d61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d68:	00 
  800d69:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800d70:	e8 81 18 00 00       	call   8025f6 <_panic>

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
  800dac:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800db3:	00 
  800db4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbb:	00 
  800dbc:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800dc3:	e8 2e 18 00 00       	call   8025f6 <_panic>

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
  800dff:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800e06:	00 
  800e07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0e:	00 
  800e0f:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800e16:	e8 db 17 00 00       	call   8025f6 <_panic>

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
  800e52:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800e59:	00 
  800e5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e61:	00 
  800e62:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800e69:	e8 88 17 00 00       	call   8025f6 <_panic>

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
  800ec7:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800ece:	00 
  800ecf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed6:	00 
  800ed7:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800ede:	e8 13 17 00 00       	call   8025f6 <_panic>

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
  800f39:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800f50:	e8 a1 16 00 00       	call   8025f6 <_panic>

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
  800f8c:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800fa3:	e8 4e 16 00 00       	call   8025f6 <_panic>

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
  800fdf:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  800fe6:	00 
  800fe7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fee:	00 
  800fef:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  800ff6:	e8 fb 15 00 00       	call   8025f6 <_panic>

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
  801031:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  801038:	00 
  801039:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801040:	00 
  801041:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  801048:	e8 a9 15 00 00       	call   8025f6 <_panic>

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
  801084:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  80108b:	00 
  80108c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801093:	00 
  801094:	c7 04 24 c8 2d 80 00 	movl   $0x802dc8,(%esp)
  80109b:	e8 56 15 00 00       	call   8025f6 <_panic>

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

008010a8 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	53                   	push   %ebx
  8010ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8010b5:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  8010b7:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	83 39 01             	cmpl   $0x1,(%ecx)
  8010c2:	7e 0f                	jle    8010d3 <argstart+0x2b>
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cb:	bb 31 2a 80 00       	mov    $0x802a31,%ebx
  8010d0:	0f 44 da             	cmove  %edx,%ebx
  8010d3:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  8010d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8010dd:	5b                   	pop    %ebx
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <argnext>:

int
argnext(struct Argstate *args)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 14             	sub    $0x14,%esp
  8010e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8010ea:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8010f1:	8b 43 08             	mov    0x8(%ebx),%eax
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	74 71                	je     801169 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  8010f8:	80 38 00             	cmpb   $0x0,(%eax)
  8010fb:	75 50                	jne    80114d <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8010fd:	8b 0b                	mov    (%ebx),%ecx
  8010ff:	83 39 01             	cmpl   $0x1,(%ecx)
  801102:	74 57                	je     80115b <argnext+0x7b>
		    || args->argv[1][0] != '-'
  801104:	8b 53 04             	mov    0x4(%ebx),%edx
  801107:	8b 42 04             	mov    0x4(%edx),%eax
  80110a:	80 38 2d             	cmpb   $0x2d,(%eax)
  80110d:	75 4c                	jne    80115b <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  80110f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801113:	74 46                	je     80115b <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801115:	83 c0 01             	add    $0x1,%eax
  801118:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80111b:	8b 01                	mov    (%ecx),%eax
  80111d:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801124:	89 44 24 08          	mov    %eax,0x8(%esp)
  801128:	8d 42 08             	lea    0x8(%edx),%eax
  80112b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80112f:	83 c2 04             	add    $0x4,%edx
  801132:	89 14 24             	mov    %edx,(%esp)
  801135:	e8 ca f8 ff ff       	call   800a04 <memmove>
		(*args->argc)--;
  80113a:	8b 03                	mov    (%ebx),%eax
  80113c:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80113f:	8b 43 08             	mov    0x8(%ebx),%eax
  801142:	80 38 2d             	cmpb   $0x2d,(%eax)
  801145:	75 06                	jne    80114d <argnext+0x6d>
  801147:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80114b:	74 0e                	je     80115b <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80114d:	8b 53 08             	mov    0x8(%ebx),%edx
  801150:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801153:	83 c2 01             	add    $0x1,%edx
  801156:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801159:	eb 13                	jmp    80116e <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  80115b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801167:	eb 05                	jmp    80116e <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801169:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80116e:	83 c4 14             	add    $0x14,%esp
  801171:	5b                   	pop    %ebx
  801172:	5d                   	pop    %ebp
  801173:	c3                   	ret    

00801174 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	53                   	push   %ebx
  801178:	83 ec 14             	sub    $0x14,%esp
  80117b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80117e:	8b 43 08             	mov    0x8(%ebx),%eax
  801181:	85 c0                	test   %eax,%eax
  801183:	74 5a                	je     8011df <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801185:	80 38 00             	cmpb   $0x0,(%eax)
  801188:	74 0c                	je     801196 <argnextvalue+0x22>
		args->argvalue = args->curarg;
  80118a:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  80118d:	c7 43 08 31 2a 80 00 	movl   $0x802a31,0x8(%ebx)
  801194:	eb 44                	jmp    8011da <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  801196:	8b 03                	mov    (%ebx),%eax
  801198:	83 38 01             	cmpl   $0x1,(%eax)
  80119b:	7e 2f                	jle    8011cc <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  80119d:	8b 53 04             	mov    0x4(%ebx),%edx
  8011a0:	8b 4a 04             	mov    0x4(%edx),%ecx
  8011a3:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011a6:	8b 00                	mov    (%eax),%eax
  8011a8:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8011af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011b3:	8d 42 08             	lea    0x8(%edx),%eax
  8011b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ba:	83 c2 04             	add    $0x4,%edx
  8011bd:	89 14 24             	mov    %edx,(%esp)
  8011c0:	e8 3f f8 ff ff       	call   800a04 <memmove>
		(*args->argc)--;
  8011c5:	8b 03                	mov    (%ebx),%eax
  8011c7:	83 28 01             	subl   $0x1,(%eax)
  8011ca:	eb 0e                	jmp    8011da <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  8011cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8011d3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8011da:	8b 43 0c             	mov    0xc(%ebx),%eax
  8011dd:	eb 05                	jmp    8011e4 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  8011df:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  8011e4:	83 c4 14             	add    $0x14,%esp
  8011e7:	5b                   	pop    %ebx
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    

008011ea <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	83 ec 18             	sub    $0x18,%esp
  8011f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011f3:	8b 51 0c             	mov    0xc(%ecx),%edx
  8011f6:	89 d0                	mov    %edx,%eax
  8011f8:	85 d2                	test   %edx,%edx
  8011fa:	75 08                	jne    801204 <argvalue+0x1a>
  8011fc:	89 0c 24             	mov    %ecx,(%esp)
  8011ff:	e8 70 ff ff ff       	call   801174 <argnextvalue>
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    
  801206:	66 90                	xchg   %ax,%ax
  801208:	66 90                	xchg   %ax,%ax
  80120a:	66 90                	xchg   %ax,%ax
  80120c:	66 90                	xchg   %ax,%ax
  80120e:	66 90                	xchg   %ax,%ax

00801210 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	05 00 00 00 30       	add    $0x30000000,%eax
  80121b:	c1 e8 0c             	shr    $0xc,%eax
}
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80122b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801230:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801235:	5d                   	pop    %ebp
  801236:	c3                   	ret    

00801237 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801242:	89 c2                	mov    %eax,%edx
  801244:	c1 ea 16             	shr    $0x16,%edx
  801247:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80124e:	f6 c2 01             	test   $0x1,%dl
  801251:	74 11                	je     801264 <fd_alloc+0x2d>
  801253:	89 c2                	mov    %eax,%edx
  801255:	c1 ea 0c             	shr    $0xc,%edx
  801258:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80125f:	f6 c2 01             	test   $0x1,%dl
  801262:	75 09                	jne    80126d <fd_alloc+0x36>
			*fd_store = fd;
  801264:	89 01                	mov    %eax,(%ecx)
			return 0;
  801266:	b8 00 00 00 00       	mov    $0x0,%eax
  80126b:	eb 17                	jmp    801284 <fd_alloc+0x4d>
  80126d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801272:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801277:	75 c9                	jne    801242 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801279:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80127f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80128c:	83 f8 1f             	cmp    $0x1f,%eax
  80128f:	77 36                	ja     8012c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801291:	c1 e0 0c             	shl    $0xc,%eax
  801294:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801299:	89 c2                	mov    %eax,%edx
  80129b:	c1 ea 16             	shr    $0x16,%edx
  80129e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012a5:	f6 c2 01             	test   $0x1,%dl
  8012a8:	74 24                	je     8012ce <fd_lookup+0x48>
  8012aa:	89 c2                	mov    %eax,%edx
  8012ac:	c1 ea 0c             	shr    $0xc,%edx
  8012af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012b6:	f6 c2 01             	test   $0x1,%dl
  8012b9:	74 1a                	je     8012d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	89 02                	mov    %eax,(%edx)
	return 0;
  8012c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c5:	eb 13                	jmp    8012da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8012c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012cc:	eb 0c                	jmp    8012da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8012ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d3:	eb 05                	jmp    8012da <fd_lookup+0x54>
  8012d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	83 ec 18             	sub    $0x18,%esp
  8012e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ea:	eb 13                	jmp    8012ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8012ec:	39 08                	cmp    %ecx,(%eax)
  8012ee:	75 0c                	jne    8012fc <dev_lookup+0x20>
			*dev = devtab[i];
  8012f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb 38                	jmp    801334 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8012fc:	83 c2 01             	add    $0x1,%edx
  8012ff:	8b 04 95 54 2e 80 00 	mov    0x802e54(,%edx,4),%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	75 e2                	jne    8012ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80130a:	a1 08 40 80 00       	mov    0x804008,%eax
  80130f:	8b 40 48             	mov    0x48(%eax),%eax
  801312:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801316:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131a:	c7 04 24 d8 2d 80 00 	movl   $0x802dd8,(%esp)
  801321:	e8 14 ef ff ff       	call   80023a <cprintf>
	*dev = 0;
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80132f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	83 ec 20             	sub    $0x20,%esp
  80133e:	8b 75 08             	mov    0x8(%ebp),%esi
  801341:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801344:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801347:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80134b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801351:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801354:	89 04 24             	mov    %eax,(%esp)
  801357:	e8 2a ff ff ff       	call   801286 <fd_lookup>
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 05                	js     801365 <fd_close+0x2f>
	    || fd != fd2)
  801360:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801363:	74 0c                	je     801371 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801365:	84 db                	test   %bl,%bl
  801367:	ba 00 00 00 00       	mov    $0x0,%edx
  80136c:	0f 44 c2             	cmove  %edx,%eax
  80136f:	eb 3f                	jmp    8013b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801371:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801374:	89 44 24 04          	mov    %eax,0x4(%esp)
  801378:	8b 06                	mov    (%esi),%eax
  80137a:	89 04 24             	mov    %eax,(%esp)
  80137d:	e8 5a ff ff ff       	call   8012dc <dev_lookup>
  801382:	89 c3                	mov    %eax,%ebx
  801384:	85 c0                	test   %eax,%eax
  801386:	78 16                	js     80139e <fd_close+0x68>
		if (dev->dev_close)
  801388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80138e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801393:	85 c0                	test   %eax,%eax
  801395:	74 07                	je     80139e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801397:	89 34 24             	mov    %esi,(%esp)
  80139a:	ff d0                	call   *%eax
  80139c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80139e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a9:	e8 7c f9 ff ff       	call   800d2a <sys_page_unmap>
	return r;
  8013ae:	89 d8                	mov    %ebx,%eax
}
  8013b0:	83 c4 20             	add    $0x20,%esp
  8013b3:	5b                   	pop    %ebx
  8013b4:	5e                   	pop    %esi
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	89 04 24             	mov    %eax,(%esp)
  8013ca:	e8 b7 fe ff ff       	call   801286 <fd_lookup>
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	85 d2                	test   %edx,%edx
  8013d3:	78 13                	js     8013e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8013d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013dc:	00 
  8013dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e0:	89 04 24             	mov    %eax,(%esp)
  8013e3:	e8 4e ff ff ff       	call   801336 <fd_close>
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <close_all>:

void
close_all(void)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	53                   	push   %ebx
  8013ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013f6:	89 1c 24             	mov    %ebx,(%esp)
  8013f9:	e8 b9 ff ff ff       	call   8013b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8013fe:	83 c3 01             	add    $0x1,%ebx
  801401:	83 fb 20             	cmp    $0x20,%ebx
  801404:	75 f0                	jne    8013f6 <close_all+0xc>
		close(i);
}
  801406:	83 c4 14             	add    $0x14,%esp
  801409:	5b                   	pop    %ebx
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801415:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801418:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	89 04 24             	mov    %eax,(%esp)
  801422:	e8 5f fe ff ff       	call   801286 <fd_lookup>
  801427:	89 c2                	mov    %eax,%edx
  801429:	85 d2                	test   %edx,%edx
  80142b:	0f 88 e1 00 00 00    	js     801512 <dup+0x106>
		return r;
	close(newfdnum);
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	89 04 24             	mov    %eax,(%esp)
  801437:	e8 7b ff ff ff       	call   8013b7 <close>

	newfd = INDEX2FD(newfdnum);
  80143c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80143f:	c1 e3 0c             	shl    $0xc,%ebx
  801442:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144b:	89 04 24             	mov    %eax,(%esp)
  80144e:	e8 cd fd ff ff       	call   801220 <fd2data>
  801453:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801455:	89 1c 24             	mov    %ebx,(%esp)
  801458:	e8 c3 fd ff ff       	call   801220 <fd2data>
  80145d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80145f:	89 f0                	mov    %esi,%eax
  801461:	c1 e8 16             	shr    $0x16,%eax
  801464:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80146b:	a8 01                	test   $0x1,%al
  80146d:	74 43                	je     8014b2 <dup+0xa6>
  80146f:	89 f0                	mov    %esi,%eax
  801471:	c1 e8 0c             	shr    $0xc,%eax
  801474:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80147b:	f6 c2 01             	test   $0x1,%dl
  80147e:	74 32                	je     8014b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801480:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801487:	25 07 0e 00 00       	and    $0xe07,%eax
  80148c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801490:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801494:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80149b:	00 
  80149c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a7:	e8 2b f8 ff ff       	call   800cd7 <sys_page_map>
  8014ac:	89 c6                	mov    %eax,%esi
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 3e                	js     8014f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b5:	89 c2                	mov    %eax,%edx
  8014b7:	c1 ea 0c             	shr    $0xc,%edx
  8014ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8014c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014d6:	00 
  8014d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014e2:	e8 f0 f7 ff ff       	call   800cd7 <sys_page_map>
  8014e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8014e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014ec:	85 f6                	test   %esi,%esi
  8014ee:	79 22                	jns    801512 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8014f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014fb:	e8 2a f8 ff ff       	call   800d2a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801500:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801504:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80150b:	e8 1a f8 ff ff       	call   800d2a <sys_page_unmap>
	return r;
  801510:	89 f0                	mov    %esi,%eax
}
  801512:	83 c4 3c             	add    $0x3c,%esp
  801515:	5b                   	pop    %ebx
  801516:	5e                   	pop    %esi
  801517:	5f                   	pop    %edi
  801518:	5d                   	pop    %ebp
  801519:	c3                   	ret    

0080151a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	53                   	push   %ebx
  80151e:	83 ec 24             	sub    $0x24,%esp
  801521:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801524:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801527:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152b:	89 1c 24             	mov    %ebx,(%esp)
  80152e:	e8 53 fd ff ff       	call   801286 <fd_lookup>
  801533:	89 c2                	mov    %eax,%edx
  801535:	85 d2                	test   %edx,%edx
  801537:	78 6d                	js     8015a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801539:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801543:	8b 00                	mov    (%eax),%eax
  801545:	89 04 24             	mov    %eax,(%esp)
  801548:	e8 8f fd ff ff       	call   8012dc <dev_lookup>
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 55                	js     8015a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801554:	8b 50 08             	mov    0x8(%eax),%edx
  801557:	83 e2 03             	and    $0x3,%edx
  80155a:	83 fa 01             	cmp    $0x1,%edx
  80155d:	75 23                	jne    801582 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80155f:	a1 08 40 80 00       	mov    0x804008,%eax
  801564:	8b 40 48             	mov    0x48(%eax),%eax
  801567:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80156b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156f:	c7 04 24 19 2e 80 00 	movl   $0x802e19,(%esp)
  801576:	e8 bf ec ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  80157b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801580:	eb 24                	jmp    8015a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801585:	8b 52 08             	mov    0x8(%edx),%edx
  801588:	85 d2                	test   %edx,%edx
  80158a:	74 15                	je     8015a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80158c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801593:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801596:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80159a:	89 04 24             	mov    %eax,(%esp)
  80159d:	ff d2                	call   *%edx
  80159f:	eb 05                	jmp    8015a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8015a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8015a6:	83 c4 24             	add    $0x24,%esp
  8015a9:	5b                   	pop    %ebx
  8015aa:	5d                   	pop    %ebp
  8015ab:	c3                   	ret    

008015ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	57                   	push   %edi
  8015b0:	56                   	push   %esi
  8015b1:	53                   	push   %ebx
  8015b2:	83 ec 1c             	sub    $0x1c,%esp
  8015b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c0:	eb 23                	jmp    8015e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c2:	89 f0                	mov    %esi,%eax
  8015c4:	29 d8                	sub    %ebx,%eax
  8015c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015ca:	89 d8                	mov    %ebx,%eax
  8015cc:	03 45 0c             	add    0xc(%ebp),%eax
  8015cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d3:	89 3c 24             	mov    %edi,(%esp)
  8015d6:	e8 3f ff ff ff       	call   80151a <read>
		if (m < 0)
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 10                	js     8015ef <readn+0x43>
			return m;
		if (m == 0)
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	74 0a                	je     8015ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015e3:	01 c3                	add    %eax,%ebx
  8015e5:	39 f3                	cmp    %esi,%ebx
  8015e7:	72 d9                	jb     8015c2 <readn+0x16>
  8015e9:	89 d8                	mov    %ebx,%eax
  8015eb:	eb 02                	jmp    8015ef <readn+0x43>
  8015ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015ef:	83 c4 1c             	add    $0x1c,%esp
  8015f2:	5b                   	pop    %ebx
  8015f3:	5e                   	pop    %esi
  8015f4:	5f                   	pop    %edi
  8015f5:	5d                   	pop    %ebp
  8015f6:	c3                   	ret    

008015f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	53                   	push   %ebx
  8015fb:	83 ec 24             	sub    $0x24,%esp
  8015fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801601:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801604:	89 44 24 04          	mov    %eax,0x4(%esp)
  801608:	89 1c 24             	mov    %ebx,(%esp)
  80160b:	e8 76 fc ff ff       	call   801286 <fd_lookup>
  801610:	89 c2                	mov    %eax,%edx
  801612:	85 d2                	test   %edx,%edx
  801614:	78 68                	js     80167e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801616:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801619:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801620:	8b 00                	mov    (%eax),%eax
  801622:	89 04 24             	mov    %eax,(%esp)
  801625:	e8 b2 fc ff ff       	call   8012dc <dev_lookup>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 50                	js     80167e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80162e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801631:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801635:	75 23                	jne    80165a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801637:	a1 08 40 80 00       	mov    0x804008,%eax
  80163c:	8b 40 48             	mov    0x48(%eax),%eax
  80163f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801643:	89 44 24 04          	mov    %eax,0x4(%esp)
  801647:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  80164e:	e8 e7 eb ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  801653:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801658:	eb 24                	jmp    80167e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80165a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165d:	8b 52 0c             	mov    0xc(%edx),%edx
  801660:	85 d2                	test   %edx,%edx
  801662:	74 15                	je     801679 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801664:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801667:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80166b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80166e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801672:	89 04 24             	mov    %eax,(%esp)
  801675:	ff d2                	call   *%edx
  801677:	eb 05                	jmp    80167e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801679:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80167e:	83 c4 24             	add    $0x24,%esp
  801681:	5b                   	pop    %ebx
  801682:	5d                   	pop    %ebp
  801683:	c3                   	ret    

00801684 <seek>:

int
seek(int fdnum, off_t offset)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80168d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	89 04 24             	mov    %eax,(%esp)
  801697:	e8 ea fb ff ff       	call   801286 <fd_lookup>
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 0e                	js     8016ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8016a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 24             	sub    $0x24,%esp
  8016b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c1:	89 1c 24             	mov    %ebx,(%esp)
  8016c4:	e8 bd fb ff ff       	call   801286 <fd_lookup>
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	85 d2                	test   %edx,%edx
  8016cd:	78 61                	js     801730 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d9:	8b 00                	mov    (%eax),%eax
  8016db:	89 04 24             	mov    %eax,(%esp)
  8016de:	e8 f9 fb ff ff       	call   8012dc <dev_lookup>
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 49                	js     801730 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ee:	75 23                	jne    801713 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016f0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016f5:	8b 40 48             	mov    0x48(%eax),%eax
  8016f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801700:	c7 04 24 f8 2d 80 00 	movl   $0x802df8,(%esp)
  801707:	e8 2e eb ff ff       	call   80023a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80170c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801711:	eb 1d                	jmp    801730 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801713:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801716:	8b 52 18             	mov    0x18(%edx),%edx
  801719:	85 d2                	test   %edx,%edx
  80171b:	74 0e                	je     80172b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80171d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801720:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801724:	89 04 24             	mov    %eax,(%esp)
  801727:	ff d2                	call   *%edx
  801729:	eb 05                	jmp    801730 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80172b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801730:	83 c4 24             	add    $0x24,%esp
  801733:	5b                   	pop    %ebx
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    

00801736 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	53                   	push   %ebx
  80173a:	83 ec 24             	sub    $0x24,%esp
  80173d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801740:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801743:	89 44 24 04          	mov    %eax,0x4(%esp)
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	89 04 24             	mov    %eax,(%esp)
  80174d:	e8 34 fb ff ff       	call   801286 <fd_lookup>
  801752:	89 c2                	mov    %eax,%edx
  801754:	85 d2                	test   %edx,%edx
  801756:	78 52                	js     8017aa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801758:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	8b 00                	mov    (%eax),%eax
  801764:	89 04 24             	mov    %eax,(%esp)
  801767:	e8 70 fb ff ff       	call   8012dc <dev_lookup>
  80176c:	85 c0                	test   %eax,%eax
  80176e:	78 3a                	js     8017aa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801773:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801777:	74 2c                	je     8017a5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801779:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80177c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801783:	00 00 00 
	stat->st_isdir = 0;
  801786:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80178d:	00 00 00 
	stat->st_dev = dev;
  801790:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801796:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80179a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80179d:	89 14 24             	mov    %edx,(%esp)
  8017a0:	ff 50 14             	call   *0x14(%eax)
  8017a3:	eb 05                	jmp    8017aa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8017a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8017aa:	83 c4 24             	add    $0x24,%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	56                   	push   %esi
  8017b4:	53                   	push   %ebx
  8017b5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017bf:	00 
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	89 04 24             	mov    %eax,(%esp)
  8017c6:	e8 1b 02 00 00       	call   8019e6 <open>
  8017cb:	89 c3                	mov    %eax,%ebx
  8017cd:	85 db                	test   %ebx,%ebx
  8017cf:	78 1b                	js     8017ec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8017d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d8:	89 1c 24             	mov    %ebx,(%esp)
  8017db:	e8 56 ff ff ff       	call   801736 <fstat>
  8017e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8017e2:	89 1c 24             	mov    %ebx,(%esp)
  8017e5:	e8 cd fb ff ff       	call   8013b7 <close>
	return r;
  8017ea:	89 f0                	mov    %esi,%eax
}
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5e                   	pop    %esi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 10             	sub    $0x10,%esp
  8017fb:	89 c6                	mov    %eax,%esi
  8017fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017ff:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801806:	75 11                	jne    801819 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801808:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80180f:	e8 fb 0e 00 00       	call   80270f <ipc_find_env>
  801814:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801819:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801820:	00 
  801821:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801828:	00 
  801829:	89 74 24 04          	mov    %esi,0x4(%esp)
  80182d:	a1 00 40 80 00       	mov    0x804000,%eax
  801832:	89 04 24             	mov    %eax,(%esp)
  801835:	e8 6a 0e 00 00       	call   8026a4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80183a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801841:	00 
  801842:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801846:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184d:	e8 fe 0d 00 00       	call   802650 <ipc_recv>
}
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	5b                   	pop    %ebx
  801856:	5e                   	pop    %esi
  801857:	5d                   	pop    %ebp
  801858:	c3                   	ret    

00801859 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8b 40 0c             	mov    0xc(%eax),%eax
  801865:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80186a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801872:	ba 00 00 00 00       	mov    $0x0,%edx
  801877:	b8 02 00 00 00       	mov    $0x2,%eax
  80187c:	e8 72 ff ff ff       	call   8017f3 <fsipc>
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	8b 40 0c             	mov    0xc(%eax),%eax
  80188f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801894:	ba 00 00 00 00       	mov    $0x0,%edx
  801899:	b8 06 00 00 00       	mov    $0x6,%eax
  80189e:	e8 50 ff ff ff       	call   8017f3 <fsipc>
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	53                   	push   %ebx
  8018a9:	83 ec 14             	sub    $0x14,%esp
  8018ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8018c4:	e8 2a ff ff ff       	call   8017f3 <fsipc>
  8018c9:	89 c2                	mov    %eax,%edx
  8018cb:	85 d2                	test   %edx,%edx
  8018cd:	78 2b                	js     8018fa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018cf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018d6:	00 
  8018d7:	89 1c 24             	mov    %ebx,(%esp)
  8018da:	e8 88 ef ff ff       	call   800867 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018df:	a1 80 50 80 00       	mov    0x805080,%eax
  8018e4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ea:	a1 84 50 80 00       	mov    0x805084,%eax
  8018ef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fa:	83 c4 14             	add    $0x14,%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    

00801900 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 18             	sub    $0x18,%esp
  801906:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801909:	8b 55 08             	mov    0x8(%ebp),%edx
  80190c:	8b 52 0c             	mov    0xc(%edx),%edx
  80190f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801915:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80191a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80191e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801921:	89 44 24 04          	mov    %eax,0x4(%esp)
  801925:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80192c:	e8 3b f1 ff ff       	call   800a6c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	b8 04 00 00 00       	mov    $0x4,%eax
  80193b:	e8 b3 fe ff ff       	call   8017f3 <fsipc>
		return r;
	}

	return r;
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	56                   	push   %esi
  801946:	53                   	push   %ebx
  801947:	83 ec 10             	sub    $0x10,%esp
  80194a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8b 40 0c             	mov    0xc(%eax),%eax
  801953:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801958:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80195e:	ba 00 00 00 00       	mov    $0x0,%edx
  801963:	b8 03 00 00 00       	mov    $0x3,%eax
  801968:	e8 86 fe ff ff       	call   8017f3 <fsipc>
  80196d:	89 c3                	mov    %eax,%ebx
  80196f:	85 c0                	test   %eax,%eax
  801971:	78 6a                	js     8019dd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801973:	39 c6                	cmp    %eax,%esi
  801975:	73 24                	jae    80199b <devfile_read+0x59>
  801977:	c7 44 24 0c 68 2e 80 	movl   $0x802e68,0xc(%esp)
  80197e:	00 
  80197f:	c7 44 24 08 6f 2e 80 	movl   $0x802e6f,0x8(%esp)
  801986:	00 
  801987:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80198e:	00 
  80198f:	c7 04 24 84 2e 80 00 	movl   $0x802e84,(%esp)
  801996:	e8 5b 0c 00 00       	call   8025f6 <_panic>
	assert(r <= PGSIZE);
  80199b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019a0:	7e 24                	jle    8019c6 <devfile_read+0x84>
  8019a2:	c7 44 24 0c 8f 2e 80 	movl   $0x802e8f,0xc(%esp)
  8019a9:	00 
  8019aa:	c7 44 24 08 6f 2e 80 	movl   $0x802e6f,0x8(%esp)
  8019b1:	00 
  8019b2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8019b9:	00 
  8019ba:	c7 04 24 84 2e 80 00 	movl   $0x802e84,(%esp)
  8019c1:	e8 30 0c 00 00       	call   8025f6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ca:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8019d1:	00 
  8019d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d5:	89 04 24             	mov    %eax,(%esp)
  8019d8:	e8 27 f0 ff ff       	call   800a04 <memmove>
	return r;
}
  8019dd:	89 d8                	mov    %ebx,%eax
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	5b                   	pop    %ebx
  8019e3:	5e                   	pop    %esi
  8019e4:	5d                   	pop    %ebp
  8019e5:	c3                   	ret    

008019e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	53                   	push   %ebx
  8019ea:	83 ec 24             	sub    $0x24,%esp
  8019ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8019f0:	89 1c 24             	mov    %ebx,(%esp)
  8019f3:	e8 38 ee ff ff       	call   800830 <strlen>
  8019f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019fd:	7f 60                	jg     801a5f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8019ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a02:	89 04 24             	mov    %eax,(%esp)
  801a05:	e8 2d f8 ff ff       	call   801237 <fd_alloc>
  801a0a:	89 c2                	mov    %eax,%edx
  801a0c:	85 d2                	test   %edx,%edx
  801a0e:	78 54                	js     801a64 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a14:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801a1b:	e8 47 ee ff ff       	call   800867 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a23:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a30:	e8 be fd ff ff       	call   8017f3 <fsipc>
  801a35:	89 c3                	mov    %eax,%ebx
  801a37:	85 c0                	test   %eax,%eax
  801a39:	79 17                	jns    801a52 <open+0x6c>
		fd_close(fd, 0);
  801a3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a42:	00 
  801a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a46:	89 04 24             	mov    %eax,(%esp)
  801a49:	e8 e8 f8 ff ff       	call   801336 <fd_close>
		return r;
  801a4e:	89 d8                	mov    %ebx,%eax
  801a50:	eb 12                	jmp    801a64 <open+0x7e>
	}

	return fd2num(fd);
  801a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a55:	89 04 24             	mov    %eax,(%esp)
  801a58:	e8 b3 f7 ff ff       	call   801210 <fd2num>
  801a5d:	eb 05                	jmp    801a64 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801a5f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801a64:	83 c4 24             	add    $0x24,%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    

00801a6a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a70:	ba 00 00 00 00       	mov    $0x0,%edx
  801a75:	b8 08 00 00 00       	mov    $0x8,%eax
  801a7a:	e8 74 fd ff ff       	call   8017f3 <fsipc>
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	53                   	push   %ebx
  801a85:	83 ec 14             	sub    $0x14,%esp
  801a88:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801a8a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a8e:	7e 31                	jle    801ac1 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a90:	8b 40 04             	mov    0x4(%eax),%eax
  801a93:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a97:	8d 43 10             	lea    0x10(%ebx),%eax
  801a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9e:	8b 03                	mov    (%ebx),%eax
  801aa0:	89 04 24             	mov    %eax,(%esp)
  801aa3:	e8 4f fb ff ff       	call   8015f7 <write>
		if (result > 0)
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	7e 03                	jle    801aaf <writebuf+0x2e>
			b->result += result;
  801aac:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801aaf:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ab2:	74 0d                	je     801ac1 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801ab4:	85 c0                	test   %eax,%eax
  801ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  801abb:	0f 4f c2             	cmovg  %edx,%eax
  801abe:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801ac1:	83 c4 14             	add    $0x14,%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5d                   	pop    %ebp
  801ac6:	c3                   	ret    

00801ac7 <putch>:

static void
putch(int ch, void *thunk)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	53                   	push   %ebx
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801ad1:	8b 53 04             	mov    0x4(%ebx),%edx
  801ad4:	8d 42 01             	lea    0x1(%edx),%eax
  801ad7:	89 43 04             	mov    %eax,0x4(%ebx)
  801ada:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801add:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801ae1:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ae6:	75 0e                	jne    801af6 <putch+0x2f>
		writebuf(b);
  801ae8:	89 d8                	mov    %ebx,%eax
  801aea:	e8 92 ff ff ff       	call   801a81 <writebuf>
		b->idx = 0;
  801aef:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801af6:	83 c4 04             	add    $0x4,%esp
  801af9:	5b                   	pop    %ebx
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    

00801afc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b0e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b15:	00 00 00 
	b.result = 0;
  801b18:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b1f:	00 00 00 
	b.error = 1;
  801b22:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b29:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b3a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b44:	c7 04 24 c7 1a 80 00 	movl   $0x801ac7,(%esp)
  801b4b:	e8 7e e8 ff ff       	call   8003ce <vprintfmt>
	if (b.idx > 0)
  801b50:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b57:	7e 0b                	jle    801b64 <vfprintf+0x68>
		writebuf(&b);
  801b59:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b5f:	e8 1d ff ff ff       	call   801a81 <writebuf>

	return (b.result ? b.result : b.error);
  801b64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b7b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	89 04 24             	mov    %eax,(%esp)
  801b8f:	e8 68 ff ff ff       	call   801afc <vfprintf>
	va_end(ap);

	return cnt;
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <printf>:

int
printf(const char *fmt, ...)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b9c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801baa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bb1:	e8 46 ff ff ff       	call   801afc <vfprintf>
	va_end(ap);

	return cnt;
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    
  801bb8:	66 90                	xchg   %ax,%ax
  801bba:	66 90                	xchg   %ax,%ax
  801bbc:	66 90                	xchg   %ax,%ax
  801bbe:	66 90                	xchg   %ax,%ax

00801bc0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801bc6:	c7 44 24 04 9b 2e 80 	movl   $0x802e9b,0x4(%esp)
  801bcd:	00 
  801bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd1:	89 04 24             	mov    %eax,(%esp)
  801bd4:	e8 8e ec ff ff       	call   800867 <strcpy>
	return 0;
}
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	53                   	push   %ebx
  801be4:	83 ec 14             	sub    $0x14,%esp
  801be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bea:	89 1c 24             	mov    %ebx,(%esp)
  801bed:	e8 5c 0b 00 00       	call   80274e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801bf2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801bf7:	83 f8 01             	cmp    $0x1,%eax
  801bfa:	75 0d                	jne    801c09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801bfc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801bff:	89 04 24             	mov    %eax,(%esp)
  801c02:	e8 29 03 00 00       	call   801f30 <nsipc_close>
  801c07:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801c09:	89 d0                	mov    %edx,%eax
  801c0b:	83 c4 14             	add    $0x14,%esp
  801c0e:	5b                   	pop    %ebx
  801c0f:	5d                   	pop    %ebp
  801c10:	c3                   	ret    

00801c11 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c1e:	00 
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	8b 40 0c             	mov    0xc(%eax),%eax
  801c33:	89 04 24             	mov    %eax,(%esp)
  801c36:	e8 f0 03 00 00       	call   80202b <nsipc_send>
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c4a:	00 
  801c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c5f:	89 04 24             	mov    %eax,(%esp)
  801c62:	e8 44 03 00 00       	call   801fab <nsipc_recv>
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c72:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c76:	89 04 24             	mov    %eax,(%esp)
  801c79:	e8 08 f6 ff ff       	call   801286 <fd_lookup>
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 17                	js     801c99 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c85:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c8b:	39 08                	cmp    %ecx,(%eax)
  801c8d:	75 05                	jne    801c94 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c92:	eb 05                	jmp    801c99 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801c94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 20             	sub    $0x20,%esp
  801ca3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca8:	89 04 24             	mov    %eax,(%esp)
  801cab:	e8 87 f5 ff ff       	call   801237 <fd_alloc>
  801cb0:	89 c3                	mov    %eax,%ebx
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	78 21                	js     801cd7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801cb6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801cbd:	00 
  801cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ccc:	e8 b2 ef ff ff       	call   800c83 <sys_page_alloc>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	79 0c                	jns    801ce3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801cd7:	89 34 24             	mov    %esi,(%esp)
  801cda:	e8 51 02 00 00       	call   801f30 <nsipc_close>
		return r;
  801cdf:	89 d8                	mov    %ebx,%eax
  801ce1:	eb 20                	jmp    801d03 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ce3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801cf8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801cfb:	89 14 24             	mov    %edx,(%esp)
  801cfe:	e8 0d f5 ff ff       	call   801210 <fd2num>
}
  801d03:	83 c4 20             	add    $0x20,%esp
  801d06:	5b                   	pop    %ebx
  801d07:	5e                   	pop    %esi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    

00801d0a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	e8 51 ff ff ff       	call   801c69 <fd2sockid>
		return r;
  801d18:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	78 23                	js     801d41 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d1e:	8b 55 10             	mov    0x10(%ebp),%edx
  801d21:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d28:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d2c:	89 04 24             	mov    %eax,(%esp)
  801d2f:	e8 45 01 00 00       	call   801e79 <nsipc_accept>
		return r;
  801d34:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d36:	85 c0                	test   %eax,%eax
  801d38:	78 07                	js     801d41 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801d3a:	e8 5c ff ff ff       	call   801c9b <alloc_sockfd>
  801d3f:	89 c1                	mov    %eax,%ecx
}
  801d41:	89 c8                	mov    %ecx,%eax
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	e8 16 ff ff ff       	call   801c69 <fd2sockid>
  801d53:	89 c2                	mov    %eax,%edx
  801d55:	85 d2                	test   %edx,%edx
  801d57:	78 16                	js     801d6f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801d59:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d67:	89 14 24             	mov    %edx,(%esp)
  801d6a:	e8 60 01 00 00       	call   801ecf <nsipc_bind>
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <shutdown>:

int
shutdown(int s, int how)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	e8 ea fe ff ff       	call   801c69 <fd2sockid>
  801d7f:	89 c2                	mov    %eax,%edx
  801d81:	85 d2                	test   %edx,%edx
  801d83:	78 0f                	js     801d94 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8c:	89 14 24             	mov    %edx,(%esp)
  801d8f:	e8 7a 01 00 00       	call   801f0e <nsipc_shutdown>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	e8 c5 fe ff ff       	call   801c69 <fd2sockid>
  801da4:	89 c2                	mov    %eax,%edx
  801da6:	85 d2                	test   %edx,%edx
  801da8:	78 16                	js     801dc0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801daa:	8b 45 10             	mov    0x10(%ebp),%eax
  801dad:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db8:	89 14 24             	mov    %edx,(%esp)
  801dbb:	e8 8a 01 00 00       	call   801f4a <nsipc_connect>
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <listen>:

int
listen(int s, int backlog)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	e8 99 fe ff ff       	call   801c69 <fd2sockid>
  801dd0:	89 c2                	mov    %eax,%edx
  801dd2:	85 d2                	test   %edx,%edx
  801dd4:	78 0f                	js     801de5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddd:	89 14 24             	mov    %edx,(%esp)
  801de0:	e8 a4 01 00 00       	call   801f89 <nsipc_listen>
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ded:	8b 45 10             	mov    0x10(%ebp),%eax
  801df0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	e8 98 02 00 00       	call   80209e <nsipc_socket>
  801e06:	89 c2                	mov    %eax,%edx
  801e08:	85 d2                	test   %edx,%edx
  801e0a:	78 05                	js     801e11 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801e0c:	e8 8a fe ff ff       	call   801c9b <alloc_sockfd>
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	53                   	push   %ebx
  801e17:	83 ec 14             	sub    $0x14,%esp
  801e1a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e1c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801e23:	75 11                	jne    801e36 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e25:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801e2c:	e8 de 08 00 00       	call   80270f <ipc_find_env>
  801e31:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e3d:	00 
  801e3e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e45:	00 
  801e46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e4a:	a1 04 40 80 00       	mov    0x804004,%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 4d 08 00 00       	call   8026a4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e5e:	00 
  801e5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e66:	00 
  801e67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e6e:	e8 dd 07 00 00       	call   802650 <ipc_recv>
}
  801e73:	83 c4 14             	add    $0x14,%esp
  801e76:	5b                   	pop    %ebx
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    

00801e79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	56                   	push   %esi
  801e7d:	53                   	push   %ebx
  801e7e:	83 ec 10             	sub    $0x10,%esp
  801e81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e8c:	8b 06                	mov    (%esi),%eax
  801e8e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e93:	b8 01 00 00 00       	mov    $0x1,%eax
  801e98:	e8 76 ff ff ff       	call   801e13 <nsipc>
  801e9d:	89 c3                	mov    %eax,%ebx
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	78 23                	js     801ec6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ea3:	a1 10 60 80 00       	mov    0x806010,%eax
  801ea8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eac:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801eb3:	00 
  801eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb7:	89 04 24             	mov    %eax,(%esp)
  801eba:	e8 45 eb ff ff       	call   800a04 <memmove>
		*addrlen = ret->ret_addrlen;
  801ebf:	a1 10 60 80 00       	mov    0x806010,%eax
  801ec4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ec6:	89 d8                	mov    %ebx,%eax
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5d                   	pop    %ebp
  801ece:	c3                   	ret    

00801ecf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 14             	sub    $0x14,%esp
  801ed6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ee1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eec:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801ef3:	e8 0c eb ff ff       	call   800a04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ef8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801efe:	b8 02 00 00 00       	mov    $0x2,%eax
  801f03:	e8 0b ff ff ff       	call   801e13 <nsipc>
}
  801f08:	83 c4 14             	add    $0x14,%esp
  801f0b:	5b                   	pop    %ebx
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    

00801f0e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f24:	b8 03 00 00 00       	mov    $0x3,%eax
  801f29:	e8 e5 fe ff ff       	call   801e13 <nsipc>
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <nsipc_close>:

int
nsipc_close(int s)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f3e:	b8 04 00 00 00       	mov    $0x4,%eax
  801f43:	e8 cb fe ff ff       	call   801e13 <nsipc>
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	53                   	push   %ebx
  801f4e:	83 ec 14             	sub    $0x14,%esp
  801f51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f5c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f67:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801f6e:	e8 91 ea ff ff       	call   800a04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f73:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f79:	b8 05 00 00 00       	mov    $0x5,%eax
  801f7e:	e8 90 fe ff ff       	call   801e13 <nsipc>
}
  801f83:	83 c4 14             	add    $0x14,%esp
  801f86:	5b                   	pop    %ebx
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    

00801f89 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f9f:	b8 06 00 00 00       	mov    $0x6,%eax
  801fa4:	e8 6a fe ff ff       	call   801e13 <nsipc>
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	56                   	push   %esi
  801faf:	53                   	push   %ebx
  801fb0:	83 ec 10             	sub    $0x10,%esp
  801fb3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801fbe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fcc:	b8 07 00 00 00       	mov    $0x7,%eax
  801fd1:	e8 3d fe ff ff       	call   801e13 <nsipc>
  801fd6:	89 c3                	mov    %eax,%ebx
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	78 46                	js     802022 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801fdc:	39 f0                	cmp    %esi,%eax
  801fde:	7f 07                	jg     801fe7 <nsipc_recv+0x3c>
  801fe0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801fe5:	7e 24                	jle    80200b <nsipc_recv+0x60>
  801fe7:	c7 44 24 0c a7 2e 80 	movl   $0x802ea7,0xc(%esp)
  801fee:	00 
  801fef:	c7 44 24 08 6f 2e 80 	movl   $0x802e6f,0x8(%esp)
  801ff6:	00 
  801ff7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801ffe:	00 
  801fff:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  802006:	e8 eb 05 00 00       	call   8025f6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80200b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80200f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802016:	00 
  802017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201a:	89 04 24             	mov    %eax,(%esp)
  80201d:	e8 e2 e9 ff ff       	call   800a04 <memmove>
	}

	return r;
}
  802022:	89 d8                	mov    %ebx,%eax
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	5b                   	pop    %ebx
  802028:	5e                   	pop    %esi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    

0080202b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	53                   	push   %ebx
  80202f:	83 ec 14             	sub    $0x14,%esp
  802032:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80203d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802043:	7e 24                	jle    802069 <nsipc_send+0x3e>
  802045:	c7 44 24 0c c8 2e 80 	movl   $0x802ec8,0xc(%esp)
  80204c:	00 
  80204d:	c7 44 24 08 6f 2e 80 	movl   $0x802e6f,0x8(%esp)
  802054:	00 
  802055:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80205c:	00 
  80205d:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  802064:	e8 8d 05 00 00       	call   8025f6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802069:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80206d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802070:	89 44 24 04          	mov    %eax,0x4(%esp)
  802074:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80207b:	e8 84 e9 ff ff       	call   800a04 <memmove>
	nsipcbuf.send.req_size = size;
  802080:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802086:	8b 45 14             	mov    0x14(%ebp),%eax
  802089:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80208e:	b8 08 00 00 00       	mov    $0x8,%eax
  802093:	e8 7b fd ff ff       	call   801e13 <nsipc>
}
  802098:	83 c4 14             	add    $0x14,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    

0080209e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020af:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8020bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8020c1:	e8 4d fd ff ff       	call   801e13 <nsipc>
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	56                   	push   %esi
  8020cc:	53                   	push   %ebx
  8020cd:	83 ec 10             	sub    $0x10,%esp
  8020d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	89 04 24             	mov    %eax,(%esp)
  8020d9:	e8 42 f1 ff ff       	call   801220 <fd2data>
  8020de:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020e0:	c7 44 24 04 d4 2e 80 	movl   $0x802ed4,0x4(%esp)
  8020e7:	00 
  8020e8:	89 1c 24             	mov    %ebx,(%esp)
  8020eb:	e8 77 e7 ff ff       	call   800867 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020f0:	8b 46 04             	mov    0x4(%esi),%eax
  8020f3:	2b 06                	sub    (%esi),%eax
  8020f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802102:	00 00 00 
	stat->st_dev = &devpipe;
  802105:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80210c:	30 80 00 
	return 0;
}
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5d                   	pop    %ebp
  80211a:	c3                   	ret    

0080211b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	53                   	push   %ebx
  80211f:	83 ec 14             	sub    $0x14,%esp
  802122:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802125:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802129:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802130:	e8 f5 eb ff ff       	call   800d2a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802135:	89 1c 24             	mov    %ebx,(%esp)
  802138:	e8 e3 f0 ff ff       	call   801220 <fd2data>
  80213d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802141:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802148:	e8 dd eb ff ff       	call   800d2a <sys_page_unmap>
}
  80214d:	83 c4 14             	add    $0x14,%esp
  802150:	5b                   	pop    %ebx
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    

00802153 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	57                   	push   %edi
  802157:	56                   	push   %esi
  802158:	53                   	push   %ebx
  802159:	83 ec 2c             	sub    $0x2c,%esp
  80215c:	89 c6                	mov    %eax,%esi
  80215e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802161:	a1 08 40 80 00       	mov    0x804008,%eax
  802166:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802169:	89 34 24             	mov    %esi,(%esp)
  80216c:	e8 dd 05 00 00       	call   80274e <pageref>
  802171:	89 c7                	mov    %eax,%edi
  802173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802176:	89 04 24             	mov    %eax,(%esp)
  802179:	e8 d0 05 00 00       	call   80274e <pageref>
  80217e:	39 c7                	cmp    %eax,%edi
  802180:	0f 94 c2             	sete   %dl
  802183:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802186:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80218c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80218f:	39 fb                	cmp    %edi,%ebx
  802191:	74 21                	je     8021b4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802193:	84 d2                	test   %dl,%dl
  802195:	74 ca                	je     802161 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802197:	8b 51 58             	mov    0x58(%ecx),%edx
  80219a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80219e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021a6:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  8021ad:	e8 88 e0 ff ff       	call   80023a <cprintf>
  8021b2:	eb ad                	jmp    802161 <_pipeisclosed+0xe>
	}
}
  8021b4:	83 c4 2c             	add    $0x2c,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5f                   	pop    %edi
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    

008021bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	57                   	push   %edi
  8021c0:	56                   	push   %esi
  8021c1:	53                   	push   %ebx
  8021c2:	83 ec 1c             	sub    $0x1c,%esp
  8021c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8021c8:	89 34 24             	mov    %esi,(%esp)
  8021cb:	e8 50 f0 ff ff       	call   801220 <fd2data>
  8021d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d7:	eb 45                	jmp    80221e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8021d9:	89 da                	mov    %ebx,%edx
  8021db:	89 f0                	mov    %esi,%eax
  8021dd:	e8 71 ff ff ff       	call   802153 <_pipeisclosed>
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 41                	jne    802227 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8021e6:	e8 79 ea ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8021ee:	8b 0b                	mov    (%ebx),%ecx
  8021f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8021f3:	39 d0                	cmp    %edx,%eax
  8021f5:	73 e2                	jae    8021d9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802201:	99                   	cltd   
  802202:	c1 ea 1b             	shr    $0x1b,%edx
  802205:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802208:	83 e1 1f             	and    $0x1f,%ecx
  80220b:	29 d1                	sub    %edx,%ecx
  80220d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802211:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802215:	83 c0 01             	add    $0x1,%eax
  802218:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80221b:	83 c7 01             	add    $0x1,%edi
  80221e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802221:	75 c8                	jne    8021eb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802223:	89 f8                	mov    %edi,%eax
  802225:	eb 05                	jmp    80222c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    

00802234 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	57                   	push   %edi
  802238:	56                   	push   %esi
  802239:	53                   	push   %ebx
  80223a:	83 ec 1c             	sub    $0x1c,%esp
  80223d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802240:	89 3c 24             	mov    %edi,(%esp)
  802243:	e8 d8 ef ff ff       	call   801220 <fd2data>
  802248:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80224a:	be 00 00 00 00       	mov    $0x0,%esi
  80224f:	eb 3d                	jmp    80228e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802251:	85 f6                	test   %esi,%esi
  802253:	74 04                	je     802259 <devpipe_read+0x25>
				return i;
  802255:	89 f0                	mov    %esi,%eax
  802257:	eb 43                	jmp    80229c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802259:	89 da                	mov    %ebx,%edx
  80225b:	89 f8                	mov    %edi,%eax
  80225d:	e8 f1 fe ff ff       	call   802153 <_pipeisclosed>
  802262:	85 c0                	test   %eax,%eax
  802264:	75 31                	jne    802297 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802266:	e8 f9 e9 ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80226b:	8b 03                	mov    (%ebx),%eax
  80226d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802270:	74 df                	je     802251 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802272:	99                   	cltd   
  802273:	c1 ea 1b             	shr    $0x1b,%edx
  802276:	01 d0                	add    %edx,%eax
  802278:	83 e0 1f             	and    $0x1f,%eax
  80227b:	29 d0                	sub    %edx,%eax
  80227d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802285:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802288:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80228b:	83 c6 01             	add    $0x1,%esi
  80228e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802291:	75 d8                	jne    80226b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802293:	89 f0                	mov    %esi,%eax
  802295:	eb 05                	jmp    80229c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80229c:	83 c4 1c             	add    $0x1c,%esp
  80229f:	5b                   	pop    %ebx
  8022a0:	5e                   	pop    %esi
  8022a1:	5f                   	pop    %edi
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    

008022a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	56                   	push   %esi
  8022a8:	53                   	push   %ebx
  8022a9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8022ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022af:	89 04 24             	mov    %eax,(%esp)
  8022b2:	e8 80 ef ff ff       	call   801237 <fd_alloc>
  8022b7:	89 c2                	mov    %eax,%edx
  8022b9:	85 d2                	test   %edx,%edx
  8022bb:	0f 88 4d 01 00 00    	js     80240e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022c8:	00 
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d7:	e8 a7 e9 ff ff       	call   800c83 <sys_page_alloc>
  8022dc:	89 c2                	mov    %eax,%edx
  8022de:	85 d2                	test   %edx,%edx
  8022e0:	0f 88 28 01 00 00    	js     80240e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8022e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022e9:	89 04 24             	mov    %eax,(%esp)
  8022ec:	e8 46 ef ff ff       	call   801237 <fd_alloc>
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	0f 88 fe 00 00 00    	js     8023f9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802302:	00 
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802311:	e8 6d e9 ff ff       	call   800c83 <sys_page_alloc>
  802316:	89 c3                	mov    %eax,%ebx
  802318:	85 c0                	test   %eax,%eax
  80231a:	0f 88 d9 00 00 00    	js     8023f9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	89 04 24             	mov    %eax,(%esp)
  802326:	e8 f5 ee ff ff       	call   801220 <fd2data>
  80232b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80232d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802334:	00 
  802335:	89 44 24 04          	mov    %eax,0x4(%esp)
  802339:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802340:	e8 3e e9 ff ff       	call   800c83 <sys_page_alloc>
  802345:	89 c3                	mov    %eax,%ebx
  802347:	85 c0                	test   %eax,%eax
  802349:	0f 88 97 00 00 00    	js     8023e6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80234f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802352:	89 04 24             	mov    %eax,(%esp)
  802355:	e8 c6 ee ff ff       	call   801220 <fd2data>
  80235a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802361:	00 
  802362:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802366:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80236d:	00 
  80236e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802372:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802379:	e8 59 e9 ff ff       	call   800cd7 <sys_page_map>
  80237e:	89 c3                	mov    %eax,%ebx
  802380:	85 c0                	test   %eax,%eax
  802382:	78 52                	js     8023d6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802384:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802399:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8023a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	89 04 24             	mov    %eax,(%esp)
  8023b4:	e8 57 ee ff ff       	call   801210 <fd2num>
  8023b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c1:	89 04 24             	mov    %eax,(%esp)
  8023c4:	e8 47 ee ff ff       	call   801210 <fd2num>
  8023c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	eb 38                	jmp    80240e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8023d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e1:	e8 44 e9 ff ff       	call   800d2a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f4:	e8 31 e9 ff ff       	call   800d2a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802400:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802407:	e8 1e e9 ff ff       	call   800d2a <sys_page_unmap>
  80240c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80240e:	83 c4 30             	add    $0x30,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5d                   	pop    %ebp
  802414:	c3                   	ret    

00802415 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80241b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80241e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	89 04 24             	mov    %eax,(%esp)
  802428:	e8 59 ee ff ff       	call   801286 <fd_lookup>
  80242d:	89 c2                	mov    %eax,%edx
  80242f:	85 d2                	test   %edx,%edx
  802431:	78 15                	js     802448 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	89 04 24             	mov    %eax,(%esp)
  802439:	e8 e2 ed ff ff       	call   801220 <fd2data>
	return _pipeisclosed(fd, p);
  80243e:	89 c2                	mov    %eax,%edx
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	e8 0b fd ff ff       	call   802153 <_pipeisclosed>
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802460:	c7 44 24 04 f3 2e 80 	movl   $0x802ef3,0x4(%esp)
  802467:	00 
  802468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246b:	89 04 24             	mov    %eax,(%esp)
  80246e:	e8 f4 e3 ff ff       	call   800867 <strcpy>
	return 0;
}
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	57                   	push   %edi
  80247e:	56                   	push   %esi
  80247f:	53                   	push   %ebx
  802480:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802486:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80248b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802491:	eb 31                	jmp    8024c4 <devcons_write+0x4a>
		m = n - tot;
  802493:	8b 75 10             	mov    0x10(%ebp),%esi
  802496:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802498:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80249b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8024a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8024a7:	03 45 0c             	add    0xc(%ebp),%eax
  8024aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ae:	89 3c 24             	mov    %edi,(%esp)
  8024b1:	e8 4e e5 ff ff       	call   800a04 <memmove>
		sys_cputs(buf, m);
  8024b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024ba:	89 3c 24             	mov    %edi,(%esp)
  8024bd:	e8 f4 e6 ff ff       	call   800bb6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024c2:	01 f3                	add    %esi,%ebx
  8024c4:	89 d8                	mov    %ebx,%eax
  8024c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8024c9:	72 c8                	jb     802493 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8024cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    

008024d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8024e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024e5:	75 07                	jne    8024ee <devcons_read+0x18>
  8024e7:	eb 2a                	jmp    802513 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8024e9:	e8 76 e7 ff ff       	call   800c64 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8024ee:	66 90                	xchg   %ax,%ax
  8024f0:	e8 df e6 ff ff       	call   800bd4 <sys_cgetc>
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	74 f0                	je     8024e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	78 16                	js     802513 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8024fd:	83 f8 04             	cmp    $0x4,%eax
  802500:	74 0c                	je     80250e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802502:	8b 55 0c             	mov    0xc(%ebp),%edx
  802505:	88 02                	mov    %al,(%edx)
	return 1;
  802507:	b8 01 00 00 00       	mov    $0x1,%eax
  80250c:	eb 05                	jmp    802513 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802521:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802528:	00 
  802529:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80252c:	89 04 24             	mov    %eax,(%esp)
  80252f:	e8 82 e6 ff ff       	call   800bb6 <sys_cputs>
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <getchar>:

int
getchar(void)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80253c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802543:	00 
  802544:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802547:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802552:	e8 c3 ef ff ff       	call   80151a <read>
	if (r < 0)
  802557:	85 c0                	test   %eax,%eax
  802559:	78 0f                	js     80256a <getchar+0x34>
		return r;
	if (r < 1)
  80255b:	85 c0                	test   %eax,%eax
  80255d:	7e 06                	jle    802565 <getchar+0x2f>
		return -E_EOF;
	return c;
  80255f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802563:	eb 05                	jmp    80256a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802565:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802572:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802575:	89 44 24 04          	mov    %eax,0x4(%esp)
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	89 04 24             	mov    %eax,(%esp)
  80257f:	e8 02 ed ff ff       	call   801286 <fd_lookup>
  802584:	85 c0                	test   %eax,%eax
  802586:	78 11                	js     802599 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802591:	39 10                	cmp    %edx,(%eax)
  802593:	0f 94 c0             	sete   %al
  802596:	0f b6 c0             	movzbl %al,%eax
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <opencons>:

int
opencons(void)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025a4:	89 04 24             	mov    %eax,(%esp)
  8025a7:	e8 8b ec ff ff       	call   801237 <fd_alloc>
		return r;
  8025ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	78 40                	js     8025f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025b9:	00 
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c8:	e8 b6 e6 ff ff       	call   800c83 <sys_page_alloc>
		return r;
  8025cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	78 1f                	js     8025f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8025d3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025e8:	89 04 24             	mov    %eax,(%esp)
  8025eb:	e8 20 ec ff ff       	call   801210 <fd2num>
  8025f0:	89 c2                	mov    %eax,%edx
}
  8025f2:	89 d0                	mov    %edx,%eax
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	56                   	push   %esi
  8025fa:	53                   	push   %ebx
  8025fb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8025fe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802601:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802607:	e8 39 e6 ff ff       	call   800c45 <sys_getenvid>
  80260c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802613:	8b 55 08             	mov    0x8(%ebp),%edx
  802616:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80261a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80261e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802622:	c7 04 24 00 2f 80 00 	movl   $0x802f00,(%esp)
  802629:	e8 0c dc ff ff       	call   80023a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80262e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802632:	8b 45 10             	mov    0x10(%ebp),%eax
  802635:	89 04 24             	mov    %eax,(%esp)
  802638:	e8 9c db ff ff       	call   8001d9 <vcprintf>
	cprintf("\n");
  80263d:	c7 04 24 30 2a 80 00 	movl   $0x802a30,(%esp)
  802644:	e8 f1 db ff ff       	call   80023a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802649:	cc                   	int3   
  80264a:	eb fd                	jmp    802649 <_panic+0x53>
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	56                   	push   %esi
  802654:	53                   	push   %ebx
  802655:	83 ec 10             	sub    $0x10,%esp
  802658:	8b 75 08             	mov    0x8(%ebp),%esi
  80265b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802661:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802663:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802668:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80266b:	89 04 24             	mov    %eax,(%esp)
  80266e:	e8 26 e8 ff ff       	call   800e99 <sys_ipc_recv>
  802673:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802675:	85 d2                	test   %edx,%edx
  802677:	75 24                	jne    80269d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802679:	85 f6                	test   %esi,%esi
  80267b:	74 0a                	je     802687 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80267d:	a1 08 40 80 00       	mov    0x804008,%eax
  802682:	8b 40 74             	mov    0x74(%eax),%eax
  802685:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802687:	85 db                	test   %ebx,%ebx
  802689:	74 0a                	je     802695 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80268b:	a1 08 40 80 00       	mov    0x804008,%eax
  802690:	8b 40 78             	mov    0x78(%eax),%eax
  802693:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802695:	a1 08 40 80 00       	mov    0x804008,%eax
  80269a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80269d:	83 c4 10             	add    $0x10,%esp
  8026a0:	5b                   	pop    %ebx
  8026a1:	5e                   	pop    %esi
  8026a2:	5d                   	pop    %ebp
  8026a3:	c3                   	ret    

008026a4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	57                   	push   %edi
  8026a8:	56                   	push   %esi
  8026a9:	53                   	push   %ebx
  8026aa:	83 ec 1c             	sub    $0x1c,%esp
  8026ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8026b6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8026b8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026bd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8026c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8026c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026cf:	89 3c 24             	mov    %edi,(%esp)
  8026d2:	e8 9f e7 ff ff       	call   800e76 <sys_ipc_try_send>

		if (ret == 0)
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	74 2c                	je     802707 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8026db:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026de:	74 20                	je     802700 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8026e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026e4:	c7 44 24 08 24 2f 80 	movl   $0x802f24,0x8(%esp)
  8026eb:	00 
  8026ec:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8026f3:	00 
  8026f4:	c7 04 24 54 2f 80 00 	movl   $0x802f54,(%esp)
  8026fb:	e8 f6 fe ff ff       	call   8025f6 <_panic>
		}

		sys_yield();
  802700:	e8 5f e5 ff ff       	call   800c64 <sys_yield>
	}
  802705:	eb b9                	jmp    8026c0 <ipc_send+0x1c>
}
  802707:	83 c4 1c             	add    $0x1c,%esp
  80270a:	5b                   	pop    %ebx
  80270b:	5e                   	pop    %esi
  80270c:	5f                   	pop    %edi
  80270d:	5d                   	pop    %ebp
  80270e:	c3                   	ret    

0080270f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802715:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80271a:	89 c2                	mov    %eax,%edx
  80271c:	c1 e2 07             	shl    $0x7,%edx
  80271f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802726:	8b 52 50             	mov    0x50(%edx),%edx
  802729:	39 ca                	cmp    %ecx,%edx
  80272b:	75 11                	jne    80273e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80272d:	89 c2                	mov    %eax,%edx
  80272f:	c1 e2 07             	shl    $0x7,%edx
  802732:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802739:	8b 40 40             	mov    0x40(%eax),%eax
  80273c:	eb 0e                	jmp    80274c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80273e:	83 c0 01             	add    $0x1,%eax
  802741:	3d 00 04 00 00       	cmp    $0x400,%eax
  802746:	75 d2                	jne    80271a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802748:	66 b8 00 00          	mov    $0x0,%ax
}
  80274c:	5d                   	pop    %ebp
  80274d:	c3                   	ret    

0080274e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802754:	89 d0                	mov    %edx,%eax
  802756:	c1 e8 16             	shr    $0x16,%eax
  802759:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802760:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802765:	f6 c1 01             	test   $0x1,%cl
  802768:	74 1d                	je     802787 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80276a:	c1 ea 0c             	shr    $0xc,%edx
  80276d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802774:	f6 c2 01             	test   $0x1,%dl
  802777:	74 0e                	je     802787 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802779:	c1 ea 0c             	shr    $0xc,%edx
  80277c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802783:	ef 
  802784:	0f b7 c0             	movzwl %ax,%eax
}
  802787:	5d                   	pop    %ebp
  802788:	c3                   	ret    
  802789:	66 90                	xchg   %ax,%ax
  80278b:	66 90                	xchg   %ax,%ax
  80278d:	66 90                	xchg   %ax,%ax
  80278f:	90                   	nop

00802790 <__udivdi3>:
  802790:	55                   	push   %ebp
  802791:	57                   	push   %edi
  802792:	56                   	push   %esi
  802793:	83 ec 0c             	sub    $0xc,%esp
  802796:	8b 44 24 28          	mov    0x28(%esp),%eax
  80279a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80279e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8027a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8027ac:	89 ea                	mov    %ebp,%edx
  8027ae:	89 0c 24             	mov    %ecx,(%esp)
  8027b1:	75 2d                	jne    8027e0 <__udivdi3+0x50>
  8027b3:	39 e9                	cmp    %ebp,%ecx
  8027b5:	77 61                	ja     802818 <__udivdi3+0x88>
  8027b7:	85 c9                	test   %ecx,%ecx
  8027b9:	89 ce                	mov    %ecx,%esi
  8027bb:	75 0b                	jne    8027c8 <__udivdi3+0x38>
  8027bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c2:	31 d2                	xor    %edx,%edx
  8027c4:	f7 f1                	div    %ecx
  8027c6:	89 c6                	mov    %eax,%esi
  8027c8:	31 d2                	xor    %edx,%edx
  8027ca:	89 e8                	mov    %ebp,%eax
  8027cc:	f7 f6                	div    %esi
  8027ce:	89 c5                	mov    %eax,%ebp
  8027d0:	89 f8                	mov    %edi,%eax
  8027d2:	f7 f6                	div    %esi
  8027d4:	89 ea                	mov    %ebp,%edx
  8027d6:	83 c4 0c             	add    $0xc,%esp
  8027d9:	5e                   	pop    %esi
  8027da:	5f                   	pop    %edi
  8027db:	5d                   	pop    %ebp
  8027dc:	c3                   	ret    
  8027dd:	8d 76 00             	lea    0x0(%esi),%esi
  8027e0:	39 e8                	cmp    %ebp,%eax
  8027e2:	77 24                	ja     802808 <__udivdi3+0x78>
  8027e4:	0f bd e8             	bsr    %eax,%ebp
  8027e7:	83 f5 1f             	xor    $0x1f,%ebp
  8027ea:	75 3c                	jne    802828 <__udivdi3+0x98>
  8027ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8027f0:	39 34 24             	cmp    %esi,(%esp)
  8027f3:	0f 86 9f 00 00 00    	jbe    802898 <__udivdi3+0x108>
  8027f9:	39 d0                	cmp    %edx,%eax
  8027fb:	0f 82 97 00 00 00    	jb     802898 <__udivdi3+0x108>
  802801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802808:	31 d2                	xor    %edx,%edx
  80280a:	31 c0                	xor    %eax,%eax
  80280c:	83 c4 0c             	add    $0xc,%esp
  80280f:	5e                   	pop    %esi
  802810:	5f                   	pop    %edi
  802811:	5d                   	pop    %ebp
  802812:	c3                   	ret    
  802813:	90                   	nop
  802814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802818:	89 f8                	mov    %edi,%eax
  80281a:	f7 f1                	div    %ecx
  80281c:	31 d2                	xor    %edx,%edx
  80281e:	83 c4 0c             	add    $0xc,%esp
  802821:	5e                   	pop    %esi
  802822:	5f                   	pop    %edi
  802823:	5d                   	pop    %ebp
  802824:	c3                   	ret    
  802825:	8d 76 00             	lea    0x0(%esi),%esi
  802828:	89 e9                	mov    %ebp,%ecx
  80282a:	8b 3c 24             	mov    (%esp),%edi
  80282d:	d3 e0                	shl    %cl,%eax
  80282f:	89 c6                	mov    %eax,%esi
  802831:	b8 20 00 00 00       	mov    $0x20,%eax
  802836:	29 e8                	sub    %ebp,%eax
  802838:	89 c1                	mov    %eax,%ecx
  80283a:	d3 ef                	shr    %cl,%edi
  80283c:	89 e9                	mov    %ebp,%ecx
  80283e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802842:	8b 3c 24             	mov    (%esp),%edi
  802845:	09 74 24 08          	or     %esi,0x8(%esp)
  802849:	89 d6                	mov    %edx,%esi
  80284b:	d3 e7                	shl    %cl,%edi
  80284d:	89 c1                	mov    %eax,%ecx
  80284f:	89 3c 24             	mov    %edi,(%esp)
  802852:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802856:	d3 ee                	shr    %cl,%esi
  802858:	89 e9                	mov    %ebp,%ecx
  80285a:	d3 e2                	shl    %cl,%edx
  80285c:	89 c1                	mov    %eax,%ecx
  80285e:	d3 ef                	shr    %cl,%edi
  802860:	09 d7                	or     %edx,%edi
  802862:	89 f2                	mov    %esi,%edx
  802864:	89 f8                	mov    %edi,%eax
  802866:	f7 74 24 08          	divl   0x8(%esp)
  80286a:	89 d6                	mov    %edx,%esi
  80286c:	89 c7                	mov    %eax,%edi
  80286e:	f7 24 24             	mull   (%esp)
  802871:	39 d6                	cmp    %edx,%esi
  802873:	89 14 24             	mov    %edx,(%esp)
  802876:	72 30                	jb     8028a8 <__udivdi3+0x118>
  802878:	8b 54 24 04          	mov    0x4(%esp),%edx
  80287c:	89 e9                	mov    %ebp,%ecx
  80287e:	d3 e2                	shl    %cl,%edx
  802880:	39 c2                	cmp    %eax,%edx
  802882:	73 05                	jae    802889 <__udivdi3+0xf9>
  802884:	3b 34 24             	cmp    (%esp),%esi
  802887:	74 1f                	je     8028a8 <__udivdi3+0x118>
  802889:	89 f8                	mov    %edi,%eax
  80288b:	31 d2                	xor    %edx,%edx
  80288d:	e9 7a ff ff ff       	jmp    80280c <__udivdi3+0x7c>
  802892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802898:	31 d2                	xor    %edx,%edx
  80289a:	b8 01 00 00 00       	mov    $0x1,%eax
  80289f:	e9 68 ff ff ff       	jmp    80280c <__udivdi3+0x7c>
  8028a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8028ab:	31 d2                	xor    %edx,%edx
  8028ad:	83 c4 0c             	add    $0xc,%esp
  8028b0:	5e                   	pop    %esi
  8028b1:	5f                   	pop    %edi
  8028b2:	5d                   	pop    %ebp
  8028b3:	c3                   	ret    
  8028b4:	66 90                	xchg   %ax,%ax
  8028b6:	66 90                	xchg   %ax,%ax
  8028b8:	66 90                	xchg   %ax,%ax
  8028ba:	66 90                	xchg   %ax,%ax
  8028bc:	66 90                	xchg   %ax,%ax
  8028be:	66 90                	xchg   %ax,%ax

008028c0 <__umoddi3>:
  8028c0:	55                   	push   %ebp
  8028c1:	57                   	push   %edi
  8028c2:	56                   	push   %esi
  8028c3:	83 ec 14             	sub    $0x14,%esp
  8028c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8028d2:	89 c7                	mov    %eax,%edi
  8028d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8028dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8028e0:	89 34 24             	mov    %esi,(%esp)
  8028e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	89 c2                	mov    %eax,%edx
  8028eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028ef:	75 17                	jne    802908 <__umoddi3+0x48>
  8028f1:	39 fe                	cmp    %edi,%esi
  8028f3:	76 4b                	jbe    802940 <__umoddi3+0x80>
  8028f5:	89 c8                	mov    %ecx,%eax
  8028f7:	89 fa                	mov    %edi,%edx
  8028f9:	f7 f6                	div    %esi
  8028fb:	89 d0                	mov    %edx,%eax
  8028fd:	31 d2                	xor    %edx,%edx
  8028ff:	83 c4 14             	add    $0x14,%esp
  802902:	5e                   	pop    %esi
  802903:	5f                   	pop    %edi
  802904:	5d                   	pop    %ebp
  802905:	c3                   	ret    
  802906:	66 90                	xchg   %ax,%ax
  802908:	39 f8                	cmp    %edi,%eax
  80290a:	77 54                	ja     802960 <__umoddi3+0xa0>
  80290c:	0f bd e8             	bsr    %eax,%ebp
  80290f:	83 f5 1f             	xor    $0x1f,%ebp
  802912:	75 5c                	jne    802970 <__umoddi3+0xb0>
  802914:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802918:	39 3c 24             	cmp    %edi,(%esp)
  80291b:	0f 87 e7 00 00 00    	ja     802a08 <__umoddi3+0x148>
  802921:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802925:	29 f1                	sub    %esi,%ecx
  802927:	19 c7                	sbb    %eax,%edi
  802929:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80292d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802931:	8b 44 24 08          	mov    0x8(%esp),%eax
  802935:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802939:	83 c4 14             	add    $0x14,%esp
  80293c:	5e                   	pop    %esi
  80293d:	5f                   	pop    %edi
  80293e:	5d                   	pop    %ebp
  80293f:	c3                   	ret    
  802940:	85 f6                	test   %esi,%esi
  802942:	89 f5                	mov    %esi,%ebp
  802944:	75 0b                	jne    802951 <__umoddi3+0x91>
  802946:	b8 01 00 00 00       	mov    $0x1,%eax
  80294b:	31 d2                	xor    %edx,%edx
  80294d:	f7 f6                	div    %esi
  80294f:	89 c5                	mov    %eax,%ebp
  802951:	8b 44 24 04          	mov    0x4(%esp),%eax
  802955:	31 d2                	xor    %edx,%edx
  802957:	f7 f5                	div    %ebp
  802959:	89 c8                	mov    %ecx,%eax
  80295b:	f7 f5                	div    %ebp
  80295d:	eb 9c                	jmp    8028fb <__umoddi3+0x3b>
  80295f:	90                   	nop
  802960:	89 c8                	mov    %ecx,%eax
  802962:	89 fa                	mov    %edi,%edx
  802964:	83 c4 14             	add    $0x14,%esp
  802967:	5e                   	pop    %esi
  802968:	5f                   	pop    %edi
  802969:	5d                   	pop    %ebp
  80296a:	c3                   	ret    
  80296b:	90                   	nop
  80296c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802970:	8b 04 24             	mov    (%esp),%eax
  802973:	be 20 00 00 00       	mov    $0x20,%esi
  802978:	89 e9                	mov    %ebp,%ecx
  80297a:	29 ee                	sub    %ebp,%esi
  80297c:	d3 e2                	shl    %cl,%edx
  80297e:	89 f1                	mov    %esi,%ecx
  802980:	d3 e8                	shr    %cl,%eax
  802982:	89 e9                	mov    %ebp,%ecx
  802984:	89 44 24 04          	mov    %eax,0x4(%esp)
  802988:	8b 04 24             	mov    (%esp),%eax
  80298b:	09 54 24 04          	or     %edx,0x4(%esp)
  80298f:	89 fa                	mov    %edi,%edx
  802991:	d3 e0                	shl    %cl,%eax
  802993:	89 f1                	mov    %esi,%ecx
  802995:	89 44 24 08          	mov    %eax,0x8(%esp)
  802999:	8b 44 24 10          	mov    0x10(%esp),%eax
  80299d:	d3 ea                	shr    %cl,%edx
  80299f:	89 e9                	mov    %ebp,%ecx
  8029a1:	d3 e7                	shl    %cl,%edi
  8029a3:	89 f1                	mov    %esi,%ecx
  8029a5:	d3 e8                	shr    %cl,%eax
  8029a7:	89 e9                	mov    %ebp,%ecx
  8029a9:	09 f8                	or     %edi,%eax
  8029ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8029af:	f7 74 24 04          	divl   0x4(%esp)
  8029b3:	d3 e7                	shl    %cl,%edi
  8029b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029b9:	89 d7                	mov    %edx,%edi
  8029bb:	f7 64 24 08          	mull   0x8(%esp)
  8029bf:	39 d7                	cmp    %edx,%edi
  8029c1:	89 c1                	mov    %eax,%ecx
  8029c3:	89 14 24             	mov    %edx,(%esp)
  8029c6:	72 2c                	jb     8029f4 <__umoddi3+0x134>
  8029c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8029cc:	72 22                	jb     8029f0 <__umoddi3+0x130>
  8029ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8029d2:	29 c8                	sub    %ecx,%eax
  8029d4:	19 d7                	sbb    %edx,%edi
  8029d6:	89 e9                	mov    %ebp,%ecx
  8029d8:	89 fa                	mov    %edi,%edx
  8029da:	d3 e8                	shr    %cl,%eax
  8029dc:	89 f1                	mov    %esi,%ecx
  8029de:	d3 e2                	shl    %cl,%edx
  8029e0:	89 e9                	mov    %ebp,%ecx
  8029e2:	d3 ef                	shr    %cl,%edi
  8029e4:	09 d0                	or     %edx,%eax
  8029e6:	89 fa                	mov    %edi,%edx
  8029e8:	83 c4 14             	add    $0x14,%esp
  8029eb:	5e                   	pop    %esi
  8029ec:	5f                   	pop    %edi
  8029ed:	5d                   	pop    %ebp
  8029ee:	c3                   	ret    
  8029ef:	90                   	nop
  8029f0:	39 d7                	cmp    %edx,%edi
  8029f2:	75 da                	jne    8029ce <__umoddi3+0x10e>
  8029f4:	8b 14 24             	mov    (%esp),%edx
  8029f7:	89 c1                	mov    %eax,%ecx
  8029f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8029fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802a01:	eb cb                	jmp    8029ce <__umoddi3+0x10e>
  802a03:	90                   	nop
  802a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802a0c:	0f 82 0f ff ff ff    	jb     802921 <__umoddi3+0x61>
  802a12:	e9 1a ff ff ff       	jmp    802931 <__umoddi3+0x71>
