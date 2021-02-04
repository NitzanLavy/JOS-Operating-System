
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 e4 02 00 00       	call   800315 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 40 80 00 80 	movl   $0x802e80,0x804004
  800042:	2e 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 f4 25 00 00       	call   802644 <pipe>
  800050:	89 c6                	mov    %eax,%esi
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("pipe: %e", i);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 8c 2e 80 	movl   $0x802e8c,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  800071:	e8 04 03 00 00       	call   80037a <_panic>

	if ((pid = fork()) < 0)
  800076:	e8 8f 13 00 00       	call   80140a <fork>
  80007b:	89 c3                	mov    %eax,%ebx
  80007d:	85 c0                	test   %eax,%eax
  80007f:	79 20                	jns    8000a1 <umain+0x6e>
		panic("fork: %e", i);
  800081:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800085:	c7 44 24 08 a5 2e 80 	movl   $0x802ea5,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  80009c:	e8 d9 02 00 00       	call   80037a <_panic>

	if (pid == 0) {
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 d5 00 00 00    	jne    80017e <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  8000a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8000ae:	8b 40 48             	mov    0x48(%eax),%eax
  8000b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bc:	c7 04 24 ae 2e 80 00 	movl   $0x802eae,(%esp)
  8000c3:	e8 ab 03 00 00       	call   800473 <cprintf>
		close(p[1]);
  8000c8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 b4 17 00 00       	call   801887 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d3:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d8:	8b 40 48             	mov    0x48(%eax),%eax
  8000db:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e6:	c7 04 24 cb 2e 80 00 	movl   $0x802ecb,(%esp)
  8000ed:	e8 81 03 00 00       	call   800473 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f2:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000f9:	00 
  8000fa:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800104:	89 04 24             	mov    %eax,(%esp)
  800107:	e8 70 19 00 00       	call   801a7c <readn>
  80010c:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010e:	85 c0                	test   %eax,%eax
  800110:	79 20                	jns    800132 <umain+0xff>
			panic("read: %e", i);
  800112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800116:	c7 44 24 08 e8 2e 80 	movl   $0x802ee8,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  80012d:	e8 48 02 00 00       	call   80037a <_panic>
		buf[i] = 0;
  800132:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800137:	a1 00 40 80 00       	mov    0x804000,%eax
  80013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800140:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800143:	89 04 24             	mov    %eax,(%esp)
  800146:	e8 01 0a 00 00       	call   800b4c <strcmp>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	75 0e                	jne    80015d <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  80014f:	c7 04 24 f1 2e 80 00 	movl   $0x802ef1,(%esp)
  800156:	e8 18 03 00 00       	call   800473 <cprintf>
  80015b:	eb 17                	jmp    800174 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015d:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800160:	89 44 24 08          	mov    %eax,0x8(%esp)
  800164:	89 74 24 04          	mov    %esi,0x4(%esp)
  800168:	c7 04 24 0d 2f 80 00 	movl   $0x802f0d,(%esp)
  80016f:	e8 ff 02 00 00       	call   800473 <cprintf>
		exit();
  800174:	e8 e8 01 00 00       	call   800361 <exit>
  800179:	e9 ac 00 00 00       	jmp    80022a <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80017e:	a1 08 50 80 00       	mov    0x805008,%eax
  800183:	8b 40 48             	mov    0x48(%eax),%eax
  800186:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800189:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800191:	c7 04 24 ae 2e 80 00 	movl   $0x802eae,(%esp)
  800198:	e8 d6 02 00 00       	call   800473 <cprintf>
		close(p[0]);
  80019d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 df 16 00 00       	call   801887 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001a8:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ad:	8b 40 48             	mov    0x48(%eax),%eax
  8001b0:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bb:	c7 04 24 20 2f 80 00 	movl   $0x802f20,(%esp)
  8001c2:	e8 ac 02 00 00       	call   800473 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8001cc:	89 04 24             	mov    %eax,(%esp)
  8001cf:	e8 8c 08 00 00       	call   800a60 <strlen>
  8001d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 db 18 00 00       	call   801ac7 <write>
  8001ec:	89 c6                	mov    %eax,%esi
  8001ee:	a1 00 40 80 00       	mov    0x804000,%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 65 08 00 00       	call   800a60 <strlen>
  8001fb:	39 c6                	cmp    %eax,%esi
  8001fd:	74 20                	je     80021f <umain+0x1ec>
			panic("write: %e", i);
  8001ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800203:	c7 44 24 08 3d 2f 80 	movl   $0x802f3d,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800212:	00 
  800213:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  80021a:	e8 5b 01 00 00       	call   80037a <_panic>
		close(p[1]);
  80021f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800222:	89 04 24             	mov    %eax,(%esp)
  800225:	e8 5d 16 00 00       	call   801887 <close>
	}
	wait(pid);
  80022a:	89 1c 24             	mov    %ebx,(%esp)
  80022d:	e8 b8 25 00 00       	call   8027ea <wait>

	binaryname = "pipewriteeof";
  800232:	c7 05 04 40 80 00 47 	movl   $0x802f47,0x804004
  800239:	2f 80 00 
	if ((i = pipe(p)) < 0)
  80023c:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80023f:	89 04 24             	mov    %eax,(%esp)
  800242:	e8 fd 23 00 00       	call   802644 <pipe>
  800247:	89 c6                	mov    %eax,%esi
  800249:	85 c0                	test   %eax,%eax
  80024b:	79 20                	jns    80026d <umain+0x23a>
		panic("pipe: %e", i);
  80024d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800251:	c7 44 24 08 8c 2e 80 	movl   $0x802e8c,0x8(%esp)
  800258:	00 
  800259:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800260:	00 
  800261:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  800268:	e8 0d 01 00 00       	call   80037a <_panic>

	if ((pid = fork()) < 0)
  80026d:	e8 98 11 00 00       	call   80140a <fork>
  800272:	89 c3                	mov    %eax,%ebx
  800274:	85 c0                	test   %eax,%eax
  800276:	79 20                	jns    800298 <umain+0x265>
		panic("fork: %e", i);
  800278:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027c:	c7 44 24 08 a5 2e 80 	movl   $0x802ea5,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  800293:	e8 e2 00 00 00       	call   80037a <_panic>

	if (pid == 0) {
  800298:	85 c0                	test   %eax,%eax
  80029a:	75 48                	jne    8002e4 <umain+0x2b1>
		close(p[0]);
  80029c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	e8 e0 15 00 00       	call   801887 <close>
		while (1) {
			cprintf(".");
  8002a7:	c7 04 24 54 2f 80 00 	movl   $0x802f54,(%esp)
  8002ae:	e8 c0 01 00 00       	call   800473 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002ba:	00 
  8002bb:	c7 44 24 04 56 2f 80 	movl   $0x802f56,0x4(%esp)
  8002c2:	00 
  8002c3:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002c6:	89 14 24             	mov    %edx,(%esp)
  8002c9:	e8 f9 17 00 00       	call   801ac7 <write>
  8002ce:	83 f8 01             	cmp    $0x1,%eax
  8002d1:	74 d4                	je     8002a7 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d3:	c7 04 24 58 2f 80 00 	movl   $0x802f58,(%esp)
  8002da:	e8 94 01 00 00       	call   800473 <cprintf>
		exit();
  8002df:	e8 7d 00 00 00       	call   800361 <exit>
	}
	close(p[0]);
  8002e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e7:	89 04 24             	mov    %eax,(%esp)
  8002ea:	e8 98 15 00 00       	call   801887 <close>
	close(p[1]);
  8002ef:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	e8 8d 15 00 00       	call   801887 <close>
	wait(pid);
  8002fa:	89 1c 24             	mov    %ebx,(%esp)
  8002fd:	e8 e8 24 00 00       	call   8027ea <wait>

	cprintf("pipe tests passed\n");
  800302:	c7 04 24 75 2f 80 00 	movl   $0x802f75,(%esp)
  800309:	e8 65 01 00 00       	call   800473 <cprintf>
}
  80030e:	83 ec 80             	sub    $0xffffff80,%esp
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 10             	sub    $0x10,%esp
  80031d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800320:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800323:	e8 4d 0b 00 00       	call   800e75 <sys_getenvid>
  800328:	25 ff 03 00 00       	and    $0x3ff,%eax
  80032d:	89 c2                	mov    %eax,%edx
  80032f:	c1 e2 07             	shl    $0x7,%edx
  800332:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800339:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033e:	85 db                	test   %ebx,%ebx
  800340:	7e 07                	jle    800349 <libmain+0x34>
		binaryname = argv[0];
  800342:	8b 06                	mov    (%esi),%eax
  800344:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800349:	89 74 24 04          	mov    %esi,0x4(%esp)
  80034d:	89 1c 24             	mov    %ebx,(%esp)
  800350:	e8 de fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800355:	e8 07 00 00 00       	call   800361 <exit>
}
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	5b                   	pop    %ebx
  80035e:	5e                   	pop    %esi
  80035f:	5d                   	pop    %ebp
  800360:	c3                   	ret    

00800361 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800367:	e8 4e 15 00 00       	call   8018ba <close_all>
	sys_env_destroy(0);
  80036c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800373:	e8 ab 0a 00 00       	call   800e23 <sys_env_destroy>
}
  800378:	c9                   	leave  
  800379:	c3                   	ret    

0080037a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	56                   	push   %esi
  80037e:	53                   	push   %ebx
  80037f:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800382:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800385:	8b 35 04 40 80 00    	mov    0x804004,%esi
  80038b:	e8 e5 0a 00 00       	call   800e75 <sys_getenvid>
  800390:	8b 55 0c             	mov    0xc(%ebp),%edx
  800393:	89 54 24 10          	mov    %edx,0x10(%esp)
  800397:	8b 55 08             	mov    0x8(%ebp),%edx
  80039a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80039e:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a6:	c7 04 24 d8 2f 80 00 	movl   $0x802fd8,(%esp)
  8003ad:	e8 c1 00 00 00       	call   800473 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b9:	89 04 24             	mov    %eax,(%esp)
  8003bc:	e8 51 00 00 00       	call   800412 <vcprintf>
	cprintf("\n");
  8003c1:	c7 04 24 c9 2e 80 00 	movl   $0x802ec9,(%esp)
  8003c8:	e8 a6 00 00 00       	call   800473 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003cd:	cc                   	int3   
  8003ce:	eb fd                	jmp    8003cd <_panic+0x53>

008003d0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 14             	sub    $0x14,%esp
  8003d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003da:	8b 13                	mov    (%ebx),%edx
  8003dc:	8d 42 01             	lea    0x1(%edx),%eax
  8003df:	89 03                	mov    %eax,(%ebx)
  8003e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ed:	75 19                	jne    800408 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003ef:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003f6:	00 
  8003f7:	8d 43 08             	lea    0x8(%ebx),%eax
  8003fa:	89 04 24             	mov    %eax,(%esp)
  8003fd:	e8 e4 09 00 00       	call   800de6 <sys_cputs>
		b->idx = 0;
  800402:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800408:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80040c:	83 c4 14             	add    $0x14,%esp
  80040f:	5b                   	pop    %ebx
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80041b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800422:	00 00 00 
	b.cnt = 0;
  800425:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80042c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	89 44 24 08          	mov    %eax,0x8(%esp)
  80043d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800443:	89 44 24 04          	mov    %eax,0x4(%esp)
  800447:	c7 04 24 d0 03 80 00 	movl   $0x8003d0,(%esp)
  80044e:	e8 ab 01 00 00       	call   8005fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800453:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800463:	89 04 24             	mov    %eax,(%esp)
  800466:	e8 7b 09 00 00       	call   800de6 <sys_cputs>

	return b.cnt;
}
  80046b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800479:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80047c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	89 04 24             	mov    %eax,(%esp)
  800486:	e8 87 ff ff ff       	call   800412 <vcprintf>
	va_end(ap);

	return cnt;
}
  80048b:	c9                   	leave  
  80048c:	c3                   	ret    
  80048d:	66 90                	xchg   %ax,%ax
  80048f:	90                   	nop

00800490 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	57                   	push   %edi
  800494:	56                   	push   %esi
  800495:	53                   	push   %ebx
  800496:	83 ec 3c             	sub    $0x3c,%esp
  800499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80049c:	89 d7                	mov    %edx,%edi
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	89 c3                	mov    %eax,%ebx
  8004a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8004af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004bd:	39 d9                	cmp    %ebx,%ecx
  8004bf:	72 05                	jb     8004c6 <printnum+0x36>
  8004c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004c4:	77 69                	ja     80052f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004cd:	83 ee 01             	sub    $0x1,%esi
  8004d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004e0:	89 c3                	mov    %eax,%ebx
  8004e2:	89 d6                	mov    %edx,%esi
  8004e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f5:	89 04 24             	mov    %eax,(%esp)
  8004f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ff:	e8 ec 26 00 00       	call   802bf0 <__udivdi3>
  800504:	89 d9                	mov    %ebx,%ecx
  800506:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80050a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	89 54 24 04          	mov    %edx,0x4(%esp)
  800515:	89 fa                	mov    %edi,%edx
  800517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80051a:	e8 71 ff ff ff       	call   800490 <printnum>
  80051f:	eb 1b                	jmp    80053c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800521:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800525:	8b 45 18             	mov    0x18(%ebp),%eax
  800528:	89 04 24             	mov    %eax,(%esp)
  80052b:	ff d3                	call   *%ebx
  80052d:	eb 03                	jmp    800532 <printnum+0xa2>
  80052f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800532:	83 ee 01             	sub    $0x1,%esi
  800535:	85 f6                	test   %esi,%esi
  800537:	7f e8                	jg     800521 <printnum+0x91>
  800539:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800540:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800544:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800547:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80054a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80054e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800552:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800555:	89 04 24             	mov    %eax,(%esp)
  800558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80055b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055f:	e8 bc 27 00 00       	call   802d20 <__umoddi3>
  800564:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800568:	0f be 80 fb 2f 80 00 	movsbl 0x802ffb(%eax),%eax
  80056f:	89 04 24             	mov    %eax,(%esp)
  800572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800575:	ff d0                	call   *%eax
}
  800577:	83 c4 3c             	add    $0x3c,%esp
  80057a:	5b                   	pop    %ebx
  80057b:	5e                   	pop    %esi
  80057c:	5f                   	pop    %edi
  80057d:	5d                   	pop    %ebp
  80057e:	c3                   	ret    

0080057f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800582:	83 fa 01             	cmp    $0x1,%edx
  800585:	7e 0e                	jle    800595 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800587:	8b 10                	mov    (%eax),%edx
  800589:	8d 4a 08             	lea    0x8(%edx),%ecx
  80058c:	89 08                	mov    %ecx,(%eax)
  80058e:	8b 02                	mov    (%edx),%eax
  800590:	8b 52 04             	mov    0x4(%edx),%edx
  800593:	eb 22                	jmp    8005b7 <getuint+0x38>
	else if (lflag)
  800595:	85 d2                	test   %edx,%edx
  800597:	74 10                	je     8005a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80059e:	89 08                	mov    %ecx,(%eax)
  8005a0:	8b 02                	mov    (%edx),%eax
  8005a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a7:	eb 0e                	jmp    8005b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ae:	89 08                	mov    %ecx,(%eax)
  8005b0:	8b 02                	mov    (%edx),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005b7:	5d                   	pop    %ebp
  8005b8:	c3                   	ret    

008005b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b9:	55                   	push   %ebp
  8005ba:	89 e5                	mov    %esp,%ebp
  8005bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c3:	8b 10                	mov    (%eax),%edx
  8005c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c8:	73 0a                	jae    8005d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005cd:	89 08                	mov    %ecx,(%eax)
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	88 02                	mov    %al,(%edx)
}
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    

008005d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	89 04 24             	mov    %eax,(%esp)
  8005f7:	e8 02 00 00 00       	call   8005fe <vprintfmt>
	va_end(ap);
}
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	57                   	push   %edi
  800602:	56                   	push   %esi
  800603:	53                   	push   %ebx
  800604:	83 ec 3c             	sub    $0x3c,%esp
  800607:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80060a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80060d:	eb 14                	jmp    800623 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80060f:	85 c0                	test   %eax,%eax
  800611:	0f 84 b3 03 00 00    	je     8009ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800617:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80061b:	89 04 24             	mov    %eax,(%esp)
  80061e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800621:	89 f3                	mov    %esi,%ebx
  800623:	8d 73 01             	lea    0x1(%ebx),%esi
  800626:	0f b6 03             	movzbl (%ebx),%eax
  800629:	83 f8 25             	cmp    $0x25,%eax
  80062c:	75 e1                	jne    80060f <vprintfmt+0x11>
  80062e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800632:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800639:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800640:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800647:	ba 00 00 00 00       	mov    $0x0,%edx
  80064c:	eb 1d                	jmp    80066b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80064e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800650:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800654:	eb 15                	jmp    80066b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800656:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800658:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80065c:	eb 0d                	jmp    80066b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800661:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800664:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80066e:	0f b6 0e             	movzbl (%esi),%ecx
  800671:	0f b6 c1             	movzbl %cl,%eax
  800674:	83 e9 23             	sub    $0x23,%ecx
  800677:	80 f9 55             	cmp    $0x55,%cl
  80067a:	0f 87 2a 03 00 00    	ja     8009aa <vprintfmt+0x3ac>
  800680:	0f b6 c9             	movzbl %cl,%ecx
  800683:	ff 24 8d 80 31 80 00 	jmp    *0x803180(,%ecx,4)
  80068a:	89 de                	mov    %ebx,%esi
  80068c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800691:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800694:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800698:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80069b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80069e:	83 fb 09             	cmp    $0x9,%ebx
  8006a1:	77 36                	ja     8006d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006a6:	eb e9                	jmp    800691 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8006ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006b8:	eb 22                	jmp    8006dc <vprintfmt+0xde>
  8006ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bd:	85 c9                	test   %ecx,%ecx
  8006bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c4:	0f 49 c1             	cmovns %ecx,%eax
  8006c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ca:	89 de                	mov    %ebx,%esi
  8006cc:	eb 9d                	jmp    80066b <vprintfmt+0x6d>
  8006ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8006d7:	eb 92                	jmp    80066b <vprintfmt+0x6d>
  8006d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8006dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006e0:	79 89                	jns    80066b <vprintfmt+0x6d>
  8006e2:	e9 77 ff ff ff       	jmp    80065e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006ec:	e9 7a ff ff ff       	jmp    80066b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8d 50 04             	lea    0x4(%eax),%edx
  8006f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8006fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	89 04 24             	mov    %eax,(%esp)
  800703:	ff 55 08             	call   *0x8(%ebp)
			break;
  800706:	e9 18 ff ff ff       	jmp    800623 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 50 04             	lea    0x4(%eax),%edx
  800711:	89 55 14             	mov    %edx,0x14(%ebp)
  800714:	8b 00                	mov    (%eax),%eax
  800716:	99                   	cltd   
  800717:	31 d0                	xor    %edx,%eax
  800719:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80071b:	83 f8 12             	cmp    $0x12,%eax
  80071e:	7f 0b                	jg     80072b <vprintfmt+0x12d>
  800720:	8b 14 85 e0 32 80 00 	mov    0x8032e0(,%eax,4),%edx
  800727:	85 d2                	test   %edx,%edx
  800729:	75 20                	jne    80074b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80072b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072f:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  800736:	00 
  800737:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	89 04 24             	mov    %eax,(%esp)
  800741:	e8 90 fe ff ff       	call   8005d6 <printfmt>
  800746:	e9 d8 fe ff ff       	jmp    800623 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80074b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80074f:	c7 44 24 08 15 35 80 	movl   $0x803515,0x8(%esp)
  800756:	00 
  800757:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	e8 70 fe ff ff       	call   8005d6 <printfmt>
  800766:	e9 b8 fe ff ff       	jmp    800623 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80076e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800771:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 50 04             	lea    0x4(%eax),%edx
  80077a:	89 55 14             	mov    %edx,0x14(%ebp)
  80077d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80077f:	85 f6                	test   %esi,%esi
  800781:	b8 0c 30 80 00       	mov    $0x80300c,%eax
  800786:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800789:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80078d:	0f 84 97 00 00 00    	je     80082a <vprintfmt+0x22c>
  800793:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800797:	0f 8e 9b 00 00 00    	jle    800838 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80079d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007a1:	89 34 24             	mov    %esi,(%esp)
  8007a4:	e8 cf 02 00 00       	call   800a78 <strnlen>
  8007a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007ac:	29 c2                	sub    %eax,%edx
  8007ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c3:	eb 0f                	jmp    8007d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cc:	89 04 24             	mov    %eax,(%esp)
  8007cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d1:	83 eb 01             	sub    $0x1,%ebx
  8007d4:	85 db                	test   %ebx,%ebx
  8007d6:	7f ed                	jg     8007c5 <vprintfmt+0x1c7>
  8007d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007de:	85 d2                	test   %edx,%edx
  8007e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e5:	0f 49 c2             	cmovns %edx,%eax
  8007e8:	29 c2                	sub    %eax,%edx
  8007ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007ed:	89 d7                	mov    %edx,%edi
  8007ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007f2:	eb 50                	jmp    800844 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007f8:	74 1e                	je     800818 <vprintfmt+0x21a>
  8007fa:	0f be d2             	movsbl %dl,%edx
  8007fd:	83 ea 20             	sub    $0x20,%edx
  800800:	83 fa 5e             	cmp    $0x5e,%edx
  800803:	76 13                	jbe    800818 <vprintfmt+0x21a>
					putch('?', putdat);
  800805:	8b 45 0c             	mov    0xc(%ebp),%eax
  800808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800813:	ff 55 08             	call   *0x8(%ebp)
  800816:	eb 0d                	jmp    800825 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80081f:	89 04 24             	mov    %eax,(%esp)
  800822:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800825:	83 ef 01             	sub    $0x1,%edi
  800828:	eb 1a                	jmp    800844 <vprintfmt+0x246>
  80082a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80082d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800830:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800833:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800836:	eb 0c                	jmp    800844 <vprintfmt+0x246>
  800838:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80083b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80083e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800841:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800844:	83 c6 01             	add    $0x1,%esi
  800847:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80084b:	0f be c2             	movsbl %dl,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	74 27                	je     800879 <vprintfmt+0x27b>
  800852:	85 db                	test   %ebx,%ebx
  800854:	78 9e                	js     8007f4 <vprintfmt+0x1f6>
  800856:	83 eb 01             	sub    $0x1,%ebx
  800859:	79 99                	jns    8007f4 <vprintfmt+0x1f6>
  80085b:	89 f8                	mov    %edi,%eax
  80085d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800860:	8b 75 08             	mov    0x8(%ebp),%esi
  800863:	89 c3                	mov    %eax,%ebx
  800865:	eb 1a                	jmp    800881 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800867:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80086b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800872:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800874:	83 eb 01             	sub    $0x1,%ebx
  800877:	eb 08                	jmp    800881 <vprintfmt+0x283>
  800879:	89 fb                	mov    %edi,%ebx
  80087b:	8b 75 08             	mov    0x8(%ebp),%esi
  80087e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800881:	85 db                	test   %ebx,%ebx
  800883:	7f e2                	jg     800867 <vprintfmt+0x269>
  800885:	89 75 08             	mov    %esi,0x8(%ebp)
  800888:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80088b:	e9 93 fd ff ff       	jmp    800623 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800890:	83 fa 01             	cmp    $0x1,%edx
  800893:	7e 16                	jle    8008ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8d 50 08             	lea    0x8(%eax),%edx
  80089b:	89 55 14             	mov    %edx,0x14(%ebp)
  80089e:	8b 50 04             	mov    0x4(%eax),%edx
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008a9:	eb 32                	jmp    8008dd <vprintfmt+0x2df>
	else if (lflag)
  8008ab:	85 d2                	test   %edx,%edx
  8008ad:	74 18                	je     8008c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	8d 50 04             	lea    0x4(%eax),%edx
  8008b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008b8:	8b 30                	mov    (%eax),%esi
  8008ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008bd:	89 f0                	mov    %esi,%eax
  8008bf:	c1 f8 1f             	sar    $0x1f,%eax
  8008c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c5:	eb 16                	jmp    8008dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8d 50 04             	lea    0x4(%eax),%edx
  8008cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d0:	8b 30                	mov    (%eax),%esi
  8008d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008d5:	89 f0                	mov    %esi,%eax
  8008d7:	c1 f8 1f             	sar    $0x1f,%eax
  8008da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	0f 89 80 00 00 00    	jns    800972 <vprintfmt+0x374>
				putch('-', putdat);
  8008f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800906:	f7 d8                	neg    %eax
  800908:	83 d2 00             	adc    $0x0,%edx
  80090b:	f7 da                	neg    %edx
			}
			base = 10;
  80090d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800912:	eb 5e                	jmp    800972 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800914:	8d 45 14             	lea    0x14(%ebp),%eax
  800917:	e8 63 fc ff ff       	call   80057f <getuint>
			base = 10;
  80091c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800921:	eb 4f                	jmp    800972 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800923:	8d 45 14             	lea    0x14(%ebp),%eax
  800926:	e8 54 fc ff ff       	call   80057f <getuint>
			base = 8;
  80092b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800930:	eb 40                	jmp    800972 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800932:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800936:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80093d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800940:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800944:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80094b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800957:	8b 00                	mov    (%eax),%eax
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80095e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800963:	eb 0d                	jmp    800972 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800965:	8d 45 14             	lea    0x14(%ebp),%eax
  800968:	e8 12 fc ff ff       	call   80057f <getuint>
			base = 16;
  80096d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800972:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800976:	89 74 24 10          	mov    %esi,0x10(%esp)
  80097a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80097d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800981:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800985:	89 04 24             	mov    %eax,(%esp)
  800988:	89 54 24 04          	mov    %edx,0x4(%esp)
  80098c:	89 fa                	mov    %edi,%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	e8 fa fa ff ff       	call   800490 <printnum>
			break;
  800996:	e9 88 fc ff ff       	jmp    800623 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80099b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80099f:	89 04 24             	mov    %eax,(%esp)
  8009a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009a5:	e9 79 fc ff ff       	jmp    800623 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b8:	89 f3                	mov    %esi,%ebx
  8009ba:	eb 03                	jmp    8009bf <vprintfmt+0x3c1>
  8009bc:	83 eb 01             	sub    $0x1,%ebx
  8009bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009c3:	75 f7                	jne    8009bc <vprintfmt+0x3be>
  8009c5:	e9 59 fc ff ff       	jmp    800623 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009ca:	83 c4 3c             	add    $0x3c,%esp
  8009cd:	5b                   	pop    %ebx
  8009ce:	5e                   	pop    %esi
  8009cf:	5f                   	pop    %edi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 28             	sub    $0x28,%esp
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ef:	85 c0                	test   %eax,%eax
  8009f1:	74 30                	je     800a23 <vsnprintf+0x51>
  8009f3:	85 d2                	test   %edx,%edx
  8009f5:	7e 2c                	jle    800a23 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800a01:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a08:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a0c:	c7 04 24 b9 05 80 00 	movl   $0x8005b9,(%esp)
  800a13:	e8 e6 fb ff ff       	call   8005fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a21:	eb 05                	jmp    800a28 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a30:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a37:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	89 04 24             	mov    %eax,(%esp)
  800a4b:	e8 82 ff ff ff       	call   8009d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a50:	c9                   	leave  
  800a51:	c3                   	ret    
  800a52:	66 90                	xchg   %ax,%ax
  800a54:	66 90                	xchg   %ax,%ax
  800a56:	66 90                	xchg   %ax,%ax
  800a58:	66 90                	xchg   %ax,%ax
  800a5a:	66 90                	xchg   %ax,%ax
  800a5c:	66 90                	xchg   %ax,%ax
  800a5e:	66 90                	xchg   %ax,%ax

00800a60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a66:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6b:	eb 03                	jmp    800a70 <strlen+0x10>
		n++;
  800a6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a74:	75 f7                	jne    800a6d <strlen+0xd>
		n++;
	return n;
}
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a81:	b8 00 00 00 00       	mov    $0x0,%eax
  800a86:	eb 03                	jmp    800a8b <strnlen+0x13>
		n++;
  800a88:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8b:	39 d0                	cmp    %edx,%eax
  800a8d:	74 06                	je     800a95 <strnlen+0x1d>
  800a8f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a93:	75 f3                	jne    800a88 <strnlen+0x10>
		n++;
	return n;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	83 c1 01             	add    $0x1,%ecx
  800aa9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800aad:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab0:	84 db                	test   %bl,%bl
  800ab2:	75 ef                	jne    800aa3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ab4:	5b                   	pop    %ebx
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	53                   	push   %ebx
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac1:	89 1c 24             	mov    %ebx,(%esp)
  800ac4:	e8 97 ff ff ff       	call   800a60 <strlen>
	strcpy(dst + len, src);
  800ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ad0:	01 d8                	add    %ebx,%eax
  800ad2:	89 04 24             	mov    %eax,(%esp)
  800ad5:	e8 bd ff ff ff       	call   800a97 <strcpy>
	return dst;
}
  800ada:	89 d8                	mov    %ebx,%eax
  800adc:	83 c4 08             	add    $0x8,%esp
  800adf:	5b                   	pop    %ebx
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	56                   	push   %esi
  800ae6:	53                   	push   %ebx
  800ae7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aed:	89 f3                	mov    %esi,%ebx
  800aef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af2:	89 f2                	mov    %esi,%edx
  800af4:	eb 0f                	jmp    800b05 <strncpy+0x23>
		*dst++ = *src;
  800af6:	83 c2 01             	add    $0x1,%edx
  800af9:	0f b6 01             	movzbl (%ecx),%eax
  800afc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aff:	80 39 01             	cmpb   $0x1,(%ecx)
  800b02:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b05:	39 da                	cmp    %ebx,%edx
  800b07:	75 ed                	jne    800af6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b09:	89 f0                	mov    %esi,%eax
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	56                   	push   %esi
  800b13:	53                   	push   %ebx
  800b14:	8b 75 08             	mov    0x8(%ebp),%esi
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b1d:	89 f0                	mov    %esi,%eax
  800b1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b23:	85 c9                	test   %ecx,%ecx
  800b25:	75 0b                	jne    800b32 <strlcpy+0x23>
  800b27:	eb 1d                	jmp    800b46 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b29:	83 c0 01             	add    $0x1,%eax
  800b2c:	83 c2 01             	add    $0x1,%edx
  800b2f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b32:	39 d8                	cmp    %ebx,%eax
  800b34:	74 0b                	je     800b41 <strlcpy+0x32>
  800b36:	0f b6 0a             	movzbl (%edx),%ecx
  800b39:	84 c9                	test   %cl,%cl
  800b3b:	75 ec                	jne    800b29 <strlcpy+0x1a>
  800b3d:	89 c2                	mov    %eax,%edx
  800b3f:	eb 02                	jmp    800b43 <strlcpy+0x34>
  800b41:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b43:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b46:	29 f0                	sub    %esi,%eax
}
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b55:	eb 06                	jmp    800b5d <strcmp+0x11>
		p++, q++;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b5d:	0f b6 01             	movzbl (%ecx),%eax
  800b60:	84 c0                	test   %al,%al
  800b62:	74 04                	je     800b68 <strcmp+0x1c>
  800b64:	3a 02                	cmp    (%edx),%al
  800b66:	74 ef                	je     800b57 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b68:	0f b6 c0             	movzbl %al,%eax
  800b6b:	0f b6 12             	movzbl (%edx),%edx
  800b6e:	29 d0                	sub    %edx,%eax
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	89 c3                	mov    %eax,%ebx
  800b7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b81:	eb 06                	jmp    800b89 <strncmp+0x17>
		n--, p++, q++;
  800b83:	83 c0 01             	add    $0x1,%eax
  800b86:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b89:	39 d8                	cmp    %ebx,%eax
  800b8b:	74 15                	je     800ba2 <strncmp+0x30>
  800b8d:	0f b6 08             	movzbl (%eax),%ecx
  800b90:	84 c9                	test   %cl,%cl
  800b92:	74 04                	je     800b98 <strncmp+0x26>
  800b94:	3a 0a                	cmp    (%edx),%cl
  800b96:	74 eb                	je     800b83 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b98:	0f b6 00             	movzbl (%eax),%eax
  800b9b:	0f b6 12             	movzbl (%edx),%edx
  800b9e:	29 d0                	sub    %edx,%eax
  800ba0:	eb 05                	jmp    800ba7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bb4:	eb 07                	jmp    800bbd <strchr+0x13>
		if (*s == c)
  800bb6:	38 ca                	cmp    %cl,%dl
  800bb8:	74 0f                	je     800bc9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	0f b6 10             	movzbl (%eax),%edx
  800bc0:	84 d2                	test   %dl,%dl
  800bc2:	75 f2                	jne    800bb6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd5:	eb 07                	jmp    800bde <strfind+0x13>
		if (*s == c)
  800bd7:	38 ca                	cmp    %cl,%dl
  800bd9:	74 0a                	je     800be5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bdb:	83 c0 01             	add    $0x1,%eax
  800bde:	0f b6 10             	movzbl (%eax),%edx
  800be1:	84 d2                	test   %dl,%dl
  800be3:	75 f2                	jne    800bd7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf3:	85 c9                	test   %ecx,%ecx
  800bf5:	74 36                	je     800c2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bf7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bfd:	75 28                	jne    800c27 <memset+0x40>
  800bff:	f6 c1 03             	test   $0x3,%cl
  800c02:	75 23                	jne    800c27 <memset+0x40>
		c &= 0xFF;
  800c04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c08:	89 d3                	mov    %edx,%ebx
  800c0a:	c1 e3 08             	shl    $0x8,%ebx
  800c0d:	89 d6                	mov    %edx,%esi
  800c0f:	c1 e6 18             	shl    $0x18,%esi
  800c12:	89 d0                	mov    %edx,%eax
  800c14:	c1 e0 10             	shl    $0x10,%eax
  800c17:	09 f0                	or     %esi,%eax
  800c19:	09 c2                	or     %eax,%edx
  800c1b:	89 d0                	mov    %edx,%eax
  800c1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c22:	fc                   	cld    
  800c23:	f3 ab                	rep stos %eax,%es:(%edi)
  800c25:	eb 06                	jmp    800c2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	fc                   	cld    
  800c2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2d:	89 f8                	mov    %edi,%eax
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c42:	39 c6                	cmp    %eax,%esi
  800c44:	73 35                	jae    800c7b <memmove+0x47>
  800c46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c49:	39 d0                	cmp    %edx,%eax
  800c4b:	73 2e                	jae    800c7b <memmove+0x47>
		s += n;
		d += n;
  800c4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c50:	89 d6                	mov    %edx,%esi
  800c52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5a:	75 13                	jne    800c6f <memmove+0x3b>
  800c5c:	f6 c1 03             	test   $0x3,%cl
  800c5f:	75 0e                	jne    800c6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c61:	83 ef 04             	sub    $0x4,%edi
  800c64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c6a:	fd                   	std    
  800c6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6d:	eb 09                	jmp    800c78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c6f:	83 ef 01             	sub    $0x1,%edi
  800c72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c75:	fd                   	std    
  800c76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c78:	fc                   	cld    
  800c79:	eb 1d                	jmp    800c98 <memmove+0x64>
  800c7b:	89 f2                	mov    %esi,%edx
  800c7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c7f:	f6 c2 03             	test   $0x3,%dl
  800c82:	75 0f                	jne    800c93 <memmove+0x5f>
  800c84:	f6 c1 03             	test   $0x3,%cl
  800c87:	75 0a                	jne    800c93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c8c:	89 c7                	mov    %eax,%edi
  800c8e:	fc                   	cld    
  800c8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c91:	eb 05                	jmp    800c98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c93:	89 c7                	mov    %eax,%edi
  800c95:	fc                   	cld    
  800c96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 04 24             	mov    %eax,(%esp)
  800cb6:	e8 79 ff ff ff       	call   800c34 <memmove>
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc8:	89 d6                	mov    %edx,%esi
  800cca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ccd:	eb 1a                	jmp    800ce9 <memcmp+0x2c>
		if (*s1 != *s2)
  800ccf:	0f b6 02             	movzbl (%edx),%eax
  800cd2:	0f b6 19             	movzbl (%ecx),%ebx
  800cd5:	38 d8                	cmp    %bl,%al
  800cd7:	74 0a                	je     800ce3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800cd9:	0f b6 c0             	movzbl %al,%eax
  800cdc:	0f b6 db             	movzbl %bl,%ebx
  800cdf:	29 d8                	sub    %ebx,%eax
  800ce1:	eb 0f                	jmp    800cf2 <memcmp+0x35>
		s1++, s2++;
  800ce3:	83 c2 01             	add    $0x1,%edx
  800ce6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ce9:	39 f2                	cmp    %esi,%edx
  800ceb:	75 e2                	jne    800ccf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d04:	eb 07                	jmp    800d0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d06:	38 08                	cmp    %cl,(%eax)
  800d08:	74 07                	je     800d11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d0a:	83 c0 01             	add    $0x1,%eax
  800d0d:	39 d0                	cmp    %edx,%eax
  800d0f:	72 f5                	jb     800d06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d1f:	eb 03                	jmp    800d24 <strtol+0x11>
		s++;
  800d21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d24:	0f b6 0a             	movzbl (%edx),%ecx
  800d27:	80 f9 09             	cmp    $0x9,%cl
  800d2a:	74 f5                	je     800d21 <strtol+0xe>
  800d2c:	80 f9 20             	cmp    $0x20,%cl
  800d2f:	74 f0                	je     800d21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d31:	80 f9 2b             	cmp    $0x2b,%cl
  800d34:	75 0a                	jne    800d40 <strtol+0x2d>
		s++;
  800d36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d39:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3e:	eb 11                	jmp    800d51 <strtol+0x3e>
  800d40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d45:	80 f9 2d             	cmp    $0x2d,%cl
  800d48:	75 07                	jne    800d51 <strtol+0x3e>
		s++, neg = 1;
  800d4a:	8d 52 01             	lea    0x1(%edx),%edx
  800d4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d56:	75 15                	jne    800d6d <strtol+0x5a>
  800d58:	80 3a 30             	cmpb   $0x30,(%edx)
  800d5b:	75 10                	jne    800d6d <strtol+0x5a>
  800d5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d61:	75 0a                	jne    800d6d <strtol+0x5a>
		s += 2, base = 16;
  800d63:	83 c2 02             	add    $0x2,%edx
  800d66:	b8 10 00 00 00       	mov    $0x10,%eax
  800d6b:	eb 10                	jmp    800d7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	75 0c                	jne    800d7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d73:	80 3a 30             	cmpb   $0x30,(%edx)
  800d76:	75 05                	jne    800d7d <strtol+0x6a>
		s++, base = 8;
  800d78:	83 c2 01             	add    $0x1,%edx
  800d7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d85:	0f b6 0a             	movzbl (%edx),%ecx
  800d88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d8b:	89 f0                	mov    %esi,%eax
  800d8d:	3c 09                	cmp    $0x9,%al
  800d8f:	77 08                	ja     800d99 <strtol+0x86>
			dig = *s - '0';
  800d91:	0f be c9             	movsbl %cl,%ecx
  800d94:	83 e9 30             	sub    $0x30,%ecx
  800d97:	eb 20                	jmp    800db9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800d99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d9c:	89 f0                	mov    %esi,%eax
  800d9e:	3c 19                	cmp    $0x19,%al
  800da0:	77 08                	ja     800daa <strtol+0x97>
			dig = *s - 'a' + 10;
  800da2:	0f be c9             	movsbl %cl,%ecx
  800da5:	83 e9 57             	sub    $0x57,%ecx
  800da8:	eb 0f                	jmp    800db9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800daa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dad:	89 f0                	mov    %esi,%eax
  800daf:	3c 19                	cmp    $0x19,%al
  800db1:	77 16                	ja     800dc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800db3:	0f be c9             	movsbl %cl,%ecx
  800db6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800db9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dbc:	7d 0f                	jge    800dcd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dbe:	83 c2 01             	add    $0x1,%edx
  800dc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800dc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800dc7:	eb bc                	jmp    800d85 <strtol+0x72>
  800dc9:	89 d8                	mov    %ebx,%eax
  800dcb:	eb 02                	jmp    800dcf <strtol+0xbc>
  800dcd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800dcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd3:	74 05                	je     800dda <strtol+0xc7>
		*endptr = (char *) s;
  800dd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dda:	f7 d8                	neg    %eax
  800ddc:	85 ff                	test   %edi,%edi
  800dde:	0f 44 c3             	cmove  %ebx,%eax
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	89 c3                	mov    %eax,%ebx
  800df9:	89 c7                	mov    %eax,%edi
  800dfb:	89 c6                	mov    %eax,%esi
  800dfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e14:	89 d1                	mov    %edx,%ecx
  800e16:	89 d3                	mov    %edx,%ebx
  800e18:	89 d7                	mov    %edx,%edi
  800e1a:	89 d6                	mov    %edx,%esi
  800e1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e31:	b8 03 00 00 00       	mov    $0x3,%eax
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	89 cb                	mov    %ecx,%ebx
  800e3b:	89 cf                	mov    %ecx,%edi
  800e3d:	89 ce                	mov    %ecx,%esi
  800e3f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7e 28                	jle    800e6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e50:	00 
  800e51:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  800e58:	00 
  800e59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e60:	00 
  800e61:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  800e68:	e8 0d f5 ff ff       	call   80037a <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e6d:	83 c4 2c             	add    $0x2c,%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e80:	b8 02 00 00 00       	mov    $0x2,%eax
  800e85:	89 d1                	mov    %edx,%ecx
  800e87:	89 d3                	mov    %edx,%ebx
  800e89:	89 d7                	mov    %edx,%edi
  800e8b:	89 d6                	mov    %edx,%esi
  800e8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e8f:	5b                   	pop    %ebx
  800e90:	5e                   	pop    %esi
  800e91:	5f                   	pop    %edi
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    

00800e94 <sys_yield>:

void
sys_yield(void)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	57                   	push   %edi
  800e98:	56                   	push   %esi
  800e99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ea4:	89 d1                	mov    %edx,%ecx
  800ea6:	89 d3                	mov    %edx,%ebx
  800ea8:	89 d7                	mov    %edx,%edi
  800eaa:	89 d6                	mov    %edx,%esi
  800eac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebc:	be 00 00 00 00       	mov    $0x0,%esi
  800ec1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecf:	89 f7                	mov    %esi,%edi
  800ed1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	7e 28                	jle    800eff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800edb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ee2:	00 
  800ee3:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  800eea:	00 
  800eeb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef2:	00 
  800ef3:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  800efa:	e8 7b f4 ff ff       	call   80037a <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eff:	83 c4 2c             	add    $0x2c,%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f10:	b8 05 00 00 00       	mov    $0x5,%eax
  800f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f21:	8b 75 18             	mov    0x18(%ebp),%esi
  800f24:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f26:	85 c0                	test   %eax,%eax
  800f28:	7e 28                	jle    800f52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f35:	00 
  800f36:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  800f3d:	00 
  800f3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f45:	00 
  800f46:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  800f4d:	e8 28 f4 ff ff       	call   80037a <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f52:	83 c4 2c             	add    $0x2c,%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
  800f60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f68:	b8 06 00 00 00       	mov    $0x6,%eax
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	8b 55 08             	mov    0x8(%ebp),%edx
  800f73:	89 df                	mov    %ebx,%edi
  800f75:	89 de                	mov    %ebx,%esi
  800f77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	7e 28                	jle    800fa5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f88:	00 
  800f89:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  800f90:	00 
  800f91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f98:	00 
  800f99:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  800fa0:	e8 d5 f3 ff ff       	call   80037a <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fa5:	83 c4 2c             	add    $0x2c,%esp
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	89 df                	mov    %ebx,%edi
  800fc8:	89 de                	mov    %ebx,%esi
  800fca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	7e 28                	jle    800ff8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fdb:	00 
  800fdc:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  800fe3:	00 
  800fe4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800feb:	00 
  800fec:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  800ff3:	e8 82 f3 ff ff       	call   80037a <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ff8:	83 c4 2c             	add    $0x2c,%esp
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
  801006:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801009:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100e:	b8 09 00 00 00       	mov    $0x9,%eax
  801013:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	89 df                	mov    %ebx,%edi
  80101b:	89 de                	mov    %ebx,%esi
  80101d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80101f:	85 c0                	test   %eax,%eax
  801021:	7e 28                	jle    80104b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801023:	89 44 24 10          	mov    %eax,0x10(%esp)
  801027:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80102e:	00 
  80102f:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  801036:	00 
  801037:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103e:	00 
  80103f:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  801046:	e8 2f f3 ff ff       	call   80037a <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104b:	83 c4 2c             	add    $0x2c,%esp
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	53                   	push   %ebx
  801059:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801061:	b8 0a 00 00 00       	mov    $0xa,%eax
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	89 df                	mov    %ebx,%edi
  80106e:	89 de                	mov    %ebx,%esi
  801070:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801072:	85 c0                	test   %eax,%eax
  801074:	7e 28                	jle    80109e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801076:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801081:	00 
  801082:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  801089:	00 
  80108a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801091:	00 
  801092:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  801099:	e8 dc f2 ff ff       	call   80037a <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80109e:	83 c4 2c             	add    $0x2c,%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ac:	be 00 00 00 00       	mov    $0x0,%esi
  8010b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5f                   	pop    %edi
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    

008010c9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
  8010cf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010df:	89 cb                	mov    %ecx,%ebx
  8010e1:	89 cf                	mov    %ecx,%edi
  8010e3:	89 ce                	mov    %ecx,%esi
  8010e5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	7e 28                	jle    801113 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010f6:	00 
  8010f7:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  8010fe:	00 
  8010ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801106:	00 
  801107:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  80110e:	e8 67 f2 ff ff       	call   80037a <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801113:	83 c4 2c             	add    $0x2c,%esp
  801116:	5b                   	pop    %ebx
  801117:	5e                   	pop    %esi
  801118:	5f                   	pop    %edi
  801119:	5d                   	pop    %ebp
  80111a:	c3                   	ret    

0080111b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	57                   	push   %edi
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801121:	ba 00 00 00 00       	mov    $0x0,%edx
  801126:	b8 0e 00 00 00       	mov    $0xe,%eax
  80112b:	89 d1                	mov    %edx,%ecx
  80112d:	89 d3                	mov    %edx,%ebx
  80112f:	89 d7                	mov    %edx,%edi
  801131:	89 d6                	mov    %edx,%esi
  801133:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
  801140:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801143:	bb 00 00 00 00       	mov    $0x0,%ebx
  801148:	b8 0f 00 00 00       	mov    $0xf,%eax
  80114d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801150:	8b 55 08             	mov    0x8(%ebp),%edx
  801153:	89 df                	mov    %ebx,%edi
  801155:	89 de                	mov    %ebx,%esi
  801157:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801159:	85 c0                	test   %eax,%eax
  80115b:	7e 28                	jle    801185 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80115d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801161:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801168:	00 
  801169:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  801170:	00 
  801171:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801178:	00 
  801179:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  801180:	e8 f5 f1 ff ff       	call   80037a <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801185:	83 c4 2c             	add    $0x2c,%esp
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	57                   	push   %edi
  801191:	56                   	push   %esi
  801192:	53                   	push   %ebx
  801193:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801196:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119b:	b8 10 00 00 00       	mov    $0x10,%eax
  8011a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a6:	89 df                	mov    %ebx,%edi
  8011a8:	89 de                	mov    %ebx,%esi
  8011aa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	7e 28                	jle    8011d8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8011bb:	00 
  8011bc:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  8011c3:	00 
  8011c4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011cb:	00 
  8011cc:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  8011d3:	e8 a2 f1 ff ff       	call   80037a <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8011d8:	83 c4 2c             	add    $0x2c,%esp
  8011db:	5b                   	pop    %ebx
  8011dc:	5e                   	pop    %esi
  8011dd:	5f                   	pop    %edi
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    

008011e0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	57                   	push   %edi
  8011e4:	56                   	push   %esi
  8011e5:	53                   	push   %ebx
  8011e6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ee:	b8 11 00 00 00       	mov    $0x11,%eax
  8011f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f9:	89 df                	mov    %ebx,%edi
  8011fb:	89 de                	mov    %ebx,%esi
  8011fd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011ff:	85 c0                	test   %eax,%eax
  801201:	7e 28                	jle    80122b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801203:	89 44 24 10          	mov    %eax,0x10(%esp)
  801207:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80120e:	00 
  80120f:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  801216:	00 
  801217:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80121e:	00 
  80121f:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  801226:	e8 4f f1 ff ff       	call   80037a <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80122b:	83 c4 2c             	add    $0x2c,%esp
  80122e:	5b                   	pop    %ebx
  80122f:	5e                   	pop    %esi
  801230:	5f                   	pop    %edi
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    

00801233 <sys_sleep>:

int
sys_sleep(int channel)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	57                   	push   %edi
  801237:	56                   	push   %esi
  801238:	53                   	push   %ebx
  801239:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801241:	b8 12 00 00 00       	mov    $0x12,%eax
  801246:	8b 55 08             	mov    0x8(%ebp),%edx
  801249:	89 cb                	mov    %ecx,%ebx
  80124b:	89 cf                	mov    %ecx,%edi
  80124d:	89 ce                	mov    %ecx,%esi
  80124f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801251:	85 c0                	test   %eax,%eax
  801253:	7e 28                	jle    80127d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801255:	89 44 24 10          	mov    %eax,0x10(%esp)
  801259:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801260:	00 
  801261:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  801268:	00 
  801269:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801270:	00 
  801271:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  801278:	e8 fd f0 ff ff       	call   80037a <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80127d:	83 c4 2c             	add    $0x2c,%esp
  801280:	5b                   	pop    %ebx
  801281:	5e                   	pop    %esi
  801282:	5f                   	pop    %edi
  801283:	5d                   	pop    %ebp
  801284:	c3                   	ret    

00801285 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	57                   	push   %edi
  801289:	56                   	push   %esi
  80128a:	53                   	push   %ebx
  80128b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801293:	b8 13 00 00 00       	mov    $0x13,%eax
  801298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 df                	mov    %ebx,%edi
  8012a0:	89 de                	mov    %ebx,%esi
  8012a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	7e 28                	jle    8012d0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ac:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  8012bb:	00 
  8012bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c3:	00 
  8012c4:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  8012cb:	e8 aa f0 ff ff       	call   80037a <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8012d0:	83 c4 2c             	add    $0x2c,%esp
  8012d3:	5b                   	pop    %ebx
  8012d4:	5e                   	pop    %esi
  8012d5:	5f                   	pop    %edi
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    

008012d8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	53                   	push   %ebx
  8012dc:	83 ec 24             	sub    $0x24,%esp
  8012df:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012e2:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  8012e4:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012e8:	74 27                	je     801311 <pgfault+0x39>
  8012ea:	89 c2                	mov    %eax,%edx
  8012ec:	c1 ea 16             	shr    $0x16,%edx
  8012ef:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012f6:	f6 c2 01             	test   $0x1,%dl
  8012f9:	74 16                	je     801311 <pgfault+0x39>
  8012fb:	89 c2                	mov    %eax,%edx
  8012fd:	c1 ea 0c             	shr    $0xc,%edx
  801300:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801307:	f7 d2                	not    %edx
  801309:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80130f:	74 1c                	je     80132d <pgfault+0x55>
		panic("pgfault");
  801311:	c7 44 24 08 76 33 80 	movl   $0x803376,0x8(%esp)
  801318:	00 
  801319:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801320:	00 
  801321:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  801328:	e8 4d f0 ff ff       	call   80037a <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80132d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801332:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801334:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80133b:	00 
  80133c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801343:	00 
  801344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134b:	e8 63 fb ff ff       	call   800eb3 <sys_page_alloc>
  801350:	85 c0                	test   %eax,%eax
  801352:	79 1c                	jns    801370 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801354:	c7 44 24 08 89 33 80 	movl   $0x803389,0x8(%esp)
  80135b:	00 
  80135c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801363:	00 
  801364:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80136b:	e8 0a f0 ff ff       	call   80037a <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801370:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801377:	00 
  801378:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80137c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801383:	e8 14 f9 ff ff       	call   800c9c <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801388:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80138f:	00 
  801390:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801394:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80139b:	00 
  80139c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013a3:	00 
  8013a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ab:	e8 57 fb ff ff       	call   800f07 <sys_page_map>
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	79 1c                	jns    8013d0 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  8013b4:	c7 44 24 08 a3 33 80 	movl   $0x8033a3,0x8(%esp)
  8013bb:	00 
  8013bc:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8013c3:	00 
  8013c4:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8013cb:	e8 aa ef ff ff       	call   80037a <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  8013d0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013d7:	00 
  8013d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013df:	e8 76 fb ff ff       	call   800f5a <sys_page_unmap>
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	79 1c                	jns    801404 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  8013e8:	c7 44 24 08 bb 33 80 	movl   $0x8033bb,0x8(%esp)
  8013ef:	00 
  8013f0:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8013f7:	00 
  8013f8:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8013ff:	e8 76 ef ff ff       	call   80037a <_panic>
	}
}
  801404:	83 c4 24             	add    $0x24,%esp
  801407:	5b                   	pop    %ebx
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    

0080140a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	57                   	push   %edi
  80140e:	56                   	push   %esi
  80140f:	53                   	push   %ebx
  801410:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801413:	c7 04 24 d8 12 80 00 	movl   $0x8012d8,(%esp)
  80141a:	e8 d7 15 00 00       	call   8029f6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80141f:	b8 07 00 00 00       	mov    $0x7,%eax
  801424:	cd 30                	int    $0x30
  801426:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801429:	85 c0                	test   %eax,%eax
  80142b:	79 1c                	jns    801449 <fork+0x3f>
		panic("fork(): sys_exofork");
  80142d:	c7 44 24 08 d5 33 80 	movl   $0x8033d5,0x8(%esp)
  801434:	00 
  801435:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80143c:	00 
  80143d:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  801444:	e8 31 ef ff ff       	call   80037a <_panic>
  801449:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  80144b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80144f:	74 0a                	je     80145b <fork+0x51>
  801451:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801456:	e9 9d 01 00 00       	jmp    8015f8 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80145b:	e8 15 fa ff ff       	call   800e75 <sys_getenvid>
  801460:	25 ff 03 00 00       	and    $0x3ff,%eax
  801465:	89 c2                	mov    %eax,%edx
  801467:	c1 e2 07             	shl    $0x7,%edx
  80146a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801471:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  801476:	e9 2a 02 00 00       	jmp    8016a5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80147b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801481:	0f 84 6b 01 00 00    	je     8015f2 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801487:	89 d8                	mov    %ebx,%eax
  801489:	c1 e8 16             	shr    $0x16,%eax
  80148c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801493:	a8 01                	test   $0x1,%al
  801495:	0f 84 57 01 00 00    	je     8015f2 <fork+0x1e8>
  80149b:	89 d8                	mov    %ebx,%eax
  80149d:	c1 e8 0c             	shr    $0xc,%eax
  8014a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014a7:	f7 d0                	not    %eax
  8014a9:	a8 05                	test   $0x5,%al
  8014ab:	0f 85 41 01 00 00    	jne    8015f2 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  8014b1:	89 d8                	mov    %ebx,%eax
  8014b3:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  8014b6:	89 c6                	mov    %eax,%esi
  8014b8:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  8014bb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014c2:	f6 c6 04             	test   $0x4,%dh
  8014c5:	74 4c                	je     801513 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  8014c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014db:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014ea:	e8 18 fa ff ff       	call   800f07 <sys_page_map>
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	0f 89 fb 00 00 00    	jns    8015f2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8014f7:	c7 44 24 08 e9 33 80 	movl   $0x8033e9,0x8(%esp)
  8014fe:	00 
  8014ff:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801506:	00 
  801507:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80150e:	e8 67 ee ff ff       	call   80037a <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801513:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80151a:	f6 c6 08             	test   $0x8,%dh
  80151d:	75 0f                	jne    80152e <fork+0x124>
  80151f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801526:	a8 02                	test   $0x2,%al
  801528:	0f 84 84 00 00 00    	je     8015b2 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80152e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801535:	00 
  801536:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80153a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80153e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801542:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801549:	e8 b9 f9 ff ff       	call   800f07 <sys_page_map>
  80154e:	85 c0                	test   %eax,%eax
  801550:	79 1c                	jns    80156e <fork+0x164>
			panic("duppage: sys_page_map");
  801552:	c7 44 24 08 e9 33 80 	movl   $0x8033e9,0x8(%esp)
  801559:	00 
  80155a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801561:	00 
  801562:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  801569:	e8 0c ee ff ff       	call   80037a <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80156e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801575:	00 
  801576:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80157a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801581:	00 
  801582:	89 74 24 04          	mov    %esi,0x4(%esp)
  801586:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80158d:	e8 75 f9 ff ff       	call   800f07 <sys_page_map>
  801592:	85 c0                	test   %eax,%eax
  801594:	79 5c                	jns    8015f2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801596:	c7 44 24 08 e9 33 80 	movl   $0x8033e9,0x8(%esp)
  80159d:	00 
  80159e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8015a5:	00 
  8015a6:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8015ad:	e8 c8 ed ff ff       	call   80037a <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  8015b2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8015b9:	00 
  8015ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8015be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8015c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015cd:	e8 35 f9 ff ff       	call   800f07 <sys_page_map>
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	79 1c                	jns    8015f2 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8015d6:	c7 44 24 08 e9 33 80 	movl   $0x8033e9,0x8(%esp)
  8015dd:	00 
  8015de:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8015e5:	00 
  8015e6:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8015ed:	e8 88 ed ff ff       	call   80037a <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  8015f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015f8:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8015fe:	0f 85 77 fe ff ff    	jne    80147b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801604:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80160b:	00 
  80160c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801613:	ee 
  801614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801617:	89 04 24             	mov    %eax,(%esp)
  80161a:	e8 94 f8 ff ff       	call   800eb3 <sys_page_alloc>
  80161f:	85 c0                	test   %eax,%eax
  801621:	79 1c                	jns    80163f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801623:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  80162a:	00 
  80162b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801632:	00 
  801633:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80163a:	e8 3b ed ff ff       	call   80037a <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80163f:	c7 44 24 04 7f 2a 80 	movl   $0x802a7f,0x4(%esp)
  801646:	00 
  801647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80164a:	89 04 24             	mov    %eax,(%esp)
  80164d:	e8 01 fa ff ff       	call   801053 <sys_env_set_pgfault_upcall>
  801652:	85 c0                	test   %eax,%eax
  801654:	79 1c                	jns    801672 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801656:	c7 44 24 08 48 34 80 	movl   $0x803448,0x8(%esp)
  80165d:	00 
  80165e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801665:	00 
  801666:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80166d:	e8 08 ed ff ff       	call   80037a <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801672:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801679:	00 
  80167a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167d:	89 04 24             	mov    %eax,(%esp)
  801680:	e8 28 f9 ff ff       	call   800fad <sys_env_set_status>
  801685:	85 c0                	test   %eax,%eax
  801687:	79 1c                	jns    8016a5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801689:	c7 44 24 08 16 34 80 	movl   $0x803416,0x8(%esp)
  801690:	00 
  801691:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801698:	00 
  801699:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8016a0:	e8 d5 ec ff ff       	call   80037a <_panic>
	}

	return env_id;
}
  8016a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a8:	83 c4 2c             	add    $0x2c,%esp
  8016ab:	5b                   	pop    %ebx
  8016ac:	5e                   	pop    %esi
  8016ad:	5f                   	pop    %edi
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <sfork>:

// Challenge!
int
sfork(void)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8016b6:	c7 44 24 08 31 34 80 	movl   $0x803431,0x8(%esp)
  8016bd:	00 
  8016be:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8016c5:	00 
  8016c6:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8016cd:	e8 a8 ec ff ff       	call   80037a <_panic>
  8016d2:	66 90                	xchg   %ax,%ax
  8016d4:	66 90                	xchg   %ax,%ax
  8016d6:	66 90                	xchg   %ax,%ax
  8016d8:	66 90                	xchg   %ax,%ax
  8016da:	66 90                	xchg   %ax,%ax
  8016dc:	66 90                	xchg   %ax,%ax
  8016de:	66 90                	xchg   %ax,%ax

008016e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8016eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8016fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801700:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801712:	89 c2                	mov    %eax,%edx
  801714:	c1 ea 16             	shr    $0x16,%edx
  801717:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80171e:	f6 c2 01             	test   $0x1,%dl
  801721:	74 11                	je     801734 <fd_alloc+0x2d>
  801723:	89 c2                	mov    %eax,%edx
  801725:	c1 ea 0c             	shr    $0xc,%edx
  801728:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80172f:	f6 c2 01             	test   $0x1,%dl
  801732:	75 09                	jne    80173d <fd_alloc+0x36>
			*fd_store = fd;
  801734:	89 01                	mov    %eax,(%ecx)
			return 0;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
  80173b:	eb 17                	jmp    801754 <fd_alloc+0x4d>
  80173d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801742:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801747:	75 c9                	jne    801712 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801749:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80174f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    

00801756 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80175c:	83 f8 1f             	cmp    $0x1f,%eax
  80175f:	77 36                	ja     801797 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801761:	c1 e0 0c             	shl    $0xc,%eax
  801764:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801769:	89 c2                	mov    %eax,%edx
  80176b:	c1 ea 16             	shr    $0x16,%edx
  80176e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801775:	f6 c2 01             	test   $0x1,%dl
  801778:	74 24                	je     80179e <fd_lookup+0x48>
  80177a:	89 c2                	mov    %eax,%edx
  80177c:	c1 ea 0c             	shr    $0xc,%edx
  80177f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801786:	f6 c2 01             	test   $0x1,%dl
  801789:	74 1a                	je     8017a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80178b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178e:	89 02                	mov    %eax,(%edx)
	return 0;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 13                	jmp    8017aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801797:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179c:	eb 0c                	jmp    8017aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80179e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a3:	eb 05                	jmp    8017aa <fd_lookup+0x54>
  8017a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8017aa:	5d                   	pop    %ebp
  8017ab:	c3                   	ret    

008017ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 18             	sub    $0x18,%esp
  8017b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ba:	eb 13                	jmp    8017cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8017bc:	39 08                	cmp    %ecx,(%eax)
  8017be:	75 0c                	jne    8017cc <dev_lookup+0x20>
			*dev = devtab[i];
  8017c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ca:	eb 38                	jmp    801804 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017cc:	83 c2 01             	add    $0x1,%edx
  8017cf:	8b 04 95 e8 34 80 00 	mov    0x8034e8(,%edx,4),%eax
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	75 e2                	jne    8017bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017da:	a1 08 50 80 00       	mov    0x805008,%eax
  8017df:	8b 40 48             	mov    0x48(%eax),%eax
  8017e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ea:	c7 04 24 6c 34 80 00 	movl   $0x80346c,(%esp)
  8017f1:	e8 7d ec ff ff       	call   800473 <cprintf>
	*dev = 0;
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	56                   	push   %esi
  80180a:	53                   	push   %ebx
  80180b:	83 ec 20             	sub    $0x20,%esp
  80180e:	8b 75 08             	mov    0x8(%ebp),%esi
  801811:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801814:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801817:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80181b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801821:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801824:	89 04 24             	mov    %eax,(%esp)
  801827:	e8 2a ff ff ff       	call   801756 <fd_lookup>
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 05                	js     801835 <fd_close+0x2f>
	    || fd != fd2)
  801830:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801833:	74 0c                	je     801841 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801835:	84 db                	test   %bl,%bl
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
  80183c:	0f 44 c2             	cmove  %edx,%eax
  80183f:	eb 3f                	jmp    801880 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801841:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801844:	89 44 24 04          	mov    %eax,0x4(%esp)
  801848:	8b 06                	mov    (%esi),%eax
  80184a:	89 04 24             	mov    %eax,(%esp)
  80184d:	e8 5a ff ff ff       	call   8017ac <dev_lookup>
  801852:	89 c3                	mov    %eax,%ebx
  801854:	85 c0                	test   %eax,%eax
  801856:	78 16                	js     80186e <fd_close+0x68>
		if (dev->dev_close)
  801858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80185e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801863:	85 c0                	test   %eax,%eax
  801865:	74 07                	je     80186e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801867:	89 34 24             	mov    %esi,(%esp)
  80186a:	ff d0                	call   *%eax
  80186c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80186e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801872:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801879:	e8 dc f6 ff ff       	call   800f5a <sys_page_unmap>
	return r;
  80187e:	89 d8                	mov    %ebx,%eax
}
  801880:	83 c4 20             	add    $0x20,%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5d                   	pop    %ebp
  801886:	c3                   	ret    

00801887 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80188d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801890:	89 44 24 04          	mov    %eax,0x4(%esp)
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	89 04 24             	mov    %eax,(%esp)
  80189a:	e8 b7 fe ff ff       	call   801756 <fd_lookup>
  80189f:	89 c2                	mov    %eax,%edx
  8018a1:	85 d2                	test   %edx,%edx
  8018a3:	78 13                	js     8018b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8018a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018ac:	00 
  8018ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b0:	89 04 24             	mov    %eax,(%esp)
  8018b3:	e8 4e ff ff ff       	call   801806 <fd_close>
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <close_all>:

void
close_all(void)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018c6:	89 1c 24             	mov    %ebx,(%esp)
  8018c9:	e8 b9 ff ff ff       	call   801887 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8018ce:	83 c3 01             	add    $0x1,%ebx
  8018d1:	83 fb 20             	cmp    $0x20,%ebx
  8018d4:	75 f0                	jne    8018c6 <close_all+0xc>
		close(i);
}
  8018d6:	83 c4 14             	add    $0x14,%esp
  8018d9:	5b                   	pop    %ebx
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	57                   	push   %edi
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	89 04 24             	mov    %eax,(%esp)
  8018f2:	e8 5f fe ff ff       	call   801756 <fd_lookup>
  8018f7:	89 c2                	mov    %eax,%edx
  8018f9:	85 d2                	test   %edx,%edx
  8018fb:	0f 88 e1 00 00 00    	js     8019e2 <dup+0x106>
		return r;
	close(newfdnum);
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	e8 7b ff ff ff       	call   801887 <close>

	newfd = INDEX2FD(newfdnum);
  80190c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80190f:	c1 e3 0c             	shl    $0xc,%ebx
  801912:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80191b:	89 04 24             	mov    %eax,(%esp)
  80191e:	e8 cd fd ff ff       	call   8016f0 <fd2data>
  801923:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801925:	89 1c 24             	mov    %ebx,(%esp)
  801928:	e8 c3 fd ff ff       	call   8016f0 <fd2data>
  80192d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80192f:	89 f0                	mov    %esi,%eax
  801931:	c1 e8 16             	shr    $0x16,%eax
  801934:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80193b:	a8 01                	test   $0x1,%al
  80193d:	74 43                	je     801982 <dup+0xa6>
  80193f:	89 f0                	mov    %esi,%eax
  801941:	c1 e8 0c             	shr    $0xc,%eax
  801944:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80194b:	f6 c2 01             	test   $0x1,%dl
  80194e:	74 32                	je     801982 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801950:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801957:	25 07 0e 00 00       	and    $0xe07,%eax
  80195c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801960:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801964:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80196b:	00 
  80196c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801970:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801977:	e8 8b f5 ff ff       	call   800f07 <sys_page_map>
  80197c:	89 c6                	mov    %eax,%esi
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 3e                	js     8019c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801985:	89 c2                	mov    %eax,%edx
  801987:	c1 ea 0c             	shr    $0xc,%edx
  80198a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801991:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801997:	89 54 24 10          	mov    %edx,0x10(%esp)
  80199b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80199f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019a6:	00 
  8019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b2:	e8 50 f5 ff ff       	call   800f07 <sys_page_map>
  8019b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019bc:	85 f6                	test   %esi,%esi
  8019be:	79 22                	jns    8019e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8019c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cb:	e8 8a f5 ff ff       	call   800f5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019db:	e8 7a f5 ff ff       	call   800f5a <sys_page_unmap>
	return r;
  8019e0:	89 f0                	mov    %esi,%eax
}
  8019e2:	83 c4 3c             	add    $0x3c,%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5f                   	pop    %edi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    

008019ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 24             	sub    $0x24,%esp
  8019f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fb:	89 1c 24             	mov    %ebx,(%esp)
  8019fe:	e8 53 fd ff ff       	call   801756 <fd_lookup>
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	85 d2                	test   %edx,%edx
  801a07:	78 6d                	js     801a76 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	89 04 24             	mov    %eax,(%esp)
  801a18:	e8 8f fd ff ff       	call   8017ac <dev_lookup>
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 55                	js     801a76 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a24:	8b 50 08             	mov    0x8(%eax),%edx
  801a27:	83 e2 03             	and    $0x3,%edx
  801a2a:	83 fa 01             	cmp    $0x1,%edx
  801a2d:	75 23                	jne    801a52 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a2f:	a1 08 50 80 00       	mov    0x805008,%eax
  801a34:	8b 40 48             	mov    0x48(%eax),%eax
  801a37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3f:	c7 04 24 ad 34 80 00 	movl   $0x8034ad,(%esp)
  801a46:	e8 28 ea ff ff       	call   800473 <cprintf>
		return -E_INVAL;
  801a4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a50:	eb 24                	jmp    801a76 <read+0x8c>
	}
	if (!dev->dev_read)
  801a52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a55:	8b 52 08             	mov    0x8(%edx),%edx
  801a58:	85 d2                	test   %edx,%edx
  801a5a:	74 15                	je     801a71 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a6a:	89 04 24             	mov    %eax,(%esp)
  801a6d:	ff d2                	call   *%edx
  801a6f:	eb 05                	jmp    801a76 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801a71:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801a76:	83 c4 24             	add    $0x24,%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    

00801a7c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	57                   	push   %edi
  801a80:	56                   	push   %esi
  801a81:	53                   	push   %ebx
  801a82:	83 ec 1c             	sub    $0x1c,%esp
  801a85:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a88:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a90:	eb 23                	jmp    801ab5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a92:	89 f0                	mov    %esi,%eax
  801a94:	29 d8                	sub    %ebx,%eax
  801a96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a9a:	89 d8                	mov    %ebx,%eax
  801a9c:	03 45 0c             	add    0xc(%ebp),%eax
  801a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa3:	89 3c 24             	mov    %edi,(%esp)
  801aa6:	e8 3f ff ff ff       	call   8019ea <read>
		if (m < 0)
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 10                	js     801abf <readn+0x43>
			return m;
		if (m == 0)
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	74 0a                	je     801abd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ab3:	01 c3                	add    %eax,%ebx
  801ab5:	39 f3                	cmp    %esi,%ebx
  801ab7:	72 d9                	jb     801a92 <readn+0x16>
  801ab9:	89 d8                	mov    %ebx,%eax
  801abb:	eb 02                	jmp    801abf <readn+0x43>
  801abd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801abf:	83 c4 1c             	add    $0x1c,%esp
  801ac2:	5b                   	pop    %ebx
  801ac3:	5e                   	pop    %esi
  801ac4:	5f                   	pop    %edi
  801ac5:	5d                   	pop    %ebp
  801ac6:	c3                   	ret    

00801ac7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	53                   	push   %ebx
  801acb:	83 ec 24             	sub    $0x24,%esp
  801ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad8:	89 1c 24             	mov    %ebx,(%esp)
  801adb:	e8 76 fc ff ff       	call   801756 <fd_lookup>
  801ae0:	89 c2                	mov    %eax,%edx
  801ae2:	85 d2                	test   %edx,%edx
  801ae4:	78 68                	js     801b4e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af0:	8b 00                	mov    (%eax),%eax
  801af2:	89 04 24             	mov    %eax,(%esp)
  801af5:	e8 b2 fc ff ff       	call   8017ac <dev_lookup>
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 50                	js     801b4e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b01:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b05:	75 23                	jne    801b2a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b07:	a1 08 50 80 00       	mov    0x805008,%eax
  801b0c:	8b 40 48             	mov    0x48(%eax),%eax
  801b0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b17:	c7 04 24 c9 34 80 00 	movl   $0x8034c9,(%esp)
  801b1e:	e8 50 e9 ff ff       	call   800473 <cprintf>
		return -E_INVAL;
  801b23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b28:	eb 24                	jmp    801b4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2d:	8b 52 0c             	mov    0xc(%edx),%edx
  801b30:	85 d2                	test   %edx,%edx
  801b32:	74 15                	je     801b49 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b42:	89 04 24             	mov    %eax,(%esp)
  801b45:	ff d2                	call   *%edx
  801b47:	eb 05                	jmp    801b4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801b49:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801b4e:	83 c4 24             	add    $0x24,%esp
  801b51:	5b                   	pop    %ebx
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    

00801b54 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b5a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	89 04 24             	mov    %eax,(%esp)
  801b67:	e8 ea fb ff ff       	call   801756 <fd_lookup>
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 0e                	js     801b7e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 24             	sub    $0x24,%esp
  801b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b91:	89 1c 24             	mov    %ebx,(%esp)
  801b94:	e8 bd fb ff ff       	call   801756 <fd_lookup>
  801b99:	89 c2                	mov    %eax,%edx
  801b9b:	85 d2                	test   %edx,%edx
  801b9d:	78 61                	js     801c00 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba9:	8b 00                	mov    (%eax),%eax
  801bab:	89 04 24             	mov    %eax,(%esp)
  801bae:	e8 f9 fb ff ff       	call   8017ac <dev_lookup>
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 49                	js     801c00 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bbe:	75 23                	jne    801be3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801bc0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bc5:	8b 40 48             	mov    0x48(%eax),%eax
  801bc8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd0:	c7 04 24 8c 34 80 00 	movl   $0x80348c,(%esp)
  801bd7:	e8 97 e8 ff ff       	call   800473 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801bdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801be1:	eb 1d                	jmp    801c00 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be6:	8b 52 18             	mov    0x18(%edx),%edx
  801be9:	85 d2                	test   %edx,%edx
  801beb:	74 0e                	je     801bfb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf4:	89 04 24             	mov    %eax,(%esp)
  801bf7:	ff d2                	call   *%edx
  801bf9:	eb 05                	jmp    801c00 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801bfb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801c00:	83 c4 24             	add    $0x24,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    

00801c06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	53                   	push   %ebx
  801c0a:	83 ec 24             	sub    $0x24,%esp
  801c0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	89 04 24             	mov    %eax,(%esp)
  801c1d:	e8 34 fb ff ff       	call   801756 <fd_lookup>
  801c22:	89 c2                	mov    %eax,%edx
  801c24:	85 d2                	test   %edx,%edx
  801c26:	78 52                	js     801c7a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c32:	8b 00                	mov    (%eax),%eax
  801c34:	89 04 24             	mov    %eax,(%esp)
  801c37:	e8 70 fb ff ff       	call   8017ac <dev_lookup>
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 3a                	js     801c7a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c43:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c47:	74 2c                	je     801c75 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c49:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c53:	00 00 00 
	stat->st_isdir = 0;
  801c56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c5d:	00 00 00 
	stat->st_dev = dev;
  801c60:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c6d:	89 14 24             	mov    %edx,(%esp)
  801c70:	ff 50 14             	call   *0x14(%eax)
  801c73:	eb 05                	jmp    801c7a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801c75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801c7a:	83 c4 24             	add    $0x24,%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c8f:	00 
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	89 04 24             	mov    %eax,(%esp)
  801c96:	e8 1b 02 00 00       	call   801eb6 <open>
  801c9b:	89 c3                	mov    %eax,%ebx
  801c9d:	85 db                	test   %ebx,%ebx
  801c9f:	78 1b                	js     801cbc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca8:	89 1c 24             	mov    %ebx,(%esp)
  801cab:	e8 56 ff ff ff       	call   801c06 <fstat>
  801cb0:	89 c6                	mov    %eax,%esi
	close(fd);
  801cb2:	89 1c 24             	mov    %ebx,(%esp)
  801cb5:	e8 cd fb ff ff       	call   801887 <close>
	return r;
  801cba:	89 f0                	mov    %esi,%eax
}
  801cbc:	83 c4 10             	add    $0x10,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 10             	sub    $0x10,%esp
  801ccb:	89 c6                	mov    %eax,%esi
  801ccd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ccf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cd6:	75 11                	jne    801ce9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801cdf:	e8 8b 0e 00 00       	call   802b6f <ipc_find_env>
  801ce4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ce9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801cf0:	00 
  801cf1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801cf8:	00 
  801cf9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cfd:	a1 00 50 80 00       	mov    0x805000,%eax
  801d02:	89 04 24             	mov    %eax,(%esp)
  801d05:	e8 fa 0d 00 00       	call   802b04 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d11:	00 
  801d12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d1d:	e8 8e 0d 00 00       	call   802ab0 <ipc_recv>
}
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	8b 40 0c             	mov    0xc(%eax),%eax
  801d35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d42:	ba 00 00 00 00       	mov    $0x0,%edx
  801d47:	b8 02 00 00 00       	mov    $0x2,%eax
  801d4c:	e8 72 ff ff ff       	call   801cc3 <fsipc>
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d64:	ba 00 00 00 00       	mov    $0x0,%edx
  801d69:	b8 06 00 00 00       	mov    $0x6,%eax
  801d6e:	e8 50 ff ff ff       	call   801cc3 <fsipc>
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	53                   	push   %ebx
  801d79:	83 ec 14             	sub    $0x14,%esp
  801d7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	8b 40 0c             	mov    0xc(%eax),%eax
  801d85:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d94:	e8 2a ff ff ff       	call   801cc3 <fsipc>
  801d99:	89 c2                	mov    %eax,%edx
  801d9b:	85 d2                	test   %edx,%edx
  801d9d:	78 2b                	js     801dca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d9f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801da6:	00 
  801da7:	89 1c 24             	mov    %ebx,(%esp)
  801daa:	e8 e8 ec ff ff       	call   800a97 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801daf:	a1 80 60 80 00       	mov    0x806080,%eax
  801db4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dba:	a1 84 60 80 00       	mov    0x806084,%eax
  801dbf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dca:	83 c4 14             	add    $0x14,%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    

00801dd0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 18             	sub    $0x18,%esp
  801dd6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  801ddc:	8b 52 0c             	mov    0xc(%edx),%edx
  801ddf:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801de5:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801dea:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df5:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801dfc:	e8 9b ee ff ff       	call   800c9c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801e01:	ba 00 00 00 00       	mov    $0x0,%edx
  801e06:	b8 04 00 00 00       	mov    $0x4,%eax
  801e0b:	e8 b3 fe ff ff       	call   801cc3 <fsipc>
		return r;
	}

	return r;
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	56                   	push   %esi
  801e16:	53                   	push   %ebx
  801e17:	83 ec 10             	sub    $0x10,%esp
  801e1a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	8b 40 0c             	mov    0xc(%eax),%eax
  801e23:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e28:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e33:	b8 03 00 00 00       	mov    $0x3,%eax
  801e38:	e8 86 fe ff ff       	call   801cc3 <fsipc>
  801e3d:	89 c3                	mov    %eax,%ebx
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	78 6a                	js     801ead <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801e43:	39 c6                	cmp    %eax,%esi
  801e45:	73 24                	jae    801e6b <devfile_read+0x59>
  801e47:	c7 44 24 0c fc 34 80 	movl   $0x8034fc,0xc(%esp)
  801e4e:	00 
  801e4f:	c7 44 24 08 03 35 80 	movl   $0x803503,0x8(%esp)
  801e56:	00 
  801e57:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801e5e:	00 
  801e5f:	c7 04 24 18 35 80 00 	movl   $0x803518,(%esp)
  801e66:	e8 0f e5 ff ff       	call   80037a <_panic>
	assert(r <= PGSIZE);
  801e6b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e70:	7e 24                	jle    801e96 <devfile_read+0x84>
  801e72:	c7 44 24 0c 23 35 80 	movl   $0x803523,0xc(%esp)
  801e79:	00 
  801e7a:	c7 44 24 08 03 35 80 	movl   $0x803503,0x8(%esp)
  801e81:	00 
  801e82:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e89:	00 
  801e8a:	c7 04 24 18 35 80 00 	movl   $0x803518,(%esp)
  801e91:	e8 e4 e4 ff ff       	call   80037a <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ea1:	00 
  801ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea5:	89 04 24             	mov    %eax,(%esp)
  801ea8:	e8 87 ed ff ff       	call   800c34 <memmove>
	return r;
}
  801ead:	89 d8                	mov    %ebx,%eax
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	5b                   	pop    %ebx
  801eb3:	5e                   	pop    %esi
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    

00801eb6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	53                   	push   %ebx
  801eba:	83 ec 24             	sub    $0x24,%esp
  801ebd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ec0:	89 1c 24             	mov    %ebx,(%esp)
  801ec3:	e8 98 eb ff ff       	call   800a60 <strlen>
  801ec8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ecd:	7f 60                	jg     801f2f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ecf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed2:	89 04 24             	mov    %eax,(%esp)
  801ed5:	e8 2d f8 ff ff       	call   801707 <fd_alloc>
  801eda:	89 c2                	mov    %eax,%edx
  801edc:	85 d2                	test   %edx,%edx
  801ede:	78 54                	js     801f34 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801ee0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ee4:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801eeb:	e8 a7 eb ff ff       	call   800a97 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efb:	b8 01 00 00 00       	mov    $0x1,%eax
  801f00:	e8 be fd ff ff       	call   801cc3 <fsipc>
  801f05:	89 c3                	mov    %eax,%ebx
  801f07:	85 c0                	test   %eax,%eax
  801f09:	79 17                	jns    801f22 <open+0x6c>
		fd_close(fd, 0);
  801f0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f12:	00 
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	89 04 24             	mov    %eax,(%esp)
  801f19:	e8 e8 f8 ff ff       	call   801806 <fd_close>
		return r;
  801f1e:	89 d8                	mov    %ebx,%eax
  801f20:	eb 12                	jmp    801f34 <open+0x7e>
	}

	return fd2num(fd);
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	89 04 24             	mov    %eax,(%esp)
  801f28:	e8 b3 f7 ff ff       	call   8016e0 <fd2num>
  801f2d:	eb 05                	jmp    801f34 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801f2f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801f34:	83 c4 24             	add    $0x24,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f40:	ba 00 00 00 00       	mov    $0x0,%edx
  801f45:	b8 08 00 00 00       	mov    $0x8,%eax
  801f4a:	e8 74 fd ff ff       	call   801cc3 <fsipc>
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    
  801f51:	66 90                	xchg   %ax,%ax
  801f53:	66 90                	xchg   %ax,%ax
  801f55:	66 90                	xchg   %ax,%ax
  801f57:	66 90                	xchg   %ax,%ax
  801f59:	66 90                	xchg   %ax,%ax
  801f5b:	66 90                	xchg   %ax,%ax
  801f5d:	66 90                	xchg   %ax,%ax
  801f5f:	90                   	nop

00801f60 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f66:	c7 44 24 04 2f 35 80 	movl   $0x80352f,0x4(%esp)
  801f6d:	00 
  801f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f71:	89 04 24             	mov    %eax,(%esp)
  801f74:	e8 1e eb ff ff       	call   800a97 <strcpy>
	return 0;
}
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	53                   	push   %ebx
  801f84:	83 ec 14             	sub    $0x14,%esp
  801f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f8a:	89 1c 24             	mov    %ebx,(%esp)
  801f8d:	e8 1c 0c 00 00       	call   802bae <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f92:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f97:	83 f8 01             	cmp    $0x1,%eax
  801f9a:	75 0d                	jne    801fa9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f9c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f9f:	89 04 24             	mov    %eax,(%esp)
  801fa2:	e8 29 03 00 00       	call   8022d0 <nsipc_close>
  801fa7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801fa9:	89 d0                	mov    %edx,%eax
  801fab:	83 c4 14             	add    $0x14,%esp
  801fae:	5b                   	pop    %ebx
  801faf:	5d                   	pop    %ebp
  801fb0:	c3                   	ret    

00801fb1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fb7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fbe:	00 
  801fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd3:	89 04 24             	mov    %eax,(%esp)
  801fd6:	e8 f0 03 00 00       	call   8023cb <nsipc_send>
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fe3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fea:	00 
  801feb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fee:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fff:	89 04 24             	mov    %eax,(%esp)
  802002:	e8 44 03 00 00       	call   80234b <nsipc_recv>
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80200f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802012:	89 54 24 04          	mov    %edx,0x4(%esp)
  802016:	89 04 24             	mov    %eax,(%esp)
  802019:	e8 38 f7 ff ff       	call   801756 <fd_lookup>
  80201e:	85 c0                	test   %eax,%eax
  802020:	78 17                	js     802039 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  80202b:	39 08                	cmp    %ecx,(%eax)
  80202d:	75 05                	jne    802034 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80202f:	8b 40 0c             	mov    0xc(%eax),%eax
  802032:	eb 05                	jmp    802039 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802034:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	56                   	push   %esi
  80203f:	53                   	push   %ebx
  802040:	83 ec 20             	sub    $0x20,%esp
  802043:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802045:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802048:	89 04 24             	mov    %eax,(%esp)
  80204b:	e8 b7 f6 ff ff       	call   801707 <fd_alloc>
  802050:	89 c3                	mov    %eax,%ebx
  802052:	85 c0                	test   %eax,%eax
  802054:	78 21                	js     802077 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802056:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80205d:	00 
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	89 44 24 04          	mov    %eax,0x4(%esp)
  802065:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80206c:	e8 42 ee ff ff       	call   800eb3 <sys_page_alloc>
  802071:	89 c3                	mov    %eax,%ebx
  802073:	85 c0                	test   %eax,%eax
  802075:	79 0c                	jns    802083 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802077:	89 34 24             	mov    %esi,(%esp)
  80207a:	e8 51 02 00 00       	call   8022d0 <nsipc_close>
		return r;
  80207f:	89 d8                	mov    %ebx,%eax
  802081:	eb 20                	jmp    8020a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802083:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80208e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802091:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802098:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80209b:	89 14 24             	mov    %edx,(%esp)
  80209e:	e8 3d f6 ff ff       	call   8016e0 <fd2num>
}
  8020a3:	83 c4 20             	add    $0x20,%esp
  8020a6:	5b                   	pop    %ebx
  8020a7:	5e                   	pop    %esi
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    

008020aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	e8 51 ff ff ff       	call   802009 <fd2sockid>
		return r;
  8020b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	78 23                	js     8020e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020be:	8b 55 10             	mov    0x10(%ebp),%edx
  8020c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020cc:	89 04 24             	mov    %eax,(%esp)
  8020cf:	e8 45 01 00 00       	call   802219 <nsipc_accept>
		return r;
  8020d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	78 07                	js     8020e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8020da:	e8 5c ff ff ff       	call   80203b <alloc_sockfd>
  8020df:	89 c1                	mov    %eax,%ecx
}
  8020e1:	89 c8                	mov    %ecx,%eax
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	e8 16 ff ff ff       	call   802009 <fd2sockid>
  8020f3:	89 c2                	mov    %eax,%edx
  8020f5:	85 d2                	test   %edx,%edx
  8020f7:	78 16                	js     80210f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8020f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802100:	8b 45 0c             	mov    0xc(%ebp),%eax
  802103:	89 44 24 04          	mov    %eax,0x4(%esp)
  802107:	89 14 24             	mov    %edx,(%esp)
  80210a:	e8 60 01 00 00       	call   80226f <nsipc_bind>
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <shutdown>:

int
shutdown(int s, int how)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	e8 ea fe ff ff       	call   802009 <fd2sockid>
  80211f:	89 c2                	mov    %eax,%edx
  802121:	85 d2                	test   %edx,%edx
  802123:	78 0f                	js     802134 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212c:	89 14 24             	mov    %edx,(%esp)
  80212f:	e8 7a 01 00 00       	call   8022ae <nsipc_shutdown>
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	e8 c5 fe ff ff       	call   802009 <fd2sockid>
  802144:	89 c2                	mov    %eax,%edx
  802146:	85 d2                	test   %edx,%edx
  802148:	78 16                	js     802160 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80214a:	8b 45 10             	mov    0x10(%ebp),%eax
  80214d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802151:	8b 45 0c             	mov    0xc(%ebp),%eax
  802154:	89 44 24 04          	mov    %eax,0x4(%esp)
  802158:	89 14 24             	mov    %edx,(%esp)
  80215b:	e8 8a 01 00 00       	call   8022ea <nsipc_connect>
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <listen>:

int
listen(int s, int backlog)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	e8 99 fe ff ff       	call   802009 <fd2sockid>
  802170:	89 c2                	mov    %eax,%edx
  802172:	85 d2                	test   %edx,%edx
  802174:	78 0f                	js     802185 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802176:	8b 45 0c             	mov    0xc(%ebp),%eax
  802179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217d:	89 14 24             	mov    %edx,(%esp)
  802180:	e8 a4 01 00 00       	call   802329 <nsipc_listen>
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80218d:	8b 45 10             	mov    0x10(%ebp),%eax
  802190:	89 44 24 08          	mov    %eax,0x8(%esp)
  802194:	8b 45 0c             	mov    0xc(%ebp),%eax
  802197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	89 04 24             	mov    %eax,(%esp)
  8021a1:	e8 98 02 00 00       	call   80243e <nsipc_socket>
  8021a6:	89 c2                	mov    %eax,%edx
  8021a8:	85 d2                	test   %edx,%edx
  8021aa:	78 05                	js     8021b1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8021ac:	e8 8a fe ff ff       	call   80203b <alloc_sockfd>
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	53                   	push   %ebx
  8021b7:	83 ec 14             	sub    $0x14,%esp
  8021ba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021bc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021c3:	75 11                	jne    8021d6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8021cc:	e8 9e 09 00 00       	call   802b6f <ipc_find_env>
  8021d1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021d6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8021dd:	00 
  8021de:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8021e5:	00 
  8021e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021ea:	a1 04 50 80 00       	mov    0x805004,%eax
  8021ef:	89 04 24             	mov    %eax,(%esp)
  8021f2:	e8 0d 09 00 00       	call   802b04 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021fe:	00 
  8021ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802206:	00 
  802207:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220e:	e8 9d 08 00 00       	call   802ab0 <ipc_recv>
}
  802213:	83 c4 14             	add    $0x14,%esp
  802216:	5b                   	pop    %ebx
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    

00802219 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	56                   	push   %esi
  80221d:	53                   	push   %ebx
  80221e:	83 ec 10             	sub    $0x10,%esp
  802221:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80222c:	8b 06                	mov    (%esi),%eax
  80222e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802233:	b8 01 00 00 00       	mov    $0x1,%eax
  802238:	e8 76 ff ff ff       	call   8021b3 <nsipc>
  80223d:	89 c3                	mov    %eax,%ebx
  80223f:	85 c0                	test   %eax,%eax
  802241:	78 23                	js     802266 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802243:	a1 10 70 80 00       	mov    0x807010,%eax
  802248:	89 44 24 08          	mov    %eax,0x8(%esp)
  80224c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802253:	00 
  802254:	8b 45 0c             	mov    0xc(%ebp),%eax
  802257:	89 04 24             	mov    %eax,(%esp)
  80225a:	e8 d5 e9 ff ff       	call   800c34 <memmove>
		*addrlen = ret->ret_addrlen;
  80225f:	a1 10 70 80 00       	mov    0x807010,%eax
  802264:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802266:	89 d8                	mov    %ebx,%eax
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	5b                   	pop    %ebx
  80226c:	5e                   	pop    %esi
  80226d:	5d                   	pop    %ebp
  80226e:	c3                   	ret    

0080226f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	53                   	push   %ebx
  802273:	83 ec 14             	sub    $0x14,%esp
  802276:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802281:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802285:	8b 45 0c             	mov    0xc(%ebp),%eax
  802288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802293:	e8 9c e9 ff ff       	call   800c34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802298:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80229e:	b8 02 00 00 00       	mov    $0x2,%eax
  8022a3:	e8 0b ff ff ff       	call   8021b3 <nsipc>
}
  8022a8:	83 c4 14             	add    $0x14,%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    

008022ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8022c9:	e8 e5 fe ff ff       	call   8021b3 <nsipc>
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022de:	b8 04 00 00 00       	mov    $0x4,%eax
  8022e3:	e8 cb fe ff ff       	call   8021b3 <nsipc>
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	53                   	push   %ebx
  8022ee:	83 ec 14             	sub    $0x14,%esp
  8022f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802300:	8b 45 0c             	mov    0xc(%ebp),%eax
  802303:	89 44 24 04          	mov    %eax,0x4(%esp)
  802307:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80230e:	e8 21 e9 ff ff       	call   800c34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802313:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802319:	b8 05 00 00 00       	mov    $0x5,%eax
  80231e:	e8 90 fe ff ff       	call   8021b3 <nsipc>
}
  802323:	83 c4 14             	add    $0x14,%esp
  802326:	5b                   	pop    %ebx
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    

00802329 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80233f:	b8 06 00 00 00       	mov    $0x6,%eax
  802344:	e8 6a fe ff ff       	call   8021b3 <nsipc>
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	56                   	push   %esi
  80234f:	53                   	push   %ebx
  802350:	83 ec 10             	sub    $0x10,%esp
  802353:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80235e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802364:	8b 45 14             	mov    0x14(%ebp),%eax
  802367:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80236c:	b8 07 00 00 00       	mov    $0x7,%eax
  802371:	e8 3d fe ff ff       	call   8021b3 <nsipc>
  802376:	89 c3                	mov    %eax,%ebx
  802378:	85 c0                	test   %eax,%eax
  80237a:	78 46                	js     8023c2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80237c:	39 f0                	cmp    %esi,%eax
  80237e:	7f 07                	jg     802387 <nsipc_recv+0x3c>
  802380:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802385:	7e 24                	jle    8023ab <nsipc_recv+0x60>
  802387:	c7 44 24 0c 3b 35 80 	movl   $0x80353b,0xc(%esp)
  80238e:	00 
  80238f:	c7 44 24 08 03 35 80 	movl   $0x803503,0x8(%esp)
  802396:	00 
  802397:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80239e:	00 
  80239f:	c7 04 24 50 35 80 00 	movl   $0x803550,(%esp)
  8023a6:	e8 cf df ff ff       	call   80037a <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023af:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8023b6:	00 
  8023b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ba:	89 04 24             	mov    %eax,(%esp)
  8023bd:	e8 72 e8 ff ff       	call   800c34 <memmove>
	}

	return r;
}
  8023c2:	89 d8                	mov    %ebx,%eax
  8023c4:	83 c4 10             	add    $0x10,%esp
  8023c7:	5b                   	pop    %ebx
  8023c8:	5e                   	pop    %esi
  8023c9:	5d                   	pop    %ebp
  8023ca:	c3                   	ret    

008023cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	53                   	push   %ebx
  8023cf:	83 ec 14             	sub    $0x14,%esp
  8023d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023e3:	7e 24                	jle    802409 <nsipc_send+0x3e>
  8023e5:	c7 44 24 0c 5c 35 80 	movl   $0x80355c,0xc(%esp)
  8023ec:	00 
  8023ed:	c7 44 24 08 03 35 80 	movl   $0x803503,0x8(%esp)
  8023f4:	00 
  8023f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8023fc:	00 
  8023fd:	c7 04 24 50 35 80 00 	movl   $0x803550,(%esp)
  802404:	e8 71 df ff ff       	call   80037a <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802409:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80240d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802410:	89 44 24 04          	mov    %eax,0x4(%esp)
  802414:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80241b:	e8 14 e8 ff ff       	call   800c34 <memmove>
	nsipcbuf.send.req_size = size;
  802420:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802426:	8b 45 14             	mov    0x14(%ebp),%eax
  802429:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80242e:	b8 08 00 00 00       	mov    $0x8,%eax
  802433:	e8 7b fd ff ff       	call   8021b3 <nsipc>
}
  802438:	83 c4 14             	add    $0x14,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5d                   	pop    %ebp
  80243d:	c3                   	ret    

0080243e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80244c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802454:	8b 45 10             	mov    0x10(%ebp),%eax
  802457:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80245c:	b8 09 00 00 00       	mov    $0x9,%eax
  802461:	e8 4d fd ff ff       	call   8021b3 <nsipc>
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	56                   	push   %esi
  80246c:	53                   	push   %ebx
  80246d:	83 ec 10             	sub    $0x10,%esp
  802470:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	89 04 24             	mov    %eax,(%esp)
  802479:	e8 72 f2 ff ff       	call   8016f0 <fd2data>
  80247e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802480:	c7 44 24 04 68 35 80 	movl   $0x803568,0x4(%esp)
  802487:	00 
  802488:	89 1c 24             	mov    %ebx,(%esp)
  80248b:	e8 07 e6 ff ff       	call   800a97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802490:	8b 46 04             	mov    0x4(%esi),%eax
  802493:	2b 06                	sub    (%esi),%eax
  802495:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80249b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024a2:	00 00 00 
	stat->st_dev = &devpipe;
  8024a5:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8024ac:	40 80 00 
	return 0;
}
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	83 c4 10             	add    $0x10,%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5d                   	pop    %ebp
  8024ba:	c3                   	ret    

008024bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	53                   	push   %ebx
  8024bf:	83 ec 14             	sub    $0x14,%esp
  8024c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d0:	e8 85 ea ff ff       	call   800f5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024d5:	89 1c 24             	mov    %ebx,(%esp)
  8024d8:	e8 13 f2 ff ff       	call   8016f0 <fd2data>
  8024dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e8:	e8 6d ea ff ff       	call   800f5a <sys_page_unmap>
}
  8024ed:	83 c4 14             	add    $0x14,%esp
  8024f0:	5b                   	pop    %ebx
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    

008024f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	57                   	push   %edi
  8024f7:	56                   	push   %esi
  8024f8:	53                   	push   %ebx
  8024f9:	83 ec 2c             	sub    $0x2c,%esp
  8024fc:	89 c6                	mov    %eax,%esi
  8024fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802501:	a1 08 50 80 00       	mov    0x805008,%eax
  802506:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802509:	89 34 24             	mov    %esi,(%esp)
  80250c:	e8 9d 06 00 00       	call   802bae <pageref>
  802511:	89 c7                	mov    %eax,%edi
  802513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802516:	89 04 24             	mov    %eax,(%esp)
  802519:	e8 90 06 00 00       	call   802bae <pageref>
  80251e:	39 c7                	cmp    %eax,%edi
  802520:	0f 94 c2             	sete   %dl
  802523:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802526:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80252c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80252f:	39 fb                	cmp    %edi,%ebx
  802531:	74 21                	je     802554 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802533:	84 d2                	test   %dl,%dl
  802535:	74 ca                	je     802501 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802537:	8b 51 58             	mov    0x58(%ecx),%edx
  80253a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80253e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802542:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802546:	c7 04 24 6f 35 80 00 	movl   $0x80356f,(%esp)
  80254d:	e8 21 df ff ff       	call   800473 <cprintf>
  802552:	eb ad                	jmp    802501 <_pipeisclosed+0xe>
	}
}
  802554:	83 c4 2c             	add    $0x2c,%esp
  802557:	5b                   	pop    %ebx
  802558:	5e                   	pop    %esi
  802559:	5f                   	pop    %edi
  80255a:	5d                   	pop    %ebp
  80255b:	c3                   	ret    

0080255c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	57                   	push   %edi
  802560:	56                   	push   %esi
  802561:	53                   	push   %ebx
  802562:	83 ec 1c             	sub    $0x1c,%esp
  802565:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802568:	89 34 24             	mov    %esi,(%esp)
  80256b:	e8 80 f1 ff ff       	call   8016f0 <fd2data>
  802570:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802572:	bf 00 00 00 00       	mov    $0x0,%edi
  802577:	eb 45                	jmp    8025be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802579:	89 da                	mov    %ebx,%edx
  80257b:	89 f0                	mov    %esi,%eax
  80257d:	e8 71 ff ff ff       	call   8024f3 <_pipeisclosed>
  802582:	85 c0                	test   %eax,%eax
  802584:	75 41                	jne    8025c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802586:	e8 09 e9 ff ff       	call   800e94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80258b:	8b 43 04             	mov    0x4(%ebx),%eax
  80258e:	8b 0b                	mov    (%ebx),%ecx
  802590:	8d 51 20             	lea    0x20(%ecx),%edx
  802593:	39 d0                	cmp    %edx,%eax
  802595:	73 e2                	jae    802579 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802597:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80259a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80259e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025a1:	99                   	cltd   
  8025a2:	c1 ea 1b             	shr    $0x1b,%edx
  8025a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8025a8:	83 e1 1f             	and    $0x1f,%ecx
  8025ab:	29 d1                	sub    %edx,%ecx
  8025ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8025b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8025b5:	83 c0 01             	add    $0x1,%eax
  8025b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025bb:	83 c7 01             	add    $0x1,%edi
  8025be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025c1:	75 c8                	jne    80258b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8025c3:	89 f8                	mov    %edi,%eax
  8025c5:	eb 05                	jmp    8025cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8025cc:	83 c4 1c             	add    $0x1c,%esp
  8025cf:	5b                   	pop    %ebx
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    

008025d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	57                   	push   %edi
  8025d8:	56                   	push   %esi
  8025d9:	53                   	push   %ebx
  8025da:	83 ec 1c             	sub    $0x1c,%esp
  8025dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8025e0:	89 3c 24             	mov    %edi,(%esp)
  8025e3:	e8 08 f1 ff ff       	call   8016f0 <fd2data>
  8025e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025ea:	be 00 00 00 00       	mov    $0x0,%esi
  8025ef:	eb 3d                	jmp    80262e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8025f1:	85 f6                	test   %esi,%esi
  8025f3:	74 04                	je     8025f9 <devpipe_read+0x25>
				return i;
  8025f5:	89 f0                	mov    %esi,%eax
  8025f7:	eb 43                	jmp    80263c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025f9:	89 da                	mov    %ebx,%edx
  8025fb:	89 f8                	mov    %edi,%eax
  8025fd:	e8 f1 fe ff ff       	call   8024f3 <_pipeisclosed>
  802602:	85 c0                	test   %eax,%eax
  802604:	75 31                	jne    802637 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802606:	e8 89 e8 ff ff       	call   800e94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80260b:	8b 03                	mov    (%ebx),%eax
  80260d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802610:	74 df                	je     8025f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802612:	99                   	cltd   
  802613:	c1 ea 1b             	shr    $0x1b,%edx
  802616:	01 d0                	add    %edx,%eax
  802618:	83 e0 1f             	and    $0x1f,%eax
  80261b:	29 d0                	sub    %edx,%eax
  80261d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802622:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802625:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802628:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80262b:	83 c6 01             	add    $0x1,%esi
  80262e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802631:	75 d8                	jne    80260b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802633:	89 f0                	mov    %esi,%eax
  802635:	eb 05                	jmp    80263c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80263c:	83 c4 1c             	add    $0x1c,%esp
  80263f:	5b                   	pop    %ebx
  802640:	5e                   	pop    %esi
  802641:	5f                   	pop    %edi
  802642:	5d                   	pop    %ebp
  802643:	c3                   	ret    

00802644 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	56                   	push   %esi
  802648:	53                   	push   %ebx
  802649:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80264c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264f:	89 04 24             	mov    %eax,(%esp)
  802652:	e8 b0 f0 ff ff       	call   801707 <fd_alloc>
  802657:	89 c2                	mov    %eax,%edx
  802659:	85 d2                	test   %edx,%edx
  80265b:	0f 88 4d 01 00 00    	js     8027ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802661:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802668:	00 
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802670:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802677:	e8 37 e8 ff ff       	call   800eb3 <sys_page_alloc>
  80267c:	89 c2                	mov    %eax,%edx
  80267e:	85 d2                	test   %edx,%edx
  802680:	0f 88 28 01 00 00    	js     8027ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802686:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802689:	89 04 24             	mov    %eax,(%esp)
  80268c:	e8 76 f0 ff ff       	call   801707 <fd_alloc>
  802691:	89 c3                	mov    %eax,%ebx
  802693:	85 c0                	test   %eax,%eax
  802695:	0f 88 fe 00 00 00    	js     802799 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026a2:	00 
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b1:	e8 fd e7 ff ff       	call   800eb3 <sys_page_alloc>
  8026b6:	89 c3                	mov    %eax,%ebx
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	0f 88 d9 00 00 00    	js     802799 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	89 04 24             	mov    %eax,(%esp)
  8026c6:	e8 25 f0 ff ff       	call   8016f0 <fd2data>
  8026cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026d4:	00 
  8026d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e0:	e8 ce e7 ff ff       	call   800eb3 <sys_page_alloc>
  8026e5:	89 c3                	mov    %eax,%ebx
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	0f 88 97 00 00 00    	js     802786 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	89 04 24             	mov    %eax,(%esp)
  8026f5:	e8 f6 ef ff ff       	call   8016f0 <fd2data>
  8026fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802701:	00 
  802702:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802706:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80270d:	00 
  80270e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802712:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802719:	e8 e9 e7 ff ff       	call   800f07 <sys_page_map>
  80271e:	89 c3                	mov    %eax,%ebx
  802720:	85 c0                	test   %eax,%eax
  802722:	78 52                	js     802776 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802724:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802739:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	89 04 24             	mov    %eax,(%esp)
  802754:	e8 87 ef ff ff       	call   8016e0 <fd2num>
  802759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80275e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802761:	89 04 24             	mov    %eax,(%esp)
  802764:	e8 77 ef ff ff       	call   8016e0 <fd2num>
  802769:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80276c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	eb 38                	jmp    8027ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802776:	89 74 24 04          	mov    %esi,0x4(%esp)
  80277a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802781:	e8 d4 e7 ff ff       	call   800f5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802789:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802794:	e8 c1 e7 ff ff       	call   800f5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a7:	e8 ae e7 ff ff       	call   800f5a <sys_page_unmap>
  8027ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8027ae:	83 c4 30             	add    $0x30,%esp
  8027b1:	5b                   	pop    %ebx
  8027b2:	5e                   	pop    %esi
  8027b3:	5d                   	pop    %ebp
  8027b4:	c3                   	ret    

008027b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	89 04 24             	mov    %eax,(%esp)
  8027c8:	e8 89 ef ff ff       	call   801756 <fd_lookup>
  8027cd:	89 c2                	mov    %eax,%edx
  8027cf:	85 d2                	test   %edx,%edx
  8027d1:	78 15                	js     8027e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	89 04 24             	mov    %eax,(%esp)
  8027d9:	e8 12 ef ff ff       	call   8016f0 <fd2data>
	return _pipeisclosed(fd, p);
  8027de:	89 c2                	mov    %eax,%edx
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	e8 0b fd ff ff       	call   8024f3 <_pipeisclosed>
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	56                   	push   %esi
  8027ee:	53                   	push   %ebx
  8027ef:	83 ec 10             	sub    $0x10,%esp
  8027f2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8027f5:	85 f6                	test   %esi,%esi
  8027f7:	75 24                	jne    80281d <wait+0x33>
  8027f9:	c7 44 24 0c 87 35 80 	movl   $0x803587,0xc(%esp)
  802800:	00 
  802801:	c7 44 24 08 03 35 80 	movl   $0x803503,0x8(%esp)
  802808:	00 
  802809:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802810:	00 
  802811:	c7 04 24 92 35 80 00 	movl   $0x803592,(%esp)
  802818:	e8 5d db ff ff       	call   80037a <_panic>
	e = &envs[ENVX(envid)];
  80281d:	89 f0                	mov    %esi,%eax
  80281f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802824:	89 c2                	mov    %eax,%edx
  802826:	c1 e2 07             	shl    $0x7,%edx
  802829:	8d 9c 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802830:	eb 05                	jmp    802837 <wait+0x4d>
		sys_yield();
  802832:	e8 5d e6 ff ff       	call   800e94 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802837:	8b 43 48             	mov    0x48(%ebx),%eax
  80283a:	39 f0                	cmp    %esi,%eax
  80283c:	75 07                	jne    802845 <wait+0x5b>
  80283e:	8b 43 54             	mov    0x54(%ebx),%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	75 ed                	jne    802832 <wait+0x48>
		sys_yield();
}
  802845:	83 c4 10             	add    $0x10,%esp
  802848:	5b                   	pop    %ebx
  802849:	5e                   	pop    %esi
  80284a:	5d                   	pop    %ebp
  80284b:	c3                   	ret    
  80284c:	66 90                	xchg   %ax,%ax
  80284e:	66 90                	xchg   %ax,%ax

00802850 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
  802858:	5d                   	pop    %ebp
  802859:	c3                   	ret    

0080285a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
  80285d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802860:	c7 44 24 04 9d 35 80 	movl   $0x80359d,0x4(%esp)
  802867:	00 
  802868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286b:	89 04 24             	mov    %eax,(%esp)
  80286e:	e8 24 e2 ff ff       	call   800a97 <strcpy>
	return 0;
}
  802873:	b8 00 00 00 00       	mov    $0x0,%eax
  802878:	c9                   	leave  
  802879:	c3                   	ret    

0080287a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	57                   	push   %edi
  80287e:	56                   	push   %esi
  80287f:	53                   	push   %ebx
  802880:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802886:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80288b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802891:	eb 31                	jmp    8028c4 <devcons_write+0x4a>
		m = n - tot;
  802893:	8b 75 10             	mov    0x10(%ebp),%esi
  802896:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802898:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80289b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8028a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028a7:	03 45 0c             	add    0xc(%ebp),%eax
  8028aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ae:	89 3c 24             	mov    %edi,(%esp)
  8028b1:	e8 7e e3 ff ff       	call   800c34 <memmove>
		sys_cputs(buf, m);
  8028b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028ba:	89 3c 24             	mov    %edi,(%esp)
  8028bd:	e8 24 e5 ff ff       	call   800de6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028c2:	01 f3                	add    %esi,%ebx
  8028c4:	89 d8                	mov    %ebx,%eax
  8028c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8028c9:	72 c8                	jb     802893 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8028cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8028d1:	5b                   	pop    %ebx
  8028d2:	5e                   	pop    %esi
  8028d3:	5f                   	pop    %edi
  8028d4:	5d                   	pop    %ebp
  8028d5:	c3                   	ret    

008028d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
  8028d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8028e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028e5:	75 07                	jne    8028ee <devcons_read+0x18>
  8028e7:	eb 2a                	jmp    802913 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028e9:	e8 a6 e5 ff ff       	call   800e94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028ee:	66 90                	xchg   %ax,%ax
  8028f0:	e8 0f e5 ff ff       	call   800e04 <sys_cgetc>
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 f0                	je     8028e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	78 16                	js     802913 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8028fd:	83 f8 04             	cmp    $0x4,%eax
  802900:	74 0c                	je     80290e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802902:	8b 55 0c             	mov    0xc(%ebp),%edx
  802905:	88 02                	mov    %al,(%edx)
	return 1;
  802907:	b8 01 00 00 00       	mov    $0x1,%eax
  80290c:	eb 05                	jmp    802913 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80290e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
  802918:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802921:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802928:	00 
  802929:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80292c:	89 04 24             	mov    %eax,(%esp)
  80292f:	e8 b2 e4 ff ff       	call   800de6 <sys_cputs>
}
  802934:	c9                   	leave  
  802935:	c3                   	ret    

00802936 <getchar>:

int
getchar(void)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
  802939:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80293c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802943:	00 
  802944:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802947:	89 44 24 04          	mov    %eax,0x4(%esp)
  80294b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802952:	e8 93 f0 ff ff       	call   8019ea <read>
	if (r < 0)
  802957:	85 c0                	test   %eax,%eax
  802959:	78 0f                	js     80296a <getchar+0x34>
		return r;
	if (r < 1)
  80295b:	85 c0                	test   %eax,%eax
  80295d:	7e 06                	jle    802965 <getchar+0x2f>
		return -E_EOF;
	return c;
  80295f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802963:	eb 05                	jmp    80296a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802965:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80296a:	c9                   	leave  
  80296b:	c3                   	ret    

0080296c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80296c:	55                   	push   %ebp
  80296d:	89 e5                	mov    %esp,%ebp
  80296f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802972:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802975:	89 44 24 04          	mov    %eax,0x4(%esp)
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	89 04 24             	mov    %eax,(%esp)
  80297f:	e8 d2 ed ff ff       	call   801756 <fd_lookup>
  802984:	85 c0                	test   %eax,%eax
  802986:	78 11                	js     802999 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802991:	39 10                	cmp    %edx,(%eax)
  802993:	0f 94 c0             	sete   %al
  802996:	0f b6 c0             	movzbl %al,%eax
}
  802999:	c9                   	leave  
  80299a:	c3                   	ret    

0080299b <opencons>:

int
opencons(void)
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
  80299e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029a4:	89 04 24             	mov    %eax,(%esp)
  8029a7:	e8 5b ed ff ff       	call   801707 <fd_alloc>
		return r;
  8029ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	78 40                	js     8029f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029b9:	00 
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c8:	e8 e6 e4 ff ff       	call   800eb3 <sys_page_alloc>
		return r;
  8029cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	78 1f                	js     8029f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8029d3:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8029e8:	89 04 24             	mov    %eax,(%esp)
  8029eb:	e8 f0 ec ff ff       	call   8016e0 <fd2num>
  8029f0:	89 c2                	mov    %eax,%edx
}
  8029f2:	89 d0                	mov    %edx,%eax
  8029f4:	c9                   	leave  
  8029f5:	c3                   	ret    

008029f6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029f6:	55                   	push   %ebp
  8029f7:	89 e5                	mov    %esp,%ebp
  8029f9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029fc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a03:	75 70                	jne    802a75 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  802a05:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  802a0c:	00 
  802a0d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802a14:	ee 
  802a15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a1c:	e8 92 e4 ff ff       	call   800eb3 <sys_page_alloc>
		if (error < 0)
  802a21:	85 c0                	test   %eax,%eax
  802a23:	79 1c                	jns    802a41 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  802a25:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  802a2c:	00 
  802a2d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802a34:	00 
  802a35:	c7 04 24 ff 35 80 00 	movl   $0x8035ff,(%esp)
  802a3c:	e8 39 d9 ff ff       	call   80037a <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802a41:	c7 44 24 04 7f 2a 80 	movl   $0x802a7f,0x4(%esp)
  802a48:	00 
  802a49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a50:	e8 fe e5 ff ff       	call   801053 <sys_env_set_pgfault_upcall>
		if (error < 0)
  802a55:	85 c0                	test   %eax,%eax
  802a57:	79 1c                	jns    802a75 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  802a59:	c7 44 24 08 d4 35 80 	movl   $0x8035d4,0x8(%esp)
  802a60:	00 
  802a61:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802a68:	00 
  802a69:	c7 04 24 ff 35 80 00 	movl   $0x8035ff,(%esp)
  802a70:	e8 05 d9 ff ff       	call   80037a <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a7d:	c9                   	leave  
  802a7e:	c3                   	ret    

00802a7f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a7f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a80:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a85:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a87:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  802a8a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  802a8e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802a93:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802a97:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802a99:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802a9c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a9d:	83 c4 04             	add    $0x4,%esp
	popfl
  802aa0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802aa1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802aa2:	c3                   	ret    
  802aa3:	66 90                	xchg   %ax,%ax
  802aa5:	66 90                	xchg   %ax,%ax
  802aa7:	66 90                	xchg   %ax,%ax
  802aa9:	66 90                	xchg   %ax,%ax
  802aab:	66 90                	xchg   %ax,%ax
  802aad:	66 90                	xchg   %ax,%ax
  802aaf:	90                   	nop

00802ab0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	56                   	push   %esi
  802ab4:	53                   	push   %ebx
  802ab5:	83 ec 10             	sub    $0x10,%esp
  802ab8:	8b 75 08             	mov    0x8(%ebp),%esi
  802abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802abe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802ac1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802ac3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802ac8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  802acb:	89 04 24             	mov    %eax,(%esp)
  802ace:	e8 f6 e5 ff ff       	call   8010c9 <sys_ipc_recv>
  802ad3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802ad5:	85 d2                	test   %edx,%edx
  802ad7:	75 24                	jne    802afd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802ad9:	85 f6                	test   %esi,%esi
  802adb:	74 0a                	je     802ae7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  802add:	a1 08 50 80 00       	mov    0x805008,%eax
  802ae2:	8b 40 74             	mov    0x74(%eax),%eax
  802ae5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802ae7:	85 db                	test   %ebx,%ebx
  802ae9:	74 0a                	je     802af5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  802aeb:	a1 08 50 80 00       	mov    0x805008,%eax
  802af0:	8b 40 78             	mov    0x78(%eax),%eax
  802af3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802af5:	a1 08 50 80 00       	mov    0x805008,%eax
  802afa:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  802afd:	83 c4 10             	add    $0x10,%esp
  802b00:	5b                   	pop    %ebx
  802b01:	5e                   	pop    %esi
  802b02:	5d                   	pop    %ebp
  802b03:	c3                   	ret    

00802b04 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b04:	55                   	push   %ebp
  802b05:	89 e5                	mov    %esp,%ebp
  802b07:	57                   	push   %edi
  802b08:	56                   	push   %esi
  802b09:	53                   	push   %ebx
  802b0a:	83 ec 1c             	sub    $0x1c,%esp
  802b0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802b10:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802b16:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802b18:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802b1d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802b20:	8b 45 14             	mov    0x14(%ebp),%eax
  802b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b2f:	89 3c 24             	mov    %edi,(%esp)
  802b32:	e8 6f e5 ff ff       	call   8010a6 <sys_ipc_try_send>

		if (ret == 0)
  802b37:	85 c0                	test   %eax,%eax
  802b39:	74 2c                	je     802b67 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  802b3b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b3e:	74 20                	je     802b60 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802b40:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b44:	c7 44 24 08 10 36 80 	movl   $0x803610,0x8(%esp)
  802b4b:	00 
  802b4c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802b53:	00 
  802b54:	c7 04 24 40 36 80 00 	movl   $0x803640,(%esp)
  802b5b:	e8 1a d8 ff ff       	call   80037a <_panic>
		}

		sys_yield();
  802b60:	e8 2f e3 ff ff       	call   800e94 <sys_yield>
	}
  802b65:	eb b9                	jmp    802b20 <ipc_send+0x1c>
}
  802b67:	83 c4 1c             	add    $0x1c,%esp
  802b6a:	5b                   	pop    %ebx
  802b6b:	5e                   	pop    %esi
  802b6c:	5f                   	pop    %edi
  802b6d:	5d                   	pop    %ebp
  802b6e:	c3                   	ret    

00802b6f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b6f:	55                   	push   %ebp
  802b70:	89 e5                	mov    %esp,%ebp
  802b72:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b75:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b7a:	89 c2                	mov    %eax,%edx
  802b7c:	c1 e2 07             	shl    $0x7,%edx
  802b7f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802b86:	8b 52 50             	mov    0x50(%edx),%edx
  802b89:	39 ca                	cmp    %ecx,%edx
  802b8b:	75 11                	jne    802b9e <ipc_find_env+0x2f>
			return envs[i].env_id;
  802b8d:	89 c2                	mov    %eax,%edx
  802b8f:	c1 e2 07             	shl    $0x7,%edx
  802b92:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802b99:	8b 40 40             	mov    0x40(%eax),%eax
  802b9c:	eb 0e                	jmp    802bac <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b9e:	83 c0 01             	add    $0x1,%eax
  802ba1:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ba6:	75 d2                	jne    802b7a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802ba8:	66 b8 00 00          	mov    $0x0,%ax
}
  802bac:	5d                   	pop    %ebp
  802bad:	c3                   	ret    

00802bae <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
  802bb1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bb4:	89 d0                	mov    %edx,%eax
  802bb6:	c1 e8 16             	shr    $0x16,%eax
  802bb9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802bc0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bc5:	f6 c1 01             	test   $0x1,%cl
  802bc8:	74 1d                	je     802be7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802bca:	c1 ea 0c             	shr    $0xc,%edx
  802bcd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802bd4:	f6 c2 01             	test   $0x1,%dl
  802bd7:	74 0e                	je     802be7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802bd9:	c1 ea 0c             	shr    $0xc,%edx
  802bdc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802be3:	ef 
  802be4:	0f b7 c0             	movzwl %ax,%eax
}
  802be7:	5d                   	pop    %ebp
  802be8:	c3                   	ret    
  802be9:	66 90                	xchg   %ax,%ax
  802beb:	66 90                	xchg   %ax,%ax
  802bed:	66 90                	xchg   %ax,%ax
  802bef:	90                   	nop

00802bf0 <__udivdi3>:
  802bf0:	55                   	push   %ebp
  802bf1:	57                   	push   %edi
  802bf2:	56                   	push   %esi
  802bf3:	83 ec 0c             	sub    $0xc,%esp
  802bf6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bfa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802bfe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802c02:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c06:	85 c0                	test   %eax,%eax
  802c08:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802c0c:	89 ea                	mov    %ebp,%edx
  802c0e:	89 0c 24             	mov    %ecx,(%esp)
  802c11:	75 2d                	jne    802c40 <__udivdi3+0x50>
  802c13:	39 e9                	cmp    %ebp,%ecx
  802c15:	77 61                	ja     802c78 <__udivdi3+0x88>
  802c17:	85 c9                	test   %ecx,%ecx
  802c19:	89 ce                	mov    %ecx,%esi
  802c1b:	75 0b                	jne    802c28 <__udivdi3+0x38>
  802c1d:	b8 01 00 00 00       	mov    $0x1,%eax
  802c22:	31 d2                	xor    %edx,%edx
  802c24:	f7 f1                	div    %ecx
  802c26:	89 c6                	mov    %eax,%esi
  802c28:	31 d2                	xor    %edx,%edx
  802c2a:	89 e8                	mov    %ebp,%eax
  802c2c:	f7 f6                	div    %esi
  802c2e:	89 c5                	mov    %eax,%ebp
  802c30:	89 f8                	mov    %edi,%eax
  802c32:	f7 f6                	div    %esi
  802c34:	89 ea                	mov    %ebp,%edx
  802c36:	83 c4 0c             	add    $0xc,%esp
  802c39:	5e                   	pop    %esi
  802c3a:	5f                   	pop    %edi
  802c3b:	5d                   	pop    %ebp
  802c3c:	c3                   	ret    
  802c3d:	8d 76 00             	lea    0x0(%esi),%esi
  802c40:	39 e8                	cmp    %ebp,%eax
  802c42:	77 24                	ja     802c68 <__udivdi3+0x78>
  802c44:	0f bd e8             	bsr    %eax,%ebp
  802c47:	83 f5 1f             	xor    $0x1f,%ebp
  802c4a:	75 3c                	jne    802c88 <__udivdi3+0x98>
  802c4c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c50:	39 34 24             	cmp    %esi,(%esp)
  802c53:	0f 86 9f 00 00 00    	jbe    802cf8 <__udivdi3+0x108>
  802c59:	39 d0                	cmp    %edx,%eax
  802c5b:	0f 82 97 00 00 00    	jb     802cf8 <__udivdi3+0x108>
  802c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c68:	31 d2                	xor    %edx,%edx
  802c6a:	31 c0                	xor    %eax,%eax
  802c6c:	83 c4 0c             	add    $0xc,%esp
  802c6f:	5e                   	pop    %esi
  802c70:	5f                   	pop    %edi
  802c71:	5d                   	pop    %ebp
  802c72:	c3                   	ret    
  802c73:	90                   	nop
  802c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c78:	89 f8                	mov    %edi,%eax
  802c7a:	f7 f1                	div    %ecx
  802c7c:	31 d2                	xor    %edx,%edx
  802c7e:	83 c4 0c             	add    $0xc,%esp
  802c81:	5e                   	pop    %esi
  802c82:	5f                   	pop    %edi
  802c83:	5d                   	pop    %ebp
  802c84:	c3                   	ret    
  802c85:	8d 76 00             	lea    0x0(%esi),%esi
  802c88:	89 e9                	mov    %ebp,%ecx
  802c8a:	8b 3c 24             	mov    (%esp),%edi
  802c8d:	d3 e0                	shl    %cl,%eax
  802c8f:	89 c6                	mov    %eax,%esi
  802c91:	b8 20 00 00 00       	mov    $0x20,%eax
  802c96:	29 e8                	sub    %ebp,%eax
  802c98:	89 c1                	mov    %eax,%ecx
  802c9a:	d3 ef                	shr    %cl,%edi
  802c9c:	89 e9                	mov    %ebp,%ecx
  802c9e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ca2:	8b 3c 24             	mov    (%esp),%edi
  802ca5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ca9:	89 d6                	mov    %edx,%esi
  802cab:	d3 e7                	shl    %cl,%edi
  802cad:	89 c1                	mov    %eax,%ecx
  802caf:	89 3c 24             	mov    %edi,(%esp)
  802cb2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802cb6:	d3 ee                	shr    %cl,%esi
  802cb8:	89 e9                	mov    %ebp,%ecx
  802cba:	d3 e2                	shl    %cl,%edx
  802cbc:	89 c1                	mov    %eax,%ecx
  802cbe:	d3 ef                	shr    %cl,%edi
  802cc0:	09 d7                	or     %edx,%edi
  802cc2:	89 f2                	mov    %esi,%edx
  802cc4:	89 f8                	mov    %edi,%eax
  802cc6:	f7 74 24 08          	divl   0x8(%esp)
  802cca:	89 d6                	mov    %edx,%esi
  802ccc:	89 c7                	mov    %eax,%edi
  802cce:	f7 24 24             	mull   (%esp)
  802cd1:	39 d6                	cmp    %edx,%esi
  802cd3:	89 14 24             	mov    %edx,(%esp)
  802cd6:	72 30                	jb     802d08 <__udivdi3+0x118>
  802cd8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cdc:	89 e9                	mov    %ebp,%ecx
  802cde:	d3 e2                	shl    %cl,%edx
  802ce0:	39 c2                	cmp    %eax,%edx
  802ce2:	73 05                	jae    802ce9 <__udivdi3+0xf9>
  802ce4:	3b 34 24             	cmp    (%esp),%esi
  802ce7:	74 1f                	je     802d08 <__udivdi3+0x118>
  802ce9:	89 f8                	mov    %edi,%eax
  802ceb:	31 d2                	xor    %edx,%edx
  802ced:	e9 7a ff ff ff       	jmp    802c6c <__udivdi3+0x7c>
  802cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cf8:	31 d2                	xor    %edx,%edx
  802cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  802cff:	e9 68 ff ff ff       	jmp    802c6c <__udivdi3+0x7c>
  802d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d08:	8d 47 ff             	lea    -0x1(%edi),%eax
  802d0b:	31 d2                	xor    %edx,%edx
  802d0d:	83 c4 0c             	add    $0xc,%esp
  802d10:	5e                   	pop    %esi
  802d11:	5f                   	pop    %edi
  802d12:	5d                   	pop    %ebp
  802d13:	c3                   	ret    
  802d14:	66 90                	xchg   %ax,%ax
  802d16:	66 90                	xchg   %ax,%ax
  802d18:	66 90                	xchg   %ax,%ax
  802d1a:	66 90                	xchg   %ax,%ax
  802d1c:	66 90                	xchg   %ax,%ax
  802d1e:	66 90                	xchg   %ax,%ax

00802d20 <__umoddi3>:
  802d20:	55                   	push   %ebp
  802d21:	57                   	push   %edi
  802d22:	56                   	push   %esi
  802d23:	83 ec 14             	sub    $0x14,%esp
  802d26:	8b 44 24 28          	mov    0x28(%esp),%eax
  802d2a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802d2e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802d32:	89 c7                	mov    %eax,%edi
  802d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d38:	8b 44 24 30          	mov    0x30(%esp),%eax
  802d3c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d40:	89 34 24             	mov    %esi,(%esp)
  802d43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d47:	85 c0                	test   %eax,%eax
  802d49:	89 c2                	mov    %eax,%edx
  802d4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d4f:	75 17                	jne    802d68 <__umoddi3+0x48>
  802d51:	39 fe                	cmp    %edi,%esi
  802d53:	76 4b                	jbe    802da0 <__umoddi3+0x80>
  802d55:	89 c8                	mov    %ecx,%eax
  802d57:	89 fa                	mov    %edi,%edx
  802d59:	f7 f6                	div    %esi
  802d5b:	89 d0                	mov    %edx,%eax
  802d5d:	31 d2                	xor    %edx,%edx
  802d5f:	83 c4 14             	add    $0x14,%esp
  802d62:	5e                   	pop    %esi
  802d63:	5f                   	pop    %edi
  802d64:	5d                   	pop    %ebp
  802d65:	c3                   	ret    
  802d66:	66 90                	xchg   %ax,%ax
  802d68:	39 f8                	cmp    %edi,%eax
  802d6a:	77 54                	ja     802dc0 <__umoddi3+0xa0>
  802d6c:	0f bd e8             	bsr    %eax,%ebp
  802d6f:	83 f5 1f             	xor    $0x1f,%ebp
  802d72:	75 5c                	jne    802dd0 <__umoddi3+0xb0>
  802d74:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d78:	39 3c 24             	cmp    %edi,(%esp)
  802d7b:	0f 87 e7 00 00 00    	ja     802e68 <__umoddi3+0x148>
  802d81:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d85:	29 f1                	sub    %esi,%ecx
  802d87:	19 c7                	sbb    %eax,%edi
  802d89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d91:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d95:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d99:	83 c4 14             	add    $0x14,%esp
  802d9c:	5e                   	pop    %esi
  802d9d:	5f                   	pop    %edi
  802d9e:	5d                   	pop    %ebp
  802d9f:	c3                   	ret    
  802da0:	85 f6                	test   %esi,%esi
  802da2:	89 f5                	mov    %esi,%ebp
  802da4:	75 0b                	jne    802db1 <__umoddi3+0x91>
  802da6:	b8 01 00 00 00       	mov    $0x1,%eax
  802dab:	31 d2                	xor    %edx,%edx
  802dad:	f7 f6                	div    %esi
  802daf:	89 c5                	mov    %eax,%ebp
  802db1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802db5:	31 d2                	xor    %edx,%edx
  802db7:	f7 f5                	div    %ebp
  802db9:	89 c8                	mov    %ecx,%eax
  802dbb:	f7 f5                	div    %ebp
  802dbd:	eb 9c                	jmp    802d5b <__umoddi3+0x3b>
  802dbf:	90                   	nop
  802dc0:	89 c8                	mov    %ecx,%eax
  802dc2:	89 fa                	mov    %edi,%edx
  802dc4:	83 c4 14             	add    $0x14,%esp
  802dc7:	5e                   	pop    %esi
  802dc8:	5f                   	pop    %edi
  802dc9:	5d                   	pop    %ebp
  802dca:	c3                   	ret    
  802dcb:	90                   	nop
  802dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dd0:	8b 04 24             	mov    (%esp),%eax
  802dd3:	be 20 00 00 00       	mov    $0x20,%esi
  802dd8:	89 e9                	mov    %ebp,%ecx
  802dda:	29 ee                	sub    %ebp,%esi
  802ddc:	d3 e2                	shl    %cl,%edx
  802dde:	89 f1                	mov    %esi,%ecx
  802de0:	d3 e8                	shr    %cl,%eax
  802de2:	89 e9                	mov    %ebp,%ecx
  802de4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802de8:	8b 04 24             	mov    (%esp),%eax
  802deb:	09 54 24 04          	or     %edx,0x4(%esp)
  802def:	89 fa                	mov    %edi,%edx
  802df1:	d3 e0                	shl    %cl,%eax
  802df3:	89 f1                	mov    %esi,%ecx
  802df5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802df9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802dfd:	d3 ea                	shr    %cl,%edx
  802dff:	89 e9                	mov    %ebp,%ecx
  802e01:	d3 e7                	shl    %cl,%edi
  802e03:	89 f1                	mov    %esi,%ecx
  802e05:	d3 e8                	shr    %cl,%eax
  802e07:	89 e9                	mov    %ebp,%ecx
  802e09:	09 f8                	or     %edi,%eax
  802e0b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802e0f:	f7 74 24 04          	divl   0x4(%esp)
  802e13:	d3 e7                	shl    %cl,%edi
  802e15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e19:	89 d7                	mov    %edx,%edi
  802e1b:	f7 64 24 08          	mull   0x8(%esp)
  802e1f:	39 d7                	cmp    %edx,%edi
  802e21:	89 c1                	mov    %eax,%ecx
  802e23:	89 14 24             	mov    %edx,(%esp)
  802e26:	72 2c                	jb     802e54 <__umoddi3+0x134>
  802e28:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802e2c:	72 22                	jb     802e50 <__umoddi3+0x130>
  802e2e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802e32:	29 c8                	sub    %ecx,%eax
  802e34:	19 d7                	sbb    %edx,%edi
  802e36:	89 e9                	mov    %ebp,%ecx
  802e38:	89 fa                	mov    %edi,%edx
  802e3a:	d3 e8                	shr    %cl,%eax
  802e3c:	89 f1                	mov    %esi,%ecx
  802e3e:	d3 e2                	shl    %cl,%edx
  802e40:	89 e9                	mov    %ebp,%ecx
  802e42:	d3 ef                	shr    %cl,%edi
  802e44:	09 d0                	or     %edx,%eax
  802e46:	89 fa                	mov    %edi,%edx
  802e48:	83 c4 14             	add    $0x14,%esp
  802e4b:	5e                   	pop    %esi
  802e4c:	5f                   	pop    %edi
  802e4d:	5d                   	pop    %ebp
  802e4e:	c3                   	ret    
  802e4f:	90                   	nop
  802e50:	39 d7                	cmp    %edx,%edi
  802e52:	75 da                	jne    802e2e <__umoddi3+0x10e>
  802e54:	8b 14 24             	mov    (%esp),%edx
  802e57:	89 c1                	mov    %eax,%ecx
  802e59:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e5d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e61:	eb cb                	jmp    802e2e <__umoddi3+0x10e>
  802e63:	90                   	nop
  802e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e68:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e6c:	0f 82 0f ff ff ff    	jb     802d81 <__umoddi3+0x61>
  802e72:	e9 1a ff ff ff       	jmp    802d91 <__umoddi3+0x71>
