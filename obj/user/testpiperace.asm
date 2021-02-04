
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 f7 01 00 00       	call   800228 <libmain>
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
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800048:	c7 04 24 20 2d 80 00 	movl   $0x802d20,(%esp)
  80004f:	e8 32 03 00 00       	call   800386 <cprintf>
	if ((r = pipe(p)) < 0)
  800054:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800057:	89 04 24             	mov    %eax,(%esp)
  80005a:	e8 25 26 00 00       	call   802684 <pipe>
  80005f:	85 c0                	test   %eax,%eax
  800061:	79 20                	jns    800083 <umain+0x43>
		panic("pipe: %e", r);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 39 2d 80 	movl   $0x802d39,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 42 2d 80 00 	movl   $0x802d42,(%esp)
  80007e:	e8 0a 02 00 00       	call   80028d <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800083:	e8 92 12 00 00       	call   80131a <fork>
  800088:	89 c6                	mov    %eax,%esi
  80008a:	85 c0                	test   %eax,%eax
  80008c:	79 20                	jns    8000ae <umain+0x6e>
		panic("fork: %e", r);
  80008e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800092:	c7 44 24 08 56 2d 80 	movl   $0x802d56,0x8(%esp)
  800099:	00 
  80009a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  8000a1:	00 
  8000a2:	c7 04 24 42 2d 80 00 	movl   $0x802d42,(%esp)
  8000a9:	e8 df 01 00 00       	call   80028d <_panic>
	if (r == 0) {
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 56                	jne    800108 <umain+0xc8>
		close(p[1]);
  8000b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b5:	89 04 24             	mov    %eax,(%esp)
  8000b8:	e8 da 17 00 00       	call   801897 <close>
  8000bd:	bb c8 00 00 00       	mov    $0xc8,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	89 04 24             	mov    %eax,(%esp)
  8000c8:	e8 28 27 00 00       	call   8027f5 <pipeisclosed>
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	74 11                	je     8000e2 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000d1:	c7 04 24 5f 2d 80 00 	movl   $0x802d5f,(%esp)
  8000d8:	e8 a9 02 00 00       	call   800386 <cprintf>
				exit();
  8000dd:	e8 92 01 00 00       	call   800274 <exit>
			}
			sys_yield();
  8000e2:	e8 bd 0c 00 00       	call   800da4 <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000e7:	83 eb 01             	sub    $0x1,%ebx
  8000ea:	75 d6                	jne    8000c2 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000f3:	00 
  8000f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fb:	00 
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 e8 14 00 00       	call   8015f0 <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800108:	89 74 24 04          	mov    %esi,0x4(%esp)
  80010c:	c7 04 24 7a 2d 80 00 	movl   $0x802d7a,(%esp)
  800113:	e8 6e 02 00 00       	call   800386 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800118:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80011e:	89 f0                	mov    %esi,%eax
  800120:	c1 e0 07             	shl    $0x7,%eax
  800123:	8d 9c b0 00 00 c0 ee 	lea    -0x11400000(%eax,%esi,4),%ebx
	cprintf("kid is %d\n", kid-envs);
  80012a:	89 d8                	mov    %ebx,%eax
  80012c:	2d 00 00 c0 ee       	sub    $0xeec00000,%eax
  800131:	c1 f8 02             	sar    $0x2,%eax
  800134:	69 c0 e1 83 0f 3e    	imul   $0x3e0f83e1,%eax,%eax
  80013a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013e:	c7 04 24 85 2d 80 00 	movl   $0x802d85,(%esp)
  800145:	e8 3c 02 00 00       	call   800386 <cprintf>
	dup(p[0], 10);
  80014a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800151:	00 
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	89 04 24             	mov    %eax,(%esp)
  800158:	e8 8f 17 00 00       	call   8018ec <dup>
	while (kid->env_status == ENV_RUNNABLE)
  80015d:	eb 13                	jmp    800172 <umain+0x132>
		dup(p[0], 10);
  80015f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800166:	00 
  800167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80016a:	89 04 24             	mov    %eax,(%esp)
  80016d:	e8 7a 17 00 00       	call   8018ec <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800172:	8b 43 54             	mov    0x54(%ebx),%eax
  800175:	83 f8 02             	cmp    $0x2,%eax
  800178:	74 e5                	je     80015f <umain+0x11f>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  80017a:	c7 04 24 90 2d 80 00 	movl   $0x802d90,(%esp)
  800181:	e8 00 02 00 00       	call   800386 <cprintf>
	if (pipeisclosed(p[0]))
  800186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800189:	89 04 24             	mov    %eax,(%esp)
  80018c:	e8 64 26 00 00       	call   8027f5 <pipeisclosed>
  800191:	85 c0                	test   %eax,%eax
  800193:	74 1c                	je     8001b1 <umain+0x171>
		panic("somehow the other end of p[0] got closed!");
  800195:	c7 44 24 08 ec 2d 80 	movl   $0x802dec,0x8(%esp)
  80019c:	00 
  80019d:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8001a4:	00 
  8001a5:	c7 04 24 42 2d 80 00 	movl   $0x802d42,(%esp)
  8001ac:	e8 dc 00 00 00       	call   80028d <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001bb:	89 04 24             	mov    %eax,(%esp)
  8001be:	e8 a3 15 00 00       	call   801766 <fd_lookup>
  8001c3:	85 c0                	test   %eax,%eax
  8001c5:	79 20                	jns    8001e7 <umain+0x1a7>
		panic("cannot look up p[0]: %e", r);
  8001c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001cb:	c7 44 24 08 a6 2d 80 	movl   $0x802da6,0x8(%esp)
  8001d2:	00 
  8001d3:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001da:	00 
  8001db:	c7 04 24 42 2d 80 00 	movl   $0x802d42,(%esp)
  8001e2:	e8 a6 00 00 00       	call   80028d <_panic>
	va = fd2data(fd);
  8001e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001ea:	89 04 24             	mov    %eax,(%esp)
  8001ed:	e8 0e 15 00 00       	call   801700 <fd2data>
	if (pageref(va) != 3+1)
  8001f2:	89 04 24             	mov    %eax,(%esp)
  8001f5:	e8 67 1d 00 00       	call   801f61 <pageref>
  8001fa:	83 f8 04             	cmp    $0x4,%eax
  8001fd:	74 0e                	je     80020d <umain+0x1cd>
		cprintf("\nchild detected race\n");
  8001ff:	c7 04 24 be 2d 80 00 	movl   $0x802dbe,(%esp)
  800206:	e8 7b 01 00 00       	call   800386 <cprintf>
  80020b:	eb 14                	jmp    800221 <umain+0x1e1>
	else
		cprintf("\nrace didn't happen\n", max);
  80020d:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  800214:	00 
  800215:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  80021c:	e8 65 01 00 00       	call   800386 <cprintf>
}
  800221:	83 c4 20             	add    $0x20,%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	56                   	push   %esi
  80022c:	53                   	push   %ebx
  80022d:	83 ec 10             	sub    $0x10,%esp
  800230:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800233:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800236:	e8 4a 0b 00 00       	call   800d85 <sys_getenvid>
  80023b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800240:	89 c2                	mov    %eax,%edx
  800242:	c1 e2 07             	shl    $0x7,%edx
  800245:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80024c:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800251:	85 db                	test   %ebx,%ebx
  800253:	7e 07                	jle    80025c <libmain+0x34>
		binaryname = argv[0];
  800255:	8b 06                	mov    (%esi),%eax
  800257:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80025c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800260:	89 1c 24             	mov    %ebx,(%esp)
  800263:	e8 d8 fd ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800268:	e8 07 00 00 00       	call   800274 <exit>
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	5b                   	pop    %ebx
  800271:	5e                   	pop    %esi
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    

00800274 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80027a:	e8 4b 16 00 00       	call   8018ca <close_all>
	sys_env_destroy(0);
  80027f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800286:	e8 a8 0a 00 00       	call   800d33 <sys_env_destroy>
}
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800295:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800298:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80029e:	e8 e2 0a 00 00       	call   800d85 <sys_getenvid>
  8002a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ad:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002b1:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b9:	c7 04 24 20 2e 80 00 	movl   $0x802e20,(%esp)
  8002c0:	e8 c1 00 00 00       	call   800386 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	89 04 24             	mov    %eax,(%esp)
  8002cf:	e8 51 00 00 00       	call   800325 <vcprintf>
	cprintf("\n");
  8002d4:	c7 04 24 37 2d 80 00 	movl   $0x802d37,(%esp)
  8002db:	e8 a6 00 00 00       	call   800386 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002e0:	cc                   	int3   
  8002e1:	eb fd                	jmp    8002e0 <_panic+0x53>

008002e3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	53                   	push   %ebx
  8002e7:	83 ec 14             	sub    $0x14,%esp
  8002ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ed:	8b 13                	mov    (%ebx),%edx
  8002ef:	8d 42 01             	lea    0x1(%edx),%eax
  8002f2:	89 03                	mov    %eax,(%ebx)
  8002f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800300:	75 19                	jne    80031b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800302:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800309:	00 
  80030a:	8d 43 08             	lea    0x8(%ebx),%eax
  80030d:	89 04 24             	mov    %eax,(%esp)
  800310:	e8 e1 09 00 00       	call   800cf6 <sys_cputs>
		b->idx = 0;
  800315:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80031b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031f:	83 c4 14             	add    $0x14,%esp
  800322:	5b                   	pop    %ebx
  800323:	5d                   	pop    %ebp
  800324:	c3                   	ret    

00800325 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80032e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800335:	00 00 00 
	b.cnt = 0;
  800338:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80033f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800349:	8b 45 08             	mov    0x8(%ebp),%eax
  80034c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800350:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800356:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035a:	c7 04 24 e3 02 80 00 	movl   $0x8002e3,(%esp)
  800361:	e8 a8 01 00 00       	call   80050e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800366:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80036c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800370:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800376:	89 04 24             	mov    %eax,(%esp)
  800379:	e8 78 09 00 00       	call   800cf6 <sys_cputs>

	return b.cnt;
}
  80037e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80038c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80038f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800393:	8b 45 08             	mov    0x8(%ebp),%eax
  800396:	89 04 24             	mov    %eax,(%esp)
  800399:	e8 87 ff ff ff       	call   800325 <vcprintf>
	va_end(ap);

	return cnt;
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 3c             	sub    $0x3c,%esp
  8003a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ac:	89 d7                	mov    %edx,%edi
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	89 c3                	mov    %eax,%ebx
  8003b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003cd:	39 d9                	cmp    %ebx,%ecx
  8003cf:	72 05                	jb     8003d6 <printnum+0x36>
  8003d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d4:	77 69                	ja     80043f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003dd:	83 ee 01             	sub    $0x1,%esi
  8003e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003f0:	89 c3                	mov    %eax,%ebx
  8003f2:	89 d6                	mov    %edx,%esi
  8003f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 7c 26 00 00       	call   802a90 <__udivdi3>
  800414:	89 d9                	mov    %ebx,%ecx
  800416:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80041a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80041e:	89 04 24             	mov    %eax,(%esp)
  800421:	89 54 24 04          	mov    %edx,0x4(%esp)
  800425:	89 fa                	mov    %edi,%edx
  800427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80042a:	e8 71 ff ff ff       	call   8003a0 <printnum>
  80042f:	eb 1b                	jmp    80044c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800431:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800435:	8b 45 18             	mov    0x18(%ebp),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	ff d3                	call   *%ebx
  80043d:	eb 03                	jmp    800442 <printnum+0xa2>
  80043f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800442:	83 ee 01             	sub    $0x1,%esi
  800445:	85 f6                	test   %esi,%esi
  800447:	7f e8                	jg     800431 <printnum+0x91>
  800449:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80044c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800450:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800457:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80045a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80045e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800465:	89 04 24             	mov    %eax,(%esp)
  800468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046f:	e8 4c 27 00 00       	call   802bc0 <__umoddi3>
  800474:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800478:	0f be 80 43 2e 80 00 	movsbl 0x802e43(%eax),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800485:	ff d0                	call   *%eax
}
  800487:	83 c4 3c             	add    $0x3c,%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 fa 01             	cmp    $0x1,%edx
  800495:	7e 0e                	jle    8004a5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800497:	8b 10                	mov    (%eax),%edx
  800499:	8d 4a 08             	lea    0x8(%edx),%ecx
  80049c:	89 08                	mov    %ecx,(%eax)
  80049e:	8b 02                	mov    (%edx),%eax
  8004a0:	8b 52 04             	mov    0x4(%edx),%edx
  8004a3:	eb 22                	jmp    8004c7 <getuint+0x38>
	else if (lflag)
  8004a5:	85 d2                	test   %edx,%edx
  8004a7:	74 10                	je     8004b9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004a9:	8b 10                	mov    (%eax),%edx
  8004ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ae:	89 08                	mov    %ecx,(%eax)
  8004b0:	8b 02                	mov    (%edx),%eax
  8004b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b7:	eb 0e                	jmp    8004c7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004b9:	8b 10                	mov    (%eax),%edx
  8004bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004be:	89 08                	mov    %ecx,(%eax)
  8004c0:	8b 02                	mov    (%edx),%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c7:	5d                   	pop    %ebp
  8004c8:	c3                   	ret    

008004c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d3:	8b 10                	mov    (%eax),%edx
  8004d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d8:	73 0a                	jae    8004e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004dd:	89 08                	mov    %ecx,(%eax)
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	88 02                	mov    %al,(%edx)
}
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	89 04 24             	mov    %eax,(%esp)
  800507:	e8 02 00 00 00       	call   80050e <vprintfmt>
	va_end(ap);
}
  80050c:	c9                   	leave  
  80050d:	c3                   	ret    

0080050e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	57                   	push   %edi
  800512:	56                   	push   %esi
  800513:	53                   	push   %ebx
  800514:	83 ec 3c             	sub    $0x3c,%esp
  800517:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80051a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80051d:	eb 14                	jmp    800533 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80051f:	85 c0                	test   %eax,%eax
  800521:	0f 84 b3 03 00 00    	je     8008da <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	89 04 24             	mov    %eax,(%esp)
  80052e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800531:	89 f3                	mov    %esi,%ebx
  800533:	8d 73 01             	lea    0x1(%ebx),%esi
  800536:	0f b6 03             	movzbl (%ebx),%eax
  800539:	83 f8 25             	cmp    $0x25,%eax
  80053c:	75 e1                	jne    80051f <vprintfmt+0x11>
  80053e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800542:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800549:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800550:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800557:	ba 00 00 00 00       	mov    $0x0,%edx
  80055c:	eb 1d                	jmp    80057b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800560:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800564:	eb 15                	jmp    80057b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800568:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80056c:	eb 0d                	jmp    80057b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80056e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800571:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800574:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80057e:	0f b6 0e             	movzbl (%esi),%ecx
  800581:	0f b6 c1             	movzbl %cl,%eax
  800584:	83 e9 23             	sub    $0x23,%ecx
  800587:	80 f9 55             	cmp    $0x55,%cl
  80058a:	0f 87 2a 03 00 00    	ja     8008ba <vprintfmt+0x3ac>
  800590:	0f b6 c9             	movzbl %cl,%ecx
  800593:	ff 24 8d c0 2f 80 00 	jmp    *0x802fc0(,%ecx,4)
  80059a:	89 de                	mov    %ebx,%esi
  80059c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005a1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005a8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005ae:	83 fb 09             	cmp    $0x9,%ebx
  8005b1:	77 36                	ja     8005e9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005b6:	eb e9                	jmp    8005a1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8005be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005c8:	eb 22                	jmp    8005ec <vprintfmt+0xde>
  8005ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d4:	0f 49 c1             	cmovns %ecx,%eax
  8005d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	89 de                	mov    %ebx,%esi
  8005dc:	eb 9d                	jmp    80057b <vprintfmt+0x6d>
  8005de:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005e0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8005e7:	eb 92                	jmp    80057b <vprintfmt+0x6d>
  8005e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8005ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f0:	79 89                	jns    80057b <vprintfmt+0x6d>
  8005f2:	e9 77 ff ff ff       	jmp    80056e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005f7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005fc:	e9 7a ff ff ff       	jmp    80057b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 50 04             	lea    0x4(%eax),%edx
  800607:	89 55 14             	mov    %edx,0x14(%ebp)
  80060a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	89 04 24             	mov    %eax,(%esp)
  800613:	ff 55 08             	call   *0x8(%ebp)
			break;
  800616:	e9 18 ff ff ff       	jmp    800533 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8d 50 04             	lea    0x4(%eax),%edx
  800621:	89 55 14             	mov    %edx,0x14(%ebp)
  800624:	8b 00                	mov    (%eax),%eax
  800626:	99                   	cltd   
  800627:	31 d0                	xor    %edx,%eax
  800629:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062b:	83 f8 12             	cmp    $0x12,%eax
  80062e:	7f 0b                	jg     80063b <vprintfmt+0x12d>
  800630:	8b 14 85 20 31 80 00 	mov    0x803120(,%eax,4),%edx
  800637:	85 d2                	test   %edx,%edx
  800639:	75 20                	jne    80065b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80063b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80063f:	c7 44 24 08 5b 2e 80 	movl   $0x802e5b,0x8(%esp)
  800646:	00 
  800647:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	89 04 24             	mov    %eax,(%esp)
  800651:	e8 90 fe ff ff       	call   8004e6 <printfmt>
  800656:	e9 d8 fe ff ff       	jmp    800533 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80065b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80065f:	c7 44 24 08 8d 33 80 	movl   $0x80338d,0x8(%esp)
  800666:	00 
  800667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	89 04 24             	mov    %eax,(%esp)
  800671:	e8 70 fe ff ff       	call   8004e6 <printfmt>
  800676:	e9 b8 fe ff ff       	jmp    800533 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80067e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800681:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	89 55 14             	mov    %edx,0x14(%ebp)
  80068d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80068f:	85 f6                	test   %esi,%esi
  800691:	b8 54 2e 80 00       	mov    $0x802e54,%eax
  800696:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800699:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80069d:	0f 84 97 00 00 00    	je     80073a <vprintfmt+0x22c>
  8006a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006a7:	0f 8e 9b 00 00 00    	jle    800748 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006b1:	89 34 24             	mov    %esi,(%esp)
  8006b4:	e8 cf 02 00 00       	call   800988 <strnlen>
  8006b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006bc:	29 c2                	sub    %eax,%edx
  8006be:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8006c1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d3:	eb 0f                	jmp    8006e4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8006d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006dc:	89 04 24             	mov    %eax,(%esp)
  8006df:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e1:	83 eb 01             	sub    $0x1,%ebx
  8006e4:	85 db                	test   %ebx,%ebx
  8006e6:	7f ed                	jg     8006d5 <vprintfmt+0x1c7>
  8006e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ee:	85 d2                	test   %edx,%edx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c2             	cmovns %edx,%eax
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006fd:	89 d7                	mov    %edx,%edi
  8006ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800702:	eb 50                	jmp    800754 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800704:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800708:	74 1e                	je     800728 <vprintfmt+0x21a>
  80070a:	0f be d2             	movsbl %dl,%edx
  80070d:	83 ea 20             	sub    $0x20,%edx
  800710:	83 fa 5e             	cmp    $0x5e,%edx
  800713:	76 13                	jbe    800728 <vprintfmt+0x21a>
					putch('?', putdat);
  800715:	8b 45 0c             	mov    0xc(%ebp),%eax
  800718:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800723:	ff 55 08             	call   *0x8(%ebp)
  800726:	eb 0d                	jmp    800735 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	83 ef 01             	sub    $0x1,%edi
  800738:	eb 1a                	jmp    800754 <vprintfmt+0x246>
  80073a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80073d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800740:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800743:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800746:	eb 0c                	jmp    800754 <vprintfmt+0x246>
  800748:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80074b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80074e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800751:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800754:	83 c6 01             	add    $0x1,%esi
  800757:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80075b:	0f be c2             	movsbl %dl,%eax
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 27                	je     800789 <vprintfmt+0x27b>
  800762:	85 db                	test   %ebx,%ebx
  800764:	78 9e                	js     800704 <vprintfmt+0x1f6>
  800766:	83 eb 01             	sub    $0x1,%ebx
  800769:	79 99                	jns    800704 <vprintfmt+0x1f6>
  80076b:	89 f8                	mov    %edi,%eax
  80076d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800770:	8b 75 08             	mov    0x8(%ebp),%esi
  800773:	89 c3                	mov    %eax,%ebx
  800775:	eb 1a                	jmp    800791 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800777:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800782:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800784:	83 eb 01             	sub    $0x1,%ebx
  800787:	eb 08                	jmp    800791 <vprintfmt+0x283>
  800789:	89 fb                	mov    %edi,%ebx
  80078b:	8b 75 08             	mov    0x8(%ebp),%esi
  80078e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800791:	85 db                	test   %ebx,%ebx
  800793:	7f e2                	jg     800777 <vprintfmt+0x269>
  800795:	89 75 08             	mov    %esi,0x8(%ebp)
  800798:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80079b:	e9 93 fd ff ff       	jmp    800533 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007a0:	83 fa 01             	cmp    $0x1,%edx
  8007a3:	7e 16                	jle    8007bb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8d 50 08             	lea    0x8(%eax),%edx
  8007ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ae:	8b 50 04             	mov    0x4(%eax),%edx
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007b9:	eb 32                	jmp    8007ed <vprintfmt+0x2df>
	else if (lflag)
  8007bb:	85 d2                	test   %edx,%edx
  8007bd:	74 18                	je     8007d7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 50 04             	lea    0x4(%eax),%edx
  8007c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c8:	8b 30                	mov    (%eax),%esi
  8007ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	c1 f8 1f             	sar    $0x1f,%eax
  8007d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d5:	eb 16                	jmp    8007ed <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 50 04             	lea    0x4(%eax),%edx
  8007dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e0:	8b 30                	mov    (%eax),%esi
  8007e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007e5:	89 f0                	mov    %esi,%eax
  8007e7:	c1 f8 1f             	sar    $0x1f,%eax
  8007ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fc:	0f 89 80 00 00 00    	jns    800882 <vprintfmt+0x374>
				putch('-', putdat);
  800802:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800806:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80080d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800816:	f7 d8                	neg    %eax
  800818:	83 d2 00             	adc    $0x0,%edx
  80081b:	f7 da                	neg    %edx
			}
			base = 10;
  80081d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800822:	eb 5e                	jmp    800882 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
  800827:	e8 63 fc ff ff       	call   80048f <getuint>
			base = 10;
  80082c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800831:	eb 4f                	jmp    800882 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800833:	8d 45 14             	lea    0x14(%ebp),%eax
  800836:	e8 54 fc ff ff       	call   80048f <getuint>
			base = 8;
  80083b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800840:	eb 40                	jmp    800882 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800842:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800846:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80084d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800850:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800854:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80085b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8d 50 04             	lea    0x4(%eax),%edx
  800864:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800867:	8b 00                	mov    (%eax),%eax
  800869:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80086e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800873:	eb 0d                	jmp    800882 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
  800878:	e8 12 fc ff ff       	call   80048f <getuint>
			base = 16;
  80087d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800882:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800886:	89 74 24 10          	mov    %esi,0x10(%esp)
  80088a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80088d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800891:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800895:	89 04 24             	mov    %eax,(%esp)
  800898:	89 54 24 04          	mov    %edx,0x4(%esp)
  80089c:	89 fa                	mov    %edi,%edx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	e8 fa fa ff ff       	call   8003a0 <printnum>
			break;
  8008a6:	e9 88 fc ff ff       	jmp    800533 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008af:	89 04 24             	mov    %eax,(%esp)
  8008b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008b5:	e9 79 fc ff ff       	jmp    800533 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008be:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c8:	89 f3                	mov    %esi,%ebx
  8008ca:	eb 03                	jmp    8008cf <vprintfmt+0x3c1>
  8008cc:	83 eb 01             	sub    $0x1,%ebx
  8008cf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008d3:	75 f7                	jne    8008cc <vprintfmt+0x3be>
  8008d5:	e9 59 fc ff ff       	jmp    800533 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008da:	83 c4 3c             	add    $0x3c,%esp
  8008dd:	5b                   	pop    %ebx
  8008de:	5e                   	pop    %esi
  8008df:	5f                   	pop    %edi
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 28             	sub    $0x28,%esp
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ff:	85 c0                	test   %eax,%eax
  800901:	74 30                	je     800933 <vsnprintf+0x51>
  800903:	85 d2                	test   %edx,%edx
  800905:	7e 2c                	jle    800933 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80090e:	8b 45 10             	mov    0x10(%ebp),%eax
  800911:	89 44 24 08          	mov    %eax,0x8(%esp)
  800915:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091c:	c7 04 24 c9 04 80 00 	movl   $0x8004c9,(%esp)
  800923:	e8 e6 fb ff ff       	call   80050e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800931:	eb 05                	jmp    800938 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800933:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800940:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800943:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800947:	8b 45 10             	mov    0x10(%ebp),%eax
  80094a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	89 44 24 04          	mov    %eax,0x4(%esp)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	89 04 24             	mov    %eax,(%esp)
  80095b:	e8 82 ff ff ff       	call   8008e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800960:	c9                   	leave  
  800961:	c3                   	ret    
  800962:	66 90                	xchg   %ax,%ax
  800964:	66 90                	xchg   %ax,%ax
  800966:	66 90                	xchg   %ax,%ax
  800968:	66 90                	xchg   %ax,%ax
  80096a:	66 90                	xchg   %ax,%ax
  80096c:	66 90                	xchg   %ax,%ax
  80096e:	66 90                	xchg   %ax,%ax

00800970 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	eb 03                	jmp    800980 <strlen+0x10>
		n++;
  80097d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800980:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800984:	75 f7                	jne    80097d <strlen+0xd>
		n++;
	return n;
}
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800991:	b8 00 00 00 00       	mov    $0x0,%eax
  800996:	eb 03                	jmp    80099b <strnlen+0x13>
		n++;
  800998:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099b:	39 d0                	cmp    %edx,%eax
  80099d:	74 06                	je     8009a5 <strnlen+0x1d>
  80099f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009a3:	75 f3                	jne    800998 <strnlen+0x10>
		n++;
	return n;
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	53                   	push   %ebx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b1:	89 c2                	mov    %eax,%edx
  8009b3:	83 c2 01             	add    $0x1,%edx
  8009b6:	83 c1 01             	add    $0x1,%ecx
  8009b9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009bd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c0:	84 db                	test   %bl,%bl
  8009c2:	75 ef                	jne    8009b3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009c4:	5b                   	pop    %ebx
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	53                   	push   %ebx
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d1:	89 1c 24             	mov    %ebx,(%esp)
  8009d4:	e8 97 ff ff ff       	call   800970 <strlen>
	strcpy(dst + len, src);
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009e0:	01 d8                	add    %ebx,%eax
  8009e2:	89 04 24             	mov    %eax,(%esp)
  8009e5:	e8 bd ff ff ff       	call   8009a7 <strcpy>
	return dst;
}
  8009ea:	89 d8                	mov    %ebx,%eax
  8009ec:	83 c4 08             	add    $0x8,%esp
  8009ef:	5b                   	pop    %ebx
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fd:	89 f3                	mov    %esi,%ebx
  8009ff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a02:	89 f2                	mov    %esi,%edx
  800a04:	eb 0f                	jmp    800a15 <strncpy+0x23>
		*dst++ = *src;
  800a06:	83 c2 01             	add    $0x1,%edx
  800a09:	0f b6 01             	movzbl (%ecx),%eax
  800a0c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a0f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a12:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a15:	39 da                	cmp    %ebx,%edx
  800a17:	75 ed                	jne    800a06 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a19:	89 f0                	mov    %esi,%eax
  800a1b:	5b                   	pop    %ebx
  800a1c:	5e                   	pop    %esi
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	56                   	push   %esi
  800a23:	53                   	push   %ebx
  800a24:	8b 75 08             	mov    0x8(%ebp),%esi
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a2d:	89 f0                	mov    %esi,%eax
  800a2f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	75 0b                	jne    800a42 <strlcpy+0x23>
  800a37:	eb 1d                	jmp    800a56 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a42:	39 d8                	cmp    %ebx,%eax
  800a44:	74 0b                	je     800a51 <strlcpy+0x32>
  800a46:	0f b6 0a             	movzbl (%edx),%ecx
  800a49:	84 c9                	test   %cl,%cl
  800a4b:	75 ec                	jne    800a39 <strlcpy+0x1a>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	eb 02                	jmp    800a53 <strlcpy+0x34>
  800a51:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a53:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a56:	29 f0                	sub    %esi,%eax
}
  800a58:	5b                   	pop    %ebx
  800a59:	5e                   	pop    %esi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a65:	eb 06                	jmp    800a6d <strcmp+0x11>
		p++, q++;
  800a67:	83 c1 01             	add    $0x1,%ecx
  800a6a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a6d:	0f b6 01             	movzbl (%ecx),%eax
  800a70:	84 c0                	test   %al,%al
  800a72:	74 04                	je     800a78 <strcmp+0x1c>
  800a74:	3a 02                	cmp    (%edx),%al
  800a76:	74 ef                	je     800a67 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a78:	0f b6 c0             	movzbl %al,%eax
  800a7b:	0f b6 12             	movzbl (%edx),%edx
  800a7e:	29 d0                	sub    %edx,%eax
}
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	53                   	push   %ebx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8c:	89 c3                	mov    %eax,%ebx
  800a8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a91:	eb 06                	jmp    800a99 <strncmp+0x17>
		n--, p++, q++;
  800a93:	83 c0 01             	add    $0x1,%eax
  800a96:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a99:	39 d8                	cmp    %ebx,%eax
  800a9b:	74 15                	je     800ab2 <strncmp+0x30>
  800a9d:	0f b6 08             	movzbl (%eax),%ecx
  800aa0:	84 c9                	test   %cl,%cl
  800aa2:	74 04                	je     800aa8 <strncmp+0x26>
  800aa4:	3a 0a                	cmp    (%edx),%cl
  800aa6:	74 eb                	je     800a93 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa8:	0f b6 00             	movzbl (%eax),%eax
  800aab:	0f b6 12             	movzbl (%edx),%edx
  800aae:	29 d0                	sub    %edx,%eax
  800ab0:	eb 05                	jmp    800ab7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac4:	eb 07                	jmp    800acd <strchr+0x13>
		if (*s == c)
  800ac6:	38 ca                	cmp    %cl,%dl
  800ac8:	74 0f                	je     800ad9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	0f b6 10             	movzbl (%eax),%edx
  800ad0:	84 d2                	test   %dl,%dl
  800ad2:	75 f2                	jne    800ac6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae5:	eb 07                	jmp    800aee <strfind+0x13>
		if (*s == c)
  800ae7:	38 ca                	cmp    %cl,%dl
  800ae9:	74 0a                	je     800af5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	0f b6 10             	movzbl (%eax),%edx
  800af1:	84 d2                	test   %dl,%dl
  800af3:	75 f2                	jne    800ae7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	57                   	push   %edi
  800afb:	56                   	push   %esi
  800afc:	53                   	push   %ebx
  800afd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b03:	85 c9                	test   %ecx,%ecx
  800b05:	74 36                	je     800b3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0d:	75 28                	jne    800b37 <memset+0x40>
  800b0f:	f6 c1 03             	test   $0x3,%cl
  800b12:	75 23                	jne    800b37 <memset+0x40>
		c &= 0xFF;
  800b14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b18:	89 d3                	mov    %edx,%ebx
  800b1a:	c1 e3 08             	shl    $0x8,%ebx
  800b1d:	89 d6                	mov    %edx,%esi
  800b1f:	c1 e6 18             	shl    $0x18,%esi
  800b22:	89 d0                	mov    %edx,%eax
  800b24:	c1 e0 10             	shl    $0x10,%eax
  800b27:	09 f0                	or     %esi,%eax
  800b29:	09 c2                	or     %eax,%edx
  800b2b:	89 d0                	mov    %edx,%eax
  800b2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b32:	fc                   	cld    
  800b33:	f3 ab                	rep stos %eax,%es:(%edi)
  800b35:	eb 06                	jmp    800b3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	fc                   	cld    
  800b3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b3d:	89 f8                	mov    %edi,%eax
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b52:	39 c6                	cmp    %eax,%esi
  800b54:	73 35                	jae    800b8b <memmove+0x47>
  800b56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b59:	39 d0                	cmp    %edx,%eax
  800b5b:	73 2e                	jae    800b8b <memmove+0x47>
		s += n;
		d += n;
  800b5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b60:	89 d6                	mov    %edx,%esi
  800b62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b6a:	75 13                	jne    800b7f <memmove+0x3b>
  800b6c:	f6 c1 03             	test   $0x3,%cl
  800b6f:	75 0e                	jne    800b7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b71:	83 ef 04             	sub    $0x4,%edi
  800b74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b7a:	fd                   	std    
  800b7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7d:	eb 09                	jmp    800b88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b7f:	83 ef 01             	sub    $0x1,%edi
  800b82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b85:	fd                   	std    
  800b86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b88:	fc                   	cld    
  800b89:	eb 1d                	jmp    800ba8 <memmove+0x64>
  800b8b:	89 f2                	mov    %esi,%edx
  800b8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8f:	f6 c2 03             	test   $0x3,%dl
  800b92:	75 0f                	jne    800ba3 <memmove+0x5f>
  800b94:	f6 c1 03             	test   $0x3,%cl
  800b97:	75 0a                	jne    800ba3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b9c:	89 c7                	mov    %eax,%edi
  800b9e:	fc                   	cld    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb 05                	jmp    800ba8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ba3:	89 c7                	mov    %eax,%edi
  800ba5:	fc                   	cld    
  800ba6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 04 24             	mov    %eax,(%esp)
  800bc6:	e8 79 ff ff ff       	call   800b44 <memmove>
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd8:	89 d6                	mov    %edx,%esi
  800bda:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdd:	eb 1a                	jmp    800bf9 <memcmp+0x2c>
		if (*s1 != *s2)
  800bdf:	0f b6 02             	movzbl (%edx),%eax
  800be2:	0f b6 19             	movzbl (%ecx),%ebx
  800be5:	38 d8                	cmp    %bl,%al
  800be7:	74 0a                	je     800bf3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800be9:	0f b6 c0             	movzbl %al,%eax
  800bec:	0f b6 db             	movzbl %bl,%ebx
  800bef:	29 d8                	sub    %ebx,%eax
  800bf1:	eb 0f                	jmp    800c02 <memcmp+0x35>
		s1++, s2++;
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf9:	39 f2                	cmp    %esi,%edx
  800bfb:	75 e2                	jne    800bdf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c14:	eb 07                	jmp    800c1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c16:	38 08                	cmp    %cl,(%eax)
  800c18:	74 07                	je     800c21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	39 d0                	cmp    %edx,%eax
  800c1f:	72 f5                	jb     800c16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2f:	eb 03                	jmp    800c34 <strtol+0x11>
		s++;
  800c31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c34:	0f b6 0a             	movzbl (%edx),%ecx
  800c37:	80 f9 09             	cmp    $0x9,%cl
  800c3a:	74 f5                	je     800c31 <strtol+0xe>
  800c3c:	80 f9 20             	cmp    $0x20,%cl
  800c3f:	74 f0                	je     800c31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c41:	80 f9 2b             	cmp    $0x2b,%cl
  800c44:	75 0a                	jne    800c50 <strtol+0x2d>
		s++;
  800c46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c49:	bf 00 00 00 00       	mov    $0x0,%edi
  800c4e:	eb 11                	jmp    800c61 <strtol+0x3e>
  800c50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c55:	80 f9 2d             	cmp    $0x2d,%cl
  800c58:	75 07                	jne    800c61 <strtol+0x3e>
		s++, neg = 1;
  800c5a:	8d 52 01             	lea    0x1(%edx),%edx
  800c5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c66:	75 15                	jne    800c7d <strtol+0x5a>
  800c68:	80 3a 30             	cmpb   $0x30,(%edx)
  800c6b:	75 10                	jne    800c7d <strtol+0x5a>
  800c6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c71:	75 0a                	jne    800c7d <strtol+0x5a>
		s += 2, base = 16;
  800c73:	83 c2 02             	add    $0x2,%edx
  800c76:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7b:	eb 10                	jmp    800c8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c7d:	85 c0                	test   %eax,%eax
  800c7f:	75 0c                	jne    800c8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c83:	80 3a 30             	cmpb   $0x30,(%edx)
  800c86:	75 05                	jne    800c8d <strtol+0x6a>
		s++, base = 8;
  800c88:	83 c2 01             	add    $0x1,%edx
  800c8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c95:	0f b6 0a             	movzbl (%edx),%ecx
  800c98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c9b:	89 f0                	mov    %esi,%eax
  800c9d:	3c 09                	cmp    $0x9,%al
  800c9f:	77 08                	ja     800ca9 <strtol+0x86>
			dig = *s - '0';
  800ca1:	0f be c9             	movsbl %cl,%ecx
  800ca4:	83 e9 30             	sub    $0x30,%ecx
  800ca7:	eb 20                	jmp    800cc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ca9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cac:	89 f0                	mov    %esi,%eax
  800cae:	3c 19                	cmp    $0x19,%al
  800cb0:	77 08                	ja     800cba <strtol+0x97>
			dig = *s - 'a' + 10;
  800cb2:	0f be c9             	movsbl %cl,%ecx
  800cb5:	83 e9 57             	sub    $0x57,%ecx
  800cb8:	eb 0f                	jmp    800cc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800cba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cbd:	89 f0                	mov    %esi,%eax
  800cbf:	3c 19                	cmp    $0x19,%al
  800cc1:	77 16                	ja     800cd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800cc3:	0f be c9             	movsbl %cl,%ecx
  800cc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ccc:	7d 0f                	jge    800cdd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cd7:	eb bc                	jmp    800c95 <strtol+0x72>
  800cd9:	89 d8                	mov    %ebx,%eax
  800cdb:	eb 02                	jmp    800cdf <strtol+0xbc>
  800cdd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 05                	je     800cea <strtol+0xc7>
		*endptr = (char *) s;
  800ce5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cea:	f7 d8                	neg    %eax
  800cec:	85 ff                	test   %edi,%edi
  800cee:	0f 44 c3             	cmove  %ebx,%eax
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	89 c3                	mov    %eax,%ebx
  800d09:	89 c7                	mov    %eax,%edi
  800d0b:	89 c6                	mov    %eax,%esi
  800d0d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d24:	89 d1                	mov    %edx,%ecx
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	89 d7                	mov    %edx,%edi
  800d2a:	89 d6                	mov    %edx,%esi
  800d2c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d41:	b8 03 00 00 00       	mov    $0x3,%eax
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	89 cb                	mov    %ecx,%ebx
  800d4b:	89 cf                	mov    %ecx,%edi
  800d4d:	89 ce                	mov    %ecx,%esi
  800d4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7e 28                	jle    800d7d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d59:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d60:	00 
  800d61:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  800d68:	00 
  800d69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d70:	00 
  800d71:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  800d78:	e8 10 f5 ff ff       	call   80028d <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7d:	83 c4 2c             	add    $0x2c,%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d90:	b8 02 00 00 00       	mov    $0x2,%eax
  800d95:	89 d1                	mov    %edx,%ecx
  800d97:	89 d3                	mov    %edx,%ebx
  800d99:	89 d7                	mov    %edx,%edi
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <sys_yield>:

void
sys_yield(void)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db4:	89 d1                	mov    %edx,%ecx
  800db6:	89 d3                	mov    %edx,%ebx
  800db8:	89 d7                	mov    %edx,%edi
  800dba:	89 d6                	mov    %edx,%esi
  800dbc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcc:	be 00 00 00 00       	mov    $0x0,%esi
  800dd1:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddf:	89 f7                	mov    %esi,%edi
  800de1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7e 28                	jle    800e0f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800deb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800df2:	00 
  800df3:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  800dfa:	00 
  800dfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e02:	00 
  800e03:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  800e0a:	e8 7e f4 ff ff       	call   80028d <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e0f:	83 c4 2c             	add    $0x2c,%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e20:	b8 05 00 00 00       	mov    $0x5,%eax
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e31:	8b 75 18             	mov    0x18(%ebp),%esi
  800e34:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	7e 28                	jle    800e62 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e45:	00 
  800e46:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  800e4d:	00 
  800e4e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e55:	00 
  800e56:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  800e5d:	e8 2b f4 ff ff       	call   80028d <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e62:	83 c4 2c             	add    $0x2c,%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
  800e70:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e78:	b8 06 00 00 00       	mov    $0x6,%eax
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	89 df                	mov    %ebx,%edi
  800e85:	89 de                	mov    %ebx,%esi
  800e87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	7e 28                	jle    800eb5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e91:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e98:	00 
  800e99:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea8:	00 
  800ea9:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  800eb0:	e8 d8 f3 ff ff       	call   80028d <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eb5:	83 c4 2c             	add    $0x2c,%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	57                   	push   %edi
  800ec1:	56                   	push   %esi
  800ec2:	53                   	push   %ebx
  800ec3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	89 df                	mov    %ebx,%edi
  800ed8:	89 de                	mov    %ebx,%esi
  800eda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	7e 28                	jle    800f08 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800eeb:	00 
  800eec:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efb:	00 
  800efc:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  800f03:	e8 85 f3 ff ff       	call   80028d <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f08:	83 c4 2c             	add    $0x2c,%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
  800f16:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	89 df                	mov    %ebx,%edi
  800f2b:	89 de                	mov    %ebx,%esi
  800f2d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	7e 28                	jle    800f5b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f37:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  800f46:	00 
  800f47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4e:	00 
  800f4f:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  800f56:	e8 32 f3 ff ff       	call   80028d <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f5b:	83 c4 2c             	add    $0x2c,%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	89 df                	mov    %ebx,%edi
  800f7e:	89 de                	mov    %ebx,%esi
  800f80:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	7e 28                	jle    800fae <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f86:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f91:	00 
  800f92:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  800f99:	00 
  800f9a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa1:	00 
  800fa2:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  800fa9:	e8 df f2 ff ff       	call   80028d <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fae:	83 c4 2c             	add    $0x2c,%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	be 00 00 00 00       	mov    $0x0,%esi
  800fc1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fcf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	89 cb                	mov    %ecx,%ebx
  800ff1:	89 cf                	mov    %ecx,%edi
  800ff3:	89 ce                	mov    %ecx,%esi
  800ff5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	7e 28                	jle    801023 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801006:	00 
  801007:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  80100e:	00 
  80100f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801016:	00 
  801017:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  80101e:	e8 6a f2 ff ff       	call   80028d <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801023:	83 c4 2c             	add    $0x2c,%esp
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801031:	ba 00 00 00 00       	mov    $0x0,%edx
  801036:	b8 0e 00 00 00       	mov    $0xe,%eax
  80103b:	89 d1                	mov    %edx,%ecx
  80103d:	89 d3                	mov    %edx,%ebx
  80103f:	89 d7                	mov    %edx,%edi
  801041:	89 d6                	mov    %edx,%esi
  801043:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
  801050:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801053:	bb 00 00 00 00       	mov    $0x0,%ebx
  801058:	b8 0f 00 00 00       	mov    $0xf,%eax
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	89 df                	mov    %ebx,%edi
  801065:	89 de                	mov    %ebx,%esi
  801067:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801069:	85 c0                	test   %eax,%eax
  80106b:	7e 28                	jle    801095 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801071:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801078:	00 
  801079:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  801090:	e8 f8 f1 ff ff       	call   80028d <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801095:	83 c4 2c             	add    $0x2c,%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	89 df                	mov    %ebx,%edi
  8010b8:	89 de                	mov    %ebx,%esi
  8010ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	7e 28                	jle    8010e8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010db:	00 
  8010dc:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  8010e3:	e8 a5 f1 ff ff       	call   80028d <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8010e8:	83 c4 2c             	add    $0x2c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
  8010f6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fe:	b8 11 00 00 00       	mov    $0x11,%eax
  801103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801106:	8b 55 08             	mov    0x8(%ebp),%edx
  801109:	89 df                	mov    %ebx,%edi
  80110b:	89 de                	mov    %ebx,%esi
  80110d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80110f:	85 c0                	test   %eax,%eax
  801111:	7e 28                	jle    80113b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801113:	89 44 24 10          	mov    %eax,0x10(%esp)
  801117:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80111e:	00 
  80111f:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  801126:	00 
  801127:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80112e:	00 
  80112f:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  801136:	e8 52 f1 ff ff       	call   80028d <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80113b:	83 c4 2c             	add    $0x2c,%esp
  80113e:	5b                   	pop    %ebx
  80113f:	5e                   	pop    %esi
  801140:	5f                   	pop    %edi
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    

00801143 <sys_sleep>:

int
sys_sleep(int channel)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	57                   	push   %edi
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
  801149:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801151:	b8 12 00 00 00       	mov    $0x12,%eax
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	89 cb                	mov    %ecx,%ebx
  80115b:	89 cf                	mov    %ecx,%edi
  80115d:	89 ce                	mov    %ecx,%esi
  80115f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801161:	85 c0                	test   %eax,%eax
  801163:	7e 28                	jle    80118d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801165:	89 44 24 10          	mov    %eax,0x10(%esp)
  801169:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801170:	00 
  801171:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  801178:	00 
  801179:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801180:	00 
  801181:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  801188:	e8 00 f1 ff ff       	call   80028d <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80118d:	83 c4 2c             	add    $0x2c,%esp
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5f                   	pop    %edi
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    

00801195 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	57                   	push   %edi
  801199:	56                   	push   %esi
  80119a:	53                   	push   %ebx
  80119b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a3:	b8 13 00 00 00       	mov    $0x13,%eax
  8011a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	89 df                	mov    %ebx,%edi
  8011b0:	89 de                	mov    %ebx,%esi
  8011b2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	7e 28                	jle    8011e0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011bc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8011c3:	00 
  8011c4:	c7 44 24 08 8b 31 80 	movl   $0x80318b,0x8(%esp)
  8011cb:	00 
  8011cc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d3:	00 
  8011d4:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  8011db:	e8 ad f0 ff ff       	call   80028d <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8011e0:	83 c4 2c             	add    $0x2c,%esp
  8011e3:	5b                   	pop    %ebx
  8011e4:	5e                   	pop    %esi
  8011e5:	5f                   	pop    %edi
  8011e6:	5d                   	pop    %ebp
  8011e7:	c3                   	ret    

008011e8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	53                   	push   %ebx
  8011ec:	83 ec 24             	sub    $0x24,%esp
  8011ef:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011f2:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  8011f4:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011f8:	74 27                	je     801221 <pgfault+0x39>
  8011fa:	89 c2                	mov    %eax,%edx
  8011fc:	c1 ea 16             	shr    $0x16,%edx
  8011ff:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801206:	f6 c2 01             	test   $0x1,%dl
  801209:	74 16                	je     801221 <pgfault+0x39>
  80120b:	89 c2                	mov    %eax,%edx
  80120d:	c1 ea 0c             	shr    $0xc,%edx
  801210:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801217:	f7 d2                	not    %edx
  801219:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80121f:	74 1c                	je     80123d <pgfault+0x55>
		panic("pgfault");
  801221:	c7 44 24 08 b6 31 80 	movl   $0x8031b6,0x8(%esp)
  801228:	00 
  801229:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801230:	00 
  801231:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  801238:	e8 50 f0 ff ff       	call   80028d <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80123d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801242:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801244:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80124b:	00 
  80124c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801253:	00 
  801254:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125b:	e8 63 fb ff ff       	call   800dc3 <sys_page_alloc>
  801260:	85 c0                	test   %eax,%eax
  801262:	79 1c                	jns    801280 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801264:	c7 44 24 08 c9 31 80 	movl   $0x8031c9,0x8(%esp)
  80126b:	00 
  80126c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801273:	00 
  801274:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80127b:	e8 0d f0 ff ff       	call   80028d <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801280:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801287:	00 
  801288:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80128c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801293:	e8 14 f9 ff ff       	call   800bac <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801298:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80129f:	00 
  8012a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012ab:	00 
  8012ac:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012b3:	00 
  8012b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012bb:	e8 57 fb ff ff       	call   800e17 <sys_page_map>
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	79 1c                	jns    8012e0 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  8012c4:	c7 44 24 08 e3 31 80 	movl   $0x8031e3,0x8(%esp)
  8012cb:	00 
  8012cc:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8012d3:	00 
  8012d4:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8012db:	e8 ad ef ff ff       	call   80028d <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  8012e0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012e7:	00 
  8012e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ef:	e8 76 fb ff ff       	call   800e6a <sys_page_unmap>
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	79 1c                	jns    801314 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  8012f8:	c7 44 24 08 fb 31 80 	movl   $0x8031fb,0x8(%esp)
  8012ff:	00 
  801300:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801307:	00 
  801308:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80130f:	e8 79 ef ff ff       	call   80028d <_panic>
	}
}
  801314:	83 c4 24             	add    $0x24,%esp
  801317:	5b                   	pop    %ebx
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    

0080131a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	57                   	push   %edi
  80131e:	56                   	push   %esi
  80131f:	53                   	push   %ebx
  801320:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801323:	c7 04 24 e8 11 80 00 	movl   $0x8011e8,(%esp)
  80132a:	e8 a7 16 00 00       	call   8029d6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80132f:	b8 07 00 00 00       	mov    $0x7,%eax
  801334:	cd 30                	int    $0x30
  801336:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801339:	85 c0                	test   %eax,%eax
  80133b:	79 1c                	jns    801359 <fork+0x3f>
		panic("fork(): sys_exofork");
  80133d:	c7 44 24 08 15 32 80 	movl   $0x803215,0x8(%esp)
  801344:	00 
  801345:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80134c:	00 
  80134d:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  801354:	e8 34 ef ff ff       	call   80028d <_panic>
  801359:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  80135b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80135f:	74 0a                	je     80136b <fork+0x51>
  801361:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801366:	e9 9d 01 00 00       	jmp    801508 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80136b:	e8 15 fa ff ff       	call   800d85 <sys_getenvid>
  801370:	25 ff 03 00 00       	and    $0x3ff,%eax
  801375:	89 c2                	mov    %eax,%edx
  801377:	c1 e2 07             	shl    $0x7,%edx
  80137a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801381:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  801386:	e9 2a 02 00 00       	jmp    8015b5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80138b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801391:	0f 84 6b 01 00 00    	je     801502 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801397:	89 d8                	mov    %ebx,%eax
  801399:	c1 e8 16             	shr    $0x16,%eax
  80139c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013a3:	a8 01                	test   $0x1,%al
  8013a5:	0f 84 57 01 00 00    	je     801502 <fork+0x1e8>
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	c1 e8 0c             	shr    $0xc,%eax
  8013b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b7:	f7 d0                	not    %eax
  8013b9:	a8 05                	test   $0x5,%al
  8013bb:	0f 85 41 01 00 00    	jne    801502 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  8013c1:	89 d8                	mov    %ebx,%eax
  8013c3:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  8013c6:	89 c6                	mov    %eax,%esi
  8013c8:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  8013cb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d2:	f6 c6 04             	test   $0x4,%dh
  8013d5:	74 4c                	je     801423 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  8013d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013de:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013eb:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fa:	e8 18 fa ff ff       	call   800e17 <sys_page_map>
  8013ff:	85 c0                	test   %eax,%eax
  801401:	0f 89 fb 00 00 00    	jns    801502 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801407:	c7 44 24 08 29 32 80 	movl   $0x803229,0x8(%esp)
  80140e:	00 
  80140f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801416:	00 
  801417:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80141e:	e8 6a ee ff ff       	call   80028d <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801423:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80142a:	f6 c6 08             	test   $0x8,%dh
  80142d:	75 0f                	jne    80143e <fork+0x124>
  80142f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801436:	a8 02                	test   $0x2,%al
  801438:	0f 84 84 00 00 00    	je     8014c2 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80143e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801445:	00 
  801446:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80144a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80144e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801459:	e8 b9 f9 ff ff       	call   800e17 <sys_page_map>
  80145e:	85 c0                	test   %eax,%eax
  801460:	79 1c                	jns    80147e <fork+0x164>
			panic("duppage: sys_page_map");
  801462:	c7 44 24 08 29 32 80 	movl   $0x803229,0x8(%esp)
  801469:	00 
  80146a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801471:	00 
  801472:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  801479:	e8 0f ee ff ff       	call   80028d <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80147e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801485:	00 
  801486:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80148a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801491:	00 
  801492:	89 74 24 04          	mov    %esi,0x4(%esp)
  801496:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80149d:	e8 75 f9 ff ff       	call   800e17 <sys_page_map>
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	79 5c                	jns    801502 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8014a6:	c7 44 24 08 29 32 80 	movl   $0x803229,0x8(%esp)
  8014ad:	00 
  8014ae:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8014b5:	00 
  8014b6:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8014bd:	e8 cb ed ff ff       	call   80028d <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  8014c2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8014c9:	00 
  8014ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014dd:	e8 35 f9 ff ff       	call   800e17 <sys_page_map>
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	79 1c                	jns    801502 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8014e6:	c7 44 24 08 29 32 80 	movl   $0x803229,0x8(%esp)
  8014ed:	00 
  8014ee:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8014f5:	00 
  8014f6:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8014fd:	e8 8b ed ff ff       	call   80028d <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801502:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801508:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80150e:	0f 85 77 fe ff ff    	jne    80138b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801514:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80151b:	00 
  80151c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801523:	ee 
  801524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801527:	89 04 24             	mov    %eax,(%esp)
  80152a:	e8 94 f8 ff ff       	call   800dc3 <sys_page_alloc>
  80152f:	85 c0                	test   %eax,%eax
  801531:	79 1c                	jns    80154f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801533:	c7 44 24 08 3f 32 80 	movl   $0x80323f,0x8(%esp)
  80153a:	00 
  80153b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801542:	00 
  801543:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80154a:	e8 3e ed ff ff       	call   80028d <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80154f:	c7 44 24 04 5f 2a 80 	movl   $0x802a5f,0x4(%esp)
  801556:	00 
  801557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80155a:	89 04 24             	mov    %eax,(%esp)
  80155d:	e8 01 fa ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
  801562:	85 c0                	test   %eax,%eax
  801564:	79 1c                	jns    801582 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801566:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  80156d:	00 
  80156e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801575:	00 
  801576:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80157d:	e8 0b ed ff ff       	call   80028d <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801582:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801589:	00 
  80158a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158d:	89 04 24             	mov    %eax,(%esp)
  801590:	e8 28 f9 ff ff       	call   800ebd <sys_env_set_status>
  801595:	85 c0                	test   %eax,%eax
  801597:	79 1c                	jns    8015b5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801599:	c7 44 24 08 56 32 80 	movl   $0x803256,0x8(%esp)
  8015a0:	00 
  8015a1:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  8015a8:	00 
  8015a9:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8015b0:	e8 d8 ec ff ff       	call   80028d <_panic>
	}

	return env_id;
}
  8015b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b8:	83 c4 2c             	add    $0x2c,%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5f                   	pop    %edi
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    

008015c0 <sfork>:

// Challenge!
int
sfork(void)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8015c6:	c7 44 24 08 71 32 80 	movl   $0x803271,0x8(%esp)
  8015cd:	00 
  8015ce:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8015d5:	00 
  8015d6:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8015dd:	e8 ab ec ff ff       	call   80028d <_panic>
  8015e2:	66 90                	xchg   %ax,%ax
  8015e4:	66 90                	xchg   %ax,%ax
  8015e6:	66 90                	xchg   %ax,%ax
  8015e8:	66 90                	xchg   %ax,%ax
  8015ea:	66 90                	xchg   %ax,%ax
  8015ec:	66 90                	xchg   %ax,%ax
  8015ee:	66 90                	xchg   %ax,%ax

008015f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	56                   	push   %esi
  8015f4:	53                   	push   %ebx
  8015f5:	83 ec 10             	sub    $0x10,%esp
  8015f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801601:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  801603:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801608:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80160b:	89 04 24             	mov    %eax,(%esp)
  80160e:	e8 c6 f9 ff ff       	call   800fd9 <sys_ipc_recv>
  801613:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  801615:	85 d2                	test   %edx,%edx
  801617:	75 24                	jne    80163d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  801619:	85 f6                	test   %esi,%esi
  80161b:	74 0a                	je     801627 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80161d:	a1 08 50 80 00       	mov    0x805008,%eax
  801622:	8b 40 74             	mov    0x74(%eax),%eax
  801625:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  801627:	85 db                	test   %ebx,%ebx
  801629:	74 0a                	je     801635 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80162b:	a1 08 50 80 00       	mov    0x805008,%eax
  801630:	8b 40 78             	mov    0x78(%eax),%eax
  801633:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801635:	a1 08 50 80 00       	mov    0x805008,%eax
  80163a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	5b                   	pop    %ebx
  801641:	5e                   	pop    %esi
  801642:	5d                   	pop    %ebp
  801643:	c3                   	ret    

00801644 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	57                   	push   %edi
  801648:	56                   	push   %esi
  801649:	53                   	push   %ebx
  80164a:	83 ec 1c             	sub    $0x1c,%esp
  80164d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801650:	8b 75 0c             	mov    0xc(%ebp),%esi
  801653:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  801656:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  801658:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80165d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801660:	8b 45 14             	mov    0x14(%ebp),%eax
  801663:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801667:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80166b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80166f:	89 3c 24             	mov    %edi,(%esp)
  801672:	e8 3f f9 ff ff       	call   800fb6 <sys_ipc_try_send>

		if (ret == 0)
  801677:	85 c0                	test   %eax,%eax
  801679:	74 2c                	je     8016a7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80167b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80167e:	74 20                	je     8016a0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  801680:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801684:	c7 44 24 08 ac 32 80 	movl   $0x8032ac,0x8(%esp)
  80168b:	00 
  80168c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801693:	00 
  801694:	c7 04 24 da 32 80 00 	movl   $0x8032da,(%esp)
  80169b:	e8 ed eb ff ff       	call   80028d <_panic>
		}

		sys_yield();
  8016a0:	e8 ff f6 ff ff       	call   800da4 <sys_yield>
	}
  8016a5:	eb b9                	jmp    801660 <ipc_send+0x1c>
}
  8016a7:	83 c4 1c             	add    $0x1c,%esp
  8016aa:	5b                   	pop    %ebx
  8016ab:	5e                   	pop    %esi
  8016ac:	5f                   	pop    %edi
  8016ad:	5d                   	pop    %ebp
  8016ae:	c3                   	ret    

008016af <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8016ba:	89 c2                	mov    %eax,%edx
  8016bc:	c1 e2 07             	shl    $0x7,%edx
  8016bf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8016c6:	8b 52 50             	mov    0x50(%edx),%edx
  8016c9:	39 ca                	cmp    %ecx,%edx
  8016cb:	75 11                	jne    8016de <ipc_find_env+0x2f>
			return envs[i].env_id;
  8016cd:	89 c2                	mov    %eax,%edx
  8016cf:	c1 e2 07             	shl    $0x7,%edx
  8016d2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8016d9:	8b 40 40             	mov    0x40(%eax),%eax
  8016dc:	eb 0e                	jmp    8016ec <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8016de:	83 c0 01             	add    $0x1,%eax
  8016e1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8016e6:	75 d2                	jne    8016ba <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8016e8:	66 b8 00 00          	mov    $0x0,%ax
}
  8016ec:	5d                   	pop    %ebp
  8016ed:	c3                   	ret    
  8016ee:	66 90                	xchg   %ax,%ax

008016f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8016fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    

00801700 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80170b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801710:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80171d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801722:	89 c2                	mov    %eax,%edx
  801724:	c1 ea 16             	shr    $0x16,%edx
  801727:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80172e:	f6 c2 01             	test   $0x1,%dl
  801731:	74 11                	je     801744 <fd_alloc+0x2d>
  801733:	89 c2                	mov    %eax,%edx
  801735:	c1 ea 0c             	shr    $0xc,%edx
  801738:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80173f:	f6 c2 01             	test   $0x1,%dl
  801742:	75 09                	jne    80174d <fd_alloc+0x36>
			*fd_store = fd;
  801744:	89 01                	mov    %eax,(%ecx)
			return 0;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
  80174b:	eb 17                	jmp    801764 <fd_alloc+0x4d>
  80174d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801752:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801757:	75 c9                	jne    801722 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801759:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80175f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    

00801766 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80176c:	83 f8 1f             	cmp    $0x1f,%eax
  80176f:	77 36                	ja     8017a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801771:	c1 e0 0c             	shl    $0xc,%eax
  801774:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801779:	89 c2                	mov    %eax,%edx
  80177b:	c1 ea 16             	shr    $0x16,%edx
  80177e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801785:	f6 c2 01             	test   $0x1,%dl
  801788:	74 24                	je     8017ae <fd_lookup+0x48>
  80178a:	89 c2                	mov    %eax,%edx
  80178c:	c1 ea 0c             	shr    $0xc,%edx
  80178f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801796:	f6 c2 01             	test   $0x1,%dl
  801799:	74 1a                	je     8017b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179e:	89 02                	mov    %eax,(%edx)
	return 0;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a5:	eb 13                	jmp    8017ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8017a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ac:	eb 0c                	jmp    8017ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8017ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b3:	eb 05                	jmp    8017ba <fd_lookup+0x54>
  8017b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	83 ec 18             	sub    $0x18,%esp
  8017c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ca:	eb 13                	jmp    8017df <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8017cc:	39 08                	cmp    %ecx,(%eax)
  8017ce:	75 0c                	jne    8017dc <dev_lookup+0x20>
			*dev = devtab[i];
  8017d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017da:	eb 38                	jmp    801814 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017dc:	83 c2 01             	add    $0x1,%edx
  8017df:	8b 04 95 60 33 80 00 	mov    0x803360(,%edx,4),%eax
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	75 e2                	jne    8017cc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8017ef:	8b 40 48             	mov    0x48(%eax),%eax
  8017f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fa:	c7 04 24 e4 32 80 00 	movl   $0x8032e4,(%esp)
  801801:	e8 80 eb ff ff       	call   800386 <cprintf>
	*dev = 0;
  801806:	8b 45 0c             	mov    0xc(%ebp),%eax
  801809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80180f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	56                   	push   %esi
  80181a:	53                   	push   %ebx
  80181b:	83 ec 20             	sub    $0x20,%esp
  80181e:	8b 75 08             	mov    0x8(%ebp),%esi
  801821:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801824:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801827:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80182b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801831:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801834:	89 04 24             	mov    %eax,(%esp)
  801837:	e8 2a ff ff ff       	call   801766 <fd_lookup>
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 05                	js     801845 <fd_close+0x2f>
	    || fd != fd2)
  801840:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801843:	74 0c                	je     801851 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801845:	84 db                	test   %bl,%bl
  801847:	ba 00 00 00 00       	mov    $0x0,%edx
  80184c:	0f 44 c2             	cmove  %edx,%eax
  80184f:	eb 3f                	jmp    801890 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801851:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801854:	89 44 24 04          	mov    %eax,0x4(%esp)
  801858:	8b 06                	mov    (%esi),%eax
  80185a:	89 04 24             	mov    %eax,(%esp)
  80185d:	e8 5a ff ff ff       	call   8017bc <dev_lookup>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	85 c0                	test   %eax,%eax
  801866:	78 16                	js     80187e <fd_close+0x68>
		if (dev->dev_close)
  801868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80186e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801873:	85 c0                	test   %eax,%eax
  801875:	74 07                	je     80187e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801877:	89 34 24             	mov    %esi,(%esp)
  80187a:	ff d0                	call   *%eax
  80187c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80187e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801882:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801889:	e8 dc f5 ff ff       	call   800e6a <sys_page_unmap>
	return r;
  80188e:	89 d8                	mov    %ebx,%eax
}
  801890:	83 c4 20             	add    $0x20,%esp
  801893:	5b                   	pop    %ebx
  801894:	5e                   	pop    %esi
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    

00801897 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	89 04 24             	mov    %eax,(%esp)
  8018aa:	e8 b7 fe ff ff       	call   801766 <fd_lookup>
  8018af:	89 c2                	mov    %eax,%edx
  8018b1:	85 d2                	test   %edx,%edx
  8018b3:	78 13                	js     8018c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8018b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018bc:	00 
  8018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c0:	89 04 24             	mov    %eax,(%esp)
  8018c3:	e8 4e ff ff ff       	call   801816 <fd_close>
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <close_all>:

void
close_all(void)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	53                   	push   %ebx
  8018ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018d6:	89 1c 24             	mov    %ebx,(%esp)
  8018d9:	e8 b9 ff ff ff       	call   801897 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8018de:	83 c3 01             	add    $0x1,%ebx
  8018e1:	83 fb 20             	cmp    $0x20,%ebx
  8018e4:	75 f0                	jne    8018d6 <close_all+0xc>
		close(i);
}
  8018e6:	83 c4 14             	add    $0x14,%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	57                   	push   %edi
  8018f0:	56                   	push   %esi
  8018f1:	53                   	push   %ebx
  8018f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	89 04 24             	mov    %eax,(%esp)
  801902:	e8 5f fe ff ff       	call   801766 <fd_lookup>
  801907:	89 c2                	mov    %eax,%edx
  801909:	85 d2                	test   %edx,%edx
  80190b:	0f 88 e1 00 00 00    	js     8019f2 <dup+0x106>
		return r;
	close(newfdnum);
  801911:	8b 45 0c             	mov    0xc(%ebp),%eax
  801914:	89 04 24             	mov    %eax,(%esp)
  801917:	e8 7b ff ff ff       	call   801897 <close>

	newfd = INDEX2FD(newfdnum);
  80191c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80191f:	c1 e3 0c             	shl    $0xc,%ebx
  801922:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80192b:	89 04 24             	mov    %eax,(%esp)
  80192e:	e8 cd fd ff ff       	call   801700 <fd2data>
  801933:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801935:	89 1c 24             	mov    %ebx,(%esp)
  801938:	e8 c3 fd ff ff       	call   801700 <fd2data>
  80193d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80193f:	89 f0                	mov    %esi,%eax
  801941:	c1 e8 16             	shr    $0x16,%eax
  801944:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80194b:	a8 01                	test   $0x1,%al
  80194d:	74 43                	je     801992 <dup+0xa6>
  80194f:	89 f0                	mov    %esi,%eax
  801951:	c1 e8 0c             	shr    $0xc,%eax
  801954:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80195b:	f6 c2 01             	test   $0x1,%dl
  80195e:	74 32                	je     801992 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801960:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801967:	25 07 0e 00 00       	and    $0xe07,%eax
  80196c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801970:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801974:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80197b:	00 
  80197c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801980:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801987:	e8 8b f4 ff ff       	call   800e17 <sys_page_map>
  80198c:	89 c6                	mov    %eax,%esi
  80198e:	85 c0                	test   %eax,%eax
  801990:	78 3e                	js     8019d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801995:	89 c2                	mov    %eax,%edx
  801997:	c1 ea 0c             	shr    $0xc,%edx
  80199a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8019a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8019ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8019af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019b6:	00 
  8019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019c2:	e8 50 f4 ff ff       	call   800e17 <sys_page_map>
  8019c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8019c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019cc:	85 f6                	test   %esi,%esi
  8019ce:	79 22                	jns    8019f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8019d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019db:	e8 8a f4 ff ff       	call   800e6a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019eb:	e8 7a f4 ff ff       	call   800e6a <sys_page_unmap>
	return r;
  8019f0:	89 f0                	mov    %esi,%eax
}
  8019f2:	83 c4 3c             	add    $0x3c,%esp
  8019f5:	5b                   	pop    %ebx
  8019f6:	5e                   	pop    %esi
  8019f7:	5f                   	pop    %edi
  8019f8:	5d                   	pop    %ebp
  8019f9:	c3                   	ret    

008019fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	53                   	push   %ebx
  8019fe:	83 ec 24             	sub    $0x24,%esp
  801a01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0b:	89 1c 24             	mov    %ebx,(%esp)
  801a0e:	e8 53 fd ff ff       	call   801766 <fd_lookup>
  801a13:	89 c2                	mov    %eax,%edx
  801a15:	85 d2                	test   %edx,%edx
  801a17:	78 6d                	js     801a86 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a23:	8b 00                	mov    (%eax),%eax
  801a25:	89 04 24             	mov    %eax,(%esp)
  801a28:	e8 8f fd ff ff       	call   8017bc <dev_lookup>
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	78 55                	js     801a86 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a34:	8b 50 08             	mov    0x8(%eax),%edx
  801a37:	83 e2 03             	and    $0x3,%edx
  801a3a:	83 fa 01             	cmp    $0x1,%edx
  801a3d:	75 23                	jne    801a62 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a3f:	a1 08 50 80 00       	mov    0x805008,%eax
  801a44:	8b 40 48             	mov    0x48(%eax),%eax
  801a47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4f:	c7 04 24 25 33 80 00 	movl   $0x803325,(%esp)
  801a56:	e8 2b e9 ff ff       	call   800386 <cprintf>
		return -E_INVAL;
  801a5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a60:	eb 24                	jmp    801a86 <read+0x8c>
	}
	if (!dev->dev_read)
  801a62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a65:	8b 52 08             	mov    0x8(%edx),%edx
  801a68:	85 d2                	test   %edx,%edx
  801a6a:	74 15                	je     801a81 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a7a:	89 04 24             	mov    %eax,(%esp)
  801a7d:	ff d2                	call   *%edx
  801a7f:	eb 05                	jmp    801a86 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801a81:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801a86:	83 c4 24             	add    $0x24,%esp
  801a89:	5b                   	pop    %ebx
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    

00801a8c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	57                   	push   %edi
  801a90:	56                   	push   %esi
  801a91:	53                   	push   %ebx
  801a92:	83 ec 1c             	sub    $0x1c,%esp
  801a95:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a98:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa0:	eb 23                	jmp    801ac5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aa2:	89 f0                	mov    %esi,%eax
  801aa4:	29 d8                	sub    %ebx,%eax
  801aa6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aaa:	89 d8                	mov    %ebx,%eax
  801aac:	03 45 0c             	add    0xc(%ebp),%eax
  801aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab3:	89 3c 24             	mov    %edi,(%esp)
  801ab6:	e8 3f ff ff ff       	call   8019fa <read>
		if (m < 0)
  801abb:	85 c0                	test   %eax,%eax
  801abd:	78 10                	js     801acf <readn+0x43>
			return m;
		if (m == 0)
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	74 0a                	je     801acd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ac3:	01 c3                	add    %eax,%ebx
  801ac5:	39 f3                	cmp    %esi,%ebx
  801ac7:	72 d9                	jb     801aa2 <readn+0x16>
  801ac9:	89 d8                	mov    %ebx,%eax
  801acb:	eb 02                	jmp    801acf <readn+0x43>
  801acd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801acf:	83 c4 1c             	add    $0x1c,%esp
  801ad2:	5b                   	pop    %ebx
  801ad3:	5e                   	pop    %esi
  801ad4:	5f                   	pop    %edi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    

00801ad7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	53                   	push   %ebx
  801adb:	83 ec 24             	sub    $0x24,%esp
  801ade:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae8:	89 1c 24             	mov    %ebx,(%esp)
  801aeb:	e8 76 fc ff ff       	call   801766 <fd_lookup>
  801af0:	89 c2                	mov    %eax,%edx
  801af2:	85 d2                	test   %edx,%edx
  801af4:	78 68                	js     801b5e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	89 04 24             	mov    %eax,(%esp)
  801b05:	e8 b2 fc ff ff       	call   8017bc <dev_lookup>
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 50                	js     801b5e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b11:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b15:	75 23                	jne    801b3a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b17:	a1 08 50 80 00       	mov    0x805008,%eax
  801b1c:	8b 40 48             	mov    0x48(%eax),%eax
  801b1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b27:	c7 04 24 41 33 80 00 	movl   $0x803341,(%esp)
  801b2e:	e8 53 e8 ff ff       	call   800386 <cprintf>
		return -E_INVAL;
  801b33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b38:	eb 24                	jmp    801b5e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3d:	8b 52 0c             	mov    0xc(%edx),%edx
  801b40:	85 d2                	test   %edx,%edx
  801b42:	74 15                	je     801b59 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b52:	89 04 24             	mov    %eax,(%esp)
  801b55:	ff d2                	call   *%edx
  801b57:	eb 05                	jmp    801b5e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801b59:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801b5e:	83 c4 24             	add    $0x24,%esp
  801b61:	5b                   	pop    %ebx
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    

00801b64 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b6a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	89 04 24             	mov    %eax,(%esp)
  801b77:	e8 ea fb ff ff       	call   801766 <fd_lookup>
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	78 0e                	js     801b8e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b86:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	53                   	push   %ebx
  801b94:	83 ec 24             	sub    $0x24,%esp
  801b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba1:	89 1c 24             	mov    %ebx,(%esp)
  801ba4:	e8 bd fb ff ff       	call   801766 <fd_lookup>
  801ba9:	89 c2                	mov    %eax,%edx
  801bab:	85 d2                	test   %edx,%edx
  801bad:	78 61                	js     801c10 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801baf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb9:	8b 00                	mov    (%eax),%eax
  801bbb:	89 04 24             	mov    %eax,(%esp)
  801bbe:	e8 f9 fb ff ff       	call   8017bc <dev_lookup>
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 49                	js     801c10 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bce:	75 23                	jne    801bf3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801bd0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bd5:	8b 40 48             	mov    0x48(%eax),%eax
  801bd8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be0:	c7 04 24 04 33 80 00 	movl   $0x803304,(%esp)
  801be7:	e8 9a e7 ff ff       	call   800386 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801bec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf1:	eb 1d                	jmp    801c10 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801bf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf6:	8b 52 18             	mov    0x18(%edx),%edx
  801bf9:	85 d2                	test   %edx,%edx
  801bfb:	74 0e                	je     801c0b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c00:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c04:	89 04 24             	mov    %eax,(%esp)
  801c07:	ff d2                	call   *%edx
  801c09:	eb 05                	jmp    801c10 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801c0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801c10:	83 c4 24             	add    $0x24,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    

00801c16 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 24             	sub    $0x24,%esp
  801c1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	89 04 24             	mov    %eax,(%esp)
  801c2d:	e8 34 fb ff ff       	call   801766 <fd_lookup>
  801c32:	89 c2                	mov    %eax,%edx
  801c34:	85 d2                	test   %edx,%edx
  801c36:	78 52                	js     801c8a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c42:	8b 00                	mov    (%eax),%eax
  801c44:	89 04 24             	mov    %eax,(%esp)
  801c47:	e8 70 fb ff ff       	call   8017bc <dev_lookup>
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	78 3a                	js     801c8a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c53:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c57:	74 2c                	je     801c85 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c59:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c5c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c63:	00 00 00 
	stat->st_isdir = 0;
  801c66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c6d:	00 00 00 
	stat->st_dev = dev;
  801c70:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c7d:	89 14 24             	mov    %edx,(%esp)
  801c80:	ff 50 14             	call   *0x14(%eax)
  801c83:	eb 05                	jmp    801c8a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801c85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801c8a:	83 c4 24             	add    $0x24,%esp
  801c8d:	5b                   	pop    %ebx
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	56                   	push   %esi
  801c94:	53                   	push   %ebx
  801c95:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c9f:	00 
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	89 04 24             	mov    %eax,(%esp)
  801ca6:	e8 1b 02 00 00       	call   801ec6 <open>
  801cab:	89 c3                	mov    %eax,%ebx
  801cad:	85 db                	test   %ebx,%ebx
  801caf:	78 1b                	js     801ccc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb8:	89 1c 24             	mov    %ebx,(%esp)
  801cbb:	e8 56 ff ff ff       	call   801c16 <fstat>
  801cc0:	89 c6                	mov    %eax,%esi
	close(fd);
  801cc2:	89 1c 24             	mov    %ebx,(%esp)
  801cc5:	e8 cd fb ff ff       	call   801897 <close>
	return r;
  801cca:	89 f0                	mov    %esi,%eax
}
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 10             	sub    $0x10,%esp
  801cdb:	89 c6                	mov    %eax,%esi
  801cdd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cdf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ce6:	75 11                	jne    801cf9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ce8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801cef:	e8 bb f9 ff ff       	call   8016af <ipc_find_env>
  801cf4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cf9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d00:	00 
  801d01:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d08:	00 
  801d09:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d0d:	a1 00 50 80 00       	mov    0x805000,%eax
  801d12:	89 04 24             	mov    %eax,(%esp)
  801d15:	e8 2a f9 ff ff       	call   801644 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d21:	00 
  801d22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2d:	e8 be f8 ff ff       	call   8015f0 <ipc_recv>
}
  801d32:	83 c4 10             	add    $0x10,%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	8b 40 0c             	mov    0xc(%eax),%eax
  801d45:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
  801d57:	b8 02 00 00 00       	mov    $0x2,%eax
  801d5c:	e8 72 ff ff ff       	call   801cd3 <fsipc>
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d74:	ba 00 00 00 00       	mov    $0x0,%edx
  801d79:	b8 06 00 00 00       	mov    $0x6,%eax
  801d7e:	e8 50 ff ff ff       	call   801cd3 <fsipc>
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	53                   	push   %ebx
  801d89:	83 ec 14             	sub    $0x14,%esp
  801d8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	8b 40 0c             	mov    0xc(%eax),%eax
  801d95:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9f:	b8 05 00 00 00       	mov    $0x5,%eax
  801da4:	e8 2a ff ff ff       	call   801cd3 <fsipc>
  801da9:	89 c2                	mov    %eax,%edx
  801dab:	85 d2                	test   %edx,%edx
  801dad:	78 2b                	js     801dda <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801daf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801db6:	00 
  801db7:	89 1c 24             	mov    %ebx,(%esp)
  801dba:	e8 e8 eb ff ff       	call   8009a7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dbf:	a1 80 60 80 00       	mov    0x806080,%eax
  801dc4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dca:	a1 84 60 80 00       	mov    0x806084,%eax
  801dcf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dda:	83 c4 14             	add    $0x14,%esp
  801ddd:	5b                   	pop    %ebx
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    

00801de0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 18             	sub    $0x18,%esp
  801de6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801de9:	8b 55 08             	mov    0x8(%ebp),%edx
  801dec:	8b 52 0c             	mov    0xc(%edx),%edx
  801def:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801df5:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801dfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e05:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e0c:	e8 9b ed ff ff       	call   800bac <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801e11:	ba 00 00 00 00       	mov    $0x0,%edx
  801e16:	b8 04 00 00 00       	mov    $0x4,%eax
  801e1b:	e8 b3 fe ff ff       	call   801cd3 <fsipc>
		return r;
	}

	return r;
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	56                   	push   %esi
  801e26:	53                   	push   %ebx
  801e27:	83 ec 10             	sub    $0x10,%esp
  801e2a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	8b 40 0c             	mov    0xc(%eax),%eax
  801e33:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e38:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e43:	b8 03 00 00 00       	mov    $0x3,%eax
  801e48:	e8 86 fe ff ff       	call   801cd3 <fsipc>
  801e4d:	89 c3                	mov    %eax,%ebx
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 6a                	js     801ebd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801e53:	39 c6                	cmp    %eax,%esi
  801e55:	73 24                	jae    801e7b <devfile_read+0x59>
  801e57:	c7 44 24 0c 74 33 80 	movl   $0x803374,0xc(%esp)
  801e5e:	00 
  801e5f:	c7 44 24 08 7b 33 80 	movl   $0x80337b,0x8(%esp)
  801e66:	00 
  801e67:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801e6e:	00 
  801e6f:	c7 04 24 90 33 80 00 	movl   $0x803390,(%esp)
  801e76:	e8 12 e4 ff ff       	call   80028d <_panic>
	assert(r <= PGSIZE);
  801e7b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e80:	7e 24                	jle    801ea6 <devfile_read+0x84>
  801e82:	c7 44 24 0c 9b 33 80 	movl   $0x80339b,0xc(%esp)
  801e89:	00 
  801e8a:	c7 44 24 08 7b 33 80 	movl   $0x80337b,0x8(%esp)
  801e91:	00 
  801e92:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e99:	00 
  801e9a:	c7 04 24 90 33 80 00 	movl   $0x803390,(%esp)
  801ea1:	e8 e7 e3 ff ff       	call   80028d <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ea6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eaa:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801eb1:	00 
  801eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb5:	89 04 24             	mov    %eax,(%esp)
  801eb8:	e8 87 ec ff ff       	call   800b44 <memmove>
	return r;
}
  801ebd:	89 d8                	mov    %ebx,%eax
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	53                   	push   %ebx
  801eca:	83 ec 24             	sub    $0x24,%esp
  801ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ed0:	89 1c 24             	mov    %ebx,(%esp)
  801ed3:	e8 98 ea ff ff       	call   800970 <strlen>
  801ed8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801edd:	7f 60                	jg     801f3f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801edf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee2:	89 04 24             	mov    %eax,(%esp)
  801ee5:	e8 2d f8 ff ff       	call   801717 <fd_alloc>
  801eea:	89 c2                	mov    %eax,%edx
  801eec:	85 d2                	test   %edx,%edx
  801eee:	78 54                	js     801f44 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801ef0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ef4:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801efb:	e8 a7 ea ff ff       	call   8009a7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f03:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f10:	e8 be fd ff ff       	call   801cd3 <fsipc>
  801f15:	89 c3                	mov    %eax,%ebx
  801f17:	85 c0                	test   %eax,%eax
  801f19:	79 17                	jns    801f32 <open+0x6c>
		fd_close(fd, 0);
  801f1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f22:	00 
  801f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f26:	89 04 24             	mov    %eax,(%esp)
  801f29:	e8 e8 f8 ff ff       	call   801816 <fd_close>
		return r;
  801f2e:	89 d8                	mov    %ebx,%eax
  801f30:	eb 12                	jmp    801f44 <open+0x7e>
	}

	return fd2num(fd);
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	89 04 24             	mov    %eax,(%esp)
  801f38:	e8 b3 f7 ff ff       	call   8016f0 <fd2num>
  801f3d:	eb 05                	jmp    801f44 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801f3f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801f44:	83 c4 24             	add    $0x24,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    

00801f4a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f50:	ba 00 00 00 00       	mov    $0x0,%edx
  801f55:	b8 08 00 00 00       	mov    $0x8,%eax
  801f5a:	e8 74 fd ff ff       	call   801cd3 <fsipc>
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f67:	89 d0                	mov    %edx,%eax
  801f69:	c1 e8 16             	shr    $0x16,%eax
  801f6c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f78:	f6 c1 01             	test   $0x1,%cl
  801f7b:	74 1d                	je     801f9a <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f7d:	c1 ea 0c             	shr    $0xc,%edx
  801f80:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f87:	f6 c2 01             	test   $0x1,%dl
  801f8a:	74 0e                	je     801f9a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f8c:	c1 ea 0c             	shr    $0xc,%edx
  801f8f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f96:	ef 
  801f97:	0f b7 c0             	movzwl %ax,%eax
}
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    
  801f9c:	66 90                	xchg   %ax,%ax
  801f9e:	66 90                	xchg   %ax,%ax

00801fa0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801fa6:	c7 44 24 04 a7 33 80 	movl   $0x8033a7,0x4(%esp)
  801fad:	00 
  801fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb1:	89 04 24             	mov    %eax,(%esp)
  801fb4:	e8 ee e9 ff ff       	call   8009a7 <strcpy>
	return 0;
}
  801fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	53                   	push   %ebx
  801fc4:	83 ec 14             	sub    $0x14,%esp
  801fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fca:	89 1c 24             	mov    %ebx,(%esp)
  801fcd:	e8 8f ff ff ff       	call   801f61 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801fd2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801fd7:	83 f8 01             	cmp    $0x1,%eax
  801fda:	75 0d                	jne    801fe9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801fdc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801fdf:	89 04 24             	mov    %eax,(%esp)
  801fe2:	e8 29 03 00 00       	call   802310 <nsipc_close>
  801fe7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801fe9:	89 d0                	mov    %edx,%eax
  801feb:	83 c4 14             	add    $0x14,%esp
  801fee:	5b                   	pop    %ebx
  801fef:	5d                   	pop    %ebp
  801ff0:	c3                   	ret    

00801ff1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ff7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ffe:	00 
  801fff:	8b 45 10             	mov    0x10(%ebp),%eax
  802002:	89 44 24 08          	mov    %eax,0x8(%esp)
  802006:	8b 45 0c             	mov    0xc(%ebp),%eax
  802009:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	8b 40 0c             	mov    0xc(%eax),%eax
  802013:	89 04 24             	mov    %eax,(%esp)
  802016:	e8 f0 03 00 00       	call   80240b <nsipc_send>
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802023:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80202a:	00 
  80202b:	8b 45 10             	mov    0x10(%ebp),%eax
  80202e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802032:	8b 45 0c             	mov    0xc(%ebp),%eax
  802035:	89 44 24 04          	mov    %eax,0x4(%esp)
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	8b 40 0c             	mov    0xc(%eax),%eax
  80203f:	89 04 24             	mov    %eax,(%esp)
  802042:	e8 44 03 00 00       	call   80238b <nsipc_recv>
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80204f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802052:	89 54 24 04          	mov    %edx,0x4(%esp)
  802056:	89 04 24             	mov    %eax,(%esp)
  802059:	e8 08 f7 ff ff       	call   801766 <fd_lookup>
  80205e:	85 c0                	test   %eax,%eax
  802060:	78 17                	js     802079 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80206b:	39 08                	cmp    %ecx,(%eax)
  80206d:	75 05                	jne    802074 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80206f:	8b 40 0c             	mov    0xc(%eax),%eax
  802072:	eb 05                	jmp    802079 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802074:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	56                   	push   %esi
  80207f:	53                   	push   %ebx
  802080:	83 ec 20             	sub    $0x20,%esp
  802083:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802085:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802088:	89 04 24             	mov    %eax,(%esp)
  80208b:	e8 87 f6 ff ff       	call   801717 <fd_alloc>
  802090:	89 c3                	mov    %eax,%ebx
  802092:	85 c0                	test   %eax,%eax
  802094:	78 21                	js     8020b7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802096:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80209d:	00 
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ac:	e8 12 ed ff ff       	call   800dc3 <sys_page_alloc>
  8020b1:	89 c3                	mov    %eax,%ebx
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	79 0c                	jns    8020c3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8020b7:	89 34 24             	mov    %esi,(%esp)
  8020ba:	e8 51 02 00 00       	call   802310 <nsipc_close>
		return r;
  8020bf:	89 d8                	mov    %ebx,%eax
  8020c1:	eb 20                	jmp    8020e3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8020c3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8020d8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8020db:	89 14 24             	mov    %edx,(%esp)
  8020de:	e8 0d f6 ff ff       	call   8016f0 <fd2num>
}
  8020e3:	83 c4 20             	add    $0x20,%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5e                   	pop    %esi
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    

008020ea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	e8 51 ff ff ff       	call   802049 <fd2sockid>
		return r;
  8020f8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	78 23                	js     802121 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020fe:	8b 55 10             	mov    0x10(%ebp),%edx
  802101:	89 54 24 08          	mov    %edx,0x8(%esp)
  802105:	8b 55 0c             	mov    0xc(%ebp),%edx
  802108:	89 54 24 04          	mov    %edx,0x4(%esp)
  80210c:	89 04 24             	mov    %eax,(%esp)
  80210f:	e8 45 01 00 00       	call   802259 <nsipc_accept>
		return r;
  802114:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802116:	85 c0                	test   %eax,%eax
  802118:	78 07                	js     802121 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80211a:	e8 5c ff ff ff       	call   80207b <alloc_sockfd>
  80211f:	89 c1                	mov    %eax,%ecx
}
  802121:	89 c8                	mov    %ecx,%eax
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	e8 16 ff ff ff       	call   802049 <fd2sockid>
  802133:	89 c2                	mov    %eax,%edx
  802135:	85 d2                	test   %edx,%edx
  802137:	78 16                	js     80214f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802139:	8b 45 10             	mov    0x10(%ebp),%eax
  80213c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802140:	8b 45 0c             	mov    0xc(%ebp),%eax
  802143:	89 44 24 04          	mov    %eax,0x4(%esp)
  802147:	89 14 24             	mov    %edx,(%esp)
  80214a:	e8 60 01 00 00       	call   8022af <nsipc_bind>
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <shutdown>:

int
shutdown(int s, int how)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	e8 ea fe ff ff       	call   802049 <fd2sockid>
  80215f:	89 c2                	mov    %eax,%edx
  802161:	85 d2                	test   %edx,%edx
  802163:	78 0f                	js     802174 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802165:	8b 45 0c             	mov    0xc(%ebp),%eax
  802168:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216c:	89 14 24             	mov    %edx,(%esp)
  80216f:	e8 7a 01 00 00       	call   8022ee <nsipc_shutdown>
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	e8 c5 fe ff ff       	call   802049 <fd2sockid>
  802184:	89 c2                	mov    %eax,%edx
  802186:	85 d2                	test   %edx,%edx
  802188:	78 16                	js     8021a0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80218a:	8b 45 10             	mov    0x10(%ebp),%eax
  80218d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802191:	8b 45 0c             	mov    0xc(%ebp),%eax
  802194:	89 44 24 04          	mov    %eax,0x4(%esp)
  802198:	89 14 24             	mov    %edx,(%esp)
  80219b:	e8 8a 01 00 00       	call   80232a <nsipc_connect>
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <listen>:

int
listen(int s, int backlog)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	e8 99 fe ff ff       	call   802049 <fd2sockid>
  8021b0:	89 c2                	mov    %eax,%edx
  8021b2:	85 d2                	test   %edx,%edx
  8021b4:	78 0f                	js     8021c5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8021b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bd:	89 14 24             	mov    %edx,(%esp)
  8021c0:	e8 a4 01 00 00       	call   802369 <nsipc_listen>
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	89 04 24             	mov    %eax,(%esp)
  8021e1:	e8 98 02 00 00       	call   80247e <nsipc_socket>
  8021e6:	89 c2                	mov    %eax,%edx
  8021e8:	85 d2                	test   %edx,%edx
  8021ea:	78 05                	js     8021f1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8021ec:	e8 8a fe ff ff       	call   80207b <alloc_sockfd>
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	53                   	push   %ebx
  8021f7:	83 ec 14             	sub    $0x14,%esp
  8021fa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021fc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802203:	75 11                	jne    802216 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802205:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80220c:	e8 9e f4 ff ff       	call   8016af <ipc_find_env>
  802211:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802216:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80221d:	00 
  80221e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802225:	00 
  802226:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80222a:	a1 04 50 80 00       	mov    0x805004,%eax
  80222f:	89 04 24             	mov    %eax,(%esp)
  802232:	e8 0d f4 ff ff       	call   801644 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802237:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80223e:	00 
  80223f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802246:	00 
  802247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80224e:	e8 9d f3 ff ff       	call   8015f0 <ipc_recv>
}
  802253:	83 c4 14             	add    $0x14,%esp
  802256:	5b                   	pop    %ebx
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    

00802259 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	56                   	push   %esi
  80225d:	53                   	push   %ebx
  80225e:	83 ec 10             	sub    $0x10,%esp
  802261:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80226c:	8b 06                	mov    (%esi),%eax
  80226e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802273:	b8 01 00 00 00       	mov    $0x1,%eax
  802278:	e8 76 ff ff ff       	call   8021f3 <nsipc>
  80227d:	89 c3                	mov    %eax,%ebx
  80227f:	85 c0                	test   %eax,%eax
  802281:	78 23                	js     8022a6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802283:	a1 10 70 80 00       	mov    0x807010,%eax
  802288:	89 44 24 08          	mov    %eax,0x8(%esp)
  80228c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802293:	00 
  802294:	8b 45 0c             	mov    0xc(%ebp),%eax
  802297:	89 04 24             	mov    %eax,(%esp)
  80229a:	e8 a5 e8 ff ff       	call   800b44 <memmove>
		*addrlen = ret->ret_addrlen;
  80229f:	a1 10 70 80 00       	mov    0x807010,%eax
  8022a4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8022a6:	89 d8                	mov    %ebx,%eax
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5e                   	pop    %esi
  8022ad:	5d                   	pop    %ebp
  8022ae:	c3                   	ret    

008022af <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	53                   	push   %ebx
  8022b3:	83 ec 14             	sub    $0x14,%esp
  8022b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022c1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8022d3:	e8 6c e8 ff ff       	call   800b44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022d8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022de:	b8 02 00 00 00       	mov    $0x2,%eax
  8022e3:	e8 0b ff ff ff       	call   8021f3 <nsipc>
}
  8022e8:	83 c4 14             	add    $0x14,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    

008022ee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802304:	b8 03 00 00 00       	mov    $0x3,%eax
  802309:	e8 e5 fe ff ff       	call   8021f3 <nsipc>
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <nsipc_close>:

int
nsipc_close(int s)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80231e:	b8 04 00 00 00       	mov    $0x4,%eax
  802323:	e8 cb fe ff ff       	call   8021f3 <nsipc>
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	53                   	push   %ebx
  80232e:	83 ec 14             	sub    $0x14,%esp
  802331:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80233c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802340:	8b 45 0c             	mov    0xc(%ebp),%eax
  802343:	89 44 24 04          	mov    %eax,0x4(%esp)
  802347:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80234e:	e8 f1 e7 ff ff       	call   800b44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802353:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802359:	b8 05 00 00 00       	mov    $0x5,%eax
  80235e:	e8 90 fe ff ff       	call   8021f3 <nsipc>
}
  802363:	83 c4 14             	add    $0x14,%esp
  802366:	5b                   	pop    %ebx
  802367:	5d                   	pop    %ebp
  802368:	c3                   	ret    

00802369 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80237f:	b8 06 00 00 00       	mov    $0x6,%eax
  802384:	e8 6a fe ff ff       	call   8021f3 <nsipc>
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	83 ec 10             	sub    $0x10,%esp
  802393:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80239e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023ac:	b8 07 00 00 00       	mov    $0x7,%eax
  8023b1:	e8 3d fe ff ff       	call   8021f3 <nsipc>
  8023b6:	89 c3                	mov    %eax,%ebx
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	78 46                	js     802402 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8023bc:	39 f0                	cmp    %esi,%eax
  8023be:	7f 07                	jg     8023c7 <nsipc_recv+0x3c>
  8023c0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023c5:	7e 24                	jle    8023eb <nsipc_recv+0x60>
  8023c7:	c7 44 24 0c b3 33 80 	movl   $0x8033b3,0xc(%esp)
  8023ce:	00 
  8023cf:	c7 44 24 08 7b 33 80 	movl   $0x80337b,0x8(%esp)
  8023d6:	00 
  8023d7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8023de:	00 
  8023df:	c7 04 24 c8 33 80 00 	movl   $0x8033c8,(%esp)
  8023e6:	e8 a2 de ff ff       	call   80028d <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ef:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8023f6:	00 
  8023f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fa:	89 04 24             	mov    %eax,(%esp)
  8023fd:	e8 42 e7 ff ff       	call   800b44 <memmove>
	}

	return r;
}
  802402:	89 d8                	mov    %ebx,%eax
  802404:	83 c4 10             	add    $0x10,%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5d                   	pop    %ebp
  80240a:	c3                   	ret    

0080240b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	53                   	push   %ebx
  80240f:	83 ec 14             	sub    $0x14,%esp
  802412:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80241d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802423:	7e 24                	jle    802449 <nsipc_send+0x3e>
  802425:	c7 44 24 0c d4 33 80 	movl   $0x8033d4,0xc(%esp)
  80242c:	00 
  80242d:	c7 44 24 08 7b 33 80 	movl   $0x80337b,0x8(%esp)
  802434:	00 
  802435:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80243c:	00 
  80243d:	c7 04 24 c8 33 80 00 	movl   $0x8033c8,(%esp)
  802444:	e8 44 de ff ff       	call   80028d <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802449:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80244d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802450:	89 44 24 04          	mov    %eax,0x4(%esp)
  802454:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80245b:	e8 e4 e6 ff ff       	call   800b44 <memmove>
	nsipcbuf.send.req_size = size;
  802460:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802466:	8b 45 14             	mov    0x14(%ebp),%eax
  802469:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80246e:	b8 08 00 00 00       	mov    $0x8,%eax
  802473:	e8 7b fd ff ff       	call   8021f3 <nsipc>
}
  802478:	83 c4 14             	add    $0x14,%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5d                   	pop    %ebp
  80247d:	c3                   	ret    

0080247e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80248c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802494:	8b 45 10             	mov    0x10(%ebp),%eax
  802497:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80249c:	b8 09 00 00 00       	mov    $0x9,%eax
  8024a1:	e8 4d fd ff ff       	call   8021f3 <nsipc>
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	56                   	push   %esi
  8024ac:	53                   	push   %ebx
  8024ad:	83 ec 10             	sub    $0x10,%esp
  8024b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	89 04 24             	mov    %eax,(%esp)
  8024b9:	e8 42 f2 ff ff       	call   801700 <fd2data>
  8024be:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024c0:	c7 44 24 04 e0 33 80 	movl   $0x8033e0,0x4(%esp)
  8024c7:	00 
  8024c8:	89 1c 24             	mov    %ebx,(%esp)
  8024cb:	e8 d7 e4 ff ff       	call   8009a7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024d0:	8b 46 04             	mov    0x4(%esi),%eax
  8024d3:	2b 06                	sub    (%esi),%eax
  8024d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024e2:	00 00 00 
	stat->st_dev = &devpipe;
  8024e5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8024ec:	40 80 00 
	return 0;
}
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	83 c4 10             	add    $0x10,%esp
  8024f7:	5b                   	pop    %ebx
  8024f8:	5e                   	pop    %esi
  8024f9:	5d                   	pop    %ebp
  8024fa:	c3                   	ret    

008024fb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	53                   	push   %ebx
  8024ff:	83 ec 14             	sub    $0x14,%esp
  802502:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802505:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802510:	e8 55 e9 ff ff       	call   800e6a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802515:	89 1c 24             	mov    %ebx,(%esp)
  802518:	e8 e3 f1 ff ff       	call   801700 <fd2data>
  80251d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802521:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802528:	e8 3d e9 ff ff       	call   800e6a <sys_page_unmap>
}
  80252d:	83 c4 14             	add    $0x14,%esp
  802530:	5b                   	pop    %ebx
  802531:	5d                   	pop    %ebp
  802532:	c3                   	ret    

00802533 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	57                   	push   %edi
  802537:	56                   	push   %esi
  802538:	53                   	push   %ebx
  802539:	83 ec 2c             	sub    $0x2c,%esp
  80253c:	89 c6                	mov    %eax,%esi
  80253e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802541:	a1 08 50 80 00       	mov    0x805008,%eax
  802546:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802549:	89 34 24             	mov    %esi,(%esp)
  80254c:	e8 10 fa ff ff       	call   801f61 <pageref>
  802551:	89 c7                	mov    %eax,%edi
  802553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802556:	89 04 24             	mov    %eax,(%esp)
  802559:	e8 03 fa ff ff       	call   801f61 <pageref>
  80255e:	39 c7                	cmp    %eax,%edi
  802560:	0f 94 c2             	sete   %dl
  802563:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802566:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80256c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80256f:	39 fb                	cmp    %edi,%ebx
  802571:	74 21                	je     802594 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802573:	84 d2                	test   %dl,%dl
  802575:	74 ca                	je     802541 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802577:	8b 51 58             	mov    0x58(%ecx),%edx
  80257a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80257e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802582:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802586:	c7 04 24 e7 33 80 00 	movl   $0x8033e7,(%esp)
  80258d:	e8 f4 dd ff ff       	call   800386 <cprintf>
  802592:	eb ad                	jmp    802541 <_pipeisclosed+0xe>
	}
}
  802594:	83 c4 2c             	add    $0x2c,%esp
  802597:	5b                   	pop    %ebx
  802598:	5e                   	pop    %esi
  802599:	5f                   	pop    %edi
  80259a:	5d                   	pop    %ebp
  80259b:	c3                   	ret    

0080259c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	57                   	push   %edi
  8025a0:	56                   	push   %esi
  8025a1:	53                   	push   %ebx
  8025a2:	83 ec 1c             	sub    $0x1c,%esp
  8025a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8025a8:	89 34 24             	mov    %esi,(%esp)
  8025ab:	e8 50 f1 ff ff       	call   801700 <fd2data>
  8025b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b7:	eb 45                	jmp    8025fe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8025b9:	89 da                	mov    %ebx,%edx
  8025bb:	89 f0                	mov    %esi,%eax
  8025bd:	e8 71 ff ff ff       	call   802533 <_pipeisclosed>
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	75 41                	jne    802607 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8025c6:	e8 d9 e7 ff ff       	call   800da4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8025ce:	8b 0b                	mov    (%ebx),%ecx
  8025d0:	8d 51 20             	lea    0x20(%ecx),%edx
  8025d3:	39 d0                	cmp    %edx,%eax
  8025d5:	73 e2                	jae    8025b9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025da:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025de:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025e1:	99                   	cltd   
  8025e2:	c1 ea 1b             	shr    $0x1b,%edx
  8025e5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8025e8:	83 e1 1f             	and    $0x1f,%ecx
  8025eb:	29 d1                	sub    %edx,%ecx
  8025ed:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8025f1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8025f5:	83 c0 01             	add    $0x1,%eax
  8025f8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025fb:	83 c7 01             	add    $0x1,%edi
  8025fe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802601:	75 c8                	jne    8025cb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802603:	89 f8                	mov    %edi,%eax
  802605:	eb 05                	jmp    80260c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80260c:	83 c4 1c             	add    $0x1c,%esp
  80260f:	5b                   	pop    %ebx
  802610:	5e                   	pop    %esi
  802611:	5f                   	pop    %edi
  802612:	5d                   	pop    %ebp
  802613:	c3                   	ret    

00802614 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	57                   	push   %edi
  802618:	56                   	push   %esi
  802619:	53                   	push   %ebx
  80261a:	83 ec 1c             	sub    $0x1c,%esp
  80261d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802620:	89 3c 24             	mov    %edi,(%esp)
  802623:	e8 d8 f0 ff ff       	call   801700 <fd2data>
  802628:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80262a:	be 00 00 00 00       	mov    $0x0,%esi
  80262f:	eb 3d                	jmp    80266e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802631:	85 f6                	test   %esi,%esi
  802633:	74 04                	je     802639 <devpipe_read+0x25>
				return i;
  802635:	89 f0                	mov    %esi,%eax
  802637:	eb 43                	jmp    80267c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802639:	89 da                	mov    %ebx,%edx
  80263b:	89 f8                	mov    %edi,%eax
  80263d:	e8 f1 fe ff ff       	call   802533 <_pipeisclosed>
  802642:	85 c0                	test   %eax,%eax
  802644:	75 31                	jne    802677 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802646:	e8 59 e7 ff ff       	call   800da4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80264b:	8b 03                	mov    (%ebx),%eax
  80264d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802650:	74 df                	je     802631 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802652:	99                   	cltd   
  802653:	c1 ea 1b             	shr    $0x1b,%edx
  802656:	01 d0                	add    %edx,%eax
  802658:	83 e0 1f             	and    $0x1f,%eax
  80265b:	29 d0                	sub    %edx,%eax
  80265d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802662:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802665:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802668:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80266b:	83 c6 01             	add    $0x1,%esi
  80266e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802671:	75 d8                	jne    80264b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802673:	89 f0                	mov    %esi,%eax
  802675:	eb 05                	jmp    80267c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802677:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80267c:	83 c4 1c             	add    $0x1c,%esp
  80267f:	5b                   	pop    %ebx
  802680:	5e                   	pop    %esi
  802681:	5f                   	pop    %edi
  802682:	5d                   	pop    %ebp
  802683:	c3                   	ret    

00802684 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	56                   	push   %esi
  802688:	53                   	push   %ebx
  802689:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80268c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80268f:	89 04 24             	mov    %eax,(%esp)
  802692:	e8 80 f0 ff ff       	call   801717 <fd_alloc>
  802697:	89 c2                	mov    %eax,%edx
  802699:	85 d2                	test   %edx,%edx
  80269b:	0f 88 4d 01 00 00    	js     8027ee <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026a1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026a8:	00 
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b7:	e8 07 e7 ff ff       	call   800dc3 <sys_page_alloc>
  8026bc:	89 c2                	mov    %eax,%edx
  8026be:	85 d2                	test   %edx,%edx
  8026c0:	0f 88 28 01 00 00    	js     8027ee <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026c9:	89 04 24             	mov    %eax,(%esp)
  8026cc:	e8 46 f0 ff ff       	call   801717 <fd_alloc>
  8026d1:	89 c3                	mov    %eax,%ebx
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	0f 88 fe 00 00 00    	js     8027d9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026db:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026e2:	00 
  8026e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f1:	e8 cd e6 ff ff       	call   800dc3 <sys_page_alloc>
  8026f6:	89 c3                	mov    %eax,%ebx
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	0f 88 d9 00 00 00    	js     8027d9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	89 04 24             	mov    %eax,(%esp)
  802706:	e8 f5 ef ff ff       	call   801700 <fd2data>
  80270b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802714:	00 
  802715:	89 44 24 04          	mov    %eax,0x4(%esp)
  802719:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802720:	e8 9e e6 ff ff       	call   800dc3 <sys_page_alloc>
  802725:	89 c3                	mov    %eax,%ebx
  802727:	85 c0                	test   %eax,%eax
  802729:	0f 88 97 00 00 00    	js     8027c6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	89 04 24             	mov    %eax,(%esp)
  802735:	e8 c6 ef ff ff       	call   801700 <fd2data>
  80273a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802741:	00 
  802742:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802746:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80274d:	00 
  80274e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802752:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802759:	e8 b9 e6 ff ff       	call   800e17 <sys_page_map>
  80275e:	89 c3                	mov    %eax,%ebx
  802760:	85 c0                	test   %eax,%eax
  802762:	78 52                	js     8027b6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802764:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802779:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	89 04 24             	mov    %eax,(%esp)
  802794:	e8 57 ef ff ff       	call   8016f0 <fd2num>
  802799:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80279c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80279e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a1:	89 04 24             	mov    %eax,(%esp)
  8027a4:	e8 47 ef ff ff       	call   8016f0 <fd2num>
  8027a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027ac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b4:	eb 38                	jmp    8027ee <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8027b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027c1:	e8 a4 e6 ff ff       	call   800e6a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8027c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d4:	e8 91 e6 ff ff       	call   800e6a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027e7:	e8 7e e6 ff ff       	call   800e6a <sys_page_unmap>
  8027ec:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8027ee:	83 c4 30             	add    $0x30,%esp
  8027f1:	5b                   	pop    %ebx
  8027f2:	5e                   	pop    %esi
  8027f3:	5d                   	pop    %ebp
  8027f4:	c3                   	ret    

008027f5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	89 04 24             	mov    %eax,(%esp)
  802808:	e8 59 ef ff ff       	call   801766 <fd_lookup>
  80280d:	89 c2                	mov    %eax,%edx
  80280f:	85 d2                	test   %edx,%edx
  802811:	78 15                	js     802828 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	89 04 24             	mov    %eax,(%esp)
  802819:	e8 e2 ee ff ff       	call   801700 <fd2data>
	return _pipeisclosed(fd, p);
  80281e:	89 c2                	mov    %eax,%edx
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	e8 0b fd ff ff       	call   802533 <_pipeisclosed>
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	66 90                	xchg   %ax,%ax
  80282e:	66 90                	xchg   %ax,%ax

00802830 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
  802838:	5d                   	pop    %ebp
  802839:	c3                   	ret    

0080283a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
  80283d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802840:	c7 44 24 04 ff 33 80 	movl   $0x8033ff,0x4(%esp)
  802847:	00 
  802848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284b:	89 04 24             	mov    %eax,(%esp)
  80284e:	e8 54 e1 ff ff       	call   8009a7 <strcpy>
	return 0;
}
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
  80285d:	57                   	push   %edi
  80285e:	56                   	push   %esi
  80285f:	53                   	push   %ebx
  802860:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802866:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80286b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802871:	eb 31                	jmp    8028a4 <devcons_write+0x4a>
		m = n - tot;
  802873:	8b 75 10             	mov    0x10(%ebp),%esi
  802876:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802878:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80287b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802880:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802883:	89 74 24 08          	mov    %esi,0x8(%esp)
  802887:	03 45 0c             	add    0xc(%ebp),%eax
  80288a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80288e:	89 3c 24             	mov    %edi,(%esp)
  802891:	e8 ae e2 ff ff       	call   800b44 <memmove>
		sys_cputs(buf, m);
  802896:	89 74 24 04          	mov    %esi,0x4(%esp)
  80289a:	89 3c 24             	mov    %edi,(%esp)
  80289d:	e8 54 e4 ff ff       	call   800cf6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028a2:	01 f3                	add    %esi,%ebx
  8028a4:	89 d8                	mov    %ebx,%eax
  8028a6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8028a9:	72 c8                	jb     802873 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8028ab:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8028b1:	5b                   	pop    %ebx
  8028b2:	5e                   	pop    %esi
  8028b3:	5f                   	pop    %edi
  8028b4:	5d                   	pop    %ebp
  8028b5:	c3                   	ret    

008028b6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8028bc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8028c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028c5:	75 07                	jne    8028ce <devcons_read+0x18>
  8028c7:	eb 2a                	jmp    8028f3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028c9:	e8 d6 e4 ff ff       	call   800da4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028ce:	66 90                	xchg   %ax,%ax
  8028d0:	e8 3f e4 ff ff       	call   800d14 <sys_cgetc>
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 f0                	je     8028c9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	78 16                	js     8028f3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8028dd:	83 f8 04             	cmp    $0x4,%eax
  8028e0:	74 0c                	je     8028ee <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8028e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e5:	88 02                	mov    %al,(%edx)
	return 1;
  8028e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ec:	eb 05                	jmp    8028f3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8028ee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802901:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802908:	00 
  802909:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80290c:	89 04 24             	mov    %eax,(%esp)
  80290f:	e8 e2 e3 ff ff       	call   800cf6 <sys_cputs>
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <getchar>:

int
getchar(void)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80291c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802923:	00 
  802924:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80292b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802932:	e8 c3 f0 ff ff       	call   8019fa <read>
	if (r < 0)
  802937:	85 c0                	test   %eax,%eax
  802939:	78 0f                	js     80294a <getchar+0x34>
		return r;
	if (r < 1)
  80293b:	85 c0                	test   %eax,%eax
  80293d:	7e 06                	jle    802945 <getchar+0x2f>
		return -E_EOF;
	return c;
  80293f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802943:	eb 05                	jmp    80294a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802945:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80294a:	c9                   	leave  
  80294b:	c3                   	ret    

0080294c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802952:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802955:	89 44 24 04          	mov    %eax,0x4(%esp)
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	89 04 24             	mov    %eax,(%esp)
  80295f:	e8 02 ee ff ff       	call   801766 <fd_lookup>
  802964:	85 c0                	test   %eax,%eax
  802966:	78 11                	js     802979 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802971:	39 10                	cmp    %edx,(%eax)
  802973:	0f 94 c0             	sete   %al
  802976:	0f b6 c0             	movzbl %al,%eax
}
  802979:	c9                   	leave  
  80297a:	c3                   	ret    

0080297b <opencons>:

int
opencons(void)
{
  80297b:	55                   	push   %ebp
  80297c:	89 e5                	mov    %esp,%ebp
  80297e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802981:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802984:	89 04 24             	mov    %eax,(%esp)
  802987:	e8 8b ed ff ff       	call   801717 <fd_alloc>
		return r;
  80298c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80298e:	85 c0                	test   %eax,%eax
  802990:	78 40                	js     8029d2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802992:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802999:	00 
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a8:	e8 16 e4 ff ff       	call   800dc3 <sys_page_alloc>
		return r;
  8029ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	78 1f                	js     8029d2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8029b3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8029c8:	89 04 24             	mov    %eax,(%esp)
  8029cb:	e8 20 ed ff ff       	call   8016f0 <fd2num>
  8029d0:	89 c2                	mov    %eax,%edx
}
  8029d2:	89 d0                	mov    %edx,%eax
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    

008029d6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
  8029d9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029dc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8029e3:	75 70                	jne    802a55 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  8029e5:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  8029ec:	00 
  8029ed:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029f4:	ee 
  8029f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029fc:	e8 c2 e3 ff ff       	call   800dc3 <sys_page_alloc>
		if (error < 0)
  802a01:	85 c0                	test   %eax,%eax
  802a03:	79 1c                	jns    802a21 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  802a05:	c7 44 24 08 0c 34 80 	movl   $0x80340c,0x8(%esp)
  802a0c:	00 
  802a0d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802a14:	00 
  802a15:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  802a1c:	e8 6c d8 ff ff       	call   80028d <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802a21:	c7 44 24 04 5f 2a 80 	movl   $0x802a5f,0x4(%esp)
  802a28:	00 
  802a29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a30:	e8 2e e5 ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
		if (error < 0)
  802a35:	85 c0                	test   %eax,%eax
  802a37:	79 1c                	jns    802a55 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  802a39:	c7 44 24 08 34 34 80 	movl   $0x803434,0x8(%esp)
  802a40:	00 
  802a41:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802a48:	00 
  802a49:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  802a50:	e8 38 d8 ff ff       	call   80028d <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a5d:	c9                   	leave  
  802a5e:	c3                   	ret    

00802a5f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a5f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a60:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a65:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a67:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  802a6a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  802a6e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802a73:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802a77:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802a79:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802a7c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a7d:	83 c4 04             	add    $0x4,%esp
	popfl
  802a80:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a81:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a82:	c3                   	ret    
  802a83:	66 90                	xchg   %ax,%ax
  802a85:	66 90                	xchg   %ax,%ax
  802a87:	66 90                	xchg   %ax,%ax
  802a89:	66 90                	xchg   %ax,%ax
  802a8b:	66 90                	xchg   %ax,%ax
  802a8d:	66 90                	xchg   %ax,%ax
  802a8f:	90                   	nop

00802a90 <__udivdi3>:
  802a90:	55                   	push   %ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	83 ec 0c             	sub    $0xc,%esp
  802a96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a9a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a9e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802aa2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802aac:	89 ea                	mov    %ebp,%edx
  802aae:	89 0c 24             	mov    %ecx,(%esp)
  802ab1:	75 2d                	jne    802ae0 <__udivdi3+0x50>
  802ab3:	39 e9                	cmp    %ebp,%ecx
  802ab5:	77 61                	ja     802b18 <__udivdi3+0x88>
  802ab7:	85 c9                	test   %ecx,%ecx
  802ab9:	89 ce                	mov    %ecx,%esi
  802abb:	75 0b                	jne    802ac8 <__udivdi3+0x38>
  802abd:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac2:	31 d2                	xor    %edx,%edx
  802ac4:	f7 f1                	div    %ecx
  802ac6:	89 c6                	mov    %eax,%esi
  802ac8:	31 d2                	xor    %edx,%edx
  802aca:	89 e8                	mov    %ebp,%eax
  802acc:	f7 f6                	div    %esi
  802ace:	89 c5                	mov    %eax,%ebp
  802ad0:	89 f8                	mov    %edi,%eax
  802ad2:	f7 f6                	div    %esi
  802ad4:	89 ea                	mov    %ebp,%edx
  802ad6:	83 c4 0c             	add    $0xc,%esp
  802ad9:	5e                   	pop    %esi
  802ada:	5f                   	pop    %edi
  802adb:	5d                   	pop    %ebp
  802adc:	c3                   	ret    
  802add:	8d 76 00             	lea    0x0(%esi),%esi
  802ae0:	39 e8                	cmp    %ebp,%eax
  802ae2:	77 24                	ja     802b08 <__udivdi3+0x78>
  802ae4:	0f bd e8             	bsr    %eax,%ebp
  802ae7:	83 f5 1f             	xor    $0x1f,%ebp
  802aea:	75 3c                	jne    802b28 <__udivdi3+0x98>
  802aec:	8b 74 24 04          	mov    0x4(%esp),%esi
  802af0:	39 34 24             	cmp    %esi,(%esp)
  802af3:	0f 86 9f 00 00 00    	jbe    802b98 <__udivdi3+0x108>
  802af9:	39 d0                	cmp    %edx,%eax
  802afb:	0f 82 97 00 00 00    	jb     802b98 <__udivdi3+0x108>
  802b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b08:	31 d2                	xor    %edx,%edx
  802b0a:	31 c0                	xor    %eax,%eax
  802b0c:	83 c4 0c             	add    $0xc,%esp
  802b0f:	5e                   	pop    %esi
  802b10:	5f                   	pop    %edi
  802b11:	5d                   	pop    %ebp
  802b12:	c3                   	ret    
  802b13:	90                   	nop
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	89 f8                	mov    %edi,%eax
  802b1a:	f7 f1                	div    %ecx
  802b1c:	31 d2                	xor    %edx,%edx
  802b1e:	83 c4 0c             	add    $0xc,%esp
  802b21:	5e                   	pop    %esi
  802b22:	5f                   	pop    %edi
  802b23:	5d                   	pop    %ebp
  802b24:	c3                   	ret    
  802b25:	8d 76 00             	lea    0x0(%esi),%esi
  802b28:	89 e9                	mov    %ebp,%ecx
  802b2a:	8b 3c 24             	mov    (%esp),%edi
  802b2d:	d3 e0                	shl    %cl,%eax
  802b2f:	89 c6                	mov    %eax,%esi
  802b31:	b8 20 00 00 00       	mov    $0x20,%eax
  802b36:	29 e8                	sub    %ebp,%eax
  802b38:	89 c1                	mov    %eax,%ecx
  802b3a:	d3 ef                	shr    %cl,%edi
  802b3c:	89 e9                	mov    %ebp,%ecx
  802b3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b42:	8b 3c 24             	mov    (%esp),%edi
  802b45:	09 74 24 08          	or     %esi,0x8(%esp)
  802b49:	89 d6                	mov    %edx,%esi
  802b4b:	d3 e7                	shl    %cl,%edi
  802b4d:	89 c1                	mov    %eax,%ecx
  802b4f:	89 3c 24             	mov    %edi,(%esp)
  802b52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b56:	d3 ee                	shr    %cl,%esi
  802b58:	89 e9                	mov    %ebp,%ecx
  802b5a:	d3 e2                	shl    %cl,%edx
  802b5c:	89 c1                	mov    %eax,%ecx
  802b5e:	d3 ef                	shr    %cl,%edi
  802b60:	09 d7                	or     %edx,%edi
  802b62:	89 f2                	mov    %esi,%edx
  802b64:	89 f8                	mov    %edi,%eax
  802b66:	f7 74 24 08          	divl   0x8(%esp)
  802b6a:	89 d6                	mov    %edx,%esi
  802b6c:	89 c7                	mov    %eax,%edi
  802b6e:	f7 24 24             	mull   (%esp)
  802b71:	39 d6                	cmp    %edx,%esi
  802b73:	89 14 24             	mov    %edx,(%esp)
  802b76:	72 30                	jb     802ba8 <__udivdi3+0x118>
  802b78:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b7c:	89 e9                	mov    %ebp,%ecx
  802b7e:	d3 e2                	shl    %cl,%edx
  802b80:	39 c2                	cmp    %eax,%edx
  802b82:	73 05                	jae    802b89 <__udivdi3+0xf9>
  802b84:	3b 34 24             	cmp    (%esp),%esi
  802b87:	74 1f                	je     802ba8 <__udivdi3+0x118>
  802b89:	89 f8                	mov    %edi,%eax
  802b8b:	31 d2                	xor    %edx,%edx
  802b8d:	e9 7a ff ff ff       	jmp    802b0c <__udivdi3+0x7c>
  802b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b98:	31 d2                	xor    %edx,%edx
  802b9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b9f:	e9 68 ff ff ff       	jmp    802b0c <__udivdi3+0x7c>
  802ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802bab:	31 d2                	xor    %edx,%edx
  802bad:	83 c4 0c             	add    $0xc,%esp
  802bb0:	5e                   	pop    %esi
  802bb1:	5f                   	pop    %edi
  802bb2:	5d                   	pop    %ebp
  802bb3:	c3                   	ret    
  802bb4:	66 90                	xchg   %ax,%ax
  802bb6:	66 90                	xchg   %ax,%ax
  802bb8:	66 90                	xchg   %ax,%ax
  802bba:	66 90                	xchg   %ax,%ax
  802bbc:	66 90                	xchg   %ax,%ax
  802bbe:	66 90                	xchg   %ax,%ax

00802bc0 <__umoddi3>:
  802bc0:	55                   	push   %ebp
  802bc1:	57                   	push   %edi
  802bc2:	56                   	push   %esi
  802bc3:	83 ec 14             	sub    $0x14,%esp
  802bc6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802bd2:	89 c7                	mov    %eax,%edi
  802bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bd8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802bdc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802be0:	89 34 24             	mov    %esi,(%esp)
  802be3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802be7:	85 c0                	test   %eax,%eax
  802be9:	89 c2                	mov    %eax,%edx
  802beb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bef:	75 17                	jne    802c08 <__umoddi3+0x48>
  802bf1:	39 fe                	cmp    %edi,%esi
  802bf3:	76 4b                	jbe    802c40 <__umoddi3+0x80>
  802bf5:	89 c8                	mov    %ecx,%eax
  802bf7:	89 fa                	mov    %edi,%edx
  802bf9:	f7 f6                	div    %esi
  802bfb:	89 d0                	mov    %edx,%eax
  802bfd:	31 d2                	xor    %edx,%edx
  802bff:	83 c4 14             	add    $0x14,%esp
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    
  802c06:	66 90                	xchg   %ax,%ax
  802c08:	39 f8                	cmp    %edi,%eax
  802c0a:	77 54                	ja     802c60 <__umoddi3+0xa0>
  802c0c:	0f bd e8             	bsr    %eax,%ebp
  802c0f:	83 f5 1f             	xor    $0x1f,%ebp
  802c12:	75 5c                	jne    802c70 <__umoddi3+0xb0>
  802c14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c18:	39 3c 24             	cmp    %edi,(%esp)
  802c1b:	0f 87 e7 00 00 00    	ja     802d08 <__umoddi3+0x148>
  802c21:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c25:	29 f1                	sub    %esi,%ecx
  802c27:	19 c7                	sbb    %eax,%edi
  802c29:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c31:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c35:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c39:	83 c4 14             	add    $0x14,%esp
  802c3c:	5e                   	pop    %esi
  802c3d:	5f                   	pop    %edi
  802c3e:	5d                   	pop    %ebp
  802c3f:	c3                   	ret    
  802c40:	85 f6                	test   %esi,%esi
  802c42:	89 f5                	mov    %esi,%ebp
  802c44:	75 0b                	jne    802c51 <__umoddi3+0x91>
  802c46:	b8 01 00 00 00       	mov    $0x1,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	f7 f6                	div    %esi
  802c4f:	89 c5                	mov    %eax,%ebp
  802c51:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c55:	31 d2                	xor    %edx,%edx
  802c57:	f7 f5                	div    %ebp
  802c59:	89 c8                	mov    %ecx,%eax
  802c5b:	f7 f5                	div    %ebp
  802c5d:	eb 9c                	jmp    802bfb <__umoddi3+0x3b>
  802c5f:	90                   	nop
  802c60:	89 c8                	mov    %ecx,%eax
  802c62:	89 fa                	mov    %edi,%edx
  802c64:	83 c4 14             	add    $0x14,%esp
  802c67:	5e                   	pop    %esi
  802c68:	5f                   	pop    %edi
  802c69:	5d                   	pop    %ebp
  802c6a:	c3                   	ret    
  802c6b:	90                   	nop
  802c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c70:	8b 04 24             	mov    (%esp),%eax
  802c73:	be 20 00 00 00       	mov    $0x20,%esi
  802c78:	89 e9                	mov    %ebp,%ecx
  802c7a:	29 ee                	sub    %ebp,%esi
  802c7c:	d3 e2                	shl    %cl,%edx
  802c7e:	89 f1                	mov    %esi,%ecx
  802c80:	d3 e8                	shr    %cl,%eax
  802c82:	89 e9                	mov    %ebp,%ecx
  802c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c88:	8b 04 24             	mov    (%esp),%eax
  802c8b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c8f:	89 fa                	mov    %edi,%edx
  802c91:	d3 e0                	shl    %cl,%eax
  802c93:	89 f1                	mov    %esi,%ecx
  802c95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c99:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c9d:	d3 ea                	shr    %cl,%edx
  802c9f:	89 e9                	mov    %ebp,%ecx
  802ca1:	d3 e7                	shl    %cl,%edi
  802ca3:	89 f1                	mov    %esi,%ecx
  802ca5:	d3 e8                	shr    %cl,%eax
  802ca7:	89 e9                	mov    %ebp,%ecx
  802ca9:	09 f8                	or     %edi,%eax
  802cab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802caf:	f7 74 24 04          	divl   0x4(%esp)
  802cb3:	d3 e7                	shl    %cl,%edi
  802cb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cb9:	89 d7                	mov    %edx,%edi
  802cbb:	f7 64 24 08          	mull   0x8(%esp)
  802cbf:	39 d7                	cmp    %edx,%edi
  802cc1:	89 c1                	mov    %eax,%ecx
  802cc3:	89 14 24             	mov    %edx,(%esp)
  802cc6:	72 2c                	jb     802cf4 <__umoddi3+0x134>
  802cc8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802ccc:	72 22                	jb     802cf0 <__umoddi3+0x130>
  802cce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802cd2:	29 c8                	sub    %ecx,%eax
  802cd4:	19 d7                	sbb    %edx,%edi
  802cd6:	89 e9                	mov    %ebp,%ecx
  802cd8:	89 fa                	mov    %edi,%edx
  802cda:	d3 e8                	shr    %cl,%eax
  802cdc:	89 f1                	mov    %esi,%ecx
  802cde:	d3 e2                	shl    %cl,%edx
  802ce0:	89 e9                	mov    %ebp,%ecx
  802ce2:	d3 ef                	shr    %cl,%edi
  802ce4:	09 d0                	or     %edx,%eax
  802ce6:	89 fa                	mov    %edi,%edx
  802ce8:	83 c4 14             	add    $0x14,%esp
  802ceb:	5e                   	pop    %esi
  802cec:	5f                   	pop    %edi
  802ced:	5d                   	pop    %ebp
  802cee:	c3                   	ret    
  802cef:	90                   	nop
  802cf0:	39 d7                	cmp    %edx,%edi
  802cf2:	75 da                	jne    802cce <__umoddi3+0x10e>
  802cf4:	8b 14 24             	mov    (%esp),%edx
  802cf7:	89 c1                	mov    %eax,%ecx
  802cf9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802cfd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d01:	eb cb                	jmp    802cce <__umoddi3+0x10e>
  802d03:	90                   	nop
  802d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d0c:	0f 82 0f ff ff ff    	jb     802c21 <__umoddi3+0x61>
  802d12:	e9 1a ff ff ff       	jmp    802c31 <__umoddi3+0x71>
