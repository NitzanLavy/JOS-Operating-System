
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 d5 03 00 00       	call   800406 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80004b:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	eb 0c                	jmp    800063 <sum+0x23>
		tot ^= i * s[i];
  800057:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005b:	0f af ca             	imul   %edx,%ecx
  80005e:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800060:	83 c2 01             	add    $0x1,%edx
  800063:	39 da                	cmp    %ebx,%edx
  800065:	7c f0                	jl     800057 <sum+0x17>
		tot ^= i * s[i];
	return tot;
}
  800067:	5b                   	pop    %ebx
  800068:	5e                   	pop    %esi
  800069:	5d                   	pop    %ebp
  80006a:	c3                   	ret    

0080006b <umain>:

void
umain(int argc, char **argv)
{
  80006b:	55                   	push   %ebp
  80006c:	89 e5                	mov    %esp,%ebp
  80006e:	57                   	push   %edi
  80006f:	56                   	push   %esi
  800070:	53                   	push   %ebx
  800071:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  800077:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80007a:	c7 04 24 80 2f 80 00 	movl   $0x802f80,(%esp)
  800081:	e8 de 04 00 00       	call   800564 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800086:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  800095:	e8 a6 ff ff ff       	call   800040 <sum>
  80009a:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009f:	74 1a                	je     8000bb <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000a8:	00 
  8000a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ad:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  8000b4:	e8 ab 04 00 00       	call   800564 <cprintf>
  8000b9:	eb 0c                	jmp    8000c7 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000bb:	c7 04 24 8f 2f 80 00 	movl   $0x802f8f,(%esp)
  8000c2:	e8 9d 04 00 00       	call   800564 <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000c7:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000ce:	00 
  8000cf:	c7 04 24 20 60 80 00 	movl   $0x806020,(%esp)
  8000d6:	e8 65 ff ff ff       	call   800040 <sum>
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 12                	je     8000f1 <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e3:	c7 04 24 84 30 80 00 	movl   $0x803084,(%esp)
  8000ea:	e8 75 04 00 00       	call   800564 <cprintf>
  8000ef:	eb 0c                	jmp    8000fd <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000f1:	c7 04 24 a6 2f 80 00 	movl   $0x802fa6,(%esp)
  8000f8:	e8 67 04 00 00       	call   800564 <cprintf>

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000fd:	c7 44 24 04 bc 2f 80 	movl   $0x802fbc,0x4(%esp)
  800104:	00 
  800105:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80010b:	89 04 24             	mov    %eax,(%esp)
  80010e:	e8 94 0a 00 00       	call   800ba7 <strcat>
	for (i = 0; i < argc; i++) {
  800113:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  800118:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80011e:	eb 32                	jmp    800152 <umain+0xe7>
		strcat(args, " '");
  800120:	c7 44 24 04 c8 2f 80 	movl   $0x802fc8,0x4(%esp)
  800127:	00 
  800128:	89 34 24             	mov    %esi,(%esp)
  80012b:	e8 77 0a 00 00       	call   800ba7 <strcat>
		strcat(args, argv[i]);
  800130:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800133:	89 44 24 04          	mov    %eax,0x4(%esp)
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 68 0a 00 00       	call   800ba7 <strcat>
		strcat(args, "'");
  80013f:	c7 44 24 04 c9 2f 80 	movl   $0x802fc9,0x4(%esp)
  800146:	00 
  800147:	89 34 24             	mov    %esi,(%esp)
  80014a:	e8 58 0a 00 00       	call   800ba7 <strcat>
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80014f:	83 c3 01             	add    $0x1,%ebx
  800152:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800155:	7c c9                	jl     800120 <umain+0xb5>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  800157:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	c7 04 24 cb 2f 80 00 	movl   $0x802fcb,(%esp)
  800168:	e8 f7 03 00 00       	call   800564 <cprintf>

	cprintf("init: running sh\n");
  80016d:	c7 04 24 cf 2f 80 00 	movl   $0x802fcf,(%esp)
  800174:	e8 eb 03 00 00       	call   800564 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800180:	e8 f2 13 00 00       	call   801577 <close>
	if ((r = opencons()) < 0)
  800185:	e8 21 02 00 00       	call   8003ab <opencons>
  80018a:	85 c0                	test   %eax,%eax
  80018c:	79 20                	jns    8001ae <umain+0x143>
		panic("opencons: %e", r);
  80018e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800192:	c7 44 24 08 e1 2f 80 	movl   $0x802fe1,0x8(%esp)
  800199:	00 
  80019a:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8001a1:	00 
  8001a2:	c7 04 24 ee 2f 80 00 	movl   $0x802fee,(%esp)
  8001a9:	e8 bd 02 00 00       	call   80046b <_panic>
	if (r != 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	74 20                	je     8001d2 <umain+0x167>
		panic("first opencons used fd %d", r);
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 fa 2f 80 	movl   $0x802ffa,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 ee 2f 80 00 	movl   $0x802fee,(%esp)
  8001cd:	e8 99 02 00 00       	call   80046b <_panic>
	if ((r = dup(0, 1)) < 0)
  8001d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001d9:	00 
  8001da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e1:	e8 e6 13 00 00       	call   8015cc <dup>
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	79 20                	jns    80020a <umain+0x19f>
		panic("dup: %e", r);
  8001ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ee:	c7 44 24 08 14 30 80 	movl   $0x803014,0x8(%esp)
  8001f5:	00 
  8001f6:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  8001fd:	00 
  8001fe:	c7 04 24 ee 2f 80 00 	movl   $0x802fee,(%esp)
  800205:	e8 61 02 00 00       	call   80046b <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  80020a:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  800211:	e8 4e 03 00 00       	call   800564 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800216:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80021d:	00 
  80021e:	c7 44 24 04 30 30 80 	movl   $0x803030,0x4(%esp)
  800225:	00 
  800226:	c7 04 24 2f 30 80 00 	movl   $0x80302f,(%esp)
  80022d:	e8 05 20 00 00       	call   802237 <spawnl>
		if (r < 0) {
  800232:	85 c0                	test   %eax,%eax
  800234:	79 12                	jns    800248 <umain+0x1dd>
			cprintf("init: spawn sh: %e\n", r);
  800236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023a:	c7 04 24 33 30 80 00 	movl   $0x803033,(%esp)
  800241:	e8 1e 03 00 00       	call   800564 <cprintf>
			continue;
  800246:	eb c2                	jmp    80020a <umain+0x19f>
		}
		wait(r);
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	e8 ea 28 00 00       	call   802b3a <wait>
  800250:	eb b8                	jmp    80020a <umain+0x19f>
  800252:	66 90                	xchg   %ax,%ax
  800254:	66 90                	xchg   %ax,%ax
  800256:	66 90                	xchg   %ax,%ax
  800258:	66 90                	xchg   %ax,%ax
  80025a:	66 90                	xchg   %ax,%ax
  80025c:	66 90                	xchg   %ax,%ax
  80025e:	66 90                	xchg   %ax,%ax

00800260 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800263:	b8 00 00 00 00       	mov    $0x0,%eax
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800270:	c7 44 24 04 b3 30 80 	movl   $0x8030b3,0x4(%esp)
  800277:	00 
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	e8 04 09 00 00       	call   800b87 <strcpy>
	return 0;
}
  800283:	b8 00 00 00 00       	mov    $0x0,%eax
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800296:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80029b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002a1:	eb 31                	jmp    8002d4 <devcons_write+0x4a>
		m = n - tot;
  8002a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8002a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8002a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8002ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8002b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002b7:	03 45 0c             	add    0xc(%ebp),%eax
  8002ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002be:	89 3c 24             	mov    %edi,(%esp)
  8002c1:	e8 5e 0a 00 00       	call   800d24 <memmove>
		sys_cputs(buf, m);
  8002c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ca:	89 3c 24             	mov    %edi,(%esp)
  8002cd:	e8 04 0c 00 00       	call   800ed6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002d2:	01 f3                	add    %esi,%ebx
  8002d4:	89 d8                	mov    %ebx,%eax
  8002d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8002d9:	72 c8                	jb     8002a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8002ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8002f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002f5:	75 07                	jne    8002fe <devcons_read+0x18>
  8002f7:	eb 2a                	jmp    800323 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8002f9:	e8 86 0c 00 00       	call   800f84 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8002fe:	66 90                	xchg   %ax,%ax
  800300:	e8 ef 0b 00 00       	call   800ef4 <sys_cgetc>
  800305:	85 c0                	test   %eax,%eax
  800307:	74 f0                	je     8002f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800309:	85 c0                	test   %eax,%eax
  80030b:	78 16                	js     800323 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80030d:	83 f8 04             	cmp    $0x4,%eax
  800310:	74 0c                	je     80031e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800312:	8b 55 0c             	mov    0xc(%ebp),%edx
  800315:	88 02                	mov    %al,(%edx)
	return 1;
  800317:	b8 01 00 00 00       	mov    $0x1,%eax
  80031c:	eb 05                	jmp    800323 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800331:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800338:	00 
  800339:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80033c:	89 04 24             	mov    %eax,(%esp)
  80033f:	e8 92 0b 00 00       	call   800ed6 <sys_cputs>
}
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <getchar>:

int
getchar(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80034c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800353:	00 
  800354:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800362:	e8 73 13 00 00       	call   8016da <read>
	if (r < 0)
  800367:	85 c0                	test   %eax,%eax
  800369:	78 0f                	js     80037a <getchar+0x34>
		return r;
	if (r < 1)
  80036b:	85 c0                	test   %eax,%eax
  80036d:	7e 06                	jle    800375 <getchar+0x2f>
		return -E_EOF;
	return c;
  80036f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800373:	eb 05                	jmp    80037a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800375:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800382:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800385:	89 44 24 04          	mov    %eax,0x4(%esp)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	89 04 24             	mov    %eax,(%esp)
  80038f:	e8 b2 10 00 00       	call   801446 <fd_lookup>
  800394:	85 c0                	test   %eax,%eax
  800396:	78 11                	js     8003a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80039b:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003a1:	39 10                	cmp    %edx,(%eax)
  8003a3:	0f 94 c0             	sete   %al
  8003a6:	0f b6 c0             	movzbl %al,%eax
}
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <opencons>:

int
opencons(void)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8003b4:	89 04 24             	mov    %eax,(%esp)
  8003b7:	e8 3b 10 00 00       	call   8013f7 <fd_alloc>
		return r;
  8003bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003be:	85 c0                	test   %eax,%eax
  8003c0:	78 40                	js     800402 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8003c9:	00 
  8003ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003d8:	e8 c6 0b 00 00       	call   800fa3 <sys_page_alloc>
		return r;
  8003dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	78 1f                	js     800402 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8003e3:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	e8 d0 0f 00 00       	call   8013d0 <fd2num>
  800400:	89 c2                	mov    %eax,%edx
}
  800402:	89 d0                	mov    %edx,%eax
  800404:	c9                   	leave  
  800405:	c3                   	ret    

00800406 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	56                   	push   %esi
  80040a:	53                   	push   %ebx
  80040b:	83 ec 10             	sub    $0x10,%esp
  80040e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800411:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800414:	e8 4c 0b 00 00       	call   800f65 <sys_getenvid>
  800419:	25 ff 03 00 00       	and    $0x3ff,%eax
  80041e:	89 c2                	mov    %eax,%edx
  800420:	c1 e2 07             	shl    $0x7,%edx
  800423:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80042a:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80042f:	85 db                	test   %ebx,%ebx
  800431:	7e 07                	jle    80043a <libmain+0x34>
		binaryname = argv[0];
  800433:	8b 06                	mov    (%esi),%eax
  800435:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  80043a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043e:	89 1c 24             	mov    %ebx,(%esp)
  800441:	e8 25 fc ff ff       	call   80006b <umain>

	// exit gracefully
	exit();
  800446:	e8 07 00 00 00       	call   800452 <exit>
}
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	5b                   	pop    %ebx
  80044f:	5e                   	pop    %esi
  800450:	5d                   	pop    %ebp
  800451:	c3                   	ret    

00800452 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
  800455:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800458:	e8 4d 11 00 00       	call   8015aa <close_all>
	sys_env_destroy(0);
  80045d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800464:	e8 aa 0a 00 00       	call   800f13 <sys_env_destroy>
}
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	56                   	push   %esi
  80046f:	53                   	push   %ebx
  800470:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800473:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800476:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  80047c:	e8 e4 0a 00 00       	call   800f65 <sys_getenvid>
  800481:	8b 55 0c             	mov    0xc(%ebp),%edx
  800484:	89 54 24 10          	mov    %edx,0x10(%esp)
  800488:	8b 55 08             	mov    0x8(%ebp),%edx
  80048b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048f:	89 74 24 08          	mov    %esi,0x8(%esp)
  800493:	89 44 24 04          	mov    %eax,0x4(%esp)
  800497:	c7 04 24 cc 30 80 00 	movl   $0x8030cc,(%esp)
  80049e:	e8 c1 00 00 00       	call   800564 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004aa:	89 04 24             	mov    %eax,(%esp)
  8004ad:	e8 51 00 00 00       	call   800503 <vcprintf>
	cprintf("\n");
  8004b2:	c7 04 24 1f 36 80 00 	movl   $0x80361f,(%esp)
  8004b9:	e8 a6 00 00 00       	call   800564 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004be:	cc                   	int3   
  8004bf:	eb fd                	jmp    8004be <_panic+0x53>

008004c1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	53                   	push   %ebx
  8004c5:	83 ec 14             	sub    $0x14,%esp
  8004c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004cb:	8b 13                	mov    (%ebx),%edx
  8004cd:	8d 42 01             	lea    0x1(%edx),%eax
  8004d0:	89 03                	mov    %eax,(%ebx)
  8004d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004d5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8004d9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004de:	75 19                	jne    8004f9 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8004e0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8004e7:	00 
  8004e8:	8d 43 08             	lea    0x8(%ebx),%eax
  8004eb:	89 04 24             	mov    %eax,(%esp)
  8004ee:	e8 e3 09 00 00       	call   800ed6 <sys_cputs>
		b->idx = 0;
  8004f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8004f9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8004fd:	83 c4 14             	add    $0x14,%esp
  800500:	5b                   	pop    %ebx
  800501:	5d                   	pop    %ebp
  800502:	c3                   	ret    

00800503 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800503:	55                   	push   %ebp
  800504:	89 e5                	mov    %esp,%ebp
  800506:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80050c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800513:	00 00 00 
	b.cnt = 0;
  800516:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80051d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80052e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800534:	89 44 24 04          	mov    %eax,0x4(%esp)
  800538:	c7 04 24 c1 04 80 00 	movl   $0x8004c1,(%esp)
  80053f:	e8 aa 01 00 00       	call   8006ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800544:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80054a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800554:	89 04 24             	mov    %eax,(%esp)
  800557:	e8 7a 09 00 00       	call   800ed6 <sys_cputs>

	return b.cnt;
}
  80055c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800562:	c9                   	leave  
  800563:	c3                   	ret    

00800564 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80056d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	89 04 24             	mov    %eax,(%esp)
  800577:	e8 87 ff ff ff       	call   800503 <vcprintf>
	va_end(ap);

	return cnt;
}
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    
  80057e:	66 90                	xchg   %ax,%ax

00800580 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 3c             	sub    $0x3c,%esp
  800589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058c:	89 d7                	mov    %edx,%edi
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	89 c3                	mov    %eax,%ebx
  800599:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80059c:	8b 45 10             	mov    0x10(%ebp),%eax
  80059f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ad:	39 d9                	cmp    %ebx,%ecx
  8005af:	72 05                	jb     8005b6 <printnum+0x36>
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	77 69                	ja     80061f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8005bd:	83 ee 01             	sub    $0x1,%esi
  8005c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8005c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8005cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8005d0:	89 c3                	mov    %eax,%ebx
  8005d2:	89 d6                	mov    %edx,%esi
  8005d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8005e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e5:	89 04 24             	mov    %eax,(%esp)
  8005e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ef:	e8 ec 26 00 00       	call   802ce0 <__udivdi3>
  8005f4:	89 d9                	mov    %ebx,%ecx
  8005f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	89 54 24 04          	mov    %edx,0x4(%esp)
  800605:	89 fa                	mov    %edi,%edx
  800607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060a:	e8 71 ff ff ff       	call   800580 <printnum>
  80060f:	eb 1b                	jmp    80062c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800611:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800615:	8b 45 18             	mov    0x18(%ebp),%eax
  800618:	89 04 24             	mov    %eax,(%esp)
  80061b:	ff d3                	call   *%ebx
  80061d:	eb 03                	jmp    800622 <printnum+0xa2>
  80061f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800622:	83 ee 01             	sub    $0x1,%esi
  800625:	85 f6                	test   %esi,%esi
  800627:	7f e8                	jg     800611 <printnum+0x91>
  800629:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80062c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800630:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800634:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800637:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80063a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80063e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800645:	89 04 24             	mov    %eax,(%esp)
  800648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064f:	e8 bc 27 00 00       	call   802e10 <__umoddi3>
  800654:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800658:	0f be 80 ef 30 80 00 	movsbl 0x8030ef(%eax),%eax
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800665:	ff d0                	call   *%eax
}
  800667:	83 c4 3c             	add    $0x3c,%esp
  80066a:	5b                   	pop    %ebx
  80066b:	5e                   	pop    %esi
  80066c:	5f                   	pop    %edi
  80066d:	5d                   	pop    %ebp
  80066e:	c3                   	ret    

0080066f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800672:	83 fa 01             	cmp    $0x1,%edx
  800675:	7e 0e                	jle    800685 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800677:	8b 10                	mov    (%eax),%edx
  800679:	8d 4a 08             	lea    0x8(%edx),%ecx
  80067c:	89 08                	mov    %ecx,(%eax)
  80067e:	8b 02                	mov    (%edx),%eax
  800680:	8b 52 04             	mov    0x4(%edx),%edx
  800683:	eb 22                	jmp    8006a7 <getuint+0x38>
	else if (lflag)
  800685:	85 d2                	test   %edx,%edx
  800687:	74 10                	je     800699 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80068e:	89 08                	mov    %ecx,(%eax)
  800690:	8b 02                	mov    (%edx),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
  800697:	eb 0e                	jmp    8006a7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800699:	8b 10                	mov    (%eax),%edx
  80069b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80069e:	89 08                	mov    %ecx,(%eax)
  8006a0:	8b 02                	mov    (%edx),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a7:	5d                   	pop    %ebp
  8006a8:	c3                   	ret    

008006a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006a9:	55                   	push   %ebp
  8006aa:	89 e5                	mov    %esp,%ebp
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006b3:	8b 10                	mov    (%eax),%edx
  8006b5:	3b 50 04             	cmp    0x4(%eax),%edx
  8006b8:	73 0a                	jae    8006c4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006bd:	89 08                	mov    %ecx,(%eax)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	88 02                	mov    %al,(%edx)
}
  8006c4:	5d                   	pop    %ebp
  8006c5:	c3                   	ret    

008006c6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	e8 02 00 00 00       	call   8006ee <vprintfmt>
	va_end(ap);
}
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	57                   	push   %edi
  8006f2:	56                   	push   %esi
  8006f3:	53                   	push   %ebx
  8006f4:	83 ec 3c             	sub    $0x3c,%esp
  8006f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006fd:	eb 14                	jmp    800713 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8006ff:	85 c0                	test   %eax,%eax
  800701:	0f 84 b3 03 00 00    	je     800aba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800707:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070b:	89 04 24             	mov    %eax,(%esp)
  80070e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800711:	89 f3                	mov    %esi,%ebx
  800713:	8d 73 01             	lea    0x1(%ebx),%esi
  800716:	0f b6 03             	movzbl (%ebx),%eax
  800719:	83 f8 25             	cmp    $0x25,%eax
  80071c:	75 e1                	jne    8006ff <vprintfmt+0x11>
  80071e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800722:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800729:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800730:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
  80073c:	eb 1d                	jmp    80075b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800740:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800744:	eb 15                	jmp    80075b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800746:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800748:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80074c:	eb 0d                	jmp    80075b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80074e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800751:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800754:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80075e:	0f b6 0e             	movzbl (%esi),%ecx
  800761:	0f b6 c1             	movzbl %cl,%eax
  800764:	83 e9 23             	sub    $0x23,%ecx
  800767:	80 f9 55             	cmp    $0x55,%cl
  80076a:	0f 87 2a 03 00 00    	ja     800a9a <vprintfmt+0x3ac>
  800770:	0f b6 c9             	movzbl %cl,%ecx
  800773:	ff 24 8d 60 32 80 00 	jmp    *0x803260(,%ecx,4)
  80077a:	89 de                	mov    %ebx,%esi
  80077c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800781:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800784:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800788:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80078b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80078e:	83 fb 09             	cmp    $0x9,%ebx
  800791:	77 36                	ja     8007c9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800796:	eb e9                	jmp    800781 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8d 48 04             	lea    0x4(%eax),%ecx
  80079e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8007a8:	eb 22                	jmp    8007cc <vprintfmt+0xde>
  8007aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b4:	0f 49 c1             	cmovns %ecx,%eax
  8007b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ba:	89 de                	mov    %ebx,%esi
  8007bc:	eb 9d                	jmp    80075b <vprintfmt+0x6d>
  8007be:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8007c0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8007c7:	eb 92                	jmp    80075b <vprintfmt+0x6d>
  8007c9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8007cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d0:	79 89                	jns    80075b <vprintfmt+0x6d>
  8007d2:	e9 77 ff ff ff       	jmp    80074e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007d7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007da:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8007dc:	e9 7a ff ff ff       	jmp    80075b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8d 50 04             	lea    0x4(%eax),%edx
  8007e7:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	89 04 24             	mov    %eax,(%esp)
  8007f3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007f6:	e9 18 ff ff ff       	jmp    800713 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 50 04             	lea    0x4(%eax),%edx
  800801:	89 55 14             	mov    %edx,0x14(%ebp)
  800804:	8b 00                	mov    (%eax),%eax
  800806:	99                   	cltd   
  800807:	31 d0                	xor    %edx,%eax
  800809:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80080b:	83 f8 12             	cmp    $0x12,%eax
  80080e:	7f 0b                	jg     80081b <vprintfmt+0x12d>
  800810:	8b 14 85 c0 33 80 00 	mov    0x8033c0(,%eax,4),%edx
  800817:	85 d2                	test   %edx,%edx
  800819:	75 20                	jne    80083b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80081b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80081f:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  800826:	00 
  800827:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	89 04 24             	mov    %eax,(%esp)
  800831:	e8 90 fe ff ff       	call   8006c6 <printfmt>
  800836:	e9 d8 fe ff ff       	jmp    800713 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80083b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80083f:	c7 44 24 08 01 35 80 	movl   $0x803501,0x8(%esp)
  800846:	00 
  800847:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 04 24             	mov    %eax,(%esp)
  800851:	e8 70 fe ff ff       	call   8006c6 <printfmt>
  800856:	e9 b8 fe ff ff       	jmp    800713 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80085b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80085e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800861:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 50 04             	lea    0x4(%eax),%edx
  80086a:	89 55 14             	mov    %edx,0x14(%ebp)
  80086d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80086f:	85 f6                	test   %esi,%esi
  800871:	b8 00 31 80 00       	mov    $0x803100,%eax
  800876:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800879:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80087d:	0f 84 97 00 00 00    	je     80091a <vprintfmt+0x22c>
  800883:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800887:	0f 8e 9b 00 00 00    	jle    800928 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80088d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800891:	89 34 24             	mov    %esi,(%esp)
  800894:	e8 cf 02 00 00       	call   800b68 <strnlen>
  800899:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80089c:	29 c2                	sub    %eax,%edx
  80089e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8008a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8008a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008b1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b3:	eb 0f                	jmp    8008c4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8008b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008bc:	89 04 24             	mov    %eax,(%esp)
  8008bf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c1:	83 eb 01             	sub    $0x1,%ebx
  8008c4:	85 db                	test   %ebx,%ebx
  8008c6:	7f ed                	jg     8008b5 <vprintfmt+0x1c7>
  8008c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8008cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8008ce:	85 d2                	test   %edx,%edx
  8008d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d5:	0f 49 c2             	cmovns %edx,%eax
  8008d8:	29 c2                	sub    %eax,%edx
  8008da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8008dd:	89 d7                	mov    %edx,%edi
  8008df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008e2:	eb 50                	jmp    800934 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008e8:	74 1e                	je     800908 <vprintfmt+0x21a>
  8008ea:	0f be d2             	movsbl %dl,%edx
  8008ed:	83 ea 20             	sub    $0x20,%edx
  8008f0:	83 fa 5e             	cmp    $0x5e,%edx
  8008f3:	76 13                	jbe    800908 <vprintfmt+0x21a>
					putch('?', putdat);
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800903:	ff 55 08             	call   *0x8(%ebp)
  800906:	eb 0d                	jmp    800915 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80090f:	89 04 24             	mov    %eax,(%esp)
  800912:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	83 ef 01             	sub    $0x1,%edi
  800918:	eb 1a                	jmp    800934 <vprintfmt+0x246>
  80091a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80091d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800920:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800923:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800926:	eb 0c                	jmp    800934 <vprintfmt+0x246>
  800928:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80092b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80092e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800931:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800934:	83 c6 01             	add    $0x1,%esi
  800937:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80093b:	0f be c2             	movsbl %dl,%eax
  80093e:	85 c0                	test   %eax,%eax
  800940:	74 27                	je     800969 <vprintfmt+0x27b>
  800942:	85 db                	test   %ebx,%ebx
  800944:	78 9e                	js     8008e4 <vprintfmt+0x1f6>
  800946:	83 eb 01             	sub    $0x1,%ebx
  800949:	79 99                	jns    8008e4 <vprintfmt+0x1f6>
  80094b:	89 f8                	mov    %edi,%eax
  80094d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800950:	8b 75 08             	mov    0x8(%ebp),%esi
  800953:	89 c3                	mov    %eax,%ebx
  800955:	eb 1a                	jmp    800971 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800957:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800962:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800964:	83 eb 01             	sub    $0x1,%ebx
  800967:	eb 08                	jmp    800971 <vprintfmt+0x283>
  800969:	89 fb                	mov    %edi,%ebx
  80096b:	8b 75 08             	mov    0x8(%ebp),%esi
  80096e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800971:	85 db                	test   %ebx,%ebx
  800973:	7f e2                	jg     800957 <vprintfmt+0x269>
  800975:	89 75 08             	mov    %esi,0x8(%ebp)
  800978:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80097b:	e9 93 fd ff ff       	jmp    800713 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800980:	83 fa 01             	cmp    $0x1,%edx
  800983:	7e 16                	jle    80099b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	8d 50 08             	lea    0x8(%eax),%edx
  80098b:	89 55 14             	mov    %edx,0x14(%ebp)
  80098e:	8b 50 04             	mov    0x4(%eax),%edx
  800991:	8b 00                	mov    (%eax),%eax
  800993:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800996:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800999:	eb 32                	jmp    8009cd <vprintfmt+0x2df>
	else if (lflag)
  80099b:	85 d2                	test   %edx,%edx
  80099d:	74 18                	je     8009b7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8d 50 04             	lea    0x4(%eax),%edx
  8009a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009a8:	8b 30                	mov    (%eax),%esi
  8009aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8009ad:	89 f0                	mov    %esi,%eax
  8009af:	c1 f8 1f             	sar    $0x1f,%eax
  8009b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b5:	eb 16                	jmp    8009cd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	8d 50 04             	lea    0x4(%eax),%edx
  8009bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8009c0:	8b 30                	mov    (%eax),%esi
  8009c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8009c5:	89 f0                	mov    %esi,%eax
  8009c7:	c1 f8 1f             	sar    $0x1f,%eax
  8009ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8009d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8009d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dc:	0f 89 80 00 00 00    	jns    800a62 <vprintfmt+0x374>
				putch('-', putdat);
  8009e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009ed:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8009f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009f6:	f7 d8                	neg    %eax
  8009f8:	83 d2 00             	adc    $0x0,%edx
  8009fb:	f7 da                	neg    %edx
			}
			base = 10;
  8009fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800a02:	eb 5e                	jmp    800a62 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a04:	8d 45 14             	lea    0x14(%ebp),%eax
  800a07:	e8 63 fc ff ff       	call   80066f <getuint>
			base = 10;
  800a0c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800a11:	eb 4f                	jmp    800a62 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800a13:	8d 45 14             	lea    0x14(%ebp),%eax
  800a16:	e8 54 fc ff ff       	call   80066f <getuint>
			base = 8;
  800a1b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800a20:	eb 40                	jmp    800a62 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800a22:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a26:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a2d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800a30:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a34:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a3b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	8d 50 04             	lea    0x4(%eax),%edx
  800a44:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a47:	8b 00                	mov    (%eax),%eax
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a4e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800a53:	eb 0d                	jmp    800a62 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a55:	8d 45 14             	lea    0x14(%ebp),%eax
  800a58:	e8 12 fc ff ff       	call   80066f <getuint>
			base = 16;
  800a5d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800a66:	89 74 24 10          	mov    %esi,0x10(%esp)
  800a6a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800a6d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a71:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a75:	89 04 24             	mov    %eax,(%esp)
  800a78:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a7c:	89 fa                	mov    %edi,%edx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	e8 fa fa ff ff       	call   800580 <printnum>
			break;
  800a86:	e9 88 fc ff ff       	jmp    800713 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a8f:	89 04 24             	mov    %eax,(%esp)
  800a92:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a95:	e9 79 fc ff ff       	jmp    800713 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a9e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800aa5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	89 f3                	mov    %esi,%ebx
  800aaa:	eb 03                	jmp    800aaf <vprintfmt+0x3c1>
  800aac:	83 eb 01             	sub    $0x1,%ebx
  800aaf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800ab3:	75 f7                	jne    800aac <vprintfmt+0x3be>
  800ab5:	e9 59 fc ff ff       	jmp    800713 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800aba:	83 c4 3c             	add    $0x3c,%esp
  800abd:	5b                   	pop    %ebx
  800abe:	5e                   	pop    %esi
  800abf:	5f                   	pop    %edi
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 28             	sub    $0x28,%esp
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ace:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ad1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ad5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ad8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800adf:	85 c0                	test   %eax,%eax
  800ae1:	74 30                	je     800b13 <vsnprintf+0x51>
  800ae3:	85 d2                	test   %edx,%edx
  800ae5:	7e 2c                	jle    800b13 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800aee:	8b 45 10             	mov    0x10(%ebp),%eax
  800af1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800afc:	c7 04 24 a9 06 80 00 	movl   $0x8006a9,(%esp)
  800b03:	e8 e6 fb ff ff       	call   8006ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b11:	eb 05                	jmp    800b18 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800b13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b20:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b27:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	89 04 24             	mov    %eax,(%esp)
  800b3b:	e8 82 ff ff ff       	call   800ac2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b40:	c9                   	leave  
  800b41:	c3                   	ret    
  800b42:	66 90                	xchg   %ax,%ax
  800b44:	66 90                	xchg   %ax,%ax
  800b46:	66 90                	xchg   %ax,%ax
  800b48:	66 90                	xchg   %ax,%ax
  800b4a:	66 90                	xchg   %ax,%ax
  800b4c:	66 90                	xchg   %ax,%ax
  800b4e:	66 90                	xchg   %ax,%ax

00800b50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5b:	eb 03                	jmp    800b60 <strlen+0x10>
		n++;
  800b5d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b60:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b64:	75 f7                	jne    800b5d <strlen+0xd>
		n++;
	return n;
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
  800b76:	eb 03                	jmp    800b7b <strnlen+0x13>
		n++;
  800b78:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7b:	39 d0                	cmp    %edx,%eax
  800b7d:	74 06                	je     800b85 <strnlen+0x1d>
  800b7f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b83:	75 f3                	jne    800b78 <strnlen+0x10>
		n++;
	return n;
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b91:	89 c2                	mov    %eax,%edx
  800b93:	83 c2 01             	add    $0x1,%edx
  800b96:	83 c1 01             	add    $0x1,%ecx
  800b99:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b9d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ba0:	84 db                	test   %bl,%bl
  800ba2:	75 ef                	jne    800b93 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	53                   	push   %ebx
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bb1:	89 1c 24             	mov    %ebx,(%esp)
  800bb4:	e8 97 ff ff ff       	call   800b50 <strlen>
	strcpy(dst + len, src);
  800bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bc0:	01 d8                	add    %ebx,%eax
  800bc2:	89 04 24             	mov    %eax,(%esp)
  800bc5:	e8 bd ff ff ff       	call   800b87 <strcpy>
	return dst;
}
  800bca:	89 d8                	mov    %ebx,%eax
  800bcc:	83 c4 08             	add    $0x8,%esp
  800bcf:	5b                   	pop    %ebx
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	8b 75 08             	mov    0x8(%ebp),%esi
  800bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be2:	89 f2                	mov    %esi,%edx
  800be4:	eb 0f                	jmp    800bf5 <strncpy+0x23>
		*dst++ = *src;
  800be6:	83 c2 01             	add    $0x1,%edx
  800be9:	0f b6 01             	movzbl (%ecx),%eax
  800bec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bef:	80 39 01             	cmpb   $0x1,(%ecx)
  800bf2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf5:	39 da                	cmp    %ebx,%edx
  800bf7:	75 ed                	jne    800be6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bf9:	89 f0                	mov    %esi,%eax
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	8b 75 08             	mov    0x8(%ebp),%esi
  800c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c0d:	89 f0                	mov    %esi,%eax
  800c0f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c13:	85 c9                	test   %ecx,%ecx
  800c15:	75 0b                	jne    800c22 <strlcpy+0x23>
  800c17:	eb 1d                	jmp    800c36 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c19:	83 c0 01             	add    $0x1,%eax
  800c1c:	83 c2 01             	add    $0x1,%edx
  800c1f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c22:	39 d8                	cmp    %ebx,%eax
  800c24:	74 0b                	je     800c31 <strlcpy+0x32>
  800c26:	0f b6 0a             	movzbl (%edx),%ecx
  800c29:	84 c9                	test   %cl,%cl
  800c2b:	75 ec                	jne    800c19 <strlcpy+0x1a>
  800c2d:	89 c2                	mov    %eax,%edx
  800c2f:	eb 02                	jmp    800c33 <strlcpy+0x34>
  800c31:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800c33:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800c36:	29 f0                	sub    %esi,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c45:	eb 06                	jmp    800c4d <strcmp+0x11>
		p++, q++;
  800c47:	83 c1 01             	add    $0x1,%ecx
  800c4a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c4d:	0f b6 01             	movzbl (%ecx),%eax
  800c50:	84 c0                	test   %al,%al
  800c52:	74 04                	je     800c58 <strcmp+0x1c>
  800c54:	3a 02                	cmp    (%edx),%al
  800c56:	74 ef                	je     800c47 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	0f b6 c0             	movzbl %al,%eax
  800c5b:	0f b6 12             	movzbl (%edx),%edx
  800c5e:	29 d0                	sub    %edx,%eax
}
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	53                   	push   %ebx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	89 c3                	mov    %eax,%ebx
  800c6e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c71:	eb 06                	jmp    800c79 <strncmp+0x17>
		n--, p++, q++;
  800c73:	83 c0 01             	add    $0x1,%eax
  800c76:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c79:	39 d8                	cmp    %ebx,%eax
  800c7b:	74 15                	je     800c92 <strncmp+0x30>
  800c7d:	0f b6 08             	movzbl (%eax),%ecx
  800c80:	84 c9                	test   %cl,%cl
  800c82:	74 04                	je     800c88 <strncmp+0x26>
  800c84:	3a 0a                	cmp    (%edx),%cl
  800c86:	74 eb                	je     800c73 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c88:	0f b6 00             	movzbl (%eax),%eax
  800c8b:	0f b6 12             	movzbl (%edx),%edx
  800c8e:	29 d0                	sub    %edx,%eax
  800c90:	eb 05                	jmp    800c97 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c92:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c97:	5b                   	pop    %ebx
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca4:	eb 07                	jmp    800cad <strchr+0x13>
		if (*s == c)
  800ca6:	38 ca                	cmp    %cl,%dl
  800ca8:	74 0f                	je     800cb9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800caa:	83 c0 01             	add    $0x1,%eax
  800cad:	0f b6 10             	movzbl (%eax),%edx
  800cb0:	84 d2                	test   %dl,%dl
  800cb2:	75 f2                	jne    800ca6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc5:	eb 07                	jmp    800cce <strfind+0x13>
		if (*s == c)
  800cc7:	38 ca                	cmp    %cl,%dl
  800cc9:	74 0a                	je     800cd5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ccb:	83 c0 01             	add    $0x1,%eax
  800cce:	0f b6 10             	movzbl (%eax),%edx
  800cd1:	84 d2                	test   %dl,%dl
  800cd3:	75 f2                	jne    800cc7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce3:	85 c9                	test   %ecx,%ecx
  800ce5:	74 36                	je     800d1d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ced:	75 28                	jne    800d17 <memset+0x40>
  800cef:	f6 c1 03             	test   $0x3,%cl
  800cf2:	75 23                	jne    800d17 <memset+0x40>
		c &= 0xFF;
  800cf4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf8:	89 d3                	mov    %edx,%ebx
  800cfa:	c1 e3 08             	shl    $0x8,%ebx
  800cfd:	89 d6                	mov    %edx,%esi
  800cff:	c1 e6 18             	shl    $0x18,%esi
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	c1 e0 10             	shl    $0x10,%eax
  800d07:	09 f0                	or     %esi,%eax
  800d09:	09 c2                	or     %eax,%edx
  800d0b:	89 d0                	mov    %edx,%eax
  800d0d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d12:	fc                   	cld    
  800d13:	f3 ab                	rep stos %eax,%es:(%edi)
  800d15:	eb 06                	jmp    800d1d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	fc                   	cld    
  800d1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1d:	89 f8                	mov    %edi,%eax
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d32:	39 c6                	cmp    %eax,%esi
  800d34:	73 35                	jae    800d6b <memmove+0x47>
  800d36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d39:	39 d0                	cmp    %edx,%eax
  800d3b:	73 2e                	jae    800d6b <memmove+0x47>
		s += n;
		d += n;
  800d3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d4a:	75 13                	jne    800d5f <memmove+0x3b>
  800d4c:	f6 c1 03             	test   $0x3,%cl
  800d4f:	75 0e                	jne    800d5f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d51:	83 ef 04             	sub    $0x4,%edi
  800d54:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d57:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d5a:	fd                   	std    
  800d5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d5d:	eb 09                	jmp    800d68 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d5f:	83 ef 01             	sub    $0x1,%edi
  800d62:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d65:	fd                   	std    
  800d66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d68:	fc                   	cld    
  800d69:	eb 1d                	jmp    800d88 <memmove+0x64>
  800d6b:	89 f2                	mov    %esi,%edx
  800d6d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6f:	f6 c2 03             	test   $0x3,%dl
  800d72:	75 0f                	jne    800d83 <memmove+0x5f>
  800d74:	f6 c1 03             	test   $0x3,%cl
  800d77:	75 0a                	jne    800d83 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d79:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d7c:	89 c7                	mov    %eax,%edi
  800d7e:	fc                   	cld    
  800d7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d81:	eb 05                	jmp    800d88 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d83:	89 c7                	mov    %eax,%edi
  800d85:	fc                   	cld    
  800d86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	89 04 24             	mov    %eax,(%esp)
  800da6:	e8 79 ff ff ff       	call   800d24 <memmove>
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	89 d6                	mov    %edx,%esi
  800dba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbd:	eb 1a                	jmp    800dd9 <memcmp+0x2c>
		if (*s1 != *s2)
  800dbf:	0f b6 02             	movzbl (%edx),%eax
  800dc2:	0f b6 19             	movzbl (%ecx),%ebx
  800dc5:	38 d8                	cmp    %bl,%al
  800dc7:	74 0a                	je     800dd3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800dc9:	0f b6 c0             	movzbl %al,%eax
  800dcc:	0f b6 db             	movzbl %bl,%ebx
  800dcf:	29 d8                	sub    %ebx,%eax
  800dd1:	eb 0f                	jmp    800de2 <memcmp+0x35>
		s1++, s2++;
  800dd3:	83 c2 01             	add    $0x1,%edx
  800dd6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dd9:	39 f2                	cmp    %esi,%edx
  800ddb:	75 e2                	jne    800dbf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800def:	89 c2                	mov    %eax,%edx
  800df1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df4:	eb 07                	jmp    800dfd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800df6:	38 08                	cmp    %cl,(%eax)
  800df8:	74 07                	je     800e01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dfa:	83 c0 01             	add    $0x1,%eax
  800dfd:	39 d0                	cmp    %edx,%eax
  800dff:	72 f5                	jb     800df6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0f:	eb 03                	jmp    800e14 <strtol+0x11>
		s++;
  800e11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e14:	0f b6 0a             	movzbl (%edx),%ecx
  800e17:	80 f9 09             	cmp    $0x9,%cl
  800e1a:	74 f5                	je     800e11 <strtol+0xe>
  800e1c:	80 f9 20             	cmp    $0x20,%cl
  800e1f:	74 f0                	je     800e11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e21:	80 f9 2b             	cmp    $0x2b,%cl
  800e24:	75 0a                	jne    800e30 <strtol+0x2d>
		s++;
  800e26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e29:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2e:	eb 11                	jmp    800e41 <strtol+0x3e>
  800e30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e35:	80 f9 2d             	cmp    $0x2d,%cl
  800e38:	75 07                	jne    800e41 <strtol+0x3e>
		s++, neg = 1;
  800e3a:	8d 52 01             	lea    0x1(%edx),%edx
  800e3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800e46:	75 15                	jne    800e5d <strtol+0x5a>
  800e48:	80 3a 30             	cmpb   $0x30,(%edx)
  800e4b:	75 10                	jne    800e5d <strtol+0x5a>
  800e4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e51:	75 0a                	jne    800e5d <strtol+0x5a>
		s += 2, base = 16;
  800e53:	83 c2 02             	add    $0x2,%edx
  800e56:	b8 10 00 00 00       	mov    $0x10,%eax
  800e5b:	eb 10                	jmp    800e6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 0c                	jne    800e6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e63:	80 3a 30             	cmpb   $0x30,(%edx)
  800e66:	75 05                	jne    800e6d <strtol+0x6a>
		s++, base = 8;
  800e68:	83 c2 01             	add    $0x1,%edx
  800e6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e75:	0f b6 0a             	movzbl (%edx),%ecx
  800e78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800e7b:	89 f0                	mov    %esi,%eax
  800e7d:	3c 09                	cmp    $0x9,%al
  800e7f:	77 08                	ja     800e89 <strtol+0x86>
			dig = *s - '0';
  800e81:	0f be c9             	movsbl %cl,%ecx
  800e84:	83 e9 30             	sub    $0x30,%ecx
  800e87:	eb 20                	jmp    800ea9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800e89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800e8c:	89 f0                	mov    %esi,%eax
  800e8e:	3c 19                	cmp    $0x19,%al
  800e90:	77 08                	ja     800e9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800e92:	0f be c9             	movsbl %cl,%ecx
  800e95:	83 e9 57             	sub    $0x57,%ecx
  800e98:	eb 0f                	jmp    800ea9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800e9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e9d:	89 f0                	mov    %esi,%eax
  800e9f:	3c 19                	cmp    $0x19,%al
  800ea1:	77 16                	ja     800eb9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ea3:	0f be c9             	movsbl %cl,%ecx
  800ea6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ea9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800eac:	7d 0f                	jge    800ebd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800eae:	83 c2 01             	add    $0x1,%edx
  800eb1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800eb5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800eb7:	eb bc                	jmp    800e75 <strtol+0x72>
  800eb9:	89 d8                	mov    %ebx,%eax
  800ebb:	eb 02                	jmp    800ebf <strtol+0xbc>
  800ebd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ebf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec3:	74 05                	je     800eca <strtol+0xc7>
		*endptr = (char *) s;
  800ec5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ec8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800eca:	f7 d8                	neg    %eax
  800ecc:	85 ff                	test   %edi,%edi
  800ece:	0f 44 c3             	cmove  %ebx,%eax
}
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800edc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	89 c3                	mov    %eax,%ebx
  800ee9:	89 c7                	mov    %eax,%edi
  800eeb:	89 c6                	mov    %eax,%esi
  800eed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    

00800ef4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efa:	ba 00 00 00 00       	mov    $0x0,%edx
  800eff:	b8 01 00 00 00       	mov    $0x1,%eax
  800f04:	89 d1                	mov    %edx,%ecx
  800f06:	89 d3                	mov    %edx,%ebx
  800f08:	89 d7                	mov    %edx,%edi
  800f0a:	89 d6                	mov    %edx,%esi
  800f0c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f21:	b8 03 00 00 00       	mov    $0x3,%eax
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	89 cb                	mov    %ecx,%ebx
  800f2b:	89 cf                	mov    %ecx,%edi
  800f2d:	89 ce                	mov    %ecx,%esi
  800f2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	7e 28                	jle    800f5d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f39:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f40:	00 
  800f41:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  800f48:	00 
  800f49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f50:	00 
  800f51:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  800f58:	e8 0e f5 ff ff       	call   80046b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f5d:	83 c4 2c             	add    $0x2c,%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	b8 02 00 00 00       	mov    $0x2,%eax
  800f75:	89 d1                	mov    %edx,%ecx
  800f77:	89 d3                	mov    %edx,%ebx
  800f79:	89 d7                	mov    %edx,%edi
  800f7b:	89 d6                	mov    %edx,%esi
  800f7d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f7f:	5b                   	pop    %ebx
  800f80:	5e                   	pop    %esi
  800f81:	5f                   	pop    %edi
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    

00800f84 <sys_yield>:

void
sys_yield(void)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	57                   	push   %edi
  800f88:	56                   	push   %esi
  800f89:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f94:	89 d1                	mov    %edx,%ecx
  800f96:	89 d3                	mov    %edx,%ebx
  800f98:	89 d7                	mov    %edx,%edi
  800f9a:	89 d6                	mov    %edx,%esi
  800f9c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fac:	be 00 00 00 00       	mov    $0x0,%esi
  800fb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbf:	89 f7                	mov    %esi,%edi
  800fc1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	7e 28                	jle    800fef <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fcb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fd2:	00 
  800fd3:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  800fda:	00 
  800fdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe2:	00 
  800fe3:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  800fea:	e8 7c f4 ff ff       	call   80046b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fef:	83 c4 2c             	add    $0x2c,%esp
  800ff2:	5b                   	pop    %ebx
  800ff3:	5e                   	pop    %esi
  800ff4:	5f                   	pop    %edi
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    

00800ff7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
  800ffd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801000:	b8 05 00 00 00       	mov    $0x5,%eax
  801005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801008:	8b 55 08             	mov    0x8(%ebp),%edx
  80100b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80100e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801011:	8b 75 18             	mov    0x18(%ebp),%esi
  801014:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801016:	85 c0                	test   %eax,%eax
  801018:	7e 28                	jle    801042 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80101e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801025:	00 
  801026:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  80102d:	00 
  80102e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801035:	00 
  801036:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  80103d:	e8 29 f4 ff ff       	call   80046b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801042:	83 c4 2c             	add    $0x2c,%esp
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  801058:	b8 06 00 00 00       	mov    $0x6,%eax
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
  80106b:	7e 28                	jle    801095 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801071:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801078:	00 
  801079:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  801090:	e8 d6 f3 ff ff       	call   80046b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801095:	83 c4 2c             	add    $0x2c,%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  8010ab:	b8 08 00 00 00       	mov    $0x8,%eax
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
  8010be:	7e 28                	jle    8010e8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010db:	00 
  8010dc:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  8010e3:	e8 83 f3 ff ff       	call   80046b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010e8:	83 c4 2c             	add    $0x2c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  8010fe:	b8 09 00 00 00       	mov    $0x9,%eax
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
  801111:	7e 28                	jle    80113b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801113:	89 44 24 10          	mov    %eax,0x10(%esp)
  801117:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80111e:	00 
  80111f:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  801126:	00 
  801127:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80112e:	00 
  80112f:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  801136:	e8 30 f3 ff ff       	call   80046b <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80113b:	83 c4 2c             	add    $0x2c,%esp
  80113e:	5b                   	pop    %ebx
  80113f:	5e                   	pop    %esi
  801140:	5f                   	pop    %edi
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    

00801143 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  80114c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801151:	b8 0a 00 00 00       	mov    $0xa,%eax
  801156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801159:	8b 55 08             	mov    0x8(%ebp),%edx
  80115c:	89 df                	mov    %ebx,%edi
  80115e:	89 de                	mov    %ebx,%esi
  801160:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801162:	85 c0                	test   %eax,%eax
  801164:	7e 28                	jle    80118e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801166:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801171:	00 
  801172:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  801179:	00 
  80117a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801181:	00 
  801182:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  801189:	e8 dd f2 ff ff       	call   80046b <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80118e:	83 c4 2c             	add    $0x2c,%esp
  801191:	5b                   	pop    %ebx
  801192:	5e                   	pop    %esi
  801193:	5f                   	pop    %edi
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    

00801196 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119c:	be 00 00 00 00       	mov    $0x0,%esi
  8011a1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011b4:	5b                   	pop    %ebx
  8011b5:	5e                   	pop    %esi
  8011b6:	5f                   	pop    %edi
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	57                   	push   %edi
  8011bd:	56                   	push   %esi
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011c7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cf:	89 cb                	mov    %ecx,%ebx
  8011d1:	89 cf                	mov    %ecx,%edi
  8011d3:	89 ce                	mov    %ecx,%esi
  8011d5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	7e 28                	jle    801203 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011db:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011df:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8011e6:	00 
  8011e7:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  8011ee:	00 
  8011ef:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f6:	00 
  8011f7:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  8011fe:	e8 68 f2 ff ff       	call   80046b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801203:	83 c4 2c             	add    $0x2c,%esp
  801206:	5b                   	pop    %ebx
  801207:	5e                   	pop    %esi
  801208:	5f                   	pop    %edi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801211:	ba 00 00 00 00       	mov    $0x0,%edx
  801216:	b8 0e 00 00 00       	mov    $0xe,%eax
  80121b:	89 d1                	mov    %edx,%ecx
  80121d:	89 d3                	mov    %edx,%ebx
  80121f:	89 d7                	mov    %edx,%edi
  801221:	89 d6                	mov    %edx,%esi
  801223:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5f                   	pop    %edi
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    

0080122a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	57                   	push   %edi
  80122e:	56                   	push   %esi
  80122f:	53                   	push   %ebx
  801230:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801233:	bb 00 00 00 00       	mov    $0x0,%ebx
  801238:	b8 0f 00 00 00       	mov    $0xf,%eax
  80123d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801240:	8b 55 08             	mov    0x8(%ebp),%edx
  801243:	89 df                	mov    %ebx,%edi
  801245:	89 de                	mov    %ebx,%esi
  801247:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801249:	85 c0                	test   %eax,%eax
  80124b:	7e 28                	jle    801275 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801251:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801258:	00 
  801259:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  801260:	00 
  801261:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801268:	00 
  801269:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  801270:	e8 f6 f1 ff ff       	call   80046b <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801275:	83 c4 2c             	add    $0x2c,%esp
  801278:	5b                   	pop    %ebx
  801279:	5e                   	pop    %esi
  80127a:	5f                   	pop    %edi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	57                   	push   %edi
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
  801283:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801286:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128b:	b8 10 00 00 00       	mov    $0x10,%eax
  801290:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801293:	8b 55 08             	mov    0x8(%ebp),%edx
  801296:	89 df                	mov    %ebx,%edi
  801298:	89 de                	mov    %ebx,%esi
  80129a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80129c:	85 c0                	test   %eax,%eax
  80129e:	7e 28                	jle    8012c8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8012ab:	00 
  8012ac:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012bb:	00 
  8012bc:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  8012c3:	e8 a3 f1 ff ff       	call   80046b <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8012c8:	83 c4 2c             	add    $0x2c,%esp
  8012cb:	5b                   	pop    %ebx
  8012cc:	5e                   	pop    %esi
  8012cd:	5f                   	pop    %edi
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	57                   	push   %edi
  8012d4:	56                   	push   %esi
  8012d5:	53                   	push   %ebx
  8012d6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012de:	b8 11 00 00 00       	mov    $0x11,%eax
  8012e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e9:	89 df                	mov    %ebx,%edi
  8012eb:	89 de                	mov    %ebx,%esi
  8012ed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	7e 28                	jle    80131b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  801306:	00 
  801307:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80130e:	00 
  80130f:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  801316:	e8 50 f1 ff ff       	call   80046b <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80131b:	83 c4 2c             	add    $0x2c,%esp
  80131e:	5b                   	pop    %ebx
  80131f:	5e                   	pop    %esi
  801320:	5f                   	pop    %edi
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <sys_sleep>:

int
sys_sleep(int channel)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	57                   	push   %edi
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
  801329:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801331:	b8 12 00 00 00       	mov    $0x12,%eax
  801336:	8b 55 08             	mov    0x8(%ebp),%edx
  801339:	89 cb                	mov    %ecx,%ebx
  80133b:	89 cf                	mov    %ecx,%edi
  80133d:	89 ce                	mov    %ecx,%esi
  80133f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801341:	85 c0                	test   %eax,%eax
  801343:	7e 28                	jle    80136d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801345:	89 44 24 10          	mov    %eax,0x10(%esp)
  801349:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801350:	00 
  801351:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  801358:	00 
  801359:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801360:	00 
  801361:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  801368:	e8 fe f0 ff ff       	call   80046b <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80136d:	83 c4 2c             	add    $0x2c,%esp
  801370:	5b                   	pop    %ebx
  801371:	5e                   	pop    %esi
  801372:	5f                   	pop    %edi
  801373:	5d                   	pop    %ebp
  801374:	c3                   	ret    

00801375 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	57                   	push   %edi
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
  80137b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80137e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801383:	b8 13 00 00 00       	mov    $0x13,%eax
  801388:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80138b:	8b 55 08             	mov    0x8(%ebp),%edx
  80138e:	89 df                	mov    %ebx,%edi
  801390:	89 de                	mov    %ebx,%esi
  801392:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801394:	85 c0                	test   %eax,%eax
  801396:	7e 28                	jle    8013c0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801398:	89 44 24 10          	mov    %eax,0x10(%esp)
  80139c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8013a3:	00 
  8013a4:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  8013ab:	00 
  8013ac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013b3:	00 
  8013b4:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  8013bb:	e8 ab f0 ff ff       	call   80046b <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8013c0:	83 c4 2c             	add    $0x2c,%esp
  8013c3:	5b                   	pop    %ebx
  8013c4:	5e                   	pop    %esi
  8013c5:	5f                   	pop    %edi
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    
  8013c8:	66 90                	xchg   %ax,%ax
  8013ca:	66 90                	xchg   %ax,%ax
  8013cc:	66 90                	xchg   %ax,%ax
  8013ce:	66 90                	xchg   %ax,%ax

008013d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013db:	c1 e8 0c             	shr    $0xc,%eax
}
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013f5:	5d                   	pop    %ebp
  8013f6:	c3                   	ret    

008013f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801402:	89 c2                	mov    %eax,%edx
  801404:	c1 ea 16             	shr    $0x16,%edx
  801407:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80140e:	f6 c2 01             	test   $0x1,%dl
  801411:	74 11                	je     801424 <fd_alloc+0x2d>
  801413:	89 c2                	mov    %eax,%edx
  801415:	c1 ea 0c             	shr    $0xc,%edx
  801418:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80141f:	f6 c2 01             	test   $0x1,%dl
  801422:	75 09                	jne    80142d <fd_alloc+0x36>
			*fd_store = fd;
  801424:	89 01                	mov    %eax,(%ecx)
			return 0;
  801426:	b8 00 00 00 00       	mov    $0x0,%eax
  80142b:	eb 17                	jmp    801444 <fd_alloc+0x4d>
  80142d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801432:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801437:	75 c9                	jne    801402 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801439:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80143f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801444:	5d                   	pop    %ebp
  801445:	c3                   	ret    

00801446 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80144c:	83 f8 1f             	cmp    $0x1f,%eax
  80144f:	77 36                	ja     801487 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801451:	c1 e0 0c             	shl    $0xc,%eax
  801454:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801459:	89 c2                	mov    %eax,%edx
  80145b:	c1 ea 16             	shr    $0x16,%edx
  80145e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801465:	f6 c2 01             	test   $0x1,%dl
  801468:	74 24                	je     80148e <fd_lookup+0x48>
  80146a:	89 c2                	mov    %eax,%edx
  80146c:	c1 ea 0c             	shr    $0xc,%edx
  80146f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801476:	f6 c2 01             	test   $0x1,%dl
  801479:	74 1a                	je     801495 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80147b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147e:	89 02                	mov    %eax,(%edx)
	return 0;
  801480:	b8 00 00 00 00       	mov    $0x0,%eax
  801485:	eb 13                	jmp    80149a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801487:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148c:	eb 0c                	jmp    80149a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80148e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801493:	eb 05                	jmp    80149a <fd_lookup+0x54>
  801495:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80149a:	5d                   	pop    %ebp
  80149b:	c3                   	ret    

0080149c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 18             	sub    $0x18,%esp
  8014a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014aa:	eb 13                	jmp    8014bf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8014ac:	39 08                	cmp    %ecx,(%eax)
  8014ae:	75 0c                	jne    8014bc <dev_lookup+0x20>
			*dev = devtab[i];
  8014b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ba:	eb 38                	jmp    8014f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014bc:	83 c2 01             	add    $0x1,%edx
  8014bf:	8b 04 95 d4 34 80 00 	mov    0x8034d4(,%edx,4),%eax
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	75 e2                	jne    8014ac <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ca:	a1 90 77 80 00       	mov    0x807790,%eax
  8014cf:	8b 40 48             	mov    0x48(%eax),%eax
  8014d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014da:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  8014e1:	e8 7e f0 ff ff       	call   800564 <cprintf>
	*dev = 0;
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	56                   	push   %esi
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 20             	sub    $0x20,%esp
  8014fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801501:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801504:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801507:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80150b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801511:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801514:	89 04 24             	mov    %eax,(%esp)
  801517:	e8 2a ff ff ff       	call   801446 <fd_lookup>
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 05                	js     801525 <fd_close+0x2f>
	    || fd != fd2)
  801520:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801523:	74 0c                	je     801531 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801525:	84 db                	test   %bl,%bl
  801527:	ba 00 00 00 00       	mov    $0x0,%edx
  80152c:	0f 44 c2             	cmove  %edx,%eax
  80152f:	eb 3f                	jmp    801570 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801531:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801534:	89 44 24 04          	mov    %eax,0x4(%esp)
  801538:	8b 06                	mov    (%esi),%eax
  80153a:	89 04 24             	mov    %eax,(%esp)
  80153d:	e8 5a ff ff ff       	call   80149c <dev_lookup>
  801542:	89 c3                	mov    %eax,%ebx
  801544:	85 c0                	test   %eax,%eax
  801546:	78 16                	js     80155e <fd_close+0x68>
		if (dev->dev_close)
  801548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80154e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801553:	85 c0                	test   %eax,%eax
  801555:	74 07                	je     80155e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801557:	89 34 24             	mov    %esi,(%esp)
  80155a:	ff d0                	call   *%eax
  80155c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80155e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801562:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801569:	e8 dc fa ff ff       	call   80104a <sys_page_unmap>
	return r;
  80156e:	89 d8                	mov    %ebx,%eax
}
  801570:	83 c4 20             	add    $0x20,%esp
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801580:	89 44 24 04          	mov    %eax,0x4(%esp)
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	89 04 24             	mov    %eax,(%esp)
  80158a:	e8 b7 fe ff ff       	call   801446 <fd_lookup>
  80158f:	89 c2                	mov    %eax,%edx
  801591:	85 d2                	test   %edx,%edx
  801593:	78 13                	js     8015a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801595:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80159c:	00 
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	89 04 24             	mov    %eax,(%esp)
  8015a3:	e8 4e ff ff ff       	call   8014f6 <fd_close>
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <close_all>:

void
close_all(void)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015b6:	89 1c 24             	mov    %ebx,(%esp)
  8015b9:	e8 b9 ff ff ff       	call   801577 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015be:	83 c3 01             	add    $0x1,%ebx
  8015c1:	83 fb 20             	cmp    $0x20,%ebx
  8015c4:	75 f0                	jne    8015b6 <close_all+0xc>
		close(i);
}
  8015c6:	83 c4 14             	add    $0x14,%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5d                   	pop    %ebp
  8015cb:	c3                   	ret    

008015cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	57                   	push   %edi
  8015d0:	56                   	push   %esi
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	89 04 24             	mov    %eax,(%esp)
  8015e2:	e8 5f fe ff ff       	call   801446 <fd_lookup>
  8015e7:	89 c2                	mov    %eax,%edx
  8015e9:	85 d2                	test   %edx,%edx
  8015eb:	0f 88 e1 00 00 00    	js     8016d2 <dup+0x106>
		return r;
	close(newfdnum);
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	89 04 24             	mov    %eax,(%esp)
  8015f7:	e8 7b ff ff ff       	call   801577 <close>

	newfd = INDEX2FD(newfdnum);
  8015fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015ff:	c1 e3 0c             	shl    $0xc,%ebx
  801602:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80160b:	89 04 24             	mov    %eax,(%esp)
  80160e:	e8 cd fd ff ff       	call   8013e0 <fd2data>
  801613:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801615:	89 1c 24             	mov    %ebx,(%esp)
  801618:	e8 c3 fd ff ff       	call   8013e0 <fd2data>
  80161d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80161f:	89 f0                	mov    %esi,%eax
  801621:	c1 e8 16             	shr    $0x16,%eax
  801624:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80162b:	a8 01                	test   $0x1,%al
  80162d:	74 43                	je     801672 <dup+0xa6>
  80162f:	89 f0                	mov    %esi,%eax
  801631:	c1 e8 0c             	shr    $0xc,%eax
  801634:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80163b:	f6 c2 01             	test   $0x1,%dl
  80163e:	74 32                	je     801672 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801640:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801647:	25 07 0e 00 00       	and    $0xe07,%eax
  80164c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801650:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801654:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80165b:	00 
  80165c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801667:	e8 8b f9 ff ff       	call   800ff7 <sys_page_map>
  80166c:	89 c6                	mov    %eax,%esi
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 3e                	js     8016b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801675:	89 c2                	mov    %eax,%edx
  801677:	c1 ea 0c             	shr    $0xc,%edx
  80167a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801681:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801687:	89 54 24 10          	mov    %edx,0x10(%esp)
  80168b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80168f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801696:	00 
  801697:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a2:	e8 50 f9 ff ff       	call   800ff7 <sys_page_map>
  8016a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016ac:	85 f6                	test   %esi,%esi
  8016ae:	79 22                	jns    8016d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bb:	e8 8a f9 ff ff       	call   80104a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016cb:	e8 7a f9 ff ff       	call   80104a <sys_page_unmap>
	return r;
  8016d0:	89 f0                	mov    %esi,%eax
}
  8016d2:	83 c4 3c             	add    $0x3c,%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    

008016da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 24             	sub    $0x24,%esp
  8016e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016eb:	89 1c 24             	mov    %ebx,(%esp)
  8016ee:	e8 53 fd ff ff       	call   801446 <fd_lookup>
  8016f3:	89 c2                	mov    %eax,%edx
  8016f5:	85 d2                	test   %edx,%edx
  8016f7:	78 6d                	js     801766 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	8b 00                	mov    (%eax),%eax
  801705:	89 04 24             	mov    %eax,(%esp)
  801708:	e8 8f fd ff ff       	call   80149c <dev_lookup>
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 55                	js     801766 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801714:	8b 50 08             	mov    0x8(%eax),%edx
  801717:	83 e2 03             	and    $0x3,%edx
  80171a:	83 fa 01             	cmp    $0x1,%edx
  80171d:	75 23                	jne    801742 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80171f:	a1 90 77 80 00       	mov    0x807790,%eax
  801724:	8b 40 48             	mov    0x48(%eax),%eax
  801727:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80172b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172f:	c7 04 24 99 34 80 00 	movl   $0x803499,(%esp)
  801736:	e8 29 ee ff ff       	call   800564 <cprintf>
		return -E_INVAL;
  80173b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801740:	eb 24                	jmp    801766 <read+0x8c>
	}
	if (!dev->dev_read)
  801742:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801745:	8b 52 08             	mov    0x8(%edx),%edx
  801748:	85 d2                	test   %edx,%edx
  80174a:	74 15                	je     801761 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80174c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801753:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801756:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80175a:	89 04 24             	mov    %eax,(%esp)
  80175d:	ff d2                	call   *%edx
  80175f:	eb 05                	jmp    801766 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801761:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801766:	83 c4 24             	add    $0x24,%esp
  801769:	5b                   	pop    %ebx
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	57                   	push   %edi
  801770:	56                   	push   %esi
  801771:	53                   	push   %ebx
  801772:	83 ec 1c             	sub    $0x1c,%esp
  801775:	8b 7d 08             	mov    0x8(%ebp),%edi
  801778:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80177b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801780:	eb 23                	jmp    8017a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801782:	89 f0                	mov    %esi,%eax
  801784:	29 d8                	sub    %ebx,%eax
  801786:	89 44 24 08          	mov    %eax,0x8(%esp)
  80178a:	89 d8                	mov    %ebx,%eax
  80178c:	03 45 0c             	add    0xc(%ebp),%eax
  80178f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801793:	89 3c 24             	mov    %edi,(%esp)
  801796:	e8 3f ff ff ff       	call   8016da <read>
		if (m < 0)
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 10                	js     8017af <readn+0x43>
			return m;
		if (m == 0)
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	74 0a                	je     8017ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017a3:	01 c3                	add    %eax,%ebx
  8017a5:	39 f3                	cmp    %esi,%ebx
  8017a7:	72 d9                	jb     801782 <readn+0x16>
  8017a9:	89 d8                	mov    %ebx,%eax
  8017ab:	eb 02                	jmp    8017af <readn+0x43>
  8017ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017af:	83 c4 1c             	add    $0x1c,%esp
  8017b2:	5b                   	pop    %ebx
  8017b3:	5e                   	pop    %esi
  8017b4:	5f                   	pop    %edi
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 24             	sub    $0x24,%esp
  8017be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c8:	89 1c 24             	mov    %ebx,(%esp)
  8017cb:	e8 76 fc ff ff       	call   801446 <fd_lookup>
  8017d0:	89 c2                	mov    %eax,%edx
  8017d2:	85 d2                	test   %edx,%edx
  8017d4:	78 68                	js     80183e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e0:	8b 00                	mov    (%eax),%eax
  8017e2:	89 04 24             	mov    %eax,(%esp)
  8017e5:	e8 b2 fc ff ff       	call   80149c <dev_lookup>
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 50                	js     80183e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017f5:	75 23                	jne    80181a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017f7:	a1 90 77 80 00       	mov    0x807790,%eax
  8017fc:	8b 40 48             	mov    0x48(%eax),%eax
  8017ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801803:	89 44 24 04          	mov    %eax,0x4(%esp)
  801807:	c7 04 24 b5 34 80 00 	movl   $0x8034b5,(%esp)
  80180e:	e8 51 ed ff ff       	call   800564 <cprintf>
		return -E_INVAL;
  801813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801818:	eb 24                	jmp    80183e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80181a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181d:	8b 52 0c             	mov    0xc(%edx),%edx
  801820:	85 d2                	test   %edx,%edx
  801822:	74 15                	je     801839 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801824:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801827:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80182b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80182e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801832:	89 04 24             	mov    %eax,(%esp)
  801835:	ff d2                	call   *%edx
  801837:	eb 05                	jmp    80183e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801839:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80183e:	83 c4 24             	add    $0x24,%esp
  801841:	5b                   	pop    %ebx
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    

00801844 <seek>:

int
seek(int fdnum, off_t offset)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80184a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80184d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	89 04 24             	mov    %eax,(%esp)
  801857:	e8 ea fb ff ff       	call   801446 <fd_lookup>
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 0e                	js     80186e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	53                   	push   %ebx
  801874:	83 ec 24             	sub    $0x24,%esp
  801877:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801881:	89 1c 24             	mov    %ebx,(%esp)
  801884:	e8 bd fb ff ff       	call   801446 <fd_lookup>
  801889:	89 c2                	mov    %eax,%edx
  80188b:	85 d2                	test   %edx,%edx
  80188d:	78 61                	js     8018f0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801892:	89 44 24 04          	mov    %eax,0x4(%esp)
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801899:	8b 00                	mov    (%eax),%eax
  80189b:	89 04 24             	mov    %eax,(%esp)
  80189e:	e8 f9 fb ff ff       	call   80149c <dev_lookup>
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 49                	js     8018f0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018ae:	75 23                	jne    8018d3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018b0:	a1 90 77 80 00       	mov    0x807790,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b5:	8b 40 48             	mov    0x48(%eax),%eax
  8018b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c0:	c7 04 24 78 34 80 00 	movl   $0x803478,(%esp)
  8018c7:	e8 98 ec ff ff       	call   800564 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d1:	eb 1d                	jmp    8018f0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d6:	8b 52 18             	mov    0x18(%edx),%edx
  8018d9:	85 d2                	test   %edx,%edx
  8018db:	74 0e                	je     8018eb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018e4:	89 04 24             	mov    %eax,(%esp)
  8018e7:	ff d2                	call   *%edx
  8018e9:	eb 05                	jmp    8018f0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018f0:	83 c4 24             	add    $0x24,%esp
  8018f3:	5b                   	pop    %ebx
  8018f4:	5d                   	pop    %ebp
  8018f5:	c3                   	ret    

008018f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	53                   	push   %ebx
  8018fa:	83 ec 24             	sub    $0x24,%esp
  8018fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801900:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801903:	89 44 24 04          	mov    %eax,0x4(%esp)
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	89 04 24             	mov    %eax,(%esp)
  80190d:	e8 34 fb ff ff       	call   801446 <fd_lookup>
  801912:	89 c2                	mov    %eax,%edx
  801914:	85 d2                	test   %edx,%edx
  801916:	78 52                	js     80196a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801918:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801922:	8b 00                	mov    (%eax),%eax
  801924:	89 04 24             	mov    %eax,(%esp)
  801927:	e8 70 fb ff ff       	call   80149c <dev_lookup>
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 3a                	js     80196a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801933:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801937:	74 2c                	je     801965 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801939:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80193c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801943:	00 00 00 
	stat->st_isdir = 0;
  801946:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80194d:	00 00 00 
	stat->st_dev = dev;
  801950:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801956:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80195a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80195d:	89 14 24             	mov    %edx,(%esp)
  801960:	ff 50 14             	call   *0x14(%eax)
  801963:	eb 05                	jmp    80196a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801965:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80196a:	83 c4 24             	add    $0x24,%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    

00801970 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
  801975:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801978:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80197f:	00 
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	89 04 24             	mov    %eax,(%esp)
  801986:	e8 1b 02 00 00       	call   801ba6 <open>
  80198b:	89 c3                	mov    %eax,%ebx
  80198d:	85 db                	test   %ebx,%ebx
  80198f:	78 1b                	js     8019ac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	89 1c 24             	mov    %ebx,(%esp)
  80199b:	e8 56 ff ff ff       	call   8018f6 <fstat>
  8019a0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019a2:	89 1c 24             	mov    %ebx,(%esp)
  8019a5:	e8 cd fb ff ff       	call   801577 <close>
	return r;
  8019aa:	89 f0                	mov    %esi,%eax
}
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5d                   	pop    %ebp
  8019b2:	c3                   	ret    

008019b3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 10             	sub    $0x10,%esp
  8019bb:	89 c6                	mov    %eax,%esi
  8019bd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019bf:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8019c6:	75 11                	jne    8019d9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019cf:	e8 8b 12 00 00       	call   802c5f <ipc_find_env>
  8019d4:	a3 00 60 80 00       	mov    %eax,0x806000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019d9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019e0:	00 
  8019e1:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8019e8:	00 
  8019e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019ed:	a1 00 60 80 00       	mov    0x806000,%eax
  8019f2:	89 04 24             	mov    %eax,(%esp)
  8019f5:	e8 fa 11 00 00       	call   802bf4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a01:	00 
  801a02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a0d:	e8 8e 11 00 00       	call   802ba0 <ipc_recv>
}
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    

00801a19 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	8b 40 0c             	mov    0xc(%eax),%eax
  801a25:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  801a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2d:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
  801a37:	b8 02 00 00 00       	mov    $0x2,%eax
  801a3c:	e8 72 ff ff ff       	call   8019b3 <fsipc>
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4f:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  801a54:	ba 00 00 00 00       	mov    $0x0,%edx
  801a59:	b8 06 00 00 00       	mov    $0x6,%eax
  801a5e:	e8 50 ff ff ff       	call   8019b3 <fsipc>
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	53                   	push   %ebx
  801a69:	83 ec 14             	sub    $0x14,%esp
  801a6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8b 40 0c             	mov    0xc(%eax),%eax
  801a75:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a84:	e8 2a ff ff ff       	call   8019b3 <fsipc>
  801a89:	89 c2                	mov    %eax,%edx
  801a8b:	85 d2                	test   %edx,%edx
  801a8d:	78 2b                	js     801aba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a8f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801a96:	00 
  801a97:	89 1c 24             	mov    %ebx,(%esp)
  801a9a:	e8 e8 f0 ff ff       	call   800b87 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a9f:	a1 80 80 80 00       	mov    0x808080,%eax
  801aa4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aaa:	a1 84 80 80 00       	mov    0x808084,%eax
  801aaf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aba:	83 c4 14             	add    $0x14,%esp
  801abd:	5b                   	pop    %ebx
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    

00801ac0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 18             	sub    $0x18,%esp
  801ac6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  801acc:	8b 52 0c             	mov    0xc(%edx),%edx
  801acf:	89 15 00 80 80 00    	mov    %edx,0x808000
	fsipcbuf.write.req_n = n;
  801ad5:	a3 04 80 80 00       	mov    %eax,0x808004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ada:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae5:	c7 04 24 08 80 80 00 	movl   $0x808008,(%esp)
  801aec:	e8 9b f2 ff ff       	call   800d8c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801af1:	ba 00 00 00 00       	mov    $0x0,%edx
  801af6:	b8 04 00 00 00       	mov    $0x4,%eax
  801afb:	e8 b3 fe ff ff       	call   8019b3 <fsipc>
		return r;
	}

	return r;
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	56                   	push   %esi
  801b06:	53                   	push   %ebx
  801b07:	83 ec 10             	sub    $0x10,%esp
  801b0a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	8b 40 0c             	mov    0xc(%eax),%eax
  801b13:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801b18:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b23:	b8 03 00 00 00       	mov    $0x3,%eax
  801b28:	e8 86 fe ff ff       	call   8019b3 <fsipc>
  801b2d:	89 c3                	mov    %eax,%ebx
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	78 6a                	js     801b9d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b33:	39 c6                	cmp    %eax,%esi
  801b35:	73 24                	jae    801b5b <devfile_read+0x59>
  801b37:	c7 44 24 0c e8 34 80 	movl   $0x8034e8,0xc(%esp)
  801b3e:	00 
  801b3f:	c7 44 24 08 ef 34 80 	movl   $0x8034ef,0x8(%esp)
  801b46:	00 
  801b47:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b4e:	00 
  801b4f:	c7 04 24 04 35 80 00 	movl   $0x803504,(%esp)
  801b56:	e8 10 e9 ff ff       	call   80046b <_panic>
	assert(r <= PGSIZE);
  801b5b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b60:	7e 24                	jle    801b86 <devfile_read+0x84>
  801b62:	c7 44 24 0c 0f 35 80 	movl   $0x80350f,0xc(%esp)
  801b69:	00 
  801b6a:	c7 44 24 08 ef 34 80 	movl   $0x8034ef,0x8(%esp)
  801b71:	00 
  801b72:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b79:	00 
  801b7a:	c7 04 24 04 35 80 00 	movl   $0x803504,(%esp)
  801b81:	e8 e5 e8 ff ff       	call   80046b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b86:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b8a:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801b91:	00 
  801b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b95:	89 04 24             	mov    %eax,(%esp)
  801b98:	e8 87 f1 ff ff       	call   800d24 <memmove>
	return r;
}
  801b9d:	89 d8                	mov    %ebx,%eax
  801b9f:	83 c4 10             	add    $0x10,%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    

00801ba6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	53                   	push   %ebx
  801baa:	83 ec 24             	sub    $0x24,%esp
  801bad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bb0:	89 1c 24             	mov    %ebx,(%esp)
  801bb3:	e8 98 ef ff ff       	call   800b50 <strlen>
  801bb8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bbd:	7f 60                	jg     801c1f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc2:	89 04 24             	mov    %eax,(%esp)
  801bc5:	e8 2d f8 ff ff       	call   8013f7 <fd_alloc>
  801bca:	89 c2                	mov    %eax,%edx
  801bcc:	85 d2                	test   %edx,%edx
  801bce:	78 54                	js     801c24 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bd0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bd4:	c7 04 24 00 80 80 00 	movl   $0x808000,(%esp)
  801bdb:	e8 a7 ef ff ff       	call   800b87 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be3:	a3 00 84 80 00       	mov    %eax,0x808400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801beb:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf0:	e8 be fd ff ff       	call   8019b3 <fsipc>
  801bf5:	89 c3                	mov    %eax,%ebx
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	79 17                	jns    801c12 <open+0x6c>
		fd_close(fd, 0);
  801bfb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c02:	00 
  801c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c06:	89 04 24             	mov    %eax,(%esp)
  801c09:	e8 e8 f8 ff ff       	call   8014f6 <fd_close>
		return r;
  801c0e:	89 d8                	mov    %ebx,%eax
  801c10:	eb 12                	jmp    801c24 <open+0x7e>
	}

	return fd2num(fd);
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	89 04 24             	mov    %eax,(%esp)
  801c18:	e8 b3 f7 ff ff       	call   8013d0 <fd2num>
  801c1d:	eb 05                	jmp    801c24 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c1f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c24:	83 c4 24             	add    $0x24,%esp
  801c27:	5b                   	pop    %ebx
  801c28:	5d                   	pop    %ebp
  801c29:	c3                   	ret    

00801c2a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c30:	ba 00 00 00 00       	mov    $0x0,%edx
  801c35:	b8 08 00 00 00       	mov    $0x8,%eax
  801c3a:	e8 74 fd ff ff       	call   8019b3 <fsipc>
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    
  801c41:	66 90                	xchg   %ax,%ax
  801c43:	66 90                	xchg   %ax,%ax
  801c45:	66 90                	xchg   %ax,%ax
  801c47:	66 90                	xchg   %ax,%ax
  801c49:	66 90                	xchg   %ax,%ax
  801c4b:	66 90                	xchg   %ax,%ax
  801c4d:	66 90                	xchg   %ax,%ax
  801c4f:	90                   	nop

00801c50 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	57                   	push   %edi
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801c5c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c63:	00 
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	89 04 24             	mov    %eax,(%esp)
  801c6a:	e8 37 ff ff ff       	call   801ba6 <open>
  801c6f:	89 c1                	mov    %eax,%ecx
  801c71:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801c77:	85 c0                	test   %eax,%eax
  801c79:	0f 88 fd 04 00 00    	js     80217c <spawn+0x52c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801c7f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801c86:	00 
  801c87:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c91:	89 0c 24             	mov    %ecx,(%esp)
  801c94:	e8 d3 fa ff ff       	call   80176c <readn>
  801c99:	3d 00 02 00 00       	cmp    $0x200,%eax
  801c9e:	75 0c                	jne    801cac <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801ca0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ca7:	45 4c 46 
  801caa:	74 36                	je     801ce2 <spawn+0x92>
		close(fd);
  801cac:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801cb2:	89 04 24             	mov    %eax,(%esp)
  801cb5:	e8 bd f8 ff ff       	call   801577 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801cba:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801cc1:	46 
  801cc2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ccc:	c7 04 24 1b 35 80 00 	movl   $0x80351b,(%esp)
  801cd3:	e8 8c e8 ff ff       	call   800564 <cprintf>
		return -E_NOT_EXEC;
  801cd8:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801cdd:	e9 4a 05 00 00       	jmp    80222c <spawn+0x5dc>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ce2:	b8 07 00 00 00       	mov    $0x7,%eax
  801ce7:	cd 30                	int    $0x30
  801ce9:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801cef:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	0f 88 8a 04 00 00    	js     802187 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801cfd:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d02:	89 c2                	mov    %eax,%edx
  801d04:	c1 e2 07             	shl    $0x7,%edx
  801d07:	8d b4 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%esi
  801d0e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801d14:	b9 11 00 00 00       	mov    $0x11,%ecx
  801d19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801d1b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801d21:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d27:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801d2c:	be 00 00 00 00       	mov    $0x0,%esi
  801d31:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d34:	eb 0f                	jmp    801d45 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801d36:	89 04 24             	mov    %eax,(%esp)
  801d39:	e8 12 ee ff ff       	call   800b50 <strlen>
  801d3e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d42:	83 c3 01             	add    $0x1,%ebx
  801d45:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801d4c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	75 e3                	jne    801d36 <spawn+0xe6>
  801d53:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d59:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801d5f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801d64:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d66:	89 fa                	mov    %edi,%edx
  801d68:	83 e2 fc             	and    $0xfffffffc,%edx
  801d6b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801d72:	29 c2                	sub    %eax,%edx
  801d74:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801d7a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801d7d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801d82:	0f 86 15 04 00 00    	jbe    80219d <spawn+0x54d>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d88:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d8f:	00 
  801d90:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d97:	00 
  801d98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d9f:	e8 ff f1 ff ff       	call   800fa3 <sys_page_alloc>
  801da4:	85 c0                	test   %eax,%eax
  801da6:	0f 88 80 04 00 00    	js     80222c <spawn+0x5dc>
  801dac:	be 00 00 00 00       	mov    $0x0,%esi
  801db1:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801db7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801dba:	eb 30                	jmp    801dec <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801dbc:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801dc2:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801dc8:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801dcb:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801dce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd2:	89 3c 24             	mov    %edi,(%esp)
  801dd5:	e8 ad ed ff ff       	call   800b87 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801dda:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801ddd:	89 04 24             	mov    %eax,(%esp)
  801de0:	e8 6b ed ff ff       	call   800b50 <strlen>
  801de5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801de9:	83 c6 01             	add    $0x1,%esi
  801dec:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801df2:	7f c8                	jg     801dbc <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801df4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801dfa:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801e00:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e07:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801e0d:	74 24                	je     801e33 <spawn+0x1e3>
  801e0f:	c7 44 24 0c a8 35 80 	movl   $0x8035a8,0xc(%esp)
  801e16:	00 
  801e17:	c7 44 24 08 ef 34 80 	movl   $0x8034ef,0x8(%esp)
  801e1e:	00 
  801e1f:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801e26:	00 
  801e27:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  801e2e:	e8 38 e6 ff ff       	call   80046b <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801e33:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801e39:	89 c8                	mov    %ecx,%eax
  801e3b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801e40:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801e43:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801e49:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801e4c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801e52:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e58:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801e5f:	00 
  801e60:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801e67:	ee 
  801e68:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e72:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e79:	00 
  801e7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e81:	e8 71 f1 ff ff       	call   800ff7 <sys_page_map>
  801e86:	89 c3                	mov    %eax,%ebx
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	0f 88 86 03 00 00    	js     802216 <spawn+0x5c6>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801e90:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e97:	00 
  801e98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e9f:	e8 a6 f1 ff ff       	call   80104a <sys_page_unmap>
  801ea4:	89 c3                	mov    %eax,%ebx
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	0f 88 68 03 00 00    	js     802216 <spawn+0x5c6>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801eae:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801eb4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801ebb:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ec1:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801ec8:	00 00 00 
  801ecb:	e9 b6 01 00 00       	jmp    802086 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801ed0:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801ed6:	83 38 01             	cmpl   $0x1,(%eax)
  801ed9:	0f 85 99 01 00 00    	jne    802078 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801edf:	89 c1                	mov    %eax,%ecx
  801ee1:	8b 40 18             	mov    0x18(%eax),%eax
  801ee4:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801ee7:	83 f8 01             	cmp    $0x1,%eax
  801eea:	19 c0                	sbb    %eax,%eax
  801eec:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801ef2:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801ef9:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801f00:	89 c8                	mov    %ecx,%eax
  801f02:	8b 49 04             	mov    0x4(%ecx),%ecx
  801f05:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801f0b:	8b 48 10             	mov    0x10(%eax),%ecx
  801f0e:	89 8d 94 fd ff ff    	mov    %ecx,-0x26c(%ebp)
  801f14:	8b 50 14             	mov    0x14(%eax),%edx
  801f17:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  801f1d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801f20:	89 f0                	mov    %esi,%eax
  801f22:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f27:	74 14                	je     801f3d <spawn+0x2ed>
		va -= i;
  801f29:	29 c6                	sub    %eax,%esi
		memsz += i;
  801f2b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801f31:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801f37:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f42:	e9 23 01 00 00       	jmp    80206a <spawn+0x41a>
		if (i >= filesz) {
  801f47:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801f4d:	77 2b                	ja     801f7a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801f4f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f55:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f59:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f5d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f63:	89 04 24             	mov    %eax,(%esp)
  801f66:	e8 38 f0 ff ff       	call   800fa3 <sys_page_alloc>
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	0f 89 eb 00 00 00    	jns    80205e <spawn+0x40e>
  801f73:	89 c3                	mov    %eax,%ebx
  801f75:	e9 37 02 00 00       	jmp    8021b1 <spawn+0x561>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f7a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f81:	00 
  801f82:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f89:	00 
  801f8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f91:	e8 0d f0 ff ff       	call   800fa3 <sys_page_alloc>
  801f96:	85 c0                	test   %eax,%eax
  801f98:	0f 88 09 02 00 00    	js     8021a7 <spawn+0x557>
  801f9e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801fa4:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801faa:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801fb0:	89 04 24             	mov    %eax,(%esp)
  801fb3:	e8 8c f8 ff ff       	call   801844 <seek>
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	0f 88 eb 01 00 00    	js     8021ab <spawn+0x55b>
  801fc0:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801fc6:	29 f9                	sub    %edi,%ecx
  801fc8:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801fca:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801fd0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fd5:	0f 47 c2             	cmova  %edx,%eax
  801fd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fdc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fe3:	00 
  801fe4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801fea:	89 04 24             	mov    %eax,(%esp)
  801fed:	e8 7a f7 ff ff       	call   80176c <readn>
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	0f 88 b5 01 00 00    	js     8021af <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801ffa:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802000:	89 44 24 10          	mov    %eax,0x10(%esp)
  802004:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802008:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80200e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802012:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802019:	00 
  80201a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802021:	e8 d1 ef ff ff       	call   800ff7 <sys_page_map>
  802026:	85 c0                	test   %eax,%eax
  802028:	79 20                	jns    80204a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  80202a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80202e:	c7 44 24 08 41 35 80 	movl   $0x803541,0x8(%esp)
  802035:	00 
  802036:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  80203d:	00 
  80203e:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  802045:	e8 21 e4 ff ff       	call   80046b <_panic>
			sys_page_unmap(0, UTEMP);
  80204a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802051:	00 
  802052:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802059:	e8 ec ef ff ff       	call   80104a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80205e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802064:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80206a:	89 df                	mov    %ebx,%edi
  80206c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802072:	0f 87 cf fe ff ff    	ja     801f47 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802078:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  80207f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802086:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80208d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  802093:	0f 8c 37 fe ff ff    	jl     801ed0 <spawn+0x280>
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	
	close(fd);
  802099:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80209f:	89 04 24             	mov    %eax,(%esp)
  8020a2:	e8 d0 f4 ff ff       	call   801577 <close>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  8020a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020ac:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
		if(((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_SHARE))
  8020b2:	89 d8                	mov    %ebx,%eax
  8020b4:	c1 e8 16             	shr    $0x16,%eax
  8020b7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020be:	a8 01                	test   $0x1,%al
  8020c0:	74 4d                	je     80210f <spawn+0x4bf>
  8020c2:	89 d8                	mov    %ebx,%eax
  8020c4:	c1 e8 0c             	shr    $0xc,%eax
  8020c7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020ce:	f6 c2 01             	test   $0x1,%dl
  8020d1:	74 3c                	je     80210f <spawn+0x4bf>
  8020d3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020da:	f6 c6 04             	test   $0x4,%dh
  8020dd:	74 30                	je     80210f <spawn+0x4bf>
		&& ((r = sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)]&PTE_SYSCALL)) < 0)){
  8020df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020e6:	25 07 0e 00 00       	and    $0xe07,%eax
  8020eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8020ef:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802102:	e8 f0 ee ff ff       	call   800ff7 <sys_page_map>
  802107:	85 c0                	test   %eax,%eax
  802109:	0f 88 e7 00 00 00    	js     8021f6 <spawn+0x5a6>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  80210f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802115:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80211b:	75 95                	jne    8020b2 <spawn+0x462>
  80211d:	e9 af 00 00 00       	jmp    8021d1 <spawn+0x581>
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802126:	c7 44 24 08 5e 35 80 	movl   $0x80355e,0x8(%esp)
  80212d:	00 
  80212e:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  802135:	00 
  802136:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  80213d:	e8 29 e3 ff ff       	call   80046b <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802142:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802149:	00 
  80214a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802150:	89 04 24             	mov    %eax,(%esp)
  802153:	e8 45 ef ff ff       	call   80109d <sys_env_set_status>
  802158:	85 c0                	test   %eax,%eax
  80215a:	79 36                	jns    802192 <spawn+0x542>
		panic("sys_env_set_status: %e", r);
  80215c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802160:	c7 44 24 08 78 35 80 	movl   $0x803578,0x8(%esp)
  802167:	00 
  802168:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  80216f:	00 
  802170:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  802177:	e8 ef e2 ff ff       	call   80046b <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  80217c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802182:	e9 a5 00 00 00       	jmp    80222c <spawn+0x5dc>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802187:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80218d:	e9 9a 00 00 00       	jmp    80222c <spawn+0x5dc>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  802192:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802198:	e9 8f 00 00 00       	jmp    80222c <spawn+0x5dc>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  80219d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8021a2:	e9 85 00 00 00       	jmp    80222c <spawn+0x5dc>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8021a7:	89 c3                	mov    %eax,%ebx
  8021a9:	eb 06                	jmp    8021b1 <spawn+0x561>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8021ab:	89 c3                	mov    %eax,%ebx
  8021ad:	eb 02                	jmp    8021b1 <spawn+0x561>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8021af:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8021b1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021b7:	89 04 24             	mov    %eax,(%esp)
  8021ba:	e8 54 ed ff ff       	call   800f13 <sys_env_destroy>
	close(fd);
  8021bf:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8021c5:	89 04 24             	mov    %eax,(%esp)
  8021c8:	e8 aa f3 ff ff       	call   801577 <close>
	return r;
  8021cd:	89 d8                	mov    %ebx,%eax
  8021cf:	eb 5b                	jmp    80222c <spawn+0x5dc>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8021d1:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8021d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021db:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021e1:	89 04 24             	mov    %eax,(%esp)
  8021e4:	e8 07 ef ff ff       	call   8010f0 <sys_env_set_trapframe>
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	0f 89 51 ff ff ff    	jns    802142 <spawn+0x4f2>
  8021f1:	e9 2c ff ff ff       	jmp    802122 <spawn+0x4d2>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  8021f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021fa:	c7 44 24 08 8f 35 80 	movl   $0x80358f,0x8(%esp)
  802201:	00 
  802202:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  802209:	00 
  80220a:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  802211:	e8 55 e2 ff ff       	call   80046b <_panic>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802216:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80221d:	00 
  80221e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802225:	e8 20 ee ff ff       	call   80104a <sys_page_unmap>
  80222a:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80222c:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802232:	5b                   	pop    %ebx
  802233:	5e                   	pop    %esi
  802234:	5f                   	pop    %edi
  802235:	5d                   	pop    %ebp
  802236:	c3                   	ret    

00802237 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	56                   	push   %esi
  80223b:	53                   	push   %ebx
  80223c:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80223f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802242:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802247:	eb 03                	jmp    80224c <spawnl+0x15>
		argc++;
  802249:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80224c:	83 c0 04             	add    $0x4,%eax
  80224f:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802253:	75 f4                	jne    802249 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802255:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  80225c:	83 e0 f0             	and    $0xfffffff0,%eax
  80225f:	29 c4                	sub    %eax,%esp
  802261:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802265:	c1 e8 02             	shr    $0x2,%eax
  802268:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80226f:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802271:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802274:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  80227b:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  802282:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	eb 0a                	jmp    802294 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  80228a:	83 c0 01             	add    $0x1,%eax
  80228d:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802291:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802294:	39 d0                	cmp    %edx,%eax
  802296:	75 f2                	jne    80228a <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802298:	89 74 24 04          	mov    %esi,0x4(%esp)
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	89 04 24             	mov    %eax,(%esp)
  8022a2:	e8 a9 f9 ff ff       	call   801c50 <spawn>
}
  8022a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022aa:	5b                   	pop    %ebx
  8022ab:	5e                   	pop    %esi
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8022b6:	c7 44 24 04 ce 35 80 	movl   $0x8035ce,0x4(%esp)
  8022bd:	00 
  8022be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c1:	89 04 24             	mov    %eax,(%esp)
  8022c4:	e8 be e8 ff ff       	call   800b87 <strcpy>
	return 0;
}
  8022c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 14             	sub    $0x14,%esp
  8022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8022da:	89 1c 24             	mov    %ebx,(%esp)
  8022dd:	e8 bc 09 00 00       	call   802c9e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8022e2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8022e7:	83 f8 01             	cmp    $0x1,%eax
  8022ea:	75 0d                	jne    8022f9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8022ec:	8b 43 0c             	mov    0xc(%ebx),%eax
  8022ef:	89 04 24             	mov    %eax,(%esp)
  8022f2:	e8 29 03 00 00       	call   802620 <nsipc_close>
  8022f7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8022f9:	89 d0                	mov    %edx,%eax
  8022fb:	83 c4 14             	add    $0x14,%esp
  8022fe:	5b                   	pop    %ebx
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    

00802301 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802307:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80230e:	00 
  80230f:	8b 45 10             	mov    0x10(%ebp),%eax
  802312:	89 44 24 08          	mov    %eax,0x8(%esp)
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	8b 40 0c             	mov    0xc(%eax),%eax
  802323:	89 04 24             	mov    %eax,(%esp)
  802326:	e8 f0 03 00 00       	call   80271b <nsipc_send>
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802333:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80233a:	00 
  80233b:	8b 45 10             	mov    0x10(%ebp),%eax
  80233e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802342:	8b 45 0c             	mov    0xc(%ebp),%eax
  802345:	89 44 24 04          	mov    %eax,0x4(%esp)
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8b 40 0c             	mov    0xc(%eax),%eax
  80234f:	89 04 24             	mov    %eax,(%esp)
  802352:	e8 44 03 00 00       	call   80269b <nsipc_recv>
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80235f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802362:	89 54 24 04          	mov    %edx,0x4(%esp)
  802366:	89 04 24             	mov    %eax,(%esp)
  802369:	e8 d8 f0 ff ff       	call   801446 <fd_lookup>
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 17                	js     802389 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  80237b:	39 08                	cmp    %ecx,(%eax)
  80237d:	75 05                	jne    802384 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80237f:	8b 40 0c             	mov    0xc(%eax),%eax
  802382:	eb 05                	jmp    802389 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802384:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	83 ec 20             	sub    $0x20,%esp
  802393:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802395:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802398:	89 04 24             	mov    %eax,(%esp)
  80239b:	e8 57 f0 ff ff       	call   8013f7 <fd_alloc>
  8023a0:	89 c3                	mov    %eax,%ebx
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	78 21                	js     8023c7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8023a6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023ad:	00 
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023bc:	e8 e2 eb ff ff       	call   800fa3 <sys_page_alloc>
  8023c1:	89 c3                	mov    %eax,%ebx
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	79 0c                	jns    8023d3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8023c7:	89 34 24             	mov    %esi,(%esp)
  8023ca:	e8 51 02 00 00       	call   802620 <nsipc_close>
		return r;
  8023cf:	89 d8                	mov    %ebx,%eax
  8023d1:	eb 20                	jmp    8023f3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8023d3:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8023de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8023e8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8023eb:	89 14 24             	mov    %edx,(%esp)
  8023ee:	e8 dd ef ff ff       	call   8013d0 <fd2num>
}
  8023f3:	83 c4 20             	add    $0x20,%esp
  8023f6:	5b                   	pop    %ebx
  8023f7:	5e                   	pop    %esi
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    

008023fa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	e8 51 ff ff ff       	call   802359 <fd2sockid>
		return r;
  802408:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80240a:	85 c0                	test   %eax,%eax
  80240c:	78 23                	js     802431 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80240e:	8b 55 10             	mov    0x10(%ebp),%edx
  802411:	89 54 24 08          	mov    %edx,0x8(%esp)
  802415:	8b 55 0c             	mov    0xc(%ebp),%edx
  802418:	89 54 24 04          	mov    %edx,0x4(%esp)
  80241c:	89 04 24             	mov    %eax,(%esp)
  80241f:	e8 45 01 00 00       	call   802569 <nsipc_accept>
		return r;
  802424:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802426:	85 c0                	test   %eax,%eax
  802428:	78 07                	js     802431 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80242a:	e8 5c ff ff ff       	call   80238b <alloc_sockfd>
  80242f:	89 c1                	mov    %eax,%ecx
}
  802431:	89 c8                	mov    %ecx,%eax
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	e8 16 ff ff ff       	call   802359 <fd2sockid>
  802443:	89 c2                	mov    %eax,%edx
  802445:	85 d2                	test   %edx,%edx
  802447:	78 16                	js     80245f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802449:	8b 45 10             	mov    0x10(%ebp),%eax
  80244c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802450:	8b 45 0c             	mov    0xc(%ebp),%eax
  802453:	89 44 24 04          	mov    %eax,0x4(%esp)
  802457:	89 14 24             	mov    %edx,(%esp)
  80245a:	e8 60 01 00 00       	call   8025bf <nsipc_bind>
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <shutdown>:

int
shutdown(int s, int how)
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	e8 ea fe ff ff       	call   802359 <fd2sockid>
  80246f:	89 c2                	mov    %eax,%edx
  802471:	85 d2                	test   %edx,%edx
  802473:	78 0f                	js     802484 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802475:	8b 45 0c             	mov    0xc(%ebp),%eax
  802478:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247c:	89 14 24             	mov    %edx,(%esp)
  80247f:	e8 7a 01 00 00       	call   8025fe <nsipc_shutdown>
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	e8 c5 fe ff ff       	call   802359 <fd2sockid>
  802494:	89 c2                	mov    %eax,%edx
  802496:	85 d2                	test   %edx,%edx
  802498:	78 16                	js     8024b0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80249a:	8b 45 10             	mov    0x10(%ebp),%eax
  80249d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a8:	89 14 24             	mov    %edx,(%esp)
  8024ab:	e8 8a 01 00 00       	call   80263a <nsipc_connect>
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <listen>:

int
listen(int s, int backlog)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	e8 99 fe ff ff       	call   802359 <fd2sockid>
  8024c0:	89 c2                	mov    %eax,%edx
  8024c2:	85 d2                	test   %edx,%edx
  8024c4:	78 0f                	js     8024d5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8024c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cd:	89 14 24             	mov    %edx,(%esp)
  8024d0:	e8 a4 01 00 00       	call   802679 <nsipc_listen>
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8024dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	89 04 24             	mov    %eax,(%esp)
  8024f1:	e8 98 02 00 00       	call   80278e <nsipc_socket>
  8024f6:	89 c2                	mov    %eax,%edx
  8024f8:	85 d2                	test   %edx,%edx
  8024fa:	78 05                	js     802501 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8024fc:	e8 8a fe ff ff       	call   80238b <alloc_sockfd>
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	53                   	push   %ebx
  802507:	83 ec 14             	sub    $0x14,%esp
  80250a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80250c:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802513:	75 11                	jne    802526 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802515:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80251c:	e8 3e 07 00 00       	call   802c5f <ipc_find_env>
  802521:	a3 04 60 80 00       	mov    %eax,0x806004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802526:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80252d:	00 
  80252e:	c7 44 24 08 00 90 80 	movl   $0x809000,0x8(%esp)
  802535:	00 
  802536:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80253a:	a1 04 60 80 00       	mov    0x806004,%eax
  80253f:	89 04 24             	mov    %eax,(%esp)
  802542:	e8 ad 06 00 00       	call   802bf4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802547:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80254e:	00 
  80254f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802556:	00 
  802557:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80255e:	e8 3d 06 00 00       	call   802ba0 <ipc_recv>
}
  802563:	83 c4 14             	add    $0x14,%esp
  802566:	5b                   	pop    %ebx
  802567:	5d                   	pop    %ebp
  802568:	c3                   	ret    

00802569 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	56                   	push   %esi
  80256d:	53                   	push   %ebx
  80256e:	83 ec 10             	sub    $0x10,%esp
  802571:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80257c:	8b 06                	mov    (%esi),%eax
  80257e:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802583:	b8 01 00 00 00       	mov    $0x1,%eax
  802588:	e8 76 ff ff ff       	call   802503 <nsipc>
  80258d:	89 c3                	mov    %eax,%ebx
  80258f:	85 c0                	test   %eax,%eax
  802591:	78 23                	js     8025b6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802593:	a1 10 90 80 00       	mov    0x809010,%eax
  802598:	89 44 24 08          	mov    %eax,0x8(%esp)
  80259c:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  8025a3:	00 
  8025a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a7:	89 04 24             	mov    %eax,(%esp)
  8025aa:	e8 75 e7 ff ff       	call   800d24 <memmove>
		*addrlen = ret->ret_addrlen;
  8025af:	a1 10 90 80 00       	mov    0x809010,%eax
  8025b4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8025b6:	89 d8                	mov    %ebx,%eax
  8025b8:	83 c4 10             	add    $0x10,%esp
  8025bb:	5b                   	pop    %ebx
  8025bc:	5e                   	pop    %esi
  8025bd:	5d                   	pop    %ebp
  8025be:	c3                   	ret    

008025bf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	53                   	push   %ebx
  8025c3:	83 ec 14             	sub    $0x14,%esp
  8025c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025d1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025dc:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  8025e3:	e8 3c e7 ff ff       	call   800d24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8025e8:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  8025ee:	b8 02 00 00 00       	mov    $0x2,%eax
  8025f3:	e8 0b ff ff ff       	call   802503 <nsipc>
}
  8025f8:	83 c4 14             	add    $0x14,%esp
  8025fb:	5b                   	pop    %ebx
  8025fc:	5d                   	pop    %ebp
  8025fd:	c3                   	ret    

008025fe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  80260c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260f:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  802614:	b8 03 00 00 00       	mov    $0x3,%eax
  802619:	e8 e5 fe ff ff       	call   802503 <nsipc>
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <nsipc_close>:

int
nsipc_close(int s)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  80262e:	b8 04 00 00 00       	mov    $0x4,%eax
  802633:	e8 cb fe ff ff       	call   802503 <nsipc>
}
  802638:	c9                   	leave  
  802639:	c3                   	ret    

0080263a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
  80263d:	53                   	push   %ebx
  80263e:	83 ec 14             	sub    $0x14,%esp
  802641:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80264c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802650:	8b 45 0c             	mov    0xc(%ebp),%eax
  802653:	89 44 24 04          	mov    %eax,0x4(%esp)
  802657:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  80265e:	e8 c1 e6 ff ff       	call   800d24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802663:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  802669:	b8 05 00 00 00       	mov    $0x5,%eax
  80266e:	e8 90 fe ff ff       	call   802503 <nsipc>
}
  802673:	83 c4 14             	add    $0x14,%esp
  802676:	5b                   	pop    %ebx
  802677:	5d                   	pop    %ebp
  802678:	c3                   	ret    

00802679 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268a:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  80268f:	b8 06 00 00 00       	mov    $0x6,%eax
  802694:	e8 6a fe ff ff       	call   802503 <nsipc>
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	56                   	push   %esi
  80269f:	53                   	push   %ebx
  8026a0:	83 ec 10             	sub    $0x10,%esp
  8026a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  8026ae:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  8026b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8026b7:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8026bc:	b8 07 00 00 00       	mov    $0x7,%eax
  8026c1:	e8 3d fe ff ff       	call   802503 <nsipc>
  8026c6:	89 c3                	mov    %eax,%ebx
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	78 46                	js     802712 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8026cc:	39 f0                	cmp    %esi,%eax
  8026ce:	7f 07                	jg     8026d7 <nsipc_recv+0x3c>
  8026d0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8026d5:	7e 24                	jle    8026fb <nsipc_recv+0x60>
  8026d7:	c7 44 24 0c da 35 80 	movl   $0x8035da,0xc(%esp)
  8026de:	00 
  8026df:	c7 44 24 08 ef 34 80 	movl   $0x8034ef,0x8(%esp)
  8026e6:	00 
  8026e7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8026ee:	00 
  8026ef:	c7 04 24 ef 35 80 00 	movl   $0x8035ef,(%esp)
  8026f6:	e8 70 dd ff ff       	call   80046b <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8026fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026ff:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  802706:	00 
  802707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80270a:	89 04 24             	mov    %eax,(%esp)
  80270d:	e8 12 e6 ff ff       	call   800d24 <memmove>
	}

	return r;
}
  802712:	89 d8                	mov    %ebx,%eax
  802714:	83 c4 10             	add    $0x10,%esp
  802717:	5b                   	pop    %ebx
  802718:	5e                   	pop    %esi
  802719:	5d                   	pop    %ebp
  80271a:	c3                   	ret    

0080271b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	53                   	push   %ebx
  80271f:	83 ec 14             	sub    $0x14,%esp
  802722:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  80272d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802733:	7e 24                	jle    802759 <nsipc_send+0x3e>
  802735:	c7 44 24 0c fb 35 80 	movl   $0x8035fb,0xc(%esp)
  80273c:	00 
  80273d:	c7 44 24 08 ef 34 80 	movl   $0x8034ef,0x8(%esp)
  802744:	00 
  802745:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80274c:	00 
  80274d:	c7 04 24 ef 35 80 00 	movl   $0x8035ef,(%esp)
  802754:	e8 12 dd ff ff       	call   80046b <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802759:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80275d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802760:	89 44 24 04          	mov    %eax,0x4(%esp)
  802764:	c7 04 24 0c 90 80 00 	movl   $0x80900c,(%esp)
  80276b:	e8 b4 e5 ff ff       	call   800d24 <memmove>
	nsipcbuf.send.req_size = size;
  802770:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  802776:	8b 45 14             	mov    0x14(%ebp),%eax
  802779:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  80277e:	b8 08 00 00 00       	mov    $0x8,%eax
  802783:	e8 7b fd ff ff       	call   802503 <nsipc>
}
  802788:	83 c4 14             	add    $0x14,%esp
  80278b:	5b                   	pop    %ebx
  80278c:	5d                   	pop    %ebp
  80278d:	c3                   	ret    

0080278e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  80279c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279f:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  8027a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a7:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  8027ac:	b8 09 00 00 00       	mov    $0x9,%eax
  8027b1:	e8 4d fd ff ff       	call   802503 <nsipc>
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	56                   	push   %esi
  8027bc:	53                   	push   %ebx
  8027bd:	83 ec 10             	sub    $0x10,%esp
  8027c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	89 04 24             	mov    %eax,(%esp)
  8027c9:	e8 12 ec ff ff       	call   8013e0 <fd2data>
  8027ce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8027d0:	c7 44 24 04 07 36 80 	movl   $0x803607,0x4(%esp)
  8027d7:	00 
  8027d8:	89 1c 24             	mov    %ebx,(%esp)
  8027db:	e8 a7 e3 ff ff       	call   800b87 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8027e0:	8b 46 04             	mov    0x4(%esi),%eax
  8027e3:	2b 06                	sub    (%esi),%eax
  8027e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8027eb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8027f2:	00 00 00 
	stat->st_dev = &devpipe;
  8027f5:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  8027fc:	57 80 00 
	return 0;
}
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	83 c4 10             	add    $0x10,%esp
  802807:	5b                   	pop    %ebx
  802808:	5e                   	pop    %esi
  802809:	5d                   	pop    %ebp
  80280a:	c3                   	ret    

0080280b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80280b:	55                   	push   %ebp
  80280c:	89 e5                	mov    %esp,%ebp
  80280e:	53                   	push   %ebx
  80280f:	83 ec 14             	sub    $0x14,%esp
  802812:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802815:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802819:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802820:	e8 25 e8 ff ff       	call   80104a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802825:	89 1c 24             	mov    %ebx,(%esp)
  802828:	e8 b3 eb ff ff       	call   8013e0 <fd2data>
  80282d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802831:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802838:	e8 0d e8 ff ff       	call   80104a <sys_page_unmap>
}
  80283d:	83 c4 14             	add    $0x14,%esp
  802840:	5b                   	pop    %ebx
  802841:	5d                   	pop    %ebp
  802842:	c3                   	ret    

00802843 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	57                   	push   %edi
  802847:	56                   	push   %esi
  802848:	53                   	push   %ebx
  802849:	83 ec 2c             	sub    $0x2c,%esp
  80284c:	89 c6                	mov    %eax,%esi
  80284e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802851:	a1 90 77 80 00       	mov    0x807790,%eax
  802856:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802859:	89 34 24             	mov    %esi,(%esp)
  80285c:	e8 3d 04 00 00       	call   802c9e <pageref>
  802861:	89 c7                	mov    %eax,%edi
  802863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802866:	89 04 24             	mov    %eax,(%esp)
  802869:	e8 30 04 00 00       	call   802c9e <pageref>
  80286e:	39 c7                	cmp    %eax,%edi
  802870:	0f 94 c2             	sete   %dl
  802873:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802876:	8b 0d 90 77 80 00    	mov    0x807790,%ecx
  80287c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80287f:	39 fb                	cmp    %edi,%ebx
  802881:	74 21                	je     8028a4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802883:	84 d2                	test   %dl,%dl
  802885:	74 ca                	je     802851 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802887:	8b 51 58             	mov    0x58(%ecx),%edx
  80288a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80288e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802892:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802896:	c7 04 24 0e 36 80 00 	movl   $0x80360e,(%esp)
  80289d:	e8 c2 dc ff ff       	call   800564 <cprintf>
  8028a2:	eb ad                	jmp    802851 <_pipeisclosed+0xe>
	}
}
  8028a4:	83 c4 2c             	add    $0x2c,%esp
  8028a7:	5b                   	pop    %ebx
  8028a8:	5e                   	pop    %esi
  8028a9:	5f                   	pop    %edi
  8028aa:	5d                   	pop    %ebp
  8028ab:	c3                   	ret    

008028ac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	57                   	push   %edi
  8028b0:	56                   	push   %esi
  8028b1:	53                   	push   %ebx
  8028b2:	83 ec 1c             	sub    $0x1c,%esp
  8028b5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8028b8:	89 34 24             	mov    %esi,(%esp)
  8028bb:	e8 20 eb ff ff       	call   8013e0 <fd2data>
  8028c0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c7:	eb 45                	jmp    80290e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8028c9:	89 da                	mov    %ebx,%edx
  8028cb:	89 f0                	mov    %esi,%eax
  8028cd:	e8 71 ff ff ff       	call   802843 <_pipeisclosed>
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	75 41                	jne    802917 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8028d6:	e8 a9 e6 ff ff       	call   800f84 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8028db:	8b 43 04             	mov    0x4(%ebx),%eax
  8028de:	8b 0b                	mov    (%ebx),%ecx
  8028e0:	8d 51 20             	lea    0x20(%ecx),%edx
  8028e3:	39 d0                	cmp    %edx,%eax
  8028e5:	73 e2                	jae    8028c9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8028e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028ea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8028ee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8028f1:	99                   	cltd   
  8028f2:	c1 ea 1b             	shr    $0x1b,%edx
  8028f5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8028f8:	83 e1 1f             	and    $0x1f,%ecx
  8028fb:	29 d1                	sub    %edx,%ecx
  8028fd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802901:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802905:	83 c0 01             	add    $0x1,%eax
  802908:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80290b:	83 c7 01             	add    $0x1,%edi
  80290e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802911:	75 c8                	jne    8028db <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802913:	89 f8                	mov    %edi,%eax
  802915:	eb 05                	jmp    80291c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802917:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80291c:	83 c4 1c             	add    $0x1c,%esp
  80291f:	5b                   	pop    %ebx
  802920:	5e                   	pop    %esi
  802921:	5f                   	pop    %edi
  802922:	5d                   	pop    %ebp
  802923:	c3                   	ret    

00802924 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
  802927:	57                   	push   %edi
  802928:	56                   	push   %esi
  802929:	53                   	push   %ebx
  80292a:	83 ec 1c             	sub    $0x1c,%esp
  80292d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802930:	89 3c 24             	mov    %edi,(%esp)
  802933:	e8 a8 ea ff ff       	call   8013e0 <fd2data>
  802938:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80293a:	be 00 00 00 00       	mov    $0x0,%esi
  80293f:	eb 3d                	jmp    80297e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802941:	85 f6                	test   %esi,%esi
  802943:	74 04                	je     802949 <devpipe_read+0x25>
				return i;
  802945:	89 f0                	mov    %esi,%eax
  802947:	eb 43                	jmp    80298c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802949:	89 da                	mov    %ebx,%edx
  80294b:	89 f8                	mov    %edi,%eax
  80294d:	e8 f1 fe ff ff       	call   802843 <_pipeisclosed>
  802952:	85 c0                	test   %eax,%eax
  802954:	75 31                	jne    802987 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802956:	e8 29 e6 ff ff       	call   800f84 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80295b:	8b 03                	mov    (%ebx),%eax
  80295d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802960:	74 df                	je     802941 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802962:	99                   	cltd   
  802963:	c1 ea 1b             	shr    $0x1b,%edx
  802966:	01 d0                	add    %edx,%eax
  802968:	83 e0 1f             	and    $0x1f,%eax
  80296b:	29 d0                	sub    %edx,%eax
  80296d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802975:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802978:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80297b:	83 c6 01             	add    $0x1,%esi
  80297e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802981:	75 d8                	jne    80295b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802983:	89 f0                	mov    %esi,%eax
  802985:	eb 05                	jmp    80298c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80298c:	83 c4 1c             	add    $0x1c,%esp
  80298f:	5b                   	pop    %ebx
  802990:	5e                   	pop    %esi
  802991:	5f                   	pop    %edi
  802992:	5d                   	pop    %ebp
  802993:	c3                   	ret    

00802994 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
  802997:	56                   	push   %esi
  802998:	53                   	push   %ebx
  802999:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80299c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80299f:	89 04 24             	mov    %eax,(%esp)
  8029a2:	e8 50 ea ff ff       	call   8013f7 <fd_alloc>
  8029a7:	89 c2                	mov    %eax,%edx
  8029a9:	85 d2                	test   %edx,%edx
  8029ab:	0f 88 4d 01 00 00    	js     802afe <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029b1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029b8:	00 
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c7:	e8 d7 e5 ff ff       	call   800fa3 <sys_page_alloc>
  8029cc:	89 c2                	mov    %eax,%edx
  8029ce:	85 d2                	test   %edx,%edx
  8029d0:	0f 88 28 01 00 00    	js     802afe <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8029d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8029d9:	89 04 24             	mov    %eax,(%esp)
  8029dc:	e8 16 ea ff ff       	call   8013f7 <fd_alloc>
  8029e1:	89 c3                	mov    %eax,%ebx
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	0f 88 fe 00 00 00    	js     802ae9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029f2:	00 
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a01:	e8 9d e5 ff ff       	call   800fa3 <sys_page_alloc>
  802a06:	89 c3                	mov    %eax,%ebx
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	0f 88 d9 00 00 00    	js     802ae9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	89 04 24             	mov    %eax,(%esp)
  802a16:	e8 c5 e9 ff ff       	call   8013e0 <fd2data>
  802a1b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a1d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a24:	00 
  802a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a30:	e8 6e e5 ff ff       	call   800fa3 <sys_page_alloc>
  802a35:	89 c3                	mov    %eax,%ebx
  802a37:	85 c0                	test   %eax,%eax
  802a39:	0f 88 97 00 00 00    	js     802ad6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a42:	89 04 24             	mov    %eax,(%esp)
  802a45:	e8 96 e9 ff ff       	call   8013e0 <fd2data>
  802a4a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802a51:	00 
  802a52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a56:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a5d:	00 
  802a5e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a69:	e8 89 e5 ff ff       	call   800ff7 <sys_page_map>
  802a6e:	89 c3                	mov    %eax,%ebx
  802a70:	85 c0                	test   %eax,%eax
  802a72:	78 52                	js     802ac6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802a74:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a89:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	89 04 24             	mov    %eax,(%esp)
  802aa4:	e8 27 e9 ff ff       	call   8013d0 <fd2num>
  802aa9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802aac:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	89 04 24             	mov    %eax,(%esp)
  802ab4:	e8 17 e9 ff ff       	call   8013d0 <fd2num>
  802ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802abc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802abf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac4:	eb 38                	jmp    802afe <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802ac6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802aca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ad1:	e8 74 e5 ff ff       	call   80104a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802add:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ae4:	e8 61 e5 ff ff       	call   80104a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802af7:	e8 4e e5 ff ff       	call   80104a <sys_page_unmap>
  802afc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802afe:	83 c4 30             	add    $0x30,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5d                   	pop    %ebp
  802b04:	c3                   	ret    

00802b05 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
  802b08:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	89 04 24             	mov    %eax,(%esp)
  802b18:	e8 29 e9 ff ff       	call   801446 <fd_lookup>
  802b1d:	89 c2                	mov    %eax,%edx
  802b1f:	85 d2                	test   %edx,%edx
  802b21:	78 15                	js     802b38 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	89 04 24             	mov    %eax,(%esp)
  802b29:	e8 b2 e8 ff ff       	call   8013e0 <fd2data>
	return _pipeisclosed(fd, p);
  802b2e:	89 c2                	mov    %eax,%edx
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	e8 0b fd ff ff       	call   802843 <_pipeisclosed>
}
  802b38:	c9                   	leave  
  802b39:	c3                   	ret    

00802b3a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
  802b3d:	56                   	push   %esi
  802b3e:	53                   	push   %ebx
  802b3f:	83 ec 10             	sub    $0x10,%esp
  802b42:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802b45:	85 f6                	test   %esi,%esi
  802b47:	75 24                	jne    802b6d <wait+0x33>
  802b49:	c7 44 24 0c 26 36 80 	movl   $0x803626,0xc(%esp)
  802b50:	00 
  802b51:	c7 44 24 08 ef 34 80 	movl   $0x8034ef,0x8(%esp)
  802b58:	00 
  802b59:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802b60:	00 
  802b61:	c7 04 24 31 36 80 00 	movl   $0x803631,(%esp)
  802b68:	e8 fe d8 ff ff       	call   80046b <_panic>
	e = &envs[ENVX(envid)];
  802b6d:	89 f0                	mov    %esi,%eax
  802b6f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b74:	89 c2                	mov    %eax,%edx
  802b76:	c1 e2 07             	shl    $0x7,%edx
  802b79:	8d 9c 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802b80:	eb 05                	jmp    802b87 <wait+0x4d>
		sys_yield();
  802b82:	e8 fd e3 ff ff       	call   800f84 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802b87:	8b 43 48             	mov    0x48(%ebx),%eax
  802b8a:	39 f0                	cmp    %esi,%eax
  802b8c:	75 07                	jne    802b95 <wait+0x5b>
  802b8e:	8b 43 54             	mov    0x54(%ebx),%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	75 ed                	jne    802b82 <wait+0x48>
		sys_yield();
}
  802b95:	83 c4 10             	add    $0x10,%esp
  802b98:	5b                   	pop    %ebx
  802b99:	5e                   	pop    %esi
  802b9a:	5d                   	pop    %ebp
  802b9b:	c3                   	ret    
  802b9c:	66 90                	xchg   %ax,%ax
  802b9e:	66 90                	xchg   %ax,%ax

00802ba0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	56                   	push   %esi
  802ba4:	53                   	push   %ebx
  802ba5:	83 ec 10             	sub    $0x10,%esp
  802ba8:	8b 75 08             	mov    0x8(%ebp),%esi
  802bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802bb1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802bb3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802bb8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  802bbb:	89 04 24             	mov    %eax,(%esp)
  802bbe:	e8 f6 e5 ff ff       	call   8011b9 <sys_ipc_recv>
  802bc3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802bc5:	85 d2                	test   %edx,%edx
  802bc7:	75 24                	jne    802bed <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802bc9:	85 f6                	test   %esi,%esi
  802bcb:	74 0a                	je     802bd7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  802bcd:	a1 90 77 80 00       	mov    0x807790,%eax
  802bd2:	8b 40 74             	mov    0x74(%eax),%eax
  802bd5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802bd7:	85 db                	test   %ebx,%ebx
  802bd9:	74 0a                	je     802be5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  802bdb:	a1 90 77 80 00       	mov    0x807790,%eax
  802be0:	8b 40 78             	mov    0x78(%eax),%eax
  802be3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802be5:	a1 90 77 80 00       	mov    0x807790,%eax
  802bea:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  802bed:	83 c4 10             	add    $0x10,%esp
  802bf0:	5b                   	pop    %ebx
  802bf1:	5e                   	pop    %esi
  802bf2:	5d                   	pop    %ebp
  802bf3:	c3                   	ret    

00802bf4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802bf4:	55                   	push   %ebp
  802bf5:	89 e5                	mov    %esp,%ebp
  802bf7:	57                   	push   %edi
  802bf8:	56                   	push   %esi
  802bf9:	53                   	push   %ebx
  802bfa:	83 ec 1c             	sub    $0x1c,%esp
  802bfd:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c00:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802c06:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802c08:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802c0d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802c10:	8b 45 14             	mov    0x14(%ebp),%eax
  802c13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c1b:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c1f:	89 3c 24             	mov    %edi,(%esp)
  802c22:	e8 6f e5 ff ff       	call   801196 <sys_ipc_try_send>

		if (ret == 0)
  802c27:	85 c0                	test   %eax,%eax
  802c29:	74 2c                	je     802c57 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  802c2b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c2e:	74 20                	je     802c50 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802c30:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c34:	c7 44 24 08 3c 36 80 	movl   $0x80363c,0x8(%esp)
  802c3b:	00 
  802c3c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802c43:	00 
  802c44:	c7 04 24 6c 36 80 00 	movl   $0x80366c,(%esp)
  802c4b:	e8 1b d8 ff ff       	call   80046b <_panic>
		}

		sys_yield();
  802c50:	e8 2f e3 ff ff       	call   800f84 <sys_yield>
	}
  802c55:	eb b9                	jmp    802c10 <ipc_send+0x1c>
}
  802c57:	83 c4 1c             	add    $0x1c,%esp
  802c5a:	5b                   	pop    %ebx
  802c5b:	5e                   	pop    %esi
  802c5c:	5f                   	pop    %edi
  802c5d:	5d                   	pop    %ebp
  802c5e:	c3                   	ret    

00802c5f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802c5f:	55                   	push   %ebp
  802c60:	89 e5                	mov    %esp,%ebp
  802c62:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802c65:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802c6a:	89 c2                	mov    %eax,%edx
  802c6c:	c1 e2 07             	shl    $0x7,%edx
  802c6f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802c76:	8b 52 50             	mov    0x50(%edx),%edx
  802c79:	39 ca                	cmp    %ecx,%edx
  802c7b:	75 11                	jne    802c8e <ipc_find_env+0x2f>
			return envs[i].env_id;
  802c7d:	89 c2                	mov    %eax,%edx
  802c7f:	c1 e2 07             	shl    $0x7,%edx
  802c82:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802c89:	8b 40 40             	mov    0x40(%eax),%eax
  802c8c:	eb 0e                	jmp    802c9c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802c8e:	83 c0 01             	add    $0x1,%eax
  802c91:	3d 00 04 00 00       	cmp    $0x400,%eax
  802c96:	75 d2                	jne    802c6a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802c98:	66 b8 00 00          	mov    $0x0,%ax
}
  802c9c:	5d                   	pop    %ebp
  802c9d:	c3                   	ret    

00802c9e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
  802ca1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ca4:	89 d0                	mov    %edx,%eax
  802ca6:	c1 e8 16             	shr    $0x16,%eax
  802ca9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802cb0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802cb5:	f6 c1 01             	test   $0x1,%cl
  802cb8:	74 1d                	je     802cd7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802cba:	c1 ea 0c             	shr    $0xc,%edx
  802cbd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802cc4:	f6 c2 01             	test   $0x1,%dl
  802cc7:	74 0e                	je     802cd7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802cc9:	c1 ea 0c             	shr    $0xc,%edx
  802ccc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802cd3:	ef 
  802cd4:	0f b7 c0             	movzwl %ax,%eax
}
  802cd7:	5d                   	pop    %ebp
  802cd8:	c3                   	ret    
  802cd9:	66 90                	xchg   %ax,%ax
  802cdb:	66 90                	xchg   %ax,%ax
  802cdd:	66 90                	xchg   %ax,%ax
  802cdf:	90                   	nop

00802ce0 <__udivdi3>:
  802ce0:	55                   	push   %ebp
  802ce1:	57                   	push   %edi
  802ce2:	56                   	push   %esi
  802ce3:	83 ec 0c             	sub    $0xc,%esp
  802ce6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802cee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802cf2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802cfc:	89 ea                	mov    %ebp,%edx
  802cfe:	89 0c 24             	mov    %ecx,(%esp)
  802d01:	75 2d                	jne    802d30 <__udivdi3+0x50>
  802d03:	39 e9                	cmp    %ebp,%ecx
  802d05:	77 61                	ja     802d68 <__udivdi3+0x88>
  802d07:	85 c9                	test   %ecx,%ecx
  802d09:	89 ce                	mov    %ecx,%esi
  802d0b:	75 0b                	jne    802d18 <__udivdi3+0x38>
  802d0d:	b8 01 00 00 00       	mov    $0x1,%eax
  802d12:	31 d2                	xor    %edx,%edx
  802d14:	f7 f1                	div    %ecx
  802d16:	89 c6                	mov    %eax,%esi
  802d18:	31 d2                	xor    %edx,%edx
  802d1a:	89 e8                	mov    %ebp,%eax
  802d1c:	f7 f6                	div    %esi
  802d1e:	89 c5                	mov    %eax,%ebp
  802d20:	89 f8                	mov    %edi,%eax
  802d22:	f7 f6                	div    %esi
  802d24:	89 ea                	mov    %ebp,%edx
  802d26:	83 c4 0c             	add    $0xc,%esp
  802d29:	5e                   	pop    %esi
  802d2a:	5f                   	pop    %edi
  802d2b:	5d                   	pop    %ebp
  802d2c:	c3                   	ret    
  802d2d:	8d 76 00             	lea    0x0(%esi),%esi
  802d30:	39 e8                	cmp    %ebp,%eax
  802d32:	77 24                	ja     802d58 <__udivdi3+0x78>
  802d34:	0f bd e8             	bsr    %eax,%ebp
  802d37:	83 f5 1f             	xor    $0x1f,%ebp
  802d3a:	75 3c                	jne    802d78 <__udivdi3+0x98>
  802d3c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802d40:	39 34 24             	cmp    %esi,(%esp)
  802d43:	0f 86 9f 00 00 00    	jbe    802de8 <__udivdi3+0x108>
  802d49:	39 d0                	cmp    %edx,%eax
  802d4b:	0f 82 97 00 00 00    	jb     802de8 <__udivdi3+0x108>
  802d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d58:	31 d2                	xor    %edx,%edx
  802d5a:	31 c0                	xor    %eax,%eax
  802d5c:	83 c4 0c             	add    $0xc,%esp
  802d5f:	5e                   	pop    %esi
  802d60:	5f                   	pop    %edi
  802d61:	5d                   	pop    %ebp
  802d62:	c3                   	ret    
  802d63:	90                   	nop
  802d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d68:	89 f8                	mov    %edi,%eax
  802d6a:	f7 f1                	div    %ecx
  802d6c:	31 d2                	xor    %edx,%edx
  802d6e:	83 c4 0c             	add    $0xc,%esp
  802d71:	5e                   	pop    %esi
  802d72:	5f                   	pop    %edi
  802d73:	5d                   	pop    %ebp
  802d74:	c3                   	ret    
  802d75:	8d 76 00             	lea    0x0(%esi),%esi
  802d78:	89 e9                	mov    %ebp,%ecx
  802d7a:	8b 3c 24             	mov    (%esp),%edi
  802d7d:	d3 e0                	shl    %cl,%eax
  802d7f:	89 c6                	mov    %eax,%esi
  802d81:	b8 20 00 00 00       	mov    $0x20,%eax
  802d86:	29 e8                	sub    %ebp,%eax
  802d88:	89 c1                	mov    %eax,%ecx
  802d8a:	d3 ef                	shr    %cl,%edi
  802d8c:	89 e9                	mov    %ebp,%ecx
  802d8e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d92:	8b 3c 24             	mov    (%esp),%edi
  802d95:	09 74 24 08          	or     %esi,0x8(%esp)
  802d99:	89 d6                	mov    %edx,%esi
  802d9b:	d3 e7                	shl    %cl,%edi
  802d9d:	89 c1                	mov    %eax,%ecx
  802d9f:	89 3c 24             	mov    %edi,(%esp)
  802da2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802da6:	d3 ee                	shr    %cl,%esi
  802da8:	89 e9                	mov    %ebp,%ecx
  802daa:	d3 e2                	shl    %cl,%edx
  802dac:	89 c1                	mov    %eax,%ecx
  802dae:	d3 ef                	shr    %cl,%edi
  802db0:	09 d7                	or     %edx,%edi
  802db2:	89 f2                	mov    %esi,%edx
  802db4:	89 f8                	mov    %edi,%eax
  802db6:	f7 74 24 08          	divl   0x8(%esp)
  802dba:	89 d6                	mov    %edx,%esi
  802dbc:	89 c7                	mov    %eax,%edi
  802dbe:	f7 24 24             	mull   (%esp)
  802dc1:	39 d6                	cmp    %edx,%esi
  802dc3:	89 14 24             	mov    %edx,(%esp)
  802dc6:	72 30                	jb     802df8 <__udivdi3+0x118>
  802dc8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802dcc:	89 e9                	mov    %ebp,%ecx
  802dce:	d3 e2                	shl    %cl,%edx
  802dd0:	39 c2                	cmp    %eax,%edx
  802dd2:	73 05                	jae    802dd9 <__udivdi3+0xf9>
  802dd4:	3b 34 24             	cmp    (%esp),%esi
  802dd7:	74 1f                	je     802df8 <__udivdi3+0x118>
  802dd9:	89 f8                	mov    %edi,%eax
  802ddb:	31 d2                	xor    %edx,%edx
  802ddd:	e9 7a ff ff ff       	jmp    802d5c <__udivdi3+0x7c>
  802de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802de8:	31 d2                	xor    %edx,%edx
  802dea:	b8 01 00 00 00       	mov    $0x1,%eax
  802def:	e9 68 ff ff ff       	jmp    802d5c <__udivdi3+0x7c>
  802df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802df8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802dfb:	31 d2                	xor    %edx,%edx
  802dfd:	83 c4 0c             	add    $0xc,%esp
  802e00:	5e                   	pop    %esi
  802e01:	5f                   	pop    %edi
  802e02:	5d                   	pop    %ebp
  802e03:	c3                   	ret    
  802e04:	66 90                	xchg   %ax,%ax
  802e06:	66 90                	xchg   %ax,%ax
  802e08:	66 90                	xchg   %ax,%ax
  802e0a:	66 90                	xchg   %ax,%ax
  802e0c:	66 90                	xchg   %ax,%ax
  802e0e:	66 90                	xchg   %ax,%ax

00802e10 <__umoddi3>:
  802e10:	55                   	push   %ebp
  802e11:	57                   	push   %edi
  802e12:	56                   	push   %esi
  802e13:	83 ec 14             	sub    $0x14,%esp
  802e16:	8b 44 24 28          	mov    0x28(%esp),%eax
  802e1a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802e1e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802e22:	89 c7                	mov    %eax,%edi
  802e24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e28:	8b 44 24 30          	mov    0x30(%esp),%eax
  802e2c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802e30:	89 34 24             	mov    %esi,(%esp)
  802e33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e37:	85 c0                	test   %eax,%eax
  802e39:	89 c2                	mov    %eax,%edx
  802e3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e3f:	75 17                	jne    802e58 <__umoddi3+0x48>
  802e41:	39 fe                	cmp    %edi,%esi
  802e43:	76 4b                	jbe    802e90 <__umoddi3+0x80>
  802e45:	89 c8                	mov    %ecx,%eax
  802e47:	89 fa                	mov    %edi,%edx
  802e49:	f7 f6                	div    %esi
  802e4b:	89 d0                	mov    %edx,%eax
  802e4d:	31 d2                	xor    %edx,%edx
  802e4f:	83 c4 14             	add    $0x14,%esp
  802e52:	5e                   	pop    %esi
  802e53:	5f                   	pop    %edi
  802e54:	5d                   	pop    %ebp
  802e55:	c3                   	ret    
  802e56:	66 90                	xchg   %ax,%ax
  802e58:	39 f8                	cmp    %edi,%eax
  802e5a:	77 54                	ja     802eb0 <__umoddi3+0xa0>
  802e5c:	0f bd e8             	bsr    %eax,%ebp
  802e5f:	83 f5 1f             	xor    $0x1f,%ebp
  802e62:	75 5c                	jne    802ec0 <__umoddi3+0xb0>
  802e64:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802e68:	39 3c 24             	cmp    %edi,(%esp)
  802e6b:	0f 87 e7 00 00 00    	ja     802f58 <__umoddi3+0x148>
  802e71:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802e75:	29 f1                	sub    %esi,%ecx
  802e77:	19 c7                	sbb    %eax,%edi
  802e79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e81:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e85:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802e89:	83 c4 14             	add    $0x14,%esp
  802e8c:	5e                   	pop    %esi
  802e8d:	5f                   	pop    %edi
  802e8e:	5d                   	pop    %ebp
  802e8f:	c3                   	ret    
  802e90:	85 f6                	test   %esi,%esi
  802e92:	89 f5                	mov    %esi,%ebp
  802e94:	75 0b                	jne    802ea1 <__umoddi3+0x91>
  802e96:	b8 01 00 00 00       	mov    $0x1,%eax
  802e9b:	31 d2                	xor    %edx,%edx
  802e9d:	f7 f6                	div    %esi
  802e9f:	89 c5                	mov    %eax,%ebp
  802ea1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ea5:	31 d2                	xor    %edx,%edx
  802ea7:	f7 f5                	div    %ebp
  802ea9:	89 c8                	mov    %ecx,%eax
  802eab:	f7 f5                	div    %ebp
  802ead:	eb 9c                	jmp    802e4b <__umoddi3+0x3b>
  802eaf:	90                   	nop
  802eb0:	89 c8                	mov    %ecx,%eax
  802eb2:	89 fa                	mov    %edi,%edx
  802eb4:	83 c4 14             	add    $0x14,%esp
  802eb7:	5e                   	pop    %esi
  802eb8:	5f                   	pop    %edi
  802eb9:	5d                   	pop    %ebp
  802eba:	c3                   	ret    
  802ebb:	90                   	nop
  802ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ec0:	8b 04 24             	mov    (%esp),%eax
  802ec3:	be 20 00 00 00       	mov    $0x20,%esi
  802ec8:	89 e9                	mov    %ebp,%ecx
  802eca:	29 ee                	sub    %ebp,%esi
  802ecc:	d3 e2                	shl    %cl,%edx
  802ece:	89 f1                	mov    %esi,%ecx
  802ed0:	d3 e8                	shr    %cl,%eax
  802ed2:	89 e9                	mov    %ebp,%ecx
  802ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ed8:	8b 04 24             	mov    (%esp),%eax
  802edb:	09 54 24 04          	or     %edx,0x4(%esp)
  802edf:	89 fa                	mov    %edi,%edx
  802ee1:	d3 e0                	shl    %cl,%eax
  802ee3:	89 f1                	mov    %esi,%ecx
  802ee5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ee9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802eed:	d3 ea                	shr    %cl,%edx
  802eef:	89 e9                	mov    %ebp,%ecx
  802ef1:	d3 e7                	shl    %cl,%edi
  802ef3:	89 f1                	mov    %esi,%ecx
  802ef5:	d3 e8                	shr    %cl,%eax
  802ef7:	89 e9                	mov    %ebp,%ecx
  802ef9:	09 f8                	or     %edi,%eax
  802efb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802eff:	f7 74 24 04          	divl   0x4(%esp)
  802f03:	d3 e7                	shl    %cl,%edi
  802f05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f09:	89 d7                	mov    %edx,%edi
  802f0b:	f7 64 24 08          	mull   0x8(%esp)
  802f0f:	39 d7                	cmp    %edx,%edi
  802f11:	89 c1                	mov    %eax,%ecx
  802f13:	89 14 24             	mov    %edx,(%esp)
  802f16:	72 2c                	jb     802f44 <__umoddi3+0x134>
  802f18:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802f1c:	72 22                	jb     802f40 <__umoddi3+0x130>
  802f1e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802f22:	29 c8                	sub    %ecx,%eax
  802f24:	19 d7                	sbb    %edx,%edi
  802f26:	89 e9                	mov    %ebp,%ecx
  802f28:	89 fa                	mov    %edi,%edx
  802f2a:	d3 e8                	shr    %cl,%eax
  802f2c:	89 f1                	mov    %esi,%ecx
  802f2e:	d3 e2                	shl    %cl,%edx
  802f30:	89 e9                	mov    %ebp,%ecx
  802f32:	d3 ef                	shr    %cl,%edi
  802f34:	09 d0                	or     %edx,%eax
  802f36:	89 fa                	mov    %edi,%edx
  802f38:	83 c4 14             	add    $0x14,%esp
  802f3b:	5e                   	pop    %esi
  802f3c:	5f                   	pop    %edi
  802f3d:	5d                   	pop    %ebp
  802f3e:	c3                   	ret    
  802f3f:	90                   	nop
  802f40:	39 d7                	cmp    %edx,%edi
  802f42:	75 da                	jne    802f1e <__umoddi3+0x10e>
  802f44:	8b 14 24             	mov    (%esp),%edx
  802f47:	89 c1                	mov    %eax,%ecx
  802f49:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802f4d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802f51:	eb cb                	jmp    802f1e <__umoddi3+0x10e>
  802f53:	90                   	nop
  802f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f58:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802f5c:	0f 82 0f ff ff ff    	jb     802e71 <__umoddi3+0x61>
  802f62:	e9 1a ff ff ff       	jmp    802e81 <__umoddi3+0x71>
