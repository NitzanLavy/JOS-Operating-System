
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 e5 00 00 00       	call   800116 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	unsigned now = sys_time_msec();
  800047:	e8 cf 0e 00 00       	call   800f1b <sys_time_msec>
	unsigned end = now + sec * 1000;
  80004c:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800053:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800055:	83 f8 ee             	cmp    $0xffffffee,%eax
  800058:	7c 29                	jl     800083 <sleep+0x43>
  80005a:	89 c2                	mov    %eax,%edx
  80005c:	c1 ea 1f             	shr    $0x1f,%edx
  80005f:	84 d2                	test   %dl,%dl
  800061:	74 20                	je     800083 <sleep+0x43>
		panic("sys_time_msec: %e", (int)now);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 80 27 80 	movl   $0x802780,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 92 27 80 00 	movl   $0x802792,(%esp)
  80007e:	e8 f8 00 00 00       	call   80017b <_panic>
	if (end < now)
  800083:	39 d8                	cmp    %ebx,%eax
  800085:	76 21                	jbe    8000a8 <sleep+0x68>
		panic("sleep: wrap");
  800087:	c7 44 24 08 a2 27 80 	movl   $0x8027a2,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 92 27 80 00 	movl   $0x802792,(%esp)
  80009e:	e8 d8 00 00 00       	call   80017b <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  8000a3:	e8 ec 0b 00 00       	call   800c94 <sys_yield>
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000a8:	e8 6e 0e 00 00       	call   800f1b <sys_time_msec>
  8000ad:	39 c3                	cmp    %eax,%ebx
  8000af:	90                   	nop
  8000b0:	77 f1                	ja     8000a3 <sleep+0x63>
		sys_yield();
}
  8000b2:	83 c4 14             	add    $0x14,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 14             	sub    $0x14,%esp
  8000bf:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  8000c4:	e8 cb 0b 00 00       	call   800c94 <sys_yield>
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  8000c9:	83 eb 01             	sub    $0x1,%ebx
  8000cc:	75 f6                	jne    8000c4 <umain+0xc>
		sys_yield();

	cprintf("starting count down: ");
  8000ce:	c7 04 24 ae 27 80 00 	movl   $0x8027ae,(%esp)
  8000d5:	e8 9a 01 00 00       	call   800274 <cprintf>
	for (i = 5; i >= 0; i--) {
  8000da:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e3:	c7 04 24 c4 27 80 00 	movl   $0x8027c4,(%esp)
  8000ea:	e8 85 01 00 00       	call   800274 <cprintf>
		sleep(1);
  8000ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000f6:	e8 45 ff ff ff       	call   800040 <sleep>
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  8000fb:	83 eb 01             	sub    $0x1,%ebx
  8000fe:	83 fb ff             	cmp    $0xffffffff,%ebx
  800101:	75 dc                	jne    8000df <umain+0x27>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  800103:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  80010a:	e8 65 01 00 00       	call   800274 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  80010f:	cc                   	int3   
	breakpoint();
}
  800110:	83 c4 14             	add    $0x14,%esp
  800113:	5b                   	pop    %ebx
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	83 ec 10             	sub    $0x10,%esp
  80011e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800121:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800124:	e8 4c 0b 00 00       	call   800c75 <sys_getenvid>
  800129:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012e:	89 c2                	mov    %eax,%edx
  800130:	c1 e2 07             	shl    $0x7,%edx
  800133:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80013a:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013f:	85 db                	test   %ebx,%ebx
  800141:	7e 07                	jle    80014a <libmain+0x34>
		binaryname = argv[0];
  800143:	8b 06                	mov    (%esi),%eax
  800145:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80014a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80014e:	89 1c 24             	mov    %ebx,(%esp)
  800151:	e8 62 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800156:	e8 07 00 00 00       	call   800162 <exit>
}
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	5b                   	pop    %ebx
  80015f:	5e                   	pop    %esi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800168:	e8 4d 11 00 00       	call   8012ba <close_all>
	sys_env_destroy(0);
  80016d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800174:	e8 aa 0a 00 00       	call   800c23 <sys_env_destroy>
}
  800179:	c9                   	leave  
  80017a:	c3                   	ret    

0080017b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	56                   	push   %esi
  80017f:	53                   	push   %ebx
  800180:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800183:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800186:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80018c:	e8 e4 0a 00 00       	call   800c75 <sys_getenvid>
  800191:	8b 55 0c             	mov    0xc(%ebp),%edx
  800194:	89 54 24 10          	mov    %edx,0x10(%esp)
  800198:	8b 55 08             	mov    0x8(%ebp),%edx
  80019b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80019f:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a7:	c7 04 24 d4 27 80 00 	movl   $0x8027d4,(%esp)
  8001ae:	e8 c1 00 00 00       	call   800274 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ba:	89 04 24             	mov    %eax,(%esp)
  8001bd:	e8 51 00 00 00       	call   800213 <vcprintf>
	cprintf("\n");
  8001c2:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  8001c9:	e8 a6 00 00 00       	call   800274 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ce:	cc                   	int3   
  8001cf:	eb fd                	jmp    8001ce <_panic+0x53>

008001d1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	53                   	push   %ebx
  8001d5:	83 ec 14             	sub    $0x14,%esp
  8001d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001db:	8b 13                	mov    (%ebx),%edx
  8001dd:	8d 42 01             	lea    0x1(%edx),%eax
  8001e0:	89 03                	mov    %eax,(%ebx)
  8001e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ee:	75 19                	jne    800209 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001f0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001f7:	00 
  8001f8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001fb:	89 04 24             	mov    %eax,(%esp)
  8001fe:	e8 e3 09 00 00       	call   800be6 <sys_cputs>
		b->idx = 0;
  800203:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800209:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020d:	83 c4 14             	add    $0x14,%esp
  800210:	5b                   	pop    %ebx
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    

00800213 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80021c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800223:	00 00 00 
	b.cnt = 0;
  800226:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800230:	8b 45 0c             	mov    0xc(%ebp),%eax
  800233:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800237:	8b 45 08             	mov    0x8(%ebp),%eax
  80023a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800244:	89 44 24 04          	mov    %eax,0x4(%esp)
  800248:	c7 04 24 d1 01 80 00 	movl   $0x8001d1,(%esp)
  80024f:	e8 aa 01 00 00       	call   8003fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800254:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80025a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800264:	89 04 24             	mov    %eax,(%esp)
  800267:	e8 7a 09 00 00       	call   800be6 <sys_cputs>

	return b.cnt;
}
  80026c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80027a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80027d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800281:	8b 45 08             	mov    0x8(%ebp),%eax
  800284:	89 04 24             	mov    %eax,(%esp)
  800287:	e8 87 ff ff ff       	call   800213 <vcprintf>
	va_end(ap);

	return cnt;
}
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    
  80028e:	66 90                	xchg   %ax,%ax

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 3c             	sub    $0x3c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d7                	mov    %edx,%edi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	89 c3                	mov    %eax,%ebx
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8002af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bd:	39 d9                	cmp    %ebx,%ecx
  8002bf:	72 05                	jb     8002c6 <printnum+0x36>
  8002c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c4:	77 69                	ja     80032f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002cd:	83 ee 01             	sub    $0x1,%esi
  8002d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002e0:	89 c3                	mov    %eax,%ebx
  8002e2:	89 d6                	mov    %edx,%esi
  8002e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ff:	e8 dc 21 00 00       	call   8024e0 <__udivdi3>
  800304:	89 d9                	mov    %ebx,%ecx
  800306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	89 54 24 04          	mov    %edx,0x4(%esp)
  800315:	89 fa                	mov    %edi,%edx
  800317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031a:	e8 71 ff ff ff       	call   800290 <printnum>
  80031f:	eb 1b                	jmp    80033c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800321:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800325:	8b 45 18             	mov    0x18(%ebp),%eax
  800328:	89 04 24             	mov    %eax,(%esp)
  80032b:	ff d3                	call   *%ebx
  80032d:	eb 03                	jmp    800332 <printnum+0xa2>
  80032f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800332:	83 ee 01             	sub    $0x1,%esi
  800335:	85 f6                	test   %esi,%esi
  800337:	7f e8                	jg     800321 <printnum+0x91>
  800339:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800340:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800344:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800347:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80034a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	89 04 24             	mov    %eax,(%esp)
  800358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035f:	e8 ac 22 00 00       	call   802610 <__umoddi3>
  800364:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800368:	0f be 80 f7 27 80 00 	movsbl 0x8027f7(%eax),%eax
  80036f:	89 04 24             	mov    %eax,(%esp)
  800372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800375:	ff d0                	call   *%eax
}
  800377:	83 c4 3c             	add    $0x3c,%esp
  80037a:	5b                   	pop    %ebx
  80037b:	5e                   	pop    %esi
  80037c:	5f                   	pop    %edi
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800382:	83 fa 01             	cmp    $0x1,%edx
  800385:	7e 0e                	jle    800395 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800387:	8b 10                	mov    (%eax),%edx
  800389:	8d 4a 08             	lea    0x8(%edx),%ecx
  80038c:	89 08                	mov    %ecx,(%eax)
  80038e:	8b 02                	mov    (%edx),%eax
  800390:	8b 52 04             	mov    0x4(%edx),%edx
  800393:	eb 22                	jmp    8003b7 <getuint+0x38>
	else if (lflag)
  800395:	85 d2                	test   %edx,%edx
  800397:	74 10                	je     8003a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800399:	8b 10                	mov    (%eax),%edx
  80039b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80039e:	89 08                	mov    %ecx,(%eax)
  8003a0:	8b 02                	mov    (%edx),%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a7:	eb 0e                	jmp    8003b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ae:	89 08                	mov    %ecx,(%eax)
  8003b0:	8b 02                	mov    (%edx),%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003b7:	5d                   	pop    %ebp
  8003b8:	c3                   	ret    

008003b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c3:	8b 10                	mov    (%eax),%edx
  8003c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003c8:	73 0a                	jae    8003d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003cd:	89 08                	mov    %ecx,(%eax)
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	88 02                	mov    %al,(%edx)
}
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	89 04 24             	mov    %eax,(%esp)
  8003f7:	e8 02 00 00 00       	call   8003fe <vprintfmt>
	va_end(ap);
}
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	57                   	push   %edi
  800402:	56                   	push   %esi
  800403:	53                   	push   %ebx
  800404:	83 ec 3c             	sub    $0x3c,%esp
  800407:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80040a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80040d:	eb 14                	jmp    800423 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80040f:	85 c0                	test   %eax,%eax
  800411:	0f 84 b3 03 00 00    	je     8007ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800417:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80041b:	89 04 24             	mov    %eax,(%esp)
  80041e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800421:	89 f3                	mov    %esi,%ebx
  800423:	8d 73 01             	lea    0x1(%ebx),%esi
  800426:	0f b6 03             	movzbl (%ebx),%eax
  800429:	83 f8 25             	cmp    $0x25,%eax
  80042c:	75 e1                	jne    80040f <vprintfmt+0x11>
  80042e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800432:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800439:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800440:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	eb 1d                	jmp    80046b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800450:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800454:	eb 15                	jmp    80046b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800456:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800458:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80045c:	eb 0d                	jmp    80046b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80045e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800461:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800464:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80046e:	0f b6 0e             	movzbl (%esi),%ecx
  800471:	0f b6 c1             	movzbl %cl,%eax
  800474:	83 e9 23             	sub    $0x23,%ecx
  800477:	80 f9 55             	cmp    $0x55,%cl
  80047a:	0f 87 2a 03 00 00    	ja     8007aa <vprintfmt+0x3ac>
  800480:	0f b6 c9             	movzbl %cl,%ecx
  800483:	ff 24 8d 80 29 80 00 	jmp    *0x802980(,%ecx,4)
  80048a:	89 de                	mov    %ebx,%esi
  80048c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800491:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800494:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800498:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80049b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80049e:	83 fb 09             	cmp    $0x9,%ebx
  8004a1:	77 36                	ja     8004d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004a6:	eb e9                	jmp    800491 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004b8:	eb 22                	jmp    8004dc <vprintfmt+0xde>
  8004ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004bd:	85 c9                	test   %ecx,%ecx
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	0f 49 c1             	cmovns %ecx,%eax
  8004c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	89 de                	mov    %ebx,%esi
  8004cc:	eb 9d                	jmp    80046b <vprintfmt+0x6d>
  8004ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004d7:	eb 92                	jmp    80046b <vprintfmt+0x6d>
  8004d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e0:	79 89                	jns    80046b <vprintfmt+0x6d>
  8004e2:	e9 77 ff ff ff       	jmp    80045e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004ec:	e9 7a ff ff ff       	jmp    80046b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 50 04             	lea    0x4(%eax),%edx
  8004f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 04 24             	mov    %eax,(%esp)
  800503:	ff 55 08             	call   *0x8(%ebp)
			break;
  800506:	e9 18 ff ff ff       	jmp    800423 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	89 55 14             	mov    %edx,0x14(%ebp)
  800514:	8b 00                	mov    (%eax),%eax
  800516:	99                   	cltd   
  800517:	31 d0                	xor    %edx,%eax
  800519:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051b:	83 f8 12             	cmp    $0x12,%eax
  80051e:	7f 0b                	jg     80052b <vprintfmt+0x12d>
  800520:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  800527:	85 d2                	test   %edx,%edx
  800529:	75 20                	jne    80054b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80052b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80052f:	c7 44 24 08 0f 28 80 	movl   $0x80280f,0x8(%esp)
  800536:	00 
  800537:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	e8 90 fe ff ff       	call   8003d6 <printfmt>
  800546:	e9 d8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80054b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80054f:	c7 44 24 08 21 2c 80 	movl   $0x802c21,0x8(%esp)
  800556:	00 
  800557:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	89 04 24             	mov    %eax,(%esp)
  800561:	e8 70 fe ff ff       	call   8003d6 <printfmt>
  800566:	e9 b8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80056e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800571:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 50 04             	lea    0x4(%eax),%edx
  80057a:	89 55 14             	mov    %edx,0x14(%ebp)
  80057d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80057f:	85 f6                	test   %esi,%esi
  800581:	b8 08 28 80 00       	mov    $0x802808,%eax
  800586:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800589:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80058d:	0f 84 97 00 00 00    	je     80062a <vprintfmt+0x22c>
  800593:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800597:	0f 8e 9b 00 00 00    	jle    800638 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005a1:	89 34 24             	mov    %esi,(%esp)
  8005a4:	e8 cf 02 00 00       	call   800878 <strnlen>
  8005a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ac:	29 c2                	sub    %eax,%edx
  8005ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	eb 0f                	jmp    8005d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005cc:	89 04 24             	mov    %eax,(%esp)
  8005cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d1:	83 eb 01             	sub    $0x1,%ebx
  8005d4:	85 db                	test   %ebx,%ebx
  8005d6:	7f ed                	jg     8005c5 <vprintfmt+0x1c7>
  8005d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	0f 49 c2             	cmovns %edx,%eax
  8005e8:	29 c2                	sub    %eax,%edx
  8005ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005ed:	89 d7                	mov    %edx,%edi
  8005ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005f2:	eb 50                	jmp    800644 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f8:	74 1e                	je     800618 <vprintfmt+0x21a>
  8005fa:	0f be d2             	movsbl %dl,%edx
  8005fd:	83 ea 20             	sub    $0x20,%edx
  800600:	83 fa 5e             	cmp    $0x5e,%edx
  800603:	76 13                	jbe    800618 <vprintfmt+0x21a>
					putch('?', putdat);
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800613:	ff 55 08             	call   *0x8(%ebp)
  800616:	eb 0d                	jmp    800625 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80061f:	89 04 24             	mov    %eax,(%esp)
  800622:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800625:	83 ef 01             	sub    $0x1,%edi
  800628:	eb 1a                	jmp    800644 <vprintfmt+0x246>
  80062a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800630:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800633:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800636:	eb 0c                	jmp    800644 <vprintfmt+0x246>
  800638:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80063b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80063e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800641:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800644:	83 c6 01             	add    $0x1,%esi
  800647:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80064b:	0f be c2             	movsbl %dl,%eax
  80064e:	85 c0                	test   %eax,%eax
  800650:	74 27                	je     800679 <vprintfmt+0x27b>
  800652:	85 db                	test   %ebx,%ebx
  800654:	78 9e                	js     8005f4 <vprintfmt+0x1f6>
  800656:	83 eb 01             	sub    $0x1,%ebx
  800659:	79 99                	jns    8005f4 <vprintfmt+0x1f6>
  80065b:	89 f8                	mov    %edi,%eax
  80065d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800660:	8b 75 08             	mov    0x8(%ebp),%esi
  800663:	89 c3                	mov    %eax,%ebx
  800665:	eb 1a                	jmp    800681 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800672:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800674:	83 eb 01             	sub    $0x1,%ebx
  800677:	eb 08                	jmp    800681 <vprintfmt+0x283>
  800679:	89 fb                	mov    %edi,%ebx
  80067b:	8b 75 08             	mov    0x8(%ebp),%esi
  80067e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800681:	85 db                	test   %ebx,%ebx
  800683:	7f e2                	jg     800667 <vprintfmt+0x269>
  800685:	89 75 08             	mov    %esi,0x8(%ebp)
  800688:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80068b:	e9 93 fd ff ff       	jmp    800423 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800690:	83 fa 01             	cmp    $0x1,%edx
  800693:	7e 16                	jle    8006ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 50 04             	mov    0x4(%eax),%edx
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a9:	eb 32                	jmp    8006dd <vprintfmt+0x2df>
	else if (lflag)
  8006ab:	85 d2                	test   %edx,%edx
  8006ad:	74 18                	je     8006c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 50 04             	lea    0x4(%eax),%edx
  8006b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b8:	8b 30                	mov    (%eax),%esi
  8006ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006bd:	89 f0                	mov    %esi,%eax
  8006bf:	c1 f8 1f             	sar    $0x1f,%eax
  8006c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c5:	eb 16                	jmp    8006dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d0:	8b 30                	mov    (%eax),%esi
  8006d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006d5:	89 f0                	mov    %esi,%eax
  8006d7:	c1 f8 1f             	sar    $0x1f,%eax
  8006da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ec:	0f 89 80 00 00 00    	jns    800772 <vprintfmt+0x374>
				putch('-', putdat);
  8006f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800703:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800706:	f7 d8                	neg    %eax
  800708:	83 d2 00             	adc    $0x0,%edx
  80070b:	f7 da                	neg    %edx
			}
			base = 10;
  80070d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800712:	eb 5e                	jmp    800772 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800714:	8d 45 14             	lea    0x14(%ebp),%eax
  800717:	e8 63 fc ff ff       	call   80037f <getuint>
			base = 10;
  80071c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800721:	eb 4f                	jmp    800772 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
  800726:	e8 54 fc ff ff       	call   80037f <getuint>
			base = 8;
  80072b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800730:	eb 40                	jmp    800772 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800732:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800736:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80073d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800740:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800744:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80074b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8d 50 04             	lea    0x4(%eax),%edx
  800754:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800757:	8b 00                	mov    (%eax),%eax
  800759:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80075e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800763:	eb 0d                	jmp    800772 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800765:	8d 45 14             	lea    0x14(%ebp),%eax
  800768:	e8 12 fc ff ff       	call   80037f <getuint>
			base = 16;
  80076d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800772:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800776:	89 74 24 10          	mov    %esi,0x10(%esp)
  80077a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80077d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800781:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	89 54 24 04          	mov    %edx,0x4(%esp)
  80078c:	89 fa                	mov    %edi,%edx
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	e8 fa fa ff ff       	call   800290 <printnum>
			break;
  800796:	e9 88 fc ff ff       	jmp    800423 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80079b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079f:	89 04 24             	mov    %eax,(%esp)
  8007a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007a5:	e9 79 fc ff ff       	jmp    800423 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b8:	89 f3                	mov    %esi,%ebx
  8007ba:	eb 03                	jmp    8007bf <vprintfmt+0x3c1>
  8007bc:	83 eb 01             	sub    $0x1,%ebx
  8007bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007c3:	75 f7                	jne    8007bc <vprintfmt+0x3be>
  8007c5:	e9 59 fc ff ff       	jmp    800423 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007ca:	83 c4 3c             	add    $0x3c,%esp
  8007cd:	5b                   	pop    %ebx
  8007ce:	5e                   	pop    %esi
  8007cf:	5f                   	pop    %edi
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	83 ec 28             	sub    $0x28,%esp
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	74 30                	je     800823 <vsnprintf+0x51>
  8007f3:	85 d2                	test   %edx,%edx
  8007f5:	7e 2c                	jle    800823 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800801:	89 44 24 08          	mov    %eax,0x8(%esp)
  800805:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080c:	c7 04 24 b9 03 80 00 	movl   $0x8003b9,(%esp)
  800813:	e8 e6 fb ff ff       	call   8003fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800821:	eb 05                	jmp    800828 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800828:	c9                   	leave  
  800829:	c3                   	ret    

0080082a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800830:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800833:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800837:	8b 45 10             	mov    0x10(%ebp),%eax
  80083a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800841:	89 44 24 04          	mov    %eax,0x4(%esp)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	89 04 24             	mov    %eax,(%esp)
  80084b:	e8 82 ff ff ff       	call   8007d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    
  800852:	66 90                	xchg   %ax,%ax
  800854:	66 90                	xchg   %ax,%ax
  800856:	66 90                	xchg   %ax,%ax
  800858:	66 90                	xchg   %ax,%ax
  80085a:	66 90                	xchg   %ax,%ax
  80085c:	66 90                	xchg   %ax,%ax
  80085e:	66 90                	xchg   %ax,%ax

00800860 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
  80086b:	eb 03                	jmp    800870 <strlen+0x10>
		n++;
  80086d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800870:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800874:	75 f7                	jne    80086d <strlen+0xd>
		n++;
	return n;
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
  800886:	eb 03                	jmp    80088b <strnlen+0x13>
		n++;
  800888:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088b:	39 d0                	cmp    %edx,%eax
  80088d:	74 06                	je     800895 <strnlen+0x1d>
  80088f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800893:	75 f3                	jne    800888 <strnlen+0x10>
		n++;
	return n;
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a1:	89 c2                	mov    %eax,%edx
  8008a3:	83 c2 01             	add    $0x1,%edx
  8008a6:	83 c1 01             	add    $0x1,%ecx
  8008a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008b0:	84 db                	test   %bl,%bl
  8008b2:	75 ef                	jne    8008a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008b4:	5b                   	pop    %ebx
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	53                   	push   %ebx
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c1:	89 1c 24             	mov    %ebx,(%esp)
  8008c4:	e8 97 ff ff ff       	call   800860 <strlen>
	strcpy(dst + len, src);
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008d0:	01 d8                	add    %ebx,%eax
  8008d2:	89 04 24             	mov    %eax,(%esp)
  8008d5:	e8 bd ff ff ff       	call   800897 <strcpy>
	return dst;
}
  8008da:	89 d8                	mov    %ebx,%eax
  8008dc:	83 c4 08             	add    $0x8,%esp
  8008df:	5b                   	pop    %ebx
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ed:	89 f3                	mov    %esi,%ebx
  8008ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f2:	89 f2                	mov    %esi,%edx
  8008f4:	eb 0f                	jmp    800905 <strncpy+0x23>
		*dst++ = *src;
  8008f6:	83 c2 01             	add    $0x1,%edx
  8008f9:	0f b6 01             	movzbl (%ecx),%eax
  8008fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800902:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800905:	39 da                	cmp    %ebx,%edx
  800907:	75 ed                	jne    8008f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800909:	89 f0                	mov    %esi,%eax
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	56                   	push   %esi
  800913:	53                   	push   %ebx
  800914:	8b 75 08             	mov    0x8(%ebp),%esi
  800917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800923:	85 c9                	test   %ecx,%ecx
  800925:	75 0b                	jne    800932 <strlcpy+0x23>
  800927:	eb 1d                	jmp    800946 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	83 c2 01             	add    $0x1,%edx
  80092f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800932:	39 d8                	cmp    %ebx,%eax
  800934:	74 0b                	je     800941 <strlcpy+0x32>
  800936:	0f b6 0a             	movzbl (%edx),%ecx
  800939:	84 c9                	test   %cl,%cl
  80093b:	75 ec                	jne    800929 <strlcpy+0x1a>
  80093d:	89 c2                	mov    %eax,%edx
  80093f:	eb 02                	jmp    800943 <strlcpy+0x34>
  800941:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800943:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800946:	29 f0                	sub    %esi,%eax
}
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800952:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800955:	eb 06                	jmp    80095d <strcmp+0x11>
		p++, q++;
  800957:	83 c1 01             	add    $0x1,%ecx
  80095a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	84 c0                	test   %al,%al
  800962:	74 04                	je     800968 <strcmp+0x1c>
  800964:	3a 02                	cmp    (%edx),%al
  800966:	74 ef                	je     800957 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 c0             	movzbl %al,%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
}
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	89 c3                	mov    %eax,%ebx
  80097e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800981:	eb 06                	jmp    800989 <strncmp+0x17>
		n--, p++, q++;
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800989:	39 d8                	cmp    %ebx,%eax
  80098b:	74 15                	je     8009a2 <strncmp+0x30>
  80098d:	0f b6 08             	movzbl (%eax),%ecx
  800990:	84 c9                	test   %cl,%cl
  800992:	74 04                	je     800998 <strncmp+0x26>
  800994:	3a 0a                	cmp    (%edx),%cl
  800996:	74 eb                	je     800983 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 00             	movzbl (%eax),%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
  8009a0:	eb 05                	jmp    8009a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b4:	eb 07                	jmp    8009bd <strchr+0x13>
		if (*s == c)
  8009b6:	38 ca                	cmp    %cl,%dl
  8009b8:	74 0f                	je     8009c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	0f b6 10             	movzbl (%eax),%edx
  8009c0:	84 d2                	test   %dl,%dl
  8009c2:	75 f2                	jne    8009b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d5:	eb 07                	jmp    8009de <strfind+0x13>
		if (*s == c)
  8009d7:	38 ca                	cmp    %cl,%dl
  8009d9:	74 0a                	je     8009e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	0f b6 10             	movzbl (%eax),%edx
  8009e1:	84 d2                	test   %dl,%dl
  8009e3:	75 f2                	jne    8009d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	57                   	push   %edi
  8009eb:	56                   	push   %esi
  8009ec:	53                   	push   %ebx
  8009ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f3:	85 c9                	test   %ecx,%ecx
  8009f5:	74 36                	je     800a2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009fd:	75 28                	jne    800a27 <memset+0x40>
  8009ff:	f6 c1 03             	test   $0x3,%cl
  800a02:	75 23                	jne    800a27 <memset+0x40>
		c &= 0xFF;
  800a04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a08:	89 d3                	mov    %edx,%ebx
  800a0a:	c1 e3 08             	shl    $0x8,%ebx
  800a0d:	89 d6                	mov    %edx,%esi
  800a0f:	c1 e6 18             	shl    $0x18,%esi
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	c1 e0 10             	shl    $0x10,%eax
  800a17:	09 f0                	or     %esi,%eax
  800a19:	09 c2                	or     %eax,%edx
  800a1b:	89 d0                	mov    %edx,%eax
  800a1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a22:	fc                   	cld    
  800a23:	f3 ab                	rep stos %eax,%es:(%edi)
  800a25:	eb 06                	jmp    800a2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	fc                   	cld    
  800a2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a2d:	89 f8                	mov    %edi,%eax
  800a2f:	5b                   	pop    %ebx
  800a30:	5e                   	pop    %esi
  800a31:	5f                   	pop    %edi
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a42:	39 c6                	cmp    %eax,%esi
  800a44:	73 35                	jae    800a7b <memmove+0x47>
  800a46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a49:	39 d0                	cmp    %edx,%eax
  800a4b:	73 2e                	jae    800a7b <memmove+0x47>
		s += n;
		d += n;
  800a4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a50:	89 d6                	mov    %edx,%esi
  800a52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a5a:	75 13                	jne    800a6f <memmove+0x3b>
  800a5c:	f6 c1 03             	test   $0x3,%cl
  800a5f:	75 0e                	jne    800a6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a61:	83 ef 04             	sub    $0x4,%edi
  800a64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a6a:	fd                   	std    
  800a6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6d:	eb 09                	jmp    800a78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a6f:	83 ef 01             	sub    $0x1,%edi
  800a72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a75:	fd                   	std    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a78:	fc                   	cld    
  800a79:	eb 1d                	jmp    800a98 <memmove+0x64>
  800a7b:	89 f2                	mov    %esi,%edx
  800a7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7f:	f6 c2 03             	test   $0x3,%dl
  800a82:	75 0f                	jne    800a93 <memmove+0x5f>
  800a84:	f6 c1 03             	test   $0x3,%cl
  800a87:	75 0a                	jne    800a93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a8c:	89 c7                	mov    %eax,%edi
  800a8e:	fc                   	cld    
  800a8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a91:	eb 05                	jmp    800a98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a93:	89 c7                	mov    %eax,%edi
  800a95:	fc                   	cld    
  800a96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	89 04 24             	mov    %eax,(%esp)
  800ab6:	e8 79 ff ff ff       	call   800a34 <memmove>
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac8:	89 d6                	mov    %edx,%esi
  800aca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acd:	eb 1a                	jmp    800ae9 <memcmp+0x2c>
		if (*s1 != *s2)
  800acf:	0f b6 02             	movzbl (%edx),%eax
  800ad2:	0f b6 19             	movzbl (%ecx),%ebx
  800ad5:	38 d8                	cmp    %bl,%al
  800ad7:	74 0a                	je     800ae3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ad9:	0f b6 c0             	movzbl %al,%eax
  800adc:	0f b6 db             	movzbl %bl,%ebx
  800adf:	29 d8                	sub    %ebx,%eax
  800ae1:	eb 0f                	jmp    800af2 <memcmp+0x35>
		s1++, s2++;
  800ae3:	83 c2 01             	add    $0x1,%edx
  800ae6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae9:	39 f2                	cmp    %esi,%edx
  800aeb:	75 e2                	jne    800acf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aff:	89 c2                	mov    %eax,%edx
  800b01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b04:	eb 07                	jmp    800b0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b06:	38 08                	cmp    %cl,(%eax)
  800b08:	74 07                	je     800b11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b0a:	83 c0 01             	add    $0x1,%eax
  800b0d:	39 d0                	cmp    %edx,%eax
  800b0f:	72 f5                	jb     800b06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1f:	eb 03                	jmp    800b24 <strtol+0x11>
		s++;
  800b21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b24:	0f b6 0a             	movzbl (%edx),%ecx
  800b27:	80 f9 09             	cmp    $0x9,%cl
  800b2a:	74 f5                	je     800b21 <strtol+0xe>
  800b2c:	80 f9 20             	cmp    $0x20,%cl
  800b2f:	74 f0                	je     800b21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b31:	80 f9 2b             	cmp    $0x2b,%cl
  800b34:	75 0a                	jne    800b40 <strtol+0x2d>
		s++;
  800b36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b39:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3e:	eb 11                	jmp    800b51 <strtol+0x3e>
  800b40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b45:	80 f9 2d             	cmp    $0x2d,%cl
  800b48:	75 07                	jne    800b51 <strtol+0x3e>
		s++, neg = 1;
  800b4a:	8d 52 01             	lea    0x1(%edx),%edx
  800b4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b56:	75 15                	jne    800b6d <strtol+0x5a>
  800b58:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5b:	75 10                	jne    800b6d <strtol+0x5a>
  800b5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b61:	75 0a                	jne    800b6d <strtol+0x5a>
		s += 2, base = 16;
  800b63:	83 c2 02             	add    $0x2,%edx
  800b66:	b8 10 00 00 00       	mov    $0x10,%eax
  800b6b:	eb 10                	jmp    800b7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	75 0c                	jne    800b7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b73:	80 3a 30             	cmpb   $0x30,(%edx)
  800b76:	75 05                	jne    800b7d <strtol+0x6a>
		s++, base = 8;
  800b78:	83 c2 01             	add    $0x1,%edx
  800b7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b85:	0f b6 0a             	movzbl (%edx),%ecx
  800b88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b8b:	89 f0                	mov    %esi,%eax
  800b8d:	3c 09                	cmp    $0x9,%al
  800b8f:	77 08                	ja     800b99 <strtol+0x86>
			dig = *s - '0';
  800b91:	0f be c9             	movsbl %cl,%ecx
  800b94:	83 e9 30             	sub    $0x30,%ecx
  800b97:	eb 20                	jmp    800bb9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b9c:	89 f0                	mov    %esi,%eax
  800b9e:	3c 19                	cmp    $0x19,%al
  800ba0:	77 08                	ja     800baa <strtol+0x97>
			dig = *s - 'a' + 10;
  800ba2:	0f be c9             	movsbl %cl,%ecx
  800ba5:	83 e9 57             	sub    $0x57,%ecx
  800ba8:	eb 0f                	jmp    800bb9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800baa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bad:	89 f0                	mov    %esi,%eax
  800baf:	3c 19                	cmp    $0x19,%al
  800bb1:	77 16                	ja     800bc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bb3:	0f be c9             	movsbl %cl,%ecx
  800bb6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bb9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bbc:	7d 0f                	jge    800bcd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bbe:	83 c2 01             	add    $0x1,%edx
  800bc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bc7:	eb bc                	jmp    800b85 <strtol+0x72>
  800bc9:	89 d8                	mov    %ebx,%eax
  800bcb:	eb 02                	jmp    800bcf <strtol+0xbc>
  800bcd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd3:	74 05                	je     800bda <strtol+0xc7>
		*endptr = (char *) s;
  800bd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bda:	f7 d8                	neg    %eax
  800bdc:	85 ff                	test   %edi,%edi
  800bde:	0f 44 c3             	cmove  %ebx,%eax
}
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	89 c3                	mov    %eax,%ebx
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	89 c6                	mov    %eax,%esi
  800bfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c14:	89 d1                	mov    %edx,%ecx
  800c16:	89 d3                	mov    %edx,%ebx
  800c18:	89 d7                	mov    %edx,%edi
  800c1a:	89 d6                	mov    %edx,%esi
  800c1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c1e:	5b                   	pop    %ebx
  800c1f:	5e                   	pop    %esi
  800c20:	5f                   	pop    %edi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c31:	b8 03 00 00 00       	mov    $0x3,%eax
  800c36:	8b 55 08             	mov    0x8(%ebp),%edx
  800c39:	89 cb                	mov    %ecx,%ebx
  800c3b:	89 cf                	mov    %ecx,%edi
  800c3d:	89 ce                	mov    %ecx,%esi
  800c3f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c41:	85 c0                	test   %eax,%eax
  800c43:	7e 28                	jle    800c6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c50:	00 
  800c51:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800c58:	00 
  800c59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c60:	00 
  800c61:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800c68:	e8 0e f5 ff ff       	call   80017b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6d:	83 c4 2c             	add    $0x2c,%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c80:	b8 02 00 00 00       	mov    $0x2,%eax
  800c85:	89 d1                	mov    %edx,%ecx
  800c87:	89 d3                	mov    %edx,%ebx
  800c89:	89 d7                	mov    %edx,%edi
  800c8b:	89 d6                	mov    %edx,%esi
  800c8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <sys_yield>:

void
sys_yield(void)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca4:	89 d1                	mov    %edx,%ecx
  800ca6:	89 d3                	mov    %edx,%ebx
  800ca8:	89 d7                	mov    %edx,%edi
  800caa:	89 d6                	mov    %edx,%esi
  800cac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbc:	be 00 00 00 00       	mov    $0x0,%esi
  800cc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccf:	89 f7                	mov    %esi,%edi
  800cd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7e 28                	jle    800cff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ce2:	00 
  800ce3:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800cea:	00 
  800ceb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf2:	00 
  800cf3:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800cfa:	e8 7c f4 ff ff       	call   80017b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cff:	83 c4 2c             	add    $0x2c,%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d10:	b8 05 00 00 00       	mov    $0x5,%eax
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d21:	8b 75 18             	mov    0x18(%ebp),%esi
  800d24:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	7e 28                	jle    800d52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d35:	00 
  800d36:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800d3d:	00 
  800d3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d45:	00 
  800d46:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800d4d:	e8 29 f4 ff ff       	call   80017b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d52:	83 c4 2c             	add    $0x2c,%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
  800d60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d68:	b8 06 00 00 00       	mov    $0x6,%eax
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	89 df                	mov    %ebx,%edi
  800d75:	89 de                	mov    %ebx,%esi
  800d77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	7e 28                	jle    800da5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d88:	00 
  800d89:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800d90:	00 
  800d91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d98:	00 
  800d99:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800da0:	e8 d6 f3 ff ff       	call   80017b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da5:	83 c4 2c             	add    $0x2c,%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7e 28                	jle    800df8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ddb:	00 
  800ddc:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800de3:	00 
  800de4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800deb:	00 
  800dec:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800df3:	e8 83 f3 ff ff       	call   80017b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df8:	83 c4 2c             	add    $0x2c,%esp
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 de                	mov    %ebx,%esi
  800e1d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	7e 28                	jle    800e4b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e27:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e2e:	00 
  800e2f:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800e36:	00 
  800e37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3e:	00 
  800e3f:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800e46:	e8 30 f3 ff ff       	call   80017b <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e4b:	83 c4 2c             	add    $0x2c,%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	89 df                	mov    %ebx,%edi
  800e6e:	89 de                	mov    %ebx,%esi
  800e70:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	7e 28                	jle    800e9e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e81:	00 
  800e82:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800e89:	00 
  800e8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e91:	00 
  800e92:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800e99:	e8 dd f2 ff ff       	call   80017b <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9e:	83 c4 2c             	add    $0x2c,%esp
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eac:	be 00 00 00 00       	mov    $0x0,%esi
  800eb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7e 28                	jle    800f13 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ef6:	00 
  800ef7:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800efe:	00 
  800eff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f06:	00 
  800f07:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800f0e:	e8 68 f2 ff ff       	call   80017b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f13:	83 c4 2c             	add    $0x2c,%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2b:	89 d1                	mov    %edx,%ecx
  800f2d:	89 d3                	mov    %edx,%ebx
  800f2f:	89 d7                	mov    %edx,%edi
  800f31:	89 d6                	mov    %edx,%esi
  800f33:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f48:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	89 df                	mov    %ebx,%edi
  800f55:	89 de                	mov    %ebx,%esi
  800f57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	7e 28                	jle    800f85 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f61:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f68:	00 
  800f69:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800f70:	00 
  800f71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f78:	00 
  800f79:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800f80:	e8 f6 f1 ff ff       	call   80017b <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800f85:	83 c4 2c             	add    $0x2c,%esp
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
  800f93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	b8 10 00 00 00       	mov    $0x10,%eax
  800fa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	7e 28                	jle    800fd8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800fbb:	00 
  800fbc:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  800fc3:	00 
  800fc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fcb:	00 
  800fcc:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  800fd3:	e8 a3 f1 ff ff       	call   80017b <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800fd8:	83 c4 2c             	add    $0x2c,%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
  800fe6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fee:	b8 11 00 00 00       	mov    $0x11,%eax
  800ff3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff9:	89 df                	mov    %ebx,%edi
  800ffb:	89 de                	mov    %ebx,%esi
  800ffd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fff:	85 c0                	test   %eax,%eax
  801001:	7e 28                	jle    80102b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801003:	89 44 24 10          	mov    %eax,0x10(%esp)
  801007:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80100e:	00 
  80100f:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  801016:	00 
  801017:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101e:	00 
  80101f:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  801026:	e8 50 f1 ff ff       	call   80017b <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80102b:	83 c4 2c             	add    $0x2c,%esp
  80102e:	5b                   	pop    %ebx
  80102f:	5e                   	pop    %esi
  801030:	5f                   	pop    %edi
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <sys_sleep>:

int
sys_sleep(int channel)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801041:	b8 12 00 00 00       	mov    $0x12,%eax
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	89 cb                	mov    %ecx,%ebx
  80104b:	89 cf                	mov    %ecx,%edi
  80104d:	89 ce                	mov    %ecx,%esi
  80104f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801051:	85 c0                	test   %eax,%eax
  801053:	7e 28                	jle    80107d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801055:	89 44 24 10          	mov    %eax,0x10(%esp)
  801059:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801060:	00 
  801061:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  801068:	00 
  801069:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801070:	00 
  801071:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  801078:	e8 fe f0 ff ff       	call   80017b <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80107d:	83 c4 2c             	add    $0x2c,%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801093:	b8 13 00 00 00       	mov    $0x13,%eax
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	8b 55 08             	mov    0x8(%ebp),%edx
  80109e:	89 df                	mov    %ebx,%edi
  8010a0:	89 de                	mov    %ebx,%esi
  8010a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	7e 28                	jle    8010d0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ac:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8010b3:	00 
  8010b4:	c7 44 24 08 4b 2b 80 	movl   $0x802b4b,0x8(%esp)
  8010bb:	00 
  8010bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c3:	00 
  8010c4:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  8010cb:	e8 ab f0 ff ff       	call   80017b <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8010d0:	83 c4 2c             	add    $0x2c,%esp
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5f                   	pop    %edi
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    
  8010d8:	66 90                	xchg   %ax,%ax
  8010da:	66 90                	xchg   %ax,%ax
  8010dc:	66 90                	xchg   %ax,%ax
  8010de:	66 90                	xchg   %ax,%ax

008010e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801100:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801112:	89 c2                	mov    %eax,%edx
  801114:	c1 ea 16             	shr    $0x16,%edx
  801117:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80111e:	f6 c2 01             	test   $0x1,%dl
  801121:	74 11                	je     801134 <fd_alloc+0x2d>
  801123:	89 c2                	mov    %eax,%edx
  801125:	c1 ea 0c             	shr    $0xc,%edx
  801128:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80112f:	f6 c2 01             	test   $0x1,%dl
  801132:	75 09                	jne    80113d <fd_alloc+0x36>
			*fd_store = fd;
  801134:	89 01                	mov    %eax,(%ecx)
			return 0;
  801136:	b8 00 00 00 00       	mov    $0x0,%eax
  80113b:	eb 17                	jmp    801154 <fd_alloc+0x4d>
  80113d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801142:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801147:	75 c9                	jne    801112 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801149:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80114f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    

00801156 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80115c:	83 f8 1f             	cmp    $0x1f,%eax
  80115f:	77 36                	ja     801197 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801161:	c1 e0 0c             	shl    $0xc,%eax
  801164:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801169:	89 c2                	mov    %eax,%edx
  80116b:	c1 ea 16             	shr    $0x16,%edx
  80116e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801175:	f6 c2 01             	test   $0x1,%dl
  801178:	74 24                	je     80119e <fd_lookup+0x48>
  80117a:	89 c2                	mov    %eax,%edx
  80117c:	c1 ea 0c             	shr    $0xc,%edx
  80117f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801186:	f6 c2 01             	test   $0x1,%dl
  801189:	74 1a                	je     8011a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80118b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118e:	89 02                	mov    %eax,(%edx)
	return 0;
  801190:	b8 00 00 00 00       	mov    $0x0,%eax
  801195:	eb 13                	jmp    8011aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801197:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119c:	eb 0c                	jmp    8011aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80119e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a3:	eb 05                	jmp    8011aa <fd_lookup+0x54>
  8011a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 18             	sub    $0x18,%esp
  8011b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ba:	eb 13                	jmp    8011cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8011bc:	39 08                	cmp    %ecx,(%eax)
  8011be:	75 0c                	jne    8011cc <dev_lookup+0x20>
			*dev = devtab[i];
  8011c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ca:	eb 38                	jmp    801204 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011cc:	83 c2 01             	add    $0x1,%edx
  8011cf:	8b 04 95 f4 2b 80 00 	mov    0x802bf4(,%edx,4),%eax
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	75 e2                	jne    8011bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011da:	a1 08 40 80 00       	mov    0x804008,%eax
  8011df:	8b 40 48             	mov    0x48(%eax),%eax
  8011e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ea:	c7 04 24 78 2b 80 00 	movl   $0x802b78,(%esp)
  8011f1:	e8 7e f0 ff ff       	call   800274 <cprintf>
	*dev = 0;
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	56                   	push   %esi
  80120a:	53                   	push   %ebx
  80120b:	83 ec 20             	sub    $0x20,%esp
  80120e:	8b 75 08             	mov    0x8(%ebp),%esi
  801211:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801214:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801217:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80121b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801221:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801224:	89 04 24             	mov    %eax,(%esp)
  801227:	e8 2a ff ff ff       	call   801156 <fd_lookup>
  80122c:	85 c0                	test   %eax,%eax
  80122e:	78 05                	js     801235 <fd_close+0x2f>
	    || fd != fd2)
  801230:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801233:	74 0c                	je     801241 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801235:	84 db                	test   %bl,%bl
  801237:	ba 00 00 00 00       	mov    $0x0,%edx
  80123c:	0f 44 c2             	cmove  %edx,%eax
  80123f:	eb 3f                	jmp    801280 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801241:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801244:	89 44 24 04          	mov    %eax,0x4(%esp)
  801248:	8b 06                	mov    (%esi),%eax
  80124a:	89 04 24             	mov    %eax,(%esp)
  80124d:	e8 5a ff ff ff       	call   8011ac <dev_lookup>
  801252:	89 c3                	mov    %eax,%ebx
  801254:	85 c0                	test   %eax,%eax
  801256:	78 16                	js     80126e <fd_close+0x68>
		if (dev->dev_close)
  801258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80125e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801263:	85 c0                	test   %eax,%eax
  801265:	74 07                	je     80126e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801267:	89 34 24             	mov    %esi,(%esp)
  80126a:	ff d0                	call   *%eax
  80126c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80126e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801272:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801279:	e8 dc fa ff ff       	call   800d5a <sys_page_unmap>
	return r;
  80127e:	89 d8                	mov    %ebx,%eax
}
  801280:	83 c4 20             	add    $0x20,%esp
  801283:	5b                   	pop    %ebx
  801284:	5e                   	pop    %esi
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    

00801287 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80128d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801290:	89 44 24 04          	mov    %eax,0x4(%esp)
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	89 04 24             	mov    %eax,(%esp)
  80129a:	e8 b7 fe ff ff       	call   801156 <fd_lookup>
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	85 d2                	test   %edx,%edx
  8012a3:	78 13                	js     8012b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012ac:	00 
  8012ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b0:	89 04 24             	mov    %eax,(%esp)
  8012b3:	e8 4e ff ff ff       	call   801206 <fd_close>
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <close_all>:

void
close_all(void)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012c6:	89 1c 24             	mov    %ebx,(%esp)
  8012c9:	e8 b9 ff ff ff       	call   801287 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ce:	83 c3 01             	add    $0x1,%ebx
  8012d1:	83 fb 20             	cmp    $0x20,%ebx
  8012d4:	75 f0                	jne    8012c6 <close_all+0xc>
		close(i);
}
  8012d6:	83 c4 14             	add    $0x14,%esp
  8012d9:	5b                   	pop    %ebx
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	57                   	push   %edi
  8012e0:	56                   	push   %esi
  8012e1:	53                   	push   %ebx
  8012e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	89 04 24             	mov    %eax,(%esp)
  8012f2:	e8 5f fe ff ff       	call   801156 <fd_lookup>
  8012f7:	89 c2                	mov    %eax,%edx
  8012f9:	85 d2                	test   %edx,%edx
  8012fb:	0f 88 e1 00 00 00    	js     8013e2 <dup+0x106>
		return r;
	close(newfdnum);
  801301:	8b 45 0c             	mov    0xc(%ebp),%eax
  801304:	89 04 24             	mov    %eax,(%esp)
  801307:	e8 7b ff ff ff       	call   801287 <close>

	newfd = INDEX2FD(newfdnum);
  80130c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80130f:	c1 e3 0c             	shl    $0xc,%ebx
  801312:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80131b:	89 04 24             	mov    %eax,(%esp)
  80131e:	e8 cd fd ff ff       	call   8010f0 <fd2data>
  801323:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801325:	89 1c 24             	mov    %ebx,(%esp)
  801328:	e8 c3 fd ff ff       	call   8010f0 <fd2data>
  80132d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80132f:	89 f0                	mov    %esi,%eax
  801331:	c1 e8 16             	shr    $0x16,%eax
  801334:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80133b:	a8 01                	test   $0x1,%al
  80133d:	74 43                	je     801382 <dup+0xa6>
  80133f:	89 f0                	mov    %esi,%eax
  801341:	c1 e8 0c             	shr    $0xc,%eax
  801344:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80134b:	f6 c2 01             	test   $0x1,%dl
  80134e:	74 32                	je     801382 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801350:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801357:	25 07 0e 00 00       	and    $0xe07,%eax
  80135c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801360:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801364:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80136b:	00 
  80136c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801370:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801377:	e8 8b f9 ff ff       	call   800d07 <sys_page_map>
  80137c:	89 c6                	mov    %eax,%esi
  80137e:	85 c0                	test   %eax,%eax
  801380:	78 3e                	js     8013c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801385:	89 c2                	mov    %eax,%edx
  801387:	c1 ea 0c             	shr    $0xc,%edx
  80138a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801391:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801397:	89 54 24 10          	mov    %edx,0x10(%esp)
  80139b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80139f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013a6:	00 
  8013a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b2:	e8 50 f9 ff ff       	call   800d07 <sys_page_map>
  8013b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013bc:	85 f6                	test   %esi,%esi
  8013be:	79 22                	jns    8013e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013cb:	e8 8a f9 ff ff       	call   800d5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013db:	e8 7a f9 ff ff       	call   800d5a <sys_page_unmap>
	return r;
  8013e0:	89 f0                	mov    %esi,%eax
}
  8013e2:	83 c4 3c             	add    $0x3c,%esp
  8013e5:	5b                   	pop    %ebx
  8013e6:	5e                   	pop    %esi
  8013e7:	5f                   	pop    %edi
  8013e8:	5d                   	pop    %ebp
  8013e9:	c3                   	ret    

008013ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	53                   	push   %ebx
  8013ee:	83 ec 24             	sub    $0x24,%esp
  8013f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fb:	89 1c 24             	mov    %ebx,(%esp)
  8013fe:	e8 53 fd ff ff       	call   801156 <fd_lookup>
  801403:	89 c2                	mov    %eax,%edx
  801405:	85 d2                	test   %edx,%edx
  801407:	78 6d                	js     801476 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801409:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	89 04 24             	mov    %eax,(%esp)
  801418:	e8 8f fd ff ff       	call   8011ac <dev_lookup>
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 55                	js     801476 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801424:	8b 50 08             	mov    0x8(%eax),%edx
  801427:	83 e2 03             	and    $0x3,%edx
  80142a:	83 fa 01             	cmp    $0x1,%edx
  80142d:	75 23                	jne    801452 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80142f:	a1 08 40 80 00       	mov    0x804008,%eax
  801434:	8b 40 48             	mov    0x48(%eax),%eax
  801437:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80143b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143f:	c7 04 24 b9 2b 80 00 	movl   $0x802bb9,(%esp)
  801446:	e8 29 ee ff ff       	call   800274 <cprintf>
		return -E_INVAL;
  80144b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801450:	eb 24                	jmp    801476 <read+0x8c>
	}
	if (!dev->dev_read)
  801452:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801455:	8b 52 08             	mov    0x8(%edx),%edx
  801458:	85 d2                	test   %edx,%edx
  80145a:	74 15                	je     801471 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80145c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80145f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801463:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801466:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80146a:	89 04 24             	mov    %eax,(%esp)
  80146d:	ff d2                	call   *%edx
  80146f:	eb 05                	jmp    801476 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801471:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801476:	83 c4 24             	add    $0x24,%esp
  801479:	5b                   	pop    %ebx
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	57                   	push   %edi
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
  801482:	83 ec 1c             	sub    $0x1c,%esp
  801485:	8b 7d 08             	mov    0x8(%ebp),%edi
  801488:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80148b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801490:	eb 23                	jmp    8014b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801492:	89 f0                	mov    %esi,%eax
  801494:	29 d8                	sub    %ebx,%eax
  801496:	89 44 24 08          	mov    %eax,0x8(%esp)
  80149a:	89 d8                	mov    %ebx,%eax
  80149c:	03 45 0c             	add    0xc(%ebp),%eax
  80149f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a3:	89 3c 24             	mov    %edi,(%esp)
  8014a6:	e8 3f ff ff ff       	call   8013ea <read>
		if (m < 0)
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	78 10                	js     8014bf <readn+0x43>
			return m;
		if (m == 0)
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 0a                	je     8014bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b3:	01 c3                	add    %eax,%ebx
  8014b5:	39 f3                	cmp    %esi,%ebx
  8014b7:	72 d9                	jb     801492 <readn+0x16>
  8014b9:	89 d8                	mov    %ebx,%eax
  8014bb:	eb 02                	jmp    8014bf <readn+0x43>
  8014bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014bf:	83 c4 1c             	add    $0x1c,%esp
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5f                   	pop    %edi
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 24             	sub    $0x24,%esp
  8014ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d8:	89 1c 24             	mov    %ebx,(%esp)
  8014db:	e8 76 fc ff ff       	call   801156 <fd_lookup>
  8014e0:	89 c2                	mov    %eax,%edx
  8014e2:	85 d2                	test   %edx,%edx
  8014e4:	78 68                	js     80154e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f0:	8b 00                	mov    (%eax),%eax
  8014f2:	89 04 24             	mov    %eax,(%esp)
  8014f5:	e8 b2 fc ff ff       	call   8011ac <dev_lookup>
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	78 50                	js     80154e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801501:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801505:	75 23                	jne    80152a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801507:	a1 08 40 80 00       	mov    0x804008,%eax
  80150c:	8b 40 48             	mov    0x48(%eax),%eax
  80150f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801513:	89 44 24 04          	mov    %eax,0x4(%esp)
  801517:	c7 04 24 d5 2b 80 00 	movl   $0x802bd5,(%esp)
  80151e:	e8 51 ed ff ff       	call   800274 <cprintf>
		return -E_INVAL;
  801523:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801528:	eb 24                	jmp    80154e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80152a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152d:	8b 52 0c             	mov    0xc(%edx),%edx
  801530:	85 d2                	test   %edx,%edx
  801532:	74 15                	je     801549 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801534:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801537:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80153b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80153e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801542:	89 04 24             	mov    %eax,(%esp)
  801545:	ff d2                	call   *%edx
  801547:	eb 05                	jmp    80154e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801549:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80154e:	83 c4 24             	add    $0x24,%esp
  801551:	5b                   	pop    %ebx
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    

00801554 <seek>:

int
seek(int fdnum, off_t offset)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80155a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80155d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 ea fb ff ff       	call   801156 <fd_lookup>
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 0e                	js     80157e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801570:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801573:	8b 55 0c             	mov    0xc(%ebp),%edx
  801576:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	53                   	push   %ebx
  801584:	83 ec 24             	sub    $0x24,%esp
  801587:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801591:	89 1c 24             	mov    %ebx,(%esp)
  801594:	e8 bd fb ff ff       	call   801156 <fd_lookup>
  801599:	89 c2                	mov    %eax,%edx
  80159b:	85 d2                	test   %edx,%edx
  80159d:	78 61                	js     801600 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a9:	8b 00                	mov    (%eax),%eax
  8015ab:	89 04 24             	mov    %eax,(%esp)
  8015ae:	e8 f9 fb ff ff       	call   8011ac <dev_lookup>
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 49                	js     801600 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015be:	75 23                	jne    8015e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015c0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015c5:	8b 40 48             	mov    0x48(%eax),%eax
  8015c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d0:	c7 04 24 98 2b 80 00 	movl   $0x802b98,(%esp)
  8015d7:	e8 98 ec ff ff       	call   800274 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e1:	eb 1d                	jmp    801600 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e6:	8b 52 18             	mov    0x18(%edx),%edx
  8015e9:	85 d2                	test   %edx,%edx
  8015eb:	74 0e                	je     8015fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015f4:	89 04 24             	mov    %eax,(%esp)
  8015f7:	ff d2                	call   *%edx
  8015f9:	eb 05                	jmp    801600 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801600:	83 c4 24             	add    $0x24,%esp
  801603:	5b                   	pop    %ebx
  801604:	5d                   	pop    %ebp
  801605:	c3                   	ret    

00801606 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	53                   	push   %ebx
  80160a:	83 ec 24             	sub    $0x24,%esp
  80160d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801610:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801613:	89 44 24 04          	mov    %eax,0x4(%esp)
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	89 04 24             	mov    %eax,(%esp)
  80161d:	e8 34 fb ff ff       	call   801156 <fd_lookup>
  801622:	89 c2                	mov    %eax,%edx
  801624:	85 d2                	test   %edx,%edx
  801626:	78 52                	js     80167a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801628:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	89 04 24             	mov    %eax,(%esp)
  801637:	e8 70 fb ff ff       	call   8011ac <dev_lookup>
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 3a                	js     80167a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801643:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801647:	74 2c                	je     801675 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801649:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80164c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801653:	00 00 00 
	stat->st_isdir = 0;
  801656:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80165d:	00 00 00 
	stat->st_dev = dev;
  801660:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801666:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80166a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166d:	89 14 24             	mov    %edx,(%esp)
  801670:	ff 50 14             	call   *0x14(%eax)
  801673:	eb 05                	jmp    80167a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801675:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80167a:	83 c4 24             	add    $0x24,%esp
  80167d:	5b                   	pop    %ebx
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    

00801680 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
  801685:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801688:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80168f:	00 
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	89 04 24             	mov    %eax,(%esp)
  801696:	e8 1b 02 00 00       	call   8018b6 <open>
  80169b:	89 c3                	mov    %eax,%ebx
  80169d:	85 db                	test   %ebx,%ebx
  80169f:	78 1b                	js     8016bc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a8:	89 1c 24             	mov    %ebx,(%esp)
  8016ab:	e8 56 ff ff ff       	call   801606 <fstat>
  8016b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016b2:	89 1c 24             	mov    %ebx,(%esp)
  8016b5:	e8 cd fb ff ff       	call   801287 <close>
	return r;
  8016ba:	89 f0                	mov    %esi,%eax
}
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	5b                   	pop    %ebx
  8016c0:	5e                   	pop    %esi
  8016c1:	5d                   	pop    %ebp
  8016c2:	c3                   	ret    

008016c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	56                   	push   %esi
  8016c7:	53                   	push   %ebx
  8016c8:	83 ec 10             	sub    $0x10,%esp
  8016cb:	89 c6                	mov    %eax,%esi
  8016cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016cf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016d6:	75 11                	jne    8016e9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016df:	e8 7b 0d 00 00       	call   80245f <ipc_find_env>
  8016e4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016e9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016f0:	00 
  8016f1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8016f8:	00 
  8016f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016fd:	a1 00 40 80 00       	mov    0x804000,%eax
  801702:	89 04 24             	mov    %eax,(%esp)
  801705:	e8 ea 0c 00 00       	call   8023f4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80170a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801711:	00 
  801712:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801716:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171d:	e8 7e 0c 00 00       	call   8023a0 <ipc_recv>
}
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	5b                   	pop    %ebx
  801726:	5e                   	pop    %esi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8b 40 0c             	mov    0xc(%eax),%eax
  801735:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80173a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801742:	ba 00 00 00 00       	mov    $0x0,%edx
  801747:	b8 02 00 00 00       	mov    $0x2,%eax
  80174c:	e8 72 ff ff ff       	call   8016c3 <fsipc>
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	8b 40 0c             	mov    0xc(%eax),%eax
  80175f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801764:	ba 00 00 00 00       	mov    $0x0,%edx
  801769:	b8 06 00 00 00       	mov    $0x6,%eax
  80176e:	e8 50 ff ff ff       	call   8016c3 <fsipc>
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	53                   	push   %ebx
  801779:	83 ec 14             	sub    $0x14,%esp
  80177c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8b 40 0c             	mov    0xc(%eax),%eax
  801785:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80178a:	ba 00 00 00 00       	mov    $0x0,%edx
  80178f:	b8 05 00 00 00       	mov    $0x5,%eax
  801794:	e8 2a ff ff ff       	call   8016c3 <fsipc>
  801799:	89 c2                	mov    %eax,%edx
  80179b:	85 d2                	test   %edx,%edx
  80179d:	78 2b                	js     8017ca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80179f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017a6:	00 
  8017a7:	89 1c 24             	mov    %ebx,(%esp)
  8017aa:	e8 e8 f0 ff ff       	call   800897 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017af:	a1 80 50 80 00       	mov    0x805080,%eax
  8017b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ba:	a1 84 50 80 00       	mov    0x805084,%eax
  8017bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ca:	83 c4 14             	add    $0x14,%esp
  8017cd:	5b                   	pop    %ebx
  8017ce:	5d                   	pop    %ebp
  8017cf:	c3                   	ret    

008017d0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 18             	sub    $0x18,%esp
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8017df:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8017e5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8017fc:	e8 9b f2 ff ff       	call   800a9c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801801:	ba 00 00 00 00       	mov    $0x0,%edx
  801806:	b8 04 00 00 00       	mov    $0x4,%eax
  80180b:	e8 b3 fe ff ff       	call   8016c3 <fsipc>
		return r;
	}

	return r;
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	56                   	push   %esi
  801816:	53                   	push   %ebx
  801817:	83 ec 10             	sub    $0x10,%esp
  80181a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8b 40 0c             	mov    0xc(%eax),%eax
  801823:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801828:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80182e:	ba 00 00 00 00       	mov    $0x0,%edx
  801833:	b8 03 00 00 00       	mov    $0x3,%eax
  801838:	e8 86 fe ff ff       	call   8016c3 <fsipc>
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 6a                	js     8018ad <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801843:	39 c6                	cmp    %eax,%esi
  801845:	73 24                	jae    80186b <devfile_read+0x59>
  801847:	c7 44 24 0c 08 2c 80 	movl   $0x802c08,0xc(%esp)
  80184e:	00 
  80184f:	c7 44 24 08 0f 2c 80 	movl   $0x802c0f,0x8(%esp)
  801856:	00 
  801857:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80185e:	00 
  80185f:	c7 04 24 24 2c 80 00 	movl   $0x802c24,(%esp)
  801866:	e8 10 e9 ff ff       	call   80017b <_panic>
	assert(r <= PGSIZE);
  80186b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801870:	7e 24                	jle    801896 <devfile_read+0x84>
  801872:	c7 44 24 0c 2f 2c 80 	movl   $0x802c2f,0xc(%esp)
  801879:	00 
  80187a:	c7 44 24 08 0f 2c 80 	movl   $0x802c0f,0x8(%esp)
  801881:	00 
  801882:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801889:	00 
  80188a:	c7 04 24 24 2c 80 00 	movl   $0x802c24,(%esp)
  801891:	e8 e5 e8 ff ff       	call   80017b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801896:	89 44 24 08          	mov    %eax,0x8(%esp)
  80189a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018a1:	00 
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	89 04 24             	mov    %eax,(%esp)
  8018a8:	e8 87 f1 ff ff       	call   800a34 <memmove>
	return r;
}
  8018ad:	89 d8                	mov    %ebx,%eax
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 24             	sub    $0x24,%esp
  8018bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018c0:	89 1c 24             	mov    %ebx,(%esp)
  8018c3:	e8 98 ef ff ff       	call   800860 <strlen>
  8018c8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018cd:	7f 60                	jg     80192f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d2:	89 04 24             	mov    %eax,(%esp)
  8018d5:	e8 2d f8 ff ff       	call   801107 <fd_alloc>
  8018da:	89 c2                	mov    %eax,%edx
  8018dc:	85 d2                	test   %edx,%edx
  8018de:	78 54                	js     801934 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018e4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018eb:	e8 a7 ef ff ff       	call   800897 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801900:	e8 be fd ff ff       	call   8016c3 <fsipc>
  801905:	89 c3                	mov    %eax,%ebx
  801907:	85 c0                	test   %eax,%eax
  801909:	79 17                	jns    801922 <open+0x6c>
		fd_close(fd, 0);
  80190b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801912:	00 
  801913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801916:	89 04 24             	mov    %eax,(%esp)
  801919:	e8 e8 f8 ff ff       	call   801206 <fd_close>
		return r;
  80191e:	89 d8                	mov    %ebx,%eax
  801920:	eb 12                	jmp    801934 <open+0x7e>
	}

	return fd2num(fd);
  801922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801925:	89 04 24             	mov    %eax,(%esp)
  801928:	e8 b3 f7 ff ff       	call   8010e0 <fd2num>
  80192d:	eb 05                	jmp    801934 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80192f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801934:	83 c4 24             	add    $0x24,%esp
  801937:	5b                   	pop    %ebx
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    

0080193a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801940:	ba 00 00 00 00       	mov    $0x0,%edx
  801945:	b8 08 00 00 00       	mov    $0x8,%eax
  80194a:	e8 74 fd ff ff       	call   8016c3 <fsipc>
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    
  801951:	66 90                	xchg   %ax,%ax
  801953:	66 90                	xchg   %ax,%ax
  801955:	66 90                	xchg   %ax,%ax
  801957:	66 90                	xchg   %ax,%ax
  801959:	66 90                	xchg   %ax,%ax
  80195b:	66 90                	xchg   %ax,%ax
  80195d:	66 90                	xchg   %ax,%ax
  80195f:	90                   	nop

00801960 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801966:	c7 44 24 04 3b 2c 80 	movl   $0x802c3b,0x4(%esp)
  80196d:	00 
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	89 04 24             	mov    %eax,(%esp)
  801974:	e8 1e ef ff ff       	call   800897 <strcpy>
	return 0;
}
  801979:	b8 00 00 00 00       	mov    $0x0,%eax
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
  801984:	83 ec 14             	sub    $0x14,%esp
  801987:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80198a:	89 1c 24             	mov    %ebx,(%esp)
  80198d:	e8 0c 0b 00 00       	call   80249e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801992:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801997:	83 f8 01             	cmp    $0x1,%eax
  80199a:	75 0d                	jne    8019a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80199c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 29 03 00 00       	call   801cd0 <nsipc_close>
  8019a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8019a9:	89 d0                	mov    %edx,%eax
  8019ab:	83 c4 14             	add    $0x14,%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    

008019b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019be:	00 
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d3:	89 04 24             	mov    %eax,(%esp)
  8019d6:	e8 f0 03 00 00       	call   801dcb <nsipc_send>
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ea:	00 
  8019eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ff:	89 04 24             	mov    %eax,(%esp)
  801a02:	e8 44 03 00 00       	call   801d4b <nsipc_recv>
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a0f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a12:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a16:	89 04 24             	mov    %eax,(%esp)
  801a19:	e8 38 f7 ff ff       	call   801156 <fd_lookup>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 17                	js     801a39 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a25:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a2b:	39 08                	cmp    %ecx,(%eax)
  801a2d:	75 05                	jne    801a34 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a32:	eb 05                	jmp    801a39 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 20             	sub    $0x20,%esp
  801a43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a48:	89 04 24             	mov    %eax,(%esp)
  801a4b:	e8 b7 f6 ff ff       	call   801107 <fd_alloc>
  801a50:	89 c3                	mov    %eax,%ebx
  801a52:	85 c0                	test   %eax,%eax
  801a54:	78 21                	js     801a77 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a5d:	00 
  801a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6c:	e8 42 f2 ff ff       	call   800cb3 <sys_page_alloc>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	85 c0                	test   %eax,%eax
  801a75:	79 0c                	jns    801a83 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a77:	89 34 24             	mov    %esi,(%esp)
  801a7a:	e8 51 02 00 00       	call   801cd0 <nsipc_close>
		return r;
  801a7f:	89 d8                	mov    %ebx,%eax
  801a81:	eb 20                	jmp    801aa3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a83:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a91:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a98:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a9b:	89 14 24             	mov    %edx,(%esp)
  801a9e:	e8 3d f6 ff ff       	call   8010e0 <fd2num>
}
  801aa3:	83 c4 20             	add    $0x20,%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    

00801aaa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	e8 51 ff ff ff       	call   801a09 <fd2sockid>
		return r;
  801ab8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 23                	js     801ae1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801abe:	8b 55 10             	mov    0x10(%ebp),%edx
  801ac1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801acc:	89 04 24             	mov    %eax,(%esp)
  801acf:	e8 45 01 00 00       	call   801c19 <nsipc_accept>
		return r;
  801ad4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	78 07                	js     801ae1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801ada:	e8 5c ff ff ff       	call   801a3b <alloc_sockfd>
  801adf:	89 c1                	mov    %eax,%ecx
}
  801ae1:	89 c8                	mov    %ecx,%eax
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	e8 16 ff ff ff       	call   801a09 <fd2sockid>
  801af3:	89 c2                	mov    %eax,%edx
  801af5:	85 d2                	test   %edx,%edx
  801af7:	78 16                	js     801b0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801af9:	8b 45 10             	mov    0x10(%ebp),%eax
  801afc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b07:	89 14 24             	mov    %edx,(%esp)
  801b0a:	e8 60 01 00 00       	call   801c6f <nsipc_bind>
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <shutdown>:

int
shutdown(int s, int how)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	e8 ea fe ff ff       	call   801a09 <fd2sockid>
  801b1f:	89 c2                	mov    %eax,%edx
  801b21:	85 d2                	test   %edx,%edx
  801b23:	78 0f                	js     801b34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2c:	89 14 24             	mov    %edx,(%esp)
  801b2f:	e8 7a 01 00 00       	call   801cae <nsipc_shutdown>
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	e8 c5 fe ff ff       	call   801a09 <fd2sockid>
  801b44:	89 c2                	mov    %eax,%edx
  801b46:	85 d2                	test   %edx,%edx
  801b48:	78 16                	js     801b60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b58:	89 14 24             	mov    %edx,(%esp)
  801b5b:	e8 8a 01 00 00       	call   801cea <nsipc_connect>
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <listen>:

int
listen(int s, int backlog)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	e8 99 fe ff ff       	call   801a09 <fd2sockid>
  801b70:	89 c2                	mov    %eax,%edx
  801b72:	85 d2                	test   %edx,%edx
  801b74:	78 0f                	js     801b85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7d:	89 14 24             	mov    %edx,(%esp)
  801b80:	e8 a4 01 00 00       	call   801d29 <nsipc_listen>
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	89 04 24             	mov    %eax,(%esp)
  801ba1:	e8 98 02 00 00       	call   801e3e <nsipc_socket>
  801ba6:	89 c2                	mov    %eax,%edx
  801ba8:	85 d2                	test   %edx,%edx
  801baa:	78 05                	js     801bb1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801bac:	e8 8a fe ff ff       	call   801a3b <alloc_sockfd>
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	53                   	push   %ebx
  801bb7:	83 ec 14             	sub    $0x14,%esp
  801bba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bbc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bc3:	75 11                	jne    801bd6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bc5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801bcc:	e8 8e 08 00 00       	call   80245f <ipc_find_env>
  801bd1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bdd:	00 
  801bde:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801be5:	00 
  801be6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bea:	a1 04 40 80 00       	mov    0x804004,%eax
  801bef:	89 04 24             	mov    %eax,(%esp)
  801bf2:	e8 fd 07 00 00       	call   8023f4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bf7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bfe:	00 
  801bff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c06:	00 
  801c07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0e:	e8 8d 07 00 00       	call   8023a0 <ipc_recv>
}
  801c13:	83 c4 14             	add    $0x14,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	56                   	push   %esi
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 10             	sub    $0x10,%esp
  801c21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c2c:	8b 06                	mov    (%esi),%eax
  801c2e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c33:	b8 01 00 00 00       	mov    $0x1,%eax
  801c38:	e8 76 ff ff ff       	call   801bb3 <nsipc>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 23                	js     801c66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c43:	a1 10 60 80 00       	mov    0x806010,%eax
  801c48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c53:	00 
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	89 04 24             	mov    %eax,(%esp)
  801c5a:	e8 d5 ed ff ff       	call   800a34 <memmove>
		*addrlen = ret->ret_addrlen;
  801c5f:	a1 10 60 80 00       	mov    0x806010,%eax
  801c64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801c66:	89 d8                	mov    %ebx,%eax
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    

00801c6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	53                   	push   %ebx
  801c73:	83 ec 14             	sub    $0x14,%esp
  801c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c93:	e8 9c ed ff ff       	call   800a34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801ca3:	e8 0b ff ff ff       	call   801bb3 <nsipc>
}
  801ca8:	83 c4 14             	add    $0x14,%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801cc9:	e8 e5 fe ff ff       	call   801bb3 <nsipc>
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <nsipc_close>:

int
nsipc_close(int s)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cde:	b8 04 00 00 00       	mov    $0x4,%eax
  801ce3:	e8 cb fe ff ff       	call   801bb3 <nsipc>
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
  801cee:	83 ec 14             	sub    $0x14,%esp
  801cf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d07:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d0e:	e8 21 ed ff ff       	call   800a34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d13:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d19:	b8 05 00 00 00       	mov    $0x5,%eax
  801d1e:	e8 90 fe ff ff       	call   801bb3 <nsipc>
}
  801d23:	83 c4 14             	add    $0x14,%esp
  801d26:	5b                   	pop    %ebx
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d44:	e8 6a fe ff ff       	call   801bb3 <nsipc>
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 10             	sub    $0x10,%esp
  801d53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d64:	8b 45 14             	mov    0x14(%ebp),%eax
  801d67:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d6c:	b8 07 00 00 00       	mov    $0x7,%eax
  801d71:	e8 3d fe ff ff       	call   801bb3 <nsipc>
  801d76:	89 c3                	mov    %eax,%ebx
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 46                	js     801dc2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d7c:	39 f0                	cmp    %esi,%eax
  801d7e:	7f 07                	jg     801d87 <nsipc_recv+0x3c>
  801d80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d85:	7e 24                	jle    801dab <nsipc_recv+0x60>
  801d87:	c7 44 24 0c 47 2c 80 	movl   $0x802c47,0xc(%esp)
  801d8e:	00 
  801d8f:	c7 44 24 08 0f 2c 80 	movl   $0x802c0f,0x8(%esp)
  801d96:	00 
  801d97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d9e:	00 
  801d9f:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  801da6:	e8 d0 e3 ff ff       	call   80017b <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dab:	89 44 24 08          	mov    %eax,0x8(%esp)
  801daf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801db6:	00 
  801db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dba:	89 04 24             	mov    %eax,(%esp)
  801dbd:	e8 72 ec ff ff       	call   800a34 <memmove>
	}

	return r;
}
  801dc2:	89 d8                	mov    %ebx,%eax
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 14             	sub    $0x14,%esp
  801dd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ddd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801de3:	7e 24                	jle    801e09 <nsipc_send+0x3e>
  801de5:	c7 44 24 0c 68 2c 80 	movl   $0x802c68,0xc(%esp)
  801dec:	00 
  801ded:	c7 44 24 08 0f 2c 80 	movl   $0x802c0f,0x8(%esp)
  801df4:	00 
  801df5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801dfc:	00 
  801dfd:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  801e04:	e8 72 e3 ff ff       	call   80017b <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e14:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e1b:	e8 14 ec ff ff       	call   800a34 <memmove>
	nsipcbuf.send.req_size = size;
  801e20:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e26:	8b 45 14             	mov    0x14(%ebp),%eax
  801e29:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e2e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e33:	e8 7b fd ff ff       	call   801bb3 <nsipc>
}
  801e38:	83 c4 14             	add    $0x14,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5d                   	pop    %ebp
  801e3d:	c3                   	ret    

00801e3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e54:	8b 45 10             	mov    0x10(%ebp),%eax
  801e57:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e5c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e61:	e8 4d fd ff ff       	call   801bb3 <nsipc>
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	56                   	push   %esi
  801e6c:	53                   	push   %ebx
  801e6d:	83 ec 10             	sub    $0x10,%esp
  801e70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	89 04 24             	mov    %eax,(%esp)
  801e79:	e8 72 f2 ff ff       	call   8010f0 <fd2data>
  801e7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e80:	c7 44 24 04 74 2c 80 	movl   $0x802c74,0x4(%esp)
  801e87:	00 
  801e88:	89 1c 24             	mov    %ebx,(%esp)
  801e8b:	e8 07 ea ff ff       	call   800897 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e90:	8b 46 04             	mov    0x4(%esi),%eax
  801e93:	2b 06                	sub    (%esi),%eax
  801e95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ea2:	00 00 00 
	stat->st_dev = &devpipe;
  801ea5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801eac:	30 80 00 
	return 0;
}
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	5b                   	pop    %ebx
  801eb8:	5e                   	pop    %esi
  801eb9:	5d                   	pop    %ebp
  801eba:	c3                   	ret    

00801ebb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	53                   	push   %ebx
  801ebf:	83 ec 14             	sub    $0x14,%esp
  801ec2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ec5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ec9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed0:	e8 85 ee ff ff       	call   800d5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ed5:	89 1c 24             	mov    %ebx,(%esp)
  801ed8:	e8 13 f2 ff ff       	call   8010f0 <fd2data>
  801edd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee8:	e8 6d ee ff ff       	call   800d5a <sys_page_unmap>
}
  801eed:	83 c4 14             	add    $0x14,%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    

00801ef3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	57                   	push   %edi
  801ef7:	56                   	push   %esi
  801ef8:	53                   	push   %ebx
  801ef9:	83 ec 2c             	sub    $0x2c,%esp
  801efc:	89 c6                	mov    %eax,%esi
  801efe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f01:	a1 08 40 80 00       	mov    0x804008,%eax
  801f06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f09:	89 34 24             	mov    %esi,(%esp)
  801f0c:	e8 8d 05 00 00       	call   80249e <pageref>
  801f11:	89 c7                	mov    %eax,%edi
  801f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f16:	89 04 24             	mov    %eax,(%esp)
  801f19:	e8 80 05 00 00       	call   80249e <pageref>
  801f1e:	39 c7                	cmp    %eax,%edi
  801f20:	0f 94 c2             	sete   %dl
  801f23:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f26:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801f2c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f2f:	39 fb                	cmp    %edi,%ebx
  801f31:	74 21                	je     801f54 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f33:	84 d2                	test   %dl,%dl
  801f35:	74 ca                	je     801f01 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f37:	8b 51 58             	mov    0x58(%ecx),%edx
  801f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f46:	c7 04 24 7b 2c 80 00 	movl   $0x802c7b,(%esp)
  801f4d:	e8 22 e3 ff ff       	call   800274 <cprintf>
  801f52:	eb ad                	jmp    801f01 <_pipeisclosed+0xe>
	}
}
  801f54:	83 c4 2c             	add    $0x2c,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	57                   	push   %edi
  801f60:	56                   	push   %esi
  801f61:	53                   	push   %ebx
  801f62:	83 ec 1c             	sub    $0x1c,%esp
  801f65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f68:	89 34 24             	mov    %esi,(%esp)
  801f6b:	e8 80 f1 ff ff       	call   8010f0 <fd2data>
  801f70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f72:	bf 00 00 00 00       	mov    $0x0,%edi
  801f77:	eb 45                	jmp    801fbe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f79:	89 da                	mov    %ebx,%edx
  801f7b:	89 f0                	mov    %esi,%eax
  801f7d:	e8 71 ff ff ff       	call   801ef3 <_pipeisclosed>
  801f82:	85 c0                	test   %eax,%eax
  801f84:	75 41                	jne    801fc7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f86:	e8 09 ed ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f8e:	8b 0b                	mov    (%ebx),%ecx
  801f90:	8d 51 20             	lea    0x20(%ecx),%edx
  801f93:	39 d0                	cmp    %edx,%eax
  801f95:	73 e2                	jae    801f79 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fa1:	99                   	cltd   
  801fa2:	c1 ea 1b             	shr    $0x1b,%edx
  801fa5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801fa8:	83 e1 1f             	and    $0x1f,%ecx
  801fab:	29 d1                	sub    %edx,%ecx
  801fad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801fb1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fb5:	83 c0 01             	add    $0x1,%eax
  801fb8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fbb:	83 c7 01             	add    $0x1,%edi
  801fbe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fc1:	75 c8                	jne    801f8b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fc3:	89 f8                	mov    %edi,%eax
  801fc5:	eb 05                	jmp    801fcc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fcc:	83 c4 1c             	add    $0x1c,%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5e                   	pop    %esi
  801fd1:	5f                   	pop    %edi
  801fd2:	5d                   	pop    %ebp
  801fd3:	c3                   	ret    

00801fd4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	57                   	push   %edi
  801fd8:	56                   	push   %esi
  801fd9:	53                   	push   %ebx
  801fda:	83 ec 1c             	sub    $0x1c,%esp
  801fdd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fe0:	89 3c 24             	mov    %edi,(%esp)
  801fe3:	e8 08 f1 ff ff       	call   8010f0 <fd2data>
  801fe8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fea:	be 00 00 00 00       	mov    $0x0,%esi
  801fef:	eb 3d                	jmp    80202e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ff1:	85 f6                	test   %esi,%esi
  801ff3:	74 04                	je     801ff9 <devpipe_read+0x25>
				return i;
  801ff5:	89 f0                	mov    %esi,%eax
  801ff7:	eb 43                	jmp    80203c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ff9:	89 da                	mov    %ebx,%edx
  801ffb:	89 f8                	mov    %edi,%eax
  801ffd:	e8 f1 fe ff ff       	call   801ef3 <_pipeisclosed>
  802002:	85 c0                	test   %eax,%eax
  802004:	75 31                	jne    802037 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802006:	e8 89 ec ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80200b:	8b 03                	mov    (%ebx),%eax
  80200d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802010:	74 df                	je     801ff1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802012:	99                   	cltd   
  802013:	c1 ea 1b             	shr    $0x1b,%edx
  802016:	01 d0                	add    %edx,%eax
  802018:	83 e0 1f             	and    $0x1f,%eax
  80201b:	29 d0                	sub    %edx,%eax
  80201d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802025:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802028:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80202b:	83 c6 01             	add    $0x1,%esi
  80202e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802031:	75 d8                	jne    80200b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802033:	89 f0                	mov    %esi,%eax
  802035:	eb 05                	jmp    80203c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80203c:	83 c4 1c             	add    $0x1c,%esp
  80203f:	5b                   	pop    %ebx
  802040:	5e                   	pop    %esi
  802041:	5f                   	pop    %edi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	56                   	push   %esi
  802048:	53                   	push   %ebx
  802049:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80204c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204f:	89 04 24             	mov    %eax,(%esp)
  802052:	e8 b0 f0 ff ff       	call   801107 <fd_alloc>
  802057:	89 c2                	mov    %eax,%edx
  802059:	85 d2                	test   %edx,%edx
  80205b:	0f 88 4d 01 00 00    	js     8021ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802061:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802068:	00 
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802070:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802077:	e8 37 ec ff ff       	call   800cb3 <sys_page_alloc>
  80207c:	89 c2                	mov    %eax,%edx
  80207e:	85 d2                	test   %edx,%edx
  802080:	0f 88 28 01 00 00    	js     8021ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802086:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802089:	89 04 24             	mov    %eax,(%esp)
  80208c:	e8 76 f0 ff ff       	call   801107 <fd_alloc>
  802091:	89 c3                	mov    %eax,%ebx
  802093:	85 c0                	test   %eax,%eax
  802095:	0f 88 fe 00 00 00    	js     802199 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020a2:	00 
  8020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b1:	e8 fd eb ff ff       	call   800cb3 <sys_page_alloc>
  8020b6:	89 c3                	mov    %eax,%ebx
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	0f 88 d9 00 00 00    	js     802199 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	89 04 24             	mov    %eax,(%esp)
  8020c6:	e8 25 f0 ff ff       	call   8010f0 <fd2data>
  8020cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020d4:	00 
  8020d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e0:	e8 ce eb ff ff       	call   800cb3 <sys_page_alloc>
  8020e5:	89 c3                	mov    %eax,%ebx
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 88 97 00 00 00    	js     802186 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	89 04 24             	mov    %eax,(%esp)
  8020f5:	e8 f6 ef ff ff       	call   8010f0 <fd2data>
  8020fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802101:	00 
  802102:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802106:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80210d:	00 
  80210e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802112:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802119:	e8 e9 eb ff ff       	call   800d07 <sys_page_map>
  80211e:	89 c3                	mov    %eax,%ebx
  802120:	85 c0                	test   %eax,%eax
  802122:	78 52                	js     802176 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802124:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802139:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80213f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802142:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802147:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	89 04 24             	mov    %eax,(%esp)
  802154:	e8 87 ef ff ff       	call   8010e0 <fd2num>
  802159:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802161:	89 04 24             	mov    %eax,(%esp)
  802164:	e8 77 ef ff ff       	call   8010e0 <fd2num>
  802169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80216c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	eb 38                	jmp    8021ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802176:	89 74 24 04          	mov    %esi,0x4(%esp)
  80217a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802181:	e8 d4 eb ff ff       	call   800d5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802194:	e8 c1 eb ff ff       	call   800d5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a7:	e8 ae eb ff ff       	call   800d5a <sys_page_unmap>
  8021ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8021ae:	83 c4 30             	add    $0x30,%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    

008021b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	89 04 24             	mov    %eax,(%esp)
  8021c8:	e8 89 ef ff ff       	call   801156 <fd_lookup>
  8021cd:	89 c2                	mov    %eax,%edx
  8021cf:	85 d2                	test   %edx,%edx
  8021d1:	78 15                	js     8021e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	89 04 24             	mov    %eax,(%esp)
  8021d9:	e8 12 ef ff ff       	call   8010f0 <fd2data>
	return _pipeisclosed(fd, p);
  8021de:	89 c2                	mov    %eax,%edx
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	e8 0b fd ff ff       	call   801ef3 <_pipeisclosed>
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    

008021fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802200:	c7 44 24 04 93 2c 80 	movl   $0x802c93,0x4(%esp)
  802207:	00 
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	89 04 24             	mov    %eax,(%esp)
  80220e:	e8 84 e6 ff ff       	call   800897 <strcpy>
	return 0;
}
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	57                   	push   %edi
  80221e:	56                   	push   %esi
  80221f:	53                   	push   %ebx
  802220:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802226:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80222b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802231:	eb 31                	jmp    802264 <devcons_write+0x4a>
		m = n - tot;
  802233:	8b 75 10             	mov    0x10(%ebp),%esi
  802236:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802238:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80223b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802240:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802243:	89 74 24 08          	mov    %esi,0x8(%esp)
  802247:	03 45 0c             	add    0xc(%ebp),%eax
  80224a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224e:	89 3c 24             	mov    %edi,(%esp)
  802251:	e8 de e7 ff ff       	call   800a34 <memmove>
		sys_cputs(buf, m);
  802256:	89 74 24 04          	mov    %esi,0x4(%esp)
  80225a:	89 3c 24             	mov    %edi,(%esp)
  80225d:	e8 84 e9 ff ff       	call   800be6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802262:	01 f3                	add    %esi,%ebx
  802264:	89 d8                	mov    %ebx,%eax
  802266:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802269:	72 c8                	jb     802233 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80226b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    

00802276 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802281:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802285:	75 07                	jne    80228e <devcons_read+0x18>
  802287:	eb 2a                	jmp    8022b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802289:	e8 06 ea ff ff       	call   800c94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80228e:	66 90                	xchg   %ax,%ax
  802290:	e8 6f e9 ff ff       	call   800c04 <sys_cgetc>
  802295:	85 c0                	test   %eax,%eax
  802297:	74 f0                	je     802289 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802299:	85 c0                	test   %eax,%eax
  80229b:	78 16                	js     8022b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80229d:	83 f8 04             	cmp    $0x4,%eax
  8022a0:	74 0c                	je     8022ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	88 02                	mov    %al,(%edx)
	return 1;
  8022a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ac:	eb 05                	jmp    8022b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8022ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022c8:	00 
  8022c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022cc:	89 04 24             	mov    %eax,(%esp)
  8022cf:	e8 12 e9 ff ff       	call   800be6 <sys_cputs>
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <getchar>:

int
getchar(void)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022e3:	00 
  8022e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f2:	e8 f3 f0 ff ff       	call   8013ea <read>
	if (r < 0)
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	78 0f                	js     80230a <getchar+0x34>
		return r;
	if (r < 1)
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	7e 06                	jle    802305 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802303:	eb 05                	jmp    80230a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802305:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802312:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802315:	89 44 24 04          	mov    %eax,0x4(%esp)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	89 04 24             	mov    %eax,(%esp)
  80231f:	e8 32 ee ff ff       	call   801156 <fd_lookup>
  802324:	85 c0                	test   %eax,%eax
  802326:	78 11                	js     802339 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802331:	39 10                	cmp    %edx,(%eax)
  802333:	0f 94 c0             	sete   %al
  802336:	0f b6 c0             	movzbl %al,%eax
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <opencons>:

int
opencons(void)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802341:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802344:	89 04 24             	mov    %eax,(%esp)
  802347:	e8 bb ed ff ff       	call   801107 <fd_alloc>
		return r;
  80234c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 40                	js     802392 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802352:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802359:	00 
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802361:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802368:	e8 46 e9 ff ff       	call   800cb3 <sys_page_alloc>
		return r;
  80236d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 1f                	js     802392 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802373:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802388:	89 04 24             	mov    %eax,(%esp)
  80238b:	e8 50 ed ff ff       	call   8010e0 <fd2num>
  802390:	89 c2                	mov    %eax,%edx
}
  802392:	89 d0                	mov    %edx,%eax
  802394:	c9                   	leave  
  802395:	c3                   	ret    
  802396:	66 90                	xchg   %ax,%ax
  802398:	66 90                	xchg   %ax,%ax
  80239a:	66 90                	xchg   %ax,%ax
  80239c:	66 90                	xchg   %ax,%ax
  80239e:	66 90                	xchg   %ax,%ax

008023a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	56                   	push   %esi
  8023a4:	53                   	push   %ebx
  8023a5:	83 ec 10             	sub    $0x10,%esp
  8023a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023b1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8023b3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023b8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8023bb:	89 04 24             	mov    %eax,(%esp)
  8023be:	e8 06 eb ff ff       	call   800ec9 <sys_ipc_recv>
  8023c3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8023c5:	85 d2                	test   %edx,%edx
  8023c7:	75 24                	jne    8023ed <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8023c9:	85 f6                	test   %esi,%esi
  8023cb:	74 0a                	je     8023d7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8023cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8023d2:	8b 40 74             	mov    0x74(%eax),%eax
  8023d5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8023d7:	85 db                	test   %ebx,%ebx
  8023d9:	74 0a                	je     8023e5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8023db:	a1 08 40 80 00       	mov    0x804008,%eax
  8023e0:	8b 40 78             	mov    0x78(%eax),%eax
  8023e3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8023e5:	a1 08 40 80 00       	mov    0x804008,%eax
  8023ea:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8023ed:	83 c4 10             	add    $0x10,%esp
  8023f0:	5b                   	pop    %ebx
  8023f1:	5e                   	pop    %esi
  8023f2:	5d                   	pop    %ebp
  8023f3:	c3                   	ret    

008023f4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	57                   	push   %edi
  8023f8:	56                   	push   %esi
  8023f9:	53                   	push   %ebx
  8023fa:	83 ec 1c             	sub    $0x1c,%esp
  8023fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  802400:	8b 75 0c             	mov    0xc(%ebp),%esi
  802403:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802406:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802408:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80240d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802410:	8b 45 14             	mov    0x14(%ebp),%eax
  802413:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802417:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80241b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80241f:	89 3c 24             	mov    %edi,(%esp)
  802422:	e8 7f ea ff ff       	call   800ea6 <sys_ipc_try_send>

		if (ret == 0)
  802427:	85 c0                	test   %eax,%eax
  802429:	74 2c                	je     802457 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80242b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80242e:	74 20                	je     802450 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802430:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802434:	c7 44 24 08 a0 2c 80 	movl   $0x802ca0,0x8(%esp)
  80243b:	00 
  80243c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802443:	00 
  802444:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  80244b:	e8 2b dd ff ff       	call   80017b <_panic>
		}

		sys_yield();
  802450:	e8 3f e8 ff ff       	call   800c94 <sys_yield>
	}
  802455:	eb b9                	jmp    802410 <ipc_send+0x1c>
}
  802457:	83 c4 1c             	add    $0x1c,%esp
  80245a:	5b                   	pop    %ebx
  80245b:	5e                   	pop    %esi
  80245c:	5f                   	pop    %edi
  80245d:	5d                   	pop    %ebp
  80245e:	c3                   	ret    

0080245f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802465:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80246a:	89 c2                	mov    %eax,%edx
  80246c:	c1 e2 07             	shl    $0x7,%edx
  80246f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802476:	8b 52 50             	mov    0x50(%edx),%edx
  802479:	39 ca                	cmp    %ecx,%edx
  80247b:	75 11                	jne    80248e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80247d:	89 c2                	mov    %eax,%edx
  80247f:	c1 e2 07             	shl    $0x7,%edx
  802482:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802489:	8b 40 40             	mov    0x40(%eax),%eax
  80248c:	eb 0e                	jmp    80249c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80248e:	83 c0 01             	add    $0x1,%eax
  802491:	3d 00 04 00 00       	cmp    $0x400,%eax
  802496:	75 d2                	jne    80246a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802498:	66 b8 00 00          	mov    $0x0,%ax
}
  80249c:	5d                   	pop    %ebp
  80249d:	c3                   	ret    

0080249e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024a4:	89 d0                	mov    %edx,%eax
  8024a6:	c1 e8 16             	shr    $0x16,%eax
  8024a9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024b5:	f6 c1 01             	test   $0x1,%cl
  8024b8:	74 1d                	je     8024d7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024ba:	c1 ea 0c             	shr    $0xc,%edx
  8024bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024c4:	f6 c2 01             	test   $0x1,%dl
  8024c7:	74 0e                	je     8024d7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024c9:	c1 ea 0c             	shr    $0xc,%edx
  8024cc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024d3:	ef 
  8024d4:	0f b7 c0             	movzwl %ax,%eax
}
  8024d7:	5d                   	pop    %ebp
  8024d8:	c3                   	ret    
  8024d9:	66 90                	xchg   %ax,%ax
  8024db:	66 90                	xchg   %ax,%ax
  8024dd:	66 90                	xchg   %ax,%ax
  8024df:	90                   	nop

008024e0 <__udivdi3>:
  8024e0:	55                   	push   %ebp
  8024e1:	57                   	push   %edi
  8024e2:	56                   	push   %esi
  8024e3:	83 ec 0c             	sub    $0xc,%esp
  8024e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024fc:	89 ea                	mov    %ebp,%edx
  8024fe:	89 0c 24             	mov    %ecx,(%esp)
  802501:	75 2d                	jne    802530 <__udivdi3+0x50>
  802503:	39 e9                	cmp    %ebp,%ecx
  802505:	77 61                	ja     802568 <__udivdi3+0x88>
  802507:	85 c9                	test   %ecx,%ecx
  802509:	89 ce                	mov    %ecx,%esi
  80250b:	75 0b                	jne    802518 <__udivdi3+0x38>
  80250d:	b8 01 00 00 00       	mov    $0x1,%eax
  802512:	31 d2                	xor    %edx,%edx
  802514:	f7 f1                	div    %ecx
  802516:	89 c6                	mov    %eax,%esi
  802518:	31 d2                	xor    %edx,%edx
  80251a:	89 e8                	mov    %ebp,%eax
  80251c:	f7 f6                	div    %esi
  80251e:	89 c5                	mov    %eax,%ebp
  802520:	89 f8                	mov    %edi,%eax
  802522:	f7 f6                	div    %esi
  802524:	89 ea                	mov    %ebp,%edx
  802526:	83 c4 0c             	add    $0xc,%esp
  802529:	5e                   	pop    %esi
  80252a:	5f                   	pop    %edi
  80252b:	5d                   	pop    %ebp
  80252c:	c3                   	ret    
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	39 e8                	cmp    %ebp,%eax
  802532:	77 24                	ja     802558 <__udivdi3+0x78>
  802534:	0f bd e8             	bsr    %eax,%ebp
  802537:	83 f5 1f             	xor    $0x1f,%ebp
  80253a:	75 3c                	jne    802578 <__udivdi3+0x98>
  80253c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802540:	39 34 24             	cmp    %esi,(%esp)
  802543:	0f 86 9f 00 00 00    	jbe    8025e8 <__udivdi3+0x108>
  802549:	39 d0                	cmp    %edx,%eax
  80254b:	0f 82 97 00 00 00    	jb     8025e8 <__udivdi3+0x108>
  802551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802558:	31 d2                	xor    %edx,%edx
  80255a:	31 c0                	xor    %eax,%eax
  80255c:	83 c4 0c             	add    $0xc,%esp
  80255f:	5e                   	pop    %esi
  802560:	5f                   	pop    %edi
  802561:	5d                   	pop    %ebp
  802562:	c3                   	ret    
  802563:	90                   	nop
  802564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802568:	89 f8                	mov    %edi,%eax
  80256a:	f7 f1                	div    %ecx
  80256c:	31 d2                	xor    %edx,%edx
  80256e:	83 c4 0c             	add    $0xc,%esp
  802571:	5e                   	pop    %esi
  802572:	5f                   	pop    %edi
  802573:	5d                   	pop    %ebp
  802574:	c3                   	ret    
  802575:	8d 76 00             	lea    0x0(%esi),%esi
  802578:	89 e9                	mov    %ebp,%ecx
  80257a:	8b 3c 24             	mov    (%esp),%edi
  80257d:	d3 e0                	shl    %cl,%eax
  80257f:	89 c6                	mov    %eax,%esi
  802581:	b8 20 00 00 00       	mov    $0x20,%eax
  802586:	29 e8                	sub    %ebp,%eax
  802588:	89 c1                	mov    %eax,%ecx
  80258a:	d3 ef                	shr    %cl,%edi
  80258c:	89 e9                	mov    %ebp,%ecx
  80258e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802592:	8b 3c 24             	mov    (%esp),%edi
  802595:	09 74 24 08          	or     %esi,0x8(%esp)
  802599:	89 d6                	mov    %edx,%esi
  80259b:	d3 e7                	shl    %cl,%edi
  80259d:	89 c1                	mov    %eax,%ecx
  80259f:	89 3c 24             	mov    %edi,(%esp)
  8025a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025a6:	d3 ee                	shr    %cl,%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	d3 e2                	shl    %cl,%edx
  8025ac:	89 c1                	mov    %eax,%ecx
  8025ae:	d3 ef                	shr    %cl,%edi
  8025b0:	09 d7                	or     %edx,%edi
  8025b2:	89 f2                	mov    %esi,%edx
  8025b4:	89 f8                	mov    %edi,%eax
  8025b6:	f7 74 24 08          	divl   0x8(%esp)
  8025ba:	89 d6                	mov    %edx,%esi
  8025bc:	89 c7                	mov    %eax,%edi
  8025be:	f7 24 24             	mull   (%esp)
  8025c1:	39 d6                	cmp    %edx,%esi
  8025c3:	89 14 24             	mov    %edx,(%esp)
  8025c6:	72 30                	jb     8025f8 <__udivdi3+0x118>
  8025c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025cc:	89 e9                	mov    %ebp,%ecx
  8025ce:	d3 e2                	shl    %cl,%edx
  8025d0:	39 c2                	cmp    %eax,%edx
  8025d2:	73 05                	jae    8025d9 <__udivdi3+0xf9>
  8025d4:	3b 34 24             	cmp    (%esp),%esi
  8025d7:	74 1f                	je     8025f8 <__udivdi3+0x118>
  8025d9:	89 f8                	mov    %edi,%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	e9 7a ff ff ff       	jmp    80255c <__udivdi3+0x7c>
  8025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025e8:	31 d2                	xor    %edx,%edx
  8025ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ef:	e9 68 ff ff ff       	jmp    80255c <__udivdi3+0x7c>
  8025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	83 c4 0c             	add    $0xc,%esp
  802600:	5e                   	pop    %esi
  802601:	5f                   	pop    %edi
  802602:	5d                   	pop    %ebp
  802603:	c3                   	ret    
  802604:	66 90                	xchg   %ax,%ax
  802606:	66 90                	xchg   %ax,%ax
  802608:	66 90                	xchg   %ax,%ax
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__umoddi3>:
  802610:	55                   	push   %ebp
  802611:	57                   	push   %edi
  802612:	56                   	push   %esi
  802613:	83 ec 14             	sub    $0x14,%esp
  802616:	8b 44 24 28          	mov    0x28(%esp),%eax
  80261a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80261e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802622:	89 c7                	mov    %eax,%edi
  802624:	89 44 24 04          	mov    %eax,0x4(%esp)
  802628:	8b 44 24 30          	mov    0x30(%esp),%eax
  80262c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802630:	89 34 24             	mov    %esi,(%esp)
  802633:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802637:	85 c0                	test   %eax,%eax
  802639:	89 c2                	mov    %eax,%edx
  80263b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80263f:	75 17                	jne    802658 <__umoddi3+0x48>
  802641:	39 fe                	cmp    %edi,%esi
  802643:	76 4b                	jbe    802690 <__umoddi3+0x80>
  802645:	89 c8                	mov    %ecx,%eax
  802647:	89 fa                	mov    %edi,%edx
  802649:	f7 f6                	div    %esi
  80264b:	89 d0                	mov    %edx,%eax
  80264d:	31 d2                	xor    %edx,%edx
  80264f:	83 c4 14             	add    $0x14,%esp
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
  802656:	66 90                	xchg   %ax,%ax
  802658:	39 f8                	cmp    %edi,%eax
  80265a:	77 54                	ja     8026b0 <__umoddi3+0xa0>
  80265c:	0f bd e8             	bsr    %eax,%ebp
  80265f:	83 f5 1f             	xor    $0x1f,%ebp
  802662:	75 5c                	jne    8026c0 <__umoddi3+0xb0>
  802664:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802668:	39 3c 24             	cmp    %edi,(%esp)
  80266b:	0f 87 e7 00 00 00    	ja     802758 <__umoddi3+0x148>
  802671:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802675:	29 f1                	sub    %esi,%ecx
  802677:	19 c7                	sbb    %eax,%edi
  802679:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80267d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802681:	8b 44 24 08          	mov    0x8(%esp),%eax
  802685:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802689:	83 c4 14             	add    $0x14,%esp
  80268c:	5e                   	pop    %esi
  80268d:	5f                   	pop    %edi
  80268e:	5d                   	pop    %ebp
  80268f:	c3                   	ret    
  802690:	85 f6                	test   %esi,%esi
  802692:	89 f5                	mov    %esi,%ebp
  802694:	75 0b                	jne    8026a1 <__umoddi3+0x91>
  802696:	b8 01 00 00 00       	mov    $0x1,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	f7 f6                	div    %esi
  80269f:	89 c5                	mov    %eax,%ebp
  8026a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026a5:	31 d2                	xor    %edx,%edx
  8026a7:	f7 f5                	div    %ebp
  8026a9:	89 c8                	mov    %ecx,%eax
  8026ab:	f7 f5                	div    %ebp
  8026ad:	eb 9c                	jmp    80264b <__umoddi3+0x3b>
  8026af:	90                   	nop
  8026b0:	89 c8                	mov    %ecx,%eax
  8026b2:	89 fa                	mov    %edi,%edx
  8026b4:	83 c4 14             	add    $0x14,%esp
  8026b7:	5e                   	pop    %esi
  8026b8:	5f                   	pop    %edi
  8026b9:	5d                   	pop    %ebp
  8026ba:	c3                   	ret    
  8026bb:	90                   	nop
  8026bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c0:	8b 04 24             	mov    (%esp),%eax
  8026c3:	be 20 00 00 00       	mov    $0x20,%esi
  8026c8:	89 e9                	mov    %ebp,%ecx
  8026ca:	29 ee                	sub    %ebp,%esi
  8026cc:	d3 e2                	shl    %cl,%edx
  8026ce:	89 f1                	mov    %esi,%ecx
  8026d0:	d3 e8                	shr    %cl,%eax
  8026d2:	89 e9                	mov    %ebp,%ecx
  8026d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d8:	8b 04 24             	mov    (%esp),%eax
  8026db:	09 54 24 04          	or     %edx,0x4(%esp)
  8026df:	89 fa                	mov    %edi,%edx
  8026e1:	d3 e0                	shl    %cl,%eax
  8026e3:	89 f1                	mov    %esi,%ecx
  8026e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026e9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026ed:	d3 ea                	shr    %cl,%edx
  8026ef:	89 e9                	mov    %ebp,%ecx
  8026f1:	d3 e7                	shl    %cl,%edi
  8026f3:	89 f1                	mov    %esi,%ecx
  8026f5:	d3 e8                	shr    %cl,%eax
  8026f7:	89 e9                	mov    %ebp,%ecx
  8026f9:	09 f8                	or     %edi,%eax
  8026fb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026ff:	f7 74 24 04          	divl   0x4(%esp)
  802703:	d3 e7                	shl    %cl,%edi
  802705:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802709:	89 d7                	mov    %edx,%edi
  80270b:	f7 64 24 08          	mull   0x8(%esp)
  80270f:	39 d7                	cmp    %edx,%edi
  802711:	89 c1                	mov    %eax,%ecx
  802713:	89 14 24             	mov    %edx,(%esp)
  802716:	72 2c                	jb     802744 <__umoddi3+0x134>
  802718:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80271c:	72 22                	jb     802740 <__umoddi3+0x130>
  80271e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802722:	29 c8                	sub    %ecx,%eax
  802724:	19 d7                	sbb    %edx,%edi
  802726:	89 e9                	mov    %ebp,%ecx
  802728:	89 fa                	mov    %edi,%edx
  80272a:	d3 e8                	shr    %cl,%eax
  80272c:	89 f1                	mov    %esi,%ecx
  80272e:	d3 e2                	shl    %cl,%edx
  802730:	89 e9                	mov    %ebp,%ecx
  802732:	d3 ef                	shr    %cl,%edi
  802734:	09 d0                	or     %edx,%eax
  802736:	89 fa                	mov    %edi,%edx
  802738:	83 c4 14             	add    $0x14,%esp
  80273b:	5e                   	pop    %esi
  80273c:	5f                   	pop    %edi
  80273d:	5d                   	pop    %ebp
  80273e:	c3                   	ret    
  80273f:	90                   	nop
  802740:	39 d7                	cmp    %edx,%edi
  802742:	75 da                	jne    80271e <__umoddi3+0x10e>
  802744:	8b 14 24             	mov    (%esp),%edx
  802747:	89 c1                	mov    %eax,%ecx
  802749:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80274d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802751:	eb cb                	jmp    80271e <__umoddi3+0x10e>
  802753:	90                   	nop
  802754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802758:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80275c:	0f 82 0f ff ff ff    	jb     802671 <__umoddi3+0x61>
  802762:	e9 1a ff ff ff       	jmp    802681 <__umoddi3+0x71>
