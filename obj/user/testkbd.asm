
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 50 10 00 00       	call   801094 <sys_yield>
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>
		sys_yield();

	close(0);
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 32 16 00 00       	call   801687 <close>
	if ((r = opencons()) < 0)
  800055:	e8 11 02 00 00       	call   80026b <opencons>
  80005a:	85 c0                	test   %eax,%eax
  80005c:	79 20                	jns    80007e <umain+0x4b>
		panic("opencons: %e", r);
  80005e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800062:	c7 44 24 08 00 2b 80 	movl   $0x802b00,0x8(%esp)
  800069:	00 
  80006a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800071:	00 
  800072:	c7 04 24 0d 2b 80 00 	movl   $0x802b0d,(%esp)
  800079:	e8 ad 02 00 00       	call   80032b <_panic>
	if (r != 0)
  80007e:	85 c0                	test   %eax,%eax
  800080:	74 20                	je     8000a2 <umain+0x6f>
		panic("first opencons used fd %d", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 1c 2b 80 	movl   $0x802b1c,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 0d 2b 80 00 	movl   $0x802b0d,(%esp)
  80009d:	e8 89 02 00 00       	call   80032b <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000a9:	00 
  8000aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b1:	e8 26 16 00 00       	call   8016dc <dup>
  8000b6:	85 c0                	test   %eax,%eax
  8000b8:	79 20                	jns    8000da <umain+0xa7>
		panic("dup: %e", r);
  8000ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000be:	c7 44 24 08 36 2b 80 	movl   $0x802b36,0x8(%esp)
  8000c5:	00 
  8000c6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000cd:	00 
  8000ce:	c7 04 24 0d 2b 80 00 	movl   $0x802b0d,(%esp)
  8000d5:	e8 51 02 00 00       	call   80032b <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000da:	c7 04 24 3e 2b 80 00 	movl   $0x802b3e,(%esp)
  8000e1:	e8 7c 0a 00 00       	call   800b62 <readline>
		if (buf != NULL)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	74 1a                	je     800104 <umain+0xd1>
			fprintf(1, "%s\n", buf);
  8000ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ee:	c7 44 24 04 4c 2b 80 	movl   $0x802b4c,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fd:	e8 43 1d 00 00       	call   801e45 <fprintf>
  800102:	eb d6                	jmp    8000da <umain+0xa7>
		else
			fprintf(1, "(end of file received)\n");
  800104:	c7 44 24 04 50 2b 80 	movl   $0x802b50,0x4(%esp)
  80010b:	00 
  80010c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800113:	e8 2d 1d 00 00       	call   801e45 <fprintf>
  800118:	eb c0                	jmp    8000da <umain+0xa7>
  80011a:	66 90                	xchg   %ax,%ax
  80011c:	66 90                	xchg   %ax,%ax
  80011e:	66 90                	xchg   %ax,%ax

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 68 2b 80 	movl   $0x802b68,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 54 0b 00 00       	call   800c97 <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800156:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80015b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800161:	eb 31                	jmp    800194 <devcons_write+0x4a>
		m = n - tot;
  800163:	8b 75 10             	mov    0x10(%ebp),%esi
  800166:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  800168:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80016b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800170:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800173:	89 74 24 08          	mov    %esi,0x8(%esp)
  800177:	03 45 0c             	add    0xc(%ebp),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	89 3c 24             	mov    %edi,(%esp)
  800181:	e8 ae 0c 00 00       	call   800e34 <memmove>
		sys_cputs(buf, m);
  800186:	89 74 24 04          	mov    %esi,0x4(%esp)
  80018a:	89 3c 24             	mov    %edi,(%esp)
  80018d:	e8 54 0e 00 00       	call   800fe6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800192:	01 f3                	add    %esi,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800199:	72 c8                	jb     800163 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80019b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8001ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8001b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001b5:	75 07                	jne    8001be <devcons_read+0x18>
  8001b7:	eb 2a                	jmp    8001e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001b9:	e8 d6 0e 00 00       	call   801094 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001be:	66 90                	xchg   %ax,%ax
  8001c0:	e8 3f 0e 00 00       	call   801004 <sys_cgetc>
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 f0                	je     8001b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	78 16                	js     8001e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001cd:	83 f8 04             	cmp    $0x4,%eax
  8001d0:	74 0c                	je     8001de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	88 02                	mov    %al,(%edx)
	return 1;
  8001d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8001dc:	eb 05                	jmp    8001e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8001de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8001e3:	c9                   	leave  
  8001e4:	c3                   	ret    

008001e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001f8:	00 
  8001f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001fc:	89 04 24             	mov    %eax,(%esp)
  8001ff:	e8 e2 0d 00 00       	call   800fe6 <sys_cputs>
}
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <getchar>:

int
getchar(void)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80020c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800213:	00 
  800214:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800222:	e8 c3 15 00 00       	call   8017ea <read>
	if (r < 0)
  800227:	85 c0                	test   %eax,%eax
  800229:	78 0f                	js     80023a <getchar+0x34>
		return r;
	if (r < 1)
  80022b:	85 c0                	test   %eax,%eax
  80022d:	7e 06                	jle    800235 <getchar+0x2f>
		return -E_EOF;
	return c;
  80022f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800233:	eb 05                	jmp    80023a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800235:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800242:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800245:	89 44 24 04          	mov    %eax,0x4(%esp)
  800249:	8b 45 08             	mov    0x8(%ebp),%eax
  80024c:	89 04 24             	mov    %eax,(%esp)
  80024f:	e8 02 13 00 00       	call   801556 <fd_lookup>
  800254:	85 c0                	test   %eax,%eax
  800256:	78 11                	js     800269 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025b:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800261:	39 10                	cmp    %edx,(%eax)
  800263:	0f 94 c0             	sete   %al
  800266:	0f b6 c0             	movzbl %al,%eax
}
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <opencons>:

int
opencons(void)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800271:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800274:	89 04 24             	mov    %eax,(%esp)
  800277:	e8 8b 12 00 00       	call   801507 <fd_alloc>
		return r;
  80027c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	78 40                	js     8002c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800282:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800289:	00 
  80028a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80028d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800291:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800298:	e8 16 0e 00 00       	call   8010b3 <sys_page_alloc>
		return r;
  80029d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	78 1f                	js     8002c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8002a3:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8002a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8002ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	e8 20 12 00 00       	call   8014e0 <fd2num>
  8002c0:	89 c2                	mov    %eax,%edx
}
  8002c2:	89 d0                	mov    %edx,%eax
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    

008002c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 10             	sub    $0x10,%esp
  8002ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002d1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8002d4:	e8 9c 0d 00 00       	call   801075 <sys_getenvid>
  8002d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002de:	89 c2                	mov    %eax,%edx
  8002e0:	c1 e2 07             	shl    $0x7,%edx
  8002e3:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8002ea:	a3 08 54 80 00       	mov    %eax,0x805408

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ef:	85 db                	test   %ebx,%ebx
  8002f1:	7e 07                	jle    8002fa <libmain+0x34>
		binaryname = argv[0];
  8002f3:	8b 06                	mov    (%esi),%eax
  8002f5:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8002fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002fe:	89 1c 24             	mov    %ebx,(%esp)
  800301:	e8 2d fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800306:	e8 07 00 00 00       	call   800312 <exit>
}
  80030b:	83 c4 10             	add    $0x10,%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800318:	e8 9d 13 00 00       	call   8016ba <close_all>
	sys_env_destroy(0);
  80031d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800324:	e8 fa 0c 00 00       	call   801023 <sys_env_destroy>
}
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	56                   	push   %esi
  80032f:	53                   	push   %ebx
  800330:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800333:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800336:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  80033c:	e8 34 0d 00 00       	call   801075 <sys_getenvid>
  800341:	8b 55 0c             	mov    0xc(%ebp),%edx
  800344:	89 54 24 10          	mov    %edx,0x10(%esp)
  800348:	8b 55 08             	mov    0x8(%ebp),%edx
  80034b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80034f:	89 74 24 08          	mov    %esi,0x8(%esp)
  800353:	89 44 24 04          	mov    %eax,0x4(%esp)
  800357:	c7 04 24 80 2b 80 00 	movl   $0x802b80,(%esp)
  80035e:	e8 c1 00 00 00       	call   800424 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800363:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800367:	8b 45 10             	mov    0x10(%ebp),%eax
  80036a:	89 04 24             	mov    %eax,(%esp)
  80036d:	e8 51 00 00 00       	call   8003c3 <vcprintf>
	cprintf("\n");
  800372:	c7 04 24 66 2b 80 00 	movl   $0x802b66,(%esp)
  800379:	e8 a6 00 00 00       	call   800424 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037e:	cc                   	int3   
  80037f:	eb fd                	jmp    80037e <_panic+0x53>

00800381 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	53                   	push   %ebx
  800385:	83 ec 14             	sub    $0x14,%esp
  800388:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038b:	8b 13                	mov    (%ebx),%edx
  80038d:	8d 42 01             	lea    0x1(%edx),%eax
  800390:	89 03                	mov    %eax,(%ebx)
  800392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800395:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800399:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039e:	75 19                	jne    8003b9 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003a0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003a7:	00 
  8003a8:	8d 43 08             	lea    0x8(%ebx),%eax
  8003ab:	89 04 24             	mov    %eax,(%esp)
  8003ae:	e8 33 0c 00 00       	call   800fe6 <sys_cputs>
		b->idx = 0;
  8003b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003b9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003bd:	83 c4 14             	add    $0x14,%esp
  8003c0:	5b                   	pop    %ebx
  8003c1:	5d                   	pop    %ebp
  8003c2:	c3                   	ret    

008003c3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d3:	00 00 00 
	b.cnt = 0;
  8003d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003dd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f8:	c7 04 24 81 03 80 00 	movl   $0x800381,(%esp)
  8003ff:	e8 aa 01 00 00       	call   8005ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800404:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80040a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800414:	89 04 24             	mov    %eax,(%esp)
  800417:	e8 ca 0b 00 00       	call   800fe6 <sys_cputs>

	return b.cnt;
}
  80041c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80042a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	89 04 24             	mov    %eax,(%esp)
  800437:	e8 87 ff ff ff       	call   8003c3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    
  80043e:	66 90                	xchg   %ax,%ax

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
  8004af:	e8 ac 23 00 00       	call   802860 <__udivdi3>
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
  80050f:	e8 7c 24 00 00       	call   802990 <__umoddi3>
  800514:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800518:	0f be 80 a3 2b 80 00 	movsbl 0x802ba3(%eax),%eax
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
  800633:	ff 24 8d 20 2d 80 00 	jmp    *0x802d20(,%ecx,4)
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
  8006d0:	8b 14 85 80 2e 80 00 	mov    0x802e80(,%eax,4),%edx
  8006d7:	85 d2                	test   %edx,%edx
  8006d9:	75 20                	jne    8006fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8006db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006df:	c7 44 24 08 bb 2b 80 	movl   $0x802bbb,0x8(%esp)
  8006e6:	00 
  8006e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 04 24             	mov    %eax,(%esp)
  8006f1:	e8 90 fe ff ff       	call   800586 <printfmt>
  8006f6:	e9 d8 fe ff ff       	jmp    8005d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8006fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006ff:	c7 44 24 08 b9 30 80 	movl   $0x8030b9,0x8(%esp)
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
  800731:	b8 b4 2b 80 00       	mov    $0x802bb4,%eax
  800736:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800739:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80073d:	0f 84 97 00 00 00    	je     8007da <vprintfmt+0x22c>
  800743:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800747:	0f 8e 9b 00 00 00    	jle    8007e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80074d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800751:	89 34 24             	mov    %esi,(%esp)
  800754:	e8 1f 05 00 00       	call   800c78 <strnlen>
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

00800a10 <tab_handler>:
	}
}

int
tab_handler(int tab_pos)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	57                   	push   %edi
  800a14:	56                   	push   %esi
  800a15:	53                   	push   %ebx
  800a16:	83 ec 3c             	sub    $0x3c,%esp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
	char* begin = buf + tab_pos;
  800a1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a1f:	05 00 50 80 00       	add    $0x805000,%eax
  800a24:	89 c6                	mov    %eax,%esi
	while ((begin > buf) && (*(begin -1) != ' '))
  800a26:	eb 03                	jmp    800a2b <tab_handler+0x1b>
		begin--;
  800a28:	83 ee 01             	sub    $0x1,%esi

int
tab_handler(int tab_pos)
{
	char* begin = buf + tab_pos;
	while ((begin > buf) && (*(begin -1) != ' '))
  800a2b:	81 fe 00 50 80 00    	cmp    $0x805000,%esi
  800a31:	76 06                	jbe    800a39 <tab_handler+0x29>
  800a33:	80 7e ff 20          	cmpb   $0x20,-0x1(%esi)
  800a37:	75 ef                	jne    800a28 <tab_handler+0x18>
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
  800a39:	29 f0                	sub    %esi,%eax
  800a3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	char* cmd = 0;
  800a3e:	bb 00 00 00 00       	mov    $0x0,%ebx

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
  800a43:	bf 00 00 00 00       	mov    $0x0,%edi
{
	char* begin = buf + tab_pos;
	while ((begin > buf) && (*(begin -1) != ' '))
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
  800a48:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800a4f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a56:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800a59:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800a5c:	89 c6                	mov    %eax,%esi
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
  800a5e:	eb 35                	jmp    800a95 <tab_handler+0x85>
      		if (strncmp(begin, commands[i], len) == 0) {
  800a60:	8b 1c bd a0 2f 80 00 	mov    0x802fa0(,%edi,4),%ebx
  800a67:	89 74 24 08          	mov    %esi,0x8(%esp)
  800a6b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a72:	89 04 24             	mov    %eax,(%esp)
  800a75:	e8 f8 02 00 00       	call   800d72 <strncmp>
  800a7a:	85 c0                	test   %eax,%eax
  800a7c:	75 14                	jne    800a92 <tab_handler+0x82>
			found_num++;
  800a7e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
         		cmd = commands[i];
         		cmd_append_len = strlen(cmd) - len;
  800a82:	89 1c 24             	mov    %ebx,(%esp)
  800a85:	e8 d6 01 00 00       	call   800c60 <strlen>
  800a8a:	29 f0                	sub    %esi,%eax
  800a8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
      		if (strncmp(begin, commands[i], len) == 0) {
			found_num++;
         		cmd = commands[i];
  800a8f:	89 5d d8             	mov    %ebx,-0x28(%ebp)
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
  800a92:	83 c7 01             	add    $0x1,%edi
  800a95:	83 ff 10             	cmp    $0x10,%edi
  800a98:	7f 04                	jg     800a9e <tab_handler+0x8e>
  800a9a:	85 f6                	test   %esi,%esi
  800a9c:	7f c2                	jg     800a60 <tab_handler+0x50>
  800a9e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800aa1:	8b 5d d8             	mov    -0x28(%ebp),%ebx
         		cmd = commands[i];
         		cmd_append_len = strlen(cmd) - len;
      		}
   	}

	if (found_num > 1) {
  800aa4:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  800aa8:	7e 72                	jle    800b1c <tab_handler+0x10c>
		#if JOS_KERNEL
			cprintf("\nYour options are:\n");
		#else
			fprintf(1, "\nYour options are:\n");
  800aaa:	c7 44 24 04 eb 2e 80 	movl   $0x802eeb,0x4(%esp)
  800ab1:	00 
  800ab2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800ab9:	e8 87 13 00 00       	call   801e45 <fprintf>
		#endif
		for (i = 0; i < NUM_CMDS; i++) {
  800abe:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (strncmp(begin, commands[i], len) == 0) {
  800ac3:	8b 3c 9d a0 2f 80 00 	mov    0x802fa0(,%ebx,4),%edi
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ad1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ad5:	89 34 24             	mov    %esi,(%esp)
  800ad8:	e8 95 02 00 00       	call   800d72 <strncmp>
  800add:	85 c0                	test   %eax,%eax
  800adf:	75 18                	jne    800af9 <tab_handler+0xe9>
                    		#if JOS_KERNEL
                            		cprintf("%s\n", commands[i]);
                   		 #else
                           		fprintf(1, "%s\n", commands[i]);
  800ae1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ae5:	c7 44 24 04 4c 2b 80 	movl   $0x802b4c,0x4(%esp)
  800aec:	00 
  800aed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800af4:	e8 4c 13 00 00       	call   801e45 <fprintf>
		#if JOS_KERNEL
			cprintf("\nYour options are:\n");
		#else
			fprintf(1, "\nYour options are:\n");
		#endif
		for (i = 0; i < NUM_CMDS; i++) {
  800af9:	83 c3 01             	add    $0x1,%ebx
  800afc:	83 fb 11             	cmp    $0x11,%ebx
  800aff:	75 c2                	jne    800ac3 <tab_handler+0xb3>
                 	}
            	}
		#if JOS_KERNEL
			cprintf("$ ");
		#else
			fprintf(1, "$ ");
  800b01:	c7 44 24 04 ff 2e 80 	movl   $0x802eff,0x4(%esp)
  800b08:	00 
  800b09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b10:	e8 30 13 00 00       	call   801e45 <fprintf>
		#endif
		return -len;
  800b15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b18:	f7 d8                	neg    %eax
  800b1a:	eb 3e                	jmp    800b5a <tab_handler+0x14a>
  800b1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
	}

	int pos_to_write = tab_pos;

	if (cmd_append_len > 0){
  800b21:	85 d2                	test   %edx,%edx
  800b23:	7e 35                	jle    800b5a <tab_handler+0x14a>
  800b25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b28:	89 c6                	mov    %eax,%esi
  800b2a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  800b2d:	29 c7                	sub    %eax,%edi
  800b2f:	eb 1a                	jmp    800b4b <tab_handler+0x13b>
		for (i = len; i < strlen(cmd); i++) {
      			buf[pos_to_write] = cmd[i];
  800b31:	0f b6 04 33          	movzbl (%ebx,%esi,1),%eax
  800b35:	88 84 37 00 50 80 00 	mov    %al,0x805000(%edi,%esi,1)
			pos_to_write++;
      			cputchar(cmd[i]);
  800b3c:	0f be 04 33          	movsbl (%ebx,%esi,1),%eax
  800b40:	89 04 24             	mov    %eax,(%esp)
  800b43:	e8 9d f6 ff ff       	call   8001e5 <cputchar>
	}

	int pos_to_write = tab_pos;

	if (cmd_append_len > 0){
		for (i = len; i < strlen(cmd); i++) {
  800b48:	83 c6 01             	add    $0x1,%esi
  800b4b:	89 1c 24             	mov    %ebx,(%esp)
  800b4e:	e8 0d 01 00 00       	call   800c60 <strlen>
  800b53:	39 c6                	cmp    %eax,%esi
  800b55:	7c da                	jl     800b31 <tab_handler+0x121>
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   		}

	}

	return cmd_append_len;
}
  800b5a:	83 c4 3c             	add    $0x3c,%esp
  800b5d:	5b                   	pop    %ebx
  800b5e:	5e                   	pop    %esi
  800b5f:	5f                   	pop    %edi
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    

00800b62 <readline>:
int tab_handler(int tab_pos);


char *
readline(const char *prompt)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	57                   	push   %edi
  800b66:	56                   	push   %esi
  800b67:	53                   	push   %ebx
  800b68:	83 ec 1c             	sub    $0x1c,%esp
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800b6e:	85 c0                	test   %eax,%eax
  800b70:	74 18                	je     800b8a <readline+0x28>
		fprintf(1, "%s", prompt);
  800b72:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b76:	c7 44 24 04 b9 30 80 	movl   $0x8030b9,0x4(%esp)
  800b7d:	00 
  800b7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b85:	e8 bb 12 00 00       	call   801e45 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  800b8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b91:	e8 a6 f6 ff ff       	call   80023c <iscons>
  800b96:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  800b98:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  800b9d:	e8 64 f6 ff ff       	call   800206 <getchar>
  800ba2:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	79 28                	jns    800bd0 <readline+0x6e>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  800bad:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800bb0:	0f 84 a1 00 00 00    	je     800c57 <readline+0xf5>
				cprintf("read error: %e\n", c);
  800bb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bba:	c7 04 24 02 2f 80 00 	movl   $0x802f02,(%esp)
  800bc1:	e8 5e f8 ff ff       	call   800424 <cprintf>
			return NULL;
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	e9 87 00 00 00       	jmp    800c57 <readline+0xf5>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800bd0:	83 f8 7f             	cmp    $0x7f,%eax
  800bd3:	74 05                	je     800bda <readline+0x78>
  800bd5:	83 f8 08             	cmp    $0x8,%eax
  800bd8:	75 19                	jne    800bf3 <readline+0x91>
  800bda:	85 f6                	test   %esi,%esi
  800bdc:	7e 15                	jle    800bf3 <readline+0x91>
			if (echoing)
  800bde:	85 ff                	test   %edi,%edi
  800be0:	74 0c                	je     800bee <readline+0x8c>
				cputchar('\b');
  800be2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800be9:	e8 f7 f5 ff ff       	call   8001e5 <cputchar>
			i--;
  800bee:	83 ee 01             	sub    $0x1,%esi
  800bf1:	eb aa                	jmp    800b9d <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800bf3:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800bf9:	7f 1c                	jg     800c17 <readline+0xb5>
  800bfb:	83 fb 1f             	cmp    $0x1f,%ebx
  800bfe:	7e 17                	jle    800c17 <readline+0xb5>
			if (echoing)
  800c00:	85 ff                	test   %edi,%edi
  800c02:	74 08                	je     800c0c <readline+0xaa>
				cputchar(c);
  800c04:	89 1c 24             	mov    %ebx,(%esp)
  800c07:	e8 d9 f5 ff ff       	call   8001e5 <cputchar>
			buf[i++] = c;
  800c0c:	88 9e 00 50 80 00    	mov    %bl,0x805000(%esi)
  800c12:	8d 76 01             	lea    0x1(%esi),%esi
  800c15:	eb 86                	jmp    800b9d <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800c17:	83 fb 0d             	cmp    $0xd,%ebx
  800c1a:	74 05                	je     800c21 <readline+0xbf>
  800c1c:	83 fb 0a             	cmp    $0xa,%ebx
  800c1f:	75 1e                	jne    800c3f <readline+0xdd>
			if (echoing)
  800c21:	85 ff                	test   %edi,%edi
  800c23:	74 0c                	je     800c31 <readline+0xcf>
				cputchar('\n');
  800c25:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800c2c:	e8 b4 f5 ff ff       	call   8001e5 <cputchar>
			buf[i] = 0;
  800c31:	c6 86 00 50 80 00 00 	movb   $0x0,0x805000(%esi)
			return buf;
  800c38:	b8 00 50 80 00       	mov    $0x805000,%eax
  800c3d:	eb 18                	jmp    800c57 <readline+0xf5>
		} else if (c == '\t') {
  800c3f:	83 fb 09             	cmp    $0x9,%ebx
  800c42:	0f 85 55 ff ff ff    	jne    800b9d <readline+0x3b>
			i += tab_handler(i);
  800c48:	89 34 24             	mov    %esi,(%esp)
  800c4b:	e8 c0 fd ff ff       	call   800a10 <tab_handler>
  800c50:	01 c6                	add    %eax,%esi
  800c52:	e9 46 ff ff ff       	jmp    800b9d <readline+0x3b>
		}
	}
}
  800c57:	83 c4 1c             	add    $0x1c,%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    
  800c5f:	90                   	nop

00800c60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c66:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6b:	eb 03                	jmp    800c70 <strlen+0x10>
		n++;
  800c6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c74:	75 f7                	jne    800c6d <strlen+0xd>
		n++;
	return n;
}
  800c76:	5d                   	pop    %ebp
  800c77:	c3                   	ret    

00800c78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c81:	b8 00 00 00 00       	mov    $0x0,%eax
  800c86:	eb 03                	jmp    800c8b <strnlen+0x13>
		n++;
  800c88:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8b:	39 d0                	cmp    %edx,%eax
  800c8d:	74 06                	je     800c95 <strnlen+0x1d>
  800c8f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c93:	75 f3                	jne    800c88 <strnlen+0x10>
		n++;
	return n;
}
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	53                   	push   %ebx
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ca1:	89 c2                	mov    %eax,%edx
  800ca3:	83 c2 01             	add    $0x1,%edx
  800ca6:	83 c1 01             	add    $0x1,%ecx
  800ca9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800cad:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cb0:	84 db                	test   %bl,%bl
  800cb2:	75 ef                	jne    800ca3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800cb4:	5b                   	pop    %ebx
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cc1:	89 1c 24             	mov    %ebx,(%esp)
  800cc4:	e8 97 ff ff ff       	call   800c60 <strlen>
	strcpy(dst + len, src);
  800cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800cd0:	01 d8                	add    %ebx,%eax
  800cd2:	89 04 24             	mov    %eax,(%esp)
  800cd5:	e8 bd ff ff ff       	call   800c97 <strcpy>
	return dst;
}
  800cda:	89 d8                	mov    %ebx,%eax
  800cdc:	83 c4 08             	add    $0x8,%esp
  800cdf:	5b                   	pop    %ebx
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	8b 75 08             	mov    0x8(%ebp),%esi
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ced:	89 f3                	mov    %esi,%ebx
  800cef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf2:	89 f2                	mov    %esi,%edx
  800cf4:	eb 0f                	jmp    800d05 <strncpy+0x23>
		*dst++ = *src;
  800cf6:	83 c2 01             	add    $0x1,%edx
  800cf9:	0f b6 01             	movzbl (%ecx),%eax
  800cfc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cff:	80 39 01             	cmpb   $0x1,(%ecx)
  800d02:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d05:	39 da                	cmp    %ebx,%edx
  800d07:	75 ed                	jne    800cf6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d09:	89 f0                	mov    %esi,%eax
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	8b 75 08             	mov    0x8(%ebp),%esi
  800d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d1d:	89 f0                	mov    %esi,%eax
  800d1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d23:	85 c9                	test   %ecx,%ecx
  800d25:	75 0b                	jne    800d32 <strlcpy+0x23>
  800d27:	eb 1d                	jmp    800d46 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d29:	83 c0 01             	add    $0x1,%eax
  800d2c:	83 c2 01             	add    $0x1,%edx
  800d2f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d32:	39 d8                	cmp    %ebx,%eax
  800d34:	74 0b                	je     800d41 <strlcpy+0x32>
  800d36:	0f b6 0a             	movzbl (%edx),%ecx
  800d39:	84 c9                	test   %cl,%cl
  800d3b:	75 ec                	jne    800d29 <strlcpy+0x1a>
  800d3d:	89 c2                	mov    %eax,%edx
  800d3f:	eb 02                	jmp    800d43 <strlcpy+0x34>
  800d41:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d43:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d46:	29 f0                	sub    %esi,%eax
}
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d55:	eb 06                	jmp    800d5d <strcmp+0x11>
		p++, q++;
  800d57:	83 c1 01             	add    $0x1,%ecx
  800d5a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d5d:	0f b6 01             	movzbl (%ecx),%eax
  800d60:	84 c0                	test   %al,%al
  800d62:	74 04                	je     800d68 <strcmp+0x1c>
  800d64:	3a 02                	cmp    (%edx),%al
  800d66:	74 ef                	je     800d57 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	0f b6 c0             	movzbl %al,%eax
  800d6b:	0f b6 12             	movzbl (%edx),%edx
  800d6e:	29 d0                	sub    %edx,%eax
}
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    

00800d72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	53                   	push   %ebx
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7c:	89 c3                	mov    %eax,%ebx
  800d7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d81:	eb 06                	jmp    800d89 <strncmp+0x17>
		n--, p++, q++;
  800d83:	83 c0 01             	add    $0x1,%eax
  800d86:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d89:	39 d8                	cmp    %ebx,%eax
  800d8b:	74 15                	je     800da2 <strncmp+0x30>
  800d8d:	0f b6 08             	movzbl (%eax),%ecx
  800d90:	84 c9                	test   %cl,%cl
  800d92:	74 04                	je     800d98 <strncmp+0x26>
  800d94:	3a 0a                	cmp    (%edx),%cl
  800d96:	74 eb                	je     800d83 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d98:	0f b6 00             	movzbl (%eax),%eax
  800d9b:	0f b6 12             	movzbl (%edx),%edx
  800d9e:	29 d0                	sub    %edx,%eax
  800da0:	eb 05                	jmp    800da7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800da7:	5b                   	pop    %ebx
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800db4:	eb 07                	jmp    800dbd <strchr+0x13>
		if (*s == c)
  800db6:	38 ca                	cmp    %cl,%dl
  800db8:	74 0f                	je     800dc9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dba:	83 c0 01             	add    $0x1,%eax
  800dbd:	0f b6 10             	movzbl (%eax),%edx
  800dc0:	84 d2                	test   %dl,%dl
  800dc2:	75 f2                	jne    800db6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dd5:	eb 07                	jmp    800dde <strfind+0x13>
		if (*s == c)
  800dd7:	38 ca                	cmp    %cl,%dl
  800dd9:	74 0a                	je     800de5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ddb:	83 c0 01             	add    $0x1,%eax
  800dde:	0f b6 10             	movzbl (%eax),%edx
  800de1:	84 d2                	test   %dl,%dl
  800de3:	75 f2                	jne    800dd7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
  800ded:	8b 7d 08             	mov    0x8(%ebp),%edi
  800df0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800df3:	85 c9                	test   %ecx,%ecx
  800df5:	74 36                	je     800e2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800df7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dfd:	75 28                	jne    800e27 <memset+0x40>
  800dff:	f6 c1 03             	test   $0x3,%cl
  800e02:	75 23                	jne    800e27 <memset+0x40>
		c &= 0xFF;
  800e04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e08:	89 d3                	mov    %edx,%ebx
  800e0a:	c1 e3 08             	shl    $0x8,%ebx
  800e0d:	89 d6                	mov    %edx,%esi
  800e0f:	c1 e6 18             	shl    $0x18,%esi
  800e12:	89 d0                	mov    %edx,%eax
  800e14:	c1 e0 10             	shl    $0x10,%eax
  800e17:	09 f0                	or     %esi,%eax
  800e19:	09 c2                	or     %eax,%edx
  800e1b:	89 d0                	mov    %edx,%eax
  800e1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800e22:	fc                   	cld    
  800e23:	f3 ab                	rep stos %eax,%es:(%edi)
  800e25:	eb 06                	jmp    800e2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	fc                   	cld    
  800e2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e2d:	89 f8                	mov    %edi,%eax
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    

00800e34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e42:	39 c6                	cmp    %eax,%esi
  800e44:	73 35                	jae    800e7b <memmove+0x47>
  800e46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e49:	39 d0                	cmp    %edx,%eax
  800e4b:	73 2e                	jae    800e7b <memmove+0x47>
		s += n;
		d += n;
  800e4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e50:	89 d6                	mov    %edx,%esi
  800e52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e5a:	75 13                	jne    800e6f <memmove+0x3b>
  800e5c:	f6 c1 03             	test   $0x3,%cl
  800e5f:	75 0e                	jne    800e6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e61:	83 ef 04             	sub    $0x4,%edi
  800e64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e6a:	fd                   	std    
  800e6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e6d:	eb 09                	jmp    800e78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e6f:	83 ef 01             	sub    $0x1,%edi
  800e72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e75:	fd                   	std    
  800e76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e78:	fc                   	cld    
  800e79:	eb 1d                	jmp    800e98 <memmove+0x64>
  800e7b:	89 f2                	mov    %esi,%edx
  800e7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e7f:	f6 c2 03             	test   $0x3,%dl
  800e82:	75 0f                	jne    800e93 <memmove+0x5f>
  800e84:	f6 c1 03             	test   $0x3,%cl
  800e87:	75 0a                	jne    800e93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e8c:	89 c7                	mov    %eax,%edi
  800e8e:	fc                   	cld    
  800e8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e91:	eb 05                	jmp    800e98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e93:	89 c7                	mov    %eax,%edi
  800e95:	fc                   	cld    
  800e96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 04 24             	mov    %eax,(%esp)
  800eb6:	e8 79 ff ff ff       	call   800e34 <memmove>
}
  800ebb:	c9                   	leave  
  800ebc:	c3                   	ret    

00800ebd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	89 d6                	mov    %edx,%esi
  800eca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ecd:	eb 1a                	jmp    800ee9 <memcmp+0x2c>
		if (*s1 != *s2)
  800ecf:	0f b6 02             	movzbl (%edx),%eax
  800ed2:	0f b6 19             	movzbl (%ecx),%ebx
  800ed5:	38 d8                	cmp    %bl,%al
  800ed7:	74 0a                	je     800ee3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ed9:	0f b6 c0             	movzbl %al,%eax
  800edc:	0f b6 db             	movzbl %bl,%ebx
  800edf:	29 d8                	sub    %ebx,%eax
  800ee1:	eb 0f                	jmp    800ef2 <memcmp+0x35>
		s1++, s2++;
  800ee3:	83 c2 01             	add    $0x1,%edx
  800ee6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ee9:	39 f2                	cmp    %esi,%edx
  800eeb:	75 e2                	jne    800ecf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eff:	89 c2                	mov    %eax,%edx
  800f01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f04:	eb 07                	jmp    800f0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f06:	38 08                	cmp    %cl,(%eax)
  800f08:	74 07                	je     800f11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f0a:	83 c0 01             	add    $0x1,%eax
  800f0d:	39 d0                	cmp    %edx,%eax
  800f0f:	72 f5                	jb     800f06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1f:	eb 03                	jmp    800f24 <strtol+0x11>
		s++;
  800f21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f24:	0f b6 0a             	movzbl (%edx),%ecx
  800f27:	80 f9 09             	cmp    $0x9,%cl
  800f2a:	74 f5                	je     800f21 <strtol+0xe>
  800f2c:	80 f9 20             	cmp    $0x20,%cl
  800f2f:	74 f0                	je     800f21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f31:	80 f9 2b             	cmp    $0x2b,%cl
  800f34:	75 0a                	jne    800f40 <strtol+0x2d>
		s++;
  800f36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f39:	bf 00 00 00 00       	mov    $0x0,%edi
  800f3e:	eb 11                	jmp    800f51 <strtol+0x3e>
  800f40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f45:	80 f9 2d             	cmp    $0x2d,%cl
  800f48:	75 07                	jne    800f51 <strtol+0x3e>
		s++, neg = 1;
  800f4a:	8d 52 01             	lea    0x1(%edx),%edx
  800f4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f56:	75 15                	jne    800f6d <strtol+0x5a>
  800f58:	80 3a 30             	cmpb   $0x30,(%edx)
  800f5b:	75 10                	jne    800f6d <strtol+0x5a>
  800f5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f61:	75 0a                	jne    800f6d <strtol+0x5a>
		s += 2, base = 16;
  800f63:	83 c2 02             	add    $0x2,%edx
  800f66:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6b:	eb 10                	jmp    800f7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 0c                	jne    800f7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f73:	80 3a 30             	cmpb   $0x30,(%edx)
  800f76:	75 05                	jne    800f7d <strtol+0x6a>
		s++, base = 8;
  800f78:	83 c2 01             	add    $0x1,%edx
  800f7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f85:	0f b6 0a             	movzbl (%edx),%ecx
  800f88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f8b:	89 f0                	mov    %esi,%eax
  800f8d:	3c 09                	cmp    $0x9,%al
  800f8f:	77 08                	ja     800f99 <strtol+0x86>
			dig = *s - '0';
  800f91:	0f be c9             	movsbl %cl,%ecx
  800f94:	83 e9 30             	sub    $0x30,%ecx
  800f97:	eb 20                	jmp    800fb9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800f99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800f9c:	89 f0                	mov    %esi,%eax
  800f9e:	3c 19                	cmp    $0x19,%al
  800fa0:	77 08                	ja     800faa <strtol+0x97>
			dig = *s - 'a' + 10;
  800fa2:	0f be c9             	movsbl %cl,%ecx
  800fa5:	83 e9 57             	sub    $0x57,%ecx
  800fa8:	eb 0f                	jmp    800fb9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800faa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800fad:	89 f0                	mov    %esi,%eax
  800faf:	3c 19                	cmp    $0x19,%al
  800fb1:	77 16                	ja     800fc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800fb3:	0f be c9             	movsbl %cl,%ecx
  800fb6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800fb9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800fbc:	7d 0f                	jge    800fcd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800fbe:	83 c2 01             	add    $0x1,%edx
  800fc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800fc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800fc7:	eb bc                	jmp    800f85 <strtol+0x72>
  800fc9:	89 d8                	mov    %ebx,%eax
  800fcb:	eb 02                	jmp    800fcf <strtol+0xbc>
  800fcd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800fcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fd3:	74 05                	je     800fda <strtol+0xc7>
		*endptr = (char *) s;
  800fd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800fda:	f7 d8                	neg    %eax
  800fdc:	85 ff                	test   %edi,%edi
  800fde:	0f 44 c3             	cmove  %ebx,%eax
}
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fec:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	89 c3                	mov    %eax,%ebx
  800ff9:	89 c7                	mov    %eax,%edi
  800ffb:	89 c6                	mov    %eax,%esi
  800ffd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    

00801004 <sys_cgetc>:

int
sys_cgetc(void)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	57                   	push   %edi
  801008:	56                   	push   %esi
  801009:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100a:	ba 00 00 00 00       	mov    $0x0,%edx
  80100f:	b8 01 00 00 00       	mov    $0x1,%eax
  801014:	89 d1                	mov    %edx,%ecx
  801016:	89 d3                	mov    %edx,%ebx
  801018:	89 d7                	mov    %edx,%edi
  80101a:	89 d6                	mov    %edx,%esi
  80101c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  801031:	b8 03 00 00 00       	mov    $0x3,%eax
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
  801043:	7e 28                	jle    80106d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801045:	89 44 24 10          	mov    %eax,0x10(%esp)
  801049:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801050:	00 
  801051:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801058:	00 
  801059:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801060:	00 
  801061:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  801068:	e8 be f2 ff ff       	call   80032b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80106d:	83 c4 2c             	add    $0x2c,%esp
  801070:	5b                   	pop    %ebx
  801071:	5e                   	pop    %esi
  801072:	5f                   	pop    %edi
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    

00801075 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	57                   	push   %edi
  801079:	56                   	push   %esi
  80107a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107b:	ba 00 00 00 00       	mov    $0x0,%edx
  801080:	b8 02 00 00 00       	mov    $0x2,%eax
  801085:	89 d1                	mov    %edx,%ecx
  801087:	89 d3                	mov    %edx,%ebx
  801089:	89 d7                	mov    %edx,%edi
  80108b:	89 d6                	mov    %edx,%esi
  80108d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    

00801094 <sys_yield>:

void
sys_yield(void)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109a:	ba 00 00 00 00       	mov    $0x0,%edx
  80109f:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010a4:	89 d1                	mov    %edx,%ecx
  8010a6:	89 d3                	mov    %edx,%ebx
  8010a8:	89 d7                	mov    %edx,%edi
  8010aa:	89 d6                	mov    %edx,%esi
  8010ac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bc:	be 00 00 00 00       	mov    $0x0,%esi
  8010c1:	b8 04 00 00 00       	mov    $0x4,%eax
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010cf:	89 f7                	mov    %esi,%edi
  8010d1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	7e 28                	jle    8010ff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010db:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010e2:	00 
  8010e3:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  8010ea:	00 
  8010eb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f2:	00 
  8010f3:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  8010fa:	e8 2c f2 ff ff       	call   80032b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010ff:	83 c4 2c             	add    $0x2c,%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
  80110d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801110:	b8 05 00 00 00       	mov    $0x5,%eax
  801115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80111e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801121:	8b 75 18             	mov    0x18(%ebp),%esi
  801124:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801126:	85 c0                	test   %eax,%eax
  801128:	7e 28                	jle    801152 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80112a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80112e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801135:	00 
  801136:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  80113d:	00 
  80113e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801145:	00 
  801146:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  80114d:	e8 d9 f1 ff ff       	call   80032b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801152:	83 c4 2c             	add    $0x2c,%esp
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    

0080115a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	57                   	push   %edi
  80115e:	56                   	push   %esi
  80115f:	53                   	push   %ebx
  801160:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801163:	bb 00 00 00 00       	mov    $0x0,%ebx
  801168:	b8 06 00 00 00       	mov    $0x6,%eax
  80116d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801170:	8b 55 08             	mov    0x8(%ebp),%edx
  801173:	89 df                	mov    %ebx,%edi
  801175:	89 de                	mov    %ebx,%esi
  801177:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801179:	85 c0                	test   %eax,%eax
  80117b:	7e 28                	jle    8011a5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80117d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801181:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801188:	00 
  801189:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801190:	00 
  801191:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801198:	00 
  801199:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  8011a0:	e8 86 f1 ff ff       	call   80032b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011a5:	83 c4 2c             	add    $0x2c,%esp
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    

008011ad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	57                   	push   %edi
  8011b1:	56                   	push   %esi
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8011c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	89 df                	mov    %ebx,%edi
  8011c8:	89 de                	mov    %ebx,%esi
  8011ca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	7e 28                	jle    8011f8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8011db:	00 
  8011dc:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  8011f3:	e8 33 f1 ff ff       	call   80032b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011f8:	83 c4 2c             	add    $0x2c,%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	57                   	push   %edi
  801204:	56                   	push   %esi
  801205:	53                   	push   %ebx
  801206:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801209:	bb 00 00 00 00       	mov    $0x0,%ebx
  80120e:	b8 09 00 00 00       	mov    $0x9,%eax
  801213:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801216:	8b 55 08             	mov    0x8(%ebp),%edx
  801219:	89 df                	mov    %ebx,%edi
  80121b:	89 de                	mov    %ebx,%esi
  80121d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80121f:	85 c0                	test   %eax,%eax
  801221:	7e 28                	jle    80124b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801223:	89 44 24 10          	mov    %eax,0x10(%esp)
  801227:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80122e:	00 
  80122f:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801236:	00 
  801237:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80123e:	00 
  80123f:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  801246:	e8 e0 f0 ff ff       	call   80032b <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80124b:	83 c4 2c             	add    $0x2c,%esp
  80124e:	5b                   	pop    %ebx
  80124f:	5e                   	pop    %esi
  801250:	5f                   	pop    %edi
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	57                   	push   %edi
  801257:	56                   	push   %esi
  801258:	53                   	push   %ebx
  801259:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801261:	b8 0a 00 00 00       	mov    $0xa,%eax
  801266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801269:	8b 55 08             	mov    0x8(%ebp),%edx
  80126c:	89 df                	mov    %ebx,%edi
  80126e:	89 de                	mov    %ebx,%esi
  801270:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801272:	85 c0                	test   %eax,%eax
  801274:	7e 28                	jle    80129e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801276:	89 44 24 10          	mov    %eax,0x10(%esp)
  80127a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801281:	00 
  801282:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801289:	00 
  80128a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801291:	00 
  801292:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  801299:	e8 8d f0 ff ff       	call   80032b <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80129e:	83 c4 2c             	add    $0x2c,%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    

008012a6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	57                   	push   %edi
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ac:	be 00 00 00 00       	mov    $0x0,%esi
  8012b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012c2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012c4:	5b                   	pop    %ebx
  8012c5:	5e                   	pop    %esi
  8012c6:	5f                   	pop    %edi
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    

008012c9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	57                   	push   %edi
  8012cd:	56                   	push   %esi
  8012ce:	53                   	push   %ebx
  8012cf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012df:	89 cb                	mov    %ecx,%ebx
  8012e1:	89 cf                	mov    %ecx,%edi
  8012e3:	89 ce                	mov    %ecx,%esi
  8012e5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	7e 28                	jle    801313 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8012f6:	00 
  8012f7:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801306:	00 
  801307:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  80130e:	e8 18 f0 ff ff       	call   80032b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801313:	83 c4 2c             	add    $0x2c,%esp
  801316:	5b                   	pop    %ebx
  801317:	5e                   	pop    %esi
  801318:	5f                   	pop    %edi
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    

0080131b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	57                   	push   %edi
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801321:	ba 00 00 00 00       	mov    $0x0,%edx
  801326:	b8 0e 00 00 00       	mov    $0xe,%eax
  80132b:	89 d1                	mov    %edx,%ecx
  80132d:	89 d3                	mov    %edx,%ebx
  80132f:	89 d7                	mov    %edx,%edi
  801331:	89 d6                	mov    %edx,%esi
  801333:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801335:	5b                   	pop    %ebx
  801336:	5e                   	pop    %esi
  801337:	5f                   	pop    %edi
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    

0080133a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	57                   	push   %edi
  80133e:	56                   	push   %esi
  80133f:	53                   	push   %ebx
  801340:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801343:	bb 00 00 00 00       	mov    $0x0,%ebx
  801348:	b8 0f 00 00 00       	mov    $0xf,%eax
  80134d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801350:	8b 55 08             	mov    0x8(%ebp),%edx
  801353:	89 df                	mov    %ebx,%edi
  801355:	89 de                	mov    %ebx,%esi
  801357:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801359:	85 c0                	test   %eax,%eax
  80135b:	7e 28                	jle    801385 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80135d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801361:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801368:	00 
  801369:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801370:	00 
  801371:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801378:	00 
  801379:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  801380:	e8 a6 ef ff ff       	call   80032b <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801385:	83 c4 2c             	add    $0x2c,%esp
  801388:	5b                   	pop    %ebx
  801389:	5e                   	pop    %esi
  80138a:	5f                   	pop    %edi
  80138b:	5d                   	pop    %ebp
  80138c:	c3                   	ret    

0080138d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	57                   	push   %edi
  801391:	56                   	push   %esi
  801392:	53                   	push   %ebx
  801393:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801396:	bb 00 00 00 00       	mov    $0x0,%ebx
  80139b:	b8 10 00 00 00       	mov    $0x10,%eax
  8013a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a6:	89 df                	mov    %ebx,%edi
  8013a8:	89 de                	mov    %ebx,%esi
  8013aa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	7e 28                	jle    8013d8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013b4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8013bb:	00 
  8013bc:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  8013c3:	00 
  8013c4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013cb:	00 
  8013cc:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  8013d3:	e8 53 ef ff ff       	call   80032b <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8013d8:	83 c4 2c             	add    $0x2c,%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5f                   	pop    %edi
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	57                   	push   %edi
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ee:	b8 11 00 00 00       	mov    $0x11,%eax
  8013f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f9:	89 df                	mov    %ebx,%edi
  8013fb:	89 de                	mov    %ebx,%esi
  8013fd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013ff:	85 c0                	test   %eax,%eax
  801401:	7e 28                	jle    80142b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801403:	89 44 24 10          	mov    %eax,0x10(%esp)
  801407:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80140e:	00 
  80140f:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801416:	00 
  801417:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80141e:	00 
  80141f:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  801426:	e8 00 ef ff ff       	call   80032b <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80142b:	83 c4 2c             	add    $0x2c,%esp
  80142e:	5b                   	pop    %ebx
  80142f:	5e                   	pop    %esi
  801430:	5f                   	pop    %edi
  801431:	5d                   	pop    %ebp
  801432:	c3                   	ret    

00801433 <sys_sleep>:

int
sys_sleep(int channel)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	57                   	push   %edi
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
  801439:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80143c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801441:	b8 12 00 00 00       	mov    $0x12,%eax
  801446:	8b 55 08             	mov    0x8(%ebp),%edx
  801449:	89 cb                	mov    %ecx,%ebx
  80144b:	89 cf                	mov    %ecx,%edi
  80144d:	89 ce                	mov    %ecx,%esi
  80144f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801451:	85 c0                	test   %eax,%eax
  801453:	7e 28                	jle    80147d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801455:	89 44 24 10          	mov    %eax,0x10(%esp)
  801459:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801460:	00 
  801461:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801468:	00 
  801469:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801470:	00 
  801471:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  801478:	e8 ae ee ff ff       	call   80032b <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80147d:	83 c4 2c             	add    $0x2c,%esp
  801480:	5b                   	pop    %ebx
  801481:	5e                   	pop    %esi
  801482:	5f                   	pop    %edi
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	57                   	push   %edi
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80148e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801493:	b8 13 00 00 00       	mov    $0x13,%eax
  801498:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80149b:	8b 55 08             	mov    0x8(%ebp),%edx
  80149e:	89 df                	mov    %ebx,%edi
  8014a0:	89 de                	mov    %ebx,%esi
  8014a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	7e 28                	jle    8014d0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ac:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8014b3:	00 
  8014b4:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  8014bb:	00 
  8014bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014c3:	00 
  8014c4:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  8014cb:	e8 5b ee ff ff       	call   80032b <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8014d0:	83 c4 2c             	add    $0x2c,%esp
  8014d3:	5b                   	pop    %ebx
  8014d4:	5e                   	pop    %esi
  8014d5:	5f                   	pop    %edi
  8014d6:	5d                   	pop    %ebp
  8014d7:	c3                   	ret    
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
  8015cf:	8b 04 95 8c 30 80 00 	mov    0x80308c(,%edx,4),%eax
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	75 e2                	jne    8015bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015da:	a1 08 54 80 00       	mov    0x805408,%eax
  8015df:	8b 40 48             	mov    0x48(%eax),%eax
  8015e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ea:	c7 04 24 10 30 80 00 	movl   $0x803010,(%esp)
  8015f1:	e8 2e ee ff ff       	call   800424 <cprintf>
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
  801679:	e8 dc fa ff ff       	call   80115a <sys_page_unmap>
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
  801777:	e8 8b f9 ff ff       	call   801107 <sys_page_map>
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
  8017b2:	e8 50 f9 ff ff       	call   801107 <sys_page_map>
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
  8017cb:	e8 8a f9 ff ff       	call   80115a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017db:	e8 7a f9 ff ff       	call   80115a <sys_page_unmap>
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
  80182f:	a1 08 54 80 00       	mov    0x805408,%eax
  801834:	8b 40 48             	mov    0x48(%eax),%eax
  801837:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80183b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183f:	c7 04 24 51 30 80 00 	movl   $0x803051,(%esp)
  801846:	e8 d9 eb ff ff       	call   800424 <cprintf>
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
  801907:	a1 08 54 80 00       	mov    0x805408,%eax
  80190c:	8b 40 48             	mov    0x48(%eax),%eax
  80190f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801913:	89 44 24 04          	mov    %eax,0x4(%esp)
  801917:	c7 04 24 6d 30 80 00 	movl   $0x80306d,(%esp)
  80191e:	e8 01 eb ff ff       	call   800424 <cprintf>
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
  8019c0:	a1 08 54 80 00       	mov    0x805408,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019c5:	8b 40 48             	mov    0x48(%eax),%eax
  8019c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d0:	c7 04 24 30 30 80 00 	movl   $0x803030,(%esp)
  8019d7:	e8 48 ea ff ff       	call   800424 <cprintf>
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
  801acf:	83 3d 00 54 80 00 00 	cmpl   $0x0,0x805400
  801ad6:	75 11                	jne    801ae9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ad8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801adf:	e8 fb 0c 00 00       	call   8027df <ipc_find_env>
  801ae4:	a3 00 54 80 00       	mov    %eax,0x805400
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ae9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801af0:	00 
  801af1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801af8:	00 
  801af9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801afd:	a1 00 54 80 00       	mov    0x805400,%eax
  801b02:	89 04 24             	mov    %eax,(%esp)
  801b05:	e8 6a 0c 00 00       	call   802774 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b11:	00 
  801b12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1d:	e8 fe 0b 00 00       	call   802720 <ipc_recv>
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
  801baa:	e8 e8 f0 ff ff       	call   800c97 <strcpy>
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
  801bfc:	e8 9b f2 ff ff       	call   800e9c <memcpy>

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
  801c47:	c7 44 24 0c a0 30 80 	movl   $0x8030a0,0xc(%esp)
  801c4e:	00 
  801c4f:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  801c56:	00 
  801c57:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c5e:	00 
  801c5f:	c7 04 24 bc 30 80 00 	movl   $0x8030bc,(%esp)
  801c66:	e8 c0 e6 ff ff       	call   80032b <_panic>
	assert(r <= PGSIZE);
  801c6b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c70:	7e 24                	jle    801c96 <devfile_read+0x84>
  801c72:	c7 44 24 0c c7 30 80 	movl   $0x8030c7,0xc(%esp)
  801c79:	00 
  801c7a:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  801c81:	00 
  801c82:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c89:	00 
  801c8a:	c7 04 24 bc 30 80 00 	movl   $0x8030bc,(%esp)
  801c91:	e8 95 e6 ff ff       	call   80032b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c9a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ca1:	00 
  801ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca5:	89 04 24             	mov    %eax,(%esp)
  801ca8:	e8 87 f1 ff ff       	call   800e34 <memmove>
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
  801cc3:	e8 98 ef ff ff       	call   800c60 <strlen>
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
  801ceb:	e8 a7 ef ff ff       	call   800c97 <strcpy>
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

00801d51 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	53                   	push   %ebx
  801d55:	83 ec 14             	sub    $0x14,%esp
  801d58:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801d5a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801d5e:	7e 31                	jle    801d91 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801d60:	8b 40 04             	mov    0x4(%eax),%eax
  801d63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d67:	8d 43 10             	lea    0x10(%ebx),%eax
  801d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6e:	8b 03                	mov    (%ebx),%eax
  801d70:	89 04 24             	mov    %eax,(%esp)
  801d73:	e8 4f fb ff ff       	call   8018c7 <write>
		if (result > 0)
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	7e 03                	jle    801d7f <writebuf+0x2e>
			b->result += result;
  801d7c:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801d7f:	39 43 04             	cmp    %eax,0x4(%ebx)
  801d82:	74 0d                	je     801d91 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801d84:	85 c0                	test   %eax,%eax
  801d86:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8b:	0f 4f c2             	cmovg  %edx,%eax
  801d8e:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801d91:	83 c4 14             	add    $0x14,%esp
  801d94:	5b                   	pop    %ebx
  801d95:	5d                   	pop    %ebp
  801d96:	c3                   	ret    

00801d97 <putch>:

static void
putch(int ch, void *thunk)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	53                   	push   %ebx
  801d9b:	83 ec 04             	sub    $0x4,%esp
  801d9e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801da1:	8b 53 04             	mov    0x4(%ebx),%edx
  801da4:	8d 42 01             	lea    0x1(%edx),%eax
  801da7:	89 43 04             	mov    %eax,0x4(%ebx)
  801daa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dad:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801db1:	3d 00 01 00 00       	cmp    $0x100,%eax
  801db6:	75 0e                	jne    801dc6 <putch+0x2f>
		writebuf(b);
  801db8:	89 d8                	mov    %ebx,%eax
  801dba:	e8 92 ff ff ff       	call   801d51 <writebuf>
		b->idx = 0;
  801dbf:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801dc6:	83 c4 04             	add    $0x4,%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    

00801dcc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801dde:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801de5:	00 00 00 
	b.result = 0;
  801de8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801def:	00 00 00 
	b.error = 1;
  801df2:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801df9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801dfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801dff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e0a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e14:	c7 04 24 97 1d 80 00 	movl   $0x801d97,(%esp)
  801e1b:	e8 8e e7 ff ff       	call   8005ae <vprintfmt>
	if (b.idx > 0)
  801e20:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801e27:	7e 0b                	jle    801e34 <vfprintf+0x68>
		writebuf(&b);
  801e29:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801e2f:	e8 1d ff ff ff       	call   801d51 <writebuf>

	return (b.result ? b.result : b.error);
  801e34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801e4b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801e4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	89 04 24             	mov    %eax,(%esp)
  801e5f:	e8 68 ff ff ff       	call   801dcc <vfprintf>
	va_end(ap);

	return cnt;
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <printf>:

int
printf(const char *fmt, ...)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801e6c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801e6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e81:	e8 46 ff ff ff       	call   801dcc <vfprintf>
	va_end(ap);

	return cnt;
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    
  801e88:	66 90                	xchg   %ax,%ax
  801e8a:	66 90                	xchg   %ax,%ax
  801e8c:	66 90                	xchg   %ax,%ax
  801e8e:	66 90                	xchg   %ax,%ax

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
  801e96:	c7 44 24 04 d3 30 80 	movl   $0x8030d3,0x4(%esp)
  801e9d:	00 
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 04 24             	mov    %eax,(%esp)
  801ea4:	e8 ee ed ff ff       	call   800c97 <strcpy>
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
  801ebd:	e8 5c 09 00 00       	call   80281e <pageref>
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
  801f49:	e8 08 f6 ff ff       	call   801556 <fd_lookup>
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 17                	js     801f69 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
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
  801f7b:	e8 87 f5 ff ff       	call   801507 <fd_alloc>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	85 c0                	test   %eax,%eax
  801f84:	78 21                	js     801fa7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f8d:	00 
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f9c:	e8 12 f1 ff ff       	call   8010b3 <sys_page_alloc>
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
  801fb3:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801fc8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801fcb:	89 14 24             	mov    %edx,(%esp)
  801fce:	e8 0d f5 ff ff       	call   8014e0 <fd2num>
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
  8020ec:	83 3d 04 54 80 00 00 	cmpl   $0x0,0x805404
  8020f3:	75 11                	jne    802106 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020fc:	e8 de 06 00 00       	call   8027df <ipc_find_env>
  802101:	a3 04 54 80 00       	mov    %eax,0x805404
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802106:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80210d:	00 
  80210e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802115:	00 
  802116:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80211a:	a1 04 54 80 00       	mov    0x805404,%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 4d 06 00 00       	call   802774 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802127:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80212e:	00 
  80212f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802136:	00 
  802137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213e:	e8 dd 05 00 00       	call   802720 <ipc_recv>
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
  80218a:	e8 a5 ec ff ff       	call   800e34 <memmove>
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
  8021c3:	e8 6c ec ff ff       	call   800e34 <memmove>
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
  80223e:	e8 f1 eb ff ff       	call   800e34 <memmove>
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
  8022b7:	c7 44 24 0c df 30 80 	movl   $0x8030df,0xc(%esp)
  8022be:	00 
  8022bf:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  8022c6:	00 
  8022c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022ce:	00 
  8022cf:	c7 04 24 f4 30 80 00 	movl   $0x8030f4,(%esp)
  8022d6:	e8 50 e0 ff ff       	call   80032b <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022df:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022e6:	00 
  8022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ea:	89 04 24             	mov    %eax,(%esp)
  8022ed:	e8 42 eb ff ff       	call   800e34 <memmove>
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
  802315:	c7 44 24 0c 00 31 80 	movl   $0x803100,0xc(%esp)
  80231c:	00 
  80231d:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  802324:	00 
  802325:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80232c:	00 
  80232d:	c7 04 24 f4 30 80 00 	movl   $0x8030f4,(%esp)
  802334:	e8 f2 df ff ff       	call   80032b <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802339:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80233d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802340:	89 44 24 04          	mov    %eax,0x4(%esp)
  802344:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80234b:	e8 e4 ea ff ff       	call   800e34 <memmove>
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
  8023a9:	e8 42 f1 ff ff       	call   8014f0 <fd2data>
  8023ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023b0:	c7 44 24 04 0c 31 80 	movl   $0x80310c,0x4(%esp)
  8023b7:	00 
  8023b8:	89 1c 24             	mov    %ebx,(%esp)
  8023bb:	e8 d7 e8 ff ff       	call   800c97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023c0:	8b 46 04             	mov    0x4(%esi),%eax
  8023c3:	2b 06                	sub    (%esi),%eax
  8023c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023d2:	00 00 00 
	stat->st_dev = &devpipe;
  8023d5:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
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
  802400:	e8 55 ed ff ff       	call   80115a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802405:	89 1c 24             	mov    %ebx,(%esp)
  802408:	e8 e3 f0 ff ff       	call   8014f0 <fd2data>
  80240d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802411:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802418:	e8 3d ed ff ff       	call   80115a <sys_page_unmap>
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
  802431:	a1 08 54 80 00       	mov    0x805408,%eax
  802436:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802439:	89 34 24             	mov    %esi,(%esp)
  80243c:	e8 dd 03 00 00       	call   80281e <pageref>
  802441:	89 c7                	mov    %eax,%edi
  802443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 d0 03 00 00       	call   80281e <pageref>
  80244e:	39 c7                	cmp    %eax,%edi
  802450:	0f 94 c2             	sete   %dl
  802453:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802456:	8b 0d 08 54 80 00    	mov    0x805408,%ecx
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
  802476:	c7 04 24 13 31 80 00 	movl   $0x803113,(%esp)
  80247d:	e8 a2 df ff ff       	call   800424 <cprintf>
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
  80249b:	e8 50 f0 ff ff       	call   8014f0 <fd2data>
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
  8024b6:	e8 d9 eb ff ff       	call   801094 <sys_yield>
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
  802513:	e8 d8 ef ff ff       	call   8014f0 <fd2data>
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
  802536:	e8 59 eb ff ff       	call   801094 <sys_yield>
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
  802582:	e8 80 ef ff ff       	call   801507 <fd_alloc>
  802587:	89 c2                	mov    %eax,%edx
  802589:	85 d2                	test   %edx,%edx
  80258b:	0f 88 4d 01 00 00    	js     8026de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802591:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802598:	00 
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a7:	e8 07 eb ff ff       	call   8010b3 <sys_page_alloc>
  8025ac:	89 c2                	mov    %eax,%edx
  8025ae:	85 d2                	test   %edx,%edx
  8025b0:	0f 88 28 01 00 00    	js     8026de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025b9:	89 04 24             	mov    %eax,(%esp)
  8025bc:	e8 46 ef ff ff       	call   801507 <fd_alloc>
  8025c1:	89 c3                	mov    %eax,%ebx
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	0f 88 fe 00 00 00    	js     8026c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025d2:	00 
  8025d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e1:	e8 cd ea ff ff       	call   8010b3 <sys_page_alloc>
  8025e6:	89 c3                	mov    %eax,%ebx
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	0f 88 d9 00 00 00    	js     8026c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	89 04 24             	mov    %eax,(%esp)
  8025f6:	e8 f5 ee ff ff       	call   8014f0 <fd2data>
  8025fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802604:	00 
  802605:	89 44 24 04          	mov    %eax,0x4(%esp)
  802609:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802610:	e8 9e ea ff ff       	call   8010b3 <sys_page_alloc>
  802615:	89 c3                	mov    %eax,%ebx
  802617:	85 c0                	test   %eax,%eax
  802619:	0f 88 97 00 00 00    	js     8026b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	89 04 24             	mov    %eax,(%esp)
  802625:	e8 c6 ee ff ff       	call   8014f0 <fd2data>
  80262a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802631:	00 
  802632:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802636:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80263d:	00 
  80263e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802649:	e8 b9 ea ff ff       	call   801107 <sys_page_map>
  80264e:	89 c3                	mov    %eax,%ebx
  802650:	85 c0                	test   %eax,%eax
  802652:	78 52                	js     8026a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802654:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802669:	8b 15 58 40 80 00    	mov    0x804058,%edx
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
  802684:	e8 57 ee ff ff       	call   8014e0 <fd2num>
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	89 04 24             	mov    %eax,(%esp)
  802694:	e8 47 ee ff ff       	call   8014e0 <fd2num>
  802699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80269c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	eb 38                	jmp    8026de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b1:	e8 a4 ea ff ff       	call   80115a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c4:	e8 91 ea ff ff       	call   80115a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d7:	e8 7e ea ff ff       	call   80115a <sys_page_unmap>
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
  8026f8:	e8 59 ee ff ff       	call   801556 <fd_lookup>
  8026fd:	89 c2                	mov    %eax,%edx
  8026ff:	85 d2                	test   %edx,%edx
  802701:	78 15                	js     802718 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	89 04 24             	mov    %eax,(%esp)
  802709:	e8 e2 ed ff ff       	call   8014f0 <fd2data>
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

00802720 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	56                   	push   %esi
  802724:	53                   	push   %ebx
  802725:	83 ec 10             	sub    $0x10,%esp
  802728:	8b 75 08             	mov    0x8(%ebp),%esi
  80272b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802731:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802733:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802738:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80273b:	89 04 24             	mov    %eax,(%esp)
  80273e:	e8 86 eb ff ff       	call   8012c9 <sys_ipc_recv>
  802743:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802745:	85 d2                	test   %edx,%edx
  802747:	75 24                	jne    80276d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802749:	85 f6                	test   %esi,%esi
  80274b:	74 0a                	je     802757 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80274d:	a1 08 54 80 00       	mov    0x805408,%eax
  802752:	8b 40 74             	mov    0x74(%eax),%eax
  802755:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802757:	85 db                	test   %ebx,%ebx
  802759:	74 0a                	je     802765 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80275b:	a1 08 54 80 00       	mov    0x805408,%eax
  802760:	8b 40 78             	mov    0x78(%eax),%eax
  802763:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802765:	a1 08 54 80 00       	mov    0x805408,%eax
  80276a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80276d:	83 c4 10             	add    $0x10,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    

00802774 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	57                   	push   %edi
  802778:	56                   	push   %esi
  802779:	53                   	push   %ebx
  80277a:	83 ec 1c             	sub    $0x1c,%esp
  80277d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802780:	8b 75 0c             	mov    0xc(%ebp),%esi
  802783:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802786:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802788:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80278d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802790:	8b 45 14             	mov    0x14(%ebp),%eax
  802793:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802797:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80279b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80279f:	89 3c 24             	mov    %edi,(%esp)
  8027a2:	e8 ff ea ff ff       	call   8012a6 <sys_ipc_try_send>

		if (ret == 0)
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	74 2c                	je     8027d7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8027ab:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027ae:	74 20                	je     8027d0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8027b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027b4:	c7 44 24 08 28 31 80 	movl   $0x803128,0x8(%esp)
  8027bb:	00 
  8027bc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8027c3:	00 
  8027c4:	c7 04 24 58 31 80 00 	movl   $0x803158,(%esp)
  8027cb:	e8 5b db ff ff       	call   80032b <_panic>
		}

		sys_yield();
  8027d0:	e8 bf e8 ff ff       	call   801094 <sys_yield>
	}
  8027d5:	eb b9                	jmp    802790 <ipc_send+0x1c>
}
  8027d7:	83 c4 1c             	add    $0x1c,%esp
  8027da:	5b                   	pop    %ebx
  8027db:	5e                   	pop    %esi
  8027dc:	5f                   	pop    %edi
  8027dd:	5d                   	pop    %ebp
  8027de:	c3                   	ret    

008027df <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027df:	55                   	push   %ebp
  8027e0:	89 e5                	mov    %esp,%ebp
  8027e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027e5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027ea:	89 c2                	mov    %eax,%edx
  8027ec:	c1 e2 07             	shl    $0x7,%edx
  8027ef:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8027f6:	8b 52 50             	mov    0x50(%edx),%edx
  8027f9:	39 ca                	cmp    %ecx,%edx
  8027fb:	75 11                	jne    80280e <ipc_find_env+0x2f>
			return envs[i].env_id;
  8027fd:	89 c2                	mov    %eax,%edx
  8027ff:	c1 e2 07             	shl    $0x7,%edx
  802802:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802809:	8b 40 40             	mov    0x40(%eax),%eax
  80280c:	eb 0e                	jmp    80281c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80280e:	83 c0 01             	add    $0x1,%eax
  802811:	3d 00 04 00 00       	cmp    $0x400,%eax
  802816:	75 d2                	jne    8027ea <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802818:	66 b8 00 00          	mov    $0x0,%ax
}
  80281c:	5d                   	pop    %ebp
  80281d:	c3                   	ret    

0080281e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
  802821:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802824:	89 d0                	mov    %edx,%eax
  802826:	c1 e8 16             	shr    $0x16,%eax
  802829:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802830:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802835:	f6 c1 01             	test   $0x1,%cl
  802838:	74 1d                	je     802857 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80283a:	c1 ea 0c             	shr    $0xc,%edx
  80283d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802844:	f6 c2 01             	test   $0x1,%dl
  802847:	74 0e                	je     802857 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802849:	c1 ea 0c             	shr    $0xc,%edx
  80284c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802853:	ef 
  802854:	0f b7 c0             	movzwl %ax,%eax
}
  802857:	5d                   	pop    %ebp
  802858:	c3                   	ret    
  802859:	66 90                	xchg   %ax,%ax
  80285b:	66 90                	xchg   %ax,%ax
  80285d:	66 90                	xchg   %ax,%ax
  80285f:	90                   	nop

00802860 <__udivdi3>:
  802860:	55                   	push   %ebp
  802861:	57                   	push   %edi
  802862:	56                   	push   %esi
  802863:	83 ec 0c             	sub    $0xc,%esp
  802866:	8b 44 24 28          	mov    0x28(%esp),%eax
  80286a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80286e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802872:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802876:	85 c0                	test   %eax,%eax
  802878:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80287c:	89 ea                	mov    %ebp,%edx
  80287e:	89 0c 24             	mov    %ecx,(%esp)
  802881:	75 2d                	jne    8028b0 <__udivdi3+0x50>
  802883:	39 e9                	cmp    %ebp,%ecx
  802885:	77 61                	ja     8028e8 <__udivdi3+0x88>
  802887:	85 c9                	test   %ecx,%ecx
  802889:	89 ce                	mov    %ecx,%esi
  80288b:	75 0b                	jne    802898 <__udivdi3+0x38>
  80288d:	b8 01 00 00 00       	mov    $0x1,%eax
  802892:	31 d2                	xor    %edx,%edx
  802894:	f7 f1                	div    %ecx
  802896:	89 c6                	mov    %eax,%esi
  802898:	31 d2                	xor    %edx,%edx
  80289a:	89 e8                	mov    %ebp,%eax
  80289c:	f7 f6                	div    %esi
  80289e:	89 c5                	mov    %eax,%ebp
  8028a0:	89 f8                	mov    %edi,%eax
  8028a2:	f7 f6                	div    %esi
  8028a4:	89 ea                	mov    %ebp,%edx
  8028a6:	83 c4 0c             	add    $0xc,%esp
  8028a9:	5e                   	pop    %esi
  8028aa:	5f                   	pop    %edi
  8028ab:	5d                   	pop    %ebp
  8028ac:	c3                   	ret    
  8028ad:	8d 76 00             	lea    0x0(%esi),%esi
  8028b0:	39 e8                	cmp    %ebp,%eax
  8028b2:	77 24                	ja     8028d8 <__udivdi3+0x78>
  8028b4:	0f bd e8             	bsr    %eax,%ebp
  8028b7:	83 f5 1f             	xor    $0x1f,%ebp
  8028ba:	75 3c                	jne    8028f8 <__udivdi3+0x98>
  8028bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8028c0:	39 34 24             	cmp    %esi,(%esp)
  8028c3:	0f 86 9f 00 00 00    	jbe    802968 <__udivdi3+0x108>
  8028c9:	39 d0                	cmp    %edx,%eax
  8028cb:	0f 82 97 00 00 00    	jb     802968 <__udivdi3+0x108>
  8028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	31 d2                	xor    %edx,%edx
  8028da:	31 c0                	xor    %eax,%eax
  8028dc:	83 c4 0c             	add    $0xc,%esp
  8028df:	5e                   	pop    %esi
  8028e0:	5f                   	pop    %edi
  8028e1:	5d                   	pop    %ebp
  8028e2:	c3                   	ret    
  8028e3:	90                   	nop
  8028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028e8:	89 f8                	mov    %edi,%eax
  8028ea:	f7 f1                	div    %ecx
  8028ec:	31 d2                	xor    %edx,%edx
  8028ee:	83 c4 0c             	add    $0xc,%esp
  8028f1:	5e                   	pop    %esi
  8028f2:	5f                   	pop    %edi
  8028f3:	5d                   	pop    %ebp
  8028f4:	c3                   	ret    
  8028f5:	8d 76 00             	lea    0x0(%esi),%esi
  8028f8:	89 e9                	mov    %ebp,%ecx
  8028fa:	8b 3c 24             	mov    (%esp),%edi
  8028fd:	d3 e0                	shl    %cl,%eax
  8028ff:	89 c6                	mov    %eax,%esi
  802901:	b8 20 00 00 00       	mov    $0x20,%eax
  802906:	29 e8                	sub    %ebp,%eax
  802908:	89 c1                	mov    %eax,%ecx
  80290a:	d3 ef                	shr    %cl,%edi
  80290c:	89 e9                	mov    %ebp,%ecx
  80290e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802912:	8b 3c 24             	mov    (%esp),%edi
  802915:	09 74 24 08          	or     %esi,0x8(%esp)
  802919:	89 d6                	mov    %edx,%esi
  80291b:	d3 e7                	shl    %cl,%edi
  80291d:	89 c1                	mov    %eax,%ecx
  80291f:	89 3c 24             	mov    %edi,(%esp)
  802922:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802926:	d3 ee                	shr    %cl,%esi
  802928:	89 e9                	mov    %ebp,%ecx
  80292a:	d3 e2                	shl    %cl,%edx
  80292c:	89 c1                	mov    %eax,%ecx
  80292e:	d3 ef                	shr    %cl,%edi
  802930:	09 d7                	or     %edx,%edi
  802932:	89 f2                	mov    %esi,%edx
  802934:	89 f8                	mov    %edi,%eax
  802936:	f7 74 24 08          	divl   0x8(%esp)
  80293a:	89 d6                	mov    %edx,%esi
  80293c:	89 c7                	mov    %eax,%edi
  80293e:	f7 24 24             	mull   (%esp)
  802941:	39 d6                	cmp    %edx,%esi
  802943:	89 14 24             	mov    %edx,(%esp)
  802946:	72 30                	jb     802978 <__udivdi3+0x118>
  802948:	8b 54 24 04          	mov    0x4(%esp),%edx
  80294c:	89 e9                	mov    %ebp,%ecx
  80294e:	d3 e2                	shl    %cl,%edx
  802950:	39 c2                	cmp    %eax,%edx
  802952:	73 05                	jae    802959 <__udivdi3+0xf9>
  802954:	3b 34 24             	cmp    (%esp),%esi
  802957:	74 1f                	je     802978 <__udivdi3+0x118>
  802959:	89 f8                	mov    %edi,%eax
  80295b:	31 d2                	xor    %edx,%edx
  80295d:	e9 7a ff ff ff       	jmp    8028dc <__udivdi3+0x7c>
  802962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802968:	31 d2                	xor    %edx,%edx
  80296a:	b8 01 00 00 00       	mov    $0x1,%eax
  80296f:	e9 68 ff ff ff       	jmp    8028dc <__udivdi3+0x7c>
  802974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802978:	8d 47 ff             	lea    -0x1(%edi),%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	83 c4 0c             	add    $0xc,%esp
  802980:	5e                   	pop    %esi
  802981:	5f                   	pop    %edi
  802982:	5d                   	pop    %ebp
  802983:	c3                   	ret    
  802984:	66 90                	xchg   %ax,%ax
  802986:	66 90                	xchg   %ax,%ax
  802988:	66 90                	xchg   %ax,%ax
  80298a:	66 90                	xchg   %ax,%ax
  80298c:	66 90                	xchg   %ax,%ax
  80298e:	66 90                	xchg   %ax,%ax

00802990 <__umoddi3>:
  802990:	55                   	push   %ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	83 ec 14             	sub    $0x14,%esp
  802996:	8b 44 24 28          	mov    0x28(%esp),%eax
  80299a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80299e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8029a2:	89 c7                	mov    %eax,%edi
  8029a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8029ac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8029b0:	89 34 24             	mov    %esi,(%esp)
  8029b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	89 c2                	mov    %eax,%edx
  8029bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029bf:	75 17                	jne    8029d8 <__umoddi3+0x48>
  8029c1:	39 fe                	cmp    %edi,%esi
  8029c3:	76 4b                	jbe    802a10 <__umoddi3+0x80>
  8029c5:	89 c8                	mov    %ecx,%eax
  8029c7:	89 fa                	mov    %edi,%edx
  8029c9:	f7 f6                	div    %esi
  8029cb:	89 d0                	mov    %edx,%eax
  8029cd:	31 d2                	xor    %edx,%edx
  8029cf:	83 c4 14             	add    $0x14,%esp
  8029d2:	5e                   	pop    %esi
  8029d3:	5f                   	pop    %edi
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
  8029d6:	66 90                	xchg   %ax,%ax
  8029d8:	39 f8                	cmp    %edi,%eax
  8029da:	77 54                	ja     802a30 <__umoddi3+0xa0>
  8029dc:	0f bd e8             	bsr    %eax,%ebp
  8029df:	83 f5 1f             	xor    $0x1f,%ebp
  8029e2:	75 5c                	jne    802a40 <__umoddi3+0xb0>
  8029e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8029e8:	39 3c 24             	cmp    %edi,(%esp)
  8029eb:	0f 87 e7 00 00 00    	ja     802ad8 <__umoddi3+0x148>
  8029f1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029f5:	29 f1                	sub    %esi,%ecx
  8029f7:	19 c7                	sbb    %eax,%edi
  8029f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a01:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a05:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a09:	83 c4 14             	add    $0x14,%esp
  802a0c:	5e                   	pop    %esi
  802a0d:	5f                   	pop    %edi
  802a0e:	5d                   	pop    %ebp
  802a0f:	c3                   	ret    
  802a10:	85 f6                	test   %esi,%esi
  802a12:	89 f5                	mov    %esi,%ebp
  802a14:	75 0b                	jne    802a21 <__umoddi3+0x91>
  802a16:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	f7 f6                	div    %esi
  802a1f:	89 c5                	mov    %eax,%ebp
  802a21:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a25:	31 d2                	xor    %edx,%edx
  802a27:	f7 f5                	div    %ebp
  802a29:	89 c8                	mov    %ecx,%eax
  802a2b:	f7 f5                	div    %ebp
  802a2d:	eb 9c                	jmp    8029cb <__umoddi3+0x3b>
  802a2f:	90                   	nop
  802a30:	89 c8                	mov    %ecx,%eax
  802a32:	89 fa                	mov    %edi,%edx
  802a34:	83 c4 14             	add    $0x14,%esp
  802a37:	5e                   	pop    %esi
  802a38:	5f                   	pop    %edi
  802a39:	5d                   	pop    %ebp
  802a3a:	c3                   	ret    
  802a3b:	90                   	nop
  802a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a40:	8b 04 24             	mov    (%esp),%eax
  802a43:	be 20 00 00 00       	mov    $0x20,%esi
  802a48:	89 e9                	mov    %ebp,%ecx
  802a4a:	29 ee                	sub    %ebp,%esi
  802a4c:	d3 e2                	shl    %cl,%edx
  802a4e:	89 f1                	mov    %esi,%ecx
  802a50:	d3 e8                	shr    %cl,%eax
  802a52:	89 e9                	mov    %ebp,%ecx
  802a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a58:	8b 04 24             	mov    (%esp),%eax
  802a5b:	09 54 24 04          	or     %edx,0x4(%esp)
  802a5f:	89 fa                	mov    %edi,%edx
  802a61:	d3 e0                	shl    %cl,%eax
  802a63:	89 f1                	mov    %esi,%ecx
  802a65:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a69:	8b 44 24 10          	mov    0x10(%esp),%eax
  802a6d:	d3 ea                	shr    %cl,%edx
  802a6f:	89 e9                	mov    %ebp,%ecx
  802a71:	d3 e7                	shl    %cl,%edi
  802a73:	89 f1                	mov    %esi,%ecx
  802a75:	d3 e8                	shr    %cl,%eax
  802a77:	89 e9                	mov    %ebp,%ecx
  802a79:	09 f8                	or     %edi,%eax
  802a7b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802a7f:	f7 74 24 04          	divl   0x4(%esp)
  802a83:	d3 e7                	shl    %cl,%edi
  802a85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a89:	89 d7                	mov    %edx,%edi
  802a8b:	f7 64 24 08          	mull   0x8(%esp)
  802a8f:	39 d7                	cmp    %edx,%edi
  802a91:	89 c1                	mov    %eax,%ecx
  802a93:	89 14 24             	mov    %edx,(%esp)
  802a96:	72 2c                	jb     802ac4 <__umoddi3+0x134>
  802a98:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802a9c:	72 22                	jb     802ac0 <__umoddi3+0x130>
  802a9e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802aa2:	29 c8                	sub    %ecx,%eax
  802aa4:	19 d7                	sbb    %edx,%edi
  802aa6:	89 e9                	mov    %ebp,%ecx
  802aa8:	89 fa                	mov    %edi,%edx
  802aaa:	d3 e8                	shr    %cl,%eax
  802aac:	89 f1                	mov    %esi,%ecx
  802aae:	d3 e2                	shl    %cl,%edx
  802ab0:	89 e9                	mov    %ebp,%ecx
  802ab2:	d3 ef                	shr    %cl,%edi
  802ab4:	09 d0                	or     %edx,%eax
  802ab6:	89 fa                	mov    %edi,%edx
  802ab8:	83 c4 14             	add    $0x14,%esp
  802abb:	5e                   	pop    %esi
  802abc:	5f                   	pop    %edi
  802abd:	5d                   	pop    %ebp
  802abe:	c3                   	ret    
  802abf:	90                   	nop
  802ac0:	39 d7                	cmp    %edx,%edi
  802ac2:	75 da                	jne    802a9e <__umoddi3+0x10e>
  802ac4:	8b 14 24             	mov    (%esp),%edx
  802ac7:	89 c1                	mov    %eax,%ecx
  802ac9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802acd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802ad1:	eb cb                	jmp    802a9e <__umoddi3+0x10e>
  802ad3:	90                   	nop
  802ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802adc:	0f 82 0f ff ff ff    	jb     8029f1 <__umoddi3+0x61>
  802ae2:	e9 1a ff ff ff       	jmp    802a01 <__umoddi3+0x71>
