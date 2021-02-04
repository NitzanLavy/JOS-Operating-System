
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 e2 00 00 00       	call   800113 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800048:	e8 28 0c 00 00       	call   800c75 <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80004f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800054:	e8 b1 11 00 00       	call   80120a <fork>
  800059:	85 c0                	test   %eax,%eax
  80005b:	74 0a                	je     800067 <umain+0x27>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80005d:	83 c3 01             	add    $0x1,%ebx
  800060:	83 fb 14             	cmp    $0x14,%ebx
  800063:	75 ef                	jne    800054 <umain+0x14>
  800065:	eb 1a                	jmp    800081 <umain+0x41>
		if (fork() == 0)
			break;
	
	if (i == 20) {
  800067:	83 fb 14             	cmp    $0x14,%ebx
  80006a:	74 15                	je     800081 <umain+0x41>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006c:	89 f0                	mov    %esi,%eax
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	89 c2                	mov    %eax,%edx
  800075:	c1 e2 07             	shl    $0x7,%edx
  800078:	8d 94 82 04 00 c0 ee 	lea    -0x113ffffc(%edx,%eax,4),%edx
  80007f:	eb 0c                	jmp    80008d <umain+0x4d>
	for (i = 0; i < 20; i++)
		if (fork() == 0)
			break;
	
	if (i == 20) {
		sys_yield();
  800081:	e8 0e 0c 00 00       	call   800c94 <sys_yield>
		return;
  800086:	e9 81 00 00 00       	jmp    80010c <umain+0xcc>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");
  80008b:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80008d:	8b 42 50             	mov    0x50(%edx),%eax
  800090:	85 c0                	test   %eax,%eax
  800092:	75 f7                	jne    80008b <umain+0x4b>
  800094:	bb 0a 00 00 00       	mov    $0xa,%ebx
		asm volatile("pause");


	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800099:	e8 f6 0b 00 00       	call   800c94 <sys_yield>
  80009e:	b8 10 27 00 00       	mov    $0x2710,%eax
		for (j = 0; j < 10000; j++)
			counter++;
  8000a3:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8000a9:	83 c2 01             	add    $0x1,%edx
  8000ac:	89 15 08 50 80 00    	mov    %edx,0x805008


	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  8000b2:	83 e8 01             	sub    $0x1,%eax
  8000b5:	75 ec                	jne    8000a3 <umain+0x63>
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");


	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000b7:	83 eb 01             	sub    $0x1,%ebx
  8000ba:	75 dd                	jne    800099 <umain+0x59>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  8000bc:	a1 08 50 80 00       	mov    0x805008,%eax
  8000c1:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000c6:	74 25                	je     8000ed <umain+0xad>
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000c8:	a1 08 50 80 00       	mov    0x805008,%eax
  8000cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d1:	c7 44 24 08 20 2c 80 	movl   $0x802c20,0x8(%esp)
  8000d8:	00 
  8000d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8000e0:	00 
  8000e1:	c7 04 24 48 2c 80 00 	movl   $0x802c48,(%esp)
  8000e8:	e8 8b 00 00 00       	call   800178 <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ed:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8000f2:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000f5:	8b 40 48             	mov    0x48(%eax),%eax
  8000f8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800100:	c7 04 24 5b 2c 80 00 	movl   $0x802c5b,(%esp)
  800107:	e8 65 01 00 00       	call   800271 <cprintf>

}
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
  800118:	83 ec 10             	sub    $0x10,%esp
  80011b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80011e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800121:	e8 4f 0b 00 00       	call   800c75 <sys_getenvid>
  800126:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012b:	89 c2                	mov    %eax,%edx
  80012d:	c1 e2 07             	shl    $0x7,%edx
  800130:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800137:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013c:	85 db                	test   %ebx,%ebx
  80013e:	7e 07                	jle    800147 <libmain+0x34>
		binaryname = argv[0];
  800140:	8b 06                	mov    (%esi),%eax
  800142:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800147:	89 74 24 04          	mov    %esi,0x4(%esp)
  80014b:	89 1c 24             	mov    %ebx,(%esp)
  80014e:	e8 ed fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800153:	e8 07 00 00 00       	call   80015f <exit>
}
  800158:	83 c4 10             	add    $0x10,%esp
  80015b:	5b                   	pop    %ebx
  80015c:	5e                   	pop    %esi
  80015d:	5d                   	pop    %ebp
  80015e:	c3                   	ret    

0080015f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800165:	e8 50 15 00 00       	call   8016ba <close_all>
	sys_env_destroy(0);
  80016a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800171:	e8 ad 0a 00 00       	call   800c23 <sys_env_destroy>
}
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	56                   	push   %esi
  80017c:	53                   	push   %ebx
  80017d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800180:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800183:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800189:	e8 e7 0a 00 00       	call   800c75 <sys_getenvid>
  80018e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800191:	89 54 24 10          	mov    %edx,0x10(%esp)
  800195:	8b 55 08             	mov    0x8(%ebp),%edx
  800198:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80019c:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a4:	c7 04 24 84 2c 80 00 	movl   $0x802c84,(%esp)
  8001ab:	e8 c1 00 00 00       	call   800271 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b7:	89 04 24             	mov    %eax,(%esp)
  8001ba:	e8 51 00 00 00       	call   800210 <vcprintf>
	cprintf("\n");
  8001bf:	c7 04 24 77 2c 80 00 	movl   $0x802c77,(%esp)
  8001c6:	e8 a6 00 00 00       	call   800271 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001cb:	cc                   	int3   
  8001cc:	eb fd                	jmp    8001cb <_panic+0x53>

008001ce <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	53                   	push   %ebx
  8001d2:	83 ec 14             	sub    $0x14,%esp
  8001d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d8:	8b 13                	mov    (%ebx),%edx
  8001da:	8d 42 01             	lea    0x1(%edx),%eax
  8001dd:	89 03                	mov    %eax,(%ebx)
  8001df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001eb:	75 19                	jne    800206 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ed:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001f4:	00 
  8001f5:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f8:	89 04 24             	mov    %eax,(%esp)
  8001fb:	e8 e6 09 00 00       	call   800be6 <sys_cputs>
		b->idx = 0;
  800200:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800206:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020a:	83 c4 14             	add    $0x14,%esp
  80020d:	5b                   	pop    %ebx
  80020e:	5d                   	pop    %ebp
  80020f:	c3                   	ret    

00800210 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800219:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800220:	00 00 00 
	b.cnt = 0;
  800223:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800230:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800234:	8b 45 08             	mov    0x8(%ebp),%eax
  800237:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800241:	89 44 24 04          	mov    %eax,0x4(%esp)
  800245:	c7 04 24 ce 01 80 00 	movl   $0x8001ce,(%esp)
  80024c:	e8 ad 01 00 00       	call   8003fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800251:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800261:	89 04 24             	mov    %eax,(%esp)
  800264:	e8 7d 09 00 00       	call   800be6 <sys_cputs>

	return b.cnt;
}
  800269:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800277:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80027a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 04 24             	mov    %eax,(%esp)
  800284:	e8 87 ff ff ff       	call   800210 <vcprintf>
	va_end(ap);

	return cnt;
}
  800289:	c9                   	leave  
  80028a:	c3                   	ret    
  80028b:	66 90                	xchg   %ax,%ax
  80028d:	66 90                	xchg   %ax,%ax
  80028f:	90                   	nop

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
  8002ff:	e8 8c 26 00 00       	call   802990 <__udivdi3>
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
  80035f:	e8 5c 27 00 00       	call   802ac0 <__umoddi3>
  800364:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800368:	0f be 80 a7 2c 80 00 	movsbl 0x802ca7(%eax),%eax
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
  800483:	ff 24 8d 20 2e 80 00 	jmp    *0x802e20(,%ecx,4)
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
  800520:	8b 14 85 80 2f 80 00 	mov    0x802f80(,%eax,4),%edx
  800527:	85 d2                	test   %edx,%edx
  800529:	75 20                	jne    80054b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80052b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80052f:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  800536:	00 
  800537:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	e8 90 fe ff ff       	call   8003d6 <printfmt>
  800546:	e9 d8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80054b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80054f:	c7 44 24 08 b5 31 80 	movl   $0x8031b5,0x8(%esp)
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
  800581:	b8 b8 2c 80 00       	mov    $0x802cb8,%eax
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
  800c51:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800c58:	00 
  800c59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c60:	00 
  800c61:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800c68:	e8 0b f5 ff ff       	call   800178 <_panic>

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
  800ce3:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800cea:	00 
  800ceb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf2:	00 
  800cf3:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800cfa:	e8 79 f4 ff ff       	call   800178 <_panic>

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
  800d36:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800d3d:	00 
  800d3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d45:	00 
  800d46:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800d4d:	e8 26 f4 ff ff       	call   800178 <_panic>

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
  800d89:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800d90:	00 
  800d91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d98:	00 
  800d99:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800da0:	e8 d3 f3 ff ff       	call   800178 <_panic>

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
  800ddc:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800de3:	00 
  800de4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800deb:	00 
  800dec:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800df3:	e8 80 f3 ff ff       	call   800178 <_panic>

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
  800e2f:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800e36:	00 
  800e37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3e:	00 
  800e3f:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800e46:	e8 2d f3 ff ff       	call   800178 <_panic>

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
  800e82:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800e89:	00 
  800e8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e91:	00 
  800e92:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800e99:	e8 da f2 ff ff       	call   800178 <_panic>

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
  800ef7:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800efe:	00 
  800eff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f06:	00 
  800f07:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800f0e:	e8 65 f2 ff ff       	call   800178 <_panic>

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
  800f69:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800f70:	00 
  800f71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f78:	00 
  800f79:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800f80:	e8 f3 f1 ff ff       	call   800178 <_panic>

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
  800fbc:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  800fc3:	00 
  800fc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fcb:	00 
  800fcc:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800fd3:	e8 a0 f1 ff ff       	call   800178 <_panic>

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
  80100f:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  801016:	00 
  801017:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101e:	00 
  80101f:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801026:	e8 4d f1 ff ff       	call   800178 <_panic>

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
  801061:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  801068:	00 
  801069:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801070:	00 
  801071:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801078:	e8 fb f0 ff ff       	call   800178 <_panic>

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
  8010b4:	c7 44 24 08 eb 2f 80 	movl   $0x802feb,0x8(%esp)
  8010bb:	00 
  8010bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c3:	00 
  8010c4:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8010cb:	e8 a8 f0 ff ff       	call   800178 <_panic>

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

008010d8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	53                   	push   %ebx
  8010dc:	83 ec 24             	sub    $0x24,%esp
  8010df:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8010e2:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  8010e4:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8010e8:	74 27                	je     801111 <pgfault+0x39>
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	c1 ea 16             	shr    $0x16,%edx
  8010ef:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010f6:	f6 c2 01             	test   $0x1,%dl
  8010f9:	74 16                	je     801111 <pgfault+0x39>
  8010fb:	89 c2                	mov    %eax,%edx
  8010fd:	c1 ea 0c             	shr    $0xc,%edx
  801100:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801107:	f7 d2                	not    %edx
  801109:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80110f:	74 1c                	je     80112d <pgfault+0x55>
		panic("pgfault");
  801111:	c7 44 24 08 16 30 80 	movl   $0x803016,0x8(%esp)
  801118:	00 
  801119:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801120:	00 
  801121:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  801128:	e8 4b f0 ff ff       	call   800178 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80112d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801132:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801134:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80113b:	00 
  80113c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801143:	00 
  801144:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80114b:	e8 63 fb ff ff       	call   800cb3 <sys_page_alloc>
  801150:	85 c0                	test   %eax,%eax
  801152:	79 1c                	jns    801170 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801154:	c7 44 24 08 29 30 80 	movl   $0x803029,0x8(%esp)
  80115b:	00 
  80115c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801163:	00 
  801164:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  80116b:	e8 08 f0 ff ff       	call   800178 <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801170:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801177:	00 
  801178:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80117c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801183:	e8 14 f9 ff ff       	call   800a9c <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801188:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80118f:	00 
  801190:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801194:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80119b:	00 
  80119c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011a3:	00 
  8011a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011ab:	e8 57 fb ff ff       	call   800d07 <sys_page_map>
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	79 1c                	jns    8011d0 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  8011b4:	c7 44 24 08 43 30 80 	movl   $0x803043,0x8(%esp)
  8011bb:	00 
  8011bc:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8011c3:	00 
  8011c4:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  8011cb:	e8 a8 ef ff ff       	call   800178 <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  8011d0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011d7:	00 
  8011d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011df:	e8 76 fb ff ff       	call   800d5a <sys_page_unmap>
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	79 1c                	jns    801204 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  8011e8:	c7 44 24 08 5b 30 80 	movl   $0x80305b,0x8(%esp)
  8011ef:	00 
  8011f0:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8011f7:	00 
  8011f8:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  8011ff:	e8 74 ef ff ff       	call   800178 <_panic>
	}
}
  801204:	83 c4 24             	add    $0x24,%esp
  801207:	5b                   	pop    %ebx
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    

0080120a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	57                   	push   %edi
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
  801210:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801213:	c7 04 24 d8 10 80 00 	movl   $0x8010d8,(%esp)
  80121a:	e8 77 15 00 00       	call   802796 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80121f:	b8 07 00 00 00       	mov    $0x7,%eax
  801224:	cd 30                	int    $0x30
  801226:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801229:	85 c0                	test   %eax,%eax
  80122b:	79 1c                	jns    801249 <fork+0x3f>
		panic("fork(): sys_exofork");
  80122d:	c7 44 24 08 75 30 80 	movl   $0x803075,0x8(%esp)
  801234:	00 
  801235:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80123c:	00 
  80123d:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  801244:	e8 2f ef ff ff       	call   800178 <_panic>
  801249:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  80124b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80124f:	74 0a                	je     80125b <fork+0x51>
  801251:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801256:	e9 9d 01 00 00       	jmp    8013f8 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80125b:	e8 15 fa ff ff       	call   800c75 <sys_getenvid>
  801260:	25 ff 03 00 00       	and    $0x3ff,%eax
  801265:	89 c2                	mov    %eax,%edx
  801267:	c1 e2 07             	shl    $0x7,%edx
  80126a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801271:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return env_id;
  801276:	e9 2a 02 00 00       	jmp    8014a5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80127b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801281:	0f 84 6b 01 00 00    	je     8013f2 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801287:	89 d8                	mov    %ebx,%eax
  801289:	c1 e8 16             	shr    $0x16,%eax
  80128c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801293:	a8 01                	test   $0x1,%al
  801295:	0f 84 57 01 00 00    	je     8013f2 <fork+0x1e8>
  80129b:	89 d8                	mov    %ebx,%eax
  80129d:	c1 e8 0c             	shr    $0xc,%eax
  8012a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a7:	f7 d0                	not    %eax
  8012a9:	a8 05                	test   $0x5,%al
  8012ab:	0f 85 41 01 00 00    	jne    8013f2 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  8012b6:	89 c6                	mov    %eax,%esi
  8012b8:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  8012bb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012c2:	f6 c6 04             	test   $0x4,%dh
  8012c5:	74 4c                	je     801313 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  8012c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012db:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ea:	e8 18 fa ff ff       	call   800d07 <sys_page_map>
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	0f 89 fb 00 00 00    	jns    8013f2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8012f7:	c7 44 24 08 89 30 80 	movl   $0x803089,0x8(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801306:	00 
  801307:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  80130e:	e8 65 ee ff ff       	call   800178 <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801313:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80131a:	f6 c6 08             	test   $0x8,%dh
  80131d:	75 0f                	jne    80132e <fork+0x124>
  80131f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801326:	a8 02                	test   $0x2,%al
  801328:	0f 84 84 00 00 00    	je     8013b2 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80132e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801335:	00 
  801336:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80133a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80133e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801342:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801349:	e8 b9 f9 ff ff       	call   800d07 <sys_page_map>
  80134e:	85 c0                	test   %eax,%eax
  801350:	79 1c                	jns    80136e <fork+0x164>
			panic("duppage: sys_page_map");
  801352:	c7 44 24 08 89 30 80 	movl   $0x803089,0x8(%esp)
  801359:	00 
  80135a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801361:	00 
  801362:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  801369:	e8 0a ee ff ff       	call   800178 <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80136e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801375:	00 
  801376:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80137a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801381:	00 
  801382:	89 74 24 04          	mov    %esi,0x4(%esp)
  801386:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80138d:	e8 75 f9 ff ff       	call   800d07 <sys_page_map>
  801392:	85 c0                	test   %eax,%eax
  801394:	79 5c                	jns    8013f2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801396:	c7 44 24 08 89 30 80 	movl   $0x803089,0x8(%esp)
  80139d:	00 
  80139e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8013a5:	00 
  8013a6:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  8013ad:	e8 c6 ed ff ff       	call   800178 <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  8013b2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8013b9:	00 
  8013ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013cd:	e8 35 f9 ff ff       	call   800d07 <sys_page_map>
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	79 1c                	jns    8013f2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8013d6:	c7 44 24 08 89 30 80 	movl   $0x803089,0x8(%esp)
  8013dd:	00 
  8013de:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8013e5:	00 
  8013e6:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  8013ed:	e8 86 ed ff ff       	call   800178 <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  8013f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013f8:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8013fe:	0f 85 77 fe ff ff    	jne    80127b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801404:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80140b:	00 
  80140c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801413:	ee 
  801414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801417:	89 04 24             	mov    %eax,(%esp)
  80141a:	e8 94 f8 ff ff       	call   800cb3 <sys_page_alloc>
  80141f:	85 c0                	test   %eax,%eax
  801421:	79 1c                	jns    80143f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801423:	c7 44 24 08 9f 30 80 	movl   $0x80309f,0x8(%esp)
  80142a:	00 
  80142b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801432:	00 
  801433:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  80143a:	e8 39 ed ff ff       	call   800178 <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80143f:	c7 44 24 04 1f 28 80 	movl   $0x80281f,0x4(%esp)
  801446:	00 
  801447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144a:	89 04 24             	mov    %eax,(%esp)
  80144d:	e8 01 fa ff ff       	call   800e53 <sys_env_set_pgfault_upcall>
  801452:	85 c0                	test   %eax,%eax
  801454:	79 1c                	jns    801472 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801456:	c7 44 24 08 e8 30 80 	movl   $0x8030e8,0x8(%esp)
  80145d:	00 
  80145e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801465:	00 
  801466:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  80146d:	e8 06 ed ff ff       	call   800178 <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801472:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801479:	00 
  80147a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147d:	89 04 24             	mov    %eax,(%esp)
  801480:	e8 28 f9 ff ff       	call   800dad <sys_env_set_status>
  801485:	85 c0                	test   %eax,%eax
  801487:	79 1c                	jns    8014a5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801489:	c7 44 24 08 b6 30 80 	movl   $0x8030b6,0x8(%esp)
  801490:	00 
  801491:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801498:	00 
  801499:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  8014a0:	e8 d3 ec ff ff       	call   800178 <_panic>
	}

	return env_id;
}
  8014a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a8:	83 c4 2c             	add    $0x2c,%esp
  8014ab:	5b                   	pop    %ebx
  8014ac:	5e                   	pop    %esi
  8014ad:	5f                   	pop    %edi
  8014ae:	5d                   	pop    %ebp
  8014af:	c3                   	ret    

008014b0 <sfork>:

// Challenge!
int
sfork(void)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8014b6:	c7 44 24 08 d1 30 80 	movl   $0x8030d1,0x8(%esp)
  8014bd:	00 
  8014be:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8014c5:	00 
  8014c6:	c7 04 24 1e 30 80 00 	movl   $0x80301e,(%esp)
  8014cd:	e8 a6 ec ff ff       	call   800178 <_panic>
  8014d2:	66 90                	xchg   %ax,%ax
  8014d4:	66 90                	xchg   %ax,%ax
  8014d6:	66 90                	xchg   %ax,%ax
  8014d8:	66 90                	xchg   %ax,%ax
  8014da:	66 90                	xchg   %ax,%ax
  8014dc:	66 90                	xchg   %ax,%ax
  8014de:	66 90                	xchg   %ax,%ax

008014e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    

008014f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8014fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801500:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801512:	89 c2                	mov    %eax,%edx
  801514:	c1 ea 16             	shr    $0x16,%edx
  801517:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80151e:	f6 c2 01             	test   $0x1,%dl
  801521:	74 11                	je     801534 <fd_alloc+0x2d>
  801523:	89 c2                	mov    %eax,%edx
  801525:	c1 ea 0c             	shr    $0xc,%edx
  801528:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80152f:	f6 c2 01             	test   $0x1,%dl
  801532:	75 09                	jne    80153d <fd_alloc+0x36>
			*fd_store = fd;
  801534:	89 01                	mov    %eax,(%ecx)
			return 0;
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
  80153b:	eb 17                	jmp    801554 <fd_alloc+0x4d>
  80153d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801542:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801547:	75 c9                	jne    801512 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801549:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80154f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    

00801556 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80155c:	83 f8 1f             	cmp    $0x1f,%eax
  80155f:	77 36                	ja     801597 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801561:	c1 e0 0c             	shl    $0xc,%eax
  801564:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801569:	89 c2                	mov    %eax,%edx
  80156b:	c1 ea 16             	shr    $0x16,%edx
  80156e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801575:	f6 c2 01             	test   $0x1,%dl
  801578:	74 24                	je     80159e <fd_lookup+0x48>
  80157a:	89 c2                	mov    %eax,%edx
  80157c:	c1 ea 0c             	shr    $0xc,%edx
  80157f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801586:	f6 c2 01             	test   $0x1,%dl
  801589:	74 1a                	je     8015a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80158b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158e:	89 02                	mov    %eax,(%edx)
	return 0;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
  801595:	eb 13                	jmp    8015aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801597:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159c:	eb 0c                	jmp    8015aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80159e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a3:	eb 05                	jmp    8015aa <fd_lookup+0x54>
  8015a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8015aa:	5d                   	pop    %ebp
  8015ab:	c3                   	ret    

008015ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 18             	sub    $0x18,%esp
  8015b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ba:	eb 13                	jmp    8015cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8015bc:	39 08                	cmp    %ecx,(%eax)
  8015be:	75 0c                	jne    8015cc <dev_lookup+0x20>
			*dev = devtab[i];
  8015c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ca:	eb 38                	jmp    801604 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015cc:	83 c2 01             	add    $0x1,%edx
  8015cf:	8b 04 95 88 31 80 00 	mov    0x803188(,%edx,4),%eax
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	75 e2                	jne    8015bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015da:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8015df:	8b 40 48             	mov    0x48(%eax),%eax
  8015e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ea:	c7 04 24 0c 31 80 00 	movl   $0x80310c,(%esp)
  8015f1:	e8 7b ec ff ff       	call   800271 <cprintf>
	*dev = 0;
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	56                   	push   %esi
  80160a:	53                   	push   %ebx
  80160b:	83 ec 20             	sub    $0x20,%esp
  80160e:	8b 75 08             	mov    0x8(%ebp),%esi
  801611:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801614:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801617:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80161b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801621:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	e8 2a ff ff ff       	call   801556 <fd_lookup>
  80162c:	85 c0                	test   %eax,%eax
  80162e:	78 05                	js     801635 <fd_close+0x2f>
	    || fd != fd2)
  801630:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801633:	74 0c                	je     801641 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801635:	84 db                	test   %bl,%bl
  801637:	ba 00 00 00 00       	mov    $0x0,%edx
  80163c:	0f 44 c2             	cmove  %edx,%eax
  80163f:	eb 3f                	jmp    801680 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801641:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801644:	89 44 24 04          	mov    %eax,0x4(%esp)
  801648:	8b 06                	mov    (%esi),%eax
  80164a:	89 04 24             	mov    %eax,(%esp)
  80164d:	e8 5a ff ff ff       	call   8015ac <dev_lookup>
  801652:	89 c3                	mov    %eax,%ebx
  801654:	85 c0                	test   %eax,%eax
  801656:	78 16                	js     80166e <fd_close+0x68>
		if (dev->dev_close)
  801658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80165e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801663:	85 c0                	test   %eax,%eax
  801665:	74 07                	je     80166e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801667:	89 34 24             	mov    %esi,(%esp)
  80166a:	ff d0                	call   *%eax
  80166c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80166e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801672:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801679:	e8 dc f6 ff ff       	call   800d5a <sys_page_unmap>
	return r;
  80167e:	89 d8                	mov    %ebx,%eax
}
  801680:	83 c4 20             	add    $0x20,%esp
  801683:	5b                   	pop    %ebx
  801684:	5e                   	pop    %esi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801690:	89 44 24 04          	mov    %eax,0x4(%esp)
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	89 04 24             	mov    %eax,(%esp)
  80169a:	e8 b7 fe ff ff       	call   801556 <fd_lookup>
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	85 d2                	test   %edx,%edx
  8016a3:	78 13                	js     8016b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8016a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016ac:	00 
  8016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b0:	89 04 24             	mov    %eax,(%esp)
  8016b3:	e8 4e ff ff ff       	call   801606 <fd_close>
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <close_all>:

void
close_all(void)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	53                   	push   %ebx
  8016be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016c6:	89 1c 24             	mov    %ebx,(%esp)
  8016c9:	e8 b9 ff ff ff       	call   801687 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016ce:	83 c3 01             	add    $0x1,%ebx
  8016d1:	83 fb 20             	cmp    $0x20,%ebx
  8016d4:	75 f0                	jne    8016c6 <close_all+0xc>
		close(i);
}
  8016d6:	83 c4 14             	add    $0x14,%esp
  8016d9:	5b                   	pop    %ebx
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	57                   	push   %edi
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	89 04 24             	mov    %eax,(%esp)
  8016f2:	e8 5f fe ff ff       	call   801556 <fd_lookup>
  8016f7:	89 c2                	mov    %eax,%edx
  8016f9:	85 d2                	test   %edx,%edx
  8016fb:	0f 88 e1 00 00 00    	js     8017e2 <dup+0x106>
		return r;
	close(newfdnum);
  801701:	8b 45 0c             	mov    0xc(%ebp),%eax
  801704:	89 04 24             	mov    %eax,(%esp)
  801707:	e8 7b ff ff ff       	call   801687 <close>

	newfd = INDEX2FD(newfdnum);
  80170c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80170f:	c1 e3 0c             	shl    $0xc,%ebx
  801712:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80171b:	89 04 24             	mov    %eax,(%esp)
  80171e:	e8 cd fd ff ff       	call   8014f0 <fd2data>
  801723:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801725:	89 1c 24             	mov    %ebx,(%esp)
  801728:	e8 c3 fd ff ff       	call   8014f0 <fd2data>
  80172d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80172f:	89 f0                	mov    %esi,%eax
  801731:	c1 e8 16             	shr    $0x16,%eax
  801734:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80173b:	a8 01                	test   $0x1,%al
  80173d:	74 43                	je     801782 <dup+0xa6>
  80173f:	89 f0                	mov    %esi,%eax
  801741:	c1 e8 0c             	shr    $0xc,%eax
  801744:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80174b:	f6 c2 01             	test   $0x1,%dl
  80174e:	74 32                	je     801782 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801750:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801757:	25 07 0e 00 00       	and    $0xe07,%eax
  80175c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801760:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801764:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80176b:	00 
  80176c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801770:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801777:	e8 8b f5 ff ff       	call   800d07 <sys_page_map>
  80177c:	89 c6                	mov    %eax,%esi
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 3e                	js     8017c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801785:	89 c2                	mov    %eax,%edx
  801787:	c1 ea 0c             	shr    $0xc,%edx
  80178a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801791:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801797:	89 54 24 10          	mov    %edx,0x10(%esp)
  80179b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80179f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017a6:	00 
  8017a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017b2:	e8 50 f5 ff ff       	call   800d07 <sys_page_map>
  8017b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017bc:	85 f6                	test   %esi,%esi
  8017be:	79 22                	jns    8017e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017cb:	e8 8a f5 ff ff       	call   800d5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017db:	e8 7a f5 ff ff       	call   800d5a <sys_page_unmap>
	return r;
  8017e0:	89 f0                	mov    %esi,%eax
}
  8017e2:	83 c4 3c             	add    $0x3c,%esp
  8017e5:	5b                   	pop    %ebx
  8017e6:	5e                   	pop    %esi
  8017e7:	5f                   	pop    %edi
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    

008017ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 24             	sub    $0x24,%esp
  8017f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fb:	89 1c 24             	mov    %ebx,(%esp)
  8017fe:	e8 53 fd ff ff       	call   801556 <fd_lookup>
  801803:	89 c2                	mov    %eax,%edx
  801805:	85 d2                	test   %edx,%edx
  801807:	78 6d                	js     801876 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801809:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801813:	8b 00                	mov    (%eax),%eax
  801815:	89 04 24             	mov    %eax,(%esp)
  801818:	e8 8f fd ff ff       	call   8015ac <dev_lookup>
  80181d:	85 c0                	test   %eax,%eax
  80181f:	78 55                	js     801876 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	8b 50 08             	mov    0x8(%eax),%edx
  801827:	83 e2 03             	and    $0x3,%edx
  80182a:	83 fa 01             	cmp    $0x1,%edx
  80182d:	75 23                	jne    801852 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80182f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801834:	8b 40 48             	mov    0x48(%eax),%eax
  801837:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80183b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183f:	c7 04 24 4d 31 80 00 	movl   $0x80314d,(%esp)
  801846:	e8 26 ea ff ff       	call   800271 <cprintf>
		return -E_INVAL;
  80184b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801850:	eb 24                	jmp    801876 <read+0x8c>
	}
	if (!dev->dev_read)
  801852:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801855:	8b 52 08             	mov    0x8(%edx),%edx
  801858:	85 d2                	test   %edx,%edx
  80185a:	74 15                	je     801871 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80185c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801863:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801866:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80186a:	89 04 24             	mov    %eax,(%esp)
  80186d:	ff d2                	call   *%edx
  80186f:	eb 05                	jmp    801876 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801871:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801876:	83 c4 24             	add    $0x24,%esp
  801879:	5b                   	pop    %ebx
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    

0080187c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	57                   	push   %edi
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
  801882:	83 ec 1c             	sub    $0x1c,%esp
  801885:	8b 7d 08             	mov    0x8(%ebp),%edi
  801888:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80188b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801890:	eb 23                	jmp    8018b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801892:	89 f0                	mov    %esi,%eax
  801894:	29 d8                	sub    %ebx,%eax
  801896:	89 44 24 08          	mov    %eax,0x8(%esp)
  80189a:	89 d8                	mov    %ebx,%eax
  80189c:	03 45 0c             	add    0xc(%ebp),%eax
  80189f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a3:	89 3c 24             	mov    %edi,(%esp)
  8018a6:	e8 3f ff ff ff       	call   8017ea <read>
		if (m < 0)
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 10                	js     8018bf <readn+0x43>
			return m;
		if (m == 0)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	74 0a                	je     8018bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018b3:	01 c3                	add    %eax,%ebx
  8018b5:	39 f3                	cmp    %esi,%ebx
  8018b7:	72 d9                	jb     801892 <readn+0x16>
  8018b9:	89 d8                	mov    %ebx,%eax
  8018bb:	eb 02                	jmp    8018bf <readn+0x43>
  8018bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018bf:	83 c4 1c             	add    $0x1c,%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5e                   	pop    %esi
  8018c4:	5f                   	pop    %edi
  8018c5:	5d                   	pop    %ebp
  8018c6:	c3                   	ret    

008018c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	53                   	push   %ebx
  8018cb:	83 ec 24             	sub    $0x24,%esp
  8018ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d8:	89 1c 24             	mov    %ebx,(%esp)
  8018db:	e8 76 fc ff ff       	call   801556 <fd_lookup>
  8018e0:	89 c2                	mov    %eax,%edx
  8018e2:	85 d2                	test   %edx,%edx
  8018e4:	78 68                	js     80194e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f0:	8b 00                	mov    (%eax),%eax
  8018f2:	89 04 24             	mov    %eax,(%esp)
  8018f5:	e8 b2 fc ff ff       	call   8015ac <dev_lookup>
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 50                	js     80194e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801901:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801905:	75 23                	jne    80192a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801907:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80190c:	8b 40 48             	mov    0x48(%eax),%eax
  80190f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801913:	89 44 24 04          	mov    %eax,0x4(%esp)
  801917:	c7 04 24 69 31 80 00 	movl   $0x803169,(%esp)
  80191e:	e8 4e e9 ff ff       	call   800271 <cprintf>
		return -E_INVAL;
  801923:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801928:	eb 24                	jmp    80194e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80192a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192d:	8b 52 0c             	mov    0xc(%edx),%edx
  801930:	85 d2                	test   %edx,%edx
  801932:	74 15                	je     801949 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801934:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801937:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80193b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80193e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801942:	89 04 24             	mov    %eax,(%esp)
  801945:	ff d2                	call   *%edx
  801947:	eb 05                	jmp    80194e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801949:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80194e:	83 c4 24             	add    $0x24,%esp
  801951:	5b                   	pop    %ebx
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    

00801954 <seek>:

int
seek(int fdnum, off_t offset)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80195a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80195d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	89 04 24             	mov    %eax,(%esp)
  801967:	e8 ea fb ff ff       	call   801556 <fd_lookup>
  80196c:	85 c0                	test   %eax,%eax
  80196e:	78 0e                	js     80197e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801979:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
  801984:	83 ec 24             	sub    $0x24,%esp
  801987:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80198d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801991:	89 1c 24             	mov    %ebx,(%esp)
  801994:	e8 bd fb ff ff       	call   801556 <fd_lookup>
  801999:	89 c2                	mov    %eax,%edx
  80199b:	85 d2                	test   %edx,%edx
  80199d:	78 61                	js     801a00 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80199f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	89 04 24             	mov    %eax,(%esp)
  8019ae:	e8 f9 fb ff ff       	call   8015ac <dev_lookup>
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 49                	js     801a00 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019be:	75 23                	jne    8019e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019c0:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019c5:	8b 40 48             	mov    0x48(%eax),%eax
  8019c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d0:	c7 04 24 2c 31 80 00 	movl   $0x80312c,(%esp)
  8019d7:	e8 95 e8 ff ff       	call   800271 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8019dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e1:	eb 1d                	jmp    801a00 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8019e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e6:	8b 52 18             	mov    0x18(%edx),%edx
  8019e9:	85 d2                	test   %edx,%edx
  8019eb:	74 0e                	je     8019fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019f4:	89 04 24             	mov    %eax,(%esp)
  8019f7:	ff d2                	call   *%edx
  8019f9:	eb 05                	jmp    801a00 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8019fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a00:	83 c4 24             	add    $0x24,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5d                   	pop    %ebp
  801a05:	c3                   	ret    

00801a06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 24             	sub    $0x24,%esp
  801a0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	89 04 24             	mov    %eax,(%esp)
  801a1d:	e8 34 fb ff ff       	call   801556 <fd_lookup>
  801a22:	89 c2                	mov    %eax,%edx
  801a24:	85 d2                	test   %edx,%edx
  801a26:	78 52                	js     801a7a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a32:	8b 00                	mov    (%eax),%eax
  801a34:	89 04 24             	mov    %eax,(%esp)
  801a37:	e8 70 fb ff ff       	call   8015ac <dev_lookup>
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 3a                	js     801a7a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a43:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a47:	74 2c                	je     801a75 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a49:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a53:	00 00 00 
	stat->st_isdir = 0;
  801a56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a5d:	00 00 00 
	stat->st_dev = dev;
  801a60:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a6d:	89 14 24             	mov    %edx,(%esp)
  801a70:	ff 50 14             	call   *0x14(%eax)
  801a73:	eb 05                	jmp    801a7a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a7a:	83 c4 24             	add    $0x24,%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    

00801a80 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	56                   	push   %esi
  801a84:	53                   	push   %ebx
  801a85:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a8f:	00 
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	89 04 24             	mov    %eax,(%esp)
  801a96:	e8 1b 02 00 00       	call   801cb6 <open>
  801a9b:	89 c3                	mov    %eax,%ebx
  801a9d:	85 db                	test   %ebx,%ebx
  801a9f:	78 1b                	js     801abc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa8:	89 1c 24             	mov    %ebx,(%esp)
  801aab:	e8 56 ff ff ff       	call   801a06 <fstat>
  801ab0:	89 c6                	mov    %eax,%esi
	close(fd);
  801ab2:	89 1c 24             	mov    %ebx,(%esp)
  801ab5:	e8 cd fb ff ff       	call   801687 <close>
	return r;
  801aba:	89 f0                	mov    %esi,%eax
}
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5d                   	pop    %ebp
  801ac2:	c3                   	ret    

00801ac3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	56                   	push   %esi
  801ac7:	53                   	push   %ebx
  801ac8:	83 ec 10             	sub    $0x10,%esp
  801acb:	89 c6                	mov    %eax,%esi
  801acd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801acf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ad6:	75 11                	jne    801ae9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ad8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801adf:	e8 2b 0e 00 00       	call   80290f <ipc_find_env>
  801ae4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ae9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801af0:	00 
  801af1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801af8:	00 
  801af9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801afd:	a1 00 50 80 00       	mov    0x805000,%eax
  801b02:	89 04 24             	mov    %eax,(%esp)
  801b05:	e8 9a 0d 00 00       	call   8028a4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b11:	00 
  801b12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1d:	e8 2e 0d 00 00       	call   802850 <ipc_recv>
}
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	5b                   	pop    %ebx
  801b26:	5e                   	pop    %esi
  801b27:	5d                   	pop    %ebp
  801b28:	c3                   	ret    

00801b29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	8b 40 0c             	mov    0xc(%eax),%eax
  801b35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b42:	ba 00 00 00 00       	mov    $0x0,%edx
  801b47:	b8 02 00 00 00       	mov    $0x2,%eax
  801b4c:	e8 72 ff ff ff       	call   801ac3 <fsipc>
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b64:	ba 00 00 00 00       	mov    $0x0,%edx
  801b69:	b8 06 00 00 00       	mov    $0x6,%eax
  801b6e:	e8 50 ff ff ff       	call   801ac3 <fsipc>
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	53                   	push   %ebx
  801b79:	83 ec 14             	sub    $0x14,%esp
  801b7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8b 40 0c             	mov    0xc(%eax),%eax
  801b85:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b94:	e8 2a ff ff ff       	call   801ac3 <fsipc>
  801b99:	89 c2                	mov    %eax,%edx
  801b9b:	85 d2                	test   %edx,%edx
  801b9d:	78 2b                	js     801bca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b9f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ba6:	00 
  801ba7:	89 1c 24             	mov    %ebx,(%esp)
  801baa:	e8 e8 ec ff ff       	call   800897 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801baf:	a1 80 60 80 00       	mov    0x806080,%eax
  801bb4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bba:	a1 84 60 80 00       	mov    0x806084,%eax
  801bbf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bca:	83 c4 14             	add    $0x14,%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    

00801bd0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 18             	sub    $0x18,%esp
  801bd6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  801bdc:	8b 52 0c             	mov    0xc(%edx),%edx
  801bdf:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801be5:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801bea:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf5:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801bfc:	e8 9b ee ff ff       	call   800a9c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801c01:	ba 00 00 00 00       	mov    $0x0,%edx
  801c06:	b8 04 00 00 00       	mov    $0x4,%eax
  801c0b:	e8 b3 fe ff ff       	call   801ac3 <fsipc>
		return r;
	}

	return r;
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	56                   	push   %esi
  801c16:	53                   	push   %ebx
  801c17:	83 ec 10             	sub    $0x10,%esp
  801c1a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	8b 40 0c             	mov    0xc(%eax),%eax
  801c23:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c28:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c33:	b8 03 00 00 00       	mov    $0x3,%eax
  801c38:	e8 86 fe ff ff       	call   801ac3 <fsipc>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 6a                	js     801cad <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c43:	39 c6                	cmp    %eax,%esi
  801c45:	73 24                	jae    801c6b <devfile_read+0x59>
  801c47:	c7 44 24 0c 9c 31 80 	movl   $0x80319c,0xc(%esp)
  801c4e:	00 
  801c4f:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  801c56:	00 
  801c57:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c5e:	00 
  801c5f:	c7 04 24 b8 31 80 00 	movl   $0x8031b8,(%esp)
  801c66:	e8 0d e5 ff ff       	call   800178 <_panic>
	assert(r <= PGSIZE);
  801c6b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c70:	7e 24                	jle    801c96 <devfile_read+0x84>
  801c72:	c7 44 24 0c c3 31 80 	movl   $0x8031c3,0xc(%esp)
  801c79:	00 
  801c7a:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  801c81:	00 
  801c82:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c89:	00 
  801c8a:	c7 04 24 b8 31 80 00 	movl   $0x8031b8,(%esp)
  801c91:	e8 e2 e4 ff ff       	call   800178 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c9a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ca1:	00 
  801ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca5:	89 04 24             	mov    %eax,(%esp)
  801ca8:	e8 87 ed ff ff       	call   800a34 <memmove>
	return r;
}
  801cad:	89 d8                	mov    %ebx,%eax
  801caf:	83 c4 10             	add    $0x10,%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 24             	sub    $0x24,%esp
  801cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cc0:	89 1c 24             	mov    %ebx,(%esp)
  801cc3:	e8 98 eb ff ff       	call   800860 <strlen>
  801cc8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ccd:	7f 60                	jg     801d2f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ccf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd2:	89 04 24             	mov    %eax,(%esp)
  801cd5:	e8 2d f8 ff ff       	call   801507 <fd_alloc>
  801cda:	89 c2                	mov    %eax,%edx
  801cdc:	85 d2                	test   %edx,%edx
  801cde:	78 54                	js     801d34 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801ce0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce4:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801ceb:	e8 a7 eb ff ff       	call   800897 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf3:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cfb:	b8 01 00 00 00       	mov    $0x1,%eax
  801d00:	e8 be fd ff ff       	call   801ac3 <fsipc>
  801d05:	89 c3                	mov    %eax,%ebx
  801d07:	85 c0                	test   %eax,%eax
  801d09:	79 17                	jns    801d22 <open+0x6c>
		fd_close(fd, 0);
  801d0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d12:	00 
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	89 04 24             	mov    %eax,(%esp)
  801d19:	e8 e8 f8 ff ff       	call   801606 <fd_close>
		return r;
  801d1e:	89 d8                	mov    %ebx,%eax
  801d20:	eb 12                	jmp    801d34 <open+0x7e>
	}

	return fd2num(fd);
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	89 04 24             	mov    %eax,(%esp)
  801d28:	e8 b3 f7 ff ff       	call   8014e0 <fd2num>
  801d2d:	eb 05                	jmp    801d34 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d2f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801d34:	83 c4 24             	add    $0x24,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    

00801d3a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d40:	ba 00 00 00 00       	mov    $0x0,%edx
  801d45:	b8 08 00 00 00       	mov    $0x8,%eax
  801d4a:	e8 74 fd ff ff       	call   801ac3 <fsipc>
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    
  801d51:	66 90                	xchg   %ax,%ax
  801d53:	66 90                	xchg   %ax,%ax
  801d55:	66 90                	xchg   %ax,%ax
  801d57:	66 90                	xchg   %ax,%ax
  801d59:	66 90                	xchg   %ax,%ax
  801d5b:	66 90                	xchg   %ax,%ax
  801d5d:	66 90                	xchg   %ax,%ax
  801d5f:	90                   	nop

00801d60 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d66:	c7 44 24 04 cf 31 80 	movl   $0x8031cf,0x4(%esp)
  801d6d:	00 
  801d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d71:	89 04 24             	mov    %eax,(%esp)
  801d74:	e8 1e eb ff ff       	call   800897 <strcpy>
	return 0;
}
  801d79:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	53                   	push   %ebx
  801d84:	83 ec 14             	sub    $0x14,%esp
  801d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d8a:	89 1c 24             	mov    %ebx,(%esp)
  801d8d:	e8 bc 0b 00 00       	call   80294e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d92:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d97:	83 f8 01             	cmp    $0x1,%eax
  801d9a:	75 0d                	jne    801da9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d9c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d9f:	89 04 24             	mov    %eax,(%esp)
  801da2:	e8 29 03 00 00       	call   8020d0 <nsipc_close>
  801da7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801da9:	89 d0                	mov    %edx,%eax
  801dab:	83 c4 14             	add    $0x14,%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    

00801db1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801db7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dbe:	00 
  801dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd3:	89 04 24             	mov    %eax,(%esp)
  801dd6:	e8 f0 03 00 00       	call   8021cb <nsipc_send>
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801de3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dea:	00 
  801deb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dee:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dff:	89 04 24             	mov    %eax,(%esp)
  801e02:	e8 44 03 00 00       	call   80214b <nsipc_recv>
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e0f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e12:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e16:	89 04 24             	mov    %eax,(%esp)
  801e19:	e8 38 f7 ff ff       	call   801556 <fd_lookup>
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	78 17                	js     801e39 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e25:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e2b:	39 08                	cmp    %ecx,(%eax)
  801e2d:	75 05                	jne    801e34 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e32:	eb 05                	jmp    801e39 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801e34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	56                   	push   %esi
  801e3f:	53                   	push   %ebx
  801e40:	83 ec 20             	sub    $0x20,%esp
  801e43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e48:	89 04 24             	mov    %eax,(%esp)
  801e4b:	e8 b7 f6 ff ff       	call   801507 <fd_alloc>
  801e50:	89 c3                	mov    %eax,%ebx
  801e52:	85 c0                	test   %eax,%eax
  801e54:	78 21                	js     801e77 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e5d:	00 
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e6c:	e8 42 ee ff ff       	call   800cb3 <sys_page_alloc>
  801e71:	89 c3                	mov    %eax,%ebx
  801e73:	85 c0                	test   %eax,%eax
  801e75:	79 0c                	jns    801e83 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e77:	89 34 24             	mov    %esi,(%esp)
  801e7a:	e8 51 02 00 00       	call   8020d0 <nsipc_close>
		return r;
  801e7f:	89 d8                	mov    %ebx,%eax
  801e81:	eb 20                	jmp    801ea3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e83:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e91:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e98:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e9b:	89 14 24             	mov    %edx,(%esp)
  801e9e:	e8 3d f6 ff ff       	call   8014e0 <fd2num>
}
  801ea3:	83 c4 20             	add    $0x20,%esp
  801ea6:	5b                   	pop    %ebx
  801ea7:	5e                   	pop    %esi
  801ea8:	5d                   	pop    %ebp
  801ea9:	c3                   	ret    

00801eaa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	e8 51 ff ff ff       	call   801e09 <fd2sockid>
		return r;
  801eb8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 23                	js     801ee1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ebe:	8b 55 10             	mov    0x10(%ebp),%edx
  801ec1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ecc:	89 04 24             	mov    %eax,(%esp)
  801ecf:	e8 45 01 00 00       	call   802019 <nsipc_accept>
		return r;
  801ed4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 07                	js     801ee1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801eda:	e8 5c ff ff ff       	call   801e3b <alloc_sockfd>
  801edf:	89 c1                	mov    %eax,%ecx
}
  801ee1:	89 c8                	mov    %ecx,%eax
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	e8 16 ff ff ff       	call   801e09 <fd2sockid>
  801ef3:	89 c2                	mov    %eax,%edx
  801ef5:	85 d2                	test   %edx,%edx
  801ef7:	78 16                	js     801f0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  801efc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f07:	89 14 24             	mov    %edx,(%esp)
  801f0a:	e8 60 01 00 00       	call   80206f <nsipc_bind>
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <shutdown>:

int
shutdown(int s, int how)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	e8 ea fe ff ff       	call   801e09 <fd2sockid>
  801f1f:	89 c2                	mov    %eax,%edx
  801f21:	85 d2                	test   %edx,%edx
  801f23:	78 0f                	js     801f34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2c:	89 14 24             	mov    %edx,(%esp)
  801f2f:	e8 7a 01 00 00       	call   8020ae <nsipc_shutdown>
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	e8 c5 fe ff ff       	call   801e09 <fd2sockid>
  801f44:	89 c2                	mov    %eax,%edx
  801f46:	85 d2                	test   %edx,%edx
  801f48:	78 16                	js     801f60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f58:	89 14 24             	mov    %edx,(%esp)
  801f5b:	e8 8a 01 00 00       	call   8020ea <nsipc_connect>
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <listen>:

int
listen(int s, int backlog)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	e8 99 fe ff ff       	call   801e09 <fd2sockid>
  801f70:	89 c2                	mov    %eax,%edx
  801f72:	85 d2                	test   %edx,%edx
  801f74:	78 0f                	js     801f85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7d:	89 14 24             	mov    %edx,(%esp)
  801f80:	e8 a4 01 00 00       	call   802129 <nsipc_listen>
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	89 04 24             	mov    %eax,(%esp)
  801fa1:	e8 98 02 00 00       	call   80223e <nsipc_socket>
  801fa6:	89 c2                	mov    %eax,%edx
  801fa8:	85 d2                	test   %edx,%edx
  801faa:	78 05                	js     801fb1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801fac:	e8 8a fe ff ff       	call   801e3b <alloc_sockfd>
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	53                   	push   %ebx
  801fb7:	83 ec 14             	sub    $0x14,%esp
  801fba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fbc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fc3:	75 11                	jne    801fd6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fc5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801fcc:	e8 3e 09 00 00       	call   80290f <ipc_find_env>
  801fd1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fd6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801fdd:	00 
  801fde:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801fe5:	00 
  801fe6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fea:	a1 04 50 80 00       	mov    0x805004,%eax
  801fef:	89 04 24             	mov    %eax,(%esp)
  801ff2:	e8 ad 08 00 00       	call   8028a4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ff7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ffe:	00 
  801fff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802006:	00 
  802007:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200e:	e8 3d 08 00 00       	call   802850 <ipc_recv>
}
  802013:	83 c4 14             	add    $0x14,%esp
  802016:	5b                   	pop    %ebx
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	56                   	push   %esi
  80201d:	53                   	push   %ebx
  80201e:	83 ec 10             	sub    $0x10,%esp
  802021:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80202c:	8b 06                	mov    (%esi),%eax
  80202e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802033:	b8 01 00 00 00       	mov    $0x1,%eax
  802038:	e8 76 ff ff ff       	call   801fb3 <nsipc>
  80203d:	89 c3                	mov    %eax,%ebx
  80203f:	85 c0                	test   %eax,%eax
  802041:	78 23                	js     802066 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802043:	a1 10 70 80 00       	mov    0x807010,%eax
  802048:	89 44 24 08          	mov    %eax,0x8(%esp)
  80204c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802053:	00 
  802054:	8b 45 0c             	mov    0xc(%ebp),%eax
  802057:	89 04 24             	mov    %eax,(%esp)
  80205a:	e8 d5 e9 ff ff       	call   800a34 <memmove>
		*addrlen = ret->ret_addrlen;
  80205f:	a1 10 70 80 00       	mov    0x807010,%eax
  802064:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802066:	89 d8                	mov    %ebx,%eax
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	5d                   	pop    %ebp
  80206e:	c3                   	ret    

0080206f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	53                   	push   %ebx
  802073:	83 ec 14             	sub    $0x14,%esp
  802076:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802081:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802085:	8b 45 0c             	mov    0xc(%ebp),%eax
  802088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802093:	e8 9c e9 ff ff       	call   800a34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802098:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80209e:	b8 02 00 00 00       	mov    $0x2,%eax
  8020a3:	e8 0b ff ff ff       	call   801fb3 <nsipc>
}
  8020a8:	83 c4 14             	add    $0x14,%esp
  8020ab:	5b                   	pop    %ebx
  8020ac:	5d                   	pop    %ebp
  8020ad:	c3                   	ret    

008020ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020bf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020c9:	e8 e5 fe ff ff       	call   801fb3 <nsipc>
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020de:	b8 04 00 00 00       	mov    $0x4,%eax
  8020e3:	e8 cb fe ff ff       	call   801fb3 <nsipc>
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	53                   	push   %ebx
  8020ee:	83 ec 14             	sub    $0x14,%esp
  8020f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802100:	8b 45 0c             	mov    0xc(%ebp),%eax
  802103:	89 44 24 04          	mov    %eax,0x4(%esp)
  802107:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80210e:	e8 21 e9 ff ff       	call   800a34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802113:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802119:	b8 05 00 00 00       	mov    $0x5,%eax
  80211e:	e8 90 fe ff ff       	call   801fb3 <nsipc>
}
  802123:	83 c4 14             	add    $0x14,%esp
  802126:	5b                   	pop    %ebx
  802127:	5d                   	pop    %ebp
  802128:	c3                   	ret    

00802129 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80213f:	b8 06 00 00 00       	mov    $0x6,%eax
  802144:	e8 6a fe ff ff       	call   801fb3 <nsipc>
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	83 ec 10             	sub    $0x10,%esp
  802153:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80215e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802164:	8b 45 14             	mov    0x14(%ebp),%eax
  802167:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80216c:	b8 07 00 00 00       	mov    $0x7,%eax
  802171:	e8 3d fe ff ff       	call   801fb3 <nsipc>
  802176:	89 c3                	mov    %eax,%ebx
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 46                	js     8021c2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80217c:	39 f0                	cmp    %esi,%eax
  80217e:	7f 07                	jg     802187 <nsipc_recv+0x3c>
  802180:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802185:	7e 24                	jle    8021ab <nsipc_recv+0x60>
  802187:	c7 44 24 0c db 31 80 	movl   $0x8031db,0xc(%esp)
  80218e:	00 
  80218f:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  802196:	00 
  802197:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80219e:	00 
  80219f:	c7 04 24 f0 31 80 00 	movl   $0x8031f0,(%esp)
  8021a6:	e8 cd df ff ff       	call   800178 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021af:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021b6:	00 
  8021b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ba:	89 04 24             	mov    %eax,(%esp)
  8021bd:	e8 72 e8 ff ff       	call   800a34 <memmove>
	}

	return r;
}
  8021c2:	89 d8                	mov    %ebx,%eax
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	5b                   	pop    %ebx
  8021c8:	5e                   	pop    %esi
  8021c9:	5d                   	pop    %ebp
  8021ca:	c3                   	ret    

008021cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	53                   	push   %ebx
  8021cf:	83 ec 14             	sub    $0x14,%esp
  8021d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021e3:	7e 24                	jle    802209 <nsipc_send+0x3e>
  8021e5:	c7 44 24 0c fc 31 80 	movl   $0x8031fc,0xc(%esp)
  8021ec:	00 
  8021ed:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  8021f4:	00 
  8021f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8021fc:	00 
  8021fd:	c7 04 24 f0 31 80 00 	movl   $0x8031f0,(%esp)
  802204:	e8 6f df ff ff       	call   800178 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802209:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80220d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802210:	89 44 24 04          	mov    %eax,0x4(%esp)
  802214:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80221b:	e8 14 e8 ff ff       	call   800a34 <memmove>
	nsipcbuf.send.req_size = size;
  802220:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802226:	8b 45 14             	mov    0x14(%ebp),%eax
  802229:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80222e:	b8 08 00 00 00       	mov    $0x8,%eax
  802233:	e8 7b fd ff ff       	call   801fb3 <nsipc>
}
  802238:	83 c4 14             	add    $0x14,%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    

0080223e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80224c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802254:	8b 45 10             	mov    0x10(%ebp),%eax
  802257:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80225c:	b8 09 00 00 00       	mov    $0x9,%eax
  802261:	e8 4d fd ff ff       	call   801fb3 <nsipc>
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	56                   	push   %esi
  80226c:	53                   	push   %ebx
  80226d:	83 ec 10             	sub    $0x10,%esp
  802270:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	89 04 24             	mov    %eax,(%esp)
  802279:	e8 72 f2 ff ff       	call   8014f0 <fd2data>
  80227e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802280:	c7 44 24 04 08 32 80 	movl   $0x803208,0x4(%esp)
  802287:	00 
  802288:	89 1c 24             	mov    %ebx,(%esp)
  80228b:	e8 07 e6 ff ff       	call   800897 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802290:	8b 46 04             	mov    0x4(%esi),%eax
  802293:	2b 06                	sub    (%esi),%eax
  802295:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80229b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022a2:	00 00 00 
	stat->st_dev = &devpipe;
  8022a5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022ac:	40 80 00 
	return 0;
}
  8022af:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	5d                   	pop    %ebp
  8022ba:	c3                   	ret    

008022bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	53                   	push   %ebx
  8022bf:	83 ec 14             	sub    $0x14,%esp
  8022c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d0:	e8 85 ea ff ff       	call   800d5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022d5:	89 1c 24             	mov    %ebx,(%esp)
  8022d8:	e8 13 f2 ff ff       	call   8014f0 <fd2data>
  8022dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e8:	e8 6d ea ff ff       	call   800d5a <sys_page_unmap>
}
  8022ed:	83 c4 14             	add    $0x14,%esp
  8022f0:	5b                   	pop    %ebx
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    

008022f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	57                   	push   %edi
  8022f7:	56                   	push   %esi
  8022f8:	53                   	push   %ebx
  8022f9:	83 ec 2c             	sub    $0x2c,%esp
  8022fc:	89 c6                	mov    %eax,%esi
  8022fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802301:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802306:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802309:	89 34 24             	mov    %esi,(%esp)
  80230c:	e8 3d 06 00 00       	call   80294e <pageref>
  802311:	89 c7                	mov    %eax,%edi
  802313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802316:	89 04 24             	mov    %eax,(%esp)
  802319:	e8 30 06 00 00       	call   80294e <pageref>
  80231e:	39 c7                	cmp    %eax,%edi
  802320:	0f 94 c2             	sete   %dl
  802323:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802326:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  80232c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80232f:	39 fb                	cmp    %edi,%ebx
  802331:	74 21                	je     802354 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802333:	84 d2                	test   %dl,%dl
  802335:	74 ca                	je     802301 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802337:	8b 51 58             	mov    0x58(%ecx),%edx
  80233a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80233e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802342:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802346:	c7 04 24 0f 32 80 00 	movl   $0x80320f,(%esp)
  80234d:	e8 1f df ff ff       	call   800271 <cprintf>
  802352:	eb ad                	jmp    802301 <_pipeisclosed+0xe>
	}
}
  802354:	83 c4 2c             	add    $0x2c,%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5f                   	pop    %edi
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    

0080235c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	57                   	push   %edi
  802360:	56                   	push   %esi
  802361:	53                   	push   %ebx
  802362:	83 ec 1c             	sub    $0x1c,%esp
  802365:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802368:	89 34 24             	mov    %esi,(%esp)
  80236b:	e8 80 f1 ff ff       	call   8014f0 <fd2data>
  802370:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802372:	bf 00 00 00 00       	mov    $0x0,%edi
  802377:	eb 45                	jmp    8023be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802379:	89 da                	mov    %ebx,%edx
  80237b:	89 f0                	mov    %esi,%eax
  80237d:	e8 71 ff ff ff       	call   8022f3 <_pipeisclosed>
  802382:	85 c0                	test   %eax,%eax
  802384:	75 41                	jne    8023c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802386:	e8 09 e9 ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80238b:	8b 43 04             	mov    0x4(%ebx),%eax
  80238e:	8b 0b                	mov    (%ebx),%ecx
  802390:	8d 51 20             	lea    0x20(%ecx),%edx
  802393:	39 d0                	cmp    %edx,%eax
  802395:	73 e2                	jae    802379 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802397:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80239e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023a1:	99                   	cltd   
  8023a2:	c1 ea 1b             	shr    $0x1b,%edx
  8023a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8023a8:	83 e1 1f             	and    $0x1f,%ecx
  8023ab:	29 d1                	sub    %edx,%ecx
  8023ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8023b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8023b5:	83 c0 01             	add    $0x1,%eax
  8023b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023bb:	83 c7 01             	add    $0x1,%edi
  8023be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023c1:	75 c8                	jne    80238b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023c3:	89 f8                	mov    %edi,%eax
  8023c5:	eb 05                	jmp    8023cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8023cc:	83 c4 1c             	add    $0x1c,%esp
  8023cf:	5b                   	pop    %ebx
  8023d0:	5e                   	pop    %esi
  8023d1:	5f                   	pop    %edi
  8023d2:	5d                   	pop    %ebp
  8023d3:	c3                   	ret    

008023d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	57                   	push   %edi
  8023d8:	56                   	push   %esi
  8023d9:	53                   	push   %ebx
  8023da:	83 ec 1c             	sub    $0x1c,%esp
  8023dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023e0:	89 3c 24             	mov    %edi,(%esp)
  8023e3:	e8 08 f1 ff ff       	call   8014f0 <fd2data>
  8023e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023ea:	be 00 00 00 00       	mov    $0x0,%esi
  8023ef:	eb 3d                	jmp    80242e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023f1:	85 f6                	test   %esi,%esi
  8023f3:	74 04                	je     8023f9 <devpipe_read+0x25>
				return i;
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	eb 43                	jmp    80243c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023f9:	89 da                	mov    %ebx,%edx
  8023fb:	89 f8                	mov    %edi,%eax
  8023fd:	e8 f1 fe ff ff       	call   8022f3 <_pipeisclosed>
  802402:	85 c0                	test   %eax,%eax
  802404:	75 31                	jne    802437 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802406:	e8 89 e8 ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80240b:	8b 03                	mov    (%ebx),%eax
  80240d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802410:	74 df                	je     8023f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802412:	99                   	cltd   
  802413:	c1 ea 1b             	shr    $0x1b,%edx
  802416:	01 d0                	add    %edx,%eax
  802418:	83 e0 1f             	and    $0x1f,%eax
  80241b:	29 d0                	sub    %edx,%eax
  80241d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802422:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802425:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802428:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80242b:	83 c6 01             	add    $0x1,%esi
  80242e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802431:	75 d8                	jne    80240b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802433:	89 f0                	mov    %esi,%eax
  802435:	eb 05                	jmp    80243c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80243c:	83 c4 1c             	add    $0x1c,%esp
  80243f:	5b                   	pop    %ebx
  802440:	5e                   	pop    %esi
  802441:	5f                   	pop    %edi
  802442:	5d                   	pop    %ebp
  802443:	c3                   	ret    

00802444 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	56                   	push   %esi
  802448:	53                   	push   %ebx
  802449:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80244c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80244f:	89 04 24             	mov    %eax,(%esp)
  802452:	e8 b0 f0 ff ff       	call   801507 <fd_alloc>
  802457:	89 c2                	mov    %eax,%edx
  802459:	85 d2                	test   %edx,%edx
  80245b:	0f 88 4d 01 00 00    	js     8025ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802461:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802468:	00 
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802470:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802477:	e8 37 e8 ff ff       	call   800cb3 <sys_page_alloc>
  80247c:	89 c2                	mov    %eax,%edx
  80247e:	85 d2                	test   %edx,%edx
  802480:	0f 88 28 01 00 00    	js     8025ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802486:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802489:	89 04 24             	mov    %eax,(%esp)
  80248c:	e8 76 f0 ff ff       	call   801507 <fd_alloc>
  802491:	89 c3                	mov    %eax,%ebx
  802493:	85 c0                	test   %eax,%eax
  802495:	0f 88 fe 00 00 00    	js     802599 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80249b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024a2:	00 
  8024a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b1:	e8 fd e7 ff ff       	call   800cb3 <sys_page_alloc>
  8024b6:	89 c3                	mov    %eax,%ebx
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	0f 88 d9 00 00 00    	js     802599 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	89 04 24             	mov    %eax,(%esp)
  8024c6:	e8 25 f0 ff ff       	call   8014f0 <fd2data>
  8024cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024d4:	00 
  8024d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e0:	e8 ce e7 ff ff       	call   800cb3 <sys_page_alloc>
  8024e5:	89 c3                	mov    %eax,%ebx
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	0f 88 97 00 00 00    	js     802586 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f2:	89 04 24             	mov    %eax,(%esp)
  8024f5:	e8 f6 ef ff ff       	call   8014f0 <fd2data>
  8024fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802501:	00 
  802502:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802506:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80250d:	00 
  80250e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802512:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802519:	e8 e9 e7 ff ff       	call   800d07 <sys_page_map>
  80251e:	89 c3                	mov    %eax,%ebx
  802520:	85 c0                	test   %eax,%eax
  802522:	78 52                	js     802576 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802524:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802539:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80253f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802542:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802547:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	89 04 24             	mov    %eax,(%esp)
  802554:	e8 87 ef ff ff       	call   8014e0 <fd2num>
  802559:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80255c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80255e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802561:	89 04 24             	mov    %eax,(%esp)
  802564:	e8 77 ef ff ff       	call   8014e0 <fd2num>
  802569:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80256c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	eb 38                	jmp    8025ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802576:	89 74 24 04          	mov    %esi,0x4(%esp)
  80257a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802581:	e8 d4 e7 ff ff       	call   800d5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802589:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802594:	e8 c1 e7 ff ff       	call   800d5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a7:	e8 ae e7 ff ff       	call   800d5a <sys_page_unmap>
  8025ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8025ae:	83 c4 30             	add    $0x30,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5d                   	pop    %ebp
  8025b4:	c3                   	ret    

008025b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c5:	89 04 24             	mov    %eax,(%esp)
  8025c8:	e8 89 ef ff ff       	call   801556 <fd_lookup>
  8025cd:	89 c2                	mov    %eax,%edx
  8025cf:	85 d2                	test   %edx,%edx
  8025d1:	78 15                	js     8025e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	89 04 24             	mov    %eax,(%esp)
  8025d9:	e8 12 ef ff ff       	call   8014f0 <fd2data>
	return _pipeisclosed(fd, p);
  8025de:	89 c2                	mov    %eax,%edx
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	e8 0b fd ff ff       	call   8022f3 <_pipeisclosed>
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    
  8025ea:	66 90                	xchg   %ax,%ax
  8025ec:	66 90                	xchg   %ax,%ax
  8025ee:	66 90                	xchg   %ax,%ax

008025f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f8:	5d                   	pop    %ebp
  8025f9:	c3                   	ret    

008025fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802600:	c7 44 24 04 27 32 80 	movl   $0x803227,0x4(%esp)
  802607:	00 
  802608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260b:	89 04 24             	mov    %eax,(%esp)
  80260e:	e8 84 e2 ff ff       	call   800897 <strcpy>
	return 0;
}
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	57                   	push   %edi
  80261e:	56                   	push   %esi
  80261f:	53                   	push   %ebx
  802620:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802626:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80262b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802631:	eb 31                	jmp    802664 <devcons_write+0x4a>
		m = n - tot;
  802633:	8b 75 10             	mov    0x10(%ebp),%esi
  802636:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802638:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80263b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802640:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802643:	89 74 24 08          	mov    %esi,0x8(%esp)
  802647:	03 45 0c             	add    0xc(%ebp),%eax
  80264a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80264e:	89 3c 24             	mov    %edi,(%esp)
  802651:	e8 de e3 ff ff       	call   800a34 <memmove>
		sys_cputs(buf, m);
  802656:	89 74 24 04          	mov    %esi,0x4(%esp)
  80265a:	89 3c 24             	mov    %edi,(%esp)
  80265d:	e8 84 e5 ff ff       	call   800be6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802662:	01 f3                	add    %esi,%ebx
  802664:	89 d8                	mov    %ebx,%eax
  802666:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802669:	72 c8                	jb     802633 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80266b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    

00802676 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802681:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802685:	75 07                	jne    80268e <devcons_read+0x18>
  802687:	eb 2a                	jmp    8026b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802689:	e8 06 e6 ff ff       	call   800c94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80268e:	66 90                	xchg   %ax,%ax
  802690:	e8 6f e5 ff ff       	call   800c04 <sys_cgetc>
  802695:	85 c0                	test   %eax,%eax
  802697:	74 f0                	je     802689 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802699:	85 c0                	test   %eax,%eax
  80269b:	78 16                	js     8026b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80269d:	83 f8 04             	cmp    $0x4,%eax
  8026a0:	74 0c                	je     8026ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8026a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a5:	88 02                	mov    %al,(%edx)
	return 1;
  8026a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ac:	eb 05                	jmp    8026b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8026ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8026c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8026c8:	00 
  8026c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026cc:	89 04 24             	mov    %eax,(%esp)
  8026cf:	e8 12 e5 ff ff       	call   800be6 <sys_cputs>
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <getchar>:

int
getchar(void)
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026e3:	00 
  8026e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f2:	e8 f3 f0 ff ff       	call   8017ea <read>
	if (r < 0)
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	78 0f                	js     80270a <getchar+0x34>
		return r;
	if (r < 1)
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	7e 06                	jle    802705 <getchar+0x2f>
		return -E_EOF;
	return c;
  8026ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802703:	eb 05                	jmp    80270a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802705:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80270a:	c9                   	leave  
  80270b:	c3                   	ret    

0080270c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
  80270f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802712:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802715:	89 44 24 04          	mov    %eax,0x4(%esp)
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	89 04 24             	mov    %eax,(%esp)
  80271f:	e8 32 ee ff ff       	call   801556 <fd_lookup>
  802724:	85 c0                	test   %eax,%eax
  802726:	78 11                	js     802739 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802731:	39 10                	cmp    %edx,(%eax)
  802733:	0f 94 c0             	sete   %al
  802736:	0f b6 c0             	movzbl %al,%eax
}
  802739:	c9                   	leave  
  80273a:	c3                   	ret    

0080273b <opencons>:

int
opencons(void)
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
  80273e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802741:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802744:	89 04 24             	mov    %eax,(%esp)
  802747:	e8 bb ed ff ff       	call   801507 <fd_alloc>
		return r;
  80274c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80274e:	85 c0                	test   %eax,%eax
  802750:	78 40                	js     802792 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802752:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802759:	00 
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802761:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802768:	e8 46 e5 ff ff       	call   800cb3 <sys_page_alloc>
		return r;
  80276d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80276f:	85 c0                	test   %eax,%eax
  802771:	78 1f                	js     802792 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802773:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802788:	89 04 24             	mov    %eax,(%esp)
  80278b:	e8 50 ed ff ff       	call   8014e0 <fd2num>
  802790:	89 c2                	mov    %eax,%edx
}
  802792:	89 d0                	mov    %edx,%eax
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80279c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027a3:	75 70                	jne    802815 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  8027a5:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  8027ac:	00 
  8027ad:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8027b4:	ee 
  8027b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027bc:	e8 f2 e4 ff ff       	call   800cb3 <sys_page_alloc>
		if (error < 0)
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	79 1c                	jns    8027e1 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  8027c5:	c7 44 24 08 34 32 80 	movl   $0x803234,0x8(%esp)
  8027cc:	00 
  8027cd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8027d4:	00 
  8027d5:	c7 04 24 87 32 80 00 	movl   $0x803287,(%esp)
  8027dc:	e8 97 d9 ff ff       	call   800178 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8027e1:	c7 44 24 04 1f 28 80 	movl   $0x80281f,0x4(%esp)
  8027e8:	00 
  8027e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f0:	e8 5e e6 ff ff       	call   800e53 <sys_env_set_pgfault_upcall>
		if (error < 0)
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	79 1c                	jns    802815 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  8027f9:	c7 44 24 08 5c 32 80 	movl   $0x80325c,0x8(%esp)
  802800:	00 
  802801:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802808:	00 
  802809:	c7 04 24 87 32 80 00 	movl   $0x803287,(%esp)
  802810:	e8 63 d9 ff ff       	call   800178 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80281f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802820:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802825:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802827:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  80282a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  80282e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802833:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802837:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802839:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80283c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80283d:	83 c4 04             	add    $0x4,%esp
	popfl
  802840:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802841:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802842:	c3                   	ret    
  802843:	66 90                	xchg   %ax,%ax
  802845:	66 90                	xchg   %ax,%ax
  802847:	66 90                	xchg   %ax,%ax
  802849:	66 90                	xchg   %ax,%ax
  80284b:	66 90                	xchg   %ax,%ax
  80284d:	66 90                	xchg   %ax,%ax
  80284f:	90                   	nop

00802850 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
  802853:	56                   	push   %esi
  802854:	53                   	push   %ebx
  802855:	83 ec 10             	sub    $0x10,%esp
  802858:	8b 75 08             	mov    0x8(%ebp),%esi
  80285b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80285e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802861:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802863:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802868:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80286b:	89 04 24             	mov    %eax,(%esp)
  80286e:	e8 56 e6 ff ff       	call   800ec9 <sys_ipc_recv>
  802873:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802875:	85 d2                	test   %edx,%edx
  802877:	75 24                	jne    80289d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802879:	85 f6                	test   %esi,%esi
  80287b:	74 0a                	je     802887 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80287d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802882:	8b 40 74             	mov    0x74(%eax),%eax
  802885:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802887:	85 db                	test   %ebx,%ebx
  802889:	74 0a                	je     802895 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80288b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802890:	8b 40 78             	mov    0x78(%eax),%eax
  802893:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802895:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80289a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80289d:	83 c4 10             	add    $0x10,%esp
  8028a0:	5b                   	pop    %ebx
  8028a1:	5e                   	pop    %esi
  8028a2:	5d                   	pop    %ebp
  8028a3:	c3                   	ret    

008028a4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
  8028a7:	57                   	push   %edi
  8028a8:	56                   	push   %esi
  8028a9:	53                   	push   %ebx
  8028aa:	83 ec 1c             	sub    $0x1c,%esp
  8028ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8028b6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8028b8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028bd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8028c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028cf:	89 3c 24             	mov    %edi,(%esp)
  8028d2:	e8 cf e5 ff ff       	call   800ea6 <sys_ipc_try_send>

		if (ret == 0)
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 2c                	je     802907 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8028db:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028de:	74 20                	je     802900 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8028e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028e4:	c7 44 24 08 98 32 80 	movl   $0x803298,0x8(%esp)
  8028eb:	00 
  8028ec:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8028f3:	00 
  8028f4:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  8028fb:	e8 78 d8 ff ff       	call   800178 <_panic>
		}

		sys_yield();
  802900:	e8 8f e3 ff ff       	call   800c94 <sys_yield>
	}
  802905:	eb b9                	jmp    8028c0 <ipc_send+0x1c>
}
  802907:	83 c4 1c             	add    $0x1c,%esp
  80290a:	5b                   	pop    %ebx
  80290b:	5e                   	pop    %esi
  80290c:	5f                   	pop    %edi
  80290d:	5d                   	pop    %ebp
  80290e:	c3                   	ret    

0080290f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80290f:	55                   	push   %ebp
  802910:	89 e5                	mov    %esp,%ebp
  802912:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80291a:	89 c2                	mov    %eax,%edx
  80291c:	c1 e2 07             	shl    $0x7,%edx
  80291f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802926:	8b 52 50             	mov    0x50(%edx),%edx
  802929:	39 ca                	cmp    %ecx,%edx
  80292b:	75 11                	jne    80293e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80292d:	89 c2                	mov    %eax,%edx
  80292f:	c1 e2 07             	shl    $0x7,%edx
  802932:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802939:	8b 40 40             	mov    0x40(%eax),%eax
  80293c:	eb 0e                	jmp    80294c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80293e:	83 c0 01             	add    $0x1,%eax
  802941:	3d 00 04 00 00       	cmp    $0x400,%eax
  802946:	75 d2                	jne    80291a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802948:	66 b8 00 00          	mov    $0x0,%ax
}
  80294c:	5d                   	pop    %ebp
  80294d:	c3                   	ret    

0080294e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802954:	89 d0                	mov    %edx,%eax
  802956:	c1 e8 16             	shr    $0x16,%eax
  802959:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802960:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802965:	f6 c1 01             	test   $0x1,%cl
  802968:	74 1d                	je     802987 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80296a:	c1 ea 0c             	shr    $0xc,%edx
  80296d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802974:	f6 c2 01             	test   $0x1,%dl
  802977:	74 0e                	je     802987 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802979:	c1 ea 0c             	shr    $0xc,%edx
  80297c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802983:	ef 
  802984:	0f b7 c0             	movzwl %ax,%eax
}
  802987:	5d                   	pop    %ebp
  802988:	c3                   	ret    
  802989:	66 90                	xchg   %ax,%ax
  80298b:	66 90                	xchg   %ax,%ax
  80298d:	66 90                	xchg   %ax,%ax
  80298f:	90                   	nop

00802990 <__udivdi3>:
  802990:	55                   	push   %ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	83 ec 0c             	sub    $0xc,%esp
  802996:	8b 44 24 28          	mov    0x28(%esp),%eax
  80299a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80299e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8029a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8029ac:	89 ea                	mov    %ebp,%edx
  8029ae:	89 0c 24             	mov    %ecx,(%esp)
  8029b1:	75 2d                	jne    8029e0 <__udivdi3+0x50>
  8029b3:	39 e9                	cmp    %ebp,%ecx
  8029b5:	77 61                	ja     802a18 <__udivdi3+0x88>
  8029b7:	85 c9                	test   %ecx,%ecx
  8029b9:	89 ce                	mov    %ecx,%esi
  8029bb:	75 0b                	jne    8029c8 <__udivdi3+0x38>
  8029bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c2:	31 d2                	xor    %edx,%edx
  8029c4:	f7 f1                	div    %ecx
  8029c6:	89 c6                	mov    %eax,%esi
  8029c8:	31 d2                	xor    %edx,%edx
  8029ca:	89 e8                	mov    %ebp,%eax
  8029cc:	f7 f6                	div    %esi
  8029ce:	89 c5                	mov    %eax,%ebp
  8029d0:	89 f8                	mov    %edi,%eax
  8029d2:	f7 f6                	div    %esi
  8029d4:	89 ea                	mov    %ebp,%edx
  8029d6:	83 c4 0c             	add    $0xc,%esp
  8029d9:	5e                   	pop    %esi
  8029da:	5f                   	pop    %edi
  8029db:	5d                   	pop    %ebp
  8029dc:	c3                   	ret    
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	39 e8                	cmp    %ebp,%eax
  8029e2:	77 24                	ja     802a08 <__udivdi3+0x78>
  8029e4:	0f bd e8             	bsr    %eax,%ebp
  8029e7:	83 f5 1f             	xor    $0x1f,%ebp
  8029ea:	75 3c                	jne    802a28 <__udivdi3+0x98>
  8029ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029f0:	39 34 24             	cmp    %esi,(%esp)
  8029f3:	0f 86 9f 00 00 00    	jbe    802a98 <__udivdi3+0x108>
  8029f9:	39 d0                	cmp    %edx,%eax
  8029fb:	0f 82 97 00 00 00    	jb     802a98 <__udivdi3+0x108>
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	31 d2                	xor    %edx,%edx
  802a0a:	31 c0                	xor    %eax,%eax
  802a0c:	83 c4 0c             	add    $0xc,%esp
  802a0f:	5e                   	pop    %esi
  802a10:	5f                   	pop    %edi
  802a11:	5d                   	pop    %ebp
  802a12:	c3                   	ret    
  802a13:	90                   	nop
  802a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a18:	89 f8                	mov    %edi,%eax
  802a1a:	f7 f1                	div    %ecx
  802a1c:	31 d2                	xor    %edx,%edx
  802a1e:	83 c4 0c             	add    $0xc,%esp
  802a21:	5e                   	pop    %esi
  802a22:	5f                   	pop    %edi
  802a23:	5d                   	pop    %ebp
  802a24:	c3                   	ret    
  802a25:	8d 76 00             	lea    0x0(%esi),%esi
  802a28:	89 e9                	mov    %ebp,%ecx
  802a2a:	8b 3c 24             	mov    (%esp),%edi
  802a2d:	d3 e0                	shl    %cl,%eax
  802a2f:	89 c6                	mov    %eax,%esi
  802a31:	b8 20 00 00 00       	mov    $0x20,%eax
  802a36:	29 e8                	sub    %ebp,%eax
  802a38:	89 c1                	mov    %eax,%ecx
  802a3a:	d3 ef                	shr    %cl,%edi
  802a3c:	89 e9                	mov    %ebp,%ecx
  802a3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a42:	8b 3c 24             	mov    (%esp),%edi
  802a45:	09 74 24 08          	or     %esi,0x8(%esp)
  802a49:	89 d6                	mov    %edx,%esi
  802a4b:	d3 e7                	shl    %cl,%edi
  802a4d:	89 c1                	mov    %eax,%ecx
  802a4f:	89 3c 24             	mov    %edi,(%esp)
  802a52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a56:	d3 ee                	shr    %cl,%esi
  802a58:	89 e9                	mov    %ebp,%ecx
  802a5a:	d3 e2                	shl    %cl,%edx
  802a5c:	89 c1                	mov    %eax,%ecx
  802a5e:	d3 ef                	shr    %cl,%edi
  802a60:	09 d7                	or     %edx,%edi
  802a62:	89 f2                	mov    %esi,%edx
  802a64:	89 f8                	mov    %edi,%eax
  802a66:	f7 74 24 08          	divl   0x8(%esp)
  802a6a:	89 d6                	mov    %edx,%esi
  802a6c:	89 c7                	mov    %eax,%edi
  802a6e:	f7 24 24             	mull   (%esp)
  802a71:	39 d6                	cmp    %edx,%esi
  802a73:	89 14 24             	mov    %edx,(%esp)
  802a76:	72 30                	jb     802aa8 <__udivdi3+0x118>
  802a78:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a7c:	89 e9                	mov    %ebp,%ecx
  802a7e:	d3 e2                	shl    %cl,%edx
  802a80:	39 c2                	cmp    %eax,%edx
  802a82:	73 05                	jae    802a89 <__udivdi3+0xf9>
  802a84:	3b 34 24             	cmp    (%esp),%esi
  802a87:	74 1f                	je     802aa8 <__udivdi3+0x118>
  802a89:	89 f8                	mov    %edi,%eax
  802a8b:	31 d2                	xor    %edx,%edx
  802a8d:	e9 7a ff ff ff       	jmp    802a0c <__udivdi3+0x7c>
  802a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a98:	31 d2                	xor    %edx,%edx
  802a9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a9f:	e9 68 ff ff ff       	jmp    802a0c <__udivdi3+0x7c>
  802aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802aa8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	83 c4 0c             	add    $0xc,%esp
  802ab0:	5e                   	pop    %esi
  802ab1:	5f                   	pop    %edi
  802ab2:	5d                   	pop    %ebp
  802ab3:	c3                   	ret    
  802ab4:	66 90                	xchg   %ax,%ax
  802ab6:	66 90                	xchg   %ax,%ax
  802ab8:	66 90                	xchg   %ax,%ax
  802aba:	66 90                	xchg   %ax,%ax
  802abc:	66 90                	xchg   %ax,%ax
  802abe:	66 90                	xchg   %ax,%ax

00802ac0 <__umoddi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	57                   	push   %edi
  802ac2:	56                   	push   %esi
  802ac3:	83 ec 14             	sub    $0x14,%esp
  802ac6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ace:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ad2:	89 c7                	mov    %eax,%edi
  802ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802adc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ae0:	89 34 24             	mov    %esi,(%esp)
  802ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	89 c2                	mov    %eax,%edx
  802aeb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aef:	75 17                	jne    802b08 <__umoddi3+0x48>
  802af1:	39 fe                	cmp    %edi,%esi
  802af3:	76 4b                	jbe    802b40 <__umoddi3+0x80>
  802af5:	89 c8                	mov    %ecx,%eax
  802af7:	89 fa                	mov    %edi,%edx
  802af9:	f7 f6                	div    %esi
  802afb:	89 d0                	mov    %edx,%eax
  802afd:	31 d2                	xor    %edx,%edx
  802aff:	83 c4 14             	add    $0x14,%esp
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	66 90                	xchg   %ax,%ax
  802b08:	39 f8                	cmp    %edi,%eax
  802b0a:	77 54                	ja     802b60 <__umoddi3+0xa0>
  802b0c:	0f bd e8             	bsr    %eax,%ebp
  802b0f:	83 f5 1f             	xor    $0x1f,%ebp
  802b12:	75 5c                	jne    802b70 <__umoddi3+0xb0>
  802b14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b18:	39 3c 24             	cmp    %edi,(%esp)
  802b1b:	0f 87 e7 00 00 00    	ja     802c08 <__umoddi3+0x148>
  802b21:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b25:	29 f1                	sub    %esi,%ecx
  802b27:	19 c7                	sbb    %eax,%edi
  802b29:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b31:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b35:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b39:	83 c4 14             	add    $0x14,%esp
  802b3c:	5e                   	pop    %esi
  802b3d:	5f                   	pop    %edi
  802b3e:	5d                   	pop    %ebp
  802b3f:	c3                   	ret    
  802b40:	85 f6                	test   %esi,%esi
  802b42:	89 f5                	mov    %esi,%ebp
  802b44:	75 0b                	jne    802b51 <__umoddi3+0x91>
  802b46:	b8 01 00 00 00       	mov    $0x1,%eax
  802b4b:	31 d2                	xor    %edx,%edx
  802b4d:	f7 f6                	div    %esi
  802b4f:	89 c5                	mov    %eax,%ebp
  802b51:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b55:	31 d2                	xor    %edx,%edx
  802b57:	f7 f5                	div    %ebp
  802b59:	89 c8                	mov    %ecx,%eax
  802b5b:	f7 f5                	div    %ebp
  802b5d:	eb 9c                	jmp    802afb <__umoddi3+0x3b>
  802b5f:	90                   	nop
  802b60:	89 c8                	mov    %ecx,%eax
  802b62:	89 fa                	mov    %edi,%edx
  802b64:	83 c4 14             	add    $0x14,%esp
  802b67:	5e                   	pop    %esi
  802b68:	5f                   	pop    %edi
  802b69:	5d                   	pop    %ebp
  802b6a:	c3                   	ret    
  802b6b:	90                   	nop
  802b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b70:	8b 04 24             	mov    (%esp),%eax
  802b73:	be 20 00 00 00       	mov    $0x20,%esi
  802b78:	89 e9                	mov    %ebp,%ecx
  802b7a:	29 ee                	sub    %ebp,%esi
  802b7c:	d3 e2                	shl    %cl,%edx
  802b7e:	89 f1                	mov    %esi,%ecx
  802b80:	d3 e8                	shr    %cl,%eax
  802b82:	89 e9                	mov    %ebp,%ecx
  802b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b88:	8b 04 24             	mov    (%esp),%eax
  802b8b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b8f:	89 fa                	mov    %edi,%edx
  802b91:	d3 e0                	shl    %cl,%eax
  802b93:	89 f1                	mov    %esi,%ecx
  802b95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b99:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b9d:	d3 ea                	shr    %cl,%edx
  802b9f:	89 e9                	mov    %ebp,%ecx
  802ba1:	d3 e7                	shl    %cl,%edi
  802ba3:	89 f1                	mov    %esi,%ecx
  802ba5:	d3 e8                	shr    %cl,%eax
  802ba7:	89 e9                	mov    %ebp,%ecx
  802ba9:	09 f8                	or     %edi,%eax
  802bab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802baf:	f7 74 24 04          	divl   0x4(%esp)
  802bb3:	d3 e7                	shl    %cl,%edi
  802bb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bb9:	89 d7                	mov    %edx,%edi
  802bbb:	f7 64 24 08          	mull   0x8(%esp)
  802bbf:	39 d7                	cmp    %edx,%edi
  802bc1:	89 c1                	mov    %eax,%ecx
  802bc3:	89 14 24             	mov    %edx,(%esp)
  802bc6:	72 2c                	jb     802bf4 <__umoddi3+0x134>
  802bc8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802bcc:	72 22                	jb     802bf0 <__umoddi3+0x130>
  802bce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802bd2:	29 c8                	sub    %ecx,%eax
  802bd4:	19 d7                	sbb    %edx,%edi
  802bd6:	89 e9                	mov    %ebp,%ecx
  802bd8:	89 fa                	mov    %edi,%edx
  802bda:	d3 e8                	shr    %cl,%eax
  802bdc:	89 f1                	mov    %esi,%ecx
  802bde:	d3 e2                	shl    %cl,%edx
  802be0:	89 e9                	mov    %ebp,%ecx
  802be2:	d3 ef                	shr    %cl,%edi
  802be4:	09 d0                	or     %edx,%eax
  802be6:	89 fa                	mov    %edi,%edx
  802be8:	83 c4 14             	add    $0x14,%esp
  802beb:	5e                   	pop    %esi
  802bec:	5f                   	pop    %edi
  802bed:	5d                   	pop    %ebp
  802bee:	c3                   	ret    
  802bef:	90                   	nop
  802bf0:	39 d7                	cmp    %edx,%edi
  802bf2:	75 da                	jne    802bce <__umoddi3+0x10e>
  802bf4:	8b 14 24             	mov    (%esp),%edx
  802bf7:	89 c1                	mov    %eax,%ecx
  802bf9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bfd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c01:	eb cb                	jmp    802bce <__umoddi3+0x10e>
  802c03:	90                   	nop
  802c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c0c:	0f 82 0f ff ff ff    	jb     802b21 <__umoddi3+0x61>
  802c12:	e9 1a ff ff ff       	jmp    802b31 <__umoddi3+0x71>
