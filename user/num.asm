
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 95 01 00 00       	call   8001c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 30             	sub    $0x30,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	e9 84 00 00 00       	jmp    8000ca <num+0x97>
		if (bol) {
  800046:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  80004d:	74 27                	je     800076 <num+0x43>
			printf("%5d ", ++line);
  80004f:	a1 00 40 80 00       	mov    0x804000,%eax
  800054:	83 c0 01             	add    $0x1,%eax
  800057:	a3 00 40 80 00       	mov    %eax,0x804000
  80005c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800060:	c7 04 24 60 29 80 00 	movl   $0x802960,(%esp)
  800067:	e8 aa 1a 00 00       	call   801b16 <printf>
			bol = 0;
  80006c:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800073:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  800076:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80007d:	00 
  80007e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800082:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800089:	e8 e9 14 00 00       	call   801577 <write>
  80008e:	83 f8 01             	cmp    $0x1,%eax
  800091:	74 27                	je     8000ba <num+0x87>
			panic("write error copying %s: %e", s, r);
  800093:	89 44 24 10          	mov    %eax,0x10(%esp)
  800097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80009a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80009e:	c7 44 24 08 65 29 80 	movl   $0x802965,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000ad:	00 
  8000ae:	c7 04 24 80 29 80 00 	movl   $0x802980,(%esp)
  8000b5:	e8 71 01 00 00       	call   80022b <_panic>
		if (c == '\n')
  8000ba:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  8000be:	75 0a                	jne    8000ca <num+0x97>
			bol = 1;
  8000c0:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c7:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d1:	00 
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	89 34 24             	mov    %esi,(%esp)
  8000d9:	e8 bc 13 00 00       	call   80149a <read>
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 8f 60 ff ff ff    	jg     800046 <num+0x13>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	79 27                	jns    800111 <num+0xde>
		panic("error reading %s: %e", s, n);
  8000ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f5:	c7 44 24 08 8b 29 80 	movl   $0x80298b,0x8(%esp)
  8000fc:	00 
  8000fd:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800104:	00 
  800105:	c7 04 24 80 29 80 00 	movl   $0x802980,(%esp)
  80010c:	e8 1a 01 00 00       	call   80022b <_panic>
}
  800111:	83 c4 30             	add    $0x30,%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 2c             	sub    $0x2c,%esp
	int f, i;

	binaryname = "num";
  800121:	c7 05 04 30 80 00 a0 	movl   $0x8029a0,0x803004
  800128:	29 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 0d                	je     80013e <umain+0x26>
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8d 58 04             	lea    0x4(%eax),%ebx
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
  80013c:	eb 76                	jmp    8001b4 <umain+0x9c>
		num(0, "<stdin>");
  80013e:	c7 44 24 04 a4 29 80 	movl   $0x8029a4,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 e1 fe ff ff       	call   800033 <num>
  800152:	eb 65                	jmp    8001b9 <umain+0xa1>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800154:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800157:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80015e:	00 
  80015f:	8b 03                	mov    (%ebx),%eax
  800161:	89 04 24             	mov    %eax,(%esp)
  800164:	e8 fd 17 00 00       	call   801966 <open>
  800169:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80016b:	85 c0                	test   %eax,%eax
  80016d:	79 29                	jns    800198 <umain+0x80>
				panic("can't open %s: %e", argv[i], f);
  80016f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	8b 00                	mov    (%eax),%eax
  800178:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80017c:	c7 44 24 08 ac 29 80 	movl   $0x8029ac,0x8(%esp)
  800183:	00 
  800184:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80018b:	00 
  80018c:	c7 04 24 80 29 80 00 	movl   $0x802980,(%esp)
  800193:	e8 93 00 00 00       	call   80022b <_panic>
			else {
				num(f, argv[i]);
  800198:	8b 03                	mov    (%ebx),%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	89 34 24             	mov    %esi,(%esp)
  8001a1:	e8 8d fe ff ff       	call   800033 <num>
				close(f);
  8001a6:	89 34 24             	mov    %esi,(%esp)
  8001a9:	e8 89 11 00 00       	call   801337 <close>

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001ae:	83 c7 01             	add    $0x1,%edi
  8001b1:	83 c3 04             	add    $0x4,%ebx
  8001b4:	3b 7d 08             	cmp    0x8(%ebp),%edi
  8001b7:	7c 9b                	jl     800154 <umain+0x3c>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001b9:	e8 54 00 00 00       	call   800212 <exit>
}
  8001be:	83 c4 2c             	add    $0x2c,%esp
  8001c1:	5b                   	pop    %ebx
  8001c2:	5e                   	pop    %esi
  8001c3:	5f                   	pop    %edi
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    

008001c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 10             	sub    $0x10,%esp
  8001ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8001d4:	e8 4c 0b 00 00       	call   800d25 <sys_getenvid>
  8001d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001de:	89 c2                	mov    %eax,%edx
  8001e0:	c1 e2 07             	shl    $0x7,%edx
  8001e3:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8001ea:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ef:	85 db                	test   %ebx,%ebx
  8001f1:	7e 07                	jle    8001fa <libmain+0x34>
		binaryname = argv[0];
  8001f3:	8b 06                	mov    (%esi),%eax
  8001f5:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001fe:	89 1c 24             	mov    %ebx,(%esp)
  800201:	e8 12 ff ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  800206:	e8 07 00 00 00       	call   800212 <exit>
}
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5d                   	pop    %ebp
  800211:	c3                   	ret    

00800212 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800218:	e8 4d 11 00 00       	call   80136a <close_all>
	sys_env_destroy(0);
  80021d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800224:	e8 aa 0a 00 00       	call   800cd3 <sys_env_destroy>
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
  800230:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800233:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800236:	8b 35 04 30 80 00    	mov    0x803004,%esi
  80023c:	e8 e4 0a 00 00       	call   800d25 <sys_getenvid>
  800241:	8b 55 0c             	mov    0xc(%ebp),%edx
  800244:	89 54 24 10          	mov    %edx,0x10(%esp)
  800248:	8b 55 08             	mov    0x8(%ebp),%edx
  80024b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80024f:	89 74 24 08          	mov    %esi,0x8(%esp)
  800253:	89 44 24 04          	mov    %eax,0x4(%esp)
  800257:	c7 04 24 c8 29 80 00 	movl   $0x8029c8,(%esp)
  80025e:	e8 c1 00 00 00       	call   800324 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800263:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800267:	8b 45 10             	mov    0x10(%ebp),%eax
  80026a:	89 04 24             	mov    %eax,(%esp)
  80026d:	e8 51 00 00 00       	call   8002c3 <vcprintf>
	cprintf("\n");
  800272:	c7 04 24 6c 2e 80 00 	movl   $0x802e6c,(%esp)
  800279:	e8 a6 00 00 00       	call   800324 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027e:	cc                   	int3   
  80027f:	eb fd                	jmp    80027e <_panic+0x53>

00800281 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	53                   	push   %ebx
  800285:	83 ec 14             	sub    $0x14,%esp
  800288:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80028b:	8b 13                	mov    (%ebx),%edx
  80028d:	8d 42 01             	lea    0x1(%edx),%eax
  800290:	89 03                	mov    %eax,(%ebx)
  800292:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800295:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800299:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029e:	75 19                	jne    8002b9 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002a0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002a7:	00 
  8002a8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ab:	89 04 24             	mov    %eax,(%esp)
  8002ae:	e8 e3 09 00 00       	call   800c96 <sys_cputs>
		b->idx = 0;
  8002b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002b9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002bd:	83 c4 14             	add    $0x14,%esp
  8002c0:	5b                   	pop    %ebx
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    

008002c3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002d3:	00 00 00 
	b.cnt = 0;
  8002d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002dd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f8:	c7 04 24 81 02 80 00 	movl   $0x800281,(%esp)
  8002ff:	e8 aa 01 00 00       	call   8004ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800304:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80030a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	e8 7a 09 00 00       	call   800c96 <sys_cputs>

	return b.cnt;
}
  80031c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80032a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80032d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	89 04 24             	mov    %eax,(%esp)
  800337:	e8 87 ff ff ff       	call   8002c3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    
  80033e:	66 90                	xchg   %ax,%ax

00800340 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	57                   	push   %edi
  800344:	56                   	push   %esi
  800345:	53                   	push   %ebx
  800346:	83 ec 3c             	sub    $0x3c,%esp
  800349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034c:	89 d7                	mov    %edx,%edi
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	89 c3                	mov    %eax,%ebx
  800359:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	b9 00 00 00 00       	mov    $0x0,%ecx
  800367:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80036d:	39 d9                	cmp    %ebx,%ecx
  80036f:	72 05                	jb     800376 <printnum+0x36>
  800371:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800374:	77 69                	ja     8003df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800376:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800379:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80037d:	83 ee 01             	sub    $0x1,%esi
  800380:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800384:	89 44 24 08          	mov    %eax,0x8(%esp)
  800388:	8b 44 24 08          	mov    0x8(%esp),%eax
  80038c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800390:	89 c3                	mov    %eax,%ebx
  800392:	89 d6                	mov    %edx,%esi
  800394:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80039a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80039e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	e8 0c 23 00 00       	call   8026c0 <__udivdi3>
  8003b4:	89 d9                	mov    %ebx,%ecx
  8003b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003c5:	89 fa                	mov    %edi,%edx
  8003c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ca:	e8 71 ff ff ff       	call   800340 <printnum>
  8003cf:	eb 1b                	jmp    8003ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	89 04 24             	mov    %eax,(%esp)
  8003db:	ff d3                	call   *%ebx
  8003dd:	eb 03                	jmp    8003e2 <printnum+0xa2>
  8003df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e2:	83 ee 01             	sub    $0x1,%esi
  8003e5:	85 f6                	test   %esi,%esi
  8003e7:	7f e8                	jg     8003d1 <printnum+0x91>
  8003e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 dc 23 00 00       	call   8027f0 <__umoddi3>
  800414:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800418:	0f be 80 eb 29 80 00 	movsbl 0x8029eb(%eax),%eax
  80041f:	89 04 24             	mov    %eax,(%esp)
  800422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800425:	ff d0                	call   *%eax
}
  800427:	83 c4 3c             	add    $0x3c,%esp
  80042a:	5b                   	pop    %ebx
  80042b:	5e                   	pop    %esi
  80042c:	5f                   	pop    %edi
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800432:	83 fa 01             	cmp    $0x1,%edx
  800435:	7e 0e                	jle    800445 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800437:	8b 10                	mov    (%eax),%edx
  800439:	8d 4a 08             	lea    0x8(%edx),%ecx
  80043c:	89 08                	mov    %ecx,(%eax)
  80043e:	8b 02                	mov    (%edx),%eax
  800440:	8b 52 04             	mov    0x4(%edx),%edx
  800443:	eb 22                	jmp    800467 <getuint+0x38>
	else if (lflag)
  800445:	85 d2                	test   %edx,%edx
  800447:	74 10                	je     800459 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800449:	8b 10                	mov    (%eax),%edx
  80044b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044e:	89 08                	mov    %ecx,(%eax)
  800450:	8b 02                	mov    (%edx),%eax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
  800457:	eb 0e                	jmp    800467 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800459:	8b 10                	mov    (%eax),%edx
  80045b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80045e:	89 08                	mov    %ecx,(%eax)
  800460:	8b 02                	mov    (%edx),%eax
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80046f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800473:	8b 10                	mov    (%eax),%edx
  800475:	3b 50 04             	cmp    0x4(%eax),%edx
  800478:	73 0a                	jae    800484 <sprintputch+0x1b>
		*b->buf++ = ch;
  80047a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80047d:	89 08                	mov    %ecx,(%eax)
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	88 02                	mov    %al,(%edx)
}
  800484:	5d                   	pop    %ebp
  800485:	c3                   	ret    

00800486 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80048c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80048f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800493:	8b 45 10             	mov    0x10(%ebp),%eax
  800496:	89 44 24 08          	mov    %eax,0x8(%esp)
  80049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 04 24             	mov    %eax,(%esp)
  8004a7:	e8 02 00 00 00       	call   8004ae <vprintfmt>
	va_end(ap);
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	57                   	push   %edi
  8004b2:	56                   	push   %esi
  8004b3:	53                   	push   %ebx
  8004b4:	83 ec 3c             	sub    $0x3c,%esp
  8004b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004bd:	eb 14                	jmp    8004d3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	0f 84 b3 03 00 00    	je     80087a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004cb:	89 04 24             	mov    %eax,(%esp)
  8004ce:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d1:	89 f3                	mov    %esi,%ebx
  8004d3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004d6:	0f b6 03             	movzbl (%ebx),%eax
  8004d9:	83 f8 25             	cmp    $0x25,%eax
  8004dc:	75 e1                	jne    8004bf <vprintfmt+0x11>
  8004de:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004e9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fc:	eb 1d                	jmp    80051b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800500:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800504:	eb 15                	jmp    80051b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800506:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800508:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80050c:	eb 0d                	jmp    80051b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800514:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80051e:	0f b6 0e             	movzbl (%esi),%ecx
  800521:	0f b6 c1             	movzbl %cl,%eax
  800524:	83 e9 23             	sub    $0x23,%ecx
  800527:	80 f9 55             	cmp    $0x55,%cl
  80052a:	0f 87 2a 03 00 00    	ja     80085a <vprintfmt+0x3ac>
  800530:	0f b6 c9             	movzbl %cl,%ecx
  800533:	ff 24 8d 60 2b 80 00 	jmp    *0x802b60(,%ecx,4)
  80053a:	89 de                	mov    %ebx,%esi
  80053c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800541:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800544:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800548:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80054b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80054e:	83 fb 09             	cmp    $0x9,%ebx
  800551:	77 36                	ja     800589 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800553:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800556:	eb e9                	jmp    800541 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8d 48 04             	lea    0x4(%eax),%ecx
  80055e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800568:	eb 22                	jmp    80058c <vprintfmt+0xde>
  80056a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80056d:	85 c9                	test   %ecx,%ecx
  80056f:	b8 00 00 00 00       	mov    $0x0,%eax
  800574:	0f 49 c1             	cmovns %ecx,%eax
  800577:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	89 de                	mov    %ebx,%esi
  80057c:	eb 9d                	jmp    80051b <vprintfmt+0x6d>
  80057e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800580:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800587:	eb 92                	jmp    80051b <vprintfmt+0x6d>
  800589:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80058c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800590:	79 89                	jns    80051b <vprintfmt+0x6d>
  800592:	e9 77 ff ff ff       	jmp    80050e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800597:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80059c:	e9 7a ff ff ff       	jmp    80051b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8d 50 04             	lea    0x4(%eax),%edx
  8005a7:	89 55 14             	mov    %edx,0x14(%ebp)
  8005aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	89 04 24             	mov    %eax,(%esp)
  8005b3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005b6:	e9 18 ff ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8d 50 04             	lea    0x4(%eax),%edx
  8005c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	99                   	cltd   
  8005c7:	31 d0                	xor    %edx,%eax
  8005c9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005cb:	83 f8 12             	cmp    $0x12,%eax
  8005ce:	7f 0b                	jg     8005db <vprintfmt+0x12d>
  8005d0:	8b 14 85 c0 2c 80 00 	mov    0x802cc0(,%eax,4),%edx
  8005d7:	85 d2                	test   %edx,%edx
  8005d9:	75 20                	jne    8005fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005df:	c7 44 24 08 03 2a 80 	movl   $0x802a03,0x8(%esp)
  8005e6:	00 
  8005e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	89 04 24             	mov    %eax,(%esp)
  8005f1:	e8 90 fe ff ff       	call   800486 <printfmt>
  8005f6:	e9 d8 fe ff ff       	jmp    8004d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ff:	c7 44 24 08 01 2e 80 	movl   $0x802e01,0x8(%esp)
  800606:	00 
  800607:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	89 04 24             	mov    %eax,(%esp)
  800611:	e8 70 fe ff ff       	call   800486 <printfmt>
  800616:	e9 b8 fe ff ff       	jmp    8004d3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80061e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800621:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8d 50 04             	lea    0x4(%eax),%edx
  80062a:	89 55 14             	mov    %edx,0x14(%ebp)
  80062d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80062f:	85 f6                	test   %esi,%esi
  800631:	b8 fc 29 80 00       	mov    $0x8029fc,%eax
  800636:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800639:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80063d:	0f 84 97 00 00 00    	je     8006da <vprintfmt+0x22c>
  800643:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800647:	0f 8e 9b 00 00 00    	jle    8006e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800651:	89 34 24             	mov    %esi,(%esp)
  800654:	e8 cf 02 00 00       	call   800928 <strnlen>
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	29 c2                	sub    %eax,%edx
  80065e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800661:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800665:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800668:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800671:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800673:	eb 0f                	jmp    800684 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800675:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800679:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80067c:	89 04 24             	mov    %eax,(%esp)
  80067f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	83 eb 01             	sub    $0x1,%ebx
  800684:	85 db                	test   %ebx,%ebx
  800686:	7f ed                	jg     800675 <vprintfmt+0x1c7>
  800688:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80068b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80068e:	85 d2                	test   %edx,%edx
  800690:	b8 00 00 00 00       	mov    $0x0,%eax
  800695:	0f 49 c2             	cmovns %edx,%eax
  800698:	29 c2                	sub    %eax,%edx
  80069a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80069d:	89 d7                	mov    %edx,%edi
  80069f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006a2:	eb 50                	jmp    8006f4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a8:	74 1e                	je     8006c8 <vprintfmt+0x21a>
  8006aa:	0f be d2             	movsbl %dl,%edx
  8006ad:	83 ea 20             	sub    $0x20,%edx
  8006b0:	83 fa 5e             	cmp    $0x5e,%edx
  8006b3:	76 13                	jbe    8006c8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006c3:	ff 55 08             	call   *0x8(%ebp)
  8006c6:	eb 0d                	jmp    8006d5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d5:	83 ef 01             	sub    $0x1,%edi
  8006d8:	eb 1a                	jmp    8006f4 <vprintfmt+0x246>
  8006da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006dd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006e0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006e6:	eb 0c                	jmp    8006f4 <vprintfmt+0x246>
  8006e8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006f4:	83 c6 01             	add    $0x1,%esi
  8006f7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006fb:	0f be c2             	movsbl %dl,%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	74 27                	je     800729 <vprintfmt+0x27b>
  800702:	85 db                	test   %ebx,%ebx
  800704:	78 9e                	js     8006a4 <vprintfmt+0x1f6>
  800706:	83 eb 01             	sub    $0x1,%ebx
  800709:	79 99                	jns    8006a4 <vprintfmt+0x1f6>
  80070b:	89 f8                	mov    %edi,%eax
  80070d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800710:	8b 75 08             	mov    0x8(%ebp),%esi
  800713:	89 c3                	mov    %eax,%ebx
  800715:	eb 1a                	jmp    800731 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800717:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800722:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800724:	83 eb 01             	sub    $0x1,%ebx
  800727:	eb 08                	jmp    800731 <vprintfmt+0x283>
  800729:	89 fb                	mov    %edi,%ebx
  80072b:	8b 75 08             	mov    0x8(%ebp),%esi
  80072e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800731:	85 db                	test   %ebx,%ebx
  800733:	7f e2                	jg     800717 <vprintfmt+0x269>
  800735:	89 75 08             	mov    %esi,0x8(%ebp)
  800738:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80073b:	e9 93 fd ff ff       	jmp    8004d3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800740:	83 fa 01             	cmp    $0x1,%edx
  800743:	7e 16                	jle    80075b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 50 08             	lea    0x8(%eax),%edx
  80074b:	89 55 14             	mov    %edx,0x14(%ebp)
  80074e:	8b 50 04             	mov    0x4(%eax),%edx
  800751:	8b 00                	mov    (%eax),%eax
  800753:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800756:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800759:	eb 32                	jmp    80078d <vprintfmt+0x2df>
	else if (lflag)
  80075b:	85 d2                	test   %edx,%edx
  80075d:	74 18                	je     800777 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	89 55 14             	mov    %edx,0x14(%ebp)
  800768:	8b 30                	mov    (%eax),%esi
  80076a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80076d:	89 f0                	mov    %esi,%eax
  80076f:	c1 f8 1f             	sar    $0x1f,%eax
  800772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800775:	eb 16                	jmp    80078d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8d 50 04             	lea    0x4(%eax),%edx
  80077d:	89 55 14             	mov    %edx,0x14(%ebp)
  800780:	8b 30                	mov    (%eax),%esi
  800782:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800785:	89 f0                	mov    %esi,%eax
  800787:	c1 f8 1f             	sar    $0x1f,%eax
  80078a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800793:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800798:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80079c:	0f 89 80 00 00 00    	jns    800822 <vprintfmt+0x374>
				putch('-', putdat);
  8007a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007ad:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b6:	f7 d8                	neg    %eax
  8007b8:	83 d2 00             	adc    $0x0,%edx
  8007bb:	f7 da                	neg    %edx
			}
			base = 10;
  8007bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007c2:	eb 5e                	jmp    800822 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c7:	e8 63 fc ff ff       	call   80042f <getuint>
			base = 10;
  8007cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007d1:	eb 4f                	jmp    800822 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d6:	e8 54 fc ff ff       	call   80042f <getuint>
			base = 8;
  8007db:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007e0:	eb 40                	jmp    800822 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8007e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 50 04             	lea    0x4(%eax),%edx
  800804:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800807:	8b 00                	mov    (%eax),%eax
  800809:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80080e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800813:	eb 0d                	jmp    800822 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800815:	8d 45 14             	lea    0x14(%ebp),%eax
  800818:	e8 12 fc ff ff       	call   80042f <getuint>
			base = 16;
  80081d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800822:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800826:	89 74 24 10          	mov    %esi,0x10(%esp)
  80082a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80082d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800831:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800835:	89 04 24             	mov    %eax,(%esp)
  800838:	89 54 24 04          	mov    %edx,0x4(%esp)
  80083c:	89 fa                	mov    %edi,%edx
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	e8 fa fa ff ff       	call   800340 <printnum>
			break;
  800846:	e9 88 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80084b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084f:	89 04 24             	mov    %eax,(%esp)
  800852:	ff 55 08             	call   *0x8(%ebp)
			break;
  800855:	e9 79 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80085a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80085e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800865:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800868:	89 f3                	mov    %esi,%ebx
  80086a:	eb 03                	jmp    80086f <vprintfmt+0x3c1>
  80086c:	83 eb 01             	sub    $0x1,%ebx
  80086f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800873:	75 f7                	jne    80086c <vprintfmt+0x3be>
  800875:	e9 59 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80087a:	83 c4 3c             	add    $0x3c,%esp
  80087d:	5b                   	pop    %ebx
  80087e:	5e                   	pop    %esi
  80087f:	5f                   	pop    %edi
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	83 ec 28             	sub    $0x28,%esp
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800891:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800895:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800898:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	74 30                	je     8008d3 <vsnprintf+0x51>
  8008a3:	85 d2                	test   %edx,%edx
  8008a5:	7e 2c                	jle    8008d3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bc:	c7 04 24 69 04 80 00 	movl   $0x800469,(%esp)
  8008c3:	e8 e6 fb ff ff       	call   8004ae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d1:	eb 05                	jmp    8008d8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008d8:	c9                   	leave  
  8008d9:	c3                   	ret    

008008da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	89 04 24             	mov    %eax,(%esp)
  8008fb:	e8 82 ff ff ff       	call   800882 <vsnprintf>
	va_end(ap);

	return rc;
}
  800900:	c9                   	leave  
  800901:	c3                   	ret    
  800902:	66 90                	xchg   %ax,%ax
  800904:	66 90                	xchg   %ax,%ax
  800906:	66 90                	xchg   %ax,%ax
  800908:	66 90                	xchg   %ax,%ax
  80090a:	66 90                	xchg   %ax,%ax
  80090c:	66 90                	xchg   %ax,%ax
  80090e:	66 90                	xchg   %ax,%ax

00800910 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	eb 03                	jmp    800920 <strlen+0x10>
		n++;
  80091d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800920:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800924:	75 f7                	jne    80091d <strlen+0xd>
		n++;
	return n;
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800931:	b8 00 00 00 00       	mov    $0x0,%eax
  800936:	eb 03                	jmp    80093b <strnlen+0x13>
		n++;
  800938:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093b:	39 d0                	cmp    %edx,%eax
  80093d:	74 06                	je     800945 <strnlen+0x1d>
  80093f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800943:	75 f3                	jne    800938 <strnlen+0x10>
		n++;
	return n;
}
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	53                   	push   %ebx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800951:	89 c2                	mov    %eax,%edx
  800953:	83 c2 01             	add    $0x1,%edx
  800956:	83 c1 01             	add    $0x1,%ecx
  800959:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80095d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800960:	84 db                	test   %bl,%bl
  800962:	75 ef                	jne    800953 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800964:	5b                   	pop    %ebx
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	53                   	push   %ebx
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800971:	89 1c 24             	mov    %ebx,(%esp)
  800974:	e8 97 ff ff ff       	call   800910 <strlen>
	strcpy(dst + len, src);
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800980:	01 d8                	add    %ebx,%eax
  800982:	89 04 24             	mov    %eax,(%esp)
  800985:	e8 bd ff ff ff       	call   800947 <strcpy>
	return dst;
}
  80098a:	89 d8                	mov    %ebx,%eax
  80098c:	83 c4 08             	add    $0x8,%esp
  80098f:	5b                   	pop    %ebx
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 75 08             	mov    0x8(%ebp),%esi
  80099a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099d:	89 f3                	mov    %esi,%ebx
  80099f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a2:	89 f2                	mov    %esi,%edx
  8009a4:	eb 0f                	jmp    8009b5 <strncpy+0x23>
		*dst++ = *src;
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	0f b6 01             	movzbl (%ecx),%eax
  8009ac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009af:	80 39 01             	cmpb   $0x1,(%ecx)
  8009b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b5:	39 da                	cmp    %ebx,%edx
  8009b7:	75 ed                	jne    8009a6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009b9:	89 f0                	mov    %esi,%eax
  8009bb:	5b                   	pop    %ebx
  8009bc:	5e                   	pop    %esi
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	56                   	push   %esi
  8009c3:	53                   	push   %ebx
  8009c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	75 0b                	jne    8009e2 <strlcpy+0x23>
  8009d7:	eb 1d                	jmp    8009f6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	83 c2 01             	add    $0x1,%edx
  8009df:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e2:	39 d8                	cmp    %ebx,%eax
  8009e4:	74 0b                	je     8009f1 <strlcpy+0x32>
  8009e6:	0f b6 0a             	movzbl (%edx),%ecx
  8009e9:	84 c9                	test   %cl,%cl
  8009eb:	75 ec                	jne    8009d9 <strlcpy+0x1a>
  8009ed:	89 c2                	mov    %eax,%edx
  8009ef:	eb 02                	jmp    8009f3 <strlcpy+0x34>
  8009f1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009f3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009f6:	29 f0                	sub    %esi,%eax
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a05:	eb 06                	jmp    800a0d <strcmp+0x11>
		p++, q++;
  800a07:	83 c1 01             	add    $0x1,%ecx
  800a0a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a0d:	0f b6 01             	movzbl (%ecx),%eax
  800a10:	84 c0                	test   %al,%al
  800a12:	74 04                	je     800a18 <strcmp+0x1c>
  800a14:	3a 02                	cmp    (%edx),%al
  800a16:	74 ef                	je     800a07 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a18:	0f b6 c0             	movzbl %al,%eax
  800a1b:	0f b6 12             	movzbl (%edx),%edx
  800a1e:	29 d0                	sub    %edx,%eax
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	53                   	push   %ebx
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2c:	89 c3                	mov    %eax,%ebx
  800a2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a31:	eb 06                	jmp    800a39 <strncmp+0x17>
		n--, p++, q++;
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a39:	39 d8                	cmp    %ebx,%eax
  800a3b:	74 15                	je     800a52 <strncmp+0x30>
  800a3d:	0f b6 08             	movzbl (%eax),%ecx
  800a40:	84 c9                	test   %cl,%cl
  800a42:	74 04                	je     800a48 <strncmp+0x26>
  800a44:	3a 0a                	cmp    (%edx),%cl
  800a46:	74 eb                	je     800a33 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	0f b6 00             	movzbl (%eax),%eax
  800a4b:	0f b6 12             	movzbl (%edx),%edx
  800a4e:	29 d0                	sub    %edx,%eax
  800a50:	eb 05                	jmp    800a57 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a57:	5b                   	pop    %ebx
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a64:	eb 07                	jmp    800a6d <strchr+0x13>
		if (*s == c)
  800a66:	38 ca                	cmp    %cl,%dl
  800a68:	74 0f                	je     800a79 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	0f b6 10             	movzbl (%eax),%edx
  800a70:	84 d2                	test   %dl,%dl
  800a72:	75 f2                	jne    800a66 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	eb 07                	jmp    800a8e <strfind+0x13>
		if (*s == c)
  800a87:	38 ca                	cmp    %cl,%dl
  800a89:	74 0a                	je     800a95 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	0f b6 10             	movzbl (%eax),%edx
  800a91:	84 d2                	test   %dl,%dl
  800a93:	75 f2                	jne    800a87 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	57                   	push   %edi
  800a9b:	56                   	push   %esi
  800a9c:	53                   	push   %ebx
  800a9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa3:	85 c9                	test   %ecx,%ecx
  800aa5:	74 36                	je     800add <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aad:	75 28                	jne    800ad7 <memset+0x40>
  800aaf:	f6 c1 03             	test   $0x3,%cl
  800ab2:	75 23                	jne    800ad7 <memset+0x40>
		c &= 0xFF;
  800ab4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab8:	89 d3                	mov    %edx,%ebx
  800aba:	c1 e3 08             	shl    $0x8,%ebx
  800abd:	89 d6                	mov    %edx,%esi
  800abf:	c1 e6 18             	shl    $0x18,%esi
  800ac2:	89 d0                	mov    %edx,%eax
  800ac4:	c1 e0 10             	shl    $0x10,%eax
  800ac7:	09 f0                	or     %esi,%eax
  800ac9:	09 c2                	or     %eax,%edx
  800acb:	89 d0                	mov    %edx,%eax
  800acd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ad2:	fc                   	cld    
  800ad3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad5:	eb 06                	jmp    800add <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ada:	fc                   	cld    
  800adb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800add:	89 f8                	mov    %edi,%eax
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	57                   	push   %edi
  800ae8:	56                   	push   %esi
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af2:	39 c6                	cmp    %eax,%esi
  800af4:	73 35                	jae    800b2b <memmove+0x47>
  800af6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af9:	39 d0                	cmp    %edx,%eax
  800afb:	73 2e                	jae    800b2b <memmove+0x47>
		s += n;
		d += n;
  800afd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b00:	89 d6                	mov    %edx,%esi
  800b02:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0a:	75 13                	jne    800b1f <memmove+0x3b>
  800b0c:	f6 c1 03             	test   $0x3,%cl
  800b0f:	75 0e                	jne    800b1f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b11:	83 ef 04             	sub    $0x4,%edi
  800b14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b1a:	fd                   	std    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 09                	jmp    800b28 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1f:	83 ef 01             	sub    $0x1,%edi
  800b22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b25:	fd                   	std    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b28:	fc                   	cld    
  800b29:	eb 1d                	jmp    800b48 <memmove+0x64>
  800b2b:	89 f2                	mov    %esi,%edx
  800b2d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2f:	f6 c2 03             	test   $0x3,%dl
  800b32:	75 0f                	jne    800b43 <memmove+0x5f>
  800b34:	f6 c1 03             	test   $0x3,%cl
  800b37:	75 0a                	jne    800b43 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b39:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b3c:	89 c7                	mov    %eax,%edi
  800b3e:	fc                   	cld    
  800b3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b41:	eb 05                	jmp    800b48 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b43:	89 c7                	mov    %eax,%edi
  800b45:	fc                   	cld    
  800b46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b52:	8b 45 10             	mov    0x10(%ebp),%eax
  800b55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	89 04 24             	mov    %eax,(%esp)
  800b66:	e8 79 ff ff ff       	call   800ae4 <memmove>
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b78:	89 d6                	mov    %edx,%esi
  800b7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7d:	eb 1a                	jmp    800b99 <memcmp+0x2c>
		if (*s1 != *s2)
  800b7f:	0f b6 02             	movzbl (%edx),%eax
  800b82:	0f b6 19             	movzbl (%ecx),%ebx
  800b85:	38 d8                	cmp    %bl,%al
  800b87:	74 0a                	je     800b93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b89:	0f b6 c0             	movzbl %al,%eax
  800b8c:	0f b6 db             	movzbl %bl,%ebx
  800b8f:	29 d8                	sub    %ebx,%eax
  800b91:	eb 0f                	jmp    800ba2 <memcmp+0x35>
		s1++, s2++;
  800b93:	83 c2 01             	add    $0x1,%edx
  800b96:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b99:	39 f2                	cmp    %esi,%edx
  800b9b:	75 e2                	jne    800b7f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800baf:	89 c2                	mov    %eax,%edx
  800bb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb4:	eb 07                	jmp    800bbd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb6:	38 08                	cmp    %cl,(%eax)
  800bb8:	74 07                	je     800bc1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	39 d0                	cmp    %edx,%eax
  800bbf:	72 f5                	jb     800bb6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcf:	eb 03                	jmp    800bd4 <strtol+0x11>
		s++;
  800bd1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd4:	0f b6 0a             	movzbl (%edx),%ecx
  800bd7:	80 f9 09             	cmp    $0x9,%cl
  800bda:	74 f5                	je     800bd1 <strtol+0xe>
  800bdc:	80 f9 20             	cmp    $0x20,%cl
  800bdf:	74 f0                	je     800bd1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800be1:	80 f9 2b             	cmp    $0x2b,%cl
  800be4:	75 0a                	jne    800bf0 <strtol+0x2d>
		s++;
  800be6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800be9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bee:	eb 11                	jmp    800c01 <strtol+0x3e>
  800bf0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bf5:	80 f9 2d             	cmp    $0x2d,%cl
  800bf8:	75 07                	jne    800c01 <strtol+0x3e>
		s++, neg = 1;
  800bfa:	8d 52 01             	lea    0x1(%edx),%edx
  800bfd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c01:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c06:	75 15                	jne    800c1d <strtol+0x5a>
  800c08:	80 3a 30             	cmpb   $0x30,(%edx)
  800c0b:	75 10                	jne    800c1d <strtol+0x5a>
  800c0d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c11:	75 0a                	jne    800c1d <strtol+0x5a>
		s += 2, base = 16;
  800c13:	83 c2 02             	add    $0x2,%edx
  800c16:	b8 10 00 00 00       	mov    $0x10,%eax
  800c1b:	eb 10                	jmp    800c2d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	75 0c                	jne    800c2d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c21:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c23:	80 3a 30             	cmpb   $0x30,(%edx)
  800c26:	75 05                	jne    800c2d <strtol+0x6a>
		s++, base = 8;
  800c28:	83 c2 01             	add    $0x1,%edx
  800c2b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c32:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c35:	0f b6 0a             	movzbl (%edx),%ecx
  800c38:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c3b:	89 f0                	mov    %esi,%eax
  800c3d:	3c 09                	cmp    $0x9,%al
  800c3f:	77 08                	ja     800c49 <strtol+0x86>
			dig = *s - '0';
  800c41:	0f be c9             	movsbl %cl,%ecx
  800c44:	83 e9 30             	sub    $0x30,%ecx
  800c47:	eb 20                	jmp    800c69 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c49:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c4c:	89 f0                	mov    %esi,%eax
  800c4e:	3c 19                	cmp    $0x19,%al
  800c50:	77 08                	ja     800c5a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c52:	0f be c9             	movsbl %cl,%ecx
  800c55:	83 e9 57             	sub    $0x57,%ecx
  800c58:	eb 0f                	jmp    800c69 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c5a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c5d:	89 f0                	mov    %esi,%eax
  800c5f:	3c 19                	cmp    $0x19,%al
  800c61:	77 16                	ja     800c79 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c63:	0f be c9             	movsbl %cl,%ecx
  800c66:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c69:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c6c:	7d 0f                	jge    800c7d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c6e:	83 c2 01             	add    $0x1,%edx
  800c71:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c75:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c77:	eb bc                	jmp    800c35 <strtol+0x72>
  800c79:	89 d8                	mov    %ebx,%eax
  800c7b:	eb 02                	jmp    800c7f <strtol+0xbc>
  800c7d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c83:	74 05                	je     800c8a <strtol+0xc7>
		*endptr = (char *) s;
  800c85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c88:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c8a:	f7 d8                	neg    %eax
  800c8c:	85 ff                	test   %edi,%edi
  800c8e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    

00800c96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	89 c3                	mov    %eax,%ebx
  800ca9:	89 c7                	mov    %eax,%edi
  800cab:	89 c6                	mov    %eax,%esi
  800cad:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	89 cb                	mov    %ecx,%ebx
  800ceb:	89 cf                	mov    %ecx,%edi
  800ced:	89 ce                	mov    %ecx,%esi
  800cef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7e 28                	jle    800d1d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cf9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d00:	00 
  800d01:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  800d08:	00 
  800d09:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d10:	00 
  800d11:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800d18:	e8 0e f5 ff ff       	call   80022b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d1d:	83 c4 2c             	add    $0x2c,%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	b8 02 00 00 00       	mov    $0x2,%eax
  800d35:	89 d1                	mov    %edx,%ecx
  800d37:	89 d3                	mov    %edx,%ebx
  800d39:	89 d7                	mov    %edx,%edi
  800d3b:	89 d6                	mov    %edx,%esi
  800d3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_yield>:

void
sys_yield(void)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d54:	89 d1                	mov    %edx,%ecx
  800d56:	89 d3                	mov    %edx,%ebx
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	89 d6                	mov    %edx,%esi
  800d5c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6c:	be 00 00 00 00       	mov    $0x0,%esi
  800d71:	b8 04 00 00 00       	mov    $0x4,%eax
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7f:	89 f7                	mov    %esi,%edi
  800d81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7e 28                	jle    800daf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d92:	00 
  800d93:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  800d9a:	00 
  800d9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da2:	00 
  800da3:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800daa:	e8 7c f4 ff ff       	call   80022b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800daf:	83 c4 2c             	add    $0x2c,%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc0:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dce:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd1:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7e 28                	jle    800e02 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dde:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800de5:	00 
  800de6:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  800ded:	00 
  800dee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df5:	00 
  800df6:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800dfd:	e8 29 f4 ff ff       	call   80022b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e02:	83 c4 2c             	add    $0x2c,%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e20:	8b 55 08             	mov    0x8(%ebp),%edx
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7e 28                	jle    800e55 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e31:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e38:	00 
  800e39:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  800e40:	00 
  800e41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e48:	00 
  800e49:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800e50:	e8 d6 f3 ff ff       	call   80022b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e55:	83 c4 2c             	add    $0x2c,%esp
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	89 df                	mov    %ebx,%edi
  800e78:	89 de                	mov    %ebx,%esi
  800e7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	7e 28                	jle    800ea8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e84:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e8b:	00 
  800e8c:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  800e93:	00 
  800e94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9b:	00 
  800e9c:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800ea3:	e8 83 f3 ff ff       	call   80022b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ea8:	83 c4 2c             	add    $0x2c,%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebe:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	89 df                	mov    %ebx,%edi
  800ecb:	89 de                	mov    %ebx,%esi
  800ecd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	7e 28                	jle    800efb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ede:	00 
  800edf:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  800ee6:	00 
  800ee7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eee:	00 
  800eef:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800ef6:	e8 30 f3 ff ff       	call   80022b <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800efb:	83 c4 2c             	add    $0x2c,%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f11:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	89 df                	mov    %ebx,%edi
  800f1e:	89 de                	mov    %ebx,%esi
  800f20:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7e 28                	jle    800f4e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f26:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f31:	00 
  800f32:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  800f39:	00 
  800f3a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f41:	00 
  800f42:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800f49:	e8 dd f2 ff ff       	call   80022b <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f4e:	83 c4 2c             	add    $0x2c,%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5c:	be 00 00 00 00       	mov    $0x0,%esi
  800f61:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f72:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	89 cb                	mov    %ecx,%ebx
  800f91:	89 cf                	mov    %ecx,%edi
  800f93:	89 ce                	mov    %ecx,%esi
  800f95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	7e 28                	jle    800fc3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fa6:	00 
  800fa7:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  800fae:	00 
  800faf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb6:	00 
  800fb7:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  800fbe:	e8 68 f2 ff ff       	call   80022b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc3:	83 c4 2c             	add    $0x2c,%esp
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fdb:	89 d1                	mov    %edx,%ecx
  800fdd:	89 d3                	mov    %edx,%ebx
  800fdf:	89 d7                	mov    %edx,%edi
  800fe1:	89 d6                	mov    %edx,%esi
  800fe3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
  800ff0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ffd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	89 df                	mov    %ebx,%edi
  801005:	89 de                	mov    %ebx,%esi
  801007:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801009:	85 c0                	test   %eax,%eax
  80100b:	7e 28                	jle    801035 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80100d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801011:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801018:	00 
  801019:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  801020:	00 
  801021:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801028:	00 
  801029:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  801030:	e8 f6 f1 ff ff       	call   80022b <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801035:	83 c4 2c             	add    $0x2c,%esp
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
  801043:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	b8 10 00 00 00       	mov    $0x10,%eax
  801050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	89 df                	mov    %ebx,%edi
  801058:	89 de                	mov    %ebx,%esi
  80105a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	7e 28                	jle    801088 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801060:	89 44 24 10          	mov    %eax,0x10(%esp)
  801064:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80106b:	00 
  80106c:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  801073:	00 
  801074:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80107b:	00 
  80107c:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  801083:	e8 a3 f1 ff ff       	call   80022b <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801088:	83 c4 2c             	add    $0x2c,%esp
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
  801096:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801099:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109e:	b8 11 00 00 00       	mov    $0x11,%eax
  8010a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	89 df                	mov    %ebx,%edi
  8010ab:	89 de                	mov    %ebx,%esi
  8010ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	7e 28                	jle    8010db <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8010be:	00 
  8010bf:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  8010c6:	00 
  8010c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ce:	00 
  8010cf:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  8010d6:	e8 50 f1 ff ff       	call   80022b <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8010db:	83 c4 2c             	add    $0x2c,%esp
  8010de:	5b                   	pop    %ebx
  8010df:	5e                   	pop    %esi
  8010e0:	5f                   	pop    %edi
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    

008010e3 <sys_sleep>:

int
sys_sleep(int channel)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	57                   	push   %edi
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f1:	b8 12 00 00 00       	mov    $0x12,%eax
  8010f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f9:	89 cb                	mov    %ecx,%ebx
  8010fb:	89 cf                	mov    %ecx,%edi
  8010fd:	89 ce                	mov    %ecx,%esi
  8010ff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801101:	85 c0                	test   %eax,%eax
  801103:	7e 28                	jle    80112d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801105:	89 44 24 10          	mov    %eax,0x10(%esp)
  801109:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801110:	00 
  801111:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  801118:	00 
  801119:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801120:	00 
  801121:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  801128:	e8 fe f0 ff ff       	call   80022b <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80112d:	83 c4 2c             	add    $0x2c,%esp
  801130:	5b                   	pop    %ebx
  801131:	5e                   	pop    %esi
  801132:	5f                   	pop    %edi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	57                   	push   %edi
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801143:	b8 13 00 00 00       	mov    $0x13,%eax
  801148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114b:	8b 55 08             	mov    0x8(%ebp),%edx
  80114e:	89 df                	mov    %ebx,%edi
  801150:	89 de                	mov    %ebx,%esi
  801152:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801154:	85 c0                	test   %eax,%eax
  801156:	7e 28                	jle    801180 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801158:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801163:	00 
  801164:	c7 44 24 08 2b 2d 80 	movl   $0x802d2b,0x8(%esp)
  80116b:	00 
  80116c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801173:	00 
  801174:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  80117b:	e8 ab f0 ff ff       	call   80022b <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801180:	83 c4 2c             	add    $0x2c,%esp
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    
  801188:	66 90                	xchg   %ax,%ax
  80118a:	66 90                	xchg   %ax,%ax
  80118c:	66 90                	xchg   %ax,%ax
  80118e:	66 90                	xchg   %ax,%ax

00801190 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	05 00 00 00 30       	add    $0x30000000,%eax
  80119b:	c1 e8 0c             	shr    $0xc,%eax
}
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8011ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    

008011b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011c2:	89 c2                	mov    %eax,%edx
  8011c4:	c1 ea 16             	shr    $0x16,%edx
  8011c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ce:	f6 c2 01             	test   $0x1,%dl
  8011d1:	74 11                	je     8011e4 <fd_alloc+0x2d>
  8011d3:	89 c2                	mov    %eax,%edx
  8011d5:	c1 ea 0c             	shr    $0xc,%edx
  8011d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011df:	f6 c2 01             	test   $0x1,%dl
  8011e2:	75 09                	jne    8011ed <fd_alloc+0x36>
			*fd_store = fd;
  8011e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011eb:	eb 17                	jmp    801204 <fd_alloc+0x4d>
  8011ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011f7:	75 c9                	jne    8011c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    

00801206 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80120c:	83 f8 1f             	cmp    $0x1f,%eax
  80120f:	77 36                	ja     801247 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801211:	c1 e0 0c             	shl    $0xc,%eax
  801214:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801219:	89 c2                	mov    %eax,%edx
  80121b:	c1 ea 16             	shr    $0x16,%edx
  80121e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801225:	f6 c2 01             	test   $0x1,%dl
  801228:	74 24                	je     80124e <fd_lookup+0x48>
  80122a:	89 c2                	mov    %eax,%edx
  80122c:	c1 ea 0c             	shr    $0xc,%edx
  80122f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801236:	f6 c2 01             	test   $0x1,%dl
  801239:	74 1a                	je     801255 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80123b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123e:	89 02                	mov    %eax,(%edx)
	return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 13                	jmp    80125a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801247:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124c:	eb 0c                	jmp    80125a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80124e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801253:	eb 05                	jmp    80125a <fd_lookup+0x54>
  801255:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	83 ec 18             	sub    $0x18,%esp
  801262:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801265:	ba 00 00 00 00       	mov    $0x0,%edx
  80126a:	eb 13                	jmp    80127f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80126c:	39 08                	cmp    %ecx,(%eax)
  80126e:	75 0c                	jne    80127c <dev_lookup+0x20>
			*dev = devtab[i];
  801270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801273:	89 01                	mov    %eax,(%ecx)
			return 0;
  801275:	b8 00 00 00 00       	mov    $0x0,%eax
  80127a:	eb 38                	jmp    8012b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80127c:	83 c2 01             	add    $0x1,%edx
  80127f:	8b 04 95 d4 2d 80 00 	mov    0x802dd4(,%edx,4),%eax
  801286:	85 c0                	test   %eax,%eax
  801288:	75 e2                	jne    80126c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80128a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80128f:	8b 40 48             	mov    0x48(%eax),%eax
  801292:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80129a:	c7 04 24 58 2d 80 00 	movl   $0x802d58,(%esp)
  8012a1:	e8 7e f0 ff ff       	call   800324 <cprintf>
	*dev = 0;
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 20             	sub    $0x20,%esp
  8012be:	8b 75 08             	mov    0x8(%ebp),%esi
  8012c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d4:	89 04 24             	mov    %eax,(%esp)
  8012d7:	e8 2a ff ff ff       	call   801206 <fd_lookup>
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	78 05                	js     8012e5 <fd_close+0x2f>
	    || fd != fd2)
  8012e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8012e3:	74 0c                	je     8012f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8012e5:	84 db                	test   %bl,%bl
  8012e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ec:	0f 44 c2             	cmove  %edx,%eax
  8012ef:	eb 3f                	jmp    801330 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f8:	8b 06                	mov    (%esi),%eax
  8012fa:	89 04 24             	mov    %eax,(%esp)
  8012fd:	e8 5a ff ff ff       	call   80125c <dev_lookup>
  801302:	89 c3                	mov    %eax,%ebx
  801304:	85 c0                	test   %eax,%eax
  801306:	78 16                	js     80131e <fd_close+0x68>
		if (dev->dev_close)
  801308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80130e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801313:	85 c0                	test   %eax,%eax
  801315:	74 07                	je     80131e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801317:	89 34 24             	mov    %esi,(%esp)
  80131a:	ff d0                	call   *%eax
  80131c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80131e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801322:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801329:	e8 dc fa ff ff       	call   800e0a <sys_page_unmap>
	return r;
  80132e:	89 d8                	mov    %ebx,%eax
}
  801330:	83 c4 20             	add    $0x20,%esp
  801333:	5b                   	pop    %ebx
  801334:	5e                   	pop    %esi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80133d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801340:	89 44 24 04          	mov    %eax,0x4(%esp)
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	89 04 24             	mov    %eax,(%esp)
  80134a:	e8 b7 fe ff ff       	call   801206 <fd_lookup>
  80134f:	89 c2                	mov    %eax,%edx
  801351:	85 d2                	test   %edx,%edx
  801353:	78 13                	js     801368 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801355:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80135c:	00 
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	89 04 24             	mov    %eax,(%esp)
  801363:	e8 4e ff ff ff       	call   8012b6 <fd_close>
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <close_all>:

void
close_all(void)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801371:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801376:	89 1c 24             	mov    %ebx,(%esp)
  801379:	e8 b9 ff ff ff       	call   801337 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80137e:	83 c3 01             	add    $0x1,%ebx
  801381:	83 fb 20             	cmp    $0x20,%ebx
  801384:	75 f0                	jne    801376 <close_all+0xc>
		close(i);
}
  801386:	83 c4 14             	add    $0x14,%esp
  801389:	5b                   	pop    %ebx
  80138a:	5d                   	pop    %ebp
  80138b:	c3                   	ret    

0080138c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	57                   	push   %edi
  801390:	56                   	push   %esi
  801391:	53                   	push   %ebx
  801392:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801395:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	89 04 24             	mov    %eax,(%esp)
  8013a2:	e8 5f fe ff ff       	call   801206 <fd_lookup>
  8013a7:	89 c2                	mov    %eax,%edx
  8013a9:	85 d2                	test   %edx,%edx
  8013ab:	0f 88 e1 00 00 00    	js     801492 <dup+0x106>
		return r;
	close(newfdnum);
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	89 04 24             	mov    %eax,(%esp)
  8013b7:	e8 7b ff ff ff       	call   801337 <close>

	newfd = INDEX2FD(newfdnum);
  8013bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8013bf:	c1 e3 0c             	shl    $0xc,%ebx
  8013c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8013c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013cb:	89 04 24             	mov    %eax,(%esp)
  8013ce:	e8 cd fd ff ff       	call   8011a0 <fd2data>
  8013d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8013d5:	89 1c 24             	mov    %ebx,(%esp)
  8013d8:	e8 c3 fd ff ff       	call   8011a0 <fd2data>
  8013dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013df:	89 f0                	mov    %esi,%eax
  8013e1:	c1 e8 16             	shr    $0x16,%eax
  8013e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013eb:	a8 01                	test   $0x1,%al
  8013ed:	74 43                	je     801432 <dup+0xa6>
  8013ef:	89 f0                	mov    %esi,%eax
  8013f1:	c1 e8 0c             	shr    $0xc,%eax
  8013f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013fb:	f6 c2 01             	test   $0x1,%dl
  8013fe:	74 32                	je     801432 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801400:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801407:	25 07 0e 00 00       	and    $0xe07,%eax
  80140c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801410:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801414:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80141b:	00 
  80141c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801420:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801427:	e8 8b f9 ff ff       	call   800db7 <sys_page_map>
  80142c:	89 c6                	mov    %eax,%esi
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 3e                	js     801470 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801432:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801435:	89 c2                	mov    %eax,%edx
  801437:	c1 ea 0c             	shr    $0xc,%edx
  80143a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801441:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801447:	89 54 24 10          	mov    %edx,0x10(%esp)
  80144b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80144f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801456:	00 
  801457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801462:	e8 50 f9 ff ff       	call   800db7 <sys_page_map>
  801467:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80146c:	85 f6                	test   %esi,%esi
  80146e:	79 22                	jns    801492 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801470:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80147b:	e8 8a f9 ff ff       	call   800e0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801480:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801484:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80148b:	e8 7a f9 ff ff       	call   800e0a <sys_page_unmap>
	return r;
  801490:	89 f0                	mov    %esi,%eax
}
  801492:	83 c4 3c             	add    $0x3c,%esp
  801495:	5b                   	pop    %ebx
  801496:	5e                   	pop    %esi
  801497:	5f                   	pop    %edi
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    

0080149a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	53                   	push   %ebx
  80149e:	83 ec 24             	sub    $0x24,%esp
  8014a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ab:	89 1c 24             	mov    %ebx,(%esp)
  8014ae:	e8 53 fd ff ff       	call   801206 <fd_lookup>
  8014b3:	89 c2                	mov    %eax,%edx
  8014b5:	85 d2                	test   %edx,%edx
  8014b7:	78 6d                	js     801526 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	89 04 24             	mov    %eax,(%esp)
  8014c8:	e8 8f fd ff ff       	call   80125c <dev_lookup>
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 55                	js     801526 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d4:	8b 50 08             	mov    0x8(%eax),%edx
  8014d7:	83 e2 03             	and    $0x3,%edx
  8014da:	83 fa 01             	cmp    $0x1,%edx
  8014dd:	75 23                	jne    801502 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014df:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014e4:	8b 40 48             	mov    0x48(%eax),%eax
  8014e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ef:	c7 04 24 99 2d 80 00 	movl   $0x802d99,(%esp)
  8014f6:	e8 29 ee ff ff       	call   800324 <cprintf>
		return -E_INVAL;
  8014fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801500:	eb 24                	jmp    801526 <read+0x8c>
	}
	if (!dev->dev_read)
  801502:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801505:	8b 52 08             	mov    0x8(%edx),%edx
  801508:	85 d2                	test   %edx,%edx
  80150a:	74 15                	je     801521 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80150c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80150f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801513:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801516:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80151a:	89 04 24             	mov    %eax,(%esp)
  80151d:	ff d2                	call   *%edx
  80151f:	eb 05                	jmp    801526 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801521:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801526:	83 c4 24             	add    $0x24,%esp
  801529:	5b                   	pop    %ebx
  80152a:	5d                   	pop    %ebp
  80152b:	c3                   	ret    

0080152c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	57                   	push   %edi
  801530:	56                   	push   %esi
  801531:	53                   	push   %ebx
  801532:	83 ec 1c             	sub    $0x1c,%esp
  801535:	8b 7d 08             	mov    0x8(%ebp),%edi
  801538:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80153b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801540:	eb 23                	jmp    801565 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801542:	89 f0                	mov    %esi,%eax
  801544:	29 d8                	sub    %ebx,%eax
  801546:	89 44 24 08          	mov    %eax,0x8(%esp)
  80154a:	89 d8                	mov    %ebx,%eax
  80154c:	03 45 0c             	add    0xc(%ebp),%eax
  80154f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801553:	89 3c 24             	mov    %edi,(%esp)
  801556:	e8 3f ff ff ff       	call   80149a <read>
		if (m < 0)
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 10                	js     80156f <readn+0x43>
			return m;
		if (m == 0)
  80155f:	85 c0                	test   %eax,%eax
  801561:	74 0a                	je     80156d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801563:	01 c3                	add    %eax,%ebx
  801565:	39 f3                	cmp    %esi,%ebx
  801567:	72 d9                	jb     801542 <readn+0x16>
  801569:	89 d8                	mov    %ebx,%eax
  80156b:	eb 02                	jmp    80156f <readn+0x43>
  80156d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80156f:	83 c4 1c             	add    $0x1c,%esp
  801572:	5b                   	pop    %ebx
  801573:	5e                   	pop    %esi
  801574:	5f                   	pop    %edi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	53                   	push   %ebx
  80157b:	83 ec 24             	sub    $0x24,%esp
  80157e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801581:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801584:	89 44 24 04          	mov    %eax,0x4(%esp)
  801588:	89 1c 24             	mov    %ebx,(%esp)
  80158b:	e8 76 fc ff ff       	call   801206 <fd_lookup>
  801590:	89 c2                	mov    %eax,%edx
  801592:	85 d2                	test   %edx,%edx
  801594:	78 68                	js     8015fe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801596:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a0:	8b 00                	mov    (%eax),%eax
  8015a2:	89 04 24             	mov    %eax,(%esp)
  8015a5:	e8 b2 fc ff ff       	call   80125c <dev_lookup>
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	78 50                	js     8015fe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b5:	75 23                	jne    8015da <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b7:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015bc:	8b 40 48             	mov    0x48(%eax),%eax
  8015bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c7:	c7 04 24 b5 2d 80 00 	movl   $0x802db5,(%esp)
  8015ce:	e8 51 ed ff ff       	call   800324 <cprintf>
		return -E_INVAL;
  8015d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d8:	eb 24                	jmp    8015fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8015e0:	85 d2                	test   %edx,%edx
  8015e2:	74 15                	je     8015f9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015f2:	89 04 24             	mov    %eax,(%esp)
  8015f5:	ff d2                	call   *%edx
  8015f7:	eb 05                	jmp    8015fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015fe:	83 c4 24             	add    $0x24,%esp
  801601:	5b                   	pop    %ebx
  801602:	5d                   	pop    %ebp
  801603:	c3                   	ret    

00801604 <seek>:

int
seek(int fdnum, off_t offset)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80160a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80160d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	89 04 24             	mov    %eax,(%esp)
  801617:	e8 ea fb ff ff       	call   801206 <fd_lookup>
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 0e                	js     80162e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801620:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	53                   	push   %ebx
  801634:	83 ec 24             	sub    $0x24,%esp
  801637:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80163d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801641:	89 1c 24             	mov    %ebx,(%esp)
  801644:	e8 bd fb ff ff       	call   801206 <fd_lookup>
  801649:	89 c2                	mov    %eax,%edx
  80164b:	85 d2                	test   %edx,%edx
  80164d:	78 61                	js     8016b0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801652:	89 44 24 04          	mov    %eax,0x4(%esp)
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801659:	8b 00                	mov    (%eax),%eax
  80165b:	89 04 24             	mov    %eax,(%esp)
  80165e:	e8 f9 fb ff ff       	call   80125c <dev_lookup>
  801663:	85 c0                	test   %eax,%eax
  801665:	78 49                	js     8016b0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80166e:	75 23                	jne    801693 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801670:	a1 0c 40 80 00       	mov    0x80400c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801675:	8b 40 48             	mov    0x48(%eax),%eax
  801678:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80167c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801680:	c7 04 24 78 2d 80 00 	movl   $0x802d78,(%esp)
  801687:	e8 98 ec ff ff       	call   800324 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80168c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801691:	eb 1d                	jmp    8016b0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801696:	8b 52 18             	mov    0x18(%edx),%edx
  801699:	85 d2                	test   %edx,%edx
  80169b:	74 0e                	je     8016ab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80169d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016a4:	89 04 24             	mov    %eax,(%esp)
  8016a7:	ff d2                	call   *%edx
  8016a9:	eb 05                	jmp    8016b0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8016ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8016b0:	83 c4 24             	add    $0x24,%esp
  8016b3:	5b                   	pop    %ebx
  8016b4:	5d                   	pop    %ebp
  8016b5:	c3                   	ret    

008016b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 24             	sub    $0x24,%esp
  8016bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 04 24             	mov    %eax,(%esp)
  8016cd:	e8 34 fb ff ff       	call   801206 <fd_lookup>
  8016d2:	89 c2                	mov    %eax,%edx
  8016d4:	85 d2                	test   %edx,%edx
  8016d6:	78 52                	js     80172a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	8b 00                	mov    (%eax),%eax
  8016e4:	89 04 24             	mov    %eax,(%esp)
  8016e7:	e8 70 fb ff ff       	call   80125c <dev_lookup>
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 3a                	js     80172a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8016f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016f7:	74 2c                	je     801725 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801703:	00 00 00 
	stat->st_isdir = 0;
  801706:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80170d:	00 00 00 
	stat->st_dev = dev;
  801710:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801716:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80171a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171d:	89 14 24             	mov    %edx,(%esp)
  801720:	ff 50 14             	call   *0x14(%eax)
  801723:	eb 05                	jmp    80172a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801725:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80172a:	83 c4 24             	add    $0x24,%esp
  80172d:	5b                   	pop    %ebx
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	56                   	push   %esi
  801734:	53                   	push   %ebx
  801735:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801738:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80173f:	00 
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	89 04 24             	mov    %eax,(%esp)
  801746:	e8 1b 02 00 00       	call   801966 <open>
  80174b:	89 c3                	mov    %eax,%ebx
  80174d:	85 db                	test   %ebx,%ebx
  80174f:	78 1b                	js     80176c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801751:	8b 45 0c             	mov    0xc(%ebp),%eax
  801754:	89 44 24 04          	mov    %eax,0x4(%esp)
  801758:	89 1c 24             	mov    %ebx,(%esp)
  80175b:	e8 56 ff ff ff       	call   8016b6 <fstat>
  801760:	89 c6                	mov    %eax,%esi
	close(fd);
  801762:	89 1c 24             	mov    %ebx,(%esp)
  801765:	e8 cd fb ff ff       	call   801337 <close>
	return r;
  80176a:	89 f0                	mov    %esi,%eax
}
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	5b                   	pop    %ebx
  801770:	5e                   	pop    %esi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    

00801773 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	56                   	push   %esi
  801777:	53                   	push   %ebx
  801778:	83 ec 10             	sub    $0x10,%esp
  80177b:	89 c6                	mov    %eax,%esi
  80177d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80177f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801786:	75 11                	jne    801799 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801788:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80178f:	e8 ab 0e 00 00       	call   80263f <ipc_find_env>
  801794:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801799:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8017a0:	00 
  8017a1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8017a8:	00 
  8017a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017ad:	a1 04 40 80 00       	mov    0x804004,%eax
  8017b2:	89 04 24             	mov    %eax,(%esp)
  8017b5:	e8 1a 0e 00 00       	call   8025d4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017c1:	00 
  8017c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017cd:	e8 ae 0d 00 00       	call   802580 <ipc_recv>
}
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5e                   	pop    %esi
  8017d7:	5d                   	pop    %ebp
  8017d8:	c3                   	ret    

008017d9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ed:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017fc:	e8 72 ff ff ff       	call   801773 <fsipc>
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	8b 40 0c             	mov    0xc(%eax),%eax
  80180f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801814:	ba 00 00 00 00       	mov    $0x0,%edx
  801819:	b8 06 00 00 00       	mov    $0x6,%eax
  80181e:	e8 50 ff ff ff       	call   801773 <fsipc>
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	53                   	push   %ebx
  801829:	83 ec 14             	sub    $0x14,%esp
  80182c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8b 40 0c             	mov    0xc(%eax),%eax
  801835:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80183a:	ba 00 00 00 00       	mov    $0x0,%edx
  80183f:	b8 05 00 00 00       	mov    $0x5,%eax
  801844:	e8 2a ff ff ff       	call   801773 <fsipc>
  801849:	89 c2                	mov    %eax,%edx
  80184b:	85 d2                	test   %edx,%edx
  80184d:	78 2b                	js     80187a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80184f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801856:	00 
  801857:	89 1c 24             	mov    %ebx,(%esp)
  80185a:	e8 e8 f0 ff ff       	call   800947 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80185f:	a1 80 50 80 00       	mov    0x805080,%eax
  801864:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80186a:	a1 84 50 80 00       	mov    0x805084,%eax
  80186f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187a:	83 c4 14             	add    $0x14,%esp
  80187d:	5b                   	pop    %ebx
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    

00801880 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 18             	sub    $0x18,%esp
  801886:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801889:	8b 55 08             	mov    0x8(%ebp),%edx
  80188c:	8b 52 0c             	mov    0xc(%edx),%edx
  80188f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801895:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80189a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80189e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8018ac:	e8 9b f2 ff ff       	call   800b4c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  8018b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b6:	b8 04 00 00 00       	mov    $0x4,%eax
  8018bb:	e8 b3 fe ff ff       	call   801773 <fsipc>
		return r;
	}

	return r;
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	56                   	push   %esi
  8018c6:	53                   	push   %ebx
  8018c7:	83 ec 10             	sub    $0x10,%esp
  8018ca:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018d8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018de:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8018e8:	e8 86 fe ff ff       	call   801773 <fsipc>
  8018ed:	89 c3                	mov    %eax,%ebx
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	78 6a                	js     80195d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018f3:	39 c6                	cmp    %eax,%esi
  8018f5:	73 24                	jae    80191b <devfile_read+0x59>
  8018f7:	c7 44 24 0c e8 2d 80 	movl   $0x802de8,0xc(%esp)
  8018fe:	00 
  8018ff:	c7 44 24 08 ef 2d 80 	movl   $0x802def,0x8(%esp)
  801906:	00 
  801907:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80190e:	00 
  80190f:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  801916:	e8 10 e9 ff ff       	call   80022b <_panic>
	assert(r <= PGSIZE);
  80191b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801920:	7e 24                	jle    801946 <devfile_read+0x84>
  801922:	c7 44 24 0c 0f 2e 80 	movl   $0x802e0f,0xc(%esp)
  801929:	00 
  80192a:	c7 44 24 08 ef 2d 80 	movl   $0x802def,0x8(%esp)
  801931:	00 
  801932:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801939:	00 
  80193a:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  801941:	e8 e5 e8 ff ff       	call   80022b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801946:	89 44 24 08          	mov    %eax,0x8(%esp)
  80194a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801951:	00 
  801952:	8b 45 0c             	mov    0xc(%ebp),%eax
  801955:	89 04 24             	mov    %eax,(%esp)
  801958:	e8 87 f1 ff ff       	call   800ae4 <memmove>
	return r;
}
  80195d:	89 d8                	mov    %ebx,%eax
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	5b                   	pop    %ebx
  801963:	5e                   	pop    %esi
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	53                   	push   %ebx
  80196a:	83 ec 24             	sub    $0x24,%esp
  80196d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801970:	89 1c 24             	mov    %ebx,(%esp)
  801973:	e8 98 ef ff ff       	call   800910 <strlen>
  801978:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80197d:	7f 60                	jg     8019df <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80197f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801982:	89 04 24             	mov    %eax,(%esp)
  801985:	e8 2d f8 ff ff       	call   8011b7 <fd_alloc>
  80198a:	89 c2                	mov    %eax,%edx
  80198c:	85 d2                	test   %edx,%edx
  80198e:	78 54                	js     8019e4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801990:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801994:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80199b:	e8 a7 ef ff ff       	call   800947 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b0:	e8 be fd ff ff       	call   801773 <fsipc>
  8019b5:	89 c3                	mov    %eax,%ebx
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	79 17                	jns    8019d2 <open+0x6c>
		fd_close(fd, 0);
  8019bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019c2:	00 
  8019c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c6:	89 04 24             	mov    %eax,(%esp)
  8019c9:	e8 e8 f8 ff ff       	call   8012b6 <fd_close>
		return r;
  8019ce:	89 d8                	mov    %ebx,%eax
  8019d0:	eb 12                	jmp    8019e4 <open+0x7e>
	}

	return fd2num(fd);
  8019d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d5:	89 04 24             	mov    %eax,(%esp)
  8019d8:	e8 b3 f7 ff ff       	call   801190 <fd2num>
  8019dd:	eb 05                	jmp    8019e4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019df:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019e4:	83 c4 24             	add    $0x24,%esp
  8019e7:	5b                   	pop    %ebx
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    

008019ea <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019fa:	e8 74 fd ff ff       	call   801773 <fsipc>
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	53                   	push   %ebx
  801a05:	83 ec 14             	sub    $0x14,%esp
  801a08:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801a0a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a0e:	7e 31                	jle    801a41 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a10:	8b 40 04             	mov    0x4(%eax),%eax
  801a13:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a17:	8d 43 10             	lea    0x10(%ebx),%eax
  801a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1e:	8b 03                	mov    (%ebx),%eax
  801a20:	89 04 24             	mov    %eax,(%esp)
  801a23:	e8 4f fb ff ff       	call   801577 <write>
		if (result > 0)
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	7e 03                	jle    801a2f <writebuf+0x2e>
			b->result += result;
  801a2c:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a2f:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a32:	74 0d                	je     801a41 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801a34:	85 c0                	test   %eax,%eax
  801a36:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3b:	0f 4f c2             	cmovg  %edx,%eax
  801a3e:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a41:	83 c4 14             	add    $0x14,%esp
  801a44:	5b                   	pop    %ebx
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <putch>:

static void
putch(int ch, void *thunk)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	53                   	push   %ebx
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a51:	8b 53 04             	mov    0x4(%ebx),%edx
  801a54:	8d 42 01             	lea    0x1(%edx),%eax
  801a57:	89 43 04             	mov    %eax,0x4(%ebx)
  801a5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a5d:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a61:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a66:	75 0e                	jne    801a76 <putch+0x2f>
		writebuf(b);
  801a68:	89 d8                	mov    %ebx,%eax
  801a6a:	e8 92 ff ff ff       	call   801a01 <writebuf>
		b->idx = 0;
  801a6f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801a76:	83 c4 04             	add    $0x4,%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    

00801a7c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a8e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a95:	00 00 00 
	b.result = 0;
  801a98:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a9f:	00 00 00 
	b.error = 1;
  801aa2:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801aa9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801aac:	8b 45 10             	mov    0x10(%ebp),%eax
  801aaf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aba:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac4:	c7 04 24 47 1a 80 00 	movl   $0x801a47,(%esp)
  801acb:	e8 de e9 ff ff       	call   8004ae <vprintfmt>
	if (b.idx > 0)
  801ad0:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801ad7:	7e 0b                	jle    801ae4 <vfprintf+0x68>
		writebuf(&b);
  801ad9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801adf:	e8 1d ff ff ff       	call   801a01 <writebuf>

	return (b.result ? b.result : b.error);
  801ae4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801aea:	85 c0                	test   %eax,%eax
  801aec:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801afb:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801afe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	89 04 24             	mov    %eax,(%esp)
  801b0f:	e8 68 ff ff ff       	call   801a7c <vfprintf>
	va_end(ap);

	return cnt;
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <printf>:

int
printf(const char *fmt, ...)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b1c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b31:	e8 46 ff ff ff       	call   801a7c <vfprintf>
	va_end(ap);

	return cnt;
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    
  801b38:	66 90                	xchg   %ax,%ax
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	66 90                	xchg   %ax,%ax
  801b3e:	66 90                	xchg   %ax,%ax

00801b40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801b46:	c7 44 24 04 1b 2e 80 	movl   $0x802e1b,0x4(%esp)
  801b4d:	00 
  801b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b51:	89 04 24             	mov    %eax,(%esp)
  801b54:	e8 ee ed ff ff       	call   800947 <strcpy>
	return 0;
}
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	53                   	push   %ebx
  801b64:	83 ec 14             	sub    $0x14,%esp
  801b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b6a:	89 1c 24             	mov    %ebx,(%esp)
  801b6d:	e8 0c 0b 00 00       	call   80267e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b72:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b77:	83 f8 01             	cmp    $0x1,%eax
  801b7a:	75 0d                	jne    801b89 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b7c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b7f:	89 04 24             	mov    %eax,(%esp)
  801b82:	e8 29 03 00 00       	call   801eb0 <nsipc_close>
  801b87:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b89:	89 d0                	mov    %edx,%eax
  801b8b:	83 c4 14             	add    $0x14,%esp
  801b8e:	5b                   	pop    %ebx
  801b8f:	5d                   	pop    %ebp
  801b90:	c3                   	ret    

00801b91 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b97:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b9e:	00 
  801b9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb3:	89 04 24             	mov    %eax,(%esp)
  801bb6:	e8 f0 03 00 00       	call   801fab <nsipc_send>
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bc3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801bca:	00 
  801bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bce:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bdf:	89 04 24             	mov    %eax,(%esp)
  801be2:	e8 44 03 00 00       	call   801f2b <nsipc_recv>
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bef:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bf2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bf6:	89 04 24             	mov    %eax,(%esp)
  801bf9:	e8 08 f6 ff ff       	call   801206 <fd_lookup>
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 17                	js     801c19 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c05:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801c0b:	39 08                	cmp    %ecx,(%eax)
  801c0d:	75 05                	jne    801c14 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c12:	eb 05                	jmp    801c19 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801c14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 20             	sub    $0x20,%esp
  801c23:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c28:	89 04 24             	mov    %eax,(%esp)
  801c2b:	e8 87 f5 ff ff       	call   8011b7 <fd_alloc>
  801c30:	89 c3                	mov    %eax,%ebx
  801c32:	85 c0                	test   %eax,%eax
  801c34:	78 21                	js     801c57 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c36:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c3d:	00 
  801c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c4c:	e8 12 f1 ff ff       	call   800d63 <sys_page_alloc>
  801c51:	89 c3                	mov    %eax,%ebx
  801c53:	85 c0                	test   %eax,%eax
  801c55:	79 0c                	jns    801c63 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801c57:	89 34 24             	mov    %esi,(%esp)
  801c5a:	e8 51 02 00 00       	call   801eb0 <nsipc_close>
		return r;
  801c5f:	89 d8                	mov    %ebx,%eax
  801c61:	eb 20                	jmp    801c83 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c63:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c71:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c78:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c7b:	89 14 24             	mov    %edx,(%esp)
  801c7e:	e8 0d f5 ff ff       	call   801190 <fd2num>
}
  801c83:	83 c4 20             	add    $0x20,%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    

00801c8a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	e8 51 ff ff ff       	call   801be9 <fd2sockid>
		return r;
  801c98:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	78 23                	js     801cc1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c9e:	8b 55 10             	mov    0x10(%ebp),%edx
  801ca1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cac:	89 04 24             	mov    %eax,(%esp)
  801caf:	e8 45 01 00 00       	call   801df9 <nsipc_accept>
		return r;
  801cb4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	78 07                	js     801cc1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801cba:	e8 5c ff ff ff       	call   801c1b <alloc_sockfd>
  801cbf:	89 c1                	mov    %eax,%ecx
}
  801cc1:	89 c8                	mov    %ecx,%eax
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	e8 16 ff ff ff       	call   801be9 <fd2sockid>
  801cd3:	89 c2                	mov    %eax,%edx
  801cd5:	85 d2                	test   %edx,%edx
  801cd7:	78 16                	js     801cef <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce7:	89 14 24             	mov    %edx,(%esp)
  801cea:	e8 60 01 00 00       	call   801e4f <nsipc_bind>
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <shutdown>:

int
shutdown(int s, int how)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	e8 ea fe ff ff       	call   801be9 <fd2sockid>
  801cff:	89 c2                	mov    %eax,%edx
  801d01:	85 d2                	test   %edx,%edx
  801d03:	78 0f                	js     801d14 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0c:	89 14 24             	mov    %edx,(%esp)
  801d0f:	e8 7a 01 00 00       	call   801e8e <nsipc_shutdown>
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	e8 c5 fe ff ff       	call   801be9 <fd2sockid>
  801d24:	89 c2                	mov    %eax,%edx
  801d26:	85 d2                	test   %edx,%edx
  801d28:	78 16                	js     801d40 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d38:	89 14 24             	mov    %edx,(%esp)
  801d3b:	e8 8a 01 00 00       	call   801eca <nsipc_connect>
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <listen>:

int
listen(int s, int backlog)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	e8 99 fe ff ff       	call   801be9 <fd2sockid>
  801d50:	89 c2                	mov    %eax,%edx
  801d52:	85 d2                	test   %edx,%edx
  801d54:	78 0f                	js     801d65 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5d:	89 14 24             	mov    %edx,(%esp)
  801d60:	e8 a4 01 00 00       	call   801f09 <nsipc_listen>
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d70:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	89 04 24             	mov    %eax,(%esp)
  801d81:	e8 98 02 00 00       	call   80201e <nsipc_socket>
  801d86:	89 c2                	mov    %eax,%edx
  801d88:	85 d2                	test   %edx,%edx
  801d8a:	78 05                	js     801d91 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d8c:	e8 8a fe ff ff       	call   801c1b <alloc_sockfd>
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	53                   	push   %ebx
  801d97:	83 ec 14             	sub    $0x14,%esp
  801d9a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d9c:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801da3:	75 11                	jne    801db6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801da5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801dac:	e8 8e 08 00 00       	call   80263f <ipc_find_env>
  801db1:	a3 08 40 80 00       	mov    %eax,0x804008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801db6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801dbd:	00 
  801dbe:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801dc5:	00 
  801dc6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dca:	a1 08 40 80 00       	mov    0x804008,%eax
  801dcf:	89 04 24             	mov    %eax,(%esp)
  801dd2:	e8 fd 07 00 00       	call   8025d4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dd7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dde:	00 
  801ddf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801de6:	00 
  801de7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dee:	e8 8d 07 00 00       	call   802580 <ipc_recv>
}
  801df3:	83 c4 14             	add    $0x14,%esp
  801df6:	5b                   	pop    %ebx
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    

00801df9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
  801dfe:	83 ec 10             	sub    $0x10,%esp
  801e01:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e0c:	8b 06                	mov    (%esi),%eax
  801e0e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e13:	b8 01 00 00 00       	mov    $0x1,%eax
  801e18:	e8 76 ff ff ff       	call   801d93 <nsipc>
  801e1d:	89 c3                	mov    %eax,%ebx
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 23                	js     801e46 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e23:	a1 10 60 80 00       	mov    0x806010,%eax
  801e28:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e2c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e33:	00 
  801e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e37:	89 04 24             	mov    %eax,(%esp)
  801e3a:	e8 a5 ec ff ff       	call   800ae4 <memmove>
		*addrlen = ret->ret_addrlen;
  801e3f:	a1 10 60 80 00       	mov    0x806010,%eax
  801e44:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801e46:	89 d8                	mov    %ebx,%eax
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	5b                   	pop    %ebx
  801e4c:	5e                   	pop    %esi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    

00801e4f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	53                   	push   %ebx
  801e53:	83 ec 14             	sub    $0x14,%esp
  801e56:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e61:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e73:	e8 6c ec ff ff       	call   800ae4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e78:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e7e:	b8 02 00 00 00       	mov    $0x2,%eax
  801e83:	e8 0b ff ff ff       	call   801d93 <nsipc>
}
  801e88:	83 c4 14             	add    $0x14,%esp
  801e8b:	5b                   	pop    %ebx
  801e8c:	5d                   	pop    %ebp
  801e8d:	c3                   	ret    

00801e8e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ea4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ea9:	e8 e5 fe ff ff       	call   801d93 <nsipc>
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <nsipc_close>:

int
nsipc_close(int s)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ebe:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec3:	e8 cb fe ff ff       	call   801d93 <nsipc>
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	53                   	push   %ebx
  801ece:	83 ec 14             	sub    $0x14,%esp
  801ed1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801edc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801eee:	e8 f1 eb ff ff       	call   800ae4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ef3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ef9:	b8 05 00 00 00       	mov    $0x5,%eax
  801efe:	e8 90 fe ff ff       	call   801d93 <nsipc>
}
  801f03:	83 c4 14             	add    $0x14,%esp
  801f06:	5b                   	pop    %ebx
  801f07:	5d                   	pop    %ebp
  801f08:	c3                   	ret    

00801f09 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f1f:	b8 06 00 00 00       	mov    $0x6,%eax
  801f24:	e8 6a fe ff ff       	call   801d93 <nsipc>
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	56                   	push   %esi
  801f2f:	53                   	push   %ebx
  801f30:	83 ec 10             	sub    $0x10,%esp
  801f33:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f3e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f44:	8b 45 14             	mov    0x14(%ebp),%eax
  801f47:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f4c:	b8 07 00 00 00       	mov    $0x7,%eax
  801f51:	e8 3d fe ff ff       	call   801d93 <nsipc>
  801f56:	89 c3                	mov    %eax,%ebx
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 46                	js     801fa2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801f5c:	39 f0                	cmp    %esi,%eax
  801f5e:	7f 07                	jg     801f67 <nsipc_recv+0x3c>
  801f60:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f65:	7e 24                	jle    801f8b <nsipc_recv+0x60>
  801f67:	c7 44 24 0c 27 2e 80 	movl   $0x802e27,0xc(%esp)
  801f6e:	00 
  801f6f:	c7 44 24 08 ef 2d 80 	movl   $0x802def,0x8(%esp)
  801f76:	00 
  801f77:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f7e:	00 
  801f7f:	c7 04 24 3c 2e 80 00 	movl   $0x802e3c,(%esp)
  801f86:	e8 a0 e2 ff ff       	call   80022b <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f8f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f96:	00 
  801f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9a:	89 04 24             	mov    %eax,(%esp)
  801f9d:	e8 42 eb ff ff       	call   800ae4 <memmove>
	}

	return r;
}
  801fa2:	89 d8                	mov    %ebx,%eax
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5d                   	pop    %ebp
  801faa:	c3                   	ret    

00801fab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	53                   	push   %ebx
  801faf:	83 ec 14             	sub    $0x14,%esp
  801fb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fbd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fc3:	7e 24                	jle    801fe9 <nsipc_send+0x3e>
  801fc5:	c7 44 24 0c 48 2e 80 	movl   $0x802e48,0xc(%esp)
  801fcc:	00 
  801fcd:	c7 44 24 08 ef 2d 80 	movl   $0x802def,0x8(%esp)
  801fd4:	00 
  801fd5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801fdc:	00 
  801fdd:	c7 04 24 3c 2e 80 00 	movl   $0x802e3c,(%esp)
  801fe4:	e8 42 e2 ff ff       	call   80022b <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fe9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801ffb:	e8 e4 ea ff ff       	call   800ae4 <memmove>
	nsipcbuf.send.req_size = size;
  802000:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802006:	8b 45 14             	mov    0x14(%ebp),%eax
  802009:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80200e:	b8 08 00 00 00       	mov    $0x8,%eax
  802013:	e8 7b fd ff ff       	call   801d93 <nsipc>
}
  802018:	83 c4 14             	add    $0x14,%esp
  80201b:	5b                   	pop    %ebx
  80201c:	5d                   	pop    %ebp
  80201d:	c3                   	ret    

0080201e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80202c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802034:	8b 45 10             	mov    0x10(%ebp),%eax
  802037:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80203c:	b8 09 00 00 00       	mov    $0x9,%eax
  802041:	e8 4d fd ff ff       	call   801d93 <nsipc>
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	56                   	push   %esi
  80204c:	53                   	push   %ebx
  80204d:	83 ec 10             	sub    $0x10,%esp
  802050:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	89 04 24             	mov    %eax,(%esp)
  802059:	e8 42 f1 ff ff       	call   8011a0 <fd2data>
  80205e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802060:	c7 44 24 04 54 2e 80 	movl   $0x802e54,0x4(%esp)
  802067:	00 
  802068:	89 1c 24             	mov    %ebx,(%esp)
  80206b:	e8 d7 e8 ff ff       	call   800947 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802070:	8b 46 04             	mov    0x4(%esi),%eax
  802073:	2b 06                	sub    (%esi),%eax
  802075:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80207b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802082:	00 00 00 
	stat->st_dev = &devpipe;
  802085:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  80208c:	30 80 00 
	return 0;
}
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    

0080209b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	53                   	push   %ebx
  80209f:	83 ec 14             	sub    $0x14,%esp
  8020a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b0:	e8 55 ed ff ff       	call   800e0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020b5:	89 1c 24             	mov    %ebx,(%esp)
  8020b8:	e8 e3 f0 ff ff       	call   8011a0 <fd2data>
  8020bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c8:	e8 3d ed ff ff       	call   800e0a <sys_page_unmap>
}
  8020cd:	83 c4 14             	add    $0x14,%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5d                   	pop    %ebp
  8020d2:	c3                   	ret    

008020d3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	57                   	push   %edi
  8020d7:	56                   	push   %esi
  8020d8:	53                   	push   %ebx
  8020d9:	83 ec 2c             	sub    $0x2c,%esp
  8020dc:	89 c6                	mov    %eax,%esi
  8020de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020e1:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8020e6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020e9:	89 34 24             	mov    %esi,(%esp)
  8020ec:	e8 8d 05 00 00       	call   80267e <pageref>
  8020f1:	89 c7                	mov    %eax,%edi
  8020f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f6:	89 04 24             	mov    %eax,(%esp)
  8020f9:	e8 80 05 00 00       	call   80267e <pageref>
  8020fe:	39 c7                	cmp    %eax,%edi
  802100:	0f 94 c2             	sete   %dl
  802103:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802106:	8b 0d 0c 40 80 00    	mov    0x80400c,%ecx
  80210c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80210f:	39 fb                	cmp    %edi,%ebx
  802111:	74 21                	je     802134 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802113:	84 d2                	test   %dl,%dl
  802115:	74 ca                	je     8020e1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802117:	8b 51 58             	mov    0x58(%ecx),%edx
  80211a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80211e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802122:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802126:	c7 04 24 5b 2e 80 00 	movl   $0x802e5b,(%esp)
  80212d:	e8 f2 e1 ff ff       	call   800324 <cprintf>
  802132:	eb ad                	jmp    8020e1 <_pipeisclosed+0xe>
	}
}
  802134:	83 c4 2c             	add    $0x2c,%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	57                   	push   %edi
  802140:	56                   	push   %esi
  802141:	53                   	push   %ebx
  802142:	83 ec 1c             	sub    $0x1c,%esp
  802145:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802148:	89 34 24             	mov    %esi,(%esp)
  80214b:	e8 50 f0 ff ff       	call   8011a0 <fd2data>
  802150:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802152:	bf 00 00 00 00       	mov    $0x0,%edi
  802157:	eb 45                	jmp    80219e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802159:	89 da                	mov    %ebx,%edx
  80215b:	89 f0                	mov    %esi,%eax
  80215d:	e8 71 ff ff ff       	call   8020d3 <_pipeisclosed>
  802162:	85 c0                	test   %eax,%eax
  802164:	75 41                	jne    8021a7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802166:	e8 d9 eb ff ff       	call   800d44 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80216b:	8b 43 04             	mov    0x4(%ebx),%eax
  80216e:	8b 0b                	mov    (%ebx),%ecx
  802170:	8d 51 20             	lea    0x20(%ecx),%edx
  802173:	39 d0                	cmp    %edx,%eax
  802175:	73 e2                	jae    802159 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80217a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80217e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802181:	99                   	cltd   
  802182:	c1 ea 1b             	shr    $0x1b,%edx
  802185:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802188:	83 e1 1f             	and    $0x1f,%ecx
  80218b:	29 d1                	sub    %edx,%ecx
  80218d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802191:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802195:	83 c0 01             	add    $0x1,%eax
  802198:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80219b:	83 c7 01             	add    $0x1,%edi
  80219e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021a1:	75 c8                	jne    80216b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8021a3:	89 f8                	mov    %edi,%eax
  8021a5:	eb 05                	jmp    8021ac <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8021ac:	83 c4 1c             	add    $0x1c,%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    

008021b4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	57                   	push   %edi
  8021b8:	56                   	push   %esi
  8021b9:	53                   	push   %ebx
  8021ba:	83 ec 1c             	sub    $0x1c,%esp
  8021bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021c0:	89 3c 24             	mov    %edi,(%esp)
  8021c3:	e8 d8 ef ff ff       	call   8011a0 <fd2data>
  8021c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021ca:	be 00 00 00 00       	mov    $0x0,%esi
  8021cf:	eb 3d                	jmp    80220e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021d1:	85 f6                	test   %esi,%esi
  8021d3:	74 04                	je     8021d9 <devpipe_read+0x25>
				return i;
  8021d5:	89 f0                	mov    %esi,%eax
  8021d7:	eb 43                	jmp    80221c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021d9:	89 da                	mov    %ebx,%edx
  8021db:	89 f8                	mov    %edi,%eax
  8021dd:	e8 f1 fe ff ff       	call   8020d3 <_pipeisclosed>
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 31                	jne    802217 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021e6:	e8 59 eb ff ff       	call   800d44 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021eb:	8b 03                	mov    (%ebx),%eax
  8021ed:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021f0:	74 df                	je     8021d1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021f2:	99                   	cltd   
  8021f3:	c1 ea 1b             	shr    $0x1b,%edx
  8021f6:	01 d0                	add    %edx,%eax
  8021f8:	83 e0 1f             	and    $0x1f,%eax
  8021fb:	29 d0                	sub    %edx,%eax
  8021fd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802202:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802205:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802208:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80220b:	83 c6 01             	add    $0x1,%esi
  80220e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802211:	75 d8                	jne    8021eb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802213:	89 f0                	mov    %esi,%eax
  802215:	eb 05                	jmp    80221c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80221c:	83 c4 1c             	add    $0x1c,%esp
  80221f:	5b                   	pop    %ebx
  802220:	5e                   	pop    %esi
  802221:	5f                   	pop    %edi
  802222:	5d                   	pop    %ebp
  802223:	c3                   	ret    

00802224 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	56                   	push   %esi
  802228:	53                   	push   %ebx
  802229:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80222c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80222f:	89 04 24             	mov    %eax,(%esp)
  802232:	e8 80 ef ff ff       	call   8011b7 <fd_alloc>
  802237:	89 c2                	mov    %eax,%edx
  802239:	85 d2                	test   %edx,%edx
  80223b:	0f 88 4d 01 00 00    	js     80238e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802241:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802248:	00 
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802250:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802257:	e8 07 eb ff ff       	call   800d63 <sys_page_alloc>
  80225c:	89 c2                	mov    %eax,%edx
  80225e:	85 d2                	test   %edx,%edx
  802260:	0f 88 28 01 00 00    	js     80238e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802266:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802269:	89 04 24             	mov    %eax,(%esp)
  80226c:	e8 46 ef ff ff       	call   8011b7 <fd_alloc>
  802271:	89 c3                	mov    %eax,%ebx
  802273:	85 c0                	test   %eax,%eax
  802275:	0f 88 fe 00 00 00    	js     802379 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80227b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802282:	00 
  802283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802286:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802291:	e8 cd ea ff ff       	call   800d63 <sys_page_alloc>
  802296:	89 c3                	mov    %eax,%ebx
  802298:	85 c0                	test   %eax,%eax
  80229a:	0f 88 d9 00 00 00    	js     802379 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	89 04 24             	mov    %eax,(%esp)
  8022a6:	e8 f5 ee ff ff       	call   8011a0 <fd2data>
  8022ab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ad:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022b4:	00 
  8022b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c0:	e8 9e ea ff ff       	call   800d63 <sys_page_alloc>
  8022c5:	89 c3                	mov    %eax,%ebx
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	0f 88 97 00 00 00    	js     802366 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d2:	89 04 24             	mov    %eax,(%esp)
  8022d5:	e8 c6 ee ff ff       	call   8011a0 <fd2data>
  8022da:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8022e1:	00 
  8022e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022ed:	00 
  8022ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f9:	e8 b9 ea ff ff       	call   800db7 <sys_page_map>
  8022fe:	89 c3                	mov    %eax,%ebx
  802300:	85 c0                	test   %eax,%eax
  802302:	78 52                	js     802356 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802304:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802319:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80231f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802322:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802327:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	89 04 24             	mov    %eax,(%esp)
  802334:	e8 57 ee ff ff       	call   801190 <fd2num>
  802339:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80233c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80233e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802341:	89 04 24             	mov    %eax,(%esp)
  802344:	e8 47 ee ff ff       	call   801190 <fd2num>
  802349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80234c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
  802354:	eb 38                	jmp    80238e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802356:	89 74 24 04          	mov    %esi,0x4(%esp)
  80235a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802361:	e8 a4 ea ff ff       	call   800e0a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802366:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802374:	e8 91 ea ff ff       	call   800e0a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802380:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802387:	e8 7e ea ff ff       	call   800e0a <sys_page_unmap>
  80238c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80238e:	83 c4 30             	add    $0x30,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5d                   	pop    %ebp
  802394:	c3                   	ret    

00802395 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80239b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80239e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	89 04 24             	mov    %eax,(%esp)
  8023a8:	e8 59 ee ff ff       	call   801206 <fd_lookup>
  8023ad:	89 c2                	mov    %eax,%edx
  8023af:	85 d2                	test   %edx,%edx
  8023b1:	78 15                	js     8023c8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	89 04 24             	mov    %eax,(%esp)
  8023b9:	e8 e2 ed ff ff       	call   8011a0 <fd2data>
	return _pipeisclosed(fd, p);
  8023be:	89 c2                	mov    %eax,%edx
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	e8 0b fd ff ff       	call   8020d3 <_pipeisclosed>
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    

008023da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8023e0:	c7 44 24 04 73 2e 80 	movl   $0x802e73,0x4(%esp)
  8023e7:	00 
  8023e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023eb:	89 04 24             	mov    %eax,(%esp)
  8023ee:	e8 54 e5 ff ff       	call   800947 <strcpy>
	return 0;
}
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	57                   	push   %edi
  8023fe:	56                   	push   %esi
  8023ff:	53                   	push   %ebx
  802400:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802406:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80240b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802411:	eb 31                	jmp    802444 <devcons_write+0x4a>
		m = n - tot;
  802413:	8b 75 10             	mov    0x10(%ebp),%esi
  802416:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802418:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80241b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802420:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802423:	89 74 24 08          	mov    %esi,0x8(%esp)
  802427:	03 45 0c             	add    0xc(%ebp),%eax
  80242a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80242e:	89 3c 24             	mov    %edi,(%esp)
  802431:	e8 ae e6 ff ff       	call   800ae4 <memmove>
		sys_cputs(buf, m);
  802436:	89 74 24 04          	mov    %esi,0x4(%esp)
  80243a:	89 3c 24             	mov    %edi,(%esp)
  80243d:	e8 54 e8 ff ff       	call   800c96 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802442:	01 f3                	add    %esi,%ebx
  802444:	89 d8                	mov    %ebx,%eax
  802446:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802449:	72 c8                	jb     802413 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80244b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    

00802456 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802461:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802465:	75 07                	jne    80246e <devcons_read+0x18>
  802467:	eb 2a                	jmp    802493 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802469:	e8 d6 e8 ff ff       	call   800d44 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80246e:	66 90                	xchg   %ax,%ax
  802470:	e8 3f e8 ff ff       	call   800cb4 <sys_cgetc>
  802475:	85 c0                	test   %eax,%eax
  802477:	74 f0                	je     802469 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802479:	85 c0                	test   %eax,%eax
  80247b:	78 16                	js     802493 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80247d:	83 f8 04             	cmp    $0x4,%eax
  802480:	74 0c                	je     80248e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802482:	8b 55 0c             	mov    0xc(%ebp),%edx
  802485:	88 02                	mov    %al,(%edx)
	return 1;
  802487:	b8 01 00 00 00       	mov    $0x1,%eax
  80248c:	eb 05                	jmp    802493 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
  802498:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8024a8:	00 
  8024a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024ac:	89 04 24             	mov    %eax,(%esp)
  8024af:	e8 e2 e7 ff ff       	call   800c96 <sys_cputs>
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <getchar>:

int
getchar(void)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8024c3:	00 
  8024c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d2:	e8 c3 ef ff ff       	call   80149a <read>
	if (r < 0)
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	78 0f                	js     8024ea <getchar+0x34>
		return r;
	if (r < 1)
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	7e 06                	jle    8024e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8024df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8024e3:	eb 05                	jmp    8024ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8024e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	89 04 24             	mov    %eax,(%esp)
  8024ff:	e8 02 ed ff ff       	call   801206 <fd_lookup>
  802504:	85 c0                	test   %eax,%eax
  802506:	78 11                	js     802519 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802511:	39 10                	cmp    %edx,(%eax)
  802513:	0f 94 c0             	sete   %al
  802516:	0f b6 c0             	movzbl %al,%eax
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <opencons>:

int
opencons(void)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802521:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802524:	89 04 24             	mov    %eax,(%esp)
  802527:	e8 8b ec ff ff       	call   8011b7 <fd_alloc>
		return r;
  80252c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80252e:	85 c0                	test   %eax,%eax
  802530:	78 40                	js     802572 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802532:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802539:	00 
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802541:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802548:	e8 16 e8 ff ff       	call   800d63 <sys_page_alloc>
		return r;
  80254d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80254f:	85 c0                	test   %eax,%eax
  802551:	78 1f                	js     802572 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802553:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802568:	89 04 24             	mov    %eax,(%esp)
  80256b:	e8 20 ec ff ff       	call   801190 <fd2num>
  802570:	89 c2                	mov    %eax,%edx
}
  802572:	89 d0                	mov    %edx,%eax
  802574:	c9                   	leave  
  802575:	c3                   	ret    
  802576:	66 90                	xchg   %ax,%ax
  802578:	66 90                	xchg   %ax,%ax
  80257a:	66 90                	xchg   %ax,%ax
  80257c:	66 90                	xchg   %ax,%ax
  80257e:	66 90                	xchg   %ax,%ax

00802580 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	56                   	push   %esi
  802584:	53                   	push   %ebx
  802585:	83 ec 10             	sub    $0x10,%esp
  802588:	8b 75 08             	mov    0x8(%ebp),%esi
  80258b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80258e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802591:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802593:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802598:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80259b:	89 04 24             	mov    %eax,(%esp)
  80259e:	e8 d6 e9 ff ff       	call   800f79 <sys_ipc_recv>
  8025a3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8025a5:	85 d2                	test   %edx,%edx
  8025a7:	75 24                	jne    8025cd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8025a9:	85 f6                	test   %esi,%esi
  8025ab:	74 0a                	je     8025b7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8025ad:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8025b2:	8b 40 74             	mov    0x74(%eax),%eax
  8025b5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8025b7:	85 db                	test   %ebx,%ebx
  8025b9:	74 0a                	je     8025c5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8025bb:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8025c0:	8b 40 78             	mov    0x78(%eax),%eax
  8025c3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8025c5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8025ca:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8025cd:	83 c4 10             	add    $0x10,%esp
  8025d0:	5b                   	pop    %ebx
  8025d1:	5e                   	pop    %esi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    

008025d4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	57                   	push   %edi
  8025d8:	56                   	push   %esi
  8025d9:	53                   	push   %ebx
  8025da:	83 ec 1c             	sub    $0x1c,%esp
  8025dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8025e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8025e6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8025e8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8025ed:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8025f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8025f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025ff:	89 3c 24             	mov    %edi,(%esp)
  802602:	e8 4f e9 ff ff       	call   800f56 <sys_ipc_try_send>

		if (ret == 0)
  802607:	85 c0                	test   %eax,%eax
  802609:	74 2c                	je     802637 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80260b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80260e:	74 20                	je     802630 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802610:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802614:	c7 44 24 08 80 2e 80 	movl   $0x802e80,0x8(%esp)
  80261b:	00 
  80261c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802623:	00 
  802624:	c7 04 24 b0 2e 80 00 	movl   $0x802eb0,(%esp)
  80262b:	e8 fb db ff ff       	call   80022b <_panic>
		}

		sys_yield();
  802630:	e8 0f e7 ff ff       	call   800d44 <sys_yield>
	}
  802635:	eb b9                	jmp    8025f0 <ipc_send+0x1c>
}
  802637:	83 c4 1c             	add    $0x1c,%esp
  80263a:	5b                   	pop    %ebx
  80263b:	5e                   	pop    %esi
  80263c:	5f                   	pop    %edi
  80263d:	5d                   	pop    %ebp
  80263e:	c3                   	ret    

0080263f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80264a:	89 c2                	mov    %eax,%edx
  80264c:	c1 e2 07             	shl    $0x7,%edx
  80264f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802656:	8b 52 50             	mov    0x50(%edx),%edx
  802659:	39 ca                	cmp    %ecx,%edx
  80265b:	75 11                	jne    80266e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80265d:	89 c2                	mov    %eax,%edx
  80265f:	c1 e2 07             	shl    $0x7,%edx
  802662:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802669:	8b 40 40             	mov    0x40(%eax),%eax
  80266c:	eb 0e                	jmp    80267c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80266e:	83 c0 01             	add    $0x1,%eax
  802671:	3d 00 04 00 00       	cmp    $0x400,%eax
  802676:	75 d2                	jne    80264a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802678:	66 b8 00 00          	mov    $0x0,%ax
}
  80267c:	5d                   	pop    %ebp
  80267d:	c3                   	ret    

0080267e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802684:	89 d0                	mov    %edx,%eax
  802686:	c1 e8 16             	shr    $0x16,%eax
  802689:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802695:	f6 c1 01             	test   $0x1,%cl
  802698:	74 1d                	je     8026b7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80269a:	c1 ea 0c             	shr    $0xc,%edx
  80269d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026a4:	f6 c2 01             	test   $0x1,%dl
  8026a7:	74 0e                	je     8026b7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026a9:	c1 ea 0c             	shr    $0xc,%edx
  8026ac:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026b3:	ef 
  8026b4:	0f b7 c0             	movzwl %ax,%eax
}
  8026b7:	5d                   	pop    %ebp
  8026b8:	c3                   	ret    
  8026b9:	66 90                	xchg   %ax,%ax
  8026bb:	66 90                	xchg   %ax,%ax
  8026bd:	66 90                	xchg   %ax,%ax
  8026bf:	90                   	nop

008026c0 <__udivdi3>:
  8026c0:	55                   	push   %ebp
  8026c1:	57                   	push   %edi
  8026c2:	56                   	push   %esi
  8026c3:	83 ec 0c             	sub    $0xc,%esp
  8026c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8026ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8026d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8026dc:	89 ea                	mov    %ebp,%edx
  8026de:	89 0c 24             	mov    %ecx,(%esp)
  8026e1:	75 2d                	jne    802710 <__udivdi3+0x50>
  8026e3:	39 e9                	cmp    %ebp,%ecx
  8026e5:	77 61                	ja     802748 <__udivdi3+0x88>
  8026e7:	85 c9                	test   %ecx,%ecx
  8026e9:	89 ce                	mov    %ecx,%esi
  8026eb:	75 0b                	jne    8026f8 <__udivdi3+0x38>
  8026ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f2:	31 d2                	xor    %edx,%edx
  8026f4:	f7 f1                	div    %ecx
  8026f6:	89 c6                	mov    %eax,%esi
  8026f8:	31 d2                	xor    %edx,%edx
  8026fa:	89 e8                	mov    %ebp,%eax
  8026fc:	f7 f6                	div    %esi
  8026fe:	89 c5                	mov    %eax,%ebp
  802700:	89 f8                	mov    %edi,%eax
  802702:	f7 f6                	div    %esi
  802704:	89 ea                	mov    %ebp,%edx
  802706:	83 c4 0c             	add    $0xc,%esp
  802709:	5e                   	pop    %esi
  80270a:	5f                   	pop    %edi
  80270b:	5d                   	pop    %ebp
  80270c:	c3                   	ret    
  80270d:	8d 76 00             	lea    0x0(%esi),%esi
  802710:	39 e8                	cmp    %ebp,%eax
  802712:	77 24                	ja     802738 <__udivdi3+0x78>
  802714:	0f bd e8             	bsr    %eax,%ebp
  802717:	83 f5 1f             	xor    $0x1f,%ebp
  80271a:	75 3c                	jne    802758 <__udivdi3+0x98>
  80271c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802720:	39 34 24             	cmp    %esi,(%esp)
  802723:	0f 86 9f 00 00 00    	jbe    8027c8 <__udivdi3+0x108>
  802729:	39 d0                	cmp    %edx,%eax
  80272b:	0f 82 97 00 00 00    	jb     8027c8 <__udivdi3+0x108>
  802731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802738:	31 d2                	xor    %edx,%edx
  80273a:	31 c0                	xor    %eax,%eax
  80273c:	83 c4 0c             	add    $0xc,%esp
  80273f:	5e                   	pop    %esi
  802740:	5f                   	pop    %edi
  802741:	5d                   	pop    %ebp
  802742:	c3                   	ret    
  802743:	90                   	nop
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	89 f8                	mov    %edi,%eax
  80274a:	f7 f1                	div    %ecx
  80274c:	31 d2                	xor    %edx,%edx
  80274e:	83 c4 0c             	add    $0xc,%esp
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	89 e9                	mov    %ebp,%ecx
  80275a:	8b 3c 24             	mov    (%esp),%edi
  80275d:	d3 e0                	shl    %cl,%eax
  80275f:	89 c6                	mov    %eax,%esi
  802761:	b8 20 00 00 00       	mov    $0x20,%eax
  802766:	29 e8                	sub    %ebp,%eax
  802768:	89 c1                	mov    %eax,%ecx
  80276a:	d3 ef                	shr    %cl,%edi
  80276c:	89 e9                	mov    %ebp,%ecx
  80276e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802772:	8b 3c 24             	mov    (%esp),%edi
  802775:	09 74 24 08          	or     %esi,0x8(%esp)
  802779:	89 d6                	mov    %edx,%esi
  80277b:	d3 e7                	shl    %cl,%edi
  80277d:	89 c1                	mov    %eax,%ecx
  80277f:	89 3c 24             	mov    %edi,(%esp)
  802782:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802786:	d3 ee                	shr    %cl,%esi
  802788:	89 e9                	mov    %ebp,%ecx
  80278a:	d3 e2                	shl    %cl,%edx
  80278c:	89 c1                	mov    %eax,%ecx
  80278e:	d3 ef                	shr    %cl,%edi
  802790:	09 d7                	or     %edx,%edi
  802792:	89 f2                	mov    %esi,%edx
  802794:	89 f8                	mov    %edi,%eax
  802796:	f7 74 24 08          	divl   0x8(%esp)
  80279a:	89 d6                	mov    %edx,%esi
  80279c:	89 c7                	mov    %eax,%edi
  80279e:	f7 24 24             	mull   (%esp)
  8027a1:	39 d6                	cmp    %edx,%esi
  8027a3:	89 14 24             	mov    %edx,(%esp)
  8027a6:	72 30                	jb     8027d8 <__udivdi3+0x118>
  8027a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027ac:	89 e9                	mov    %ebp,%ecx
  8027ae:	d3 e2                	shl    %cl,%edx
  8027b0:	39 c2                	cmp    %eax,%edx
  8027b2:	73 05                	jae    8027b9 <__udivdi3+0xf9>
  8027b4:	3b 34 24             	cmp    (%esp),%esi
  8027b7:	74 1f                	je     8027d8 <__udivdi3+0x118>
  8027b9:	89 f8                	mov    %edi,%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	e9 7a ff ff ff       	jmp    80273c <__udivdi3+0x7c>
  8027c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027c8:	31 d2                	xor    %edx,%edx
  8027ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8027cf:	e9 68 ff ff ff       	jmp    80273c <__udivdi3+0x7c>
  8027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8027db:	31 d2                	xor    %edx,%edx
  8027dd:	83 c4 0c             	add    $0xc,%esp
  8027e0:	5e                   	pop    %esi
  8027e1:	5f                   	pop    %edi
  8027e2:	5d                   	pop    %ebp
  8027e3:	c3                   	ret    
  8027e4:	66 90                	xchg   %ax,%ax
  8027e6:	66 90                	xchg   %ax,%ax
  8027e8:	66 90                	xchg   %ax,%ax
  8027ea:	66 90                	xchg   %ax,%ax
  8027ec:	66 90                	xchg   %ax,%ax
  8027ee:	66 90                	xchg   %ax,%ax

008027f0 <__umoddi3>:
  8027f0:	55                   	push   %ebp
  8027f1:	57                   	push   %edi
  8027f2:	56                   	push   %esi
  8027f3:	83 ec 14             	sub    $0x14,%esp
  8027f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802802:	89 c7                	mov    %eax,%edi
  802804:	89 44 24 04          	mov    %eax,0x4(%esp)
  802808:	8b 44 24 30          	mov    0x30(%esp),%eax
  80280c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802810:	89 34 24             	mov    %esi,(%esp)
  802813:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802817:	85 c0                	test   %eax,%eax
  802819:	89 c2                	mov    %eax,%edx
  80281b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80281f:	75 17                	jne    802838 <__umoddi3+0x48>
  802821:	39 fe                	cmp    %edi,%esi
  802823:	76 4b                	jbe    802870 <__umoddi3+0x80>
  802825:	89 c8                	mov    %ecx,%eax
  802827:	89 fa                	mov    %edi,%edx
  802829:	f7 f6                	div    %esi
  80282b:	89 d0                	mov    %edx,%eax
  80282d:	31 d2                	xor    %edx,%edx
  80282f:	83 c4 14             	add    $0x14,%esp
  802832:	5e                   	pop    %esi
  802833:	5f                   	pop    %edi
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    
  802836:	66 90                	xchg   %ax,%ax
  802838:	39 f8                	cmp    %edi,%eax
  80283a:	77 54                	ja     802890 <__umoddi3+0xa0>
  80283c:	0f bd e8             	bsr    %eax,%ebp
  80283f:	83 f5 1f             	xor    $0x1f,%ebp
  802842:	75 5c                	jne    8028a0 <__umoddi3+0xb0>
  802844:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802848:	39 3c 24             	cmp    %edi,(%esp)
  80284b:	0f 87 e7 00 00 00    	ja     802938 <__umoddi3+0x148>
  802851:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802855:	29 f1                	sub    %esi,%ecx
  802857:	19 c7                	sbb    %eax,%edi
  802859:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80285d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802861:	8b 44 24 08          	mov    0x8(%esp),%eax
  802865:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802869:	83 c4 14             	add    $0x14,%esp
  80286c:	5e                   	pop    %esi
  80286d:	5f                   	pop    %edi
  80286e:	5d                   	pop    %ebp
  80286f:	c3                   	ret    
  802870:	85 f6                	test   %esi,%esi
  802872:	89 f5                	mov    %esi,%ebp
  802874:	75 0b                	jne    802881 <__umoddi3+0x91>
  802876:	b8 01 00 00 00       	mov    $0x1,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	f7 f6                	div    %esi
  80287f:	89 c5                	mov    %eax,%ebp
  802881:	8b 44 24 04          	mov    0x4(%esp),%eax
  802885:	31 d2                	xor    %edx,%edx
  802887:	f7 f5                	div    %ebp
  802889:	89 c8                	mov    %ecx,%eax
  80288b:	f7 f5                	div    %ebp
  80288d:	eb 9c                	jmp    80282b <__umoddi3+0x3b>
  80288f:	90                   	nop
  802890:	89 c8                	mov    %ecx,%eax
  802892:	89 fa                	mov    %edi,%edx
  802894:	83 c4 14             	add    $0x14,%esp
  802897:	5e                   	pop    %esi
  802898:	5f                   	pop    %edi
  802899:	5d                   	pop    %ebp
  80289a:	c3                   	ret    
  80289b:	90                   	nop
  80289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028a0:	8b 04 24             	mov    (%esp),%eax
  8028a3:	be 20 00 00 00       	mov    $0x20,%esi
  8028a8:	89 e9                	mov    %ebp,%ecx
  8028aa:	29 ee                	sub    %ebp,%esi
  8028ac:	d3 e2                	shl    %cl,%edx
  8028ae:	89 f1                	mov    %esi,%ecx
  8028b0:	d3 e8                	shr    %cl,%eax
  8028b2:	89 e9                	mov    %ebp,%ecx
  8028b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b8:	8b 04 24             	mov    (%esp),%eax
  8028bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8028bf:	89 fa                	mov    %edi,%edx
  8028c1:	d3 e0                	shl    %cl,%eax
  8028c3:	89 f1                	mov    %esi,%ecx
  8028c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8028cd:	d3 ea                	shr    %cl,%edx
  8028cf:	89 e9                	mov    %ebp,%ecx
  8028d1:	d3 e7                	shl    %cl,%edi
  8028d3:	89 f1                	mov    %esi,%ecx
  8028d5:	d3 e8                	shr    %cl,%eax
  8028d7:	89 e9                	mov    %ebp,%ecx
  8028d9:	09 f8                	or     %edi,%eax
  8028db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8028df:	f7 74 24 04          	divl   0x4(%esp)
  8028e3:	d3 e7                	shl    %cl,%edi
  8028e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028e9:	89 d7                	mov    %edx,%edi
  8028eb:	f7 64 24 08          	mull   0x8(%esp)
  8028ef:	39 d7                	cmp    %edx,%edi
  8028f1:	89 c1                	mov    %eax,%ecx
  8028f3:	89 14 24             	mov    %edx,(%esp)
  8028f6:	72 2c                	jb     802924 <__umoddi3+0x134>
  8028f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8028fc:	72 22                	jb     802920 <__umoddi3+0x130>
  8028fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802902:	29 c8                	sub    %ecx,%eax
  802904:	19 d7                	sbb    %edx,%edi
  802906:	89 e9                	mov    %ebp,%ecx
  802908:	89 fa                	mov    %edi,%edx
  80290a:	d3 e8                	shr    %cl,%eax
  80290c:	89 f1                	mov    %esi,%ecx
  80290e:	d3 e2                	shl    %cl,%edx
  802910:	89 e9                	mov    %ebp,%ecx
  802912:	d3 ef                	shr    %cl,%edi
  802914:	09 d0                	or     %edx,%eax
  802916:	89 fa                	mov    %edi,%edx
  802918:	83 c4 14             	add    $0x14,%esp
  80291b:	5e                   	pop    %esi
  80291c:	5f                   	pop    %edi
  80291d:	5d                   	pop    %ebp
  80291e:	c3                   	ret    
  80291f:	90                   	nop
  802920:	39 d7                	cmp    %edx,%edi
  802922:	75 da                	jne    8028fe <__umoddi3+0x10e>
  802924:	8b 14 24             	mov    (%esp),%edx
  802927:	89 c1                	mov    %eax,%ecx
  802929:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80292d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802931:	eb cb                	jmp    8028fe <__umoddi3+0x10e>
  802933:	90                   	nop
  802934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802938:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80293c:	0f 82 0f ff ff ff    	jb     802851 <__umoddi3+0x61>
  802942:	e9 1a ff ff ff       	jmp    802861 <__umoddi3+0x71>
