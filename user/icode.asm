
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 27 01 00 00       	call   800158 <libmain>
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
  800038:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 40 80 00 20 	movl   $0x802e20,0x804000
  800045:	2e 80 00 

	cprintf("icode startup\n");
  800048:	c7 04 24 26 2e 80 00 	movl   $0x802e26,(%esp)
  80004f:	e8 62 02 00 00       	call   8002b6 <cprintf>

	cprintf("icode: open /motd\n");
  800054:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  80005b:	e8 56 02 00 00       	call   8002b6 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800060:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800067:	00 
  800068:	c7 04 24 48 2e 80 00 	movl   $0x802e48,(%esp)
  80006f:	e8 82 18 00 00       	call   8018f6 <open>
  800074:	89 c6                	mov    %eax,%esi
  800076:	85 c0                	test   %eax,%eax
  800078:	79 20                	jns    80009a <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007e:	c7 44 24 08 4e 2e 80 	movl   $0x802e4e,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 64 2e 80 00 	movl   $0x802e64,(%esp)
  800095:	e8 23 01 00 00       	call   8001bd <_panic>

	cprintf("icode: read /motd\n");
  80009a:	c7 04 24 71 2e 80 00 	movl   $0x802e71,(%esp)
  8000a1:	e8 10 02 00 00       	call   8002b6 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a6:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ac:	eb 0c                	jmp    8000ba <umain+0x87>
		sys_cputs(buf, n);
  8000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b2:	89 1c 24             	mov    %ebx,(%esp)
  8000b5:	e8 6c 0b 00 00       	call   800c26 <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ba:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c1:	00 
  8000c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c6:	89 34 24             	mov    %esi,(%esp)
  8000c9:	e8 5c 13 00 00       	call   80142a <read>
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f dc                	jg     8000ae <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d2:	c7 04 24 84 2e 80 00 	movl   $0x802e84,(%esp)
  8000d9:	e8 d8 01 00 00       	call   8002b6 <cprintf>
	close(fd);
  8000de:	89 34 24             	mov    %esi,(%esp)
  8000e1:	e8 e1 11 00 00       	call   8012c7 <close>

	cprintf("icode: spawn /init\n");
  8000e6:	c7 04 24 98 2e 80 00 	movl   $0x802e98,(%esp)
  8000ed:	e8 c4 01 00 00       	call   8002b6 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000f9:	00 
  8000fa:	c7 44 24 0c ac 2e 80 	movl   $0x802eac,0xc(%esp)
  800101:	00 
  800102:	c7 44 24 08 b5 2e 80 	movl   $0x802eb5,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 bf 2e 80 	movl   $0x802ebf,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 be 2e 80 00 	movl   $0x802ebe,(%esp)
  800119:	e8 69 1e 00 00       	call   801f87 <spawnl>
  80011e:	85 c0                	test   %eax,%eax
  800120:	79 20                	jns    800142 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800126:	c7 44 24 08 c4 2e 80 	movl   $0x802ec4,0x8(%esp)
  80012d:	00 
  80012e:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800135:	00 
  800136:	c7 04 24 64 2e 80 00 	movl   $0x802e64,(%esp)
  80013d:	e8 7b 00 00 00       	call   8001bd <_panic>

	cprintf("icode: exiting\n");
  800142:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  800149:	e8 68 01 00 00       	call   8002b6 <cprintf>
}
  80014e:	81 c4 30 02 00 00    	add    $0x230,%esp
  800154:	5b                   	pop    %ebx
  800155:	5e                   	pop    %esi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 10             	sub    $0x10,%esp
  800160:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800163:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800166:	e8 4a 0b 00 00       	call   800cb5 <sys_getenvid>
  80016b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800170:	89 c2                	mov    %eax,%edx
  800172:	c1 e2 07             	shl    $0x7,%edx
  800175:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80017c:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800181:	85 db                	test   %ebx,%ebx
  800183:	7e 07                	jle    80018c <libmain+0x34>
		binaryname = argv[0];
  800185:	8b 06                	mov    (%esi),%eax
  800187:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80018c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800190:	89 1c 24             	mov    %ebx,(%esp)
  800193:	e8 9b fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800198:	e8 07 00 00 00       	call   8001a4 <exit>
}
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	5b                   	pop    %ebx
  8001a1:	5e                   	pop    %esi
  8001a2:	5d                   	pop    %ebp
  8001a3:	c3                   	ret    

008001a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001aa:	e8 4b 11 00 00       	call   8012fa <close_all>
	sys_env_destroy(0);
  8001af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001b6:	e8 a8 0a 00 00       	call   800c63 <sys_env_destroy>
}
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001c5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c8:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001ce:	e8 e2 0a 00 00       	call   800cb5 <sys_getenvid>
  8001d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001da:	8b 55 08             	mov    0x8(%ebp),%edx
  8001dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001e1:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e9:	c7 04 24 f8 2e 80 00 	movl   $0x802ef8,(%esp)
  8001f0:	e8 c1 00 00 00       	call   8002b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fc:	89 04 24             	mov    %eax,(%esp)
  8001ff:	e8 51 00 00 00       	call   800255 <vcprintf>
	cprintf("\n");
  800204:	c7 04 24 5f 34 80 00 	movl   $0x80345f,(%esp)
  80020b:	e8 a6 00 00 00       	call   8002b6 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800210:	cc                   	int3   
  800211:	eb fd                	jmp    800210 <_panic+0x53>

00800213 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	53                   	push   %ebx
  800217:	83 ec 14             	sub    $0x14,%esp
  80021a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80021d:	8b 13                	mov    (%ebx),%edx
  80021f:	8d 42 01             	lea    0x1(%edx),%eax
  800222:	89 03                	mov    %eax,(%ebx)
  800224:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800227:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80022b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800230:	75 19                	jne    80024b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800232:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800239:	00 
  80023a:	8d 43 08             	lea    0x8(%ebx),%eax
  80023d:	89 04 24             	mov    %eax,(%esp)
  800240:	e8 e1 09 00 00       	call   800c26 <sys_cputs>
		b->idx = 0;
  800245:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80024b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80024f:	83 c4 14             	add    $0x14,%esp
  800252:	5b                   	pop    %ebx
  800253:	5d                   	pop    %ebp
  800254:	c3                   	ret    

00800255 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80025e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800265:	00 00 00 
	b.cnt = 0;
  800268:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800279:	8b 45 08             	mov    0x8(%ebp),%eax
  80027c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800280:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800286:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028a:	c7 04 24 13 02 80 00 	movl   $0x800213,(%esp)
  800291:	e8 a8 01 00 00       	call   80043e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800296:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80029c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a6:	89 04 24             	mov    %eax,(%esp)
  8002a9:	e8 78 09 00 00       	call   800c26 <sys_cputs>

	return b.cnt;
}
  8002ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	89 04 24             	mov    %eax,(%esp)
  8002c9:	e8 87 ff ff ff       	call   800255 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 3c             	sub    $0x3c,%esp
  8002d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002dc:	89 d7                	mov    %edx,%edi
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e7:	89 c3                	mov    %eax,%ebx
  8002e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002fd:	39 d9                	cmp    %ebx,%ecx
  8002ff:	72 05                	jb     800306 <printnum+0x36>
  800301:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800304:	77 69                	ja     80036f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800306:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800309:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80030d:	83 ee 01             	sub    $0x1,%esi
  800310:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800314:	89 44 24 08          	mov    %eax,0x8(%esp)
  800318:	8b 44 24 08          	mov    0x8(%esp),%eax
  80031c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800320:	89 c3                	mov    %eax,%ebx
  800322:	89 d6                	mov    %edx,%esi
  800324:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800327:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80032a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80032e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 3c 28 00 00       	call   802b80 <__udivdi3>
  800344:	89 d9                	mov    %ebx,%ecx
  800346:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80034a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80034e:	89 04 24             	mov    %eax,(%esp)
  800351:	89 54 24 04          	mov    %edx,0x4(%esp)
  800355:	89 fa                	mov    %edi,%edx
  800357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80035a:	e8 71 ff ff ff       	call   8002d0 <printnum>
  80035f:	eb 1b                	jmp    80037c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800361:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800365:	8b 45 18             	mov    0x18(%ebp),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	ff d3                	call   *%ebx
  80036d:	eb 03                	jmp    800372 <printnum+0xa2>
  80036f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800372:	83 ee 01             	sub    $0x1,%esi
  800375:	85 f6                	test   %esi,%esi
  800377:	7f e8                	jg     800361 <printnum+0x91>
  800379:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800380:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800384:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800387:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80038a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039f:	e8 0c 29 00 00       	call   802cb0 <__umoddi3>
  8003a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a8:	0f be 80 1b 2f 80 00 	movsbl 0x802f1b(%eax),%eax
  8003af:	89 04 24             	mov    %eax,(%esp)
  8003b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b5:	ff d0                	call   *%eax
}
  8003b7:	83 c4 3c             	add    $0x3c,%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c2:	83 fa 01             	cmp    $0x1,%edx
  8003c5:	7e 0e                	jle    8003d5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003c7:	8b 10                	mov    (%eax),%edx
  8003c9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003cc:	89 08                	mov    %ecx,(%eax)
  8003ce:	8b 02                	mov    (%edx),%eax
  8003d0:	8b 52 04             	mov    0x4(%edx),%edx
  8003d3:	eb 22                	jmp    8003f7 <getuint+0x38>
	else if (lflag)
  8003d5:	85 d2                	test   %edx,%edx
  8003d7:	74 10                	je     8003e9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 02                	mov    (%edx),%eax
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e7:	eb 0e                	jmp    8003f7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ee:	89 08                	mov    %ecx,(%eax)
  8003f0:	8b 02                	mov    (%edx),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f7:	5d                   	pop    %ebp
  8003f8:	c3                   	ret    

008003f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800403:	8b 10                	mov    (%eax),%edx
  800405:	3b 50 04             	cmp    0x4(%eax),%edx
  800408:	73 0a                	jae    800414 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80040d:	89 08                	mov    %ecx,(%eax)
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	88 02                	mov    %al,(%edx)
}
  800414:	5d                   	pop    %ebp
  800415:	c3                   	ret    

00800416 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80041c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80041f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	89 44 24 08          	mov    %eax,0x8(%esp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	89 04 24             	mov    %eax,(%esp)
  800437:	e8 02 00 00 00       	call   80043e <vprintfmt>
	va_end(ap);
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	57                   	push   %edi
  800442:	56                   	push   %esi
  800443:	53                   	push   %ebx
  800444:	83 ec 3c             	sub    $0x3c,%esp
  800447:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80044a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80044d:	eb 14                	jmp    800463 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80044f:	85 c0                	test   %eax,%eax
  800451:	0f 84 b3 03 00 00    	je     80080a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800457:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80045b:	89 04 24             	mov    %eax,(%esp)
  80045e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800461:	89 f3                	mov    %esi,%ebx
  800463:	8d 73 01             	lea    0x1(%ebx),%esi
  800466:	0f b6 03             	movzbl (%ebx),%eax
  800469:	83 f8 25             	cmp    $0x25,%eax
  80046c:	75 e1                	jne    80044f <vprintfmt+0x11>
  80046e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800472:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800479:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800480:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800487:	ba 00 00 00 00       	mov    $0x0,%edx
  80048c:	eb 1d                	jmp    8004ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800490:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800494:	eb 15                	jmp    8004ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800496:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800498:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80049c:	eb 0d                	jmp    8004ab <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80049e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004ae:	0f b6 0e             	movzbl (%esi),%ecx
  8004b1:	0f b6 c1             	movzbl %cl,%eax
  8004b4:	83 e9 23             	sub    $0x23,%ecx
  8004b7:	80 f9 55             	cmp    $0x55,%cl
  8004ba:	0f 87 2a 03 00 00    	ja     8007ea <vprintfmt+0x3ac>
  8004c0:	0f b6 c9             	movzbl %cl,%ecx
  8004c3:	ff 24 8d a0 30 80 00 	jmp    *0x8030a0(,%ecx,4)
  8004ca:	89 de                	mov    %ebx,%esi
  8004cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004d1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004d4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004d8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004db:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004de:	83 fb 09             	cmp    $0x9,%ebx
  8004e1:	77 36                	ja     800519 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004e6:	eb e9                	jmp    8004d1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ee:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004f8:	eb 22                	jmp    80051c <vprintfmt+0xde>
  8004fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	0f 49 c1             	cmovns %ecx,%eax
  800507:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	89 de                	mov    %ebx,%esi
  80050c:	eb 9d                	jmp    8004ab <vprintfmt+0x6d>
  80050e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800510:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800517:	eb 92                	jmp    8004ab <vprintfmt+0x6d>
  800519:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80051c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800520:	79 89                	jns    8004ab <vprintfmt+0x6d>
  800522:	e9 77 ff ff ff       	jmp    80049e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800527:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80052c:	e9 7a ff ff ff       	jmp    8004ab <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 50 04             	lea    0x4(%eax),%edx
  800537:	89 55 14             	mov    %edx,0x14(%ebp)
  80053a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 04 24             	mov    %eax,(%esp)
  800543:	ff 55 08             	call   *0x8(%ebp)
			break;
  800546:	e9 18 ff ff ff       	jmp    800463 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 50 04             	lea    0x4(%eax),%edx
  800551:	89 55 14             	mov    %edx,0x14(%ebp)
  800554:	8b 00                	mov    (%eax),%eax
  800556:	99                   	cltd   
  800557:	31 d0                	xor    %edx,%eax
  800559:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055b:	83 f8 12             	cmp    $0x12,%eax
  80055e:	7f 0b                	jg     80056b <vprintfmt+0x12d>
  800560:	8b 14 85 00 32 80 00 	mov    0x803200(,%eax,4),%edx
  800567:	85 d2                	test   %edx,%edx
  800569:	75 20                	jne    80058b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80056b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80056f:	c7 44 24 08 33 2f 80 	movl   $0x802f33,0x8(%esp)
  800576:	00 
  800577:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	89 04 24             	mov    %eax,(%esp)
  800581:	e8 90 fe ff ff       	call   800416 <printfmt>
  800586:	e9 d8 fe ff ff       	jmp    800463 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80058b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80058f:	c7 44 24 08 41 33 80 	movl   $0x803341,0x8(%esp)
  800596:	00 
  800597:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	89 04 24             	mov    %eax,(%esp)
  8005a1:	e8 70 fe ff ff       	call   800416 <printfmt>
  8005a6:	e9 b8 fe ff ff       	jmp    800463 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ab:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8005bd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005bf:	85 f6                	test   %esi,%esi
  8005c1:	b8 2c 2f 80 00       	mov    $0x802f2c,%eax
  8005c6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005cd:	0f 84 97 00 00 00    	je     80066a <vprintfmt+0x22c>
  8005d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005d7:	0f 8e 9b 00 00 00    	jle    800678 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005e1:	89 34 24             	mov    %esi,(%esp)
  8005e4:	e8 cf 02 00 00       	call   8008b8 <strnlen>
  8005e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ec:	29 c2                	sub    %eax,%edx
  8005ee:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005f1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800601:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800603:	eb 0f                	jmp    800614 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800605:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800609:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060c:	89 04 24             	mov    %eax,(%esp)
  80060f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800611:	83 eb 01             	sub    $0x1,%ebx
  800614:	85 db                	test   %ebx,%ebx
  800616:	7f ed                	jg     800605 <vprintfmt+0x1c7>
  800618:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80061b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80061e:	85 d2                	test   %edx,%edx
  800620:	b8 00 00 00 00       	mov    $0x0,%eax
  800625:	0f 49 c2             	cmovns %edx,%eax
  800628:	29 c2                	sub    %eax,%edx
  80062a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062d:	89 d7                	mov    %edx,%edi
  80062f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800632:	eb 50                	jmp    800684 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800634:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800638:	74 1e                	je     800658 <vprintfmt+0x21a>
  80063a:	0f be d2             	movsbl %dl,%edx
  80063d:	83 ea 20             	sub    $0x20,%edx
  800640:	83 fa 5e             	cmp    $0x5e,%edx
  800643:	76 13                	jbe    800658 <vprintfmt+0x21a>
					putch('?', putdat);
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800653:	ff 55 08             	call   *0x8(%ebp)
  800656:	eb 0d                	jmp    800665 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800665:	83 ef 01             	sub    $0x1,%edi
  800668:	eb 1a                	jmp    800684 <vprintfmt+0x246>
  80066a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80066d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800670:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800673:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800676:	eb 0c                	jmp    800684 <vprintfmt+0x246>
  800678:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80067b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80067e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800681:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800684:	83 c6 01             	add    $0x1,%esi
  800687:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80068b:	0f be c2             	movsbl %dl,%eax
  80068e:	85 c0                	test   %eax,%eax
  800690:	74 27                	je     8006b9 <vprintfmt+0x27b>
  800692:	85 db                	test   %ebx,%ebx
  800694:	78 9e                	js     800634 <vprintfmt+0x1f6>
  800696:	83 eb 01             	sub    $0x1,%ebx
  800699:	79 99                	jns    800634 <vprintfmt+0x1f6>
  80069b:	89 f8                	mov    %edi,%eax
  80069d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a3:	89 c3                	mov    %eax,%ebx
  8006a5:	eb 1a                	jmp    8006c1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ab:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006b2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b4:	83 eb 01             	sub    $0x1,%ebx
  8006b7:	eb 08                	jmp    8006c1 <vprintfmt+0x283>
  8006b9:	89 fb                	mov    %edi,%ebx
  8006bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006c1:	85 db                	test   %ebx,%ebx
  8006c3:	7f e2                	jg     8006a7 <vprintfmt+0x269>
  8006c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006cb:	e9 93 fd ff ff       	jmp    800463 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006d0:	83 fa 01             	cmp    $0x1,%edx
  8006d3:	7e 16                	jle    8006eb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8d 50 08             	lea    0x8(%eax),%edx
  8006db:	89 55 14             	mov    %edx,0x14(%ebp)
  8006de:	8b 50 04             	mov    0x4(%eax),%edx
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006e9:	eb 32                	jmp    80071d <vprintfmt+0x2df>
	else if (lflag)
  8006eb:	85 d2                	test   %edx,%edx
  8006ed:	74 18                	je     800707 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 50 04             	lea    0x4(%eax),%edx
  8006f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f8:	8b 30                	mov    (%eax),%esi
  8006fa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006fd:	89 f0                	mov    %esi,%eax
  8006ff:	c1 f8 1f             	sar    $0x1f,%eax
  800702:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800705:	eb 16                	jmp    80071d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8d 50 04             	lea    0x4(%eax),%edx
  80070d:	89 55 14             	mov    %edx,0x14(%ebp)
  800710:	8b 30                	mov    (%eax),%esi
  800712:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800715:	89 f0                	mov    %esi,%eax
  800717:	c1 f8 1f             	sar    $0x1f,%eax
  80071a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800723:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800728:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072c:	0f 89 80 00 00 00    	jns    8007b2 <vprintfmt+0x374>
				putch('-', putdat);
  800732:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800736:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80073d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800740:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800743:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800746:	f7 d8                	neg    %eax
  800748:	83 d2 00             	adc    $0x0,%edx
  80074b:	f7 da                	neg    %edx
			}
			base = 10;
  80074d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800752:	eb 5e                	jmp    8007b2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800754:	8d 45 14             	lea    0x14(%ebp),%eax
  800757:	e8 63 fc ff ff       	call   8003bf <getuint>
			base = 10;
  80075c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800761:	eb 4f                	jmp    8007b2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800763:	8d 45 14             	lea    0x14(%ebp),%eax
  800766:	e8 54 fc ff ff       	call   8003bf <getuint>
			base = 8;
  80076b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800770:	eb 40                	jmp    8007b2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800772:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800776:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80077d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800780:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800784:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80078b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8d 50 04             	lea    0x4(%eax),%edx
  800794:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80079e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007a3:	eb 0d                	jmp    8007b2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a8:	e8 12 fc ff ff       	call   8003bf <getuint>
			base = 16;
  8007ad:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007b6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ba:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007bd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007c5:	89 04 24             	mov    %eax,(%esp)
  8007c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007cc:	89 fa                	mov    %edi,%edx
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	e8 fa fa ff ff       	call   8002d0 <printnum>
			break;
  8007d6:	e9 88 fc ff ff       	jmp    800463 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007db:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007df:	89 04 24             	mov    %eax,(%esp)
  8007e2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007e5:	e9 79 fc ff ff       	jmp    800463 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ee:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007f5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f8:	89 f3                	mov    %esi,%ebx
  8007fa:	eb 03                	jmp    8007ff <vprintfmt+0x3c1>
  8007fc:	83 eb 01             	sub    $0x1,%ebx
  8007ff:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800803:	75 f7                	jne    8007fc <vprintfmt+0x3be>
  800805:	e9 59 fc ff ff       	jmp    800463 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80080a:	83 c4 3c             	add    $0x3c,%esp
  80080d:	5b                   	pop    %ebx
  80080e:	5e                   	pop    %esi
  80080f:	5f                   	pop    %edi
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 28             	sub    $0x28,%esp
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80081e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800821:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800825:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 30                	je     800863 <vsnprintf+0x51>
  800833:	85 d2                	test   %edx,%edx
  800835:	7e 2c                	jle    800863 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	89 44 24 08          	mov    %eax,0x8(%esp)
  800845:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	c7 04 24 f9 03 80 00 	movl   $0x8003f9,(%esp)
  800853:	e8 e6 fb ff ff       	call   80043e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800861:	eb 05                	jmp    800868 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800870:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800873:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800877:	8b 45 10             	mov    0x10(%ebp),%eax
  80087a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800881:	89 44 24 04          	mov    %eax,0x4(%esp)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 04 24             	mov    %eax,(%esp)
  80088b:	e8 82 ff ff ff       	call   800812 <vsnprintf>
	va_end(ap);

	return rc;
}
  800890:	c9                   	leave  
  800891:	c3                   	ret    
  800892:	66 90                	xchg   %ax,%ax
  800894:	66 90                	xchg   %ax,%ax
  800896:	66 90                	xchg   %ax,%ax
  800898:	66 90                	xchg   %ax,%ax
  80089a:	66 90                	xchg   %ax,%ax
  80089c:	66 90                	xchg   %ax,%ax
  80089e:	66 90                	xchg   %ax,%ax

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	eb 03                	jmp    8008b0 <strlen+0x10>
		n++;
  8008ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b4:	75 f7                	jne    8008ad <strlen+0xd>
		n++;
	return n;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	eb 03                	jmp    8008cb <strnlen+0x13>
		n++;
  8008c8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cb:	39 d0                	cmp    %edx,%eax
  8008cd:	74 06                	je     8008d5 <strnlen+0x1d>
  8008cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d3:	75 f3                	jne    8008c8 <strnlen+0x10>
		n++;
	return n;
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e1:	89 c2                	mov    %eax,%edx
  8008e3:	83 c2 01             	add    $0x1,%edx
  8008e6:	83 c1 01             	add    $0x1,%ecx
  8008e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ed:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f0:	84 db                	test   %bl,%bl
  8008f2:	75 ef                	jne    8008e3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800901:	89 1c 24             	mov    %ebx,(%esp)
  800904:	e8 97 ff ff ff       	call   8008a0 <strlen>
	strcpy(dst + len, src);
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800910:	01 d8                	add    %ebx,%eax
  800912:	89 04 24             	mov    %eax,(%esp)
  800915:	e8 bd ff ff ff       	call   8008d7 <strcpy>
	return dst;
}
  80091a:	89 d8                	mov    %ebx,%eax
  80091c:	83 c4 08             	add    $0x8,%esp
  80091f:	5b                   	pop    %ebx
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	56                   	push   %esi
  800926:	53                   	push   %ebx
  800927:	8b 75 08             	mov    0x8(%ebp),%esi
  80092a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092d:	89 f3                	mov    %esi,%ebx
  80092f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800932:	89 f2                	mov    %esi,%edx
  800934:	eb 0f                	jmp    800945 <strncpy+0x23>
		*dst++ = *src;
  800936:	83 c2 01             	add    $0x1,%edx
  800939:	0f b6 01             	movzbl (%ecx),%eax
  80093c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093f:	80 39 01             	cmpb   $0x1,(%ecx)
  800942:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800945:	39 da                	cmp    %ebx,%edx
  800947:	75 ed                	jne    800936 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800949:	89 f0                	mov    %esi,%eax
  80094b:	5b                   	pop    %ebx
  80094c:	5e                   	pop    %esi
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	8b 75 08             	mov    0x8(%ebp),%esi
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800963:	85 c9                	test   %ecx,%ecx
  800965:	75 0b                	jne    800972 <strlcpy+0x23>
  800967:	eb 1d                	jmp    800986 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	83 c2 01             	add    $0x1,%edx
  80096f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800972:	39 d8                	cmp    %ebx,%eax
  800974:	74 0b                	je     800981 <strlcpy+0x32>
  800976:	0f b6 0a             	movzbl (%edx),%ecx
  800979:	84 c9                	test   %cl,%cl
  80097b:	75 ec                	jne    800969 <strlcpy+0x1a>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	eb 02                	jmp    800983 <strlcpy+0x34>
  800981:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800983:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800986:	29 f0                	sub    %esi,%eax
}
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800995:	eb 06                	jmp    80099d <strcmp+0x11>
		p++, q++;
  800997:	83 c1 01             	add    $0x1,%ecx
  80099a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80099d:	0f b6 01             	movzbl (%ecx),%eax
  8009a0:	84 c0                	test   %al,%al
  8009a2:	74 04                	je     8009a8 <strcmp+0x1c>
  8009a4:	3a 02                	cmp    (%edx),%al
  8009a6:	74 ef                	je     800997 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 c0             	movzbl %al,%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 c3                	mov    %eax,%ebx
  8009be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c1:	eb 06                	jmp    8009c9 <strncmp+0x17>
		n--, p++, q++;
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009c9:	39 d8                	cmp    %ebx,%eax
  8009cb:	74 15                	je     8009e2 <strncmp+0x30>
  8009cd:	0f b6 08             	movzbl (%eax),%ecx
  8009d0:	84 c9                	test   %cl,%cl
  8009d2:	74 04                	je     8009d8 <strncmp+0x26>
  8009d4:	3a 0a                	cmp    (%edx),%cl
  8009d6:	74 eb                	je     8009c3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
  8009e0:	eb 05                	jmp    8009e7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009e7:	5b                   	pop    %ebx
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f4:	eb 07                	jmp    8009fd <strchr+0x13>
		if (*s == c)
  8009f6:	38 ca                	cmp    %cl,%dl
  8009f8:	74 0f                	je     800a09 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	0f b6 10             	movzbl (%eax),%edx
  800a00:	84 d2                	test   %dl,%dl
  800a02:	75 f2                	jne    8009f6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	eb 07                	jmp    800a1e <strfind+0x13>
		if (*s == c)
  800a17:	38 ca                	cmp    %cl,%dl
  800a19:	74 0a                	je     800a25 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	0f b6 10             	movzbl (%eax),%edx
  800a21:	84 d2                	test   %dl,%dl
  800a23:	75 f2                	jne    800a17 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	74 36                	je     800a6d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a37:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3d:	75 28                	jne    800a67 <memset+0x40>
  800a3f:	f6 c1 03             	test   $0x3,%cl
  800a42:	75 23                	jne    800a67 <memset+0x40>
		c &= 0xFF;
  800a44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a48:	89 d3                	mov    %edx,%ebx
  800a4a:	c1 e3 08             	shl    $0x8,%ebx
  800a4d:	89 d6                	mov    %edx,%esi
  800a4f:	c1 e6 18             	shl    $0x18,%esi
  800a52:	89 d0                	mov    %edx,%eax
  800a54:	c1 e0 10             	shl    $0x10,%eax
  800a57:	09 f0                	or     %esi,%eax
  800a59:	09 c2                	or     %eax,%edx
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a5f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a62:	fc                   	cld    
  800a63:	f3 ab                	rep stos %eax,%es:(%edi)
  800a65:	eb 06                	jmp    800a6d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	fc                   	cld    
  800a6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6d:	89 f8                	mov    %edi,%eax
  800a6f:	5b                   	pop    %ebx
  800a70:	5e                   	pop    %esi
  800a71:	5f                   	pop    %edi
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	57                   	push   %edi
  800a78:	56                   	push   %esi
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a82:	39 c6                	cmp    %eax,%esi
  800a84:	73 35                	jae    800abb <memmove+0x47>
  800a86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a89:	39 d0                	cmp    %edx,%eax
  800a8b:	73 2e                	jae    800abb <memmove+0x47>
		s += n;
		d += n;
  800a8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a90:	89 d6                	mov    %edx,%esi
  800a92:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a94:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9a:	75 13                	jne    800aaf <memmove+0x3b>
  800a9c:	f6 c1 03             	test   $0x3,%cl
  800a9f:	75 0e                	jne    800aaf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb 09                	jmp    800ab8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 1d                	jmp    800ad8 <memmove+0x64>
  800abb:	89 f2                	mov    %esi,%edx
  800abd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	f6 c2 03             	test   $0x3,%dl
  800ac2:	75 0f                	jne    800ad3 <memmove+0x5f>
  800ac4:	f6 c1 03             	test   $0x3,%cl
  800ac7:	75 0a                	jne    800ad3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800acc:	89 c7                	mov    %eax,%edi
  800ace:	fc                   	cld    
  800acf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad1:	eb 05                	jmp    800ad8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad3:	89 c7                	mov    %eax,%edi
  800ad5:	fc                   	cld    
  800ad6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	89 04 24             	mov    %eax,(%esp)
  800af6:	e8 79 ff ff ff       	call   800a74 <memmove>
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	56                   	push   %esi
  800b01:	53                   	push   %ebx
  800b02:	8b 55 08             	mov    0x8(%ebp),%edx
  800b05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0d:	eb 1a                	jmp    800b29 <memcmp+0x2c>
		if (*s1 != *s2)
  800b0f:	0f b6 02             	movzbl (%edx),%eax
  800b12:	0f b6 19             	movzbl (%ecx),%ebx
  800b15:	38 d8                	cmp    %bl,%al
  800b17:	74 0a                	je     800b23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b19:	0f b6 c0             	movzbl %al,%eax
  800b1c:	0f b6 db             	movzbl %bl,%ebx
  800b1f:	29 d8                	sub    %ebx,%eax
  800b21:	eb 0f                	jmp    800b32 <memcmp+0x35>
		s1++, s2++;
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b29:	39 f2                	cmp    %esi,%edx
  800b2b:	75 e2                	jne    800b0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3f:	89 c2                	mov    %eax,%edx
  800b41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b44:	eb 07                	jmp    800b4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b46:	38 08                	cmp    %cl,(%eax)
  800b48:	74 07                	je     800b51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	39 d0                	cmp    %edx,%eax
  800b4f:	72 f5                	jb     800b46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5f:	eb 03                	jmp    800b64 <strtol+0x11>
		s++;
  800b61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b64:	0f b6 0a             	movzbl (%edx),%ecx
  800b67:	80 f9 09             	cmp    $0x9,%cl
  800b6a:	74 f5                	je     800b61 <strtol+0xe>
  800b6c:	80 f9 20             	cmp    $0x20,%cl
  800b6f:	74 f0                	je     800b61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b71:	80 f9 2b             	cmp    $0x2b,%cl
  800b74:	75 0a                	jne    800b80 <strtol+0x2d>
		s++;
  800b76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b79:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7e:	eb 11                	jmp    800b91 <strtol+0x3e>
  800b80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b85:	80 f9 2d             	cmp    $0x2d,%cl
  800b88:	75 07                	jne    800b91 <strtol+0x3e>
		s++, neg = 1;
  800b8a:	8d 52 01             	lea    0x1(%edx),%edx
  800b8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b96:	75 15                	jne    800bad <strtol+0x5a>
  800b98:	80 3a 30             	cmpb   $0x30,(%edx)
  800b9b:	75 10                	jne    800bad <strtol+0x5a>
  800b9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba1:	75 0a                	jne    800bad <strtol+0x5a>
		s += 2, base = 16;
  800ba3:	83 c2 02             	add    $0x2,%edx
  800ba6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bab:	eb 10                	jmp    800bbd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bad:	85 c0                	test   %eax,%eax
  800baf:	75 0c                	jne    800bbd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bb6:	75 05                	jne    800bbd <strtol+0x6a>
		s++, base = 8;
  800bb8:	83 c2 01             	add    $0x1,%edx
  800bbb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bc5:	0f b6 0a             	movzbl (%edx),%ecx
  800bc8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bcb:	89 f0                	mov    %esi,%eax
  800bcd:	3c 09                	cmp    $0x9,%al
  800bcf:	77 08                	ja     800bd9 <strtol+0x86>
			dig = *s - '0';
  800bd1:	0f be c9             	movsbl %cl,%ecx
  800bd4:	83 e9 30             	sub    $0x30,%ecx
  800bd7:	eb 20                	jmp    800bf9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bd9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bdc:	89 f0                	mov    %esi,%eax
  800bde:	3c 19                	cmp    $0x19,%al
  800be0:	77 08                	ja     800bea <strtol+0x97>
			dig = *s - 'a' + 10;
  800be2:	0f be c9             	movsbl %cl,%ecx
  800be5:	83 e9 57             	sub    $0x57,%ecx
  800be8:	eb 0f                	jmp    800bf9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bed:	89 f0                	mov    %esi,%eax
  800bef:	3c 19                	cmp    $0x19,%al
  800bf1:	77 16                	ja     800c09 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bf3:	0f be c9             	movsbl %cl,%ecx
  800bf6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bf9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bfc:	7d 0f                	jge    800c0d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bfe:	83 c2 01             	add    $0x1,%edx
  800c01:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c05:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c07:	eb bc                	jmp    800bc5 <strtol+0x72>
  800c09:	89 d8                	mov    %ebx,%eax
  800c0b:	eb 02                	jmp    800c0f <strtol+0xbc>
  800c0d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c13:	74 05                	je     800c1a <strtol+0xc7>
		*endptr = (char *) s;
  800c15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c18:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c1a:	f7 d8                	neg    %eax
  800c1c:	85 ff                	test   %edi,%edi
  800c1e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	89 c3                	mov    %eax,%ebx
  800c39:	89 c7                	mov    %eax,%edi
  800c3b:	89 c6                	mov    %eax,%esi
  800c3d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c54:	89 d1                	mov    %edx,%ecx
  800c56:	89 d3                	mov    %edx,%ebx
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	89 d6                	mov    %edx,%esi
  800c5c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	89 cb                	mov    %ecx,%ebx
  800c7b:	89 cf                	mov    %ecx,%edi
  800c7d:	89 ce                	mov    %ecx,%esi
  800c7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c81:	85 c0                	test   %eax,%eax
  800c83:	7e 28                	jle    800cad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c89:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c90:	00 
  800c91:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800c98:	00 
  800c99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca0:	00 
  800ca1:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800ca8:	e8 10 f5 ff ff       	call   8001bd <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cad:	83 c4 2c             	add    $0x2c,%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc5:	89 d1                	mov    %edx,%ecx
  800cc7:	89 d3                	mov    %edx,%ebx
  800cc9:	89 d7                	mov    %edx,%edi
  800ccb:	89 d6                	mov    %edx,%esi
  800ccd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_yield>:

void
sys_yield(void)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce4:	89 d1                	mov    %edx,%ecx
  800ce6:	89 d3                	mov    %edx,%ebx
  800ce8:	89 d7                	mov    %edx,%edi
  800cea:	89 d6                	mov    %edx,%esi
  800cec:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	be 00 00 00 00       	mov    $0x0,%esi
  800d01:	b8 04 00 00 00       	mov    $0x4,%eax
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0f:	89 f7                	mov    %esi,%edi
  800d11:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7e 28                	jle    800d3f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d22:	00 
  800d23:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800d2a:	00 
  800d2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d32:	00 
  800d33:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800d3a:	e8 7e f4 ff ff       	call   8001bd <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d3f:	83 c4 2c             	add    $0x2c,%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d50:	b8 05 00 00 00       	mov    $0x5,%eax
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d61:	8b 75 18             	mov    0x18(%ebp),%esi
  800d64:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	7e 28                	jle    800d92 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d75:	00 
  800d76:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800d7d:	00 
  800d7e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d85:	00 
  800d86:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800d8d:	e8 2b f4 ff ff       	call   8001bd <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d92:	83 c4 2c             	add    $0x2c,%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	89 de                	mov    %ebx,%esi
  800db7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7e 28                	jle    800de5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dc8:	00 
  800dc9:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800dd0:	00 
  800dd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd8:	00 
  800dd9:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800de0:	e8 d8 f3 ff ff       	call   8001bd <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de5:	83 c4 2c             	add    $0x2c,%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    

00800ded <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	b8 08 00 00 00       	mov    $0x8,%eax
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7e 28                	jle    800e38 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e14:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e1b:	00 
  800e1c:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800e23:	00 
  800e24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2b:	00 
  800e2c:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800e33:	e8 85 f3 ff ff       	call   8001bd <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e38:	83 c4 2c             	add    $0x2c,%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	89 df                	mov    %ebx,%edi
  800e5b:	89 de                	mov    %ebx,%esi
  800e5d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7e 28                	jle    800e8b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e67:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e6e:	00 
  800e6f:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800e76:	00 
  800e77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7e:	00 
  800e7f:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800e86:	e8 32 f3 ff ff       	call   8001bd <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e8b:	83 c4 2c             	add    $0x2c,%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	89 df                	mov    %ebx,%edi
  800eae:	89 de                	mov    %ebx,%esi
  800eb0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	7e 28                	jle    800ede <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eba:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ec1:	00 
  800ec2:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800ec9:	00 
  800eca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed1:	00 
  800ed2:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800ed9:	e8 df f2 ff ff       	call   8001bd <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ede:	83 c4 2c             	add    $0x2c,%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	57                   	push   %edi
  800eea:	56                   	push   %esi
  800eeb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eec:	be 00 00 00 00       	mov    $0x0,%esi
  800ef1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eff:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f02:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f17:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1f:	89 cb                	mov    %ecx,%ebx
  800f21:	89 cf                	mov    %ecx,%edi
  800f23:	89 ce                	mov    %ecx,%esi
  800f25:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	7e 28                	jle    800f53 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f36:	00 
  800f37:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f46:	00 
  800f47:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800f4e:	e8 6a f2 ff ff       	call   8001bd <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f53:	83 c4 2c             	add    $0x2c,%esp
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f61:	ba 00 00 00 00       	mov    $0x0,%edx
  800f66:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f6b:	89 d1                	mov    %edx,%ecx
  800f6d:	89 d3                	mov    %edx,%ebx
  800f6f:	89 d7                	mov    %edx,%edi
  800f71:	89 d6                	mov    %edx,%esi
  800f73:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	89 df                	mov    %ebx,%edi
  800f95:	89 de                	mov    %ebx,%esi
  800f97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	7e 28                	jle    800fc5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fa8:	00 
  800fa9:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  800fb0:	00 
  800fb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb8:	00 
  800fb9:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800fc0:	e8 f8 f1 ff ff       	call   8001bd <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800fc5:	83 c4 2c             	add    $0x2c,%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	b8 10 00 00 00       	mov    $0x10,%eax
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe6:	89 df                	mov    %ebx,%edi
  800fe8:	89 de                	mov    %ebx,%esi
  800fea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7e 28                	jle    801018 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  801003:	00 
  801004:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100b:	00 
  80100c:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  801013:	e8 a5 f1 ff ff       	call   8001bd <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801018:	83 c4 2c             	add    $0x2c,%esp
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801029:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102e:	b8 11 00 00 00       	mov    $0x11,%eax
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 df                	mov    %ebx,%edi
  80103b:	89 de                	mov    %ebx,%esi
  80103d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7e 28                	jle    80106b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	89 44 24 10          	mov    %eax,0x10(%esp)
  801047:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80104e:	00 
  80104f:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  801056:	00 
  801057:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105e:	00 
  80105f:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  801066:	e8 52 f1 ff ff       	call   8001bd <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80106b:	83 c4 2c             	add    $0x2c,%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <sys_sleep>:

int
sys_sleep(int channel)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	57                   	push   %edi
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
  801079:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801081:	b8 12 00 00 00       	mov    $0x12,%eax
  801086:	8b 55 08             	mov    0x8(%ebp),%edx
  801089:	89 cb                	mov    %ecx,%ebx
  80108b:	89 cf                	mov    %ecx,%edi
  80108d:	89 ce                	mov    %ecx,%esi
  80108f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801091:	85 c0                	test   %eax,%eax
  801093:	7e 28                	jle    8010bd <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801095:	89 44 24 10          	mov    %eax,0x10(%esp)
  801099:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8010a0:	00 
  8010a1:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  8010a8:	00 
  8010a9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b0:	00 
  8010b1:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  8010b8:	e8 00 f1 ff ff       	call   8001bd <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  8010bd:	83 c4 2c             	add    $0x2c,%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    

008010c5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	57                   	push   %edi
  8010c9:	56                   	push   %esi
  8010ca:	53                   	push   %ebx
  8010cb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d3:	b8 13 00 00 00       	mov    $0x13,%eax
  8010d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010db:	8b 55 08             	mov    0x8(%ebp),%edx
  8010de:	89 df                	mov    %ebx,%edi
  8010e0:	89 de                	mov    %ebx,%esi
  8010e2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	7e 28                	jle    801110 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ec:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8010f3:	00 
  8010f4:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  8010fb:	00 
  8010fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801103:	00 
  801104:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  80110b:	e8 ad f0 ff ff       	call   8001bd <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801110:	83 c4 2c             	add    $0x2c,%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
  801118:	66 90                	xchg   %ax,%ax
  80111a:	66 90                	xchg   %ax,%ax
  80111c:	66 90                	xchg   %ax,%ax
  80111e:	66 90                	xchg   %ax,%ax

00801120 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	05 00 00 00 30       	add    $0x30000000,%eax
  80112b:	c1 e8 0c             	shr    $0xc,%eax
}
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80113b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801140:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80114d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801152:	89 c2                	mov    %eax,%edx
  801154:	c1 ea 16             	shr    $0x16,%edx
  801157:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80115e:	f6 c2 01             	test   $0x1,%dl
  801161:	74 11                	je     801174 <fd_alloc+0x2d>
  801163:	89 c2                	mov    %eax,%edx
  801165:	c1 ea 0c             	shr    $0xc,%edx
  801168:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80116f:	f6 c2 01             	test   $0x1,%dl
  801172:	75 09                	jne    80117d <fd_alloc+0x36>
			*fd_store = fd;
  801174:	89 01                	mov    %eax,(%ecx)
			return 0;
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
  80117b:	eb 17                	jmp    801194 <fd_alloc+0x4d>
  80117d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801182:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801187:	75 c9                	jne    801152 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801189:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80118f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    

00801196 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80119c:	83 f8 1f             	cmp    $0x1f,%eax
  80119f:	77 36                	ja     8011d7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011a1:	c1 e0 0c             	shl    $0xc,%eax
  8011a4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011a9:	89 c2                	mov    %eax,%edx
  8011ab:	c1 ea 16             	shr    $0x16,%edx
  8011ae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011b5:	f6 c2 01             	test   $0x1,%dl
  8011b8:	74 24                	je     8011de <fd_lookup+0x48>
  8011ba:	89 c2                	mov    %eax,%edx
  8011bc:	c1 ea 0c             	shr    $0xc,%edx
  8011bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c6:	f6 c2 01             	test   $0x1,%dl
  8011c9:	74 1a                	je     8011e5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ce:	89 02                	mov    %eax,(%edx)
	return 0;
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d5:	eb 13                	jmp    8011ea <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011dc:	eb 0c                	jmp    8011ea <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e3:	eb 05                	jmp    8011ea <fd_lookup+0x54>
  8011e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011ea:	5d                   	pop    %ebp
  8011eb:	c3                   	ret    

008011ec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 18             	sub    $0x18,%esp
  8011f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fa:	eb 13                	jmp    80120f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8011fc:	39 08                	cmp    %ecx,(%eax)
  8011fe:	75 0c                	jne    80120c <dev_lookup+0x20>
			*dev = devtab[i];
  801200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801203:	89 01                	mov    %eax,(%ecx)
			return 0;
  801205:	b8 00 00 00 00       	mov    $0x0,%eax
  80120a:	eb 38                	jmp    801244 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80120c:	83 c2 01             	add    $0x1,%edx
  80120f:	8b 04 95 14 33 80 00 	mov    0x803314(,%edx,4),%eax
  801216:	85 c0                	test   %eax,%eax
  801218:	75 e2                	jne    8011fc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80121a:	a1 08 50 80 00       	mov    0x805008,%eax
  80121f:	8b 40 48             	mov    0x48(%eax),%eax
  801222:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801226:	89 44 24 04          	mov    %eax,0x4(%esp)
  80122a:	c7 04 24 98 32 80 00 	movl   $0x803298,(%esp)
  801231:	e8 80 f0 ff ff       	call   8002b6 <cprintf>
	*dev = 0;
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80123f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	56                   	push   %esi
  80124a:	53                   	push   %ebx
  80124b:	83 ec 20             	sub    $0x20,%esp
  80124e:	8b 75 08             	mov    0x8(%ebp),%esi
  801251:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801257:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80125b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801261:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801264:	89 04 24             	mov    %eax,(%esp)
  801267:	e8 2a ff ff ff       	call   801196 <fd_lookup>
  80126c:	85 c0                	test   %eax,%eax
  80126e:	78 05                	js     801275 <fd_close+0x2f>
	    || fd != fd2)
  801270:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801273:	74 0c                	je     801281 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801275:	84 db                	test   %bl,%bl
  801277:	ba 00 00 00 00       	mov    $0x0,%edx
  80127c:	0f 44 c2             	cmove  %edx,%eax
  80127f:	eb 3f                	jmp    8012c0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801281:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801284:	89 44 24 04          	mov    %eax,0x4(%esp)
  801288:	8b 06                	mov    (%esi),%eax
  80128a:	89 04 24             	mov    %eax,(%esp)
  80128d:	e8 5a ff ff ff       	call   8011ec <dev_lookup>
  801292:	89 c3                	mov    %eax,%ebx
  801294:	85 c0                	test   %eax,%eax
  801296:	78 16                	js     8012ae <fd_close+0x68>
		if (dev->dev_close)
  801298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80129e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	74 07                	je     8012ae <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8012a7:	89 34 24             	mov    %esi,(%esp)
  8012aa:	ff d0                	call   *%eax
  8012ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b9:	e8 dc fa ff ff       	call   800d9a <sys_page_unmap>
	return r;
  8012be:	89 d8                	mov    %ebx,%eax
}
  8012c0:	83 c4 20             	add    $0x20,%esp
  8012c3:	5b                   	pop    %ebx
  8012c4:	5e                   	pop    %esi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    

008012c7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	89 04 24             	mov    %eax,(%esp)
  8012da:	e8 b7 fe ff ff       	call   801196 <fd_lookup>
  8012df:	89 c2                	mov    %eax,%edx
  8012e1:	85 d2                	test   %edx,%edx
  8012e3:	78 13                	js     8012f8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012ec:	00 
  8012ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f0:	89 04 24             	mov    %eax,(%esp)
  8012f3:	e8 4e ff ff ff       	call   801246 <fd_close>
}
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <close_all>:

void
close_all(void)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	53                   	push   %ebx
  8012fe:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801301:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801306:	89 1c 24             	mov    %ebx,(%esp)
  801309:	e8 b9 ff ff ff       	call   8012c7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80130e:	83 c3 01             	add    $0x1,%ebx
  801311:	83 fb 20             	cmp    $0x20,%ebx
  801314:	75 f0                	jne    801306 <close_all+0xc>
		close(i);
}
  801316:	83 c4 14             	add    $0x14,%esp
  801319:	5b                   	pop    %ebx
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	57                   	push   %edi
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
  801322:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801325:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801328:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	89 04 24             	mov    %eax,(%esp)
  801332:	e8 5f fe ff ff       	call   801196 <fd_lookup>
  801337:	89 c2                	mov    %eax,%edx
  801339:	85 d2                	test   %edx,%edx
  80133b:	0f 88 e1 00 00 00    	js     801422 <dup+0x106>
		return r;
	close(newfdnum);
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	89 04 24             	mov    %eax,(%esp)
  801347:	e8 7b ff ff ff       	call   8012c7 <close>

	newfd = INDEX2FD(newfdnum);
  80134c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80134f:	c1 e3 0c             	shl    $0xc,%ebx
  801352:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80135b:	89 04 24             	mov    %eax,(%esp)
  80135e:	e8 cd fd ff ff       	call   801130 <fd2data>
  801363:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801365:	89 1c 24             	mov    %ebx,(%esp)
  801368:	e8 c3 fd ff ff       	call   801130 <fd2data>
  80136d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80136f:	89 f0                	mov    %esi,%eax
  801371:	c1 e8 16             	shr    $0x16,%eax
  801374:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80137b:	a8 01                	test   $0x1,%al
  80137d:	74 43                	je     8013c2 <dup+0xa6>
  80137f:	89 f0                	mov    %esi,%eax
  801381:	c1 e8 0c             	shr    $0xc,%eax
  801384:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80138b:	f6 c2 01             	test   $0x1,%dl
  80138e:	74 32                	je     8013c2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801390:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801397:	25 07 0e 00 00       	and    $0xe07,%eax
  80139c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013a0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013ab:	00 
  8013ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b7:	e8 8b f9 ff ff       	call   800d47 <sys_page_map>
  8013bc:	89 c6                	mov    %eax,%esi
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 3e                	js     801400 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c5:	89 c2                	mov    %eax,%edx
  8013c7:	c1 ea 0c             	shr    $0xc,%edx
  8013ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013d7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013e6:	00 
  8013e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f2:	e8 50 f9 ff ff       	call   800d47 <sys_page_map>
  8013f7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013fc:	85 f6                	test   %esi,%esi
  8013fe:	79 22                	jns    801422 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801400:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801404:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80140b:	e8 8a f9 ff ff       	call   800d9a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801410:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801414:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80141b:	e8 7a f9 ff ff       	call   800d9a <sys_page_unmap>
	return r;
  801420:	89 f0                	mov    %esi,%eax
}
  801422:	83 c4 3c             	add    $0x3c,%esp
  801425:	5b                   	pop    %ebx
  801426:	5e                   	pop    %esi
  801427:	5f                   	pop    %edi
  801428:	5d                   	pop    %ebp
  801429:	c3                   	ret    

0080142a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	53                   	push   %ebx
  80142e:	83 ec 24             	sub    $0x24,%esp
  801431:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801434:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801437:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143b:	89 1c 24             	mov    %ebx,(%esp)
  80143e:	e8 53 fd ff ff       	call   801196 <fd_lookup>
  801443:	89 c2                	mov    %eax,%edx
  801445:	85 d2                	test   %edx,%edx
  801447:	78 6d                	js     8014b6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801449:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801453:	8b 00                	mov    (%eax),%eax
  801455:	89 04 24             	mov    %eax,(%esp)
  801458:	e8 8f fd ff ff       	call   8011ec <dev_lookup>
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 55                	js     8014b6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801464:	8b 50 08             	mov    0x8(%eax),%edx
  801467:	83 e2 03             	and    $0x3,%edx
  80146a:	83 fa 01             	cmp    $0x1,%edx
  80146d:	75 23                	jne    801492 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80146f:	a1 08 50 80 00       	mov    0x805008,%eax
  801474:	8b 40 48             	mov    0x48(%eax),%eax
  801477:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80147b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147f:	c7 04 24 d9 32 80 00 	movl   $0x8032d9,(%esp)
  801486:	e8 2b ee ff ff       	call   8002b6 <cprintf>
		return -E_INVAL;
  80148b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801490:	eb 24                	jmp    8014b6 <read+0x8c>
	}
	if (!dev->dev_read)
  801492:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801495:	8b 52 08             	mov    0x8(%edx),%edx
  801498:	85 d2                	test   %edx,%edx
  80149a:	74 15                	je     8014b1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80149c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014aa:	89 04 24             	mov    %eax,(%esp)
  8014ad:	ff d2                	call   *%edx
  8014af:	eb 05                	jmp    8014b6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014b6:	83 c4 24             	add    $0x24,%esp
  8014b9:	5b                   	pop    %ebx
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    

008014bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	57                   	push   %edi
  8014c0:	56                   	push   %esi
  8014c1:	53                   	push   %ebx
  8014c2:	83 ec 1c             	sub    $0x1c,%esp
  8014c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d0:	eb 23                	jmp    8014f5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014d2:	89 f0                	mov    %esi,%eax
  8014d4:	29 d8                	sub    %ebx,%eax
  8014d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014da:	89 d8                	mov    %ebx,%eax
  8014dc:	03 45 0c             	add    0xc(%ebp),%eax
  8014df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e3:	89 3c 24             	mov    %edi,(%esp)
  8014e6:	e8 3f ff ff ff       	call   80142a <read>
		if (m < 0)
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 10                	js     8014ff <readn+0x43>
			return m;
		if (m == 0)
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	74 0a                	je     8014fd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014f3:	01 c3                	add    %eax,%ebx
  8014f5:	39 f3                	cmp    %esi,%ebx
  8014f7:	72 d9                	jb     8014d2 <readn+0x16>
  8014f9:	89 d8                	mov    %ebx,%eax
  8014fb:	eb 02                	jmp    8014ff <readn+0x43>
  8014fd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014ff:	83 c4 1c             	add    $0x1c,%esp
  801502:	5b                   	pop    %ebx
  801503:	5e                   	pop    %esi
  801504:	5f                   	pop    %edi
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	53                   	push   %ebx
  80150b:	83 ec 24             	sub    $0x24,%esp
  80150e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801511:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801514:	89 44 24 04          	mov    %eax,0x4(%esp)
  801518:	89 1c 24             	mov    %ebx,(%esp)
  80151b:	e8 76 fc ff ff       	call   801196 <fd_lookup>
  801520:	89 c2                	mov    %eax,%edx
  801522:	85 d2                	test   %edx,%edx
  801524:	78 68                	js     80158e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801526:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801529:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801530:	8b 00                	mov    (%eax),%eax
  801532:	89 04 24             	mov    %eax,(%esp)
  801535:	e8 b2 fc ff ff       	call   8011ec <dev_lookup>
  80153a:	85 c0                	test   %eax,%eax
  80153c:	78 50                	js     80158e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80153e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801541:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801545:	75 23                	jne    80156a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801547:	a1 08 50 80 00       	mov    0x805008,%eax
  80154c:	8b 40 48             	mov    0x48(%eax),%eax
  80154f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801553:	89 44 24 04          	mov    %eax,0x4(%esp)
  801557:	c7 04 24 f5 32 80 00 	movl   $0x8032f5,(%esp)
  80155e:	e8 53 ed ff ff       	call   8002b6 <cprintf>
		return -E_INVAL;
  801563:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801568:	eb 24                	jmp    80158e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156d:	8b 52 0c             	mov    0xc(%edx),%edx
  801570:	85 d2                	test   %edx,%edx
  801572:	74 15                	je     801589 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801574:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801577:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80157b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801582:	89 04 24             	mov    %eax,(%esp)
  801585:	ff d2                	call   *%edx
  801587:	eb 05                	jmp    80158e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801589:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80158e:	83 c4 24             	add    $0x24,%esp
  801591:	5b                   	pop    %ebx
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    

00801594 <seek>:

int
seek(int fdnum, off_t offset)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80159a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80159d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	89 04 24             	mov    %eax,(%esp)
  8015a7:	e8 ea fb ff ff       	call   801196 <fd_lookup>
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 0e                	js     8015be <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	53                   	push   %ebx
  8015c4:	83 ec 24             	sub    $0x24,%esp
  8015c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d1:	89 1c 24             	mov    %ebx,(%esp)
  8015d4:	e8 bd fb ff ff       	call   801196 <fd_lookup>
  8015d9:	89 c2                	mov    %eax,%edx
  8015db:	85 d2                	test   %edx,%edx
  8015dd:	78 61                	js     801640 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e9:	8b 00                	mov    (%eax),%eax
  8015eb:	89 04 24             	mov    %eax,(%esp)
  8015ee:	e8 f9 fb ff ff       	call   8011ec <dev_lookup>
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	78 49                	js     801640 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015fe:	75 23                	jne    801623 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801600:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801605:	8b 40 48             	mov    0x48(%eax),%eax
  801608:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80160c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801610:	c7 04 24 b8 32 80 00 	movl   $0x8032b8,(%esp)
  801617:	e8 9a ec ff ff       	call   8002b6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80161c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801621:	eb 1d                	jmp    801640 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801626:	8b 52 18             	mov    0x18(%edx),%edx
  801629:	85 d2                	test   %edx,%edx
  80162b:	74 0e                	je     80163b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80162d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801630:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801634:	89 04 24             	mov    %eax,(%esp)
  801637:	ff d2                	call   *%edx
  801639:	eb 05                	jmp    801640 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80163b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801640:	83 c4 24             	add    $0x24,%esp
  801643:	5b                   	pop    %ebx
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    

00801646 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	53                   	push   %ebx
  80164a:	83 ec 24             	sub    $0x24,%esp
  80164d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801650:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801653:	89 44 24 04          	mov    %eax,0x4(%esp)
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	89 04 24             	mov    %eax,(%esp)
  80165d:	e8 34 fb ff ff       	call   801196 <fd_lookup>
  801662:	89 c2                	mov    %eax,%edx
  801664:	85 d2                	test   %edx,%edx
  801666:	78 52                	js     8016ba <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801668:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801672:	8b 00                	mov    (%eax),%eax
  801674:	89 04 24             	mov    %eax,(%esp)
  801677:	e8 70 fb ff ff       	call   8011ec <dev_lookup>
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 3a                	js     8016ba <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801683:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801687:	74 2c                	je     8016b5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801689:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80168c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801693:	00 00 00 
	stat->st_isdir = 0;
  801696:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80169d:	00 00 00 
	stat->st_dev = dev;
  8016a0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ad:	89 14 24             	mov    %edx,(%esp)
  8016b0:	ff 50 14             	call   *0x14(%eax)
  8016b3:	eb 05                	jmp    8016ba <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016ba:	83 c4 24             	add    $0x24,%esp
  8016bd:	5b                   	pop    %ebx
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    

008016c0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	56                   	push   %esi
  8016c4:	53                   	push   %ebx
  8016c5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016cf:	00 
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 04 24             	mov    %eax,(%esp)
  8016d6:	e8 1b 02 00 00       	call   8018f6 <open>
  8016db:	89 c3                	mov    %eax,%ebx
  8016dd:	85 db                	test   %ebx,%ebx
  8016df:	78 1b                	js     8016fc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e8:	89 1c 24             	mov    %ebx,(%esp)
  8016eb:	e8 56 ff ff ff       	call   801646 <fstat>
  8016f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f2:	89 1c 24             	mov    %ebx,(%esp)
  8016f5:	e8 cd fb ff ff       	call   8012c7 <close>
	return r;
  8016fa:	89 f0                	mov    %esi,%eax
}
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	5b                   	pop    %ebx
  801700:	5e                   	pop    %esi
  801701:	5d                   	pop    %ebp
  801702:	c3                   	ret    

00801703 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	83 ec 10             	sub    $0x10,%esp
  80170b:	89 c6                	mov    %eax,%esi
  80170d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80170f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801716:	75 11                	jne    801729 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801718:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80171f:	e8 db 13 00 00       	call   802aff <ipc_find_env>
  801724:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801729:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801730:	00 
  801731:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801738:	00 
  801739:	89 74 24 04          	mov    %esi,0x4(%esp)
  80173d:	a1 00 50 80 00       	mov    0x805000,%eax
  801742:	89 04 24             	mov    %eax,(%esp)
  801745:	e8 4a 13 00 00       	call   802a94 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80174a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801751:	00 
  801752:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801756:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80175d:	e8 de 12 00 00       	call   802a40 <ipc_recv>
}
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5d                   	pop    %ebp
  801768:	c3                   	ret    

00801769 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8b 40 0c             	mov    0xc(%eax),%eax
  801775:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80177a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801782:	ba 00 00 00 00       	mov    $0x0,%edx
  801787:	b8 02 00 00 00       	mov    $0x2,%eax
  80178c:	e8 72 ff ff ff       	call   801703 <fsipc>
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8b 40 0c             	mov    0xc(%eax),%eax
  80179f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ae:	e8 50 ff ff ff       	call   801703 <fsipc>
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 14             	sub    $0x14,%esp
  8017bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8017d4:	e8 2a ff ff ff       	call   801703 <fsipc>
  8017d9:	89 c2                	mov    %eax,%edx
  8017db:	85 d2                	test   %edx,%edx
  8017dd:	78 2b                	js     80180a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017df:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8017e6:	00 
  8017e7:	89 1c 24             	mov    %ebx,(%esp)
  8017ea:	e8 e8 f0 ff ff       	call   8008d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017ef:	a1 80 60 80 00       	mov    0x806080,%eax
  8017f4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017fa:	a1 84 60 80 00       	mov    0x806084,%eax
  8017ff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180a:	83 c4 14             	add    $0x14,%esp
  80180d:	5b                   	pop    %ebx
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    

00801810 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 18             	sub    $0x18,%esp
  801816:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801819:	8b 55 08             	mov    0x8(%ebp),%edx
  80181c:	8b 52 0c             	mov    0xc(%edx),%edx
  80181f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801825:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80182a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80182e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801831:	89 44 24 04          	mov    %eax,0x4(%esp)
  801835:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80183c:	e8 9b f2 ff ff       	call   800adc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801841:	ba 00 00 00 00       	mov    $0x0,%edx
  801846:	b8 04 00 00 00       	mov    $0x4,%eax
  80184b:	e8 b3 fe ff ff       	call   801703 <fsipc>
		return r;
	}

	return r;
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	56                   	push   %esi
  801856:	53                   	push   %ebx
  801857:	83 ec 10             	sub    $0x10,%esp
  80185a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	8b 40 0c             	mov    0xc(%eax),%eax
  801863:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801868:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	b8 03 00 00 00       	mov    $0x3,%eax
  801878:	e8 86 fe ff ff       	call   801703 <fsipc>
  80187d:	89 c3                	mov    %eax,%ebx
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 6a                	js     8018ed <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801883:	39 c6                	cmp    %eax,%esi
  801885:	73 24                	jae    8018ab <devfile_read+0x59>
  801887:	c7 44 24 0c 28 33 80 	movl   $0x803328,0xc(%esp)
  80188e:	00 
  80188f:	c7 44 24 08 2f 33 80 	movl   $0x80332f,0x8(%esp)
  801896:	00 
  801897:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80189e:	00 
  80189f:	c7 04 24 44 33 80 00 	movl   $0x803344,(%esp)
  8018a6:	e8 12 e9 ff ff       	call   8001bd <_panic>
	assert(r <= PGSIZE);
  8018ab:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018b0:	7e 24                	jle    8018d6 <devfile_read+0x84>
  8018b2:	c7 44 24 0c 4f 33 80 	movl   $0x80334f,0xc(%esp)
  8018b9:	00 
  8018ba:	c7 44 24 08 2f 33 80 	movl   $0x80332f,0x8(%esp)
  8018c1:	00 
  8018c2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018c9:	00 
  8018ca:	c7 04 24 44 33 80 00 	movl   $0x803344,(%esp)
  8018d1:	e8 e7 e8 ff ff       	call   8001bd <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018da:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8018e1:	00 
  8018e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e5:	89 04 24             	mov    %eax,(%esp)
  8018e8:	e8 87 f1 ff ff       	call   800a74 <memmove>
	return r;
}
  8018ed:	89 d8                	mov    %ebx,%eax
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	5b                   	pop    %ebx
  8018f3:	5e                   	pop    %esi
  8018f4:	5d                   	pop    %ebp
  8018f5:	c3                   	ret    

008018f6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	53                   	push   %ebx
  8018fa:	83 ec 24             	sub    $0x24,%esp
  8018fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801900:	89 1c 24             	mov    %ebx,(%esp)
  801903:	e8 98 ef ff ff       	call   8008a0 <strlen>
  801908:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80190d:	7f 60                	jg     80196f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80190f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801912:	89 04 24             	mov    %eax,(%esp)
  801915:	e8 2d f8 ff ff       	call   801147 <fd_alloc>
  80191a:	89 c2                	mov    %eax,%edx
  80191c:	85 d2                	test   %edx,%edx
  80191e:	78 54                	js     801974 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801920:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801924:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80192b:	e8 a7 ef ff ff       	call   8008d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801938:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193b:	b8 01 00 00 00       	mov    $0x1,%eax
  801940:	e8 be fd ff ff       	call   801703 <fsipc>
  801945:	89 c3                	mov    %eax,%ebx
  801947:	85 c0                	test   %eax,%eax
  801949:	79 17                	jns    801962 <open+0x6c>
		fd_close(fd, 0);
  80194b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801952:	00 
  801953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801956:	89 04 24             	mov    %eax,(%esp)
  801959:	e8 e8 f8 ff ff       	call   801246 <fd_close>
		return r;
  80195e:	89 d8                	mov    %ebx,%eax
  801960:	eb 12                	jmp    801974 <open+0x7e>
	}

	return fd2num(fd);
  801962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801965:	89 04 24             	mov    %eax,(%esp)
  801968:	e8 b3 f7 ff ff       	call   801120 <fd2num>
  80196d:	eb 05                	jmp    801974 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80196f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801974:	83 c4 24             	add    $0x24,%esp
  801977:	5b                   	pop    %ebx
  801978:	5d                   	pop    %ebp
  801979:	c3                   	ret    

0080197a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801980:	ba 00 00 00 00       	mov    $0x0,%edx
  801985:	b8 08 00 00 00       	mov    $0x8,%eax
  80198a:	e8 74 fd ff ff       	call   801703 <fsipc>
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    
  801991:	66 90                	xchg   %ax,%ax
  801993:	66 90                	xchg   %ax,%ax
  801995:	66 90                	xchg   %ax,%ax
  801997:	66 90                	xchg   %ax,%ax
  801999:	66 90                	xchg   %ax,%ax
  80199b:	66 90                	xchg   %ax,%ax
  80199d:	66 90                	xchg   %ax,%ax
  80199f:	90                   	nop

008019a0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	57                   	push   %edi
  8019a4:	56                   	push   %esi
  8019a5:	53                   	push   %ebx
  8019a6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019b3:	00 
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	89 04 24             	mov    %eax,(%esp)
  8019ba:	e8 37 ff ff ff       	call   8018f6 <open>
  8019bf:	89 c1                	mov    %eax,%ecx
  8019c1:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	0f 88 fd 04 00 00    	js     801ecc <spawn+0x52c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019cf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8019d6:	00 
  8019d7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e1:	89 0c 24             	mov    %ecx,(%esp)
  8019e4:	e8 d3 fa ff ff       	call   8014bc <readn>
  8019e9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8019ee:	75 0c                	jne    8019fc <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  8019f0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8019f7:	45 4c 46 
  8019fa:	74 36                	je     801a32 <spawn+0x92>
		close(fd);
  8019fc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801a02:	89 04 24             	mov    %eax,(%esp)
  801a05:	e8 bd f8 ff ff       	call   8012c7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a0a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801a11:	46 
  801a12:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1c:	c7 04 24 5b 33 80 00 	movl   $0x80335b,(%esp)
  801a23:	e8 8e e8 ff ff       	call   8002b6 <cprintf>
		return -E_NOT_EXEC;
  801a28:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801a2d:	e9 4a 05 00 00       	jmp    801f7c <spawn+0x5dc>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801a32:	b8 07 00 00 00       	mov    $0x7,%eax
  801a37:	cd 30                	int    $0x30
  801a39:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a3f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a45:	85 c0                	test   %eax,%eax
  801a47:	0f 88 8a 04 00 00    	js     801ed7 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a4d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a52:	89 c2                	mov    %eax,%edx
  801a54:	c1 e2 07             	shl    $0x7,%edx
  801a57:	8d b4 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%esi
  801a5e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a64:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a6b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a71:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a77:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801a7c:	be 00 00 00 00       	mov    $0x0,%esi
  801a81:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a84:	eb 0f                	jmp    801a95 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801a86:	89 04 24             	mov    %eax,(%esp)
  801a89:	e8 12 ee ff ff       	call   8008a0 <strlen>
  801a8e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a92:	83 c3 01             	add    $0x1,%ebx
  801a95:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a9c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	75 e3                	jne    801a86 <spawn+0xe6>
  801aa3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801aa9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801aaf:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ab4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ab6:	89 fa                	mov    %edi,%edx
  801ab8:	83 e2 fc             	and    $0xfffffffc,%edx
  801abb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ac2:	29 c2                	sub    %eax,%edx
  801ac4:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801aca:	8d 42 f8             	lea    -0x8(%edx),%eax
  801acd:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ad2:	0f 86 15 04 00 00    	jbe    801eed <spawn+0x54d>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ad8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801adf:	00 
  801ae0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ae7:	00 
  801ae8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aef:	e8 ff f1 ff ff       	call   800cf3 <sys_page_alloc>
  801af4:	85 c0                	test   %eax,%eax
  801af6:	0f 88 80 04 00 00    	js     801f7c <spawn+0x5dc>
  801afc:	be 00 00 00 00       	mov    $0x0,%esi
  801b01:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801b07:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b0a:	eb 30                	jmp    801b3c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801b0c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b12:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b18:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b1b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b22:	89 3c 24             	mov    %edi,(%esp)
  801b25:	e8 ad ed ff ff       	call   8008d7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b2a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801b2d:	89 04 24             	mov    %eax,(%esp)
  801b30:	e8 6b ed ff ff       	call   8008a0 <strlen>
  801b35:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b39:	83 c6 01             	add    $0x1,%esi
  801b3c:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801b42:	7f c8                	jg     801b0c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801b44:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b4a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b50:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b57:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b5d:	74 24                	je     801b83 <spawn+0x1e3>
  801b5f:	c7 44 24 0c e8 33 80 	movl   $0x8033e8,0xc(%esp)
  801b66:	00 
  801b67:	c7 44 24 08 2f 33 80 	movl   $0x80332f,0x8(%esp)
  801b6e:	00 
  801b6f:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801b76:	00 
  801b77:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801b7e:	e8 3a e6 ff ff       	call   8001bd <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b83:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b89:	89 c8                	mov    %ecx,%eax
  801b8b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801b90:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801b93:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801b99:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b9c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801ba2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ba8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801baf:	00 
  801bb0:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801bb7:	ee 
  801bb8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801bbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bc9:	00 
  801bca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bd1:	e8 71 f1 ff ff       	call   800d47 <sys_page_map>
  801bd6:	89 c3                	mov    %eax,%ebx
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	0f 88 86 03 00 00    	js     801f66 <spawn+0x5c6>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801be0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801be7:	00 
  801be8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bef:	e8 a6 f1 ff ff       	call   800d9a <sys_page_unmap>
  801bf4:	89 c3                	mov    %eax,%ebx
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	0f 88 68 03 00 00    	js     801f66 <spawn+0x5c6>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bfe:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c04:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801c0b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c11:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801c18:	00 00 00 
  801c1b:	e9 b6 01 00 00       	jmp    801dd6 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801c20:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801c26:	83 38 01             	cmpl   $0x1,(%eax)
  801c29:	0f 85 99 01 00 00    	jne    801dc8 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801c2f:	89 c1                	mov    %eax,%ecx
  801c31:	8b 40 18             	mov    0x18(%eax),%eax
  801c34:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801c37:	83 f8 01             	cmp    $0x1,%eax
  801c3a:	19 c0                	sbb    %eax,%eax
  801c3c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801c42:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801c49:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801c50:	89 c8                	mov    %ecx,%eax
  801c52:	8b 49 04             	mov    0x4(%ecx),%ecx
  801c55:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801c5b:	8b 48 10             	mov    0x10(%eax),%ecx
  801c5e:	89 8d 94 fd ff ff    	mov    %ecx,-0x26c(%ebp)
  801c64:	8b 50 14             	mov    0x14(%eax),%edx
  801c67:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  801c6d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801c70:	89 f0                	mov    %esi,%eax
  801c72:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c77:	74 14                	je     801c8d <spawn+0x2ed>
		va -= i;
  801c79:	29 c6                	sub    %eax,%esi
		memsz += i;
  801c7b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801c81:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801c87:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801c8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c92:	e9 23 01 00 00       	jmp    801dba <spawn+0x41a>
		if (i >= filesz) {
  801c97:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801c9d:	77 2b                	ja     801cca <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c9f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cad:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801cb3:	89 04 24             	mov    %eax,(%esp)
  801cb6:	e8 38 f0 ff ff       	call   800cf3 <sys_page_alloc>
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	0f 89 eb 00 00 00    	jns    801dae <spawn+0x40e>
  801cc3:	89 c3                	mov    %eax,%ebx
  801cc5:	e9 37 02 00 00       	jmp    801f01 <spawn+0x561>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801cca:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801cd1:	00 
  801cd2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cd9:	00 
  801cda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce1:	e8 0d f0 ff ff       	call   800cf3 <sys_page_alloc>
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	0f 88 09 02 00 00    	js     801ef7 <spawn+0x557>
  801cee:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801cf4:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfa:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d00:	89 04 24             	mov    %eax,(%esp)
  801d03:	e8 8c f8 ff ff       	call   801594 <seek>
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	0f 88 eb 01 00 00    	js     801efb <spawn+0x55b>
  801d10:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801d16:	29 f9                	sub    %edi,%ecx
  801d18:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d1a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801d20:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d25:	0f 47 c2             	cmova  %edx,%eax
  801d28:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d2c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d33:	00 
  801d34:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d3a:	89 04 24             	mov    %eax,(%esp)
  801d3d:	e8 7a f7 ff ff       	call   8014bc <readn>
  801d42:	85 c0                	test   %eax,%eax
  801d44:	0f 88 b5 01 00 00    	js     801eff <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d4a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d50:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d54:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d58:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d62:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d69:	00 
  801d6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d71:	e8 d1 ef ff ff       	call   800d47 <sys_page_map>
  801d76:	85 c0                	test   %eax,%eax
  801d78:	79 20                	jns    801d9a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  801d7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7e:	c7 44 24 08 81 33 80 	movl   $0x803381,0x8(%esp)
  801d85:	00 
  801d86:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  801d8d:	00 
  801d8e:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801d95:	e8 23 e4 ff ff       	call   8001bd <_panic>
			sys_page_unmap(0, UTEMP);
  801d9a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801da1:	00 
  801da2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da9:	e8 ec ef ff ff       	call   800d9a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801dae:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801db4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801dba:	89 df                	mov    %ebx,%edi
  801dbc:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801dc2:	0f 87 cf fe ff ff    	ja     801c97 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801dc8:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801dcf:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801dd6:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801ddd:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801de3:	0f 8c 37 fe ff ff    	jl     801c20 <spawn+0x280>
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	
	close(fd);
  801de9:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801def:	89 04 24             	mov    %eax,(%esp)
  801df2:	e8 d0 f4 ff ff       	call   8012c7 <close>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801df7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dfc:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
		if(((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_SHARE))
  801e02:	89 d8                	mov    %ebx,%eax
  801e04:	c1 e8 16             	shr    $0x16,%eax
  801e07:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e0e:	a8 01                	test   $0x1,%al
  801e10:	74 4d                	je     801e5f <spawn+0x4bf>
  801e12:	89 d8                	mov    %ebx,%eax
  801e14:	c1 e8 0c             	shr    $0xc,%eax
  801e17:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e1e:	f6 c2 01             	test   $0x1,%dl
  801e21:	74 3c                	je     801e5f <spawn+0x4bf>
  801e23:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e2a:	f6 c6 04             	test   $0x4,%dh
  801e2d:	74 30                	je     801e5f <spawn+0x4bf>
		&& ((r = sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)]&PTE_SYSCALL)) < 0)){
  801e2f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e36:	25 07 0e 00 00       	and    $0xe07,%eax
  801e3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e3f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e43:	89 74 24 08          	mov    %esi,0x8(%esp)
  801e47:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e52:	e8 f0 ee ff ff       	call   800d47 <sys_page_map>
  801e57:	85 c0                	test   %eax,%eax
  801e59:	0f 88 e7 00 00 00    	js     801f46 <spawn+0x5a6>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801e5f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e65:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e6b:	75 95                	jne    801e02 <spawn+0x462>
  801e6d:	e9 af 00 00 00       	jmp    801f21 <spawn+0x581>
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  801e72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e76:	c7 44 24 08 9e 33 80 	movl   $0x80339e,0x8(%esp)
  801e7d:	00 
  801e7e:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  801e85:	00 
  801e86:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801e8d:	e8 2b e3 ff ff       	call   8001bd <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e92:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801e99:	00 
  801e9a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ea0:	89 04 24             	mov    %eax,(%esp)
  801ea3:	e8 45 ef ff ff       	call   800ded <sys_env_set_status>
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	79 36                	jns    801ee2 <spawn+0x542>
		panic("sys_env_set_status: %e", r);
  801eac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eb0:	c7 44 24 08 b8 33 80 	movl   $0x8033b8,0x8(%esp)
  801eb7:	00 
  801eb8:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  801ebf:	00 
  801ec0:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801ec7:	e8 f1 e2 ff ff       	call   8001bd <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801ecc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ed2:	e9 a5 00 00 00       	jmp    801f7c <spawn+0x5dc>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801ed7:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801edd:	e9 9a 00 00 00       	jmp    801f7c <spawn+0x5dc>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801ee2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ee8:	e9 8f 00 00 00       	jmp    801f7c <spawn+0x5dc>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801eed:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801ef2:	e9 85 00 00 00       	jmp    801f7c <spawn+0x5dc>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ef7:	89 c3                	mov    %eax,%ebx
  801ef9:	eb 06                	jmp    801f01 <spawn+0x561>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	eb 02                	jmp    801f01 <spawn+0x561>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801eff:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  801f01:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f07:	89 04 24             	mov    %eax,(%esp)
  801f0a:	e8 54 ed ff ff       	call   800c63 <sys_env_destroy>
	close(fd);
  801f0f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801f15:	89 04 24             	mov    %eax,(%esp)
  801f18:	e8 aa f3 ff ff       	call   8012c7 <close>
	return r;
  801f1d:	89 d8                	mov    %ebx,%eax
  801f1f:	eb 5b                	jmp    801f7c <spawn+0x5dc>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801f21:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801f27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f31:	89 04 24             	mov    %eax,(%esp)
  801f34:	e8 07 ef ff ff       	call   800e40 <sys_env_set_trapframe>
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	0f 89 51 ff ff ff    	jns    801e92 <spawn+0x4f2>
  801f41:	e9 2c ff ff ff       	jmp    801e72 <spawn+0x4d2>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  801f46:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f4a:	c7 44 24 08 cf 33 80 	movl   $0x8033cf,0x8(%esp)
  801f51:	00 
  801f52:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  801f59:	00 
  801f5a:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801f61:	e8 57 e2 ff ff       	call   8001bd <_panic>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801f66:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f6d:	00 
  801f6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f75:	e8 20 ee ff ff       	call   800d9a <sys_page_unmap>
  801f7a:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801f7c:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801f82:	5b                   	pop    %ebx
  801f83:	5e                   	pop    %esi
  801f84:	5f                   	pop    %edi
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    

00801f87 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	56                   	push   %esi
  801f8b:	53                   	push   %ebx
  801f8c:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801f8f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801f92:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801f97:	eb 03                	jmp    801f9c <spawnl+0x15>
		argc++;
  801f99:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801f9c:	83 c0 04             	add    $0x4,%eax
  801f9f:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801fa3:	75 f4                	jne    801f99 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801fa5:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  801fac:	83 e0 f0             	and    $0xfffffff0,%eax
  801faf:	29 c4                	sub    %eax,%esp
  801fb1:	8d 44 24 0b          	lea    0xb(%esp),%eax
  801fb5:	c1 e8 02             	shr    $0x2,%eax
  801fb8:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  801fbf:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801fc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fc4:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  801fcb:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  801fd2:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	eb 0a                	jmp    801fe4 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  801fda:	83 c0 01             	add    $0x1,%eax
  801fdd:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801fe1:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801fe4:	39 d0                	cmp    %edx,%eax
  801fe6:	75 f2                	jne    801fda <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801fe8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	89 04 24             	mov    %eax,(%esp)
  801ff2:	e8 a9 f9 ff ff       	call   8019a0 <spawn>
}
  801ff7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ffa:	5b                   	pop    %ebx
  801ffb:	5e                   	pop    %esi
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    
  801ffe:	66 90                	xchg   %ax,%ax

00802000 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802006:	c7 44 24 04 0e 34 80 	movl   $0x80340e,0x4(%esp)
  80200d:	00 
  80200e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802011:	89 04 24             	mov    %eax,(%esp)
  802014:	e8 be e8 ff ff       	call   8008d7 <strcpy>
	return 0;
}
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	53                   	push   %ebx
  802024:	83 ec 14             	sub    $0x14,%esp
  802027:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80202a:	89 1c 24             	mov    %ebx,(%esp)
  80202d:	e8 0c 0b 00 00       	call   802b3e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802032:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802037:	83 f8 01             	cmp    $0x1,%eax
  80203a:	75 0d                	jne    802049 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80203c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80203f:	89 04 24             	mov    %eax,(%esp)
  802042:	e8 29 03 00 00       	call   802370 <nsipc_close>
  802047:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802049:	89 d0                	mov    %edx,%eax
  80204b:	83 c4 14             	add    $0x14,%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802057:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80205e:	00 
  80205f:	8b 45 10             	mov    0x10(%ebp),%eax
  802062:	89 44 24 08          	mov    %eax,0x8(%esp)
  802066:	8b 45 0c             	mov    0xc(%ebp),%eax
  802069:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 40 0c             	mov    0xc(%eax),%eax
  802073:	89 04 24             	mov    %eax,(%esp)
  802076:	e8 f0 03 00 00       	call   80246b <nsipc_send>
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802083:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80208a:	00 
  80208b:	8b 45 10             	mov    0x10(%ebp),%eax
  80208e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802092:	8b 45 0c             	mov    0xc(%ebp),%eax
  802095:	89 44 24 04          	mov    %eax,0x4(%esp)
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	8b 40 0c             	mov    0xc(%eax),%eax
  80209f:	89 04 24             	mov    %eax,(%esp)
  8020a2:	e8 44 03 00 00       	call   8023eb <nsipc_recv>
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020af:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020b6:	89 04 24             	mov    %eax,(%esp)
  8020b9:	e8 d8 f0 ff ff       	call   801196 <fd_lookup>
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	78 17                	js     8020d9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020cb:	39 08                	cmp    %ecx,(%eax)
  8020cd:	75 05                	jne    8020d4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8020cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d2:	eb 05                	jmp    8020d9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8020d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	56                   	push   %esi
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 20             	sub    $0x20,%esp
  8020e3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e8:	89 04 24             	mov    %eax,(%esp)
  8020eb:	e8 57 f0 ff ff       	call   801147 <fd_alloc>
  8020f0:	89 c3                	mov    %eax,%ebx
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 21                	js     802117 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020fd:	00 
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	89 44 24 04          	mov    %eax,0x4(%esp)
  802105:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80210c:	e8 e2 eb ff ff       	call   800cf3 <sys_page_alloc>
  802111:	89 c3                	mov    %eax,%ebx
  802113:	85 c0                	test   %eax,%eax
  802115:	79 0c                	jns    802123 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802117:	89 34 24             	mov    %esi,(%esp)
  80211a:	e8 51 02 00 00       	call   802370 <nsipc_close>
		return r;
  80211f:	89 d8                	mov    %ebx,%eax
  802121:	eb 20                	jmp    802143 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802123:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80212e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802131:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802138:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80213b:	89 14 24             	mov    %edx,(%esp)
  80213e:	e8 dd ef ff ff       	call   801120 <fd2num>
}
  802143:	83 c4 20             	add    $0x20,%esp
  802146:	5b                   	pop    %ebx
  802147:	5e                   	pop    %esi
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    

0080214a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	e8 51 ff ff ff       	call   8020a9 <fd2sockid>
		return r;
  802158:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80215a:	85 c0                	test   %eax,%eax
  80215c:	78 23                	js     802181 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80215e:	8b 55 10             	mov    0x10(%ebp),%edx
  802161:	89 54 24 08          	mov    %edx,0x8(%esp)
  802165:	8b 55 0c             	mov    0xc(%ebp),%edx
  802168:	89 54 24 04          	mov    %edx,0x4(%esp)
  80216c:	89 04 24             	mov    %eax,(%esp)
  80216f:	e8 45 01 00 00       	call   8022b9 <nsipc_accept>
		return r;
  802174:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802176:	85 c0                	test   %eax,%eax
  802178:	78 07                	js     802181 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80217a:	e8 5c ff ff ff       	call   8020db <alloc_sockfd>
  80217f:	89 c1                	mov    %eax,%ecx
}
  802181:	89 c8                	mov    %ecx,%eax
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	e8 16 ff ff ff       	call   8020a9 <fd2sockid>
  802193:	89 c2                	mov    %eax,%edx
  802195:	85 d2                	test   %edx,%edx
  802197:	78 16                	js     8021af <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802199:	8b 45 10             	mov    0x10(%ebp),%eax
  80219c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a7:	89 14 24             	mov    %edx,(%esp)
  8021aa:	e8 60 01 00 00       	call   80230f <nsipc_bind>
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <shutdown>:

int
shutdown(int s, int how)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	e8 ea fe ff ff       	call   8020a9 <fd2sockid>
  8021bf:	89 c2                	mov    %eax,%edx
  8021c1:	85 d2                	test   %edx,%edx
  8021c3:	78 0f                	js     8021d4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8021c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cc:	89 14 24             	mov    %edx,(%esp)
  8021cf:	e8 7a 01 00 00       	call   80234e <nsipc_shutdown>
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	e8 c5 fe ff ff       	call   8020a9 <fd2sockid>
  8021e4:	89 c2                	mov    %eax,%edx
  8021e6:	85 d2                	test   %edx,%edx
  8021e8:	78 16                	js     802200 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f8:	89 14 24             	mov    %edx,(%esp)
  8021fb:	e8 8a 01 00 00       	call   80238a <nsipc_connect>
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <listen>:

int
listen(int s, int backlog)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	e8 99 fe ff ff       	call   8020a9 <fd2sockid>
  802210:	89 c2                	mov    %eax,%edx
  802212:	85 d2                	test   %edx,%edx
  802214:	78 0f                	js     802225 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802216:	8b 45 0c             	mov    0xc(%ebp),%eax
  802219:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221d:	89 14 24             	mov    %edx,(%esp)
  802220:	e8 a4 01 00 00       	call   8023c9 <nsipc_listen>
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80222d:	8b 45 10             	mov    0x10(%ebp),%eax
  802230:	89 44 24 08          	mov    %eax,0x8(%esp)
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	89 04 24             	mov    %eax,(%esp)
  802241:	e8 98 02 00 00       	call   8024de <nsipc_socket>
  802246:	89 c2                	mov    %eax,%edx
  802248:	85 d2                	test   %edx,%edx
  80224a:	78 05                	js     802251 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80224c:	e8 8a fe ff ff       	call   8020db <alloc_sockfd>
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	53                   	push   %ebx
  802257:	83 ec 14             	sub    $0x14,%esp
  80225a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80225c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802263:	75 11                	jne    802276 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802265:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80226c:	e8 8e 08 00 00       	call   802aff <ipc_find_env>
  802271:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802276:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80227d:	00 
  80227e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802285:	00 
  802286:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80228a:	a1 04 50 80 00       	mov    0x805004,%eax
  80228f:	89 04 24             	mov    %eax,(%esp)
  802292:	e8 fd 07 00 00       	call   802a94 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802297:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80229e:	00 
  80229f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022a6:	00 
  8022a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022ae:	e8 8d 07 00 00       	call   802a40 <ipc_recv>
}
  8022b3:	83 c4 14             	add    $0x14,%esp
  8022b6:	5b                   	pop    %ebx
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    

008022b9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	56                   	push   %esi
  8022bd:	53                   	push   %ebx
  8022be:	83 ec 10             	sub    $0x10,%esp
  8022c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022cc:	8b 06                	mov    (%esi),%eax
  8022ce:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d8:	e8 76 ff ff ff       	call   802253 <nsipc>
  8022dd:	89 c3                	mov    %eax,%ebx
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	78 23                	js     802306 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022e3:	a1 10 70 80 00       	mov    0x807010,%eax
  8022e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ec:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022f3:	00 
  8022f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f7:	89 04 24             	mov    %eax,(%esp)
  8022fa:	e8 75 e7 ff ff       	call   800a74 <memmove>
		*addrlen = ret->ret_addrlen;
  8022ff:	a1 10 70 80 00       	mov    0x807010,%eax
  802304:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802306:	89 d8                	mov    %ebx,%eax
  802308:	83 c4 10             	add    $0x10,%esp
  80230b:	5b                   	pop    %ebx
  80230c:	5e                   	pop    %esi
  80230d:	5d                   	pop    %ebp
  80230e:	c3                   	ret    

0080230f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	53                   	push   %ebx
  802313:	83 ec 14             	sub    $0x14,%esp
  802316:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802321:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802325:	8b 45 0c             	mov    0xc(%ebp),%eax
  802328:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802333:	e8 3c e7 ff ff       	call   800a74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802338:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80233e:	b8 02 00 00 00       	mov    $0x2,%eax
  802343:	e8 0b ff ff ff       	call   802253 <nsipc>
}
  802348:	83 c4 14             	add    $0x14,%esp
  80234b:	5b                   	pop    %ebx
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    

0080234e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80235c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802364:	b8 03 00 00 00       	mov    $0x3,%eax
  802369:	e8 e5 fe ff ff       	call   802253 <nsipc>
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <nsipc_close>:

int
nsipc_close(int s)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80237e:	b8 04 00 00 00       	mov    $0x4,%eax
  802383:	e8 cb fe ff ff       	call   802253 <nsipc>
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	53                   	push   %ebx
  80238e:	83 ec 14             	sub    $0x14,%esp
  802391:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80239c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023ae:	e8 c1 e6 ff ff       	call   800a74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023b3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8023be:	e8 90 fe ff ff       	call   802253 <nsipc>
}
  8023c3:	83 c4 14             	add    $0x14,%esp
  8023c6:	5b                   	pop    %ebx
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    

008023c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023da:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023df:	b8 06 00 00 00       	mov    $0x6,%eax
  8023e4:	e8 6a fe ff ff       	call   802253 <nsipc>
}
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	56                   	push   %esi
  8023ef:	53                   	push   %ebx
  8023f0:	83 ec 10             	sub    $0x10,%esp
  8023f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023fe:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802404:	8b 45 14             	mov    0x14(%ebp),%eax
  802407:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80240c:	b8 07 00 00 00       	mov    $0x7,%eax
  802411:	e8 3d fe ff ff       	call   802253 <nsipc>
  802416:	89 c3                	mov    %eax,%ebx
  802418:	85 c0                	test   %eax,%eax
  80241a:	78 46                	js     802462 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80241c:	39 f0                	cmp    %esi,%eax
  80241e:	7f 07                	jg     802427 <nsipc_recv+0x3c>
  802420:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802425:	7e 24                	jle    80244b <nsipc_recv+0x60>
  802427:	c7 44 24 0c 1a 34 80 	movl   $0x80341a,0xc(%esp)
  80242e:	00 
  80242f:	c7 44 24 08 2f 33 80 	movl   $0x80332f,0x8(%esp)
  802436:	00 
  802437:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80243e:	00 
  80243f:	c7 04 24 2f 34 80 00 	movl   $0x80342f,(%esp)
  802446:	e8 72 dd ff ff       	call   8001bd <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80244b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80244f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802456:	00 
  802457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245a:	89 04 24             	mov    %eax,(%esp)
  80245d:	e8 12 e6 ff ff       	call   800a74 <memmove>
	}

	return r;
}
  802462:	89 d8                	mov    %ebx,%eax
  802464:	83 c4 10             	add    $0x10,%esp
  802467:	5b                   	pop    %ebx
  802468:	5e                   	pop    %esi
  802469:	5d                   	pop    %ebp
  80246a:	c3                   	ret    

0080246b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	53                   	push   %ebx
  80246f:	83 ec 14             	sub    $0x14,%esp
  802472:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80247d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802483:	7e 24                	jle    8024a9 <nsipc_send+0x3e>
  802485:	c7 44 24 0c 3b 34 80 	movl   $0x80343b,0xc(%esp)
  80248c:	00 
  80248d:	c7 44 24 08 2f 33 80 	movl   $0x80332f,0x8(%esp)
  802494:	00 
  802495:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80249c:	00 
  80249d:	c7 04 24 2f 34 80 00 	movl   $0x80342f,(%esp)
  8024a4:	e8 14 dd ff ff       	call   8001bd <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8024bb:	e8 b4 e5 ff ff       	call   800a74 <memmove>
	nsipcbuf.send.req_size = size;
  8024c0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024c9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8024d3:	e8 7b fd ff ff       	call   802253 <nsipc>
}
  8024d8:	83 c4 14             	add    $0x14,%esp
  8024db:	5b                   	pop    %ebx
  8024dc:	5d                   	pop    %ebp
  8024dd:	c3                   	ret    

008024de <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ef:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024fc:	b8 09 00 00 00       	mov    $0x9,%eax
  802501:	e8 4d fd ff ff       	call   802253 <nsipc>
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	56                   	push   %esi
  80250c:	53                   	push   %ebx
  80250d:	83 ec 10             	sub    $0x10,%esp
  802510:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	89 04 24             	mov    %eax,(%esp)
  802519:	e8 12 ec ff ff       	call   801130 <fd2data>
  80251e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802520:	c7 44 24 04 47 34 80 	movl   $0x803447,0x4(%esp)
  802527:	00 
  802528:	89 1c 24             	mov    %ebx,(%esp)
  80252b:	e8 a7 e3 ff ff       	call   8008d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802530:	8b 46 04             	mov    0x4(%esi),%eax
  802533:	2b 06                	sub    (%esi),%eax
  802535:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80253b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802542:	00 00 00 
	stat->st_dev = &devpipe;
  802545:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80254c:	40 80 00 
	return 0;
}
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
  802554:	83 c4 10             	add    $0x10,%esp
  802557:	5b                   	pop    %ebx
  802558:	5e                   	pop    %esi
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    

0080255b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	53                   	push   %ebx
  80255f:	83 ec 14             	sub    $0x14,%esp
  802562:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802565:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802569:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802570:	e8 25 e8 ff ff       	call   800d9a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802575:	89 1c 24             	mov    %ebx,(%esp)
  802578:	e8 b3 eb ff ff       	call   801130 <fd2data>
  80257d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802581:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802588:	e8 0d e8 ff ff       	call   800d9a <sys_page_unmap>
}
  80258d:	83 c4 14             	add    $0x14,%esp
  802590:	5b                   	pop    %ebx
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    

00802593 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	57                   	push   %edi
  802597:	56                   	push   %esi
  802598:	53                   	push   %ebx
  802599:	83 ec 2c             	sub    $0x2c,%esp
  80259c:	89 c6                	mov    %eax,%esi
  80259e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8025a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8025a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025a9:	89 34 24             	mov    %esi,(%esp)
  8025ac:	e8 8d 05 00 00       	call   802b3e <pageref>
  8025b1:	89 c7                	mov    %eax,%edi
  8025b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b6:	89 04 24             	mov    %eax,(%esp)
  8025b9:	e8 80 05 00 00       	call   802b3e <pageref>
  8025be:	39 c7                	cmp    %eax,%edi
  8025c0:	0f 94 c2             	sete   %dl
  8025c3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8025c6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8025cc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8025cf:	39 fb                	cmp    %edi,%ebx
  8025d1:	74 21                	je     8025f4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8025d3:	84 d2                	test   %dl,%dl
  8025d5:	74 ca                	je     8025a1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025d7:	8b 51 58             	mov    0x58(%ecx),%edx
  8025da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025e6:	c7 04 24 4e 34 80 00 	movl   $0x80344e,(%esp)
  8025ed:	e8 c4 dc ff ff       	call   8002b6 <cprintf>
  8025f2:	eb ad                	jmp    8025a1 <_pipeisclosed+0xe>
	}
}
  8025f4:	83 c4 2c             	add    $0x2c,%esp
  8025f7:	5b                   	pop    %ebx
  8025f8:	5e                   	pop    %esi
  8025f9:	5f                   	pop    %edi
  8025fa:	5d                   	pop    %ebp
  8025fb:	c3                   	ret    

008025fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	57                   	push   %edi
  802600:	56                   	push   %esi
  802601:	53                   	push   %ebx
  802602:	83 ec 1c             	sub    $0x1c,%esp
  802605:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802608:	89 34 24             	mov    %esi,(%esp)
  80260b:	e8 20 eb ff ff       	call   801130 <fd2data>
  802610:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802612:	bf 00 00 00 00       	mov    $0x0,%edi
  802617:	eb 45                	jmp    80265e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802619:	89 da                	mov    %ebx,%edx
  80261b:	89 f0                	mov    %esi,%eax
  80261d:	e8 71 ff ff ff       	call   802593 <_pipeisclosed>
  802622:	85 c0                	test   %eax,%eax
  802624:	75 41                	jne    802667 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802626:	e8 a9 e6 ff ff       	call   800cd4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80262b:	8b 43 04             	mov    0x4(%ebx),%eax
  80262e:	8b 0b                	mov    (%ebx),%ecx
  802630:	8d 51 20             	lea    0x20(%ecx),%edx
  802633:	39 d0                	cmp    %edx,%eax
  802635:	73 e2                	jae    802619 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802637:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80263a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80263e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802641:	99                   	cltd   
  802642:	c1 ea 1b             	shr    $0x1b,%edx
  802645:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802648:	83 e1 1f             	and    $0x1f,%ecx
  80264b:	29 d1                	sub    %edx,%ecx
  80264d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802651:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802655:	83 c0 01             	add    $0x1,%eax
  802658:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80265b:	83 c7 01             	add    $0x1,%edi
  80265e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802661:	75 c8                	jne    80262b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802663:	89 f8                	mov    %edi,%eax
  802665:	eb 05                	jmp    80266c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80266c:	83 c4 1c             	add    $0x1c,%esp
  80266f:	5b                   	pop    %ebx
  802670:	5e                   	pop    %esi
  802671:	5f                   	pop    %edi
  802672:	5d                   	pop    %ebp
  802673:	c3                   	ret    

00802674 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	57                   	push   %edi
  802678:	56                   	push   %esi
  802679:	53                   	push   %ebx
  80267a:	83 ec 1c             	sub    $0x1c,%esp
  80267d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802680:	89 3c 24             	mov    %edi,(%esp)
  802683:	e8 a8 ea ff ff       	call   801130 <fd2data>
  802688:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80268a:	be 00 00 00 00       	mov    $0x0,%esi
  80268f:	eb 3d                	jmp    8026ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802691:	85 f6                	test   %esi,%esi
  802693:	74 04                	je     802699 <devpipe_read+0x25>
				return i;
  802695:	89 f0                	mov    %esi,%eax
  802697:	eb 43                	jmp    8026dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802699:	89 da                	mov    %ebx,%edx
  80269b:	89 f8                	mov    %edi,%eax
  80269d:	e8 f1 fe ff ff       	call   802593 <_pipeisclosed>
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	75 31                	jne    8026d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026a6:	e8 29 e6 ff ff       	call   800cd4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026ab:	8b 03                	mov    (%ebx),%eax
  8026ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026b0:	74 df                	je     802691 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026b2:	99                   	cltd   
  8026b3:	c1 ea 1b             	shr    $0x1b,%edx
  8026b6:	01 d0                	add    %edx,%eax
  8026b8:	83 e0 1f             	and    $0x1f,%eax
  8026bb:	29 d0                	sub    %edx,%eax
  8026bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026cb:	83 c6 01             	add    $0x1,%esi
  8026ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026d1:	75 d8                	jne    8026ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8026d3:	89 f0                	mov    %esi,%eax
  8026d5:	eb 05                	jmp    8026dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8026dc:	83 c4 1c             	add    $0x1c,%esp
  8026df:	5b                   	pop    %ebx
  8026e0:	5e                   	pop    %esi
  8026e1:	5f                   	pop    %edi
  8026e2:	5d                   	pop    %ebp
  8026e3:	c3                   	ret    

008026e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	56                   	push   %esi
  8026e8:	53                   	push   %ebx
  8026e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ef:	89 04 24             	mov    %eax,(%esp)
  8026f2:	e8 50 ea ff ff       	call   801147 <fd_alloc>
  8026f7:	89 c2                	mov    %eax,%edx
  8026f9:	85 d2                	test   %edx,%edx
  8026fb:	0f 88 4d 01 00 00    	js     80284e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802701:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802708:	00 
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802710:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802717:	e8 d7 e5 ff ff       	call   800cf3 <sys_page_alloc>
  80271c:	89 c2                	mov    %eax,%edx
  80271e:	85 d2                	test   %edx,%edx
  802720:	0f 88 28 01 00 00    	js     80284e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802726:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802729:	89 04 24             	mov    %eax,(%esp)
  80272c:	e8 16 ea ff ff       	call   801147 <fd_alloc>
  802731:	89 c3                	mov    %eax,%ebx
  802733:	85 c0                	test   %eax,%eax
  802735:	0f 88 fe 00 00 00    	js     802839 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80273b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802742:	00 
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802751:	e8 9d e5 ff ff       	call   800cf3 <sys_page_alloc>
  802756:	89 c3                	mov    %eax,%ebx
  802758:	85 c0                	test   %eax,%eax
  80275a:	0f 88 d9 00 00 00    	js     802839 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	89 04 24             	mov    %eax,(%esp)
  802766:	e8 c5 e9 ff ff       	call   801130 <fd2data>
  80276b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80276d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802774:	00 
  802775:	89 44 24 04          	mov    %eax,0x4(%esp)
  802779:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802780:	e8 6e e5 ff ff       	call   800cf3 <sys_page_alloc>
  802785:	89 c3                	mov    %eax,%ebx
  802787:	85 c0                	test   %eax,%eax
  802789:	0f 88 97 00 00 00    	js     802826 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	89 04 24             	mov    %eax,(%esp)
  802795:	e8 96 e9 ff ff       	call   801130 <fd2data>
  80279a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8027a1:	00 
  8027a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027ad:	00 
  8027ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b9:	e8 89 e5 ff ff       	call   800d47 <sys_page_map>
  8027be:	89 c3                	mov    %eax,%ebx
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	78 52                	js     802816 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8027c4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8027d9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	89 04 24             	mov    %eax,(%esp)
  8027f4:	e8 27 e9 ff ff       	call   801120 <fd2num>
  8027f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027fc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802801:	89 04 24             	mov    %eax,(%esp)
  802804:	e8 17 e9 ff ff       	call   801120 <fd2num>
  802809:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80280c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80280f:	b8 00 00 00 00       	mov    $0x0,%eax
  802814:	eb 38                	jmp    80284e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802816:	89 74 24 04          	mov    %esi,0x4(%esp)
  80281a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802821:	e8 74 e5 ff ff       	call   800d9a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80282d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802834:	e8 61 e5 ff ff       	call   800d9a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802840:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802847:	e8 4e e5 ff ff       	call   800d9a <sys_page_unmap>
  80284c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80284e:	83 c4 30             	add    $0x30,%esp
  802851:	5b                   	pop    %ebx
  802852:	5e                   	pop    %esi
  802853:	5d                   	pop    %ebp
  802854:	c3                   	ret    

00802855 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
  802858:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80285b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80285e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	89 04 24             	mov    %eax,(%esp)
  802868:	e8 29 e9 ff ff       	call   801196 <fd_lookup>
  80286d:	89 c2                	mov    %eax,%edx
  80286f:	85 d2                	test   %edx,%edx
  802871:	78 15                	js     802888 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	89 04 24             	mov    %eax,(%esp)
  802879:	e8 b2 e8 ff ff       	call   801130 <fd2data>
	return _pipeisclosed(fd, p);
  80287e:	89 c2                	mov    %eax,%edx
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	e8 0b fd ff ff       	call   802593 <_pipeisclosed>
}
  802888:	c9                   	leave  
  802889:	c3                   	ret    
  80288a:	66 90                	xchg   %ax,%ax
  80288c:	66 90                	xchg   %ax,%ax
  80288e:	66 90                	xchg   %ax,%ax

00802890 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802893:	b8 00 00 00 00       	mov    $0x0,%eax
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    

0080289a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8028a0:	c7 44 24 04 66 34 80 	movl   $0x803466,0x4(%esp)
  8028a7:	00 
  8028a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ab:	89 04 24             	mov    %eax,(%esp)
  8028ae:	e8 24 e0 ff ff       	call   8008d7 <strcpy>
	return 0;
}
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	c9                   	leave  
  8028b9:	c3                   	ret    

008028ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8028ba:	55                   	push   %ebp
  8028bb:	89 e5                	mov    %esp,%ebp
  8028bd:	57                   	push   %edi
  8028be:	56                   	push   %esi
  8028bf:	53                   	push   %ebx
  8028c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028d1:	eb 31                	jmp    802904 <devcons_write+0x4a>
		m = n - tot;
  8028d3:	8b 75 10             	mov    0x10(%ebp),%esi
  8028d6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8028d8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8028db:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8028e0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028e7:	03 45 0c             	add    0xc(%ebp),%eax
  8028ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ee:	89 3c 24             	mov    %edi,(%esp)
  8028f1:	e8 7e e1 ff ff       	call   800a74 <memmove>
		sys_cputs(buf, m);
  8028f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028fa:	89 3c 24             	mov    %edi,(%esp)
  8028fd:	e8 24 e3 ff ff       	call   800c26 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802902:	01 f3                	add    %esi,%ebx
  802904:	89 d8                	mov    %ebx,%eax
  802906:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802909:	72 c8                	jb     8028d3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80290b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802911:	5b                   	pop    %ebx
  802912:	5e                   	pop    %esi
  802913:	5f                   	pop    %edi
  802914:	5d                   	pop    %ebp
  802915:	c3                   	ret    

00802916 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80291c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802921:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802925:	75 07                	jne    80292e <devcons_read+0x18>
  802927:	eb 2a                	jmp    802953 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802929:	e8 a6 e3 ff ff       	call   800cd4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80292e:	66 90                	xchg   %ax,%ax
  802930:	e8 0f e3 ff ff       	call   800c44 <sys_cgetc>
  802935:	85 c0                	test   %eax,%eax
  802937:	74 f0                	je     802929 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802939:	85 c0                	test   %eax,%eax
  80293b:	78 16                	js     802953 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80293d:	83 f8 04             	cmp    $0x4,%eax
  802940:	74 0c                	je     80294e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802942:	8b 55 0c             	mov    0xc(%ebp),%edx
  802945:	88 02                	mov    %al,(%edx)
	return 1;
  802947:	b8 01 00 00 00       	mov    $0x1,%eax
  80294c:	eb 05                	jmp    802953 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80294e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802961:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802968:	00 
  802969:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80296c:	89 04 24             	mov    %eax,(%esp)
  80296f:	e8 b2 e2 ff ff       	call   800c26 <sys_cputs>
}
  802974:	c9                   	leave  
  802975:	c3                   	ret    

00802976 <getchar>:

int
getchar(void)
{
  802976:	55                   	push   %ebp
  802977:	89 e5                	mov    %esp,%ebp
  802979:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80297c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802983:	00 
  802984:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802992:	e8 93 ea ff ff       	call   80142a <read>
	if (r < 0)
  802997:	85 c0                	test   %eax,%eax
  802999:	78 0f                	js     8029aa <getchar+0x34>
		return r;
	if (r < 1)
  80299b:	85 c0                	test   %eax,%eax
  80299d:	7e 06                	jle    8029a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80299f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8029a3:	eb 05                	jmp    8029aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8029a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	89 04 24             	mov    %eax,(%esp)
  8029bf:	e8 d2 e7 ff ff       	call   801196 <fd_lookup>
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	78 11                	js     8029d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029d1:	39 10                	cmp    %edx,(%eax)
  8029d3:	0f 94 c0             	sete   %al
  8029d6:	0f b6 c0             	movzbl %al,%eax
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <opencons>:

int
opencons(void)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
  8029de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029e4:	89 04 24             	mov    %eax,(%esp)
  8029e7:	e8 5b e7 ff ff       	call   801147 <fd_alloc>
		return r;
  8029ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	78 40                	js     802a32 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029f9:	00 
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a08:	e8 e6 e2 ff ff       	call   800cf3 <sys_page_alloc>
		return r;
  802a0d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	78 1f                	js     802a32 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a13:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a28:	89 04 24             	mov    %eax,(%esp)
  802a2b:	e8 f0 e6 ff ff       	call   801120 <fd2num>
  802a30:	89 c2                	mov    %eax,%edx
}
  802a32:	89 d0                	mov    %edx,%eax
  802a34:	c9                   	leave  
  802a35:	c3                   	ret    
  802a36:	66 90                	xchg   %ax,%ax
  802a38:	66 90                	xchg   %ax,%ax
  802a3a:	66 90                	xchg   %ax,%ax
  802a3c:	66 90                	xchg   %ax,%ax
  802a3e:	66 90                	xchg   %ax,%ax

00802a40 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a40:	55                   	push   %ebp
  802a41:	89 e5                	mov    %esp,%ebp
  802a43:	56                   	push   %esi
  802a44:	53                   	push   %ebx
  802a45:	83 ec 10             	sub    $0x10,%esp
  802a48:	8b 75 08             	mov    0x8(%ebp),%esi
  802a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802a51:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802a53:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a58:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  802a5b:	89 04 24             	mov    %eax,(%esp)
  802a5e:	e8 a6 e4 ff ff       	call   800f09 <sys_ipc_recv>
  802a63:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802a65:	85 d2                	test   %edx,%edx
  802a67:	75 24                	jne    802a8d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802a69:	85 f6                	test   %esi,%esi
  802a6b:	74 0a                	je     802a77 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  802a6d:	a1 08 50 80 00       	mov    0x805008,%eax
  802a72:	8b 40 74             	mov    0x74(%eax),%eax
  802a75:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802a77:	85 db                	test   %ebx,%ebx
  802a79:	74 0a                	je     802a85 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  802a7b:	a1 08 50 80 00       	mov    0x805008,%eax
  802a80:	8b 40 78             	mov    0x78(%eax),%eax
  802a83:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802a85:	a1 08 50 80 00       	mov    0x805008,%eax
  802a8a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  802a8d:	83 c4 10             	add    $0x10,%esp
  802a90:	5b                   	pop    %ebx
  802a91:	5e                   	pop    %esi
  802a92:	5d                   	pop    %ebp
  802a93:	c3                   	ret    

00802a94 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a94:	55                   	push   %ebp
  802a95:	89 e5                	mov    %esp,%ebp
  802a97:	57                   	push   %edi
  802a98:	56                   	push   %esi
  802a99:	53                   	push   %ebx
  802a9a:	83 ec 1c             	sub    $0x1c,%esp
  802a9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802aa0:	8b 75 0c             	mov    0xc(%ebp),%esi
  802aa3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802aa6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802aa8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802aad:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  802ab3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ab7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802abb:	89 74 24 04          	mov    %esi,0x4(%esp)
  802abf:	89 3c 24             	mov    %edi,(%esp)
  802ac2:	e8 1f e4 ff ff       	call   800ee6 <sys_ipc_try_send>

		if (ret == 0)
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	74 2c                	je     802af7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  802acb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ace:	74 20                	je     802af0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802ad0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ad4:	c7 44 24 08 74 34 80 	movl   $0x803474,0x8(%esp)
  802adb:	00 
  802adc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802ae3:	00 
  802ae4:	c7 04 24 a4 34 80 00 	movl   $0x8034a4,(%esp)
  802aeb:	e8 cd d6 ff ff       	call   8001bd <_panic>
		}

		sys_yield();
  802af0:	e8 df e1 ff ff       	call   800cd4 <sys_yield>
	}
  802af5:	eb b9                	jmp    802ab0 <ipc_send+0x1c>
}
  802af7:	83 c4 1c             	add    $0x1c,%esp
  802afa:	5b                   	pop    %ebx
  802afb:	5e                   	pop    %esi
  802afc:	5f                   	pop    %edi
  802afd:	5d                   	pop    %ebp
  802afe:	c3                   	ret    

00802aff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
  802b02:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b0a:	89 c2                	mov    %eax,%edx
  802b0c:	c1 e2 07             	shl    $0x7,%edx
  802b0f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802b16:	8b 52 50             	mov    0x50(%edx),%edx
  802b19:	39 ca                	cmp    %ecx,%edx
  802b1b:	75 11                	jne    802b2e <ipc_find_env+0x2f>
			return envs[i].env_id;
  802b1d:	89 c2                	mov    %eax,%edx
  802b1f:	c1 e2 07             	shl    $0x7,%edx
  802b22:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802b29:	8b 40 40             	mov    0x40(%eax),%eax
  802b2c:	eb 0e                	jmp    802b3c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b2e:	83 c0 01             	add    $0x1,%eax
  802b31:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b36:	75 d2                	jne    802b0a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802b38:	66 b8 00 00          	mov    $0x0,%ax
}
  802b3c:	5d                   	pop    %ebp
  802b3d:	c3                   	ret    

00802b3e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
  802b41:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b44:	89 d0                	mov    %edx,%eax
  802b46:	c1 e8 16             	shr    $0x16,%eax
  802b49:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b55:	f6 c1 01             	test   $0x1,%cl
  802b58:	74 1d                	je     802b77 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b5a:	c1 ea 0c             	shr    $0xc,%edx
  802b5d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b64:	f6 c2 01             	test   $0x1,%dl
  802b67:	74 0e                	je     802b77 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b69:	c1 ea 0c             	shr    $0xc,%edx
  802b6c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b73:	ef 
  802b74:	0f b7 c0             	movzwl %ax,%eax
}
  802b77:	5d                   	pop    %ebp
  802b78:	c3                   	ret    
  802b79:	66 90                	xchg   %ax,%ax
  802b7b:	66 90                	xchg   %ax,%ax
  802b7d:	66 90                	xchg   %ax,%ax
  802b7f:	90                   	nop

00802b80 <__udivdi3>:
  802b80:	55                   	push   %ebp
  802b81:	57                   	push   %edi
  802b82:	56                   	push   %esi
  802b83:	83 ec 0c             	sub    $0xc,%esp
  802b86:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b8a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b8e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b92:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b96:	85 c0                	test   %eax,%eax
  802b98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b9c:	89 ea                	mov    %ebp,%edx
  802b9e:	89 0c 24             	mov    %ecx,(%esp)
  802ba1:	75 2d                	jne    802bd0 <__udivdi3+0x50>
  802ba3:	39 e9                	cmp    %ebp,%ecx
  802ba5:	77 61                	ja     802c08 <__udivdi3+0x88>
  802ba7:	85 c9                	test   %ecx,%ecx
  802ba9:	89 ce                	mov    %ecx,%esi
  802bab:	75 0b                	jne    802bb8 <__udivdi3+0x38>
  802bad:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb2:	31 d2                	xor    %edx,%edx
  802bb4:	f7 f1                	div    %ecx
  802bb6:	89 c6                	mov    %eax,%esi
  802bb8:	31 d2                	xor    %edx,%edx
  802bba:	89 e8                	mov    %ebp,%eax
  802bbc:	f7 f6                	div    %esi
  802bbe:	89 c5                	mov    %eax,%ebp
  802bc0:	89 f8                	mov    %edi,%eax
  802bc2:	f7 f6                	div    %esi
  802bc4:	89 ea                	mov    %ebp,%edx
  802bc6:	83 c4 0c             	add    $0xc,%esp
  802bc9:	5e                   	pop    %esi
  802bca:	5f                   	pop    %edi
  802bcb:	5d                   	pop    %ebp
  802bcc:	c3                   	ret    
  802bcd:	8d 76 00             	lea    0x0(%esi),%esi
  802bd0:	39 e8                	cmp    %ebp,%eax
  802bd2:	77 24                	ja     802bf8 <__udivdi3+0x78>
  802bd4:	0f bd e8             	bsr    %eax,%ebp
  802bd7:	83 f5 1f             	xor    $0x1f,%ebp
  802bda:	75 3c                	jne    802c18 <__udivdi3+0x98>
  802bdc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802be0:	39 34 24             	cmp    %esi,(%esp)
  802be3:	0f 86 9f 00 00 00    	jbe    802c88 <__udivdi3+0x108>
  802be9:	39 d0                	cmp    %edx,%eax
  802beb:	0f 82 97 00 00 00    	jb     802c88 <__udivdi3+0x108>
  802bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bf8:	31 d2                	xor    %edx,%edx
  802bfa:	31 c0                	xor    %eax,%eax
  802bfc:	83 c4 0c             	add    $0xc,%esp
  802bff:	5e                   	pop    %esi
  802c00:	5f                   	pop    %edi
  802c01:	5d                   	pop    %ebp
  802c02:	c3                   	ret    
  802c03:	90                   	nop
  802c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c08:	89 f8                	mov    %edi,%eax
  802c0a:	f7 f1                	div    %ecx
  802c0c:	31 d2                	xor    %edx,%edx
  802c0e:	83 c4 0c             	add    $0xc,%esp
  802c11:	5e                   	pop    %esi
  802c12:	5f                   	pop    %edi
  802c13:	5d                   	pop    %ebp
  802c14:	c3                   	ret    
  802c15:	8d 76 00             	lea    0x0(%esi),%esi
  802c18:	89 e9                	mov    %ebp,%ecx
  802c1a:	8b 3c 24             	mov    (%esp),%edi
  802c1d:	d3 e0                	shl    %cl,%eax
  802c1f:	89 c6                	mov    %eax,%esi
  802c21:	b8 20 00 00 00       	mov    $0x20,%eax
  802c26:	29 e8                	sub    %ebp,%eax
  802c28:	89 c1                	mov    %eax,%ecx
  802c2a:	d3 ef                	shr    %cl,%edi
  802c2c:	89 e9                	mov    %ebp,%ecx
  802c2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c32:	8b 3c 24             	mov    (%esp),%edi
  802c35:	09 74 24 08          	or     %esi,0x8(%esp)
  802c39:	89 d6                	mov    %edx,%esi
  802c3b:	d3 e7                	shl    %cl,%edi
  802c3d:	89 c1                	mov    %eax,%ecx
  802c3f:	89 3c 24             	mov    %edi,(%esp)
  802c42:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c46:	d3 ee                	shr    %cl,%esi
  802c48:	89 e9                	mov    %ebp,%ecx
  802c4a:	d3 e2                	shl    %cl,%edx
  802c4c:	89 c1                	mov    %eax,%ecx
  802c4e:	d3 ef                	shr    %cl,%edi
  802c50:	09 d7                	or     %edx,%edi
  802c52:	89 f2                	mov    %esi,%edx
  802c54:	89 f8                	mov    %edi,%eax
  802c56:	f7 74 24 08          	divl   0x8(%esp)
  802c5a:	89 d6                	mov    %edx,%esi
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	f7 24 24             	mull   (%esp)
  802c61:	39 d6                	cmp    %edx,%esi
  802c63:	89 14 24             	mov    %edx,(%esp)
  802c66:	72 30                	jb     802c98 <__udivdi3+0x118>
  802c68:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c6c:	89 e9                	mov    %ebp,%ecx
  802c6e:	d3 e2                	shl    %cl,%edx
  802c70:	39 c2                	cmp    %eax,%edx
  802c72:	73 05                	jae    802c79 <__udivdi3+0xf9>
  802c74:	3b 34 24             	cmp    (%esp),%esi
  802c77:	74 1f                	je     802c98 <__udivdi3+0x118>
  802c79:	89 f8                	mov    %edi,%eax
  802c7b:	31 d2                	xor    %edx,%edx
  802c7d:	e9 7a ff ff ff       	jmp    802bfc <__udivdi3+0x7c>
  802c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c88:	31 d2                	xor    %edx,%edx
  802c8a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c8f:	e9 68 ff ff ff       	jmp    802bfc <__udivdi3+0x7c>
  802c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c98:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c9b:	31 d2                	xor    %edx,%edx
  802c9d:	83 c4 0c             	add    $0xc,%esp
  802ca0:	5e                   	pop    %esi
  802ca1:	5f                   	pop    %edi
  802ca2:	5d                   	pop    %ebp
  802ca3:	c3                   	ret    
  802ca4:	66 90                	xchg   %ax,%ax
  802ca6:	66 90                	xchg   %ax,%ax
  802ca8:	66 90                	xchg   %ax,%ax
  802caa:	66 90                	xchg   %ax,%ax
  802cac:	66 90                	xchg   %ax,%ax
  802cae:	66 90                	xchg   %ax,%ax

00802cb0 <__umoddi3>:
  802cb0:	55                   	push   %ebp
  802cb1:	57                   	push   %edi
  802cb2:	56                   	push   %esi
  802cb3:	83 ec 14             	sub    $0x14,%esp
  802cb6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cbe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802cc2:	89 c7                	mov    %eax,%edi
  802cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cc8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802ccc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802cd0:	89 34 24             	mov    %esi,(%esp)
  802cd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	89 c2                	mov    %eax,%edx
  802cdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cdf:	75 17                	jne    802cf8 <__umoddi3+0x48>
  802ce1:	39 fe                	cmp    %edi,%esi
  802ce3:	76 4b                	jbe    802d30 <__umoddi3+0x80>
  802ce5:	89 c8                	mov    %ecx,%eax
  802ce7:	89 fa                	mov    %edi,%edx
  802ce9:	f7 f6                	div    %esi
  802ceb:	89 d0                	mov    %edx,%eax
  802ced:	31 d2                	xor    %edx,%edx
  802cef:	83 c4 14             	add    $0x14,%esp
  802cf2:	5e                   	pop    %esi
  802cf3:	5f                   	pop    %edi
  802cf4:	5d                   	pop    %ebp
  802cf5:	c3                   	ret    
  802cf6:	66 90                	xchg   %ax,%ax
  802cf8:	39 f8                	cmp    %edi,%eax
  802cfa:	77 54                	ja     802d50 <__umoddi3+0xa0>
  802cfc:	0f bd e8             	bsr    %eax,%ebp
  802cff:	83 f5 1f             	xor    $0x1f,%ebp
  802d02:	75 5c                	jne    802d60 <__umoddi3+0xb0>
  802d04:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d08:	39 3c 24             	cmp    %edi,(%esp)
  802d0b:	0f 87 e7 00 00 00    	ja     802df8 <__umoddi3+0x148>
  802d11:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d15:	29 f1                	sub    %esi,%ecx
  802d17:	19 c7                	sbb    %eax,%edi
  802d19:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d21:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d25:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d29:	83 c4 14             	add    $0x14,%esp
  802d2c:	5e                   	pop    %esi
  802d2d:	5f                   	pop    %edi
  802d2e:	5d                   	pop    %ebp
  802d2f:	c3                   	ret    
  802d30:	85 f6                	test   %esi,%esi
  802d32:	89 f5                	mov    %esi,%ebp
  802d34:	75 0b                	jne    802d41 <__umoddi3+0x91>
  802d36:	b8 01 00 00 00       	mov    $0x1,%eax
  802d3b:	31 d2                	xor    %edx,%edx
  802d3d:	f7 f6                	div    %esi
  802d3f:	89 c5                	mov    %eax,%ebp
  802d41:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d45:	31 d2                	xor    %edx,%edx
  802d47:	f7 f5                	div    %ebp
  802d49:	89 c8                	mov    %ecx,%eax
  802d4b:	f7 f5                	div    %ebp
  802d4d:	eb 9c                	jmp    802ceb <__umoddi3+0x3b>
  802d4f:	90                   	nop
  802d50:	89 c8                	mov    %ecx,%eax
  802d52:	89 fa                	mov    %edi,%edx
  802d54:	83 c4 14             	add    $0x14,%esp
  802d57:	5e                   	pop    %esi
  802d58:	5f                   	pop    %edi
  802d59:	5d                   	pop    %ebp
  802d5a:	c3                   	ret    
  802d5b:	90                   	nop
  802d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d60:	8b 04 24             	mov    (%esp),%eax
  802d63:	be 20 00 00 00       	mov    $0x20,%esi
  802d68:	89 e9                	mov    %ebp,%ecx
  802d6a:	29 ee                	sub    %ebp,%esi
  802d6c:	d3 e2                	shl    %cl,%edx
  802d6e:	89 f1                	mov    %esi,%ecx
  802d70:	d3 e8                	shr    %cl,%eax
  802d72:	89 e9                	mov    %ebp,%ecx
  802d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d78:	8b 04 24             	mov    (%esp),%eax
  802d7b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d7f:	89 fa                	mov    %edi,%edx
  802d81:	d3 e0                	shl    %cl,%eax
  802d83:	89 f1                	mov    %esi,%ecx
  802d85:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d89:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d8d:	d3 ea                	shr    %cl,%edx
  802d8f:	89 e9                	mov    %ebp,%ecx
  802d91:	d3 e7                	shl    %cl,%edi
  802d93:	89 f1                	mov    %esi,%ecx
  802d95:	d3 e8                	shr    %cl,%eax
  802d97:	89 e9                	mov    %ebp,%ecx
  802d99:	09 f8                	or     %edi,%eax
  802d9b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d9f:	f7 74 24 04          	divl   0x4(%esp)
  802da3:	d3 e7                	shl    %cl,%edi
  802da5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802da9:	89 d7                	mov    %edx,%edi
  802dab:	f7 64 24 08          	mull   0x8(%esp)
  802daf:	39 d7                	cmp    %edx,%edi
  802db1:	89 c1                	mov    %eax,%ecx
  802db3:	89 14 24             	mov    %edx,(%esp)
  802db6:	72 2c                	jb     802de4 <__umoddi3+0x134>
  802db8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802dbc:	72 22                	jb     802de0 <__umoddi3+0x130>
  802dbe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802dc2:	29 c8                	sub    %ecx,%eax
  802dc4:	19 d7                	sbb    %edx,%edi
  802dc6:	89 e9                	mov    %ebp,%ecx
  802dc8:	89 fa                	mov    %edi,%edx
  802dca:	d3 e8                	shr    %cl,%eax
  802dcc:	89 f1                	mov    %esi,%ecx
  802dce:	d3 e2                	shl    %cl,%edx
  802dd0:	89 e9                	mov    %ebp,%ecx
  802dd2:	d3 ef                	shr    %cl,%edi
  802dd4:	09 d0                	or     %edx,%eax
  802dd6:	89 fa                	mov    %edi,%edx
  802dd8:	83 c4 14             	add    $0x14,%esp
  802ddb:	5e                   	pop    %esi
  802ddc:	5f                   	pop    %edi
  802ddd:	5d                   	pop    %ebp
  802dde:	c3                   	ret    
  802ddf:	90                   	nop
  802de0:	39 d7                	cmp    %edx,%edi
  802de2:	75 da                	jne    802dbe <__umoddi3+0x10e>
  802de4:	8b 14 24             	mov    (%esp),%edx
  802de7:	89 c1                	mov    %eax,%ecx
  802de9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802ded:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802df1:	eb cb                	jmp    802dbe <__umoddi3+0x10e>
  802df3:	90                   	nop
  802df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802df8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802dfc:	0f 82 0f ff ff ff    	jb     802d11 <__umoddi3+0x61>
  802e02:	e9 1a ff ff ff       	jmp    802d21 <__umoddi3+0x71>
