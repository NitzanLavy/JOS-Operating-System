
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 8c 02 00 00       	call   8002bd <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004c:	00 
  80004d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800051:	89 1c 24             	mov    %ebx,(%esp)
  800054:	e8 d3 19 00 00       	call   801a2c <readn>
  800059:	83 f8 04             	cmp    $0x4,%eax
  80005c:	74 2e                	je     80008c <primeproc+0x59>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005e:	85 c0                	test   %eax,%eax
  800060:	ba 00 00 00 00       	mov    $0x0,%edx
  800065:	0f 4e d0             	cmovle %eax,%edx
  800068:	89 54 24 10          	mov    %edx,0x10(%esp)
  80006c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800070:	c7 44 24 08 e0 2d 80 	movl   $0x802de0,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  80007f:	00 
  800080:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  800087:	e8 96 02 00 00       	call   800322 <_panic>

	cprintf("%d\n", p);
  80008c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80008f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800093:	c7 04 24 21 2e 80 00 	movl   $0x802e21,(%esp)
  80009a:	e8 7c 03 00 00       	call   80041b <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  80009f:	89 3c 24             	mov    %edi,(%esp)
  8000a2:	e8 4d 25 00 00       	call   8025f4 <pipe>
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <primeproc+0x9b>
		panic("pipe: %e", i);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 25 2e 80 	movl   $0x802e25,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  8000c9:	e8 54 02 00 00       	call   800322 <_panic>
	if ((id = fork()) < 0)
  8000ce:	e8 e7 12 00 00       	call   8013ba <fork>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	79 20                	jns    8000f7 <primeproc+0xc4>
		panic("fork: %e", id);
  8000d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000db:	c7 44 24 08 2e 2e 80 	movl   $0x802e2e,0x8(%esp)
  8000e2:	00 
  8000e3:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000ea:	00 
  8000eb:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  8000f2:	e8 2b 02 00 00       	call   800322 <_panic>
	if (id == 0) {
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	75 1b                	jne    800116 <primeproc+0xe3>
		close(fd);
  8000fb:	89 1c 24             	mov    %ebx,(%esp)
  8000fe:	e8 34 17 00 00       	call   801837 <close>
		close(pfd[1]);
  800103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800106:	89 04 24             	mov    %eax,(%esp)
  800109:	e8 29 17 00 00       	call   801837 <close>
		fd = pfd[0];
  80010e:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800111:	e9 2f ff ff ff       	jmp    800045 <primeproc+0x12>
	}

	close(pfd[0]);
  800116:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800119:	89 04 24             	mov    %eax,(%esp)
  80011c:	e8 16 17 00 00       	call   801837 <close>
	wfd = pfd[1];
  800121:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800124:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800127:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80012e:	00 
  80012f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800133:	89 1c 24             	mov    %ebx,(%esp)
  800136:	e8 f1 18 00 00       	call   801a2c <readn>
  80013b:	83 f8 04             	cmp    $0x4,%eax
  80013e:	74 39                	je     800179 <primeproc+0x146>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800140:	85 c0                	test   %eax,%eax
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	0f 4e d0             	cmovle %eax,%edx
  80014a:	89 54 24 18          	mov    %edx,0x18(%esp)
  80014e:	89 44 24 14          	mov    %eax,0x14(%esp)
  800152:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800159:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015d:	c7 44 24 08 37 2e 80 	movl   $0x802e37,0x8(%esp)
  800164:	00 
  800165:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  80016c:	00 
  80016d:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  800174:	e8 a9 01 00 00       	call   800322 <_panic>
		if (i%p)
  800179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017c:	99                   	cltd   
  80017d:	f7 7d e0             	idivl  -0x20(%ebp)
  800180:	85 d2                	test   %edx,%edx
  800182:	74 a3                	je     800127 <primeproc+0xf4>
			if ((r=write(wfd, &i, 4)) != 4)
  800184:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80018b:	00 
  80018c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800190:	89 3c 24             	mov    %edi,(%esp)
  800193:	e8 df 18 00 00       	call   801a77 <write>
  800198:	83 f8 04             	cmp    $0x4,%eax
  80019b:	74 8a                	je     800127 <primeproc+0xf4>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80019d:	85 c0                	test   %eax,%eax
  80019f:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a4:	0f 4e d0             	cmovle %eax,%edx
  8001a7:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 53 2e 80 	movl   $0x802e53,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  8001cd:	e8 50 01 00 00       	call   800322 <_panic>

008001d2 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  8001d9:	c7 05 00 40 80 00 6d 	movl   $0x802e6d,0x804000
  8001e0:	2e 80 00 

	if ((i=pipe(p)) < 0)
  8001e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 06 24 00 00       	call   8025f4 <pipe>
  8001ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	79 20                	jns    800215 <umain+0x43>
		panic("pipe: %e", i);
  8001f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f9:	c7 44 24 08 25 2e 80 	movl   $0x802e25,0x8(%esp)
  800200:	00 
  800201:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800208:	00 
  800209:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  800210:	e8 0d 01 00 00       	call   800322 <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800215:	e8 a0 11 00 00       	call   8013ba <fork>
  80021a:	85 c0                	test   %eax,%eax
  80021c:	79 20                	jns    80023e <umain+0x6c>
		panic("fork: %e", id);
  80021e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800222:	c7 44 24 08 2e 2e 80 	movl   $0x802e2e,0x8(%esp)
  800229:	00 
  80022a:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  800231:	00 
  800232:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  800239:	e8 e4 00 00 00       	call   800322 <_panic>

	if (id == 0) {
  80023e:	85 c0                	test   %eax,%eax
  800240:	75 16                	jne    800258 <umain+0x86>
		close(p[1]);
  800242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	e8 ea 15 00 00       	call   801837 <close>
		primeproc(p[0]);
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	e8 db fd ff ff       	call   800033 <primeproc>
	}

	close(p[0]);
  800258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 d4 15 00 00       	call   801837 <close>

	// feed all the integers through
	for (i=2;; i++)
  800263:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80026a:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80026d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800274:	00 
  800275:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027c:	89 04 24             	mov    %eax,(%esp)
  80027f:	e8 f3 17 00 00       	call   801a77 <write>
  800284:	83 f8 04             	cmp    $0x4,%eax
  800287:	74 2e                	je     8002b7 <umain+0xe5>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800289:	85 c0                	test   %eax,%eax
  80028b:	ba 00 00 00 00       	mov    $0x0,%edx
  800290:	0f 4e d0             	cmovle %eax,%edx
  800293:	89 54 24 10          	mov    %edx,0x10(%esp)
  800297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029b:	c7 44 24 08 78 2e 80 	movl   $0x802e78,0x8(%esp)
  8002a2:	00 
  8002a3:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002aa:	00 
  8002ab:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  8002b2:	e8 6b 00 00 00       	call   800322 <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002bb:	eb b0                	jmp    80026d <umain+0x9b>

008002bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 10             	sub    $0x10,%esp
  8002c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8002cb:	e8 55 0b 00 00       	call   800e25 <sys_getenvid>
  8002d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d5:	89 c2                	mov    %eax,%edx
  8002d7:	c1 e2 07             	shl    $0x7,%edx
  8002da:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8002e1:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e6:	85 db                	test   %ebx,%ebx
  8002e8:	7e 07                	jle    8002f1 <libmain+0x34>
		binaryname = argv[0];
  8002ea:	8b 06                	mov    (%esi),%eax
  8002ec:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8002f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002f5:	89 1c 24             	mov    %ebx,(%esp)
  8002f8:	e8 d5 fe ff ff       	call   8001d2 <umain>

	// exit gracefully
	exit();
  8002fd:	e8 07 00 00 00       	call   800309 <exit>
}
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	5b                   	pop    %ebx
  800306:	5e                   	pop    %esi
  800307:	5d                   	pop    %ebp
  800308:	c3                   	ret    

00800309 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80030f:	e8 56 15 00 00       	call   80186a <close_all>
	sys_env_destroy(0);
  800314:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80031b:	e8 b3 0a 00 00       	call   800dd3 <sys_env_destroy>
}
  800320:	c9                   	leave  
  800321:	c3                   	ret    

00800322 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
  800327:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80032a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80032d:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800333:	e8 ed 0a 00 00       	call   800e25 <sys_getenvid>
  800338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80033b:	89 54 24 10          	mov    %edx,0x10(%esp)
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800346:	89 74 24 08          	mov    %esi,0x8(%esp)
  80034a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034e:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  800355:	e8 c1 00 00 00       	call   80041b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80035e:	8b 45 10             	mov    0x10(%ebp),%eax
  800361:	89 04 24             	mov    %eax,(%esp)
  800364:	e8 51 00 00 00       	call   8003ba <vcprintf>
	cprintf("\n");
  800369:	c7 04 24 23 2e 80 00 	movl   $0x802e23,(%esp)
  800370:	e8 a6 00 00 00       	call   80041b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800375:	cc                   	int3   
  800376:	eb fd                	jmp    800375 <_panic+0x53>

00800378 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	53                   	push   %ebx
  80037c:	83 ec 14             	sub    $0x14,%esp
  80037f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800382:	8b 13                	mov    (%ebx),%edx
  800384:	8d 42 01             	lea    0x1(%edx),%eax
  800387:	89 03                	mov    %eax,(%ebx)
  800389:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80038c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800390:	3d ff 00 00 00       	cmp    $0xff,%eax
  800395:	75 19                	jne    8003b0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800397:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80039e:	00 
  80039f:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a2:	89 04 24             	mov    %eax,(%esp)
  8003a5:	e8 ec 09 00 00       	call   800d96 <sys_cputs>
		b->idx = 0;
  8003aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003b0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b4:	83 c4 14             	add    $0x14,%esp
  8003b7:	5b                   	pop    %ebx
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003ba:	55                   	push   %ebp
  8003bb:	89 e5                	mov    %esp,%ebp
  8003bd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ca:	00 00 00 
	b.cnt = 0;
  8003cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ef:	c7 04 24 78 03 80 00 	movl   $0x800378,(%esp)
  8003f6:	e8 b3 01 00 00       	call   8005ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003fb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800401:	89 44 24 04          	mov    %eax,0x4(%esp)
  800405:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80040b:	89 04 24             	mov    %eax,(%esp)
  80040e:	e8 83 09 00 00       	call   800d96 <sys_cputs>

	return b.cnt;
}
  800413:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800419:	c9                   	leave  
  80041a:	c3                   	ret    

0080041b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800421:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800424:	89 44 24 04          	mov    %eax,0x4(%esp)
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	89 04 24             	mov    %eax,(%esp)
  80042e:	e8 87 ff ff ff       	call   8003ba <vcprintf>
	va_end(ap);

	return cnt;
}
  800433:	c9                   	leave  
  800434:	c3                   	ret    
  800435:	66 90                	xchg   %ax,%ax
  800437:	66 90                	xchg   %ax,%ax
  800439:	66 90                	xchg   %ax,%ax
  80043b:	66 90                	xchg   %ax,%ax
  80043d:	66 90                	xchg   %ax,%ax
  80043f:	90                   	nop

00800440 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	57                   	push   %edi
  800444:	56                   	push   %esi
  800445:	53                   	push   %ebx
  800446:	83 ec 3c             	sub    $0x3c,%esp
  800449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044c:	89 d7                	mov    %edx,%edi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800454:	8b 45 0c             	mov    0xc(%ebp),%eax
  800457:	89 c3                	mov    %eax,%ebx
  800459:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80045c:	8b 45 10             	mov    0x10(%ebp),%eax
  80045f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800462:	b9 00 00 00 00       	mov    $0x0,%ecx
  800467:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80046d:	39 d9                	cmp    %ebx,%ecx
  80046f:	72 05                	jb     800476 <printnum+0x36>
  800471:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800474:	77 69                	ja     8004df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800476:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800479:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80047d:	83 ee 01             	sub    $0x1,%esi
  800480:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800484:	89 44 24 08          	mov    %eax,0x8(%esp)
  800488:	8b 44 24 08          	mov    0x8(%esp),%eax
  80048c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800490:	89 c3                	mov    %eax,%ebx
  800492:	89 d6                	mov    %edx,%esi
  800494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800497:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80049a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80049e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a5:	89 04 24             	mov    %eax,(%esp)
  8004a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004af:	e8 8c 26 00 00       	call   802b40 <__udivdi3>
  8004b4:	89 d9                	mov    %ebx,%ecx
  8004b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004c5:	89 fa                	mov    %edi,%edx
  8004c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ca:	e8 71 ff ff ff       	call   800440 <printnum>
  8004cf:	eb 1b                	jmp    8004ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d8:	89 04 24             	mov    %eax,(%esp)
  8004db:	ff d3                	call   *%ebx
  8004dd:	eb 03                	jmp    8004e2 <printnum+0xa2>
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e2:	83 ee 01             	sub    $0x1,%esi
  8004e5:	85 f6                	test   %esi,%esi
  8004e7:	7f e8                	jg     8004d1 <printnum+0x91>
  8004e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 5c 27 00 00       	call   802c70 <__umoddi3>
  800514:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800518:	0f be 80 bf 2e 80 00 	movsbl 0x802ebf(%eax),%eax
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800525:	ff d0                	call   *%eax
}
  800527:	83 c4 3c             	add    $0x3c,%esp
  80052a:	5b                   	pop    %ebx
  80052b:	5e                   	pop    %esi
  80052c:	5f                   	pop    %edi
  80052d:	5d                   	pop    %ebp
  80052e:	c3                   	ret    

0080052f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800532:	83 fa 01             	cmp    $0x1,%edx
  800535:	7e 0e                	jle    800545 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800537:	8b 10                	mov    (%eax),%edx
  800539:	8d 4a 08             	lea    0x8(%edx),%ecx
  80053c:	89 08                	mov    %ecx,(%eax)
  80053e:	8b 02                	mov    (%edx),%eax
  800540:	8b 52 04             	mov    0x4(%edx),%edx
  800543:	eb 22                	jmp    800567 <getuint+0x38>
	else if (lflag)
  800545:	85 d2                	test   %edx,%edx
  800547:	74 10                	je     800559 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800549:	8b 10                	mov    (%eax),%edx
  80054b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80054e:	89 08                	mov    %ecx,(%eax)
  800550:	8b 02                	mov    (%edx),%eax
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
  800557:	eb 0e                	jmp    800567 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800559:	8b 10                	mov    (%eax),%edx
  80055b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80055e:	89 08                	mov    %ecx,(%eax)
  800560:	8b 02                	mov    (%edx),%eax
  800562:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800567:	5d                   	pop    %ebp
  800568:	c3                   	ret    

00800569 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80056f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800573:	8b 10                	mov    (%eax),%edx
  800575:	3b 50 04             	cmp    0x4(%eax),%edx
  800578:	73 0a                	jae    800584 <sprintputch+0x1b>
		*b->buf++ = ch;
  80057a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80057d:	89 08                	mov    %ecx,(%eax)
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	88 02                	mov    %al,(%edx)
}
  800584:	5d                   	pop    %ebp
  800585:	c3                   	ret    

00800586 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80058c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80058f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800593:	8b 45 10             	mov    0x10(%ebp),%eax
  800596:	89 44 24 08          	mov    %eax,0x8(%esp)
  80059a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 04 24             	mov    %eax,(%esp)
  8005a7:	e8 02 00 00 00       	call   8005ae <vprintfmt>
	va_end(ap);
}
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

008005ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	57                   	push   %edi
  8005b2:	56                   	push   %esi
  8005b3:	53                   	push   %ebx
  8005b4:	83 ec 3c             	sub    $0x3c,%esp
  8005b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005bd:	eb 14                	jmp    8005d3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005bf:	85 c0                	test   %eax,%eax
  8005c1:	0f 84 b3 03 00 00    	je     80097a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8005c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cb:	89 04 24             	mov    %eax,(%esp)
  8005ce:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d1:	89 f3                	mov    %esi,%ebx
  8005d3:	8d 73 01             	lea    0x1(%ebx),%esi
  8005d6:	0f b6 03             	movzbl (%ebx),%eax
  8005d9:	83 f8 25             	cmp    $0x25,%eax
  8005dc:	75 e1                	jne    8005bf <vprintfmt+0x11>
  8005de:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8005e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005e9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8005f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8005f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fc:	eb 1d                	jmp    80061b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800600:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800604:	eb 15                	jmp    80061b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800606:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800608:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80060c:	eb 0d                	jmp    80061b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80060e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800611:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800614:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80061e:	0f b6 0e             	movzbl (%esi),%ecx
  800621:	0f b6 c1             	movzbl %cl,%eax
  800624:	83 e9 23             	sub    $0x23,%ecx
  800627:	80 f9 55             	cmp    $0x55,%cl
  80062a:	0f 87 2a 03 00 00    	ja     80095a <vprintfmt+0x3ac>
  800630:	0f b6 c9             	movzbl %cl,%ecx
  800633:	ff 24 8d 40 30 80 00 	jmp    *0x803040(,%ecx,4)
  80063a:	89 de                	mov    %ebx,%esi
  80063c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800641:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800644:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800648:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80064b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80064e:	83 fb 09             	cmp    $0x9,%ebx
  800651:	77 36                	ja     800689 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800653:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800656:	eb e9                	jmp    800641 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 48 04             	lea    0x4(%eax),%ecx
  80065e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800661:	8b 00                	mov    (%eax),%eax
  800663:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800666:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800668:	eb 22                	jmp    80068c <vprintfmt+0xde>
  80066a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
  800674:	0f 49 c1             	cmovns %ecx,%eax
  800677:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	89 de                	mov    %ebx,%esi
  80067c:	eb 9d                	jmp    80061b <vprintfmt+0x6d>
  80067e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800680:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800687:	eb 92                	jmp    80061b <vprintfmt+0x6d>
  800689:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80068c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800690:	79 89                	jns    80061b <vprintfmt+0x6d>
  800692:	e9 77 ff ff ff       	jmp    80060e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800697:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80069c:	e9 7a ff ff ff       	jmp    80061b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 50 04             	lea    0x4(%eax),%edx
  8006a7:	89 55 14             	mov    %edx,0x14(%ebp)
  8006aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	89 04 24             	mov    %eax,(%esp)
  8006b3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006b6:	e9 18 ff ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 50 04             	lea    0x4(%eax),%edx
  8006c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	99                   	cltd   
  8006c7:	31 d0                	xor    %edx,%eax
  8006c9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006cb:	83 f8 12             	cmp    $0x12,%eax
  8006ce:	7f 0b                	jg     8006db <vprintfmt+0x12d>
  8006d0:	8b 14 85 a0 31 80 00 	mov    0x8031a0(,%eax,4),%edx
  8006d7:	85 d2                	test   %edx,%edx
  8006d9:	75 20                	jne    8006fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8006db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006df:	c7 44 24 08 d7 2e 80 	movl   $0x802ed7,0x8(%esp)
  8006e6:	00 
  8006e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 04 24             	mov    %eax,(%esp)
  8006f1:	e8 90 fe ff ff       	call   800586 <printfmt>
  8006f6:	e9 d8 fe ff ff       	jmp    8005d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8006fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006ff:	c7 44 24 08 d5 33 80 	movl   $0x8033d5,0x8(%esp)
  800706:	00 
  800707:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 04 24             	mov    %eax,(%esp)
  800711:	e8 70 fe ff ff       	call   800586 <printfmt>
  800716:	e9 b8 fe ff ff       	jmp    8005d3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80071e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800721:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 50 04             	lea    0x4(%eax),%edx
  80072a:	89 55 14             	mov    %edx,0x14(%ebp)
  80072d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80072f:	85 f6                	test   %esi,%esi
  800731:	b8 d0 2e 80 00       	mov    $0x802ed0,%eax
  800736:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800739:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80073d:	0f 84 97 00 00 00    	je     8007da <vprintfmt+0x22c>
  800743:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800747:	0f 8e 9b 00 00 00    	jle    8007e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80074d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800751:	89 34 24             	mov    %esi,(%esp)
  800754:	e8 cf 02 00 00       	call   800a28 <strnlen>
  800759:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075c:	29 c2                	sub    %eax,%edx
  80075e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800761:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800765:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800768:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80076b:	8b 75 08             	mov    0x8(%ebp),%esi
  80076e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800771:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800773:	eb 0f                	jmp    800784 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800775:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800779:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80077c:	89 04 24             	mov    %eax,(%esp)
  80077f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800781:	83 eb 01             	sub    $0x1,%ebx
  800784:	85 db                	test   %ebx,%ebx
  800786:	7f ed                	jg     800775 <vprintfmt+0x1c7>
  800788:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80078b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80078e:	85 d2                	test   %edx,%edx
  800790:	b8 00 00 00 00       	mov    $0x0,%eax
  800795:	0f 49 c2             	cmovns %edx,%eax
  800798:	29 c2                	sub    %eax,%edx
  80079a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80079d:	89 d7                	mov    %edx,%edi
  80079f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007a2:	eb 50                	jmp    8007f4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a8:	74 1e                	je     8007c8 <vprintfmt+0x21a>
  8007aa:	0f be d2             	movsbl %dl,%edx
  8007ad:	83 ea 20             	sub    $0x20,%edx
  8007b0:	83 fa 5e             	cmp    $0x5e,%edx
  8007b3:	76 13                	jbe    8007c8 <vprintfmt+0x21a>
					putch('?', putdat);
  8007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007c3:	ff 55 08             	call   *0x8(%ebp)
  8007c6:	eb 0d                	jmp    8007d5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8007c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007cf:	89 04 24             	mov    %eax,(%esp)
  8007d2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d5:	83 ef 01             	sub    $0x1,%edi
  8007d8:	eb 1a                	jmp    8007f4 <vprintfmt+0x246>
  8007da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007dd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007e0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007e6:	eb 0c                	jmp    8007f4 <vprintfmt+0x246>
  8007e8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007f4:	83 c6 01             	add    $0x1,%esi
  8007f7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8007fb:	0f be c2             	movsbl %dl,%eax
  8007fe:	85 c0                	test   %eax,%eax
  800800:	74 27                	je     800829 <vprintfmt+0x27b>
  800802:	85 db                	test   %ebx,%ebx
  800804:	78 9e                	js     8007a4 <vprintfmt+0x1f6>
  800806:	83 eb 01             	sub    $0x1,%ebx
  800809:	79 99                	jns    8007a4 <vprintfmt+0x1f6>
  80080b:	89 f8                	mov    %edi,%eax
  80080d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800810:	8b 75 08             	mov    0x8(%ebp),%esi
  800813:	89 c3                	mov    %eax,%ebx
  800815:	eb 1a                	jmp    800831 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800817:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800822:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800824:	83 eb 01             	sub    $0x1,%ebx
  800827:	eb 08                	jmp    800831 <vprintfmt+0x283>
  800829:	89 fb                	mov    %edi,%ebx
  80082b:	8b 75 08             	mov    0x8(%ebp),%esi
  80082e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800831:	85 db                	test   %ebx,%ebx
  800833:	7f e2                	jg     800817 <vprintfmt+0x269>
  800835:	89 75 08             	mov    %esi,0x8(%ebp)
  800838:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80083b:	e9 93 fd ff ff       	jmp    8005d3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800840:	83 fa 01             	cmp    $0x1,%edx
  800843:	7e 16                	jle    80085b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8d 50 08             	lea    0x8(%eax),%edx
  80084b:	89 55 14             	mov    %edx,0x14(%ebp)
  80084e:	8b 50 04             	mov    0x4(%eax),%edx
  800851:	8b 00                	mov    (%eax),%eax
  800853:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800856:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800859:	eb 32                	jmp    80088d <vprintfmt+0x2df>
	else if (lflag)
  80085b:	85 d2                	test   %edx,%edx
  80085d:	74 18                	je     800877 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8d 50 04             	lea    0x4(%eax),%edx
  800865:	89 55 14             	mov    %edx,0x14(%ebp)
  800868:	8b 30                	mov    (%eax),%esi
  80086a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80086d:	89 f0                	mov    %esi,%eax
  80086f:	c1 f8 1f             	sar    $0x1f,%eax
  800872:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800875:	eb 16                	jmp    80088d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8d 50 04             	lea    0x4(%eax),%edx
  80087d:	89 55 14             	mov    %edx,0x14(%ebp)
  800880:	8b 30                	mov    (%eax),%esi
  800882:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800885:	89 f0                	mov    %esi,%eax
  800887:	c1 f8 1f             	sar    $0x1f,%eax
  80088a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800890:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800893:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800898:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089c:	0f 89 80 00 00 00    	jns    800922 <vprintfmt+0x374>
				putch('-', putdat);
  8008a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008ad:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008b6:	f7 d8                	neg    %eax
  8008b8:	83 d2 00             	adc    $0x0,%edx
  8008bb:	f7 da                	neg    %edx
			}
			base = 10;
  8008bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008c2:	eb 5e                	jmp    800922 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c7:	e8 63 fc ff ff       	call   80052f <getuint>
			base = 10;
  8008cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8008d1:	eb 4f                	jmp    800922 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d6:	e8 54 fc ff ff       	call   80052f <getuint>
			base = 8;
  8008db:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8008e0:	eb 40                	jmp    800922 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8008e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8008f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8d 50 04             	lea    0x4(%eax),%edx
  800904:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800907:	8b 00                	mov    (%eax),%eax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80090e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800913:	eb 0d                	jmp    800922 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800915:	8d 45 14             	lea    0x14(%ebp),%eax
  800918:	e8 12 fc ff ff       	call   80052f <getuint>
			base = 16;
  80091d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800922:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800926:	89 74 24 10          	mov    %esi,0x10(%esp)
  80092a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80092d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800931:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800935:	89 04 24             	mov    %eax,(%esp)
  800938:	89 54 24 04          	mov    %edx,0x4(%esp)
  80093c:	89 fa                	mov    %edi,%edx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	e8 fa fa ff ff       	call   800440 <printnum>
			break;
  800946:	e9 88 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80094b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80094f:	89 04 24             	mov    %eax,(%esp)
  800952:	ff 55 08             	call   *0x8(%ebp)
			break;
  800955:	e9 79 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80095a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800965:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800968:	89 f3                	mov    %esi,%ebx
  80096a:	eb 03                	jmp    80096f <vprintfmt+0x3c1>
  80096c:	83 eb 01             	sub    $0x1,%ebx
  80096f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800973:	75 f7                	jne    80096c <vprintfmt+0x3be>
  800975:	e9 59 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80097a:	83 c4 3c             	add    $0x3c,%esp
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5f                   	pop    %edi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 28             	sub    $0x28,%esp
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800991:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800995:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099f:	85 c0                	test   %eax,%eax
  8009a1:	74 30                	je     8009d3 <vsnprintf+0x51>
  8009a3:	85 d2                	test   %edx,%edx
  8009a5:	7e 2c                	jle    8009d3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bc:	c7 04 24 69 05 80 00 	movl   $0x800569,(%esp)
  8009c3:	e8 e6 fb ff ff       	call   8005ae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d1:	eb 05                	jmp    8009d8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	89 04 24             	mov    %eax,(%esp)
  8009fb:	e8 82 ff ff ff       	call   800982 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    
  800a02:	66 90                	xchg   %ax,%ax
  800a04:	66 90                	xchg   %ax,%ax
  800a06:	66 90                	xchg   %ax,%ax
  800a08:	66 90                	xchg   %ax,%ax
  800a0a:	66 90                	xchg   %ax,%ax
  800a0c:	66 90                	xchg   %ax,%ax
  800a0e:	66 90                	xchg   %ax,%ax

00800a10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a16:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1b:	eb 03                	jmp    800a20 <strlen+0x10>
		n++;
  800a1d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a20:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a24:	75 f7                	jne    800a1d <strlen+0xd>
		n++;
	return n;
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a31:	b8 00 00 00 00       	mov    $0x0,%eax
  800a36:	eb 03                	jmp    800a3b <strnlen+0x13>
		n++;
  800a38:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3b:	39 d0                	cmp    %edx,%eax
  800a3d:	74 06                	je     800a45 <strnlen+0x1d>
  800a3f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a43:	75 f3                	jne    800a38 <strnlen+0x10>
		n++;
	return n;
}
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	53                   	push   %ebx
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a51:	89 c2                	mov    %eax,%edx
  800a53:	83 c2 01             	add    $0x1,%edx
  800a56:	83 c1 01             	add    $0x1,%ecx
  800a59:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a5d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a60:	84 db                	test   %bl,%bl
  800a62:	75 ef                	jne    800a53 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a64:	5b                   	pop    %ebx
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	53                   	push   %ebx
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a71:	89 1c 24             	mov    %ebx,(%esp)
  800a74:	e8 97 ff ff ff       	call   800a10 <strlen>
	strcpy(dst + len, src);
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a80:	01 d8                	add    %ebx,%eax
  800a82:	89 04 24             	mov    %eax,(%esp)
  800a85:	e8 bd ff ff ff       	call   800a47 <strcpy>
	return dst;
}
  800a8a:	89 d8                	mov    %ebx,%eax
  800a8c:	83 c4 08             	add    $0x8,%esp
  800a8f:	5b                   	pop    %ebx
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9d:	89 f3                	mov    %esi,%ebx
  800a9f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa2:	89 f2                	mov    %esi,%edx
  800aa4:	eb 0f                	jmp    800ab5 <strncpy+0x23>
		*dst++ = *src;
  800aa6:	83 c2 01             	add    $0x1,%edx
  800aa9:	0f b6 01             	movzbl (%ecx),%eax
  800aac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aaf:	80 39 01             	cmpb   $0x1,(%ecx)
  800ab2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab5:	39 da                	cmp    %ebx,%edx
  800ab7:	75 ed                	jne    800aa6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ab9:	89 f0                	mov    %esi,%eax
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	56                   	push   %esi
  800ac3:	53                   	push   %ebx
  800ac4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800acd:	89 f0                	mov    %esi,%eax
  800acf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad3:	85 c9                	test   %ecx,%ecx
  800ad5:	75 0b                	jne    800ae2 <strlcpy+0x23>
  800ad7:	eb 1d                	jmp    800af6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad9:	83 c0 01             	add    $0x1,%eax
  800adc:	83 c2 01             	add    $0x1,%edx
  800adf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae2:	39 d8                	cmp    %ebx,%eax
  800ae4:	74 0b                	je     800af1 <strlcpy+0x32>
  800ae6:	0f b6 0a             	movzbl (%edx),%ecx
  800ae9:	84 c9                	test   %cl,%cl
  800aeb:	75 ec                	jne    800ad9 <strlcpy+0x1a>
  800aed:	89 c2                	mov    %eax,%edx
  800aef:	eb 02                	jmp    800af3 <strlcpy+0x34>
  800af1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800af3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800af6:	29 f0                	sub    %esi,%eax
}
  800af8:	5b                   	pop    %ebx
  800af9:	5e                   	pop    %esi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b05:	eb 06                	jmp    800b0d <strcmp+0x11>
		p++, q++;
  800b07:	83 c1 01             	add    $0x1,%ecx
  800b0a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b0d:	0f b6 01             	movzbl (%ecx),%eax
  800b10:	84 c0                	test   %al,%al
  800b12:	74 04                	je     800b18 <strcmp+0x1c>
  800b14:	3a 02                	cmp    (%edx),%al
  800b16:	74 ef                	je     800b07 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b18:	0f b6 c0             	movzbl %al,%eax
  800b1b:	0f b6 12             	movzbl (%edx),%edx
  800b1e:	29 d0                	sub    %edx,%eax
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 c3                	mov    %eax,%ebx
  800b2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b31:	eb 06                	jmp    800b39 <strncmp+0x17>
		n--, p++, q++;
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b39:	39 d8                	cmp    %ebx,%eax
  800b3b:	74 15                	je     800b52 <strncmp+0x30>
  800b3d:	0f b6 08             	movzbl (%eax),%ecx
  800b40:	84 c9                	test   %cl,%cl
  800b42:	74 04                	je     800b48 <strncmp+0x26>
  800b44:	3a 0a                	cmp    (%edx),%cl
  800b46:	74 eb                	je     800b33 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b48:	0f b6 00             	movzbl (%eax),%eax
  800b4b:	0f b6 12             	movzbl (%edx),%edx
  800b4e:	29 d0                	sub    %edx,%eax
  800b50:	eb 05                	jmp    800b57 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b64:	eb 07                	jmp    800b6d <strchr+0x13>
		if (*s == c)
  800b66:	38 ca                	cmp    %cl,%dl
  800b68:	74 0f                	je     800b79 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b6a:	83 c0 01             	add    $0x1,%eax
  800b6d:	0f b6 10             	movzbl (%eax),%edx
  800b70:	84 d2                	test   %dl,%dl
  800b72:	75 f2                	jne    800b66 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b85:	eb 07                	jmp    800b8e <strfind+0x13>
		if (*s == c)
  800b87:	38 ca                	cmp    %cl,%dl
  800b89:	74 0a                	je     800b95 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b8b:	83 c0 01             	add    $0x1,%eax
  800b8e:	0f b6 10             	movzbl (%eax),%edx
  800b91:	84 d2                	test   %dl,%dl
  800b93:	75 f2                	jne    800b87 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba3:	85 c9                	test   %ecx,%ecx
  800ba5:	74 36                	je     800bdd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bad:	75 28                	jne    800bd7 <memset+0x40>
  800baf:	f6 c1 03             	test   $0x3,%cl
  800bb2:	75 23                	jne    800bd7 <memset+0x40>
		c &= 0xFF;
  800bb4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb8:	89 d3                	mov    %edx,%ebx
  800bba:	c1 e3 08             	shl    $0x8,%ebx
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	c1 e6 18             	shl    $0x18,%esi
  800bc2:	89 d0                	mov    %edx,%eax
  800bc4:	c1 e0 10             	shl    $0x10,%eax
  800bc7:	09 f0                	or     %esi,%eax
  800bc9:	09 c2                	or     %eax,%edx
  800bcb:	89 d0                	mov    %edx,%eax
  800bcd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bcf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800bd2:	fc                   	cld    
  800bd3:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd5:	eb 06                	jmp    800bdd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	fc                   	cld    
  800bdb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bdd:	89 f8                	mov    %edi,%eax
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf2:	39 c6                	cmp    %eax,%esi
  800bf4:	73 35                	jae    800c2b <memmove+0x47>
  800bf6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf9:	39 d0                	cmp    %edx,%eax
  800bfb:	73 2e                	jae    800c2b <memmove+0x47>
		s += n;
		d += n;
  800bfd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c00:	89 d6                	mov    %edx,%esi
  800c02:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0a:	75 13                	jne    800c1f <memmove+0x3b>
  800c0c:	f6 c1 03             	test   $0x3,%cl
  800c0f:	75 0e                	jne    800c1f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c11:	83 ef 04             	sub    $0x4,%edi
  800c14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c1a:	fd                   	std    
  800c1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1d:	eb 09                	jmp    800c28 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c1f:	83 ef 01             	sub    $0x1,%edi
  800c22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c25:	fd                   	std    
  800c26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c28:	fc                   	cld    
  800c29:	eb 1d                	jmp    800c48 <memmove+0x64>
  800c2b:	89 f2                	mov    %esi,%edx
  800c2d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2f:	f6 c2 03             	test   $0x3,%dl
  800c32:	75 0f                	jne    800c43 <memmove+0x5f>
  800c34:	f6 c1 03             	test   $0x3,%cl
  800c37:	75 0a                	jne    800c43 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c39:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c3c:	89 c7                	mov    %eax,%edi
  800c3e:	fc                   	cld    
  800c3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c41:	eb 05                	jmp    800c48 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c43:	89 c7                	mov    %eax,%edi
  800c45:	fc                   	cld    
  800c46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 04 24             	mov    %eax,(%esp)
  800c66:	e8 79 ff ff ff       	call   800be4 <memmove>
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	89 d6                	mov    %edx,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7d:	eb 1a                	jmp    800c99 <memcmp+0x2c>
		if (*s1 != *s2)
  800c7f:	0f b6 02             	movzbl (%edx),%eax
  800c82:	0f b6 19             	movzbl (%ecx),%ebx
  800c85:	38 d8                	cmp    %bl,%al
  800c87:	74 0a                	je     800c93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c89:	0f b6 c0             	movzbl %al,%eax
  800c8c:	0f b6 db             	movzbl %bl,%ebx
  800c8f:	29 d8                	sub    %ebx,%eax
  800c91:	eb 0f                	jmp    800ca2 <memcmp+0x35>
		s1++, s2++;
  800c93:	83 c2 01             	add    $0x1,%edx
  800c96:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c99:	39 f2                	cmp    %esi,%edx
  800c9b:	75 e2                	jne    800c7f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	eb 07                	jmp    800cbd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb6:	38 08                	cmp    %cl,(%eax)
  800cb8:	74 07                	je     800cc1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	39 d0                	cmp    %edx,%eax
  800cbf:	72 f5                	jb     800cb6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccf:	eb 03                	jmp    800cd4 <strtol+0x11>
		s++;
  800cd1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd4:	0f b6 0a             	movzbl (%edx),%ecx
  800cd7:	80 f9 09             	cmp    $0x9,%cl
  800cda:	74 f5                	je     800cd1 <strtol+0xe>
  800cdc:	80 f9 20             	cmp    $0x20,%cl
  800cdf:	74 f0                	je     800cd1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ce1:	80 f9 2b             	cmp    $0x2b,%cl
  800ce4:	75 0a                	jne    800cf0 <strtol+0x2d>
		s++;
  800ce6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cee:	eb 11                	jmp    800d01 <strtol+0x3e>
  800cf0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800cf5:	80 f9 2d             	cmp    $0x2d,%cl
  800cf8:	75 07                	jne    800d01 <strtol+0x3e>
		s++, neg = 1;
  800cfa:	8d 52 01             	lea    0x1(%edx),%edx
  800cfd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d01:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d06:	75 15                	jne    800d1d <strtol+0x5a>
  800d08:	80 3a 30             	cmpb   $0x30,(%edx)
  800d0b:	75 10                	jne    800d1d <strtol+0x5a>
  800d0d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d11:	75 0a                	jne    800d1d <strtol+0x5a>
		s += 2, base = 16;
  800d13:	83 c2 02             	add    $0x2,%edx
  800d16:	b8 10 00 00 00       	mov    $0x10,%eax
  800d1b:	eb 10                	jmp    800d2d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	75 0c                	jne    800d2d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d21:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d23:	80 3a 30             	cmpb   $0x30,(%edx)
  800d26:	75 05                	jne    800d2d <strtol+0x6a>
		s++, base = 8;
  800d28:	83 c2 01             	add    $0x1,%edx
  800d2b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d32:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d35:	0f b6 0a             	movzbl (%edx),%ecx
  800d38:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d3b:	89 f0                	mov    %esi,%eax
  800d3d:	3c 09                	cmp    $0x9,%al
  800d3f:	77 08                	ja     800d49 <strtol+0x86>
			dig = *s - '0';
  800d41:	0f be c9             	movsbl %cl,%ecx
  800d44:	83 e9 30             	sub    $0x30,%ecx
  800d47:	eb 20                	jmp    800d69 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800d49:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d4c:	89 f0                	mov    %esi,%eax
  800d4e:	3c 19                	cmp    $0x19,%al
  800d50:	77 08                	ja     800d5a <strtol+0x97>
			dig = *s - 'a' + 10;
  800d52:	0f be c9             	movsbl %cl,%ecx
  800d55:	83 e9 57             	sub    $0x57,%ecx
  800d58:	eb 0f                	jmp    800d69 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800d5a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800d5d:	89 f0                	mov    %esi,%eax
  800d5f:	3c 19                	cmp    $0x19,%al
  800d61:	77 16                	ja     800d79 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800d63:	0f be c9             	movsbl %cl,%ecx
  800d66:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d69:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d6c:	7d 0f                	jge    800d7d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800d6e:	83 c2 01             	add    $0x1,%edx
  800d71:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d75:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d77:	eb bc                	jmp    800d35 <strtol+0x72>
  800d79:	89 d8                	mov    %ebx,%eax
  800d7b:	eb 02                	jmp    800d7f <strtol+0xbc>
  800d7d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d83:	74 05                	je     800d8a <strtol+0xc7>
		*endptr = (char *) s;
  800d85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d88:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d8a:	f7 d8                	neg    %eax
  800d8c:	85 ff                	test   %edi,%edi
  800d8e:	0f 44 c3             	cmove  %ebx,%eax
}
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	89 c3                	mov    %eax,%ebx
  800da9:	89 c7                	mov    %eax,%edi
  800dab:	89 c6                	mov    %eax,%esi
  800dad:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dba:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800dc4:	89 d1                	mov    %edx,%ecx
  800dc6:	89 d3                	mov    %edx,%ebx
  800dc8:	89 d7                	mov    %edx,%edi
  800dca:	89 d6                	mov    %edx,%esi
  800dcc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de1:	b8 03 00 00 00       	mov    $0x3,%eax
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	89 cb                	mov    %ecx,%ebx
  800deb:	89 cf                	mov    %ecx,%edi
  800ded:	89 ce                	mov    %ecx,%esi
  800def:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7e 28                	jle    800e1d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e00:	00 
  800e01:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  800e08:	00 
  800e09:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e10:	00 
  800e11:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  800e18:	e8 05 f5 ff ff       	call   800322 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e1d:	83 c4 2c             	add    $0x2c,%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    

00800e25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e30:	b8 02 00 00 00       	mov    $0x2,%eax
  800e35:	89 d1                	mov    %edx,%ecx
  800e37:	89 d3                	mov    %edx,%ebx
  800e39:	89 d7                	mov    %edx,%edi
  800e3b:	89 d6                	mov    %edx,%esi
  800e3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    

00800e44 <sys_yield>:

void
sys_yield(void)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e54:	89 d1                	mov    %edx,%ecx
  800e56:	89 d3                	mov    %edx,%ebx
  800e58:	89 d7                	mov    %edx,%edi
  800e5a:	89 d6                	mov    %edx,%esi
  800e5c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6c:	be 00 00 00 00       	mov    $0x0,%esi
  800e71:	b8 04 00 00 00       	mov    $0x4,%eax
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7f:	89 f7                	mov    %esi,%edi
  800e81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7e 28                	jle    800eaf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e92:	00 
  800e93:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  800e9a:	00 
  800e9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea2:	00 
  800ea3:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  800eaa:	e8 73 f4 ff ff       	call   800322 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eaf:	83 c4 2c             	add    $0x2c,%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ece:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed1:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	7e 28                	jle    800f02 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ede:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ee5:	00 
  800ee6:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  800eed:	00 
  800eee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef5:	00 
  800ef6:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  800efd:	e8 20 f4 ff ff       	call   800322 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f02:	83 c4 2c             	add    $0x2c,%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800f18:	b8 06 00 00 00       	mov    $0x6,%eax
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
  800f2b:	7e 28                	jle    800f55 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  800f50:	e8 cd f3 ff ff       	call   800322 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f55:	83 c4 2c             	add    $0x2c,%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800f6b:	b8 08 00 00 00       	mov    $0x8,%eax
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
  800f7e:	7e 28                	jle    800fa8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  800fa3:	e8 7a f3 ff ff       	call   800322 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fa8:	83 c4 2c             	add    $0x2c,%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800fbe:	b8 09 00 00 00       	mov    $0x9,%eax
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
  800fd1:	7e 28                	jle    800ffb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fde:	00 
  800fdf:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  800fe6:	00 
  800fe7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fee:	00 
  800fef:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  800ff6:	e8 27 f3 ff ff       	call   800322 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ffb:	83 c4 2c             	add    $0x2c,%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  80100c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801011:	b8 0a 00 00 00       	mov    $0xa,%eax
  801016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	89 df                	mov    %ebx,%edi
  80101e:	89 de                	mov    %ebx,%esi
  801020:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801022:	85 c0                	test   %eax,%eax
  801024:	7e 28                	jle    80104e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801026:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801031:	00 
  801032:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  801039:	00 
  80103a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801041:	00 
  801042:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  801049:	e8 d4 f2 ff ff       	call   800322 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80104e:	83 c4 2c             	add    $0x2c,%esp
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5f                   	pop    %edi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	57                   	push   %edi
  80105a:	56                   	push   %esi
  80105b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105c:	be 00 00 00 00       	mov    $0x0,%esi
  801061:	b8 0c 00 00 00       	mov    $0xc,%eax
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801072:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    

00801079 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	57                   	push   %edi
  80107d:	56                   	push   %esi
  80107e:	53                   	push   %ebx
  80107f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801082:	b9 00 00 00 00       	mov    $0x0,%ecx
  801087:	b8 0d 00 00 00       	mov    $0xd,%eax
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	89 cb                	mov    %ecx,%ebx
  801091:	89 cf                	mov    %ecx,%edi
  801093:	89 ce                	mov    %ecx,%esi
  801095:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801097:	85 c0                	test   %eax,%eax
  801099:	7e 28                	jle    8010c3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80109b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010a6:	00 
  8010a7:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  8010ae:	00 
  8010af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b6:	00 
  8010b7:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  8010be:	e8 5f f2 ff ff       	call   800322 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010c3:	83 c4 2c             	add    $0x2c,%esp
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010db:	89 d1                	mov    %edx,%ecx
  8010dd:	89 d3                	mov    %edx,%ebx
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	89 d6                	mov    %edx,%esi
  8010e3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	89 df                	mov    %ebx,%edi
  801105:	89 de                	mov    %ebx,%esi
  801107:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801109:	85 c0                	test   %eax,%eax
  80110b:	7e 28                	jle    801135 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801111:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801118:	00 
  801119:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  801120:	00 
  801121:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801128:	00 
  801129:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  801130:	e8 ed f1 ff ff       	call   800322 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801135:	83 c4 2c             	add    $0x2c,%esp
  801138:	5b                   	pop    %ebx
  801139:	5e                   	pop    %esi
  80113a:	5f                   	pop    %edi
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	57                   	push   %edi
  801141:	56                   	push   %esi
  801142:	53                   	push   %ebx
  801143:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801146:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114b:	b8 10 00 00 00       	mov    $0x10,%eax
  801150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	89 df                	mov    %ebx,%edi
  801158:	89 de                	mov    %ebx,%esi
  80115a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	7e 28                	jle    801188 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801160:	89 44 24 10          	mov    %eax,0x10(%esp)
  801164:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80116b:	00 
  80116c:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  801173:	00 
  801174:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80117b:	00 
  80117c:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  801183:	e8 9a f1 ff ff       	call   800322 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801188:	83 c4 2c             	add    $0x2c,%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	57                   	push   %edi
  801194:	56                   	push   %esi
  801195:	53                   	push   %ebx
  801196:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801199:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119e:	b8 11 00 00 00       	mov    $0x11,%eax
  8011a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a9:	89 df                	mov    %ebx,%edi
  8011ab:	89 de                	mov    %ebx,%esi
  8011ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	7e 28                	jle    8011db <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8011be:	00 
  8011bf:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  8011c6:	00 
  8011c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ce:	00 
  8011cf:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  8011d6:	e8 47 f1 ff ff       	call   800322 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8011db:	83 c4 2c             	add    $0x2c,%esp
  8011de:	5b                   	pop    %ebx
  8011df:	5e                   	pop    %esi
  8011e0:	5f                   	pop    %edi
  8011e1:	5d                   	pop    %ebp
  8011e2:	c3                   	ret    

008011e3 <sys_sleep>:

int
sys_sleep(int channel)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	57                   	push   %edi
  8011e7:	56                   	push   %esi
  8011e8:	53                   	push   %ebx
  8011e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011f1:	b8 12 00 00 00       	mov    $0x12,%eax
  8011f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f9:	89 cb                	mov    %ecx,%ebx
  8011fb:	89 cf                	mov    %ecx,%edi
  8011fd:	89 ce                	mov    %ecx,%esi
  8011ff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801201:	85 c0                	test   %eax,%eax
  801203:	7e 28                	jle    80122d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801205:	89 44 24 10          	mov    %eax,0x10(%esp)
  801209:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801210:	00 
  801211:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  801218:	00 
  801219:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801220:	00 
  801221:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  801228:	e8 f5 f0 ff ff       	call   800322 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80122d:	83 c4 2c             	add    $0x2c,%esp
  801230:	5b                   	pop    %ebx
  801231:	5e                   	pop    %esi
  801232:	5f                   	pop    %edi
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    

00801235 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	57                   	push   %edi
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801243:	b8 13 00 00 00       	mov    $0x13,%eax
  801248:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124b:	8b 55 08             	mov    0x8(%ebp),%edx
  80124e:	89 df                	mov    %ebx,%edi
  801250:	89 de                	mov    %ebx,%esi
  801252:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801254:	85 c0                	test   %eax,%eax
  801256:	7e 28                	jle    801280 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801258:	89 44 24 10          	mov    %eax,0x10(%esp)
  80125c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801263:	00 
  801264:	c7 44 24 08 0b 32 80 	movl   $0x80320b,0x8(%esp)
  80126b:	00 
  80126c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801273:	00 
  801274:	c7 04 24 28 32 80 00 	movl   $0x803228,(%esp)
  80127b:	e8 a2 f0 ff ff       	call   800322 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801280:	83 c4 2c             	add    $0x2c,%esp
  801283:	5b                   	pop    %ebx
  801284:	5e                   	pop    %esi
  801285:	5f                   	pop    %edi
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    

00801288 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	53                   	push   %ebx
  80128c:	83 ec 24             	sub    $0x24,%esp
  80128f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801292:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801294:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801298:	74 27                	je     8012c1 <pgfault+0x39>
  80129a:	89 c2                	mov    %eax,%edx
  80129c:	c1 ea 16             	shr    $0x16,%edx
  80129f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012a6:	f6 c2 01             	test   $0x1,%dl
  8012a9:	74 16                	je     8012c1 <pgfault+0x39>
  8012ab:	89 c2                	mov    %eax,%edx
  8012ad:	c1 ea 0c             	shr    $0xc,%edx
  8012b0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012b7:	f7 d2                	not    %edx
  8012b9:	f7 c2 01 08 00 00    	test   $0x801,%edx
  8012bf:	74 1c                	je     8012dd <pgfault+0x55>
		panic("pgfault");
  8012c1:	c7 44 24 08 36 32 80 	movl   $0x803236,0x8(%esp)
  8012c8:	00 
  8012c9:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8012d0:	00 
  8012d1:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  8012d8:	e8 45 f0 ff ff       	call   800322 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  8012dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012e2:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  8012e4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012eb:	00 
  8012ec:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012f3:	00 
  8012f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012fb:	e8 63 fb ff ff       	call   800e63 <sys_page_alloc>
  801300:	85 c0                	test   %eax,%eax
  801302:	79 1c                	jns    801320 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801304:	c7 44 24 08 49 32 80 	movl   $0x803249,0x8(%esp)
  80130b:	00 
  80130c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801313:	00 
  801314:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  80131b:	e8 02 f0 ff ff       	call   800322 <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801320:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801327:	00 
  801328:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80132c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801333:	e8 14 f9 ff ff       	call   800c4c <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801338:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80133f:	00 
  801340:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801344:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80134b:	00 
  80134c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801353:	00 
  801354:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80135b:	e8 57 fb ff ff       	call   800eb7 <sys_page_map>
  801360:	85 c0                	test   %eax,%eax
  801362:	79 1c                	jns    801380 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  801364:	c7 44 24 08 63 32 80 	movl   $0x803263,0x8(%esp)
  80136b:	00 
  80136c:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801373:	00 
  801374:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  80137b:	e8 a2 ef ff ff       	call   800322 <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801380:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801387:	00 
  801388:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80138f:	e8 76 fb ff ff       	call   800f0a <sys_page_unmap>
  801394:	85 c0                	test   %eax,%eax
  801396:	79 1c                	jns    8013b4 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801398:	c7 44 24 08 7b 32 80 	movl   $0x80327b,0x8(%esp)
  80139f:	00 
  8013a0:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8013a7:	00 
  8013a8:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  8013af:	e8 6e ef ff ff       	call   800322 <_panic>
	}
}
  8013b4:	83 c4 24             	add    $0x24,%esp
  8013b7:	5b                   	pop    %ebx
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	57                   	push   %edi
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
  8013c0:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  8013c3:	c7 04 24 88 12 80 00 	movl   $0x801288,(%esp)
  8013ca:	e8 77 15 00 00       	call   802946 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8013cf:	b8 07 00 00 00       	mov    $0x7,%eax
  8013d4:	cd 30                	int    $0x30
  8013d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	79 1c                	jns    8013f9 <fork+0x3f>
		panic("fork(): sys_exofork");
  8013dd:	c7 44 24 08 95 32 80 	movl   $0x803295,0x8(%esp)
  8013e4:	00 
  8013e5:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8013ec:	00 
  8013ed:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  8013f4:	e8 29 ef ff ff       	call   800322 <_panic>
  8013f9:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  8013fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013ff:	74 0a                	je     80140b <fork+0x51>
  801401:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801406:	e9 9d 01 00 00       	jmp    8015a8 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80140b:	e8 15 fa ff ff       	call   800e25 <sys_getenvid>
  801410:	25 ff 03 00 00       	and    $0x3ff,%eax
  801415:	89 c2                	mov    %eax,%edx
  801417:	c1 e2 07             	shl    $0x7,%edx
  80141a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801421:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  801426:	e9 2a 02 00 00       	jmp    801655 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80142b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801431:	0f 84 6b 01 00 00    	je     8015a2 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801437:	89 d8                	mov    %ebx,%eax
  801439:	c1 e8 16             	shr    $0x16,%eax
  80143c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801443:	a8 01                	test   $0x1,%al
  801445:	0f 84 57 01 00 00    	je     8015a2 <fork+0x1e8>
  80144b:	89 d8                	mov    %ebx,%eax
  80144d:	c1 e8 0c             	shr    $0xc,%eax
  801450:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801457:	f7 d0                	not    %eax
  801459:	a8 05                	test   $0x5,%al
  80145b:	0f 85 41 01 00 00    	jne    8015a2 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  801461:	89 d8                	mov    %ebx,%eax
  801463:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  801466:	89 c6                	mov    %eax,%esi
  801468:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  80146b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801472:	f6 c6 04             	test   $0x4,%dh
  801475:	74 4c                	je     8014c3 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  801477:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80147e:	25 07 0e 00 00       	and    $0xe07,%eax
  801483:	89 44 24 10          	mov    %eax,0x10(%esp)
  801487:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80148b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80148f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801493:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80149a:	e8 18 fa ff ff       	call   800eb7 <sys_page_map>
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	0f 89 fb 00 00 00    	jns    8015a2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8014a7:	c7 44 24 08 a9 32 80 	movl   $0x8032a9,0x8(%esp)
  8014ae:	00 
  8014af:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8014b6:	00 
  8014b7:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  8014be:	e8 5f ee ff ff       	call   800322 <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  8014c3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014ca:	f6 c6 08             	test   $0x8,%dh
  8014cd:	75 0f                	jne    8014de <fork+0x124>
  8014cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d6:	a8 02                	test   $0x2,%al
  8014d8:	0f 84 84 00 00 00    	je     801562 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  8014de:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8014e5:	00 
  8014e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f9:	e8 b9 f9 ff ff       	call   800eb7 <sys_page_map>
  8014fe:	85 c0                	test   %eax,%eax
  801500:	79 1c                	jns    80151e <fork+0x164>
			panic("duppage: sys_page_map");
  801502:	c7 44 24 08 a9 32 80 	movl   $0x8032a9,0x8(%esp)
  801509:	00 
  80150a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801511:	00 
  801512:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  801519:	e8 04 ee ff ff       	call   800322 <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80151e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801525:	00 
  801526:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80152a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801531:	00 
  801532:	89 74 24 04          	mov    %esi,0x4(%esp)
  801536:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80153d:	e8 75 f9 ff ff       	call   800eb7 <sys_page_map>
  801542:	85 c0                	test   %eax,%eax
  801544:	79 5c                	jns    8015a2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801546:	c7 44 24 08 a9 32 80 	movl   $0x8032a9,0x8(%esp)
  80154d:	00 
  80154e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  801555:	00 
  801556:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  80155d:	e8 c0 ed ff ff       	call   800322 <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  801562:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801569:	00 
  80156a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80156e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801572:	89 74 24 04          	mov    %esi,0x4(%esp)
  801576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157d:	e8 35 f9 ff ff       	call   800eb7 <sys_page_map>
  801582:	85 c0                	test   %eax,%eax
  801584:	79 1c                	jns    8015a2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801586:	c7 44 24 08 a9 32 80 	movl   $0x8032a9,0x8(%esp)
  80158d:	00 
  80158e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801595:	00 
  801596:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  80159d:	e8 80 ed ff ff       	call   800322 <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  8015a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015a8:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8015ae:	0f 85 77 fe ff ff    	jne    80142b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  8015b4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015bb:	00 
  8015bc:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015c3:	ee 
  8015c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015c7:	89 04 24             	mov    %eax,(%esp)
  8015ca:	e8 94 f8 ff ff       	call   800e63 <sys_page_alloc>
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	79 1c                	jns    8015ef <fork+0x235>
		panic("fork(): sys_page_alloc");
  8015d3:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  8015da:	00 
  8015db:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8015e2:	00 
  8015e3:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  8015ea:	e8 33 ed ff ff       	call   800322 <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  8015ef:	c7 44 24 04 cf 29 80 	movl   $0x8029cf,0x4(%esp)
  8015f6:	00 
  8015f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fa:	89 04 24             	mov    %eax,(%esp)
  8015fd:	e8 01 fa ff ff       	call   801003 <sys_env_set_pgfault_upcall>
  801602:	85 c0                	test   %eax,%eax
  801604:	79 1c                	jns    801622 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801606:	c7 44 24 08 08 33 80 	movl   $0x803308,0x8(%esp)
  80160d:	00 
  80160e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801615:	00 
  801616:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  80161d:	e8 00 ed ff ff       	call   800322 <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801622:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801629:	00 
  80162a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162d:	89 04 24             	mov    %eax,(%esp)
  801630:	e8 28 f9 ff ff       	call   800f5d <sys_env_set_status>
  801635:	85 c0                	test   %eax,%eax
  801637:	79 1c                	jns    801655 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801639:	c7 44 24 08 d6 32 80 	movl   $0x8032d6,0x8(%esp)
  801640:	00 
  801641:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801648:	00 
  801649:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  801650:	e8 cd ec ff ff       	call   800322 <_panic>
	}

	return env_id;
}
  801655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801658:	83 c4 2c             	add    $0x2c,%esp
  80165b:	5b                   	pop    %ebx
  80165c:	5e                   	pop    %esi
  80165d:	5f                   	pop    %edi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <sfork>:

// Challenge!
int
sfork(void)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801666:	c7 44 24 08 f1 32 80 	movl   $0x8032f1,0x8(%esp)
  80166d:	00 
  80166e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  801675:	00 
  801676:	c7 04 24 3e 32 80 00 	movl   $0x80323e,(%esp)
  80167d:	e8 a0 ec ff ff       	call   800322 <_panic>
  801682:	66 90                	xchg   %ax,%ax
  801684:	66 90                	xchg   %ax,%ax
  801686:	66 90                	xchg   %ax,%ax
  801688:	66 90                	xchg   %ax,%ax
  80168a:	66 90                	xchg   %ax,%ax
  80168c:	66 90                	xchg   %ax,%ax
  80168e:	66 90                	xchg   %ax,%ax

00801690 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	05 00 00 00 30       	add    $0x30000000,%eax
  80169b:	c1 e8 0c             	shr    $0xc,%eax
}
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    

008016a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8016ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016b5:	5d                   	pop    %ebp
  8016b6:	c3                   	ret    

008016b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016c2:	89 c2                	mov    %eax,%edx
  8016c4:	c1 ea 16             	shr    $0x16,%edx
  8016c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ce:	f6 c2 01             	test   $0x1,%dl
  8016d1:	74 11                	je     8016e4 <fd_alloc+0x2d>
  8016d3:	89 c2                	mov    %eax,%edx
  8016d5:	c1 ea 0c             	shr    $0xc,%edx
  8016d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016df:	f6 c2 01             	test   $0x1,%dl
  8016e2:	75 09                	jne    8016ed <fd_alloc+0x36>
			*fd_store = fd;
  8016e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	eb 17                	jmp    801704 <fd_alloc+0x4d>
  8016ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8016f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016f7:	75 c9                	jne    8016c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8016ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    

00801706 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80170c:	83 f8 1f             	cmp    $0x1f,%eax
  80170f:	77 36                	ja     801747 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801711:	c1 e0 0c             	shl    $0xc,%eax
  801714:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801719:	89 c2                	mov    %eax,%edx
  80171b:	c1 ea 16             	shr    $0x16,%edx
  80171e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801725:	f6 c2 01             	test   $0x1,%dl
  801728:	74 24                	je     80174e <fd_lookup+0x48>
  80172a:	89 c2                	mov    %eax,%edx
  80172c:	c1 ea 0c             	shr    $0xc,%edx
  80172f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801736:	f6 c2 01             	test   $0x1,%dl
  801739:	74 1a                	je     801755 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80173b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173e:	89 02                	mov    %eax,(%edx)
	return 0;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
  801745:	eb 13                	jmp    80175a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801747:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174c:	eb 0c                	jmp    80175a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80174e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801753:	eb 05                	jmp    80175a <fd_lookup+0x54>
  801755:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 18             	sub    $0x18,%esp
  801762:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801765:	ba 00 00 00 00       	mov    $0x0,%edx
  80176a:	eb 13                	jmp    80177f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80176c:	39 08                	cmp    %ecx,(%eax)
  80176e:	75 0c                	jne    80177c <dev_lookup+0x20>
			*dev = devtab[i];
  801770:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801773:	89 01                	mov    %eax,(%ecx)
			return 0;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	eb 38                	jmp    8017b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80177c:	83 c2 01             	add    $0x1,%edx
  80177f:	8b 04 95 a8 33 80 00 	mov    0x8033a8(,%edx,4),%eax
  801786:	85 c0                	test   %eax,%eax
  801788:	75 e2                	jne    80176c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80178a:	a1 08 50 80 00       	mov    0x805008,%eax
  80178f:	8b 40 48             	mov    0x48(%eax),%eax
  801792:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801796:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179a:	c7 04 24 2c 33 80 00 	movl   $0x80332c,(%esp)
  8017a1:	e8 75 ec ff ff       	call   80041b <cprintf>
	*dev = 0;
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 20             	sub    $0x20,%esp
  8017be:	8b 75 08             	mov    0x8(%ebp),%esi
  8017c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017d4:	89 04 24             	mov    %eax,(%esp)
  8017d7:	e8 2a ff ff ff       	call   801706 <fd_lookup>
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 05                	js     8017e5 <fd_close+0x2f>
	    || fd != fd2)
  8017e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8017e3:	74 0c                	je     8017f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8017e5:	84 db                	test   %bl,%bl
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ec:	0f 44 c2             	cmove  %edx,%eax
  8017ef:	eb 3f                	jmp    801830 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f8:	8b 06                	mov    (%esi),%eax
  8017fa:	89 04 24             	mov    %eax,(%esp)
  8017fd:	e8 5a ff ff ff       	call   80175c <dev_lookup>
  801802:	89 c3                	mov    %eax,%ebx
  801804:	85 c0                	test   %eax,%eax
  801806:	78 16                	js     80181e <fd_close+0x68>
		if (dev->dev_close)
  801808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80180e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801813:	85 c0                	test   %eax,%eax
  801815:	74 07                	je     80181e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801817:	89 34 24             	mov    %esi,(%esp)
  80181a:	ff d0                	call   *%eax
  80181c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80181e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801822:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801829:	e8 dc f6 ff ff       	call   800f0a <sys_page_unmap>
	return r;
  80182e:	89 d8                	mov    %ebx,%eax
}
  801830:	83 c4 20             	add    $0x20,%esp
  801833:	5b                   	pop    %ebx
  801834:	5e                   	pop    %esi
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    

00801837 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801840:	89 44 24 04          	mov    %eax,0x4(%esp)
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	89 04 24             	mov    %eax,(%esp)
  80184a:	e8 b7 fe ff ff       	call   801706 <fd_lookup>
  80184f:	89 c2                	mov    %eax,%edx
  801851:	85 d2                	test   %edx,%edx
  801853:	78 13                	js     801868 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801855:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80185c:	00 
  80185d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801860:	89 04 24             	mov    %eax,(%esp)
  801863:	e8 4e ff ff ff       	call   8017b6 <fd_close>
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <close_all>:

void
close_all(void)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	53                   	push   %ebx
  80186e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801871:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801876:	89 1c 24             	mov    %ebx,(%esp)
  801879:	e8 b9 ff ff ff       	call   801837 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80187e:	83 c3 01             	add    $0x1,%ebx
  801881:	83 fb 20             	cmp    $0x20,%ebx
  801884:	75 f0                	jne    801876 <close_all+0xc>
		close(i);
}
  801886:	83 c4 14             	add    $0x14,%esp
  801889:	5b                   	pop    %ebx
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801895:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801898:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	89 04 24             	mov    %eax,(%esp)
  8018a2:	e8 5f fe ff ff       	call   801706 <fd_lookup>
  8018a7:	89 c2                	mov    %eax,%edx
  8018a9:	85 d2                	test   %edx,%edx
  8018ab:	0f 88 e1 00 00 00    	js     801992 <dup+0x106>
		return r;
	close(newfdnum);
  8018b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b4:	89 04 24             	mov    %eax,(%esp)
  8018b7:	e8 7b ff ff ff       	call   801837 <close>

	newfd = INDEX2FD(newfdnum);
  8018bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018bf:	c1 e3 0c             	shl    $0xc,%ebx
  8018c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8018c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018cb:	89 04 24             	mov    %eax,(%esp)
  8018ce:	e8 cd fd ff ff       	call   8016a0 <fd2data>
  8018d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8018d5:	89 1c 24             	mov    %ebx,(%esp)
  8018d8:	e8 c3 fd ff ff       	call   8016a0 <fd2data>
  8018dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018df:	89 f0                	mov    %esi,%eax
  8018e1:	c1 e8 16             	shr    $0x16,%eax
  8018e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018eb:	a8 01                	test   $0x1,%al
  8018ed:	74 43                	je     801932 <dup+0xa6>
  8018ef:	89 f0                	mov    %esi,%eax
  8018f1:	c1 e8 0c             	shr    $0xc,%eax
  8018f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018fb:	f6 c2 01             	test   $0x1,%dl
  8018fe:	74 32                	je     801932 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801900:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801907:	25 07 0e 00 00       	and    $0xe07,%eax
  80190c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801910:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801914:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80191b:	00 
  80191c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801920:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801927:	e8 8b f5 ff ff       	call   800eb7 <sys_page_map>
  80192c:	89 c6                	mov    %eax,%esi
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 3e                	js     801970 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801935:	89 c2                	mov    %eax,%edx
  801937:	c1 ea 0c             	shr    $0xc,%edx
  80193a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801941:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801947:	89 54 24 10          	mov    %edx,0x10(%esp)
  80194b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80194f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801956:	00 
  801957:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801962:	e8 50 f5 ff ff       	call   800eb7 <sys_page_map>
  801967:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801969:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80196c:	85 f6                	test   %esi,%esi
  80196e:	79 22                	jns    801992 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801970:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801974:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197b:	e8 8a f5 ff ff       	call   800f0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801980:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801984:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198b:	e8 7a f5 ff ff       	call   800f0a <sys_page_unmap>
	return r;
  801990:	89 f0                	mov    %esi,%eax
}
  801992:	83 c4 3c             	add    $0x3c,%esp
  801995:	5b                   	pop    %ebx
  801996:	5e                   	pop    %esi
  801997:	5f                   	pop    %edi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 24             	sub    $0x24,%esp
  8019a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ab:	89 1c 24             	mov    %ebx,(%esp)
  8019ae:	e8 53 fd ff ff       	call   801706 <fd_lookup>
  8019b3:	89 c2                	mov    %eax,%edx
  8019b5:	85 d2                	test   %edx,%edx
  8019b7:	78 6d                	js     801a26 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 00                	mov    (%eax),%eax
  8019c5:	89 04 24             	mov    %eax,(%esp)
  8019c8:	e8 8f fd ff ff       	call   80175c <dev_lookup>
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	78 55                	js     801a26 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d4:	8b 50 08             	mov    0x8(%eax),%edx
  8019d7:	83 e2 03             	and    $0x3,%edx
  8019da:	83 fa 01             	cmp    $0x1,%edx
  8019dd:	75 23                	jne    801a02 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019df:	a1 08 50 80 00       	mov    0x805008,%eax
  8019e4:	8b 40 48             	mov    0x48(%eax),%eax
  8019e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ef:	c7 04 24 6d 33 80 00 	movl   $0x80336d,(%esp)
  8019f6:	e8 20 ea ff ff       	call   80041b <cprintf>
		return -E_INVAL;
  8019fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a00:	eb 24                	jmp    801a26 <read+0x8c>
	}
	if (!dev->dev_read)
  801a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a05:	8b 52 08             	mov    0x8(%edx),%edx
  801a08:	85 d2                	test   %edx,%edx
  801a0a:	74 15                	je     801a21 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a1a:	89 04 24             	mov    %eax,(%esp)
  801a1d:	ff d2                	call   *%edx
  801a1f:	eb 05                	jmp    801a26 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801a21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801a26:	83 c4 24             	add    $0x24,%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	57                   	push   %edi
  801a30:	56                   	push   %esi
  801a31:	53                   	push   %ebx
  801a32:	83 ec 1c             	sub    $0x1c,%esp
  801a35:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a38:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a40:	eb 23                	jmp    801a65 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a42:	89 f0                	mov    %esi,%eax
  801a44:	29 d8                	sub    %ebx,%eax
  801a46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4a:	89 d8                	mov    %ebx,%eax
  801a4c:	03 45 0c             	add    0xc(%ebp),%eax
  801a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a53:	89 3c 24             	mov    %edi,(%esp)
  801a56:	e8 3f ff ff ff       	call   80199a <read>
		if (m < 0)
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 10                	js     801a6f <readn+0x43>
			return m;
		if (m == 0)
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	74 0a                	je     801a6d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a63:	01 c3                	add    %eax,%ebx
  801a65:	39 f3                	cmp    %esi,%ebx
  801a67:	72 d9                	jb     801a42 <readn+0x16>
  801a69:	89 d8                	mov    %ebx,%eax
  801a6b:	eb 02                	jmp    801a6f <readn+0x43>
  801a6d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a6f:	83 c4 1c             	add    $0x1c,%esp
  801a72:	5b                   	pop    %ebx
  801a73:	5e                   	pop    %esi
  801a74:	5f                   	pop    %edi
  801a75:	5d                   	pop    %ebp
  801a76:	c3                   	ret    

00801a77 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	53                   	push   %ebx
  801a7b:	83 ec 24             	sub    $0x24,%esp
  801a7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a81:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a88:	89 1c 24             	mov    %ebx,(%esp)
  801a8b:	e8 76 fc ff ff       	call   801706 <fd_lookup>
  801a90:	89 c2                	mov    %eax,%edx
  801a92:	85 d2                	test   %edx,%edx
  801a94:	78 68                	js     801afe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa0:	8b 00                	mov    (%eax),%eax
  801aa2:	89 04 24             	mov    %eax,(%esp)
  801aa5:	e8 b2 fc ff ff       	call   80175c <dev_lookup>
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 50                	js     801afe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ab5:	75 23                	jne    801ada <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ab7:	a1 08 50 80 00       	mov    0x805008,%eax
  801abc:	8b 40 48             	mov    0x48(%eax),%eax
  801abf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac7:	c7 04 24 89 33 80 00 	movl   $0x803389,(%esp)
  801ace:	e8 48 e9 ff ff       	call   80041b <cprintf>
		return -E_INVAL;
  801ad3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad8:	eb 24                	jmp    801afe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ada:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801add:	8b 52 0c             	mov    0xc(%edx),%edx
  801ae0:	85 d2                	test   %edx,%edx
  801ae2:	74 15                	je     801af9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ae4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af2:	89 04 24             	mov    %eax,(%esp)
  801af5:	ff d2                	call   *%edx
  801af7:	eb 05                	jmp    801afe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801af9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801afe:	83 c4 24             	add    $0x24,%esp
  801b01:	5b                   	pop    %ebx
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    

00801b04 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b0a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	89 04 24             	mov    %eax,(%esp)
  801b17:	e8 ea fb ff ff       	call   801706 <fd_lookup>
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 0e                	js     801b2e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	53                   	push   %ebx
  801b34:	83 ec 24             	sub    $0x24,%esp
  801b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b41:	89 1c 24             	mov    %ebx,(%esp)
  801b44:	e8 bd fb ff ff       	call   801706 <fd_lookup>
  801b49:	89 c2                	mov    %eax,%edx
  801b4b:	85 d2                	test   %edx,%edx
  801b4d:	78 61                	js     801bb0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b59:	8b 00                	mov    (%eax),%eax
  801b5b:	89 04 24             	mov    %eax,(%esp)
  801b5e:	e8 f9 fb ff ff       	call   80175c <dev_lookup>
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 49                	js     801bb0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b6e:	75 23                	jne    801b93 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801b70:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b75:	8b 40 48             	mov    0x48(%eax),%eax
  801b78:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b80:	c7 04 24 4c 33 80 00 	movl   $0x80334c,(%esp)
  801b87:	e8 8f e8 ff ff       	call   80041b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b91:	eb 1d                	jmp    801bb0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b96:	8b 52 18             	mov    0x18(%edx),%edx
  801b99:	85 d2                	test   %edx,%edx
  801b9b:	74 0e                	je     801bab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ba0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba4:	89 04 24             	mov    %eax,(%esp)
  801ba7:	ff d2                	call   *%edx
  801ba9:	eb 05                	jmp    801bb0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801bab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801bb0:	83 c4 24             	add    $0x24,%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5d                   	pop    %ebp
  801bb5:	c3                   	ret    

00801bb6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	53                   	push   %ebx
  801bba:	83 ec 24             	sub    $0x24,%esp
  801bbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	89 04 24             	mov    %eax,(%esp)
  801bcd:	e8 34 fb ff ff       	call   801706 <fd_lookup>
  801bd2:	89 c2                	mov    %eax,%edx
  801bd4:	85 d2                	test   %edx,%edx
  801bd6:	78 52                	js     801c2a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be2:	8b 00                	mov    (%eax),%eax
  801be4:	89 04 24             	mov    %eax,(%esp)
  801be7:	e8 70 fb ff ff       	call   80175c <dev_lookup>
  801bec:	85 c0                	test   %eax,%eax
  801bee:	78 3a                	js     801c2a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bf7:	74 2c                	je     801c25 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bf9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bfc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c03:	00 00 00 
	stat->st_isdir = 0;
  801c06:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c0d:	00 00 00 
	stat->st_dev = dev;
  801c10:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c1d:	89 14 24             	mov    %edx,(%esp)
  801c20:	ff 50 14             	call   *0x14(%eax)
  801c23:	eb 05                	jmp    801c2a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801c25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801c2a:	83 c4 24             	add    $0x24,%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	56                   	push   %esi
  801c34:	53                   	push   %ebx
  801c35:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c3f:	00 
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	89 04 24             	mov    %eax,(%esp)
  801c46:	e8 1b 02 00 00       	call   801e66 <open>
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	85 db                	test   %ebx,%ebx
  801c4f:	78 1b                	js     801c6c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c58:	89 1c 24             	mov    %ebx,(%esp)
  801c5b:	e8 56 ff ff ff       	call   801bb6 <fstat>
  801c60:	89 c6                	mov    %eax,%esi
	close(fd);
  801c62:	89 1c 24             	mov    %ebx,(%esp)
  801c65:	e8 cd fb ff ff       	call   801837 <close>
	return r;
  801c6a:	89 f0                	mov    %esi,%eax
}
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	5b                   	pop    %ebx
  801c70:	5e                   	pop    %esi
  801c71:	5d                   	pop    %ebp
  801c72:	c3                   	ret    

00801c73 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	56                   	push   %esi
  801c77:	53                   	push   %ebx
  801c78:	83 ec 10             	sub    $0x10,%esp
  801c7b:	89 c6                	mov    %eax,%esi
  801c7d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c7f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c86:	75 11                	jne    801c99 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c8f:	e8 2b 0e 00 00       	call   802abf <ipc_find_env>
  801c94:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c99:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ca0:	00 
  801ca1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ca8:	00 
  801ca9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cad:	a1 00 50 80 00       	mov    0x805000,%eax
  801cb2:	89 04 24             	mov    %eax,(%esp)
  801cb5:	e8 9a 0d 00 00       	call   802a54 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cc1:	00 
  801cc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ccd:	e8 2e 0d 00 00       	call   802a00 <ipc_recv>
}
  801cd2:	83 c4 10             	add    $0x10,%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5e                   	pop    %esi
  801cd7:	5d                   	pop    %ebp
  801cd8:	c3                   	ret    

00801cd9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ced:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf7:	b8 02 00 00 00       	mov    $0x2,%eax
  801cfc:	e8 72 ff ff ff       	call   801c73 <fsipc>
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d14:	ba 00 00 00 00       	mov    $0x0,%edx
  801d19:	b8 06 00 00 00       	mov    $0x6,%eax
  801d1e:	e8 50 ff ff ff       	call   801c73 <fsipc>
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	53                   	push   %ebx
  801d29:	83 ec 14             	sub    $0x14,%esp
  801d2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	8b 40 0c             	mov    0xc(%eax),%eax
  801d35:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d44:	e8 2a ff ff ff       	call   801c73 <fsipc>
  801d49:	89 c2                	mov    %eax,%edx
  801d4b:	85 d2                	test   %edx,%edx
  801d4d:	78 2b                	js     801d7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d4f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d56:	00 
  801d57:	89 1c 24             	mov    %ebx,(%esp)
  801d5a:	e8 e8 ec ff ff       	call   800a47 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d5f:	a1 80 60 80 00       	mov    0x806080,%eax
  801d64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d6a:	a1 84 60 80 00       	mov    0x806084,%eax
  801d6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7a:	83 c4 14             	add    $0x14,%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    

00801d80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 18             	sub    $0x18,%esp
  801d86:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d89:	8b 55 08             	mov    0x8(%ebp),%edx
  801d8c:	8b 52 0c             	mov    0xc(%edx),%edx
  801d8f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801d95:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da5:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801dac:	e8 9b ee ff ff       	call   800c4c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801db1:	ba 00 00 00 00       	mov    $0x0,%edx
  801db6:	b8 04 00 00 00       	mov    $0x4,%eax
  801dbb:	e8 b3 fe ff ff       	call   801c73 <fsipc>
		return r;
	}

	return r;
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	56                   	push   %esi
  801dc6:	53                   	push   %ebx
  801dc7:	83 ec 10             	sub    $0x10,%esp
  801dca:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dd8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dde:	ba 00 00 00 00       	mov    $0x0,%edx
  801de3:	b8 03 00 00 00       	mov    $0x3,%eax
  801de8:	e8 86 fe ff ff       	call   801c73 <fsipc>
  801ded:	89 c3                	mov    %eax,%ebx
  801def:	85 c0                	test   %eax,%eax
  801df1:	78 6a                	js     801e5d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801df3:	39 c6                	cmp    %eax,%esi
  801df5:	73 24                	jae    801e1b <devfile_read+0x59>
  801df7:	c7 44 24 0c bc 33 80 	movl   $0x8033bc,0xc(%esp)
  801dfe:	00 
  801dff:	c7 44 24 08 c3 33 80 	movl   $0x8033c3,0x8(%esp)
  801e06:	00 
  801e07:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801e0e:	00 
  801e0f:	c7 04 24 d8 33 80 00 	movl   $0x8033d8,(%esp)
  801e16:	e8 07 e5 ff ff       	call   800322 <_panic>
	assert(r <= PGSIZE);
  801e1b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e20:	7e 24                	jle    801e46 <devfile_read+0x84>
  801e22:	c7 44 24 0c e3 33 80 	movl   $0x8033e3,0xc(%esp)
  801e29:	00 
  801e2a:	c7 44 24 08 c3 33 80 	movl   $0x8033c3,0x8(%esp)
  801e31:	00 
  801e32:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e39:	00 
  801e3a:	c7 04 24 d8 33 80 00 	movl   $0x8033d8,(%esp)
  801e41:	e8 dc e4 ff ff       	call   800322 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e4a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e51:	00 
  801e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e55:	89 04 24             	mov    %eax,(%esp)
  801e58:	e8 87 ed ff ff       	call   800be4 <memmove>
	return r;
}
  801e5d:	89 d8                	mov    %ebx,%eax
  801e5f:	83 c4 10             	add    $0x10,%esp
  801e62:	5b                   	pop    %ebx
  801e63:	5e                   	pop    %esi
  801e64:	5d                   	pop    %ebp
  801e65:	c3                   	ret    

00801e66 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	53                   	push   %ebx
  801e6a:	83 ec 24             	sub    $0x24,%esp
  801e6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e70:	89 1c 24             	mov    %ebx,(%esp)
  801e73:	e8 98 eb ff ff       	call   800a10 <strlen>
  801e78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e7d:	7f 60                	jg     801edf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e82:	89 04 24             	mov    %eax,(%esp)
  801e85:	e8 2d f8 ff ff       	call   8016b7 <fd_alloc>
  801e8a:	89 c2                	mov    %eax,%edx
  801e8c:	85 d2                	test   %edx,%edx
  801e8e:	78 54                	js     801ee4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e94:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e9b:	e8 a7 eb ff ff       	call   800a47 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea3:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eab:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb0:	e8 be fd ff ff       	call   801c73 <fsipc>
  801eb5:	89 c3                	mov    %eax,%ebx
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	79 17                	jns    801ed2 <open+0x6c>
		fd_close(fd, 0);
  801ebb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ec2:	00 
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	89 04 24             	mov    %eax,(%esp)
  801ec9:	e8 e8 f8 ff ff       	call   8017b6 <fd_close>
		return r;
  801ece:	89 d8                	mov    %ebx,%eax
  801ed0:	eb 12                	jmp    801ee4 <open+0x7e>
	}

	return fd2num(fd);
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	89 04 24             	mov    %eax,(%esp)
  801ed8:	e8 b3 f7 ff ff       	call   801690 <fd2num>
  801edd:	eb 05                	jmp    801ee4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801edf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ee4:	83 c4 24             	add    $0x24,%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5d                   	pop    %ebp
  801ee9:	c3                   	ret    

00801eea <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ef0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef5:	b8 08 00 00 00       	mov    $0x8,%eax
  801efa:	e8 74 fd ff ff       	call   801c73 <fsipc>
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    
  801f01:	66 90                	xchg   %ax,%ax
  801f03:	66 90                	xchg   %ax,%ax
  801f05:	66 90                	xchg   %ax,%ax
  801f07:	66 90                	xchg   %ax,%ax
  801f09:	66 90                	xchg   %ax,%ax
  801f0b:	66 90                	xchg   %ax,%ax
  801f0d:	66 90                	xchg   %ax,%ax
  801f0f:	90                   	nop

00801f10 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f16:	c7 44 24 04 ef 33 80 	movl   $0x8033ef,0x4(%esp)
  801f1d:	00 
  801f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f21:	89 04 24             	mov    %eax,(%esp)
  801f24:	e8 1e eb ff ff       	call   800a47 <strcpy>
	return 0;
}
  801f29:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	53                   	push   %ebx
  801f34:	83 ec 14             	sub    $0x14,%esp
  801f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f3a:	89 1c 24             	mov    %ebx,(%esp)
  801f3d:	e8 bc 0b 00 00       	call   802afe <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f42:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f47:	83 f8 01             	cmp    $0x1,%eax
  801f4a:	75 0d                	jne    801f59 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f4f:	89 04 24             	mov    %eax,(%esp)
  801f52:	e8 29 03 00 00       	call   802280 <nsipc_close>
  801f57:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f59:	89 d0                	mov    %edx,%eax
  801f5b:	83 c4 14             	add    $0x14,%esp
  801f5e:	5b                   	pop    %ebx
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    

00801f61 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f67:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f6e:	00 
  801f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	8b 40 0c             	mov    0xc(%eax),%eax
  801f83:	89 04 24             	mov    %eax,(%esp)
  801f86:	e8 f0 03 00 00       	call   80237b <nsipc_send>
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f93:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f9a:	00 
  801f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	8b 40 0c             	mov    0xc(%eax),%eax
  801faf:	89 04 24             	mov    %eax,(%esp)
  801fb2:	e8 44 03 00 00       	call   8022fb <nsipc_recv>
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fbf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fc2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fc6:	89 04 24             	mov    %eax,(%esp)
  801fc9:	e8 38 f7 ff ff       	call   801706 <fd_lookup>
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	78 17                	js     801fe9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fdb:	39 08                	cmp    %ecx,(%eax)
  801fdd:	75 05                	jne    801fe4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801fdf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe2:	eb 05                	jmp    801fe9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801fe4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	56                   	push   %esi
  801fef:	53                   	push   %ebx
  801ff0:	83 ec 20             	sub    $0x20,%esp
  801ff3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ff5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff8:	89 04 24             	mov    %eax,(%esp)
  801ffb:	e8 b7 f6 ff ff       	call   8016b7 <fd_alloc>
  802000:	89 c3                	mov    %eax,%ebx
  802002:	85 c0                	test   %eax,%eax
  802004:	78 21                	js     802027 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802006:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80200d:	00 
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	89 44 24 04          	mov    %eax,0x4(%esp)
  802015:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80201c:	e8 42 ee ff ff       	call   800e63 <sys_page_alloc>
  802021:	89 c3                	mov    %eax,%ebx
  802023:	85 c0                	test   %eax,%eax
  802025:	79 0c                	jns    802033 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802027:	89 34 24             	mov    %esi,(%esp)
  80202a:	e8 51 02 00 00       	call   802280 <nsipc_close>
		return r;
  80202f:	89 d8                	mov    %ebx,%eax
  802031:	eb 20                	jmp    802053 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802033:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80203e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802041:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802048:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80204b:	89 14 24             	mov    %edx,(%esp)
  80204e:	e8 3d f6 ff ff       	call   801690 <fd2num>
}
  802053:	83 c4 20             	add    $0x20,%esp
  802056:	5b                   	pop    %ebx
  802057:	5e                   	pop    %esi
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	e8 51 ff ff ff       	call   801fb9 <fd2sockid>
		return r;
  802068:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 23                	js     802091 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80206e:	8b 55 10             	mov    0x10(%ebp),%edx
  802071:	89 54 24 08          	mov    %edx,0x8(%esp)
  802075:	8b 55 0c             	mov    0xc(%ebp),%edx
  802078:	89 54 24 04          	mov    %edx,0x4(%esp)
  80207c:	89 04 24             	mov    %eax,(%esp)
  80207f:	e8 45 01 00 00       	call   8021c9 <nsipc_accept>
		return r;
  802084:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802086:	85 c0                	test   %eax,%eax
  802088:	78 07                	js     802091 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80208a:	e8 5c ff ff ff       	call   801feb <alloc_sockfd>
  80208f:	89 c1                	mov    %eax,%ecx
}
  802091:	89 c8                	mov    %ecx,%eax
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	e8 16 ff ff ff       	call   801fb9 <fd2sockid>
  8020a3:	89 c2                	mov    %eax,%edx
  8020a5:	85 d2                	test   %edx,%edx
  8020a7:	78 16                	js     8020bf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8020a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b7:	89 14 24             	mov    %edx,(%esp)
  8020ba:	e8 60 01 00 00       	call   80221f <nsipc_bind>
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <shutdown>:

int
shutdown(int s, int how)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	e8 ea fe ff ff       	call   801fb9 <fd2sockid>
  8020cf:	89 c2                	mov    %eax,%edx
  8020d1:	85 d2                	test   %edx,%edx
  8020d3:	78 0f                	js     8020e4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dc:	89 14 24             	mov    %edx,(%esp)
  8020df:	e8 7a 01 00 00       	call   80225e <nsipc_shutdown>
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	e8 c5 fe ff ff       	call   801fb9 <fd2sockid>
  8020f4:	89 c2                	mov    %eax,%edx
  8020f6:	85 d2                	test   %edx,%edx
  8020f8:	78 16                	js     802110 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8020fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802101:	8b 45 0c             	mov    0xc(%ebp),%eax
  802104:	89 44 24 04          	mov    %eax,0x4(%esp)
  802108:	89 14 24             	mov    %edx,(%esp)
  80210b:	e8 8a 01 00 00       	call   80229a <nsipc_connect>
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <listen>:

int
listen(int s, int backlog)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	e8 99 fe ff ff       	call   801fb9 <fd2sockid>
  802120:	89 c2                	mov    %eax,%edx
  802122:	85 d2                	test   %edx,%edx
  802124:	78 0f                	js     802135 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802126:	8b 45 0c             	mov    0xc(%ebp),%eax
  802129:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212d:	89 14 24             	mov    %edx,(%esp)
  802130:	e8 a4 01 00 00       	call   8022d9 <nsipc_listen>
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80213d:	8b 45 10             	mov    0x10(%ebp),%eax
  802140:	89 44 24 08          	mov    %eax,0x8(%esp)
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	89 04 24             	mov    %eax,(%esp)
  802151:	e8 98 02 00 00       	call   8023ee <nsipc_socket>
  802156:	89 c2                	mov    %eax,%edx
  802158:	85 d2                	test   %edx,%edx
  80215a:	78 05                	js     802161 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80215c:	e8 8a fe ff ff       	call   801feb <alloc_sockfd>
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	53                   	push   %ebx
  802167:	83 ec 14             	sub    $0x14,%esp
  80216a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80216c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802173:	75 11                	jne    802186 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802175:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80217c:	e8 3e 09 00 00       	call   802abf <ipc_find_env>
  802181:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802186:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80218d:	00 
  80218e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802195:	00 
  802196:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80219a:	a1 04 50 80 00       	mov    0x805004,%eax
  80219f:	89 04 24             	mov    %eax,(%esp)
  8021a2:	e8 ad 08 00 00       	call   802a54 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021ae:	00 
  8021af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021b6:	00 
  8021b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021be:	e8 3d 08 00 00       	call   802a00 <ipc_recv>
}
  8021c3:	83 c4 14             	add    $0x14,%esp
  8021c6:	5b                   	pop    %ebx
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    

008021c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	56                   	push   %esi
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 10             	sub    $0x10,%esp
  8021d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021dc:	8b 06                	mov    (%esi),%eax
  8021de:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e8:	e8 76 ff ff ff       	call   802163 <nsipc>
  8021ed:	89 c3                	mov    %eax,%ebx
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	78 23                	js     802216 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021f3:	a1 10 70 80 00       	mov    0x807010,%eax
  8021f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021fc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802203:	00 
  802204:	8b 45 0c             	mov    0xc(%ebp),%eax
  802207:	89 04 24             	mov    %eax,(%esp)
  80220a:	e8 d5 e9 ff ff       	call   800be4 <memmove>
		*addrlen = ret->ret_addrlen;
  80220f:	a1 10 70 80 00       	mov    0x807010,%eax
  802214:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802216:	89 d8                	mov    %ebx,%eax
  802218:	83 c4 10             	add    $0x10,%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5e                   	pop    %esi
  80221d:	5d                   	pop    %ebp
  80221e:	c3                   	ret    

0080221f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	53                   	push   %ebx
  802223:	83 ec 14             	sub    $0x14,%esp
  802226:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802231:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802235:	8b 45 0c             	mov    0xc(%ebp),%eax
  802238:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802243:	e8 9c e9 ff ff       	call   800be4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802248:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80224e:	b8 02 00 00 00       	mov    $0x2,%eax
  802253:	e8 0b ff ff ff       	call   802163 <nsipc>
}
  802258:	83 c4 14             	add    $0x14,%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    

0080225e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80226c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802274:	b8 03 00 00 00       	mov    $0x3,%eax
  802279:	e8 e5 fe ff ff       	call   802163 <nsipc>
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <nsipc_close>:

int
nsipc_close(int s)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80228e:	b8 04 00 00 00       	mov    $0x4,%eax
  802293:	e8 cb fe ff ff       	call   802163 <nsipc>
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	53                   	push   %ebx
  80229e:	83 ec 14             	sub    $0x14,%esp
  8022a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8022be:	e8 21 e9 ff ff       	call   800be4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022c3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8022ce:	e8 90 fe ff ff       	call   802163 <nsipc>
}
  8022d3:	83 c4 14             	add    $0x14,%esp
  8022d6:	5b                   	pop    %ebx
  8022d7:	5d                   	pop    %ebp
  8022d8:	c3                   	ret    

008022d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ea:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8022f4:	e8 6a fe ff ff       	call   802163 <nsipc>
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	56                   	push   %esi
  8022ff:	53                   	push   %ebx
  802300:	83 ec 10             	sub    $0x10,%esp
  802303:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80230e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802314:	8b 45 14             	mov    0x14(%ebp),%eax
  802317:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80231c:	b8 07 00 00 00       	mov    $0x7,%eax
  802321:	e8 3d fe ff ff       	call   802163 <nsipc>
  802326:	89 c3                	mov    %eax,%ebx
  802328:	85 c0                	test   %eax,%eax
  80232a:	78 46                	js     802372 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80232c:	39 f0                	cmp    %esi,%eax
  80232e:	7f 07                	jg     802337 <nsipc_recv+0x3c>
  802330:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802335:	7e 24                	jle    80235b <nsipc_recv+0x60>
  802337:	c7 44 24 0c fb 33 80 	movl   $0x8033fb,0xc(%esp)
  80233e:	00 
  80233f:	c7 44 24 08 c3 33 80 	movl   $0x8033c3,0x8(%esp)
  802346:	00 
  802347:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80234e:	00 
  80234f:	c7 04 24 10 34 80 00 	movl   $0x803410,(%esp)
  802356:	e8 c7 df ff ff       	call   800322 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80235b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80235f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802366:	00 
  802367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236a:	89 04 24             	mov    %eax,(%esp)
  80236d:	e8 72 e8 ff ff       	call   800be4 <memmove>
	}

	return r;
}
  802372:	89 d8                	mov    %ebx,%eax
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	5b                   	pop    %ebx
  802378:	5e                   	pop    %esi
  802379:	5d                   	pop    %ebp
  80237a:	c3                   	ret    

0080237b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	53                   	push   %ebx
  80237f:	83 ec 14             	sub    $0x14,%esp
  802382:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80238d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802393:	7e 24                	jle    8023b9 <nsipc_send+0x3e>
  802395:	c7 44 24 0c 1c 34 80 	movl   $0x80341c,0xc(%esp)
  80239c:	00 
  80239d:	c7 44 24 08 c3 33 80 	movl   $0x8033c3,0x8(%esp)
  8023a4:	00 
  8023a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8023ac:	00 
  8023ad:	c7 04 24 10 34 80 00 	movl   $0x803410,(%esp)
  8023b4:	e8 69 df ff ff       	call   800322 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8023cb:	e8 14 e8 ff ff       	call   800be4 <memmove>
	nsipcbuf.send.req_size = size;
  8023d0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023de:	b8 08 00 00 00       	mov    $0x8,%eax
  8023e3:	e8 7b fd ff ff       	call   802163 <nsipc>
}
  8023e8:	83 c4 14             	add    $0x14,%esp
  8023eb:	5b                   	pop    %ebx
  8023ec:	5d                   	pop    %ebp
  8023ed:	c3                   	ret    

008023ee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ff:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802404:	8b 45 10             	mov    0x10(%ebp),%eax
  802407:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80240c:	b8 09 00 00 00       	mov    $0x9,%eax
  802411:	e8 4d fd ff ff       	call   802163 <nsipc>
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	56                   	push   %esi
  80241c:	53                   	push   %ebx
  80241d:	83 ec 10             	sub    $0x10,%esp
  802420:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	89 04 24             	mov    %eax,(%esp)
  802429:	e8 72 f2 ff ff       	call   8016a0 <fd2data>
  80242e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802430:	c7 44 24 04 28 34 80 	movl   $0x803428,0x4(%esp)
  802437:	00 
  802438:	89 1c 24             	mov    %ebx,(%esp)
  80243b:	e8 07 e6 ff ff       	call   800a47 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802440:	8b 46 04             	mov    0x4(%esi),%eax
  802443:	2b 06                	sub    (%esi),%eax
  802445:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80244b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802452:	00 00 00 
	stat->st_dev = &devpipe;
  802455:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80245c:	40 80 00 
	return 0;
}
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
  802464:	83 c4 10             	add    $0x10,%esp
  802467:	5b                   	pop    %ebx
  802468:	5e                   	pop    %esi
  802469:	5d                   	pop    %ebp
  80246a:	c3                   	ret    

0080246b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	53                   	push   %ebx
  80246f:	83 ec 14             	sub    $0x14,%esp
  802472:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802475:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802479:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802480:	e8 85 ea ff ff       	call   800f0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802485:	89 1c 24             	mov    %ebx,(%esp)
  802488:	e8 13 f2 ff ff       	call   8016a0 <fd2data>
  80248d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802491:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802498:	e8 6d ea ff ff       	call   800f0a <sys_page_unmap>
}
  80249d:	83 c4 14             	add    $0x14,%esp
  8024a0:	5b                   	pop    %ebx
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    

008024a3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	57                   	push   %edi
  8024a7:	56                   	push   %esi
  8024a8:	53                   	push   %ebx
  8024a9:	83 ec 2c             	sub    $0x2c,%esp
  8024ac:	89 c6                	mov    %eax,%esi
  8024ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8024b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8024b6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024b9:	89 34 24             	mov    %esi,(%esp)
  8024bc:	e8 3d 06 00 00       	call   802afe <pageref>
  8024c1:	89 c7                	mov    %eax,%edi
  8024c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c6:	89 04 24             	mov    %eax,(%esp)
  8024c9:	e8 30 06 00 00       	call   802afe <pageref>
  8024ce:	39 c7                	cmp    %eax,%edi
  8024d0:	0f 94 c2             	sete   %dl
  8024d3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8024d6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8024dc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8024df:	39 fb                	cmp    %edi,%ebx
  8024e1:	74 21                	je     802504 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8024e3:	84 d2                	test   %dl,%dl
  8024e5:	74 ca                	je     8024b1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024e7:	8b 51 58             	mov    0x58(%ecx),%edx
  8024ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024f6:	c7 04 24 2f 34 80 00 	movl   $0x80342f,(%esp)
  8024fd:	e8 19 df ff ff       	call   80041b <cprintf>
  802502:	eb ad                	jmp    8024b1 <_pipeisclosed+0xe>
	}
}
  802504:	83 c4 2c             	add    $0x2c,%esp
  802507:	5b                   	pop    %ebx
  802508:	5e                   	pop    %esi
  802509:	5f                   	pop    %edi
  80250a:	5d                   	pop    %ebp
  80250b:	c3                   	ret    

0080250c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	57                   	push   %edi
  802510:	56                   	push   %esi
  802511:	53                   	push   %ebx
  802512:	83 ec 1c             	sub    $0x1c,%esp
  802515:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802518:	89 34 24             	mov    %esi,(%esp)
  80251b:	e8 80 f1 ff ff       	call   8016a0 <fd2data>
  802520:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802522:	bf 00 00 00 00       	mov    $0x0,%edi
  802527:	eb 45                	jmp    80256e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802529:	89 da                	mov    %ebx,%edx
  80252b:	89 f0                	mov    %esi,%eax
  80252d:	e8 71 ff ff ff       	call   8024a3 <_pipeisclosed>
  802532:	85 c0                	test   %eax,%eax
  802534:	75 41                	jne    802577 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802536:	e8 09 e9 ff ff       	call   800e44 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80253b:	8b 43 04             	mov    0x4(%ebx),%eax
  80253e:	8b 0b                	mov    (%ebx),%ecx
  802540:	8d 51 20             	lea    0x20(%ecx),%edx
  802543:	39 d0                	cmp    %edx,%eax
  802545:	73 e2                	jae    802529 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802547:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80254a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80254e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802551:	99                   	cltd   
  802552:	c1 ea 1b             	shr    $0x1b,%edx
  802555:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802558:	83 e1 1f             	and    $0x1f,%ecx
  80255b:	29 d1                	sub    %edx,%ecx
  80255d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802561:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802565:	83 c0 01             	add    $0x1,%eax
  802568:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80256b:	83 c7 01             	add    $0x1,%edi
  80256e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802571:	75 c8                	jne    80253b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802573:	89 f8                	mov    %edi,%eax
  802575:	eb 05                	jmp    80257c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802577:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80257c:	83 c4 1c             	add    $0x1c,%esp
  80257f:	5b                   	pop    %ebx
  802580:	5e                   	pop    %esi
  802581:	5f                   	pop    %edi
  802582:	5d                   	pop    %ebp
  802583:	c3                   	ret    

00802584 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	57                   	push   %edi
  802588:	56                   	push   %esi
  802589:	53                   	push   %ebx
  80258a:	83 ec 1c             	sub    $0x1c,%esp
  80258d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802590:	89 3c 24             	mov    %edi,(%esp)
  802593:	e8 08 f1 ff ff       	call   8016a0 <fd2data>
  802598:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80259a:	be 00 00 00 00       	mov    $0x0,%esi
  80259f:	eb 3d                	jmp    8025de <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8025a1:	85 f6                	test   %esi,%esi
  8025a3:	74 04                	je     8025a9 <devpipe_read+0x25>
				return i;
  8025a5:	89 f0                	mov    %esi,%eax
  8025a7:	eb 43                	jmp    8025ec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025a9:	89 da                	mov    %ebx,%edx
  8025ab:	89 f8                	mov    %edi,%eax
  8025ad:	e8 f1 fe ff ff       	call   8024a3 <_pipeisclosed>
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	75 31                	jne    8025e7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8025b6:	e8 89 e8 ff ff       	call   800e44 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8025bb:	8b 03                	mov    (%ebx),%eax
  8025bd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025c0:	74 df                	je     8025a1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025c2:	99                   	cltd   
  8025c3:	c1 ea 1b             	shr    $0x1b,%edx
  8025c6:	01 d0                	add    %edx,%eax
  8025c8:	83 e0 1f             	and    $0x1f,%eax
  8025cb:	29 d0                	sub    %edx,%eax
  8025cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025d8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025db:	83 c6 01             	add    $0x1,%esi
  8025de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025e1:	75 d8                	jne    8025bb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025e3:	89 f0                	mov    %esi,%eax
  8025e5:	eb 05                	jmp    8025ec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8025ec:	83 c4 1c             	add    $0x1c,%esp
  8025ef:	5b                   	pop    %ebx
  8025f0:	5e                   	pop    %esi
  8025f1:	5f                   	pop    %edi
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    

008025f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	56                   	push   %esi
  8025f8:	53                   	push   %ebx
  8025f9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ff:	89 04 24             	mov    %eax,(%esp)
  802602:	e8 b0 f0 ff ff       	call   8016b7 <fd_alloc>
  802607:	89 c2                	mov    %eax,%edx
  802609:	85 d2                	test   %edx,%edx
  80260b:	0f 88 4d 01 00 00    	js     80275e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802611:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802618:	00 
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802620:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802627:	e8 37 e8 ff ff       	call   800e63 <sys_page_alloc>
  80262c:	89 c2                	mov    %eax,%edx
  80262e:	85 d2                	test   %edx,%edx
  802630:	0f 88 28 01 00 00    	js     80275e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802636:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802639:	89 04 24             	mov    %eax,(%esp)
  80263c:	e8 76 f0 ff ff       	call   8016b7 <fd_alloc>
  802641:	89 c3                	mov    %eax,%ebx
  802643:	85 c0                	test   %eax,%eax
  802645:	0f 88 fe 00 00 00    	js     802749 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80264b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802652:	00 
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	89 44 24 04          	mov    %eax,0x4(%esp)
  80265a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802661:	e8 fd e7 ff ff       	call   800e63 <sys_page_alloc>
  802666:	89 c3                	mov    %eax,%ebx
  802668:	85 c0                	test   %eax,%eax
  80266a:	0f 88 d9 00 00 00    	js     802749 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	89 04 24             	mov    %eax,(%esp)
  802676:	e8 25 f0 ff ff       	call   8016a0 <fd2data>
  80267b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802684:	00 
  802685:	89 44 24 04          	mov    %eax,0x4(%esp)
  802689:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802690:	e8 ce e7 ff ff       	call   800e63 <sys_page_alloc>
  802695:	89 c3                	mov    %eax,%ebx
  802697:	85 c0                	test   %eax,%eax
  802699:	0f 88 97 00 00 00    	js     802736 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a2:	89 04 24             	mov    %eax,(%esp)
  8026a5:	e8 f6 ef ff ff       	call   8016a0 <fd2data>
  8026aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026b1:	00 
  8026b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026bd:	00 
  8026be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c9:	e8 e9 e7 ff ff       	call   800eb7 <sys_page_map>
  8026ce:	89 c3                	mov    %eax,%ebx
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	78 52                	js     802726 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026d4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8026e9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	89 04 24             	mov    %eax,(%esp)
  802704:	e8 87 ef ff ff       	call   801690 <fd2num>
  802709:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80270c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80270e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802711:	89 04 24             	mov    %eax,(%esp)
  802714:	e8 77 ef ff ff       	call   801690 <fd2num>
  802719:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80271c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	eb 38                	jmp    80275e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802726:	89 74 24 04          	mov    %esi,0x4(%esp)
  80272a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802731:	e8 d4 e7 ff ff       	call   800f0a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	89 44 24 04          	mov    %eax,0x4(%esp)
  80273d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802744:	e8 c1 e7 ff ff       	call   800f0a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802750:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802757:	e8 ae e7 ff ff       	call   800f0a <sys_page_unmap>
  80275c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80275e:	83 c4 30             	add    $0x30,%esp
  802761:	5b                   	pop    %ebx
  802762:	5e                   	pop    %esi
  802763:	5d                   	pop    %ebp
  802764:	c3                   	ret    

00802765 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80276b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80276e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802772:	8b 45 08             	mov    0x8(%ebp),%eax
  802775:	89 04 24             	mov    %eax,(%esp)
  802778:	e8 89 ef ff ff       	call   801706 <fd_lookup>
  80277d:	89 c2                	mov    %eax,%edx
  80277f:	85 d2                	test   %edx,%edx
  802781:	78 15                	js     802798 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	89 04 24             	mov    %eax,(%esp)
  802789:	e8 12 ef ff ff       	call   8016a0 <fd2data>
	return _pipeisclosed(fd, p);
  80278e:	89 c2                	mov    %eax,%edx
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	e8 0b fd ff ff       	call   8024a3 <_pipeisclosed>
}
  802798:	c9                   	leave  
  802799:	c3                   	ret    
  80279a:	66 90                	xchg   %ax,%ax
  80279c:	66 90                	xchg   %ax,%ax
  80279e:	66 90                	xchg   %ax,%ax

008027a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	5d                   	pop    %ebp
  8027a9:	c3                   	ret    

008027aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8027b0:	c7 44 24 04 42 34 80 	movl   $0x803442,0x4(%esp)
  8027b7:	00 
  8027b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027bb:	89 04 24             	mov    %eax,(%esp)
  8027be:	e8 84 e2 ff ff       	call   800a47 <strcpy>
	return 0;
}
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	57                   	push   %edi
  8027ce:	56                   	push   %esi
  8027cf:	53                   	push   %ebx
  8027d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027e1:	eb 31                	jmp    802814 <devcons_write+0x4a>
		m = n - tot;
  8027e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8027e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8027e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027f7:	03 45 0c             	add    0xc(%ebp),%eax
  8027fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027fe:	89 3c 24             	mov    %edi,(%esp)
  802801:	e8 de e3 ff ff       	call   800be4 <memmove>
		sys_cputs(buf, m);
  802806:	89 74 24 04          	mov    %esi,0x4(%esp)
  80280a:	89 3c 24             	mov    %edi,(%esp)
  80280d:	e8 84 e5 ff ff       	call   800d96 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802812:	01 f3                	add    %esi,%ebx
  802814:	89 d8                	mov    %ebx,%eax
  802816:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802819:	72 c8                	jb     8027e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80281b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802821:	5b                   	pop    %ebx
  802822:	5e                   	pop    %esi
  802823:	5f                   	pop    %edi
  802824:	5d                   	pop    %ebp
  802825:	c3                   	ret    

00802826 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80282c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802831:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802835:	75 07                	jne    80283e <devcons_read+0x18>
  802837:	eb 2a                	jmp    802863 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802839:	e8 06 e6 ff ff       	call   800e44 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80283e:	66 90                	xchg   %ax,%ax
  802840:	e8 6f e5 ff ff       	call   800db4 <sys_cgetc>
  802845:	85 c0                	test   %eax,%eax
  802847:	74 f0                	je     802839 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802849:	85 c0                	test   %eax,%eax
  80284b:	78 16                	js     802863 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80284d:	83 f8 04             	cmp    $0x4,%eax
  802850:	74 0c                	je     80285e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802852:	8b 55 0c             	mov    0xc(%ebp),%edx
  802855:	88 02                	mov    %al,(%edx)
	return 1;
  802857:	b8 01 00 00 00       	mov    $0x1,%eax
  80285c:	eb 05                	jmp    802863 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80285e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802871:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802878:	00 
  802879:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80287c:	89 04 24             	mov    %eax,(%esp)
  80287f:	e8 12 e5 ff ff       	call   800d96 <sys_cputs>
}
  802884:	c9                   	leave  
  802885:	c3                   	ret    

00802886 <getchar>:

int
getchar(void)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80288c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802893:	00 
  802894:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80289b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a2:	e8 f3 f0 ff ff       	call   80199a <read>
	if (r < 0)
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	78 0f                	js     8028ba <getchar+0x34>
		return r;
	if (r < 1)
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	7e 06                	jle    8028b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8028af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8028b3:	eb 05                	jmp    8028ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8028b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8028ba:	c9                   	leave  
  8028bb:	c3                   	ret    

008028bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	89 04 24             	mov    %eax,(%esp)
  8028cf:	e8 32 ee ff ff       	call   801706 <fd_lookup>
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	78 11                	js     8028e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028e1:	39 10                	cmp    %edx,(%eax)
  8028e3:	0f 94 c0             	sete   %al
  8028e6:	0f b6 c0             	movzbl %al,%eax
}
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <opencons>:

int
opencons(void)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
  8028ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028f4:	89 04 24             	mov    %eax,(%esp)
  8028f7:	e8 bb ed ff ff       	call   8016b7 <fd_alloc>
		return r;
  8028fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028fe:	85 c0                	test   %eax,%eax
  802900:	78 40                	js     802942 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802902:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802909:	00 
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802911:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802918:	e8 46 e5 ff ff       	call   800e63 <sys_page_alloc>
		return r;
  80291d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80291f:	85 c0                	test   %eax,%eax
  802921:	78 1f                	js     802942 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802923:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802938:	89 04 24             	mov    %eax,(%esp)
  80293b:	e8 50 ed ff ff       	call   801690 <fd2num>
  802940:	89 c2                	mov    %eax,%edx
}
  802942:	89 d0                	mov    %edx,%eax
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80294c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802953:	75 70                	jne    8029c5 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  802955:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  80295c:	00 
  80295d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802964:	ee 
  802965:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80296c:	e8 f2 e4 ff ff       	call   800e63 <sys_page_alloc>
		if (error < 0)
  802971:	85 c0                	test   %eax,%eax
  802973:	79 1c                	jns    802991 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  802975:	c7 44 24 08 50 34 80 	movl   $0x803450,0x8(%esp)
  80297c:	00 
  80297d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802984:	00 
  802985:	c7 04 24 a3 34 80 00 	movl   $0x8034a3,(%esp)
  80298c:	e8 91 d9 ff ff       	call   800322 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802991:	c7 44 24 04 cf 29 80 	movl   $0x8029cf,0x4(%esp)
  802998:	00 
  802999:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a0:	e8 5e e6 ff ff       	call   801003 <sys_env_set_pgfault_upcall>
		if (error < 0)
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	79 1c                	jns    8029c5 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  8029a9:	c7 44 24 08 78 34 80 	movl   $0x803478,0x8(%esp)
  8029b0:	00 
  8029b1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8029b8:	00 
  8029b9:	c7 04 24 a3 34 80 00 	movl   $0x8034a3,(%esp)
  8029c0:	e8 5d d9 ff ff       	call   800322 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029cf:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029d0:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029d5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029d7:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  8029da:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  8029de:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  8029e3:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  8029e7:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  8029e9:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8029ec:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029ed:	83 c4 04             	add    $0x4,%esp
	popfl
  8029f0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029f1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8029f2:	c3                   	ret    
  8029f3:	66 90                	xchg   %ax,%ax
  8029f5:	66 90                	xchg   %ax,%ax
  8029f7:	66 90                	xchg   %ax,%ax
  8029f9:	66 90                	xchg   %ax,%ax
  8029fb:	66 90                	xchg   %ax,%ax
  8029fd:	66 90                	xchg   %ax,%ax
  8029ff:	90                   	nop

00802a00 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	56                   	push   %esi
  802a04:	53                   	push   %ebx
  802a05:	83 ec 10             	sub    $0x10,%esp
  802a08:	8b 75 08             	mov    0x8(%ebp),%esi
  802a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802a11:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802a13:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a18:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  802a1b:	89 04 24             	mov    %eax,(%esp)
  802a1e:	e8 56 e6 ff ff       	call   801079 <sys_ipc_recv>
  802a23:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802a25:	85 d2                	test   %edx,%edx
  802a27:	75 24                	jne    802a4d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802a29:	85 f6                	test   %esi,%esi
  802a2b:	74 0a                	je     802a37 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  802a2d:	a1 08 50 80 00       	mov    0x805008,%eax
  802a32:	8b 40 74             	mov    0x74(%eax),%eax
  802a35:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802a37:	85 db                	test   %ebx,%ebx
  802a39:	74 0a                	je     802a45 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  802a3b:	a1 08 50 80 00       	mov    0x805008,%eax
  802a40:	8b 40 78             	mov    0x78(%eax),%eax
  802a43:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802a45:	a1 08 50 80 00       	mov    0x805008,%eax
  802a4a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  802a4d:	83 c4 10             	add    $0x10,%esp
  802a50:	5b                   	pop    %ebx
  802a51:	5e                   	pop    %esi
  802a52:	5d                   	pop    %ebp
  802a53:	c3                   	ret    

00802a54 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	57                   	push   %edi
  802a58:	56                   	push   %esi
  802a59:	53                   	push   %ebx
  802a5a:	83 ec 1c             	sub    $0x1c,%esp
  802a5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a60:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802a66:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802a68:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a6d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802a70:	8b 45 14             	mov    0x14(%ebp),%eax
  802a73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a7f:	89 3c 24             	mov    %edi,(%esp)
  802a82:	e8 cf e5 ff ff       	call   801056 <sys_ipc_try_send>

		if (ret == 0)
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 2c                	je     802ab7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  802a8b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a8e:	74 20                	je     802ab0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802a90:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a94:	c7 44 24 08 b4 34 80 	movl   $0x8034b4,0x8(%esp)
  802a9b:	00 
  802a9c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802aa3:	00 
  802aa4:	c7 04 24 e4 34 80 00 	movl   $0x8034e4,(%esp)
  802aab:	e8 72 d8 ff ff       	call   800322 <_panic>
		}

		sys_yield();
  802ab0:	e8 8f e3 ff ff       	call   800e44 <sys_yield>
	}
  802ab5:	eb b9                	jmp    802a70 <ipc_send+0x1c>
}
  802ab7:	83 c4 1c             	add    $0x1c,%esp
  802aba:	5b                   	pop    %ebx
  802abb:	5e                   	pop    %esi
  802abc:	5f                   	pop    %edi
  802abd:	5d                   	pop    %ebp
  802abe:	c3                   	ret    

00802abf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
  802ac2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ac5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802aca:	89 c2                	mov    %eax,%edx
  802acc:	c1 e2 07             	shl    $0x7,%edx
  802acf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802ad6:	8b 52 50             	mov    0x50(%edx),%edx
  802ad9:	39 ca                	cmp    %ecx,%edx
  802adb:	75 11                	jne    802aee <ipc_find_env+0x2f>
			return envs[i].env_id;
  802add:	89 c2                	mov    %eax,%edx
  802adf:	c1 e2 07             	shl    $0x7,%edx
  802ae2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802ae9:	8b 40 40             	mov    0x40(%eax),%eax
  802aec:	eb 0e                	jmp    802afc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802aee:	83 c0 01             	add    $0x1,%eax
  802af1:	3d 00 04 00 00       	cmp    $0x400,%eax
  802af6:	75 d2                	jne    802aca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802af8:	66 b8 00 00          	mov    $0x0,%ax
}
  802afc:	5d                   	pop    %ebp
  802afd:	c3                   	ret    

00802afe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802afe:	55                   	push   %ebp
  802aff:	89 e5                	mov    %esp,%ebp
  802b01:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b04:	89 d0                	mov    %edx,%eax
  802b06:	c1 e8 16             	shr    $0x16,%eax
  802b09:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b10:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b15:	f6 c1 01             	test   $0x1,%cl
  802b18:	74 1d                	je     802b37 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b1a:	c1 ea 0c             	shr    $0xc,%edx
  802b1d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b24:	f6 c2 01             	test   $0x1,%dl
  802b27:	74 0e                	je     802b37 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b29:	c1 ea 0c             	shr    $0xc,%edx
  802b2c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b33:	ef 
  802b34:	0f b7 c0             	movzwl %ax,%eax
}
  802b37:	5d                   	pop    %ebp
  802b38:	c3                   	ret    
  802b39:	66 90                	xchg   %ax,%ax
  802b3b:	66 90                	xchg   %ax,%ax
  802b3d:	66 90                	xchg   %ax,%ax
  802b3f:	90                   	nop

00802b40 <__udivdi3>:
  802b40:	55                   	push   %ebp
  802b41:	57                   	push   %edi
  802b42:	56                   	push   %esi
  802b43:	83 ec 0c             	sub    $0xc,%esp
  802b46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b56:	85 c0                	test   %eax,%eax
  802b58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b5c:	89 ea                	mov    %ebp,%edx
  802b5e:	89 0c 24             	mov    %ecx,(%esp)
  802b61:	75 2d                	jne    802b90 <__udivdi3+0x50>
  802b63:	39 e9                	cmp    %ebp,%ecx
  802b65:	77 61                	ja     802bc8 <__udivdi3+0x88>
  802b67:	85 c9                	test   %ecx,%ecx
  802b69:	89 ce                	mov    %ecx,%esi
  802b6b:	75 0b                	jne    802b78 <__udivdi3+0x38>
  802b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b72:	31 d2                	xor    %edx,%edx
  802b74:	f7 f1                	div    %ecx
  802b76:	89 c6                	mov    %eax,%esi
  802b78:	31 d2                	xor    %edx,%edx
  802b7a:	89 e8                	mov    %ebp,%eax
  802b7c:	f7 f6                	div    %esi
  802b7e:	89 c5                	mov    %eax,%ebp
  802b80:	89 f8                	mov    %edi,%eax
  802b82:	f7 f6                	div    %esi
  802b84:	89 ea                	mov    %ebp,%edx
  802b86:	83 c4 0c             	add    $0xc,%esp
  802b89:	5e                   	pop    %esi
  802b8a:	5f                   	pop    %edi
  802b8b:	5d                   	pop    %ebp
  802b8c:	c3                   	ret    
  802b8d:	8d 76 00             	lea    0x0(%esi),%esi
  802b90:	39 e8                	cmp    %ebp,%eax
  802b92:	77 24                	ja     802bb8 <__udivdi3+0x78>
  802b94:	0f bd e8             	bsr    %eax,%ebp
  802b97:	83 f5 1f             	xor    $0x1f,%ebp
  802b9a:	75 3c                	jne    802bd8 <__udivdi3+0x98>
  802b9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802ba0:	39 34 24             	cmp    %esi,(%esp)
  802ba3:	0f 86 9f 00 00 00    	jbe    802c48 <__udivdi3+0x108>
  802ba9:	39 d0                	cmp    %edx,%eax
  802bab:	0f 82 97 00 00 00    	jb     802c48 <__udivdi3+0x108>
  802bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	31 d2                	xor    %edx,%edx
  802bba:	31 c0                	xor    %eax,%eax
  802bbc:	83 c4 0c             	add    $0xc,%esp
  802bbf:	5e                   	pop    %esi
  802bc0:	5f                   	pop    %edi
  802bc1:	5d                   	pop    %ebp
  802bc2:	c3                   	ret    
  802bc3:	90                   	nop
  802bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	89 f8                	mov    %edi,%eax
  802bca:	f7 f1                	div    %ecx
  802bcc:	31 d2                	xor    %edx,%edx
  802bce:	83 c4 0c             	add    $0xc,%esp
  802bd1:	5e                   	pop    %esi
  802bd2:	5f                   	pop    %edi
  802bd3:	5d                   	pop    %ebp
  802bd4:	c3                   	ret    
  802bd5:	8d 76 00             	lea    0x0(%esi),%esi
  802bd8:	89 e9                	mov    %ebp,%ecx
  802bda:	8b 3c 24             	mov    (%esp),%edi
  802bdd:	d3 e0                	shl    %cl,%eax
  802bdf:	89 c6                	mov    %eax,%esi
  802be1:	b8 20 00 00 00       	mov    $0x20,%eax
  802be6:	29 e8                	sub    %ebp,%eax
  802be8:	89 c1                	mov    %eax,%ecx
  802bea:	d3 ef                	shr    %cl,%edi
  802bec:	89 e9                	mov    %ebp,%ecx
  802bee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802bf2:	8b 3c 24             	mov    (%esp),%edi
  802bf5:	09 74 24 08          	or     %esi,0x8(%esp)
  802bf9:	89 d6                	mov    %edx,%esi
  802bfb:	d3 e7                	shl    %cl,%edi
  802bfd:	89 c1                	mov    %eax,%ecx
  802bff:	89 3c 24             	mov    %edi,(%esp)
  802c02:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c06:	d3 ee                	shr    %cl,%esi
  802c08:	89 e9                	mov    %ebp,%ecx
  802c0a:	d3 e2                	shl    %cl,%edx
  802c0c:	89 c1                	mov    %eax,%ecx
  802c0e:	d3 ef                	shr    %cl,%edi
  802c10:	09 d7                	or     %edx,%edi
  802c12:	89 f2                	mov    %esi,%edx
  802c14:	89 f8                	mov    %edi,%eax
  802c16:	f7 74 24 08          	divl   0x8(%esp)
  802c1a:	89 d6                	mov    %edx,%esi
  802c1c:	89 c7                	mov    %eax,%edi
  802c1e:	f7 24 24             	mull   (%esp)
  802c21:	39 d6                	cmp    %edx,%esi
  802c23:	89 14 24             	mov    %edx,(%esp)
  802c26:	72 30                	jb     802c58 <__udivdi3+0x118>
  802c28:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c2c:	89 e9                	mov    %ebp,%ecx
  802c2e:	d3 e2                	shl    %cl,%edx
  802c30:	39 c2                	cmp    %eax,%edx
  802c32:	73 05                	jae    802c39 <__udivdi3+0xf9>
  802c34:	3b 34 24             	cmp    (%esp),%esi
  802c37:	74 1f                	je     802c58 <__udivdi3+0x118>
  802c39:	89 f8                	mov    %edi,%eax
  802c3b:	31 d2                	xor    %edx,%edx
  802c3d:	e9 7a ff ff ff       	jmp    802bbc <__udivdi3+0x7c>
  802c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c48:	31 d2                	xor    %edx,%edx
  802c4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c4f:	e9 68 ff ff ff       	jmp    802bbc <__udivdi3+0x7c>
  802c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c58:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c5b:	31 d2                	xor    %edx,%edx
  802c5d:	83 c4 0c             	add    $0xc,%esp
  802c60:	5e                   	pop    %esi
  802c61:	5f                   	pop    %edi
  802c62:	5d                   	pop    %ebp
  802c63:	c3                   	ret    
  802c64:	66 90                	xchg   %ax,%ax
  802c66:	66 90                	xchg   %ax,%ax
  802c68:	66 90                	xchg   %ax,%ax
  802c6a:	66 90                	xchg   %ax,%ax
  802c6c:	66 90                	xchg   %ax,%ax
  802c6e:	66 90                	xchg   %ax,%ax

00802c70 <__umoddi3>:
  802c70:	55                   	push   %ebp
  802c71:	57                   	push   %edi
  802c72:	56                   	push   %esi
  802c73:	83 ec 14             	sub    $0x14,%esp
  802c76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c7a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c7e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c82:	89 c7                	mov    %eax,%edi
  802c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c88:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c8c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c90:	89 34 24             	mov    %esi,(%esp)
  802c93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c97:	85 c0                	test   %eax,%eax
  802c99:	89 c2                	mov    %eax,%edx
  802c9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c9f:	75 17                	jne    802cb8 <__umoddi3+0x48>
  802ca1:	39 fe                	cmp    %edi,%esi
  802ca3:	76 4b                	jbe    802cf0 <__umoddi3+0x80>
  802ca5:	89 c8                	mov    %ecx,%eax
  802ca7:	89 fa                	mov    %edi,%edx
  802ca9:	f7 f6                	div    %esi
  802cab:	89 d0                	mov    %edx,%eax
  802cad:	31 d2                	xor    %edx,%edx
  802caf:	83 c4 14             	add    $0x14,%esp
  802cb2:	5e                   	pop    %esi
  802cb3:	5f                   	pop    %edi
  802cb4:	5d                   	pop    %ebp
  802cb5:	c3                   	ret    
  802cb6:	66 90                	xchg   %ax,%ax
  802cb8:	39 f8                	cmp    %edi,%eax
  802cba:	77 54                	ja     802d10 <__umoddi3+0xa0>
  802cbc:	0f bd e8             	bsr    %eax,%ebp
  802cbf:	83 f5 1f             	xor    $0x1f,%ebp
  802cc2:	75 5c                	jne    802d20 <__umoddi3+0xb0>
  802cc4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802cc8:	39 3c 24             	cmp    %edi,(%esp)
  802ccb:	0f 87 e7 00 00 00    	ja     802db8 <__umoddi3+0x148>
  802cd1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802cd5:	29 f1                	sub    %esi,%ecx
  802cd7:	19 c7                	sbb    %eax,%edi
  802cd9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ce1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ce5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ce9:	83 c4 14             	add    $0x14,%esp
  802cec:	5e                   	pop    %esi
  802ced:	5f                   	pop    %edi
  802cee:	5d                   	pop    %ebp
  802cef:	c3                   	ret    
  802cf0:	85 f6                	test   %esi,%esi
  802cf2:	89 f5                	mov    %esi,%ebp
  802cf4:	75 0b                	jne    802d01 <__umoddi3+0x91>
  802cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  802cfb:	31 d2                	xor    %edx,%edx
  802cfd:	f7 f6                	div    %esi
  802cff:	89 c5                	mov    %eax,%ebp
  802d01:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d05:	31 d2                	xor    %edx,%edx
  802d07:	f7 f5                	div    %ebp
  802d09:	89 c8                	mov    %ecx,%eax
  802d0b:	f7 f5                	div    %ebp
  802d0d:	eb 9c                	jmp    802cab <__umoddi3+0x3b>
  802d0f:	90                   	nop
  802d10:	89 c8                	mov    %ecx,%eax
  802d12:	89 fa                	mov    %edi,%edx
  802d14:	83 c4 14             	add    $0x14,%esp
  802d17:	5e                   	pop    %esi
  802d18:	5f                   	pop    %edi
  802d19:	5d                   	pop    %ebp
  802d1a:	c3                   	ret    
  802d1b:	90                   	nop
  802d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d20:	8b 04 24             	mov    (%esp),%eax
  802d23:	be 20 00 00 00       	mov    $0x20,%esi
  802d28:	89 e9                	mov    %ebp,%ecx
  802d2a:	29 ee                	sub    %ebp,%esi
  802d2c:	d3 e2                	shl    %cl,%edx
  802d2e:	89 f1                	mov    %esi,%ecx
  802d30:	d3 e8                	shr    %cl,%eax
  802d32:	89 e9                	mov    %ebp,%ecx
  802d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d38:	8b 04 24             	mov    (%esp),%eax
  802d3b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d3f:	89 fa                	mov    %edi,%edx
  802d41:	d3 e0                	shl    %cl,%eax
  802d43:	89 f1                	mov    %esi,%ecx
  802d45:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d49:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d4d:	d3 ea                	shr    %cl,%edx
  802d4f:	89 e9                	mov    %ebp,%ecx
  802d51:	d3 e7                	shl    %cl,%edi
  802d53:	89 f1                	mov    %esi,%ecx
  802d55:	d3 e8                	shr    %cl,%eax
  802d57:	89 e9                	mov    %ebp,%ecx
  802d59:	09 f8                	or     %edi,%eax
  802d5b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d5f:	f7 74 24 04          	divl   0x4(%esp)
  802d63:	d3 e7                	shl    %cl,%edi
  802d65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d69:	89 d7                	mov    %edx,%edi
  802d6b:	f7 64 24 08          	mull   0x8(%esp)
  802d6f:	39 d7                	cmp    %edx,%edi
  802d71:	89 c1                	mov    %eax,%ecx
  802d73:	89 14 24             	mov    %edx,(%esp)
  802d76:	72 2c                	jb     802da4 <__umoddi3+0x134>
  802d78:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d7c:	72 22                	jb     802da0 <__umoddi3+0x130>
  802d7e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d82:	29 c8                	sub    %ecx,%eax
  802d84:	19 d7                	sbb    %edx,%edi
  802d86:	89 e9                	mov    %ebp,%ecx
  802d88:	89 fa                	mov    %edi,%edx
  802d8a:	d3 e8                	shr    %cl,%eax
  802d8c:	89 f1                	mov    %esi,%ecx
  802d8e:	d3 e2                	shl    %cl,%edx
  802d90:	89 e9                	mov    %ebp,%ecx
  802d92:	d3 ef                	shr    %cl,%edi
  802d94:	09 d0                	or     %edx,%eax
  802d96:	89 fa                	mov    %edi,%edx
  802d98:	83 c4 14             	add    $0x14,%esp
  802d9b:	5e                   	pop    %esi
  802d9c:	5f                   	pop    %edi
  802d9d:	5d                   	pop    %ebp
  802d9e:	c3                   	ret    
  802d9f:	90                   	nop
  802da0:	39 d7                	cmp    %edx,%edi
  802da2:	75 da                	jne    802d7e <__umoddi3+0x10e>
  802da4:	8b 14 24             	mov    (%esp),%edx
  802da7:	89 c1                	mov    %eax,%ecx
  802da9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802dad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802db1:	eb cb                	jmp    802d7e <__umoddi3+0x10e>
  802db3:	90                   	nop
  802db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802db8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802dbc:	0f 82 0f ff ff ff    	jb     802cd1 <__umoddi3+0x61>
  802dc2:	e9 1a ff ff ff       	jmp    802ce1 <__umoddi3+0x71>
