
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 cd 00 00 00       	call   8000fe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	c7 04 24 60 27 80 00 	movl   $0x802760,(%esp)
  800040:	e8 17 02 00 00       	call   80025c <cprintf>
	for (i = 0; i < ARRAYSIZE; i++)
  800045:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004a:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800051:	00 
  800052:	74 20                	je     800074 <umain+0x41>
			panic("bigarray[%d] isn't cleared!\n", i);
  800054:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800058:	c7 44 24 08 db 27 80 	movl   $0x8027db,0x8(%esp)
  80005f:	00 
  800060:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800067:	00 
  800068:	c7 04 24 f8 27 80 00 	movl   $0x8027f8,(%esp)
  80006f:	e8 ef 00 00 00       	call   800163 <_panic>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  800074:	83 c0 01             	add    $0x1,%eax
  800077:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80007c:	75 cc                	jne    80004a <umain+0x17>
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
  800083:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80008a:	83 c0 01             	add    $0x1,%eax
  80008d:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800092:	75 ef                	jne    800083 <umain+0x50>
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != i)
  800099:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  8000a0:	74 20                	je     8000c2 <umain+0x8f>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a6:	c7 44 24 08 80 27 80 	movl   $0x802780,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 f8 27 80 00 	movl   $0x8027f8,(%esp)
  8000bd:	e8 a1 00 00 00       	call   800163 <_panic>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000c2:	83 c0 01             	add    $0x1,%eax
  8000c5:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000ca:	75 cd                	jne    800099 <umain+0x66>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000cc:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  8000d3:	e8 84 01 00 00       	call   80025c <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000d8:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000df:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000e2:	c7 44 24 08 07 28 80 	movl   $0x802807,0x8(%esp)
  8000e9:	00 
  8000ea:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8000f1:	00 
  8000f2:	c7 04 24 f8 27 80 00 	movl   $0x8027f8,(%esp)
  8000f9:	e8 65 00 00 00       	call   800163 <_panic>

008000fe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	83 ec 10             	sub    $0x10,%esp
  800106:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800109:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  80010c:	e8 54 0b 00 00       	call   800c65 <sys_getenvid>
  800111:	25 ff 03 00 00       	and    $0x3ff,%eax
  800116:	89 c2                	mov    %eax,%edx
  800118:	c1 e2 07             	shl    $0x7,%edx
  80011b:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800122:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800127:	85 db                	test   %ebx,%ebx
  800129:	7e 07                	jle    800132 <libmain+0x34>
		binaryname = argv[0];
  80012b:	8b 06                	mov    (%esi),%eax
  80012d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800132:	89 74 24 04          	mov    %esi,0x4(%esp)
  800136:	89 1c 24             	mov    %ebx,(%esp)
  800139:	e8 f5 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013e:	e8 07 00 00 00       	call   80014a <exit>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5d                   	pop    %ebp
  800149:	c3                   	ret    

0080014a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800150:	e8 55 11 00 00       	call   8012aa <close_all>
	sys_env_destroy(0);
  800155:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015c:	e8 b2 0a 00 00       	call   800c13 <sys_env_destroy>
}
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
  800168:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80016b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80016e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800174:	e8 ec 0a 00 00       	call   800c65 <sys_getenvid>
  800179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800180:	8b 55 08             	mov    0x8(%ebp),%edx
  800183:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800187:	89 74 24 08          	mov    %esi,0x8(%esp)
  80018b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018f:	c7 04 24 28 28 80 00 	movl   $0x802828,(%esp)
  800196:	e8 c1 00 00 00       	call   80025c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80019b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80019f:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a2:	89 04 24             	mov    %eax,(%esp)
  8001a5:	e8 51 00 00 00       	call   8001fb <vcprintf>
	cprintf("\n");
  8001aa:	c7 04 24 f6 27 80 00 	movl   $0x8027f6,(%esp)
  8001b1:	e8 a6 00 00 00       	call   80025c <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b6:	cc                   	int3   
  8001b7:	eb fd                	jmp    8001b6 <_panic+0x53>

008001b9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 14             	sub    $0x14,%esp
  8001c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001c3:	8b 13                	mov    (%ebx),%edx
  8001c5:	8d 42 01             	lea    0x1(%edx),%eax
  8001c8:	89 03                	mov    %eax,(%ebx)
  8001ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001cd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001d1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d6:	75 19                	jne    8001f1 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001d8:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001df:	00 
  8001e0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e3:	89 04 24             	mov    %eax,(%esp)
  8001e6:	e8 eb 09 00 00       	call   800bd6 <sys_cputs>
		b->idx = 0;
  8001eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f5:	83 c4 14             	add    $0x14,%esp
  8001f8:	5b                   	pop    %ebx
  8001f9:	5d                   	pop    %ebp
  8001fa:	c3                   	ret    

008001fb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800204:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020b:	00 00 00 
	b.cnt = 0;
  80020e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800215:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021f:	8b 45 08             	mov    0x8(%ebp),%eax
  800222:	89 44 24 08          	mov    %eax,0x8(%esp)
  800226:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80022c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800230:	c7 04 24 b9 01 80 00 	movl   $0x8001b9,(%esp)
  800237:	e8 b2 01 00 00       	call   8003ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80023c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800242:	89 44 24 04          	mov    %eax,0x4(%esp)
  800246:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80024c:	89 04 24             	mov    %eax,(%esp)
  80024f:	e8 82 09 00 00       	call   800bd6 <sys_cputs>

	return b.cnt;
}
  800254:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80025a:	c9                   	leave  
  80025b:	c3                   	ret    

0080025c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800262:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800265:	89 44 24 04          	mov    %eax,0x4(%esp)
  800269:	8b 45 08             	mov    0x8(%ebp),%eax
  80026c:	89 04 24             	mov    %eax,(%esp)
  80026f:	e8 87 ff ff ff       	call   8001fb <vcprintf>
	va_end(ap);

	return cnt;
}
  800274:	c9                   	leave  
  800275:	c3                   	ret    
  800276:	66 90                	xchg   %ax,%ax
  800278:	66 90                	xchg   %ax,%ax
  80027a:	66 90                	xchg   %ax,%ax
  80027c:	66 90                	xchg   %ax,%ax
  80027e:	66 90                	xchg   %ax,%ax

00800280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 3c             	sub    $0x3c,%esp
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028c:	89 d7                	mov    %edx,%edi
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	89 c3                	mov    %eax,%ebx
  800299:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80029c:	8b 45 10             	mov    0x10(%ebp),%eax
  80029f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002ad:	39 d9                	cmp    %ebx,%ecx
  8002af:	72 05                	jb     8002b6 <printnum+0x36>
  8002b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002b4:	77 69                	ja     80031f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002bd:	83 ee 01             	sub    $0x1,%esi
  8002c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002d0:	89 c3                	mov    %eax,%ebx
  8002d2:	89 d6                	mov    %edx,%esi
  8002d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	e8 dc 21 00 00       	call   8024d0 <__udivdi3>
  8002f4:	89 d9                	mov    %ebx,%ecx
  8002f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002fe:	89 04 24             	mov    %eax,(%esp)
  800301:	89 54 24 04          	mov    %edx,0x4(%esp)
  800305:	89 fa                	mov    %edi,%edx
  800307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80030a:	e8 71 ff ff ff       	call   800280 <printnum>
  80030f:	eb 1b                	jmp    80032c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800311:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800315:	8b 45 18             	mov    0x18(%ebp),%eax
  800318:	89 04 24             	mov    %eax,(%esp)
  80031b:	ff d3                	call   *%ebx
  80031d:	eb 03                	jmp    800322 <printnum+0xa2>
  80031f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800322:	83 ee 01             	sub    $0x1,%esi
  800325:	85 f6                	test   %esi,%esi
  800327:	7f e8                	jg     800311 <printnum+0x91>
  800329:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800330:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800334:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800337:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80033a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	e8 ac 22 00 00       	call   802600 <__umoddi3>
  800354:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800358:	0f be 80 4b 28 80 00 	movsbl 0x80284b(%eax),%eax
  80035f:	89 04 24             	mov    %eax,(%esp)
  800362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800365:	ff d0                	call   *%eax
}
  800367:	83 c4 3c             	add    $0x3c,%esp
  80036a:	5b                   	pop    %ebx
  80036b:	5e                   	pop    %esi
  80036c:	5f                   	pop    %edi
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800372:	83 fa 01             	cmp    $0x1,%edx
  800375:	7e 0e                	jle    800385 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800377:	8b 10                	mov    (%eax),%edx
  800379:	8d 4a 08             	lea    0x8(%edx),%ecx
  80037c:	89 08                	mov    %ecx,(%eax)
  80037e:	8b 02                	mov    (%edx),%eax
  800380:	8b 52 04             	mov    0x4(%edx),%edx
  800383:	eb 22                	jmp    8003a7 <getuint+0x38>
	else if (lflag)
  800385:	85 d2                	test   %edx,%edx
  800387:	74 10                	je     800399 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038e:	89 08                	mov    %ecx,(%eax)
  800390:	8b 02                	mov    (%edx),%eax
  800392:	ba 00 00 00 00       	mov    $0x0,%edx
  800397:	eb 0e                	jmp    8003a7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800399:	8b 10                	mov    (%eax),%edx
  80039b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80039e:	89 08                	mov    %ecx,(%eax)
  8003a0:	8b 02                	mov    (%edx),%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003a7:	5d                   	pop    %ebp
  8003a8:	c3                   	ret    

008003a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b3:	8b 10                	mov    (%eax),%edx
  8003b5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b8:	73 0a                	jae    8003c4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003bd:	89 08                	mov    %ecx,(%eax)
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	88 02                	mov    %al,(%edx)
}
  8003c4:	5d                   	pop    %ebp
  8003c5:	c3                   	ret    

008003c6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
  8003c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	89 04 24             	mov    %eax,(%esp)
  8003e7:	e8 02 00 00 00       	call   8003ee <vprintfmt>
	va_end(ap);
}
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	57                   	push   %edi
  8003f2:	56                   	push   %esi
  8003f3:	53                   	push   %ebx
  8003f4:	83 ec 3c             	sub    $0x3c,%esp
  8003f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003fd:	eb 14                	jmp    800413 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ff:	85 c0                	test   %eax,%eax
  800401:	0f 84 b3 03 00 00    	je     8007ba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800407:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80040b:	89 04 24             	mov    %eax,(%esp)
  80040e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800411:	89 f3                	mov    %esi,%ebx
  800413:	8d 73 01             	lea    0x1(%ebx),%esi
  800416:	0f b6 03             	movzbl (%ebx),%eax
  800419:	83 f8 25             	cmp    $0x25,%eax
  80041c:	75 e1                	jne    8003ff <vprintfmt+0x11>
  80041e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800422:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800429:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800430:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800437:	ba 00 00 00 00       	mov    $0x0,%edx
  80043c:	eb 1d                	jmp    80045b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800440:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800444:	eb 15                	jmp    80045b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800448:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80044c:	eb 0d                	jmp    80045b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80044e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800451:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800454:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80045e:	0f b6 0e             	movzbl (%esi),%ecx
  800461:	0f b6 c1             	movzbl %cl,%eax
  800464:	83 e9 23             	sub    $0x23,%ecx
  800467:	80 f9 55             	cmp    $0x55,%cl
  80046a:	0f 87 2a 03 00 00    	ja     80079a <vprintfmt+0x3ac>
  800470:	0f b6 c9             	movzbl %cl,%ecx
  800473:	ff 24 8d c0 29 80 00 	jmp    *0x8029c0(,%ecx,4)
  80047a:	89 de                	mov    %ebx,%esi
  80047c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800481:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800484:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800488:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80048b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80048e:	83 fb 09             	cmp    $0x9,%ebx
  800491:	77 36                	ja     8004c9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800493:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800496:	eb e9                	jmp    800481 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800498:	8b 45 14             	mov    0x14(%ebp),%eax
  80049b:	8d 48 04             	lea    0x4(%eax),%ecx
  80049e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004a8:	eb 22                	jmp    8004cc <vprintfmt+0xde>
  8004aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ad:	85 c9                	test   %ecx,%ecx
  8004af:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b4:	0f 49 c1             	cmovns %ecx,%eax
  8004b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	89 de                	mov    %ebx,%esi
  8004bc:	eb 9d                	jmp    80045b <vprintfmt+0x6d>
  8004be:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004c0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004c7:	eb 92                	jmp    80045b <vprintfmt+0x6d>
  8004c9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d0:	79 89                	jns    80045b <vprintfmt+0x6d>
  8004d2:	e9 77 ff ff ff       	jmp    80044e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004d7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004dc:	e9 7a ff ff ff       	jmp    80045b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8d 50 04             	lea    0x4(%eax),%edx
  8004e7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	89 04 24             	mov    %eax,(%esp)
  8004f3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004f6:	e9 18 ff ff ff       	jmp    800413 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8d 50 04             	lea    0x4(%eax),%edx
  800501:	89 55 14             	mov    %edx,0x14(%ebp)
  800504:	8b 00                	mov    (%eax),%eax
  800506:	99                   	cltd   
  800507:	31 d0                	xor    %edx,%eax
  800509:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050b:	83 f8 12             	cmp    $0x12,%eax
  80050e:	7f 0b                	jg     80051b <vprintfmt+0x12d>
  800510:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  800517:	85 d2                	test   %edx,%edx
  800519:	75 20                	jne    80053b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80051b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80051f:	c7 44 24 08 63 28 80 	movl   $0x802863,0x8(%esp)
  800526:	00 
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	e8 90 fe ff ff       	call   8003c6 <printfmt>
  800536:	e9 d8 fe ff ff       	jmp    800413 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80053b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80053f:	c7 44 24 08 61 2c 80 	movl   $0x802c61,0x8(%esp)
  800546:	00 
  800547:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054b:	8b 45 08             	mov    0x8(%ebp),%eax
  80054e:	89 04 24             	mov    %eax,(%esp)
  800551:	e8 70 fe ff ff       	call   8003c6 <printfmt>
  800556:	e9 b8 fe ff ff       	jmp    800413 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80055e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800561:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8d 50 04             	lea    0x4(%eax),%edx
  80056a:	89 55 14             	mov    %edx,0x14(%ebp)
  80056d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80056f:	85 f6                	test   %esi,%esi
  800571:	b8 5c 28 80 00       	mov    $0x80285c,%eax
  800576:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800579:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80057d:	0f 84 97 00 00 00    	je     80061a <vprintfmt+0x22c>
  800583:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800587:	0f 8e 9b 00 00 00    	jle    800628 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800591:	89 34 24             	mov    %esi,(%esp)
  800594:	e8 cf 02 00 00       	call   800868 <strnlen>
  800599:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80059c:	29 c2                	sub    %eax,%edx
  80059e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005b1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b3:	eb 0f                	jmp    8005c4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005bc:	89 04 24             	mov    %eax,(%esp)
  8005bf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	83 eb 01             	sub    $0x1,%ebx
  8005c4:	85 db                	test   %ebx,%ebx
  8005c6:	7f ed                	jg     8005b5 <vprintfmt+0x1c7>
  8005c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ce:	85 d2                	test   %edx,%edx
  8005d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d5:	0f 49 c2             	cmovns %edx,%eax
  8005d8:	29 c2                	sub    %eax,%edx
  8005da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005dd:	89 d7                	mov    %edx,%edi
  8005df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005e2:	eb 50                	jmp    800634 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e8:	74 1e                	je     800608 <vprintfmt+0x21a>
  8005ea:	0f be d2             	movsbl %dl,%edx
  8005ed:	83 ea 20             	sub    $0x20,%edx
  8005f0:	83 fa 5e             	cmp    $0x5e,%edx
  8005f3:	76 13                	jbe    800608 <vprintfmt+0x21a>
					putch('?', putdat);
  8005f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800603:	ff 55 08             	call   *0x8(%ebp)
  800606:	eb 0d                	jmp    800615 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80060f:	89 04 24             	mov    %eax,(%esp)
  800612:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800615:	83 ef 01             	sub    $0x1,%edi
  800618:	eb 1a                	jmp    800634 <vprintfmt+0x246>
  80061a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800620:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800623:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800626:	eb 0c                	jmp    800634 <vprintfmt+0x246>
  800628:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80062e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800631:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800634:	83 c6 01             	add    $0x1,%esi
  800637:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80063b:	0f be c2             	movsbl %dl,%eax
  80063e:	85 c0                	test   %eax,%eax
  800640:	74 27                	je     800669 <vprintfmt+0x27b>
  800642:	85 db                	test   %ebx,%ebx
  800644:	78 9e                	js     8005e4 <vprintfmt+0x1f6>
  800646:	83 eb 01             	sub    $0x1,%ebx
  800649:	79 99                	jns    8005e4 <vprintfmt+0x1f6>
  80064b:	89 f8                	mov    %edi,%eax
  80064d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800650:	8b 75 08             	mov    0x8(%ebp),%esi
  800653:	89 c3                	mov    %eax,%ebx
  800655:	eb 1a                	jmp    800671 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800657:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80065b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800662:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800664:	83 eb 01             	sub    $0x1,%ebx
  800667:	eb 08                	jmp    800671 <vprintfmt+0x283>
  800669:	89 fb                	mov    %edi,%ebx
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800671:	85 db                	test   %ebx,%ebx
  800673:	7f e2                	jg     800657 <vprintfmt+0x269>
  800675:	89 75 08             	mov    %esi,0x8(%ebp)
  800678:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80067b:	e9 93 fd ff ff       	jmp    800413 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800680:	83 fa 01             	cmp    $0x1,%edx
  800683:	7e 16                	jle    80069b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	89 55 14             	mov    %edx,0x14(%ebp)
  80068e:	8b 50 04             	mov    0x4(%eax),%edx
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800696:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800699:	eb 32                	jmp    8006cd <vprintfmt+0x2df>
	else if (lflag)
  80069b:	85 d2                	test   %edx,%edx
  80069d:	74 18                	je     8006b7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 50 04             	lea    0x4(%eax),%edx
  8006a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a8:	8b 30                	mov    (%eax),%esi
  8006aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006ad:	89 f0                	mov    %esi,%eax
  8006af:	c1 f8 1f             	sar    $0x1f,%eax
  8006b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b5:	eb 16                	jmp    8006cd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c0:	8b 30                	mov    (%eax),%esi
  8006c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006c5:	89 f0                	mov    %esi,%eax
  8006c7:	c1 f8 1f             	sar    $0x1f,%eax
  8006ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006dc:	0f 89 80 00 00 00    	jns    800762 <vprintfmt+0x374>
				putch('-', putdat);
  8006e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006ed:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f6:	f7 d8                	neg    %eax
  8006f8:	83 d2 00             	adc    $0x0,%edx
  8006fb:	f7 da                	neg    %edx
			}
			base = 10;
  8006fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800702:	eb 5e                	jmp    800762 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800704:	8d 45 14             	lea    0x14(%ebp),%eax
  800707:	e8 63 fc ff ff       	call   80036f <getuint>
			base = 10;
  80070c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800711:	eb 4f                	jmp    800762 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800713:	8d 45 14             	lea    0x14(%ebp),%eax
  800716:	e8 54 fc ff ff       	call   80036f <getuint>
			base = 8;
  80071b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800720:	eb 40                	jmp    800762 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800722:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800726:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80072d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800730:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800734:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80073b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 50 04             	lea    0x4(%eax),%edx
  800744:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800747:	8b 00                	mov    (%eax),%eax
  800749:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80074e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800753:	eb 0d                	jmp    800762 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800755:	8d 45 14             	lea    0x14(%ebp),%eax
  800758:	e8 12 fc ff ff       	call   80036f <getuint>
			base = 16;
  80075d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800762:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800766:	89 74 24 10          	mov    %esi,0x10(%esp)
  80076a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80076d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800771:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800775:	89 04 24             	mov    %eax,(%esp)
  800778:	89 54 24 04          	mov    %edx,0x4(%esp)
  80077c:	89 fa                	mov    %edi,%edx
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	e8 fa fa ff ff       	call   800280 <printnum>
			break;
  800786:	e9 88 fc ff ff       	jmp    800413 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80078b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078f:	89 04 24             	mov    %eax,(%esp)
  800792:	ff 55 08             	call   *0x8(%ebp)
			break;
  800795:	e9 79 fc ff ff       	jmp    800413 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80079a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007a5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007a8:	89 f3                	mov    %esi,%ebx
  8007aa:	eb 03                	jmp    8007af <vprintfmt+0x3c1>
  8007ac:	83 eb 01             	sub    $0x1,%ebx
  8007af:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007b3:	75 f7                	jne    8007ac <vprintfmt+0x3be>
  8007b5:	e9 59 fc ff ff       	jmp    800413 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007ba:	83 c4 3c             	add    $0x3c,%esp
  8007bd:	5b                   	pop    %ebx
  8007be:	5e                   	pop    %esi
  8007bf:	5f                   	pop    %edi
  8007c0:	5d                   	pop    %ebp
  8007c1:	c3                   	ret    

008007c2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	83 ec 28             	sub    $0x28,%esp
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	74 30                	je     800813 <vsnprintf+0x51>
  8007e3:	85 d2                	test   %edx,%edx
  8007e5:	7e 2c                	jle    800813 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007fc:	c7 04 24 a9 03 80 00 	movl   $0x8003a9,(%esp)
  800803:	e8 e6 fb ff ff       	call   8003ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80080e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800811:	eb 05                	jmp    800818 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800818:	c9                   	leave  
  800819:	c3                   	ret    

0080081a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800820:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800823:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800827:	8b 45 10             	mov    0x10(%ebp),%eax
  80082a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80082e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800831:	89 44 24 04          	mov    %eax,0x4(%esp)
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	89 04 24             	mov    %eax,(%esp)
  80083b:	e8 82 ff ff ff       	call   8007c2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800840:	c9                   	leave  
  800841:	c3                   	ret    
  800842:	66 90                	xchg   %ax,%ax
  800844:	66 90                	xchg   %ax,%ax
  800846:	66 90                	xchg   %ax,%ax
  800848:	66 90                	xchg   %ax,%ax
  80084a:	66 90                	xchg   %ax,%ax
  80084c:	66 90                	xchg   %ax,%ax
  80084e:	66 90                	xchg   %ax,%ax

00800850 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
  80085b:	eb 03                	jmp    800860 <strlen+0x10>
		n++;
  80085d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800860:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800864:	75 f7                	jne    80085d <strlen+0xd>
		n++;
	return n;
}
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
  800876:	eb 03                	jmp    80087b <strnlen+0x13>
		n++;
  800878:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087b:	39 d0                	cmp    %edx,%eax
  80087d:	74 06                	je     800885 <strnlen+0x1d>
  80087f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800883:	75 f3                	jne    800878 <strnlen+0x10>
		n++;
	return n;
}
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	53                   	push   %ebx
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800891:	89 c2                	mov    %eax,%edx
  800893:	83 c2 01             	add    $0x1,%edx
  800896:	83 c1 01             	add    $0x1,%ecx
  800899:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80089d:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a0:	84 db                	test   %bl,%bl
  8008a2:	75 ef                	jne    800893 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a4:	5b                   	pop    %ebx
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	53                   	push   %ebx
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b1:	89 1c 24             	mov    %ebx,(%esp)
  8008b4:	e8 97 ff ff ff       	call   800850 <strlen>
	strcpy(dst + len, src);
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008c0:	01 d8                	add    %ebx,%eax
  8008c2:	89 04 24             	mov    %eax,(%esp)
  8008c5:	e8 bd ff ff ff       	call   800887 <strcpy>
	return dst;
}
  8008ca:	89 d8                	mov    %ebx,%eax
  8008cc:	83 c4 08             	add    $0x8,%esp
  8008cf:	5b                   	pop    %ebx
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	56                   	push   %esi
  8008d6:	53                   	push   %ebx
  8008d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008dd:	89 f3                	mov    %esi,%ebx
  8008df:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e2:	89 f2                	mov    %esi,%edx
  8008e4:	eb 0f                	jmp    8008f5 <strncpy+0x23>
		*dst++ = *src;
  8008e6:	83 c2 01             	add    $0x1,%edx
  8008e9:	0f b6 01             	movzbl (%ecx),%eax
  8008ec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ef:	80 39 01             	cmpb   $0x1,(%ecx)
  8008f2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f5:	39 da                	cmp    %ebx,%edx
  8008f7:	75 ed                	jne    8008e6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008f9:	89 f0                	mov    %esi,%eax
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	56                   	push   %esi
  800903:	53                   	push   %ebx
  800904:	8b 75 08             	mov    0x8(%ebp),%esi
  800907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80090d:	89 f0                	mov    %esi,%eax
  80090f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800913:	85 c9                	test   %ecx,%ecx
  800915:	75 0b                	jne    800922 <strlcpy+0x23>
  800917:	eb 1d                	jmp    800936 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800919:	83 c0 01             	add    $0x1,%eax
  80091c:	83 c2 01             	add    $0x1,%edx
  80091f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800922:	39 d8                	cmp    %ebx,%eax
  800924:	74 0b                	je     800931 <strlcpy+0x32>
  800926:	0f b6 0a             	movzbl (%edx),%ecx
  800929:	84 c9                	test   %cl,%cl
  80092b:	75 ec                	jne    800919 <strlcpy+0x1a>
  80092d:	89 c2                	mov    %eax,%edx
  80092f:	eb 02                	jmp    800933 <strlcpy+0x34>
  800931:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800933:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800936:	29 f0                	sub    %esi,%eax
}
  800938:	5b                   	pop    %ebx
  800939:	5e                   	pop    %esi
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800945:	eb 06                	jmp    80094d <strcmp+0x11>
		p++, q++;
  800947:	83 c1 01             	add    $0x1,%ecx
  80094a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80094d:	0f b6 01             	movzbl (%ecx),%eax
  800950:	84 c0                	test   %al,%al
  800952:	74 04                	je     800958 <strcmp+0x1c>
  800954:	3a 02                	cmp    (%edx),%al
  800956:	74 ef                	je     800947 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800958:	0f b6 c0             	movzbl %al,%eax
  80095b:	0f b6 12             	movzbl (%edx),%edx
  80095e:	29 d0                	sub    %edx,%eax
}
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	53                   	push   %ebx
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096c:	89 c3                	mov    %eax,%ebx
  80096e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800971:	eb 06                	jmp    800979 <strncmp+0x17>
		n--, p++, q++;
  800973:	83 c0 01             	add    $0x1,%eax
  800976:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800979:	39 d8                	cmp    %ebx,%eax
  80097b:	74 15                	je     800992 <strncmp+0x30>
  80097d:	0f b6 08             	movzbl (%eax),%ecx
  800980:	84 c9                	test   %cl,%cl
  800982:	74 04                	je     800988 <strncmp+0x26>
  800984:	3a 0a                	cmp    (%edx),%cl
  800986:	74 eb                	je     800973 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800988:	0f b6 00             	movzbl (%eax),%eax
  80098b:	0f b6 12             	movzbl (%edx),%edx
  80098e:	29 d0                	sub    %edx,%eax
  800990:	eb 05                	jmp    800997 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800992:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800997:	5b                   	pop    %ebx
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a4:	eb 07                	jmp    8009ad <strchr+0x13>
		if (*s == c)
  8009a6:	38 ca                	cmp    %cl,%dl
  8009a8:	74 0f                	je     8009b9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	0f b6 10             	movzbl (%eax),%edx
  8009b0:	84 d2                	test   %dl,%dl
  8009b2:	75 f2                	jne    8009a6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c5:	eb 07                	jmp    8009ce <strfind+0x13>
		if (*s == c)
  8009c7:	38 ca                	cmp    %cl,%dl
  8009c9:	74 0a                	je     8009d5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009cb:	83 c0 01             	add    $0x1,%eax
  8009ce:	0f b6 10             	movzbl (%eax),%edx
  8009d1:	84 d2                	test   %dl,%dl
  8009d3:	75 f2                	jne    8009c7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	57                   	push   %edi
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009e3:	85 c9                	test   %ecx,%ecx
  8009e5:	74 36                	je     800a1d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009e7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ed:	75 28                	jne    800a17 <memset+0x40>
  8009ef:	f6 c1 03             	test   $0x3,%cl
  8009f2:	75 23                	jne    800a17 <memset+0x40>
		c &= 0xFF;
  8009f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f8:	89 d3                	mov    %edx,%ebx
  8009fa:	c1 e3 08             	shl    $0x8,%ebx
  8009fd:	89 d6                	mov    %edx,%esi
  8009ff:	c1 e6 18             	shl    $0x18,%esi
  800a02:	89 d0                	mov    %edx,%eax
  800a04:	c1 e0 10             	shl    $0x10,%eax
  800a07:	09 f0                	or     %esi,%eax
  800a09:	09 c2                	or     %eax,%edx
  800a0b:	89 d0                	mov    %edx,%eax
  800a0d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a0f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a12:	fc                   	cld    
  800a13:	f3 ab                	rep stos %eax,%es:(%edi)
  800a15:	eb 06                	jmp    800a1d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1a:	fc                   	cld    
  800a1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a1d:	89 f8                	mov    %edi,%eax
  800a1f:	5b                   	pop    %ebx
  800a20:	5e                   	pop    %esi
  800a21:	5f                   	pop    %edi
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	57                   	push   %edi
  800a28:	56                   	push   %esi
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a32:	39 c6                	cmp    %eax,%esi
  800a34:	73 35                	jae    800a6b <memmove+0x47>
  800a36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a39:	39 d0                	cmp    %edx,%eax
  800a3b:	73 2e                	jae    800a6b <memmove+0x47>
		s += n;
		d += n;
  800a3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a40:	89 d6                	mov    %edx,%esi
  800a42:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4a:	75 13                	jne    800a5f <memmove+0x3b>
  800a4c:	f6 c1 03             	test   $0x3,%cl
  800a4f:	75 0e                	jne    800a5f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a51:	83 ef 04             	sub    $0x4,%edi
  800a54:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a57:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a5a:	fd                   	std    
  800a5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5d:	eb 09                	jmp    800a68 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a5f:	83 ef 01             	sub    $0x1,%edi
  800a62:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a65:	fd                   	std    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a68:	fc                   	cld    
  800a69:	eb 1d                	jmp    800a88 <memmove+0x64>
  800a6b:	89 f2                	mov    %esi,%edx
  800a6d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6f:	f6 c2 03             	test   $0x3,%dl
  800a72:	75 0f                	jne    800a83 <memmove+0x5f>
  800a74:	f6 c1 03             	test   $0x3,%cl
  800a77:	75 0a                	jne    800a83 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a79:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a7c:	89 c7                	mov    %eax,%edi
  800a7e:	fc                   	cld    
  800a7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a81:	eb 05                	jmp    800a88 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a83:	89 c7                	mov    %eax,%edi
  800a85:	fc                   	cld    
  800a86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a88:	5e                   	pop    %esi
  800a89:	5f                   	pop    %edi
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a92:	8b 45 10             	mov    0x10(%ebp),%eax
  800a95:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	89 04 24             	mov    %eax,(%esp)
  800aa6:	e8 79 ff ff ff       	call   800a24 <memmove>
}
  800aab:	c9                   	leave  
  800aac:	c3                   	ret    

00800aad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	56                   	push   %esi
  800ab1:	53                   	push   %ebx
  800ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab8:	89 d6                	mov    %edx,%esi
  800aba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abd:	eb 1a                	jmp    800ad9 <memcmp+0x2c>
		if (*s1 != *s2)
  800abf:	0f b6 02             	movzbl (%edx),%eax
  800ac2:	0f b6 19             	movzbl (%ecx),%ebx
  800ac5:	38 d8                	cmp    %bl,%al
  800ac7:	74 0a                	je     800ad3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ac9:	0f b6 c0             	movzbl %al,%eax
  800acc:	0f b6 db             	movzbl %bl,%ebx
  800acf:	29 d8                	sub    %ebx,%eax
  800ad1:	eb 0f                	jmp    800ae2 <memcmp+0x35>
		s1++, s2++;
  800ad3:	83 c2 01             	add    $0x1,%edx
  800ad6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad9:	39 f2                	cmp    %esi,%edx
  800adb:	75 e2                	jne    800abf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae2:	5b                   	pop    %ebx
  800ae3:	5e                   	pop    %esi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aef:	89 c2                	mov    %eax,%edx
  800af1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af4:	eb 07                	jmp    800afd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af6:	38 08                	cmp    %cl,(%eax)
  800af8:	74 07                	je     800b01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	39 d0                	cmp    %edx,%eax
  800aff:	72 f5                	jb     800af6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	57                   	push   %edi
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0f:	eb 03                	jmp    800b14 <strtol+0x11>
		s++;
  800b11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b14:	0f b6 0a             	movzbl (%edx),%ecx
  800b17:	80 f9 09             	cmp    $0x9,%cl
  800b1a:	74 f5                	je     800b11 <strtol+0xe>
  800b1c:	80 f9 20             	cmp    $0x20,%cl
  800b1f:	74 f0                	je     800b11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b21:	80 f9 2b             	cmp    $0x2b,%cl
  800b24:	75 0a                	jne    800b30 <strtol+0x2d>
		s++;
  800b26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b29:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2e:	eb 11                	jmp    800b41 <strtol+0x3e>
  800b30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b35:	80 f9 2d             	cmp    $0x2d,%cl
  800b38:	75 07                	jne    800b41 <strtol+0x3e>
		s++, neg = 1;
  800b3a:	8d 52 01             	lea    0x1(%edx),%edx
  800b3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b46:	75 15                	jne    800b5d <strtol+0x5a>
  800b48:	80 3a 30             	cmpb   $0x30,(%edx)
  800b4b:	75 10                	jne    800b5d <strtol+0x5a>
  800b4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b51:	75 0a                	jne    800b5d <strtol+0x5a>
		s += 2, base = 16;
  800b53:	83 c2 02             	add    $0x2,%edx
  800b56:	b8 10 00 00 00       	mov    $0x10,%eax
  800b5b:	eb 10                	jmp    800b6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b5d:	85 c0                	test   %eax,%eax
  800b5f:	75 0c                	jne    800b6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b63:	80 3a 30             	cmpb   $0x30,(%edx)
  800b66:	75 05                	jne    800b6d <strtol+0x6a>
		s++, base = 8;
  800b68:	83 c2 01             	add    $0x1,%edx
  800b6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b75:	0f b6 0a             	movzbl (%edx),%ecx
  800b78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b7b:	89 f0                	mov    %esi,%eax
  800b7d:	3c 09                	cmp    $0x9,%al
  800b7f:	77 08                	ja     800b89 <strtol+0x86>
			dig = *s - '0';
  800b81:	0f be c9             	movsbl %cl,%ecx
  800b84:	83 e9 30             	sub    $0x30,%ecx
  800b87:	eb 20                	jmp    800ba9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b8c:	89 f0                	mov    %esi,%eax
  800b8e:	3c 19                	cmp    $0x19,%al
  800b90:	77 08                	ja     800b9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b92:	0f be c9             	movsbl %cl,%ecx
  800b95:	83 e9 57             	sub    $0x57,%ecx
  800b98:	eb 0f                	jmp    800ba9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b9d:	89 f0                	mov    %esi,%eax
  800b9f:	3c 19                	cmp    $0x19,%al
  800ba1:	77 16                	ja     800bb9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ba3:	0f be c9             	movsbl %cl,%ecx
  800ba6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ba9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bac:	7d 0f                	jge    800bbd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bae:	83 c2 01             	add    $0x1,%edx
  800bb1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bb5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bb7:	eb bc                	jmp    800b75 <strtol+0x72>
  800bb9:	89 d8                	mov    %ebx,%eax
  800bbb:	eb 02                	jmp    800bbf <strtol+0xbc>
  800bbd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc3:	74 05                	je     800bca <strtol+0xc7>
		*endptr = (char *) s;
  800bc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bca:	f7 d8                	neg    %eax
  800bcc:	85 ff                	test   %edi,%edi
  800bce:	0f 44 c3             	cmove  %ebx,%eax
}
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	57                   	push   %edi
  800bda:	56                   	push   %esi
  800bdb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be4:	8b 55 08             	mov    0x8(%ebp),%edx
  800be7:	89 c3                	mov    %eax,%ebx
  800be9:	89 c7                	mov    %eax,%edi
  800beb:	89 c6                	mov    %eax,%esi
  800bed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <sys_cgetc>:

int
sys_cgetc(void)
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
  800bff:	b8 01 00 00 00       	mov    $0x1,%eax
  800c04:	89 d1                	mov    %edx,%ecx
  800c06:	89 d3                	mov    %edx,%ebx
  800c08:	89 d7                	mov    %edx,%edi
  800c0a:	89 d6                	mov    %edx,%esi
  800c0c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800c1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c21:	b8 03 00 00 00       	mov    $0x3,%eax
  800c26:	8b 55 08             	mov    0x8(%ebp),%edx
  800c29:	89 cb                	mov    %ecx,%ebx
  800c2b:	89 cf                	mov    %ecx,%edi
  800c2d:	89 ce                	mov    %ecx,%esi
  800c2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c31:	85 c0                	test   %eax,%eax
  800c33:	7e 28                	jle    800c5d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c39:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c40:	00 
  800c41:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800c48:	00 
  800c49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c50:	00 
  800c51:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800c58:	e8 06 f5 ff ff       	call   800163 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c5d:	83 c4 2c             	add    $0x2c,%esp
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	57                   	push   %edi
  800c69:	56                   	push   %esi
  800c6a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c70:	b8 02 00 00 00       	mov    $0x2,%eax
  800c75:	89 d1                	mov    %edx,%ecx
  800c77:	89 d3                	mov    %edx,%ebx
  800c79:	89 d7                	mov    %edx,%edi
  800c7b:	89 d6                	mov    %edx,%esi
  800c7d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <sys_yield>:

void
sys_yield(void)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	57                   	push   %edi
  800c88:	56                   	push   %esi
  800c89:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c94:	89 d1                	mov    %edx,%ecx
  800c96:	89 d3                	mov    %edx,%ebx
  800c98:	89 d7                	mov    %edx,%edi
  800c9a:	89 d6                	mov    %edx,%esi
  800c9c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cac:	be 00 00 00 00       	mov    $0x0,%esi
  800cb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cbf:	89 f7                	mov    %esi,%edi
  800cc1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	7e 28                	jle    800cef <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cd2:	00 
  800cd3:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800cda:	00 
  800cdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce2:	00 
  800ce3:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800cea:	e8 74 f4 ff ff       	call   800163 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cef:	83 c4 2c             	add    $0x2c,%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d00:	b8 05 00 00 00       	mov    $0x5,%eax
  800d05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d08:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d11:	8b 75 18             	mov    0x18(%ebp),%esi
  800d14:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d16:	85 c0                	test   %eax,%eax
  800d18:	7e 28                	jle    800d42 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d25:	00 
  800d26:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800d2d:	00 
  800d2e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d35:	00 
  800d36:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800d3d:	e8 21 f4 ff ff       	call   800163 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d42:	83 c4 2c             	add    $0x2c,%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
  800d50:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d58:	b8 06 00 00 00       	mov    $0x6,%eax
  800d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	89 df                	mov    %ebx,%edi
  800d65:	89 de                	mov    %ebx,%esi
  800d67:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7e 28                	jle    800d95 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d71:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d78:	00 
  800d79:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800d80:	00 
  800d81:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d88:	00 
  800d89:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800d90:	e8 ce f3 ff ff       	call   800163 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d95:	83 c4 2c             	add    $0x2c,%esp
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	b8 08 00 00 00       	mov    $0x8,%eax
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	89 de                	mov    %ebx,%esi
  800dba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	7e 28                	jle    800de8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dcb:	00 
  800dcc:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800dd3:	00 
  800dd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ddb:	00 
  800ddc:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800de3:	e8 7b f3 ff ff       	call   800163 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de8:	83 c4 2c             	add    $0x2c,%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfe:	b8 09 00 00 00       	mov    $0x9,%eax
  800e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	89 de                	mov    %ebx,%esi
  800e0d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	7e 28                	jle    800e3b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e13:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e17:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e1e:	00 
  800e1f:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800e26:	00 
  800e27:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2e:	00 
  800e2f:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800e36:	e8 28 f3 ff ff       	call   800163 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e3b:	83 c4 2c             	add    $0x2c,%esp
  800e3e:	5b                   	pop    %ebx
  800e3f:	5e                   	pop    %esi
  800e40:	5f                   	pop    %edi
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 df                	mov    %ebx,%edi
  800e5e:	89 de                	mov    %ebx,%esi
  800e60:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7e 28                	jle    800e8e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e71:	00 
  800e72:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800e79:	00 
  800e7a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e81:	00 
  800e82:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800e89:	e8 d5 f2 ff ff       	call   800163 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e8e:	83 c4 2c             	add    $0x2c,%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ea1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	89 cb                	mov    %ecx,%ebx
  800ed1:	89 cf                	mov    %ecx,%edi
  800ed3:	89 ce                	mov    %ecx,%esi
  800ed5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	7e 28                	jle    800f03 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800edf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ee6:	00 
  800ee7:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800eee:	00 
  800eef:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef6:	00 
  800ef7:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800efe:	e8 60 f2 ff ff       	call   800163 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f03:	83 c4 2c             	add    $0x2c,%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f11:	ba 00 00 00 00       	mov    $0x0,%edx
  800f16:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f1b:	89 d1                	mov    %edx,%ecx
  800f1d:	89 d3                	mov    %edx,%ebx
  800f1f:	89 d7                	mov    %edx,%edi
  800f21:	89 d6                	mov    %edx,%esi
  800f23:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f25:	5b                   	pop    %ebx
  800f26:	5e                   	pop    %esi
  800f27:	5f                   	pop    %edi
  800f28:	5d                   	pop    %ebp
  800f29:	c3                   	ret    

00800f2a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f38:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	89 df                	mov    %ebx,%edi
  800f45:	89 de                	mov    %ebx,%esi
  800f47:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	7e 28                	jle    800f75 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f51:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f58:	00 
  800f59:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800f60:	00 
  800f61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f68:	00 
  800f69:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800f70:	e8 ee f1 ff ff       	call   800163 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800f75:	83 c4 2c             	add    $0x2c,%esp
  800f78:	5b                   	pop    %ebx
  800f79:	5e                   	pop    %esi
  800f7a:	5f                   	pop    %edi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
  800f83:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	89 df                	mov    %ebx,%edi
  800f98:	89 de                	mov    %ebx,%esi
  800f9a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	7e 28                	jle    800fc8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800fab:	00 
  800fac:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  800fb3:	00 
  800fb4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fbb:	00 
  800fbc:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800fc3:	e8 9b f1 ff ff       	call   800163 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800fc8:	83 c4 2c             	add    $0x2c,%esp
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	57                   	push   %edi
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
  800fd6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fde:	b8 11 00 00 00       	mov    $0x11,%eax
  800fe3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	89 df                	mov    %ebx,%edi
  800feb:	89 de                	mov    %ebx,%esi
  800fed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	7e 28                	jle    80101b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800ffe:	00 
  800fff:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  801006:	00 
  801007:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100e:	00 
  80100f:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  801016:	e8 48 f1 ff ff       	call   800163 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80101b:	83 c4 2c             	add    $0x2c,%esp
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <sys_sleep>:

int
sys_sleep(int channel)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
  801029:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801031:	b8 12 00 00 00       	mov    $0x12,%eax
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 cb                	mov    %ecx,%ebx
  80103b:	89 cf                	mov    %ecx,%edi
  80103d:	89 ce                	mov    %ecx,%esi
  80103f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801041:	85 c0                	test   %eax,%eax
  801043:	7e 28                	jle    80106d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801045:	89 44 24 10          	mov    %eax,0x10(%esp)
  801049:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801050:	00 
  801051:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  801058:	00 
  801059:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801060:	00 
  801061:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  801068:	e8 f6 f0 ff ff       	call   800163 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80106d:	83 c4 2c             	add    $0x2c,%esp
  801070:	5b                   	pop    %ebx
  801071:	5e                   	pop    %esi
  801072:	5f                   	pop    %edi
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    

00801075 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	57                   	push   %edi
  801079:	56                   	push   %esi
  80107a:	53                   	push   %ebx
  80107b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801083:	b8 13 00 00 00       	mov    $0x13,%eax
  801088:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108b:	8b 55 08             	mov    0x8(%ebp),%edx
  80108e:	89 df                	mov    %ebx,%edi
  801090:	89 de                	mov    %ebx,%esi
  801092:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801094:	85 c0                	test   %eax,%eax
  801096:	7e 28                	jle    8010c0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801098:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8010a3:	00 
  8010a4:	c7 44 24 08 8b 2b 80 	movl   $0x802b8b,0x8(%esp)
  8010ab:	00 
  8010ac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b3:	00 
  8010b4:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  8010bb:	e8 a3 f0 ff ff       	call   800163 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8010c0:	83 c4 2c             	add    $0x2c,%esp
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5f                   	pop    %edi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    
  8010c8:	66 90                	xchg   %ax,%ax
  8010ca:	66 90                	xchg   %ax,%ax
  8010cc:	66 90                	xchg   %ax,%ax
  8010ce:	66 90                	xchg   %ax,%ax

008010d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010db:	c1 e8 0c             	shr    $0xc,%eax
}
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    

008010f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801102:	89 c2                	mov    %eax,%edx
  801104:	c1 ea 16             	shr    $0x16,%edx
  801107:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80110e:	f6 c2 01             	test   $0x1,%dl
  801111:	74 11                	je     801124 <fd_alloc+0x2d>
  801113:	89 c2                	mov    %eax,%edx
  801115:	c1 ea 0c             	shr    $0xc,%edx
  801118:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80111f:	f6 c2 01             	test   $0x1,%dl
  801122:	75 09                	jne    80112d <fd_alloc+0x36>
			*fd_store = fd;
  801124:	89 01                	mov    %eax,(%ecx)
			return 0;
  801126:	b8 00 00 00 00       	mov    $0x0,%eax
  80112b:	eb 17                	jmp    801144 <fd_alloc+0x4d>
  80112d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801132:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801137:	75 c9                	jne    801102 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801139:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80113f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80114c:	83 f8 1f             	cmp    $0x1f,%eax
  80114f:	77 36                	ja     801187 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801151:	c1 e0 0c             	shl    $0xc,%eax
  801154:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801159:	89 c2                	mov    %eax,%edx
  80115b:	c1 ea 16             	shr    $0x16,%edx
  80115e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801165:	f6 c2 01             	test   $0x1,%dl
  801168:	74 24                	je     80118e <fd_lookup+0x48>
  80116a:	89 c2                	mov    %eax,%edx
  80116c:	c1 ea 0c             	shr    $0xc,%edx
  80116f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801176:	f6 c2 01             	test   $0x1,%dl
  801179:	74 1a                	je     801195 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117e:	89 02                	mov    %eax,(%edx)
	return 0;
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
  801185:	eb 13                	jmp    80119a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801187:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118c:	eb 0c                	jmp    80119a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80118e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801193:	eb 05                	jmp    80119a <fd_lookup+0x54>
  801195:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 18             	sub    $0x18,%esp
  8011a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011aa:	eb 13                	jmp    8011bf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8011ac:	39 08                	cmp    %ecx,(%eax)
  8011ae:	75 0c                	jne    8011bc <dev_lookup+0x20>
			*dev = devtab[i];
  8011b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ba:	eb 38                	jmp    8011f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011bc:	83 c2 01             	add    $0x1,%edx
  8011bf:	8b 04 95 34 2c 80 00 	mov    0x802c34(,%edx,4),%eax
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	75 e2                	jne    8011ac <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ca:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8011cf:	8b 40 48             	mov    0x48(%eax),%eax
  8011d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011da:	c7 04 24 b8 2b 80 00 	movl   $0x802bb8,(%esp)
  8011e1:	e8 76 f0 ff ff       	call   80025c <cprintf>
	*dev = 0;
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	56                   	push   %esi
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 20             	sub    $0x20,%esp
  8011fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801201:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801204:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801207:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80120b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801211:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801214:	89 04 24             	mov    %eax,(%esp)
  801217:	e8 2a ff ff ff       	call   801146 <fd_lookup>
  80121c:	85 c0                	test   %eax,%eax
  80121e:	78 05                	js     801225 <fd_close+0x2f>
	    || fd != fd2)
  801220:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801223:	74 0c                	je     801231 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801225:	84 db                	test   %bl,%bl
  801227:	ba 00 00 00 00       	mov    $0x0,%edx
  80122c:	0f 44 c2             	cmove  %edx,%eax
  80122f:	eb 3f                	jmp    801270 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801231:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801234:	89 44 24 04          	mov    %eax,0x4(%esp)
  801238:	8b 06                	mov    (%esi),%eax
  80123a:	89 04 24             	mov    %eax,(%esp)
  80123d:	e8 5a ff ff ff       	call   80119c <dev_lookup>
  801242:	89 c3                	mov    %eax,%ebx
  801244:	85 c0                	test   %eax,%eax
  801246:	78 16                	js     80125e <fd_close+0x68>
		if (dev->dev_close)
  801248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80124e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801253:	85 c0                	test   %eax,%eax
  801255:	74 07                	je     80125e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801257:	89 34 24             	mov    %esi,(%esp)
  80125a:	ff d0                	call   *%eax
  80125c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80125e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801262:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801269:	e8 dc fa ff ff       	call   800d4a <sys_page_unmap>
	return r;
  80126e:	89 d8                	mov    %ebx,%eax
}
  801270:	83 c4 20             	add    $0x20,%esp
  801273:	5b                   	pop    %ebx
  801274:	5e                   	pop    %esi
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80127d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801280:	89 44 24 04          	mov    %eax,0x4(%esp)
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	89 04 24             	mov    %eax,(%esp)
  80128a:	e8 b7 fe ff ff       	call   801146 <fd_lookup>
  80128f:	89 c2                	mov    %eax,%edx
  801291:	85 d2                	test   %edx,%edx
  801293:	78 13                	js     8012a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801295:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80129c:	00 
  80129d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a0:	89 04 24             	mov    %eax,(%esp)
  8012a3:	e8 4e ff ff ff       	call   8011f6 <fd_close>
}
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <close_all>:

void
close_all(void)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012b6:	89 1c 24             	mov    %ebx,(%esp)
  8012b9:	e8 b9 ff ff ff       	call   801277 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012be:	83 c3 01             	add    $0x1,%ebx
  8012c1:	83 fb 20             	cmp    $0x20,%ebx
  8012c4:	75 f0                	jne    8012b6 <close_all+0xc>
		close(i);
}
  8012c6:	83 c4 14             	add    $0x14,%esp
  8012c9:	5b                   	pop    %ebx
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	89 04 24             	mov    %eax,(%esp)
  8012e2:	e8 5f fe ff ff       	call   801146 <fd_lookup>
  8012e7:	89 c2                	mov    %eax,%edx
  8012e9:	85 d2                	test   %edx,%edx
  8012eb:	0f 88 e1 00 00 00    	js     8013d2 <dup+0x106>
		return r;
	close(newfdnum);
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	89 04 24             	mov    %eax,(%esp)
  8012f7:	e8 7b ff ff ff       	call   801277 <close>

	newfd = INDEX2FD(newfdnum);
  8012fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012ff:	c1 e3 0c             	shl    $0xc,%ebx
  801302:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80130b:	89 04 24             	mov    %eax,(%esp)
  80130e:	e8 cd fd ff ff       	call   8010e0 <fd2data>
  801313:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801315:	89 1c 24             	mov    %ebx,(%esp)
  801318:	e8 c3 fd ff ff       	call   8010e0 <fd2data>
  80131d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80131f:	89 f0                	mov    %esi,%eax
  801321:	c1 e8 16             	shr    $0x16,%eax
  801324:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80132b:	a8 01                	test   $0x1,%al
  80132d:	74 43                	je     801372 <dup+0xa6>
  80132f:	89 f0                	mov    %esi,%eax
  801331:	c1 e8 0c             	shr    $0xc,%eax
  801334:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80133b:	f6 c2 01             	test   $0x1,%dl
  80133e:	74 32                	je     801372 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801340:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801347:	25 07 0e 00 00       	and    $0xe07,%eax
  80134c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801350:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801354:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80135b:	00 
  80135c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801360:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801367:	e8 8b f9 ff ff       	call   800cf7 <sys_page_map>
  80136c:	89 c6                	mov    %eax,%esi
  80136e:	85 c0                	test   %eax,%eax
  801370:	78 3e                	js     8013b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801375:	89 c2                	mov    %eax,%edx
  801377:	c1 ea 0c             	shr    $0xc,%edx
  80137a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801381:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801387:	89 54 24 10          	mov    %edx,0x10(%esp)
  80138b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80138f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801396:	00 
  801397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a2:	e8 50 f9 ff ff       	call   800cf7 <sys_page_map>
  8013a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ac:	85 f6                	test   %esi,%esi
  8013ae:	79 22                	jns    8013d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013bb:	e8 8a f9 ff ff       	call   800d4a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013cb:	e8 7a f9 ff ff       	call   800d4a <sys_page_unmap>
	return r;
  8013d0:	89 f0                	mov    %esi,%eax
}
  8013d2:	83 c4 3c             	add    $0x3c,%esp
  8013d5:	5b                   	pop    %ebx
  8013d6:	5e                   	pop    %esi
  8013d7:	5f                   	pop    %edi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 24             	sub    $0x24,%esp
  8013e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013eb:	89 1c 24             	mov    %ebx,(%esp)
  8013ee:	e8 53 fd ff ff       	call   801146 <fd_lookup>
  8013f3:	89 c2                	mov    %eax,%edx
  8013f5:	85 d2                	test   %edx,%edx
  8013f7:	78 6d                	js     801466 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801403:	8b 00                	mov    (%eax),%eax
  801405:	89 04 24             	mov    %eax,(%esp)
  801408:	e8 8f fd ff ff       	call   80119c <dev_lookup>
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 55                	js     801466 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801414:	8b 50 08             	mov    0x8(%eax),%edx
  801417:	83 e2 03             	and    $0x3,%edx
  80141a:	83 fa 01             	cmp    $0x1,%edx
  80141d:	75 23                	jne    801442 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80141f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801424:	8b 40 48             	mov    0x48(%eax),%eax
  801427:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142f:	c7 04 24 f9 2b 80 00 	movl   $0x802bf9,(%esp)
  801436:	e8 21 ee ff ff       	call   80025c <cprintf>
		return -E_INVAL;
  80143b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801440:	eb 24                	jmp    801466 <read+0x8c>
	}
	if (!dev->dev_read)
  801442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801445:	8b 52 08             	mov    0x8(%edx),%edx
  801448:	85 d2                	test   %edx,%edx
  80144a:	74 15                	je     801461 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80144c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801453:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801456:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80145a:	89 04 24             	mov    %eax,(%esp)
  80145d:	ff d2                	call   *%edx
  80145f:	eb 05                	jmp    801466 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801461:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801466:	83 c4 24             	add    $0x24,%esp
  801469:	5b                   	pop    %ebx
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    

0080146c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	57                   	push   %edi
  801470:	56                   	push   %esi
  801471:	53                   	push   %ebx
  801472:	83 ec 1c             	sub    $0x1c,%esp
  801475:	8b 7d 08             	mov    0x8(%ebp),%edi
  801478:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80147b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801480:	eb 23                	jmp    8014a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801482:	89 f0                	mov    %esi,%eax
  801484:	29 d8                	sub    %ebx,%eax
  801486:	89 44 24 08          	mov    %eax,0x8(%esp)
  80148a:	89 d8                	mov    %ebx,%eax
  80148c:	03 45 0c             	add    0xc(%ebp),%eax
  80148f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801493:	89 3c 24             	mov    %edi,(%esp)
  801496:	e8 3f ff ff ff       	call   8013da <read>
		if (m < 0)
  80149b:	85 c0                	test   %eax,%eax
  80149d:	78 10                	js     8014af <readn+0x43>
			return m;
		if (m == 0)
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 0a                	je     8014ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014a3:	01 c3                	add    %eax,%ebx
  8014a5:	39 f3                	cmp    %esi,%ebx
  8014a7:	72 d9                	jb     801482 <readn+0x16>
  8014a9:	89 d8                	mov    %ebx,%eax
  8014ab:	eb 02                	jmp    8014af <readn+0x43>
  8014ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014af:	83 c4 1c             	add    $0x1c,%esp
  8014b2:	5b                   	pop    %ebx
  8014b3:	5e                   	pop    %esi
  8014b4:	5f                   	pop    %edi
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    

008014b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 24             	sub    $0x24,%esp
  8014be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c8:	89 1c 24             	mov    %ebx,(%esp)
  8014cb:	e8 76 fc ff ff       	call   801146 <fd_lookup>
  8014d0:	89 c2                	mov    %eax,%edx
  8014d2:	85 d2                	test   %edx,%edx
  8014d4:	78 68                	js     80153e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e0:	8b 00                	mov    (%eax),%eax
  8014e2:	89 04 24             	mov    %eax,(%esp)
  8014e5:	e8 b2 fc ff ff       	call   80119c <dev_lookup>
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 50                	js     80153e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014f5:	75 23                	jne    80151a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f7:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8014fc:	8b 40 48             	mov    0x48(%eax),%eax
  8014ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801503:	89 44 24 04          	mov    %eax,0x4(%esp)
  801507:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  80150e:	e8 49 ed ff ff       	call   80025c <cprintf>
		return -E_INVAL;
  801513:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801518:	eb 24                	jmp    80153e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80151a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151d:	8b 52 0c             	mov    0xc(%edx),%edx
  801520:	85 d2                	test   %edx,%edx
  801522:	74 15                	je     801539 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801524:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801527:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80152b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80152e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801532:	89 04 24             	mov    %eax,(%esp)
  801535:	ff d2                	call   *%edx
  801537:	eb 05                	jmp    80153e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801539:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80153e:	83 c4 24             	add    $0x24,%esp
  801541:	5b                   	pop    %ebx
  801542:	5d                   	pop    %ebp
  801543:	c3                   	ret    

00801544 <seek>:

int
seek(int fdnum, off_t offset)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80154a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80154d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 04 24             	mov    %eax,(%esp)
  801557:	e8 ea fb ff ff       	call   801146 <fd_lookup>
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 0e                	js     80156e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801560:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801563:	8b 55 0c             	mov    0xc(%ebp),%edx
  801566:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	53                   	push   %ebx
  801574:	83 ec 24             	sub    $0x24,%esp
  801577:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80157d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801581:	89 1c 24             	mov    %ebx,(%esp)
  801584:	e8 bd fb ff ff       	call   801146 <fd_lookup>
  801589:	89 c2                	mov    %eax,%edx
  80158b:	85 d2                	test   %edx,%edx
  80158d:	78 61                	js     8015f0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801592:	89 44 24 04          	mov    %eax,0x4(%esp)
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	8b 00                	mov    (%eax),%eax
  80159b:	89 04 24             	mov    %eax,(%esp)
  80159e:	e8 f9 fb ff ff       	call   80119c <dev_lookup>
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 49                	js     8015f0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ae:	75 23                	jne    8015d3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015b0:	a1 20 40 c0 00       	mov    0xc04020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015b5:	8b 40 48             	mov    0x48(%eax),%eax
  8015b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c0:	c7 04 24 d8 2b 80 00 	movl   $0x802bd8,(%esp)
  8015c7:	e8 90 ec ff ff       	call   80025c <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d1:	eb 1d                	jmp    8015f0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d6:	8b 52 18             	mov    0x18(%edx),%edx
  8015d9:	85 d2                	test   %edx,%edx
  8015db:	74 0e                	je     8015eb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015e4:	89 04 24             	mov    %eax,(%esp)
  8015e7:	ff d2                	call   *%edx
  8015e9:	eb 05                	jmp    8015f0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015f0:	83 c4 24             	add    $0x24,%esp
  8015f3:	5b                   	pop    %ebx
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 24             	sub    $0x24,%esp
  8015fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801600:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801603:	89 44 24 04          	mov    %eax,0x4(%esp)
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 04 24             	mov    %eax,(%esp)
  80160d:	e8 34 fb ff ff       	call   801146 <fd_lookup>
  801612:	89 c2                	mov    %eax,%edx
  801614:	85 d2                	test   %edx,%edx
  801616:	78 52                	js     80166a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801618:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801622:	8b 00                	mov    (%eax),%eax
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	e8 70 fb ff ff       	call   80119c <dev_lookup>
  80162c:	85 c0                	test   %eax,%eax
  80162e:	78 3a                	js     80166a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801633:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801637:	74 2c                	je     801665 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801639:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80163c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801643:	00 00 00 
	stat->st_isdir = 0;
  801646:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80164d:	00 00 00 
	stat->st_dev = dev;
  801650:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801656:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80165a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165d:	89 14 24             	mov    %edx,(%esp)
  801660:	ff 50 14             	call   *0x14(%eax)
  801663:	eb 05                	jmp    80166a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801665:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80166a:	83 c4 24             	add    $0x24,%esp
  80166d:	5b                   	pop    %ebx
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801678:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80167f:	00 
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	89 04 24             	mov    %eax,(%esp)
  801686:	e8 1b 02 00 00       	call   8018a6 <open>
  80168b:	89 c3                	mov    %eax,%ebx
  80168d:	85 db                	test   %ebx,%ebx
  80168f:	78 1b                	js     8016ac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801691:	8b 45 0c             	mov    0xc(%ebp),%eax
  801694:	89 44 24 04          	mov    %eax,0x4(%esp)
  801698:	89 1c 24             	mov    %ebx,(%esp)
  80169b:	e8 56 ff ff ff       	call   8015f6 <fstat>
  8016a0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016a2:	89 1c 24             	mov    %ebx,(%esp)
  8016a5:	e8 cd fb ff ff       	call   801277 <close>
	return r;
  8016aa:	89 f0                	mov    %esi,%eax
}
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	5b                   	pop    %ebx
  8016b0:	5e                   	pop    %esi
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    

008016b3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	56                   	push   %esi
  8016b7:	53                   	push   %ebx
  8016b8:	83 ec 10             	sub    $0x10,%esp
  8016bb:	89 c6                	mov    %eax,%esi
  8016bd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016bf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016c6:	75 11                	jne    8016d9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016cf:	e8 7b 0d 00 00       	call   80244f <ipc_find_env>
  8016d4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016d9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016e0:	00 
  8016e1:	c7 44 24 08 00 50 c0 	movl   $0xc05000,0x8(%esp)
  8016e8:	00 
  8016e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016ed:	a1 00 40 80 00       	mov    0x804000,%eax
  8016f2:	89 04 24             	mov    %eax,(%esp)
  8016f5:	e8 ea 0c 00 00       	call   8023e4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801701:	00 
  801702:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801706:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80170d:	e8 7e 0c 00 00       	call   802390 <ipc_recv>
}
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	8b 40 0c             	mov    0xc(%eax),%eax
  801725:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  80172a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172d:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801732:	ba 00 00 00 00       	mov    $0x0,%edx
  801737:	b8 02 00 00 00       	mov    $0x2,%eax
  80173c:	e8 72 ff ff ff       	call   8016b3 <fsipc>
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8b 40 0c             	mov    0xc(%eax),%eax
  80174f:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	b8 06 00 00 00       	mov    $0x6,%eax
  80175e:	e8 50 ff ff ff       	call   8016b3 <fsipc>
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	53                   	push   %ebx
  801769:	83 ec 14             	sub    $0x14,%esp
  80176c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8b 40 0c             	mov    0xc(%eax),%eax
  801775:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80177a:	ba 00 00 00 00       	mov    $0x0,%edx
  80177f:	b8 05 00 00 00       	mov    $0x5,%eax
  801784:	e8 2a ff ff ff       	call   8016b3 <fsipc>
  801789:	89 c2                	mov    %eax,%edx
  80178b:	85 d2                	test   %edx,%edx
  80178d:	78 2b                	js     8017ba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80178f:	c7 44 24 04 00 50 c0 	movl   $0xc05000,0x4(%esp)
  801796:	00 
  801797:	89 1c 24             	mov    %ebx,(%esp)
  80179a:	e8 e8 f0 ff ff       	call   800887 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80179f:	a1 80 50 c0 00       	mov    0xc05080,%eax
  8017a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017aa:	a1 84 50 c0 00       	mov    0xc05084,%eax
  8017af:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ba:	83 c4 14             	add    $0x14,%esp
  8017bd:	5b                   	pop    %ebx
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    

008017c0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 18             	sub    $0x18,%esp
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8017cf:	89 15 00 50 c0 00    	mov    %edx,0xc05000
	fsipcbuf.write.req_n = n;
  8017d5:	a3 04 50 c0 00       	mov    %eax,0xc05004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e5:	c7 04 24 08 50 c0 00 	movl   $0xc05008,(%esp)
  8017ec:	e8 9b f2 ff ff       	call   800a8c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  8017f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f6:	b8 04 00 00 00       	mov    $0x4,%eax
  8017fb:	e8 b3 fe ff ff       	call   8016b3 <fsipc>
		return r;
	}

	return r;
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	56                   	push   %esi
  801806:	53                   	push   %ebx
  801807:	83 ec 10             	sub    $0x10,%esp
  80180a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8b 40 0c             	mov    0xc(%eax),%eax
  801813:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  801818:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80181e:	ba 00 00 00 00       	mov    $0x0,%edx
  801823:	b8 03 00 00 00       	mov    $0x3,%eax
  801828:	e8 86 fe ff ff       	call   8016b3 <fsipc>
  80182d:	89 c3                	mov    %eax,%ebx
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 6a                	js     80189d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801833:	39 c6                	cmp    %eax,%esi
  801835:	73 24                	jae    80185b <devfile_read+0x59>
  801837:	c7 44 24 0c 48 2c 80 	movl   $0x802c48,0xc(%esp)
  80183e:	00 
  80183f:	c7 44 24 08 4f 2c 80 	movl   $0x802c4f,0x8(%esp)
  801846:	00 
  801847:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80184e:	00 
  80184f:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  801856:	e8 08 e9 ff ff       	call   800163 <_panic>
	assert(r <= PGSIZE);
  80185b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801860:	7e 24                	jle    801886 <devfile_read+0x84>
  801862:	c7 44 24 0c 6f 2c 80 	movl   $0x802c6f,0xc(%esp)
  801869:	00 
  80186a:	c7 44 24 08 4f 2c 80 	movl   $0x802c4f,0x8(%esp)
  801871:	00 
  801872:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801879:	00 
  80187a:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  801881:	e8 dd e8 ff ff       	call   800163 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801886:	89 44 24 08          	mov    %eax,0x8(%esp)
  80188a:	c7 44 24 04 00 50 c0 	movl   $0xc05000,0x4(%esp)
  801891:	00 
  801892:	8b 45 0c             	mov    0xc(%ebp),%eax
  801895:	89 04 24             	mov    %eax,(%esp)
  801898:	e8 87 f1 ff ff       	call   800a24 <memmove>
	return r;
}
  80189d:	89 d8                	mov    %ebx,%eax
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	5b                   	pop    %ebx
  8018a3:	5e                   	pop    %esi
  8018a4:	5d                   	pop    %ebp
  8018a5:	c3                   	ret    

008018a6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	53                   	push   %ebx
  8018aa:	83 ec 24             	sub    $0x24,%esp
  8018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018b0:	89 1c 24             	mov    %ebx,(%esp)
  8018b3:	e8 98 ef ff ff       	call   800850 <strlen>
  8018b8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018bd:	7f 60                	jg     80191f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c2:	89 04 24             	mov    %eax,(%esp)
  8018c5:	e8 2d f8 ff ff       	call   8010f7 <fd_alloc>
  8018ca:	89 c2                	mov    %eax,%edx
  8018cc:	85 d2                	test   %edx,%edx
  8018ce:	78 54                	js     801924 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d4:	c7 04 24 00 50 c0 00 	movl   $0xc05000,(%esp)
  8018db:	e8 a7 ef ff ff       	call   800887 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e3:	a3 00 54 c0 00       	mov    %eax,0xc05400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f0:	e8 be fd ff ff       	call   8016b3 <fsipc>
  8018f5:	89 c3                	mov    %eax,%ebx
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	79 17                	jns    801912 <open+0x6c>
		fd_close(fd, 0);
  8018fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801902:	00 
  801903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801906:	89 04 24             	mov    %eax,(%esp)
  801909:	e8 e8 f8 ff ff       	call   8011f6 <fd_close>
		return r;
  80190e:	89 d8                	mov    %ebx,%eax
  801910:	eb 12                	jmp    801924 <open+0x7e>
	}

	return fd2num(fd);
  801912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801915:	89 04 24             	mov    %eax,(%esp)
  801918:	e8 b3 f7 ff ff       	call   8010d0 <fd2num>
  80191d:	eb 05                	jmp    801924 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80191f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801924:	83 c4 24             	add    $0x24,%esp
  801927:	5b                   	pop    %ebx
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801930:	ba 00 00 00 00       	mov    $0x0,%edx
  801935:	b8 08 00 00 00       	mov    $0x8,%eax
  80193a:	e8 74 fd ff ff       	call   8016b3 <fsipc>
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    
  801941:	66 90                	xchg   %ax,%ax
  801943:	66 90                	xchg   %ax,%ax
  801945:	66 90                	xchg   %ax,%ax
  801947:	66 90                	xchg   %ax,%ax
  801949:	66 90                	xchg   %ax,%ax
  80194b:	66 90                	xchg   %ax,%ax
  80194d:	66 90                	xchg   %ax,%ax
  80194f:	90                   	nop

00801950 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801956:	c7 44 24 04 7b 2c 80 	movl   $0x802c7b,0x4(%esp)
  80195d:	00 
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	89 04 24             	mov    %eax,(%esp)
  801964:	e8 1e ef ff ff       	call   800887 <strcpy>
	return 0;
}
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	53                   	push   %ebx
  801974:	83 ec 14             	sub    $0x14,%esp
  801977:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80197a:	89 1c 24             	mov    %ebx,(%esp)
  80197d:	e8 0c 0b 00 00       	call   80248e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801987:	83 f8 01             	cmp    $0x1,%eax
  80198a:	75 0d                	jne    801999 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80198c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80198f:	89 04 24             	mov    %eax,(%esp)
  801992:	e8 29 03 00 00       	call   801cc0 <nsipc_close>
  801997:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801999:	89 d0                	mov    %edx,%eax
  80199b:	83 c4 14             	add    $0x14,%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    

008019a1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ae:	00 
  8019af:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c3:	89 04 24             	mov    %eax,(%esp)
  8019c6:	e8 f0 03 00 00       	call   801dbb <nsipc_send>
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019da:	00 
  8019db:	8b 45 10             	mov    0x10(%ebp),%eax
  8019de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ef:	89 04 24             	mov    %eax,(%esp)
  8019f2:	e8 44 03 00 00       	call   801d3b <nsipc_recv>
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019ff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a02:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a06:	89 04 24             	mov    %eax,(%esp)
  801a09:	e8 38 f7 ff ff       	call   801146 <fd_lookup>
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 17                	js     801a29 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a1b:	39 08                	cmp    %ecx,(%eax)
  801a1d:	75 05                	jne    801a24 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a22:	eb 05                	jmp    801a29 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	83 ec 20             	sub    $0x20,%esp
  801a33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a38:	89 04 24             	mov    %eax,(%esp)
  801a3b:	e8 b7 f6 ff ff       	call   8010f7 <fd_alloc>
  801a40:	89 c3                	mov    %eax,%ebx
  801a42:	85 c0                	test   %eax,%eax
  801a44:	78 21                	js     801a67 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a4d:	00 
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5c:	e8 42 f2 ff ff       	call   800ca3 <sys_page_alloc>
  801a61:	89 c3                	mov    %eax,%ebx
  801a63:	85 c0                	test   %eax,%eax
  801a65:	79 0c                	jns    801a73 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a67:	89 34 24             	mov    %esi,(%esp)
  801a6a:	e8 51 02 00 00       	call   801cc0 <nsipc_close>
		return r;
  801a6f:	89 d8                	mov    %ebx,%eax
  801a71:	eb 20                	jmp    801a93 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a73:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a81:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a88:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a8b:	89 14 24             	mov    %edx,(%esp)
  801a8e:	e8 3d f6 ff ff       	call   8010d0 <fd2num>
}
  801a93:	83 c4 20             	add    $0x20,%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    

00801a9a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	e8 51 ff ff ff       	call   8019f9 <fd2sockid>
		return r;
  801aa8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 23                	js     801ad1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801aae:	8b 55 10             	mov    0x10(%ebp),%edx
  801ab1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801abc:	89 04 24             	mov    %eax,(%esp)
  801abf:	e8 45 01 00 00       	call   801c09 <nsipc_accept>
		return r;
  801ac4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 07                	js     801ad1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801aca:	e8 5c ff ff ff       	call   801a2b <alloc_sockfd>
  801acf:	89 c1                	mov    %eax,%ecx
}
  801ad1:	89 c8                	mov    %ecx,%eax
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	e8 16 ff ff ff       	call   8019f9 <fd2sockid>
  801ae3:	89 c2                	mov    %eax,%edx
  801ae5:	85 d2                	test   %edx,%edx
  801ae7:	78 16                	js     801aff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af7:	89 14 24             	mov    %edx,(%esp)
  801afa:	e8 60 01 00 00       	call   801c5f <nsipc_bind>
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <shutdown>:

int
shutdown(int s, int how)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	e8 ea fe ff ff       	call   8019f9 <fd2sockid>
  801b0f:	89 c2                	mov    %eax,%edx
  801b11:	85 d2                	test   %edx,%edx
  801b13:	78 0f                	js     801b24 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	89 14 24             	mov    %edx,(%esp)
  801b1f:	e8 7a 01 00 00       	call   801c9e <nsipc_shutdown>
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	e8 c5 fe ff ff       	call   8019f9 <fd2sockid>
  801b34:	89 c2                	mov    %eax,%edx
  801b36:	85 d2                	test   %edx,%edx
  801b38:	78 16                	js     801b50 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b48:	89 14 24             	mov    %edx,(%esp)
  801b4b:	e8 8a 01 00 00       	call   801cda <nsipc_connect>
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <listen>:

int
listen(int s, int backlog)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	e8 99 fe ff ff       	call   8019f9 <fd2sockid>
  801b60:	89 c2                	mov    %eax,%edx
  801b62:	85 d2                	test   %edx,%edx
  801b64:	78 0f                	js     801b75 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6d:	89 14 24             	mov    %edx,(%esp)
  801b70:	e8 a4 01 00 00       	call   801d19 <nsipc_listen>
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 98 02 00 00       	call   801e2e <nsipc_socket>
  801b96:	89 c2                	mov    %eax,%edx
  801b98:	85 d2                	test   %edx,%edx
  801b9a:	78 05                	js     801ba1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801b9c:	e8 8a fe ff ff       	call   801a2b <alloc_sockfd>
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	53                   	push   %ebx
  801ba7:	83 ec 14             	sub    $0x14,%esp
  801baa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bac:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bb3:	75 11                	jne    801bc6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bb5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801bbc:	e8 8e 08 00 00       	call   80244f <ipc_find_env>
  801bc1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bc6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bcd:	00 
  801bce:	c7 44 24 08 00 60 c0 	movl   $0xc06000,0x8(%esp)
  801bd5:	00 
  801bd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bda:	a1 04 40 80 00       	mov    0x804004,%eax
  801bdf:	89 04 24             	mov    %eax,(%esp)
  801be2:	e8 fd 07 00 00       	call   8023e4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801be7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bee:	00 
  801bef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bf6:	00 
  801bf7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bfe:	e8 8d 07 00 00       	call   802390 <ipc_recv>
}
  801c03:	83 c4 14             	add    $0x14,%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5d                   	pop    %ebp
  801c08:	c3                   	ret    

00801c09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	56                   	push   %esi
  801c0d:	53                   	push   %ebx
  801c0e:	83 ec 10             	sub    $0x10,%esp
  801c11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c1c:	8b 06                	mov    (%esi),%eax
  801c1e:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c23:	b8 01 00 00 00       	mov    $0x1,%eax
  801c28:	e8 76 ff ff ff       	call   801ba3 <nsipc>
  801c2d:	89 c3                	mov    %eax,%ebx
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 23                	js     801c56 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c33:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801c38:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c3c:	c7 44 24 04 00 60 c0 	movl   $0xc06000,0x4(%esp)
  801c43:	00 
  801c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c47:	89 04 24             	mov    %eax,(%esp)
  801c4a:	e8 d5 ed ff ff       	call   800a24 <memmove>
		*addrlen = ret->ret_addrlen;
  801c4f:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801c54:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801c56:	89 d8                	mov    %ebx,%eax
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    

00801c5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	53                   	push   %ebx
  801c63:	83 ec 14             	sub    $0x14,%esp
  801c66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7c:	c7 04 24 04 60 c0 00 	movl   $0xc06004,(%esp)
  801c83:	e8 9c ed ff ff       	call   800a24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c88:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801c8e:	b8 02 00 00 00       	mov    $0x2,%eax
  801c93:	e8 0b ff ff ff       	call   801ba3 <nsipc>
}
  801c98:	83 c4 14             	add    $0x14,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    

00801c9e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801caf:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801cb4:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb9:	e8 e5 fe ff ff       	call   801ba3 <nsipc>
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <nsipc_close>:

int
nsipc_close(int s)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801cce:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd3:	e8 cb fe ff ff       	call   801ba3 <nsipc>
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 14             	sub    $0x14,%esp
  801ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf7:	c7 04 24 04 60 c0 00 	movl   $0xc06004,(%esp)
  801cfe:	e8 21 ed ff ff       	call   800a24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d03:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801d09:	b8 05 00 00 00       	mov    $0x5,%eax
  801d0e:	e8 90 fe ff ff       	call   801ba3 <nsipc>
}
  801d13:	83 c4 14             	add    $0x14,%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    

00801d19 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801d2f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d34:	e8 6a fe ff ff       	call   801ba3 <nsipc>
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	83 ec 10             	sub    $0x10,%esp
  801d43:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801d4e:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801d54:	8b 45 14             	mov    0x14(%ebp),%eax
  801d57:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d5c:	b8 07 00 00 00       	mov    $0x7,%eax
  801d61:	e8 3d fe ff ff       	call   801ba3 <nsipc>
  801d66:	89 c3                	mov    %eax,%ebx
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 46                	js     801db2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d6c:	39 f0                	cmp    %esi,%eax
  801d6e:	7f 07                	jg     801d77 <nsipc_recv+0x3c>
  801d70:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d75:	7e 24                	jle    801d9b <nsipc_recv+0x60>
  801d77:	c7 44 24 0c 87 2c 80 	movl   $0x802c87,0xc(%esp)
  801d7e:	00 
  801d7f:	c7 44 24 08 4f 2c 80 	movl   $0x802c4f,0x8(%esp)
  801d86:	00 
  801d87:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d8e:	00 
  801d8f:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  801d96:	e8 c8 e3 ff ff       	call   800163 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d9f:	c7 44 24 04 00 60 c0 	movl   $0xc06000,0x4(%esp)
  801da6:	00 
  801da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801daa:	89 04 24             	mov    %eax,(%esp)
  801dad:	e8 72 ec ff ff       	call   800a24 <memmove>
	}

	return r;
}
  801db2:	89 d8                	mov    %ebx,%eax
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    

00801dbb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	53                   	push   %ebx
  801dbf:	83 ec 14             	sub    $0x14,%esp
  801dc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801dcd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dd3:	7e 24                	jle    801df9 <nsipc_send+0x3e>
  801dd5:	c7 44 24 0c a8 2c 80 	movl   $0x802ca8,0xc(%esp)
  801ddc:	00 
  801ddd:	c7 44 24 08 4f 2c 80 	movl   $0x802c4f,0x8(%esp)
  801de4:	00 
  801de5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801dec:	00 
  801ded:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  801df4:	e8 6a e3 ff ff       	call   800163 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801df9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	c7 04 24 0c 60 c0 00 	movl   $0xc0600c,(%esp)
  801e0b:	e8 14 ec ff ff       	call   800a24 <memmove>
	nsipcbuf.send.req_size = size;
  801e10:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801e16:	8b 45 14             	mov    0x14(%ebp),%eax
  801e19:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801e1e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e23:	e8 7b fd ff ff       	call   801ba3 <nsipc>
}
  801e28:	83 c4 14             	add    $0x14,%esp
  801e2b:	5b                   	pop    %ebx
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    

00801e2e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3f:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801e4c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e51:	e8 4d fd ff ff       	call   801ba3 <nsipc>
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	56                   	push   %esi
  801e5c:	53                   	push   %ebx
  801e5d:	83 ec 10             	sub    $0x10,%esp
  801e60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	89 04 24             	mov    %eax,(%esp)
  801e69:	e8 72 f2 ff ff       	call   8010e0 <fd2data>
  801e6e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e70:	c7 44 24 04 b4 2c 80 	movl   $0x802cb4,0x4(%esp)
  801e77:	00 
  801e78:	89 1c 24             	mov    %ebx,(%esp)
  801e7b:	e8 07 ea ff ff       	call   800887 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e80:	8b 46 04             	mov    0x4(%esi),%eax
  801e83:	2b 06                	sub    (%esi),%eax
  801e85:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e8b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e92:	00 00 00 
	stat->st_dev = &devpipe;
  801e95:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e9c:	30 80 00 
	return 0;
}
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	53                   	push   %ebx
  801eaf:	83 ec 14             	sub    $0x14,%esp
  801eb2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801eb5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec0:	e8 85 ee ff ff       	call   800d4a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ec5:	89 1c 24             	mov    %ebx,(%esp)
  801ec8:	e8 13 f2 ff ff       	call   8010e0 <fd2data>
  801ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed8:	e8 6d ee ff ff       	call   800d4a <sys_page_unmap>
}
  801edd:	83 c4 14             	add    $0x14,%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5d                   	pop    %ebp
  801ee2:	c3                   	ret    

00801ee3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	57                   	push   %edi
  801ee7:	56                   	push   %esi
  801ee8:	53                   	push   %ebx
  801ee9:	83 ec 2c             	sub    $0x2c,%esp
  801eec:	89 c6                	mov    %eax,%esi
  801eee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ef1:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801ef6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ef9:	89 34 24             	mov    %esi,(%esp)
  801efc:	e8 8d 05 00 00       	call   80248e <pageref>
  801f01:	89 c7                	mov    %eax,%edi
  801f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f06:	89 04 24             	mov    %eax,(%esp)
  801f09:	e8 80 05 00 00       	call   80248e <pageref>
  801f0e:	39 c7                	cmp    %eax,%edi
  801f10:	0f 94 c2             	sete   %dl
  801f13:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f16:	8b 0d 20 40 c0 00    	mov    0xc04020,%ecx
  801f1c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f1f:	39 fb                	cmp    %edi,%ebx
  801f21:	74 21                	je     801f44 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f23:	84 d2                	test   %dl,%dl
  801f25:	74 ca                	je     801ef1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f27:	8b 51 58             	mov    0x58(%ecx),%edx
  801f2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f2e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f36:	c7 04 24 bb 2c 80 00 	movl   $0x802cbb,(%esp)
  801f3d:	e8 1a e3 ff ff       	call   80025c <cprintf>
  801f42:	eb ad                	jmp    801ef1 <_pipeisclosed+0xe>
	}
}
  801f44:	83 c4 2c             	add    $0x2c,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5f                   	pop    %edi
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    

00801f4c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	57                   	push   %edi
  801f50:	56                   	push   %esi
  801f51:	53                   	push   %ebx
  801f52:	83 ec 1c             	sub    $0x1c,%esp
  801f55:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f58:	89 34 24             	mov    %esi,(%esp)
  801f5b:	e8 80 f1 ff ff       	call   8010e0 <fd2data>
  801f60:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f62:	bf 00 00 00 00       	mov    $0x0,%edi
  801f67:	eb 45                	jmp    801fae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f69:	89 da                	mov    %ebx,%edx
  801f6b:	89 f0                	mov    %esi,%eax
  801f6d:	e8 71 ff ff ff       	call   801ee3 <_pipeisclosed>
  801f72:	85 c0                	test   %eax,%eax
  801f74:	75 41                	jne    801fb7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f76:	e8 09 ed ff ff       	call   800c84 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f7b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f7e:	8b 0b                	mov    (%ebx),%ecx
  801f80:	8d 51 20             	lea    0x20(%ecx),%edx
  801f83:	39 d0                	cmp    %edx,%eax
  801f85:	73 e2                	jae    801f69 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f8a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f8e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f91:	99                   	cltd   
  801f92:	c1 ea 1b             	shr    $0x1b,%edx
  801f95:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f98:	83 e1 1f             	and    $0x1f,%ecx
  801f9b:	29 d1                	sub    %edx,%ecx
  801f9d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801fa1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fa5:	83 c0 01             	add    $0x1,%eax
  801fa8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fab:	83 c7 01             	add    $0x1,%edi
  801fae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fb1:	75 c8                	jne    801f7b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fb3:	89 f8                	mov    %edi,%eax
  801fb5:	eb 05                	jmp    801fbc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fbc:	83 c4 1c             	add    $0x1c,%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	57                   	push   %edi
  801fc8:	56                   	push   %esi
  801fc9:	53                   	push   %ebx
  801fca:	83 ec 1c             	sub    $0x1c,%esp
  801fcd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fd0:	89 3c 24             	mov    %edi,(%esp)
  801fd3:	e8 08 f1 ff ff       	call   8010e0 <fd2data>
  801fd8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fda:	be 00 00 00 00       	mov    $0x0,%esi
  801fdf:	eb 3d                	jmp    80201e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801fe1:	85 f6                	test   %esi,%esi
  801fe3:	74 04                	je     801fe9 <devpipe_read+0x25>
				return i;
  801fe5:	89 f0                	mov    %esi,%eax
  801fe7:	eb 43                	jmp    80202c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801fe9:	89 da                	mov    %ebx,%edx
  801feb:	89 f8                	mov    %edi,%eax
  801fed:	e8 f1 fe ff ff       	call   801ee3 <_pipeisclosed>
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	75 31                	jne    802027 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ff6:	e8 89 ec ff ff       	call   800c84 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801ffb:	8b 03                	mov    (%ebx),%eax
  801ffd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802000:	74 df                	je     801fe1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802002:	99                   	cltd   
  802003:	c1 ea 1b             	shr    $0x1b,%edx
  802006:	01 d0                	add    %edx,%eax
  802008:	83 e0 1f             	and    $0x1f,%eax
  80200b:	29 d0                	sub    %edx,%eax
  80200d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802012:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802015:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802018:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80201b:	83 c6 01             	add    $0x1,%esi
  80201e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802021:	75 d8                	jne    801ffb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802023:	89 f0                	mov    %esi,%eax
  802025:	eb 05                	jmp    80202c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80202c:	83 c4 1c             	add    $0x1c,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    

00802034 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	56                   	push   %esi
  802038:	53                   	push   %ebx
  802039:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80203c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203f:	89 04 24             	mov    %eax,(%esp)
  802042:	e8 b0 f0 ff ff       	call   8010f7 <fd_alloc>
  802047:	89 c2                	mov    %eax,%edx
  802049:	85 d2                	test   %edx,%edx
  80204b:	0f 88 4d 01 00 00    	js     80219e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802051:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802058:	00 
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802060:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802067:	e8 37 ec ff ff       	call   800ca3 <sys_page_alloc>
  80206c:	89 c2                	mov    %eax,%edx
  80206e:	85 d2                	test   %edx,%edx
  802070:	0f 88 28 01 00 00    	js     80219e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802076:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802079:	89 04 24             	mov    %eax,(%esp)
  80207c:	e8 76 f0 ff ff       	call   8010f7 <fd_alloc>
  802081:	89 c3                	mov    %eax,%ebx
  802083:	85 c0                	test   %eax,%eax
  802085:	0f 88 fe 00 00 00    	js     802189 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80208b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802092:	00 
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802096:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a1:	e8 fd eb ff ff       	call   800ca3 <sys_page_alloc>
  8020a6:	89 c3                	mov    %eax,%ebx
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	0f 88 d9 00 00 00    	js     802189 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	89 04 24             	mov    %eax,(%esp)
  8020b6:	e8 25 f0 ff ff       	call   8010e0 <fd2data>
  8020bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020c4:	00 
  8020c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d0:	e8 ce eb ff ff       	call   800ca3 <sys_page_alloc>
  8020d5:	89 c3                	mov    %eax,%ebx
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	0f 88 97 00 00 00    	js     802176 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e2:	89 04 24             	mov    %eax,(%esp)
  8020e5:	e8 f6 ef ff ff       	call   8010e0 <fd2data>
  8020ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8020f1:	00 
  8020f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020fd:	00 
  8020fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802102:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802109:	e8 e9 eb ff ff       	call   800cf7 <sys_page_map>
  80210e:	89 c3                	mov    %eax,%ebx
  802110:	85 c0                	test   %eax,%eax
  802112:	78 52                	js     802166 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802114:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802129:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80212f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802132:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802137:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	89 04 24             	mov    %eax,(%esp)
  802144:	e8 87 ef ff ff       	call   8010d0 <fd2num>
  802149:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80214c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80214e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802151:	89 04 24             	mov    %eax,(%esp)
  802154:	e8 77 ef ff ff       	call   8010d0 <fd2num>
  802159:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80215f:	b8 00 00 00 00       	mov    $0x0,%eax
  802164:	eb 38                	jmp    80219e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802166:	89 74 24 04          	mov    %esi,0x4(%esp)
  80216a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802171:	e8 d4 eb ff ff       	call   800d4a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802184:	e8 c1 eb ff ff       	call   800d4a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802190:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802197:	e8 ae eb ff ff       	call   800d4a <sys_page_unmap>
  80219c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80219e:	83 c4 30             	add    $0x30,%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    

008021a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	89 04 24             	mov    %eax,(%esp)
  8021b8:	e8 89 ef ff ff       	call   801146 <fd_lookup>
  8021bd:	89 c2                	mov    %eax,%edx
  8021bf:	85 d2                	test   %edx,%edx
  8021c1:	78 15                	js     8021d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	89 04 24             	mov    %eax,(%esp)
  8021c9:	e8 12 ef ff ff       	call   8010e0 <fd2data>
	return _pipeisclosed(fd, p);
  8021ce:	89 c2                	mov    %eax,%edx
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	e8 0b fd ff ff       	call   801ee3 <_pipeisclosed>
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	66 90                	xchg   %ax,%ax
  8021de:	66 90                	xchg   %ax,%ax

008021e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    

008021ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021f0:	c7 44 24 04 d3 2c 80 	movl   $0x802cd3,0x4(%esp)
  8021f7:	00 
  8021f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fb:	89 04 24             	mov    %eax,(%esp)
  8021fe:	e8 84 e6 ff ff       	call   800887 <strcpy>
	return 0;
}
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	57                   	push   %edi
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802216:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80221b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802221:	eb 31                	jmp    802254 <devcons_write+0x4a>
		m = n - tot;
  802223:	8b 75 10             	mov    0x10(%ebp),%esi
  802226:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802228:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80222b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802230:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802233:	89 74 24 08          	mov    %esi,0x8(%esp)
  802237:	03 45 0c             	add    0xc(%ebp),%eax
  80223a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223e:	89 3c 24             	mov    %edi,(%esp)
  802241:	e8 de e7 ff ff       	call   800a24 <memmove>
		sys_cputs(buf, m);
  802246:	89 74 24 04          	mov    %esi,0x4(%esp)
  80224a:	89 3c 24             	mov    %edi,(%esp)
  80224d:	e8 84 e9 ff ff       	call   800bd6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802252:	01 f3                	add    %esi,%ebx
  802254:	89 d8                	mov    %ebx,%eax
  802256:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802259:	72 c8                	jb     802223 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80225b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5f                   	pop    %edi
  802264:	5d                   	pop    %ebp
  802265:	c3                   	ret    

00802266 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80226c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802271:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802275:	75 07                	jne    80227e <devcons_read+0x18>
  802277:	eb 2a                	jmp    8022a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802279:	e8 06 ea ff ff       	call   800c84 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80227e:	66 90                	xchg   %ax,%ax
  802280:	e8 6f e9 ff ff       	call   800bf4 <sys_cgetc>
  802285:	85 c0                	test   %eax,%eax
  802287:	74 f0                	je     802279 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802289:	85 c0                	test   %eax,%eax
  80228b:	78 16                	js     8022a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80228d:	83 f8 04             	cmp    $0x4,%eax
  802290:	74 0c                	je     80229e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802292:	8b 55 0c             	mov    0xc(%ebp),%edx
  802295:	88 02                	mov    %al,(%edx)
	return 1;
  802297:	b8 01 00 00 00       	mov    $0x1,%eax
  80229c:	eb 05                	jmp    8022a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022b8:	00 
  8022b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022bc:	89 04 24             	mov    %eax,(%esp)
  8022bf:	e8 12 e9 ff ff       	call   800bd6 <sys_cputs>
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <getchar>:

int
getchar(void)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022d3:	00 
  8022d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e2:	e8 f3 f0 ff ff       	call   8013da <read>
	if (r < 0)
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	78 0f                	js     8022fa <getchar+0x34>
		return r;
	if (r < 1)
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	7e 06                	jle    8022f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022f3:	eb 05                	jmp    8022fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802302:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802305:	89 44 24 04          	mov    %eax,0x4(%esp)
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	89 04 24             	mov    %eax,(%esp)
  80230f:	e8 32 ee ff ff       	call   801146 <fd_lookup>
  802314:	85 c0                	test   %eax,%eax
  802316:	78 11                	js     802329 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802321:	39 10                	cmp    %edx,(%eax)
  802323:	0f 94 c0             	sete   %al
  802326:	0f b6 c0             	movzbl %al,%eax
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <opencons>:

int
opencons(void)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802331:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802334:	89 04 24             	mov    %eax,(%esp)
  802337:	e8 bb ed ff ff       	call   8010f7 <fd_alloc>
		return r;
  80233c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80233e:	85 c0                	test   %eax,%eax
  802340:	78 40                	js     802382 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802342:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802349:	00 
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802351:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802358:	e8 46 e9 ff ff       	call   800ca3 <sys_page_alloc>
		return r;
  80235d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 1f                	js     802382 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802363:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802378:	89 04 24             	mov    %eax,(%esp)
  80237b:	e8 50 ed ff ff       	call   8010d0 <fd2num>
  802380:	89 c2                	mov    %eax,%edx
}
  802382:	89 d0                	mov    %edx,%eax
  802384:	c9                   	leave  
  802385:	c3                   	ret    
  802386:	66 90                	xchg   %ax,%ax
  802388:	66 90                	xchg   %ax,%ax
  80238a:	66 90                	xchg   %ax,%ax
  80238c:	66 90                	xchg   %ax,%ax
  80238e:	66 90                	xchg   %ax,%ax

00802390 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	56                   	push   %esi
  802394:	53                   	push   %ebx
  802395:	83 ec 10             	sub    $0x10,%esp
  802398:	8b 75 08             	mov    0x8(%ebp),%esi
  80239b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023a1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8023a3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023a8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8023ab:	89 04 24             	mov    %eax,(%esp)
  8023ae:	e8 06 eb ff ff       	call   800eb9 <sys_ipc_recv>
  8023b3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8023b5:	85 d2                	test   %edx,%edx
  8023b7:	75 24                	jne    8023dd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8023b9:	85 f6                	test   %esi,%esi
  8023bb:	74 0a                	je     8023c7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8023bd:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8023c2:	8b 40 74             	mov    0x74(%eax),%eax
  8023c5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8023c7:	85 db                	test   %ebx,%ebx
  8023c9:	74 0a                	je     8023d5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8023cb:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8023d0:	8b 40 78             	mov    0x78(%eax),%eax
  8023d3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8023d5:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8023da:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8023dd:	83 c4 10             	add    $0x10,%esp
  8023e0:	5b                   	pop    %ebx
  8023e1:	5e                   	pop    %esi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	57                   	push   %edi
  8023e8:	56                   	push   %esi
  8023e9:	53                   	push   %ebx
  8023ea:	83 ec 1c             	sub    $0x1c,%esp
  8023ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8023f6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8023f8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023fd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802400:	8b 45 14             	mov    0x14(%ebp),%eax
  802403:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802407:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80240b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80240f:	89 3c 24             	mov    %edi,(%esp)
  802412:	e8 7f ea ff ff       	call   800e96 <sys_ipc_try_send>

		if (ret == 0)
  802417:	85 c0                	test   %eax,%eax
  802419:	74 2c                	je     802447 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80241b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80241e:	74 20                	je     802440 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802420:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802424:	c7 44 24 08 e0 2c 80 	movl   $0x802ce0,0x8(%esp)
  80242b:	00 
  80242c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802433:	00 
  802434:	c7 04 24 10 2d 80 00 	movl   $0x802d10,(%esp)
  80243b:	e8 23 dd ff ff       	call   800163 <_panic>
		}

		sys_yield();
  802440:	e8 3f e8 ff ff       	call   800c84 <sys_yield>
	}
  802445:	eb b9                	jmp    802400 <ipc_send+0x1c>
}
  802447:	83 c4 1c             	add    $0x1c,%esp
  80244a:	5b                   	pop    %ebx
  80244b:	5e                   	pop    %esi
  80244c:	5f                   	pop    %edi
  80244d:	5d                   	pop    %ebp
  80244e:	c3                   	ret    

0080244f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80245a:	89 c2                	mov    %eax,%edx
  80245c:	c1 e2 07             	shl    $0x7,%edx
  80245f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802466:	8b 52 50             	mov    0x50(%edx),%edx
  802469:	39 ca                	cmp    %ecx,%edx
  80246b:	75 11                	jne    80247e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80246d:	89 c2                	mov    %eax,%edx
  80246f:	c1 e2 07             	shl    $0x7,%edx
  802472:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802479:	8b 40 40             	mov    0x40(%eax),%eax
  80247c:	eb 0e                	jmp    80248c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80247e:	83 c0 01             	add    $0x1,%eax
  802481:	3d 00 04 00 00       	cmp    $0x400,%eax
  802486:	75 d2                	jne    80245a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802488:	66 b8 00 00          	mov    $0x0,%ax
}
  80248c:	5d                   	pop    %ebp
  80248d:	c3                   	ret    

0080248e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802494:	89 d0                	mov    %edx,%eax
  802496:	c1 e8 16             	shr    $0x16,%eax
  802499:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024a0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024a5:	f6 c1 01             	test   $0x1,%cl
  8024a8:	74 1d                	je     8024c7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024aa:	c1 ea 0c             	shr    $0xc,%edx
  8024ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024b4:	f6 c2 01             	test   $0x1,%dl
  8024b7:	74 0e                	je     8024c7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024b9:	c1 ea 0c             	shr    $0xc,%edx
  8024bc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024c3:	ef 
  8024c4:	0f b7 c0             	movzwl %ax,%eax
}
  8024c7:	5d                   	pop    %ebp
  8024c8:	c3                   	ret    
  8024c9:	66 90                	xchg   %ax,%ax
  8024cb:	66 90                	xchg   %ax,%ax
  8024cd:	66 90                	xchg   %ax,%ax
  8024cf:	90                   	nop

008024d0 <__udivdi3>:
  8024d0:	55                   	push   %ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	83 ec 0c             	sub    $0xc,%esp
  8024d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024ec:	89 ea                	mov    %ebp,%edx
  8024ee:	89 0c 24             	mov    %ecx,(%esp)
  8024f1:	75 2d                	jne    802520 <__udivdi3+0x50>
  8024f3:	39 e9                	cmp    %ebp,%ecx
  8024f5:	77 61                	ja     802558 <__udivdi3+0x88>
  8024f7:	85 c9                	test   %ecx,%ecx
  8024f9:	89 ce                	mov    %ecx,%esi
  8024fb:	75 0b                	jne    802508 <__udivdi3+0x38>
  8024fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802502:	31 d2                	xor    %edx,%edx
  802504:	f7 f1                	div    %ecx
  802506:	89 c6                	mov    %eax,%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	89 e8                	mov    %ebp,%eax
  80250c:	f7 f6                	div    %esi
  80250e:	89 c5                	mov    %eax,%ebp
  802510:	89 f8                	mov    %edi,%eax
  802512:	f7 f6                	div    %esi
  802514:	89 ea                	mov    %ebp,%edx
  802516:	83 c4 0c             	add    $0xc,%esp
  802519:	5e                   	pop    %esi
  80251a:	5f                   	pop    %edi
  80251b:	5d                   	pop    %ebp
  80251c:	c3                   	ret    
  80251d:	8d 76 00             	lea    0x0(%esi),%esi
  802520:	39 e8                	cmp    %ebp,%eax
  802522:	77 24                	ja     802548 <__udivdi3+0x78>
  802524:	0f bd e8             	bsr    %eax,%ebp
  802527:	83 f5 1f             	xor    $0x1f,%ebp
  80252a:	75 3c                	jne    802568 <__udivdi3+0x98>
  80252c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802530:	39 34 24             	cmp    %esi,(%esp)
  802533:	0f 86 9f 00 00 00    	jbe    8025d8 <__udivdi3+0x108>
  802539:	39 d0                	cmp    %edx,%eax
  80253b:	0f 82 97 00 00 00    	jb     8025d8 <__udivdi3+0x108>
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	31 c0                	xor    %eax,%eax
  80254c:	83 c4 0c             	add    $0xc,%esp
  80254f:	5e                   	pop    %esi
  802550:	5f                   	pop    %edi
  802551:	5d                   	pop    %ebp
  802552:	c3                   	ret    
  802553:	90                   	nop
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 f8                	mov    %edi,%eax
  80255a:	f7 f1                	div    %ecx
  80255c:	31 d2                	xor    %edx,%edx
  80255e:	83 c4 0c             	add    $0xc,%esp
  802561:	5e                   	pop    %esi
  802562:	5f                   	pop    %edi
  802563:	5d                   	pop    %ebp
  802564:	c3                   	ret    
  802565:	8d 76 00             	lea    0x0(%esi),%esi
  802568:	89 e9                	mov    %ebp,%ecx
  80256a:	8b 3c 24             	mov    (%esp),%edi
  80256d:	d3 e0                	shl    %cl,%eax
  80256f:	89 c6                	mov    %eax,%esi
  802571:	b8 20 00 00 00       	mov    $0x20,%eax
  802576:	29 e8                	sub    %ebp,%eax
  802578:	89 c1                	mov    %eax,%ecx
  80257a:	d3 ef                	shr    %cl,%edi
  80257c:	89 e9                	mov    %ebp,%ecx
  80257e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802582:	8b 3c 24             	mov    (%esp),%edi
  802585:	09 74 24 08          	or     %esi,0x8(%esp)
  802589:	89 d6                	mov    %edx,%esi
  80258b:	d3 e7                	shl    %cl,%edi
  80258d:	89 c1                	mov    %eax,%ecx
  80258f:	89 3c 24             	mov    %edi,(%esp)
  802592:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802596:	d3 ee                	shr    %cl,%esi
  802598:	89 e9                	mov    %ebp,%ecx
  80259a:	d3 e2                	shl    %cl,%edx
  80259c:	89 c1                	mov    %eax,%ecx
  80259e:	d3 ef                	shr    %cl,%edi
  8025a0:	09 d7                	or     %edx,%edi
  8025a2:	89 f2                	mov    %esi,%edx
  8025a4:	89 f8                	mov    %edi,%eax
  8025a6:	f7 74 24 08          	divl   0x8(%esp)
  8025aa:	89 d6                	mov    %edx,%esi
  8025ac:	89 c7                	mov    %eax,%edi
  8025ae:	f7 24 24             	mull   (%esp)
  8025b1:	39 d6                	cmp    %edx,%esi
  8025b3:	89 14 24             	mov    %edx,(%esp)
  8025b6:	72 30                	jb     8025e8 <__udivdi3+0x118>
  8025b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025bc:	89 e9                	mov    %ebp,%ecx
  8025be:	d3 e2                	shl    %cl,%edx
  8025c0:	39 c2                	cmp    %eax,%edx
  8025c2:	73 05                	jae    8025c9 <__udivdi3+0xf9>
  8025c4:	3b 34 24             	cmp    (%esp),%esi
  8025c7:	74 1f                	je     8025e8 <__udivdi3+0x118>
  8025c9:	89 f8                	mov    %edi,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	e9 7a ff ff ff       	jmp    80254c <__udivdi3+0x7c>
  8025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025d8:	31 d2                	xor    %edx,%edx
  8025da:	b8 01 00 00 00       	mov    $0x1,%eax
  8025df:	e9 68 ff ff ff       	jmp    80254c <__udivdi3+0x7c>
  8025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	83 c4 0c             	add    $0xc,%esp
  8025f0:	5e                   	pop    %esi
  8025f1:	5f                   	pop    %edi
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    
  8025f4:	66 90                	xchg   %ax,%ax
  8025f6:	66 90                	xchg   %ax,%ax
  8025f8:	66 90                	xchg   %ax,%ax
  8025fa:	66 90                	xchg   %ax,%ax
  8025fc:	66 90                	xchg   %ax,%ax
  8025fe:	66 90                	xchg   %ax,%ax

00802600 <__umoddi3>:
  802600:	55                   	push   %ebp
  802601:	57                   	push   %edi
  802602:	56                   	push   %esi
  802603:	83 ec 14             	sub    $0x14,%esp
  802606:	8b 44 24 28          	mov    0x28(%esp),%eax
  80260a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80260e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802612:	89 c7                	mov    %eax,%edi
  802614:	89 44 24 04          	mov    %eax,0x4(%esp)
  802618:	8b 44 24 30          	mov    0x30(%esp),%eax
  80261c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802620:	89 34 24             	mov    %esi,(%esp)
  802623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802627:	85 c0                	test   %eax,%eax
  802629:	89 c2                	mov    %eax,%edx
  80262b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80262f:	75 17                	jne    802648 <__umoddi3+0x48>
  802631:	39 fe                	cmp    %edi,%esi
  802633:	76 4b                	jbe    802680 <__umoddi3+0x80>
  802635:	89 c8                	mov    %ecx,%eax
  802637:	89 fa                	mov    %edi,%edx
  802639:	f7 f6                	div    %esi
  80263b:	89 d0                	mov    %edx,%eax
  80263d:	31 d2                	xor    %edx,%edx
  80263f:	83 c4 14             	add    $0x14,%esp
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    
  802646:	66 90                	xchg   %ax,%ax
  802648:	39 f8                	cmp    %edi,%eax
  80264a:	77 54                	ja     8026a0 <__umoddi3+0xa0>
  80264c:	0f bd e8             	bsr    %eax,%ebp
  80264f:	83 f5 1f             	xor    $0x1f,%ebp
  802652:	75 5c                	jne    8026b0 <__umoddi3+0xb0>
  802654:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802658:	39 3c 24             	cmp    %edi,(%esp)
  80265b:	0f 87 e7 00 00 00    	ja     802748 <__umoddi3+0x148>
  802661:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802665:	29 f1                	sub    %esi,%ecx
  802667:	19 c7                	sbb    %eax,%edi
  802669:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80266d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802671:	8b 44 24 08          	mov    0x8(%esp),%eax
  802675:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802679:	83 c4 14             	add    $0x14,%esp
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
  802680:	85 f6                	test   %esi,%esi
  802682:	89 f5                	mov    %esi,%ebp
  802684:	75 0b                	jne    802691 <__umoddi3+0x91>
  802686:	b8 01 00 00 00       	mov    $0x1,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	f7 f6                	div    %esi
  80268f:	89 c5                	mov    %eax,%ebp
  802691:	8b 44 24 04          	mov    0x4(%esp),%eax
  802695:	31 d2                	xor    %edx,%edx
  802697:	f7 f5                	div    %ebp
  802699:	89 c8                	mov    %ecx,%eax
  80269b:	f7 f5                	div    %ebp
  80269d:	eb 9c                	jmp    80263b <__umoddi3+0x3b>
  80269f:	90                   	nop
  8026a0:	89 c8                	mov    %ecx,%eax
  8026a2:	89 fa                	mov    %edi,%edx
  8026a4:	83 c4 14             	add    $0x14,%esp
  8026a7:	5e                   	pop    %esi
  8026a8:	5f                   	pop    %edi
  8026a9:	5d                   	pop    %ebp
  8026aa:	c3                   	ret    
  8026ab:	90                   	nop
  8026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	8b 04 24             	mov    (%esp),%eax
  8026b3:	be 20 00 00 00       	mov    $0x20,%esi
  8026b8:	89 e9                	mov    %ebp,%ecx
  8026ba:	29 ee                	sub    %ebp,%esi
  8026bc:	d3 e2                	shl    %cl,%edx
  8026be:	89 f1                	mov    %esi,%ecx
  8026c0:	d3 e8                	shr    %cl,%eax
  8026c2:	89 e9                	mov    %ebp,%ecx
  8026c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c8:	8b 04 24             	mov    (%esp),%eax
  8026cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8026cf:	89 fa                	mov    %edi,%edx
  8026d1:	d3 e0                	shl    %cl,%eax
  8026d3:	89 f1                	mov    %esi,%ecx
  8026d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026dd:	d3 ea                	shr    %cl,%edx
  8026df:	89 e9                	mov    %ebp,%ecx
  8026e1:	d3 e7                	shl    %cl,%edi
  8026e3:	89 f1                	mov    %esi,%ecx
  8026e5:	d3 e8                	shr    %cl,%eax
  8026e7:	89 e9                	mov    %ebp,%ecx
  8026e9:	09 f8                	or     %edi,%eax
  8026eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026ef:	f7 74 24 04          	divl   0x4(%esp)
  8026f3:	d3 e7                	shl    %cl,%edi
  8026f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026f9:	89 d7                	mov    %edx,%edi
  8026fb:	f7 64 24 08          	mull   0x8(%esp)
  8026ff:	39 d7                	cmp    %edx,%edi
  802701:	89 c1                	mov    %eax,%ecx
  802703:	89 14 24             	mov    %edx,(%esp)
  802706:	72 2c                	jb     802734 <__umoddi3+0x134>
  802708:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80270c:	72 22                	jb     802730 <__umoddi3+0x130>
  80270e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802712:	29 c8                	sub    %ecx,%eax
  802714:	19 d7                	sbb    %edx,%edi
  802716:	89 e9                	mov    %ebp,%ecx
  802718:	89 fa                	mov    %edi,%edx
  80271a:	d3 e8                	shr    %cl,%eax
  80271c:	89 f1                	mov    %esi,%ecx
  80271e:	d3 e2                	shl    %cl,%edx
  802720:	89 e9                	mov    %ebp,%ecx
  802722:	d3 ef                	shr    %cl,%edi
  802724:	09 d0                	or     %edx,%eax
  802726:	89 fa                	mov    %edi,%edx
  802728:	83 c4 14             	add    $0x14,%esp
  80272b:	5e                   	pop    %esi
  80272c:	5f                   	pop    %edi
  80272d:	5d                   	pop    %ebp
  80272e:	c3                   	ret    
  80272f:	90                   	nop
  802730:	39 d7                	cmp    %edx,%edi
  802732:	75 da                	jne    80270e <__umoddi3+0x10e>
  802734:	8b 14 24             	mov    (%esp),%edx
  802737:	89 c1                	mov    %eax,%ecx
  802739:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80273d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802741:	eb cb                	jmp    80270e <__umoddi3+0x10e>
  802743:	90                   	nop
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80274c:	0f 82 0f ff ff ff    	jb     802661 <__umoddi3+0x61>
  802752:	e9 1a ff ff ff       	jmp    802671 <__umoddi3+0x71>
