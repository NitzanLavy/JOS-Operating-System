
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 bb 01 00 00       	call   8001ec <libmain>
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
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	c7 04 24 00 2d 80 00 	movl   $0x802d00,(%esp)
  800043:	e8 02 03 00 00       	call   80034a <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 d1 24 00 00       	call   802524 <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x44>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 4e 2d 80 	movl   $0x802d4e,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 57 2d 80 00 	movl   $0x802d57,(%esp)
  800072:	e8 da 01 00 00       	call   800251 <_panic>
	if ((r = fork()) < 0)
  800077:	e8 6e 12 00 00       	call   8012ea <fork>
  80007c:	89 c7                	mov    %eax,%edi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6f>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 6c 2d 80 	movl   $0x802d6c,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 57 2d 80 00 	movl   $0x802d57,(%esp)
  80009d:	e8 af 01 00 00       	call   800251 <_panic>
	if (r == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	75 75                	jne    80011b <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000a9:	89 04 24             	mov    %eax,(%esp)
  8000ac:	e8 b6 16 00 00       	call   801767 <close>
		for (i = 0; i < 200; i++) {
  8000b1:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (i % 10 == 0)
  8000b6:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	f7 ee                	imul   %esi
  8000bf:	c1 fa 02             	sar    $0x2,%edx
  8000c2:	89 d8                	mov    %ebx,%eax
  8000c4:	c1 f8 1f             	sar    $0x1f,%eax
  8000c7:	29 c2                	sub    %eax,%edx
  8000c9:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cc:	01 c0                	add    %eax,%eax
  8000ce:	39 c3                	cmp    %eax,%ebx
  8000d0:	75 10                	jne    8000e2 <umain+0xaf>
				cprintf("%d.", i);
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	c7 04 24 75 2d 80 00 	movl   $0x802d75,(%esp)
  8000dd:	e8 68 02 00 00       	call   80034a <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000e9:	00 
  8000ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 c7 16 00 00       	call   8017bc <dup>
			sys_yield();
  8000f5:	e8 7a 0c 00 00       	call   800d74 <sys_yield>
			close(10);
  8000fa:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800101:	e8 61 16 00 00       	call   801767 <close>
			sys_yield();
  800106:	e8 69 0c 00 00       	call   800d74 <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010b:	83 c3 01             	add    $0x1,%ebx
  80010e:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800114:	75 a5                	jne    8000bb <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800116:	e8 1d 01 00 00       	call   800238 <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011b:	89 f8                	mov    %edi,%eax
  80011d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	c1 e2 07             	shl    $0x7,%edx
  800127:	8d 9c 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012e:	eb 28                	jmp    800158 <umain+0x125>
		if (pipeisclosed(p[0]) != 0) {
  800130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800133:	89 04 24             	mov    %eax,(%esp)
  800136:	e8 5a 25 00 00       	call   802695 <pipeisclosed>
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 19                	je     800158 <umain+0x125>
			cprintf("\nRACE: pipe appears closed\n");
  80013f:	c7 04 24 79 2d 80 00 	movl   $0x802d79,(%esp)
  800146:	e8 ff 01 00 00       	call   80034a <cprintf>
			sys_env_destroy(r);
  80014b:	89 3c 24             	mov    %edi,(%esp)
  80014e:	e8 b0 0b 00 00       	call   800d03 <sys_env_destroy>
			exit();
  800153:	e8 e0 00 00 00       	call   800238 <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800158:	8b 43 54             	mov    0x54(%ebx),%eax
  80015b:	83 f8 02             	cmp    $0x2,%eax
  80015e:	74 d0                	je     800130 <umain+0xfd>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800160:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  800167:	e8 de 01 00 00       	call   80034a <cprintf>
	if (pipeisclosed(p[0]))
  80016c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016f:	89 04 24             	mov    %eax,(%esp)
  800172:	e8 1e 25 00 00       	call   802695 <pipeisclosed>
  800177:	85 c0                	test   %eax,%eax
  800179:	74 1c                	je     800197 <umain+0x164>
		panic("somehow the other end of p[0] got closed!");
  80017b:	c7 44 24 08 24 2d 80 	movl   $0x802d24,0x8(%esp)
  800182:	00 
  800183:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  80018a:	00 
  80018b:	c7 04 24 57 2d 80 00 	movl   $0x802d57,(%esp)
  800192:	e8 ba 00 00 00       	call   800251 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800197:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a1:	89 04 24             	mov    %eax,(%esp)
  8001a4:	e8 8d 14 00 00       	call   801636 <fd_lookup>
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	79 20                	jns    8001cd <umain+0x19a>
		panic("cannot look up p[0]: %e", r);
  8001ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b1:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  8001b8:	00 
  8001b9:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001c0:	00 
  8001c1:	c7 04 24 57 2d 80 00 	movl   $0x802d57,(%esp)
  8001c8:	e8 84 00 00 00       	call   800251 <_panic>
	(void) fd2data(fd);
  8001cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001d0:	89 04 24             	mov    %eax,(%esp)
  8001d3:	e8 f8 13 00 00       	call   8015d0 <fd2data>
	cprintf("race didn't happen\n");
  8001d8:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  8001df:	e8 66 01 00 00       	call   80034a <cprintf>
}
  8001e4:	83 c4 2c             	add    $0x2c,%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5e                   	pop    %esi
  8001e9:	5f                   	pop    %edi
  8001ea:	5d                   	pop    %ebp
  8001eb:	c3                   	ret    

008001ec <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	56                   	push   %esi
  8001f0:	53                   	push   %ebx
  8001f1:	83 ec 10             	sub    $0x10,%esp
  8001f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8001fa:	e8 56 0b 00 00       	call   800d55 <sys_getenvid>
  8001ff:	25 ff 03 00 00       	and    $0x3ff,%eax
  800204:	89 c2                	mov    %eax,%edx
  800206:	c1 e2 07             	shl    $0x7,%edx
  800209:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800210:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800215:	85 db                	test   %ebx,%ebx
  800217:	7e 07                	jle    800220 <libmain+0x34>
		binaryname = argv[0];
  800219:	8b 06                	mov    (%esi),%eax
  80021b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800220:	89 74 24 04          	mov    %esi,0x4(%esp)
  800224:	89 1c 24             	mov    %ebx,(%esp)
  800227:	e8 07 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80022c:	e8 07 00 00 00       	call   800238 <exit>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	5b                   	pop    %ebx
  800235:	5e                   	pop    %esi
  800236:	5d                   	pop    %ebp
  800237:	c3                   	ret    

00800238 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80023e:	e8 57 15 00 00       	call   80179a <close_all>
	sys_env_destroy(0);
  800243:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80024a:	e8 b4 0a 00 00       	call   800d03 <sys_env_destroy>
}
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800259:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80025c:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800262:	e8 ee 0a 00 00       	call   800d55 <sys_getenvid>
  800267:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80026e:	8b 55 08             	mov    0x8(%ebp),%edx
  800271:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800275:	89 74 24 08          	mov    %esi,0x8(%esp)
  800279:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027d:	c7 04 24 e4 2d 80 00 	movl   $0x802de4,(%esp)
  800284:	e8 c1 00 00 00       	call   80034a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800289:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80028d:	8b 45 10             	mov    0x10(%ebp),%eax
  800290:	89 04 24             	mov    %eax,(%esp)
  800293:	e8 51 00 00 00       	call   8002e9 <vcprintf>
	cprintf("\n");
  800298:	c7 04 24 80 33 80 00 	movl   $0x803380,(%esp)
  80029f:	e8 a6 00 00 00       	call   80034a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a4:	cc                   	int3   
  8002a5:	eb fd                	jmp    8002a4 <_panic+0x53>

008002a7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 14             	sub    $0x14,%esp
  8002ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b1:	8b 13                	mov    (%ebx),%edx
  8002b3:	8d 42 01             	lea    0x1(%edx),%eax
  8002b6:	89 03                	mov    %eax,(%ebx)
  8002b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c4:	75 19                	jne    8002df <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002c6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002cd:	00 
  8002ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d1:	89 04 24             	mov    %eax,(%esp)
  8002d4:	e8 ed 09 00 00       	call   800cc6 <sys_cputs>
		b->idx = 0;
  8002d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002e3:	83 c4 14             	add    $0x14,%esp
  8002e6:	5b                   	pop    %ebx
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f9:	00 00 00 
	b.cnt = 0;
  8002fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800303:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800306:	8b 45 0c             	mov    0xc(%ebp),%eax
  800309:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	89 44 24 08          	mov    %eax,0x8(%esp)
  800314:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031e:	c7 04 24 a7 02 80 00 	movl   $0x8002a7,(%esp)
  800325:	e8 b4 01 00 00       	call   8004de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80032a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800330:	89 44 24 04          	mov    %eax,0x4(%esp)
  800334:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80033a:	89 04 24             	mov    %eax,(%esp)
  80033d:	e8 84 09 00 00       	call   800cc6 <sys_cputs>

	return b.cnt;
}
  800342:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800348:	c9                   	leave  
  800349:	c3                   	ret    

0080034a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800350:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800353:	89 44 24 04          	mov    %eax,0x4(%esp)
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	89 04 24             	mov    %eax,(%esp)
  80035d:	e8 87 ff ff ff       	call   8002e9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800362:	c9                   	leave  
  800363:	c3                   	ret    
  800364:	66 90                	xchg   %ax,%ax
  800366:	66 90                	xchg   %ax,%ax
  800368:	66 90                	xchg   %ax,%ax
  80036a:	66 90                	xchg   %ax,%ax
  80036c:	66 90                	xchg   %ax,%ax
  80036e:	66 90                	xchg   %ax,%ax

00800370 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	57                   	push   %edi
  800374:	56                   	push   %esi
  800375:	53                   	push   %ebx
  800376:	83 ec 3c             	sub    $0x3c,%esp
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037c:	89 d7                	mov    %edx,%edi
  80037e:	8b 45 08             	mov    0x8(%ebp),%eax
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
  800387:	89 c3                	mov    %eax,%ebx
  800389:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800392:	b9 00 00 00 00       	mov    $0x0,%ecx
  800397:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80039d:	39 d9                	cmp    %ebx,%ecx
  80039f:	72 05                	jb     8003a6 <printnum+0x36>
  8003a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003a4:	77 69                	ja     80040f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003ad:	83 ee 01             	sub    $0x1,%esi
  8003b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003c0:	89 c3                	mov    %eax,%ebx
  8003c2:	89 d6                	mov    %edx,%esi
  8003c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d5:	89 04 24             	mov    %eax,(%esp)
  8003d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003df:	e8 8c 26 00 00       	call   802a70 <__udivdi3>
  8003e4:	89 d9                	mov    %ebx,%ecx
  8003e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003ee:	89 04 24             	mov    %eax,(%esp)
  8003f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003f5:	89 fa                	mov    %edi,%edx
  8003f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fa:	e8 71 ff ff ff       	call   800370 <printnum>
  8003ff:	eb 1b                	jmp    80041c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800401:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800405:	8b 45 18             	mov    0x18(%ebp),%eax
  800408:	89 04 24             	mov    %eax,(%esp)
  80040b:	ff d3                	call   *%ebx
  80040d:	eb 03                	jmp    800412 <printnum+0xa2>
  80040f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800412:	83 ee 01             	sub    $0x1,%esi
  800415:	85 f6                	test   %esi,%esi
  800417:	7f e8                	jg     800401 <printnum+0x91>
  800419:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80041c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800420:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800424:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800427:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80042a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80042e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800435:	89 04 24             	mov    %eax,(%esp)
  800438:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043f:	e8 5c 27 00 00       	call   802ba0 <__umoddi3>
  800444:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800448:	0f be 80 07 2e 80 00 	movsbl 0x802e07(%eax),%eax
  80044f:	89 04 24             	mov    %eax,(%esp)
  800452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800455:	ff d0                	call   *%eax
}
  800457:	83 c4 3c             	add    $0x3c,%esp
  80045a:	5b                   	pop    %ebx
  80045b:	5e                   	pop    %esi
  80045c:	5f                   	pop    %edi
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    

0080045f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800462:	83 fa 01             	cmp    $0x1,%edx
  800465:	7e 0e                	jle    800475 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800467:	8b 10                	mov    (%eax),%edx
  800469:	8d 4a 08             	lea    0x8(%edx),%ecx
  80046c:	89 08                	mov    %ecx,(%eax)
  80046e:	8b 02                	mov    (%edx),%eax
  800470:	8b 52 04             	mov    0x4(%edx),%edx
  800473:	eb 22                	jmp    800497 <getuint+0x38>
	else if (lflag)
  800475:	85 d2                	test   %edx,%edx
  800477:	74 10                	je     800489 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80047e:	89 08                	mov    %ecx,(%eax)
  800480:	8b 02                	mov    (%edx),%eax
  800482:	ba 00 00 00 00       	mov    $0x0,%edx
  800487:	eb 0e                	jmp    800497 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800489:	8b 10                	mov    (%eax),%edx
  80048b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80048e:	89 08                	mov    %ecx,(%eax)
  800490:	8b 02                	mov    (%edx),%eax
  800492:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800497:	5d                   	pop    %ebp
  800498:	c3                   	ret    

00800499 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80049f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004a3:	8b 10                	mov    (%eax),%edx
  8004a5:	3b 50 04             	cmp    0x4(%eax),%edx
  8004a8:	73 0a                	jae    8004b4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ad:	89 08                	mov    %ecx,(%eax)
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	88 02                	mov    %al,(%edx)
}
  8004b4:	5d                   	pop    %ebp
  8004b5:	c3                   	ret    

008004b6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004bc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	89 04 24             	mov    %eax,(%esp)
  8004d7:	e8 02 00 00 00       	call   8004de <vprintfmt>
	va_end(ap);
}
  8004dc:	c9                   	leave  
  8004dd:	c3                   	ret    

008004de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	57                   	push   %edi
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	83 ec 3c             	sub    $0x3c,%esp
  8004e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004ed:	eb 14                	jmp    800503 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	0f 84 b3 03 00 00    	je     8008aa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800501:	89 f3                	mov    %esi,%ebx
  800503:	8d 73 01             	lea    0x1(%ebx),%esi
  800506:	0f b6 03             	movzbl (%ebx),%eax
  800509:	83 f8 25             	cmp    $0x25,%eax
  80050c:	75 e1                	jne    8004ef <vprintfmt+0x11>
  80050e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800512:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800519:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800520:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800527:	ba 00 00 00 00       	mov    $0x0,%edx
  80052c:	eb 1d                	jmp    80054b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800530:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800534:	eb 15                	jmp    80054b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800536:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800538:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80053c:	eb 0d                	jmp    80054b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80053e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800541:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800544:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80054e:	0f b6 0e             	movzbl (%esi),%ecx
  800551:	0f b6 c1             	movzbl %cl,%eax
  800554:	83 e9 23             	sub    $0x23,%ecx
  800557:	80 f9 55             	cmp    $0x55,%cl
  80055a:	0f 87 2a 03 00 00    	ja     80088a <vprintfmt+0x3ac>
  800560:	0f b6 c9             	movzbl %cl,%ecx
  800563:	ff 24 8d 80 2f 80 00 	jmp    *0x802f80(,%ecx,4)
  80056a:	89 de                	mov    %ebx,%esi
  80056c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800571:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800574:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800578:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80057b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80057e:	83 fb 09             	cmp    $0x9,%ebx
  800581:	77 36                	ja     8005b9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800583:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800586:	eb e9                	jmp    800571 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8d 48 04             	lea    0x4(%eax),%ecx
  80058e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800596:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800598:	eb 22                	jmp    8005bc <vprintfmt+0xde>
  80059a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80059d:	85 c9                	test   %ecx,%ecx
  80059f:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a4:	0f 49 c1             	cmovns %ecx,%eax
  8005a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	89 de                	mov    %ebx,%esi
  8005ac:	eb 9d                	jmp    80054b <vprintfmt+0x6d>
  8005ae:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005b0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8005b7:	eb 92                	jmp    80054b <vprintfmt+0x6d>
  8005b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8005bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005c0:	79 89                	jns    80054b <vprintfmt+0x6d>
  8005c2:	e9 77 ff ff ff       	jmp    80053e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005cc:	e9 7a ff ff ff       	jmp    80054b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8d 50 04             	lea    0x4(%eax),%edx
  8005d7:	89 55 14             	mov    %edx,0x14(%ebp)
  8005da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	89 04 24             	mov    %eax,(%esp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005e6:	e9 18 ff ff ff       	jmp    800503 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 50 04             	lea    0x4(%eax),%edx
  8005f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	99                   	cltd   
  8005f7:	31 d0                	xor    %edx,%eax
  8005f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005fb:	83 f8 12             	cmp    $0x12,%eax
  8005fe:	7f 0b                	jg     80060b <vprintfmt+0x12d>
  800600:	8b 14 85 e0 30 80 00 	mov    0x8030e0(,%eax,4),%edx
  800607:	85 d2                	test   %edx,%edx
  800609:	75 20                	jne    80062b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80060b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80060f:	c7 44 24 08 1f 2e 80 	movl   $0x802e1f,0x8(%esp)
  800616:	00 
  800617:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	89 04 24             	mov    %eax,(%esp)
  800621:	e8 90 fe ff ff       	call   8004b6 <printfmt>
  800626:	e9 d8 fe ff ff       	jmp    800503 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80062b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80062f:	c7 44 24 08 15 33 80 	movl   $0x803315,0x8(%esp)
  800636:	00 
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	89 04 24             	mov    %eax,(%esp)
  800641:	e8 70 fe ff ff       	call   8004b6 <printfmt>
  800646:	e9 b8 fe ff ff       	jmp    800503 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80064b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80064e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800651:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 50 04             	lea    0x4(%eax),%edx
  80065a:	89 55 14             	mov    %edx,0x14(%ebp)
  80065d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80065f:	85 f6                	test   %esi,%esi
  800661:	b8 18 2e 80 00       	mov    $0x802e18,%eax
  800666:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800669:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80066d:	0f 84 97 00 00 00    	je     80070a <vprintfmt+0x22c>
  800673:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800677:	0f 8e 9b 00 00 00    	jle    800718 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800681:	89 34 24             	mov    %esi,(%esp)
  800684:	e8 cf 02 00 00       	call   800958 <strnlen>
  800689:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80068c:	29 c2                	sub    %eax,%edx
  80068e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800691:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800695:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800698:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80069b:	8b 75 08             	mov    0x8(%ebp),%esi
  80069e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006a1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a3:	eb 0f                	jmp    8006b4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8006a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ac:	89 04 24             	mov    %eax,(%esp)
  8006af:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b1:	83 eb 01             	sub    $0x1,%ebx
  8006b4:	85 db                	test   %ebx,%ebx
  8006b6:	7f ed                	jg     8006a5 <vprintfmt+0x1c7>
  8006b8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006be:	85 d2                	test   %edx,%edx
  8006c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c5:	0f 49 c2             	cmovns %edx,%eax
  8006c8:	29 c2                	sub    %eax,%edx
  8006ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006cd:	89 d7                	mov    %edx,%edi
  8006cf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006d2:	eb 50                	jmp    800724 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d8:	74 1e                	je     8006f8 <vprintfmt+0x21a>
  8006da:	0f be d2             	movsbl %dl,%edx
  8006dd:	83 ea 20             	sub    $0x20,%edx
  8006e0:	83 fa 5e             	cmp    $0x5e,%edx
  8006e3:	76 13                	jbe    8006f8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006f3:	ff 55 08             	call   *0x8(%ebp)
  8006f6:	eb 0d                	jmp    800705 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	83 ef 01             	sub    $0x1,%edi
  800708:	eb 1a                	jmp    800724 <vprintfmt+0x246>
  80070a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80070d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800710:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800713:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800716:	eb 0c                	jmp    800724 <vprintfmt+0x246>
  800718:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80071b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80071e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800721:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800724:	83 c6 01             	add    $0x1,%esi
  800727:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80072b:	0f be c2             	movsbl %dl,%eax
  80072e:	85 c0                	test   %eax,%eax
  800730:	74 27                	je     800759 <vprintfmt+0x27b>
  800732:	85 db                	test   %ebx,%ebx
  800734:	78 9e                	js     8006d4 <vprintfmt+0x1f6>
  800736:	83 eb 01             	sub    $0x1,%ebx
  800739:	79 99                	jns    8006d4 <vprintfmt+0x1f6>
  80073b:	89 f8                	mov    %edi,%eax
  80073d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800740:	8b 75 08             	mov    0x8(%ebp),%esi
  800743:	89 c3                	mov    %eax,%ebx
  800745:	eb 1a                	jmp    800761 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800747:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800752:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800754:	83 eb 01             	sub    $0x1,%ebx
  800757:	eb 08                	jmp    800761 <vprintfmt+0x283>
  800759:	89 fb                	mov    %edi,%ebx
  80075b:	8b 75 08             	mov    0x8(%ebp),%esi
  80075e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800761:	85 db                	test   %ebx,%ebx
  800763:	7f e2                	jg     800747 <vprintfmt+0x269>
  800765:	89 75 08             	mov    %esi,0x8(%ebp)
  800768:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80076b:	e9 93 fd ff ff       	jmp    800503 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800770:	83 fa 01             	cmp    $0x1,%edx
  800773:	7e 16                	jle    80078b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8d 50 08             	lea    0x8(%eax),%edx
  80077b:	89 55 14             	mov    %edx,0x14(%ebp)
  80077e:	8b 50 04             	mov    0x4(%eax),%edx
  800781:	8b 00                	mov    (%eax),%eax
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800786:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800789:	eb 32                	jmp    8007bd <vprintfmt+0x2df>
	else if (lflag)
  80078b:	85 d2                	test   %edx,%edx
  80078d:	74 18                	je     8007a7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	89 55 14             	mov    %edx,0x14(%ebp)
  800798:	8b 30                	mov    (%eax),%esi
  80079a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80079d:	89 f0                	mov    %esi,%eax
  80079f:	c1 f8 1f             	sar    $0x1f,%eax
  8007a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a5:	eb 16                	jmp    8007bd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 50 04             	lea    0x4(%eax),%edx
  8007ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b0:	8b 30                	mov    (%eax),%esi
  8007b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007b5:	89 f0                	mov    %esi,%eax
  8007b7:	c1 f8 1f             	sar    $0x1f,%eax
  8007ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cc:	0f 89 80 00 00 00    	jns    800852 <vprintfmt+0x374>
				putch('-', putdat);
  8007d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007dd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007e6:	f7 d8                	neg    %eax
  8007e8:	83 d2 00             	adc    $0x0,%edx
  8007eb:	f7 da                	neg    %edx
			}
			base = 10;
  8007ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007f2:	eb 5e                	jmp    800852 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f7:	e8 63 fc ff ff       	call   80045f <getuint>
			base = 10;
  8007fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800801:	eb 4f                	jmp    800852 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	e8 54 fc ff ff       	call   80045f <getuint>
			base = 8;
  80080b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800810:	eb 40                	jmp    800852 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800812:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800816:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80081d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800820:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800824:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80082b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8d 50 04             	lea    0x4(%eax),%edx
  800834:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800837:	8b 00                	mov    (%eax),%eax
  800839:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80083e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800843:	eb 0d                	jmp    800852 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800845:	8d 45 14             	lea    0x14(%ebp),%eax
  800848:	e8 12 fc ff ff       	call   80045f <getuint>
			base = 16;
  80084d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800852:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800856:	89 74 24 10          	mov    %esi,0x10(%esp)
  80085a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80085d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800861:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800865:	89 04 24             	mov    %eax,(%esp)
  800868:	89 54 24 04          	mov    %edx,0x4(%esp)
  80086c:	89 fa                	mov    %edi,%edx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	e8 fa fa ff ff       	call   800370 <printnum>
			break;
  800876:	e9 88 fc ff ff       	jmp    800503 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80087b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087f:	89 04 24             	mov    %eax,(%esp)
  800882:	ff 55 08             	call   *0x8(%ebp)
			break;
  800885:	e9 79 fc ff ff       	jmp    800503 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80088a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80088e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800895:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800898:	89 f3                	mov    %esi,%ebx
  80089a:	eb 03                	jmp    80089f <vprintfmt+0x3c1>
  80089c:	83 eb 01             	sub    $0x1,%ebx
  80089f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008a3:	75 f7                	jne    80089c <vprintfmt+0x3be>
  8008a5:	e9 59 fc ff ff       	jmp    800503 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008aa:	83 c4 3c             	add    $0x3c,%esp
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5f                   	pop    %edi
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	83 ec 28             	sub    $0x28,%esp
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	74 30                	je     800903 <vsnprintf+0x51>
  8008d3:	85 d2                	test   %edx,%edx
  8008d5:	7e 2c                	jle    800903 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ec:	c7 04 24 99 04 80 00 	movl   $0x800499,(%esp)
  8008f3:	e8 e6 fb ff ff       	call   8004de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800901:	eb 05                	jmp    800908 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800903:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800910:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800913:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800917:	8b 45 10             	mov    0x10(%ebp),%eax
  80091a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 44 24 04          	mov    %eax,0x4(%esp)
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	89 04 24             	mov    %eax,(%esp)
  80092b:	e8 82 ff ff ff       	call   8008b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800930:	c9                   	leave  
  800931:	c3                   	ret    
  800932:	66 90                	xchg   %ax,%ax
  800934:	66 90                	xchg   %ax,%ax
  800936:	66 90                	xchg   %ax,%ax
  800938:	66 90                	xchg   %ax,%ax
  80093a:	66 90                	xchg   %ax,%ax
  80093c:	66 90                	xchg   %ax,%ax
  80093e:	66 90                	xchg   %ax,%ax

00800940 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	eb 03                	jmp    800950 <strlen+0x10>
		n++;
  80094d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800950:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800954:	75 f7                	jne    80094d <strlen+0xd>
		n++;
	return n;
}
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800961:	b8 00 00 00 00       	mov    $0x0,%eax
  800966:	eb 03                	jmp    80096b <strnlen+0x13>
		n++;
  800968:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096b:	39 d0                	cmp    %edx,%eax
  80096d:	74 06                	je     800975 <strnlen+0x1d>
  80096f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800973:	75 f3                	jne    800968 <strnlen+0x10>
		n++;
	return n;
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800981:	89 c2                	mov    %eax,%edx
  800983:	83 c2 01             	add    $0x1,%edx
  800986:	83 c1 01             	add    $0x1,%ecx
  800989:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80098d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800990:	84 db                	test   %bl,%bl
  800992:	75 ef                	jne    800983 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800994:	5b                   	pop    %ebx
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	53                   	push   %ebx
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009a1:	89 1c 24             	mov    %ebx,(%esp)
  8009a4:	e8 97 ff ff ff       	call   800940 <strlen>
	strcpy(dst + len, src);
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009b0:	01 d8                	add    %ebx,%eax
  8009b2:	89 04 24             	mov    %eax,(%esp)
  8009b5:	e8 bd ff ff ff       	call   800977 <strcpy>
	return dst;
}
  8009ba:	89 d8                	mov    %ebx,%eax
  8009bc:	83 c4 08             	add    $0x8,%esp
  8009bf:	5b                   	pop    %ebx
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	56                   	push   %esi
  8009c6:	53                   	push   %ebx
  8009c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cd:	89 f3                	mov    %esi,%ebx
  8009cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d2:	89 f2                	mov    %esi,%edx
  8009d4:	eb 0f                	jmp    8009e5 <strncpy+0x23>
		*dst++ = *src;
  8009d6:	83 c2 01             	add    $0x1,%edx
  8009d9:	0f b6 01             	movzbl (%ecx),%eax
  8009dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009df:	80 39 01             	cmpb   $0x1,(%ecx)
  8009e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e5:	39 da                	cmp    %ebx,%edx
  8009e7:	75 ed                	jne    8009d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009e9:	89 f0                	mov    %esi,%eax
  8009eb:	5b                   	pop    %ebx
  8009ec:	5e                   	pop    %esi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	56                   	push   %esi
  8009f3:	53                   	push   %ebx
  8009f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009fd:	89 f0                	mov    %esi,%eax
  8009ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a03:	85 c9                	test   %ecx,%ecx
  800a05:	75 0b                	jne    800a12 <strlcpy+0x23>
  800a07:	eb 1d                	jmp    800a26 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	83 c2 01             	add    $0x1,%edx
  800a0f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a12:	39 d8                	cmp    %ebx,%eax
  800a14:	74 0b                	je     800a21 <strlcpy+0x32>
  800a16:	0f b6 0a             	movzbl (%edx),%ecx
  800a19:	84 c9                	test   %cl,%cl
  800a1b:	75 ec                	jne    800a09 <strlcpy+0x1a>
  800a1d:	89 c2                	mov    %eax,%edx
  800a1f:	eb 02                	jmp    800a23 <strlcpy+0x34>
  800a21:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a23:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a26:	29 f0                	sub    %esi,%eax
}
  800a28:	5b                   	pop    %ebx
  800a29:	5e                   	pop    %esi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a32:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a35:	eb 06                	jmp    800a3d <strcmp+0x11>
		p++, q++;
  800a37:	83 c1 01             	add    $0x1,%ecx
  800a3a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a3d:	0f b6 01             	movzbl (%ecx),%eax
  800a40:	84 c0                	test   %al,%al
  800a42:	74 04                	je     800a48 <strcmp+0x1c>
  800a44:	3a 02                	cmp    (%edx),%al
  800a46:	74 ef                	je     800a37 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	0f b6 c0             	movzbl %al,%eax
  800a4b:	0f b6 12             	movzbl (%edx),%edx
  800a4e:	29 d0                	sub    %edx,%eax
}
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5c:	89 c3                	mov    %eax,%ebx
  800a5e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a61:	eb 06                	jmp    800a69 <strncmp+0x17>
		n--, p++, q++;
  800a63:	83 c0 01             	add    $0x1,%eax
  800a66:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a69:	39 d8                	cmp    %ebx,%eax
  800a6b:	74 15                	je     800a82 <strncmp+0x30>
  800a6d:	0f b6 08             	movzbl (%eax),%ecx
  800a70:	84 c9                	test   %cl,%cl
  800a72:	74 04                	je     800a78 <strncmp+0x26>
  800a74:	3a 0a                	cmp    (%edx),%cl
  800a76:	74 eb                	je     800a63 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a78:	0f b6 00             	movzbl (%eax),%eax
  800a7b:	0f b6 12             	movzbl (%edx),%edx
  800a7e:	29 d0                	sub    %edx,%eax
  800a80:	eb 05                	jmp    800a87 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a87:	5b                   	pop    %ebx
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a94:	eb 07                	jmp    800a9d <strchr+0x13>
		if (*s == c)
  800a96:	38 ca                	cmp    %cl,%dl
  800a98:	74 0f                	je     800aa9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	0f b6 10             	movzbl (%eax),%edx
  800aa0:	84 d2                	test   %dl,%dl
  800aa2:	75 f2                	jne    800a96 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab5:	eb 07                	jmp    800abe <strfind+0x13>
		if (*s == c)
  800ab7:	38 ca                	cmp    %cl,%dl
  800ab9:	74 0a                	je     800ac5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800abb:	83 c0 01             	add    $0x1,%eax
  800abe:	0f b6 10             	movzbl (%eax),%edx
  800ac1:	84 d2                	test   %dl,%dl
  800ac3:	75 f2                	jne    800ab7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	57                   	push   %edi
  800acb:	56                   	push   %esi
  800acc:	53                   	push   %ebx
  800acd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad3:	85 c9                	test   %ecx,%ecx
  800ad5:	74 36                	je     800b0d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800add:	75 28                	jne    800b07 <memset+0x40>
  800adf:	f6 c1 03             	test   $0x3,%cl
  800ae2:	75 23                	jne    800b07 <memset+0x40>
		c &= 0xFF;
  800ae4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae8:	89 d3                	mov    %edx,%ebx
  800aea:	c1 e3 08             	shl    $0x8,%ebx
  800aed:	89 d6                	mov    %edx,%esi
  800aef:	c1 e6 18             	shl    $0x18,%esi
  800af2:	89 d0                	mov    %edx,%eax
  800af4:	c1 e0 10             	shl    $0x10,%eax
  800af7:	09 f0                	or     %esi,%eax
  800af9:	09 c2                	or     %eax,%edx
  800afb:	89 d0                	mov    %edx,%eax
  800afd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b02:	fc                   	cld    
  800b03:	f3 ab                	rep stos %eax,%es:(%edi)
  800b05:	eb 06                	jmp    800b0d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	fc                   	cld    
  800b0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0d:	89 f8                	mov    %edi,%eax
  800b0f:	5b                   	pop    %ebx
  800b10:	5e                   	pop    %esi
  800b11:	5f                   	pop    %edi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	57                   	push   %edi
  800b18:	56                   	push   %esi
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b22:	39 c6                	cmp    %eax,%esi
  800b24:	73 35                	jae    800b5b <memmove+0x47>
  800b26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b29:	39 d0                	cmp    %edx,%eax
  800b2b:	73 2e                	jae    800b5b <memmove+0x47>
		s += n;
		d += n;
  800b2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b30:	89 d6                	mov    %edx,%esi
  800b32:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3a:	75 13                	jne    800b4f <memmove+0x3b>
  800b3c:	f6 c1 03             	test   $0x3,%cl
  800b3f:	75 0e                	jne    800b4f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b41:	83 ef 04             	sub    $0x4,%edi
  800b44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b4a:	fd                   	std    
  800b4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4d:	eb 09                	jmp    800b58 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b4f:	83 ef 01             	sub    $0x1,%edi
  800b52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b55:	fd                   	std    
  800b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b58:	fc                   	cld    
  800b59:	eb 1d                	jmp    800b78 <memmove+0x64>
  800b5b:	89 f2                	mov    %esi,%edx
  800b5d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5f:	f6 c2 03             	test   $0x3,%dl
  800b62:	75 0f                	jne    800b73 <memmove+0x5f>
  800b64:	f6 c1 03             	test   $0x3,%cl
  800b67:	75 0a                	jne    800b73 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b69:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b6c:	89 c7                	mov    %eax,%edi
  800b6e:	fc                   	cld    
  800b6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b71:	eb 05                	jmp    800b78 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b73:	89 c7                	mov    %eax,%edi
  800b75:	fc                   	cld    
  800b76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b82:	8b 45 10             	mov    0x10(%ebp),%eax
  800b85:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	89 04 24             	mov    %eax,(%esp)
  800b96:	e8 79 ff ff ff       	call   800b14 <memmove>
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba8:	89 d6                	mov    %edx,%esi
  800baa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bad:	eb 1a                	jmp    800bc9 <memcmp+0x2c>
		if (*s1 != *s2)
  800baf:	0f b6 02             	movzbl (%edx),%eax
  800bb2:	0f b6 19             	movzbl (%ecx),%ebx
  800bb5:	38 d8                	cmp    %bl,%al
  800bb7:	74 0a                	je     800bc3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800bb9:	0f b6 c0             	movzbl %al,%eax
  800bbc:	0f b6 db             	movzbl %bl,%ebx
  800bbf:	29 d8                	sub    %ebx,%eax
  800bc1:	eb 0f                	jmp    800bd2 <memcmp+0x35>
		s1++, s2++;
  800bc3:	83 c2 01             	add    $0x1,%edx
  800bc6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc9:	39 f2                	cmp    %esi,%edx
  800bcb:	75 e2                	jne    800baf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd2:	5b                   	pop    %ebx
  800bd3:	5e                   	pop    %esi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bdf:	89 c2                	mov    %eax,%edx
  800be1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be4:	eb 07                	jmp    800bed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be6:	38 08                	cmp    %cl,(%eax)
  800be8:	74 07                	je     800bf1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	39 d0                	cmp    %edx,%eax
  800bef:	72 f5                	jb     800be6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bff:	eb 03                	jmp    800c04 <strtol+0x11>
		s++;
  800c01:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c04:	0f b6 0a             	movzbl (%edx),%ecx
  800c07:	80 f9 09             	cmp    $0x9,%cl
  800c0a:	74 f5                	je     800c01 <strtol+0xe>
  800c0c:	80 f9 20             	cmp    $0x20,%cl
  800c0f:	74 f0                	je     800c01 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c11:	80 f9 2b             	cmp    $0x2b,%cl
  800c14:	75 0a                	jne    800c20 <strtol+0x2d>
		s++;
  800c16:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c19:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1e:	eb 11                	jmp    800c31 <strtol+0x3e>
  800c20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c25:	80 f9 2d             	cmp    $0x2d,%cl
  800c28:	75 07                	jne    800c31 <strtol+0x3e>
		s++, neg = 1;
  800c2a:	8d 52 01             	lea    0x1(%edx),%edx
  800c2d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c31:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c36:	75 15                	jne    800c4d <strtol+0x5a>
  800c38:	80 3a 30             	cmpb   $0x30,(%edx)
  800c3b:	75 10                	jne    800c4d <strtol+0x5a>
  800c3d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c41:	75 0a                	jne    800c4d <strtol+0x5a>
		s += 2, base = 16;
  800c43:	83 c2 02             	add    $0x2,%edx
  800c46:	b8 10 00 00 00       	mov    $0x10,%eax
  800c4b:	eb 10                	jmp    800c5d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c4d:	85 c0                	test   %eax,%eax
  800c4f:	75 0c                	jne    800c5d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c51:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c53:	80 3a 30             	cmpb   $0x30,(%edx)
  800c56:	75 05                	jne    800c5d <strtol+0x6a>
		s++, base = 8;
  800c58:	83 c2 01             	add    $0x1,%edx
  800c5b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c62:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c65:	0f b6 0a             	movzbl (%edx),%ecx
  800c68:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c6b:	89 f0                	mov    %esi,%eax
  800c6d:	3c 09                	cmp    $0x9,%al
  800c6f:	77 08                	ja     800c79 <strtol+0x86>
			dig = *s - '0';
  800c71:	0f be c9             	movsbl %cl,%ecx
  800c74:	83 e9 30             	sub    $0x30,%ecx
  800c77:	eb 20                	jmp    800c99 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c79:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c7c:	89 f0                	mov    %esi,%eax
  800c7e:	3c 19                	cmp    $0x19,%al
  800c80:	77 08                	ja     800c8a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c82:	0f be c9             	movsbl %cl,%ecx
  800c85:	83 e9 57             	sub    $0x57,%ecx
  800c88:	eb 0f                	jmp    800c99 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c8a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c8d:	89 f0                	mov    %esi,%eax
  800c8f:	3c 19                	cmp    $0x19,%al
  800c91:	77 16                	ja     800ca9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c93:	0f be c9             	movsbl %cl,%ecx
  800c96:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c99:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c9c:	7d 0f                	jge    800cad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ca5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ca7:	eb bc                	jmp    800c65 <strtol+0x72>
  800ca9:	89 d8                	mov    %ebx,%eax
  800cab:	eb 02                	jmp    800caf <strtol+0xbc>
  800cad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800caf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb3:	74 05                	je     800cba <strtol+0xc7>
		*endptr = (char *) s;
  800cb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cba:	f7 d8                	neg    %eax
  800cbc:	85 ff                	test   %edi,%edi
  800cbe:	0f 44 c3             	cmove  %ebx,%eax
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	89 c3                	mov    %eax,%ebx
  800cd9:	89 c7                	mov    %eax,%edi
  800cdb:	89 c6                	mov    %eax,%esi
  800cdd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cea:	ba 00 00 00 00       	mov    $0x0,%edx
  800cef:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf4:	89 d1                	mov    %edx,%ecx
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	89 d7                	mov    %edx,%edi
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d11:	b8 03 00 00 00       	mov    $0x3,%eax
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	89 cb                	mov    %ecx,%ebx
  800d1b:	89 cf                	mov    %ecx,%edi
  800d1d:	89 ce                	mov    %ecx,%esi
  800d1f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d21:	85 c0                	test   %eax,%eax
  800d23:	7e 28                	jle    800d4d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d29:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d30:	00 
  800d31:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  800d38:	00 
  800d39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d40:	00 
  800d41:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  800d48:	e8 04 f5 ff ff       	call   800251 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d4d:	83 c4 2c             	add    $0x2c,%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d60:	b8 02 00 00 00       	mov    $0x2,%eax
  800d65:	89 d1                	mov    %edx,%ecx
  800d67:	89 d3                	mov    %edx,%ebx
  800d69:	89 d7                	mov    %edx,%edi
  800d6b:	89 d6                	mov    %edx,%esi
  800d6d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <sys_yield>:

void
sys_yield(void)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d84:	89 d1                	mov    %edx,%ecx
  800d86:	89 d3                	mov    %edx,%ebx
  800d88:	89 d7                	mov    %edx,%edi
  800d8a:	89 d6                	mov    %edx,%esi
  800d8c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9c:	be 00 00 00 00       	mov    $0x0,%esi
  800da1:	b8 04 00 00 00       	mov    $0x4,%eax
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800daf:	89 f7                	mov    %esi,%edi
  800db1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db3:	85 c0                	test   %eax,%eax
  800db5:	7e 28                	jle    800ddf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dbb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800dc2:	00 
  800dc3:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  800dca:	00 
  800dcb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd2:	00 
  800dd3:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  800dda:	e8 72 f4 ff ff       	call   800251 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ddf:	83 c4 2c             	add    $0x2c,%esp
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
  800ded:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df0:	b8 05 00 00 00       	mov    $0x5,%eax
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e01:	8b 75 18             	mov    0x18(%ebp),%esi
  800e04:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7e 28                	jle    800e32 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e15:	00 
  800e16:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  800e1d:	00 
  800e1e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e25:	00 
  800e26:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  800e2d:	e8 1f f4 ff ff       	call   800251 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e32:	83 c4 2c             	add    $0x2c,%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e48:	b8 06 00 00 00       	mov    $0x6,%eax
  800e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	89 df                	mov    %ebx,%edi
  800e55:	89 de                	mov    %ebx,%esi
  800e57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	7e 28                	jle    800e85 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e61:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e68:	00 
  800e69:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  800e70:	00 
  800e71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e78:	00 
  800e79:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  800e80:	e8 cc f3 ff ff       	call   800251 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e85:	83 c4 2c             	add    $0x2c,%esp
  800e88:	5b                   	pop    %ebx
  800e89:	5e                   	pop    %esi
  800e8a:	5f                   	pop    %edi
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7e 28                	jle    800ed8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ebb:	00 
  800ebc:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  800ec3:	00 
  800ec4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ecb:	00 
  800ecc:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  800ed3:	e8 79 f3 ff ff       	call   800251 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ed8:	83 c4 2c             	add    $0x2c,%esp
  800edb:	5b                   	pop    %ebx
  800edc:	5e                   	pop    %esi
  800edd:	5f                   	pop    %edi
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
  800ee6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eee:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	89 df                	mov    %ebx,%edi
  800efb:	89 de                	mov    %ebx,%esi
  800efd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	7e 28                	jle    800f2b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f07:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f0e:	00 
  800f0f:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  800f16:	00 
  800f17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1e:	00 
  800f1f:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  800f26:	e8 26 f3 ff ff       	call   800251 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f2b:	83 c4 2c             	add    $0x2c,%esp
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
  800f39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	89 df                	mov    %ebx,%edi
  800f4e:	89 de                	mov    %ebx,%esi
  800f50:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f52:	85 c0                	test   %eax,%eax
  800f54:	7e 28                	jle    800f7e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f61:	00 
  800f62:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  800f69:	00 
  800f6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f71:	00 
  800f72:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  800f79:	e8 d3 f2 ff ff       	call   800251 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f7e:	83 c4 2c             	add    $0x2c,%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8c:	be 00 00 00 00       	mov    $0x0,%esi
  800f91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fa2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	89 cb                	mov    %ecx,%ebx
  800fc1:	89 cf                	mov    %ecx,%edi
  800fc3:	89 ce                	mov    %ecx,%esi
  800fc5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	7e 28                	jle    800ff3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fcf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fd6:	00 
  800fd7:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  800fde:	00 
  800fdf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe6:	00 
  800fe7:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  800fee:	e8 5e f2 ff ff       	call   800251 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ff3:	83 c4 2c             	add    $0x2c,%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801001:	ba 00 00 00 00       	mov    $0x0,%edx
  801006:	b8 0e 00 00 00       	mov    $0xe,%eax
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	89 d3                	mov    %edx,%ebx
  80100f:	89 d7                	mov    %edx,%edi
  801011:	89 d6                	mov    %edx,%esi
  801013:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
  801020:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801023:	bb 00 00 00 00       	mov    $0x0,%ebx
  801028:	b8 0f 00 00 00       	mov    $0xf,%eax
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	89 df                	mov    %ebx,%edi
  801035:	89 de                	mov    %ebx,%esi
  801037:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801039:	85 c0                	test   %eax,%eax
  80103b:	7e 28                	jle    801065 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801041:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801048:	00 
  801049:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  801050:	00 
  801051:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801058:	00 
  801059:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  801060:	e8 ec f1 ff ff       	call   800251 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801065:	83 c4 2c             	add    $0x2c,%esp
  801068:	5b                   	pop    %ebx
  801069:	5e                   	pop    %esi
  80106a:	5f                   	pop    %edi
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	57                   	push   %edi
  801071:	56                   	push   %esi
  801072:	53                   	push   %ebx
  801073:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107b:	b8 10 00 00 00       	mov    $0x10,%eax
  801080:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	89 df                	mov    %ebx,%edi
  801088:	89 de                	mov    %ebx,%esi
  80108a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	7e 28                	jle    8010b8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801090:	89 44 24 10          	mov    %eax,0x10(%esp)
  801094:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80109b:	00 
  80109c:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  8010a3:	00 
  8010a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ab:	00 
  8010ac:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  8010b3:	e8 99 f1 ff ff       	call   800251 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8010b8:	83 c4 2c             	add    $0x2c,%esp
  8010bb:	5b                   	pop    %ebx
  8010bc:	5e                   	pop    %esi
  8010bd:	5f                   	pop    %edi
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	57                   	push   %edi
  8010c4:	56                   	push   %esi
  8010c5:	53                   	push   %ebx
  8010c6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ce:	b8 11 00 00 00       	mov    $0x11,%eax
  8010d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d9:	89 df                	mov    %ebx,%edi
  8010db:	89 de                	mov    %ebx,%esi
  8010dd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	7e 28                	jle    80110b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8010ee:	00 
  8010ef:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  8010f6:	00 
  8010f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010fe:	00 
  8010ff:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  801106:	e8 46 f1 ff ff       	call   800251 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80110b:	83 c4 2c             	add    $0x2c,%esp
  80110e:	5b                   	pop    %ebx
  80110f:	5e                   	pop    %esi
  801110:	5f                   	pop    %edi
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <sys_sleep>:

int
sys_sleep(int channel)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	57                   	push   %edi
  801117:	56                   	push   %esi
  801118:	53                   	push   %ebx
  801119:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801121:	b8 12 00 00 00       	mov    $0x12,%eax
  801126:	8b 55 08             	mov    0x8(%ebp),%edx
  801129:	89 cb                	mov    %ecx,%ebx
  80112b:	89 cf                	mov    %ecx,%edi
  80112d:	89 ce                	mov    %ecx,%esi
  80112f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801131:	85 c0                	test   %eax,%eax
  801133:	7e 28                	jle    80115d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801135:	89 44 24 10          	mov    %eax,0x10(%esp)
  801139:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801140:	00 
  801141:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  801148:	00 
  801149:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801150:	00 
  801151:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  801158:	e8 f4 f0 ff ff       	call   800251 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80115d:	83 c4 2c             	add    $0x2c,%esp
  801160:	5b                   	pop    %ebx
  801161:	5e                   	pop    %esi
  801162:	5f                   	pop    %edi
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    

00801165 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	57                   	push   %edi
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
  80116b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801173:	b8 13 00 00 00       	mov    $0x13,%eax
  801178:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117b:	8b 55 08             	mov    0x8(%ebp),%edx
  80117e:	89 df                	mov    %ebx,%edi
  801180:	89 de                	mov    %ebx,%esi
  801182:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801184:	85 c0                	test   %eax,%eax
  801186:	7e 28                	jle    8011b0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801188:	89 44 24 10          	mov    %eax,0x10(%esp)
  80118c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801193:	00 
  801194:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  80119b:	00 
  80119c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a3:	00 
  8011a4:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  8011ab:	e8 a1 f0 ff ff       	call   800251 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8011b0:	83 c4 2c             	add    $0x2c,%esp
  8011b3:	5b                   	pop    %ebx
  8011b4:	5e                   	pop    %esi
  8011b5:	5f                   	pop    %edi
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    

008011b8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	53                   	push   %ebx
  8011bc:	83 ec 24             	sub    $0x24,%esp
  8011bf:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011c2:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  8011c4:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011c8:	74 27                	je     8011f1 <pgfault+0x39>
  8011ca:	89 c2                	mov    %eax,%edx
  8011cc:	c1 ea 16             	shr    $0x16,%edx
  8011cf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011d6:	f6 c2 01             	test   $0x1,%dl
  8011d9:	74 16                	je     8011f1 <pgfault+0x39>
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	c1 ea 0c             	shr    $0xc,%edx
  8011e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e7:	f7 d2                	not    %edx
  8011e9:	f7 c2 01 08 00 00    	test   $0x801,%edx
  8011ef:	74 1c                	je     80120d <pgfault+0x55>
		panic("pgfault");
  8011f1:	c7 44 24 08 76 31 80 	movl   $0x803176,0x8(%esp)
  8011f8:	00 
  8011f9:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801200:	00 
  801201:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  801208:	e8 44 f0 ff ff       	call   800251 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80120d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801212:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801214:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80121b:	00 
  80121c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801223:	00 
  801224:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80122b:	e8 63 fb ff ff       	call   800d93 <sys_page_alloc>
  801230:	85 c0                	test   %eax,%eax
  801232:	79 1c                	jns    801250 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801234:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80123b:	00 
  80123c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801243:	00 
  801244:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80124b:	e8 01 f0 ff ff       	call   800251 <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801250:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801257:	00 
  801258:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80125c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801263:	e8 14 f9 ff ff       	call   800b7c <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801268:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80126f:	00 
  801270:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801274:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80127b:	00 
  80127c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801283:	00 
  801284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80128b:	e8 57 fb ff ff       	call   800de7 <sys_page_map>
  801290:	85 c0                	test   %eax,%eax
  801292:	79 1c                	jns    8012b0 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  801294:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  80129b:	00 
  80129c:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8012a3:	00 
  8012a4:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8012ab:	e8 a1 ef ff ff       	call   800251 <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  8012b0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012b7:	00 
  8012b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012bf:	e8 76 fb ff ff       	call   800e3a <sys_page_unmap>
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	79 1c                	jns    8012e4 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  8012c8:	c7 44 24 08 bb 31 80 	movl   $0x8031bb,0x8(%esp)
  8012cf:	00 
  8012d0:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8012d7:	00 
  8012d8:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8012df:	e8 6d ef ff ff       	call   800251 <_panic>
	}
}
  8012e4:	83 c4 24             	add    $0x24,%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	57                   	push   %edi
  8012ee:	56                   	push   %esi
  8012ef:	53                   	push   %ebx
  8012f0:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  8012f3:	c7 04 24 b8 11 80 00 	movl   $0x8011b8,(%esp)
  8012fa:	e8 77 15 00 00       	call   802876 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8012ff:	b8 07 00 00 00       	mov    $0x7,%eax
  801304:	cd 30                	int    $0x30
  801306:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801309:	85 c0                	test   %eax,%eax
  80130b:	79 1c                	jns    801329 <fork+0x3f>
		panic("fork(): sys_exofork");
  80130d:	c7 44 24 08 d5 31 80 	movl   $0x8031d5,0x8(%esp)
  801314:	00 
  801315:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80131c:	00 
  80131d:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  801324:	e8 28 ef ff ff       	call   800251 <_panic>
  801329:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  80132b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80132f:	74 0a                	je     80133b <fork+0x51>
  801331:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801336:	e9 9d 01 00 00       	jmp    8014d8 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80133b:	e8 15 fa ff ff       	call   800d55 <sys_getenvid>
  801340:	25 ff 03 00 00       	and    $0x3ff,%eax
  801345:	89 c2                	mov    %eax,%edx
  801347:	c1 e2 07             	shl    $0x7,%edx
  80134a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801351:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  801356:	e9 2a 02 00 00       	jmp    801585 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80135b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801361:	0f 84 6b 01 00 00    	je     8014d2 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801367:	89 d8                	mov    %ebx,%eax
  801369:	c1 e8 16             	shr    $0x16,%eax
  80136c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801373:	a8 01                	test   $0x1,%al
  801375:	0f 84 57 01 00 00    	je     8014d2 <fork+0x1e8>
  80137b:	89 d8                	mov    %ebx,%eax
  80137d:	c1 e8 0c             	shr    $0xc,%eax
  801380:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801387:	f7 d0                	not    %eax
  801389:	a8 05                	test   $0x5,%al
  80138b:	0f 85 41 01 00 00    	jne    8014d2 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  801391:	89 d8                	mov    %ebx,%eax
  801393:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  801396:	89 c6                	mov    %eax,%esi
  801398:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  80139b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013a2:	f6 c6 04             	test   $0x4,%dh
  8013a5:	74 4c                	je     8013f3 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  8013a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8013b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013b7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013bb:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ca:	e8 18 fa ff ff       	call   800de7 <sys_page_map>
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	0f 89 fb 00 00 00    	jns    8014d2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8013d7:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  8013de:	00 
  8013df:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8013e6:	00 
  8013e7:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8013ee:	e8 5e ee ff ff       	call   800251 <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  8013f3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013fa:	f6 c6 08             	test   $0x8,%dh
  8013fd:	75 0f                	jne    80140e <fork+0x124>
  8013ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801406:	a8 02                	test   $0x2,%al
  801408:	0f 84 84 00 00 00    	je     801492 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80140e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801415:	00 
  801416:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80141a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80141e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801429:	e8 b9 f9 ff ff       	call   800de7 <sys_page_map>
  80142e:	85 c0                	test   %eax,%eax
  801430:	79 1c                	jns    80144e <fork+0x164>
			panic("duppage: sys_page_map");
  801432:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  801439:	00 
  80143a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801441:	00 
  801442:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  801449:	e8 03 ee ff ff       	call   800251 <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80144e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801455:	00 
  801456:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80145a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801461:	00 
  801462:	89 74 24 04          	mov    %esi,0x4(%esp)
  801466:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80146d:	e8 75 f9 ff ff       	call   800de7 <sys_page_map>
  801472:	85 c0                	test   %eax,%eax
  801474:	79 5c                	jns    8014d2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801476:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  80147d:	00 
  80147e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  801485:	00 
  801486:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80148d:	e8 bf ed ff ff       	call   800251 <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  801492:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801499:	00 
  80149a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80149e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014ad:	e8 35 f9 ff ff       	call   800de7 <sys_page_map>
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	79 1c                	jns    8014d2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8014b6:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  8014bd:	00 
  8014be:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8014c5:	00 
  8014c6:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8014cd:	e8 7f ed ff ff       	call   800251 <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  8014d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014d8:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8014de:	0f 85 77 fe ff ff    	jne    80135b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  8014e4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014eb:	00 
  8014ec:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014f3:	ee 
  8014f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f7:	89 04 24             	mov    %eax,(%esp)
  8014fa:	e8 94 f8 ff ff       	call   800d93 <sys_page_alloc>
  8014ff:	85 c0                	test   %eax,%eax
  801501:	79 1c                	jns    80151f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801503:	c7 44 24 08 ff 31 80 	movl   $0x8031ff,0x8(%esp)
  80150a:	00 
  80150b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801512:	00 
  801513:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80151a:	e8 32 ed ff ff       	call   800251 <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80151f:	c7 44 24 04 ff 28 80 	movl   $0x8028ff,0x4(%esp)
  801526:	00 
  801527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80152a:	89 04 24             	mov    %eax,(%esp)
  80152d:	e8 01 fa ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
  801532:	85 c0                	test   %eax,%eax
  801534:	79 1c                	jns    801552 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801536:	c7 44 24 08 48 32 80 	movl   $0x803248,0x8(%esp)
  80153d:	00 
  80153e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801545:	00 
  801546:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80154d:	e8 ff ec ff ff       	call   800251 <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801552:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801559:	00 
  80155a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80155d:	89 04 24             	mov    %eax,(%esp)
  801560:	e8 28 f9 ff ff       	call   800e8d <sys_env_set_status>
  801565:	85 c0                	test   %eax,%eax
  801567:	79 1c                	jns    801585 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801569:	c7 44 24 08 16 32 80 	movl   $0x803216,0x8(%esp)
  801570:	00 
  801571:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801578:	00 
  801579:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  801580:	e8 cc ec ff ff       	call   800251 <_panic>
	}

	return env_id;
}
  801585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801588:	83 c4 2c             	add    $0x2c,%esp
  80158b:	5b                   	pop    %ebx
  80158c:	5e                   	pop    %esi
  80158d:	5f                   	pop    %edi
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <sfork>:

// Challenge!
int
sfork(void)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801596:	c7 44 24 08 31 32 80 	movl   $0x803231,0x8(%esp)
  80159d:	00 
  80159e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8015a5:	00 
  8015a6:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8015ad:	e8 9f ec ff ff       	call   800251 <_panic>
  8015b2:	66 90                	xchg   %ax,%ax
  8015b4:	66 90                	xchg   %ax,%ax
  8015b6:	66 90                	xchg   %ax,%ax
  8015b8:	66 90                	xchg   %ax,%ax
  8015ba:	66 90                	xchg   %ax,%ax
  8015bc:	66 90                	xchg   %ax,%ax
  8015be:	66 90                	xchg   %ax,%ax

008015c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8015ce:	5d                   	pop    %ebp
  8015cf:	c3                   	ret    

008015d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8015db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015e0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015e5:	5d                   	pop    %ebp
  8015e6:	c3                   	ret    

008015e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015f2:	89 c2                	mov    %eax,%edx
  8015f4:	c1 ea 16             	shr    $0x16,%edx
  8015f7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015fe:	f6 c2 01             	test   $0x1,%dl
  801601:	74 11                	je     801614 <fd_alloc+0x2d>
  801603:	89 c2                	mov    %eax,%edx
  801605:	c1 ea 0c             	shr    $0xc,%edx
  801608:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80160f:	f6 c2 01             	test   $0x1,%dl
  801612:	75 09                	jne    80161d <fd_alloc+0x36>
			*fd_store = fd;
  801614:	89 01                	mov    %eax,(%ecx)
			return 0;
  801616:	b8 00 00 00 00       	mov    $0x0,%eax
  80161b:	eb 17                	jmp    801634 <fd_alloc+0x4d>
  80161d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801622:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801627:	75 c9                	jne    8015f2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801629:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80162f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80163c:	83 f8 1f             	cmp    $0x1f,%eax
  80163f:	77 36                	ja     801677 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801641:	c1 e0 0c             	shl    $0xc,%eax
  801644:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801649:	89 c2                	mov    %eax,%edx
  80164b:	c1 ea 16             	shr    $0x16,%edx
  80164e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801655:	f6 c2 01             	test   $0x1,%dl
  801658:	74 24                	je     80167e <fd_lookup+0x48>
  80165a:	89 c2                	mov    %eax,%edx
  80165c:	c1 ea 0c             	shr    $0xc,%edx
  80165f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801666:	f6 c2 01             	test   $0x1,%dl
  801669:	74 1a                	je     801685 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80166b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166e:	89 02                	mov    %eax,(%edx)
	return 0;
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
  801675:	eb 13                	jmp    80168a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801677:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167c:	eb 0c                	jmp    80168a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80167e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801683:	eb 05                	jmp    80168a <fd_lookup+0x54>
  801685:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    

0080168c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	83 ec 18             	sub    $0x18,%esp
  801692:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801695:	ba 00 00 00 00       	mov    $0x0,%edx
  80169a:	eb 13                	jmp    8016af <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80169c:	39 08                	cmp    %ecx,(%eax)
  80169e:	75 0c                	jne    8016ac <dev_lookup+0x20>
			*dev = devtab[i];
  8016a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016aa:	eb 38                	jmp    8016e4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016ac:	83 c2 01             	add    $0x1,%edx
  8016af:	8b 04 95 e8 32 80 00 	mov    0x8032e8(,%edx,4),%eax
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	75 e2                	jne    80169c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016ba:	a1 08 50 80 00       	mov    0x805008,%eax
  8016bf:	8b 40 48             	mov    0x48(%eax),%eax
  8016c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ca:	c7 04 24 6c 32 80 00 	movl   $0x80326c,(%esp)
  8016d1:	e8 74 ec ff ff       	call   80034a <cprintf>
	*dev = 0;
  8016d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	56                   	push   %esi
  8016ea:	53                   	push   %ebx
  8016eb:	83 ec 20             	sub    $0x20,%esp
  8016ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8016f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801701:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801704:	89 04 24             	mov    %eax,(%esp)
  801707:	e8 2a ff ff ff       	call   801636 <fd_lookup>
  80170c:	85 c0                	test   %eax,%eax
  80170e:	78 05                	js     801715 <fd_close+0x2f>
	    || fd != fd2)
  801710:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801713:	74 0c                	je     801721 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801715:	84 db                	test   %bl,%bl
  801717:	ba 00 00 00 00       	mov    $0x0,%edx
  80171c:	0f 44 c2             	cmove  %edx,%eax
  80171f:	eb 3f                	jmp    801760 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801721:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801724:	89 44 24 04          	mov    %eax,0x4(%esp)
  801728:	8b 06                	mov    (%esi),%eax
  80172a:	89 04 24             	mov    %eax,(%esp)
  80172d:	e8 5a ff ff ff       	call   80168c <dev_lookup>
  801732:	89 c3                	mov    %eax,%ebx
  801734:	85 c0                	test   %eax,%eax
  801736:	78 16                	js     80174e <fd_close+0x68>
		if (dev->dev_close)
  801738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80173e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801743:	85 c0                	test   %eax,%eax
  801745:	74 07                	je     80174e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801747:	89 34 24             	mov    %esi,(%esp)
  80174a:	ff d0                	call   *%eax
  80174c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80174e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801752:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801759:	e8 dc f6 ff ff       	call   800e3a <sys_page_unmap>
	return r;
  80175e:	89 d8                	mov    %ebx,%eax
}
  801760:	83 c4 20             	add    $0x20,%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    

00801767 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80176d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801770:	89 44 24 04          	mov    %eax,0x4(%esp)
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	89 04 24             	mov    %eax,(%esp)
  80177a:	e8 b7 fe ff ff       	call   801636 <fd_lookup>
  80177f:	89 c2                	mov    %eax,%edx
  801781:	85 d2                	test   %edx,%edx
  801783:	78 13                	js     801798 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801785:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80178c:	00 
  80178d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801790:	89 04 24             	mov    %eax,(%esp)
  801793:	e8 4e ff ff ff       	call   8016e6 <fd_close>
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <close_all>:

void
close_all(void)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	53                   	push   %ebx
  80179e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017a6:	89 1c 24             	mov    %ebx,(%esp)
  8017a9:	e8 b9 ff ff ff       	call   801767 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017ae:	83 c3 01             	add    $0x1,%ebx
  8017b1:	83 fb 20             	cmp    $0x20,%ebx
  8017b4:	75 f0                	jne    8017a6 <close_all+0xc>
		close(i);
}
  8017b6:	83 c4 14             	add    $0x14,%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	57                   	push   %edi
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	89 04 24             	mov    %eax,(%esp)
  8017d2:	e8 5f fe ff ff       	call   801636 <fd_lookup>
  8017d7:	89 c2                	mov    %eax,%edx
  8017d9:	85 d2                	test   %edx,%edx
  8017db:	0f 88 e1 00 00 00    	js     8018c2 <dup+0x106>
		return r;
	close(newfdnum);
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	89 04 24             	mov    %eax,(%esp)
  8017e7:	e8 7b ff ff ff       	call   801767 <close>

	newfd = INDEX2FD(newfdnum);
  8017ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017ef:	c1 e3 0c             	shl    $0xc,%ebx
  8017f2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017fb:	89 04 24             	mov    %eax,(%esp)
  8017fe:	e8 cd fd ff ff       	call   8015d0 <fd2data>
  801803:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801805:	89 1c 24             	mov    %ebx,(%esp)
  801808:	e8 c3 fd ff ff       	call   8015d0 <fd2data>
  80180d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80180f:	89 f0                	mov    %esi,%eax
  801811:	c1 e8 16             	shr    $0x16,%eax
  801814:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80181b:	a8 01                	test   $0x1,%al
  80181d:	74 43                	je     801862 <dup+0xa6>
  80181f:	89 f0                	mov    %esi,%eax
  801821:	c1 e8 0c             	shr    $0xc,%eax
  801824:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80182b:	f6 c2 01             	test   $0x1,%dl
  80182e:	74 32                	je     801862 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801830:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801837:	25 07 0e 00 00       	and    $0xe07,%eax
  80183c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801840:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801844:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80184b:	00 
  80184c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801850:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801857:	e8 8b f5 ff ff       	call   800de7 <sys_page_map>
  80185c:	89 c6                	mov    %eax,%esi
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 3e                	js     8018a0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801865:	89 c2                	mov    %eax,%edx
  801867:	c1 ea 0c             	shr    $0xc,%edx
  80186a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801871:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801877:	89 54 24 10          	mov    %edx,0x10(%esp)
  80187b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80187f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801886:	00 
  801887:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801892:	e8 50 f5 ff ff       	call   800de7 <sys_page_map>
  801897:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801899:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80189c:	85 f6                	test   %esi,%esi
  80189e:	79 22                	jns    8018c2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ab:	e8 8a f5 ff ff       	call   800e3a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018bb:	e8 7a f5 ff ff       	call   800e3a <sys_page_unmap>
	return r;
  8018c0:	89 f0                	mov    %esi,%eax
}
  8018c2:	83 c4 3c             	add    $0x3c,%esp
  8018c5:	5b                   	pop    %ebx
  8018c6:	5e                   	pop    %esi
  8018c7:	5f                   	pop    %edi
  8018c8:	5d                   	pop    %ebp
  8018c9:	c3                   	ret    

008018ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	53                   	push   %ebx
  8018ce:	83 ec 24             	sub    $0x24,%esp
  8018d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018db:	89 1c 24             	mov    %ebx,(%esp)
  8018de:	e8 53 fd ff ff       	call   801636 <fd_lookup>
  8018e3:	89 c2                	mov    %eax,%edx
  8018e5:	85 d2                	test   %edx,%edx
  8018e7:	78 6d                	js     801956 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f3:	8b 00                	mov    (%eax),%eax
  8018f5:	89 04 24             	mov    %eax,(%esp)
  8018f8:	e8 8f fd ff ff       	call   80168c <dev_lookup>
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	78 55                	js     801956 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801904:	8b 50 08             	mov    0x8(%eax),%edx
  801907:	83 e2 03             	and    $0x3,%edx
  80190a:	83 fa 01             	cmp    $0x1,%edx
  80190d:	75 23                	jne    801932 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80190f:	a1 08 50 80 00       	mov    0x805008,%eax
  801914:	8b 40 48             	mov    0x48(%eax),%eax
  801917:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80191b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191f:	c7 04 24 ad 32 80 00 	movl   $0x8032ad,(%esp)
  801926:	e8 1f ea ff ff       	call   80034a <cprintf>
		return -E_INVAL;
  80192b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801930:	eb 24                	jmp    801956 <read+0x8c>
	}
	if (!dev->dev_read)
  801932:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801935:	8b 52 08             	mov    0x8(%edx),%edx
  801938:	85 d2                	test   %edx,%edx
  80193a:	74 15                	je     801951 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80193c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801943:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801946:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80194a:	89 04 24             	mov    %eax,(%esp)
  80194d:	ff d2                	call   *%edx
  80194f:	eb 05                	jmp    801956 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801951:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801956:	83 c4 24             	add    $0x24,%esp
  801959:	5b                   	pop    %ebx
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	57                   	push   %edi
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
  801962:	83 ec 1c             	sub    $0x1c,%esp
  801965:	8b 7d 08             	mov    0x8(%ebp),%edi
  801968:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80196b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801970:	eb 23                	jmp    801995 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801972:	89 f0                	mov    %esi,%eax
  801974:	29 d8                	sub    %ebx,%eax
  801976:	89 44 24 08          	mov    %eax,0x8(%esp)
  80197a:	89 d8                	mov    %ebx,%eax
  80197c:	03 45 0c             	add    0xc(%ebp),%eax
  80197f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801983:	89 3c 24             	mov    %edi,(%esp)
  801986:	e8 3f ff ff ff       	call   8018ca <read>
		if (m < 0)
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 10                	js     80199f <readn+0x43>
			return m;
		if (m == 0)
  80198f:	85 c0                	test   %eax,%eax
  801991:	74 0a                	je     80199d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801993:	01 c3                	add    %eax,%ebx
  801995:	39 f3                	cmp    %esi,%ebx
  801997:	72 d9                	jb     801972 <readn+0x16>
  801999:	89 d8                	mov    %ebx,%eax
  80199b:	eb 02                	jmp    80199f <readn+0x43>
  80199d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80199f:	83 c4 1c             	add    $0x1c,%esp
  8019a2:	5b                   	pop    %ebx
  8019a3:	5e                   	pop    %esi
  8019a4:	5f                   	pop    %edi
  8019a5:	5d                   	pop    %ebp
  8019a6:	c3                   	ret    

008019a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	53                   	push   %ebx
  8019ab:	83 ec 24             	sub    $0x24,%esp
  8019ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b8:	89 1c 24             	mov    %ebx,(%esp)
  8019bb:	e8 76 fc ff ff       	call   801636 <fd_lookup>
  8019c0:	89 c2                	mov    %eax,%edx
  8019c2:	85 d2                	test   %edx,%edx
  8019c4:	78 68                	js     801a2e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d0:	8b 00                	mov    (%eax),%eax
  8019d2:	89 04 24             	mov    %eax,(%esp)
  8019d5:	e8 b2 fc ff ff       	call   80168c <dev_lookup>
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 50                	js     801a2e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019e5:	75 23                	jne    801a0a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019e7:	a1 08 50 80 00       	mov    0x805008,%eax
  8019ec:	8b 40 48             	mov    0x48(%eax),%eax
  8019ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f7:	c7 04 24 c9 32 80 00 	movl   $0x8032c9,(%esp)
  8019fe:	e8 47 e9 ff ff       	call   80034a <cprintf>
		return -E_INVAL;
  801a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a08:	eb 24                	jmp    801a2e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a10:	85 d2                	test   %edx,%edx
  801a12:	74 15                	je     801a29 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a22:	89 04 24             	mov    %eax,(%esp)
  801a25:	ff d2                	call   *%edx
  801a27:	eb 05                	jmp    801a2e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a29:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a2e:	83 c4 24             	add    $0x24,%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    

00801a34 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a3a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	89 04 24             	mov    %eax,(%esp)
  801a47:	e8 ea fb ff ff       	call   801636 <fd_lookup>
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 0e                	js     801a5e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a56:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	53                   	push   %ebx
  801a64:	83 ec 24             	sub    $0x24,%esp
  801a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a71:	89 1c 24             	mov    %ebx,(%esp)
  801a74:	e8 bd fb ff ff       	call   801636 <fd_lookup>
  801a79:	89 c2                	mov    %eax,%edx
  801a7b:	85 d2                	test   %edx,%edx
  801a7d:	78 61                	js     801ae0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a89:	8b 00                	mov    (%eax),%eax
  801a8b:	89 04 24             	mov    %eax,(%esp)
  801a8e:	e8 f9 fb ff ff       	call   80168c <dev_lookup>
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 49                	js     801ae0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a9e:	75 23                	jne    801ac3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801aa0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801aa5:	8b 40 48             	mov    0x48(%eax),%eax
  801aa8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab0:	c7 04 24 8c 32 80 00 	movl   $0x80328c,(%esp)
  801ab7:	e8 8e e8 ff ff       	call   80034a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801abc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ac1:	eb 1d                	jmp    801ae0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801ac3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac6:	8b 52 18             	mov    0x18(%edx),%edx
  801ac9:	85 d2                	test   %edx,%edx
  801acb:	74 0e                	je     801adb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801acd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad4:	89 04 24             	mov    %eax,(%esp)
  801ad7:	ff d2                	call   *%edx
  801ad9:	eb 05                	jmp    801ae0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801adb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801ae0:	83 c4 24             	add    $0x24,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    

00801ae6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	53                   	push   %ebx
  801aea:	83 ec 24             	sub    $0x24,%esp
  801aed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	89 04 24             	mov    %eax,(%esp)
  801afd:	e8 34 fb ff ff       	call   801636 <fd_lookup>
  801b02:	89 c2                	mov    %eax,%edx
  801b04:	85 d2                	test   %edx,%edx
  801b06:	78 52                	js     801b5a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b12:	8b 00                	mov    (%eax),%eax
  801b14:	89 04 24             	mov    %eax,(%esp)
  801b17:	e8 70 fb ff ff       	call   80168c <dev_lookup>
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 3a                	js     801b5a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b23:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b27:	74 2c                	je     801b55 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b29:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b2c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b33:	00 00 00 
	stat->st_isdir = 0;
  801b36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b3d:	00 00 00 
	stat->st_dev = dev;
  801b40:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b4d:	89 14 24             	mov    %edx,(%esp)
  801b50:	ff 50 14             	call   *0x14(%eax)
  801b53:	eb 05                	jmp    801b5a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b55:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b5a:	83 c4 24             	add    $0x24,%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    

00801b60 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	56                   	push   %esi
  801b64:	53                   	push   %ebx
  801b65:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b6f:	00 
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	89 04 24             	mov    %eax,(%esp)
  801b76:	e8 1b 02 00 00       	call   801d96 <open>
  801b7b:	89 c3                	mov    %eax,%ebx
  801b7d:	85 db                	test   %ebx,%ebx
  801b7f:	78 1b                	js     801b9c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b88:	89 1c 24             	mov    %ebx,(%esp)
  801b8b:	e8 56 ff ff ff       	call   801ae6 <fstat>
  801b90:	89 c6                	mov    %eax,%esi
	close(fd);
  801b92:	89 1c 24             	mov    %ebx,(%esp)
  801b95:	e8 cd fb ff ff       	call   801767 <close>
	return r;
  801b9a:	89 f0                	mov    %esi,%eax
}
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5d                   	pop    %ebp
  801ba2:	c3                   	ret    

00801ba3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	56                   	push   %esi
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 10             	sub    $0x10,%esp
  801bab:	89 c6                	mov    %eax,%esi
  801bad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801baf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bb6:	75 11                	jne    801bc9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bbf:	e8 2b 0e 00 00       	call   8029ef <ipc_find_env>
  801bc4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bc9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bd0:	00 
  801bd1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801bd8:	00 
  801bd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bdd:	a1 00 50 80 00       	mov    0x805000,%eax
  801be2:	89 04 24             	mov    %eax,(%esp)
  801be5:	e8 9a 0d 00 00       	call   802984 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bf1:	00 
  801bf2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bf6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bfd:	e8 2e 0d 00 00       	call   802930 <ipc_recv>
}
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	5b                   	pop    %ebx
  801c06:	5e                   	pop    %esi
  801c07:	5d                   	pop    %ebp
  801c08:	c3                   	ret    

00801c09 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	8b 40 0c             	mov    0xc(%eax),%eax
  801c15:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c22:	ba 00 00 00 00       	mov    $0x0,%edx
  801c27:	b8 02 00 00 00       	mov    $0x2,%eax
  801c2c:	e8 72 ff ff ff       	call   801ba3 <fsipc>
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c3f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c44:	ba 00 00 00 00       	mov    $0x0,%edx
  801c49:	b8 06 00 00 00       	mov    $0x6,%eax
  801c4e:	e8 50 ff ff ff       	call   801ba3 <fsipc>
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	53                   	push   %ebx
  801c59:	83 ec 14             	sub    $0x14,%esp
  801c5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	8b 40 0c             	mov    0xc(%eax),%eax
  801c65:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c74:	e8 2a ff ff ff       	call   801ba3 <fsipc>
  801c79:	89 c2                	mov    %eax,%edx
  801c7b:	85 d2                	test   %edx,%edx
  801c7d:	78 2b                	js     801caa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c7f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c86:	00 
  801c87:	89 1c 24             	mov    %ebx,(%esp)
  801c8a:	e8 e8 ec ff ff       	call   800977 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c8f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c94:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c9a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c9f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ca5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801caa:	83 c4 14             	add    $0x14,%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    

00801cb0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 18             	sub    $0x18,%esp
  801cb6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  801cbc:	8b 52 0c             	mov    0xc(%edx),%edx
  801cbf:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801cc5:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801cca:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd5:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801cdc:	e8 9b ee ff ff       	call   800b7c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce6:	b8 04 00 00 00       	mov    $0x4,%eax
  801ceb:	e8 b3 fe ff ff       	call   801ba3 <fsipc>
		return r;
	}

	return r;
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	56                   	push   %esi
  801cf6:	53                   	push   %ebx
  801cf7:	83 ec 10             	sub    $0x10,%esp
  801cfa:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	8b 40 0c             	mov    0xc(%eax),%eax
  801d03:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d08:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d13:	b8 03 00 00 00       	mov    $0x3,%eax
  801d18:	e8 86 fe ff ff       	call   801ba3 <fsipc>
  801d1d:	89 c3                	mov    %eax,%ebx
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	78 6a                	js     801d8d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d23:	39 c6                	cmp    %eax,%esi
  801d25:	73 24                	jae    801d4b <devfile_read+0x59>
  801d27:	c7 44 24 0c fc 32 80 	movl   $0x8032fc,0xc(%esp)
  801d2e:	00 
  801d2f:	c7 44 24 08 03 33 80 	movl   $0x803303,0x8(%esp)
  801d36:	00 
  801d37:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d3e:	00 
  801d3f:	c7 04 24 18 33 80 00 	movl   $0x803318,(%esp)
  801d46:	e8 06 e5 ff ff       	call   800251 <_panic>
	assert(r <= PGSIZE);
  801d4b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d50:	7e 24                	jle    801d76 <devfile_read+0x84>
  801d52:	c7 44 24 0c 23 33 80 	movl   $0x803323,0xc(%esp)
  801d59:	00 
  801d5a:	c7 44 24 08 03 33 80 	movl   $0x803303,0x8(%esp)
  801d61:	00 
  801d62:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d69:	00 
  801d6a:	c7 04 24 18 33 80 00 	movl   $0x803318,(%esp)
  801d71:	e8 db e4 ff ff       	call   800251 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d76:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d7a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d81:	00 
  801d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d85:	89 04 24             	mov    %eax,(%esp)
  801d88:	e8 87 ed ff ff       	call   800b14 <memmove>
	return r;
}
  801d8d:	89 d8                	mov    %ebx,%eax
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	5b                   	pop    %ebx
  801d93:	5e                   	pop    %esi
  801d94:	5d                   	pop    %ebp
  801d95:	c3                   	ret    

00801d96 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 24             	sub    $0x24,%esp
  801d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801da0:	89 1c 24             	mov    %ebx,(%esp)
  801da3:	e8 98 eb ff ff       	call   800940 <strlen>
  801da8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dad:	7f 60                	jg     801e0f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801daf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801db2:	89 04 24             	mov    %eax,(%esp)
  801db5:	e8 2d f8 ff ff       	call   8015e7 <fd_alloc>
  801dba:	89 c2                	mov    %eax,%edx
  801dbc:	85 d2                	test   %edx,%edx
  801dbe:	78 54                	js     801e14 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801dc0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dc4:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801dcb:	e8 a7 eb ff ff       	call   800977 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd3:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddb:	b8 01 00 00 00       	mov    $0x1,%eax
  801de0:	e8 be fd ff ff       	call   801ba3 <fsipc>
  801de5:	89 c3                	mov    %eax,%ebx
  801de7:	85 c0                	test   %eax,%eax
  801de9:	79 17                	jns    801e02 <open+0x6c>
		fd_close(fd, 0);
  801deb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801df2:	00 
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df6:	89 04 24             	mov    %eax,(%esp)
  801df9:	e8 e8 f8 ff ff       	call   8016e6 <fd_close>
		return r;
  801dfe:	89 d8                	mov    %ebx,%eax
  801e00:	eb 12                	jmp    801e14 <open+0x7e>
	}

	return fd2num(fd);
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	89 04 24             	mov    %eax,(%esp)
  801e08:	e8 b3 f7 ff ff       	call   8015c0 <fd2num>
  801e0d:	eb 05                	jmp    801e14 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e0f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e14:	83 c4 24             	add    $0x24,%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    

00801e1a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e20:	ba 00 00 00 00       	mov    $0x0,%edx
  801e25:	b8 08 00 00 00       	mov    $0x8,%eax
  801e2a:	e8 74 fd ff ff       	call   801ba3 <fsipc>
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    
  801e31:	66 90                	xchg   %ax,%ax
  801e33:	66 90                	xchg   %ax,%ax
  801e35:	66 90                	xchg   %ax,%ax
  801e37:	66 90                	xchg   %ax,%ax
  801e39:	66 90                	xchg   %ax,%ax
  801e3b:	66 90                	xchg   %ax,%ax
  801e3d:	66 90                	xchg   %ax,%ax
  801e3f:	90                   	nop

00801e40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e46:	c7 44 24 04 2f 33 80 	movl   $0x80332f,0x4(%esp)
  801e4d:	00 
  801e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e51:	89 04 24             	mov    %eax,(%esp)
  801e54:	e8 1e eb ff ff       	call   800977 <strcpy>
	return 0;
}
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	53                   	push   %ebx
  801e64:	83 ec 14             	sub    $0x14,%esp
  801e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e6a:	89 1c 24             	mov    %ebx,(%esp)
  801e6d:	e8 bc 0b 00 00       	call   802a2e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e72:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e77:	83 f8 01             	cmp    $0x1,%eax
  801e7a:	75 0d                	jne    801e89 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e7c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e7f:	89 04 24             	mov    %eax,(%esp)
  801e82:	e8 29 03 00 00       	call   8021b0 <nsipc_close>
  801e87:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e89:	89 d0                	mov    %edx,%eax
  801e8b:	83 c4 14             	add    $0x14,%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5d                   	pop    %ebp
  801e90:	c3                   	ret    

00801e91 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e97:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e9e:	00 
  801e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb3:	89 04 24             	mov    %eax,(%esp)
  801eb6:	e8 f0 03 00 00       	call   8022ab <nsipc_send>
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ec3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eca:	00 
  801ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ece:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	8b 40 0c             	mov    0xc(%eax),%eax
  801edf:	89 04 24             	mov    %eax,(%esp)
  801ee2:	e8 44 03 00 00       	call   80222b <nsipc_recv>
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801eef:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ef2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ef6:	89 04 24             	mov    %eax,(%esp)
  801ef9:	e8 38 f7 ff ff       	call   801636 <fd_lookup>
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 17                	js     801f19 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f0b:	39 08                	cmp    %ecx,(%eax)
  801f0d:	75 05                	jne    801f14 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f12:	eb 05                	jmp    801f19 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	56                   	push   %esi
  801f1f:	53                   	push   %ebx
  801f20:	83 ec 20             	sub    $0x20,%esp
  801f23:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f28:	89 04 24             	mov    %eax,(%esp)
  801f2b:	e8 b7 f6 ff ff       	call   8015e7 <fd_alloc>
  801f30:	89 c3                	mov    %eax,%ebx
  801f32:	85 c0                	test   %eax,%eax
  801f34:	78 21                	js     801f57 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f36:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f3d:	00 
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4c:	e8 42 ee ff ff       	call   800d93 <sys_page_alloc>
  801f51:	89 c3                	mov    %eax,%ebx
  801f53:	85 c0                	test   %eax,%eax
  801f55:	79 0c                	jns    801f63 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f57:	89 34 24             	mov    %esi,(%esp)
  801f5a:	e8 51 02 00 00       	call   8021b0 <nsipc_close>
		return r;
  801f5f:	89 d8                	mov    %ebx,%eax
  801f61:	eb 20                	jmp    801f83 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f63:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f71:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f78:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f7b:	89 14 24             	mov    %edx,(%esp)
  801f7e:	e8 3d f6 ff ff       	call   8015c0 <fd2num>
}
  801f83:	83 c4 20             	add    $0x20,%esp
  801f86:	5b                   	pop    %ebx
  801f87:	5e                   	pop    %esi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    

00801f8a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	e8 51 ff ff ff       	call   801ee9 <fd2sockid>
		return r;
  801f98:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	78 23                	js     801fc1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f9e:	8b 55 10             	mov    0x10(%ebp),%edx
  801fa1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fac:	89 04 24             	mov    %eax,(%esp)
  801faf:	e8 45 01 00 00       	call   8020f9 <nsipc_accept>
		return r;
  801fb4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	78 07                	js     801fc1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801fba:	e8 5c ff ff ff       	call   801f1b <alloc_sockfd>
  801fbf:	89 c1                	mov    %eax,%ecx
}
  801fc1:	89 c8                	mov    %ecx,%eax
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	e8 16 ff ff ff       	call   801ee9 <fd2sockid>
  801fd3:	89 c2                	mov    %eax,%edx
  801fd5:	85 d2                	test   %edx,%edx
  801fd7:	78 16                	js     801fef <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe7:	89 14 24             	mov    %edx,(%esp)
  801fea:	e8 60 01 00 00       	call   80214f <nsipc_bind>
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <shutdown>:

int
shutdown(int s, int how)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	e8 ea fe ff ff       	call   801ee9 <fd2sockid>
  801fff:	89 c2                	mov    %eax,%edx
  802001:	85 d2                	test   %edx,%edx
  802003:	78 0f                	js     802014 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802005:	8b 45 0c             	mov    0xc(%ebp),%eax
  802008:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200c:	89 14 24             	mov    %edx,(%esp)
  80200f:	e8 7a 01 00 00       	call   80218e <nsipc_shutdown>
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	e8 c5 fe ff ff       	call   801ee9 <fd2sockid>
  802024:	89 c2                	mov    %eax,%edx
  802026:	85 d2                	test   %edx,%edx
  802028:	78 16                	js     802040 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80202a:	8b 45 10             	mov    0x10(%ebp),%eax
  80202d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802031:	8b 45 0c             	mov    0xc(%ebp),%eax
  802034:	89 44 24 04          	mov    %eax,0x4(%esp)
  802038:	89 14 24             	mov    %edx,(%esp)
  80203b:	e8 8a 01 00 00       	call   8021ca <nsipc_connect>
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <listen>:

int
listen(int s, int backlog)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	e8 99 fe ff ff       	call   801ee9 <fd2sockid>
  802050:	89 c2                	mov    %eax,%edx
  802052:	85 d2                	test   %edx,%edx
  802054:	78 0f                	js     802065 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205d:	89 14 24             	mov    %edx,(%esp)
  802060:	e8 a4 01 00 00       	call   802209 <nsipc_listen>
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80206d:	8b 45 10             	mov    0x10(%ebp),%eax
  802070:	89 44 24 08          	mov    %eax,0x8(%esp)
  802074:	8b 45 0c             	mov    0xc(%ebp),%eax
  802077:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	89 04 24             	mov    %eax,(%esp)
  802081:	e8 98 02 00 00       	call   80231e <nsipc_socket>
  802086:	89 c2                	mov    %eax,%edx
  802088:	85 d2                	test   %edx,%edx
  80208a:	78 05                	js     802091 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80208c:	e8 8a fe ff ff       	call   801f1b <alloc_sockfd>
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	53                   	push   %ebx
  802097:	83 ec 14             	sub    $0x14,%esp
  80209a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80209c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020a3:	75 11                	jne    8020b6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020a5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020ac:	e8 3e 09 00 00       	call   8029ef <ipc_find_env>
  8020b1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020b6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020bd:	00 
  8020be:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8020c5:	00 
  8020c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8020cf:	89 04 24             	mov    %eax,(%esp)
  8020d2:	e8 ad 08 00 00       	call   802984 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020de:	00 
  8020df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020e6:	00 
  8020e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ee:	e8 3d 08 00 00       	call   802930 <ipc_recv>
}
  8020f3:	83 c4 14             	add    $0x14,%esp
  8020f6:	5b                   	pop    %ebx
  8020f7:	5d                   	pop    %ebp
  8020f8:	c3                   	ret    

008020f9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	56                   	push   %esi
  8020fd:	53                   	push   %ebx
  8020fe:	83 ec 10             	sub    $0x10,%esp
  802101:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80210c:	8b 06                	mov    (%esi),%eax
  80210e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802113:	b8 01 00 00 00       	mov    $0x1,%eax
  802118:	e8 76 ff ff ff       	call   802093 <nsipc>
  80211d:	89 c3                	mov    %eax,%ebx
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 23                	js     802146 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802123:	a1 10 70 80 00       	mov    0x807010,%eax
  802128:	89 44 24 08          	mov    %eax,0x8(%esp)
  80212c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802133:	00 
  802134:	8b 45 0c             	mov    0xc(%ebp),%eax
  802137:	89 04 24             	mov    %eax,(%esp)
  80213a:	e8 d5 e9 ff ff       	call   800b14 <memmove>
		*addrlen = ret->ret_addrlen;
  80213f:	a1 10 70 80 00       	mov    0x807010,%eax
  802144:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802146:	89 d8                	mov    %ebx,%eax
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	5b                   	pop    %ebx
  80214c:	5e                   	pop    %esi
  80214d:	5d                   	pop    %ebp
  80214e:	c3                   	ret    

0080214f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	53                   	push   %ebx
  802153:	83 ec 14             	sub    $0x14,%esp
  802156:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802161:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802165:	8b 45 0c             	mov    0xc(%ebp),%eax
  802168:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802173:	e8 9c e9 ff ff       	call   800b14 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802178:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80217e:	b8 02 00 00 00       	mov    $0x2,%eax
  802183:	e8 0b ff ff ff       	call   802093 <nsipc>
}
  802188:	83 c4 14             	add    $0x14,%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    

0080218e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80219c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8021a9:	e8 e5 fe ff ff       	call   802093 <nsipc>
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <nsipc_close>:

int
nsipc_close(int s)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021be:	b8 04 00 00 00       	mov    $0x4,%eax
  8021c3:	e8 cb fe ff ff       	call   802093 <nsipc>
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 14             	sub    $0x14,%esp
  8021d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021ee:	e8 21 e9 ff ff       	call   800b14 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021f3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021f9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021fe:	e8 90 fe ff ff       	call   802093 <nsipc>
}
  802203:	83 c4 14             	add    $0x14,%esp
  802206:	5b                   	pop    %ebx
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    

00802209 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80221f:	b8 06 00 00 00       	mov    $0x6,%eax
  802224:	e8 6a fe ff ff       	call   802093 <nsipc>
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	56                   	push   %esi
  80222f:	53                   	push   %ebx
  802230:	83 ec 10             	sub    $0x10,%esp
  802233:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80223e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802244:	8b 45 14             	mov    0x14(%ebp),%eax
  802247:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80224c:	b8 07 00 00 00       	mov    $0x7,%eax
  802251:	e8 3d fe ff ff       	call   802093 <nsipc>
  802256:	89 c3                	mov    %eax,%ebx
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 46                	js     8022a2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80225c:	39 f0                	cmp    %esi,%eax
  80225e:	7f 07                	jg     802267 <nsipc_recv+0x3c>
  802260:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802265:	7e 24                	jle    80228b <nsipc_recv+0x60>
  802267:	c7 44 24 0c 3b 33 80 	movl   $0x80333b,0xc(%esp)
  80226e:	00 
  80226f:	c7 44 24 08 03 33 80 	movl   $0x803303,0x8(%esp)
  802276:	00 
  802277:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80227e:	00 
  80227f:	c7 04 24 50 33 80 00 	movl   $0x803350,(%esp)
  802286:	e8 c6 df ff ff       	call   800251 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80228b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80228f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802296:	00 
  802297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229a:	89 04 24             	mov    %eax,(%esp)
  80229d:	e8 72 e8 ff ff       	call   800b14 <memmove>
	}

	return r;
}
  8022a2:	89 d8                	mov    %ebx,%eax
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5d                   	pop    %ebp
  8022aa:	c3                   	ret    

008022ab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	53                   	push   %ebx
  8022af:	83 ec 14             	sub    $0x14,%esp
  8022b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022bd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022c3:	7e 24                	jle    8022e9 <nsipc_send+0x3e>
  8022c5:	c7 44 24 0c 5c 33 80 	movl   $0x80335c,0xc(%esp)
  8022cc:	00 
  8022cd:	c7 44 24 08 03 33 80 	movl   $0x803303,0x8(%esp)
  8022d4:	00 
  8022d5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8022dc:	00 
  8022dd:	c7 04 24 50 33 80 00 	movl   $0x803350,(%esp)
  8022e4:	e8 68 df ff ff       	call   800251 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022fb:	e8 14 e8 ff ff       	call   800b14 <memmove>
	nsipcbuf.send.req_size = size;
  802300:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802306:	8b 45 14             	mov    0x14(%ebp),%eax
  802309:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80230e:	b8 08 00 00 00       	mov    $0x8,%eax
  802313:	e8 7b fd ff ff       	call   802093 <nsipc>
}
  802318:	83 c4 14             	add    $0x14,%esp
  80231b:	5b                   	pop    %ebx
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    

0080231e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80232c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802334:	8b 45 10             	mov    0x10(%ebp),%eax
  802337:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80233c:	b8 09 00 00 00       	mov    $0x9,%eax
  802341:	e8 4d fd ff ff       	call   802093 <nsipc>
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	56                   	push   %esi
  80234c:	53                   	push   %ebx
  80234d:	83 ec 10             	sub    $0x10,%esp
  802350:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	89 04 24             	mov    %eax,(%esp)
  802359:	e8 72 f2 ff ff       	call   8015d0 <fd2data>
  80235e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802360:	c7 44 24 04 68 33 80 	movl   $0x803368,0x4(%esp)
  802367:	00 
  802368:	89 1c 24             	mov    %ebx,(%esp)
  80236b:	e8 07 e6 ff ff       	call   800977 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802370:	8b 46 04             	mov    0x4(%esi),%eax
  802373:	2b 06                	sub    (%esi),%eax
  802375:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80237b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802382:	00 00 00 
	stat->st_dev = &devpipe;
  802385:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80238c:	40 80 00 
	return 0;
}
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
  802394:	83 c4 10             	add    $0x10,%esp
  802397:	5b                   	pop    %ebx
  802398:	5e                   	pop    %esi
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    

0080239b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	53                   	push   %ebx
  80239f:	83 ec 14             	sub    $0x14,%esp
  8023a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b0:	e8 85 ea ff ff       	call   800e3a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023b5:	89 1c 24             	mov    %ebx,(%esp)
  8023b8:	e8 13 f2 ff ff       	call   8015d0 <fd2data>
  8023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c8:	e8 6d ea ff ff       	call   800e3a <sys_page_unmap>
}
  8023cd:	83 c4 14             	add    $0x14,%esp
  8023d0:	5b                   	pop    %ebx
  8023d1:	5d                   	pop    %ebp
  8023d2:	c3                   	ret    

008023d3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	57                   	push   %edi
  8023d7:	56                   	push   %esi
  8023d8:	53                   	push   %ebx
  8023d9:	83 ec 2c             	sub    $0x2c,%esp
  8023dc:	89 c6                	mov    %eax,%esi
  8023de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023e1:	a1 08 50 80 00       	mov    0x805008,%eax
  8023e6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023e9:	89 34 24             	mov    %esi,(%esp)
  8023ec:	e8 3d 06 00 00       	call   802a2e <pageref>
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f6:	89 04 24             	mov    %eax,(%esp)
  8023f9:	e8 30 06 00 00       	call   802a2e <pageref>
  8023fe:	39 c7                	cmp    %eax,%edi
  802400:	0f 94 c2             	sete   %dl
  802403:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802406:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80240c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80240f:	39 fb                	cmp    %edi,%ebx
  802411:	74 21                	je     802434 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802413:	84 d2                	test   %dl,%dl
  802415:	74 ca                	je     8023e1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802417:	8b 51 58             	mov    0x58(%ecx),%edx
  80241a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80241e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802422:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802426:	c7 04 24 6f 33 80 00 	movl   $0x80336f,(%esp)
  80242d:	e8 18 df ff ff       	call   80034a <cprintf>
  802432:	eb ad                	jmp    8023e1 <_pipeisclosed+0xe>
	}
}
  802434:	83 c4 2c             	add    $0x2c,%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5f                   	pop    %edi
  80243a:	5d                   	pop    %ebp
  80243b:	c3                   	ret    

0080243c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	57                   	push   %edi
  802440:	56                   	push   %esi
  802441:	53                   	push   %ebx
  802442:	83 ec 1c             	sub    $0x1c,%esp
  802445:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802448:	89 34 24             	mov    %esi,(%esp)
  80244b:	e8 80 f1 ff ff       	call   8015d0 <fd2data>
  802450:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802452:	bf 00 00 00 00       	mov    $0x0,%edi
  802457:	eb 45                	jmp    80249e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802459:	89 da                	mov    %ebx,%edx
  80245b:	89 f0                	mov    %esi,%eax
  80245d:	e8 71 ff ff ff       	call   8023d3 <_pipeisclosed>
  802462:	85 c0                	test   %eax,%eax
  802464:	75 41                	jne    8024a7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802466:	e8 09 e9 ff ff       	call   800d74 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80246b:	8b 43 04             	mov    0x4(%ebx),%eax
  80246e:	8b 0b                	mov    (%ebx),%ecx
  802470:	8d 51 20             	lea    0x20(%ecx),%edx
  802473:	39 d0                	cmp    %edx,%eax
  802475:	73 e2                	jae    802459 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802477:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80247a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80247e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802481:	99                   	cltd   
  802482:	c1 ea 1b             	shr    $0x1b,%edx
  802485:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802488:	83 e1 1f             	and    $0x1f,%ecx
  80248b:	29 d1                	sub    %edx,%ecx
  80248d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802491:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802495:	83 c0 01             	add    $0x1,%eax
  802498:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80249b:	83 c7 01             	add    $0x1,%edi
  80249e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024a1:	75 c8                	jne    80246b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024a3:	89 f8                	mov    %edi,%eax
  8024a5:	eb 05                	jmp    8024ac <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024ac:	83 c4 1c             	add    $0x1c,%esp
  8024af:	5b                   	pop    %ebx
  8024b0:	5e                   	pop    %esi
  8024b1:	5f                   	pop    %edi
  8024b2:	5d                   	pop    %ebp
  8024b3:	c3                   	ret    

008024b4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	57                   	push   %edi
  8024b8:	56                   	push   %esi
  8024b9:	53                   	push   %ebx
  8024ba:	83 ec 1c             	sub    $0x1c,%esp
  8024bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8024c0:	89 3c 24             	mov    %edi,(%esp)
  8024c3:	e8 08 f1 ff ff       	call   8015d0 <fd2data>
  8024c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024ca:	be 00 00 00 00       	mov    $0x0,%esi
  8024cf:	eb 3d                	jmp    80250e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024d1:	85 f6                	test   %esi,%esi
  8024d3:	74 04                	je     8024d9 <devpipe_read+0x25>
				return i;
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	eb 43                	jmp    80251c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024d9:	89 da                	mov    %ebx,%edx
  8024db:	89 f8                	mov    %edi,%eax
  8024dd:	e8 f1 fe ff ff       	call   8023d3 <_pipeisclosed>
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	75 31                	jne    802517 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024e6:	e8 89 e8 ff ff       	call   800d74 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024eb:	8b 03                	mov    (%ebx),%eax
  8024ed:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024f0:	74 df                	je     8024d1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024f2:	99                   	cltd   
  8024f3:	c1 ea 1b             	shr    $0x1b,%edx
  8024f6:	01 d0                	add    %edx,%eax
  8024f8:	83 e0 1f             	and    $0x1f,%eax
  8024fb:	29 d0                	sub    %edx,%eax
  8024fd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802502:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802505:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802508:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80250b:	83 c6 01             	add    $0x1,%esi
  80250e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802511:	75 d8                	jne    8024eb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802513:	89 f0                	mov    %esi,%eax
  802515:	eb 05                	jmp    80251c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80251c:	83 c4 1c             	add    $0x1c,%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    

00802524 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	56                   	push   %esi
  802528:	53                   	push   %ebx
  802529:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80252c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252f:	89 04 24             	mov    %eax,(%esp)
  802532:	e8 b0 f0 ff ff       	call   8015e7 <fd_alloc>
  802537:	89 c2                	mov    %eax,%edx
  802539:	85 d2                	test   %edx,%edx
  80253b:	0f 88 4d 01 00 00    	js     80268e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802541:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802548:	00 
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802550:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802557:	e8 37 e8 ff ff       	call   800d93 <sys_page_alloc>
  80255c:	89 c2                	mov    %eax,%edx
  80255e:	85 d2                	test   %edx,%edx
  802560:	0f 88 28 01 00 00    	js     80268e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802566:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802569:	89 04 24             	mov    %eax,(%esp)
  80256c:	e8 76 f0 ff ff       	call   8015e7 <fd_alloc>
  802571:	89 c3                	mov    %eax,%ebx
  802573:	85 c0                	test   %eax,%eax
  802575:	0f 88 fe 00 00 00    	js     802679 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802582:	00 
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802591:	e8 fd e7 ff ff       	call   800d93 <sys_page_alloc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 88 d9 00 00 00    	js     802679 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	89 04 24             	mov    %eax,(%esp)
  8025a6:	e8 25 f0 ff ff       	call   8015d0 <fd2data>
  8025ab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ad:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025b4:	00 
  8025b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c0:	e8 ce e7 ff ff       	call   800d93 <sys_page_alloc>
  8025c5:	89 c3                	mov    %eax,%ebx
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	0f 88 97 00 00 00    	js     802666 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	89 04 24             	mov    %eax,(%esp)
  8025d5:	e8 f6 ef ff ff       	call   8015d0 <fd2data>
  8025da:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025e1:	00 
  8025e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025ed:	00 
  8025ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f9:	e8 e9 e7 ff ff       	call   800de7 <sys_page_map>
  8025fe:	89 c3                	mov    %eax,%ebx
  802600:	85 c0                	test   %eax,%eax
  802602:	78 52                	js     802656 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802604:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802619:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	89 04 24             	mov    %eax,(%esp)
  802634:	e8 87 ef ff ff       	call   8015c0 <fd2num>
  802639:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80263c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	89 04 24             	mov    %eax,(%esp)
  802644:	e8 77 ef ff ff       	call   8015c0 <fd2num>
  802649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	eb 38                	jmp    80268e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802656:	89 74 24 04          	mov    %esi,0x4(%esp)
  80265a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802661:	e8 d4 e7 ff ff       	call   800e3a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802669:	89 44 24 04          	mov    %eax,0x4(%esp)
  80266d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802674:	e8 c1 e7 ff ff       	call   800e3a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802680:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802687:	e8 ae e7 ff ff       	call   800e3a <sys_page_unmap>
  80268c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80268e:	83 c4 30             	add    $0x30,%esp
  802691:	5b                   	pop    %ebx
  802692:	5e                   	pop    %esi
  802693:	5d                   	pop    %ebp
  802694:	c3                   	ret    

00802695 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80269b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80269e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	89 04 24             	mov    %eax,(%esp)
  8026a8:	e8 89 ef ff ff       	call   801636 <fd_lookup>
  8026ad:	89 c2                	mov    %eax,%edx
  8026af:	85 d2                	test   %edx,%edx
  8026b1:	78 15                	js     8026c8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	89 04 24             	mov    %eax,(%esp)
  8026b9:	e8 12 ef ff ff       	call   8015d0 <fd2data>
	return _pipeisclosed(fd, p);
  8026be:	89 c2                	mov    %eax,%edx
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	e8 0b fd ff ff       	call   8023d3 <_pipeisclosed>
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	5d                   	pop    %ebp
  8026d9:	c3                   	ret    

008026da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
  8026dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026e0:	c7 44 24 04 87 33 80 	movl   $0x803387,0x4(%esp)
  8026e7:	00 
  8026e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026eb:	89 04 24             	mov    %eax,(%esp)
  8026ee:	e8 84 e2 ff ff       	call   800977 <strcpy>
	return 0;
}
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	57                   	push   %edi
  8026fe:	56                   	push   %esi
  8026ff:	53                   	push   %ebx
  802700:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802706:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80270b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802711:	eb 31                	jmp    802744 <devcons_write+0x4a>
		m = n - tot;
  802713:	8b 75 10             	mov    0x10(%ebp),%esi
  802716:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802718:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80271b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802720:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802723:	89 74 24 08          	mov    %esi,0x8(%esp)
  802727:	03 45 0c             	add    0xc(%ebp),%eax
  80272a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80272e:	89 3c 24             	mov    %edi,(%esp)
  802731:	e8 de e3 ff ff       	call   800b14 <memmove>
		sys_cputs(buf, m);
  802736:	89 74 24 04          	mov    %esi,0x4(%esp)
  80273a:	89 3c 24             	mov    %edi,(%esp)
  80273d:	e8 84 e5 ff ff       	call   800cc6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802742:	01 f3                	add    %esi,%ebx
  802744:	89 d8                	mov    %ebx,%eax
  802746:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802749:	72 c8                	jb     802713 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80274b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    

00802756 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802761:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802765:	75 07                	jne    80276e <devcons_read+0x18>
  802767:	eb 2a                	jmp    802793 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802769:	e8 06 e6 ff ff       	call   800d74 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80276e:	66 90                	xchg   %ax,%ax
  802770:	e8 6f e5 ff ff       	call   800ce4 <sys_cgetc>
  802775:	85 c0                	test   %eax,%eax
  802777:	74 f0                	je     802769 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802779:	85 c0                	test   %eax,%eax
  80277b:	78 16                	js     802793 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80277d:	83 f8 04             	cmp    $0x4,%eax
  802780:	74 0c                	je     80278e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802782:	8b 55 0c             	mov    0xc(%ebp),%edx
  802785:	88 02                	mov    %al,(%edx)
	return 1;
  802787:	b8 01 00 00 00       	mov    $0x1,%eax
  80278c:	eb 05                	jmp    802793 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027a8:	00 
  8027a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027ac:	89 04 24             	mov    %eax,(%esp)
  8027af:	e8 12 e5 ff ff       	call   800cc6 <sys_cputs>
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <getchar>:

int
getchar(void)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8027bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027c3:	00 
  8027c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d2:	e8 f3 f0 ff ff       	call   8018ca <read>
	if (r < 0)
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	78 0f                	js     8027ea <getchar+0x34>
		return r;
	if (r < 1)
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	7e 06                	jle    8027e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027e3:	eb 05                	jmp    8027ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	89 04 24             	mov    %eax,(%esp)
  8027ff:	e8 32 ee ff ff       	call   801636 <fd_lookup>
  802804:	85 c0                	test   %eax,%eax
  802806:	78 11                	js     802819 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802811:	39 10                	cmp    %edx,(%eax)
  802813:	0f 94 c0             	sete   %al
  802816:	0f b6 c0             	movzbl %al,%eax
}
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <opencons>:

int
opencons(void)
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802821:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802824:	89 04 24             	mov    %eax,(%esp)
  802827:	e8 bb ed ff ff       	call   8015e7 <fd_alloc>
		return r;
  80282c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80282e:	85 c0                	test   %eax,%eax
  802830:	78 40                	js     802872 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802832:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802839:	00 
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802841:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802848:	e8 46 e5 ff ff       	call   800d93 <sys_page_alloc>
		return r;
  80284d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80284f:	85 c0                	test   %eax,%eax
  802851:	78 1f                	js     802872 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802853:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802868:	89 04 24             	mov    %eax,(%esp)
  80286b:	e8 50 ed ff ff       	call   8015c0 <fd2num>
  802870:	89 c2                	mov    %eax,%edx
}
  802872:	89 d0                	mov    %edx,%eax
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
  802879:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80287c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802883:	75 70                	jne    8028f5 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  802885:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  80288c:	00 
  80288d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802894:	ee 
  802895:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80289c:	e8 f2 e4 ff ff       	call   800d93 <sys_page_alloc>
		if (error < 0)
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	79 1c                	jns    8028c1 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  8028a5:	c7 44 24 08 94 33 80 	movl   $0x803394,0x8(%esp)
  8028ac:	00 
  8028ad:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8028b4:	00 
  8028b5:	c7 04 24 e7 33 80 00 	movl   $0x8033e7,(%esp)
  8028bc:	e8 90 d9 ff ff       	call   800251 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8028c1:	c7 44 24 04 ff 28 80 	movl   $0x8028ff,0x4(%esp)
  8028c8:	00 
  8028c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d0:	e8 5e e6 ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
		if (error < 0)
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	79 1c                	jns    8028f5 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  8028d9:	c7 44 24 08 bc 33 80 	movl   $0x8033bc,0x8(%esp)
  8028e0:	00 
  8028e1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8028e8:	00 
  8028e9:	c7 04 24 e7 33 80 00 	movl   $0x8033e7,(%esp)
  8028f0:	e8 5c d9 ff ff       	call   800251 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028fd:	c9                   	leave  
  8028fe:	c3                   	ret    

008028ff <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028ff:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802900:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802905:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802907:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  80290a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  80290e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802913:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802917:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802919:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80291c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80291d:	83 c4 04             	add    $0x4,%esp
	popfl
  802920:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802921:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802922:	c3                   	ret    
  802923:	66 90                	xchg   %ax,%ax
  802925:	66 90                	xchg   %ax,%ax
  802927:	66 90                	xchg   %ax,%ax
  802929:	66 90                	xchg   %ax,%ax
  80292b:	66 90                	xchg   %ax,%ax
  80292d:	66 90                	xchg   %ax,%ax
  80292f:	90                   	nop

00802930 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
  802933:	56                   	push   %esi
  802934:	53                   	push   %ebx
  802935:	83 ec 10             	sub    $0x10,%esp
  802938:	8b 75 08             	mov    0x8(%ebp),%esi
  80293b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80293e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802941:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802943:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802948:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80294b:	89 04 24             	mov    %eax,(%esp)
  80294e:	e8 56 e6 ff ff       	call   800fa9 <sys_ipc_recv>
  802953:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802955:	85 d2                	test   %edx,%edx
  802957:	75 24                	jne    80297d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802959:	85 f6                	test   %esi,%esi
  80295b:	74 0a                	je     802967 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80295d:	a1 08 50 80 00       	mov    0x805008,%eax
  802962:	8b 40 74             	mov    0x74(%eax),%eax
  802965:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802967:	85 db                	test   %ebx,%ebx
  802969:	74 0a                	je     802975 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80296b:	a1 08 50 80 00       	mov    0x805008,%eax
  802970:	8b 40 78             	mov    0x78(%eax),%eax
  802973:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802975:	a1 08 50 80 00       	mov    0x805008,%eax
  80297a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80297d:	83 c4 10             	add    $0x10,%esp
  802980:	5b                   	pop    %ebx
  802981:	5e                   	pop    %esi
  802982:	5d                   	pop    %ebp
  802983:	c3                   	ret    

00802984 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	57                   	push   %edi
  802988:	56                   	push   %esi
  802989:	53                   	push   %ebx
  80298a:	83 ec 1c             	sub    $0x1c,%esp
  80298d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802990:	8b 75 0c             	mov    0xc(%ebp),%esi
  802993:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802996:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802998:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80299d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8029a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8029a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029af:	89 3c 24             	mov    %edi,(%esp)
  8029b2:	e8 cf e5 ff ff       	call   800f86 <sys_ipc_try_send>

		if (ret == 0)
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	74 2c                	je     8029e7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8029bb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029be:	74 20                	je     8029e0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8029c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029c4:	c7 44 24 08 f8 33 80 	movl   $0x8033f8,0x8(%esp)
  8029cb:	00 
  8029cc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8029d3:	00 
  8029d4:	c7 04 24 28 34 80 00 	movl   $0x803428,(%esp)
  8029db:	e8 71 d8 ff ff       	call   800251 <_panic>
		}

		sys_yield();
  8029e0:	e8 8f e3 ff ff       	call   800d74 <sys_yield>
	}
  8029e5:	eb b9                	jmp    8029a0 <ipc_send+0x1c>
}
  8029e7:	83 c4 1c             	add    $0x1c,%esp
  8029ea:	5b                   	pop    %ebx
  8029eb:	5e                   	pop    %esi
  8029ec:	5f                   	pop    %edi
  8029ed:	5d                   	pop    %ebp
  8029ee:	c3                   	ret    

008029ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029ef:	55                   	push   %ebp
  8029f0:	89 e5                	mov    %esp,%ebp
  8029f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029fa:	89 c2                	mov    %eax,%edx
  8029fc:	c1 e2 07             	shl    $0x7,%edx
  8029ff:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802a06:	8b 52 50             	mov    0x50(%edx),%edx
  802a09:	39 ca                	cmp    %ecx,%edx
  802a0b:	75 11                	jne    802a1e <ipc_find_env+0x2f>
			return envs[i].env_id;
  802a0d:	89 c2                	mov    %eax,%edx
  802a0f:	c1 e2 07             	shl    $0x7,%edx
  802a12:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802a19:	8b 40 40             	mov    0x40(%eax),%eax
  802a1c:	eb 0e                	jmp    802a2c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a1e:	83 c0 01             	add    $0x1,%eax
  802a21:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a26:	75 d2                	jne    8029fa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802a28:	66 b8 00 00          	mov    $0x0,%ax
}
  802a2c:	5d                   	pop    %ebp
  802a2d:	c3                   	ret    

00802a2e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
  802a31:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a34:	89 d0                	mov    %edx,%eax
  802a36:	c1 e8 16             	shr    $0x16,%eax
  802a39:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a40:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a45:	f6 c1 01             	test   $0x1,%cl
  802a48:	74 1d                	je     802a67 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a4a:	c1 ea 0c             	shr    $0xc,%edx
  802a4d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a54:	f6 c2 01             	test   $0x1,%dl
  802a57:	74 0e                	je     802a67 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a59:	c1 ea 0c             	shr    $0xc,%edx
  802a5c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a63:	ef 
  802a64:	0f b7 c0             	movzwl %ax,%eax
}
  802a67:	5d                   	pop    %ebp
  802a68:	c3                   	ret    
  802a69:	66 90                	xchg   %ax,%ax
  802a6b:	66 90                	xchg   %ax,%ax
  802a6d:	66 90                	xchg   %ax,%ax
  802a6f:	90                   	nop

00802a70 <__udivdi3>:
  802a70:	55                   	push   %ebp
  802a71:	57                   	push   %edi
  802a72:	56                   	push   %esi
  802a73:	83 ec 0c             	sub    $0xc,%esp
  802a76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a7a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a7e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a82:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a86:	85 c0                	test   %eax,%eax
  802a88:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a8c:	89 ea                	mov    %ebp,%edx
  802a8e:	89 0c 24             	mov    %ecx,(%esp)
  802a91:	75 2d                	jne    802ac0 <__udivdi3+0x50>
  802a93:	39 e9                	cmp    %ebp,%ecx
  802a95:	77 61                	ja     802af8 <__udivdi3+0x88>
  802a97:	85 c9                	test   %ecx,%ecx
  802a99:	89 ce                	mov    %ecx,%esi
  802a9b:	75 0b                	jne    802aa8 <__udivdi3+0x38>
  802a9d:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa2:	31 d2                	xor    %edx,%edx
  802aa4:	f7 f1                	div    %ecx
  802aa6:	89 c6                	mov    %eax,%esi
  802aa8:	31 d2                	xor    %edx,%edx
  802aaa:	89 e8                	mov    %ebp,%eax
  802aac:	f7 f6                	div    %esi
  802aae:	89 c5                	mov    %eax,%ebp
  802ab0:	89 f8                	mov    %edi,%eax
  802ab2:	f7 f6                	div    %esi
  802ab4:	89 ea                	mov    %ebp,%edx
  802ab6:	83 c4 0c             	add    $0xc,%esp
  802ab9:	5e                   	pop    %esi
  802aba:	5f                   	pop    %edi
  802abb:	5d                   	pop    %ebp
  802abc:	c3                   	ret    
  802abd:	8d 76 00             	lea    0x0(%esi),%esi
  802ac0:	39 e8                	cmp    %ebp,%eax
  802ac2:	77 24                	ja     802ae8 <__udivdi3+0x78>
  802ac4:	0f bd e8             	bsr    %eax,%ebp
  802ac7:	83 f5 1f             	xor    $0x1f,%ebp
  802aca:	75 3c                	jne    802b08 <__udivdi3+0x98>
  802acc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802ad0:	39 34 24             	cmp    %esi,(%esp)
  802ad3:	0f 86 9f 00 00 00    	jbe    802b78 <__udivdi3+0x108>
  802ad9:	39 d0                	cmp    %edx,%eax
  802adb:	0f 82 97 00 00 00    	jb     802b78 <__udivdi3+0x108>
  802ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ae8:	31 d2                	xor    %edx,%edx
  802aea:	31 c0                	xor    %eax,%eax
  802aec:	83 c4 0c             	add    $0xc,%esp
  802aef:	5e                   	pop    %esi
  802af0:	5f                   	pop    %edi
  802af1:	5d                   	pop    %ebp
  802af2:	c3                   	ret    
  802af3:	90                   	nop
  802af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802af8:	89 f8                	mov    %edi,%eax
  802afa:	f7 f1                	div    %ecx
  802afc:	31 d2                	xor    %edx,%edx
  802afe:	83 c4 0c             	add    $0xc,%esp
  802b01:	5e                   	pop    %esi
  802b02:	5f                   	pop    %edi
  802b03:	5d                   	pop    %ebp
  802b04:	c3                   	ret    
  802b05:	8d 76 00             	lea    0x0(%esi),%esi
  802b08:	89 e9                	mov    %ebp,%ecx
  802b0a:	8b 3c 24             	mov    (%esp),%edi
  802b0d:	d3 e0                	shl    %cl,%eax
  802b0f:	89 c6                	mov    %eax,%esi
  802b11:	b8 20 00 00 00       	mov    $0x20,%eax
  802b16:	29 e8                	sub    %ebp,%eax
  802b18:	89 c1                	mov    %eax,%ecx
  802b1a:	d3 ef                	shr    %cl,%edi
  802b1c:	89 e9                	mov    %ebp,%ecx
  802b1e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b22:	8b 3c 24             	mov    (%esp),%edi
  802b25:	09 74 24 08          	or     %esi,0x8(%esp)
  802b29:	89 d6                	mov    %edx,%esi
  802b2b:	d3 e7                	shl    %cl,%edi
  802b2d:	89 c1                	mov    %eax,%ecx
  802b2f:	89 3c 24             	mov    %edi,(%esp)
  802b32:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b36:	d3 ee                	shr    %cl,%esi
  802b38:	89 e9                	mov    %ebp,%ecx
  802b3a:	d3 e2                	shl    %cl,%edx
  802b3c:	89 c1                	mov    %eax,%ecx
  802b3e:	d3 ef                	shr    %cl,%edi
  802b40:	09 d7                	or     %edx,%edi
  802b42:	89 f2                	mov    %esi,%edx
  802b44:	89 f8                	mov    %edi,%eax
  802b46:	f7 74 24 08          	divl   0x8(%esp)
  802b4a:	89 d6                	mov    %edx,%esi
  802b4c:	89 c7                	mov    %eax,%edi
  802b4e:	f7 24 24             	mull   (%esp)
  802b51:	39 d6                	cmp    %edx,%esi
  802b53:	89 14 24             	mov    %edx,(%esp)
  802b56:	72 30                	jb     802b88 <__udivdi3+0x118>
  802b58:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b5c:	89 e9                	mov    %ebp,%ecx
  802b5e:	d3 e2                	shl    %cl,%edx
  802b60:	39 c2                	cmp    %eax,%edx
  802b62:	73 05                	jae    802b69 <__udivdi3+0xf9>
  802b64:	3b 34 24             	cmp    (%esp),%esi
  802b67:	74 1f                	je     802b88 <__udivdi3+0x118>
  802b69:	89 f8                	mov    %edi,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	e9 7a ff ff ff       	jmp    802aec <__udivdi3+0x7c>
  802b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b78:	31 d2                	xor    %edx,%edx
  802b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b7f:	e9 68 ff ff ff       	jmp    802aec <__udivdi3+0x7c>
  802b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b88:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b8b:	31 d2                	xor    %edx,%edx
  802b8d:	83 c4 0c             	add    $0xc,%esp
  802b90:	5e                   	pop    %esi
  802b91:	5f                   	pop    %edi
  802b92:	5d                   	pop    %ebp
  802b93:	c3                   	ret    
  802b94:	66 90                	xchg   %ax,%ax
  802b96:	66 90                	xchg   %ax,%ax
  802b98:	66 90                	xchg   %ax,%ax
  802b9a:	66 90                	xchg   %ax,%ax
  802b9c:	66 90                	xchg   %ax,%ax
  802b9e:	66 90                	xchg   %ax,%ax

00802ba0 <__umoddi3>:
  802ba0:	55                   	push   %ebp
  802ba1:	57                   	push   %edi
  802ba2:	56                   	push   %esi
  802ba3:	83 ec 14             	sub    $0x14,%esp
  802ba6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802baa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802bb2:	89 c7                	mov    %eax,%edi
  802bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bb8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802bbc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802bc0:	89 34 24             	mov    %esi,(%esp)
  802bc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	89 c2                	mov    %eax,%edx
  802bcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bcf:	75 17                	jne    802be8 <__umoddi3+0x48>
  802bd1:	39 fe                	cmp    %edi,%esi
  802bd3:	76 4b                	jbe    802c20 <__umoddi3+0x80>
  802bd5:	89 c8                	mov    %ecx,%eax
  802bd7:	89 fa                	mov    %edi,%edx
  802bd9:	f7 f6                	div    %esi
  802bdb:	89 d0                	mov    %edx,%eax
  802bdd:	31 d2                	xor    %edx,%edx
  802bdf:	83 c4 14             	add    $0x14,%esp
  802be2:	5e                   	pop    %esi
  802be3:	5f                   	pop    %edi
  802be4:	5d                   	pop    %ebp
  802be5:	c3                   	ret    
  802be6:	66 90                	xchg   %ax,%ax
  802be8:	39 f8                	cmp    %edi,%eax
  802bea:	77 54                	ja     802c40 <__umoddi3+0xa0>
  802bec:	0f bd e8             	bsr    %eax,%ebp
  802bef:	83 f5 1f             	xor    $0x1f,%ebp
  802bf2:	75 5c                	jne    802c50 <__umoddi3+0xb0>
  802bf4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802bf8:	39 3c 24             	cmp    %edi,(%esp)
  802bfb:	0f 87 e7 00 00 00    	ja     802ce8 <__umoddi3+0x148>
  802c01:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c05:	29 f1                	sub    %esi,%ecx
  802c07:	19 c7                	sbb    %eax,%edi
  802c09:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c11:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c15:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c19:	83 c4 14             	add    $0x14,%esp
  802c1c:	5e                   	pop    %esi
  802c1d:	5f                   	pop    %edi
  802c1e:	5d                   	pop    %ebp
  802c1f:	c3                   	ret    
  802c20:	85 f6                	test   %esi,%esi
  802c22:	89 f5                	mov    %esi,%ebp
  802c24:	75 0b                	jne    802c31 <__umoddi3+0x91>
  802c26:	b8 01 00 00 00       	mov    $0x1,%eax
  802c2b:	31 d2                	xor    %edx,%edx
  802c2d:	f7 f6                	div    %esi
  802c2f:	89 c5                	mov    %eax,%ebp
  802c31:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c35:	31 d2                	xor    %edx,%edx
  802c37:	f7 f5                	div    %ebp
  802c39:	89 c8                	mov    %ecx,%eax
  802c3b:	f7 f5                	div    %ebp
  802c3d:	eb 9c                	jmp    802bdb <__umoddi3+0x3b>
  802c3f:	90                   	nop
  802c40:	89 c8                	mov    %ecx,%eax
  802c42:	89 fa                	mov    %edi,%edx
  802c44:	83 c4 14             	add    $0x14,%esp
  802c47:	5e                   	pop    %esi
  802c48:	5f                   	pop    %edi
  802c49:	5d                   	pop    %ebp
  802c4a:	c3                   	ret    
  802c4b:	90                   	nop
  802c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c50:	8b 04 24             	mov    (%esp),%eax
  802c53:	be 20 00 00 00       	mov    $0x20,%esi
  802c58:	89 e9                	mov    %ebp,%ecx
  802c5a:	29 ee                	sub    %ebp,%esi
  802c5c:	d3 e2                	shl    %cl,%edx
  802c5e:	89 f1                	mov    %esi,%ecx
  802c60:	d3 e8                	shr    %cl,%eax
  802c62:	89 e9                	mov    %ebp,%ecx
  802c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c68:	8b 04 24             	mov    (%esp),%eax
  802c6b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c6f:	89 fa                	mov    %edi,%edx
  802c71:	d3 e0                	shl    %cl,%eax
  802c73:	89 f1                	mov    %esi,%ecx
  802c75:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c79:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c7d:	d3 ea                	shr    %cl,%edx
  802c7f:	89 e9                	mov    %ebp,%ecx
  802c81:	d3 e7                	shl    %cl,%edi
  802c83:	89 f1                	mov    %esi,%ecx
  802c85:	d3 e8                	shr    %cl,%eax
  802c87:	89 e9                	mov    %ebp,%ecx
  802c89:	09 f8                	or     %edi,%eax
  802c8b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c8f:	f7 74 24 04          	divl   0x4(%esp)
  802c93:	d3 e7                	shl    %cl,%edi
  802c95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c99:	89 d7                	mov    %edx,%edi
  802c9b:	f7 64 24 08          	mull   0x8(%esp)
  802c9f:	39 d7                	cmp    %edx,%edi
  802ca1:	89 c1                	mov    %eax,%ecx
  802ca3:	89 14 24             	mov    %edx,(%esp)
  802ca6:	72 2c                	jb     802cd4 <__umoddi3+0x134>
  802ca8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802cac:	72 22                	jb     802cd0 <__umoddi3+0x130>
  802cae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802cb2:	29 c8                	sub    %ecx,%eax
  802cb4:	19 d7                	sbb    %edx,%edi
  802cb6:	89 e9                	mov    %ebp,%ecx
  802cb8:	89 fa                	mov    %edi,%edx
  802cba:	d3 e8                	shr    %cl,%eax
  802cbc:	89 f1                	mov    %esi,%ecx
  802cbe:	d3 e2                	shl    %cl,%edx
  802cc0:	89 e9                	mov    %ebp,%ecx
  802cc2:	d3 ef                	shr    %cl,%edi
  802cc4:	09 d0                	or     %edx,%eax
  802cc6:	89 fa                	mov    %edi,%edx
  802cc8:	83 c4 14             	add    $0x14,%esp
  802ccb:	5e                   	pop    %esi
  802ccc:	5f                   	pop    %edi
  802ccd:	5d                   	pop    %ebp
  802cce:	c3                   	ret    
  802ccf:	90                   	nop
  802cd0:	39 d7                	cmp    %edx,%edi
  802cd2:	75 da                	jne    802cae <__umoddi3+0x10e>
  802cd4:	8b 14 24             	mov    (%esp),%edx
  802cd7:	89 c1                	mov    %eax,%ecx
  802cd9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802cdd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802ce1:	eb cb                	jmp    802cae <__umoddi3+0x10e>
  802ce3:	90                   	nop
  802ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ce8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802cec:	0f 82 0f ff ff ff    	jb     802c01 <__umoddi3+0x61>
  802cf2:	e9 1a ff ff ff       	jmp    802c11 <__umoddi3+0x71>
