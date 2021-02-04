
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 15 05 00 00       	call   800546 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004c:	89 34 24             	mov    %esi,(%esp)
  80004f:	e8 30 1d 00 00       	call   801d84 <seek>
	seek(kfd, off);
  800054:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800058:	89 3c 24             	mov    %edi,(%esp)
  80005b:	e8 24 1d 00 00       	call   801d84 <seek>

	cprintf("shell produced incorrect output.\n");
  800060:	c7 04 24 60 35 80 00 	movl   $0x803560,(%esp)
  800067:	e8 38 06 00 00       	call   8006a4 <cprintf>
	cprintf("expected:\n===\n");
  80006c:	c7 04 24 cb 35 80 00 	movl   $0x8035cb,(%esp)
  800073:	e8 2c 06 00 00       	call   8006a4 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	eb 0c                	jmp    800089 <wrong+0x56>
		sys_cputs(buf, n);
  80007d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800081:	89 1c 24             	mov    %ebx,(%esp)
  800084:	e8 8d 0f 00 00       	call   801016 <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800089:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  800090:	00 
  800091:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800095:	89 3c 24             	mov    %edi,(%esp)
  800098:	e8 7d 1b 00 00       	call   801c1a <read>
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f dc                	jg     80007d <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000a1:	c7 04 24 da 35 80 00 	movl   $0x8035da,(%esp)
  8000a8:	e8 f7 05 00 00       	call   8006a4 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ad:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b0:	eb 0c                	jmp    8000be <wrong+0x8b>
		sys_cputs(buf, n);
  8000b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b6:	89 1c 24             	mov    %ebx,(%esp)
  8000b9:	e8 58 0f 00 00       	call   801016 <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000be:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000c5:	00 
  8000c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ca:	89 34 24             	mov    %esi,(%esp)
  8000cd:	e8 48 1b 00 00       	call   801c1a <read>
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	7f dc                	jg     8000b2 <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000d6:	c7 04 24 d5 35 80 00 	movl   $0x8035d5,(%esp)
  8000dd:	e8 c2 05 00 00       	call   8006a4 <cprintf>
	exit();
  8000e2:	e8 ab 04 00 00       	call   800592 <exit>
}
  8000e7:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000ed:	5b                   	pop    %ebx
  8000ee:	5e                   	pop    %esi
  8000ef:	5f                   	pop    %edi
  8000f0:	5d                   	pop    %ebp
  8000f1:	c3                   	ret    

008000f2 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  8000fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800102:	e8 b0 19 00 00       	call   801ab7 <close>
	close(1);
  800107:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010e:	e8 a4 19 00 00       	call   801ab7 <close>
	opencons();
  800113:	e8 d3 03 00 00       	call   8004eb <opencons>
	opencons();
  800118:	e8 ce 03 00 00       	call   8004eb <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80011d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800124:	00 
  800125:	c7 04 24 e8 35 80 00 	movl   $0x8035e8,(%esp)
  80012c:	e8 b5 1f 00 00       	call   8020e6 <open>
  800131:	89 c3                	mov    %eax,%ebx
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 f5 35 80 	movl   $0x8035f5,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 0b 36 80 00 	movl   $0x80360b,(%esp)
  800152:	e8 54 04 00 00       	call   8005ab <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800157:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 72 2d 00 00       	call   802ed4 <pipe>
  800162:	85 c0                	test   %eax,%eax
  800164:	79 20                	jns    800186 <umain+0x94>
		panic("pipe: %e", wfd);
  800166:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016a:	c7 44 24 08 1c 36 80 	movl   $0x80361c,0x8(%esp)
  800171:	00 
  800172:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800179:	00 
  80017a:	c7 04 24 0b 36 80 00 	movl   $0x80360b,(%esp)
  800181:	e8 25 04 00 00       	call   8005ab <_panic>
	wfd = pfds[1];
  800186:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  800189:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800190:	e8 0f 05 00 00       	call   8006a4 <cprintf>
	if ((r = fork()) < 0)
  800195:	e8 a0 14 00 00       	call   80163a <fork>
  80019a:	85 c0                	test   %eax,%eax
  80019c:	79 20                	jns    8001be <umain+0xcc>
		panic("fork: %e", r);
  80019e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a2:	c7 44 24 08 25 36 80 	movl   $0x803625,0x8(%esp)
  8001a9:	00 
  8001aa:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8001b1:	00 
  8001b2:	c7 04 24 0b 36 80 00 	movl   $0x80360b,(%esp)
  8001b9:	e8 ed 03 00 00       	call   8005ab <_panic>
	if (r == 0) {
  8001be:	85 c0                	test   %eax,%eax
  8001c0:	0f 85 9f 00 00 00    	jne    800265 <umain+0x173>
		dup(rfd, 0);
  8001c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001cd:	00 
  8001ce:	89 1c 24             	mov    %ebx,(%esp)
  8001d1:	e8 36 19 00 00       	call   801b0c <dup>
		dup(wfd, 1);
  8001d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001dd:	00 
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 26 19 00 00       	call   801b0c <dup>
		close(rfd);
  8001e6:	89 1c 24             	mov    %ebx,(%esp)
  8001e9:	e8 c9 18 00 00       	call   801ab7 <close>
		close(wfd);
  8001ee:	89 34 24             	mov    %esi,(%esp)
  8001f1:	e8 c1 18 00 00       	call   801ab7 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  8001f6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001fd:	00 
  8001fe:	c7 44 24 08 2e 36 80 	movl   $0x80362e,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 f2 35 80 	movl   $0x8035f2,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 31 36 80 00 	movl   $0x803631,(%esp)
  800215:	e8 5d 25 00 00       	call   802777 <spawnl>
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	85 c0                	test   %eax,%eax
  80021e:	79 20                	jns    800240 <umain+0x14e>
			panic("spawn: %e", r);
  800220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800224:	c7 44 24 08 35 36 80 	movl   $0x803635,0x8(%esp)
  80022b:	00 
  80022c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800233:	00 
  800234:	c7 04 24 0b 36 80 00 	movl   $0x80360b,(%esp)
  80023b:	e8 6b 03 00 00       	call   8005ab <_panic>
		close(0);
  800240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800247:	e8 6b 18 00 00       	call   801ab7 <close>
		close(1);
  80024c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800253:	e8 5f 18 00 00       	call   801ab7 <close>
		wait(r);
  800258:	89 3c 24             	mov    %edi,(%esp)
  80025b:	e8 1a 2e 00 00       	call   80307a <wait>
		exit();
  800260:	e8 2d 03 00 00       	call   800592 <exit>
	}
	close(rfd);
  800265:	89 1c 24             	mov    %ebx,(%esp)
  800268:	e8 4a 18 00 00       	call   801ab7 <close>
	close(wfd);
  80026d:	89 34 24             	mov    %esi,(%esp)
  800270:	e8 42 18 00 00       	call   801ab7 <close>

	rfd = pfds[0];
  800275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800278:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  80027b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800282:	00 
  800283:	c7 04 24 3f 36 80 00 	movl   $0x80363f,(%esp)
  80028a:	e8 57 1e 00 00       	call   8020e6 <open>
  80028f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800292:	85 c0                	test   %eax,%eax
  800294:	79 20                	jns    8002b6 <umain+0x1c4>
		panic("open testshell.key for reading: %e", kfd);
  800296:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029a:	c7 44 24 08 a8 35 80 	movl   $0x8035a8,0x8(%esp)
  8002a1:	00 
  8002a2:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002a9:	00 
  8002aa:	c7 04 24 0b 36 80 00 	movl   $0x80360b,(%esp)
  8002b1:	e8 f5 02 00 00       	call   8005ab <_panic>
	}
	close(rfd);
	close(wfd);

	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002b6:	be 01 00 00 00       	mov    $0x1,%esi
  8002bb:	bf 00 00 00 00       	mov    $0x0,%edi
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  8002c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002c7:	00 
  8002c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d2:	89 04 24             	mov    %eax,(%esp)
  8002d5:	e8 40 19 00 00       	call   801c1a <read>
  8002da:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002e3:	00 
  8002e4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	e8 24 19 00 00       	call   801c1a <read>
		if (n1 < 0)
  8002f6:	85 db                	test   %ebx,%ebx
  8002f8:	79 20                	jns    80031a <umain+0x228>
			panic("reading testshell.out: %e", n1);
  8002fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002fe:	c7 44 24 08 4d 36 80 	movl   $0x80364d,0x8(%esp)
  800305:	00 
  800306:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80030d:	00 
  80030e:	c7 04 24 0b 36 80 00 	movl   $0x80360b,(%esp)
  800315:	e8 91 02 00 00       	call   8005ab <_panic>
		if (n2 < 0)
  80031a:	85 c0                	test   %eax,%eax
  80031c:	79 20                	jns    80033e <umain+0x24c>
			panic("reading testshell.key: %e", n2);
  80031e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800322:	c7 44 24 08 67 36 80 	movl   $0x803667,0x8(%esp)
  800329:	00 
  80032a:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800331:	00 
  800332:	c7 04 24 0b 36 80 00 	movl   $0x80360b,(%esp)
  800339:	e8 6d 02 00 00       	call   8005ab <_panic>
		if (n1 == 0 && n2 == 0)
  80033e:	89 c2                	mov    %eax,%edx
  800340:	09 da                	or     %ebx,%edx
  800342:	74 38                	je     80037c <umain+0x28a>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800344:	83 fb 01             	cmp    $0x1,%ebx
  800347:	75 0e                	jne    800357 <umain+0x265>
  800349:	83 f8 01             	cmp    $0x1,%eax
  80034c:	75 09                	jne    800357 <umain+0x265>
  80034e:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  800352:	38 45 e7             	cmp    %al,-0x19(%ebp)
  800355:	74 16                	je     80036d <umain+0x27b>
			wrong(rfd, kfd, nloff);
  800357:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80035b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800362:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	e8 c6 fc ff ff       	call   800033 <wrong>
		if (c1 == '\n')
			nloff = off+1;
  80036d:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  800371:	0f 44 fe             	cmove  %esi,%edi
  800374:	83 c6 01             	add    $0x1,%esi
	}
  800377:	e9 44 ff ff ff       	jmp    8002c0 <umain+0x1ce>
	cprintf("shell ran correctly\n");
  80037c:	c7 04 24 81 36 80 00 	movl   $0x803681,(%esp)
  800383:	e8 1c 03 00 00       	call   8006a4 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800388:	cc                   	int3   

	breakpoint();
}
  800389:	83 c4 3c             	add    $0x3c,%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    
  800391:	66 90                	xchg   %ax,%ax
  800393:	66 90                	xchg   %ax,%ax
  800395:	66 90                	xchg   %ax,%ax
  800397:	66 90                	xchg   %ax,%ax
  800399:	66 90                	xchg   %ax,%ax
  80039b:	66 90                	xchg   %ax,%ax
  80039d:	66 90                	xchg   %ax,%ax
  80039f:	90                   	nop

008003a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8003b0:	c7 44 24 04 96 36 80 	movl   $0x803696,0x4(%esp)
  8003b7:	00 
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	e8 04 09 00 00       	call   800cc7 <strcpy>
	return 0;
}
  8003c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
  8003d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003e1:	eb 31                	jmp    800414 <devcons_write+0x4a>
		m = n - tot;
  8003e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8003e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8003e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8003eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8003f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003f7:	03 45 0c             	add    0xc(%ebp),%eax
  8003fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fe:	89 3c 24             	mov    %edi,(%esp)
  800401:	e8 5e 0a 00 00       	call   800e64 <memmove>
		sys_cputs(buf, m);
  800406:	89 74 24 04          	mov    %esi,0x4(%esp)
  80040a:	89 3c 24             	mov    %edi,(%esp)
  80040d:	e8 04 0c 00 00       	call   801016 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800412:	01 f3                	add    %esi,%ebx
  800414:	89 d8                	mov    %ebx,%eax
  800416:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800419:	72 c8                	jb     8003e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80041b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80042c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800431:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800435:	75 07                	jne    80043e <devcons_read+0x18>
  800437:	eb 2a                	jmp    800463 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800439:	e8 86 0c 00 00       	call   8010c4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80043e:	66 90                	xchg   %ax,%ax
  800440:	e8 ef 0b 00 00       	call   801034 <sys_cgetc>
  800445:	85 c0                	test   %eax,%eax
  800447:	74 f0                	je     800439 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800449:	85 c0                	test   %eax,%eax
  80044b:	78 16                	js     800463 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80044d:	83 f8 04             	cmp    $0x4,%eax
  800450:	74 0c                	je     80045e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	88 02                	mov    %al,(%edx)
	return 1;
  800457:	b8 01 00 00 00       	mov    $0x1,%eax
  80045c:	eb 05                	jmp    800463 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80045e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800471:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800478:	00 
  800479:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80047c:	89 04 24             	mov    %eax,(%esp)
  80047f:	e8 92 0b 00 00       	call   801016 <sys_cputs>
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <getchar>:

int
getchar(void)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80048c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800493:	00 
  800494:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004a2:	e8 73 17 00 00       	call   801c1a <read>
	if (r < 0)
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	78 0f                	js     8004ba <getchar+0x34>
		return r;
	if (r < 1)
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	7e 06                	jle    8004b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8004af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8004b3:	eb 05                	jmp    8004ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8004b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	89 04 24             	mov    %eax,(%esp)
  8004cf:	e8 b2 14 00 00       	call   801986 <fd_lookup>
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	78 11                	js     8004e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8004d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004db:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8004e1:	39 10                	cmp    %edx,(%eax)
  8004e3:	0f 94 c0             	sete   %al
  8004e6:	0f b6 c0             	movzbl %al,%eax
}
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <opencons>:

int
opencons(void)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004f4:	89 04 24             	mov    %eax,(%esp)
  8004f7:	e8 3b 14 00 00       	call   801937 <fd_alloc>
		return r;
  8004fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004fe:	85 c0                	test   %eax,%eax
  800500:	78 40                	js     800542 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800502:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800509:	00 
  80050a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800518:	e8 c6 0b 00 00       	call   8010e3 <sys_page_alloc>
		return r;
  80051d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80051f:	85 c0                	test   %eax,%eax
  800521:	78 1f                	js     800542 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800523:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80052e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800531:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	e8 d0 13 00 00       	call   801910 <fd2num>
  800540:	89 c2                	mov    %eax,%edx
}
  800542:	89 d0                	mov    %edx,%eax
  800544:	c9                   	leave  
  800545:	c3                   	ret    

00800546 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	56                   	push   %esi
  80054a:	53                   	push   %ebx
  80054b:	83 ec 10             	sub    $0x10,%esp
  80054e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800551:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800554:	e8 4c 0b 00 00       	call   8010a5 <sys_getenvid>
  800559:	25 ff 03 00 00       	and    $0x3ff,%eax
  80055e:	89 c2                	mov    %eax,%edx
  800560:	c1 e2 07             	shl    $0x7,%edx
  800563:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80056a:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80056f:	85 db                	test   %ebx,%ebx
  800571:	7e 07                	jle    80057a <libmain+0x34>
		binaryname = argv[0];
  800573:	8b 06                	mov    (%esi),%eax
  800575:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  80057a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057e:	89 1c 24             	mov    %ebx,(%esp)
  800581:	e8 6c fb ff ff       	call   8000f2 <umain>

	// exit gracefully
	exit();
  800586:	e8 07 00 00 00       	call   800592 <exit>
}
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	5b                   	pop    %ebx
  80058f:	5e                   	pop    %esi
  800590:	5d                   	pop    %ebp
  800591:	c3                   	ret    

00800592 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800598:	e8 4d 15 00 00       	call   801aea <close_all>
	sys_env_destroy(0);
  80059d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005a4:	e8 aa 0a 00 00       	call   801053 <sys_env_destroy>
}
  8005a9:	c9                   	leave  
  8005aa:	c3                   	ret    

008005ab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	56                   	push   %esi
  8005af:	53                   	push   %ebx
  8005b0:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8005b3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005b6:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8005bc:	e8 e4 0a 00 00       	call   8010a5 <sys_getenvid>
  8005c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8005cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005cf:	89 74 24 08          	mov    %esi,0x8(%esp)
  8005d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d7:	c7 04 24 ac 36 80 00 	movl   $0x8036ac,(%esp)
  8005de:	e8 c1 00 00 00       	call   8006a4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ea:	89 04 24             	mov    %eax,(%esp)
  8005ed:	e8 51 00 00 00       	call   800643 <vcprintf>
	cprintf("\n");
  8005f2:	c7 04 24 d8 35 80 00 	movl   $0x8035d8,(%esp)
  8005f9:	e8 a6 00 00 00       	call   8006a4 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005fe:	cc                   	int3   
  8005ff:	eb fd                	jmp    8005fe <_panic+0x53>

00800601 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
  800604:	53                   	push   %ebx
  800605:	83 ec 14             	sub    $0x14,%esp
  800608:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80060b:	8b 13                	mov    (%ebx),%edx
  80060d:	8d 42 01             	lea    0x1(%edx),%eax
  800610:	89 03                	mov    %eax,(%ebx)
  800612:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800615:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800619:	3d ff 00 00 00       	cmp    $0xff,%eax
  80061e:	75 19                	jne    800639 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800620:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800627:	00 
  800628:	8d 43 08             	lea    0x8(%ebx),%eax
  80062b:	89 04 24             	mov    %eax,(%esp)
  80062e:	e8 e3 09 00 00       	call   801016 <sys_cputs>
		b->idx = 0;
  800633:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800639:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80063d:	83 c4 14             	add    $0x14,%esp
  800640:	5b                   	pop    %ebx
  800641:	5d                   	pop    %ebp
  800642:	c3                   	ret    

00800643 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
  800646:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80064c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800653:	00 00 00 
	b.cnt = 0;
  800656:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800660:	8b 45 0c             	mov    0xc(%ebp),%eax
  800663:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80066e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800674:	89 44 24 04          	mov    %eax,0x4(%esp)
  800678:	c7 04 24 01 06 80 00 	movl   $0x800601,(%esp)
  80067f:	e8 aa 01 00 00       	call   80082e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800684:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80068a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800694:	89 04 24             	mov    %eax,(%esp)
  800697:	e8 7a 09 00 00       	call   801016 <sys_cputs>

	return b.cnt;
}
  80069c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006a2:	c9                   	leave  
  8006a3:	c3                   	ret    

008006a4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006a4:	55                   	push   %ebp
  8006a5:	89 e5                	mov    %esp,%ebp
  8006a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006aa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 04 24             	mov    %eax,(%esp)
  8006b7:	e8 87 ff ff ff       	call   800643 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006bc:	c9                   	leave  
  8006bd:	c3                   	ret    
  8006be:	66 90                	xchg   %ax,%ax

008006c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	57                   	push   %edi
  8006c4:	56                   	push   %esi
  8006c5:	53                   	push   %ebx
  8006c6:	83 ec 3c             	sub    $0x3c,%esp
  8006c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cc:	89 d7                	mov    %edx,%edi
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d7:	89 c3                	mov    %eax,%ebx
  8006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8006df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ed:	39 d9                	cmp    %ebx,%ecx
  8006ef:	72 05                	jb     8006f6 <printnum+0x36>
  8006f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006f4:	77 69                	ja     80075f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8006fd:	83 ee 01             	sub    $0x1,%esi
  800700:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800704:	89 44 24 08          	mov    %eax,0x8(%esp)
  800708:	8b 44 24 08          	mov    0x8(%esp),%eax
  80070c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800710:	89 c3                	mov    %eax,%ebx
  800712:	89 d6                	mov    %edx,%esi
  800714:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800717:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80071a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80071e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800725:	89 04 24             	mov    %eax,(%esp)
  800728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072f:	e8 9c 2b 00 00       	call   8032d0 <__udivdi3>
  800734:	89 d9                	mov    %ebx,%ecx
  800736:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80073a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80073e:	89 04 24             	mov    %eax,(%esp)
  800741:	89 54 24 04          	mov    %edx,0x4(%esp)
  800745:	89 fa                	mov    %edi,%edx
  800747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80074a:	e8 71 ff ff ff       	call   8006c0 <printnum>
  80074f:	eb 1b                	jmp    80076c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800751:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800755:	8b 45 18             	mov    0x18(%ebp),%eax
  800758:	89 04 24             	mov    %eax,(%esp)
  80075b:	ff d3                	call   *%ebx
  80075d:	eb 03                	jmp    800762 <printnum+0xa2>
  80075f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800762:	83 ee 01             	sub    $0x1,%esi
  800765:	85 f6                	test   %esi,%esi
  800767:	7f e8                	jg     800751 <printnum+0x91>
  800769:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80076c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800770:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800774:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800777:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80077a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80077e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800782:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80078b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078f:	e8 6c 2c 00 00       	call   803400 <__umoddi3>
  800794:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800798:	0f be 80 cf 36 80 00 	movsbl 0x8036cf(%eax),%eax
  80079f:	89 04 24             	mov    %eax,(%esp)
  8007a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
}
  8007a7:	83 c4 3c             	add    $0x3c,%esp
  8007aa:	5b                   	pop    %ebx
  8007ab:	5e                   	pop    %esi
  8007ac:	5f                   	pop    %edi
  8007ad:	5d                   	pop    %ebp
  8007ae:	c3                   	ret    

008007af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b2:	83 fa 01             	cmp    $0x1,%edx
  8007b5:	7e 0e                	jle    8007c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007b7:	8b 10                	mov    (%eax),%edx
  8007b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007bc:	89 08                	mov    %ecx,(%eax)
  8007be:	8b 02                	mov    (%edx),%eax
  8007c0:	8b 52 04             	mov    0x4(%edx),%edx
  8007c3:	eb 22                	jmp    8007e7 <getuint+0x38>
	else if (lflag)
  8007c5:	85 d2                	test   %edx,%edx
  8007c7:	74 10                	je     8007d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007c9:	8b 10                	mov    (%eax),%edx
  8007cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007ce:	89 08                	mov    %ecx,(%eax)
  8007d0:	8b 02                	mov    (%edx),%eax
  8007d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d7:	eb 0e                	jmp    8007e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007d9:	8b 10                	mov    (%eax),%edx
  8007db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007de:	89 08                	mov    %ecx,(%eax)
  8007e0:	8b 02                	mov    (%edx),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007f3:	8b 10                	mov    (%eax),%edx
  8007f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8007f8:	73 0a                	jae    800804 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007fd:	89 08                	mov    %ecx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	88 02                	mov    %al,(%edx)
}
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80080c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80080f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800813:	8b 45 10             	mov    0x10(%ebp),%eax
  800816:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	89 04 24             	mov    %eax,(%esp)
  800827:	e8 02 00 00 00       	call   80082e <vprintfmt>
	va_end(ap);
}
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    

0080082e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	57                   	push   %edi
  800832:	56                   	push   %esi
  800833:	53                   	push   %ebx
  800834:	83 ec 3c             	sub    $0x3c,%esp
  800837:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80083a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80083d:	eb 14                	jmp    800853 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80083f:	85 c0                	test   %eax,%eax
  800841:	0f 84 b3 03 00 00    	je     800bfa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800847:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084b:	89 04 24             	mov    %eax,(%esp)
  80084e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800851:	89 f3                	mov    %esi,%ebx
  800853:	8d 73 01             	lea    0x1(%ebx),%esi
  800856:	0f b6 03             	movzbl (%ebx),%eax
  800859:	83 f8 25             	cmp    $0x25,%eax
  80085c:	75 e1                	jne    80083f <vprintfmt+0x11>
  80085e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800862:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800869:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800870:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800877:	ba 00 00 00 00       	mov    $0x0,%edx
  80087c:	eb 1d                	jmp    80089b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800880:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800884:	eb 15                	jmp    80089b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800886:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800888:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80088c:	eb 0d                	jmp    80089b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80088e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800891:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800894:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80089e:	0f b6 0e             	movzbl (%esi),%ecx
  8008a1:	0f b6 c1             	movzbl %cl,%eax
  8008a4:	83 e9 23             	sub    $0x23,%ecx
  8008a7:	80 f9 55             	cmp    $0x55,%cl
  8008aa:	0f 87 2a 03 00 00    	ja     800bda <vprintfmt+0x3ac>
  8008b0:	0f b6 c9             	movzbl %cl,%ecx
  8008b3:	ff 24 8d 40 38 80 00 	jmp    *0x803840(,%ecx,4)
  8008ba:	89 de                	mov    %ebx,%esi
  8008bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008c1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8008c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8008c8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8008cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8008ce:	83 fb 09             	cmp    $0x9,%ebx
  8008d1:	77 36                	ja     800909 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d6:	eb e9                	jmp    8008c1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8d 48 04             	lea    0x4(%eax),%ecx
  8008de:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8008e8:	eb 22                	jmp    80090c <vprintfmt+0xde>
  8008ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8008ed:	85 c9                	test   %ecx,%ecx
  8008ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f4:	0f 49 c1             	cmovns %ecx,%eax
  8008f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008fa:	89 de                	mov    %ebx,%esi
  8008fc:	eb 9d                	jmp    80089b <vprintfmt+0x6d>
  8008fe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800900:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800907:	eb 92                	jmp    80089b <vprintfmt+0x6d>
  800909:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80090c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800910:	79 89                	jns    80089b <vprintfmt+0x6d>
  800912:	e9 77 ff ff ff       	jmp    80088e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800917:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80091c:	e9 7a ff ff ff       	jmp    80089b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8d 50 04             	lea    0x4(%eax),%edx
  800927:	89 55 14             	mov    %edx,0x14(%ebp)
  80092a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	89 04 24             	mov    %eax,(%esp)
  800933:	ff 55 08             	call   *0x8(%ebp)
			break;
  800936:	e9 18 ff ff ff       	jmp    800853 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	8d 50 04             	lea    0x4(%eax),%edx
  800941:	89 55 14             	mov    %edx,0x14(%ebp)
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
  800947:	31 d0                	xor    %edx,%eax
  800949:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80094b:	83 f8 12             	cmp    $0x12,%eax
  80094e:	7f 0b                	jg     80095b <vprintfmt+0x12d>
  800950:	8b 14 85 a0 39 80 00 	mov    0x8039a0(,%eax,4),%edx
  800957:	85 d2                	test   %edx,%edx
  800959:	75 20                	jne    80097b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80095b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80095f:	c7 44 24 08 e7 36 80 	movl   $0x8036e7,0x8(%esp)
  800966:	00 
  800967:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	89 04 24             	mov    %eax,(%esp)
  800971:	e8 90 fe ff ff       	call   800806 <printfmt>
  800976:	e9 d8 fe ff ff       	jmp    800853 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80097b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80097f:	c7 44 24 08 d5 3b 80 	movl   $0x803bd5,0x8(%esp)
  800986:	00 
  800987:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 04 24             	mov    %eax,(%esp)
  800991:	e8 70 fe ff ff       	call   800806 <printfmt>
  800996:	e9 b8 fe ff ff       	jmp    800853 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80099e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8009ad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8009af:	85 f6                	test   %esi,%esi
  8009b1:	b8 e0 36 80 00       	mov    $0x8036e0,%eax
  8009b6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8009b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8009bd:	0f 84 97 00 00 00    	je     800a5a <vprintfmt+0x22c>
  8009c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8009c7:	0f 8e 9b 00 00 00    	jle    800a68 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009d1:	89 34 24             	mov    %esi,(%esp)
  8009d4:	e8 cf 02 00 00       	call   800ca8 <strnlen>
  8009d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8009dc:	29 c2                	sub    %eax,%edx
  8009de:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8009e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8009e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8009eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f3:	eb 0f                	jmp    800a04 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8009f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009fc:	89 04 24             	mov    %eax,(%esp)
  8009ff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a01:	83 eb 01             	sub    $0x1,%ebx
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	7f ed                	jg     8009f5 <vprintfmt+0x1c7>
  800a08:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800a0b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a0e:	85 d2                	test   %edx,%edx
  800a10:	b8 00 00 00 00       	mov    $0x0,%eax
  800a15:	0f 49 c2             	cmovns %edx,%eax
  800a18:	29 c2                	sub    %eax,%edx
  800a1a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a1d:	89 d7                	mov    %edx,%edi
  800a1f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a22:	eb 50                	jmp    800a74 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a28:	74 1e                	je     800a48 <vprintfmt+0x21a>
  800a2a:	0f be d2             	movsbl %dl,%edx
  800a2d:	83 ea 20             	sub    $0x20,%edx
  800a30:	83 fa 5e             	cmp    $0x5e,%edx
  800a33:	76 13                	jbe    800a48 <vprintfmt+0x21a>
					putch('?', putdat);
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a43:	ff 55 08             	call   *0x8(%ebp)
  800a46:	eb 0d                	jmp    800a55 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a4f:	89 04 24             	mov    %eax,(%esp)
  800a52:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a55:	83 ef 01             	sub    $0x1,%edi
  800a58:	eb 1a                	jmp    800a74 <vprintfmt+0x246>
  800a5a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a5d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a60:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a63:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a66:	eb 0c                	jmp    800a74 <vprintfmt+0x246>
  800a68:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a6b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a6e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a71:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a74:	83 c6 01             	add    $0x1,%esi
  800a77:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800a7b:	0f be c2             	movsbl %dl,%eax
  800a7e:	85 c0                	test   %eax,%eax
  800a80:	74 27                	je     800aa9 <vprintfmt+0x27b>
  800a82:	85 db                	test   %ebx,%ebx
  800a84:	78 9e                	js     800a24 <vprintfmt+0x1f6>
  800a86:	83 eb 01             	sub    $0x1,%ebx
  800a89:	79 99                	jns    800a24 <vprintfmt+0x1f6>
  800a8b:	89 f8                	mov    %edi,%eax
  800a8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a90:	8b 75 08             	mov    0x8(%ebp),%esi
  800a93:	89 c3                	mov    %eax,%ebx
  800a95:	eb 1a                	jmp    800ab1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a9b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800aa2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa4:	83 eb 01             	sub    $0x1,%ebx
  800aa7:	eb 08                	jmp    800ab1 <vprintfmt+0x283>
  800aa9:	89 fb                	mov    %edi,%ebx
  800aab:	8b 75 08             	mov    0x8(%ebp),%esi
  800aae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ab1:	85 db                	test   %ebx,%ebx
  800ab3:	7f e2                	jg     800a97 <vprintfmt+0x269>
  800ab5:	89 75 08             	mov    %esi,0x8(%ebp)
  800ab8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800abb:	e9 93 fd ff ff       	jmp    800853 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ac0:	83 fa 01             	cmp    $0x1,%edx
  800ac3:	7e 16                	jle    800adb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	8d 50 08             	lea    0x8(%eax),%edx
  800acb:	89 55 14             	mov    %edx,0x14(%ebp)
  800ace:	8b 50 04             	mov    0x4(%eax),%edx
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ad6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ad9:	eb 32                	jmp    800b0d <vprintfmt+0x2df>
	else if (lflag)
  800adb:	85 d2                	test   %edx,%edx
  800add:	74 18                	je     800af7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	8d 50 04             	lea    0x4(%eax),%edx
  800ae5:	89 55 14             	mov    %edx,0x14(%ebp)
  800ae8:	8b 30                	mov    (%eax),%esi
  800aea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800aed:	89 f0                	mov    %esi,%eax
  800aef:	c1 f8 1f             	sar    $0x1f,%eax
  800af2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800af5:	eb 16                	jmp    800b0d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	8d 50 04             	lea    0x4(%eax),%edx
  800afd:	89 55 14             	mov    %edx,0x14(%ebp)
  800b00:	8b 30                	mov    (%eax),%esi
  800b02:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b05:	89 f0                	mov    %esi,%eax
  800b07:	c1 f8 1f             	sar    $0x1f,%eax
  800b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b13:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1c:	0f 89 80 00 00 00    	jns    800ba2 <vprintfmt+0x374>
				putch('-', putdat);
  800b22:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b26:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b2d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b36:	f7 d8                	neg    %eax
  800b38:	83 d2 00             	adc    $0x0,%edx
  800b3b:	f7 da                	neg    %edx
			}
			base = 10;
  800b3d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b42:	eb 5e                	jmp    800ba2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b44:	8d 45 14             	lea    0x14(%ebp),%eax
  800b47:	e8 63 fc ff ff       	call   8007af <getuint>
			base = 10;
  800b4c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800b51:	eb 4f                	jmp    800ba2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800b53:	8d 45 14             	lea    0x14(%ebp),%eax
  800b56:	e8 54 fc ff ff       	call   8007af <getuint>
			base = 8;
  800b5b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800b60:	eb 40                	jmp    800ba2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800b62:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b66:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b6d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b74:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b7b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b81:	8d 50 04             	lea    0x4(%eax),%edx
  800b84:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b8e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b93:	eb 0d                	jmp    800ba2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b95:	8d 45 14             	lea    0x14(%ebp),%eax
  800b98:	e8 12 fc ff ff       	call   8007af <getuint>
			base = 16;
  800b9d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ba2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800ba6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800baa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800bad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bb1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bb5:	89 04 24             	mov    %eax,(%esp)
  800bb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bbc:	89 fa                	mov    %edi,%edx
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	e8 fa fa ff ff       	call   8006c0 <printnum>
			break;
  800bc6:	e9 88 fc ff ff       	jmp    800853 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bcb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bcf:	89 04 24             	mov    %eax,(%esp)
  800bd2:	ff 55 08             	call   *0x8(%ebp)
			break;
  800bd5:	e9 79 fc ff ff       	jmp    800853 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bda:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bde:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800be5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be8:	89 f3                	mov    %esi,%ebx
  800bea:	eb 03                	jmp    800bef <vprintfmt+0x3c1>
  800bec:	83 eb 01             	sub    $0x1,%ebx
  800bef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800bf3:	75 f7                	jne    800bec <vprintfmt+0x3be>
  800bf5:	e9 59 fc ff ff       	jmp    800853 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800bfa:	83 c4 3c             	add    $0x3c,%esp
  800bfd:	5b                   	pop    %ebx
  800bfe:	5e                   	pop    %esi
  800bff:	5f                   	pop    %edi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 28             	sub    $0x28,%esp
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c11:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	74 30                	je     800c53 <vsnprintf+0x51>
  800c23:	85 d2                	test   %edx,%edx
  800c25:	7e 2c                	jle    800c53 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3c:	c7 04 24 e9 07 80 00 	movl   $0x8007e9,(%esp)
  800c43:	e8 e6 fb ff ff       	call   80082e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c51:	eb 05                	jmp    800c58 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800c53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c60:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 04 24             	mov    %eax,(%esp)
  800c7b:	e8 82 ff ff ff       	call   800c02 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    
  800c82:	66 90                	xchg   %ax,%ax
  800c84:	66 90                	xchg   %ax,%ax
  800c86:	66 90                	xchg   %ax,%ax
  800c88:	66 90                	xchg   %ax,%ax
  800c8a:	66 90                	xchg   %ax,%ax
  800c8c:	66 90                	xchg   %ax,%ax
  800c8e:	66 90                	xchg   %ax,%ax

00800c90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c96:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9b:	eb 03                	jmp    800ca0 <strlen+0x10>
		n++;
  800c9d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ca4:	75 f7                	jne    800c9d <strlen+0xd>
		n++;
	return n;
}
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	eb 03                	jmp    800cbb <strnlen+0x13>
		n++;
  800cb8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cbb:	39 d0                	cmp    %edx,%eax
  800cbd:	74 06                	je     800cc5 <strnlen+0x1d>
  800cbf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800cc3:	75 f3                	jne    800cb8 <strnlen+0x10>
		n++;
	return n;
}
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	53                   	push   %ebx
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cd1:	89 c2                	mov    %eax,%edx
  800cd3:	83 c2 01             	add    $0x1,%edx
  800cd6:	83 c1 01             	add    $0x1,%ecx
  800cd9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800cdd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ce0:	84 db                	test   %bl,%bl
  800ce2:	75 ef                	jne    800cd3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ce4:	5b                   	pop    %ebx
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cf1:	89 1c 24             	mov    %ebx,(%esp)
  800cf4:	e8 97 ff ff ff       	call   800c90 <strlen>
	strcpy(dst + len, src);
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d00:	01 d8                	add    %ebx,%eax
  800d02:	89 04 24             	mov    %eax,(%esp)
  800d05:	e8 bd ff ff ff       	call   800cc7 <strcpy>
	return dst;
}
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 c4 08             	add    $0x8,%esp
  800d0f:	5b                   	pop    %ebx
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	8b 75 08             	mov    0x8(%ebp),%esi
  800d1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1d:	89 f3                	mov    %esi,%ebx
  800d1f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d22:	89 f2                	mov    %esi,%edx
  800d24:	eb 0f                	jmp    800d35 <strncpy+0x23>
		*dst++ = *src;
  800d26:	83 c2 01             	add    $0x1,%edx
  800d29:	0f b6 01             	movzbl (%ecx),%eax
  800d2c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d2f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d32:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d35:	39 da                	cmp    %ebx,%edx
  800d37:	75 ed                	jne    800d26 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d39:	89 f0                	mov    %esi,%eax
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	8b 75 08             	mov    0x8(%ebp),%esi
  800d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d4d:	89 f0                	mov    %esi,%eax
  800d4f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d53:	85 c9                	test   %ecx,%ecx
  800d55:	75 0b                	jne    800d62 <strlcpy+0x23>
  800d57:	eb 1d                	jmp    800d76 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d59:	83 c0 01             	add    $0x1,%eax
  800d5c:	83 c2 01             	add    $0x1,%edx
  800d5f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d62:	39 d8                	cmp    %ebx,%eax
  800d64:	74 0b                	je     800d71 <strlcpy+0x32>
  800d66:	0f b6 0a             	movzbl (%edx),%ecx
  800d69:	84 c9                	test   %cl,%cl
  800d6b:	75 ec                	jne    800d59 <strlcpy+0x1a>
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	eb 02                	jmp    800d73 <strlcpy+0x34>
  800d71:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d73:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d76:	29 f0                	sub    %esi,%eax
}
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d82:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d85:	eb 06                	jmp    800d8d <strcmp+0x11>
		p++, q++;
  800d87:	83 c1 01             	add    $0x1,%ecx
  800d8a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d8d:	0f b6 01             	movzbl (%ecx),%eax
  800d90:	84 c0                	test   %al,%al
  800d92:	74 04                	je     800d98 <strcmp+0x1c>
  800d94:	3a 02                	cmp    (%edx),%al
  800d96:	74 ef                	je     800d87 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d98:	0f b6 c0             	movzbl %al,%eax
  800d9b:	0f b6 12             	movzbl (%edx),%edx
  800d9e:	29 d0                	sub    %edx,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	53                   	push   %ebx
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dac:	89 c3                	mov    %eax,%ebx
  800dae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800db1:	eb 06                	jmp    800db9 <strncmp+0x17>
		n--, p++, q++;
  800db3:	83 c0 01             	add    $0x1,%eax
  800db6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800db9:	39 d8                	cmp    %ebx,%eax
  800dbb:	74 15                	je     800dd2 <strncmp+0x30>
  800dbd:	0f b6 08             	movzbl (%eax),%ecx
  800dc0:	84 c9                	test   %cl,%cl
  800dc2:	74 04                	je     800dc8 <strncmp+0x26>
  800dc4:	3a 0a                	cmp    (%edx),%cl
  800dc6:	74 eb                	je     800db3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc8:	0f b6 00             	movzbl (%eax),%eax
  800dcb:	0f b6 12             	movzbl (%edx),%edx
  800dce:	29 d0                	sub    %edx,%eax
  800dd0:	eb 05                	jmp    800dd7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800dd2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800dd7:	5b                   	pop    %ebx
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800de4:	eb 07                	jmp    800ded <strchr+0x13>
		if (*s == c)
  800de6:	38 ca                	cmp    %cl,%dl
  800de8:	74 0f                	je     800df9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dea:	83 c0 01             	add    $0x1,%eax
  800ded:	0f b6 10             	movzbl (%eax),%edx
  800df0:	84 d2                	test   %dl,%dl
  800df2:	75 f2                	jne    800de6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e05:	eb 07                	jmp    800e0e <strfind+0x13>
		if (*s == c)
  800e07:	38 ca                	cmp    %cl,%dl
  800e09:	74 0a                	je     800e15 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	83 c0 01             	add    $0x1,%eax
  800e0e:	0f b6 10             	movzbl (%eax),%edx
  800e11:	84 d2                	test   %dl,%dl
  800e13:	75 f2                	jne    800e07 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e23:	85 c9                	test   %ecx,%ecx
  800e25:	74 36                	je     800e5d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e27:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e2d:	75 28                	jne    800e57 <memset+0x40>
  800e2f:	f6 c1 03             	test   $0x3,%cl
  800e32:	75 23                	jne    800e57 <memset+0x40>
		c &= 0xFF;
  800e34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e38:	89 d3                	mov    %edx,%ebx
  800e3a:	c1 e3 08             	shl    $0x8,%ebx
  800e3d:	89 d6                	mov    %edx,%esi
  800e3f:	c1 e6 18             	shl    $0x18,%esi
  800e42:	89 d0                	mov    %edx,%eax
  800e44:	c1 e0 10             	shl    $0x10,%eax
  800e47:	09 f0                	or     %esi,%eax
  800e49:	09 c2                	or     %eax,%edx
  800e4b:	89 d0                	mov    %edx,%eax
  800e4d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e4f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800e52:	fc                   	cld    
  800e53:	f3 ab                	rep stos %eax,%es:(%edi)
  800e55:	eb 06                	jmp    800e5d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	fc                   	cld    
  800e5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e5d:	89 f8                	mov    %edi,%eax
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	39 c6                	cmp    %eax,%esi
  800e74:	73 35                	jae    800eab <memmove+0x47>
  800e76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e79:	39 d0                	cmp    %edx,%eax
  800e7b:	73 2e                	jae    800eab <memmove+0x47>
		s += n;
		d += n;
  800e7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e80:	89 d6                	mov    %edx,%esi
  800e82:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e8a:	75 13                	jne    800e9f <memmove+0x3b>
  800e8c:	f6 c1 03             	test   $0x3,%cl
  800e8f:	75 0e                	jne    800e9f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e91:	83 ef 04             	sub    $0x4,%edi
  800e94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e9a:	fd                   	std    
  800e9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e9d:	eb 09                	jmp    800ea8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e9f:	83 ef 01             	sub    $0x1,%edi
  800ea2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ea5:	fd                   	std    
  800ea6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ea8:	fc                   	cld    
  800ea9:	eb 1d                	jmp    800ec8 <memmove+0x64>
  800eab:	89 f2                	mov    %esi,%edx
  800ead:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eaf:	f6 c2 03             	test   $0x3,%dl
  800eb2:	75 0f                	jne    800ec3 <memmove+0x5f>
  800eb4:	f6 c1 03             	test   $0x3,%cl
  800eb7:	75 0a                	jne    800ec3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800eb9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800ebc:	89 c7                	mov    %eax,%edi
  800ebe:	fc                   	cld    
  800ebf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ec1:	eb 05                	jmp    800ec8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ec3:	89 c7                	mov    %eax,%edi
  800ec5:	fc                   	cld    
  800ec6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 04 24             	mov    %eax,(%esp)
  800ee6:	e8 79 ff ff ff       	call   800e64 <memmove>
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
  800ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef8:	89 d6                	mov    %edx,%esi
  800efa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800efd:	eb 1a                	jmp    800f19 <memcmp+0x2c>
		if (*s1 != *s2)
  800eff:	0f b6 02             	movzbl (%edx),%eax
  800f02:	0f b6 19             	movzbl (%ecx),%ebx
  800f05:	38 d8                	cmp    %bl,%al
  800f07:	74 0a                	je     800f13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	0f b6 db             	movzbl %bl,%ebx
  800f0f:	29 d8                	sub    %ebx,%eax
  800f11:	eb 0f                	jmp    800f22 <memcmp+0x35>
		s1++, s2++;
  800f13:	83 c2 01             	add    $0x1,%edx
  800f16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f19:	39 f2                	cmp    %esi,%edx
  800f1b:	75 e2                	jne    800eff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f2f:	89 c2                	mov    %eax,%edx
  800f31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f34:	eb 07                	jmp    800f3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f36:	38 08                	cmp    %cl,(%eax)
  800f38:	74 07                	je     800f41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f3a:	83 c0 01             	add    $0x1,%eax
  800f3d:	39 d0                	cmp    %edx,%eax
  800f3f:	72 f5                	jb     800f36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	57                   	push   %edi
  800f47:	56                   	push   %esi
  800f48:	53                   	push   %ebx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4f:	eb 03                	jmp    800f54 <strtol+0x11>
		s++;
  800f51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f54:	0f b6 0a             	movzbl (%edx),%ecx
  800f57:	80 f9 09             	cmp    $0x9,%cl
  800f5a:	74 f5                	je     800f51 <strtol+0xe>
  800f5c:	80 f9 20             	cmp    $0x20,%cl
  800f5f:	74 f0                	je     800f51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f61:	80 f9 2b             	cmp    $0x2b,%cl
  800f64:	75 0a                	jne    800f70 <strtol+0x2d>
		s++;
  800f66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f69:	bf 00 00 00 00       	mov    $0x0,%edi
  800f6e:	eb 11                	jmp    800f81 <strtol+0x3e>
  800f70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f75:	80 f9 2d             	cmp    $0x2d,%cl
  800f78:	75 07                	jne    800f81 <strtol+0x3e>
		s++, neg = 1;
  800f7a:	8d 52 01             	lea    0x1(%edx),%edx
  800f7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f86:	75 15                	jne    800f9d <strtol+0x5a>
  800f88:	80 3a 30             	cmpb   $0x30,(%edx)
  800f8b:	75 10                	jne    800f9d <strtol+0x5a>
  800f8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f91:	75 0a                	jne    800f9d <strtol+0x5a>
		s += 2, base = 16;
  800f93:	83 c2 02             	add    $0x2,%edx
  800f96:	b8 10 00 00 00       	mov    $0x10,%eax
  800f9b:	eb 10                	jmp    800fad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	75 0c                	jne    800fad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fa1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fa3:	80 3a 30             	cmpb   $0x30,(%edx)
  800fa6:	75 05                	jne    800fad <strtol+0x6a>
		s++, base = 8;
  800fa8:	83 c2 01             	add    $0x1,%edx
  800fab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800fad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	0f b6 0a             	movzbl (%edx),%ecx
  800fb8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	3c 09                	cmp    $0x9,%al
  800fbf:	77 08                	ja     800fc9 <strtol+0x86>
			dig = *s - '0';
  800fc1:	0f be c9             	movsbl %cl,%ecx
  800fc4:	83 e9 30             	sub    $0x30,%ecx
  800fc7:	eb 20                	jmp    800fe9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800fcc:	89 f0                	mov    %esi,%eax
  800fce:	3c 19                	cmp    $0x19,%al
  800fd0:	77 08                	ja     800fda <strtol+0x97>
			dig = *s - 'a' + 10;
  800fd2:	0f be c9             	movsbl %cl,%ecx
  800fd5:	83 e9 57             	sub    $0x57,%ecx
  800fd8:	eb 0f                	jmp    800fe9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800fda:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800fdd:	89 f0                	mov    %esi,%eax
  800fdf:	3c 19                	cmp    $0x19,%al
  800fe1:	77 16                	ja     800ff9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800fe3:	0f be c9             	movsbl %cl,%ecx
  800fe6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800fe9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800fec:	7d 0f                	jge    800ffd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800fee:	83 c2 01             	add    $0x1,%edx
  800ff1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ff5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ff7:	eb bc                	jmp    800fb5 <strtol+0x72>
  800ff9:	89 d8                	mov    %ebx,%eax
  800ffb:	eb 02                	jmp    800fff <strtol+0xbc>
  800ffd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800fff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801003:	74 05                	je     80100a <strtol+0xc7>
		*endptr = (char *) s;
  801005:	8b 75 0c             	mov    0xc(%ebp),%esi
  801008:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80100a:	f7 d8                	neg    %eax
  80100c:	85 ff                	test   %edi,%edi
  80100e:	0f 44 c3             	cmove  %ebx,%eax
}
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101c:	b8 00 00 00 00       	mov    $0x0,%eax
  801021:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801024:	8b 55 08             	mov    0x8(%ebp),%edx
  801027:	89 c3                	mov    %eax,%ebx
  801029:	89 c7                	mov    %eax,%edi
  80102b:	89 c6                	mov    %eax,%esi
  80102d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <sys_cgetc>:

int
sys_cgetc(void)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	57                   	push   %edi
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103a:	ba 00 00 00 00       	mov    $0x0,%edx
  80103f:	b8 01 00 00 00       	mov    $0x1,%eax
  801044:	89 d1                	mov    %edx,%ecx
  801046:	89 d3                	mov    %edx,%ebx
  801048:	89 d7                	mov    %edx,%edi
  80104a:	89 d6                	mov    %edx,%esi
  80104c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  80105c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 cb                	mov    %ecx,%ebx
  80106b:	89 cf                	mov    %ecx,%edi
  80106d:	89 ce                	mov    %ecx,%esi
  80106f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801071:	85 c0                	test   %eax,%eax
  801073:	7e 28                	jle    80109d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801075:	89 44 24 10          	mov    %eax,0x10(%esp)
  801079:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801080:	00 
  801081:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  801088:	00 
  801089:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801090:	00 
  801091:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  801098:	e8 0e f5 ff ff       	call   8005ab <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80109d:	83 c4 2c             	add    $0x2c,%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	57                   	push   %edi
  8010a9:	56                   	push   %esi
  8010aa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b0:	b8 02 00 00 00       	mov    $0x2,%eax
  8010b5:	89 d1                	mov    %edx,%ecx
  8010b7:	89 d3                	mov    %edx,%ebx
  8010b9:	89 d7                	mov    %edx,%edi
  8010bb:	89 d6                	mov    %edx,%esi
  8010bd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <sys_yield>:

void
sys_yield(void)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cf:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010d4:	89 d1                	mov    %edx,%ecx
  8010d6:	89 d3                	mov    %edx,%ebx
  8010d8:	89 d7                	mov    %edx,%edi
  8010da:	89 d6                	mov    %edx,%esi
  8010dc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010de:	5b                   	pop    %ebx
  8010df:	5e                   	pop    %esi
  8010e0:	5f                   	pop    %edi
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    

008010e3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  8010ec:	be 00 00 00 00       	mov    $0x0,%esi
  8010f1:	b8 04 00 00 00       	mov    $0x4,%eax
  8010f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ff:	89 f7                	mov    %esi,%edi
  801101:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801103:	85 c0                	test   %eax,%eax
  801105:	7e 28                	jle    80112f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801107:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801112:	00 
  801113:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  80111a:	00 
  80111b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801122:	00 
  801123:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  80112a:	e8 7c f4 ff ff       	call   8005ab <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80112f:	83 c4 2c             	add    $0x2c,%esp
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801140:	b8 05 00 00 00       	mov    $0x5,%eax
  801145:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801148:	8b 55 08             	mov    0x8(%ebp),%edx
  80114b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801151:	8b 75 18             	mov    0x18(%ebp),%esi
  801154:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801156:	85 c0                	test   %eax,%eax
  801158:	7e 28                	jle    801182 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80115a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801165:	00 
  801166:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  80116d:	00 
  80116e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801175:	00 
  801176:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  80117d:	e8 29 f4 ff ff       	call   8005ab <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801182:	83 c4 2c             	add    $0x2c,%esp
  801185:	5b                   	pop    %ebx
  801186:	5e                   	pop    %esi
  801187:	5f                   	pop    %edi
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	57                   	push   %edi
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
  801190:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801193:	bb 00 00 00 00       	mov    $0x0,%ebx
  801198:	b8 06 00 00 00       	mov    $0x6,%eax
  80119d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a3:	89 df                	mov    %ebx,%edi
  8011a5:	89 de                	mov    %ebx,%esi
  8011a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	7e 28                	jle    8011d5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011b8:	00 
  8011b9:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  8011c0:	00 
  8011c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c8:	00 
  8011c9:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  8011d0:	e8 d6 f3 ff ff       	call   8005ab <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011d5:	83 c4 2c             	add    $0x2c,%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5f                   	pop    %edi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	57                   	push   %edi
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
  8011e3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8011f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f6:	89 df                	mov    %ebx,%edi
  8011f8:	89 de                	mov    %ebx,%esi
  8011fa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	7e 28                	jle    801228 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801200:	89 44 24 10          	mov    %eax,0x10(%esp)
  801204:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80120b:	00 
  80120c:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  801213:	00 
  801214:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80121b:	00 
  80121c:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  801223:	e8 83 f3 ff ff       	call   8005ab <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801228:	83 c4 2c             	add    $0x2c,%esp
  80122b:	5b                   	pop    %ebx
  80122c:	5e                   	pop    %esi
  80122d:	5f                   	pop    %edi
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
  801236:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801239:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123e:	b8 09 00 00 00       	mov    $0x9,%eax
  801243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801246:	8b 55 08             	mov    0x8(%ebp),%edx
  801249:	89 df                	mov    %ebx,%edi
  80124b:	89 de                	mov    %ebx,%esi
  80124d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80124f:	85 c0                	test   %eax,%eax
  801251:	7e 28                	jle    80127b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801253:	89 44 24 10          	mov    %eax,0x10(%esp)
  801257:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80125e:	00 
  80125f:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  801266:	00 
  801267:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126e:	00 
  80126f:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  801276:	e8 30 f3 ff ff       	call   8005ab <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80127b:	83 c4 2c             	add    $0x2c,%esp
  80127e:	5b                   	pop    %ebx
  80127f:	5e                   	pop    %esi
  801280:	5f                   	pop    %edi
  801281:	5d                   	pop    %ebp
  801282:	c3                   	ret    

00801283 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	57                   	push   %edi
  801287:	56                   	push   %esi
  801288:	53                   	push   %ebx
  801289:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801291:	b8 0a 00 00 00       	mov    $0xa,%eax
  801296:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801299:	8b 55 08             	mov    0x8(%ebp),%edx
  80129c:	89 df                	mov    %ebx,%edi
  80129e:	89 de                	mov    %ebx,%esi
  8012a0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	7e 28                	jle    8012ce <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012aa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8012b1:	00 
  8012b2:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  8012b9:	00 
  8012ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c1:	00 
  8012c2:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  8012c9:	e8 dd f2 ff ff       	call   8005ab <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012ce:	83 c4 2c             	add    $0x2c,%esp
  8012d1:	5b                   	pop    %ebx
  8012d2:	5e                   	pop    %esi
  8012d3:	5f                   	pop    %edi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	57                   	push   %edi
  8012da:	56                   	push   %esi
  8012db:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012dc:	be 00 00 00 00       	mov    $0x0,%esi
  8012e1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012f2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012f4:	5b                   	pop    %ebx
  8012f5:	5e                   	pop    %esi
  8012f6:	5f                   	pop    %edi
  8012f7:	5d                   	pop    %ebp
  8012f8:	c3                   	ret    

008012f9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	57                   	push   %edi
  8012fd:	56                   	push   %esi
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801302:	b9 00 00 00 00       	mov    $0x0,%ecx
  801307:	b8 0d 00 00 00       	mov    $0xd,%eax
  80130c:	8b 55 08             	mov    0x8(%ebp),%edx
  80130f:	89 cb                	mov    %ecx,%ebx
  801311:	89 cf                	mov    %ecx,%edi
  801313:	89 ce                	mov    %ecx,%esi
  801315:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801317:	85 c0                	test   %eax,%eax
  801319:	7e 28                	jle    801343 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80131b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80131f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801326:	00 
  801327:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  80132e:	00 
  80132f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801336:	00 
  801337:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  80133e:	e8 68 f2 ff ff       	call   8005ab <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801343:	83 c4 2c             	add    $0x2c,%esp
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	57                   	push   %edi
  80134f:	56                   	push   %esi
  801350:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801351:	ba 00 00 00 00       	mov    $0x0,%edx
  801356:	b8 0e 00 00 00       	mov    $0xe,%eax
  80135b:	89 d1                	mov    %edx,%ecx
  80135d:	89 d3                	mov    %edx,%ebx
  80135f:	89 d7                	mov    %edx,%edi
  801361:	89 d6                	mov    %edx,%esi
  801363:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	57                   	push   %edi
  80136e:	56                   	push   %esi
  80136f:	53                   	push   %ebx
  801370:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801373:	bb 00 00 00 00       	mov    $0x0,%ebx
  801378:	b8 0f 00 00 00       	mov    $0xf,%eax
  80137d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801380:	8b 55 08             	mov    0x8(%ebp),%edx
  801383:	89 df                	mov    %ebx,%edi
  801385:	89 de                	mov    %ebx,%esi
  801387:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801389:	85 c0                	test   %eax,%eax
  80138b:	7e 28                	jle    8013b5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80138d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801391:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801398:	00 
  801399:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  8013a0:	00 
  8013a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013a8:	00 
  8013a9:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  8013b0:	e8 f6 f1 ff ff       	call   8005ab <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  8013b5:	83 c4 2c             	add    $0x2c,%esp
  8013b8:	5b                   	pop    %ebx
  8013b9:	5e                   	pop    %esi
  8013ba:	5f                   	pop    %edi
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    

008013bd <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	57                   	push   %edi
  8013c1:	56                   	push   %esi
  8013c2:	53                   	push   %ebx
  8013c3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8013d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d6:	89 df                	mov    %ebx,%edi
  8013d8:	89 de                	mov    %ebx,%esi
  8013da:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	7e 28                	jle    801408 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8013eb:	00 
  8013ec:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  8013f3:	00 
  8013f4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013fb:	00 
  8013fc:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  801403:	e8 a3 f1 ff ff       	call   8005ab <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801408:	83 c4 2c             	add    $0x2c,%esp
  80140b:	5b                   	pop    %ebx
  80140c:	5e                   	pop    %esi
  80140d:	5f                   	pop    %edi
  80140e:	5d                   	pop    %ebp
  80140f:	c3                   	ret    

00801410 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	57                   	push   %edi
  801414:	56                   	push   %esi
  801415:	53                   	push   %ebx
  801416:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801419:	bb 00 00 00 00       	mov    $0x0,%ebx
  80141e:	b8 11 00 00 00       	mov    $0x11,%eax
  801423:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801426:	8b 55 08             	mov    0x8(%ebp),%edx
  801429:	89 df                	mov    %ebx,%edi
  80142b:	89 de                	mov    %ebx,%esi
  80142d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80142f:	85 c0                	test   %eax,%eax
  801431:	7e 28                	jle    80145b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801433:	89 44 24 10          	mov    %eax,0x10(%esp)
  801437:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80143e:	00 
  80143f:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  801446:	00 
  801447:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80144e:	00 
  80144f:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  801456:	e8 50 f1 ff ff       	call   8005ab <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80145b:	83 c4 2c             	add    $0x2c,%esp
  80145e:	5b                   	pop    %ebx
  80145f:	5e                   	pop    %esi
  801460:	5f                   	pop    %edi
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    

00801463 <sys_sleep>:

int
sys_sleep(int channel)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	57                   	push   %edi
  801467:	56                   	push   %esi
  801468:	53                   	push   %ebx
  801469:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801471:	b8 12 00 00 00       	mov    $0x12,%eax
  801476:	8b 55 08             	mov    0x8(%ebp),%edx
  801479:	89 cb                	mov    %ecx,%ebx
  80147b:	89 cf                	mov    %ecx,%edi
  80147d:	89 ce                	mov    %ecx,%esi
  80147f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801481:	85 c0                	test   %eax,%eax
  801483:	7e 28                	jle    8014ad <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801485:	89 44 24 10          	mov    %eax,0x10(%esp)
  801489:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801490:	00 
  801491:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  801498:	00 
  801499:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014a0:	00 
  8014a1:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  8014a8:	e8 fe f0 ff ff       	call   8005ab <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  8014ad:	83 c4 2c             	add    $0x2c,%esp
  8014b0:	5b                   	pop    %ebx
  8014b1:	5e                   	pop    %esi
  8014b2:	5f                   	pop    %edi
  8014b3:	5d                   	pop    %ebp
  8014b4:	c3                   	ret    

008014b5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	57                   	push   %edi
  8014b9:	56                   	push   %esi
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c3:	b8 13 00 00 00       	mov    $0x13,%eax
  8014c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ce:	89 df                	mov    %ebx,%edi
  8014d0:	89 de                	mov    %ebx,%esi
  8014d2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	7e 28                	jle    801500 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014dc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8014e3:	00 
  8014e4:	c7 44 24 08 0b 3a 80 	movl   $0x803a0b,0x8(%esp)
  8014eb:	00 
  8014ec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014f3:	00 
  8014f4:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  8014fb:	e8 ab f0 ff ff       	call   8005ab <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801500:	83 c4 2c             	add    $0x2c,%esp
  801503:	5b                   	pop    %ebx
  801504:	5e                   	pop    %esi
  801505:	5f                   	pop    %edi
  801506:	5d                   	pop    %ebp
  801507:	c3                   	ret    

00801508 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	53                   	push   %ebx
  80150c:	83 ec 24             	sub    $0x24,%esp
  80150f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801512:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801514:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801518:	74 27                	je     801541 <pgfault+0x39>
  80151a:	89 c2                	mov    %eax,%edx
  80151c:	c1 ea 16             	shr    $0x16,%edx
  80151f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801526:	f6 c2 01             	test   $0x1,%dl
  801529:	74 16                	je     801541 <pgfault+0x39>
  80152b:	89 c2                	mov    %eax,%edx
  80152d:	c1 ea 0c             	shr    $0xc,%edx
  801530:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801537:	f7 d2                	not    %edx
  801539:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80153f:	74 1c                	je     80155d <pgfault+0x55>
		panic("pgfault");
  801541:	c7 44 24 08 36 3a 80 	movl   $0x803a36,0x8(%esp)
  801548:	00 
  801549:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801550:	00 
  801551:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  801558:	e8 4e f0 ff ff       	call   8005ab <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80155d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801562:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801564:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80156b:	00 
  80156c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801573:	00 
  801574:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157b:	e8 63 fb ff ff       	call   8010e3 <sys_page_alloc>
  801580:	85 c0                	test   %eax,%eax
  801582:	79 1c                	jns    8015a0 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801584:	c7 44 24 08 49 3a 80 	movl   $0x803a49,0x8(%esp)
  80158b:	00 
  80158c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801593:	00 
  801594:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  80159b:	e8 0b f0 ff ff       	call   8005ab <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  8015a0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8015a7:	00 
  8015a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ac:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8015b3:	e8 14 f9 ff ff       	call   800ecc <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  8015b8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8015bf:	00 
  8015c0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015cb:	00 
  8015cc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015d3:	00 
  8015d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015db:	e8 57 fb ff ff       	call   801137 <sys_page_map>
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	79 1c                	jns    801600 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  8015e4:	c7 44 24 08 63 3a 80 	movl   $0x803a63,0x8(%esp)
  8015eb:	00 
  8015ec:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8015f3:	00 
  8015f4:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  8015fb:	e8 ab ef ff ff       	call   8005ab <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801600:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801607:	00 
  801608:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80160f:	e8 76 fb ff ff       	call   80118a <sys_page_unmap>
  801614:	85 c0                	test   %eax,%eax
  801616:	79 1c                	jns    801634 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801618:	c7 44 24 08 7b 3a 80 	movl   $0x803a7b,0x8(%esp)
  80161f:	00 
  801620:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801627:	00 
  801628:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  80162f:	e8 77 ef ff ff       	call   8005ab <_panic>
	}
}
  801634:	83 c4 24             	add    $0x24,%esp
  801637:	5b                   	pop    %ebx
  801638:	5d                   	pop    %ebp
  801639:	c3                   	ret    

0080163a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	57                   	push   %edi
  80163e:	56                   	push   %esi
  80163f:	53                   	push   %ebx
  801640:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801643:	c7 04 24 08 15 80 00 	movl   $0x801508,(%esp)
  80164a:	e8 8d 1a 00 00       	call   8030dc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80164f:	b8 07 00 00 00       	mov    $0x7,%eax
  801654:	cd 30                	int    $0x30
  801656:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801659:	85 c0                	test   %eax,%eax
  80165b:	79 1c                	jns    801679 <fork+0x3f>
		panic("fork(): sys_exofork");
  80165d:	c7 44 24 08 95 3a 80 	movl   $0x803a95,0x8(%esp)
  801664:	00 
  801665:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80166c:	00 
  80166d:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  801674:	e8 32 ef ff ff       	call   8005ab <_panic>
  801679:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  80167b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80167f:	74 0a                	je     80168b <fork+0x51>
  801681:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801686:	e9 9d 01 00 00       	jmp    801828 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80168b:	e8 15 fa ff ff       	call   8010a5 <sys_getenvid>
  801690:	25 ff 03 00 00       	and    $0x3ff,%eax
  801695:	89 c2                	mov    %eax,%edx
  801697:	c1 e2 07             	shl    $0x7,%edx
  80169a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8016a1:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  8016a6:	e9 2a 02 00 00       	jmp    8018d5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  8016ab:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8016b1:	0f 84 6b 01 00 00    	je     801822 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  8016b7:	89 d8                	mov    %ebx,%eax
  8016b9:	c1 e8 16             	shr    $0x16,%eax
  8016bc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016c3:	a8 01                	test   $0x1,%al
  8016c5:	0f 84 57 01 00 00    	je     801822 <fork+0x1e8>
  8016cb:	89 d8                	mov    %ebx,%eax
  8016cd:	c1 e8 0c             	shr    $0xc,%eax
  8016d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016d7:	f7 d0                	not    %eax
  8016d9:	a8 05                	test   $0x5,%al
  8016db:	0f 85 41 01 00 00    	jne    801822 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  8016e1:	89 d8                	mov    %ebx,%eax
  8016e3:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  8016e6:	89 c6                	mov    %eax,%esi
  8016e8:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  8016eb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016f2:	f6 c6 04             	test   $0x4,%dh
  8016f5:	74 4c                	je     801743 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  8016f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801703:	89 44 24 10          	mov    %eax,0x10(%esp)
  801707:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80170b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80170f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801713:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171a:	e8 18 fa ff ff       	call   801137 <sys_page_map>
  80171f:	85 c0                	test   %eax,%eax
  801721:	0f 89 fb 00 00 00    	jns    801822 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801727:	c7 44 24 08 a9 3a 80 	movl   $0x803aa9,0x8(%esp)
  80172e:	00 
  80172f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801736:	00 
  801737:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  80173e:	e8 68 ee ff ff       	call   8005ab <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801743:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80174a:	f6 c6 08             	test   $0x8,%dh
  80174d:	75 0f                	jne    80175e <fork+0x124>
  80174f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801756:	a8 02                	test   $0x2,%al
  801758:	0f 84 84 00 00 00    	je     8017e2 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80175e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801765:	00 
  801766:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80176a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80176e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801772:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801779:	e8 b9 f9 ff ff       	call   801137 <sys_page_map>
  80177e:	85 c0                	test   %eax,%eax
  801780:	79 1c                	jns    80179e <fork+0x164>
			panic("duppage: sys_page_map");
  801782:	c7 44 24 08 a9 3a 80 	movl   $0x803aa9,0x8(%esp)
  801789:	00 
  80178a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801791:	00 
  801792:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  801799:	e8 0d ee ff ff       	call   8005ab <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80179e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8017a5:	00 
  8017a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b1:	00 
  8017b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017bd:	e8 75 f9 ff ff       	call   801137 <sys_page_map>
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	79 5c                	jns    801822 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8017c6:	c7 44 24 08 a9 3a 80 	movl   $0x803aa9,0x8(%esp)
  8017cd:	00 
  8017ce:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8017d5:	00 
  8017d6:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  8017dd:	e8 c9 ed ff ff       	call   8005ab <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  8017e2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8017e9:	00 
  8017ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8017f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017fd:	e8 35 f9 ff ff       	call   801137 <sys_page_map>
  801802:	85 c0                	test   %eax,%eax
  801804:	79 1c                	jns    801822 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801806:	c7 44 24 08 a9 3a 80 	movl   $0x803aa9,0x8(%esp)
  80180d:	00 
  80180e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801815:	00 
  801816:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  80181d:	e8 89 ed ff ff       	call   8005ab <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801822:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801828:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80182e:	0f 85 77 fe ff ff    	jne    8016ab <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801834:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80183b:	00 
  80183c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801843:	ee 
  801844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801847:	89 04 24             	mov    %eax,(%esp)
  80184a:	e8 94 f8 ff ff       	call   8010e3 <sys_page_alloc>
  80184f:	85 c0                	test   %eax,%eax
  801851:	79 1c                	jns    80186f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801853:	c7 44 24 08 bf 3a 80 	movl   $0x803abf,0x8(%esp)
  80185a:	00 
  80185b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801862:	00 
  801863:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  80186a:	e8 3c ed ff ff       	call   8005ab <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80186f:	c7 44 24 04 65 31 80 	movl   $0x803165,0x4(%esp)
  801876:	00 
  801877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187a:	89 04 24             	mov    %eax,(%esp)
  80187d:	e8 01 fa ff ff       	call   801283 <sys_env_set_pgfault_upcall>
  801882:	85 c0                	test   %eax,%eax
  801884:	79 1c                	jns    8018a2 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801886:	c7 44 24 08 08 3b 80 	movl   $0x803b08,0x8(%esp)
  80188d:	00 
  80188e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801895:	00 
  801896:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  80189d:	e8 09 ed ff ff       	call   8005ab <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  8018a2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8018a9:	00 
  8018aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ad:	89 04 24             	mov    %eax,(%esp)
  8018b0:	e8 28 f9 ff ff       	call   8011dd <sys_env_set_status>
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	79 1c                	jns    8018d5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  8018b9:	c7 44 24 08 d6 3a 80 	movl   $0x803ad6,0x8(%esp)
  8018c0:	00 
  8018c1:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  8018c8:	00 
  8018c9:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  8018d0:	e8 d6 ec ff ff       	call   8005ab <_panic>
	}

	return env_id;
}
  8018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d8:	83 c4 2c             	add    $0x2c,%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5e                   	pop    %esi
  8018dd:	5f                   	pop    %edi
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    

008018e0 <sfork>:

// Challenge!
int
sfork(void)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8018e6:	c7 44 24 08 f1 3a 80 	movl   $0x803af1,0x8(%esp)
  8018ed:	00 
  8018ee:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8018f5:	00 
  8018f6:	c7 04 24 3e 3a 80 00 	movl   $0x803a3e,(%esp)
  8018fd:	e8 a9 ec ff ff       	call   8005ab <_panic>
  801902:	66 90                	xchg   %ax,%ax
  801904:	66 90                	xchg   %ax,%ax
  801906:	66 90                	xchg   %ax,%ax
  801908:	66 90                	xchg   %ax,%ax
  80190a:	66 90                	xchg   %ax,%ax
  80190c:	66 90                	xchg   %ax,%ax
  80190e:	66 90                	xchg   %ax,%ax

00801910 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	05 00 00 00 30       	add    $0x30000000,%eax
  80191b:	c1 e8 0c             	shr    $0xc,%eax
}
  80191e:	5d                   	pop    %ebp
  80191f:	c3                   	ret    

00801920 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80192b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801930:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801942:	89 c2                	mov    %eax,%edx
  801944:	c1 ea 16             	shr    $0x16,%edx
  801947:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80194e:	f6 c2 01             	test   $0x1,%dl
  801951:	74 11                	je     801964 <fd_alloc+0x2d>
  801953:	89 c2                	mov    %eax,%edx
  801955:	c1 ea 0c             	shr    $0xc,%edx
  801958:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80195f:	f6 c2 01             	test   $0x1,%dl
  801962:	75 09                	jne    80196d <fd_alloc+0x36>
			*fd_store = fd;
  801964:	89 01                	mov    %eax,(%ecx)
			return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 17                	jmp    801984 <fd_alloc+0x4d>
  80196d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801972:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801977:	75 c9                	jne    801942 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801979:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80197f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    

00801986 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80198c:	83 f8 1f             	cmp    $0x1f,%eax
  80198f:	77 36                	ja     8019c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801991:	c1 e0 0c             	shl    $0xc,%eax
  801994:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801999:	89 c2                	mov    %eax,%edx
  80199b:	c1 ea 16             	shr    $0x16,%edx
  80199e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019a5:	f6 c2 01             	test   $0x1,%dl
  8019a8:	74 24                	je     8019ce <fd_lookup+0x48>
  8019aa:	89 c2                	mov    %eax,%edx
  8019ac:	c1 ea 0c             	shr    $0xc,%edx
  8019af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019b6:	f6 c2 01             	test   $0x1,%dl
  8019b9:	74 1a                	je     8019d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019be:	89 02                	mov    %eax,(%edx)
	return 0;
  8019c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c5:	eb 13                	jmp    8019da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8019c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019cc:	eb 0c                	jmp    8019da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8019ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d3:	eb 05                	jmp    8019da <fd_lookup+0x54>
  8019d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    

008019dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 18             	sub    $0x18,%esp
  8019e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8019e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ea:	eb 13                	jmp    8019ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8019ec:	39 08                	cmp    %ecx,(%eax)
  8019ee:	75 0c                	jne    8019fc <dev_lookup+0x20>
			*dev = devtab[i];
  8019f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8019f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fa:	eb 38                	jmp    801a34 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8019fc:	83 c2 01             	add    $0x1,%edx
  8019ff:	8b 04 95 a8 3b 80 00 	mov    0x803ba8(,%edx,4),%eax
  801a06:	85 c0                	test   %eax,%eax
  801a08:	75 e2                	jne    8019ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a0a:	a1 08 50 80 00       	mov    0x805008,%eax
  801a0f:	8b 40 48             	mov    0x48(%eax),%eax
  801a12:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1a:	c7 04 24 2c 3b 80 00 	movl   $0x803b2c,(%esp)
  801a21:	e8 7e ec ff ff       	call   8006a4 <cprintf>
	*dev = 0;
  801a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
  801a3b:	83 ec 20             	sub    $0x20,%esp
  801a3e:	8b 75 08             	mov    0x8(%ebp),%esi
  801a41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a47:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a4b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a51:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a54:	89 04 24             	mov    %eax,(%esp)
  801a57:	e8 2a ff ff ff       	call   801986 <fd_lookup>
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	78 05                	js     801a65 <fd_close+0x2f>
	    || fd != fd2)
  801a60:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801a63:	74 0c                	je     801a71 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801a65:	84 db                	test   %bl,%bl
  801a67:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6c:	0f 44 c2             	cmove  %edx,%eax
  801a6f:	eb 3f                	jmp    801ab0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a78:	8b 06                	mov    (%esi),%eax
  801a7a:	89 04 24             	mov    %eax,(%esp)
  801a7d:	e8 5a ff ff ff       	call   8019dc <dev_lookup>
  801a82:	89 c3                	mov    %eax,%ebx
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 16                	js     801a9e <fd_close+0x68>
		if (dev->dev_close)
  801a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801a8e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801a93:	85 c0                	test   %eax,%eax
  801a95:	74 07                	je     801a9e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801a97:	89 34 24             	mov    %esi,(%esp)
  801a9a:	ff d0                	call   *%eax
  801a9c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a9e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aa9:	e8 dc f6 ff ff       	call   80118a <sys_page_unmap>
	return r;
  801aae:	89 d8                	mov    %ebx,%eax
}
  801ab0:	83 c4 20             	add    $0x20,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    

00801ab7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801abd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	89 04 24             	mov    %eax,(%esp)
  801aca:	e8 b7 fe ff ff       	call   801986 <fd_lookup>
  801acf:	89 c2                	mov    %eax,%edx
  801ad1:	85 d2                	test   %edx,%edx
  801ad3:	78 13                	js     801ae8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801ad5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801adc:	00 
  801add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae0:	89 04 24             	mov    %eax,(%esp)
  801ae3:	e8 4e ff ff ff       	call   801a36 <fd_close>
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <close_all>:

void
close_all(void)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	53                   	push   %ebx
  801aee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801af1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801af6:	89 1c 24             	mov    %ebx,(%esp)
  801af9:	e8 b9 ff ff ff       	call   801ab7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801afe:	83 c3 01             	add    $0x1,%ebx
  801b01:	83 fb 20             	cmp    $0x20,%ebx
  801b04:	75 f0                	jne    801af6 <close_all+0xc>
		close(i);
}
  801b06:	83 c4 14             	add    $0x14,%esp
  801b09:	5b                   	pop    %ebx
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    

00801b0c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	57                   	push   %edi
  801b10:	56                   	push   %esi
  801b11:	53                   	push   %ebx
  801b12:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b15:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	89 04 24             	mov    %eax,(%esp)
  801b22:	e8 5f fe ff ff       	call   801986 <fd_lookup>
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	85 d2                	test   %edx,%edx
  801b2b:	0f 88 e1 00 00 00    	js     801c12 <dup+0x106>
		return r;
	close(newfdnum);
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	89 04 24             	mov    %eax,(%esp)
  801b37:	e8 7b ff ff ff       	call   801ab7 <close>

	newfd = INDEX2FD(newfdnum);
  801b3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b3f:	c1 e3 0c             	shl    $0xc,%ebx
  801b42:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b4b:	89 04 24             	mov    %eax,(%esp)
  801b4e:	e8 cd fd ff ff       	call   801920 <fd2data>
  801b53:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801b55:	89 1c 24             	mov    %ebx,(%esp)
  801b58:	e8 c3 fd ff ff       	call   801920 <fd2data>
  801b5d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b5f:	89 f0                	mov    %esi,%eax
  801b61:	c1 e8 16             	shr    $0x16,%eax
  801b64:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b6b:	a8 01                	test   $0x1,%al
  801b6d:	74 43                	je     801bb2 <dup+0xa6>
  801b6f:	89 f0                	mov    %esi,%eax
  801b71:	c1 e8 0c             	shr    $0xc,%eax
  801b74:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b7b:	f6 c2 01             	test   $0x1,%dl
  801b7e:	74 32                	je     801bb2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b80:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b87:	25 07 0e 00 00       	and    $0xe07,%eax
  801b8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b90:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b94:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b9b:	00 
  801b9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ba0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ba7:	e8 8b f5 ff ff       	call   801137 <sys_page_map>
  801bac:	89 c6                	mov    %eax,%esi
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 3e                	js     801bf0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bb5:	89 c2                	mov    %eax,%edx
  801bb7:	c1 ea 0c             	shr    $0xc,%edx
  801bba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801bc1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801bc7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801bcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801bcf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bd6:	00 
  801bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be2:	e8 50 f5 ff ff       	call   801137 <sys_page_map>
  801be7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801be9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801bec:	85 f6                	test   %esi,%esi
  801bee:	79 22                	jns    801c12 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801bf0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bf4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bfb:	e8 8a f5 ff ff       	call   80118a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0b:	e8 7a f5 ff ff       	call   80118a <sys_page_unmap>
	return r;
  801c10:	89 f0                	mov    %esi,%eax
}
  801c12:	83 c4 3c             	add    $0x3c,%esp
  801c15:	5b                   	pop    %ebx
  801c16:	5e                   	pop    %esi
  801c17:	5f                   	pop    %edi
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    

00801c1a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 24             	sub    $0x24,%esp
  801c21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c24:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2b:	89 1c 24             	mov    %ebx,(%esp)
  801c2e:	e8 53 fd ff ff       	call   801986 <fd_lookup>
  801c33:	89 c2                	mov    %eax,%edx
  801c35:	85 d2                	test   %edx,%edx
  801c37:	78 6d                	js     801ca6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c43:	8b 00                	mov    (%eax),%eax
  801c45:	89 04 24             	mov    %eax,(%esp)
  801c48:	e8 8f fd ff ff       	call   8019dc <dev_lookup>
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	78 55                	js     801ca6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c54:	8b 50 08             	mov    0x8(%eax),%edx
  801c57:	83 e2 03             	and    $0x3,%edx
  801c5a:	83 fa 01             	cmp    $0x1,%edx
  801c5d:	75 23                	jne    801c82 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c5f:	a1 08 50 80 00       	mov    0x805008,%eax
  801c64:	8b 40 48             	mov    0x48(%eax),%eax
  801c67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6f:	c7 04 24 6d 3b 80 00 	movl   $0x803b6d,(%esp)
  801c76:	e8 29 ea ff ff       	call   8006a4 <cprintf>
		return -E_INVAL;
  801c7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c80:	eb 24                	jmp    801ca6 <read+0x8c>
	}
	if (!dev->dev_read)
  801c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c85:	8b 52 08             	mov    0x8(%edx),%edx
  801c88:	85 d2                	test   %edx,%edx
  801c8a:	74 15                	je     801ca1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c9a:	89 04 24             	mov    %eax,(%esp)
  801c9d:	ff d2                	call   *%edx
  801c9f:	eb 05                	jmp    801ca6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801ca1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801ca6:	83 c4 24             	add    $0x24,%esp
  801ca9:	5b                   	pop    %ebx
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    

00801cac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	57                   	push   %edi
  801cb0:	56                   	push   %esi
  801cb1:	53                   	push   %ebx
  801cb2:	83 ec 1c             	sub    $0x1c,%esp
  801cb5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cb8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc0:	eb 23                	jmp    801ce5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801cc2:	89 f0                	mov    %esi,%eax
  801cc4:	29 d8                	sub    %ebx,%eax
  801cc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cca:	89 d8                	mov    %ebx,%eax
  801ccc:	03 45 0c             	add    0xc(%ebp),%eax
  801ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd3:	89 3c 24             	mov    %edi,(%esp)
  801cd6:	e8 3f ff ff ff       	call   801c1a <read>
		if (m < 0)
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 10                	js     801cef <readn+0x43>
			return m;
		if (m == 0)
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	74 0a                	je     801ced <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ce3:	01 c3                	add    %eax,%ebx
  801ce5:	39 f3                	cmp    %esi,%ebx
  801ce7:	72 d9                	jb     801cc2 <readn+0x16>
  801ce9:	89 d8                	mov    %ebx,%eax
  801ceb:	eb 02                	jmp    801cef <readn+0x43>
  801ced:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801cef:	83 c4 1c             	add    $0x1c,%esp
  801cf2:	5b                   	pop    %ebx
  801cf3:	5e                   	pop    %esi
  801cf4:	5f                   	pop    %edi
  801cf5:	5d                   	pop    %ebp
  801cf6:	c3                   	ret    

00801cf7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 24             	sub    $0x24,%esp
  801cfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d08:	89 1c 24             	mov    %ebx,(%esp)
  801d0b:	e8 76 fc ff ff       	call   801986 <fd_lookup>
  801d10:	89 c2                	mov    %eax,%edx
  801d12:	85 d2                	test   %edx,%edx
  801d14:	78 68                	js     801d7e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 b2 fc ff ff       	call   8019dc <dev_lookup>
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	78 50                	js     801d7e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d35:	75 23                	jne    801d5a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d37:	a1 08 50 80 00       	mov    0x805008,%eax
  801d3c:	8b 40 48             	mov    0x48(%eax),%eax
  801d3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d47:	c7 04 24 89 3b 80 00 	movl   $0x803b89,(%esp)
  801d4e:	e8 51 e9 ff ff       	call   8006a4 <cprintf>
		return -E_INVAL;
  801d53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d58:	eb 24                	jmp    801d7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5d:	8b 52 0c             	mov    0xc(%edx),%edx
  801d60:	85 d2                	test   %edx,%edx
  801d62:	74 15                	je     801d79 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d72:	89 04 24             	mov    %eax,(%esp)
  801d75:	ff d2                	call   *%edx
  801d77:	eb 05                	jmp    801d7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801d79:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801d7e:	83 c4 24             	add    $0x24,%esp
  801d81:	5b                   	pop    %ebx
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    

00801d84 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d8a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	89 04 24             	mov    %eax,(%esp)
  801d97:	e8 ea fb ff ff       	call   801986 <fd_lookup>
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 0e                	js     801dae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	53                   	push   %ebx
  801db4:	83 ec 24             	sub    $0x24,%esp
  801db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc1:	89 1c 24             	mov    %ebx,(%esp)
  801dc4:	e8 bd fb ff ff       	call   801986 <fd_lookup>
  801dc9:	89 c2                	mov    %eax,%edx
  801dcb:	85 d2                	test   %edx,%edx
  801dcd:	78 61                	js     801e30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd9:	8b 00                	mov    (%eax),%eax
  801ddb:	89 04 24             	mov    %eax,(%esp)
  801dde:	e8 f9 fb ff ff       	call   8019dc <dev_lookup>
  801de3:	85 c0                	test   %eax,%eax
  801de5:	78 49                	js     801e30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801dee:	75 23                	jne    801e13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801df0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801df5:	8b 40 48             	mov    0x48(%eax),%eax
  801df8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e00:	c7 04 24 4c 3b 80 00 	movl   $0x803b4c,(%esp)
  801e07:	e8 98 e8 ff ff       	call   8006a4 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801e0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e11:	eb 1d                	jmp    801e30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e16:	8b 52 18             	mov    0x18(%edx),%edx
  801e19:	85 d2                	test   %edx,%edx
  801e1b:	74 0e                	je     801e2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e24:	89 04 24             	mov    %eax,(%esp)
  801e27:	ff d2                	call   *%edx
  801e29:	eb 05                	jmp    801e30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801e2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801e30:	83 c4 24             	add    $0x24,%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    

00801e36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	53                   	push   %ebx
  801e3a:	83 ec 24             	sub    $0x24,%esp
  801e3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	89 04 24             	mov    %eax,(%esp)
  801e4d:	e8 34 fb ff ff       	call   801986 <fd_lookup>
  801e52:	89 c2                	mov    %eax,%edx
  801e54:	85 d2                	test   %edx,%edx
  801e56:	78 52                	js     801eaa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e62:	8b 00                	mov    (%eax),%eax
  801e64:	89 04 24             	mov    %eax,(%esp)
  801e67:	e8 70 fb ff ff       	call   8019dc <dev_lookup>
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	78 3a                	js     801eaa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e77:	74 2c                	je     801ea5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e83:	00 00 00 
	stat->st_isdir = 0;
  801e86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e8d:	00 00 00 
	stat->st_dev = dev;
  801e90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e9d:	89 14 24             	mov    %edx,(%esp)
  801ea0:	ff 50 14             	call   *0x14(%eax)
  801ea3:	eb 05                	jmp    801eaa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ea5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801eaa:	83 c4 24             	add    $0x24,%esp
  801ead:	5b                   	pop    %ebx
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	56                   	push   %esi
  801eb4:	53                   	push   %ebx
  801eb5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801eb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ebf:	00 
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	89 04 24             	mov    %eax,(%esp)
  801ec6:	e8 1b 02 00 00       	call   8020e6 <open>
  801ecb:	89 c3                	mov    %eax,%ebx
  801ecd:	85 db                	test   %ebx,%ebx
  801ecf:	78 1b                	js     801eec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed8:	89 1c 24             	mov    %ebx,(%esp)
  801edb:	e8 56 ff ff ff       	call   801e36 <fstat>
  801ee0:	89 c6                	mov    %eax,%esi
	close(fd);
  801ee2:	89 1c 24             	mov    %ebx,(%esp)
  801ee5:	e8 cd fb ff ff       	call   801ab7 <close>
	return r;
  801eea:	89 f0                	mov    %esi,%eax
}
  801eec:	83 c4 10             	add    $0x10,%esp
  801eef:	5b                   	pop    %ebx
  801ef0:	5e                   	pop    %esi
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    

00801ef3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	56                   	push   %esi
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 10             	sub    $0x10,%esp
  801efb:	89 c6                	mov    %eax,%esi
  801efd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801eff:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801f06:	75 11                	jne    801f19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801f0f:	e8 3b 13 00 00       	call   80324f <ipc_find_env>
  801f14:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f20:	00 
  801f21:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801f28:	00 
  801f29:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f2d:	a1 00 50 80 00       	mov    0x805000,%eax
  801f32:	89 04 24             	mov    %eax,(%esp)
  801f35:	e8 aa 12 00 00       	call   8031e4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f41:	00 
  801f42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4d:	e8 3e 12 00 00       	call   803190 <ipc_recv>
}
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	5b                   	pop    %ebx
  801f56:	5e                   	pop    %esi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    

00801f59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	8b 40 0c             	mov    0xc(%eax),%eax
  801f65:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f72:	ba 00 00 00 00       	mov    $0x0,%edx
  801f77:	b8 02 00 00 00       	mov    $0x2,%eax
  801f7c:	e8 72 ff ff ff       	call   801ef3 <fsipc>
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f94:	ba 00 00 00 00       	mov    $0x0,%edx
  801f99:	b8 06 00 00 00       	mov    $0x6,%eax
  801f9e:	e8 50 ff ff ff       	call   801ef3 <fsipc>
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	53                   	push   %ebx
  801fa9:	83 ec 14             	sub    $0x14,%esp
  801fac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801fba:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801fc4:	e8 2a ff ff ff       	call   801ef3 <fsipc>
  801fc9:	89 c2                	mov    %eax,%edx
  801fcb:	85 d2                	test   %edx,%edx
  801fcd:	78 2b                	js     801ffa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fcf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fd6:	00 
  801fd7:	89 1c 24             	mov    %ebx,(%esp)
  801fda:	e8 e8 ec ff ff       	call   800cc7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801fdf:	a1 80 60 80 00       	mov    0x806080,%eax
  801fe4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fea:	a1 84 60 80 00       	mov    0x806084,%eax
  801fef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffa:	83 c4 14             	add    $0x14,%esp
  801ffd:	5b                   	pop    %ebx
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    

00802000 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 18             	sub    $0x18,%esp
  802006:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802009:	8b 55 08             	mov    0x8(%ebp),%edx
  80200c:	8b 52 0c             	mov    0xc(%edx),%edx
  80200f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  802015:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80201a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	89 44 24 04          	mov    %eax,0x4(%esp)
  802025:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80202c:	e8 9b ee ff ff       	call   800ecc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  802031:	ba 00 00 00 00       	mov    $0x0,%edx
  802036:	b8 04 00 00 00       	mov    $0x4,%eax
  80203b:	e8 b3 fe ff ff       	call   801ef3 <fsipc>
		return r;
	}

	return r;
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	83 ec 10             	sub    $0x10,%esp
  80204a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	8b 40 0c             	mov    0xc(%eax),%eax
  802053:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802058:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80205e:	ba 00 00 00 00       	mov    $0x0,%edx
  802063:	b8 03 00 00 00       	mov    $0x3,%eax
  802068:	e8 86 fe ff ff       	call   801ef3 <fsipc>
  80206d:	89 c3                	mov    %eax,%ebx
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 6a                	js     8020dd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802073:	39 c6                	cmp    %eax,%esi
  802075:	73 24                	jae    80209b <devfile_read+0x59>
  802077:	c7 44 24 0c bc 3b 80 	movl   $0x803bbc,0xc(%esp)
  80207e:	00 
  80207f:	c7 44 24 08 c3 3b 80 	movl   $0x803bc3,0x8(%esp)
  802086:	00 
  802087:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80208e:	00 
  80208f:	c7 04 24 d8 3b 80 00 	movl   $0x803bd8,(%esp)
  802096:	e8 10 e5 ff ff       	call   8005ab <_panic>
	assert(r <= PGSIZE);
  80209b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020a0:	7e 24                	jle    8020c6 <devfile_read+0x84>
  8020a2:	c7 44 24 0c e3 3b 80 	movl   $0x803be3,0xc(%esp)
  8020a9:	00 
  8020aa:	c7 44 24 08 c3 3b 80 	movl   $0x803bc3,0x8(%esp)
  8020b1:	00 
  8020b2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8020b9:	00 
  8020ba:	c7 04 24 d8 3b 80 00 	movl   $0x803bd8,(%esp)
  8020c1:	e8 e5 e4 ff ff       	call   8005ab <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8020c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020ca:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8020d1:	00 
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	89 04 24             	mov    %eax,(%esp)
  8020d8:	e8 87 ed ff ff       	call   800e64 <memmove>
	return r;
}
  8020dd:	89 d8                	mov    %ebx,%eax
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	5b                   	pop    %ebx
  8020e3:	5e                   	pop    %esi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    

008020e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	53                   	push   %ebx
  8020ea:	83 ec 24             	sub    $0x24,%esp
  8020ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8020f0:	89 1c 24             	mov    %ebx,(%esp)
  8020f3:	e8 98 eb ff ff       	call   800c90 <strlen>
  8020f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020fd:	7f 60                	jg     80215f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8020ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802102:	89 04 24             	mov    %eax,(%esp)
  802105:	e8 2d f8 ff ff       	call   801937 <fd_alloc>
  80210a:	89 c2                	mov    %eax,%edx
  80210c:	85 d2                	test   %edx,%edx
  80210e:	78 54                	js     802164 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802110:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802114:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80211b:	e8 a7 eb ff ff       	call   800cc7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212b:	b8 01 00 00 00       	mov    $0x1,%eax
  802130:	e8 be fd ff ff       	call   801ef3 <fsipc>
  802135:	89 c3                	mov    %eax,%ebx
  802137:	85 c0                	test   %eax,%eax
  802139:	79 17                	jns    802152 <open+0x6c>
		fd_close(fd, 0);
  80213b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802142:	00 
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	89 04 24             	mov    %eax,(%esp)
  802149:	e8 e8 f8 ff ff       	call   801a36 <fd_close>
		return r;
  80214e:	89 d8                	mov    %ebx,%eax
  802150:	eb 12                	jmp    802164 <open+0x7e>
	}

	return fd2num(fd);
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	89 04 24             	mov    %eax,(%esp)
  802158:	e8 b3 f7 ff ff       	call   801910 <fd2num>
  80215d:	eb 05                	jmp    802164 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80215f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802164:	83 c4 24             	add    $0x24,%esp
  802167:	5b                   	pop    %ebx
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    

0080216a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802170:	ba 00 00 00 00       	mov    $0x0,%edx
  802175:	b8 08 00 00 00       	mov    $0x8,%eax
  80217a:	e8 74 fd ff ff       	call   801ef3 <fsipc>
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    
  802181:	66 90                	xchg   %ax,%ax
  802183:	66 90                	xchg   %ax,%ax
  802185:	66 90                	xchg   %ax,%ax
  802187:	66 90                	xchg   %ax,%ax
  802189:	66 90                	xchg   %ax,%ax
  80218b:	66 90                	xchg   %ax,%ax
  80218d:	66 90                	xchg   %ax,%ax
  80218f:	90                   	nop

00802190 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	57                   	push   %edi
  802194:	56                   	push   %esi
  802195:	53                   	push   %ebx
  802196:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80219c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021a3:	00 
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	89 04 24             	mov    %eax,(%esp)
  8021aa:	e8 37 ff ff ff       	call   8020e6 <open>
  8021af:	89 c1                	mov    %eax,%ecx
  8021b1:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	0f 88 fd 04 00 00    	js     8026bc <spawn+0x52c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8021bf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8021c6:	00 
  8021c7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8021cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d1:	89 0c 24             	mov    %ecx,(%esp)
  8021d4:	e8 d3 fa ff ff       	call   801cac <readn>
  8021d9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8021de:	75 0c                	jne    8021ec <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  8021e0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8021e7:	45 4c 46 
  8021ea:	74 36                	je     802222 <spawn+0x92>
		close(fd);
  8021ec:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8021f2:	89 04 24             	mov    %eax,(%esp)
  8021f5:	e8 bd f8 ff ff       	call   801ab7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8021fa:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802201:	46 
  802202:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802208:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220c:	c7 04 24 ef 3b 80 00 	movl   $0x803bef,(%esp)
  802213:	e8 8c e4 ff ff       	call   8006a4 <cprintf>
		return -E_NOT_EXEC;
  802218:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80221d:	e9 4a 05 00 00       	jmp    80276c <spawn+0x5dc>
  802222:	b8 07 00 00 00       	mov    $0x7,%eax
  802227:	cd 30                	int    $0x30
  802229:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80222f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802235:	85 c0                	test   %eax,%eax
  802237:	0f 88 8a 04 00 00    	js     8026c7 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80223d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802242:	89 c2                	mov    %eax,%edx
  802244:	c1 e2 07             	shl    $0x7,%edx
  802247:	8d b4 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%esi
  80224e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802254:	b9 11 00 00 00       	mov    $0x11,%ecx
  802259:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80225b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802261:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802267:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80226c:	be 00 00 00 00       	mov    $0x0,%esi
  802271:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802274:	eb 0f                	jmp    802285 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802276:	89 04 24             	mov    %eax,(%esp)
  802279:	e8 12 ea ff ff       	call   800c90 <strlen>
  80227e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802282:	83 c3 01             	add    $0x1,%ebx
  802285:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80228c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80228f:	85 c0                	test   %eax,%eax
  802291:	75 e3                	jne    802276 <spawn+0xe6>
  802293:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802299:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80229f:	bf 00 10 40 00       	mov    $0x401000,%edi
  8022a4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8022a6:	89 fa                	mov    %edi,%edx
  8022a8:	83 e2 fc             	and    $0xfffffffc,%edx
  8022ab:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8022b2:	29 c2                	sub    %eax,%edx
  8022b4:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8022ba:	8d 42 f8             	lea    -0x8(%edx),%eax
  8022bd:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8022c2:	0f 86 15 04 00 00    	jbe    8026dd <spawn+0x54d>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8022c8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8022cf:	00 
  8022d0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8022d7:	00 
  8022d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022df:	e8 ff ed ff ff       	call   8010e3 <sys_page_alloc>
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	0f 88 80 04 00 00    	js     80276c <spawn+0x5dc>
  8022ec:	be 00 00 00 00       	mov    $0x0,%esi
  8022f1:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8022f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8022fa:	eb 30                	jmp    80232c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  8022fc:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802302:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802308:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80230b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80230e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802312:	89 3c 24             	mov    %edi,(%esp)
  802315:	e8 ad e9 ff ff       	call   800cc7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80231a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80231d:	89 04 24             	mov    %eax,(%esp)
  802320:	e8 6b e9 ff ff       	call   800c90 <strlen>
  802325:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802329:	83 c6 01             	add    $0x1,%esi
  80232c:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  802332:	7f c8                	jg     8022fc <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802334:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80233a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802340:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802347:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80234d:	74 24                	je     802373 <spawn+0x1e3>
  80234f:	c7 44 24 0c 7c 3c 80 	movl   $0x803c7c,0xc(%esp)
  802356:	00 
  802357:	c7 44 24 08 c3 3b 80 	movl   $0x803bc3,0x8(%esp)
  80235e:	00 
  80235f:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  802366:	00 
  802367:	c7 04 24 09 3c 80 00 	movl   $0x803c09,(%esp)
  80236e:	e8 38 e2 ff ff       	call   8005ab <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802373:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802379:	89 c8                	mov    %ecx,%eax
  80237b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802380:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802383:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802389:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80238c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802392:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802398:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80239f:	00 
  8023a0:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  8023a7:	ee 
  8023a8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8023ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023b2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023b9:	00 
  8023ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c1:	e8 71 ed ff ff       	call   801137 <sys_page_map>
  8023c6:	89 c3                	mov    %eax,%ebx
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	0f 88 86 03 00 00    	js     802756 <spawn+0x5c6>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8023d0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023d7:	00 
  8023d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023df:	e8 a6 ed ff ff       	call   80118a <sys_page_unmap>
  8023e4:	89 c3                	mov    %eax,%ebx
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	0f 88 68 03 00 00    	js     802756 <spawn+0x5c6>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8023ee:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8023f4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8023fb:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802401:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802408:	00 00 00 
  80240b:	e9 b6 01 00 00       	jmp    8025c6 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  802410:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802416:	83 38 01             	cmpl   $0x1,(%eax)
  802419:	0f 85 99 01 00 00    	jne    8025b8 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80241f:	89 c1                	mov    %eax,%ecx
  802421:	8b 40 18             	mov    0x18(%eax),%eax
  802424:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802427:	83 f8 01             	cmp    $0x1,%eax
  80242a:	19 c0                	sbb    %eax,%eax
  80242c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802432:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  802439:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802440:	89 c8                	mov    %ecx,%eax
  802442:	8b 49 04             	mov    0x4(%ecx),%ecx
  802445:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80244b:	8b 48 10             	mov    0x10(%eax),%ecx
  80244e:	89 8d 94 fd ff ff    	mov    %ecx,-0x26c(%ebp)
  802454:	8b 50 14             	mov    0x14(%eax),%edx
  802457:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  80245d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802460:	89 f0                	mov    %esi,%eax
  802462:	25 ff 0f 00 00       	and    $0xfff,%eax
  802467:	74 14                	je     80247d <spawn+0x2ed>
		va -= i;
  802469:	29 c6                	sub    %eax,%esi
		memsz += i;
  80246b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802471:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  802477:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80247d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802482:	e9 23 01 00 00       	jmp    8025aa <spawn+0x41a>
		if (i >= filesz) {
  802487:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  80248d:	77 2b                	ja     8024ba <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80248f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802495:	89 44 24 08          	mov    %eax,0x8(%esp)
  802499:	89 74 24 04          	mov    %esi,0x4(%esp)
  80249d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8024a3:	89 04 24             	mov    %eax,(%esp)
  8024a6:	e8 38 ec ff ff       	call   8010e3 <sys_page_alloc>
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	0f 89 eb 00 00 00    	jns    80259e <spawn+0x40e>
  8024b3:	89 c3                	mov    %eax,%ebx
  8024b5:	e9 37 02 00 00       	jmp    8026f1 <spawn+0x561>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8024ba:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8024c1:	00 
  8024c2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8024c9:	00 
  8024ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d1:	e8 0d ec ff ff       	call   8010e3 <sys_page_alloc>
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	0f 88 09 02 00 00    	js     8026e7 <spawn+0x557>
  8024de:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8024e4:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8024e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ea:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8024f0:	89 04 24             	mov    %eax,(%esp)
  8024f3:	e8 8c f8 ff ff       	call   801d84 <seek>
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	0f 88 eb 01 00 00    	js     8026eb <spawn+0x55b>
  802500:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802506:	29 f9                	sub    %edi,%ecx
  802508:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80250a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802510:	ba 00 10 00 00       	mov    $0x1000,%edx
  802515:	0f 47 c2             	cmova  %edx,%eax
  802518:	89 44 24 08          	mov    %eax,0x8(%esp)
  80251c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802523:	00 
  802524:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80252a:	89 04 24             	mov    %eax,(%esp)
  80252d:	e8 7a f7 ff ff       	call   801cac <readn>
  802532:	85 c0                	test   %eax,%eax
  802534:	0f 88 b5 01 00 00    	js     8026ef <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80253a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802540:	89 44 24 10          	mov    %eax,0x10(%esp)
  802544:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802548:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80254e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802552:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802559:	00 
  80255a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802561:	e8 d1 eb ff ff       	call   801137 <sys_page_map>
  802566:	85 c0                	test   %eax,%eax
  802568:	79 20                	jns    80258a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  80256a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80256e:	c7 44 24 08 15 3c 80 	movl   $0x803c15,0x8(%esp)
  802575:	00 
  802576:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  80257d:	00 
  80257e:	c7 04 24 09 3c 80 00 	movl   $0x803c09,(%esp)
  802585:	e8 21 e0 ff ff       	call   8005ab <_panic>
			sys_page_unmap(0, UTEMP);
  80258a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802591:	00 
  802592:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802599:	e8 ec eb ff ff       	call   80118a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80259e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8025a4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8025aa:	89 df                	mov    %ebx,%edi
  8025ac:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8025b2:	0f 87 cf fe ff ff    	ja     802487 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8025b8:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  8025bf:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  8025c6:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8025cd:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  8025d3:	0f 8c 37 fe ff ff    	jl     802410 <spawn+0x280>
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	
	close(fd);
  8025d9:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8025df:	89 04 24             	mov    %eax,(%esp)
  8025e2:	e8 d0 f4 ff ff       	call   801ab7 <close>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  8025e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025ec:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
		if(((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_SHARE))
  8025f2:	89 d8                	mov    %ebx,%eax
  8025f4:	c1 e8 16             	shr    $0x16,%eax
  8025f7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8025fe:	a8 01                	test   $0x1,%al
  802600:	74 4d                	je     80264f <spawn+0x4bf>
  802602:	89 d8                	mov    %ebx,%eax
  802604:	c1 e8 0c             	shr    $0xc,%eax
  802607:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80260e:	f6 c2 01             	test   $0x1,%dl
  802611:	74 3c                	je     80264f <spawn+0x4bf>
  802613:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80261a:	f6 c6 04             	test   $0x4,%dh
  80261d:	74 30                	je     80264f <spawn+0x4bf>
		&& ((r = sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)]&PTE_SYSCALL)) < 0)){
  80261f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802626:	25 07 0e 00 00       	and    $0xe07,%eax
  80262b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80262f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802633:	89 74 24 08          	mov    %esi,0x8(%esp)
  802637:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80263b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802642:	e8 f0 ea ff ff       	call   801137 <sys_page_map>
  802647:	85 c0                	test   %eax,%eax
  802649:	0f 88 e7 00 00 00    	js     802736 <spawn+0x5a6>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  80264f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802655:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80265b:	75 95                	jne    8025f2 <spawn+0x462>
  80265d:	e9 af 00 00 00       	jmp    802711 <spawn+0x581>
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802662:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802666:	c7 44 24 08 32 3c 80 	movl   $0x803c32,0x8(%esp)
  80266d:	00 
  80266e:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  802675:	00 
  802676:	c7 04 24 09 3c 80 00 	movl   $0x803c09,(%esp)
  80267d:	e8 29 df ff ff       	call   8005ab <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802682:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802689:	00 
  80268a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802690:	89 04 24             	mov    %eax,(%esp)
  802693:	e8 45 eb ff ff       	call   8011dd <sys_env_set_status>
  802698:	85 c0                	test   %eax,%eax
  80269a:	79 36                	jns    8026d2 <spawn+0x542>
		panic("sys_env_set_status: %e", r);
  80269c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026a0:	c7 44 24 08 4c 3c 80 	movl   $0x803c4c,0x8(%esp)
  8026a7:	00 
  8026a8:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  8026af:	00 
  8026b0:	c7 04 24 09 3c 80 00 	movl   $0x803c09,(%esp)
  8026b7:	e8 ef de ff ff       	call   8005ab <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8026bc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8026c2:	e9 a5 00 00 00       	jmp    80276c <spawn+0x5dc>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8026c7:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026cd:	e9 9a 00 00 00       	jmp    80276c <spawn+0x5dc>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8026d2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026d8:	e9 8f 00 00 00       	jmp    80276c <spawn+0x5dc>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8026dd:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8026e2:	e9 85 00 00 00       	jmp    80276c <spawn+0x5dc>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8026e7:	89 c3                	mov    %eax,%ebx
  8026e9:	eb 06                	jmp    8026f1 <spawn+0x561>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8026eb:	89 c3                	mov    %eax,%ebx
  8026ed:	eb 02                	jmp    8026f1 <spawn+0x561>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8026ef:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8026f1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026f7:	89 04 24             	mov    %eax,(%esp)
  8026fa:	e8 54 e9 ff ff       	call   801053 <sys_env_destroy>
	close(fd);
  8026ff:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802705:	89 04 24             	mov    %eax,(%esp)
  802708:	e8 aa f3 ff ff       	call   801ab7 <close>
	return r;
  80270d:	89 d8                	mov    %ebx,%eax
  80270f:	eb 5b                	jmp    80276c <spawn+0x5dc>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802711:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80271b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802721:	89 04 24             	mov    %eax,(%esp)
  802724:	e8 07 eb ff ff       	call   801230 <sys_env_set_trapframe>
  802729:	85 c0                	test   %eax,%eax
  80272b:	0f 89 51 ff ff ff    	jns    802682 <spawn+0x4f2>
  802731:	e9 2c ff ff ff       	jmp    802662 <spawn+0x4d2>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  802736:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80273a:	c7 44 24 08 63 3c 80 	movl   $0x803c63,0x8(%esp)
  802741:	00 
  802742:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  802749:	00 
  80274a:	c7 04 24 09 3c 80 00 	movl   $0x803c09,(%esp)
  802751:	e8 55 de ff ff       	call   8005ab <_panic>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802756:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80275d:	00 
  80275e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802765:	e8 20 ea ff ff       	call   80118a <sys_page_unmap>
  80276a:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80276c:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802772:	5b                   	pop    %ebx
  802773:	5e                   	pop    %esi
  802774:	5f                   	pop    %edi
  802775:	5d                   	pop    %ebp
  802776:	c3                   	ret    

00802777 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	56                   	push   %esi
  80277b:	53                   	push   %ebx
  80277c:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80277f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802782:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802787:	eb 03                	jmp    80278c <spawnl+0x15>
		argc++;
  802789:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80278c:	83 c0 04             	add    $0x4,%eax
  80278f:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802793:	75 f4                	jne    802789 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802795:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  80279c:	83 e0 f0             	and    $0xfffffff0,%eax
  80279f:	29 c4                	sub    %eax,%esp
  8027a1:	8d 44 24 0b          	lea    0xb(%esp),%eax
  8027a5:	c1 e8 02             	shr    $0x2,%eax
  8027a8:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  8027af:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8027b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027b4:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  8027bb:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  8027c2:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c8:	eb 0a                	jmp    8027d4 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  8027ca:	83 c0 01             	add    $0x1,%eax
  8027cd:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  8027d1:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8027d4:	39 d0                	cmp    %edx,%eax
  8027d6:	75 f2                	jne    8027ca <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8027d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	89 04 24             	mov    %eax,(%esp)
  8027e2:	e8 a9 f9 ff ff       	call   802190 <spawn>
}
  8027e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027ea:	5b                   	pop    %ebx
  8027eb:	5e                   	pop    %esi
  8027ec:	5d                   	pop    %ebp
  8027ed:	c3                   	ret    
  8027ee:	66 90                	xchg   %ax,%ax

008027f0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8027f6:	c7 44 24 04 a2 3c 80 	movl   $0x803ca2,0x4(%esp)
  8027fd:	00 
  8027fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802801:	89 04 24             	mov    %eax,(%esp)
  802804:	e8 be e4 ff ff       	call   800cc7 <strcpy>
	return 0;
}
  802809:	b8 00 00 00 00       	mov    $0x0,%eax
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	53                   	push   %ebx
  802814:	83 ec 14             	sub    $0x14,%esp
  802817:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80281a:	89 1c 24             	mov    %ebx,(%esp)
  80281d:	e8 6c 0a 00 00       	call   80328e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802822:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802827:	83 f8 01             	cmp    $0x1,%eax
  80282a:	75 0d                	jne    802839 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80282c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80282f:	89 04 24             	mov    %eax,(%esp)
  802832:	e8 29 03 00 00       	call   802b60 <nsipc_close>
  802837:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802839:	89 d0                	mov    %edx,%eax
  80283b:	83 c4 14             	add    $0x14,%esp
  80283e:	5b                   	pop    %ebx
  80283f:	5d                   	pop    %ebp
  802840:	c3                   	ret    

00802841 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802847:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80284e:	00 
  80284f:	8b 45 10             	mov    0x10(%ebp),%eax
  802852:	89 44 24 08          	mov    %eax,0x8(%esp)
  802856:	8b 45 0c             	mov    0xc(%ebp),%eax
  802859:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	8b 40 0c             	mov    0xc(%eax),%eax
  802863:	89 04 24             	mov    %eax,(%esp)
  802866:	e8 f0 03 00 00       	call   802c5b <nsipc_send>
}
  80286b:	c9                   	leave  
  80286c:	c3                   	ret    

0080286d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80286d:	55                   	push   %ebp
  80286e:	89 e5                	mov    %esp,%ebp
  802870:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802873:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80287a:	00 
  80287b:	8b 45 10             	mov    0x10(%ebp),%eax
  80287e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802882:	8b 45 0c             	mov    0xc(%ebp),%eax
  802885:	89 44 24 04          	mov    %eax,0x4(%esp)
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	8b 40 0c             	mov    0xc(%eax),%eax
  80288f:	89 04 24             	mov    %eax,(%esp)
  802892:	e8 44 03 00 00       	call   802bdb <nsipc_recv>
}
  802897:	c9                   	leave  
  802898:	c3                   	ret    

00802899 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
  80289c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80289f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8028a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028a6:	89 04 24             	mov    %eax,(%esp)
  8028a9:	e8 d8 f0 ff ff       	call   801986 <fd_lookup>
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	78 17                	js     8028c9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  8028bb:	39 08                	cmp    %ecx,(%eax)
  8028bd:	75 05                	jne    8028c4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8028bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c2:	eb 05                	jmp    8028c9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8028c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	56                   	push   %esi
  8028cf:	53                   	push   %ebx
  8028d0:	83 ec 20             	sub    $0x20,%esp
  8028d3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8028d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028d8:	89 04 24             	mov    %eax,(%esp)
  8028db:	e8 57 f0 ff ff       	call   801937 <fd_alloc>
  8028e0:	89 c3                	mov    %eax,%ebx
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	78 21                	js     802907 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8028e6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028ed:	00 
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028fc:	e8 e2 e7 ff ff       	call   8010e3 <sys_page_alloc>
  802901:	89 c3                	mov    %eax,%ebx
  802903:	85 c0                	test   %eax,%eax
  802905:	79 0c                	jns    802913 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802907:	89 34 24             	mov    %esi,(%esp)
  80290a:	e8 51 02 00 00       	call   802b60 <nsipc_close>
		return r;
  80290f:	89 d8                	mov    %ebx,%eax
  802911:	eb 20                	jmp    802933 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802913:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80291e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802921:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802928:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80292b:	89 14 24             	mov    %edx,(%esp)
  80292e:	e8 dd ef ff ff       	call   801910 <fd2num>
}
  802933:	83 c4 20             	add    $0x20,%esp
  802936:	5b                   	pop    %ebx
  802937:	5e                   	pop    %esi
  802938:	5d                   	pop    %ebp
  802939:	c3                   	ret    

0080293a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	e8 51 ff ff ff       	call   802899 <fd2sockid>
		return r;
  802948:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80294a:	85 c0                	test   %eax,%eax
  80294c:	78 23                	js     802971 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80294e:	8b 55 10             	mov    0x10(%ebp),%edx
  802951:	89 54 24 08          	mov    %edx,0x8(%esp)
  802955:	8b 55 0c             	mov    0xc(%ebp),%edx
  802958:	89 54 24 04          	mov    %edx,0x4(%esp)
  80295c:	89 04 24             	mov    %eax,(%esp)
  80295f:	e8 45 01 00 00       	call   802aa9 <nsipc_accept>
		return r;
  802964:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802966:	85 c0                	test   %eax,%eax
  802968:	78 07                	js     802971 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80296a:	e8 5c ff ff ff       	call   8028cb <alloc_sockfd>
  80296f:	89 c1                	mov    %eax,%ecx
}
  802971:	89 c8                	mov    %ecx,%eax
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	e8 16 ff ff ff       	call   802899 <fd2sockid>
  802983:	89 c2                	mov    %eax,%edx
  802985:	85 d2                	test   %edx,%edx
  802987:	78 16                	js     80299f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802989:	8b 45 10             	mov    0x10(%ebp),%eax
  80298c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802990:	8b 45 0c             	mov    0xc(%ebp),%eax
  802993:	89 44 24 04          	mov    %eax,0x4(%esp)
  802997:	89 14 24             	mov    %edx,(%esp)
  80299a:	e8 60 01 00 00       	call   802aff <nsipc_bind>
}
  80299f:	c9                   	leave  
  8029a0:	c3                   	ret    

008029a1 <shutdown>:

int
shutdown(int s, int how)
{
  8029a1:	55                   	push   %ebp
  8029a2:	89 e5                	mov    %esp,%ebp
  8029a4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	e8 ea fe ff ff       	call   802899 <fd2sockid>
  8029af:	89 c2                	mov    %eax,%edx
  8029b1:	85 d2                	test   %edx,%edx
  8029b3:	78 0f                	js     8029c4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8029b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029bc:	89 14 24             	mov    %edx,(%esp)
  8029bf:	e8 7a 01 00 00       	call   802b3e <nsipc_shutdown>
}
  8029c4:	c9                   	leave  
  8029c5:	c3                   	ret    

008029c6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8029c6:	55                   	push   %ebp
  8029c7:	89 e5                	mov    %esp,%ebp
  8029c9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	e8 c5 fe ff ff       	call   802899 <fd2sockid>
  8029d4:	89 c2                	mov    %eax,%edx
  8029d6:	85 d2                	test   %edx,%edx
  8029d8:	78 16                	js     8029f0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8029da:	8b 45 10             	mov    0x10(%ebp),%eax
  8029dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e8:	89 14 24             	mov    %edx,(%esp)
  8029eb:	e8 8a 01 00 00       	call   802b7a <nsipc_connect>
}
  8029f0:	c9                   	leave  
  8029f1:	c3                   	ret    

008029f2 <listen>:

int
listen(int s, int backlog)
{
  8029f2:	55                   	push   %ebp
  8029f3:	89 e5                	mov    %esp,%ebp
  8029f5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	e8 99 fe ff ff       	call   802899 <fd2sockid>
  802a00:	89 c2                	mov    %eax,%edx
  802a02:	85 d2                	test   %edx,%edx
  802a04:	78 0f                	js     802a15 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a0d:	89 14 24             	mov    %edx,(%esp)
  802a10:	e8 a4 01 00 00       	call   802bb9 <nsipc_listen>
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
  802a1a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  802a20:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	89 04 24             	mov    %eax,(%esp)
  802a31:	e8 98 02 00 00       	call   802cce <nsipc_socket>
  802a36:	89 c2                	mov    %eax,%edx
  802a38:	85 d2                	test   %edx,%edx
  802a3a:	78 05                	js     802a41 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  802a3c:	e8 8a fe ff ff       	call   8028cb <alloc_sockfd>
}
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    

00802a43 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
  802a46:	53                   	push   %ebx
  802a47:	83 ec 14             	sub    $0x14,%esp
  802a4a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802a4c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802a53:	75 11                	jne    802a66 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802a55:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802a5c:	e8 ee 07 00 00       	call   80324f <ipc_find_env>
  802a61:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802a66:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802a6d:	00 
  802a6e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802a75:	00 
  802a76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a7a:	a1 04 50 80 00       	mov    0x805004,%eax
  802a7f:	89 04 24             	mov    %eax,(%esp)
  802a82:	e8 5d 07 00 00       	call   8031e4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802a87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a8e:	00 
  802a8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a96:	00 
  802a97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a9e:	e8 ed 06 00 00       	call   803190 <ipc_recv>
}
  802aa3:	83 c4 14             	add    $0x14,%esp
  802aa6:	5b                   	pop    %ebx
  802aa7:	5d                   	pop    %ebp
  802aa8:	c3                   	ret    

00802aa9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802aa9:	55                   	push   %ebp
  802aaa:	89 e5                	mov    %esp,%ebp
  802aac:	56                   	push   %esi
  802aad:	53                   	push   %ebx
  802aae:	83 ec 10             	sub    $0x10,%esp
  802ab1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802abc:	8b 06                	mov    (%esi),%eax
  802abe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802ac3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac8:	e8 76 ff ff ff       	call   802a43 <nsipc>
  802acd:	89 c3                	mov    %eax,%ebx
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	78 23                	js     802af6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802ad3:	a1 10 70 80 00       	mov    0x807010,%eax
  802ad8:	89 44 24 08          	mov    %eax,0x8(%esp)
  802adc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802ae3:	00 
  802ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae7:	89 04 24             	mov    %eax,(%esp)
  802aea:	e8 75 e3 ff ff       	call   800e64 <memmove>
		*addrlen = ret->ret_addrlen;
  802aef:	a1 10 70 80 00       	mov    0x807010,%eax
  802af4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802af6:	89 d8                	mov    %ebx,%eax
  802af8:	83 c4 10             	add    $0x10,%esp
  802afb:	5b                   	pop    %ebx
  802afc:	5e                   	pop    %esi
  802afd:	5d                   	pop    %ebp
  802afe:	c3                   	ret    

00802aff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
  802b02:	53                   	push   %ebx
  802b03:	83 ec 14             	sub    $0x14,%esp
  802b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802b11:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b1c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802b23:	e8 3c e3 ff ff       	call   800e64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802b28:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802b2e:	b8 02 00 00 00       	mov    $0x2,%eax
  802b33:	e8 0b ff ff ff       	call   802a43 <nsipc>
}
  802b38:	83 c4 14             	add    $0x14,%esp
  802b3b:	5b                   	pop    %ebx
  802b3c:	5d                   	pop    %ebp
  802b3d:	c3                   	ret    

00802b3e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
  802b41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802b54:	b8 03 00 00 00       	mov    $0x3,%eax
  802b59:	e8 e5 fe ff ff       	call   802a43 <nsipc>
}
  802b5e:	c9                   	leave  
  802b5f:	c3                   	ret    

00802b60 <nsipc_close>:

int
nsipc_close(int s)
{
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
  802b63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802b6e:	b8 04 00 00 00       	mov    $0x4,%eax
  802b73:	e8 cb fe ff ff       	call   802a43 <nsipc>
}
  802b78:	c9                   	leave  
  802b79:	c3                   	ret    

00802b7a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802b7a:	55                   	push   %ebp
  802b7b:	89 e5                	mov    %esp,%ebp
  802b7d:	53                   	push   %ebx
  802b7e:	83 ec 14             	sub    $0x14,%esp
  802b81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802b8c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b97:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802b9e:	e8 c1 e2 ff ff       	call   800e64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802ba3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802ba9:	b8 05 00 00 00       	mov    $0x5,%eax
  802bae:	e8 90 fe ff ff       	call   802a43 <nsipc>
}
  802bb3:	83 c4 14             	add    $0x14,%esp
  802bb6:	5b                   	pop    %ebx
  802bb7:	5d                   	pop    %ebp
  802bb8:	c3                   	ret    

00802bb9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
  802bbc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bca:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802bcf:	b8 06 00 00 00       	mov    $0x6,%eax
  802bd4:	e8 6a fe ff ff       	call   802a43 <nsipc>
}
  802bd9:	c9                   	leave  
  802bda:	c3                   	ret    

00802bdb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802bdb:	55                   	push   %ebp
  802bdc:	89 e5                	mov    %esp,%ebp
  802bde:	56                   	push   %esi
  802bdf:	53                   	push   %ebx
  802be0:	83 ec 10             	sub    $0x10,%esp
  802be3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802bee:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  802bf7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802bfc:	b8 07 00 00 00       	mov    $0x7,%eax
  802c01:	e8 3d fe ff ff       	call   802a43 <nsipc>
  802c06:	89 c3                	mov    %eax,%ebx
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	78 46                	js     802c52 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802c0c:	39 f0                	cmp    %esi,%eax
  802c0e:	7f 07                	jg     802c17 <nsipc_recv+0x3c>
  802c10:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802c15:	7e 24                	jle    802c3b <nsipc_recv+0x60>
  802c17:	c7 44 24 0c ae 3c 80 	movl   $0x803cae,0xc(%esp)
  802c1e:	00 
  802c1f:	c7 44 24 08 c3 3b 80 	movl   $0x803bc3,0x8(%esp)
  802c26:	00 
  802c27:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802c2e:	00 
  802c2f:	c7 04 24 c3 3c 80 00 	movl   $0x803cc3,(%esp)
  802c36:	e8 70 d9 ff ff       	call   8005ab <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802c3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c3f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802c46:	00 
  802c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4a:	89 04 24             	mov    %eax,(%esp)
  802c4d:	e8 12 e2 ff ff       	call   800e64 <memmove>
	}

	return r;
}
  802c52:	89 d8                	mov    %ebx,%eax
  802c54:	83 c4 10             	add    $0x10,%esp
  802c57:	5b                   	pop    %ebx
  802c58:	5e                   	pop    %esi
  802c59:	5d                   	pop    %ebp
  802c5a:	c3                   	ret    

00802c5b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802c5b:	55                   	push   %ebp
  802c5c:	89 e5                	mov    %esp,%ebp
  802c5e:	53                   	push   %ebx
  802c5f:	83 ec 14             	sub    $0x14,%esp
  802c62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802c6d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802c73:	7e 24                	jle    802c99 <nsipc_send+0x3e>
  802c75:	c7 44 24 0c cf 3c 80 	movl   $0x803ccf,0xc(%esp)
  802c7c:	00 
  802c7d:	c7 44 24 08 c3 3b 80 	movl   $0x803bc3,0x8(%esp)
  802c84:	00 
  802c85:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802c8c:	00 
  802c8d:	c7 04 24 c3 3c 80 00 	movl   $0x803cc3,(%esp)
  802c94:	e8 12 d9 ff ff       	call   8005ab <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802c99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ca4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  802cab:	e8 b4 e1 ff ff       	call   800e64 <memmove>
	nsipcbuf.send.req_size = size;
  802cb0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802cb6:	8b 45 14             	mov    0x14(%ebp),%eax
  802cb9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802cbe:	b8 08 00 00 00       	mov    $0x8,%eax
  802cc3:	e8 7b fd ff ff       	call   802a43 <nsipc>
}
  802cc8:	83 c4 14             	add    $0x14,%esp
  802ccb:	5b                   	pop    %ebx
  802ccc:	5d                   	pop    %ebp
  802ccd:	c3                   	ret    

00802cce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802cce:	55                   	push   %ebp
  802ccf:	89 e5                	mov    %esp,%ebp
  802cd1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ce7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802cec:	b8 09 00 00 00       	mov    $0x9,%eax
  802cf1:	e8 4d fd ff ff       	call   802a43 <nsipc>
}
  802cf6:	c9                   	leave  
  802cf7:	c3                   	ret    

00802cf8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
  802cfb:	56                   	push   %esi
  802cfc:	53                   	push   %ebx
  802cfd:	83 ec 10             	sub    $0x10,%esp
  802d00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	89 04 24             	mov    %eax,(%esp)
  802d09:	e8 12 ec ff ff       	call   801920 <fd2data>
  802d0e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802d10:	c7 44 24 04 db 3c 80 	movl   $0x803cdb,0x4(%esp)
  802d17:	00 
  802d18:	89 1c 24             	mov    %ebx,(%esp)
  802d1b:	e8 a7 df ff ff       	call   800cc7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802d20:	8b 46 04             	mov    0x4(%esi),%eax
  802d23:	2b 06                	sub    (%esi),%eax
  802d25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802d2b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802d32:	00 00 00 
	stat->st_dev = &devpipe;
  802d35:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802d3c:	40 80 00 
	return 0;
}
  802d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d44:	83 c4 10             	add    $0x10,%esp
  802d47:	5b                   	pop    %ebx
  802d48:	5e                   	pop    %esi
  802d49:	5d                   	pop    %ebp
  802d4a:	c3                   	ret    

00802d4b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
  802d4e:	53                   	push   %ebx
  802d4f:	83 ec 14             	sub    $0x14,%esp
  802d52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802d55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d60:	e8 25 e4 ff ff       	call   80118a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802d65:	89 1c 24             	mov    %ebx,(%esp)
  802d68:	e8 b3 eb ff ff       	call   801920 <fd2data>
  802d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d78:	e8 0d e4 ff ff       	call   80118a <sys_page_unmap>
}
  802d7d:	83 c4 14             	add    $0x14,%esp
  802d80:	5b                   	pop    %ebx
  802d81:	5d                   	pop    %ebp
  802d82:	c3                   	ret    

00802d83 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802d83:	55                   	push   %ebp
  802d84:	89 e5                	mov    %esp,%ebp
  802d86:	57                   	push   %edi
  802d87:	56                   	push   %esi
  802d88:	53                   	push   %ebx
  802d89:	83 ec 2c             	sub    $0x2c,%esp
  802d8c:	89 c6                	mov    %eax,%esi
  802d8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802d91:	a1 08 50 80 00       	mov    0x805008,%eax
  802d96:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802d99:	89 34 24             	mov    %esi,(%esp)
  802d9c:	e8 ed 04 00 00       	call   80328e <pageref>
  802da1:	89 c7                	mov    %eax,%edi
  802da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da6:	89 04 24             	mov    %eax,(%esp)
  802da9:	e8 e0 04 00 00       	call   80328e <pageref>
  802dae:	39 c7                	cmp    %eax,%edi
  802db0:	0f 94 c2             	sete   %dl
  802db3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802db6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  802dbc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802dbf:	39 fb                	cmp    %edi,%ebx
  802dc1:	74 21                	je     802de4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802dc3:	84 d2                	test   %dl,%dl
  802dc5:	74 ca                	je     802d91 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802dc7:	8b 51 58             	mov    0x58(%ecx),%edx
  802dca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802dce:	89 54 24 08          	mov    %edx,0x8(%esp)
  802dd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802dd6:	c7 04 24 e2 3c 80 00 	movl   $0x803ce2,(%esp)
  802ddd:	e8 c2 d8 ff ff       	call   8006a4 <cprintf>
  802de2:	eb ad                	jmp    802d91 <_pipeisclosed+0xe>
	}
}
  802de4:	83 c4 2c             	add    $0x2c,%esp
  802de7:	5b                   	pop    %ebx
  802de8:	5e                   	pop    %esi
  802de9:	5f                   	pop    %edi
  802dea:	5d                   	pop    %ebp
  802deb:	c3                   	ret    

00802dec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802dec:	55                   	push   %ebp
  802ded:	89 e5                	mov    %esp,%ebp
  802def:	57                   	push   %edi
  802df0:	56                   	push   %esi
  802df1:	53                   	push   %ebx
  802df2:	83 ec 1c             	sub    $0x1c,%esp
  802df5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802df8:	89 34 24             	mov    %esi,(%esp)
  802dfb:	e8 20 eb ff ff       	call   801920 <fd2data>
  802e00:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e02:	bf 00 00 00 00       	mov    $0x0,%edi
  802e07:	eb 45                	jmp    802e4e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802e09:	89 da                	mov    %ebx,%edx
  802e0b:	89 f0                	mov    %esi,%eax
  802e0d:	e8 71 ff ff ff       	call   802d83 <_pipeisclosed>
  802e12:	85 c0                	test   %eax,%eax
  802e14:	75 41                	jne    802e57 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802e16:	e8 a9 e2 ff ff       	call   8010c4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e1b:	8b 43 04             	mov    0x4(%ebx),%eax
  802e1e:	8b 0b                	mov    (%ebx),%ecx
  802e20:	8d 51 20             	lea    0x20(%ecx),%edx
  802e23:	39 d0                	cmp    %edx,%eax
  802e25:	73 e2                	jae    802e09 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e2a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802e2e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802e31:	99                   	cltd   
  802e32:	c1 ea 1b             	shr    $0x1b,%edx
  802e35:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802e38:	83 e1 1f             	and    $0x1f,%ecx
  802e3b:	29 d1                	sub    %edx,%ecx
  802e3d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802e41:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802e45:	83 c0 01             	add    $0x1,%eax
  802e48:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e4b:	83 c7 01             	add    $0x1,%edi
  802e4e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802e51:	75 c8                	jne    802e1b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802e53:	89 f8                	mov    %edi,%eax
  802e55:	eb 05                	jmp    802e5c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802e57:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802e5c:	83 c4 1c             	add    $0x1c,%esp
  802e5f:	5b                   	pop    %ebx
  802e60:	5e                   	pop    %esi
  802e61:	5f                   	pop    %edi
  802e62:	5d                   	pop    %ebp
  802e63:	c3                   	ret    

00802e64 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
  802e67:	57                   	push   %edi
  802e68:	56                   	push   %esi
  802e69:	53                   	push   %ebx
  802e6a:	83 ec 1c             	sub    $0x1c,%esp
  802e6d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802e70:	89 3c 24             	mov    %edi,(%esp)
  802e73:	e8 a8 ea ff ff       	call   801920 <fd2data>
  802e78:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e7a:	be 00 00 00 00       	mov    $0x0,%esi
  802e7f:	eb 3d                	jmp    802ebe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802e81:	85 f6                	test   %esi,%esi
  802e83:	74 04                	je     802e89 <devpipe_read+0x25>
				return i;
  802e85:	89 f0                	mov    %esi,%eax
  802e87:	eb 43                	jmp    802ecc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802e89:	89 da                	mov    %ebx,%edx
  802e8b:	89 f8                	mov    %edi,%eax
  802e8d:	e8 f1 fe ff ff       	call   802d83 <_pipeisclosed>
  802e92:	85 c0                	test   %eax,%eax
  802e94:	75 31                	jne    802ec7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802e96:	e8 29 e2 ff ff       	call   8010c4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802e9b:	8b 03                	mov    (%ebx),%eax
  802e9d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802ea0:	74 df                	je     802e81 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ea2:	99                   	cltd   
  802ea3:	c1 ea 1b             	shr    $0x1b,%edx
  802ea6:	01 d0                	add    %edx,%eax
  802ea8:	83 e0 1f             	and    $0x1f,%eax
  802eab:	29 d0                	sub    %edx,%eax
  802ead:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802eb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802eb5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802eb8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ebb:	83 c6 01             	add    $0x1,%esi
  802ebe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ec1:	75 d8                	jne    802e9b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802ec3:	89 f0                	mov    %esi,%eax
  802ec5:	eb 05                	jmp    802ecc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802ec7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802ecc:	83 c4 1c             	add    $0x1c,%esp
  802ecf:	5b                   	pop    %ebx
  802ed0:	5e                   	pop    %esi
  802ed1:	5f                   	pop    %edi
  802ed2:	5d                   	pop    %ebp
  802ed3:	c3                   	ret    

00802ed4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802ed4:	55                   	push   %ebp
  802ed5:	89 e5                	mov    %esp,%ebp
  802ed7:	56                   	push   %esi
  802ed8:	53                   	push   %ebx
  802ed9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802edc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802edf:	89 04 24             	mov    %eax,(%esp)
  802ee2:	e8 50 ea ff ff       	call   801937 <fd_alloc>
  802ee7:	89 c2                	mov    %eax,%edx
  802ee9:	85 d2                	test   %edx,%edx
  802eeb:	0f 88 4d 01 00 00    	js     80303e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ef1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ef8:	00 
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f07:	e8 d7 e1 ff ff       	call   8010e3 <sys_page_alloc>
  802f0c:	89 c2                	mov    %eax,%edx
  802f0e:	85 d2                	test   %edx,%edx
  802f10:	0f 88 28 01 00 00    	js     80303e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f16:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f19:	89 04 24             	mov    %eax,(%esp)
  802f1c:	e8 16 ea ff ff       	call   801937 <fd_alloc>
  802f21:	89 c3                	mov    %eax,%ebx
  802f23:	85 c0                	test   %eax,%eax
  802f25:	0f 88 fe 00 00 00    	js     803029 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f2b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802f32:	00 
  802f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f36:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f41:	e8 9d e1 ff ff       	call   8010e3 <sys_page_alloc>
  802f46:	89 c3                	mov    %eax,%ebx
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	0f 88 d9 00 00 00    	js     803029 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	89 04 24             	mov    %eax,(%esp)
  802f56:	e8 c5 e9 ff ff       	call   801920 <fd2data>
  802f5b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f5d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802f64:	00 
  802f65:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f70:	e8 6e e1 ff ff       	call   8010e3 <sys_page_alloc>
  802f75:	89 c3                	mov    %eax,%ebx
  802f77:	85 c0                	test   %eax,%eax
  802f79:	0f 88 97 00 00 00    	js     803016 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	89 04 24             	mov    %eax,(%esp)
  802f85:	e8 96 e9 ff ff       	call   801920 <fd2data>
  802f8a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802f91:	00 
  802f92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f96:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802f9d:	00 
  802f9e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802fa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fa9:	e8 89 e1 ff ff       	call   801137 <sys_page_map>
  802fae:	89 c3                	mov    %eax,%ebx
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	78 52                	js     803006 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802fb4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802fc9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe1:	89 04 24             	mov    %eax,(%esp)
  802fe4:	e8 27 e9 ff ff       	call   801910 <fd2num>
  802fe9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff1:	89 04 24             	mov    %eax,(%esp)
  802ff4:	e8 17 e9 ff ff       	call   801910 <fd2num>
  802ff9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ffc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802fff:	b8 00 00 00 00       	mov    $0x0,%eax
  803004:	eb 38                	jmp    80303e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803006:	89 74 24 04          	mov    %esi,0x4(%esp)
  80300a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803011:	e8 74 e1 ff ff       	call   80118a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803019:	89 44 24 04          	mov    %eax,0x4(%esp)
  80301d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803024:	e8 61 e1 ff ff       	call   80118a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803030:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803037:	e8 4e e1 ff ff       	call   80118a <sys_page_unmap>
  80303c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80303e:	83 c4 30             	add    $0x30,%esp
  803041:	5b                   	pop    %ebx
  803042:	5e                   	pop    %esi
  803043:	5d                   	pop    %ebp
  803044:	c3                   	ret    

00803045 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803045:	55                   	push   %ebp
  803046:	89 e5                	mov    %esp,%ebp
  803048:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80304b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80304e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	89 04 24             	mov    %eax,(%esp)
  803058:	e8 29 e9 ff ff       	call   801986 <fd_lookup>
  80305d:	89 c2                	mov    %eax,%edx
  80305f:	85 d2                	test   %edx,%edx
  803061:	78 15                	js     803078 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	89 04 24             	mov    %eax,(%esp)
  803069:	e8 b2 e8 ff ff       	call   801920 <fd2data>
	return _pipeisclosed(fd, p);
  80306e:	89 c2                	mov    %eax,%edx
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	e8 0b fd ff ff       	call   802d83 <_pipeisclosed>
}
  803078:	c9                   	leave  
  803079:	c3                   	ret    

0080307a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80307a:	55                   	push   %ebp
  80307b:	89 e5                	mov    %esp,%ebp
  80307d:	56                   	push   %esi
  80307e:	53                   	push   %ebx
  80307f:	83 ec 10             	sub    $0x10,%esp
  803082:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803085:	85 f6                	test   %esi,%esi
  803087:	75 24                	jne    8030ad <wait+0x33>
  803089:	c7 44 24 0c fa 3c 80 	movl   $0x803cfa,0xc(%esp)
  803090:	00 
  803091:	c7 44 24 08 c3 3b 80 	movl   $0x803bc3,0x8(%esp)
  803098:	00 
  803099:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8030a0:	00 
  8030a1:	c7 04 24 05 3d 80 00 	movl   $0x803d05,(%esp)
  8030a8:	e8 fe d4 ff ff       	call   8005ab <_panic>
	e = &envs[ENVX(envid)];
  8030ad:	89 f0                	mov    %esi,%eax
  8030af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8030b4:	89 c2                	mov    %eax,%edx
  8030b6:	c1 e2 07             	shl    $0x7,%edx
  8030b9:	8d 9c 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8030c0:	eb 05                	jmp    8030c7 <wait+0x4d>
		sys_yield();
  8030c2:	e8 fd df ff ff       	call   8010c4 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8030c7:	8b 43 48             	mov    0x48(%ebx),%eax
  8030ca:	39 f0                	cmp    %esi,%eax
  8030cc:	75 07                	jne    8030d5 <wait+0x5b>
  8030ce:	8b 43 54             	mov    0x54(%ebx),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	75 ed                	jne    8030c2 <wait+0x48>
		sys_yield();
}
  8030d5:	83 c4 10             	add    $0x10,%esp
  8030d8:	5b                   	pop    %ebx
  8030d9:	5e                   	pop    %esi
  8030da:	5d                   	pop    %ebp
  8030db:	c3                   	ret    

008030dc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8030dc:	55                   	push   %ebp
  8030dd:	89 e5                	mov    %esp,%ebp
  8030df:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8030e2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8030e9:	75 70                	jne    80315b <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  8030eb:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  8030f2:	00 
  8030f3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8030fa:	ee 
  8030fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803102:	e8 dc df ff ff       	call   8010e3 <sys_page_alloc>
		if (error < 0)
  803107:	85 c0                	test   %eax,%eax
  803109:	79 1c                	jns    803127 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  80310b:	c7 44 24 08 10 3d 80 	movl   $0x803d10,0x8(%esp)
  803112:	00 
  803113:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80311a:	00 
  80311b:	c7 04 24 63 3d 80 00 	movl   $0x803d63,(%esp)
  803122:	e8 84 d4 ff ff       	call   8005ab <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803127:	c7 44 24 04 65 31 80 	movl   $0x803165,0x4(%esp)
  80312e:	00 
  80312f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803136:	e8 48 e1 ff ff       	call   801283 <sys_env_set_pgfault_upcall>
		if (error < 0)
  80313b:	85 c0                	test   %eax,%eax
  80313d:	79 1c                	jns    80315b <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  80313f:	c7 44 24 08 38 3d 80 	movl   $0x803d38,0x8(%esp)
  803146:	00 
  803147:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80314e:	00 
  80314f:	c7 04 24 63 3d 80 00 	movl   $0x803d63,(%esp)
  803156:	e8 50 d4 ff ff       	call   8005ab <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	a3 00 80 80 00       	mov    %eax,0x808000
}
  803163:	c9                   	leave  
  803164:	c3                   	ret    

00803165 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803165:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803166:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80316b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80316d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  803170:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  803174:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  803179:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  80317d:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  80317f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  803182:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803183:	83 c4 04             	add    $0x4,%esp
	popfl
  803186:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803187:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803188:	c3                   	ret    
  803189:	66 90                	xchg   %ax,%ax
  80318b:	66 90                	xchg   %ax,%ax
  80318d:	66 90                	xchg   %ax,%ax
  80318f:	90                   	nop

00803190 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803190:	55                   	push   %ebp
  803191:	89 e5                	mov    %esp,%ebp
  803193:	56                   	push   %esi
  803194:	53                   	push   %ebx
  803195:	83 ec 10             	sub    $0x10,%esp
  803198:	8b 75 08             	mov    0x8(%ebp),%esi
  80319b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8031a1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8031a3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8031a8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8031ab:	89 04 24             	mov    %eax,(%esp)
  8031ae:	e8 46 e1 ff ff       	call   8012f9 <sys_ipc_recv>
  8031b3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8031b5:	85 d2                	test   %edx,%edx
  8031b7:	75 24                	jne    8031dd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8031b9:	85 f6                	test   %esi,%esi
  8031bb:	74 0a                	je     8031c7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8031bd:	a1 08 50 80 00       	mov    0x805008,%eax
  8031c2:	8b 40 74             	mov    0x74(%eax),%eax
  8031c5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8031c7:	85 db                	test   %ebx,%ebx
  8031c9:	74 0a                	je     8031d5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8031cb:	a1 08 50 80 00       	mov    0x805008,%eax
  8031d0:	8b 40 78             	mov    0x78(%eax),%eax
  8031d3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8031d5:	a1 08 50 80 00       	mov    0x805008,%eax
  8031da:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8031dd:	83 c4 10             	add    $0x10,%esp
  8031e0:	5b                   	pop    %ebx
  8031e1:	5e                   	pop    %esi
  8031e2:	5d                   	pop    %ebp
  8031e3:	c3                   	ret    

008031e4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8031e4:	55                   	push   %ebp
  8031e5:	89 e5                	mov    %esp,%ebp
  8031e7:	57                   	push   %edi
  8031e8:	56                   	push   %esi
  8031e9:	53                   	push   %ebx
  8031ea:	83 ec 1c             	sub    $0x1c,%esp
  8031ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8031f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8031f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8031f6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8031f8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8031fd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  803200:	8b 45 14             	mov    0x14(%ebp),%eax
  803203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803207:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80320b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80320f:	89 3c 24             	mov    %edi,(%esp)
  803212:	e8 bf e0 ff ff       	call   8012d6 <sys_ipc_try_send>

		if (ret == 0)
  803217:	85 c0                	test   %eax,%eax
  803219:	74 2c                	je     803247 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80321b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80321e:	74 20                	je     803240 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  803220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803224:	c7 44 24 08 74 3d 80 	movl   $0x803d74,0x8(%esp)
  80322b:	00 
  80322c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  803233:	00 
  803234:	c7 04 24 a4 3d 80 00 	movl   $0x803da4,(%esp)
  80323b:	e8 6b d3 ff ff       	call   8005ab <_panic>
		}

		sys_yield();
  803240:	e8 7f de ff ff       	call   8010c4 <sys_yield>
	}
  803245:	eb b9                	jmp    803200 <ipc_send+0x1c>
}
  803247:	83 c4 1c             	add    $0x1c,%esp
  80324a:	5b                   	pop    %ebx
  80324b:	5e                   	pop    %esi
  80324c:	5f                   	pop    %edi
  80324d:	5d                   	pop    %ebp
  80324e:	c3                   	ret    

0080324f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80324f:	55                   	push   %ebp
  803250:	89 e5                	mov    %esp,%ebp
  803252:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803255:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80325a:	89 c2                	mov    %eax,%edx
  80325c:	c1 e2 07             	shl    $0x7,%edx
  80325f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  803266:	8b 52 50             	mov    0x50(%edx),%edx
  803269:	39 ca                	cmp    %ecx,%edx
  80326b:	75 11                	jne    80327e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80326d:	89 c2                	mov    %eax,%edx
  80326f:	c1 e2 07             	shl    $0x7,%edx
  803272:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  803279:	8b 40 40             	mov    0x40(%eax),%eax
  80327c:	eb 0e                	jmp    80328c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80327e:	83 c0 01             	add    $0x1,%eax
  803281:	3d 00 04 00 00       	cmp    $0x400,%eax
  803286:	75 d2                	jne    80325a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803288:	66 b8 00 00          	mov    $0x0,%ax
}
  80328c:	5d                   	pop    %ebp
  80328d:	c3                   	ret    

0080328e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80328e:	55                   	push   %ebp
  80328f:	89 e5                	mov    %esp,%ebp
  803291:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803294:	89 d0                	mov    %edx,%eax
  803296:	c1 e8 16             	shr    $0x16,%eax
  803299:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8032a0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8032a5:	f6 c1 01             	test   $0x1,%cl
  8032a8:	74 1d                	je     8032c7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8032aa:	c1 ea 0c             	shr    $0xc,%edx
  8032ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8032b4:	f6 c2 01             	test   $0x1,%dl
  8032b7:	74 0e                	je     8032c7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8032b9:	c1 ea 0c             	shr    $0xc,%edx
  8032bc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8032c3:	ef 
  8032c4:	0f b7 c0             	movzwl %ax,%eax
}
  8032c7:	5d                   	pop    %ebp
  8032c8:	c3                   	ret    
  8032c9:	66 90                	xchg   %ax,%ax
  8032cb:	66 90                	xchg   %ax,%ax
  8032cd:	66 90                	xchg   %ax,%ax
  8032cf:	90                   	nop

008032d0 <__udivdi3>:
  8032d0:	55                   	push   %ebp
  8032d1:	57                   	push   %edi
  8032d2:	56                   	push   %esi
  8032d3:	83 ec 0c             	sub    $0xc,%esp
  8032d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8032da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8032de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8032e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8032ec:	89 ea                	mov    %ebp,%edx
  8032ee:	89 0c 24             	mov    %ecx,(%esp)
  8032f1:	75 2d                	jne    803320 <__udivdi3+0x50>
  8032f3:	39 e9                	cmp    %ebp,%ecx
  8032f5:	77 61                	ja     803358 <__udivdi3+0x88>
  8032f7:	85 c9                	test   %ecx,%ecx
  8032f9:	89 ce                	mov    %ecx,%esi
  8032fb:	75 0b                	jne    803308 <__udivdi3+0x38>
  8032fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803302:	31 d2                	xor    %edx,%edx
  803304:	f7 f1                	div    %ecx
  803306:	89 c6                	mov    %eax,%esi
  803308:	31 d2                	xor    %edx,%edx
  80330a:	89 e8                	mov    %ebp,%eax
  80330c:	f7 f6                	div    %esi
  80330e:	89 c5                	mov    %eax,%ebp
  803310:	89 f8                	mov    %edi,%eax
  803312:	f7 f6                	div    %esi
  803314:	89 ea                	mov    %ebp,%edx
  803316:	83 c4 0c             	add    $0xc,%esp
  803319:	5e                   	pop    %esi
  80331a:	5f                   	pop    %edi
  80331b:	5d                   	pop    %ebp
  80331c:	c3                   	ret    
  80331d:	8d 76 00             	lea    0x0(%esi),%esi
  803320:	39 e8                	cmp    %ebp,%eax
  803322:	77 24                	ja     803348 <__udivdi3+0x78>
  803324:	0f bd e8             	bsr    %eax,%ebp
  803327:	83 f5 1f             	xor    $0x1f,%ebp
  80332a:	75 3c                	jne    803368 <__udivdi3+0x98>
  80332c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803330:	39 34 24             	cmp    %esi,(%esp)
  803333:	0f 86 9f 00 00 00    	jbe    8033d8 <__udivdi3+0x108>
  803339:	39 d0                	cmp    %edx,%eax
  80333b:	0f 82 97 00 00 00    	jb     8033d8 <__udivdi3+0x108>
  803341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803348:	31 d2                	xor    %edx,%edx
  80334a:	31 c0                	xor    %eax,%eax
  80334c:	83 c4 0c             	add    $0xc,%esp
  80334f:	5e                   	pop    %esi
  803350:	5f                   	pop    %edi
  803351:	5d                   	pop    %ebp
  803352:	c3                   	ret    
  803353:	90                   	nop
  803354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803358:	89 f8                	mov    %edi,%eax
  80335a:	f7 f1                	div    %ecx
  80335c:	31 d2                	xor    %edx,%edx
  80335e:	83 c4 0c             	add    $0xc,%esp
  803361:	5e                   	pop    %esi
  803362:	5f                   	pop    %edi
  803363:	5d                   	pop    %ebp
  803364:	c3                   	ret    
  803365:	8d 76 00             	lea    0x0(%esi),%esi
  803368:	89 e9                	mov    %ebp,%ecx
  80336a:	8b 3c 24             	mov    (%esp),%edi
  80336d:	d3 e0                	shl    %cl,%eax
  80336f:	89 c6                	mov    %eax,%esi
  803371:	b8 20 00 00 00       	mov    $0x20,%eax
  803376:	29 e8                	sub    %ebp,%eax
  803378:	89 c1                	mov    %eax,%ecx
  80337a:	d3 ef                	shr    %cl,%edi
  80337c:	89 e9                	mov    %ebp,%ecx
  80337e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803382:	8b 3c 24             	mov    (%esp),%edi
  803385:	09 74 24 08          	or     %esi,0x8(%esp)
  803389:	89 d6                	mov    %edx,%esi
  80338b:	d3 e7                	shl    %cl,%edi
  80338d:	89 c1                	mov    %eax,%ecx
  80338f:	89 3c 24             	mov    %edi,(%esp)
  803392:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803396:	d3 ee                	shr    %cl,%esi
  803398:	89 e9                	mov    %ebp,%ecx
  80339a:	d3 e2                	shl    %cl,%edx
  80339c:	89 c1                	mov    %eax,%ecx
  80339e:	d3 ef                	shr    %cl,%edi
  8033a0:	09 d7                	or     %edx,%edi
  8033a2:	89 f2                	mov    %esi,%edx
  8033a4:	89 f8                	mov    %edi,%eax
  8033a6:	f7 74 24 08          	divl   0x8(%esp)
  8033aa:	89 d6                	mov    %edx,%esi
  8033ac:	89 c7                	mov    %eax,%edi
  8033ae:	f7 24 24             	mull   (%esp)
  8033b1:	39 d6                	cmp    %edx,%esi
  8033b3:	89 14 24             	mov    %edx,(%esp)
  8033b6:	72 30                	jb     8033e8 <__udivdi3+0x118>
  8033b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033bc:	89 e9                	mov    %ebp,%ecx
  8033be:	d3 e2                	shl    %cl,%edx
  8033c0:	39 c2                	cmp    %eax,%edx
  8033c2:	73 05                	jae    8033c9 <__udivdi3+0xf9>
  8033c4:	3b 34 24             	cmp    (%esp),%esi
  8033c7:	74 1f                	je     8033e8 <__udivdi3+0x118>
  8033c9:	89 f8                	mov    %edi,%eax
  8033cb:	31 d2                	xor    %edx,%edx
  8033cd:	e9 7a ff ff ff       	jmp    80334c <__udivdi3+0x7c>
  8033d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8033d8:	31 d2                	xor    %edx,%edx
  8033da:	b8 01 00 00 00       	mov    $0x1,%eax
  8033df:	e9 68 ff ff ff       	jmp    80334c <__udivdi3+0x7c>
  8033e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8033e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8033eb:	31 d2                	xor    %edx,%edx
  8033ed:	83 c4 0c             	add    $0xc,%esp
  8033f0:	5e                   	pop    %esi
  8033f1:	5f                   	pop    %edi
  8033f2:	5d                   	pop    %ebp
  8033f3:	c3                   	ret    
  8033f4:	66 90                	xchg   %ax,%ax
  8033f6:	66 90                	xchg   %ax,%ax
  8033f8:	66 90                	xchg   %ax,%ax
  8033fa:	66 90                	xchg   %ax,%ax
  8033fc:	66 90                	xchg   %ax,%ax
  8033fe:	66 90                	xchg   %ax,%ax

00803400 <__umoddi3>:
  803400:	55                   	push   %ebp
  803401:	57                   	push   %edi
  803402:	56                   	push   %esi
  803403:	83 ec 14             	sub    $0x14,%esp
  803406:	8b 44 24 28          	mov    0x28(%esp),%eax
  80340a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80340e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803412:	89 c7                	mov    %eax,%edi
  803414:	89 44 24 04          	mov    %eax,0x4(%esp)
  803418:	8b 44 24 30          	mov    0x30(%esp),%eax
  80341c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803420:	89 34 24             	mov    %esi,(%esp)
  803423:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803427:	85 c0                	test   %eax,%eax
  803429:	89 c2                	mov    %eax,%edx
  80342b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80342f:	75 17                	jne    803448 <__umoddi3+0x48>
  803431:	39 fe                	cmp    %edi,%esi
  803433:	76 4b                	jbe    803480 <__umoddi3+0x80>
  803435:	89 c8                	mov    %ecx,%eax
  803437:	89 fa                	mov    %edi,%edx
  803439:	f7 f6                	div    %esi
  80343b:	89 d0                	mov    %edx,%eax
  80343d:	31 d2                	xor    %edx,%edx
  80343f:	83 c4 14             	add    $0x14,%esp
  803442:	5e                   	pop    %esi
  803443:	5f                   	pop    %edi
  803444:	5d                   	pop    %ebp
  803445:	c3                   	ret    
  803446:	66 90                	xchg   %ax,%ax
  803448:	39 f8                	cmp    %edi,%eax
  80344a:	77 54                	ja     8034a0 <__umoddi3+0xa0>
  80344c:	0f bd e8             	bsr    %eax,%ebp
  80344f:	83 f5 1f             	xor    $0x1f,%ebp
  803452:	75 5c                	jne    8034b0 <__umoddi3+0xb0>
  803454:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803458:	39 3c 24             	cmp    %edi,(%esp)
  80345b:	0f 87 e7 00 00 00    	ja     803548 <__umoddi3+0x148>
  803461:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803465:	29 f1                	sub    %esi,%ecx
  803467:	19 c7                	sbb    %eax,%edi
  803469:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80346d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803471:	8b 44 24 08          	mov    0x8(%esp),%eax
  803475:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803479:	83 c4 14             	add    $0x14,%esp
  80347c:	5e                   	pop    %esi
  80347d:	5f                   	pop    %edi
  80347e:	5d                   	pop    %ebp
  80347f:	c3                   	ret    
  803480:	85 f6                	test   %esi,%esi
  803482:	89 f5                	mov    %esi,%ebp
  803484:	75 0b                	jne    803491 <__umoddi3+0x91>
  803486:	b8 01 00 00 00       	mov    $0x1,%eax
  80348b:	31 d2                	xor    %edx,%edx
  80348d:	f7 f6                	div    %esi
  80348f:	89 c5                	mov    %eax,%ebp
  803491:	8b 44 24 04          	mov    0x4(%esp),%eax
  803495:	31 d2                	xor    %edx,%edx
  803497:	f7 f5                	div    %ebp
  803499:	89 c8                	mov    %ecx,%eax
  80349b:	f7 f5                	div    %ebp
  80349d:	eb 9c                	jmp    80343b <__umoddi3+0x3b>
  80349f:	90                   	nop
  8034a0:	89 c8                	mov    %ecx,%eax
  8034a2:	89 fa                	mov    %edi,%edx
  8034a4:	83 c4 14             	add    $0x14,%esp
  8034a7:	5e                   	pop    %esi
  8034a8:	5f                   	pop    %edi
  8034a9:	5d                   	pop    %ebp
  8034aa:	c3                   	ret    
  8034ab:	90                   	nop
  8034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034b0:	8b 04 24             	mov    (%esp),%eax
  8034b3:	be 20 00 00 00       	mov    $0x20,%esi
  8034b8:	89 e9                	mov    %ebp,%ecx
  8034ba:	29 ee                	sub    %ebp,%esi
  8034bc:	d3 e2                	shl    %cl,%edx
  8034be:	89 f1                	mov    %esi,%ecx
  8034c0:	d3 e8                	shr    %cl,%eax
  8034c2:	89 e9                	mov    %ebp,%ecx
  8034c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c8:	8b 04 24             	mov    (%esp),%eax
  8034cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8034cf:	89 fa                	mov    %edi,%edx
  8034d1:	d3 e0                	shl    %cl,%eax
  8034d3:	89 f1                	mov    %esi,%ecx
  8034d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8034dd:	d3 ea                	shr    %cl,%edx
  8034df:	89 e9                	mov    %ebp,%ecx
  8034e1:	d3 e7                	shl    %cl,%edi
  8034e3:	89 f1                	mov    %esi,%ecx
  8034e5:	d3 e8                	shr    %cl,%eax
  8034e7:	89 e9                	mov    %ebp,%ecx
  8034e9:	09 f8                	or     %edi,%eax
  8034eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8034ef:	f7 74 24 04          	divl   0x4(%esp)
  8034f3:	d3 e7                	shl    %cl,%edi
  8034f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034f9:	89 d7                	mov    %edx,%edi
  8034fb:	f7 64 24 08          	mull   0x8(%esp)
  8034ff:	39 d7                	cmp    %edx,%edi
  803501:	89 c1                	mov    %eax,%ecx
  803503:	89 14 24             	mov    %edx,(%esp)
  803506:	72 2c                	jb     803534 <__umoddi3+0x134>
  803508:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80350c:	72 22                	jb     803530 <__umoddi3+0x130>
  80350e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803512:	29 c8                	sub    %ecx,%eax
  803514:	19 d7                	sbb    %edx,%edi
  803516:	89 e9                	mov    %ebp,%ecx
  803518:	89 fa                	mov    %edi,%edx
  80351a:	d3 e8                	shr    %cl,%eax
  80351c:	89 f1                	mov    %esi,%ecx
  80351e:	d3 e2                	shl    %cl,%edx
  803520:	89 e9                	mov    %ebp,%ecx
  803522:	d3 ef                	shr    %cl,%edi
  803524:	09 d0                	or     %edx,%eax
  803526:	89 fa                	mov    %edi,%edx
  803528:	83 c4 14             	add    $0x14,%esp
  80352b:	5e                   	pop    %esi
  80352c:	5f                   	pop    %edi
  80352d:	5d                   	pop    %ebp
  80352e:	c3                   	ret    
  80352f:	90                   	nop
  803530:	39 d7                	cmp    %edx,%edi
  803532:	75 da                	jne    80350e <__umoddi3+0x10e>
  803534:	8b 14 24             	mov    (%esp),%edx
  803537:	89 c1                	mov    %eax,%ecx
  803539:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80353d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803541:	eb cb                	jmp    80350e <__umoddi3+0x10e>
  803543:	90                   	nop
  803544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803548:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80354c:	0f 82 0f ff ff ff    	jb     803461 <__umoddi3+0x61>
  803552:	e9 1a ff ff ff       	jmp    803471 <__umoddi3+0x71>
