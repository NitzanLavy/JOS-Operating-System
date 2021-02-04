
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 17 01 00 00       	call   800148 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800046:	00 
  800047:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004e:	00 
  80004f:	89 34 24             	mov    %esi,(%esp)
  800052:	e8 b9 14 00 00       	call   801510 <ipc_recv>
  800057:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800059:	a1 08 50 80 00       	mov    0x805008,%eax
  80005e:	8b 40 5c             	mov    0x5c(%eax),%eax
  800061:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	c7 04 24 40 2c 80 00 	movl   $0x802c40,(%esp)
  800070:	e8 31 02 00 00       	call   8002a6 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800075:	e8 c0 11 00 00       	call   80123a <fork>
  80007a:	89 c7                	mov    %eax,%edi
  80007c:	85 c0                	test   %eax,%eax
  80007e:	79 20                	jns    8000a0 <primeproc+0x6d>
		panic("fork: %e", id);
  800080:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800084:	c7 44 24 08 4c 2c 80 	movl   $0x802c4c,0x8(%esp)
  80008b:	00 
  80008c:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800093:	00 
  800094:	c7 04 24 55 2c 80 00 	movl   $0x802c55,(%esp)
  80009b:	e8 0d 01 00 00       	call   8001ad <_panic>
	if (id == 0)
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	74 9b                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000a4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ae:	00 
  8000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b6:	00 
  8000b7:	89 34 24             	mov    %esi,(%esp)
  8000ba:	e8 51 14 00 00       	call   801510 <ipc_recv>
  8000bf:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000c1:	99                   	cltd   
  8000c2:	f7 fb                	idiv   %ebx
  8000c4:	85 d2                	test   %edx,%edx
  8000c6:	74 df                	je     8000a7 <primeproc+0x74>
			ipc_send(id, i, 0, 0);
  8000c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000d7:	00 
  8000d8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000dc:	89 3c 24             	mov    %edi,(%esp)
  8000df:	e8 80 14 00 00       	call   801564 <ipc_send>
  8000e4:	eb c1                	jmp    8000a7 <primeproc+0x74>

008000e6 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ee:	e8 47 11 00 00       	call   80123a <fork>
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	79 20                	jns    800119 <umain+0x33>
		panic("fork: %e", id);
  8000f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fd:	c7 44 24 08 4c 2c 80 	movl   $0x802c4c,0x8(%esp)
  800104:	00 
  800105:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  80010c:	00 
  80010d:	c7 04 24 55 2c 80 00 	movl   $0x802c55,(%esp)
  800114:	e8 94 00 00 00       	call   8001ad <_panic>
	if (id == 0)
  800119:	bb 02 00 00 00       	mov    $0x2,%ebx
  80011e:	85 c0                	test   %eax,%eax
  800120:	75 05                	jne    800127 <umain+0x41>
		primeproc();
  800122:	e8 0c ff ff ff       	call   800033 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  800127:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80012e:	00 
  80012f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800136:	00 
  800137:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80013b:	89 34 24             	mov    %esi,(%esp)
  80013e:	e8 21 14 00 00       	call   801564 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  800143:	83 c3 01             	add    $0x1,%ebx
  800146:	eb df                	jmp    800127 <umain+0x41>

00800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
  80014d:	83 ec 10             	sub    $0x10,%esp
  800150:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800153:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800156:	e8 4a 0b 00 00       	call   800ca5 <sys_getenvid>
  80015b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800160:	89 c2                	mov    %eax,%edx
  800162:	c1 e2 07             	shl    $0x7,%edx
  800165:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80016c:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800171:	85 db                	test   %ebx,%ebx
  800173:	7e 07                	jle    80017c <libmain+0x34>
		binaryname = argv[0];
  800175:	8b 06                	mov    (%esi),%eax
  800177:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80017c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800180:	89 1c 24             	mov    %ebx,(%esp)
  800183:	e8 5e ff ff ff       	call   8000e6 <umain>

	// exit gracefully
	exit();
  800188:	e8 07 00 00 00       	call   800194 <exit>
}
  80018d:	83 c4 10             	add    $0x10,%esp
  800190:	5b                   	pop    %ebx
  800191:	5e                   	pop    %esi
  800192:	5d                   	pop    %ebp
  800193:	c3                   	ret    

00800194 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80019a:	e8 4b 16 00 00       	call   8017ea <close_all>
	sys_env_destroy(0);
  80019f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a6:	e8 a8 0a 00 00       	call   800c53 <sys_env_destroy>
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	56                   	push   %esi
  8001b1:	53                   	push   %ebx
  8001b2:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001b5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001b8:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001be:	e8 e2 0a 00 00       	call   800ca5 <sys_getenvid>
  8001c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8001cd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001d1:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d9:	c7 04 24 70 2c 80 00 	movl   $0x802c70,(%esp)
  8001e0:	e8 c1 00 00 00       	call   8002a6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ec:	89 04 24             	mov    %eax,(%esp)
  8001ef:	e8 51 00 00 00       	call   800245 <vcprintf>
	cprintf("\n");
  8001f4:	c7 04 24 38 32 80 00 	movl   $0x803238,(%esp)
  8001fb:	e8 a6 00 00 00       	call   8002a6 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800200:	cc                   	int3   
  800201:	eb fd                	jmp    800200 <_panic+0x53>

00800203 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	53                   	push   %ebx
  800207:	83 ec 14             	sub    $0x14,%esp
  80020a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80020d:	8b 13                	mov    (%ebx),%edx
  80020f:	8d 42 01             	lea    0x1(%edx),%eax
  800212:	89 03                	mov    %eax,(%ebx)
  800214:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800217:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80021b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800220:	75 19                	jne    80023b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800222:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800229:	00 
  80022a:	8d 43 08             	lea    0x8(%ebx),%eax
  80022d:	89 04 24             	mov    %eax,(%esp)
  800230:	e8 e1 09 00 00       	call   800c16 <sys_cputs>
		b->idx = 0;
  800235:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80023b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80023f:	83 c4 14             	add    $0x14,%esp
  800242:	5b                   	pop    %ebx
  800243:	5d                   	pop    %ebp
  800244:	c3                   	ret    

00800245 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80024e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800255:	00 00 00 
	b.cnt = 0;
  800258:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800262:	8b 45 0c             	mov    0xc(%ebp),%eax
  800265:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800269:	8b 45 08             	mov    0x8(%ebp),%eax
  80026c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800270:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800276:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027a:	c7 04 24 03 02 80 00 	movl   $0x800203,(%esp)
  800281:	e8 a8 01 00 00       	call   80042e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800286:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80028c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800290:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800296:	89 04 24             	mov    %eax,(%esp)
  800299:	e8 78 09 00 00       	call   800c16 <sys_cputs>

	return b.cnt;
}
  80029e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b6:	89 04 24             	mov    %eax,(%esp)
  8002b9:	e8 87 ff ff ff       	call   800245 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	83 ec 3c             	sub    $0x3c,%esp
  8002c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002cc:	89 d7                	mov    %edx,%edi
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 c3                	mov    %eax,%ebx
  8002d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002ed:	39 d9                	cmp    %ebx,%ecx
  8002ef:	72 05                	jb     8002f6 <printnum+0x36>
  8002f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f4:	77 69                	ja     80035f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002fd:	83 ee 01             	sub    $0x1,%esi
  800300:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800304:	89 44 24 08          	mov    %eax,0x8(%esp)
  800308:	8b 44 24 08          	mov    0x8(%esp),%eax
  80030c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800310:	89 c3                	mov    %eax,%ebx
  800312:	89 d6                	mov    %edx,%esi
  800314:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800317:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80031a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80031e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	e8 7c 26 00 00       	call   8029b0 <__udivdi3>
  800334:	89 d9                	mov    %ebx,%ecx
  800336:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80033a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80033e:	89 04 24             	mov    %eax,(%esp)
  800341:	89 54 24 04          	mov    %edx,0x4(%esp)
  800345:	89 fa                	mov    %edi,%edx
  800347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80034a:	e8 71 ff ff ff       	call   8002c0 <printnum>
  80034f:	eb 1b                	jmp    80036c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800351:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800355:	8b 45 18             	mov    0x18(%ebp),%eax
  800358:	89 04 24             	mov    %eax,(%esp)
  80035b:	ff d3                	call   *%ebx
  80035d:	eb 03                	jmp    800362 <printnum+0xa2>
  80035f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800362:	83 ee 01             	sub    $0x1,%esi
  800365:	85 f6                	test   %esi,%esi
  800367:	7f e8                	jg     800351 <printnum+0x91>
  800369:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80036c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800370:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800374:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800377:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80037a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80037e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038f:	e8 4c 27 00 00       	call   802ae0 <__umoddi3>
  800394:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800398:	0f be 80 93 2c 80 00 	movsbl 0x802c93(%eax),%eax
  80039f:	89 04 24             	mov    %eax,(%esp)
  8003a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a5:	ff d0                	call   *%eax
}
  8003a7:	83 c4 3c             	add    $0x3c,%esp
  8003aa:	5b                   	pop    %ebx
  8003ab:	5e                   	pop    %esi
  8003ac:	5f                   	pop    %edi
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003b2:	83 fa 01             	cmp    $0x1,%edx
  8003b5:	7e 0e                	jle    8003c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003b7:	8b 10                	mov    (%eax),%edx
  8003b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003bc:	89 08                	mov    %ecx,(%eax)
  8003be:	8b 02                	mov    (%edx),%eax
  8003c0:	8b 52 04             	mov    0x4(%edx),%edx
  8003c3:	eb 22                	jmp    8003e7 <getuint+0x38>
	else if (lflag)
  8003c5:	85 d2                	test   %edx,%edx
  8003c7:	74 10                	je     8003d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003c9:	8b 10                	mov    (%eax),%edx
  8003cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ce:	89 08                	mov    %ecx,(%eax)
  8003d0:	8b 02                	mov    (%edx),%eax
  8003d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d7:	eb 0e                	jmp    8003e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 02                	mov    (%edx),%eax
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f3:	8b 10                	mov    (%eax),%edx
  8003f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f8:	73 0a                	jae    800404 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003fd:	89 08                	mov    %ecx,(%eax)
  8003ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800402:	88 02                	mov    %al,(%edx)
}
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80040c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800413:	8b 45 10             	mov    0x10(%ebp),%eax
  800416:	89 44 24 08          	mov    %eax,0x8(%esp)
  80041a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	89 04 24             	mov    %eax,(%esp)
  800427:	e8 02 00 00 00       	call   80042e <vprintfmt>
	va_end(ap);
}
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	57                   	push   %edi
  800432:	56                   	push   %esi
  800433:	53                   	push   %ebx
  800434:	83 ec 3c             	sub    $0x3c,%esp
  800437:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80043a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80043d:	eb 14                	jmp    800453 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80043f:	85 c0                	test   %eax,%eax
  800441:	0f 84 b3 03 00 00    	je     8007fa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800447:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80044b:	89 04 24             	mov    %eax,(%esp)
  80044e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800451:	89 f3                	mov    %esi,%ebx
  800453:	8d 73 01             	lea    0x1(%ebx),%esi
  800456:	0f b6 03             	movzbl (%ebx),%eax
  800459:	83 f8 25             	cmp    $0x25,%eax
  80045c:	75 e1                	jne    80043f <vprintfmt+0x11>
  80045e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800462:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800469:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800470:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800477:	ba 00 00 00 00       	mov    $0x0,%edx
  80047c:	eb 1d                	jmp    80049b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800480:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800484:	eb 15                	jmp    80049b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800486:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800488:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80048c:	eb 0d                	jmp    80049b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80048e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800491:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800494:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80049e:	0f b6 0e             	movzbl (%esi),%ecx
  8004a1:	0f b6 c1             	movzbl %cl,%eax
  8004a4:	83 e9 23             	sub    $0x23,%ecx
  8004a7:	80 f9 55             	cmp    $0x55,%cl
  8004aa:	0f 87 2a 03 00 00    	ja     8007da <vprintfmt+0x3ac>
  8004b0:	0f b6 c9             	movzbl %cl,%ecx
  8004b3:	ff 24 8d 00 2e 80 00 	jmp    *0x802e00(,%ecx,4)
  8004ba:	89 de                	mov    %ebx,%esi
  8004bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004c1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004c8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ce:	83 fb 09             	cmp    $0x9,%ebx
  8004d1:	77 36                	ja     800509 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004d6:	eb e9                	jmp    8004c1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	8d 48 04             	lea    0x4(%eax),%ecx
  8004de:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004e8:	eb 22                	jmp    80050c <vprintfmt+0xde>
  8004ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ed:	85 c9                	test   %ecx,%ecx
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	0f 49 c1             	cmovns %ecx,%eax
  8004f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	89 de                	mov    %ebx,%esi
  8004fc:	eb 9d                	jmp    80049b <vprintfmt+0x6d>
  8004fe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800500:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800507:	eb 92                	jmp    80049b <vprintfmt+0x6d>
  800509:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80050c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800510:	79 89                	jns    80049b <vprintfmt+0x6d>
  800512:	e9 77 ff ff ff       	jmp    80048e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800517:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80051c:	e9 7a ff ff ff       	jmp    80049b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8d 50 04             	lea    0x4(%eax),%edx
  800527:	89 55 14             	mov    %edx,0x14(%ebp)
  80052a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 04 24             	mov    %eax,(%esp)
  800533:	ff 55 08             	call   *0x8(%ebp)
			break;
  800536:	e9 18 ff ff ff       	jmp    800453 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 50 04             	lea    0x4(%eax),%edx
  800541:	89 55 14             	mov    %edx,0x14(%ebp)
  800544:	8b 00                	mov    (%eax),%eax
  800546:	99                   	cltd   
  800547:	31 d0                	xor    %edx,%eax
  800549:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054b:	83 f8 12             	cmp    $0x12,%eax
  80054e:	7f 0b                	jg     80055b <vprintfmt+0x12d>
  800550:	8b 14 85 60 2f 80 00 	mov    0x802f60(,%eax,4),%edx
  800557:	85 d2                	test   %edx,%edx
  800559:	75 20                	jne    80057b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80055b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80055f:	c7 44 24 08 ab 2c 80 	movl   $0x802cab,0x8(%esp)
  800566:	00 
  800567:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	e8 90 fe ff ff       	call   800406 <printfmt>
  800576:	e9 d8 fe ff ff       	jmp    800453 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80057b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80057f:	c7 44 24 08 cd 31 80 	movl   $0x8031cd,0x8(%esp)
  800586:	00 
  800587:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	89 04 24             	mov    %eax,(%esp)
  800591:	e8 70 fe ff ff       	call   800406 <printfmt>
  800596:	e9 b8 fe ff ff       	jmp    800453 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80059e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 50 04             	lea    0x4(%eax),%edx
  8005aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005af:	85 f6                	test   %esi,%esi
  8005b1:	b8 a4 2c 80 00       	mov    $0x802ca4,%eax
  8005b6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005bd:	0f 84 97 00 00 00    	je     80065a <vprintfmt+0x22c>
  8005c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005c7:	0f 8e 9b 00 00 00    	jle    800668 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005d1:	89 34 24             	mov    %esi,(%esp)
  8005d4:	e8 cf 02 00 00       	call   8008a8 <strnlen>
  8005d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005dc:	29 c2                	sub    %eax,%edx
  8005de:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005f1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f3:	eb 0f                	jmp    800604 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005fc:	89 04 24             	mov    %eax,(%esp)
  8005ff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800601:	83 eb 01             	sub    $0x1,%ebx
  800604:	85 db                	test   %ebx,%ebx
  800606:	7f ed                	jg     8005f5 <vprintfmt+0x1c7>
  800608:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80060b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80060e:	85 d2                	test   %edx,%edx
  800610:	b8 00 00 00 00       	mov    $0x0,%eax
  800615:	0f 49 c2             	cmovns %edx,%eax
  800618:	29 c2                	sub    %eax,%edx
  80061a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061d:	89 d7                	mov    %edx,%edi
  80061f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800622:	eb 50                	jmp    800674 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800624:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800628:	74 1e                	je     800648 <vprintfmt+0x21a>
  80062a:	0f be d2             	movsbl %dl,%edx
  80062d:	83 ea 20             	sub    $0x20,%edx
  800630:	83 fa 5e             	cmp    $0x5e,%edx
  800633:	76 13                	jbe    800648 <vprintfmt+0x21a>
					putch('?', putdat);
  800635:	8b 45 0c             	mov    0xc(%ebp),%eax
  800638:	89 44 24 04          	mov    %eax,0x4(%esp)
  80063c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800643:	ff 55 08             	call   *0x8(%ebp)
  800646:	eb 0d                	jmp    800655 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80064f:	89 04 24             	mov    %eax,(%esp)
  800652:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800655:	83 ef 01             	sub    $0x1,%edi
  800658:	eb 1a                	jmp    800674 <vprintfmt+0x246>
  80065a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80065d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800660:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800663:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800666:	eb 0c                	jmp    800674 <vprintfmt+0x246>
  800668:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80066b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80066e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800671:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800674:	83 c6 01             	add    $0x1,%esi
  800677:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80067b:	0f be c2             	movsbl %dl,%eax
  80067e:	85 c0                	test   %eax,%eax
  800680:	74 27                	je     8006a9 <vprintfmt+0x27b>
  800682:	85 db                	test   %ebx,%ebx
  800684:	78 9e                	js     800624 <vprintfmt+0x1f6>
  800686:	83 eb 01             	sub    $0x1,%ebx
  800689:	79 99                	jns    800624 <vprintfmt+0x1f6>
  80068b:	89 f8                	mov    %edi,%eax
  80068d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800690:	8b 75 08             	mov    0x8(%ebp),%esi
  800693:	89 c3                	mov    %eax,%ebx
  800695:	eb 1a                	jmp    8006b1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800697:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80069b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006a2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006a4:	83 eb 01             	sub    $0x1,%ebx
  8006a7:	eb 08                	jmp    8006b1 <vprintfmt+0x283>
  8006a9:	89 fb                	mov    %edi,%ebx
  8006ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006b1:	85 db                	test   %ebx,%ebx
  8006b3:	7f e2                	jg     800697 <vprintfmt+0x269>
  8006b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006bb:	e9 93 fd ff ff       	jmp    800453 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006c0:	83 fa 01             	cmp    $0x1,%edx
  8006c3:	7e 16                	jle    8006db <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 50 08             	lea    0x8(%eax),%edx
  8006cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ce:	8b 50 04             	mov    0x4(%eax),%edx
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006d9:	eb 32                	jmp    80070d <vprintfmt+0x2df>
	else if (lflag)
  8006db:	85 d2                	test   %edx,%edx
  8006dd:	74 18                	je     8006f7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 50 04             	lea    0x4(%eax),%edx
  8006e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e8:	8b 30                	mov    (%eax),%esi
  8006ea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006ed:	89 f0                	mov    %esi,%eax
  8006ef:	c1 f8 1f             	sar    $0x1f,%eax
  8006f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f5:	eb 16                	jmp    80070d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8d 50 04             	lea    0x4(%eax),%edx
  8006fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800700:	8b 30                	mov    (%eax),%esi
  800702:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800705:	89 f0                	mov    %esi,%eax
  800707:	c1 f8 1f             	sar    $0x1f,%eax
  80070a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800713:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071c:	0f 89 80 00 00 00    	jns    8007a2 <vprintfmt+0x374>
				putch('-', putdat);
  800722:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800726:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80072d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800733:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800736:	f7 d8                	neg    %eax
  800738:	83 d2 00             	adc    $0x0,%edx
  80073b:	f7 da                	neg    %edx
			}
			base = 10;
  80073d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800742:	eb 5e                	jmp    8007a2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800744:	8d 45 14             	lea    0x14(%ebp),%eax
  800747:	e8 63 fc ff ff       	call   8003af <getuint>
			base = 10;
  80074c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800751:	eb 4f                	jmp    8007a2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800753:	8d 45 14             	lea    0x14(%ebp),%eax
  800756:	e8 54 fc ff ff       	call   8003af <getuint>
			base = 8;
  80075b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800760:	eb 40                	jmp    8007a2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800762:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800766:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80076d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800770:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800774:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80077b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8d 50 04             	lea    0x4(%eax),%edx
  800784:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800787:	8b 00                	mov    (%eax),%eax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80078e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800793:	eb 0d                	jmp    8007a2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800795:	8d 45 14             	lea    0x14(%ebp),%eax
  800798:	e8 12 fc ff ff       	call   8003af <getuint>
			base = 16;
  80079d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007aa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007b5:	89 04 24             	mov    %eax,(%esp)
  8007b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007bc:	89 fa                	mov    %edi,%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	e8 fa fa ff ff       	call   8002c0 <printnum>
			break;
  8007c6:	e9 88 fc ff ff       	jmp    800453 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007cf:	89 04 24             	mov    %eax,(%esp)
  8007d2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007d5:	e9 79 fc ff ff       	jmp    800453 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007de:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007e5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e8:	89 f3                	mov    %esi,%ebx
  8007ea:	eb 03                	jmp    8007ef <vprintfmt+0x3c1>
  8007ec:	83 eb 01             	sub    $0x1,%ebx
  8007ef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007f3:	75 f7                	jne    8007ec <vprintfmt+0x3be>
  8007f5:	e9 59 fc ff ff       	jmp    800453 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007fa:	83 c4 3c             	add    $0x3c,%esp
  8007fd:	5b                   	pop    %ebx
  8007fe:	5e                   	pop    %esi
  8007ff:	5f                   	pop    %edi
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	83 ec 28             	sub    $0x28,%esp
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80080e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800811:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800815:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80081f:	85 c0                	test   %eax,%eax
  800821:	74 30                	je     800853 <vsnprintf+0x51>
  800823:	85 d2                	test   %edx,%edx
  800825:	7e 2c                	jle    800853 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80082e:	8b 45 10             	mov    0x10(%ebp),%eax
  800831:	89 44 24 08          	mov    %eax,0x8(%esp)
  800835:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083c:	c7 04 24 e9 03 80 00 	movl   $0x8003e9,(%esp)
  800843:	e8 e6 fb ff ff       	call   80042e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80084e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800851:	eb 05                	jmp    800858 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800853:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800858:	c9                   	leave  
  800859:	c3                   	ret    

0080085a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800860:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800863:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800871:	89 44 24 04          	mov    %eax,0x4(%esp)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	89 04 24             	mov    %eax,(%esp)
  80087b:	e8 82 ff ff ff       	call   800802 <vsnprintf>
	va_end(ap);

	return rc;
}
  800880:	c9                   	leave  
  800881:	c3                   	ret    
  800882:	66 90                	xchg   %ax,%ax
  800884:	66 90                	xchg   %ax,%ax
  800886:	66 90                	xchg   %ax,%ax
  800888:	66 90                	xchg   %ax,%ax
  80088a:	66 90                	xchg   %ax,%ax
  80088c:	66 90                	xchg   %ax,%ax
  80088e:	66 90                	xchg   %ax,%ax

00800890 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	eb 03                	jmp    8008a0 <strlen+0x10>
		n++;
  80089d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a4:	75 f7                	jne    80089d <strlen+0xd>
		n++;
	return n;
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b6:	eb 03                	jmp    8008bb <strnlen+0x13>
		n++;
  8008b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008bb:	39 d0                	cmp    %edx,%eax
  8008bd:	74 06                	je     8008c5 <strnlen+0x1d>
  8008bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008c3:	75 f3                	jne    8008b8 <strnlen+0x10>
		n++;
	return n;
}
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008d1:	89 c2                	mov    %eax,%edx
  8008d3:	83 c2 01             	add    $0x1,%edx
  8008d6:	83 c1 01             	add    $0x1,%ecx
  8008d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e0:	84 db                	test   %bl,%bl
  8008e2:	75 ef                	jne    8008d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008e4:	5b                   	pop    %ebx
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f1:	89 1c 24             	mov    %ebx,(%esp)
  8008f4:	e8 97 ff ff ff       	call   800890 <strlen>
	strcpy(dst + len, src);
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800900:	01 d8                	add    %ebx,%eax
  800902:	89 04 24             	mov    %eax,(%esp)
  800905:	e8 bd ff ff ff       	call   8008c7 <strcpy>
	return dst;
}
  80090a:	89 d8                	mov    %ebx,%eax
  80090c:	83 c4 08             	add    $0x8,%esp
  80090f:	5b                   	pop    %ebx
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091d:	89 f3                	mov    %esi,%ebx
  80091f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800922:	89 f2                	mov    %esi,%edx
  800924:	eb 0f                	jmp    800935 <strncpy+0x23>
		*dst++ = *src;
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	0f b6 01             	movzbl (%ecx),%eax
  80092c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80092f:	80 39 01             	cmpb   $0x1,(%ecx)
  800932:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800935:	39 da                	cmp    %ebx,%edx
  800937:	75 ed                	jne    800926 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800939:	89 f0                	mov    %esi,%eax
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
  800944:	8b 75 08             	mov    0x8(%ebp),%esi
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80094d:	89 f0                	mov    %esi,%eax
  80094f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800953:	85 c9                	test   %ecx,%ecx
  800955:	75 0b                	jne    800962 <strlcpy+0x23>
  800957:	eb 1d                	jmp    800976 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800959:	83 c0 01             	add    $0x1,%eax
  80095c:	83 c2 01             	add    $0x1,%edx
  80095f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800962:	39 d8                	cmp    %ebx,%eax
  800964:	74 0b                	je     800971 <strlcpy+0x32>
  800966:	0f b6 0a             	movzbl (%edx),%ecx
  800969:	84 c9                	test   %cl,%cl
  80096b:	75 ec                	jne    800959 <strlcpy+0x1a>
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	eb 02                	jmp    800973 <strlcpy+0x34>
  800971:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800973:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800976:	29 f0                	sub    %esi,%eax
}
  800978:	5b                   	pop    %ebx
  800979:	5e                   	pop    %esi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800985:	eb 06                	jmp    80098d <strcmp+0x11>
		p++, q++;
  800987:	83 c1 01             	add    $0x1,%ecx
  80098a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80098d:	0f b6 01             	movzbl (%ecx),%eax
  800990:	84 c0                	test   %al,%al
  800992:	74 04                	je     800998 <strcmp+0x1c>
  800994:	3a 02                	cmp    (%edx),%al
  800996:	74 ef                	je     800987 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 c0             	movzbl %al,%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	89 c3                	mov    %eax,%ebx
  8009ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b1:	eb 06                	jmp    8009b9 <strncmp+0x17>
		n--, p++, q++;
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009b9:	39 d8                	cmp    %ebx,%eax
  8009bb:	74 15                	je     8009d2 <strncmp+0x30>
  8009bd:	0f b6 08             	movzbl (%eax),%ecx
  8009c0:	84 c9                	test   %cl,%cl
  8009c2:	74 04                	je     8009c8 <strncmp+0x26>
  8009c4:	3a 0a                	cmp    (%edx),%cl
  8009c6:	74 eb                	je     8009b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c8:	0f b6 00             	movzbl (%eax),%eax
  8009cb:	0f b6 12             	movzbl (%edx),%edx
  8009ce:	29 d0                	sub    %edx,%eax
  8009d0:	eb 05                	jmp    8009d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	eb 07                	jmp    8009ed <strchr+0x13>
		if (*s == c)
  8009e6:	38 ca                	cmp    %cl,%dl
  8009e8:	74 0f                	je     8009f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ea:	83 c0 01             	add    $0x1,%eax
  8009ed:	0f b6 10             	movzbl (%eax),%edx
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	75 f2                	jne    8009e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a05:	eb 07                	jmp    800a0e <strfind+0x13>
		if (*s == c)
  800a07:	38 ca                	cmp    %cl,%dl
  800a09:	74 0a                	je     800a15 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a0b:	83 c0 01             	add    $0x1,%eax
  800a0e:	0f b6 10             	movzbl (%eax),%edx
  800a11:	84 d2                	test   %dl,%dl
  800a13:	75 f2                	jne    800a07 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	57                   	push   %edi
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a23:	85 c9                	test   %ecx,%ecx
  800a25:	74 36                	je     800a5d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a27:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a2d:	75 28                	jne    800a57 <memset+0x40>
  800a2f:	f6 c1 03             	test   $0x3,%cl
  800a32:	75 23                	jne    800a57 <memset+0x40>
		c &= 0xFF;
  800a34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a38:	89 d3                	mov    %edx,%ebx
  800a3a:	c1 e3 08             	shl    $0x8,%ebx
  800a3d:	89 d6                	mov    %edx,%esi
  800a3f:	c1 e6 18             	shl    $0x18,%esi
  800a42:	89 d0                	mov    %edx,%eax
  800a44:	c1 e0 10             	shl    $0x10,%eax
  800a47:	09 f0                	or     %esi,%eax
  800a49:	09 c2                	or     %eax,%edx
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a4f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a52:	fc                   	cld    
  800a53:	f3 ab                	rep stos %eax,%es:(%edi)
  800a55:	eb 06                	jmp    800a5d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	5b                   	pop    %ebx
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a72:	39 c6                	cmp    %eax,%esi
  800a74:	73 35                	jae    800aab <memmove+0x47>
  800a76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a79:	39 d0                	cmp    %edx,%eax
  800a7b:	73 2e                	jae    800aab <memmove+0x47>
		s += n;
		d += n;
  800a7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a80:	89 d6                	mov    %edx,%esi
  800a82:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8a:	75 13                	jne    800a9f <memmove+0x3b>
  800a8c:	f6 c1 03             	test   $0x3,%cl
  800a8f:	75 0e                	jne    800a9f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a91:	83 ef 04             	sub    $0x4,%edi
  800a94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a9a:	fd                   	std    
  800a9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9d:	eb 09                	jmp    800aa8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9f:	83 ef 01             	sub    $0x1,%edi
  800aa2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800aa5:	fd                   	std    
  800aa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa8:	fc                   	cld    
  800aa9:	eb 1d                	jmp    800ac8 <memmove+0x64>
  800aab:	89 f2                	mov    %esi,%edx
  800aad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaf:	f6 c2 03             	test   $0x3,%dl
  800ab2:	75 0f                	jne    800ac3 <memmove+0x5f>
  800ab4:	f6 c1 03             	test   $0x3,%cl
  800ab7:	75 0a                	jne    800ac3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800abc:	89 c7                	mov    %eax,%edi
  800abe:	fc                   	cld    
  800abf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac1:	eb 05                	jmp    800ac8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac8:	5e                   	pop    %esi
  800ac9:	5f                   	pop    %edi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	89 04 24             	mov    %eax,(%esp)
  800ae6:	e8 79 ff ff ff       	call   800a64 <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af8:	89 d6                	mov    %edx,%esi
  800afa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afd:	eb 1a                	jmp    800b19 <memcmp+0x2c>
		if (*s1 != *s2)
  800aff:	0f b6 02             	movzbl (%edx),%eax
  800b02:	0f b6 19             	movzbl (%ecx),%ebx
  800b05:	38 d8                	cmp    %bl,%al
  800b07:	74 0a                	je     800b13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b09:	0f b6 c0             	movzbl %al,%eax
  800b0c:	0f b6 db             	movzbl %bl,%ebx
  800b0f:	29 d8                	sub    %ebx,%eax
  800b11:	eb 0f                	jmp    800b22 <memcmp+0x35>
		s1++, s2++;
  800b13:	83 c2 01             	add    $0x1,%edx
  800b16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b19:	39 f2                	cmp    %esi,%edx
  800b1b:	75 e2                	jne    800aff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	eb 07                	jmp    800b3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b36:	38 08                	cmp    %cl,(%eax)
  800b38:	74 07                	je     800b41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	39 d0                	cmp    %edx,%eax
  800b3f:	72 f5                	jb     800b36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4f:	eb 03                	jmp    800b54 <strtol+0x11>
		s++;
  800b51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b54:	0f b6 0a             	movzbl (%edx),%ecx
  800b57:	80 f9 09             	cmp    $0x9,%cl
  800b5a:	74 f5                	je     800b51 <strtol+0xe>
  800b5c:	80 f9 20             	cmp    $0x20,%cl
  800b5f:	74 f0                	je     800b51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b61:	80 f9 2b             	cmp    $0x2b,%cl
  800b64:	75 0a                	jne    800b70 <strtol+0x2d>
		s++;
  800b66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b69:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6e:	eb 11                	jmp    800b81 <strtol+0x3e>
  800b70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b75:	80 f9 2d             	cmp    $0x2d,%cl
  800b78:	75 07                	jne    800b81 <strtol+0x3e>
		s++, neg = 1;
  800b7a:	8d 52 01             	lea    0x1(%edx),%edx
  800b7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b86:	75 15                	jne    800b9d <strtol+0x5a>
  800b88:	80 3a 30             	cmpb   $0x30,(%edx)
  800b8b:	75 10                	jne    800b9d <strtol+0x5a>
  800b8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b91:	75 0a                	jne    800b9d <strtol+0x5a>
		s += 2, base = 16;
  800b93:	83 c2 02             	add    $0x2,%edx
  800b96:	b8 10 00 00 00       	mov    $0x10,%eax
  800b9b:	eb 10                	jmp    800bad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b9d:	85 c0                	test   %eax,%eax
  800b9f:	75 0c                	jne    800bad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ba3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ba6:	75 05                	jne    800bad <strtol+0x6a>
		s++, base = 8;
  800ba8:	83 c2 01             	add    $0x1,%edx
  800bab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bb5:	0f b6 0a             	movzbl (%edx),%ecx
  800bb8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bbb:	89 f0                	mov    %esi,%eax
  800bbd:	3c 09                	cmp    $0x9,%al
  800bbf:	77 08                	ja     800bc9 <strtol+0x86>
			dig = *s - '0';
  800bc1:	0f be c9             	movsbl %cl,%ecx
  800bc4:	83 e9 30             	sub    $0x30,%ecx
  800bc7:	eb 20                	jmp    800be9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bc9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bcc:	89 f0                	mov    %esi,%eax
  800bce:	3c 19                	cmp    $0x19,%al
  800bd0:	77 08                	ja     800bda <strtol+0x97>
			dig = *s - 'a' + 10;
  800bd2:	0f be c9             	movsbl %cl,%ecx
  800bd5:	83 e9 57             	sub    $0x57,%ecx
  800bd8:	eb 0f                	jmp    800be9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bda:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bdd:	89 f0                	mov    %esi,%eax
  800bdf:	3c 19                	cmp    $0x19,%al
  800be1:	77 16                	ja     800bf9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800be3:	0f be c9             	movsbl %cl,%ecx
  800be6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800be9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bec:	7d 0f                	jge    800bfd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bf5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bf7:	eb bc                	jmp    800bb5 <strtol+0x72>
  800bf9:	89 d8                	mov    %ebx,%eax
  800bfb:	eb 02                	jmp    800bff <strtol+0xbc>
  800bfd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c03:	74 05                	je     800c0a <strtol+0xc7>
		*endptr = (char *) s;
  800c05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c0a:	f7 d8                	neg    %eax
  800c0c:	85 ff                	test   %edi,%edi
  800c0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	89 c3                	mov    %eax,%ebx
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	89 c6                	mov    %eax,%esi
  800c2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c44:	89 d1                	mov    %edx,%ecx
  800c46:	89 d3                	mov    %edx,%ebx
  800c48:	89 d7                	mov    %edx,%edi
  800c4a:	89 d6                	mov    %edx,%esi
  800c4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c61:	b8 03 00 00 00       	mov    $0x3,%eax
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	89 cb                	mov    %ecx,%ebx
  800c6b:	89 cf                	mov    %ecx,%edi
  800c6d:	89 ce                	mov    %ecx,%esi
  800c6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c71:	85 c0                	test   %eax,%eax
  800c73:	7e 28                	jle    800c9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c80:	00 
  800c81:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800c88:	00 
  800c89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c90:	00 
  800c91:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800c98:	e8 10 f5 ff ff       	call   8001ad <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c9d:	83 c4 2c             	add    $0x2c,%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb5:	89 d1                	mov    %edx,%ecx
  800cb7:	89 d3                	mov    %edx,%ebx
  800cb9:	89 d7                	mov    %edx,%edi
  800cbb:	89 d6                	mov    %edx,%esi
  800cbd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_yield>:

void
sys_yield(void)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd4:	89 d1                	mov    %edx,%ecx
  800cd6:	89 d3                	mov    %edx,%ebx
  800cd8:	89 d7                	mov    %edx,%edi
  800cda:	89 d6                	mov    %edx,%esi
  800cdc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cec:	be 00 00 00 00       	mov    $0x0,%esi
  800cf1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cff:	89 f7                	mov    %esi,%edi
  800d01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7e 28                	jle    800d2f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d12:	00 
  800d13:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800d1a:	00 
  800d1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d22:	00 
  800d23:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800d2a:	e8 7e f4 ff ff       	call   8001ad <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d2f:	83 c4 2c             	add    $0x2c,%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d40:	b8 05 00 00 00       	mov    $0x5,%eax
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d51:	8b 75 18             	mov    0x18(%ebp),%esi
  800d54:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	7e 28                	jle    800d82 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d65:	00 
  800d66:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800d6d:	00 
  800d6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d75:	00 
  800d76:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800d7d:	e8 2b f4 ff ff       	call   8001ad <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d82:	83 c4 2c             	add    $0x2c,%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7e 28                	jle    800dd5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800db8:	00 
  800db9:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800dc0:	00 
  800dc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc8:	00 
  800dc9:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800dd0:	e8 d8 f3 ff ff       	call   8001ad <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd5:	83 c4 2c             	add    $0x2c,%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800deb:	b8 08 00 00 00       	mov    $0x8,%eax
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	89 df                	mov    %ebx,%edi
  800df8:	89 de                	mov    %ebx,%esi
  800dfa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7e 28                	jle    800e28 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e04:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e0b:	00 
  800e0c:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800e13:	00 
  800e14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1b:	00 
  800e1c:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800e23:	e8 85 f3 ff ff       	call   8001ad <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e28:	83 c4 2c             	add    $0x2c,%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
  800e36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	89 df                	mov    %ebx,%edi
  800e4b:	89 de                	mov    %ebx,%esi
  800e4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	7e 28                	jle    800e7b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e57:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800e66:	00 
  800e67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e6e:	00 
  800e6f:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800e76:	e8 32 f3 ff ff       	call   8001ad <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e7b:	83 c4 2c             	add    $0x2c,%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	89 df                	mov    %ebx,%edi
  800e9e:	89 de                	mov    %ebx,%esi
  800ea0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	7e 28                	jle    800ece <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eaa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800eb1:	00 
  800eb2:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800eb9:	00 
  800eba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec1:	00 
  800ec2:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800ec9:	e8 df f2 ff ff       	call   8001ad <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ece:	83 c4 2c             	add    $0x2c,%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edc:	be 00 00 00 00       	mov    $0x0,%esi
  800ee1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eef:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	57                   	push   %edi
  800efd:	56                   	push   %esi
  800efe:	53                   	push   %ebx
  800eff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f07:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	89 cb                	mov    %ecx,%ebx
  800f11:	89 cf                	mov    %ecx,%edi
  800f13:	89 ce                	mov    %ecx,%esi
  800f15:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	7e 28                	jle    800f43 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f26:	00 
  800f27:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800f2e:	00 
  800f2f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f36:	00 
  800f37:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800f3e:	e8 6a f2 ff ff       	call   8001ad <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f43:	83 c4 2c             	add    $0x2c,%esp
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5f                   	pop    %edi
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    

00800f4b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f51:	ba 00 00 00 00       	mov    $0x0,%edx
  800f56:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5b:	89 d1                	mov    %edx,%ecx
  800f5d:	89 d3                	mov    %edx,%ebx
  800f5f:	89 d7                	mov    %edx,%edi
  800f61:	89 d6                	mov    %edx,%esi
  800f63:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f78:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	89 df                	mov    %ebx,%edi
  800f85:	89 de                	mov    %ebx,%esi
  800f87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	7e 28                	jle    800fb5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f91:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f98:	00 
  800f99:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800fa0:	00 
  800fa1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa8:	00 
  800fa9:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  800fb0:	e8 f8 f1 ff ff       	call   8001ad <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800fb5:	83 c4 2c             	add    $0x2c,%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
  800fc3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7e 28                	jle    801008 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800feb:	00 
  800fec:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffb:	00 
  800ffc:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  801003:	e8 a5 f1 ff ff       	call   8001ad <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801008:	83 c4 2c             	add    $0x2c,%esp
  80100b:	5b                   	pop    %ebx
  80100c:	5e                   	pop    %esi
  80100d:	5f                   	pop    %edi
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    

00801010 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	57                   	push   %edi
  801014:	56                   	push   %esi
  801015:	53                   	push   %ebx
  801016:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	b8 11 00 00 00       	mov    $0x11,%eax
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	89 df                	mov    %ebx,%edi
  80102b:	89 de                	mov    %ebx,%esi
  80102d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102f:	85 c0                	test   %eax,%eax
  801031:	7e 28                	jle    80105b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801033:	89 44 24 10          	mov    %eax,0x10(%esp)
  801037:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80103e:	00 
  80103f:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  801046:	00 
  801047:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104e:	00 
  80104f:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  801056:	e8 52 f1 ff ff       	call   8001ad <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80105b:	83 c4 2c             	add    $0x2c,%esp
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <sys_sleep>:

int
sys_sleep(int channel)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	57                   	push   %edi
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
  801069:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801071:	b8 12 00 00 00       	mov    $0x12,%eax
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	89 cb                	mov    %ecx,%ebx
  80107b:	89 cf                	mov    %ecx,%edi
  80107d:	89 ce                	mov    %ecx,%esi
  80107f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801081:	85 c0                	test   %eax,%eax
  801083:	7e 28                	jle    8010ad <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801085:	89 44 24 10          	mov    %eax,0x10(%esp)
  801089:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801090:	00 
  801091:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  801098:	00 
  801099:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a0:	00 
  8010a1:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  8010a8:	e8 00 f1 ff ff       	call   8001ad <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  8010ad:	83 c4 2c             	add    $0x2c,%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
  8010bb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c3:	b8 13 00 00 00       	mov    $0x13,%eax
  8010c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ce:	89 df                	mov    %ebx,%edi
  8010d0:	89 de                	mov    %ebx,%esi
  8010d2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	7e 28                	jle    801100 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010dc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8010e3:	00 
  8010e4:	c7 44 24 08 cb 2f 80 	movl   $0x802fcb,0x8(%esp)
  8010eb:	00 
  8010ec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f3:	00 
  8010f4:	c7 04 24 e8 2f 80 00 	movl   $0x802fe8,(%esp)
  8010fb:	e8 ad f0 ff ff       	call   8001ad <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801100:	83 c4 2c             	add    $0x2c,%esp
  801103:	5b                   	pop    %ebx
  801104:	5e                   	pop    %esi
  801105:	5f                   	pop    %edi
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    

00801108 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	53                   	push   %ebx
  80110c:	83 ec 24             	sub    $0x24,%esp
  80110f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801112:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801114:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801118:	74 27                	je     801141 <pgfault+0x39>
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	c1 ea 16             	shr    $0x16,%edx
  80111f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801126:	f6 c2 01             	test   $0x1,%dl
  801129:	74 16                	je     801141 <pgfault+0x39>
  80112b:	89 c2                	mov    %eax,%edx
  80112d:	c1 ea 0c             	shr    $0xc,%edx
  801130:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801137:	f7 d2                	not    %edx
  801139:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80113f:	74 1c                	je     80115d <pgfault+0x55>
		panic("pgfault");
  801141:	c7 44 24 08 f6 2f 80 	movl   $0x802ff6,0x8(%esp)
  801148:	00 
  801149:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801150:	00 
  801151:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  801158:	e8 50 f0 ff ff       	call   8001ad <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80115d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801162:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801164:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80116b:	00 
  80116c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801173:	00 
  801174:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80117b:	e8 63 fb ff ff       	call   800ce3 <sys_page_alloc>
  801180:	85 c0                	test   %eax,%eax
  801182:	79 1c                	jns    8011a0 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801184:	c7 44 24 08 09 30 80 	movl   $0x803009,0x8(%esp)
  80118b:	00 
  80118c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801193:	00 
  801194:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80119b:	e8 0d f0 ff ff       	call   8001ad <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  8011a0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011a7:	00 
  8011a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011ac:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011b3:	e8 14 f9 ff ff       	call   800acc <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  8011b8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011bf:	00 
  8011c0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011cb:	00 
  8011cc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011d3:	00 
  8011d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011db:	e8 57 fb ff ff       	call   800d37 <sys_page_map>
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	79 1c                	jns    801200 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  8011e4:	c7 44 24 08 23 30 80 	movl   $0x803023,0x8(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8011f3:	00 
  8011f4:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  8011fb:	e8 ad ef ff ff       	call   8001ad <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801200:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801207:	00 
  801208:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80120f:	e8 76 fb ff ff       	call   800d8a <sys_page_unmap>
  801214:	85 c0                	test   %eax,%eax
  801216:	79 1c                	jns    801234 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801218:	c7 44 24 08 3b 30 80 	movl   $0x80303b,0x8(%esp)
  80121f:	00 
  801220:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801227:	00 
  801228:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80122f:	e8 79 ef ff ff       	call   8001ad <_panic>
	}
}
  801234:	83 c4 24             	add    $0x24,%esp
  801237:	5b                   	pop    %ebx
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	57                   	push   %edi
  80123e:	56                   	push   %esi
  80123f:	53                   	push   %ebx
  801240:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801243:	c7 04 24 08 11 80 00 	movl   $0x801108,(%esp)
  80124a:	e8 77 16 00 00       	call   8028c6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80124f:	b8 07 00 00 00       	mov    $0x7,%eax
  801254:	cd 30                	int    $0x30
  801256:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801259:	85 c0                	test   %eax,%eax
  80125b:	79 1c                	jns    801279 <fork+0x3f>
		panic("fork(): sys_exofork");
  80125d:	c7 44 24 08 55 30 80 	movl   $0x803055,0x8(%esp)
  801264:	00 
  801265:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80126c:	00 
  80126d:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  801274:	e8 34 ef ff ff       	call   8001ad <_panic>
  801279:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  80127b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127f:	74 0a                	je     80128b <fork+0x51>
  801281:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801286:	e9 9d 01 00 00       	jmp    801428 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80128b:	e8 15 fa ff ff       	call   800ca5 <sys_getenvid>
  801290:	25 ff 03 00 00       	and    $0x3ff,%eax
  801295:	89 c2                	mov    %eax,%edx
  801297:	c1 e2 07             	shl    $0x7,%edx
  80129a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8012a1:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  8012a6:	e9 2a 02 00 00       	jmp    8014d5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  8012ab:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8012b1:	0f 84 6b 01 00 00    	je     801422 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  8012b7:	89 d8                	mov    %ebx,%eax
  8012b9:	c1 e8 16             	shr    $0x16,%eax
  8012bc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c3:	a8 01                	test   $0x1,%al
  8012c5:	0f 84 57 01 00 00    	je     801422 <fork+0x1e8>
  8012cb:	89 d8                	mov    %ebx,%eax
  8012cd:	c1 e8 0c             	shr    $0xc,%eax
  8012d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d7:	f7 d0                	not    %eax
  8012d9:	a8 05                	test   $0x5,%al
  8012db:	0f 85 41 01 00 00    	jne    801422 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  8012e1:	89 d8                	mov    %ebx,%eax
  8012e3:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  8012e6:	89 c6                	mov    %eax,%esi
  8012e8:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  8012eb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012f2:	f6 c6 04             	test   $0x4,%dh
  8012f5:	74 4c                	je     801343 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  8012f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801303:	89 44 24 10          	mov    %eax,0x10(%esp)
  801307:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80130b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80130f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801313:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80131a:	e8 18 fa ff ff       	call   800d37 <sys_page_map>
  80131f:	85 c0                	test   %eax,%eax
  801321:	0f 89 fb 00 00 00    	jns    801422 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801327:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  80132e:	00 
  80132f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801336:	00 
  801337:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80133e:	e8 6a ee ff ff       	call   8001ad <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801343:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80134a:	f6 c6 08             	test   $0x8,%dh
  80134d:	75 0f                	jne    80135e <fork+0x124>
  80134f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801356:	a8 02                	test   $0x2,%al
  801358:	0f 84 84 00 00 00    	je     8013e2 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80135e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801365:	00 
  801366:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80136a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80136e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801372:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801379:	e8 b9 f9 ff ff       	call   800d37 <sys_page_map>
  80137e:	85 c0                	test   %eax,%eax
  801380:	79 1c                	jns    80139e <fork+0x164>
			panic("duppage: sys_page_map");
  801382:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  801389:	00 
  80138a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801391:	00 
  801392:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  801399:	e8 0f ee ff ff       	call   8001ad <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80139e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013a5:	00 
  8013a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013b1:	00 
  8013b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013bd:	e8 75 f9 ff ff       	call   800d37 <sys_page_map>
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	79 5c                	jns    801422 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8013c6:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  8013cd:	00 
  8013ce:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8013d5:	00 
  8013d6:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  8013dd:	e8 cb ed ff ff       	call   8001ad <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  8013e2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8013e9:	00 
  8013ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fd:	e8 35 f9 ff ff       	call   800d37 <sys_page_map>
  801402:	85 c0                	test   %eax,%eax
  801404:	79 1c                	jns    801422 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801406:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  80140d:	00 
  80140e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801415:	00 
  801416:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80141d:	e8 8b ed ff ff       	call   8001ad <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801422:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801428:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80142e:	0f 85 77 fe ff ff    	jne    8012ab <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801434:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80143b:	00 
  80143c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801443:	ee 
  801444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801447:	89 04 24             	mov    %eax,(%esp)
  80144a:	e8 94 f8 ff ff       	call   800ce3 <sys_page_alloc>
  80144f:	85 c0                	test   %eax,%eax
  801451:	79 1c                	jns    80146f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801453:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  80145a:	00 
  80145b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801462:	00 
  801463:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80146a:	e8 3e ed ff ff       	call   8001ad <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80146f:	c7 44 24 04 4f 29 80 	movl   $0x80294f,0x4(%esp)
  801476:	00 
  801477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147a:	89 04 24             	mov    %eax,(%esp)
  80147d:	e8 01 fa ff ff       	call   800e83 <sys_env_set_pgfault_upcall>
  801482:	85 c0                	test   %eax,%eax
  801484:	79 1c                	jns    8014a2 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801486:	c7 44 24 08 c8 30 80 	movl   $0x8030c8,0x8(%esp)
  80148d:	00 
  80148e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801495:	00 
  801496:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  80149d:	e8 0b ed ff ff       	call   8001ad <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  8014a2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014a9:	00 
  8014aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ad:	89 04 24             	mov    %eax,(%esp)
  8014b0:	e8 28 f9 ff ff       	call   800ddd <sys_env_set_status>
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	79 1c                	jns    8014d5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  8014b9:	c7 44 24 08 96 30 80 	movl   $0x803096,0x8(%esp)
  8014c0:	00 
  8014c1:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  8014c8:	00 
  8014c9:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  8014d0:	e8 d8 ec ff ff       	call   8001ad <_panic>
	}

	return env_id;
}
  8014d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d8:	83 c4 2c             	add    $0x2c,%esp
  8014db:	5b                   	pop    %ebx
  8014dc:	5e                   	pop    %esi
  8014dd:	5f                   	pop    %edi
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    

008014e0 <sfork>:

// Challenge!
int
sfork(void)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8014e6:	c7 44 24 08 b1 30 80 	movl   $0x8030b1,0x8(%esp)
  8014ed:	00 
  8014ee:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8014f5:	00 
  8014f6:	c7 04 24 fe 2f 80 00 	movl   $0x802ffe,(%esp)
  8014fd:	e8 ab ec ff ff       	call   8001ad <_panic>
  801502:	66 90                	xchg   %ax,%ax
  801504:	66 90                	xchg   %ax,%ax
  801506:	66 90                	xchg   %ax,%ax
  801508:	66 90                	xchg   %ax,%ax
  80150a:	66 90                	xchg   %ax,%ax
  80150c:	66 90                	xchg   %ax,%ax
  80150e:	66 90                	xchg   %ax,%ax

00801510 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	56                   	push   %esi
  801514:	53                   	push   %ebx
  801515:	83 ec 10             	sub    $0x10,%esp
  801518:	8b 75 08             	mov    0x8(%ebp),%esi
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801521:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  801523:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801528:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80152b:	89 04 24             	mov    %eax,(%esp)
  80152e:	e8 c6 f9 ff ff       	call   800ef9 <sys_ipc_recv>
  801533:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  801535:	85 d2                	test   %edx,%edx
  801537:	75 24                	jne    80155d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  801539:	85 f6                	test   %esi,%esi
  80153b:	74 0a                	je     801547 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80153d:	a1 08 50 80 00       	mov    0x805008,%eax
  801542:	8b 40 74             	mov    0x74(%eax),%eax
  801545:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  801547:	85 db                	test   %ebx,%ebx
  801549:	74 0a                	je     801555 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80154b:	a1 08 50 80 00       	mov    0x805008,%eax
  801550:	8b 40 78             	mov    0x78(%eax),%eax
  801553:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801555:	a1 08 50 80 00       	mov    0x805008,%eax
  80155a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    

00801564 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	57                   	push   %edi
  801568:	56                   	push   %esi
  801569:	53                   	push   %ebx
  80156a:	83 ec 1c             	sub    $0x1c,%esp
  80156d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801570:	8b 75 0c             	mov    0xc(%ebp),%esi
  801573:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  801576:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  801578:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80157d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801580:	8b 45 14             	mov    0x14(%ebp),%eax
  801583:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801587:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80158b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80158f:	89 3c 24             	mov    %edi,(%esp)
  801592:	e8 3f f9 ff ff       	call   800ed6 <sys_ipc_try_send>

		if (ret == 0)
  801597:	85 c0                	test   %eax,%eax
  801599:	74 2c                	je     8015c7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80159b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80159e:	74 20                	je     8015c0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8015a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015a4:	c7 44 24 08 ec 30 80 	movl   $0x8030ec,0x8(%esp)
  8015ab:	00 
  8015ac:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8015b3:	00 
  8015b4:	c7 04 24 1a 31 80 00 	movl   $0x80311a,(%esp)
  8015bb:	e8 ed eb ff ff       	call   8001ad <_panic>
		}

		sys_yield();
  8015c0:	e8 ff f6 ff ff       	call   800cc4 <sys_yield>
	}
  8015c5:	eb b9                	jmp    801580 <ipc_send+0x1c>
}
  8015c7:	83 c4 1c             	add    $0x1c,%esp
  8015ca:	5b                   	pop    %ebx
  8015cb:	5e                   	pop    %esi
  8015cc:	5f                   	pop    %edi
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015da:	89 c2                	mov    %eax,%edx
  8015dc:	c1 e2 07             	shl    $0x7,%edx
  8015df:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8015e6:	8b 52 50             	mov    0x50(%edx),%edx
  8015e9:	39 ca                	cmp    %ecx,%edx
  8015eb:	75 11                	jne    8015fe <ipc_find_env+0x2f>
			return envs[i].env_id;
  8015ed:	89 c2                	mov    %eax,%edx
  8015ef:	c1 e2 07             	shl    $0x7,%edx
  8015f2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8015f9:	8b 40 40             	mov    0x40(%eax),%eax
  8015fc:	eb 0e                	jmp    80160c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8015fe:	83 c0 01             	add    $0x1,%eax
  801601:	3d 00 04 00 00       	cmp    $0x400,%eax
  801606:	75 d2                	jne    8015da <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801608:	66 b8 00 00          	mov    $0x0,%ax
}
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    
  80160e:	66 90                	xchg   %ax,%ax

00801610 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	05 00 00 00 30       	add    $0x30000000,%eax
  80161b:	c1 e8 0c             	shr    $0xc,%eax
}
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80162b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801630:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    

00801637 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80163d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801642:	89 c2                	mov    %eax,%edx
  801644:	c1 ea 16             	shr    $0x16,%edx
  801647:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80164e:	f6 c2 01             	test   $0x1,%dl
  801651:	74 11                	je     801664 <fd_alloc+0x2d>
  801653:	89 c2                	mov    %eax,%edx
  801655:	c1 ea 0c             	shr    $0xc,%edx
  801658:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165f:	f6 c2 01             	test   $0x1,%dl
  801662:	75 09                	jne    80166d <fd_alloc+0x36>
			*fd_store = fd;
  801664:	89 01                	mov    %eax,(%ecx)
			return 0;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 17                	jmp    801684 <fd_alloc+0x4d>
  80166d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801672:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801677:	75 c9                	jne    801642 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801679:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80167f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801684:	5d                   	pop    %ebp
  801685:	c3                   	ret    

00801686 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80168c:	83 f8 1f             	cmp    $0x1f,%eax
  80168f:	77 36                	ja     8016c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801691:	c1 e0 0c             	shl    $0xc,%eax
  801694:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801699:	89 c2                	mov    %eax,%edx
  80169b:	c1 ea 16             	shr    $0x16,%edx
  80169e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016a5:	f6 c2 01             	test   $0x1,%dl
  8016a8:	74 24                	je     8016ce <fd_lookup+0x48>
  8016aa:	89 c2                	mov    %eax,%edx
  8016ac:	c1 ea 0c             	shr    $0xc,%edx
  8016af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b6:	f6 c2 01             	test   $0x1,%dl
  8016b9:	74 1a                	je     8016d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	89 02                	mov    %eax,(%edx)
	return 0;
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c5:	eb 13                	jmp    8016da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016cc:	eb 0c                	jmp    8016da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d3:	eb 05                	jmp    8016da <fd_lookup+0x54>
  8016d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 18             	sub    $0x18,%esp
  8016e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ea:	eb 13                	jmp    8016ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8016ec:	39 08                	cmp    %ecx,(%eax)
  8016ee:	75 0c                	jne    8016fc <dev_lookup+0x20>
			*dev = devtab[i];
  8016f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fa:	eb 38                	jmp    801734 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016fc:	83 c2 01             	add    $0x1,%edx
  8016ff:	8b 04 95 a0 31 80 00 	mov    0x8031a0(,%edx,4),%eax
  801706:	85 c0                	test   %eax,%eax
  801708:	75 e2                	jne    8016ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80170a:	a1 08 50 80 00       	mov    0x805008,%eax
  80170f:	8b 40 48             	mov    0x48(%eax),%eax
  801712:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171a:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  801721:	e8 80 eb ff ff       	call   8002a6 <cprintf>
	*dev = 0;
  801726:	8b 45 0c             	mov    0xc(%ebp),%eax
  801729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80172f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	83 ec 20             	sub    $0x20,%esp
  80173e:	8b 75 08             	mov    0x8(%ebp),%esi
  801741:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801744:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801747:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80174b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801751:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801754:	89 04 24             	mov    %eax,(%esp)
  801757:	e8 2a ff ff ff       	call   801686 <fd_lookup>
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 05                	js     801765 <fd_close+0x2f>
	    || fd != fd2)
  801760:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801763:	74 0c                	je     801771 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801765:	84 db                	test   %bl,%bl
  801767:	ba 00 00 00 00       	mov    $0x0,%edx
  80176c:	0f 44 c2             	cmove  %edx,%eax
  80176f:	eb 3f                	jmp    8017b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801771:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801774:	89 44 24 04          	mov    %eax,0x4(%esp)
  801778:	8b 06                	mov    (%esi),%eax
  80177a:	89 04 24             	mov    %eax,(%esp)
  80177d:	e8 5a ff ff ff       	call   8016dc <dev_lookup>
  801782:	89 c3                	mov    %eax,%ebx
  801784:	85 c0                	test   %eax,%eax
  801786:	78 16                	js     80179e <fd_close+0x68>
		if (dev->dev_close)
  801788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80178e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801793:	85 c0                	test   %eax,%eax
  801795:	74 07                	je     80179e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801797:	89 34 24             	mov    %esi,(%esp)
  80179a:	ff d0                	call   *%eax
  80179c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80179e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a9:	e8 dc f5 ff ff       	call   800d8a <sys_page_unmap>
	return r;
  8017ae:	89 d8                	mov    %ebx,%eax
}
  8017b0:	83 c4 20             	add    $0x20,%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	89 04 24             	mov    %eax,(%esp)
  8017ca:	e8 b7 fe ff ff       	call   801686 <fd_lookup>
  8017cf:	89 c2                	mov    %eax,%edx
  8017d1:	85 d2                	test   %edx,%edx
  8017d3:	78 13                	js     8017e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8017d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017dc:	00 
  8017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e0:	89 04 24             	mov    %eax,(%esp)
  8017e3:	e8 4e ff ff ff       	call   801736 <fd_close>
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <close_all>:

void
close_all(void)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017f6:	89 1c 24             	mov    %ebx,(%esp)
  8017f9:	e8 b9 ff ff ff       	call   8017b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017fe:	83 c3 01             	add    $0x1,%ebx
  801801:	83 fb 20             	cmp    $0x20,%ebx
  801804:	75 f0                	jne    8017f6 <close_all+0xc>
		close(i);
}
  801806:	83 c4 14             	add    $0x14,%esp
  801809:	5b                   	pop    %ebx
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    

0080180c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	57                   	push   %edi
  801810:	56                   	push   %esi
  801811:	53                   	push   %ebx
  801812:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801815:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	89 04 24             	mov    %eax,(%esp)
  801822:	e8 5f fe ff ff       	call   801686 <fd_lookup>
  801827:	89 c2                	mov    %eax,%edx
  801829:	85 d2                	test   %edx,%edx
  80182b:	0f 88 e1 00 00 00    	js     801912 <dup+0x106>
		return r;
	close(newfdnum);
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	89 04 24             	mov    %eax,(%esp)
  801837:	e8 7b ff ff ff       	call   8017b7 <close>

	newfd = INDEX2FD(newfdnum);
  80183c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80183f:	c1 e3 0c             	shl    $0xc,%ebx
  801842:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184b:	89 04 24             	mov    %eax,(%esp)
  80184e:	e8 cd fd ff ff       	call   801620 <fd2data>
  801853:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801855:	89 1c 24             	mov    %ebx,(%esp)
  801858:	e8 c3 fd ff ff       	call   801620 <fd2data>
  80185d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80185f:	89 f0                	mov    %esi,%eax
  801861:	c1 e8 16             	shr    $0x16,%eax
  801864:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80186b:	a8 01                	test   $0x1,%al
  80186d:	74 43                	je     8018b2 <dup+0xa6>
  80186f:	89 f0                	mov    %esi,%eax
  801871:	c1 e8 0c             	shr    $0xc,%eax
  801874:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80187b:	f6 c2 01             	test   $0x1,%dl
  80187e:	74 32                	je     8018b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801880:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801887:	25 07 0e 00 00       	and    $0xe07,%eax
  80188c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801890:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801894:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80189b:	00 
  80189c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a7:	e8 8b f4 ff ff       	call   800d37 <sys_page_map>
  8018ac:	89 c6                	mov    %eax,%esi
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 3e                	js     8018f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b5:	89 c2                	mov    %eax,%edx
  8018b7:	c1 ea 0c             	shr    $0xc,%edx
  8018ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8018c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8018cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018d6:	00 
  8018d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e2:	e8 50 f4 ff ff       	call   800d37 <sys_page_map>
  8018e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018ec:	85 f6                	test   %esi,%esi
  8018ee:	79 22                	jns    801912 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018fb:	e8 8a f4 ff ff       	call   800d8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801900:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801904:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80190b:	e8 7a f4 ff ff       	call   800d8a <sys_page_unmap>
	return r;
  801910:	89 f0                	mov    %esi,%eax
}
  801912:	83 c4 3c             	add    $0x3c,%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5f                   	pop    %edi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	53                   	push   %ebx
  80191e:	83 ec 24             	sub    $0x24,%esp
  801921:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801924:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	89 1c 24             	mov    %ebx,(%esp)
  80192e:	e8 53 fd ff ff       	call   801686 <fd_lookup>
  801933:	89 c2                	mov    %eax,%edx
  801935:	85 d2                	test   %edx,%edx
  801937:	78 6d                	js     8019a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	8b 00                	mov    (%eax),%eax
  801945:	89 04 24             	mov    %eax,(%esp)
  801948:	e8 8f fd ff ff       	call   8016dc <dev_lookup>
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 55                	js     8019a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	8b 50 08             	mov    0x8(%eax),%edx
  801957:	83 e2 03             	and    $0x3,%edx
  80195a:	83 fa 01             	cmp    $0x1,%edx
  80195d:	75 23                	jne    801982 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80195f:	a1 08 50 80 00       	mov    0x805008,%eax
  801964:	8b 40 48             	mov    0x48(%eax),%eax
  801967:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80196b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196f:	c7 04 24 65 31 80 00 	movl   $0x803165,(%esp)
  801976:	e8 2b e9 ff ff       	call   8002a6 <cprintf>
		return -E_INVAL;
  80197b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801980:	eb 24                	jmp    8019a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801985:	8b 52 08             	mov    0x8(%edx),%edx
  801988:	85 d2                	test   %edx,%edx
  80198a:	74 15                	je     8019a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80198c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801996:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80199a:	89 04 24             	mov    %eax,(%esp)
  80199d:	ff d2                	call   *%edx
  80199f:	eb 05                	jmp    8019a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8019a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8019a6:	83 c4 24             	add    $0x24,%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    

008019ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	57                   	push   %edi
  8019b0:	56                   	push   %esi
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 1c             	sub    $0x1c,%esp
  8019b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c0:	eb 23                	jmp    8019e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019c2:	89 f0                	mov    %esi,%eax
  8019c4:	29 d8                	sub    %ebx,%eax
  8019c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ca:	89 d8                	mov    %ebx,%eax
  8019cc:	03 45 0c             	add    0xc(%ebp),%eax
  8019cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d3:	89 3c 24             	mov    %edi,(%esp)
  8019d6:	e8 3f ff ff ff       	call   80191a <read>
		if (m < 0)
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	78 10                	js     8019ef <readn+0x43>
			return m;
		if (m == 0)
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	74 0a                	je     8019ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019e3:	01 c3                	add    %eax,%ebx
  8019e5:	39 f3                	cmp    %esi,%ebx
  8019e7:	72 d9                	jb     8019c2 <readn+0x16>
  8019e9:	89 d8                	mov    %ebx,%eax
  8019eb:	eb 02                	jmp    8019ef <readn+0x43>
  8019ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8019ef:	83 c4 1c             	add    $0x1c,%esp
  8019f2:	5b                   	pop    %ebx
  8019f3:	5e                   	pop    %esi
  8019f4:	5f                   	pop    %edi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    

008019f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 24             	sub    $0x24,%esp
  8019fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a08:	89 1c 24             	mov    %ebx,(%esp)
  801a0b:	e8 76 fc ff ff       	call   801686 <fd_lookup>
  801a10:	89 c2                	mov    %eax,%edx
  801a12:	85 d2                	test   %edx,%edx
  801a14:	78 68                	js     801a7e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a20:	8b 00                	mov    (%eax),%eax
  801a22:	89 04 24             	mov    %eax,(%esp)
  801a25:	e8 b2 fc ff ff       	call   8016dc <dev_lookup>
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 50                	js     801a7e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a35:	75 23                	jne    801a5a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a37:	a1 08 50 80 00       	mov    0x805008,%eax
  801a3c:	8b 40 48             	mov    0x48(%eax),%eax
  801a3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	c7 04 24 81 31 80 00 	movl   $0x803181,(%esp)
  801a4e:	e8 53 e8 ff ff       	call   8002a6 <cprintf>
		return -E_INVAL;
  801a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a58:	eb 24                	jmp    801a7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a60:	85 d2                	test   %edx,%edx
  801a62:	74 15                	je     801a79 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	ff d2                	call   *%edx
  801a77:	eb 05                	jmp    801a7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a79:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a7e:	83 c4 24             	add    $0x24,%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    

00801a84 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	89 04 24             	mov    %eax,(%esp)
  801a97:	e8 ea fb ff ff       	call   801686 <fd_lookup>
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 0e                	js     801aae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 24             	sub    $0x24,%esp
  801ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac1:	89 1c 24             	mov    %ebx,(%esp)
  801ac4:	e8 bd fb ff ff       	call   801686 <fd_lookup>
  801ac9:	89 c2                	mov    %eax,%edx
  801acb:	85 d2                	test   %edx,%edx
  801acd:	78 61                	js     801b30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801acf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad9:	8b 00                	mov    (%eax),%eax
  801adb:	89 04 24             	mov    %eax,(%esp)
  801ade:	e8 f9 fb ff ff       	call   8016dc <dev_lookup>
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 49                	js     801b30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aee:	75 23                	jne    801b13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801af0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801af5:	8b 40 48             	mov    0x48(%eax),%eax
  801af8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b00:	c7 04 24 44 31 80 00 	movl   $0x803144,(%esp)
  801b07:	e8 9a e7 ff ff       	call   8002a6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b11:	eb 1d                	jmp    801b30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b16:	8b 52 18             	mov    0x18(%edx),%edx
  801b19:	85 d2                	test   %edx,%edx
  801b1b:	74 0e                	je     801b2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b24:	89 04 24             	mov    %eax,(%esp)
  801b27:	ff d2                	call   *%edx
  801b29:	eb 05                	jmp    801b30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b30:	83 c4 24             	add    $0x24,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 24             	sub    $0x24,%esp
  801b3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	89 04 24             	mov    %eax,(%esp)
  801b4d:	e8 34 fb ff ff       	call   801686 <fd_lookup>
  801b52:	89 c2                	mov    %eax,%edx
  801b54:	85 d2                	test   %edx,%edx
  801b56:	78 52                	js     801baa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b62:	8b 00                	mov    (%eax),%eax
  801b64:	89 04 24             	mov    %eax,(%esp)
  801b67:	e8 70 fb ff ff       	call   8016dc <dev_lookup>
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 3a                	js     801baa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b77:	74 2c                	je     801ba5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b83:	00 00 00 
	stat->st_isdir = 0;
  801b86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b8d:	00 00 00 
	stat->st_dev = dev;
  801b90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b9d:	89 14 24             	mov    %edx,(%esp)
  801ba0:	ff 50 14             	call   *0x14(%eax)
  801ba3:	eb 05                	jmp    801baa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ba5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801baa:	83 c4 24             	add    $0x24,%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    

00801bb0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bbf:	00 
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	89 04 24             	mov    %eax,(%esp)
  801bc6:	e8 1b 02 00 00       	call   801de6 <open>
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	85 db                	test   %ebx,%ebx
  801bcf:	78 1b                	js     801bec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd8:	89 1c 24             	mov    %ebx,(%esp)
  801bdb:	e8 56 ff ff ff       	call   801b36 <fstat>
  801be0:	89 c6                	mov    %eax,%esi
	close(fd);
  801be2:	89 1c 24             	mov    %ebx,(%esp)
  801be5:	e8 cd fb ff ff       	call   8017b7 <close>
	return r;
  801bea:	89 f0                	mov    %esi,%eax
}
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 10             	sub    $0x10,%esp
  801bfb:	89 c6                	mov    %eax,%esi
  801bfd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bff:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c06:	75 11                	jne    801c19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c0f:	e8 bb f9 ff ff       	call   8015cf <ipc_find_env>
  801c14:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c20:	00 
  801c21:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c28:	00 
  801c29:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c2d:	a1 00 50 80 00       	mov    0x805000,%eax
  801c32:	89 04 24             	mov    %eax,(%esp)
  801c35:	e8 2a f9 ff ff       	call   801564 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c41:	00 
  801c42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c4d:	e8 be f8 ff ff       	call   801510 <ipc_recv>
}
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	8b 40 0c             	mov    0xc(%eax),%eax
  801c65:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c72:	ba 00 00 00 00       	mov    $0x0,%edx
  801c77:	b8 02 00 00 00       	mov    $0x2,%eax
  801c7c:	e8 72 ff ff ff       	call   801bf3 <fsipc>
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c94:	ba 00 00 00 00       	mov    $0x0,%edx
  801c99:	b8 06 00 00 00       	mov    $0x6,%eax
  801c9e:	e8 50 ff ff ff       	call   801bf3 <fsipc>
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	53                   	push   %ebx
  801ca9:	83 ec 14             	sub    $0x14,%esp
  801cac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cba:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801cc4:	e8 2a ff ff ff       	call   801bf3 <fsipc>
  801cc9:	89 c2                	mov    %eax,%edx
  801ccb:	85 d2                	test   %edx,%edx
  801ccd:	78 2b                	js     801cfa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ccf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cd6:	00 
  801cd7:	89 1c 24             	mov    %ebx,(%esp)
  801cda:	e8 e8 eb ff ff       	call   8008c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cdf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ce4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cea:	a1 84 60 80 00       	mov    0x806084,%eax
  801cef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfa:	83 c4 14             	add    $0x14,%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    

00801d00 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 18             	sub    $0x18,%esp
  801d06:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d09:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0c:	8b 52 0c             	mov    0xc(%edx),%edx
  801d0f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801d15:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d25:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d2c:	e8 9b ed ff ff       	call   800acc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801d31:	ba 00 00 00 00       	mov    $0x0,%edx
  801d36:	b8 04 00 00 00       	mov    $0x4,%eax
  801d3b:	e8 b3 fe ff ff       	call   801bf3 <fsipc>
		return r;
	}

	return r;
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	83 ec 10             	sub    $0x10,%esp
  801d4a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	8b 40 0c             	mov    0xc(%eax),%eax
  801d53:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d58:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d63:	b8 03 00 00 00       	mov    $0x3,%eax
  801d68:	e8 86 fe ff ff       	call   801bf3 <fsipc>
  801d6d:	89 c3                	mov    %eax,%ebx
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	78 6a                	js     801ddd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d73:	39 c6                	cmp    %eax,%esi
  801d75:	73 24                	jae    801d9b <devfile_read+0x59>
  801d77:	c7 44 24 0c b4 31 80 	movl   $0x8031b4,0xc(%esp)
  801d7e:	00 
  801d7f:	c7 44 24 08 bb 31 80 	movl   $0x8031bb,0x8(%esp)
  801d86:	00 
  801d87:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d8e:	00 
  801d8f:	c7 04 24 d0 31 80 00 	movl   $0x8031d0,(%esp)
  801d96:	e8 12 e4 ff ff       	call   8001ad <_panic>
	assert(r <= PGSIZE);
  801d9b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801da0:	7e 24                	jle    801dc6 <devfile_read+0x84>
  801da2:	c7 44 24 0c db 31 80 	movl   $0x8031db,0xc(%esp)
  801da9:	00 
  801daa:	c7 44 24 08 bb 31 80 	movl   $0x8031bb,0x8(%esp)
  801db1:	00 
  801db2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801db9:	00 
  801dba:	c7 04 24 d0 31 80 00 	movl   $0x8031d0,(%esp)
  801dc1:	e8 e7 e3 ff ff       	call   8001ad <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dca:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dd1:	00 
  801dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd5:	89 04 24             	mov    %eax,(%esp)
  801dd8:	e8 87 ec ff ff       	call   800a64 <memmove>
	return r;
}
  801ddd:	89 d8                	mov    %ebx,%eax
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	53                   	push   %ebx
  801dea:	83 ec 24             	sub    $0x24,%esp
  801ded:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801df0:	89 1c 24             	mov    %ebx,(%esp)
  801df3:	e8 98 ea ff ff       	call   800890 <strlen>
  801df8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dfd:	7f 60                	jg     801e5f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e02:	89 04 24             	mov    %eax,(%esp)
  801e05:	e8 2d f8 ff ff       	call   801637 <fd_alloc>
  801e0a:	89 c2                	mov    %eax,%edx
  801e0c:	85 d2                	test   %edx,%edx
  801e0e:	78 54                	js     801e64 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e14:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e1b:	e8 a7 ea ff ff       	call   8008c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e23:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e30:	e8 be fd ff ff       	call   801bf3 <fsipc>
  801e35:	89 c3                	mov    %eax,%ebx
  801e37:	85 c0                	test   %eax,%eax
  801e39:	79 17                	jns    801e52 <open+0x6c>
		fd_close(fd, 0);
  801e3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e42:	00 
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	89 04 24             	mov    %eax,(%esp)
  801e49:	e8 e8 f8 ff ff       	call   801736 <fd_close>
		return r;
  801e4e:	89 d8                	mov    %ebx,%eax
  801e50:	eb 12                	jmp    801e64 <open+0x7e>
	}

	return fd2num(fd);
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	89 04 24             	mov    %eax,(%esp)
  801e58:	e8 b3 f7 ff ff       	call   801610 <fd2num>
  801e5d:	eb 05                	jmp    801e64 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e5f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e64:	83 c4 24             	add    $0x24,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e70:	ba 00 00 00 00       	mov    $0x0,%edx
  801e75:	b8 08 00 00 00       	mov    $0x8,%eax
  801e7a:	e8 74 fd ff ff       	call   801bf3 <fsipc>
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    
  801e81:	66 90                	xchg   %ax,%ax
  801e83:	66 90                	xchg   %ax,%ax
  801e85:	66 90                	xchg   %ax,%ax
  801e87:	66 90                	xchg   %ax,%ax
  801e89:	66 90                	xchg   %ax,%ax
  801e8b:	66 90                	xchg   %ax,%ax
  801e8d:	66 90                	xchg   %ax,%ax
  801e8f:	90                   	nop

00801e90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e96:	c7 44 24 04 e7 31 80 	movl   $0x8031e7,0x4(%esp)
  801e9d:	00 
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 04 24             	mov    %eax,(%esp)
  801ea4:	e8 1e ea ff ff       	call   8008c7 <strcpy>
	return 0;
}
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 14             	sub    $0x14,%esp
  801eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eba:	89 1c 24             	mov    %ebx,(%esp)
  801ebd:	e8 b1 0a 00 00       	call   802973 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801ec2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801ec7:	83 f8 01             	cmp    $0x1,%eax
  801eca:	75 0d                	jne    801ed9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801ecc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ecf:	89 04 24             	mov    %eax,(%esp)
  801ed2:	e8 29 03 00 00       	call   802200 <nsipc_close>
  801ed7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ed9:	89 d0                	mov    %edx,%eax
  801edb:	83 c4 14             	add    $0x14,%esp
  801ede:	5b                   	pop    %ebx
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    

00801ee1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ee7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eee:	00 
  801eef:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	8b 40 0c             	mov    0xc(%eax),%eax
  801f03:	89 04 24             	mov    %eax,(%esp)
  801f06:	e8 f0 03 00 00       	call   8022fb <nsipc_send>
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f13:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f1a:	00 
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2f:	89 04 24             	mov    %eax,(%esp)
  801f32:	e8 44 03 00 00       	call   80227b <nsipc_recv>
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f3f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f42:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f46:	89 04 24             	mov    %eax,(%esp)
  801f49:	e8 38 f7 ff ff       	call   801686 <fd_lookup>
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 17                	js     801f69 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f5b:	39 08                	cmp    %ecx,(%eax)
  801f5d:	75 05                	jne    801f64 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f62:	eb 05                	jmp    801f69 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	56                   	push   %esi
  801f6f:	53                   	push   %ebx
  801f70:	83 ec 20             	sub    $0x20,%esp
  801f73:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f78:	89 04 24             	mov    %eax,(%esp)
  801f7b:	e8 b7 f6 ff ff       	call   801637 <fd_alloc>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	85 c0                	test   %eax,%eax
  801f84:	78 21                	js     801fa7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f8d:	00 
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f9c:	e8 42 ed ff ff       	call   800ce3 <sys_page_alloc>
  801fa1:	89 c3                	mov    %eax,%ebx
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	79 0c                	jns    801fb3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801fa7:	89 34 24             	mov    %esi,(%esp)
  801faa:	e8 51 02 00 00       	call   802200 <nsipc_close>
		return r;
  801faf:	89 d8                	mov    %ebx,%eax
  801fb1:	eb 20                	jmp    801fd3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fb3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801fc8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801fcb:	89 14 24             	mov    %edx,(%esp)
  801fce:	e8 3d f6 ff ff       	call   801610 <fd2num>
}
  801fd3:	83 c4 20             	add    $0x20,%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5e                   	pop    %esi
  801fd8:	5d                   	pop    %ebp
  801fd9:	c3                   	ret    

00801fda <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	e8 51 ff ff ff       	call   801f39 <fd2sockid>
		return r;
  801fe8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fea:	85 c0                	test   %eax,%eax
  801fec:	78 23                	js     802011 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fee:	8b 55 10             	mov    0x10(%ebp),%edx
  801ff1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ffc:	89 04 24             	mov    %eax,(%esp)
  801fff:	e8 45 01 00 00       	call   802149 <nsipc_accept>
		return r;
  802004:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802006:	85 c0                	test   %eax,%eax
  802008:	78 07                	js     802011 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80200a:	e8 5c ff ff ff       	call   801f6b <alloc_sockfd>
  80200f:	89 c1                	mov    %eax,%ecx
}
  802011:	89 c8                	mov    %ecx,%eax
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	e8 16 ff ff ff       	call   801f39 <fd2sockid>
  802023:	89 c2                	mov    %eax,%edx
  802025:	85 d2                	test   %edx,%edx
  802027:	78 16                	js     80203f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802029:	8b 45 10             	mov    0x10(%ebp),%eax
  80202c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802030:	8b 45 0c             	mov    0xc(%ebp),%eax
  802033:	89 44 24 04          	mov    %eax,0x4(%esp)
  802037:	89 14 24             	mov    %edx,(%esp)
  80203a:	e8 60 01 00 00       	call   80219f <nsipc_bind>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <shutdown>:

int
shutdown(int s, int how)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	e8 ea fe ff ff       	call   801f39 <fd2sockid>
  80204f:	89 c2                	mov    %eax,%edx
  802051:	85 d2                	test   %edx,%edx
  802053:	78 0f                	js     802064 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802055:	8b 45 0c             	mov    0xc(%ebp),%eax
  802058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205c:	89 14 24             	mov    %edx,(%esp)
  80205f:	e8 7a 01 00 00       	call   8021de <nsipc_shutdown>
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	e8 c5 fe ff ff       	call   801f39 <fd2sockid>
  802074:	89 c2                	mov    %eax,%edx
  802076:	85 d2                	test   %edx,%edx
  802078:	78 16                	js     802090 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80207a:	8b 45 10             	mov    0x10(%ebp),%eax
  80207d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802081:	8b 45 0c             	mov    0xc(%ebp),%eax
  802084:	89 44 24 04          	mov    %eax,0x4(%esp)
  802088:	89 14 24             	mov    %edx,(%esp)
  80208b:	e8 8a 01 00 00       	call   80221a <nsipc_connect>
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <listen>:

int
listen(int s, int backlog)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	e8 99 fe ff ff       	call   801f39 <fd2sockid>
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	85 d2                	test   %edx,%edx
  8020a4:	78 0f                	js     8020b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ad:	89 14 24             	mov    %edx,(%esp)
  8020b0:	e8 a4 01 00 00       	call   802259 <nsipc_listen>
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	89 04 24             	mov    %eax,(%esp)
  8020d1:	e8 98 02 00 00       	call   80236e <nsipc_socket>
  8020d6:	89 c2                	mov    %eax,%edx
  8020d8:	85 d2                	test   %edx,%edx
  8020da:	78 05                	js     8020e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8020dc:	e8 8a fe ff ff       	call   801f6b <alloc_sockfd>
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	53                   	push   %ebx
  8020e7:	83 ec 14             	sub    $0x14,%esp
  8020ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020ec:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020f3:	75 11                	jne    802106 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020fc:	e8 ce f4 ff ff       	call   8015cf <ipc_find_env>
  802101:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802106:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80210d:	00 
  80210e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802115:	00 
  802116:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80211a:	a1 04 50 80 00       	mov    0x805004,%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 3d f4 ff ff       	call   801564 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802127:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80212e:	00 
  80212f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802136:	00 
  802137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213e:	e8 cd f3 ff ff       	call   801510 <ipc_recv>
}
  802143:	83 c4 14             	add    $0x14,%esp
  802146:	5b                   	pop    %ebx
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    

00802149 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	83 ec 10             	sub    $0x10,%esp
  802151:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80215c:	8b 06                	mov    (%esi),%eax
  80215e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802163:	b8 01 00 00 00       	mov    $0x1,%eax
  802168:	e8 76 ff ff ff       	call   8020e3 <nsipc>
  80216d:	89 c3                	mov    %eax,%ebx
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 23                	js     802196 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802173:	a1 10 70 80 00       	mov    0x807010,%eax
  802178:	89 44 24 08          	mov    %eax,0x8(%esp)
  80217c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802183:	00 
  802184:	8b 45 0c             	mov    0xc(%ebp),%eax
  802187:	89 04 24             	mov    %eax,(%esp)
  80218a:	e8 d5 e8 ff ff       	call   800a64 <memmove>
		*addrlen = ret->ret_addrlen;
  80218f:	a1 10 70 80 00       	mov    0x807010,%eax
  802194:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802196:	89 d8                	mov    %ebx,%eax
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5e                   	pop    %esi
  80219d:	5d                   	pop    %ebp
  80219e:	c3                   	ret    

0080219f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	53                   	push   %ebx
  8021a3:	83 ec 14             	sub    $0x14,%esp
  8021a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021c3:	e8 9c e8 ff ff       	call   800a64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021c8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8021d3:	e8 0b ff ff ff       	call   8020e3 <nsipc>
}
  8021d8:	83 c4 14             	add    $0x14,%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8021f9:	e8 e5 fe ff ff       	call   8020e3 <nsipc>
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <nsipc_close>:

int
nsipc_close(int s)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80220e:	b8 04 00 00 00       	mov    $0x4,%eax
  802213:	e8 cb fe ff ff       	call   8020e3 <nsipc>
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	53                   	push   %ebx
  80221e:	83 ec 14             	sub    $0x14,%esp
  802221:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80222c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802230:	8b 45 0c             	mov    0xc(%ebp),%eax
  802233:	89 44 24 04          	mov    %eax,0x4(%esp)
  802237:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80223e:	e8 21 e8 ff ff       	call   800a64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802243:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802249:	b8 05 00 00 00       	mov    $0x5,%eax
  80224e:	e8 90 fe ff ff       	call   8020e3 <nsipc>
}
  802253:	83 c4 14             	add    $0x14,%esp
  802256:	5b                   	pop    %ebx
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    

00802259 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80226f:	b8 06 00 00 00       	mov    $0x6,%eax
  802274:	e8 6a fe ff ff       	call   8020e3 <nsipc>
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	83 ec 10             	sub    $0x10,%esp
  802283:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80228e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802294:	8b 45 14             	mov    0x14(%ebp),%eax
  802297:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80229c:	b8 07 00 00 00       	mov    $0x7,%eax
  8022a1:	e8 3d fe ff ff       	call   8020e3 <nsipc>
  8022a6:	89 c3                	mov    %eax,%ebx
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	78 46                	js     8022f2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022ac:	39 f0                	cmp    %esi,%eax
  8022ae:	7f 07                	jg     8022b7 <nsipc_recv+0x3c>
  8022b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022b5:	7e 24                	jle    8022db <nsipc_recv+0x60>
  8022b7:	c7 44 24 0c f3 31 80 	movl   $0x8031f3,0xc(%esp)
  8022be:	00 
  8022bf:	c7 44 24 08 bb 31 80 	movl   $0x8031bb,0x8(%esp)
  8022c6:	00 
  8022c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022ce:	00 
  8022cf:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  8022d6:	e8 d2 de ff ff       	call   8001ad <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022df:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022e6:	00 
  8022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ea:	89 04 24             	mov    %eax,(%esp)
  8022ed:	e8 72 e7 ff ff       	call   800a64 <memmove>
	}

	return r;
}
  8022f2:	89 d8                	mov    %ebx,%eax
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	53                   	push   %ebx
  8022ff:	83 ec 14             	sub    $0x14,%esp
  802302:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80230d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802313:	7e 24                	jle    802339 <nsipc_send+0x3e>
  802315:	c7 44 24 0c 14 32 80 	movl   $0x803214,0xc(%esp)
  80231c:	00 
  80231d:	c7 44 24 08 bb 31 80 	movl   $0x8031bb,0x8(%esp)
  802324:	00 
  802325:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80232c:	00 
  80232d:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  802334:	e8 74 de ff ff       	call   8001ad <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802339:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80233d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802340:	89 44 24 04          	mov    %eax,0x4(%esp)
  802344:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80234b:	e8 14 e7 ff ff       	call   800a64 <memmove>
	nsipcbuf.send.req_size = size;
  802350:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802356:	8b 45 14             	mov    0x14(%ebp),%eax
  802359:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80235e:	b8 08 00 00 00       	mov    $0x8,%eax
  802363:	e8 7b fd ff ff       	call   8020e3 <nsipc>
}
  802368:	83 c4 14             	add    $0x14,%esp
  80236b:	5b                   	pop    %ebx
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80237c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802384:	8b 45 10             	mov    0x10(%ebp),%eax
  802387:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80238c:	b8 09 00 00 00       	mov    $0x9,%eax
  802391:	e8 4d fd ff ff       	call   8020e3 <nsipc>
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	56                   	push   %esi
  80239c:	53                   	push   %ebx
  80239d:	83 ec 10             	sub    $0x10,%esp
  8023a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 72 f2 ff ff       	call   801620 <fd2data>
  8023ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023b0:	c7 44 24 04 20 32 80 	movl   $0x803220,0x4(%esp)
  8023b7:	00 
  8023b8:	89 1c 24             	mov    %ebx,(%esp)
  8023bb:	e8 07 e5 ff ff       	call   8008c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023c0:	8b 46 04             	mov    0x4(%esi),%eax
  8023c3:	2b 06                	sub    (%esi),%eax
  8023c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023d2:	00 00 00 
	stat->st_dev = &devpipe;
  8023d5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023dc:	40 80 00 
	return 0;
}
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	83 c4 10             	add    $0x10,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5d                   	pop    %ebp
  8023ea:	c3                   	ret    

008023eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	53                   	push   %ebx
  8023ef:	83 ec 14             	sub    $0x14,%esp
  8023f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802400:	e8 85 e9 ff ff       	call   800d8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802405:	89 1c 24             	mov    %ebx,(%esp)
  802408:	e8 13 f2 ff ff       	call   801620 <fd2data>
  80240d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802411:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802418:	e8 6d e9 ff ff       	call   800d8a <sys_page_unmap>
}
  80241d:	83 c4 14             	add    $0x14,%esp
  802420:	5b                   	pop    %ebx
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    

00802423 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	57                   	push   %edi
  802427:	56                   	push   %esi
  802428:	53                   	push   %ebx
  802429:	83 ec 2c             	sub    $0x2c,%esp
  80242c:	89 c6                	mov    %eax,%esi
  80242e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802431:	a1 08 50 80 00       	mov    0x805008,%eax
  802436:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802439:	89 34 24             	mov    %esi,(%esp)
  80243c:	e8 32 05 00 00       	call   802973 <pageref>
  802441:	89 c7                	mov    %eax,%edi
  802443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 25 05 00 00       	call   802973 <pageref>
  80244e:	39 c7                	cmp    %eax,%edi
  802450:	0f 94 c2             	sete   %dl
  802453:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802456:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80245c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80245f:	39 fb                	cmp    %edi,%ebx
  802461:	74 21                	je     802484 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802463:	84 d2                	test   %dl,%dl
  802465:	74 ca                	je     802431 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802467:	8b 51 58             	mov    0x58(%ecx),%edx
  80246a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80246e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802472:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802476:	c7 04 24 27 32 80 00 	movl   $0x803227,(%esp)
  80247d:	e8 24 de ff ff       	call   8002a6 <cprintf>
  802482:	eb ad                	jmp    802431 <_pipeisclosed+0xe>
	}
}
  802484:	83 c4 2c             	add    $0x2c,%esp
  802487:	5b                   	pop    %ebx
  802488:	5e                   	pop    %esi
  802489:	5f                   	pop    %edi
  80248a:	5d                   	pop    %ebp
  80248b:	c3                   	ret    

0080248c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	57                   	push   %edi
  802490:	56                   	push   %esi
  802491:	53                   	push   %ebx
  802492:	83 ec 1c             	sub    $0x1c,%esp
  802495:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802498:	89 34 24             	mov    %esi,(%esp)
  80249b:	e8 80 f1 ff ff       	call   801620 <fd2data>
  8024a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a7:	eb 45                	jmp    8024ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024a9:	89 da                	mov    %ebx,%edx
  8024ab:	89 f0                	mov    %esi,%eax
  8024ad:	e8 71 ff ff ff       	call   802423 <_pipeisclosed>
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	75 41                	jne    8024f7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024b6:	e8 09 e8 ff ff       	call   800cc4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8024be:	8b 0b                	mov    (%ebx),%ecx
  8024c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024c3:	39 d0                	cmp    %edx,%eax
  8024c5:	73 e2                	jae    8024a9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024d1:	99                   	cltd   
  8024d2:	c1 ea 1b             	shr    $0x1b,%edx
  8024d5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8024d8:	83 e1 1f             	and    $0x1f,%ecx
  8024db:	29 d1                	sub    %edx,%ecx
  8024dd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8024e1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8024e5:	83 c0 01             	add    $0x1,%eax
  8024e8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024eb:	83 c7 01             	add    $0x1,%edi
  8024ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024f1:	75 c8                	jne    8024bb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024f3:	89 f8                	mov    %edi,%eax
  8024f5:	eb 05                	jmp    8024fc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024fc:	83 c4 1c             	add    $0x1c,%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5f                   	pop    %edi
  802502:	5d                   	pop    %ebp
  802503:	c3                   	ret    

00802504 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	57                   	push   %edi
  802508:	56                   	push   %esi
  802509:	53                   	push   %ebx
  80250a:	83 ec 1c             	sub    $0x1c,%esp
  80250d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802510:	89 3c 24             	mov    %edi,(%esp)
  802513:	e8 08 f1 ff ff       	call   801620 <fd2data>
  802518:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80251a:	be 00 00 00 00       	mov    $0x0,%esi
  80251f:	eb 3d                	jmp    80255e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802521:	85 f6                	test   %esi,%esi
  802523:	74 04                	je     802529 <devpipe_read+0x25>
				return i;
  802525:	89 f0                	mov    %esi,%eax
  802527:	eb 43                	jmp    80256c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802529:	89 da                	mov    %ebx,%edx
  80252b:	89 f8                	mov    %edi,%eax
  80252d:	e8 f1 fe ff ff       	call   802423 <_pipeisclosed>
  802532:	85 c0                	test   %eax,%eax
  802534:	75 31                	jne    802567 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802536:	e8 89 e7 ff ff       	call   800cc4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80253b:	8b 03                	mov    (%ebx),%eax
  80253d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802540:	74 df                	je     802521 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802542:	99                   	cltd   
  802543:	c1 ea 1b             	shr    $0x1b,%edx
  802546:	01 d0                	add    %edx,%eax
  802548:	83 e0 1f             	and    $0x1f,%eax
  80254b:	29 d0                	sub    %edx,%eax
  80254d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802552:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802555:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802558:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80255b:	83 c6 01             	add    $0x1,%esi
  80255e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802561:	75 d8                	jne    80253b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802563:	89 f0                	mov    %esi,%eax
  802565:	eb 05                	jmp    80256c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80256c:	83 c4 1c             	add    $0x1c,%esp
  80256f:	5b                   	pop    %ebx
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    

00802574 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	56                   	push   %esi
  802578:	53                   	push   %ebx
  802579:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80257c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257f:	89 04 24             	mov    %eax,(%esp)
  802582:	e8 b0 f0 ff ff       	call   801637 <fd_alloc>
  802587:	89 c2                	mov    %eax,%edx
  802589:	85 d2                	test   %edx,%edx
  80258b:	0f 88 4d 01 00 00    	js     8026de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802591:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802598:	00 
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a7:	e8 37 e7 ff ff       	call   800ce3 <sys_page_alloc>
  8025ac:	89 c2                	mov    %eax,%edx
  8025ae:	85 d2                	test   %edx,%edx
  8025b0:	0f 88 28 01 00 00    	js     8026de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025b9:	89 04 24             	mov    %eax,(%esp)
  8025bc:	e8 76 f0 ff ff       	call   801637 <fd_alloc>
  8025c1:	89 c3                	mov    %eax,%ebx
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	0f 88 fe 00 00 00    	js     8026c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025d2:	00 
  8025d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e1:	e8 fd e6 ff ff       	call   800ce3 <sys_page_alloc>
  8025e6:	89 c3                	mov    %eax,%ebx
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	0f 88 d9 00 00 00    	js     8026c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	89 04 24             	mov    %eax,(%esp)
  8025f6:	e8 25 f0 ff ff       	call   801620 <fd2data>
  8025fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802604:	00 
  802605:	89 44 24 04          	mov    %eax,0x4(%esp)
  802609:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802610:	e8 ce e6 ff ff       	call   800ce3 <sys_page_alloc>
  802615:	89 c3                	mov    %eax,%ebx
  802617:	85 c0                	test   %eax,%eax
  802619:	0f 88 97 00 00 00    	js     8026b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	89 04 24             	mov    %eax,(%esp)
  802625:	e8 f6 ef ff ff       	call   801620 <fd2data>
  80262a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802631:	00 
  802632:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802636:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80263d:	00 
  80263e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802649:	e8 e9 e6 ff ff       	call   800d37 <sys_page_map>
  80264e:	89 c3                	mov    %eax,%ebx
  802650:	85 c0                	test   %eax,%eax
  802652:	78 52                	js     8026a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802654:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802669:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	89 04 24             	mov    %eax,(%esp)
  802684:	e8 87 ef ff ff       	call   801610 <fd2num>
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	89 04 24             	mov    %eax,(%esp)
  802694:	e8 77 ef ff ff       	call   801610 <fd2num>
  802699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80269c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	eb 38                	jmp    8026de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b1:	e8 d4 e6 ff ff       	call   800d8a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c4:	e8 c1 e6 ff ff       	call   800d8a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d7:	e8 ae e6 ff ff       	call   800d8a <sys_page_unmap>
  8026dc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8026de:	83 c4 30             	add    $0x30,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5d                   	pop    %ebp
  8026e4:	c3                   	ret    

008026e5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	89 04 24             	mov    %eax,(%esp)
  8026f8:	e8 89 ef ff ff       	call   801686 <fd_lookup>
  8026fd:	89 c2                	mov    %eax,%edx
  8026ff:	85 d2                	test   %edx,%edx
  802701:	78 15                	js     802718 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	89 04 24             	mov    %eax,(%esp)
  802709:	e8 12 ef ff ff       	call   801620 <fd2data>
	return _pipeisclosed(fd, p);
  80270e:	89 c2                	mov    %eax,%edx
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	e8 0b fd ff ff       	call   802423 <_pipeisclosed>
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    

0080272a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802730:	c7 44 24 04 3f 32 80 	movl   $0x80323f,0x4(%esp)
  802737:	00 
  802738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273b:	89 04 24             	mov    %eax,(%esp)
  80273e:	e8 84 e1 ff ff       	call   8008c7 <strcpy>
	return 0;
}
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	57                   	push   %edi
  80274e:	56                   	push   %esi
  80274f:	53                   	push   %ebx
  802750:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802756:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80275b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802761:	eb 31                	jmp    802794 <devcons_write+0x4a>
		m = n - tot;
  802763:	8b 75 10             	mov    0x10(%ebp),%esi
  802766:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802768:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80276b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802770:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802773:	89 74 24 08          	mov    %esi,0x8(%esp)
  802777:	03 45 0c             	add    0xc(%ebp),%eax
  80277a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277e:	89 3c 24             	mov    %edi,(%esp)
  802781:	e8 de e2 ff ff       	call   800a64 <memmove>
		sys_cputs(buf, m);
  802786:	89 74 24 04          	mov    %esi,0x4(%esp)
  80278a:	89 3c 24             	mov    %edi,(%esp)
  80278d:	e8 84 e4 ff ff       	call   800c16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802792:	01 f3                	add    %esi,%ebx
  802794:	89 d8                	mov    %ebx,%eax
  802796:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802799:	72 c8                	jb     802763 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80279b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    

008027a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027b5:	75 07                	jne    8027be <devcons_read+0x18>
  8027b7:	eb 2a                	jmp    8027e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027b9:	e8 06 e5 ff ff       	call   800cc4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	e8 6f e4 ff ff       	call   800c34 <sys_cgetc>
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 f0                	je     8027b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	78 16                	js     8027e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8027cd:	83 f8 04             	cmp    $0x4,%eax
  8027d0:	74 0c                	je     8027de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8027d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d5:	88 02                	mov    %al,(%edx)
	return 1;
  8027d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027dc:	eb 05                	jmp    8027e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027f8:	00 
  8027f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027fc:	89 04 24             	mov    %eax,(%esp)
  8027ff:	e8 12 e4 ff ff       	call   800c16 <sys_cputs>
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <getchar>:

int
getchar(void)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80280c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802813:	00 
  802814:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802822:	e8 f3 f0 ff ff       	call   80191a <read>
	if (r < 0)
  802827:	85 c0                	test   %eax,%eax
  802829:	78 0f                	js     80283a <getchar+0x34>
		return r;
	if (r < 1)
  80282b:	85 c0                	test   %eax,%eax
  80282d:	7e 06                	jle    802835 <getchar+0x2f>
		return -E_EOF;
	return c;
  80282f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802833:	eb 05                	jmp    80283a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802835:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802842:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802845:	89 44 24 04          	mov    %eax,0x4(%esp)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	89 04 24             	mov    %eax,(%esp)
  80284f:	e8 32 ee ff ff       	call   801686 <fd_lookup>
  802854:	85 c0                	test   %eax,%eax
  802856:	78 11                	js     802869 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802861:	39 10                	cmp    %edx,(%eax)
  802863:	0f 94 c0             	sete   %al
  802866:	0f b6 c0             	movzbl %al,%eax
}
  802869:	c9                   	leave  
  80286a:	c3                   	ret    

0080286b <opencons>:

int
opencons(void)
{
  80286b:	55                   	push   %ebp
  80286c:	89 e5                	mov    %esp,%ebp
  80286e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802871:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802874:	89 04 24             	mov    %eax,(%esp)
  802877:	e8 bb ed ff ff       	call   801637 <fd_alloc>
		return r;
  80287c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80287e:	85 c0                	test   %eax,%eax
  802880:	78 40                	js     8028c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802882:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802889:	00 
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802891:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802898:	e8 46 e4 ff ff       	call   800ce3 <sys_page_alloc>
		return r;
  80289d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	78 1f                	js     8028c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028a3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b8:	89 04 24             	mov    %eax,(%esp)
  8028bb:	e8 50 ed ff ff       	call   801610 <fd2num>
  8028c0:	89 c2                	mov    %eax,%edx
}
  8028c2:	89 d0                	mov    %edx,%eax
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028cc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028d3:	75 70                	jne    802945 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  8028d5:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  8028dc:	00 
  8028dd:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8028e4:	ee 
  8028e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ec:	e8 f2 e3 ff ff       	call   800ce3 <sys_page_alloc>
		if (error < 0)
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	79 1c                	jns    802911 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  8028f5:	c7 44 24 08 4c 32 80 	movl   $0x80324c,0x8(%esp)
  8028fc:	00 
  8028fd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802904:	00 
  802905:	c7 04 24 a0 32 80 00 	movl   $0x8032a0,(%esp)
  80290c:	e8 9c d8 ff ff       	call   8001ad <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802911:	c7 44 24 04 4f 29 80 	movl   $0x80294f,0x4(%esp)
  802918:	00 
  802919:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802920:	e8 5e e5 ff ff       	call   800e83 <sys_env_set_pgfault_upcall>
		if (error < 0)
  802925:	85 c0                	test   %eax,%eax
  802927:	79 1c                	jns    802945 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  802929:	c7 44 24 08 74 32 80 	movl   $0x803274,0x8(%esp)
  802930:	00 
  802931:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802938:	00 
  802939:	c7 04 24 a0 32 80 00 	movl   $0x8032a0,(%esp)
  802940:	e8 68 d8 ff ff       	call   8001ad <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80294d:	c9                   	leave  
  80294e:	c3                   	ret    

0080294f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80294f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802950:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802955:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802957:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  80295a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  80295e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802963:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802967:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802969:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80296c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80296d:	83 c4 04             	add    $0x4,%esp
	popfl
  802970:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802971:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802972:	c3                   	ret    

00802973 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
  802976:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802979:	89 d0                	mov    %edx,%eax
  80297b:	c1 e8 16             	shr    $0x16,%eax
  80297e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802985:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80298a:	f6 c1 01             	test   $0x1,%cl
  80298d:	74 1d                	je     8029ac <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80298f:	c1 ea 0c             	shr    $0xc,%edx
  802992:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802999:	f6 c2 01             	test   $0x1,%dl
  80299c:	74 0e                	je     8029ac <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80299e:	c1 ea 0c             	shr    $0xc,%edx
  8029a1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029a8:	ef 
  8029a9:	0f b7 c0             	movzwl %ax,%eax
}
  8029ac:	5d                   	pop    %ebp
  8029ad:	c3                   	ret    
  8029ae:	66 90                	xchg   %ax,%ax

008029b0 <__udivdi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	83 ec 0c             	sub    $0xc,%esp
  8029b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8029be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8029c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8029cc:	89 ea                	mov    %ebp,%edx
  8029ce:	89 0c 24             	mov    %ecx,(%esp)
  8029d1:	75 2d                	jne    802a00 <__udivdi3+0x50>
  8029d3:	39 e9                	cmp    %ebp,%ecx
  8029d5:	77 61                	ja     802a38 <__udivdi3+0x88>
  8029d7:	85 c9                	test   %ecx,%ecx
  8029d9:	89 ce                	mov    %ecx,%esi
  8029db:	75 0b                	jne    8029e8 <__udivdi3+0x38>
  8029dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e2:	31 d2                	xor    %edx,%edx
  8029e4:	f7 f1                	div    %ecx
  8029e6:	89 c6                	mov    %eax,%esi
  8029e8:	31 d2                	xor    %edx,%edx
  8029ea:	89 e8                	mov    %ebp,%eax
  8029ec:	f7 f6                	div    %esi
  8029ee:	89 c5                	mov    %eax,%ebp
  8029f0:	89 f8                	mov    %edi,%eax
  8029f2:	f7 f6                	div    %esi
  8029f4:	89 ea                	mov    %ebp,%edx
  8029f6:	83 c4 0c             	add    $0xc,%esp
  8029f9:	5e                   	pop    %esi
  8029fa:	5f                   	pop    %edi
  8029fb:	5d                   	pop    %ebp
  8029fc:	c3                   	ret    
  8029fd:	8d 76 00             	lea    0x0(%esi),%esi
  802a00:	39 e8                	cmp    %ebp,%eax
  802a02:	77 24                	ja     802a28 <__udivdi3+0x78>
  802a04:	0f bd e8             	bsr    %eax,%ebp
  802a07:	83 f5 1f             	xor    $0x1f,%ebp
  802a0a:	75 3c                	jne    802a48 <__udivdi3+0x98>
  802a0c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a10:	39 34 24             	cmp    %esi,(%esp)
  802a13:	0f 86 9f 00 00 00    	jbe    802ab8 <__udivdi3+0x108>
  802a19:	39 d0                	cmp    %edx,%eax
  802a1b:	0f 82 97 00 00 00    	jb     802ab8 <__udivdi3+0x108>
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	31 d2                	xor    %edx,%edx
  802a2a:	31 c0                	xor    %eax,%eax
  802a2c:	83 c4 0c             	add    $0xc,%esp
  802a2f:	5e                   	pop    %esi
  802a30:	5f                   	pop    %edi
  802a31:	5d                   	pop    %ebp
  802a32:	c3                   	ret    
  802a33:	90                   	nop
  802a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 f8                	mov    %edi,%eax
  802a3a:	f7 f1                	div    %ecx
  802a3c:	31 d2                	xor    %edx,%edx
  802a3e:	83 c4 0c             	add    $0xc,%esp
  802a41:	5e                   	pop    %esi
  802a42:	5f                   	pop    %edi
  802a43:	5d                   	pop    %ebp
  802a44:	c3                   	ret    
  802a45:	8d 76 00             	lea    0x0(%esi),%esi
  802a48:	89 e9                	mov    %ebp,%ecx
  802a4a:	8b 3c 24             	mov    (%esp),%edi
  802a4d:	d3 e0                	shl    %cl,%eax
  802a4f:	89 c6                	mov    %eax,%esi
  802a51:	b8 20 00 00 00       	mov    $0x20,%eax
  802a56:	29 e8                	sub    %ebp,%eax
  802a58:	89 c1                	mov    %eax,%ecx
  802a5a:	d3 ef                	shr    %cl,%edi
  802a5c:	89 e9                	mov    %ebp,%ecx
  802a5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a62:	8b 3c 24             	mov    (%esp),%edi
  802a65:	09 74 24 08          	or     %esi,0x8(%esp)
  802a69:	89 d6                	mov    %edx,%esi
  802a6b:	d3 e7                	shl    %cl,%edi
  802a6d:	89 c1                	mov    %eax,%ecx
  802a6f:	89 3c 24             	mov    %edi,(%esp)
  802a72:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a76:	d3 ee                	shr    %cl,%esi
  802a78:	89 e9                	mov    %ebp,%ecx
  802a7a:	d3 e2                	shl    %cl,%edx
  802a7c:	89 c1                	mov    %eax,%ecx
  802a7e:	d3 ef                	shr    %cl,%edi
  802a80:	09 d7                	or     %edx,%edi
  802a82:	89 f2                	mov    %esi,%edx
  802a84:	89 f8                	mov    %edi,%eax
  802a86:	f7 74 24 08          	divl   0x8(%esp)
  802a8a:	89 d6                	mov    %edx,%esi
  802a8c:	89 c7                	mov    %eax,%edi
  802a8e:	f7 24 24             	mull   (%esp)
  802a91:	39 d6                	cmp    %edx,%esi
  802a93:	89 14 24             	mov    %edx,(%esp)
  802a96:	72 30                	jb     802ac8 <__udivdi3+0x118>
  802a98:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a9c:	89 e9                	mov    %ebp,%ecx
  802a9e:	d3 e2                	shl    %cl,%edx
  802aa0:	39 c2                	cmp    %eax,%edx
  802aa2:	73 05                	jae    802aa9 <__udivdi3+0xf9>
  802aa4:	3b 34 24             	cmp    (%esp),%esi
  802aa7:	74 1f                	je     802ac8 <__udivdi3+0x118>
  802aa9:	89 f8                	mov    %edi,%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	e9 7a ff ff ff       	jmp    802a2c <__udivdi3+0x7c>
  802ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ab8:	31 d2                	xor    %edx,%edx
  802aba:	b8 01 00 00 00       	mov    $0x1,%eax
  802abf:	e9 68 ff ff ff       	jmp    802a2c <__udivdi3+0x7c>
  802ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	83 c4 0c             	add    $0xc,%esp
  802ad0:	5e                   	pop    %esi
  802ad1:	5f                   	pop    %edi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    
  802ad4:	66 90                	xchg   %ax,%ax
  802ad6:	66 90                	xchg   %ax,%ax
  802ad8:	66 90                	xchg   %ax,%ax
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__umoddi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	83 ec 14             	sub    $0x14,%esp
  802ae6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802aee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802af2:	89 c7                	mov    %eax,%edi
  802af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802afc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b00:	89 34 24             	mov    %esi,(%esp)
  802b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b07:	85 c0                	test   %eax,%eax
  802b09:	89 c2                	mov    %eax,%edx
  802b0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b0f:	75 17                	jne    802b28 <__umoddi3+0x48>
  802b11:	39 fe                	cmp    %edi,%esi
  802b13:	76 4b                	jbe    802b60 <__umoddi3+0x80>
  802b15:	89 c8                	mov    %ecx,%eax
  802b17:	89 fa                	mov    %edi,%edx
  802b19:	f7 f6                	div    %esi
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	31 d2                	xor    %edx,%edx
  802b1f:	83 c4 14             	add    $0x14,%esp
  802b22:	5e                   	pop    %esi
  802b23:	5f                   	pop    %edi
  802b24:	5d                   	pop    %ebp
  802b25:	c3                   	ret    
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	39 f8                	cmp    %edi,%eax
  802b2a:	77 54                	ja     802b80 <__umoddi3+0xa0>
  802b2c:	0f bd e8             	bsr    %eax,%ebp
  802b2f:	83 f5 1f             	xor    $0x1f,%ebp
  802b32:	75 5c                	jne    802b90 <__umoddi3+0xb0>
  802b34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b38:	39 3c 24             	cmp    %edi,(%esp)
  802b3b:	0f 87 e7 00 00 00    	ja     802c28 <__umoddi3+0x148>
  802b41:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b45:	29 f1                	sub    %esi,%ecx
  802b47:	19 c7                	sbb    %eax,%edi
  802b49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b51:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b55:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b59:	83 c4 14             	add    $0x14,%esp
  802b5c:	5e                   	pop    %esi
  802b5d:	5f                   	pop    %edi
  802b5e:	5d                   	pop    %ebp
  802b5f:	c3                   	ret    
  802b60:	85 f6                	test   %esi,%esi
  802b62:	89 f5                	mov    %esi,%ebp
  802b64:	75 0b                	jne    802b71 <__umoddi3+0x91>
  802b66:	b8 01 00 00 00       	mov    $0x1,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	f7 f6                	div    %esi
  802b6f:	89 c5                	mov    %eax,%ebp
  802b71:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b75:	31 d2                	xor    %edx,%edx
  802b77:	f7 f5                	div    %ebp
  802b79:	89 c8                	mov    %ecx,%eax
  802b7b:	f7 f5                	div    %ebp
  802b7d:	eb 9c                	jmp    802b1b <__umoddi3+0x3b>
  802b7f:	90                   	nop
  802b80:	89 c8                	mov    %ecx,%eax
  802b82:	89 fa                	mov    %edi,%edx
  802b84:	83 c4 14             	add    $0x14,%esp
  802b87:	5e                   	pop    %esi
  802b88:	5f                   	pop    %edi
  802b89:	5d                   	pop    %ebp
  802b8a:	c3                   	ret    
  802b8b:	90                   	nop
  802b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b90:	8b 04 24             	mov    (%esp),%eax
  802b93:	be 20 00 00 00       	mov    $0x20,%esi
  802b98:	89 e9                	mov    %ebp,%ecx
  802b9a:	29 ee                	sub    %ebp,%esi
  802b9c:	d3 e2                	shl    %cl,%edx
  802b9e:	89 f1                	mov    %esi,%ecx
  802ba0:	d3 e8                	shr    %cl,%eax
  802ba2:	89 e9                	mov    %ebp,%ecx
  802ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ba8:	8b 04 24             	mov    (%esp),%eax
  802bab:	09 54 24 04          	or     %edx,0x4(%esp)
  802baf:	89 fa                	mov    %edi,%edx
  802bb1:	d3 e0                	shl    %cl,%eax
  802bb3:	89 f1                	mov    %esi,%ecx
  802bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bb9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802bbd:	d3 ea                	shr    %cl,%edx
  802bbf:	89 e9                	mov    %ebp,%ecx
  802bc1:	d3 e7                	shl    %cl,%edi
  802bc3:	89 f1                	mov    %esi,%ecx
  802bc5:	d3 e8                	shr    %cl,%eax
  802bc7:	89 e9                	mov    %ebp,%ecx
  802bc9:	09 f8                	or     %edi,%eax
  802bcb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802bcf:	f7 74 24 04          	divl   0x4(%esp)
  802bd3:	d3 e7                	shl    %cl,%edi
  802bd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bd9:	89 d7                	mov    %edx,%edi
  802bdb:	f7 64 24 08          	mull   0x8(%esp)
  802bdf:	39 d7                	cmp    %edx,%edi
  802be1:	89 c1                	mov    %eax,%ecx
  802be3:	89 14 24             	mov    %edx,(%esp)
  802be6:	72 2c                	jb     802c14 <__umoddi3+0x134>
  802be8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802bec:	72 22                	jb     802c10 <__umoddi3+0x130>
  802bee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802bf2:	29 c8                	sub    %ecx,%eax
  802bf4:	19 d7                	sbb    %edx,%edi
  802bf6:	89 e9                	mov    %ebp,%ecx
  802bf8:	89 fa                	mov    %edi,%edx
  802bfa:	d3 e8                	shr    %cl,%eax
  802bfc:	89 f1                	mov    %esi,%ecx
  802bfe:	d3 e2                	shl    %cl,%edx
  802c00:	89 e9                	mov    %ebp,%ecx
  802c02:	d3 ef                	shr    %cl,%edi
  802c04:	09 d0                	or     %edx,%eax
  802c06:	89 fa                	mov    %edi,%edx
  802c08:	83 c4 14             	add    $0x14,%esp
  802c0b:	5e                   	pop    %esi
  802c0c:	5f                   	pop    %edi
  802c0d:	5d                   	pop    %ebp
  802c0e:	c3                   	ret    
  802c0f:	90                   	nop
  802c10:	39 d7                	cmp    %edx,%edi
  802c12:	75 da                	jne    802bee <__umoddi3+0x10e>
  802c14:	8b 14 24             	mov    (%esp),%edx
  802c17:	89 c1                	mov    %eax,%ecx
  802c19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c21:	eb cb                	jmp    802bee <__umoddi3+0x10e>
  802c23:	90                   	nop
  802c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c2c:	0f 82 0f ff ff ff    	jb     802b41 <__umoddi3+0x61>
  802c32:	e9 1a ff ff ff       	jmp    802b51 <__umoddi3+0x71>
