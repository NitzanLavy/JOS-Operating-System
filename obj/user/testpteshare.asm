
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 86 01 00 00       	call   8001b7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  800039:	a1 00 40 80 00       	mov    0x804000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800049:	e8 e9 08 00 00       	call   800937 <strcpy>
	exit();
  80004e:	e8 b0 01 00 00       	call   800203 <exit>
}
  800053:	c9                   	leave  
  800054:	c3                   	ret    

00800055 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	53                   	push   %ebx
  800059:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800060:	74 05                	je     800067 <umain+0x12>
		childofspawn();
  800062:	e8 cc ff ff ff       	call   800033 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800067:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800076:	a0 
  800077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007e:	e8 d0 0c 00 00       	call   800d53 <sys_page_alloc>
  800083:	85 c0                	test   %eax,%eax
  800085:	79 20                	jns    8000a7 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008b:	c7 44 24 08 8c 33 80 	movl   $0x80338c,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009a:	00 
  80009b:	c7 04 24 9f 33 80 00 	movl   $0x80339f,(%esp)
  8000a2:	e8 75 01 00 00       	call   80021c <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a7:	e8 fe 11 00 00       	call   8012aa <fork>
  8000ac:	89 c3                	mov    %eax,%ebx
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	79 20                	jns    8000d2 <umain+0x7d>
		panic("fork: %e", r);
  8000b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b6:	c7 44 24 08 b3 33 80 	movl   $0x8033b3,0x8(%esp)
  8000bd:	00 
  8000be:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c5:	00 
  8000c6:	c7 04 24 9f 33 80 00 	movl   $0x80339f,(%esp)
  8000cd:	e8 4a 01 00 00       	call   80021c <_panic>
	if (r == 0) {
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 1a                	jne    8000f0 <umain+0x9b>
		strcpy(VA, msg);
  8000d6:	a1 04 40 80 00       	mov    0x804004,%eax
  8000db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000df:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e6:	e8 4c 08 00 00       	call   800937 <strcpy>
		exit();
  8000eb:	e8 13 01 00 00       	call   800203 <exit>
	}
	wait(r);
  8000f0:	89 1c 24             	mov    %ebx,(%esp)
  8000f3:	e8 f2 2b 00 00       	call   802cea <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800108:	e8 df 08 00 00       	call   8009ec <strcmp>
  80010d:	85 c0                	test   %eax,%eax
  80010f:	b8 80 33 80 00       	mov    $0x803380,%eax
  800114:	ba 86 33 80 00       	mov    $0x803386,%edx
  800119:	0f 45 c2             	cmovne %edx,%eax
  80011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800120:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  800127:	e8 e9 01 00 00       	call   800315 <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  80013b:	00 
  80013c:	c7 44 24 04 dc 33 80 	movl   $0x8033dc,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 db 33 80 00 	movl   $0x8033db,(%esp)
  80014b:	e8 97 22 00 00       	call   8023e7 <spawnl>
  800150:	85 c0                	test   %eax,%eax
  800152:	79 20                	jns    800174 <umain+0x11f>
		panic("spawn: %e", r);
  800154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800158:	c7 44 24 08 e9 33 80 	movl   $0x8033e9,0x8(%esp)
  80015f:	00 
  800160:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800167:	00 
  800168:	c7 04 24 9f 33 80 00 	movl   $0x80339f,(%esp)
  80016f:	e8 a8 00 00 00       	call   80021c <_panic>
	wait(r);
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 6e 2b 00 00       	call   802cea <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017c:	a1 00 40 80 00       	mov    0x804000,%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018c:	e8 5b 08 00 00       	call   8009ec <strcmp>
  800191:	85 c0                	test   %eax,%eax
  800193:	b8 80 33 80 00       	mov    $0x803380,%eax
  800198:	ba 86 33 80 00       	mov    $0x803386,%edx
  80019d:	0f 45 c2             	cmovne %edx,%eax
  8001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a4:	c7 04 24 f3 33 80 00 	movl   $0x8033f3,(%esp)
  8001ab:	e8 65 01 00 00       	call   800315 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001b0:	cc                   	int3   

	breakpoint();
}
  8001b1:	83 c4 14             	add    $0x14,%esp
  8001b4:	5b                   	pop    %ebx
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 10             	sub    $0x10,%esp
  8001bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001c2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8001c5:	e8 4b 0b 00 00       	call   800d15 <sys_getenvid>
  8001ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cf:	89 c2                	mov    %eax,%edx
  8001d1:	c1 e2 07             	shl    $0x7,%edx
  8001d4:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8001db:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e0:	85 db                	test   %ebx,%ebx
  8001e2:	7e 07                	jle    8001eb <libmain+0x34>
		binaryname = argv[0];
  8001e4:	8b 06                	mov    (%esi),%eax
  8001e6:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001ef:	89 1c 24             	mov    %ebx,(%esp)
  8001f2:	e8 5e fe ff ff       	call   800055 <umain>

	// exit gracefully
	exit();
  8001f7:	e8 07 00 00 00       	call   800203 <exit>
}
  8001fc:	83 c4 10             	add    $0x10,%esp
  8001ff:	5b                   	pop    %ebx
  800200:	5e                   	pop    %esi
  800201:	5d                   	pop    %ebp
  800202:	c3                   	ret    

00800203 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800209:	e8 4c 15 00 00       	call   80175a <close_all>
	sys_env_destroy(0);
  80020e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800215:	e8 a9 0a 00 00       	call   800cc3 <sys_env_destroy>
}
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    

0080021c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	56                   	push   %esi
  800220:	53                   	push   %ebx
  800221:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800224:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800227:	8b 35 08 40 80 00    	mov    0x804008,%esi
  80022d:	e8 e3 0a 00 00       	call   800d15 <sys_getenvid>
  800232:	8b 55 0c             	mov    0xc(%ebp),%edx
  800235:	89 54 24 10          	mov    %edx,0x10(%esp)
  800239:	8b 55 08             	mov    0x8(%ebp),%edx
  80023c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800240:	89 74 24 08          	mov    %esi,0x8(%esp)
  800244:	89 44 24 04          	mov    %eax,0x4(%esp)
  800248:	c7 04 24 38 34 80 00 	movl   $0x803438,(%esp)
  80024f:	e8 c1 00 00 00       	call   800315 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800254:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800258:	8b 45 10             	mov    0x10(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 51 00 00 00       	call   8002b4 <vcprintf>
	cprintf("\n");
  800263:	c7 04 24 93 3a 80 00 	movl   $0x803a93,(%esp)
  80026a:	e8 a6 00 00 00       	call   800315 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026f:	cc                   	int3   
  800270:	eb fd                	jmp    80026f <_panic+0x53>

00800272 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	53                   	push   %ebx
  800276:	83 ec 14             	sub    $0x14,%esp
  800279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027c:	8b 13                	mov    (%ebx),%edx
  80027e:	8d 42 01             	lea    0x1(%edx),%eax
  800281:	89 03                	mov    %eax,(%ebx)
  800283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800286:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028f:	75 19                	jne    8002aa <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800291:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800298:	00 
  800299:	8d 43 08             	lea    0x8(%ebx),%eax
  80029c:	89 04 24             	mov    %eax,(%esp)
  80029f:	e8 e2 09 00 00       	call   800c86 <sys_cputs>
		b->idx = 0;
  8002a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002aa:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ae:	83 c4 14             	add    $0x14,%esp
  8002b1:	5b                   	pop    %ebx
  8002b2:	5d                   	pop    %ebp
  8002b3:	c3                   	ret    

008002b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c4:	00 00 00 
	b.cnt = 0;
  8002c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e9:	c7 04 24 72 02 80 00 	movl   $0x800272,(%esp)
  8002f0:	e8 a9 01 00 00       	call   80049e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ff:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800305:	89 04 24             	mov    %eax,(%esp)
  800308:	e8 79 09 00 00       	call   800c86 <sys_cputs>

	return b.cnt;
}
  80030d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80031b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80031e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	e8 87 ff ff ff       	call   8002b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    
  80032f:	90                   	nop

00800330 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 3c             	sub    $0x3c,%esp
  800339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033c:	89 d7                	mov    %edx,%edi
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	89 c3                	mov    %eax,%ebx
  800349:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80034c:	8b 45 10             	mov    0x10(%ebp),%eax
  80034f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800352:	b9 00 00 00 00       	mov    $0x0,%ecx
  800357:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80035d:	39 d9                	cmp    %ebx,%ecx
  80035f:	72 05                	jb     800366 <printnum+0x36>
  800361:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800364:	77 69                	ja     8003cf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800366:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800369:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80036d:	83 ee 01             	sub    $0x1,%esi
  800370:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800374:	89 44 24 08          	mov    %eax,0x8(%esp)
  800378:	8b 44 24 08          	mov    0x8(%esp),%eax
  80037c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800380:	89 c3                	mov    %eax,%ebx
  800382:	89 d6                	mov    %edx,%esi
  800384:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800387:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80038a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80038e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039f:	e8 4c 2d 00 00       	call   8030f0 <__udivdi3>
  8003a4:	89 d9                	mov    %ebx,%ecx
  8003a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003aa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003ae:	89 04 24             	mov    %eax,(%esp)
  8003b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003b5:	89 fa                	mov    %edi,%edx
  8003b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ba:	e8 71 ff ff ff       	call   800330 <printnum>
  8003bf:	eb 1b                	jmp    8003dc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c8:	89 04 24             	mov    %eax,(%esp)
  8003cb:	ff d3                	call   *%ebx
  8003cd:	eb 03                	jmp    8003d2 <printnum+0xa2>
  8003cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d2:	83 ee 01             	sub    $0x1,%esi
  8003d5:	85 f6                	test   %esi,%esi
  8003d7:	7f e8                	jg     8003c1 <printnum+0x91>
  8003d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003e0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f5:	89 04 24             	mov    %eax,(%esp)
  8003f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ff:	e8 1c 2e 00 00       	call   803220 <__umoddi3>
  800404:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800408:	0f be 80 5b 34 80 00 	movsbl 0x80345b(%eax),%eax
  80040f:	89 04 24             	mov    %eax,(%esp)
  800412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800415:	ff d0                	call   *%eax
}
  800417:	83 c4 3c             	add    $0x3c,%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800422:	83 fa 01             	cmp    $0x1,%edx
  800425:	7e 0e                	jle    800435 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800427:	8b 10                	mov    (%eax),%edx
  800429:	8d 4a 08             	lea    0x8(%edx),%ecx
  80042c:	89 08                	mov    %ecx,(%eax)
  80042e:	8b 02                	mov    (%edx),%eax
  800430:	8b 52 04             	mov    0x4(%edx),%edx
  800433:	eb 22                	jmp    800457 <getuint+0x38>
	else if (lflag)
  800435:	85 d2                	test   %edx,%edx
  800437:	74 10                	je     800449 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800439:	8b 10                	mov    (%eax),%edx
  80043b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80043e:	89 08                	mov    %ecx,(%eax)
  800440:	8b 02                	mov    (%edx),%eax
  800442:	ba 00 00 00 00       	mov    $0x0,%edx
  800447:	eb 0e                	jmp    800457 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800449:	8b 10                	mov    (%eax),%edx
  80044b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044e:	89 08                	mov    %ecx,(%eax)
  800450:	8b 02                	mov    (%edx),%eax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    

00800459 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80045f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800463:	8b 10                	mov    (%eax),%edx
  800465:	3b 50 04             	cmp    0x4(%eax),%edx
  800468:	73 0a                	jae    800474 <sprintputch+0x1b>
		*b->buf++ = ch;
  80046a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80046d:	89 08                	mov    %ecx,(%eax)
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	88 02                	mov    %al,(%edx)
}
  800474:	5d                   	pop    %ebp
  800475:	c3                   	ret    

00800476 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80047c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80047f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800483:	8b 45 10             	mov    0x10(%ebp),%eax
  800486:	89 44 24 08          	mov    %eax,0x8(%esp)
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	89 04 24             	mov    %eax,(%esp)
  800497:	e8 02 00 00 00       	call   80049e <vprintfmt>
	va_end(ap);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    

0080049e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	57                   	push   %edi
  8004a2:	56                   	push   %esi
  8004a3:	53                   	push   %ebx
  8004a4:	83 ec 3c             	sub    $0x3c,%esp
  8004a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004ad:	eb 14                	jmp    8004c3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004af:	85 c0                	test   %eax,%eax
  8004b1:	0f 84 b3 03 00 00    	je     80086a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004bb:	89 04 24             	mov    %eax,(%esp)
  8004be:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c1:	89 f3                	mov    %esi,%ebx
  8004c3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004c6:	0f b6 03             	movzbl (%ebx),%eax
  8004c9:	83 f8 25             	cmp    $0x25,%eax
  8004cc:	75 e1                	jne    8004af <vprintfmt+0x11>
  8004ce:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004d9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004e0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ec:	eb 1d                	jmp    80050b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ee:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004f0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004f4:	eb 15                	jmp    80050b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004f8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004fc:	eb 0d                	jmp    80050b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800501:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800504:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80050e:	0f b6 0e             	movzbl (%esi),%ecx
  800511:	0f b6 c1             	movzbl %cl,%eax
  800514:	83 e9 23             	sub    $0x23,%ecx
  800517:	80 f9 55             	cmp    $0x55,%cl
  80051a:	0f 87 2a 03 00 00    	ja     80084a <vprintfmt+0x3ac>
  800520:	0f b6 c9             	movzbl %cl,%ecx
  800523:	ff 24 8d e0 35 80 00 	jmp    *0x8035e0(,%ecx,4)
  80052a:	89 de                	mov    %ebx,%esi
  80052c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800531:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800534:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800538:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80053b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80053e:	83 fb 09             	cmp    $0x9,%ebx
  800541:	77 36                	ja     800579 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800543:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800546:	eb e9                	jmp    800531 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8d 48 04             	lea    0x4(%eax),%ecx
  80054e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800551:	8b 00                	mov    (%eax),%eax
  800553:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800556:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800558:	eb 22                	jmp    80057c <vprintfmt+0xde>
  80055a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80055d:	85 c9                	test   %ecx,%ecx
  80055f:	b8 00 00 00 00       	mov    $0x0,%eax
  800564:	0f 49 c1             	cmovns %ecx,%eax
  800567:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	89 de                	mov    %ebx,%esi
  80056c:	eb 9d                	jmp    80050b <vprintfmt+0x6d>
  80056e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800570:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800577:	eb 92                	jmp    80050b <vprintfmt+0x6d>
  800579:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80057c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800580:	79 89                	jns    80050b <vprintfmt+0x6d>
  800582:	e9 77 ff ff ff       	jmp    8004fe <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800587:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80058c:	e9 7a ff ff ff       	jmp    80050b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 50 04             	lea    0x4(%eax),%edx
  800597:	89 55 14             	mov    %edx,0x14(%ebp)
  80059a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 04 24             	mov    %eax,(%esp)
  8005a3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005a6:	e9 18 ff ff ff       	jmp    8004c3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8d 50 04             	lea    0x4(%eax),%edx
  8005b1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	99                   	cltd   
  8005b7:	31 d0                	xor    %edx,%eax
  8005b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005bb:	83 f8 12             	cmp    $0x12,%eax
  8005be:	7f 0b                	jg     8005cb <vprintfmt+0x12d>
  8005c0:	8b 14 85 40 37 80 00 	mov    0x803740(,%eax,4),%edx
  8005c7:	85 d2                	test   %edx,%edx
  8005c9:	75 20                	jne    8005eb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cf:	c7 44 24 08 73 34 80 	movl   $0x803473,0x8(%esp)
  8005d6:	00 
  8005d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	89 04 24             	mov    %eax,(%esp)
  8005e1:	e8 90 fe ff ff       	call   800476 <printfmt>
  8005e6:	e9 d8 fe ff ff       	jmp    8004c3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ef:	c7 44 24 08 75 39 80 	movl   $0x803975,0x8(%esp)
  8005f6:	00 
  8005f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	e8 70 fe ff ff       	call   800476 <printfmt>
  800606:	e9 b8 fe ff ff       	jmp    8004c3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80060e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800611:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 50 04             	lea    0x4(%eax),%edx
  80061a:	89 55 14             	mov    %edx,0x14(%ebp)
  80061d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80061f:	85 f6                	test   %esi,%esi
  800621:	b8 6c 34 80 00       	mov    $0x80346c,%eax
  800626:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800629:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80062d:	0f 84 97 00 00 00    	je     8006ca <vprintfmt+0x22c>
  800633:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800637:	0f 8e 9b 00 00 00    	jle    8006d8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80063d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800641:	89 34 24             	mov    %esi,(%esp)
  800644:	e8 cf 02 00 00       	call   800918 <strnlen>
  800649:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80064c:	29 c2                	sub    %eax,%edx
  80064e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800651:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800655:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800658:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80065b:	8b 75 08             	mov    0x8(%ebp),%esi
  80065e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800661:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800663:	eb 0f                	jmp    800674 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800665:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800669:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80066c:	89 04 24             	mov    %eax,(%esp)
  80066f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800671:	83 eb 01             	sub    $0x1,%ebx
  800674:	85 db                	test   %ebx,%ebx
  800676:	7f ed                	jg     800665 <vprintfmt+0x1c7>
  800678:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80067b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80067e:	85 d2                	test   %edx,%edx
  800680:	b8 00 00 00 00       	mov    $0x0,%eax
  800685:	0f 49 c2             	cmovns %edx,%eax
  800688:	29 c2                	sub    %eax,%edx
  80068a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80068d:	89 d7                	mov    %edx,%edi
  80068f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800692:	eb 50                	jmp    8006e4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800694:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800698:	74 1e                	je     8006b8 <vprintfmt+0x21a>
  80069a:	0f be d2             	movsbl %dl,%edx
  80069d:	83 ea 20             	sub    $0x20,%edx
  8006a0:	83 fa 5e             	cmp    $0x5e,%edx
  8006a3:	76 13                	jbe    8006b8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ac:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006b3:	ff 55 08             	call   *0x8(%ebp)
  8006b6:	eb 0d                	jmp    8006c5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006bf:	89 04 24             	mov    %eax,(%esp)
  8006c2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c5:	83 ef 01             	sub    $0x1,%edi
  8006c8:	eb 1a                	jmp    8006e4 <vprintfmt+0x246>
  8006ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006cd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006d0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006d6:	eb 0c                	jmp    8006e4 <vprintfmt+0x246>
  8006d8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006db:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006e1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006e4:	83 c6 01             	add    $0x1,%esi
  8006e7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006eb:	0f be c2             	movsbl %dl,%eax
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	74 27                	je     800719 <vprintfmt+0x27b>
  8006f2:	85 db                	test   %ebx,%ebx
  8006f4:	78 9e                	js     800694 <vprintfmt+0x1f6>
  8006f6:	83 eb 01             	sub    $0x1,%ebx
  8006f9:	79 99                	jns    800694 <vprintfmt+0x1f6>
  8006fb:	89 f8                	mov    %edi,%eax
  8006fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800700:	8b 75 08             	mov    0x8(%ebp),%esi
  800703:	89 c3                	mov    %eax,%ebx
  800705:	eb 1a                	jmp    800721 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800707:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800712:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800714:	83 eb 01             	sub    $0x1,%ebx
  800717:	eb 08                	jmp    800721 <vprintfmt+0x283>
  800719:	89 fb                	mov    %edi,%ebx
  80071b:	8b 75 08             	mov    0x8(%ebp),%esi
  80071e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800721:	85 db                	test   %ebx,%ebx
  800723:	7f e2                	jg     800707 <vprintfmt+0x269>
  800725:	89 75 08             	mov    %esi,0x8(%ebp)
  800728:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80072b:	e9 93 fd ff ff       	jmp    8004c3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800730:	83 fa 01             	cmp    $0x1,%edx
  800733:	7e 16                	jle    80074b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 50 08             	lea    0x8(%eax),%edx
  80073b:	89 55 14             	mov    %edx,0x14(%ebp)
  80073e:	8b 50 04             	mov    0x4(%eax),%edx
  800741:	8b 00                	mov    (%eax),%eax
  800743:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800746:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800749:	eb 32                	jmp    80077d <vprintfmt+0x2df>
	else if (lflag)
  80074b:	85 d2                	test   %edx,%edx
  80074d:	74 18                	je     800767 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 50 04             	lea    0x4(%eax),%edx
  800755:	89 55 14             	mov    %edx,0x14(%ebp)
  800758:	8b 30                	mov    (%eax),%esi
  80075a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80075d:	89 f0                	mov    %esi,%eax
  80075f:	c1 f8 1f             	sar    $0x1f,%eax
  800762:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800765:	eb 16                	jmp    80077d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 50 04             	lea    0x4(%eax),%edx
  80076d:	89 55 14             	mov    %edx,0x14(%ebp)
  800770:	8b 30                	mov    (%eax),%esi
  800772:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800775:	89 f0                	mov    %esi,%eax
  800777:	c1 f8 1f             	sar    $0x1f,%eax
  80077a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800783:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800788:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078c:	0f 89 80 00 00 00    	jns    800812 <vprintfmt+0x374>
				putch('-', putdat);
  800792:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800796:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80079d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a6:	f7 d8                	neg    %eax
  8007a8:	83 d2 00             	adc    $0x0,%edx
  8007ab:	f7 da                	neg    %edx
			}
			base = 10;
  8007ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007b2:	eb 5e                	jmp    800812 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b7:	e8 63 fc ff ff       	call   80041f <getuint>
			base = 10;
  8007bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007c1:	eb 4f                	jmp    800812 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c6:	e8 54 fc ff ff       	call   80041f <getuint>
			base = 8;
  8007cb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007d0:	eb 40                	jmp    800812 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8007d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007dd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007eb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 50 04             	lea    0x4(%eax),%edx
  8007f4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007fe:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800803:	eb 0d                	jmp    800812 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800805:	8d 45 14             	lea    0x14(%ebp),%eax
  800808:	e8 12 fc ff ff       	call   80041f <getuint>
			base = 16;
  80080d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800812:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800816:	89 74 24 10          	mov    %esi,0x10(%esp)
  80081a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80081d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800821:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800825:	89 04 24             	mov    %eax,(%esp)
  800828:	89 54 24 04          	mov    %edx,0x4(%esp)
  80082c:	89 fa                	mov    %edi,%edx
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	e8 fa fa ff ff       	call   800330 <printnum>
			break;
  800836:	e9 88 fc ff ff       	jmp    8004c3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80083f:	89 04 24             	mov    %eax,(%esp)
  800842:	ff 55 08             	call   *0x8(%ebp)
			break;
  800845:	e9 79 fc ff ff       	jmp    8004c3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80084a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800855:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800858:	89 f3                	mov    %esi,%ebx
  80085a:	eb 03                	jmp    80085f <vprintfmt+0x3c1>
  80085c:	83 eb 01             	sub    $0x1,%ebx
  80085f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800863:	75 f7                	jne    80085c <vprintfmt+0x3be>
  800865:	e9 59 fc ff ff       	jmp    8004c3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80086a:	83 c4 3c             	add    $0x3c,%esp
  80086d:	5b                   	pop    %ebx
  80086e:	5e                   	pop    %esi
  80086f:	5f                   	pop    %edi
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	83 ec 28             	sub    $0x28,%esp
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800881:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800885:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088f:	85 c0                	test   %eax,%eax
  800891:	74 30                	je     8008c3 <vsnprintf+0x51>
  800893:	85 d2                	test   %edx,%edx
  800895:	7e 2c                	jle    8008c3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80089e:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ac:	c7 04 24 59 04 80 00 	movl   $0x800459,(%esp)
  8008b3:	e8 e6 fb ff ff       	call   80049e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c1:	eb 05                	jmp    8008c8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008c8:	c9                   	leave  
  8008c9:	c3                   	ret    

008008ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	89 04 24             	mov    %eax,(%esp)
  8008eb:	e8 82 ff ff ff       	call   800872 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    
  8008f2:	66 90                	xchg   %ax,%ax
  8008f4:	66 90                	xchg   %ax,%ax
  8008f6:	66 90                	xchg   %ax,%ax
  8008f8:	66 90                	xchg   %ax,%ax
  8008fa:	66 90                	xchg   %ax,%ax
  8008fc:	66 90                	xchg   %ax,%ax
  8008fe:	66 90                	xchg   %ax,%ax

00800900 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	eb 03                	jmp    800910 <strlen+0x10>
		n++;
  80090d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800910:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800914:	75 f7                	jne    80090d <strlen+0xd>
		n++;
	return n;
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	eb 03                	jmp    80092b <strnlen+0x13>
		n++;
  800928:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092b:	39 d0                	cmp    %edx,%eax
  80092d:	74 06                	je     800935 <strnlen+0x1d>
  80092f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800933:	75 f3                	jne    800928 <strnlen+0x10>
		n++;
	return n;
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	53                   	push   %ebx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800941:	89 c2                	mov    %eax,%edx
  800943:	83 c2 01             	add    $0x1,%edx
  800946:	83 c1 01             	add    $0x1,%ecx
  800949:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80094d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800950:	84 db                	test   %bl,%bl
  800952:	75 ef                	jne    800943 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800954:	5b                   	pop    %ebx
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800961:	89 1c 24             	mov    %ebx,(%esp)
  800964:	e8 97 ff ff ff       	call   800900 <strlen>
	strcpy(dst + len, src);
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800970:	01 d8                	add    %ebx,%eax
  800972:	89 04 24             	mov    %eax,(%esp)
  800975:	e8 bd ff ff ff       	call   800937 <strcpy>
	return dst;
}
  80097a:	89 d8                	mov    %ebx,%eax
  80097c:	83 c4 08             	add    $0x8,%esp
  80097f:	5b                   	pop    %ebx
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	56                   	push   %esi
  800986:	53                   	push   %ebx
  800987:	8b 75 08             	mov    0x8(%ebp),%esi
  80098a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098d:	89 f3                	mov    %esi,%ebx
  80098f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800992:	89 f2                	mov    %esi,%edx
  800994:	eb 0f                	jmp    8009a5 <strncpy+0x23>
		*dst++ = *src;
  800996:	83 c2 01             	add    $0x1,%edx
  800999:	0f b6 01             	movzbl (%ecx),%eax
  80099c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099f:	80 39 01             	cmpb   $0x1,(%ecx)
  8009a2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a5:	39 da                	cmp    %ebx,%edx
  8009a7:	75 ed                	jne    800996 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009a9:	89 f0                	mov    %esi,%eax
  8009ab:	5b                   	pop    %ebx
  8009ac:	5e                   	pop    %esi
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009bd:	89 f0                	mov    %esi,%eax
  8009bf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	75 0b                	jne    8009d2 <strlcpy+0x23>
  8009c7:	eb 1d                	jmp    8009e6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d2:	39 d8                	cmp    %ebx,%eax
  8009d4:	74 0b                	je     8009e1 <strlcpy+0x32>
  8009d6:	0f b6 0a             	movzbl (%edx),%ecx
  8009d9:	84 c9                	test   %cl,%cl
  8009db:	75 ec                	jne    8009c9 <strlcpy+0x1a>
  8009dd:	89 c2                	mov    %eax,%edx
  8009df:	eb 02                	jmp    8009e3 <strlcpy+0x34>
  8009e1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009e3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009e6:	29 f0                	sub    %esi,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5e                   	pop    %esi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f5:	eb 06                	jmp    8009fd <strcmp+0x11>
		p++, q++;
  8009f7:	83 c1 01             	add    $0x1,%ecx
  8009fa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009fd:	0f b6 01             	movzbl (%ecx),%eax
  800a00:	84 c0                	test   %al,%al
  800a02:	74 04                	je     800a08 <strcmp+0x1c>
  800a04:	3a 02                	cmp    (%edx),%al
  800a06:	74 ef                	je     8009f7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 c0             	movzbl %al,%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	53                   	push   %ebx
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	89 c3                	mov    %eax,%ebx
  800a1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a21:	eb 06                	jmp    800a29 <strncmp+0x17>
		n--, p++, q++;
  800a23:	83 c0 01             	add    $0x1,%eax
  800a26:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a29:	39 d8                	cmp    %ebx,%eax
  800a2b:	74 15                	je     800a42 <strncmp+0x30>
  800a2d:	0f b6 08             	movzbl (%eax),%ecx
  800a30:	84 c9                	test   %cl,%cl
  800a32:	74 04                	je     800a38 <strncmp+0x26>
  800a34:	3a 0a                	cmp    (%edx),%cl
  800a36:	74 eb                	je     800a23 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a38:	0f b6 00             	movzbl (%eax),%eax
  800a3b:	0f b6 12             	movzbl (%edx),%edx
  800a3e:	29 d0                	sub    %edx,%eax
  800a40:	eb 05                	jmp    800a47 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a47:	5b                   	pop    %ebx
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a54:	eb 07                	jmp    800a5d <strchr+0x13>
		if (*s == c)
  800a56:	38 ca                	cmp    %cl,%dl
  800a58:	74 0f                	je     800a69 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a5a:	83 c0 01             	add    $0x1,%eax
  800a5d:	0f b6 10             	movzbl (%eax),%edx
  800a60:	84 d2                	test   %dl,%dl
  800a62:	75 f2                	jne    800a56 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a75:	eb 07                	jmp    800a7e <strfind+0x13>
		if (*s == c)
  800a77:	38 ca                	cmp    %cl,%dl
  800a79:	74 0a                	je     800a85 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a7b:	83 c0 01             	add    $0x1,%eax
  800a7e:	0f b6 10             	movzbl (%eax),%edx
  800a81:	84 d2                	test   %dl,%dl
  800a83:	75 f2                	jne    800a77 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
  800a8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a93:	85 c9                	test   %ecx,%ecx
  800a95:	74 36                	je     800acd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9d:	75 28                	jne    800ac7 <memset+0x40>
  800a9f:	f6 c1 03             	test   $0x3,%cl
  800aa2:	75 23                	jne    800ac7 <memset+0x40>
		c &= 0xFF;
  800aa4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aa8:	89 d3                	mov    %edx,%ebx
  800aaa:	c1 e3 08             	shl    $0x8,%ebx
  800aad:	89 d6                	mov    %edx,%esi
  800aaf:	c1 e6 18             	shl    $0x18,%esi
  800ab2:	89 d0                	mov    %edx,%eax
  800ab4:	c1 e0 10             	shl    $0x10,%eax
  800ab7:	09 f0                	or     %esi,%eax
  800ab9:	09 c2                	or     %eax,%edx
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800abf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ac2:	fc                   	cld    
  800ac3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac5:	eb 06                	jmp    800acd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aca:	fc                   	cld    
  800acb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800acd:	89 f8                	mov    %edi,%eax
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5f                   	pop    %edi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	57                   	push   %edi
  800ad8:	56                   	push   %esi
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae2:	39 c6                	cmp    %eax,%esi
  800ae4:	73 35                	jae    800b1b <memmove+0x47>
  800ae6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae9:	39 d0                	cmp    %edx,%eax
  800aeb:	73 2e                	jae    800b1b <memmove+0x47>
		s += n;
		d += n;
  800aed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800af0:	89 d6                	mov    %edx,%esi
  800af2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afa:	75 13                	jne    800b0f <memmove+0x3b>
  800afc:	f6 c1 03             	test   $0x3,%cl
  800aff:	75 0e                	jne    800b0f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b01:	83 ef 04             	sub    $0x4,%edi
  800b04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b0a:	fd                   	std    
  800b0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0d:	eb 09                	jmp    800b18 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b0f:	83 ef 01             	sub    $0x1,%edi
  800b12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b15:	fd                   	std    
  800b16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b18:	fc                   	cld    
  800b19:	eb 1d                	jmp    800b38 <memmove+0x64>
  800b1b:	89 f2                	mov    %esi,%edx
  800b1d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1f:	f6 c2 03             	test   $0x3,%dl
  800b22:	75 0f                	jne    800b33 <memmove+0x5f>
  800b24:	f6 c1 03             	test   $0x3,%cl
  800b27:	75 0a                	jne    800b33 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b29:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b2c:	89 c7                	mov    %eax,%edi
  800b2e:	fc                   	cld    
  800b2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b31:	eb 05                	jmp    800b38 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b33:	89 c7                	mov    %eax,%edi
  800b35:	fc                   	cld    
  800b36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b38:	5e                   	pop    %esi
  800b39:	5f                   	pop    %edi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b42:	8b 45 10             	mov    0x10(%ebp),%eax
  800b45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	89 04 24             	mov    %eax,(%esp)
  800b56:	e8 79 ff ff ff       	call   800ad4 <memmove>
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b68:	89 d6                	mov    %edx,%esi
  800b6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6d:	eb 1a                	jmp    800b89 <memcmp+0x2c>
		if (*s1 != *s2)
  800b6f:	0f b6 02             	movzbl (%edx),%eax
  800b72:	0f b6 19             	movzbl (%ecx),%ebx
  800b75:	38 d8                	cmp    %bl,%al
  800b77:	74 0a                	je     800b83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b79:	0f b6 c0             	movzbl %al,%eax
  800b7c:	0f b6 db             	movzbl %bl,%ebx
  800b7f:	29 d8                	sub    %ebx,%eax
  800b81:	eb 0f                	jmp    800b92 <memcmp+0x35>
		s1++, s2++;
  800b83:	83 c2 01             	add    $0x1,%edx
  800b86:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b89:	39 f2                	cmp    %esi,%edx
  800b8b:	75 e2                	jne    800b6f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b9f:	89 c2                	mov    %eax,%edx
  800ba1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba4:	eb 07                	jmp    800bad <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba6:	38 08                	cmp    %cl,(%eax)
  800ba8:	74 07                	je     800bb1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800baa:	83 c0 01             	add    $0x1,%eax
  800bad:	39 d0                	cmp    %edx,%eax
  800baf:	72 f5                	jb     800ba6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbf:	eb 03                	jmp    800bc4 <strtol+0x11>
		s++;
  800bc1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc4:	0f b6 0a             	movzbl (%edx),%ecx
  800bc7:	80 f9 09             	cmp    $0x9,%cl
  800bca:	74 f5                	je     800bc1 <strtol+0xe>
  800bcc:	80 f9 20             	cmp    $0x20,%cl
  800bcf:	74 f0                	je     800bc1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bd1:	80 f9 2b             	cmp    $0x2b,%cl
  800bd4:	75 0a                	jne    800be0 <strtol+0x2d>
		s++;
  800bd6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bd9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bde:	eb 11                	jmp    800bf1 <strtol+0x3e>
  800be0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800be5:	80 f9 2d             	cmp    $0x2d,%cl
  800be8:	75 07                	jne    800bf1 <strtol+0x3e>
		s++, neg = 1;
  800bea:	8d 52 01             	lea    0x1(%edx),%edx
  800bed:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bf6:	75 15                	jne    800c0d <strtol+0x5a>
  800bf8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfb:	75 10                	jne    800c0d <strtol+0x5a>
  800bfd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c01:	75 0a                	jne    800c0d <strtol+0x5a>
		s += 2, base = 16;
  800c03:	83 c2 02             	add    $0x2,%edx
  800c06:	b8 10 00 00 00       	mov    $0x10,%eax
  800c0b:	eb 10                	jmp    800c1d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	75 0c                	jne    800c1d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c11:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c13:	80 3a 30             	cmpb   $0x30,(%edx)
  800c16:	75 05                	jne    800c1d <strtol+0x6a>
		s++, base = 8;
  800c18:	83 c2 01             	add    $0x1,%edx
  800c1b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c22:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c25:	0f b6 0a             	movzbl (%edx),%ecx
  800c28:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c2b:	89 f0                	mov    %esi,%eax
  800c2d:	3c 09                	cmp    $0x9,%al
  800c2f:	77 08                	ja     800c39 <strtol+0x86>
			dig = *s - '0';
  800c31:	0f be c9             	movsbl %cl,%ecx
  800c34:	83 e9 30             	sub    $0x30,%ecx
  800c37:	eb 20                	jmp    800c59 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c39:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c3c:	89 f0                	mov    %esi,%eax
  800c3e:	3c 19                	cmp    $0x19,%al
  800c40:	77 08                	ja     800c4a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c42:	0f be c9             	movsbl %cl,%ecx
  800c45:	83 e9 57             	sub    $0x57,%ecx
  800c48:	eb 0f                	jmp    800c59 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c4a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c4d:	89 f0                	mov    %esi,%eax
  800c4f:	3c 19                	cmp    $0x19,%al
  800c51:	77 16                	ja     800c69 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c53:	0f be c9             	movsbl %cl,%ecx
  800c56:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c59:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c5c:	7d 0f                	jge    800c6d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c5e:	83 c2 01             	add    $0x1,%edx
  800c61:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c65:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c67:	eb bc                	jmp    800c25 <strtol+0x72>
  800c69:	89 d8                	mov    %ebx,%eax
  800c6b:	eb 02                	jmp    800c6f <strtol+0xbc>
  800c6d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	74 05                	je     800c7a <strtol+0xc7>
		*endptr = (char *) s;
  800c75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c78:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c7a:	f7 d8                	neg    %eax
  800c7c:	85 ff                	test   %edi,%edi
  800c7e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	89 c3                	mov    %eax,%ebx
  800c99:	89 c7                	mov    %eax,%edi
  800c9b:	89 c6                	mov    %eax,%esi
  800c9d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb4:	89 d1                	mov    %edx,%ecx
  800cb6:	89 d3                	mov    %edx,%ebx
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	89 d6                	mov    %edx,%esi
  800cbc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	89 cb                	mov    %ecx,%ebx
  800cdb:	89 cf                	mov    %ecx,%edi
  800cdd:	89 ce                	mov    %ecx,%esi
  800cdf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7e 28                	jle    800d0d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ce9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cf0:	00 
  800cf1:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  800cf8:	00 
  800cf9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d00:	00 
  800d01:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  800d08:	e8 0f f5 ff ff       	call   80021c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0d:	83 c4 2c             	add    $0x2c,%esp
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 02 00 00 00       	mov    $0x2,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <sys_yield>:

void
sys_yield(void)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d44:	89 d1                	mov    %edx,%ecx
  800d46:	89 d3                	mov    %edx,%ebx
  800d48:	89 d7                	mov    %edx,%edi
  800d4a:	89 d6                	mov    %edx,%esi
  800d4c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800d5c:	be 00 00 00 00       	mov    $0x0,%esi
  800d61:	b8 04 00 00 00       	mov    $0x4,%eax
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6f:	89 f7                	mov    %esi,%edi
  800d71:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	7e 28                	jle    800d9f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d77:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d82:	00 
  800d83:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  800d8a:	00 
  800d8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d92:	00 
  800d93:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  800d9a:	e8 7d f4 ff ff       	call   80021c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d9f:	83 c4 2c             	add    $0x2c,%esp
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5f                   	pop    %edi
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db0:	b8 05 00 00 00       	mov    $0x5,%eax
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc1:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	7e 28                	jle    800df2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dca:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dce:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dd5:	00 
  800dd6:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  800ddd:	00 
  800dde:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de5:	00 
  800de6:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  800ded:	e8 2a f4 ff ff       	call   80021c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df2:	83 c4 2c             	add    $0x2c,%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    

00800dfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	b8 06 00 00 00       	mov    $0x6,%eax
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7e 28                	jle    800e45 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e21:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e28:	00 
  800e29:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  800e30:	00 
  800e31:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e38:	00 
  800e39:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  800e40:	e8 d7 f3 ff ff       	call   80021c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e45:	83 c4 2c             	add    $0x2c,%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	8b 55 08             	mov    0x8(%ebp),%edx
  800e66:	89 df                	mov    %ebx,%edi
  800e68:	89 de                	mov    %ebx,%esi
  800e6a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7e 28                	jle    800e98 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e74:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e7b:	00 
  800e7c:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  800e83:	00 
  800e84:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8b:	00 
  800e8c:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  800e93:	e8 84 f3 ff ff       	call   80021c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e98:	83 c4 2c             	add    $0x2c,%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eae:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 de                	mov    %ebx,%esi
  800ebd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7e 28                	jle    800eeb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ece:	00 
  800ecf:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ede:	00 
  800edf:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  800ee6:	e8 31 f3 ff ff       	call   80021c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eeb:	83 c4 2c             	add    $0x2c,%esp
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	89 df                	mov    %ebx,%edi
  800f0e:	89 de                	mov    %ebx,%esi
  800f10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	7e 28                	jle    800f3e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f21:	00 
  800f22:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  800f29:	00 
  800f2a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f31:	00 
  800f32:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  800f39:	e8 de f2 ff ff       	call   80021c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f3e:	83 c4 2c             	add    $0x2c,%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4c:	be 00 00 00 00       	mov    $0x0,%esi
  800f51:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f62:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	57                   	push   %edi
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
  800f6f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f77:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7f:	89 cb                	mov    %ecx,%ebx
  800f81:	89 cf                	mov    %ecx,%edi
  800f83:	89 ce                	mov    %ecx,%esi
  800f85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f87:	85 c0                	test   %eax,%eax
  800f89:	7e 28                	jle    800fb3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f96:	00 
  800f97:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  800f9e:	00 
  800f9f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa6:	00 
  800fa7:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  800fae:	e8 69 f2 ff ff       	call   80021c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb3:	83 c4 2c             	add    $0x2c,%esp
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fcb:	89 d1                	mov    %edx,%ecx
  800fcd:	89 d3                	mov    %edx,%ebx
  800fcf:	89 d7                	mov    %edx,%edi
  800fd1:	89 d6                	mov    %edx,%esi
  800fd3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fd5:	5b                   	pop    %ebx
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
  800fe0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	89 df                	mov    %ebx,%edi
  800ff5:	89 de                	mov    %ebx,%esi
  800ff7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	7e 28                	jle    801025 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801001:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801008:	00 
  801009:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  801010:	00 
  801011:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801018:	00 
  801019:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  801020:	e8 f7 f1 ff ff       	call   80021c <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801025:	83 c4 2c             	add    $0x2c,%esp
  801028:	5b                   	pop    %ebx
  801029:	5e                   	pop    %esi
  80102a:	5f                   	pop    %edi
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	57                   	push   %edi
  801031:	56                   	push   %esi
  801032:	53                   	push   %ebx
  801033:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801036:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103b:	b8 10 00 00 00       	mov    $0x10,%eax
  801040:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801043:	8b 55 08             	mov    0x8(%ebp),%edx
  801046:	89 df                	mov    %ebx,%edi
  801048:	89 de                	mov    %ebx,%esi
  80104a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80104c:	85 c0                	test   %eax,%eax
  80104e:	7e 28                	jle    801078 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801050:	89 44 24 10          	mov    %eax,0x10(%esp)
  801054:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80105b:	00 
  80105c:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  801063:	00 
  801064:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80106b:	00 
  80106c:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  801073:	e8 a4 f1 ff ff       	call   80021c <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801078:	83 c4 2c             	add    $0x2c,%esp
  80107b:	5b                   	pop    %ebx
  80107c:	5e                   	pop    %esi
  80107d:	5f                   	pop    %edi
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    

00801080 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	57                   	push   %edi
  801084:	56                   	push   %esi
  801085:	53                   	push   %ebx
  801086:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801089:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108e:	b8 11 00 00 00       	mov    $0x11,%eax
  801093:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 df                	mov    %ebx,%edi
  80109b:	89 de                	mov    %ebx,%esi
  80109d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	7e 28                	jle    8010cb <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8010ae:	00 
  8010af:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  8010b6:	00 
  8010b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010be:	00 
  8010bf:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  8010c6:	e8 51 f1 ff ff       	call   80021c <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8010cb:	83 c4 2c             	add    $0x2c,%esp
  8010ce:	5b                   	pop    %ebx
  8010cf:	5e                   	pop    %esi
  8010d0:	5f                   	pop    %edi
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <sys_sleep>:

int
sys_sleep(int channel)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	57                   	push   %edi
  8010d7:	56                   	push   %esi
  8010d8:	53                   	push   %ebx
  8010d9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e1:	b8 12 00 00 00       	mov    $0x12,%eax
  8010e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e9:	89 cb                	mov    %ecx,%ebx
  8010eb:	89 cf                	mov    %ecx,%edi
  8010ed:	89 ce                	mov    %ecx,%esi
  8010ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	7e 28                	jle    80111d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801100:	00 
  801101:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  801108:	00 
  801109:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801110:	00 
  801111:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  801118:	e8 ff f0 ff ff       	call   80021c <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80111d:	83 c4 2c             	add    $0x2c,%esp
  801120:	5b                   	pop    %ebx
  801121:	5e                   	pop    %esi
  801122:	5f                   	pop    %edi
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	b8 13 00 00 00       	mov    $0x13,%eax
  801138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	89 df                	mov    %ebx,%edi
  801140:	89 de                	mov    %ebx,%esi
  801142:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801144:	85 c0                	test   %eax,%eax
  801146:	7e 28                	jle    801170 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801148:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801153:	00 
  801154:	c7 44 24 08 ab 37 80 	movl   $0x8037ab,0x8(%esp)
  80115b:	00 
  80115c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801163:	00 
  801164:	c7 04 24 c8 37 80 00 	movl   $0x8037c8,(%esp)
  80116b:	e8 ac f0 ff ff       	call   80021c <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801170:	83 c4 2c             	add    $0x2c,%esp
  801173:	5b                   	pop    %ebx
  801174:	5e                   	pop    %esi
  801175:	5f                   	pop    %edi
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    

00801178 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	53                   	push   %ebx
  80117c:	83 ec 24             	sub    $0x24,%esp
  80117f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801182:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801184:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801188:	74 27                	je     8011b1 <pgfault+0x39>
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	c1 ea 16             	shr    $0x16,%edx
  80118f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801196:	f6 c2 01             	test   $0x1,%dl
  801199:	74 16                	je     8011b1 <pgfault+0x39>
  80119b:	89 c2                	mov    %eax,%edx
  80119d:	c1 ea 0c             	shr    $0xc,%edx
  8011a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a7:	f7 d2                	not    %edx
  8011a9:	f7 c2 01 08 00 00    	test   $0x801,%edx
  8011af:	74 1c                	je     8011cd <pgfault+0x55>
		panic("pgfault");
  8011b1:	c7 44 24 08 d6 37 80 	movl   $0x8037d6,0x8(%esp)
  8011b8:	00 
  8011b9:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8011c0:	00 
  8011c1:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  8011c8:	e8 4f f0 ff ff       	call   80021c <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  8011cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d2:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  8011d4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011db:	00 
  8011dc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011e3:	00 
  8011e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011eb:	e8 63 fb ff ff       	call   800d53 <sys_page_alloc>
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	79 1c                	jns    801210 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  8011f4:	c7 44 24 08 e9 37 80 	movl   $0x8037e9,0x8(%esp)
  8011fb:	00 
  8011fc:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801203:	00 
  801204:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  80120b:	e8 0c f0 ff ff       	call   80021c <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801210:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801217:	00 
  801218:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80121c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801223:	e8 14 f9 ff ff       	call   800b3c <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801228:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80122f:	00 
  801230:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801234:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80123b:	00 
  80123c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801243:	00 
  801244:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80124b:	e8 57 fb ff ff       	call   800da7 <sys_page_map>
  801250:	85 c0                	test   %eax,%eax
  801252:	79 1c                	jns    801270 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  801254:	c7 44 24 08 03 38 80 	movl   $0x803803,0x8(%esp)
  80125b:	00 
  80125c:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801263:	00 
  801264:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  80126b:	e8 ac ef ff ff       	call   80021c <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801270:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801277:	00 
  801278:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127f:	e8 76 fb ff ff       	call   800dfa <sys_page_unmap>
  801284:	85 c0                	test   %eax,%eax
  801286:	79 1c                	jns    8012a4 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801288:	c7 44 24 08 1b 38 80 	movl   $0x80381b,0x8(%esp)
  80128f:	00 
  801290:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801297:	00 
  801298:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  80129f:	e8 78 ef ff ff       	call   80021c <_panic>
	}
}
  8012a4:	83 c4 24             	add    $0x24,%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    

008012aa <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  8012b3:	c7 04 24 78 11 80 00 	movl   $0x801178,(%esp)
  8012ba:	e8 37 1c 00 00       	call   802ef6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8012bf:	b8 07 00 00 00       	mov    $0x7,%eax
  8012c4:	cd 30                	int    $0x30
  8012c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	79 1c                	jns    8012e9 <fork+0x3f>
		panic("fork(): sys_exofork");
  8012cd:	c7 44 24 08 35 38 80 	movl   $0x803835,0x8(%esp)
  8012d4:	00 
  8012d5:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8012dc:	00 
  8012dd:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  8012e4:	e8 33 ef ff ff       	call   80021c <_panic>
  8012e9:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  8012eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012ef:	74 0a                	je     8012fb <fork+0x51>
  8012f1:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8012f6:	e9 9d 01 00 00       	jmp    801498 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  8012fb:	e8 15 fa ff ff       	call   800d15 <sys_getenvid>
  801300:	25 ff 03 00 00       	and    $0x3ff,%eax
  801305:	89 c2                	mov    %eax,%edx
  801307:	c1 e2 07             	shl    $0x7,%edx
  80130a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801311:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  801316:	e9 2a 02 00 00       	jmp    801545 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80131b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801321:	0f 84 6b 01 00 00    	je     801492 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801327:	89 d8                	mov    %ebx,%eax
  801329:	c1 e8 16             	shr    $0x16,%eax
  80132c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801333:	a8 01                	test   $0x1,%al
  801335:	0f 84 57 01 00 00    	je     801492 <fork+0x1e8>
  80133b:	89 d8                	mov    %ebx,%eax
  80133d:	c1 e8 0c             	shr    $0xc,%eax
  801340:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801347:	f7 d0                	not    %eax
  801349:	a8 05                	test   $0x5,%al
  80134b:	0f 85 41 01 00 00    	jne    801492 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  801351:	89 d8                	mov    %ebx,%eax
  801353:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  801356:	89 c6                	mov    %eax,%esi
  801358:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  80135b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801362:	f6 c6 04             	test   $0x4,%dh
  801365:	74 4c                	je     8013b3 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  801367:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80136e:	25 07 0e 00 00       	and    $0xe07,%eax
  801373:	89 44 24 10          	mov    %eax,0x10(%esp)
  801377:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80137b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80137f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801383:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80138a:	e8 18 fa ff ff       	call   800da7 <sys_page_map>
  80138f:	85 c0                	test   %eax,%eax
  801391:	0f 89 fb 00 00 00    	jns    801492 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801397:	c7 44 24 08 49 38 80 	movl   $0x803849,0x8(%esp)
  80139e:	00 
  80139f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8013a6:	00 
  8013a7:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  8013ae:	e8 69 ee ff ff       	call   80021c <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  8013b3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013ba:	f6 c6 08             	test   $0x8,%dh
  8013bd:	75 0f                	jne    8013ce <fork+0x124>
  8013bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013c6:	a8 02                	test   $0x2,%al
  8013c8:	0f 84 84 00 00 00    	je     801452 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  8013ce:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013d5:	00 
  8013d6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013da:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e9:	e8 b9 f9 ff ff       	call   800da7 <sys_page_map>
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	79 1c                	jns    80140e <fork+0x164>
			panic("duppage: sys_page_map");
  8013f2:	c7 44 24 08 49 38 80 	movl   $0x803849,0x8(%esp)
  8013f9:	00 
  8013fa:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801401:	00 
  801402:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  801409:	e8 0e ee ff ff       	call   80021c <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80140e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801415:	00 
  801416:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80141a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801421:	00 
  801422:	89 74 24 04          	mov    %esi,0x4(%esp)
  801426:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142d:	e8 75 f9 ff ff       	call   800da7 <sys_page_map>
  801432:	85 c0                	test   %eax,%eax
  801434:	79 5c                	jns    801492 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801436:	c7 44 24 08 49 38 80 	movl   $0x803849,0x8(%esp)
  80143d:	00 
  80143e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  801445:	00 
  801446:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  80144d:	e8 ca ed ff ff       	call   80021c <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  801452:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801459:	00 
  80145a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80145e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801462:	89 74 24 04          	mov    %esi,0x4(%esp)
  801466:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80146d:	e8 35 f9 ff ff       	call   800da7 <sys_page_map>
  801472:	85 c0                	test   %eax,%eax
  801474:	79 1c                	jns    801492 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801476:	c7 44 24 08 49 38 80 	movl   $0x803849,0x8(%esp)
  80147d:	00 
  80147e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801485:	00 
  801486:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  80148d:	e8 8a ed ff ff       	call   80021c <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801492:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801498:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80149e:	0f 85 77 fe ff ff    	jne    80131b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  8014a4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014ab:	00 
  8014ac:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014b3:	ee 
  8014b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b7:	89 04 24             	mov    %eax,(%esp)
  8014ba:	e8 94 f8 ff ff       	call   800d53 <sys_page_alloc>
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	79 1c                	jns    8014df <fork+0x235>
		panic("fork(): sys_page_alloc");
  8014c3:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  8014ca:	00 
  8014cb:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8014d2:	00 
  8014d3:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  8014da:	e8 3d ed ff ff       	call   80021c <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  8014df:	c7 44 24 04 7f 2f 80 	movl   $0x802f7f,0x4(%esp)
  8014e6:	00 
  8014e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ea:	89 04 24             	mov    %eax,(%esp)
  8014ed:	e8 01 fa ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	79 1c                	jns    801512 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  8014f6:	c7 44 24 08 a8 38 80 	movl   $0x8038a8,0x8(%esp)
  8014fd:	00 
  8014fe:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801505:	00 
  801506:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  80150d:	e8 0a ed ff ff       	call   80021c <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801512:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801519:	00 
  80151a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80151d:	89 04 24             	mov    %eax,(%esp)
  801520:	e8 28 f9 ff ff       	call   800e4d <sys_env_set_status>
  801525:	85 c0                	test   %eax,%eax
  801527:	79 1c                	jns    801545 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801529:	c7 44 24 08 76 38 80 	movl   $0x803876,0x8(%esp)
  801530:	00 
  801531:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801538:	00 
  801539:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  801540:	e8 d7 ec ff ff       	call   80021c <_panic>
	}

	return env_id;
}
  801545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801548:	83 c4 2c             	add    $0x2c,%esp
  80154b:	5b                   	pop    %ebx
  80154c:	5e                   	pop    %esi
  80154d:	5f                   	pop    %edi
  80154e:	5d                   	pop    %ebp
  80154f:	c3                   	ret    

00801550 <sfork>:

// Challenge!
int
sfork(void)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801556:	c7 44 24 08 91 38 80 	movl   $0x803891,0x8(%esp)
  80155d:	00 
  80155e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  801565:	00 
  801566:	c7 04 24 de 37 80 00 	movl   $0x8037de,(%esp)
  80156d:	e8 aa ec ff ff       	call   80021c <_panic>
  801572:	66 90                	xchg   %ax,%ax
  801574:	66 90                	xchg   %ax,%ax
  801576:	66 90                	xchg   %ax,%ax
  801578:	66 90                	xchg   %ax,%ax
  80157a:	66 90                	xchg   %ax,%ax
  80157c:	66 90                	xchg   %ax,%ax
  80157e:	66 90                	xchg   %ax,%ax

00801580 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	05 00 00 00 30       	add    $0x30000000,%eax
  80158b:	c1 e8 0c             	shr    $0xc,%eax
}
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80159b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    

008015a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ad:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015b2:	89 c2                	mov    %eax,%edx
  8015b4:	c1 ea 16             	shr    $0x16,%edx
  8015b7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015be:	f6 c2 01             	test   $0x1,%dl
  8015c1:	74 11                	je     8015d4 <fd_alloc+0x2d>
  8015c3:	89 c2                	mov    %eax,%edx
  8015c5:	c1 ea 0c             	shr    $0xc,%edx
  8015c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015cf:	f6 c2 01             	test   $0x1,%dl
  8015d2:	75 09                	jne    8015dd <fd_alloc+0x36>
			*fd_store = fd;
  8015d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015db:	eb 17                	jmp    8015f4 <fd_alloc+0x4d>
  8015dd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015e7:	75 c9                	jne    8015b2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015e9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015ef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015fc:	83 f8 1f             	cmp    $0x1f,%eax
  8015ff:	77 36                	ja     801637 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801601:	c1 e0 0c             	shl    $0xc,%eax
  801604:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801609:	89 c2                	mov    %eax,%edx
  80160b:	c1 ea 16             	shr    $0x16,%edx
  80160e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801615:	f6 c2 01             	test   $0x1,%dl
  801618:	74 24                	je     80163e <fd_lookup+0x48>
  80161a:	89 c2                	mov    %eax,%edx
  80161c:	c1 ea 0c             	shr    $0xc,%edx
  80161f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801626:	f6 c2 01             	test   $0x1,%dl
  801629:	74 1a                	je     801645 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80162b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162e:	89 02                	mov    %eax,(%edx)
	return 0;
  801630:	b8 00 00 00 00       	mov    $0x0,%eax
  801635:	eb 13                	jmp    80164a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801637:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80163c:	eb 0c                	jmp    80164a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80163e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801643:	eb 05                	jmp    80164a <fd_lookup+0x54>
  801645:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80164a:	5d                   	pop    %ebp
  80164b:	c3                   	ret    

0080164c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 18             	sub    $0x18,%esp
  801652:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801655:	ba 00 00 00 00       	mov    $0x0,%edx
  80165a:	eb 13                	jmp    80166f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80165c:	39 08                	cmp    %ecx,(%eax)
  80165e:	75 0c                	jne    80166c <dev_lookup+0x20>
			*dev = devtab[i];
  801660:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801663:	89 01                	mov    %eax,(%ecx)
			return 0;
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
  80166a:	eb 38                	jmp    8016a4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80166c:	83 c2 01             	add    $0x1,%edx
  80166f:	8b 04 95 48 39 80 00 	mov    0x803948(,%edx,4),%eax
  801676:	85 c0                	test   %eax,%eax
  801678:	75 e2                	jne    80165c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80167a:	a1 08 50 80 00       	mov    0x805008,%eax
  80167f:	8b 40 48             	mov    0x48(%eax),%eax
  801682:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801686:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168a:	c7 04 24 cc 38 80 00 	movl   $0x8038cc,(%esp)
  801691:	e8 7f ec ff ff       	call   800315 <cprintf>
	*dev = 0;
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80169f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	83 ec 20             	sub    $0x20,%esp
  8016ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8016b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016c1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016c4:	89 04 24             	mov    %eax,(%esp)
  8016c7:	e8 2a ff ff ff       	call   8015f6 <fd_lookup>
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 05                	js     8016d5 <fd_close+0x2f>
	    || fd != fd2)
  8016d0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016d3:	74 0c                	je     8016e1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016d5:	84 db                	test   %bl,%bl
  8016d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016dc:	0f 44 c2             	cmove  %edx,%eax
  8016df:	eb 3f                	jmp    801720 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e8:	8b 06                	mov    (%esi),%eax
  8016ea:	89 04 24             	mov    %eax,(%esp)
  8016ed:	e8 5a ff ff ff       	call   80164c <dev_lookup>
  8016f2:	89 c3                	mov    %eax,%ebx
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	78 16                	js     80170e <fd_close+0x68>
		if (dev->dev_close)
  8016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016fe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801703:	85 c0                	test   %eax,%eax
  801705:	74 07                	je     80170e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801707:	89 34 24             	mov    %esi,(%esp)
  80170a:	ff d0                	call   *%eax
  80170c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80170e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801712:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801719:	e8 dc f6 ff ff       	call   800dfa <sys_page_unmap>
	return r;
  80171e:	89 d8                	mov    %ebx,%eax
}
  801720:	83 c4 20             	add    $0x20,%esp
  801723:	5b                   	pop    %ebx
  801724:	5e                   	pop    %esi
  801725:	5d                   	pop    %ebp
  801726:	c3                   	ret    

00801727 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80172d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801730:	89 44 24 04          	mov    %eax,0x4(%esp)
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	89 04 24             	mov    %eax,(%esp)
  80173a:	e8 b7 fe ff ff       	call   8015f6 <fd_lookup>
  80173f:	89 c2                	mov    %eax,%edx
  801741:	85 d2                	test   %edx,%edx
  801743:	78 13                	js     801758 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801745:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80174c:	00 
  80174d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801750:	89 04 24             	mov    %eax,(%esp)
  801753:	e8 4e ff ff ff       	call   8016a6 <fd_close>
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <close_all>:

void
close_all(void)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	53                   	push   %ebx
  80175e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801761:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801766:	89 1c 24             	mov    %ebx,(%esp)
  801769:	e8 b9 ff ff ff       	call   801727 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80176e:	83 c3 01             	add    $0x1,%ebx
  801771:	83 fb 20             	cmp    $0x20,%ebx
  801774:	75 f0                	jne    801766 <close_all+0xc>
		close(i);
}
  801776:	83 c4 14             	add    $0x14,%esp
  801779:	5b                   	pop    %ebx
  80177a:	5d                   	pop    %ebp
  80177b:	c3                   	ret    

0080177c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	57                   	push   %edi
  801780:	56                   	push   %esi
  801781:	53                   	push   %ebx
  801782:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801785:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	89 04 24             	mov    %eax,(%esp)
  801792:	e8 5f fe ff ff       	call   8015f6 <fd_lookup>
  801797:	89 c2                	mov    %eax,%edx
  801799:	85 d2                	test   %edx,%edx
  80179b:	0f 88 e1 00 00 00    	js     801882 <dup+0x106>
		return r;
	close(newfdnum);
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	89 04 24             	mov    %eax,(%esp)
  8017a7:	e8 7b ff ff ff       	call   801727 <close>

	newfd = INDEX2FD(newfdnum);
  8017ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017af:	c1 e3 0c             	shl    $0xc,%ebx
  8017b2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017bb:	89 04 24             	mov    %eax,(%esp)
  8017be:	e8 cd fd ff ff       	call   801590 <fd2data>
  8017c3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017c5:	89 1c 24             	mov    %ebx,(%esp)
  8017c8:	e8 c3 fd ff ff       	call   801590 <fd2data>
  8017cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017cf:	89 f0                	mov    %esi,%eax
  8017d1:	c1 e8 16             	shr    $0x16,%eax
  8017d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017db:	a8 01                	test   $0x1,%al
  8017dd:	74 43                	je     801822 <dup+0xa6>
  8017df:	89 f0                	mov    %esi,%eax
  8017e1:	c1 e8 0c             	shr    $0xc,%eax
  8017e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017eb:	f6 c2 01             	test   $0x1,%dl
  8017ee:	74 32                	je     801822 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801800:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801804:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80180b:	00 
  80180c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801810:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801817:	e8 8b f5 ff ff       	call   800da7 <sys_page_map>
  80181c:	89 c6                	mov    %eax,%esi
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 3e                	js     801860 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801825:	89 c2                	mov    %eax,%edx
  801827:	c1 ea 0c             	shr    $0xc,%edx
  80182a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801831:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801837:	89 54 24 10          	mov    %edx,0x10(%esp)
  80183b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80183f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801846:	00 
  801847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801852:	e8 50 f5 ff ff       	call   800da7 <sys_page_map>
  801857:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801859:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80185c:	85 f6                	test   %esi,%esi
  80185e:	79 22                	jns    801882 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801860:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801864:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80186b:	e8 8a f5 ff ff       	call   800dfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801870:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801874:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80187b:	e8 7a f5 ff ff       	call   800dfa <sys_page_unmap>
	return r;
  801880:	89 f0                	mov    %esi,%eax
}
  801882:	83 c4 3c             	add    $0x3c,%esp
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5f                   	pop    %edi
  801888:	5d                   	pop    %ebp
  801889:	c3                   	ret    

0080188a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	53                   	push   %ebx
  80188e:	83 ec 24             	sub    $0x24,%esp
  801891:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801894:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189b:	89 1c 24             	mov    %ebx,(%esp)
  80189e:	e8 53 fd ff ff       	call   8015f6 <fd_lookup>
  8018a3:	89 c2                	mov    %eax,%edx
  8018a5:	85 d2                	test   %edx,%edx
  8018a7:	78 6d                	js     801916 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	89 04 24             	mov    %eax,(%esp)
  8018b8:	e8 8f fd ff ff       	call   80164c <dev_lookup>
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	78 55                	js     801916 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c4:	8b 50 08             	mov    0x8(%eax),%edx
  8018c7:	83 e2 03             	and    $0x3,%edx
  8018ca:	83 fa 01             	cmp    $0x1,%edx
  8018cd:	75 23                	jne    8018f2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8018d4:	8b 40 48             	mov    0x48(%eax),%eax
  8018d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018df:	c7 04 24 0d 39 80 00 	movl   $0x80390d,(%esp)
  8018e6:	e8 2a ea ff ff       	call   800315 <cprintf>
		return -E_INVAL;
  8018eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f0:	eb 24                	jmp    801916 <read+0x8c>
	}
	if (!dev->dev_read)
  8018f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f5:	8b 52 08             	mov    0x8(%edx),%edx
  8018f8:	85 d2                	test   %edx,%edx
  8018fa:	74 15                	je     801911 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801903:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801906:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80190a:	89 04 24             	mov    %eax,(%esp)
  80190d:	ff d2                	call   *%edx
  80190f:	eb 05                	jmp    801916 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801911:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801916:	83 c4 24             	add    $0x24,%esp
  801919:	5b                   	pop    %ebx
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	57                   	push   %edi
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
  801922:	83 ec 1c             	sub    $0x1c,%esp
  801925:	8b 7d 08             	mov    0x8(%ebp),%edi
  801928:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80192b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801930:	eb 23                	jmp    801955 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801932:	89 f0                	mov    %esi,%eax
  801934:	29 d8                	sub    %ebx,%eax
  801936:	89 44 24 08          	mov    %eax,0x8(%esp)
  80193a:	89 d8                	mov    %ebx,%eax
  80193c:	03 45 0c             	add    0xc(%ebp),%eax
  80193f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801943:	89 3c 24             	mov    %edi,(%esp)
  801946:	e8 3f ff ff ff       	call   80188a <read>
		if (m < 0)
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 10                	js     80195f <readn+0x43>
			return m;
		if (m == 0)
  80194f:	85 c0                	test   %eax,%eax
  801951:	74 0a                	je     80195d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801953:	01 c3                	add    %eax,%ebx
  801955:	39 f3                	cmp    %esi,%ebx
  801957:	72 d9                	jb     801932 <readn+0x16>
  801959:	89 d8                	mov    %ebx,%eax
  80195b:	eb 02                	jmp    80195f <readn+0x43>
  80195d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80195f:	83 c4 1c             	add    $0x1c,%esp
  801962:	5b                   	pop    %ebx
  801963:	5e                   	pop    %esi
  801964:	5f                   	pop    %edi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	53                   	push   %ebx
  80196b:	83 ec 24             	sub    $0x24,%esp
  80196e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801971:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801974:	89 44 24 04          	mov    %eax,0x4(%esp)
  801978:	89 1c 24             	mov    %ebx,(%esp)
  80197b:	e8 76 fc ff ff       	call   8015f6 <fd_lookup>
  801980:	89 c2                	mov    %eax,%edx
  801982:	85 d2                	test   %edx,%edx
  801984:	78 68                	js     8019ee <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801986:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801989:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801990:	8b 00                	mov    (%eax),%eax
  801992:	89 04 24             	mov    %eax,(%esp)
  801995:	e8 b2 fc ff ff       	call   80164c <dev_lookup>
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 50                	js     8019ee <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80199e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019a5:	75 23                	jne    8019ca <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8019ac:	8b 40 48             	mov    0x48(%eax),%eax
  8019af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b7:	c7 04 24 29 39 80 00 	movl   $0x803929,(%esp)
  8019be:	e8 52 e9 ff ff       	call   800315 <cprintf>
		return -E_INVAL;
  8019c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019c8:	eb 24                	jmp    8019ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8019d0:	85 d2                	test   %edx,%edx
  8019d2:	74 15                	je     8019e9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019e2:	89 04 24             	mov    %eax,(%esp)
  8019e5:	ff d2                	call   *%edx
  8019e7:	eb 05                	jmp    8019ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019ee:	83 c4 24             	add    $0x24,%esp
  8019f1:	5b                   	pop    %ebx
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	89 04 24             	mov    %eax,(%esp)
  801a07:	e8 ea fb ff ff       	call   8015f6 <fd_lookup>
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	78 0e                	js     801a1e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a16:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	53                   	push   %ebx
  801a24:	83 ec 24             	sub    $0x24,%esp
  801a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a31:	89 1c 24             	mov    %ebx,(%esp)
  801a34:	e8 bd fb ff ff       	call   8015f6 <fd_lookup>
  801a39:	89 c2                	mov    %eax,%edx
  801a3b:	85 d2                	test   %edx,%edx
  801a3d:	78 61                	js     801aa0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a49:	8b 00                	mov    (%eax),%eax
  801a4b:	89 04 24             	mov    %eax,(%esp)
  801a4e:	e8 f9 fb ff ff       	call   80164c <dev_lookup>
  801a53:	85 c0                	test   %eax,%eax
  801a55:	78 49                	js     801aa0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a5e:	75 23                	jne    801a83 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a60:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a65:	8b 40 48             	mov    0x48(%eax),%eax
  801a68:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a70:	c7 04 24 ec 38 80 00 	movl   $0x8038ec,(%esp)
  801a77:	e8 99 e8 ff ff       	call   800315 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a81:	eb 1d                	jmp    801aa0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a86:	8b 52 18             	mov    0x18(%edx),%edx
  801a89:	85 d2                	test   %edx,%edx
  801a8b:	74 0e                	je     801a9b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a90:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a94:	89 04 24             	mov    %eax,(%esp)
  801a97:	ff d2                	call   *%edx
  801a99:	eb 05                	jmp    801aa0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a9b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801aa0:	83 c4 24             	add    $0x24,%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5d                   	pop    %ebp
  801aa5:	c3                   	ret    

00801aa6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	53                   	push   %ebx
  801aaa:	83 ec 24             	sub    $0x24,%esp
  801aad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	89 04 24             	mov    %eax,(%esp)
  801abd:	e8 34 fb ff ff       	call   8015f6 <fd_lookup>
  801ac2:	89 c2                	mov    %eax,%edx
  801ac4:	85 d2                	test   %edx,%edx
  801ac6:	78 52                	js     801b1a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ac8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad2:	8b 00                	mov    (%eax),%eax
  801ad4:	89 04 24             	mov    %eax,(%esp)
  801ad7:	e8 70 fb ff ff       	call   80164c <dev_lookup>
  801adc:	85 c0                	test   %eax,%eax
  801ade:	78 3a                	js     801b1a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ae7:	74 2c                	je     801b15 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ae9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801af3:	00 00 00 
	stat->st_isdir = 0;
  801af6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801afd:	00 00 00 
	stat->st_dev = dev;
  801b00:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b0d:	89 14 24             	mov    %edx,(%esp)
  801b10:	ff 50 14             	call   *0x14(%eax)
  801b13:	eb 05                	jmp    801b1a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b15:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b1a:	83 c4 24             	add    $0x24,%esp
  801b1d:	5b                   	pop    %ebx
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    

00801b20 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	56                   	push   %esi
  801b24:	53                   	push   %ebx
  801b25:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b2f:	00 
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	89 04 24             	mov    %eax,(%esp)
  801b36:	e8 1b 02 00 00       	call   801d56 <open>
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	85 db                	test   %ebx,%ebx
  801b3f:	78 1b                	js     801b5c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b48:	89 1c 24             	mov    %ebx,(%esp)
  801b4b:	e8 56 ff ff ff       	call   801aa6 <fstat>
  801b50:	89 c6                	mov    %eax,%esi
	close(fd);
  801b52:	89 1c 24             	mov    %ebx,(%esp)
  801b55:	e8 cd fb ff ff       	call   801727 <close>
	return r;
  801b5a:	89 f0                	mov    %esi,%eax
}
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	5b                   	pop    %ebx
  801b60:	5e                   	pop    %esi
  801b61:	5d                   	pop    %ebp
  801b62:	c3                   	ret    

00801b63 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	83 ec 10             	sub    $0x10,%esp
  801b6b:	89 c6                	mov    %eax,%esi
  801b6d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b6f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b76:	75 11                	jne    801b89 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b7f:	e8 eb 14 00 00       	call   80306f <ipc_find_env>
  801b84:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b89:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b90:	00 
  801b91:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b98:	00 
  801b99:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b9d:	a1 00 50 80 00       	mov    0x805000,%eax
  801ba2:	89 04 24             	mov    %eax,(%esp)
  801ba5:	e8 5a 14 00 00       	call   803004 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801baa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bb1:	00 
  801bb2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bb6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bbd:	e8 ee 13 00 00       	call   802fb0 <ipc_recv>
}
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	5b                   	pop    %ebx
  801bc6:	5e                   	pop    %esi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801be2:	ba 00 00 00 00       	mov    $0x0,%edx
  801be7:	b8 02 00 00 00       	mov    $0x2,%eax
  801bec:	e8 72 ff ff ff       	call   801b63 <fsipc>
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bff:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c04:	ba 00 00 00 00       	mov    $0x0,%edx
  801c09:	b8 06 00 00 00       	mov    $0x6,%eax
  801c0e:	e8 50 ff ff ff       	call   801b63 <fsipc>
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	53                   	push   %ebx
  801c19:	83 ec 14             	sub    $0x14,%esp
  801c1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	8b 40 0c             	mov    0xc(%eax),%eax
  801c25:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c34:	e8 2a ff ff ff       	call   801b63 <fsipc>
  801c39:	89 c2                	mov    %eax,%edx
  801c3b:	85 d2                	test   %edx,%edx
  801c3d:	78 2b                	js     801c6a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c3f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c46:	00 
  801c47:	89 1c 24             	mov    %ebx,(%esp)
  801c4a:	e8 e8 ec ff ff       	call   800937 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c4f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c54:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c5a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c5f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6a:	83 c4 14             	add    $0x14,%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    

00801c70 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 18             	sub    $0x18,%esp
  801c76:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c79:	8b 55 08             	mov    0x8(%ebp),%edx
  801c7c:	8b 52 0c             	mov    0xc(%edx),%edx
  801c7f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801c85:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c95:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c9c:	e8 9b ee ff ff       	call   800b3c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca6:	b8 04 00 00 00       	mov    $0x4,%eax
  801cab:	e8 b3 fe ff ff       	call   801b63 <fsipc>
		return r;
	}

	return r;
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	56                   	push   %esi
  801cb6:	53                   	push   %ebx
  801cb7:	83 ec 10             	sub    $0x10,%esp
  801cba:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cc8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cce:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd3:	b8 03 00 00 00       	mov    $0x3,%eax
  801cd8:	e8 86 fe ff ff       	call   801b63 <fsipc>
  801cdd:	89 c3                	mov    %eax,%ebx
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 6a                	js     801d4d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ce3:	39 c6                	cmp    %eax,%esi
  801ce5:	73 24                	jae    801d0b <devfile_read+0x59>
  801ce7:	c7 44 24 0c 5c 39 80 	movl   $0x80395c,0xc(%esp)
  801cee:	00 
  801cef:	c7 44 24 08 63 39 80 	movl   $0x803963,0x8(%esp)
  801cf6:	00 
  801cf7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801cfe:	00 
  801cff:	c7 04 24 78 39 80 00 	movl   $0x803978,(%esp)
  801d06:	e8 11 e5 ff ff       	call   80021c <_panic>
	assert(r <= PGSIZE);
  801d0b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d10:	7e 24                	jle    801d36 <devfile_read+0x84>
  801d12:	c7 44 24 0c 83 39 80 	movl   $0x803983,0xc(%esp)
  801d19:	00 
  801d1a:	c7 44 24 08 63 39 80 	movl   $0x803963,0x8(%esp)
  801d21:	00 
  801d22:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d29:	00 
  801d2a:	c7 04 24 78 39 80 00 	movl   $0x803978,(%esp)
  801d31:	e8 e6 e4 ff ff       	call   80021c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d3a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d41:	00 
  801d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d45:	89 04 24             	mov    %eax,(%esp)
  801d48:	e8 87 ed ff ff       	call   800ad4 <memmove>
	return r;
}
  801d4d:	89 d8                	mov    %ebx,%eax
  801d4f:	83 c4 10             	add    $0x10,%esp
  801d52:	5b                   	pop    %ebx
  801d53:	5e                   	pop    %esi
  801d54:	5d                   	pop    %ebp
  801d55:	c3                   	ret    

00801d56 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	53                   	push   %ebx
  801d5a:	83 ec 24             	sub    $0x24,%esp
  801d5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d60:	89 1c 24             	mov    %ebx,(%esp)
  801d63:	e8 98 eb ff ff       	call   800900 <strlen>
  801d68:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d6d:	7f 60                	jg     801dcf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d72:	89 04 24             	mov    %eax,(%esp)
  801d75:	e8 2d f8 ff ff       	call   8015a7 <fd_alloc>
  801d7a:	89 c2                	mov    %eax,%edx
  801d7c:	85 d2                	test   %edx,%edx
  801d7e:	78 54                	js     801dd4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d80:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d84:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d8b:	e8 a7 eb ff ff       	call   800937 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d93:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801da0:	e8 be fd ff ff       	call   801b63 <fsipc>
  801da5:	89 c3                	mov    %eax,%ebx
  801da7:	85 c0                	test   %eax,%eax
  801da9:	79 17                	jns    801dc2 <open+0x6c>
		fd_close(fd, 0);
  801dab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801db2:	00 
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	89 04 24             	mov    %eax,(%esp)
  801db9:	e8 e8 f8 ff ff       	call   8016a6 <fd_close>
		return r;
  801dbe:	89 d8                	mov    %ebx,%eax
  801dc0:	eb 12                	jmp    801dd4 <open+0x7e>
	}

	return fd2num(fd);
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	89 04 24             	mov    %eax,(%esp)
  801dc8:	e8 b3 f7 ff ff       	call   801580 <fd2num>
  801dcd:	eb 05                	jmp    801dd4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801dcf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801dd4:	83 c4 24             	add    $0x24,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    

00801dda <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801de0:	ba 00 00 00 00       	mov    $0x0,%edx
  801de5:	b8 08 00 00 00       	mov    $0x8,%eax
  801dea:	e8 74 fd ff ff       	call   801b63 <fsipc>
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    
  801df1:	66 90                	xchg   %ax,%ax
  801df3:	66 90                	xchg   %ax,%ax
  801df5:	66 90                	xchg   %ax,%ax
  801df7:	66 90                	xchg   %ax,%ax
  801df9:	66 90                	xchg   %ax,%ax
  801dfb:	66 90                	xchg   %ax,%ax
  801dfd:	66 90                	xchg   %ax,%ax
  801dff:	90                   	nop

00801e00 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	57                   	push   %edi
  801e04:	56                   	push   %esi
  801e05:	53                   	push   %ebx
  801e06:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801e0c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e13:	00 
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	89 04 24             	mov    %eax,(%esp)
  801e1a:	e8 37 ff ff ff       	call   801d56 <open>
  801e1f:	89 c1                	mov    %eax,%ecx
  801e21:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801e27:	85 c0                	test   %eax,%eax
  801e29:	0f 88 fd 04 00 00    	js     80232c <spawn+0x52c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801e2f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801e36:	00 
  801e37:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e41:	89 0c 24             	mov    %ecx,(%esp)
  801e44:	e8 d3 fa ff ff       	call   80191c <readn>
  801e49:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e4e:	75 0c                	jne    801e5c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801e50:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801e57:	45 4c 46 
  801e5a:	74 36                	je     801e92 <spawn+0x92>
		close(fd);
  801e5c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e62:	89 04 24             	mov    %eax,(%esp)
  801e65:	e8 bd f8 ff ff       	call   801727 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e6a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801e71:	46 
  801e72:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7c:	c7 04 24 8f 39 80 00 	movl   $0x80398f,(%esp)
  801e83:	e8 8d e4 ff ff       	call   800315 <cprintf>
		return -E_NOT_EXEC;
  801e88:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801e8d:	e9 4a 05 00 00       	jmp    8023dc <spawn+0x5dc>
  801e92:	b8 07 00 00 00       	mov    $0x7,%eax
  801e97:	cd 30                	int    $0x30
  801e99:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801e9f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	0f 88 8a 04 00 00    	js     802337 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801ead:	25 ff 03 00 00       	and    $0x3ff,%eax
  801eb2:	89 c2                	mov    %eax,%edx
  801eb4:	c1 e2 07             	shl    $0x7,%edx
  801eb7:	8d b4 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%esi
  801ebe:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801ec4:	b9 11 00 00 00       	mov    $0x11,%ecx
  801ec9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801ecb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801ed1:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ed7:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801edc:	be 00 00 00 00       	mov    $0x0,%esi
  801ee1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ee4:	eb 0f                	jmp    801ef5 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801ee6:	89 04 24             	mov    %eax,(%esp)
  801ee9:	e8 12 ea ff ff       	call   800900 <strlen>
  801eee:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ef2:	83 c3 01             	add    $0x1,%ebx
  801ef5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801efc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	75 e3                	jne    801ee6 <spawn+0xe6>
  801f03:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801f09:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801f0f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801f14:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801f16:	89 fa                	mov    %edi,%edx
  801f18:	83 e2 fc             	and    $0xfffffffc,%edx
  801f1b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801f22:	29 c2                	sub    %eax,%edx
  801f24:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801f2a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801f2d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801f32:	0f 86 15 04 00 00    	jbe    80234d <spawn+0x54d>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f38:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f3f:	00 
  801f40:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f47:	00 
  801f48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4f:	e8 ff ed ff ff       	call   800d53 <sys_page_alloc>
  801f54:	85 c0                	test   %eax,%eax
  801f56:	0f 88 80 04 00 00    	js     8023dc <spawn+0x5dc>
  801f5c:	be 00 00 00 00       	mov    $0x0,%esi
  801f61:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801f67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f6a:	eb 30                	jmp    801f9c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801f6c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f72:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801f78:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801f7b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f82:	89 3c 24             	mov    %edi,(%esp)
  801f85:	e8 ad e9 ff ff       	call   800937 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801f8a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801f8d:	89 04 24             	mov    %eax,(%esp)
  801f90:	e8 6b e9 ff ff       	call   800900 <strlen>
  801f95:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801f99:	83 c6 01             	add    $0x1,%esi
  801f9c:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801fa2:	7f c8                	jg     801f6c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801fa4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801faa:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801fb0:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801fb7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801fbd:	74 24                	je     801fe3 <spawn+0x1e3>
  801fbf:	c7 44 24 0c 1c 3a 80 	movl   $0x803a1c,0xc(%esp)
  801fc6:	00 
  801fc7:	c7 44 24 08 63 39 80 	movl   $0x803963,0x8(%esp)
  801fce:	00 
  801fcf:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801fd6:	00 
  801fd7:	c7 04 24 a9 39 80 00 	movl   $0x8039a9,(%esp)
  801fde:	e8 39 e2 ff ff       	call   80021c <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801fe3:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801fe9:	89 c8                	mov    %ecx,%eax
  801feb:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801ff0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801ff3:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801ff9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ffc:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802002:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802008:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80200f:	00 
  802010:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802017:	ee 
  802018:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80201e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802022:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802029:	00 
  80202a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802031:	e8 71 ed ff ff       	call   800da7 <sys_page_map>
  802036:	89 c3                	mov    %eax,%ebx
  802038:	85 c0                	test   %eax,%eax
  80203a:	0f 88 86 03 00 00    	js     8023c6 <spawn+0x5c6>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802040:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802047:	00 
  802048:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80204f:	e8 a6 ed ff ff       	call   800dfa <sys_page_unmap>
  802054:	89 c3                	mov    %eax,%ebx
  802056:	85 c0                	test   %eax,%eax
  802058:	0f 88 68 03 00 00    	js     8023c6 <spawn+0x5c6>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80205e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802064:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80206b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802071:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802078:	00 00 00 
  80207b:	e9 b6 01 00 00       	jmp    802236 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  802080:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802086:	83 38 01             	cmpl   $0x1,(%eax)
  802089:	0f 85 99 01 00 00    	jne    802228 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80208f:	89 c1                	mov    %eax,%ecx
  802091:	8b 40 18             	mov    0x18(%eax),%eax
  802094:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802097:	83 f8 01             	cmp    $0x1,%eax
  80209a:	19 c0                	sbb    %eax,%eax
  80209c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8020a2:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  8020a9:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8020b0:	89 c8                	mov    %ecx,%eax
  8020b2:	8b 49 04             	mov    0x4(%ecx),%ecx
  8020b5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8020bb:	8b 48 10             	mov    0x10(%eax),%ecx
  8020be:	89 8d 94 fd ff ff    	mov    %ecx,-0x26c(%ebp)
  8020c4:	8b 50 14             	mov    0x14(%eax),%edx
  8020c7:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  8020cd:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8020d0:	89 f0                	mov    %esi,%eax
  8020d2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8020d7:	74 14                	je     8020ed <spawn+0x2ed>
		va -= i;
  8020d9:	29 c6                	sub    %eax,%esi
		memsz += i;
  8020db:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  8020e1:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  8020e7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8020ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020f2:	e9 23 01 00 00       	jmp    80221a <spawn+0x41a>
		if (i >= filesz) {
  8020f7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8020fd:	77 2b                	ja     80212a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8020ff:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802105:	89 44 24 08          	mov    %eax,0x8(%esp)
  802109:	89 74 24 04          	mov    %esi,0x4(%esp)
  80210d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802113:	89 04 24             	mov    %eax,(%esp)
  802116:	e8 38 ec ff ff       	call   800d53 <sys_page_alloc>
  80211b:	85 c0                	test   %eax,%eax
  80211d:	0f 89 eb 00 00 00    	jns    80220e <spawn+0x40e>
  802123:	89 c3                	mov    %eax,%ebx
  802125:	e9 37 02 00 00       	jmp    802361 <spawn+0x561>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80212a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802131:	00 
  802132:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802139:	00 
  80213a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802141:	e8 0d ec ff ff       	call   800d53 <sys_page_alloc>
  802146:	85 c0                	test   %eax,%eax
  802148:	0f 88 09 02 00 00    	js     802357 <spawn+0x557>
  80214e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802154:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802156:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802160:	89 04 24             	mov    %eax,(%esp)
  802163:	e8 8c f8 ff ff       	call   8019f4 <seek>
  802168:	85 c0                	test   %eax,%eax
  80216a:	0f 88 eb 01 00 00    	js     80235b <spawn+0x55b>
  802170:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802176:	29 f9                	sub    %edi,%ecx
  802178:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80217a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802180:	ba 00 10 00 00       	mov    $0x1000,%edx
  802185:	0f 47 c2             	cmova  %edx,%eax
  802188:	89 44 24 08          	mov    %eax,0x8(%esp)
  80218c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802193:	00 
  802194:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80219a:	89 04 24             	mov    %eax,(%esp)
  80219d:	e8 7a f7 ff ff       	call   80191c <readn>
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	0f 88 b5 01 00 00    	js     80235f <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8021aa:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8021b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8021b4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8021b8:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8021be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021c9:	00 
  8021ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d1:	e8 d1 eb ff ff       	call   800da7 <sys_page_map>
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	79 20                	jns    8021fa <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  8021da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021de:	c7 44 24 08 b5 39 80 	movl   $0x8039b5,0x8(%esp)
  8021e5:	00 
  8021e6:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  8021ed:	00 
  8021ee:	c7 04 24 a9 39 80 00 	movl   $0x8039a9,(%esp)
  8021f5:	e8 22 e0 ff ff       	call   80021c <_panic>
			sys_page_unmap(0, UTEMP);
  8021fa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802201:	00 
  802202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802209:	e8 ec eb ff ff       	call   800dfa <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80220e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802214:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80221a:	89 df                	mov    %ebx,%edi
  80221c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802222:	0f 87 cf fe ff ff    	ja     8020f7 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802228:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  80222f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802236:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80223d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  802243:	0f 8c 37 fe ff ff    	jl     802080 <spawn+0x280>
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	
	close(fd);
  802249:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80224f:	89 04 24             	mov    %eax,(%esp)
  802252:	e8 d0 f4 ff ff       	call   801727 <close>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  802257:	bb 00 00 00 00       	mov    $0x0,%ebx
  80225c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
		if(((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_SHARE))
  802262:	89 d8                	mov    %ebx,%eax
  802264:	c1 e8 16             	shr    $0x16,%eax
  802267:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80226e:	a8 01                	test   $0x1,%al
  802270:	74 4d                	je     8022bf <spawn+0x4bf>
  802272:	89 d8                	mov    %ebx,%eax
  802274:	c1 e8 0c             	shr    $0xc,%eax
  802277:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80227e:	f6 c2 01             	test   $0x1,%dl
  802281:	74 3c                	je     8022bf <spawn+0x4bf>
  802283:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80228a:	f6 c6 04             	test   $0x4,%dh
  80228d:	74 30                	je     8022bf <spawn+0x4bf>
		&& ((r = sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)]&PTE_SYSCALL)) < 0)){
  80228f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802296:	25 07 0e 00 00       	and    $0xe07,%eax
  80229b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80229f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b2:	e8 f0 ea ff ff       	call   800da7 <sys_page_map>
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	0f 88 e7 00 00 00    	js     8023a6 <spawn+0x5a6>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  8022bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8022c5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8022cb:	75 95                	jne    802262 <spawn+0x462>
  8022cd:	e9 af 00 00 00       	jmp    802381 <spawn+0x581>
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  8022d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022d6:	c7 44 24 08 d2 39 80 	movl   $0x8039d2,0x8(%esp)
  8022dd:	00 
  8022de:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  8022e5:	00 
  8022e6:	c7 04 24 a9 39 80 00 	movl   $0x8039a9,(%esp)
  8022ed:	e8 2a df ff ff       	call   80021c <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8022f2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8022f9:	00 
  8022fa:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802300:	89 04 24             	mov    %eax,(%esp)
  802303:	e8 45 eb ff ff       	call   800e4d <sys_env_set_status>
  802308:	85 c0                	test   %eax,%eax
  80230a:	79 36                	jns    802342 <spawn+0x542>
		panic("sys_env_set_status: %e", r);
  80230c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802310:	c7 44 24 08 ec 39 80 	movl   $0x8039ec,0x8(%esp)
  802317:	00 
  802318:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  80231f:	00 
  802320:	c7 04 24 a9 39 80 00 	movl   $0x8039a9,(%esp)
  802327:	e8 f0 de ff ff       	call   80021c <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  80232c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802332:	e9 a5 00 00 00       	jmp    8023dc <spawn+0x5dc>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802337:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80233d:	e9 9a 00 00 00       	jmp    8023dc <spawn+0x5dc>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  802342:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802348:	e9 8f 00 00 00       	jmp    8023dc <spawn+0x5dc>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  80234d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802352:	e9 85 00 00 00       	jmp    8023dc <spawn+0x5dc>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802357:	89 c3                	mov    %eax,%ebx
  802359:	eb 06                	jmp    802361 <spawn+0x561>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80235b:	89 c3                	mov    %eax,%ebx
  80235d:	eb 02                	jmp    802361 <spawn+0x561>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80235f:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802361:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802367:	89 04 24             	mov    %eax,(%esp)
  80236a:	e8 54 e9 ff ff       	call   800cc3 <sys_env_destroy>
	close(fd);
  80236f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802375:	89 04 24             	mov    %eax,(%esp)
  802378:	e8 aa f3 ff ff       	call   801727 <close>
	return r;
  80237d:	89 d8                	mov    %ebx,%eax
  80237f:	eb 5b                	jmp    8023dc <spawn+0x5dc>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802381:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802391:	89 04 24             	mov    %eax,(%esp)
  802394:	e8 07 eb ff ff       	call   800ea0 <sys_env_set_trapframe>
  802399:	85 c0                	test   %eax,%eax
  80239b:	0f 89 51 ff ff ff    	jns    8022f2 <spawn+0x4f2>
  8023a1:	e9 2c ff ff ff       	jmp    8022d2 <spawn+0x4d2>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  8023a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023aa:	c7 44 24 08 03 3a 80 	movl   $0x803a03,0x8(%esp)
  8023b1:	00 
  8023b2:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  8023b9:	00 
  8023ba:	c7 04 24 a9 39 80 00 	movl   $0x8039a9,(%esp)
  8023c1:	e8 56 de ff ff       	call   80021c <_panic>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8023c6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023cd:	00 
  8023ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d5:	e8 20 ea ff ff       	call   800dfa <sys_page_unmap>
  8023da:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8023dc:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8023e2:	5b                   	pop    %ebx
  8023e3:	5e                   	pop    %esi
  8023e4:	5f                   	pop    %edi
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    

008023e7 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	56                   	push   %esi
  8023eb:	53                   	push   %ebx
  8023ec:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8023ef:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8023f2:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8023f7:	eb 03                	jmp    8023fc <spawnl+0x15>
		argc++;
  8023f9:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8023fc:	83 c0 04             	add    $0x4,%eax
  8023ff:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802403:	75 f4                	jne    8023f9 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802405:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  80240c:	83 e0 f0             	and    $0xfffffff0,%eax
  80240f:	29 c4                	sub    %eax,%esp
  802411:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802415:	c1 e8 02             	shr    $0x2,%eax
  802418:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80241f:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802421:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802424:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  80242b:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  802432:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	eb 0a                	jmp    802444 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  80243a:	83 c0 01             	add    $0x1,%eax
  80243d:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802441:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802444:	39 d0                	cmp    %edx,%eax
  802446:	75 f2                	jne    80243a <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802448:	89 74 24 04          	mov    %esi,0x4(%esp)
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	89 04 24             	mov    %eax,(%esp)
  802452:	e8 a9 f9 ff ff       	call   801e00 <spawn>
}
  802457:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80245a:	5b                   	pop    %ebx
  80245b:	5e                   	pop    %esi
  80245c:	5d                   	pop    %ebp
  80245d:	c3                   	ret    
  80245e:	66 90                	xchg   %ax,%ax

00802460 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802466:	c7 44 24 04 42 3a 80 	movl   $0x803a42,0x4(%esp)
  80246d:	00 
  80246e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802471:	89 04 24             	mov    %eax,(%esp)
  802474:	e8 be e4 ff ff       	call   800937 <strcpy>
	return 0;
}
  802479:	b8 00 00 00 00       	mov    $0x0,%eax
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	53                   	push   %ebx
  802484:	83 ec 14             	sub    $0x14,%esp
  802487:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80248a:	89 1c 24             	mov    %ebx,(%esp)
  80248d:	e8 1c 0c 00 00       	call   8030ae <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802492:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802497:	83 f8 01             	cmp    $0x1,%eax
  80249a:	75 0d                	jne    8024a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80249c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80249f:	89 04 24             	mov    %eax,(%esp)
  8024a2:	e8 29 03 00 00       	call   8027d0 <nsipc_close>
  8024a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8024a9:	89 d0                	mov    %edx,%eax
  8024ab:	83 c4 14             	add    $0x14,%esp
  8024ae:	5b                   	pop    %ebx
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    

008024b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8024b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024be:	00 
  8024bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d3:	89 04 24             	mov    %eax,(%esp)
  8024d6:	e8 f0 03 00 00       	call   8028cb <nsipc_send>
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8024e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024ea:	00 
  8024eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	89 04 24             	mov    %eax,(%esp)
  802502:	e8 44 03 00 00       	call   80284b <nsipc_recv>
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80250f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802512:	89 54 24 04          	mov    %edx,0x4(%esp)
  802516:	89 04 24             	mov    %eax,(%esp)
  802519:	e8 d8 f0 ff ff       	call   8015f6 <fd_lookup>
  80251e:	85 c0                	test   %eax,%eax
  802520:	78 17                	js     802539 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  80252b:	39 08                	cmp    %ecx,(%eax)
  80252d:	75 05                	jne    802534 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80252f:	8b 40 0c             	mov    0xc(%eax),%eax
  802532:	eb 05                	jmp    802539 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802534:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	56                   	push   %esi
  80253f:	53                   	push   %ebx
  802540:	83 ec 20             	sub    $0x20,%esp
  802543:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802545:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802548:	89 04 24             	mov    %eax,(%esp)
  80254b:	e8 57 f0 ff ff       	call   8015a7 <fd_alloc>
  802550:	89 c3                	mov    %eax,%ebx
  802552:	85 c0                	test   %eax,%eax
  802554:	78 21                	js     802577 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802556:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80255d:	00 
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	89 44 24 04          	mov    %eax,0x4(%esp)
  802565:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80256c:	e8 e2 e7 ff ff       	call   800d53 <sys_page_alloc>
  802571:	89 c3                	mov    %eax,%ebx
  802573:	85 c0                	test   %eax,%eax
  802575:	79 0c                	jns    802583 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802577:	89 34 24             	mov    %esi,(%esp)
  80257a:	e8 51 02 00 00       	call   8027d0 <nsipc_close>
		return r;
  80257f:	89 d8                	mov    %ebx,%eax
  802581:	eb 20                	jmp    8025a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802583:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80258e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802591:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802598:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80259b:	89 14 24             	mov    %edx,(%esp)
  80259e:	e8 dd ef ff ff       	call   801580 <fd2num>
}
  8025a3:	83 c4 20             	add    $0x20,%esp
  8025a6:	5b                   	pop    %ebx
  8025a7:	5e                   	pop    %esi
  8025a8:	5d                   	pop    %ebp
  8025a9:	c3                   	ret    

008025aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	e8 51 ff ff ff       	call   802509 <fd2sockid>
		return r;
  8025b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	78 23                	js     8025e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025be:	8b 55 10             	mov    0x10(%ebp),%edx
  8025c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025cc:	89 04 24             	mov    %eax,(%esp)
  8025cf:	e8 45 01 00 00       	call   802719 <nsipc_accept>
		return r;
  8025d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	78 07                	js     8025e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8025da:	e8 5c ff ff ff       	call   80253b <alloc_sockfd>
  8025df:	89 c1                	mov    %eax,%ecx
}
  8025e1:	89 c8                	mov    %ecx,%eax
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
  8025e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	e8 16 ff ff ff       	call   802509 <fd2sockid>
  8025f3:	89 c2                	mov    %eax,%edx
  8025f5:	85 d2                	test   %edx,%edx
  8025f7:	78 16                	js     80260f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8025f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8025fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802600:	8b 45 0c             	mov    0xc(%ebp),%eax
  802603:	89 44 24 04          	mov    %eax,0x4(%esp)
  802607:	89 14 24             	mov    %edx,(%esp)
  80260a:	e8 60 01 00 00       	call   80276f <nsipc_bind>
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <shutdown>:

int
shutdown(int s, int how)
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802617:	8b 45 08             	mov    0x8(%ebp),%eax
  80261a:	e8 ea fe ff ff       	call   802509 <fd2sockid>
  80261f:	89 c2                	mov    %eax,%edx
  802621:	85 d2                	test   %edx,%edx
  802623:	78 0f                	js     802634 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802625:	8b 45 0c             	mov    0xc(%ebp),%eax
  802628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262c:	89 14 24             	mov    %edx,(%esp)
  80262f:	e8 7a 01 00 00       	call   8027ae <nsipc_shutdown>
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	e8 c5 fe ff ff       	call   802509 <fd2sockid>
  802644:	89 c2                	mov    %eax,%edx
  802646:	85 d2                	test   %edx,%edx
  802648:	78 16                	js     802660 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80264a:	8b 45 10             	mov    0x10(%ebp),%eax
  80264d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802651:	8b 45 0c             	mov    0xc(%ebp),%eax
  802654:	89 44 24 04          	mov    %eax,0x4(%esp)
  802658:	89 14 24             	mov    %edx,(%esp)
  80265b:	e8 8a 01 00 00       	call   8027ea <nsipc_connect>
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <listen>:

int
listen(int s, int backlog)
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
  802665:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	e8 99 fe ff ff       	call   802509 <fd2sockid>
  802670:	89 c2                	mov    %eax,%edx
  802672:	85 d2                	test   %edx,%edx
  802674:	78 0f                	js     802685 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802676:	8b 45 0c             	mov    0xc(%ebp),%eax
  802679:	89 44 24 04          	mov    %eax,0x4(%esp)
  80267d:	89 14 24             	mov    %edx,(%esp)
  802680:	e8 a4 01 00 00       	call   802829 <nsipc_listen>
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80268d:	8b 45 10             	mov    0x10(%ebp),%eax
  802690:	89 44 24 08          	mov    %eax,0x8(%esp)
  802694:	8b 45 0c             	mov    0xc(%ebp),%eax
  802697:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	89 04 24             	mov    %eax,(%esp)
  8026a1:	e8 98 02 00 00       	call   80293e <nsipc_socket>
  8026a6:	89 c2                	mov    %eax,%edx
  8026a8:	85 d2                	test   %edx,%edx
  8026aa:	78 05                	js     8026b1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8026ac:	e8 8a fe ff ff       	call   80253b <alloc_sockfd>
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

008026b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
  8026b6:	53                   	push   %ebx
  8026b7:	83 ec 14             	sub    $0x14,%esp
  8026ba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8026bc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8026c3:	75 11                	jne    8026d6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8026c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8026cc:	e8 9e 09 00 00       	call   80306f <ipc_find_env>
  8026d1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8026d6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8026dd:	00 
  8026de:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8026e5:	00 
  8026e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026ea:	a1 04 50 80 00       	mov    0x805004,%eax
  8026ef:	89 04 24             	mov    %eax,(%esp)
  8026f2:	e8 0d 09 00 00       	call   803004 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8026f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026fe:	00 
  8026ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802706:	00 
  802707:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80270e:	e8 9d 08 00 00       	call   802fb0 <ipc_recv>
}
  802713:	83 c4 14             	add    $0x14,%esp
  802716:	5b                   	pop    %ebx
  802717:	5d                   	pop    %ebp
  802718:	c3                   	ret    

00802719 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	56                   	push   %esi
  80271d:	53                   	push   %ebx
  80271e:	83 ec 10             	sub    $0x10,%esp
  802721:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80272c:	8b 06                	mov    (%esi),%eax
  80272e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802733:	b8 01 00 00 00       	mov    $0x1,%eax
  802738:	e8 76 ff ff ff       	call   8026b3 <nsipc>
  80273d:	89 c3                	mov    %eax,%ebx
  80273f:	85 c0                	test   %eax,%eax
  802741:	78 23                	js     802766 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802743:	a1 10 70 80 00       	mov    0x807010,%eax
  802748:	89 44 24 08          	mov    %eax,0x8(%esp)
  80274c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802753:	00 
  802754:	8b 45 0c             	mov    0xc(%ebp),%eax
  802757:	89 04 24             	mov    %eax,(%esp)
  80275a:	e8 75 e3 ff ff       	call   800ad4 <memmove>
		*addrlen = ret->ret_addrlen;
  80275f:	a1 10 70 80 00       	mov    0x807010,%eax
  802764:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802766:	89 d8                	mov    %ebx,%eax
  802768:	83 c4 10             	add    $0x10,%esp
  80276b:	5b                   	pop    %ebx
  80276c:	5e                   	pop    %esi
  80276d:	5d                   	pop    %ebp
  80276e:	c3                   	ret    

0080276f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	53                   	push   %ebx
  802773:	83 ec 14             	sub    $0x14,%esp
  802776:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802781:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802785:	8b 45 0c             	mov    0xc(%ebp),%eax
  802788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802793:	e8 3c e3 ff ff       	call   800ad4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802798:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80279e:	b8 02 00 00 00       	mov    $0x2,%eax
  8027a3:	e8 0b ff ff ff       	call   8026b3 <nsipc>
}
  8027a8:	83 c4 14             	add    $0x14,%esp
  8027ab:	5b                   	pop    %ebx
  8027ac:	5d                   	pop    %ebp
  8027ad:	c3                   	ret    

008027ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8027bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027bf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8027c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8027c9:	e8 e5 fe ff ff       	call   8026b3 <nsipc>
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8027de:	b8 04 00 00 00       	mov    $0x4,%eax
  8027e3:	e8 cb fe ff ff       	call   8026b3 <nsipc>
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	53                   	push   %ebx
  8027ee:	83 ec 14             	sub    $0x14,%esp
  8027f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802800:	8b 45 0c             	mov    0xc(%ebp),%eax
  802803:	89 44 24 04          	mov    %eax,0x4(%esp)
  802807:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80280e:	e8 c1 e2 ff ff       	call   800ad4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802813:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802819:	b8 05 00 00 00       	mov    $0x5,%eax
  80281e:	e8 90 fe ff ff       	call   8026b3 <nsipc>
}
  802823:	83 c4 14             	add    $0x14,%esp
  802826:	5b                   	pop    %ebx
  802827:	5d                   	pop    %ebp
  802828:	c3                   	ret    

00802829 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
  80282c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80283a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80283f:	b8 06 00 00 00       	mov    $0x6,%eax
  802844:	e8 6a fe ff ff       	call   8026b3 <nsipc>
}
  802849:	c9                   	leave  
  80284a:	c3                   	ret    

0080284b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80284b:	55                   	push   %ebp
  80284c:	89 e5                	mov    %esp,%ebp
  80284e:	56                   	push   %esi
  80284f:	53                   	push   %ebx
  802850:	83 ec 10             	sub    $0x10,%esp
  802853:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80285e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802864:	8b 45 14             	mov    0x14(%ebp),%eax
  802867:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80286c:	b8 07 00 00 00       	mov    $0x7,%eax
  802871:	e8 3d fe ff ff       	call   8026b3 <nsipc>
  802876:	89 c3                	mov    %eax,%ebx
  802878:	85 c0                	test   %eax,%eax
  80287a:	78 46                	js     8028c2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80287c:	39 f0                	cmp    %esi,%eax
  80287e:	7f 07                	jg     802887 <nsipc_recv+0x3c>
  802880:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802885:	7e 24                	jle    8028ab <nsipc_recv+0x60>
  802887:	c7 44 24 0c 4e 3a 80 	movl   $0x803a4e,0xc(%esp)
  80288e:	00 
  80288f:	c7 44 24 08 63 39 80 	movl   $0x803963,0x8(%esp)
  802896:	00 
  802897:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80289e:	00 
  80289f:	c7 04 24 63 3a 80 00 	movl   $0x803a63,(%esp)
  8028a6:	e8 71 d9 ff ff       	call   80021c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8028ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028af:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8028b6:	00 
  8028b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ba:	89 04 24             	mov    %eax,(%esp)
  8028bd:	e8 12 e2 ff ff       	call   800ad4 <memmove>
	}

	return r;
}
  8028c2:	89 d8                	mov    %ebx,%eax
  8028c4:	83 c4 10             	add    $0x10,%esp
  8028c7:	5b                   	pop    %ebx
  8028c8:	5e                   	pop    %esi
  8028c9:	5d                   	pop    %ebp
  8028ca:	c3                   	ret    

008028cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	53                   	push   %ebx
  8028cf:	83 ec 14             	sub    $0x14,%esp
  8028d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8028dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8028e3:	7e 24                	jle    802909 <nsipc_send+0x3e>
  8028e5:	c7 44 24 0c 6f 3a 80 	movl   $0x803a6f,0xc(%esp)
  8028ec:	00 
  8028ed:	c7 44 24 08 63 39 80 	movl   $0x803963,0x8(%esp)
  8028f4:	00 
  8028f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8028fc:	00 
  8028fd:	c7 04 24 63 3a 80 00 	movl   $0x803a63,(%esp)
  802904:	e8 13 d9 ff ff       	call   80021c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802909:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80290d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802910:	89 44 24 04          	mov    %eax,0x4(%esp)
  802914:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80291b:	e8 b4 e1 ff ff       	call   800ad4 <memmove>
	nsipcbuf.send.req_size = size;
  802920:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802926:	8b 45 14             	mov    0x14(%ebp),%eax
  802929:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80292e:	b8 08 00 00 00       	mov    $0x8,%eax
  802933:	e8 7b fd ff ff       	call   8026b3 <nsipc>
}
  802938:	83 c4 14             	add    $0x14,%esp
  80293b:	5b                   	pop    %ebx
  80293c:	5d                   	pop    %ebp
  80293d:	c3                   	ret    

0080293e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
  802941:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80294c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802954:	8b 45 10             	mov    0x10(%ebp),%eax
  802957:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80295c:	b8 09 00 00 00       	mov    $0x9,%eax
  802961:	e8 4d fd ff ff       	call   8026b3 <nsipc>
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	56                   	push   %esi
  80296c:	53                   	push   %ebx
  80296d:	83 ec 10             	sub    $0x10,%esp
  802970:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	89 04 24             	mov    %eax,(%esp)
  802979:	e8 12 ec ff ff       	call   801590 <fd2data>
  80297e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802980:	c7 44 24 04 7b 3a 80 	movl   $0x803a7b,0x4(%esp)
  802987:	00 
  802988:	89 1c 24             	mov    %ebx,(%esp)
  80298b:	e8 a7 df ff ff       	call   800937 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802990:	8b 46 04             	mov    0x4(%esi),%eax
  802993:	2b 06                	sub    (%esi),%eax
  802995:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80299b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8029a2:	00 00 00 
	stat->st_dev = &devpipe;
  8029a5:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8029ac:	40 80 00 
	return 0;
}
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b4:	83 c4 10             	add    $0x10,%esp
  8029b7:	5b                   	pop    %ebx
  8029b8:	5e                   	pop    %esi
  8029b9:	5d                   	pop    %ebp
  8029ba:	c3                   	ret    

008029bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
  8029be:	53                   	push   %ebx
  8029bf:	83 ec 14             	sub    $0x14,%esp
  8029c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8029c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8029c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029d0:	e8 25 e4 ff ff       	call   800dfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8029d5:	89 1c 24             	mov    %ebx,(%esp)
  8029d8:	e8 b3 eb ff ff       	call   801590 <fd2data>
  8029dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029e8:	e8 0d e4 ff ff       	call   800dfa <sys_page_unmap>
}
  8029ed:	83 c4 14             	add    $0x14,%esp
  8029f0:	5b                   	pop    %ebx
  8029f1:	5d                   	pop    %ebp
  8029f2:	c3                   	ret    

008029f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8029f3:	55                   	push   %ebp
  8029f4:	89 e5                	mov    %esp,%ebp
  8029f6:	57                   	push   %edi
  8029f7:	56                   	push   %esi
  8029f8:	53                   	push   %ebx
  8029f9:	83 ec 2c             	sub    $0x2c,%esp
  8029fc:	89 c6                	mov    %eax,%esi
  8029fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802a01:	a1 08 50 80 00       	mov    0x805008,%eax
  802a06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802a09:	89 34 24             	mov    %esi,(%esp)
  802a0c:	e8 9d 06 00 00       	call   8030ae <pageref>
  802a11:	89 c7                	mov    %eax,%edi
  802a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a16:	89 04 24             	mov    %eax,(%esp)
  802a19:	e8 90 06 00 00       	call   8030ae <pageref>
  802a1e:	39 c7                	cmp    %eax,%edi
  802a20:	0f 94 c2             	sete   %dl
  802a23:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802a26:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  802a2c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802a2f:	39 fb                	cmp    %edi,%ebx
  802a31:	74 21                	je     802a54 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802a33:	84 d2                	test   %dl,%dl
  802a35:	74 ca                	je     802a01 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802a37:	8b 51 58             	mov    0x58(%ecx),%edx
  802a3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a46:	c7 04 24 82 3a 80 00 	movl   $0x803a82,(%esp)
  802a4d:	e8 c3 d8 ff ff       	call   800315 <cprintf>
  802a52:	eb ad                	jmp    802a01 <_pipeisclosed+0xe>
	}
}
  802a54:	83 c4 2c             	add    $0x2c,%esp
  802a57:	5b                   	pop    %ebx
  802a58:	5e                   	pop    %esi
  802a59:	5f                   	pop    %edi
  802a5a:	5d                   	pop    %ebp
  802a5b:	c3                   	ret    

00802a5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a5c:	55                   	push   %ebp
  802a5d:	89 e5                	mov    %esp,%ebp
  802a5f:	57                   	push   %edi
  802a60:	56                   	push   %esi
  802a61:	53                   	push   %ebx
  802a62:	83 ec 1c             	sub    $0x1c,%esp
  802a65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802a68:	89 34 24             	mov    %esi,(%esp)
  802a6b:	e8 20 eb ff ff       	call   801590 <fd2data>
  802a70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a72:	bf 00 00 00 00       	mov    $0x0,%edi
  802a77:	eb 45                	jmp    802abe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802a79:	89 da                	mov    %ebx,%edx
  802a7b:	89 f0                	mov    %esi,%eax
  802a7d:	e8 71 ff ff ff       	call   8029f3 <_pipeisclosed>
  802a82:	85 c0                	test   %eax,%eax
  802a84:	75 41                	jne    802ac7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802a86:	e8 a9 e2 ff ff       	call   800d34 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a8b:	8b 43 04             	mov    0x4(%ebx),%eax
  802a8e:	8b 0b                	mov    (%ebx),%ecx
  802a90:	8d 51 20             	lea    0x20(%ecx),%edx
  802a93:	39 d0                	cmp    %edx,%eax
  802a95:	73 e2                	jae    802a79 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802a9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802aa1:	99                   	cltd   
  802aa2:	c1 ea 1b             	shr    $0x1b,%edx
  802aa5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802aa8:	83 e1 1f             	and    $0x1f,%ecx
  802aab:	29 d1                	sub    %edx,%ecx
  802aad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802ab1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802ab5:	83 c0 01             	add    $0x1,%eax
  802ab8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802abb:	83 c7 01             	add    $0x1,%edi
  802abe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802ac1:	75 c8                	jne    802a8b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802ac3:	89 f8                	mov    %edi,%eax
  802ac5:	eb 05                	jmp    802acc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802ac7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802acc:	83 c4 1c             	add    $0x1c,%esp
  802acf:	5b                   	pop    %ebx
  802ad0:	5e                   	pop    %esi
  802ad1:	5f                   	pop    %edi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    

00802ad4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802ad4:	55                   	push   %ebp
  802ad5:	89 e5                	mov    %esp,%ebp
  802ad7:	57                   	push   %edi
  802ad8:	56                   	push   %esi
  802ad9:	53                   	push   %ebx
  802ada:	83 ec 1c             	sub    $0x1c,%esp
  802add:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802ae0:	89 3c 24             	mov    %edi,(%esp)
  802ae3:	e8 a8 ea ff ff       	call   801590 <fd2data>
  802ae8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802aea:	be 00 00 00 00       	mov    $0x0,%esi
  802aef:	eb 3d                	jmp    802b2e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802af1:	85 f6                	test   %esi,%esi
  802af3:	74 04                	je     802af9 <devpipe_read+0x25>
				return i;
  802af5:	89 f0                	mov    %esi,%eax
  802af7:	eb 43                	jmp    802b3c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802af9:	89 da                	mov    %ebx,%edx
  802afb:	89 f8                	mov    %edi,%eax
  802afd:	e8 f1 fe ff ff       	call   8029f3 <_pipeisclosed>
  802b02:	85 c0                	test   %eax,%eax
  802b04:	75 31                	jne    802b37 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802b06:	e8 29 e2 ff ff       	call   800d34 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802b0b:	8b 03                	mov    (%ebx),%eax
  802b0d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802b10:	74 df                	je     802af1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b12:	99                   	cltd   
  802b13:	c1 ea 1b             	shr    $0x1b,%edx
  802b16:	01 d0                	add    %edx,%eax
  802b18:	83 e0 1f             	and    $0x1f,%eax
  802b1b:	29 d0                	sub    %edx,%eax
  802b1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802b28:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b2b:	83 c6 01             	add    $0x1,%esi
  802b2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b31:	75 d8                	jne    802b0b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802b33:	89 f0                	mov    %esi,%eax
  802b35:	eb 05                	jmp    802b3c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802b37:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802b3c:	83 c4 1c             	add    $0x1c,%esp
  802b3f:	5b                   	pop    %ebx
  802b40:	5e                   	pop    %esi
  802b41:	5f                   	pop    %edi
  802b42:	5d                   	pop    %ebp
  802b43:	c3                   	ret    

00802b44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b44:	55                   	push   %ebp
  802b45:	89 e5                	mov    %esp,%ebp
  802b47:	56                   	push   %esi
  802b48:	53                   	push   %ebx
  802b49:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b4f:	89 04 24             	mov    %eax,(%esp)
  802b52:	e8 50 ea ff ff       	call   8015a7 <fd_alloc>
  802b57:	89 c2                	mov    %eax,%edx
  802b59:	85 d2                	test   %edx,%edx
  802b5b:	0f 88 4d 01 00 00    	js     802cae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b61:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b68:	00 
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b77:	e8 d7 e1 ff ff       	call   800d53 <sys_page_alloc>
  802b7c:	89 c2                	mov    %eax,%edx
  802b7e:	85 d2                	test   %edx,%edx
  802b80:	0f 88 28 01 00 00    	js     802cae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b89:	89 04 24             	mov    %eax,(%esp)
  802b8c:	e8 16 ea ff ff       	call   8015a7 <fd_alloc>
  802b91:	89 c3                	mov    %eax,%ebx
  802b93:	85 c0                	test   %eax,%eax
  802b95:	0f 88 fe 00 00 00    	js     802c99 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b9b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ba2:	00 
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802baa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bb1:	e8 9d e1 ff ff       	call   800d53 <sys_page_alloc>
  802bb6:	89 c3                	mov    %eax,%ebx
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	0f 88 d9 00 00 00    	js     802c99 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	89 04 24             	mov    %eax,(%esp)
  802bc6:	e8 c5 e9 ff ff       	call   801590 <fd2data>
  802bcb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bcd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802bd4:	00 
  802bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802be0:	e8 6e e1 ff ff       	call   800d53 <sys_page_alloc>
  802be5:	89 c3                	mov    %eax,%ebx
  802be7:	85 c0                	test   %eax,%eax
  802be9:	0f 88 97 00 00 00    	js     802c86 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	89 04 24             	mov    %eax,(%esp)
  802bf5:	e8 96 e9 ff ff       	call   801590 <fd2data>
  802bfa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802c01:	00 
  802c02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802c0d:	00 
  802c0e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c19:	e8 89 e1 ff ff       	call   800da7 <sys_page_map>
  802c1e:	89 c3                	mov    %eax,%ebx
  802c20:	85 c0                	test   %eax,%eax
  802c22:	78 52                	js     802c76 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802c24:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802c39:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c42:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	89 04 24             	mov    %eax,(%esp)
  802c54:	e8 27 e9 ff ff       	call   801580 <fd2num>
  802c59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c5c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	89 04 24             	mov    %eax,(%esp)
  802c64:	e8 17 e9 ff ff       	call   801580 <fd2num>
  802c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c6c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c74:	eb 38                	jmp    802cae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802c76:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c81:	e8 74 e1 ff ff       	call   800dfa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c94:	e8 61 e1 ff ff       	call   800dfa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ca0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ca7:	e8 4e e1 ff ff       	call   800dfa <sys_page_unmap>
  802cac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802cae:	83 c4 30             	add    $0x30,%esp
  802cb1:	5b                   	pop    %ebx
  802cb2:	5e                   	pop    %esi
  802cb3:	5d                   	pop    %ebp
  802cb4:	c3                   	ret    

00802cb5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802cb5:	55                   	push   %ebp
  802cb6:	89 e5                	mov    %esp,%ebp
  802cb8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	89 04 24             	mov    %eax,(%esp)
  802cc8:	e8 29 e9 ff ff       	call   8015f6 <fd_lookup>
  802ccd:	89 c2                	mov    %eax,%edx
  802ccf:	85 d2                	test   %edx,%edx
  802cd1:	78 15                	js     802ce8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	89 04 24             	mov    %eax,(%esp)
  802cd9:	e8 b2 e8 ff ff       	call   801590 <fd2data>
	return _pipeisclosed(fd, p);
  802cde:	89 c2                	mov    %eax,%edx
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	e8 0b fd ff ff       	call   8029f3 <_pipeisclosed>
}
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
  802ced:	56                   	push   %esi
  802cee:	53                   	push   %ebx
  802cef:	83 ec 10             	sub    $0x10,%esp
  802cf2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802cf5:	85 f6                	test   %esi,%esi
  802cf7:	75 24                	jne    802d1d <wait+0x33>
  802cf9:	c7 44 24 0c 9a 3a 80 	movl   $0x803a9a,0xc(%esp)
  802d00:	00 
  802d01:	c7 44 24 08 63 39 80 	movl   $0x803963,0x8(%esp)
  802d08:	00 
  802d09:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802d10:	00 
  802d11:	c7 04 24 a5 3a 80 00 	movl   $0x803aa5,(%esp)
  802d18:	e8 ff d4 ff ff       	call   80021c <_panic>
	e = &envs[ENVX(envid)];
  802d1d:	89 f0                	mov    %esi,%eax
  802d1f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802d24:	89 c2                	mov    %eax,%edx
  802d26:	c1 e2 07             	shl    $0x7,%edx
  802d29:	8d 9c 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802d30:	eb 05                	jmp    802d37 <wait+0x4d>
		sys_yield();
  802d32:	e8 fd df ff ff       	call   800d34 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802d37:	8b 43 48             	mov    0x48(%ebx),%eax
  802d3a:	39 f0                	cmp    %esi,%eax
  802d3c:	75 07                	jne    802d45 <wait+0x5b>
  802d3e:	8b 43 54             	mov    0x54(%ebx),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	75 ed                	jne    802d32 <wait+0x48>
		sys_yield();
}
  802d45:	83 c4 10             	add    $0x10,%esp
  802d48:	5b                   	pop    %ebx
  802d49:	5e                   	pop    %esi
  802d4a:	5d                   	pop    %ebp
  802d4b:	c3                   	ret    
  802d4c:	66 90                	xchg   %ax,%ax
  802d4e:	66 90                	xchg   %ax,%ax

00802d50 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802d53:	b8 00 00 00 00       	mov    $0x0,%eax
  802d58:	5d                   	pop    %ebp
  802d59:	c3                   	ret    

00802d5a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802d5a:	55                   	push   %ebp
  802d5b:	89 e5                	mov    %esp,%ebp
  802d5d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802d60:	c7 44 24 04 b0 3a 80 	movl   $0x803ab0,0x4(%esp)
  802d67:	00 
  802d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6b:	89 04 24             	mov    %eax,(%esp)
  802d6e:	e8 c4 db ff ff       	call   800937 <strcpy>
	return 0;
}
  802d73:	b8 00 00 00 00       	mov    $0x0,%eax
  802d78:	c9                   	leave  
  802d79:	c3                   	ret    

00802d7a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d7a:	55                   	push   %ebp
  802d7b:	89 e5                	mov    %esp,%ebp
  802d7d:	57                   	push   %edi
  802d7e:	56                   	push   %esi
  802d7f:	53                   	push   %ebx
  802d80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d86:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802d8b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d91:	eb 31                	jmp    802dc4 <devcons_write+0x4a>
		m = n - tot;
  802d93:	8b 75 10             	mov    0x10(%ebp),%esi
  802d96:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802d98:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802d9b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802da0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802da3:	89 74 24 08          	mov    %esi,0x8(%esp)
  802da7:	03 45 0c             	add    0xc(%ebp),%eax
  802daa:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dae:	89 3c 24             	mov    %edi,(%esp)
  802db1:	e8 1e dd ff ff       	call   800ad4 <memmove>
		sys_cputs(buf, m);
  802db6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dba:	89 3c 24             	mov    %edi,(%esp)
  802dbd:	e8 c4 de ff ff       	call   800c86 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802dc2:	01 f3                	add    %esi,%ebx
  802dc4:	89 d8                	mov    %ebx,%eax
  802dc6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802dc9:	72 c8                	jb     802d93 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802dcb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802dd1:	5b                   	pop    %ebx
  802dd2:	5e                   	pop    %esi
  802dd3:	5f                   	pop    %edi
  802dd4:	5d                   	pop    %ebp
  802dd5:	c3                   	ret    

00802dd6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802dd6:	55                   	push   %ebp
  802dd7:	89 e5                	mov    %esp,%ebp
  802dd9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802de1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802de5:	75 07                	jne    802dee <devcons_read+0x18>
  802de7:	eb 2a                	jmp    802e13 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802de9:	e8 46 df ff ff       	call   800d34 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802dee:	66 90                	xchg   %ax,%ax
  802df0:	e8 af de ff ff       	call   800ca4 <sys_cgetc>
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 f0                	je     802de9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802df9:	85 c0                	test   %eax,%eax
  802dfb:	78 16                	js     802e13 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802dfd:	83 f8 04             	cmp    $0x4,%eax
  802e00:	74 0c                	je     802e0e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e05:	88 02                	mov    %al,(%edx)
	return 1;
  802e07:	b8 01 00 00 00       	mov    $0x1,%eax
  802e0c:	eb 05                	jmp    802e13 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802e0e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802e13:	c9                   	leave  
  802e14:	c3                   	ret    

00802e15 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802e15:	55                   	push   %ebp
  802e16:	89 e5                	mov    %esp,%ebp
  802e18:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802e21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802e28:	00 
  802e29:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e2c:	89 04 24             	mov    %eax,(%esp)
  802e2f:	e8 52 de ff ff       	call   800c86 <sys_cputs>
}
  802e34:	c9                   	leave  
  802e35:	c3                   	ret    

00802e36 <getchar>:

int
getchar(void)
{
  802e36:	55                   	push   %ebp
  802e37:	89 e5                	mov    %esp,%ebp
  802e39:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802e3c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802e43:	00 
  802e44:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e47:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e52:	e8 33 ea ff ff       	call   80188a <read>
	if (r < 0)
  802e57:	85 c0                	test   %eax,%eax
  802e59:	78 0f                	js     802e6a <getchar+0x34>
		return r;
	if (r < 1)
  802e5b:	85 c0                	test   %eax,%eax
  802e5d:	7e 06                	jle    802e65 <getchar+0x2f>
		return -E_EOF;
	return c;
  802e5f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802e63:	eb 05                	jmp    802e6a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802e65:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802e6a:	c9                   	leave  
  802e6b:	c3                   	ret    

00802e6c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802e6c:	55                   	push   %ebp
  802e6d:	89 e5                	mov    %esp,%ebp
  802e6f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e75:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	89 04 24             	mov    %eax,(%esp)
  802e7f:	e8 72 e7 ff ff       	call   8015f6 <fd_lookup>
  802e84:	85 c0                	test   %eax,%eax
  802e86:	78 11                	js     802e99 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802e91:	39 10                	cmp    %edx,(%eax)
  802e93:	0f 94 c0             	sete   %al
  802e96:	0f b6 c0             	movzbl %al,%eax
}
  802e99:	c9                   	leave  
  802e9a:	c3                   	ret    

00802e9b <opencons>:

int
opencons(void)
{
  802e9b:	55                   	push   %ebp
  802e9c:	89 e5                	mov    %esp,%ebp
  802e9e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ea1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ea4:	89 04 24             	mov    %eax,(%esp)
  802ea7:	e8 fb e6 ff ff       	call   8015a7 <fd_alloc>
		return r;
  802eac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	78 40                	js     802ef2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802eb2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802eb9:	00 
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ec1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ec8:	e8 86 de ff ff       	call   800d53 <sys_page_alloc>
		return r;
  802ecd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	78 1f                	js     802ef2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802ed3:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ee8:	89 04 24             	mov    %eax,(%esp)
  802eeb:	e8 90 e6 ff ff       	call   801580 <fd2num>
  802ef0:	89 c2                	mov    %eax,%edx
}
  802ef2:	89 d0                	mov    %edx,%eax
  802ef4:	c9                   	leave  
  802ef5:	c3                   	ret    

00802ef6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
  802ef9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802efc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802f03:	75 70                	jne    802f75 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  802f05:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  802f0c:	00 
  802f0d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802f14:	ee 
  802f15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f1c:	e8 32 de ff ff       	call   800d53 <sys_page_alloc>
		if (error < 0)
  802f21:	85 c0                	test   %eax,%eax
  802f23:	79 1c                	jns    802f41 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  802f25:	c7 44 24 08 bc 3a 80 	movl   $0x803abc,0x8(%esp)
  802f2c:	00 
  802f2d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802f34:	00 
  802f35:	c7 04 24 0f 3b 80 00 	movl   $0x803b0f,(%esp)
  802f3c:	e8 db d2 ff ff       	call   80021c <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802f41:	c7 44 24 04 7f 2f 80 	movl   $0x802f7f,0x4(%esp)
  802f48:	00 
  802f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f50:	e8 9e df ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
		if (error < 0)
  802f55:	85 c0                	test   %eax,%eax
  802f57:	79 1c                	jns    802f75 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  802f59:	c7 44 24 08 e4 3a 80 	movl   $0x803ae4,0x8(%esp)
  802f60:	00 
  802f61:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802f68:	00 
  802f69:	c7 04 24 0f 3b 80 00 	movl   $0x803b0f,(%esp)
  802f70:	e8 a7 d2 ff ff       	call   80021c <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802f7d:	c9                   	leave  
  802f7e:	c3                   	ret    

00802f7f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802f7f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802f80:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802f85:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802f87:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  802f8a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  802f8e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802f93:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802f97:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802f99:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802f9c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802f9d:	83 c4 04             	add    $0x4,%esp
	popfl
  802fa0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802fa1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802fa2:	c3                   	ret    
  802fa3:	66 90                	xchg   %ax,%ax
  802fa5:	66 90                	xchg   %ax,%ax
  802fa7:	66 90                	xchg   %ax,%ax
  802fa9:	66 90                	xchg   %ax,%ax
  802fab:	66 90                	xchg   %ax,%ax
  802fad:	66 90                	xchg   %ax,%ax
  802faf:	90                   	nop

00802fb0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802fb0:	55                   	push   %ebp
  802fb1:	89 e5                	mov    %esp,%ebp
  802fb3:	56                   	push   %esi
  802fb4:	53                   	push   %ebx
  802fb5:	83 ec 10             	sub    $0x10,%esp
  802fb8:	8b 75 08             	mov    0x8(%ebp),%esi
  802fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802fc1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802fc3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802fc8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  802fcb:	89 04 24             	mov    %eax,(%esp)
  802fce:	e8 96 df ff ff       	call   800f69 <sys_ipc_recv>
  802fd3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802fd5:	85 d2                	test   %edx,%edx
  802fd7:	75 24                	jne    802ffd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802fd9:	85 f6                	test   %esi,%esi
  802fdb:	74 0a                	je     802fe7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  802fdd:	a1 08 50 80 00       	mov    0x805008,%eax
  802fe2:	8b 40 74             	mov    0x74(%eax),%eax
  802fe5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802fe7:	85 db                	test   %ebx,%ebx
  802fe9:	74 0a                	je     802ff5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  802feb:	a1 08 50 80 00       	mov    0x805008,%eax
  802ff0:	8b 40 78             	mov    0x78(%eax),%eax
  802ff3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802ff5:	a1 08 50 80 00       	mov    0x805008,%eax
  802ffa:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  802ffd:	83 c4 10             	add    $0x10,%esp
  803000:	5b                   	pop    %ebx
  803001:	5e                   	pop    %esi
  803002:	5d                   	pop    %ebp
  803003:	c3                   	ret    

00803004 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803004:	55                   	push   %ebp
  803005:	89 e5                	mov    %esp,%ebp
  803007:	57                   	push   %edi
  803008:	56                   	push   %esi
  803009:	53                   	push   %ebx
  80300a:	83 ec 1c             	sub    $0x1c,%esp
  80300d:	8b 7d 08             	mov    0x8(%ebp),%edi
  803010:	8b 75 0c             	mov    0xc(%ebp),%esi
  803013:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  803016:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  803018:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80301d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  803020:	8b 45 14             	mov    0x14(%ebp),%eax
  803023:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803027:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80302b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80302f:	89 3c 24             	mov    %edi,(%esp)
  803032:	e8 0f df ff ff       	call   800f46 <sys_ipc_try_send>

		if (ret == 0)
  803037:	85 c0                	test   %eax,%eax
  803039:	74 2c                	je     803067 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80303b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80303e:	74 20                	je     803060 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  803040:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803044:	c7 44 24 08 20 3b 80 	movl   $0x803b20,0x8(%esp)
  80304b:	00 
  80304c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  803053:	00 
  803054:	c7 04 24 50 3b 80 00 	movl   $0x803b50,(%esp)
  80305b:	e8 bc d1 ff ff       	call   80021c <_panic>
		}

		sys_yield();
  803060:	e8 cf dc ff ff       	call   800d34 <sys_yield>
	}
  803065:	eb b9                	jmp    803020 <ipc_send+0x1c>
}
  803067:	83 c4 1c             	add    $0x1c,%esp
  80306a:	5b                   	pop    %ebx
  80306b:	5e                   	pop    %esi
  80306c:	5f                   	pop    %edi
  80306d:	5d                   	pop    %ebp
  80306e:	c3                   	ret    

0080306f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80306f:	55                   	push   %ebp
  803070:	89 e5                	mov    %esp,%ebp
  803072:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80307a:	89 c2                	mov    %eax,%edx
  80307c:	c1 e2 07             	shl    $0x7,%edx
  80307f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  803086:	8b 52 50             	mov    0x50(%edx),%edx
  803089:	39 ca                	cmp    %ecx,%edx
  80308b:	75 11                	jne    80309e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80308d:	89 c2                	mov    %eax,%edx
  80308f:	c1 e2 07             	shl    $0x7,%edx
  803092:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  803099:	8b 40 40             	mov    0x40(%eax),%eax
  80309c:	eb 0e                	jmp    8030ac <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80309e:	83 c0 01             	add    $0x1,%eax
  8030a1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8030a6:	75 d2                	jne    80307a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8030a8:	66 b8 00 00          	mov    $0x0,%ax
}
  8030ac:	5d                   	pop    %ebp
  8030ad:	c3                   	ret    

008030ae <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8030ae:	55                   	push   %ebp
  8030af:	89 e5                	mov    %esp,%ebp
  8030b1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8030b4:	89 d0                	mov    %edx,%eax
  8030b6:	c1 e8 16             	shr    $0x16,%eax
  8030b9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8030c0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8030c5:	f6 c1 01             	test   $0x1,%cl
  8030c8:	74 1d                	je     8030e7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8030ca:	c1 ea 0c             	shr    $0xc,%edx
  8030cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8030d4:	f6 c2 01             	test   $0x1,%dl
  8030d7:	74 0e                	je     8030e7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8030d9:	c1 ea 0c             	shr    $0xc,%edx
  8030dc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8030e3:	ef 
  8030e4:	0f b7 c0             	movzwl %ax,%eax
}
  8030e7:	5d                   	pop    %ebp
  8030e8:	c3                   	ret    
  8030e9:	66 90                	xchg   %ax,%ax
  8030eb:	66 90                	xchg   %ax,%ax
  8030ed:	66 90                	xchg   %ax,%ax
  8030ef:	90                   	nop

008030f0 <__udivdi3>:
  8030f0:	55                   	push   %ebp
  8030f1:	57                   	push   %edi
  8030f2:	56                   	push   %esi
  8030f3:	83 ec 0c             	sub    $0xc,%esp
  8030f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8030fa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8030fe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803102:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803106:	85 c0                	test   %eax,%eax
  803108:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80310c:	89 ea                	mov    %ebp,%edx
  80310e:	89 0c 24             	mov    %ecx,(%esp)
  803111:	75 2d                	jne    803140 <__udivdi3+0x50>
  803113:	39 e9                	cmp    %ebp,%ecx
  803115:	77 61                	ja     803178 <__udivdi3+0x88>
  803117:	85 c9                	test   %ecx,%ecx
  803119:	89 ce                	mov    %ecx,%esi
  80311b:	75 0b                	jne    803128 <__udivdi3+0x38>
  80311d:	b8 01 00 00 00       	mov    $0x1,%eax
  803122:	31 d2                	xor    %edx,%edx
  803124:	f7 f1                	div    %ecx
  803126:	89 c6                	mov    %eax,%esi
  803128:	31 d2                	xor    %edx,%edx
  80312a:	89 e8                	mov    %ebp,%eax
  80312c:	f7 f6                	div    %esi
  80312e:	89 c5                	mov    %eax,%ebp
  803130:	89 f8                	mov    %edi,%eax
  803132:	f7 f6                	div    %esi
  803134:	89 ea                	mov    %ebp,%edx
  803136:	83 c4 0c             	add    $0xc,%esp
  803139:	5e                   	pop    %esi
  80313a:	5f                   	pop    %edi
  80313b:	5d                   	pop    %ebp
  80313c:	c3                   	ret    
  80313d:	8d 76 00             	lea    0x0(%esi),%esi
  803140:	39 e8                	cmp    %ebp,%eax
  803142:	77 24                	ja     803168 <__udivdi3+0x78>
  803144:	0f bd e8             	bsr    %eax,%ebp
  803147:	83 f5 1f             	xor    $0x1f,%ebp
  80314a:	75 3c                	jne    803188 <__udivdi3+0x98>
  80314c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803150:	39 34 24             	cmp    %esi,(%esp)
  803153:	0f 86 9f 00 00 00    	jbe    8031f8 <__udivdi3+0x108>
  803159:	39 d0                	cmp    %edx,%eax
  80315b:	0f 82 97 00 00 00    	jb     8031f8 <__udivdi3+0x108>
  803161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803168:	31 d2                	xor    %edx,%edx
  80316a:	31 c0                	xor    %eax,%eax
  80316c:	83 c4 0c             	add    $0xc,%esp
  80316f:	5e                   	pop    %esi
  803170:	5f                   	pop    %edi
  803171:	5d                   	pop    %ebp
  803172:	c3                   	ret    
  803173:	90                   	nop
  803174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803178:	89 f8                	mov    %edi,%eax
  80317a:	f7 f1                	div    %ecx
  80317c:	31 d2                	xor    %edx,%edx
  80317e:	83 c4 0c             	add    $0xc,%esp
  803181:	5e                   	pop    %esi
  803182:	5f                   	pop    %edi
  803183:	5d                   	pop    %ebp
  803184:	c3                   	ret    
  803185:	8d 76 00             	lea    0x0(%esi),%esi
  803188:	89 e9                	mov    %ebp,%ecx
  80318a:	8b 3c 24             	mov    (%esp),%edi
  80318d:	d3 e0                	shl    %cl,%eax
  80318f:	89 c6                	mov    %eax,%esi
  803191:	b8 20 00 00 00       	mov    $0x20,%eax
  803196:	29 e8                	sub    %ebp,%eax
  803198:	89 c1                	mov    %eax,%ecx
  80319a:	d3 ef                	shr    %cl,%edi
  80319c:	89 e9                	mov    %ebp,%ecx
  80319e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8031a2:	8b 3c 24             	mov    (%esp),%edi
  8031a5:	09 74 24 08          	or     %esi,0x8(%esp)
  8031a9:	89 d6                	mov    %edx,%esi
  8031ab:	d3 e7                	shl    %cl,%edi
  8031ad:	89 c1                	mov    %eax,%ecx
  8031af:	89 3c 24             	mov    %edi,(%esp)
  8031b2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8031b6:	d3 ee                	shr    %cl,%esi
  8031b8:	89 e9                	mov    %ebp,%ecx
  8031ba:	d3 e2                	shl    %cl,%edx
  8031bc:	89 c1                	mov    %eax,%ecx
  8031be:	d3 ef                	shr    %cl,%edi
  8031c0:	09 d7                	or     %edx,%edi
  8031c2:	89 f2                	mov    %esi,%edx
  8031c4:	89 f8                	mov    %edi,%eax
  8031c6:	f7 74 24 08          	divl   0x8(%esp)
  8031ca:	89 d6                	mov    %edx,%esi
  8031cc:	89 c7                	mov    %eax,%edi
  8031ce:	f7 24 24             	mull   (%esp)
  8031d1:	39 d6                	cmp    %edx,%esi
  8031d3:	89 14 24             	mov    %edx,(%esp)
  8031d6:	72 30                	jb     803208 <__udivdi3+0x118>
  8031d8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031dc:	89 e9                	mov    %ebp,%ecx
  8031de:	d3 e2                	shl    %cl,%edx
  8031e0:	39 c2                	cmp    %eax,%edx
  8031e2:	73 05                	jae    8031e9 <__udivdi3+0xf9>
  8031e4:	3b 34 24             	cmp    (%esp),%esi
  8031e7:	74 1f                	je     803208 <__udivdi3+0x118>
  8031e9:	89 f8                	mov    %edi,%eax
  8031eb:	31 d2                	xor    %edx,%edx
  8031ed:	e9 7a ff ff ff       	jmp    80316c <__udivdi3+0x7c>
  8031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8031f8:	31 d2                	xor    %edx,%edx
  8031fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ff:	e9 68 ff ff ff       	jmp    80316c <__udivdi3+0x7c>
  803204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803208:	8d 47 ff             	lea    -0x1(%edi),%eax
  80320b:	31 d2                	xor    %edx,%edx
  80320d:	83 c4 0c             	add    $0xc,%esp
  803210:	5e                   	pop    %esi
  803211:	5f                   	pop    %edi
  803212:	5d                   	pop    %ebp
  803213:	c3                   	ret    
  803214:	66 90                	xchg   %ax,%ax
  803216:	66 90                	xchg   %ax,%ax
  803218:	66 90                	xchg   %ax,%ax
  80321a:	66 90                	xchg   %ax,%ax
  80321c:	66 90                	xchg   %ax,%ax
  80321e:	66 90                	xchg   %ax,%ax

00803220 <__umoddi3>:
  803220:	55                   	push   %ebp
  803221:	57                   	push   %edi
  803222:	56                   	push   %esi
  803223:	83 ec 14             	sub    $0x14,%esp
  803226:	8b 44 24 28          	mov    0x28(%esp),%eax
  80322a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80322e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803232:	89 c7                	mov    %eax,%edi
  803234:	89 44 24 04          	mov    %eax,0x4(%esp)
  803238:	8b 44 24 30          	mov    0x30(%esp),%eax
  80323c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803240:	89 34 24             	mov    %esi,(%esp)
  803243:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803247:	85 c0                	test   %eax,%eax
  803249:	89 c2                	mov    %eax,%edx
  80324b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80324f:	75 17                	jne    803268 <__umoddi3+0x48>
  803251:	39 fe                	cmp    %edi,%esi
  803253:	76 4b                	jbe    8032a0 <__umoddi3+0x80>
  803255:	89 c8                	mov    %ecx,%eax
  803257:	89 fa                	mov    %edi,%edx
  803259:	f7 f6                	div    %esi
  80325b:	89 d0                	mov    %edx,%eax
  80325d:	31 d2                	xor    %edx,%edx
  80325f:	83 c4 14             	add    $0x14,%esp
  803262:	5e                   	pop    %esi
  803263:	5f                   	pop    %edi
  803264:	5d                   	pop    %ebp
  803265:	c3                   	ret    
  803266:	66 90                	xchg   %ax,%ax
  803268:	39 f8                	cmp    %edi,%eax
  80326a:	77 54                	ja     8032c0 <__umoddi3+0xa0>
  80326c:	0f bd e8             	bsr    %eax,%ebp
  80326f:	83 f5 1f             	xor    $0x1f,%ebp
  803272:	75 5c                	jne    8032d0 <__umoddi3+0xb0>
  803274:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803278:	39 3c 24             	cmp    %edi,(%esp)
  80327b:	0f 87 e7 00 00 00    	ja     803368 <__umoddi3+0x148>
  803281:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803285:	29 f1                	sub    %esi,%ecx
  803287:	19 c7                	sbb    %eax,%edi
  803289:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80328d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803291:	8b 44 24 08          	mov    0x8(%esp),%eax
  803295:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803299:	83 c4 14             	add    $0x14,%esp
  80329c:	5e                   	pop    %esi
  80329d:	5f                   	pop    %edi
  80329e:	5d                   	pop    %ebp
  80329f:	c3                   	ret    
  8032a0:	85 f6                	test   %esi,%esi
  8032a2:	89 f5                	mov    %esi,%ebp
  8032a4:	75 0b                	jne    8032b1 <__umoddi3+0x91>
  8032a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ab:	31 d2                	xor    %edx,%edx
  8032ad:	f7 f6                	div    %esi
  8032af:	89 c5                	mov    %eax,%ebp
  8032b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032b5:	31 d2                	xor    %edx,%edx
  8032b7:	f7 f5                	div    %ebp
  8032b9:	89 c8                	mov    %ecx,%eax
  8032bb:	f7 f5                	div    %ebp
  8032bd:	eb 9c                	jmp    80325b <__umoddi3+0x3b>
  8032bf:	90                   	nop
  8032c0:	89 c8                	mov    %ecx,%eax
  8032c2:	89 fa                	mov    %edi,%edx
  8032c4:	83 c4 14             	add    $0x14,%esp
  8032c7:	5e                   	pop    %esi
  8032c8:	5f                   	pop    %edi
  8032c9:	5d                   	pop    %ebp
  8032ca:	c3                   	ret    
  8032cb:	90                   	nop
  8032cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8032d0:	8b 04 24             	mov    (%esp),%eax
  8032d3:	be 20 00 00 00       	mov    $0x20,%esi
  8032d8:	89 e9                	mov    %ebp,%ecx
  8032da:	29 ee                	sub    %ebp,%esi
  8032dc:	d3 e2                	shl    %cl,%edx
  8032de:	89 f1                	mov    %esi,%ecx
  8032e0:	d3 e8                	shr    %cl,%eax
  8032e2:	89 e9                	mov    %ebp,%ecx
  8032e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032e8:	8b 04 24             	mov    (%esp),%eax
  8032eb:	09 54 24 04          	or     %edx,0x4(%esp)
  8032ef:	89 fa                	mov    %edi,%edx
  8032f1:	d3 e0                	shl    %cl,%eax
  8032f3:	89 f1                	mov    %esi,%ecx
  8032f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8032f9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8032fd:	d3 ea                	shr    %cl,%edx
  8032ff:	89 e9                	mov    %ebp,%ecx
  803301:	d3 e7                	shl    %cl,%edi
  803303:	89 f1                	mov    %esi,%ecx
  803305:	d3 e8                	shr    %cl,%eax
  803307:	89 e9                	mov    %ebp,%ecx
  803309:	09 f8                	or     %edi,%eax
  80330b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80330f:	f7 74 24 04          	divl   0x4(%esp)
  803313:	d3 e7                	shl    %cl,%edi
  803315:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803319:	89 d7                	mov    %edx,%edi
  80331b:	f7 64 24 08          	mull   0x8(%esp)
  80331f:	39 d7                	cmp    %edx,%edi
  803321:	89 c1                	mov    %eax,%ecx
  803323:	89 14 24             	mov    %edx,(%esp)
  803326:	72 2c                	jb     803354 <__umoddi3+0x134>
  803328:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80332c:	72 22                	jb     803350 <__umoddi3+0x130>
  80332e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803332:	29 c8                	sub    %ecx,%eax
  803334:	19 d7                	sbb    %edx,%edi
  803336:	89 e9                	mov    %ebp,%ecx
  803338:	89 fa                	mov    %edi,%edx
  80333a:	d3 e8                	shr    %cl,%eax
  80333c:	89 f1                	mov    %esi,%ecx
  80333e:	d3 e2                	shl    %cl,%edx
  803340:	89 e9                	mov    %ebp,%ecx
  803342:	d3 ef                	shr    %cl,%edi
  803344:	09 d0                	or     %edx,%eax
  803346:	89 fa                	mov    %edi,%edx
  803348:	83 c4 14             	add    $0x14,%esp
  80334b:	5e                   	pop    %esi
  80334c:	5f                   	pop    %edi
  80334d:	5d                   	pop    %ebp
  80334e:	c3                   	ret    
  80334f:	90                   	nop
  803350:	39 d7                	cmp    %edx,%edi
  803352:	75 da                	jne    80332e <__umoddi3+0x10e>
  803354:	8b 14 24             	mov    (%esp),%edx
  803357:	89 c1                	mov    %eax,%ecx
  803359:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80335d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803361:	eb cb                	jmp    80332e <__umoddi3+0x10e>
  803363:	90                   	nop
  803364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803368:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80336c:	0f 82 0f ff ff ff    	jb     803281 <__umoddi3+0x61>
  803372:	e9 1a ff ff ff       	jmp    803291 <__umoddi3+0x71>
